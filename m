From: akpm@linux-foundation.org
Subject: + nilfs2-introduce-secondary-super-block.patch added to -mm tree
Date: Thu, 05 Mar 2009 14:34:26 -0800
Message-ID: <200903052234.n25MYR74009195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754264AbZCEWfC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 17:35:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp


The patch titled
     nilfs2: introduce secondary super block
has been added to the -mm tree.  Its filename is
     nilfs2-introduce-secondary-super-block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: introduce secondary super block
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

The former versions didn't have extra super blocks.  This improves the
weak point by introducing another super block at unused region in tail of
the partition.

This doesn't break disk format compatibility; older versions just ingore
the secondary super block, and new versions just recover it if it doesn't
exist.  The partition created by an old mkfs may not have unused region,
but in that case, the secondary super block will not be added.

This doesn't make more redundant copies of the super block; it is a future
work.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/nilfs.h         |    7 -
 fs/nilfs2/recovery.c      |    1 
 fs/nilfs2/segment.c       |    8 -
 fs/nilfs2/segment.h       |    2 
 fs/nilfs2/super.c         |  229 ++++++++++++++----------------------
 fs/nilfs2/the_nilfs.c     |  179 ++++++++++++++++++++++++----
 fs/nilfs2/the_nilfs.h     |   18 ++
 include/linux/nilfs2_fs.h |    4 
 8 files changed, 273 insertions(+), 175 deletions(-)

