From: akpm@linux-foundation.org
Subject: + fat-use-same-logic-in-fat_search_long-and-__fat_readdir.patch added to -mm tree
Date: Mon, 30 Jun 2008 20:34:16 -0700
Message-ID: <200807010334.m613YGn5007142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752865AbYGADeT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 23:34:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     fat: use same logic in fat_search_long() and __fat_readdir()
has been added to the -mm tree.  Its filename is
     fat-use-same-logic-in-fat_search_long-and-__fat_readdir.patch

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
Subject: fat: use same logic in fat_search_long() and __fat_readdir()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

This uses uses stack for shortname, and uses __getname() for longname in
fat_search_long() and __fat_readdir().  By this, it removes unneeded
__getname() for shortname.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |   42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff -puN fs/fat/dir.c~fat-use-same-logic-in-fat_search_long-and-__fat_readdir fs/fat/dir.c
--- a/fs/fat/dir.c~fat-use-same-logic-in-fat_search_long-and-__fat_readdir
+++ a/fs/fat/dir.c
@@ -325,6 +325,19 @@ parse_long:
 }
 
 /*
+ * Maximum buffer size of short name.
+ * [(MSDOS_NAME + '.') * max one char + nul]
+ * For msdos style, ['.' (hidden) + MSDOS_NAME + '.' + nul]
+ */
+#define FAT_MAX_SHORT_SIZE	((MSDOS_NAME + 1) * NLS_MAX_CHARSET_SIZE + 1)
+/*
+ * Maximum buffer size of unicode chars from slots.
+ * [(max longname slots * 13 (size in a slot) + nul) * sizeof(wchar_t)]
+ */
+#define FAT_MAX_UNI_CHARS	((MSDOS_SLOTS - 1) * 13 + 1)
+#define FAT_MAX_UNI_SIZE	(FAT_MAX_UNI_CHARS * sizeof(wchar_t))
+
+/*
  * Return values: negative -> error, 0 -> not found, positive -> found,
  * value is the total amount of slots, including the shortname entry.
  */
@@ -340,15 +353,11 @@ int fat_search_long(struct inode *inode,
 	wchar_t bufuname[14];
 	wchar_t *unicode = NULL;
 	unsigned char work[MSDOS_NAME];
-	unsigned char *bufname = NULL;
+	unsigned char bufname[FAT_MAX_SHORT_SIZE];
 	unsigned short opt_shortname = sbi->options.shortname;
 	loff_t cpos = 0;
 	int chl, i, j, last_u, err, len;
 
-	bufname = __getname();
-	if (!bufname)
-		return -ENOMEM;
-
 	err = -ENOENT;
 	while (1) {
 		if (fat_get_entry(inode, &cpos, &bh, &de) == -1)
@@ -414,14 +423,17 @@ parse_record:
 
 		/* Compare shortname */
 		bufuname[last_u] = 0x0000;
-		len = fat_uni_to_x8(sbi, bufuname, bufname, PATH_MAX);
+		len = fat_uni_to_x8(sbi, bufuname, bufname, sizeof(bufname));
 		if (fat_name_match(sbi, name, name_len, bufname, len))
 			goto found;
 
 		if (nr_slots) {
+			void *longname = unicode + FAT_MAX_UNI_CHARS;
+			int size = PATH_MAX - FAT_MAX_UNI_SIZE;
+
 			/* Compare longname */
-			len = fat_uni_to_x8(sbi, unicode, bufname, PATH_MAX);
-			if (fat_name_match(sbi, name, name_len, bufname, len))
+			len = fat_uni_to_x8(sbi, unicode, longname, size);
+			if (fat_name_match(sbi, name, name_len, longname, len))
 				goto found;
 		}
 	}
@@ -435,8 +447,6 @@ found:
 	sinfo->i_pos = fat_make_i_pos(sb, sinfo->bh, sinfo->de);
 	err = 0;
 end_of_dir:
-	if (bufname)
-		__putname(bufname);
 	if (unicode)
 		__putname(unicode);
 
@@ -466,7 +476,8 @@ static int __fat_readdir(struct inode *i
 	unsigned char nr_slots;
 	wchar_t bufuname[14];
 	wchar_t *unicode = NULL;
-	unsigned char c, work[MSDOS_NAME], bufname[56], *ptname = bufname;
+	unsigned char c, work[MSDOS_NAME];
+	unsigned char bufname[FAT_MAX_SHORT_SIZE], *ptname = bufname;
 	unsigned short opt_shortname = sbi->options.shortname;
 	int isvfat = sbi->options.isvfat;
 	int nocase = sbi->options.nocase;
@@ -620,11 +631,10 @@ parse_record:
 	fill_name = bufname;
 	fill_len = i;
 	if (!short_only && nr_slots) {
-		/* convert the unicode long name. 261 is maximum size
-		 * of unicode buffer. (13 * slots + nul) */
-		void *longname = unicode + 261;
-		int buf_size = PATH_MAX - (261 * sizeof(unicode[0]));
-		int long_len = fat_uni_to_x8(sbi, unicode, longname, buf_size);
+		void *longname = unicode + FAT_MAX_UNI_CHARS;
+		int long_len, size = PATH_MAX - FAT_MAX_UNI_SIZE;
+
+		long_len = fat_uni_to_x8(sbi, unicode, longname, size);
 
 		if (!both) {
 			fill_name = longname;
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

