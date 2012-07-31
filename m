From: akpm@linux-foundation.org
Subject: [merged] nilfs2-add-omitted-comments-for-structures-in-nilfs2_fsh.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:53:15 -0700
Message-ID: <20120731185315.B52281E006E@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab2GaSxQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:53:16 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:53:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slava@dubeyko.com, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: add omitted comments for structures in nilfs2_fs.h
has been removed from the -mm tree.  Its filename was
     nilfs2-add-omitted-comments-for-structures-in-nilfs2_fsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: nilfs2: add omitted comments for structures in nilfs2_fs.h

Add omitted comments for structures in nilfs2_fs.h.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nilfs2_fs.h |   63 ++++++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff -puN include/linux/nilfs2_fs.h~nilfs2-add-omitted-comments-for-structures-in-nilfs2_fsh include/linux/nilfs2_fs.h
--- a/include/linux/nilfs2_fs.h~nilfs2-add-omitted-comments-for-structures-in-nilfs2_fsh
+++ a/include/linux/nilfs2_fs.h
@@ -293,7 +293,7 @@ struct nilfs_dir_entry {
 	__le64	inode;			/* Inode number */
 	__le16	rec_len;		/* Directory entry length */
 	__u8	name_len;		/* Name length */
-	__u8	file_type;
+	__u8	file_type;		/* Dir entry type (file, dir, etc) */
 	char	name[NILFS_NAME_LEN];	/* File name */
 	char    pad;
 };
@@ -395,7 +395,7 @@ union nilfs_binfo {
 };
 
 /**
- * struct nilfs_segment_summary - segment summary
+ * struct nilfs_segment_summary - segment summary header
  * @ss_datasum: checksum of data
  * @ss_sumsum: checksum of segment summary
  * @ss_magic: magic number
@@ -683,9 +683,9 @@ struct nilfs_sufile_header {
 
 /**
  * nilfs_suinfo - segment usage information
- * @sui_lastmod:
- * @sui_nblocks:
- * @sui_flags:
+ * @sui_lastmod: timestamp of last modification
+ * @sui_nblocks: number of written blocks in segment
+ * @sui_flags: segment usage flags
  */
 struct nilfs_suinfo {
 	__u64 sui_lastmod;
@@ -716,9 +716,10 @@ enum {
 };
 
 /**
- * struct nilfs_cpmode -
- * @cc_cno:
- * @cc_mode:
+ * struct nilfs_cpmode - change checkpoint mode structure
+ * @cm_cno: checkpoint number
+ * @cm_mode: mode of checkpoint
+ * @cm_pad: padding
  */
 struct nilfs_cpmode {
 	__u64 cm_cno;
@@ -728,11 +729,11 @@ struct nilfs_cpmode {
 
 /**
  * struct nilfs_argv - argument vector
- * @v_base:
- * @v_nmembs:
- * @v_size:
- * @v_flags:
- * @v_index:
+ * @v_base: pointer on data array from userspace
+ * @v_nmembs: number of members in data array
+ * @v_size: size of data array in bytes
+ * @v_flags: flags
+ * @v_index: start number of target data items
  */
 struct nilfs_argv {
 	__u64 v_base;
@@ -743,9 +744,9 @@ struct nilfs_argv {
 };
 
 /**
- * struct nilfs_period -
- * @p_start:
- * @p_end:
+ * struct nilfs_period - period of checkpoint numbers
+ * @p_start: start checkpoint number (inclusive)
+ * @p_end: end checkpoint number (exclusive)
  */
 struct nilfs_period {
 	__u64 p_start;
@@ -753,7 +754,7 @@ struct nilfs_period {
 };
 
 /**
- * struct nilfs_cpstat -
+ * struct nilfs_cpstat - checkpoint statistics
  * @cs_cno: checkpoint number
  * @cs_ncps: number of checkpoints
  * @cs_nsss: number of snapshots
@@ -765,7 +766,7 @@ struct nilfs_cpstat {
 };
 
 /**
- * struct nilfs_sustat -
+ * struct nilfs_sustat - segment usage statistics
  * @ss_nsegs: number of segments
  * @ss_ncleansegs: number of clean segments
  * @ss_ndirtysegs: number of dirty segments
@@ -784,10 +785,10 @@ struct nilfs_sustat {
 
 /**
  * struct nilfs_vinfo - virtual block number information
- * @vi_vblocknr:
- * @vi_start:
- * @vi_end:
- * @vi_blocknr:
+ * @vi_vblocknr: virtual block number
+ * @vi_start: start checkpoint number (inclusive)
+ * @vi_end: end checkpoint number (exclusive)
+ * @vi_blocknr: disk block number
  */
 struct nilfs_vinfo {
 	__u64 vi_vblocknr;
@@ -797,7 +798,15 @@ struct nilfs_vinfo {
 };
 
 /**
- * struct nilfs_vdesc -
+ * struct nilfs_vdesc - descriptor of virtual block number
+ * @vd_ino: inode number
+ * @vd_cno: checkpoint number
+ * @vd_vblocknr: virtual block number
+ * @vd_period: period of checkpoint numbers
+ * @vd_blocknr: disk block number
+ * @vd_offset: logical block offset inside a file
+ * @vd_flags: flags (data or node block)
+ * @vd_pad: padding
  */
 struct nilfs_vdesc {
 	__u64 vd_ino;
@@ -811,7 +820,13 @@ struct nilfs_vdesc {
 };
 
 /**
- * struct nilfs_bdesc -
+ * struct nilfs_bdesc - descriptor of disk block number
+ * @bd_ino: inode number
+ * @bd_oblocknr: disk block address (for skipping dead blocks)
+ * @bd_blocknr: disk block address
+ * @bd_offset: logical block offset inside a file
+ * @bd_level: level in the b-tree organization
+ * @bd_pad: padding
  */
 struct nilfs_bdesc {
 	__u64 bd_ino;
_

Patches currently in -mm which might be from slava@dubeyko.com are

origin.patch

