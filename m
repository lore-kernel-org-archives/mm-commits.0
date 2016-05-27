From: akpm@linux-foundation.org
Subject: [merged] nilfs2-fix-block-comments.patch removed from -mm tree
Date: Fri, 27 May 2016 11:43:14 -0700
Message-ID: <57489542.h4e5Dk/6NRE7RYZU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbcE0SnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:43:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix block comments
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-block-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: fix block comments

This fixes block comments with proper formatting to eliminate the
following checkpatch.pl warnings:

  "WARNING: Block comments use * on subsequent lines"
  "WARNING: Block comments use a trailing */ on a separate line"

Link: http://lkml.kernel.org/r/1462886671-3521-8-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c         |   12 +++--
 fs/nilfs2/bmap.h          |   12 +++--
 fs/nilfs2/cpfile.c        |    6 +-
 fs/nilfs2/ifile.c         |    6 +-
 fs/nilfs2/inode.c         |   73 +++++++++++++++++++++++-------------
 fs/nilfs2/nilfs.h         |   24 +++++++----
 fs/nilfs2/recovery.c      |   14 ++++--
 fs/nilfs2/segment.c       |   56 ++++++++++++++++++---------
 fs/nilfs2/segment.h       |   34 ++++++++++------
 fs/nilfs2/the_nilfs.c     |    6 +-
 include/linux/nilfs2_fs.h |   66 +++++++++++++++++++++-----------
 11 files changed, 202 insertions(+), 107 deletions(-)

diff -puN fs/nilfs2/alloc.c~nilfs2-fix-block-comments fs/nilfs2/alloc.c
--- a/fs/nilfs2/alloc.c~nilfs2-fix-block-comments
+++ a/fs/nilfs2/alloc.c
@@ -68,13 +68,17 @@ int nilfs_palloc_init_blockgroup(struct
 	mi->mi_blocks_per_group =
 		DIV_ROUND_UP(nilfs_palloc_entries_per_group(inode),
 			     mi->mi_entries_per_block) + 1;
-		/* Number of blocks in a group including entry blocks and
-		   a bitmap block */
+		/*
+		 * Number of blocks in a group including entry blocks
+		 * and a bitmap block
+		 */
 	mi->mi_blocks_per_desc_block =
 		nilfs_palloc_groups_per_desc_block(inode) *
 		mi->mi_blocks_per_group + 1;
-		/* Number of blocks per descriptor including the
-		   descriptor block */
+		/*
+		 * Number of blocks per descriptor including the
+		 * descriptor block
+		 */
 	return 0;
 }
 
diff -puN fs/nilfs2/bmap.h~nilfs2-fix-block-comments fs/nilfs2/bmap.h
--- a/fs/nilfs2/bmap.h~nilfs2-fix-block-comments
+++ a/fs/nilfs2/bmap.h
@@ -122,10 +122,14 @@ struct nilfs_bmap {
 
 /* pointer type */
 #define NILFS_BMAP_PTR_P	0	/* physical block number (i.e. LBN) */
-#define NILFS_BMAP_PTR_VS	1	/* virtual block number (single
-					   version) */
-#define NILFS_BMAP_PTR_VM	2	/* virtual block number (has multiple
-					   versions) */
+#define NILFS_BMAP_PTR_VS	1	/*
+					 * virtual block number (single
+					 * version)
+					 */
+#define NILFS_BMAP_PTR_VM	2	/*
+					 * virtual block number (has multiple
+					 * versions)
+					 */
 #define NILFS_BMAP_PTR_U	(-1)	/* never perform pointer operations */
 
 #define NILFS_BMAP_USE_VBN(bmap)	((bmap)->b_ptr_type > 0)
