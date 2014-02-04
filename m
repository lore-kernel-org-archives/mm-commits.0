From: akpm@linux-foundation.org
Subject: + hfsplus-rework-hfsplus_submit_bio-method.patch added to -mm
 tree
Date: Tue, 04 Feb 2014 14:33:32 -0800
Message-ID: <52f16abc.QPn3eMketddyNxK+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933793AbaBDWdd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 17:33:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: + hfsplus-rework-hfsplus_submit_bio-method.patch added to -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 14:33:32 -0800


The patch titled
     Subject: hfsplus: rework hfsplus_submit_bio() method
has been added to the -mm tree.  Its filename is
     hfsplus-rework-hfsplus_submit_bio-method.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-rework-hfsplus_submit_bio-method.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-rework-hfsplus_submit_bio-method.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: rework hfsplus_submit_bio() method

Rework hfsplus_submit_bio() method with the goal to get length of data
from address of data pointer till the end of data block.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/hfsplus_fs.h |    2 +-
 fs/hfsplus/part_tbl.c   |    4 ++--
 fs/hfsplus/super.c      |    5 +++--
 fs/hfsplus/wrapper.c    |   28 +++++++++++++++++++++-------
 4 files changed, 27 insertions(+), 12 deletions(-)

diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-rework-hfsplus_submit_bio-method fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-rework-hfsplus_submit_bio-method
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -537,7 +537,7 @@ int hfsplus_compare_dentry(const struct
 int hfsplus_read_wrapper(struct super_block *);
 int hfs_part_find(struct super_block *, sector_t *, sector_t *);
 int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
-		void *buf, void **data, int rw);
+			void *buf, void **data, int rw, size_t *data_len);
 
 /* time macros */
 #define __hfsp_mt2ut(t)		(be32_to_cpu(t) - 2082844800U)
diff -puN fs/hfsplus/part_tbl.c~hfsplus-rework-hfsplus_submit_bio-method fs/hfsplus/part_tbl.c
--- a/fs/hfsplus/part_tbl.c~hfsplus-rework-hfsplus_submit_bio-method
+++ a/fs/hfsplus/part_tbl.c
@@ -112,7 +112,7 @@ static int hfs_parse_new_pmap(struct sup
 		if ((u8 *)pm - (u8 *)buf >= buf_size) {
 			res = hfsplus_submit_bio(sb,
 						 *part_start + HFS_PMAP_BLK + i,
-						 buf, (void **)&pm, READ);
+						 buf, (void **)&pm, READ, NULL);
 			if (res)
 				return res;
 		}
@@ -136,7 +136,7 @@ int hfs_part_find(struct super_block *sb
 		return -ENOMEM;
 
 	res = hfsplus_submit_bio(sb, *part_start + HFS_PMAP_BLK,
-				 buf, &data, READ);
+				 buf, &data, READ, NULL);
 	if (res)
 		goto out;
 
diff -puN fs/hfsplus/super.c~hfsplus-rework-hfsplus_submit_bio-method fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-rework-hfsplus_submit_bio-method
+++ a/fs/hfsplus/super.c
@@ -217,7 +217,7 @@ static int hfsplus_sync_fs(struct super_
 
 	error2 = hfsplus_submit_bio(sb,
 				   sbi->part_start + HFSPLUS_VOLHEAD_SECTOR,
-				   sbi->s_vhdr_buf, NULL, WRITE_SYNC);
+				   sbi->s_vhdr_buf, NULL, WRITE_SYNC, NULL);
 	if (!error)
 		error = error2;
 	if (!write_backup)
@@ -225,7 +225,8 @@ static int hfsplus_sync_fs(struct super_
 
 	error2 = hfsplus_submit_bio(sb,
 				  sbi->part_start + sbi->sect_count - 2,
-				  sbi->s_backup_vhdr_buf, NULL, WRITE_SYNC);
+				  sbi->s_backup_vhdr_buf, NULL, WRITE_SYNC,
+				  NULL);
 	if (!error)
 		error2 = error;
 out:
