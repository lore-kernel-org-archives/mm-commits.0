From: akpm@linux-foundation.org
Subject: + fat-accessors-for-msdos_dir_entry-start-fields.patch added to -mm tree
Date: Fri, 29 Jun 2012 14:28:51 -0700
Message-ID: <20120629212851.5DEFBA024B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:58970 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab2F2V2x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jun 2012 17:28:53 -0400
Received: by wgbdt11 with SMTP id dt11so190358wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 29 Jun 2012 14:28:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steve@digidescorp.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fat: accessors for msdos_dir_entry 'start' fields
has been added to the -mm tree.  Its filename is
     fat-accessors-for-msdos_dir_entry-start-fields.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Steven J. Magnani" <steve@digidescorp.com>
Subject: fat: accessors for msdos_dir_entry 'start' fields

Simplify code by providing accessor functions for the directory entry
start cluster fields.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h         |   15 +++++++++++++++
 fs/fat/inode.c       |   12 +++---------
 fs/fat/namei_msdos.c |   11 +++--------
 fs/fat/namei_vfat.c  |   11 +++--------
 4 files changed, 24 insertions(+), 25 deletions(-)

diff -puN fs/fat/fat.h~fat-accessors-for-msdos_dir_entry-start-fields fs/fat/fat.h
--- a/fs/fat/fat.h~fat-accessors-for-msdos_dir_entry-start-fields
+++ a/fs/fat/fat.h
@@ -217,6 +217,21 @@ static inline void fat16_towchar(wchar_t
 #endif
 }
 