diff -puN fs/nilfs2/cpfile.c~nilfs2-fix-block-comments fs/nilfs2/cpfile.c
--- a/fs/nilfs2/cpfile.c~nilfs2-fix-block-comments
+++ a/fs/nilfs2/cpfile.c
@@ -870,8 +870,10 @@ int nilfs_cpfile_is_snapshot(struct inod
 	void *kaddr;
 	int ret;
 
-	/* CP number is invalid if it's zero or larger than the
-	largest	exist one.*/
+	/*
+	 * CP number is invalid if it's zero or larger than the
+	 * largest existing one.
+	 */
 	if (cno == 0 || cno >= nilfs_mdt_cno(cpfile))
 		return -ENOENT;
 	down_read(&NILFS_MDT(cpfile)->mi_sem);
diff -puN fs/nilfs2/ifile.c~nilfs2-fix-block-comments fs/nilfs2/ifile.c
--- a/fs/nilfs2/ifile.c~nilfs2-fix-block-comments
+++ a/fs/nilfs2/ifile.c
@@ -64,8 +64,10 @@ int nilfs_ifile_create_inode(struct inod
 	struct nilfs_palloc_req req;
 	int ret;
 
-	req.pr_entry_nr = 0;  /* 0 says find free inode from beginning of
-				 a group. dull code!! */
+	req.pr_entry_nr = 0;  /*
+			       * 0 says find free inode from beginning
+			       * of a group. dull code!!
+			       */
 	req.pr_entry_bh = NULL;
 
 	ret = nilfs_palloc_prepare_alloc_entry(ifile, &req);
diff -puN fs/nilfs2/inode.c~nilfs2-fix-block-comments fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-fix-block-comments
+++ a/fs/nilfs2/inode.c
@@ -129,11 +129,14 @@ int nilfs_get_block(struct inode *inode,
 		/* Error handling should be detailed */
 		set_buffer_new(bh_result);
 		set_buffer_delay(bh_result);
-		map_bh(bh_result, inode->i_sb, 0); /* dbn must be changed
-						      to proper value */
+		map_bh(bh_result, inode->i_sb, 0);
+		/* Disk block number must be changed to proper value */
+
 	} else if (ret == -ENOENT) {
-		/* not found is not error (e.g. hole); must return without
-		   the mapped state flag. */
+		/*
+		 * not found is not error (e.g. hole); must return without
+		 * the mapped state flag.
+		 */
 		;
 	} else {
 		err = ret;
@@ -395,23 +398,26 @@ struct inode *nilfs_new_inode(struct ino
 
 	err = nilfs_init_acl(inode, dir);
 	if (unlikely(err))
-		goto failed_after_creation; /* never occur. When supporting
-				    nilfs_init_acl(), proper cancellation of
-				    above jobs should be considered */
+		/*
+		 * Never occur.  When supporting nilfs_init_acl(),
+		 * proper cancellation of above jobs should be considered.
+		 */
+		goto failed_after_creation;
 
 	return inode;
 
  failed_after_creation:
 	clear_nlink(inode);
 	unlock_new_inode(inode);
-	iput(inode);  /* raw_inode will be deleted through
-			 nilfs_evict_inode() */
+	iput(inode);  /*
+		       * raw_inode will be deleted through
+		       * nilfs_evict_inode().
+		       */
 	goto failed;
 
  failed_ifile_create_inode:
 	make_bad_inode(inode);
-	iput(inode);  /* if i_nlink == 1, generic_forget_inode() will be
-			 called */
+	iput(inode);
  failed:
 	return ERR_PTR(err);
 }
@@ -662,8 +668,10 @@ void nilfs_write_inode_common(struct ino
 	else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
 		raw_inode->i_device_code =
 			cpu_to_le64(huge_encode_dev(inode->i_rdev));
-	/* When extending inode, nilfs->ns_inode_size should be checked
-	   for substitutions of appended fields */
+	/*
+	 * When extending inode, nilfs->ns_inode_size should be checked
+	 * for substitutions of appended fields.
+	 */
 }
 
 void nilfs_update_inode(struct inode *inode, struct buffer_head *ibh, int flags)
@@ -681,9 +689,12 @@ void nilfs_update_inode(struct inode *in
 		set_bit(NILFS_I_INODE_SYNC, &ii->i_state);
 
 	nilfs_write_inode_common(inode, raw_inode, 0);
-		/* XXX: call with has_bmap = 0 is a workaround to avoid
-		   deadlock of bmap. This delays update of i_bmap to just
-		   before writing */
+		/*
+		 * XXX: call with has_bmap = 0 is a workaround to avoid
+		 * deadlock of bmap.  This delays update of i_bmap to just
+		 * before writing.
+		 */
+
 	nilfs_ifile_unmap_inode(ifile, ino, ibh);
 }
 
@@ -748,8 +759,10 @@ void nilfs_truncate(struct inode *inode)
 	nilfs_mark_inode_dirty(inode);
 	nilfs_set_file_dirty(inode, 0);
 	nilfs_transaction_commit(sb);
-	/* May construct a logical segment and may fail in sync mode.
-	   But truncate has no return value. */
+	/*
+	 * May construct a logical segment and may fail in sync mode.
+	 * But truncate has no return value.
+	 */
 }
 
 static void nilfs_clear_inode(struct inode *inode)
@@ -806,8 +819,10 @@ void nilfs_evict_inode(struct inode *ino
 	if (IS_SYNC(inode))
 		nilfs_set_transaction_flag(NILFS_TI_SYNC);
 	nilfs_transaction_commit(sb);
-	/* May construct a logical segment and may fail in sync mode.
-	   But delete_inode has no return value. */
+	/*
+	 * May construct a logical segment and may fail in sync mode.
+	 * But delete_inode has no return value.
+	 */
 }
 
 int nilfs_setattr(struct dentry *dentry, struct iattr *iattr)
@@ -915,17 +930,23 @@ int nilfs_set_file_dirty(struct inode *i
 	spin_lock(&nilfs->ns_inode_lock);
 	if (!test_bit(NILFS_I_QUEUED, &ii->i_state) &&
 	    !test_bit(NILFS_I_BUSY, &ii->i_state)) {
-		/* Because this routine may race with nilfs_dispose_list(),
-		   we have to check NILFS_I_QUEUED here, too. */
+		/*
+		 * Because this routine may race with nilfs_dispose_list(),
+		 * we have to check NILFS_I_QUEUED here, too.
+		 */
 		if (list_empty(&ii->i_dirty) && igrab(inode) == NULL) {
-			/* This will happen when somebody is freeing
-			   this inode. */
+			/*
+			 * This will happen when somebody is freeing
+			 * this inode.
+			 */
 			nilfs_warning(inode->i_sb, __func__,
 				      "cannot get inode (ino=%lu)",
 				      inode->i_ino);
 			spin_unlock(&nilfs->ns_inode_lock);
-			return -EINVAL; /* NILFS_I_DIRTY may remain for
-					   freeing inode */
+			return -EINVAL; /*
+					 * NILFS_I_DIRTY may remain for
+					 * freeing inode.
+					 */
 		}
 		list_move_tail(&ii->i_dirty, &nilfs->ns_dirty_files);
 		set_bit(NILFS_I_QUEUED, &ii->i_state);
diff -puN fs/nilfs2/nilfs.h~nilfs2-fix-block-comments fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~nilfs2-fix-block-comments
+++ a/fs/nilfs2/nilfs.h
@@ -64,8 +64,10 @@ struct nilfs_inode_info {
 	 */
 	struct rw_semaphore xattr_sem;
 #endif
-	struct buffer_head *i_bh;	/* i_bh contains a new or dirty
-					   disk inode */
+	struct buffer_head *i_bh;	/*
+					 * i_bh contains a new or dirty
+					 * disk inode.
+					 */
 	struct nilfs_root *i_root;
 	struct inode vfs_inode;
 };
@@ -95,8 +97,10 @@ enum {
 	NILFS_I_NEW = 0,		/* Inode is newly created */
 	NILFS_I_DIRTY,			/* The file is dirty */
 	NILFS_I_QUEUED,			/* inode is in dirty_files list */
-	NILFS_I_BUSY,			/* inode is grabbed by a segment
-					   constructor */
+	NILFS_I_BUSY,			/*
+					 * Inode is grabbed by a segment
+					 * constructor
+					 */
 	NILFS_I_COLLECTED,		/* All dirty blocks are collected */
 	NILFS_I_UPDATED,		/* The file has been written back */
 	NILFS_I_INODE_SYNC,		/* dsync is not allowed for inode */
@@ -140,8 +144,10 @@ enum {
 struct nilfs_transaction_info {
 	u32			ti_magic;
 	void		       *ti_save;
-				/* This should never used. If this happens,
-				   one of other filesystems has a bug. */
+				/*
+				 * This should never be used.  If it happens,
+				 * one of other filesystems has a bug.
+				 */
 	unsigned short		ti_flags;
 	unsigned short		ti_count;
 };
@@ -151,8 +157,10 @@ struct nilfs_transaction_info {
 
 /* ti_flags */
 #define NILFS_TI_DYNAMIC_ALLOC	0x0001  /* Allocated from slab */
-#define NILFS_TI_SYNC		0x0002	/* Force to construct segment at the
-					   end of transaction. */
+#define NILFS_TI_SYNC		0x0002	/*
+					 * Force to construct segment at the
+					 * end of transaction.
+					 */
 #define NILFS_TI_GC		0x0004	/* GC context */
 #define NILFS_TI_COMMIT		0x0008	/* Change happened or not */
 #define NILFS_TI_WRITER		0x0010	/* Constructor context */
diff -puN fs/nilfs2/recovery.c~nilfs2-fix-block-comments fs/nilfs2/recovery.c
--- a/fs/nilfs2/recovery.c~nilfs2-fix-block-comments
+++ a/fs/nilfs2/recovery.c
@@ -43,8 +43,10 @@ enum {
 
 /* work structure for recovery */
 struct nilfs_recovery_block {
-	ino_t ino;		/* Inode number of the file that this block
-				   belongs to */
+	ino_t ino;		/*
+				 * Inode number of the file that this block
+				 * belongs to
+				 */
 	sector_t blocknr;	/* block number */
 	__u64 vblocknr;		/* virtual block number */
 	unsigned long blkoff;	/* File offset of the data block (per block) */
@@ -869,9 +871,11 @@ int nilfs_search_super_root(struct the_n
 
 		flags = le16_to_cpu(sum->ss_flags);
 		if (!(flags & NILFS_SS_SR) && !scan_newer) {
-			/* This will never happen because a superblock
-			   (last_segment) always points to a pseg
-			   having a super root. */
+			/*
+			 * This will never happen because a superblock
+			 * (last_segment) always points to a pseg with
+			 * a super root.
+			 */
 			ret = NILFS_SEG_FAIL_CONSISTENCY;
 			goto failed;
 		}
diff -puN fs/nilfs2/segment.c~nilfs2-fix-block-comments fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-fix-block-comments
+++ a/fs/nilfs2/segment.c
@@ -45,18 +45,26 @@
  */
 #define SC_N_INODEVEC	16   /* Size of locally allocated inode vector */
 
-#define SC_MAX_SEGDELTA 64   /* Upper limit of the number of segments
-				appended in collection retry loop */
+#define SC_MAX_SEGDELTA 64   /*
+			      * Upper limit of the number of segments
+			      * appended in collection retry loop
+			      */
 
 /* Construction mode */
 enum {
 	SC_LSEG_SR = 1,	/* Make a logical segment having a super root */
-	SC_LSEG_DSYNC,	/* Flush data blocks of a given file and make
-			   a logical segment without a super root */
-	SC_FLUSH_FILE,	/* Flush data files, leads to segment writes without
-			   creating a checkpoint */
-	SC_FLUSH_DAT,	/* Flush DAT file. This also creates segments without
-			   a checkpoint */
+	SC_LSEG_DSYNC,	/*
+			 * Flush data blocks of a given file and make
+			 * a logical segment without a super root.
+			 */
+	SC_FLUSH_FILE,	/*
+			 * Flush data files, leads to segment writes without
+			 * creating a checkpoint.
+			 */
+	SC_FLUSH_DAT,	/*
+			 * Flush DAT file.  This also creates segments
+			 * without a checkpoint.
+			 */
 };
 
 /* Stage numbers of dirty block collection */
@@ -438,8 +446,10 @@ static int nilfs_segctor_feed_segment(st
 {
 	sci->sc_nblk_this_inc += sci->sc_curseg->sb_sum.nblocks;
 	if (NILFS_SEGBUF_IS_LAST(sci->sc_curseg, &sci->sc_segbufs))
-		return -E2BIG; /* The current segment is filled up
-				  (internal code) */
+		return -E2BIG; /*
+				* The current segment is filled up
+				* (internal code)
+				*/
 	sci->sc_curseg = NILFS_NEXT_SEGBUF(sci->sc_curseg);
 	return nilfs_segctor_reset_segment_buffer(sci);
 }
@@ -869,9 +879,11 @@ static int nilfs_segctor_create_checkpoi
 	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, 1,
 					  &raw_cp, &bh_cp);
 	if (likely(!err)) {
-		/* The following code is duplicated with cpfile.  But, it is
-		   needed to collect the checkpoint even if it was not newly
-		   created */
+		/*
+		 * The following code is duplicated with cpfile.  But, it is
+		 * needed to collect the checkpoint even if it was not newly
+		 * created.
+		 */
 		mark_buffer_dirty(bh_cp);
 		nilfs_mdt_mark_dirty(nilfs->ns_cpfile);
 		nilfs_cpfile_put_checkpoint(
@@ -1400,8 +1412,10 @@ static void nilfs_free_incomplete_logs(s
 	if (atomic_read(&segbuf->sb_err)) {
 		/* Case 1: The first segment failed */
 		if (segbuf->sb_pseg_start != segbuf->sb_fseg_start)
-			/* Case 1a:  Partial segment appended into an existing
-			   segment */
+			/*
+			 * Case 1a:  Partial segment appended into an existing
+			 * segment
+			 */
 			nilfs_terminate_segment(nilfs, segbuf->sb_fseg_start,
 						segbuf->sb_fseg_end);
 		else /* Case 1b:  New full segment */
@@ -1625,8 +1639,10 @@ static int nilfs_segctor_assign(struct n
 static void nilfs_begin_page_io(struct page *page)
 {
 	if (!page || PageWriteback(page))
-		/* For split b-tree node pages, this function may be called
-		   twice.  We ignore the 2nd or later calls by this check. */
+		/*
+		 * For split b-tree node pages, this function may be called
+		 * twice.  We ignore the 2nd or later calls by this check.
+		 */
 		return;
 
 	lock_page(page);
@@ -2679,8 +2695,10 @@ static void nilfs_segctor_write_out(stru
 {
 	int ret, retrycount = NILFS_SC_CLEANUP_RETRY;
 
-	/* The segctord thread was stopped and its timer was removed.
-	   But some tasks remain. */
+	/*
+	 * The segctord thread was stopped and its timer was removed.
+	 * But some tasks remain.
+	 */
 	do {
 		struct nilfs_transaction_info ti;
 
diff -puN fs/nilfs2/segment.h~nilfs2-fix-block-comments fs/nilfs2/segment.h
--- a/fs/nilfs2/segment.h~nilfs2-fix-block-comments
+++ a/fs/nilfs2/segment.h
@@ -189,11 +189,15 @@ enum {
 	NILFS_SC_DIRTY,		/* One or more dirty meta-data blocks exist */
 	NILFS_SC_UNCLOSED,	/* Logical segment is not closed */
 	NILFS_SC_SUPER_ROOT,	/* The latest segment has a super root */
-	NILFS_SC_PRIOR_FLUSH,	/* Requesting immediate flush without making a
-				   checkpoint */
-	NILFS_SC_HAVE_DELTA,	/* Next checkpoint will have update of files
-				   other than DAT, cpfile, sufile, or files
-				   moved by GC */
+	NILFS_SC_PRIOR_FLUSH,	/*
+				 * Requesting immediate flush without making a
+				 * checkpoint
+				 */
+	NILFS_SC_HAVE_DELTA,	/*
+				 * Next checkpoint will have update of files
+				 * other than DAT, cpfile, sufile, or files
+				 * moved by GC.
+				 */
 };
 
 /* sc_state */
@@ -203,17 +207,23 @@ enum {
 /*
  * Constant parameters
  */
-#define NILFS_SC_CLEANUP_RETRY	    3  /* Retry count of construction when
-					  destroying segctord */
+#define NILFS_SC_CLEANUP_RETRY	    3  /*
+					* Retry count of construction when
+					* destroying segctord
+					*/
 
 /*
  * Default values of timeout, in seconds.
  */
-#define NILFS_SC_DEFAULT_TIMEOUT    5   /* Timeout value of dirty blocks.
-					   It triggers construction of a
-					   logical segment with a super root */
-#define NILFS_SC_DEFAULT_SR_FREQ    30  /* Maximum frequency of super root
-					   creation */
+#define NILFS_SC_DEFAULT_TIMEOUT    5   /*
+					 * Timeout value of dirty blocks.
+					 * It triggers construction of a
+					 * logical segment with a super root.
+					 */
+#define NILFS_SC_DEFAULT_SR_FREQ    30  /*
+					 * Maximum frequency of super root
+					 * creation
+					 */
 
 /*
  * The default threshold amount of data, in block counts.
diff -puN fs/nilfs2/the_nilfs.c~nilfs2-fix-block-comments fs/nilfs2/the_nilfs.c
--- a/fs/nilfs2/the_nilfs.c~nilfs2-fix-block-comments
+++ a/fs/nilfs2/the_nilfs.c
@@ -617,8 +617,10 @@ int init_nilfs(struct the_nilfs *nilfs,
 		err = nilfs_load_super_block(nilfs, sb, blocksize, &sbp);
 		if (err)
 			goto out;
-			/* not failed_sbh; sbh is released automatically
-			   when reloading fails. */
+			/*
+			 * Not to failed_sbh; sbh is released automatically
+			 * when reloading fails.
+			 */
 	}
 	nilfs->ns_blocksize_bits = sb->s_blocksize_bits;
 	nilfs->ns_blocksize = blocksize;
diff -puN include/linux/nilfs2_fs.h~nilfs2-fix-block-comments include/linux/nilfs2_fs.h
--- a/include/linux/nilfs2_fs.h~nilfs2-fix-block-comments
+++ a/include/linux/nilfs2_fs.h
@@ -127,10 +127,14 @@ struct nilfs_super_root {
 #define NILFS_MOUNT_ERRORS_RO		0x0020  /* Remount fs ro on errors */
 #define NILFS_MOUNT_ERRORS_PANIC	0x0040  /* Panic on errors */
 #define NILFS_MOUNT_BARRIER		0x1000  /* Use block barriers */
-#define NILFS_MOUNT_STRICT_ORDER	0x2000  /* Apply strict in-order
-						   semantics also for data */
-#define NILFS_MOUNT_NORECOVERY		0x4000  /* Disable write access during
-						   mount-time recovery */
+#define NILFS_MOUNT_STRICT_ORDER	0x2000  /*
+						 * Apply strict in-order
+						 * semantics also for data
+						 */
+#define NILFS_MOUNT_NORECOVERY		0x4000  /*
+						 * Disable write access during
+						 * mount-time recovery
+						 */
 #define NILFS_MOUNT_DISCARD		0x8000  /* Issue DISCARD requests */
 
 
@@ -142,16 +146,20 @@ struct nilfs_super_block {
 	__le16	s_minor_rev_level;	/* minor revision level */
 	__le16	s_magic;		/* Magic signature */
 
-	__le16  s_bytes;		/* Bytes count of CRC calculation
-					   for this structure. s_reserved
-					   is excluded. */
+	__le16  s_bytes;		/*
+					 * Bytes count of CRC calculation
+					 * for this structure. s_reserved
+					 * is excluded.
+					 */
 	__le16  s_flags;		/* flags */
 	__le32  s_crc_seed;		/* Seed value of CRC calculation */
 /*10*/	__le32	s_sum;			/* Check sum of super block */
 
-	__le32	s_log_block_size;	/* Block size represented as follows
-					   blocksize =
-					       1 << (s_log_block_size + 10) */
+	__le32	s_log_block_size;	/*
+					 * Block size represented as follows
+					 * blocksize =
+					 *     1 << (s_log_block_size + 10)
+					 */
 	__le64  s_nsegments;		/* Number of segments in filesystem */
 /*20*/	__le64  s_dev_size;		/* block device size in bytes */
 	__le64	s_first_data_block;	/* 1st seg disk block number */
@@ -163,8 +171,10 @@ struct nilfs_super_block {
 	__le64  s_last_seq;             /* seq. number of seg written last */
 /*50*/	__le64	s_free_blocks_count;	/* Free blocks count */
 
-	__le64	s_ctime;		/* Creation time (execution time of
-					   newfs) */
+	__le64	s_ctime;		/*
+					 * Creation time (execution time of
+					 * newfs)
+					 */
 /*60*/	__le64	s_mtime;		/* Mount time */
 	__le64	s_wtime;		/* Write time */
 /*70*/	__le16	s_mnt_count;		/* Mount count */
@@ -188,8 +198,10 @@ struct nilfs_super_block {
 /*A8*/	char	s_volume_name[80];	/* volume name */
 
 /*F8*/	__le32  s_c_interval;           /* Commit interval of segment */
-	__le32  s_c_block_max;          /* Threshold of data amount for
-					   the segment construction */
+	__le32  s_c_block_max;          /*
+					 * Threshold of data amount for
+					 * the segment construction
+					 */
 /*100*/	__le64  s_feature_compat;	/* Compatible feature set */
 	__le64  s_feature_compat_ro;	/* Read-only compatible feature set */
 	__le64  s_feature_incompat;	/* Incompatible feature set */
@@ -242,12 +254,18 @@ struct nilfs_super_block {
 
 #define NILFS_SB_OFFSET_BYTES	1024	/* byte offset of nilfs superblock */
 
-#define NILFS_SEG_MIN_BLOCKS	16	/* Minimum number of blocks in
-					   a full segment */
-#define NILFS_PSEG_MIN_BLOCKS	2	/* Minimum number of blocks in
-					   a partial segment */
-#define NILFS_MIN_NRSVSEGS	8	/* Minimum number of reserved
-					   segments */
+#define NILFS_SEG_MIN_BLOCKS	16	/*
+					 * Minimum number of blocks in
+					 * a full segment
+					 */
+#define NILFS_PSEG_MIN_BLOCKS	2	/*
+					 * Minimum number of blocks in
+					 * a partial segment
+					 */
+#define NILFS_MIN_NRSVSEGS	8	/*
+					 * Minimum number of reserved
+					 * segments
+					 */
 
 /*
  * We call DAT, cpfile, and sufile root metadata files.  Inodes of
@@ -513,9 +531,11 @@ struct nilfs_checkpoint {
 	__le64 cp_inodes_count;
 	__le64 cp_blocks_count;
 
-	/* Do not change the byte offset of ifile inode.
-	   To keep the compatibility of the disk format,
-	   additional fields should be added behind cp_ifile_inode. */
+	/*
+	 * Do not change the byte offset of ifile inode.
+	 * To keep the compatibility of the disk format,
+	 * additional fields should be added behind cp_ifile_inode.
+	 */
 	struct nilfs_inode cp_ifile_inode;
 };
 
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