diff -puN fs/hfsplus/wrapper.c~hfsplus-rework-hfsplus_submit_bio-method fs/hfsplus/wrapper.c
--- a/fs/hfsplus/wrapper.c~hfsplus-rework-hfsplus_submit_bio-method
+++ a/fs/hfsplus/wrapper.c
@@ -31,6 +31,7 @@ struct hfsplus_wd {
  * @buf: buffer for I/O
  * @data: output pointer for location of requested data
  * @rw: direction of I/O
+ * @data_len: output pointer for length of requested data
  *
  * The unit of I/O is hfsplus_min_io_size(sb), which may be bigger than
  * HFSPLUS_SECTOR_SIZE, and @buf must be sized accordingly. On reads
@@ -44,13 +45,14 @@ struct hfsplus_wd {
  * will work correctly.
  */
 int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
-		void *buf, void **data, int rw)
+			void *buf, void **data, int rw, size_t *data_len)
 {
 	struct bio *bio;
 	int ret = 0;
 	u64 io_size;
 	loff_t start;
 	int offset;
+	unsigned int page_offset;
 
 	/*
 	 * Align sector to hardware sector size and find offset. We
@@ -66,13 +68,25 @@ int hfsplus_submit_bio(struct super_bloc
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_bdev = sb->s_bdev;
 
-	if (!(rw & WRITE) && data)
+	if (!(rw & WRITE) && data) {
 		*data = (u8 *)buf + offset;
 
+		if (data_len) {
+			page_offset = offset_in_page(buf);
+
+			BUG_ON(offset > io_size);
+			BUG_ON((page_offset + offset) > PAGE_SIZE);
+
+			*data_len = min_t(size_t, io_size - offset,
+					  PAGE_SIZE - page_offset - offset);
+		}
+	}
+
 	while (io_size > 0) {
-		unsigned int page_offset = offset_in_page(buf);
-		unsigned int len = min_t(unsigned int, PAGE_SIZE - page_offset,
-					 io_size);
+		unsigned int len;
+
+		page_offset = offset_in_page(buf);
+		len = min_t(unsigned int, PAGE_SIZE - page_offset, io_size);
 
 		ret = bio_add_page(bio, virt_to_page(buf), len, page_offset);
 		if (ret != len) {
@@ -181,7 +195,7 @@ int hfsplus_read_wrapper(struct super_bl
 reread:
 	error = hfsplus_submit_bio(sb, part_start + HFSPLUS_VOLHEAD_SECTOR,
 				   sbi->s_vhdr_buf, (void **)&sbi->s_vhdr,
-				   READ);
+				   READ, NULL);
 	if (error)
 		goto out_free_backup_vhdr;
 
@@ -213,7 +227,7 @@ reread:
 
 	error = hfsplus_submit_bio(sb, part_start + part_size - 2,
 				   sbi->s_backup_vhdr_buf,
-				   (void **)&sbi->s_backup_vhdr, READ);
+				   (void **)&sbi->s_backup_vhdr, READ, NULL);
 	if (error)
 		goto out_free_backup_vhdr;
 
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-add-necessary-declarations-for-journal-replay.patch
hfsplus-rework-hfsplus_submit_bio-method.patch
hfsplus-implement-init-destroy-journal-object-functionality.patch
hfsplus-implement-functionality-for-hfsplus_journal_need_init-flag.patch
hfsplus-implement-norecovery-mount-option-support.patch
hfsplus-fix-remount-issue.patch
hfsplus-implement-check-consistency-of-journal-log-file.patch
hfsplus-introduce-descriptor-of-block-list-buffer.patch
hfsplus-implement-get-and-verify-block-list-header-functionality.patch
hfsplus-implement-functionality-of-getting-transactions-block-info.patch
hfsplus-implement-functionality-of-journal-log-wrapping.patch
hfsplus-implement-functionality-of-transactions-block-check.patch
hfsplus-implement-replay-transactions-block-functionality.patch
hfsplus-implement-replay-journal-functionality.patch
hfsplus-integrate-journal-replay-support-into-driver.patch

