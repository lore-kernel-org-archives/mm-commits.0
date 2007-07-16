From: akpm@linux-foundation.org
Subject: - fat-gcc-43-warning-fix.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:53:56 -0700
Message-ID: <200707162053.l6GKruNW001691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52547 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754108AbXGPVUj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:20:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: gcc 4.3 warning fix
has been removed from the -mm tree.  Its filename was
     fat-gcc-43-warning-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fat: gcc 4.3 warning fix
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

This patch fixes the following warnings.

fs/fat/dir.c: In function 'fat_parse_long':
include/linux/msdos_fs.h:294: warning: array subscript is above array bounds
include/linux/msdos_fs.h:295: warning: array subscript is above array bounds
include/linux/msdos_fs.h:295: warning: array subscript is above array bounds

The ->name is defined as "name[8], ext[3]", but fat_checksum() uses
those as name[11]. There is no actual problem, but it's not a good manner.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c             |   31 ++++++++++++++++++-------------
 fs/fat/inode.c           |    3 +--
 include/linux/msdos_fs.h |    2 +-
 3 files changed, 20 insertions(+), 16 deletions(-)

diff -puN fs/fat/dir.c~fat-gcc-43-warning-fix fs/fat/dir.c
--- a/fs/fat/dir.c~fat-gcc-43-warning-fix
+++ a/fs/fat/dir.c
@@ -313,7 +313,7 @@ int fat_search_long(struct inode *inode,
 	wchar_t bufuname[14];
 	unsigned char xlate_len, nr_slots;
 	wchar_t *unicode = NULL;
-	unsigned char work[8], bufname[260];	/* 256 + 4 */
+	unsigned char work[MSDOS_NAME], bufname[260];	/* 256 + 4 */
 	int uni_xlate = sbi->options.unicode_xlate;
 	int utf8 = sbi->options.utf8;
 	int anycase = (sbi->options.name_check != 's');
@@ -351,7 +351,8 @@ parse_record:
 		if (work[0] == 0x05)
 			work[0] = 0xE5;
 		for (i = 0, j = 0, last_u = 0; i < 8;) {
-			if (!work[i]) break;
+			if (!work[i])
+				break;
 			chl = fat_shortname2uni(nls_disk, &work[i], 8 - i,
 						&bufuname[j++], opt_shortname,
 						de->lcase & CASE_LOWER_BASE);
@@ -365,13 +366,15 @@ parse_record:
 		}
 		j = last_u;
 		fat_short2uni(nls_disk, ".", 1, &bufuname[j++]);
-		for (i = 0; i < 3;) {
-			if (!de->ext[i]) break;
-			chl = fat_shortname2uni(nls_disk, &de->ext[i], 3 - i,
+		for (i = 8; i < MSDOS_NAME;) {
+			if (!work[i])
+				break;
+			chl = fat_shortname2uni(nls_disk, &work[i],
+						MSDOS_NAME - i,
 						&bufuname[j++], opt_shortname,
 						de->lcase & CASE_LOWER_EXT);
 			if (chl <= 1) {
-				if (de->ext[i] != ' ')
+				if (work[i] != ' ')
 					last_u = j;
 			} else {
 				last_u = j;
@@ -445,7 +448,7 @@ static int __fat_readdir(struct inode *i
 	int fill_len;
 	wchar_t bufuname[14];
 	wchar_t *unicode = NULL;
-	unsigned char c, work[8], bufname[56], *ptname = bufname;
+	unsigned char c, work[MSDOS_NAME], bufname[56], *ptname = bufname;
 	unsigned long lpos, dummy, *furrfu = &lpos;
 	int uni_xlate = sbi->options.unicode_xlate;
 	int isvfat = sbi->options.isvfat;
@@ -527,7 +530,8 @@ parse_record:
 	if (work[0] == 0x05)
 		work[0] = 0xE5;
 	for (i = 0, j = 0, last = 0, last_u = 0; i < 8;) {
-		if (!(c = work[i])) break;
+		if (!(c = work[i]))
+			break;
 		chl = fat_shortname2uni(nls_disk, &work[i], 8 - i,
 					&bufuname[j++], opt_shortname,
 					de->lcase & CASE_LOWER_BASE);
@@ -549,9 +553,10 @@ parse_record:
 	j = last_u;
 	fat_short2uni(nls_disk, ".", 1, &bufuname[j++]);
 	ptname[i++] = '.';
-	for (i2 = 0; i2 < 3;) {
-		if (!(c = de->ext[i2])) break;
-		chl = fat_shortname2uni(nls_disk, &de->ext[i2], 3 - i2,
+	for (i2 = 8; i2 < MSDOS_NAME;) {
+		if (!(c = work[i2]))
+			break;
+		chl = fat_shortname2uni(nls_disk, &work[i2], MSDOS_NAME - i2,
 					&bufuname[j++], opt_shortname,
 					de->lcase & CASE_LOWER_EXT);
 		if (chl <= 1) {
@@ -563,8 +568,8 @@ parse_record:
 			}
 		} else {
 			last_u = j;
-			for (chi = 0; chi < chl && i2 < 3; chi++) {
-				ptname[i++] = de->ext[i2++];
+			for (chi = 0; chi < chl && i2 < MSDOS_NAME; chi++) {
+				ptname[i++] = work[i2++];
 				last = i;
 			}
 		}
diff -puN fs/fat/inode.c~fat-gcc-43-warning-fix fs/fat/inode.c
--- a/fs/fat/inode.c~fat-gcc-43-warning-fix
+++ a/fs/fat/inode.c
@@ -354,8 +354,7 @@ static int fat_fill_inode(struct inode *
 	} else { /* not a directory */
 		inode->i_generation |= 1;
 		inode->i_mode = MSDOS_MKMODE(de->attr,
-		    ((sbi->options.showexec &&
-			!is_exec(de->ext))
+		    ((sbi->options.showexec && !is_exec(de->name + 8))
 			? S_IRUGO|S_IWUGO : S_IRWXUGO)
 		    & ~sbi->options.fs_fmask) | S_IFREG;
 		MSDOS_I(inode)->i_start = le16_to_cpu(de->start);
diff -puN include/linux/msdos_fs.h~fat-gcc-43-warning-fix include/linux/msdos_fs.h
--- a/include/linux/msdos_fs.h~fat-gcc-43-warning-fix
+++ a/include/linux/msdos_fs.h
@@ -146,7 +146,7 @@ struct fat_boot_fsinfo {
 };
 
 struct msdos_dir_entry {
-	__u8	name[8],ext[3];	/* name and extension */
+	__u8	name[MSDOS_NAME];/* name and extension */
 	__u8	attr;		/* attribute bits */
 	__u8    lcase;		/* Case for base and extension */
 	__u8	ctime_cs;	/* Creation time, centiseconds (0-199) */
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