diff -puN fs/nilfs2/nilfs.h~nilfs2-introduce-secondary-super-block fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~nilfs2-introduce-secondary-super-block
+++ a/fs/nilfs2/nilfs.h
@@ -275,13 +275,10 @@ extern void nilfs_error(struct super_blo
 extern void nilfs_warning(struct super_block *, const char *, const char *, ...)
        __attribute__ ((format (printf, 3, 4)));
 extern struct nilfs_super_block *
-nilfs_load_super_block(struct super_block *, struct buffer_head **);
-extern struct nilfs_super_block *
-nilfs_reload_super_block(struct super_block *, struct buffer_head **, int);
+nilfs_read_super_block(struct super_block *, u64, int, struct buffer_head **);
 extern int nilfs_store_magic_and_option(struct super_block *,
 					struct nilfs_super_block *, char *);
-extern void nilfs_update_last_segment(struct nilfs_sb_info *, int);
-extern int nilfs_commit_super(struct nilfs_sb_info *);
+extern int nilfs_commit_super(struct nilfs_sb_info *, int);
 extern int nilfs_attach_checkpoint(struct nilfs_sb_info *, __u64);
 extern void nilfs_detach_checkpoint(struct nilfs_sb_info *);
 
diff -puN fs/nilfs2/recovery.c~nilfs2-introduce-secondary-super-block fs/nilfs2/recovery.c
--- a/fs/nilfs2/recovery.c~nilfs2-introduce-secondary-super-block
+++ a/fs/nilfs2/recovery.c
@@ -870,7 +870,6 @@ int nilfs_search_super_root(struct the_n
 		if (scan_newer)
 			ri->ri_need_recovery = NILFS_RECOVERY_SR_UPDATED;
 		else {
-			nilfs->ns_prot_seq = ssi.seg_seq;
 			if (nilfs->ns_mount_state & NILFS_VALID_FS)
 				goto super_root_found;
 			scan_newer = 1;
diff -puN fs/nilfs2/segment.c~nilfs2-introduce-secondary-super-block fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-introduce-secondary-super-block
+++ a/fs/nilfs2/segment.c
@@ -2068,7 +2068,8 @@ static void nilfs_segctor_complete_write
 
 	if (update_sr) {
 		nilfs_set_last_segment(nilfs, segbuf->sb_pseg_start,
-				       segbuf->sb_sum.seg_seq, nilfs->ns_cno);
+				       segbuf->sb_sum.seg_seq, nilfs->ns_cno++);
+		sbi->s_super->s_dirt = 1;
 
 		clear_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags);
 		clear_bit(NILFS_SC_DIRTY, &sci->sc_flags);
@@ -2224,9 +2225,6 @@ static int nilfs_segctor_do_construct(st
 
 		/* Commit segments */
 		if (has_sr) {
-			down_write(&nilfs->ns_sem);
-			nilfs_update_last_segment(sbi, 1);
-			up_write(&nilfs->ns_sem);
 			nilfs_segctor_commit_free_segments(sci);
 			nilfs_segctor_clear_metadata_dirty(sci);
 		}
@@ -2564,7 +2562,7 @@ static int nilfs_segctor_construct(struc
 		if (test_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags) &&
 		    nilfs_discontinued(nilfs)) {
 			down_write(&nilfs->ns_sem);
-			req->sb_err = nilfs_commit_super(sbi);
+			req->sb_err = nilfs_commit_super(sbi, 0);
 			up_write(&nilfs->ns_sem);
 		}
 	}
diff -puN fs/nilfs2/segment.h~nilfs2-introduce-secondary-super-block fs/nilfs2/segment.h
--- a/fs/nilfs2/segment.h~nilfs2-introduce-secondary-super-block
+++ a/fs/nilfs2/segment.h
@@ -206,8 +206,6 @@ enum {
 					   logical segment with a super root */
 #define NILFS_SC_DEFAULT_SR_FREQ    30  /* Maximum frequency of super root
 					   creation */
-#define NILFS_SC_DEFAULT_SB_FREQ    30  /* Minimum interval of periodical
-					   update of superblock (reserved) */
 
 /*
  * The default threshold amount of data, in block counts.
diff -puN fs/nilfs2/super.c~nilfs2-introduce-secondary-super-block fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-introduce-secondary-super-block
+++ a/fs/nilfs2/super.c
@@ -103,8 +103,9 @@ void nilfs_error(struct super_block *sb,
 		down_write(&nilfs->ns_sem);
 		if (!(nilfs->ns_mount_state & NILFS_ERROR_FS)) {
 			nilfs->ns_mount_state |= NILFS_ERROR_FS;
-			nilfs->ns_sbp->s_state |= cpu_to_le16(NILFS_ERROR_FS);
-			nilfs_commit_super(sbi);
+			nilfs->ns_sbp[0]->s_state |=
+				cpu_to_le16(NILFS_ERROR_FS);
+			nilfs_commit_super(sbi, 1);
 		}
 		up_write(&nilfs->ns_sem);
 
@@ -208,90 +209,106 @@ static void nilfs_clear_inode(struct ino
 	nilfs_btnode_cache_clear(&ii->i_btnode_cache);
 }
 
-/**
- * nilfs_update_last_segment - change pointer to the latest segment
- * @sbi: nilfs_sb_info
- * @update_cno: flag whether to update checkpoint number.
- *
- * nilfs_update_last_segment() changes information in the super block
- * after a partial segment is written out successfully. The super
- * block is marked dirty. It will be written out at the next VFS sync
- * operations such as sync_supers() and generic_shutdown_super().
- */
-void nilfs_update_last_segment(struct nilfs_sb_info *sbi, int update_cno)
-{
-	struct the_nilfs *nilfs = sbi->s_nilfs;
-	struct nilfs_super_block *sbp = nilfs->ns_sbp;
-
-	/* nilfs->sem must be locked by the caller. */
-	spin_lock(&nilfs->ns_last_segment_lock);
-	if (update_cno)
-		nilfs->ns_last_cno = nilfs->ns_cno++;
-	sbp->s_last_seq = cpu_to_le64(nilfs->ns_last_seq);
-	sbp->s_last_pseg = cpu_to_le64(nilfs->ns_last_pseg);
-	sbp->s_last_cno = cpu_to_le64(nilfs->ns_last_cno);
-	spin_unlock(&nilfs->ns_last_segment_lock);
-
-	sbi->s_super->s_dirt = 1; /* must be set if delaying the call of
-				     nilfs_commit_super() */
-}
-
-static int nilfs_sync_super(struct nilfs_sb_info *sbi)
+static int nilfs_sync_super(struct nilfs_sb_info *sbi, int dupsb)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	int err;
 	int barrier_done = 0;
 
 	if (nilfs_test_opt(sbi, BARRIER)) {
-		set_buffer_ordered(nilfs->ns_sbh);
+		set_buffer_ordered(nilfs->ns_sbh[0]);
 		barrier_done = 1;
 	}
  retry:
-	set_buffer_dirty(nilfs->ns_sbh);
-	err = sync_dirty_buffer(nilfs->ns_sbh);
+	set_buffer_dirty(nilfs->ns_sbh[0]);
+	err = sync_dirty_buffer(nilfs->ns_sbh[0]);
 	if (err == -EOPNOTSUPP && barrier_done) {
 		nilfs_warning(sbi->s_super, __func__,
 			      "barrier-based sync failed. "
 			      "disabling barriers\n");
 		nilfs_clear_opt(sbi, BARRIER);
 		barrier_done = 0;
-		clear_buffer_ordered(nilfs->ns_sbh);
+		clear_buffer_ordered(nilfs->ns_sbh[0]);
 		goto retry;
 	}
-	if (unlikely(err))
+	if (unlikely(err)) {
 		printk(KERN_ERR
 		       "NILFS: unable to write superblock (err=%d)\n", err);
-	else {
+		if (err == -EIO && nilfs->ns_sbh[1]) {
+			nilfs_fall_back_super_block(nilfs);
+			goto retry;
+		}
+	} else {
+		struct nilfs_super_block *sbp = nilfs->ns_sbp[0];
+
+		/*
+		 * The latest segment becomes trailable from the position
+		 * written in superblock.
+		 */
 		clear_nilfs_discontinued(nilfs);
-		spin_lock(&nilfs->ns_last_segment_lock);
-		nilfs->ns_prot_seq = le64_to_cpu(nilfs->ns_sbp->s_last_seq);
-		spin_unlock(&nilfs->ns_last_segment_lock);
+
+		/* update GC protection for recent segments */
+		if (nilfs->ns_sbh[1]) {
+			sbp = NULL;
+			if (dupsb) {
+				set_buffer_dirty(nilfs->ns_sbh[1]);
+				if (!sync_dirty_buffer(nilfs->ns_sbh[1]))
+					sbp = nilfs->ns_sbp[1];
+			}
+		}
+		if (sbp) {
+			spin_lock(&nilfs->ns_last_segment_lock);
+			nilfs->ns_prot_seq = le64_to_cpu(sbp->s_last_seq);
+			spin_unlock(&nilfs->ns_last_segment_lock);
+		}
 	}
 
 	return err;
 }
 
-int nilfs_commit_super(struct nilfs_sb_info *sbi)
+int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
-	struct nilfs_super_block *sbp = nilfs->ns_sbp;
+	struct nilfs_super_block **sbp = nilfs->ns_sbp;
 	sector_t nfreeblocks;
+	time_t t;
 	int err;
 
 	/* nilfs->sem must be locked by the caller. */
+	if (sbp[0]->s_magic != NILFS_SUPER_MAGIC) {
+		if (sbp[1] && sbp[1]->s_magic == NILFS_SUPER_MAGIC)
+			nilfs_swap_super_block(nilfs);
+		else {
+			printk(KERN_CRIT "NILFS: superblock broke on dev %s\n",
+			       sbi->s_super->s_id);
+			return -EIO;
+		}
+	}
 	err = nilfs_count_free_blocks(nilfs, &nfreeblocks);
 	if (unlikely(err)) {
 		printk(KERN_ERR "NILFS: failed to count free blocks\n");
 		return err;
 	}
-	sbp->s_free_blocks_count = cpu_to_le64(nfreeblocks);
-	sbp->s_wtime = cpu_to_le64(get_seconds());
-	sbp->s_sum = 0;
-	sbp->s_sum = cpu_to_le32(crc32_le(nilfs->ns_crc_seed,
-					  (unsigned char *)sbp,
-					  le16_to_cpu(sbp->s_bytes)));
+	spin_lock(&nilfs->ns_last_segment_lock);
+	sbp[0]->s_last_seq = cpu_to_le64(nilfs->ns_last_seq);
+	sbp[0]->s_last_pseg = cpu_to_le64(nilfs->ns_last_pseg);
+	sbp[0]->s_last_cno = cpu_to_le64(nilfs->ns_last_cno);
+	spin_unlock(&nilfs->ns_last_segment_lock);
+
+	t = get_seconds();
+	nilfs->ns_sbwtime[0] = t;
+	sbp[0]->s_free_blocks_count = cpu_to_le64(nfreeblocks);
+	sbp[0]->s_wtime = cpu_to_le64(t);
+	sbp[0]->s_sum = 0;
+	sbp[0]->s_sum = cpu_to_le32(crc32_le(nilfs->ns_crc_seed,
+					     (unsigned char *)sbp[0],
+					     nilfs->ns_sbsize));
+	if (dupsb && sbp[1]) {
+		memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
+		nilfs->ns_sbwtime[1] = t;
+	}
 	sbi->s_super->s_dirt = 0;
-	return nilfs_sync_super(sbi);
+	return nilfs_sync_super(sbi, dupsb);
 }
 
 static void nilfs_put_super(struct super_block *sb)
@@ -303,8 +320,8 @@ static void nilfs_put_super(struct super
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		down_write(&nilfs->ns_sem);
-		nilfs->ns_sbp->s_state = cpu_to_le16(nilfs->ns_mount_state);
-		nilfs_commit_super(sbi);
+		nilfs->ns_sbp[0]->s_state = cpu_to_le16(nilfs->ns_mount_state);
+		nilfs_commit_super(sbi, 1);
 		up_write(&nilfs->ns_sem);
 	}
 
@@ -330,7 +347,7 @@ static void nilfs_put_super(struct super
  *   2.    down_write(&nilfs->ns_sem)
  *
  * Inside NILFS, locking ns_sem is enough to protect s_dirt and the buffer
- * of the super block (nilfs->ns_sbp).
+ * of the super block (nilfs->ns_sbp[]).
  *
  * In most cases, VFS functions call lock_super() before calling these
  * methods.  So we must be careful not to bring on deadlocks when using
@@ -346,8 +363,19 @@ static void nilfs_write_super(struct sup
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 
 	down_write(&nilfs->ns_sem);
-	if (!(sb->s_flags & MS_RDONLY))
-		nilfs_commit_super(sbi);
+	if (!(sb->s_flags & MS_RDONLY)) {
+		struct nilfs_super_block **sbp = nilfs->ns_sbp;
+		u64 t = get_seconds();
+		int dupsb;
+
+		if (!nilfs_discontinued(nilfs) && t >= nilfs->ns_sbwtime[0] &&
+		    t < nilfs->ns_sbwtime[0] + NILFS_SB_FREQ) {
+			up_write(&nilfs->ns_sem);
+			return;
+		}
+		dupsb = sbp[1] && t > nilfs->ns_sbwtime[1] + NILFS_ALTSB_FREQ;
+		nilfs_commit_super(sbi, dupsb);
+	}
 	sb->s_dirt = 0;
 	up_write(&nilfs->ns_sem);
 }
@@ -436,7 +464,7 @@ static int nilfs_mark_recovery_complete(
 	down_write(&nilfs->ns_sem);
 	if (!(nilfs->ns_mount_state & NILFS_VALID_FS)) {
 		nilfs->ns_mount_state |= NILFS_VALID_FS;
-		err = nilfs_commit_super(sbi);
+		err = nilfs_commit_super(sbi, 1);
 		if (likely(!err))
 			printk(KERN_INFO "NILFS: recovery complete.\n");
 	}
@@ -652,7 +680,7 @@ nilfs_set_default_options(struct nilfs_s
 static int nilfs_setup_super(struct nilfs_sb_info *sbi)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
-	struct nilfs_super_block *sbp = nilfs->ns_sbp;
+	struct nilfs_super_block *sbp = nilfs->ns_sbp[0];
 	int max_mnt_count = le16_to_cpu(sbp->s_max_mnt_count);
 	int mnt_count = le16_to_cpu(sbp->s_mnt_count);
 
@@ -674,88 +702,29 @@ static int nilfs_setup_super(struct nilf
 	sbp->s_mnt_count = cpu_to_le16(mnt_count + 1);
 	sbp->s_state = cpu_to_le16(le16_to_cpu(sbp->s_state) & ~NILFS_VALID_FS);
 	sbp->s_mtime = cpu_to_le64(get_seconds());
-	return nilfs_commit_super(sbi);
+	return nilfs_commit_super(sbi, 1);
 }
 
-struct nilfs_super_block *
-nilfs_load_super_block(struct super_block *sb, struct buffer_head **pbh)
+struct nilfs_super_block *nilfs_read_super_block(struct super_block *sb,
+						 u64 pos, int blocksize,
+						 struct buffer_head **pbh)
 {
-	int blocksize;
-	unsigned long offset, sb_index;
-
-	/*
-	 * Adjusting block size
-	 * Blocksize will be enlarged when it is smaller than hardware
-	 * sector size.
-	 * Disk format of superblock does not change.
-	 */
-	blocksize = sb_min_blocksize(sb, BLOCK_SIZE);
-	if (!blocksize) {
-		printk(KERN_ERR
-		       "NILFS: unable to set blocksize of superblock\n");
-		return NULL;
-	}
-	sb_index = NILFS_SB_OFFSET_BYTES / blocksize;
-	offset = NILFS_SB_OFFSET_BYTES % blocksize;
+	unsigned long long sb_index = pos;
+	unsigned long offset;
 
+	offset = do_div(sb_index, blocksize);
 	*pbh = sb_bread(sb, sb_index);
-	if (!*pbh) {
-		printk(KERN_ERR "NILFS: unable to read superblock\n");
+	if (!*pbh)
 		return NULL;
-	}
 	return (struct nilfs_super_block *)((char *)(*pbh)->b_data + offset);
 }
 
-struct nilfs_super_block *
-nilfs_reload_super_block(struct super_block *sb, struct buffer_head **pbh,
-			 int blocksize)
-{
-	struct nilfs_super_block *sbp;
-	unsigned long offset, sb_index;
-	int hw_blocksize = bdev_hardsect_size(sb->s_bdev);
-
-	if (blocksize < hw_blocksize) {
-		printk(KERN_ERR
-		       "NILFS: blocksize %d too small for device "
-		       "(sector-size = %d).\n",
-		       blocksize, hw_blocksize);
-		goto failed_sbh;
-	}
-	brelse(*pbh);
-	sb_set_blocksize(sb, blocksize);
-
-	sb_index = NILFS_SB_OFFSET_BYTES / blocksize;
-	offset = NILFS_SB_OFFSET_BYTES % blocksize;
-
-	*pbh = sb_bread(sb, sb_index);
-	if (!*pbh) {
-		printk(KERN_ERR
-		       "NILFS: cannot read superblock on 2nd try.\n");
-		goto failed;
-	}
-
-	sbp = (struct nilfs_super_block *)((char *)(*pbh)->b_data + offset);
-	if (sbp->s_magic != cpu_to_le16(NILFS_SUPER_MAGIC)) {
-		printk(KERN_ERR
-		       "NILFS: !? Magic mismatch on 2nd try.\n");
-		goto failed_sbh;
-	}
-	return sbp;
-
- failed_sbh:
-	brelse(*pbh);
-
- failed:
-	return NULL;
-}
-
 int nilfs_store_magic_and_option(struct super_block *sb,
 				 struct nilfs_super_block *sbp,
 				 char *data)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
 
-	/* trying to fill super (1st stage) */
 	sb->s_magic = le16_to_cpu(sbp->s_magic);
 
 	/* FS independent flags */
@@ -763,11 +732,6 @@ int nilfs_store_magic_and_option(struct 
 	sb->s_flags |= MS_NOATIME;
 #endif
 
-	if (sb->s_magic != NILFS_SUPER_MAGIC) {
-		printk("NILFS: Can't find nilfs on dev %s.\n", sb->s_id);
-		return -EINVAL;
-	}
-
 	nilfs_set_default_options(sbi, sbp);
 
 	sbi->s_resuid = le16_to_cpu(sbp->s_def_resuid);
@@ -775,10 +739,7 @@ int nilfs_store_magic_and_option(struct 
 	sbi->s_interval = le32_to_cpu(sbp->s_c_interval);
 	sbi->s_watermark = le32_to_cpu(sbp->s_c_block_max);
 
-	if (!parse_options(data, sb))
-		return -EINVAL;
-
-	return 0;
+	return !parse_options(data, sb) ? -EINVAL : 0 ;
 }
 
 /**
@@ -967,12 +928,12 @@ static int nilfs_remount(struct super_bl
 		 * the RDONLY flag and then mark the partition as valid again.
 		 */
 		down_write(&nilfs->ns_sem);
-		sbp = nilfs->ns_sbp;
+		sbp = nilfs->ns_sbp[0];
 		if (!(sbp->s_state & le16_to_cpu(NILFS_VALID_FS)) &&
 		    (nilfs->ns_mount_state & NILFS_VALID_FS))
 			sbp->s_state = cpu_to_le16(nilfs->ns_mount_state);
 		sbp->s_mtime = cpu_to_le64(get_seconds());
-		nilfs_commit_super(sbi);
+		nilfs_commit_super(sbi, 1);
 		up_write(&nilfs->ns_sem);
 	} else {
 		/*
diff -puN fs/nilfs2/the_nilfs.c~nilfs2-introduce-secondary-super-block fs/nilfs2/the_nilfs.c
--- a/fs/nilfs2/the_nilfs.c~nilfs2-introduce-secondary-super-block
+++ a/fs/nilfs2/the_nilfs.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
+#include <linux/crc32.h>
 #include "nilfs.h"
 #include "segment.h"
 #include "alloc.h"
@@ -105,7 +106,8 @@ void put_nilfs(struct the_nilfs *nilfs)
 	}
 	if (nilfs_init(nilfs)) {
 		nilfs_destroy_gccache(nilfs);
-		brelse(nilfs->ns_sbh);
+		brelse(nilfs->ns_sbh[0]);
+		brelse(nilfs->ns_sbh[1]);
 	}
 	kfree(nilfs);
 }
@@ -115,6 +117,7 @@ static int nilfs_load_super_root(struct 
 {
 	struct buffer_head *bh_sr;
 	struct nilfs_super_root *raw_sr;
+	struct nilfs_super_block **sbp = nilfs->ns_sbp;
 	unsigned dat_entry_size, segment_usage_size, checkpoint_size;
 	unsigned inode_size;
 	int err;
@@ -124,9 +127,9 @@ static int nilfs_load_super_root(struct 
 		return err;
 
 	down_read(&nilfs->ns_sem);
-	dat_entry_size = le16_to_cpu(nilfs->ns_sbp->s_dat_entry_size);
-	checkpoint_size = le16_to_cpu(nilfs->ns_sbp->s_checkpoint_size);
-	segment_usage_size = le16_to_cpu(nilfs->ns_sbp->s_segment_usage_size);
+	dat_entry_size = le16_to_cpu(sbp[0]->s_dat_entry_size);
+	checkpoint_size = le16_to_cpu(sbp[0]->s_checkpoint_size);
+	segment_usage_size = le16_to_cpu(sbp[0]->s_segment_usage_size);
 	up_read(&nilfs->ns_sem);
 
 	inode_size = nilfs->ns_inode_size;
@@ -270,11 +273,8 @@ int load_nilfs(struct the_nilfs *nilfs, 
 			nilfs_mdt_destroy(nilfs->ns_dat);
 			goto failed;
 		}
-		if (ri.ri_need_recovery == NILFS_RECOVERY_SR_UPDATED) {
-			down_write(&nilfs->ns_sem);
-			nilfs_update_last_segment(sbi, 0);
-			up_write(&nilfs->ns_sem);
-		}
+		if (ri.ri_need_recovery == NILFS_RECOVERY_SR_UPDATED)
+			sbi->s_super->s_dirt = 1;
 	}
 
 	set_nilfs_loaded(nilfs);
@@ -296,9 +296,8 @@ static unsigned long long nilfs_max_size
 	return res;
 }
 
-static int
-nilfs_store_disk_layout(struct the_nilfs *nilfs, struct super_block *sb,
-			struct nilfs_super_block *sbp)
+static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
+				   struct nilfs_super_block *sbp)
 {
 	if (le32_to_cpu(sbp->s_rev_level) != NILFS_CURRENT_REV) {
 		printk(KERN_ERR "NILFS: revision mismatch "
@@ -309,6 +308,10 @@ nilfs_store_disk_layout(struct the_nilfs
 		       NILFS_CURRENT_REV, NILFS_MINOR_REV);
 		return -EINVAL;
 	}
+	nilfs->ns_sbsize = le16_to_cpu(sbp->s_bytes);
+	if (nilfs->ns_sbsize > BLOCK_SIZE)
+		return -EINVAL;
+
 	nilfs->ns_inode_size = le16_to_cpu(sbp->s_inode_size);
 	nilfs->ns_first_ino = le32_to_cpu(sbp->s_first_ino);
 
@@ -330,6 +333,122 @@ nilfs_store_disk_layout(struct the_nilfs
 	return 0;
 }
 
+static int nilfs_valid_sb(struct nilfs_super_block *sbp)
+{
+	static unsigned char sum[4];
+	const int sumoff = offsetof(struct nilfs_super_block, s_sum);
+	size_t bytes;
+	u32 crc;
+
+	if (!sbp || le16_to_cpu(sbp->s_magic) != NILFS_SUPER_MAGIC)
+		return 0;
+	bytes = le16_to_cpu(sbp->s_bytes);
+	if (bytes > BLOCK_SIZE)
+		return 0;
+	crc = crc32_le(le32_to_cpu(sbp->s_crc_seed), (unsigned char *)sbp,
+		       sumoff);
+	crc = crc32_le(crc, sum, 4);
+	crc = crc32_le(crc, (unsigned char *)sbp + sumoff + 4,
+		       bytes - sumoff - 4);
+	return crc == le32_to_cpu(sbp->s_sum);
+}
+
+static int nilfs_sb2_bad_offset(struct nilfs_super_block *sbp, u64 offset)
+{
+	return offset < ((le64_to_cpu(sbp->s_nsegments) *
+			  le32_to_cpu(sbp->s_blocks_per_segment)) <<
+			 (le32_to_cpu(sbp->s_log_block_size) + 10));
+}
+
+static void nilfs_release_super_block(struct the_nilfs *nilfs)
+{
+	int i;
+
+	for (i = 0; i < 2; i++) {
+		if (nilfs->ns_sbp[i]) {
+			brelse(nilfs->ns_sbh[i]);
+			nilfs->ns_sbh[i] = NULL;
+			nilfs->ns_sbp[i] = NULL;
+		}
+	}
+}
+
+void nilfs_fall_back_super_block(struct the_nilfs *nilfs)
+{
+	brelse(nilfs->ns_sbh[0]);
+	nilfs->ns_sbh[0] = nilfs->ns_sbh[1];
+	nilfs->ns_sbp[0] = nilfs->ns_sbp[1];
+	nilfs->ns_sbh[1] = NULL;
+	nilfs->ns_sbp[1] = NULL;
+}
+
+void nilfs_swap_super_block(struct the_nilfs *nilfs)
+{
+	struct buffer_head *tsbh = nilfs->ns_sbh[0];
+	struct nilfs_super_block *tsbp = nilfs->ns_sbp[0];
+
+	nilfs->ns_sbh[0] = nilfs->ns_sbh[1];
+	nilfs->ns_sbp[0] = nilfs->ns_sbp[1];
+	nilfs->ns_sbh[1] = tsbh;
+	nilfs->ns_sbp[1] = tsbp;
+}
+
+static int nilfs_load_super_block(struct the_nilfs *nilfs,
+				  struct super_block *sb, int blocksize,
+				  struct nilfs_super_block **sbpp)
+{
+	struct nilfs_super_block **sbp = nilfs->ns_sbp;
+	struct buffer_head **sbh = nilfs->ns_sbh;
+	u64 sb2off = NILFS_SB2_OFFSET_BYTES(nilfs->ns_bdev->bd_inode->i_size);
+	int valid[2], swp = 0;
+
+	sbp[0] = nilfs_read_super_block(sb, NILFS_SB_OFFSET_BYTES, blocksize,
+					&sbh[0]);
+	sbp[1] = nilfs_read_super_block(sb, sb2off, blocksize, &sbh[1]);
+
+	if (!sbp[0]) {
+		if (!sbp[1]) {
+			printk(KERN_ERR "NILFS: unable to read superblock\n");
+			return -EIO;
+		}
+		printk(KERN_WARNING
+		       "NILFS warning: unable to read primary superblock\n");
+	} else if (!sbp[1])
+		printk(KERN_WARNING
+		       "NILFS warning: unable to read secondary superblock\n");
+
+	valid[0] = nilfs_valid_sb(sbp[0]);
+	valid[1] = nilfs_valid_sb(sbp[1]);
+	swp = valid[1] &&
+		(!valid[0] ||
+		 le64_to_cpu(sbp[1]->s_wtime) > le64_to_cpu(sbp[0]->s_wtime));
+
+	if (valid[swp] && nilfs_sb2_bad_offset(sbp[swp], sb2off)) {
+		brelse(sbh[1]);
+		sbh[1] = NULL;
+		sbp[1] = NULL;
+		swp = 0;
+	}
+	if (!valid[swp]) {
+		nilfs_release_super_block(nilfs);
+		printk(KERN_ERR "NILFS: Can't find nilfs on dev %s.\n",
+		       sb->s_id);
+		return -EINVAL;
+	}
+
+	if (swp) {
+		printk(KERN_WARNING "NILFS warning: broken superblock. "
+		       "using spare superblock.\n");
+		nilfs_swap_super_block(nilfs);
+	}
+
+	nilfs->ns_sbwtime[0] = le64_to_cpu(sbp[0]->s_wtime);
+	nilfs->ns_sbwtime[1] = valid[!swp] ? le64_to_cpu(sbp[1]->s_wtime) : 0;
+	nilfs->ns_prot_seq = le64_to_cpu(sbp[valid[1] & !swp]->s_last_seq);
+	*sbpp = sbp[0];
+	return 0;
+}
+
 /**
  * init_nilfs - initialize a NILFS instance.
  * @nilfs: the_nilfs structure
@@ -352,7 +471,6 @@ nilfs_store_disk_layout(struct the_nilfs
 int init_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi, char *data)
 {
 	struct super_block *sb = sbi->s_super;
-	struct buffer_head *sbh;
 	struct nilfs_super_block *sbp;
 	struct backing_dev_info *bdi;
 	int blocksize;
@@ -361,7 +479,7 @@ int init_nilfs(struct the_nilfs *nilfs, 
 	down_write(&nilfs->ns_sem);
 	if (nilfs_init(nilfs)) {
 		/* Load values from existing the_nilfs */
-		sbp = nilfs->ns_sbp;
+		sbp = nilfs->ns_sbp[0];
 		err = nilfs_store_magic_and_option(sb, sbp, data);
 		if (err)
 			goto out;
@@ -377,36 +495,49 @@ int init_nilfs(struct the_nilfs *nilfs, 
 		goto out;
 	}
 
-	sbp = nilfs_load_super_block(sb, &sbh);
-	if (!sbp) {
+	blocksize = sb_min_blocksize(sb, BLOCK_SIZE);
+	if (!blocksize) {
+		printk(KERN_ERR "NILFS: unable to set blocksize\n");
 		err = -EINVAL;
 		goto out;
 	}
+	err = nilfs_load_super_block(nilfs, sb, blocksize, &sbp);
+	if (err)
+		goto out;
+
 	err = nilfs_store_magic_and_option(sb, sbp, data);
 	if (err)
 		goto failed_sbh;
 
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbp->s_log_block_size);
 	if (sb->s_blocksize != blocksize) {
-		sbp = nilfs_reload_super_block(sb, &sbh, blocksize);
-		if (!sbp) {
-			err = -EINVAL;
+		int hw_blocksize = bdev_hardsect_size(sb->s_bdev);
+
+		if (blocksize < hw_blocksize) {
+			printk(KERN_ERR
+			       "NILFS: blocksize %d too small for device "
+			       "(sector-size = %d).\n",
+			       blocksize, hw_blocksize);
+			goto failed_sbh;
+		}
+		nilfs_release_super_block(nilfs);
+		sb_set_blocksize(sb, blocksize);
+
+		err = nilfs_load_super_block(nilfs, sb, blocksize, &sbp);
+		if (err)
 			goto out;
 			/* not failed_sbh; sbh is released automatically
 			   when reloading fails. */
-		}
 	}
 	nilfs->ns_blocksize_bits = sb->s_blocksize_bits;
 
-	err = nilfs_store_disk_layout(nilfs, sb, sbp);
+	err = nilfs_store_disk_layout(nilfs, sbp);
 	if (err)
 		goto failed_sbh;
 
 	sb->s_maxbytes = nilfs_max_size(sb->s_blocksize_bits);
 
 	nilfs->ns_mount_state = le16_to_cpu(sbp->s_state);
-	nilfs->ns_sbh = sbh;
-	nilfs->ns_sbp = sbp;
 
 	bdi = nilfs->ns_bdev->bd_inode_backing_dev_info;
 	if (!bdi)
@@ -443,7 +574,7 @@ int init_nilfs(struct the_nilfs *nilfs, 
 	return err;
 
  failed_sbh:
-	brelse(sbh);
+	nilfs_release_super_block(nilfs);
 	goto out;
 }
 
diff -puN fs/nilfs2/the_nilfs.h~nilfs2-introduce-secondary-super-block fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-introduce-secondary-super-block
+++ a/fs/nilfs2/the_nilfs.h
@@ -49,8 +49,10 @@ enum {
  * @ns_sem: semaphore for shared states
  * @ns_writer_mutex: mutex protecting ns_writer attach/detach
  * @ns_writer_refcount: number of referrers on ns_writer
- * @ns_sbh: buffer head of the on-disk super block
- * @ns_sbp: pointer to the super block data
+ * @ns_sbh: buffer heads of on-disk super blocks
+ * @ns_sbp: pointers to super block data
+ * @ns_sbwtime: previous write time of super blocks
+ * @ns_sbsize: size of valid data in super block
  * @ns_supers: list of nilfs super block structs
  * @ns_seg_seq: segment sequence counter
  * @ns_segnum: index number of the latest full segment.
@@ -101,8 +103,10 @@ struct the_nilfs {
 	 * - protecting s_dirt in the super_block struct
 	 *   (see nilfs_write_super) and the following fields.
 	 */
-	struct buffer_head     *ns_sbh;
-	struct nilfs_super_block *ns_sbp;
+	struct buffer_head     *ns_sbh[2];
+	struct nilfs_super_block *ns_sbp[2];
+	time_t			ns_sbwtime[2];
+	unsigned		ns_sbsize;
 	unsigned		ns_mount_state;
 	struct list_head	ns_supers;
 
@@ -182,6 +186,10 @@ THE_NILFS_FNS(INIT, init)
 THE_NILFS_FNS(LOADED, loaded)
 THE_NILFS_FNS(DISCONTINUED, discontinued)
 
+/* Minimum interval of periodical update of superblocks (in seconds) */
+#define NILFS_SB_FREQ		10
+#define NILFS_ALTSB_FREQ	60  /* spare superblock */
+
 void nilfs_set_last_segment(struct the_nilfs *, sector_t, u64, __u64);
 struct the_nilfs *alloc_nilfs(struct block_device *);
 void put_nilfs(struct the_nilfs *);
@@ -190,6 +198,8 @@ int load_nilfs(struct the_nilfs *, struc
 int nilfs_count_free_blocks(struct the_nilfs *, sector_t *);
 int nilfs_checkpoint_is_mounted(struct the_nilfs *, __u64, int);
 int nilfs_near_disk_full(struct the_nilfs *);
+void nilfs_fall_back_super_block(struct the_nilfs *);
+void nilfs_swap_super_block(struct the_nilfs *);
 
 
 static inline void get_nilfs(struct the_nilfs *nilfs)
diff -puN include/linux/nilfs2_fs.h~nilfs2-introduce-secondary-super-block include/linux/nilfs2_fs.h
--- a/include/linux/nilfs2_fs.h~nilfs2-introduce-secondary-super-block
+++ a/include/linux/nilfs2_fs.h
@@ -252,6 +252,10 @@ struct nilfs_super_block {
 #define NILFS_MIN_NRSVSEGS	8	/* Minimum number of reserved
 					   segments */
 
+/*
+ * bytes offset of secondary super block
+ */
+#define NILFS_SB2_OFFSET_BYTES(devsize)	((((devsize) >> 12) - 1) << 12)
 
 /*
  * Maximal count of links to a file
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-add-document.patch
nilfs2-disk-format-and-userland-interface.patch
nilfs2-add-inode-and-other-major-structures.patch
nilfs2-integrated-block-mapping.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-b-tree-based-block-mapping.patch
nilfs2-direct-block-mapping.patch
nilfs2-b-tree-node-cache.patch
nilfs2-buffer-and-page-operations.patch
nilfs2-meta-data-file.patch
nilfs2-persistent-object-allocator.patch
nilfs2-disk-address-translator.patch
nilfs2-inode-map-file.patch
nilfs2-checkpoint-file.patch
nilfs2-segment-usage-file.patch
nilfs2-segment-usage-file-fix-wrong-counting-of-checkpoints-and-dirty-segments.patch
nilfs2-inode-operations.patch
nilfs2-inode-operations-fix.patch
nilfs2-file-operations.patch
nilfs2-directory-entry-operations.patch
nilfs2-pathname-operations.patch
nilfs2-pathname-operations-fix.patch
nilfs2-operations-for-the_nilfs-core-object.patch
nilfs2-super-block-operations.patch
nilfs2-super-block-operations-fix.patch
nilfs2-segment-buffer.patch
nilfs2-segment-buffer-fix.patch
nilfs2-segment-constructor.patch
nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite.patch
nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range.patch
nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range-fix.patch
nilfs2-recovery-functions.patch
nilfs2-another-dat-for-garbage-collection.patch
nilfs2-block-cache-for-garbage-collection.patch
nilfs2-ioctl-operations.patch
nilfs2-update-makefile-and-kconfig.patch
nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch
nilfs2-cleanup-nilfs_clear_inode.patch
nilfs2-avoid-double-error-caused-by-nilfs_transaction_end.patch
nilfs2-insert-explanations-in-gcinode-file.patch
nilfs2-add-maintainer.patch
nilfs2-fix-gc-failure-on-volumes-keeping-numerous-snapshots.patch
nilfs2-clean-up-indirect-function-calling-conventions.patch
nilfs2-fix-buggy-behavior-seen-in-enumerating-checkpoints.patch
nilfs2-remove-timedwait-ioctl-command.patch
nilfs2-use-fixed-sized-types-for-ioctl-structures.patch
nilfs2-remove-compat-ioctl-code.patch
nilfs2-use-unlocked_ioctl.patch
nilfs2-extend-nilfs_sustat-ioctl-struct.patch
nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl.patch
nilfs2-super-block-operations-fix-endian-bug.patch
nilfs2-clean-up-sketch-file.patch
nilfs2-mark-minor-flag-for-checkpoint-created-by-internal-operation.patch
nilfs2-simplify-handling-of-active-state-of-segments.patch
nilfs2-introduce-secondary-super-block.patch

