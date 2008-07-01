From: akpm@linux-foundation.org
Subject: + fat-small-optimization-to-__fat_readdir.patch added to -mm tree
Date: Mon, 30 Jun 2008 20:34:18 -0700
Message-ID: <200807010334.m613YIP1007145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752870AbYGADeV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 23:34:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     fat: small optimization to __fat_readdir()
has been added to the -mm tree.  Its filename is
     fat-small-optimization-to-__fat_readdir.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: small optimization to __fat_readdir()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

This removes unnecessary parsing for directory entries.

If short_only, we don't need to parse longname.  And if !both and it found
the longname, we don't need shortname.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |   71 ++++++++++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 32 deletions(-)

diff -puN fs/fat/dir.c~fat-small-optimization-to-__fat_readdir fs/fat/dir.c
--- a/fs/fat/dir.c~fat-small-optimization-to-__fat_readdir
+++ a/fs/fat/dir.c
@@ -481,11 +481,11 @@ static int __fat_readdir(struct inode *i
 	unsigned short opt_shortname = sbi->options.shortname;
 	int isvfat = sbi->options.isvfat;
 	int nocase = sbi->options.nocase;
-	const char *fill_name;
+	const char *fill_name = NULL;
 	unsigned long inum;
 	unsigned long lpos, dummy, *furrfu = &lpos;
 	loff_t cpos;
-	int chi, chl, i, i2, j, last, last_u, dotoffset = 0, fill_len;
+	int chi, chl, i, i2, j, last, last_u, dotoffset = 0, fill_len = 0;
 	int ret = 0;
 
 	lock_super(sb);
@@ -516,8 +516,11 @@ get_new:
 		goto end_of_dir;
 parse_record:
 	nr_slots = 0;
-	/* Check for long filename entry */
-	if (isvfat) {
+	/*
+	 * Check for long filename entry, but if short_only, we don't
+	 * need to parse long filename.
+	 */
+	if (isvfat && !short_only) {
 		if (de->name[0] == DELETED_FLAG)
 			goto record_end;
 		if (de->attr != ATTR_EXT && (de->attr & ATTR_VOLUME))
@@ -542,6 +545,18 @@ parse_record:
 			goto parse_record;
 		else if (status == PARSE_EOF)
 			goto end_of_dir;
+
+		if (nr_slots) {
+			void *longname = unicode + FAT_MAX_UNI_CHARS;
+			int size = PATH_MAX - FAT_MAX_UNI_SIZE;
+			int len = fat_uni_to_x8(sbi, unicode, longname, size);
+
+			fill_name = longname;
+			fill_len = len;
+			/* !both && !short_only, so we don't need shortname. */
+			if (!both)
+				goto start_filldir;
+		}
 	}
 
 	if (sbi->options.dotsOK) {
@@ -608,6 +623,26 @@ parse_record:
 	i = last + dotoffset;
 	j = last_u;
 
+	if (isvfat) {
+		bufuname[j] = 0x0000;
+		i = fat_uni_to_x8(sbi, bufuname, bufname, sizeof(bufname));
+	}
+	if (nr_slots) {
+		/* hack for fat_ioctl_filldir() */
+		struct fat_ioctl_filldir_callback *p = dirent;
+
+		p->longname = fill_name;
+		p->long_len = fill_len;
+		p->shortname = bufname;
+		p->short_len = i;
+		fill_name = NULL;
+		fill_len = 0;
+	} else {
+		fill_name = bufname;
+		fill_len = i;
+	}
+
+start_filldir:
 	lpos = cpos - (nr_slots + 1) * sizeof(struct msdos_dir_entry);
 	if (!memcmp(de->name, MSDOS_DOT, MSDOS_NAME))
 		inum = inode->i_ino;
@@ -623,34 +658,6 @@ parse_record:
 			inum = iunique(sb, MSDOS_ROOT_INO);
 	}
 
-	if (isvfat) {
-		bufuname[j] = 0x0000;
-		i = fat_uni_to_x8(sbi, bufuname, bufname, sizeof(bufname));
-	}
-
-	fill_name = bufname;
-	fill_len = i;
-	if (!short_only && nr_slots) {
-		void *longname = unicode + FAT_MAX_UNI_CHARS;
-		int long_len, size = PATH_MAX - FAT_MAX_UNI_SIZE;
-
-		long_len = fat_uni_to_x8(sbi, unicode, longname, size);
-
-		if (!both) {
-			fill_name = longname;
-			fill_len = long_len;
-		} else {
-			/* hack for fat_ioctl_filldir() */
-			struct fat_ioctl_filldir_callback *p = dirent;
-
-			p->longname = longname;
-			p->long_len = long_len;
-			p->shortname = bufname;
-			p->short_len = i;
-			fill_name = NULL;
-			fill_len = 0;
-		}
-	}
 	if (filldir(dirent, fill_name, fill_len, *furrfu, inum,
 		    (de->attr & ATTR_DIR) ? DT_DIR : DT_REG) < 0)
 		goto fill_failed;
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fat-fix-parse_options.patch
fat-fix-vfat_ioctl_readdir_xxx-and-cleanup-for-userland.patch
fat-dirc-switch-to-struct-__fat_dirent.patch
fat-cleanup-fs-fat-dirc.patch
fat-use-same-logic-in-fat_search_long-and-__fat_readdir.patch
fat-small-optimization-to-__fat_readdir.patch
pdflush-use-time_after-instead-of-open-coding-it.patch
msdos-fs-remove-unsettable-atari-option.patch
fat-dirc-switch-to-struct-__fat_fs_dirent.patch
remove-the-in-kernel-struct-dirent64.patch