+static inline int fat_get_start(const struct msdos_sb_info *sbi,
+				const struct msdos_dir_entry *de)
+{
+	int cluster = le16_to_cpu(de->start);
+	if (sbi->fat_bits == 32)
+		cluster |= (le16_to_cpu(de->starthi) << 16);
+	return cluster;
+}
+
+static inline void fat_set_start(struct msdos_dir_entry *de, int cluster)
+{
+	de->start   = cpu_to_le16(cluster);
+	de->starthi = cpu_to_le16(cluster >> 16);
+}
+
 static inline void fatwchar_to16(__u8 *dst, const wchar_t *src, size_t len)
 {
 #ifdef __BIG_ENDIAN
diff -puN fs/fat/inode.c~fat-accessors-for-msdos_dir_entry-start-fields fs/fat/inode.c
--- a/fs/fat/inode.c~fat-accessors-for-msdos_dir_entry-start-fields
+++ a/fs/fat/inode.c
@@ -369,10 +369,7 @@ static int fat_fill_inode(struct inode *
 		inode->i_op = sbi->dir_ops;
 		inode->i_fop = &fat_dir_operations;
 
-		MSDOS_I(inode)->i_start = le16_to_cpu(de->start);
-		if (sbi->fat_bits == 32)
-			MSDOS_I(inode)->i_start |= (le16_to_cpu(de->starthi) << 16);
-
+		MSDOS_I(inode)->i_start = fat_get_start(sbi, de);
 		MSDOS_I(inode)->i_logstart = MSDOS_I(inode)->i_start;
 		error = fat_calc_dir_size(inode);
 		if (error < 0)
@@ -385,9 +382,7 @@ static int fat_fill_inode(struct inode *
 		inode->i_mode = fat_make_mode(sbi, de->attr,
 			((sbi->options.showexec && !is_exec(de->name + 8))
 			 ? S_IRUGO|S_IWUGO : S_IRWXUGO));
-		MSDOS_I(inode)->i_start = le16_to_cpu(de->start);
-		if (sbi->fat_bits == 32)
-			MSDOS_I(inode)->i_start |= (le16_to_cpu(de->starthi) << 16);
+		MSDOS_I(inode)->i_start = fat_get_start(sbi, de);
 
 		MSDOS_I(inode)->i_logstart = MSDOS_I(inode)->i_start;
 		inode->i_size = le32_to_cpu(de->size);
@@ -618,8 +613,7 @@ retry:
 	else
 		raw_entry->size = cpu_to_le32(inode->i_size);
 	raw_entry->attr = fat_make_attrs(inode);
-	raw_entry->start = cpu_to_le16(MSDOS_I(inode)->i_logstart);
-	raw_entry->starthi = cpu_to_le16(MSDOS_I(inode)->i_logstart >> 16);
+	fat_set_start(raw_entry, MSDOS_I(inode)->i_logstart);
 	fat_time_unix2fat(sbi, &inode->i_mtime, &raw_entry->time,
 			  &raw_entry->date, NULL);
 	if (sbi->options.isvfat) {
diff -puN fs/fat/namei_msdos.c~fat-accessors-for-msdos_dir_entry-start-fields fs/fat/namei_msdos.c
--- a/fs/fat/namei_msdos.c~fat-accessors-for-msdos_dir_entry-start-fields
+++ a/fs/fat/namei_msdos.c
@@ -246,8 +246,7 @@ static int msdos_add_entry(struct inode 
 	de.ctime_cs = 0;
 	de.time = time;
 	de.date = date;
-	de.start = cpu_to_le16(cluster);
-	de.starthi = cpu_to_le16(cluster >> 16);
+	fat_set_start(&de, cluster);
 	de.size = 0;
 
 	err = fat_add_entries(dir, &de, 1, sinfo);
@@ -530,9 +529,7 @@ static int do_msdos_rename(struct inode 
 		mark_inode_dirty(old_inode);
 
 	if (update_dotdot) {
-		int start = MSDOS_I(new_dir)->i_logstart;
-		dotdot_de->start = cpu_to_le16(start);
-		dotdot_de->starthi = cpu_to_le16(start >> 16);
+		fat_set_start(dotdot_de, MSDOS_I(new_dir)->i_logstart);
 		mark_buffer_dirty_inode(dotdot_bh, old_inode);
 		if (IS_DIRSYNC(new_dir)) {
 			err = sync_dirty_buffer(dotdot_bh);
@@ -572,9 +569,7 @@ error_dotdot:
 	corrupt = 1;
 
 	if (update_dotdot) {
-		int start = MSDOS_I(old_dir)->i_logstart;
-		dotdot_de->start = cpu_to_le16(start);
-		dotdot_de->starthi = cpu_to_le16(start >> 16);
+		fat_set_start(dotdot_de, MSDOS_I(old_dir)->i_logstart);
 		mark_buffer_dirty_inode(dotdot_bh, old_inode);
 		corrupt |= sync_dirty_buffer(dotdot_bh);
 	}
diff -puN fs/fat/namei_vfat.c~fat-accessors-for-msdos_dir_entry-start-fields fs/fat/namei_vfat.c
--- a/fs/fat/namei_vfat.c~fat-accessors-for-msdos_dir_entry-start-fields
+++ a/fs/fat/namei_vfat.c
@@ -651,8 +651,7 @@ shortname:
 	de->time = de->ctime = time;
 	de->date = de->cdate = de->adate = date;
 	de->ctime_cs = time_cs;
-	de->start = cpu_to_le16(cluster);
-	de->starthi = cpu_to_le16(cluster >> 16);
+	fat_set_start(de, cluster);
 	de->size = 0;
 out_free:
 	__putname(uname);
@@ -965,9 +964,7 @@ static int vfat_rename(struct inode *old
 		mark_inode_dirty(old_inode);
 
 	if (update_dotdot) {
-		int start = MSDOS_I(new_dir)->i_logstart;
-		dotdot_de->start = cpu_to_le16(start);
-		dotdot_de->starthi = cpu_to_le16(start >> 16);
+		fat_set_start(dotdot_de, MSDOS_I(new_dir)->i_logstart);
 		mark_buffer_dirty_inode(dotdot_bh, old_inode);
 		if (IS_DIRSYNC(new_dir)) {
 			err = sync_dirty_buffer(dotdot_bh);
@@ -1009,9 +1006,7 @@ error_dotdot:
 	corrupt = 1;
 
 	if (update_dotdot) {
-		int start = MSDOS_I(old_dir)->i_logstart;
-		dotdot_de->start = cpu_to_le16(start);
-		dotdot_de->starthi = cpu_to_le16(start >> 16);
+		fat_set_start(dotdot_de, MSDOS_I(old_dir)->i_logstart);
 		mark_buffer_dirty_inode(dotdot_bh, old_inode);
 		corrupt |= sync_dirty_buffer(dotdot_bh);
 	}
_
Subject: Subject: fat: accessors for msdos_dir_entry 'start' fields

Patches currently in -mm which might be from steve@digidescorp.com are

fat-fix-non-atomic-nfs-i_pos-read.patch
fat-accessors-for-msdos_dir_entry-start-fields.patch

