From: akpm@linux-foundation.org
Subject: + fat-use-__getname.patch added to -mm tree
Date: Sun, 27 Apr 2008 12:08:29 -0700
Message-ID: <200804271908.m3RJ8TQx020451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763155AbYD0TIc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 15:08:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     fat: use __getname()
has been added to the -mm tree.  Its filename is
     fat-use-__getname.patch

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
Subject: fat: use __getname()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

__getname() is faster than __get_free_page(). Use it.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c    |   20 ++++++++++----------
 fs/vfat/namei.c |   10 ++++------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff -puN fs/fat/dir.c~fat-use-__getname fs/fat/dir.c
--- a/fs/fat/dir.c~fat-use-__getname
+++ a/fs/fat/dir.c
@@ -247,7 +247,7 @@ static int fat_parse_long(struct inode *
 	unsigned char id, slot, slots, alias_checksum;
 
 	if (!*unicode) {
-		*unicode = (wchar_t *)__get_free_page(GFP_KERNEL);
+		*unicode = __getname();
 		if (!*unicode) {
 			brelse(*bh);
 			return -ENOMEM;
@@ -327,7 +327,7 @@ int fat_search_long(struct inode *inode,
 	loff_t cpos = 0;
 	int chl, i, j, last_u, err;
 
-	bufname = (unsigned char*)__get_free_page(GFP_KERNEL);
+	bufname = __getname();
 	if (!bufname)
 		return -ENOMEM;
 
@@ -396,8 +396,8 @@ parse_record:
 
 		bufuname[last_u] = 0x0000;
 		xlate_len = utf8
-			?utf8_wcstombs(bufname, bufuname, PAGE_SIZE)
-			:uni16_to_x8(bufname, bufuname, PAGE_SIZE, uni_xlate, nls_io);
+			?utf8_wcstombs(bufname, bufuname, PATH_MAX)
+			:uni16_to_x8(bufname, bufuname, PATH_MAX, uni_xlate, nls_io);
 		if (xlate_len == name_len)
 			if ((!anycase && !memcmp(name, bufname, xlate_len)) ||
 			    (anycase && !nls_strnicmp(nls_io, name, bufname,
@@ -406,8 +406,8 @@ parse_record:
 
 		if (nr_slots) {
 			xlate_len = utf8
-				?utf8_wcstombs(bufname, unicode, PAGE_SIZE)
-				:uni16_to_x8(bufname, unicode, PAGE_SIZE, uni_xlate, nls_io);
+				?utf8_wcstombs(bufname, unicode, PATH_MAX)
+				:uni16_to_x8(bufname, unicode, PATH_MAX, uni_xlate, nls_io);
 			if (xlate_len != name_len)
 				continue;
 			if ((!anycase && !memcmp(name, bufname, xlate_len)) ||
@@ -427,9 +427,9 @@ Found:
 	err = 0;
 EODir:
 	if (bufname)
-		free_page((unsigned long)bufname);
+		__putname(bufname);
 	if (unicode)
-		free_page((unsigned long)unicode);
+		__putname(unicode);
 
 	return err;
 }
@@ -619,7 +619,7 @@ parse_record:
 		/* convert the unicode long name. 261 is maximum size
 		 * of unicode buffer. (13 * slots + nul) */
 		void *longname = unicode + 261;
-		int buf_size = PAGE_SIZE - (261 * sizeof(unicode[0]));
+		int buf_size = PATH_MAX - (261 * sizeof(unicode[0]));
 		int long_len = utf8
 			? utf8_wcstombs(longname, unicode, buf_size)
 			: uni16_to_x8(longname, unicode, buf_size, uni_xlate, nls_io);
@@ -652,7 +652,7 @@ EODir:
 FillFailed:
 	brelse(bh);
 	if (unicode)
-		free_page((unsigned long)unicode);
+		__putname(unicode);
 out:
 	unlock_kernel();
 	return ret;
diff -puN fs/vfat/namei.c~fat-use-__getname fs/vfat/namei.c
--- a/fs/vfat/namei.c~fat-use-__getname
+++ a/fs/vfat/namei.c
@@ -472,7 +472,7 @@ xlate_to_uni(const unsigned char *name, 
 	if (utf8) {
 		int name_len = strlen(name);
 
-		*outlen = utf8_mbstowcs((wchar_t *)outname, name, PAGE_SIZE);
+		*outlen = utf8_mbstowcs((wchar_t *)outname, name, PATH_MAX);
 
 		/*
 		 * We stripped '.'s before and set len appropriately,
@@ -565,7 +565,6 @@ static int vfat_build_slots(struct inode
 	struct fat_mount_options *opts = &sbi->options;
 	struct msdos_dir_slot *ps;
 	struct msdos_dir_entry *de;
-	unsigned long page;
 	unsigned char cksum, lcase;
 	unsigned char msdos_name[MSDOS_NAME];
 	wchar_t *uname;
@@ -575,11 +574,10 @@ static int vfat_build_slots(struct inode
 
 	*nr_slots = 0;
 
-	page = __get_free_page(GFP_KERNEL);
-	if (!page)
+	uname = __getname();
+	if (!uname)
 		return -ENOMEM;
 
-	uname = (wchar_t *)page;
 	err = xlate_to_uni(name, len, (unsigned char *)uname, &ulen, &usize,
 			   opts->unicode_xlate, opts->utf8, sbi->nls_io);
 	if (err)
@@ -631,7 +629,7 @@ shortname:
 	de->starthi = cpu_to_le16(cluster >> 16);
 	de->size = 0;
 out_free:
-	free_page(page);
+	__putname(uname);
 	return err;
 }
 
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fat-kill-is_bad_inode-check.patch
fat-fat_notify_change-and-check_mode-cleanup.patch
fat-fat_setattr-fix.patch
fat-add-allow_utime-option.patch
fat-update-free_clusters-even-if-it-is-untrusted.patch
fat-remove-fat_clusters_flush.patch
add-balance_dirty_pages_ratelimited-to-cont_expand_zero.patch
vfat-bug-fix-for-vfat-cannot-handle-filename-with-255.patch
fat-use-__getname.patch
fat_valid_media-remove-pointless-test.patch
fat-detect-media-without-partition-table-correctly.patch
fatfs-fix-build-warning-with-64k-page_size.patch
fat-use-get-put_unaligned_-helpers.patch

