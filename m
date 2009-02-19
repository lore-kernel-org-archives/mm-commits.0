From: akpm@linux-foundation.org
Subject: + nilfs2-remove-timedwait-ioctl-command.patch added to -mm tree
Date: Wed, 18 Feb 2009 17:22:26 -0800
Message-ID: <200902190122.n1J1MQLk006658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753749AbZBSBWf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 20:22:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp


The patch titled
     nilfs2: remove timedwait ioctl command
has been added to the -mm tree.  Its filename is
     nilfs2-remove-timedwait-ioctl-command.patch

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
Subject: nilfs2: remove timedwait ioctl command
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This removes NILFS_IOCTL_TIMEDWAIT command from ioctl interface along
with the related flags and wait queue.

The command is terrible because it just sleeps in the ioctl.  I prefer
to avoid this by devising means of event polling in userland program.
By reconsidering the userland GC daemon, I found this is possible
without changing behaviour of the daemon and sacrificing efficiency.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c         |   95 ------------------------------------
 fs/nilfs2/segment.c       |    5 -
 fs/nilfs2/the_nilfs.c     |    1 
 fs/nilfs2/the_nilfs.h     |    6 --
 include/linux/nilfs2_fs.h |   22 --------
 5 files changed, 2 insertions(+), 127 deletions(-)

diff -puN fs/nilfs2/ioctl.c~nilfs2-remove-timedwait-ioctl-command fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-remove-timedwait-ioctl-command
+++ a/fs/nilfs2/ioctl.c
@@ -578,62 +578,9 @@ int nilfs_ioctl_prepare_clean_segments(s
 static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 				      unsigned int cmd, void __user *argp)
 {
-	int ret;
-
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-
-	ret = nilfs_clean_segments(inode->i_sb, argp);
-	clear_nilfs_cond_nongc_write(NILFS_SB(inode->i_sb)->s_nilfs);
-	return ret;
-}
-
-static int nilfs_ioctl_test_cond(struct the_nilfs *nilfs, int cond)
-{
-	return (cond & NILFS_TIMEDWAIT_SEG_WRITE) &&
-		nilfs_cond_nongc_write(nilfs);
-}
-
-static void nilfs_ioctl_clear_cond(struct the_nilfs *nilfs, int cond)
-{
-	if (cond & NILFS_TIMEDWAIT_SEG_WRITE)
-		clear_nilfs_cond_nongc_write(nilfs);
-}
-
-static int nilfs_ioctl_timedwait(struct inode *inode, struct file *filp,
-				 unsigned int cmd, void __user *argp)
-{
-	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
-	struct nilfs_wait_cond wc;
-	long ret;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-	if (copy_from_user(&wc, argp, sizeof(wc)))
-		return -EFAULT;
-
-	unlock_kernel();
-	ret = wc.wc_flags ?
-		wait_event_interruptible_timeout(
-			nilfs->ns_cleanerd_wq,
-			nilfs_ioctl_test_cond(nilfs, wc.wc_cond),
-			timespec_to_jiffies(&wc.wc_timeout)) :
-		wait_event_interruptible(
-			nilfs->ns_cleanerd_wq,
-			nilfs_ioctl_test_cond(nilfs, wc.wc_cond));
-	lock_kernel();
-	nilfs_ioctl_clear_cond(nilfs, wc.wc_cond);
-
-	if (ret > 0) {
-		jiffies_to_timespec(ret, &wc.wc_timeout);
-		if (copy_to_user(argp, &wc, sizeof(wc)))
-			return -EFAULT;
-		return 0;
-	}
-	if (ret != 0)
-		return -EINTR;
-
-	return wc.wc_flags ? -ETIME : 0;
+	return nilfs_clean_segments(inode->i_sb, argp);
 }
 
 static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
@@ -679,8 +626,6 @@ int nilfs_ioctl(struct inode *inode, str
 		return nilfs_ioctl_get_bdescs(inode, filp, cmd, argp);
 	case NILFS_IOCTL_CLEAN_SEGMENTS:
 		return nilfs_ioctl_clean_segments(inode, filp, cmd, argp);
-	case NILFS_IOCTL_TIMEDWAIT:
-		return nilfs_ioctl_timedwait(inode, filp, cmd, argp);
 	case NILFS_IOCTL_SYNC:
 		return nilfs_ioctl_sync(inode, filp, cmd, argp);
 	default:
@@ -871,41 +816,6 @@ nilfs_compat_ioctl_clean_segments(struct
 		inode, filp, cmd, (unsigned long)uargv);
 }
 
-static int
-nilfs_compat_ioctl_timedwait(struct inode *inode, struct file *filp,
-			     unsigned int cmd, unsigned long arg)
-{
-	struct nilfs_wait_cond __user *uwcond;
-	struct nilfs_wait_cond32 __user *uwcond32;
-	struct timespec ts;
-	int cond, flags, ret;
-
-	uwcond = compat_alloc_user_space(sizeof(struct nilfs_wait_cond));
-	uwcond32 = compat_ptr(arg);
-	if (get_user(cond, &uwcond32->wc_cond) ||
-	    put_user(cond, &uwcond->wc_cond) ||
-	    get_user(flags, &uwcond32->wc_flags) ||
-	    put_user(flags, &uwcond->wc_flags) ||
-	    get_user(ts.tv_sec, &uwcond32->wc_timeout.tv_sec) ||
-	    get_user(ts.tv_nsec, &uwcond32->wc_timeout.tv_nsec) ||
-	    put_user(ts.tv_sec, &uwcond->wc_timeout.tv_sec) ||
-	    put_user(ts.tv_nsec, &uwcond->wc_timeout.tv_nsec))
-		return -EFAULT;
-
-	ret = nilfs_compat_locked_ioctl(inode, filp, cmd,
-					(unsigned long)uwcond);
-	if (ret < 0)
-		return ret;
-
-	if (get_user(ts.tv_sec, &uwcond->wc_timeout.tv_sec) ||
-	    get_user(ts.tv_nsec, &uwcond->wc_timeout.tv_nsec) ||
-	    put_user(ts.tv_sec, &uwcond32->wc_timeout.tv_sec) ||
-	    put_user(ts.tv_nsec, &uwcond32->wc_timeout.tv_nsec))
-		return -EFAULT;
-
-	return 0;
-}
-
 static int nilfs_compat_ioctl_sync(struct inode *inode, struct file *filp,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -943,9 +853,6 @@ long nilfs_compat_ioctl(struct file *fil
 	case NILFS_IOCTL32_CLEAN_SEGMENTS:
 		return nilfs_compat_ioctl_clean_segments(
 			inode, filp, NILFS_IOCTL_CLEAN_SEGMENTS, arg);
-	case NILFS_IOCTL32_TIMEDWAIT:
-		return nilfs_compat_ioctl_timedwait(
-			inode, filp, NILFS_IOCTL_TIMEDWAIT, arg);
 	case NILFS_IOCTL_SYNC:
 		return nilfs_compat_ioctl_sync(inode, filp, cmd, arg);
 	default:
diff -puN fs/nilfs2/segment.c~nilfs2-remove-timedwait-ioctl-command fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-remove-timedwait-ioctl-command
+++ a/fs/nilfs2/segment.c
@@ -2114,11 +2114,8 @@ static void nilfs_segctor_complete_write
 		nilfs_drop_collected_inodes(&sci->sc_gc_inodes);
 		if (update_sr)
 			nilfs_commit_gcdat_inode(nilfs);
-	} else {
+	} else
 		nilfs->ns_nongc_ctime = sci->sc_seg_ctime;
-		set_nilfs_cond_nongc_write(nilfs);
-		wake_up(&nilfs->ns_cleanerd_wq);
-	}
 
 	sci->sc_nblk_inc += sci->sc_nblk_this_inc;
 
diff -puN fs/nilfs2/the_nilfs.c~nilfs2-remove-timedwait-ioctl-command fs/nilfs2/the_nilfs.c
--- a/fs/nilfs2/the_nilfs.c~nilfs2-remove-timedwait-ioctl-command
+++ a/fs/nilfs2/the_nilfs.c
@@ -73,7 +73,6 @@ struct the_nilfs *alloc_nilfs(struct blo
 	nilfs->ns_gc_inodes_h = NULL;
 	INIT_LIST_HEAD(&nilfs->ns_used_segments);
 	init_rwsem(&nilfs->ns_segctor_sem);
-	init_waitqueue_head(&nilfs->ns_cleanerd_wq);
 
 	return nilfs;
 }
diff -puN fs/nilfs2/the_nilfs.h~nilfs2-remove-timedwait-ioctl-command fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-remove-timedwait-ioctl-command
+++ a/fs/nilfs2/the_nilfs.h
@@ -37,7 +37,6 @@ enum {
 	THE_NILFS_LOADED,       /* Roll-back/roll-forward has done and
 				   the latest checkpoint was loaded */
 	THE_NILFS_DISCONTINUED,	/* 'next' pointer chain has broken */
-	THE_NILFS_COND_NONGC_WRITE,	/* Condition to wake up cleanerd */
 };
 
 /**
@@ -74,7 +73,6 @@ enum {
  * @ns_gc_dat: shadow inode of the DAT file inode for GC
  * @ns_gc_inodes: dummy inodes to keep live blocks
  * @ns_gc_inodes_h: hash list to keep dummy inode holding live blocks
- * @ns_cleanerd_wq: wait queue for cleanerd
  * @ns_blocksize_bits: bit length of block size
  * @ns_nsegments: number of segments in filesystem
  * @ns_blocks_per_segment: number of blocks per segment
@@ -151,9 +149,6 @@ struct the_nilfs {
 	struct list_head	ns_gc_inodes;
 	struct hlist_head      *ns_gc_inodes_h;
 
-	/* cleanerd */
-	wait_queue_head_t	ns_cleanerd_wq;
-
 	/* Disk layout information (static) */
 	unsigned int		ns_blocksize_bits;
 	unsigned long		ns_nsegments;
@@ -186,7 +181,6 @@ static inline int nilfs_##name(struct th
 THE_NILFS_FNS(INIT, init)
 THE_NILFS_FNS(LOADED, loaded)
 THE_NILFS_FNS(DISCONTINUED, discontinued)
-THE_NILFS_FNS(COND_NONGC_WRITE, cond_nongc_write)
 
 void nilfs_set_last_segment(struct the_nilfs *, sector_t, u64, __u64);
 struct the_nilfs *alloc_nilfs(struct block_device *);
diff -puN include/linux/nilfs2_fs.h~nilfs2-remove-timedwait-ioctl-command include/linux/nilfs2_fs.h
--- a/include/linux/nilfs2_fs.h~nilfs2-remove-timedwait-ioctl-command
+++ a/include/linux/nilfs2_fs.h
@@ -763,18 +763,6 @@ struct nilfs_bdesc {
 	__u32 bd_level;
 };
 
-#define	NILFS_TIMEDWAIT_WRITE_LOCKED	0x1
-#define	NILFS_TIMEDWAIT_SEG_WRITE	0x2
-
-/**
- * struct nilfs_wait_cond -
- */
-struct nilfs_wait_cond {
-	int wc_cond;
-	int wc_flags;
-	struct timespec wc_timeout;
-};
-
 #define NILFS_IOCTL_IDENT		'n'
 
 #define NILFS_IOCTL_CHANGE_CPMODE  \
@@ -795,8 +783,6 @@ struct nilfs_wait_cond {
 	_IOWR(NILFS_IOCTL_IDENT, 0x87, struct nilfs_argv)
 #define NILFS_IOCTL_CLEAN_SEGMENTS  \
 	_IOW(NILFS_IOCTL_IDENT, 0x88, struct nilfs_argv[5])
-#define NILFS_IOCTL_TIMEDWAIT  \
-	_IOWR(NILFS_IOCTL_IDENT, 0x89, struct nilfs_wait_cond)
 #define NILFS_IOCTL_SYNC  \
 	_IOR(NILFS_IOCTL_IDENT, 0x8A, __u64)
 #define NILFS_IOCTL_RESIZE  \
@@ -827,12 +813,6 @@ struct nilfs_sustat32 {
 	compat_time_t ss_nongc_ctime;
 };
 
-struct nilfs_wait_cond32 {
-	compat_int_t wc_cond;
-	compat_int_t wc_flags;
-	struct compat_timespec wc_timeout;
-};
-
 #define NILFS_IOCTL32_CHANGE_CPMODE  \
 	_IOW(NILFS_IOCTL_IDENT, 0x80, struct nilfs_cpmode32)
 #define NILFS_IOCTL32_GET_CPINFO  \
@@ -847,8 +827,6 @@ struct nilfs_wait_cond32 {
 	_IOWR(NILFS_IOCTL_IDENT, 0x87, struct nilfs_argv32)
 #define NILFS_IOCTL32_CLEAN_SEGMENTS  \
 	_IOW(NILFS_IOCTL_IDENT, 0x88, struct nilfs_argv32[5])
-#define NILFS_IOCTL32_TIMEDWAIT  \
-	_IOWR(NILFS_IOCTL_IDENT, 0x89, struct nilfs_wait_cond32)
 #endif	/* CONFIG_COMPAT */
 
 #endif	/* _LINUX_NILFS_FS_H */
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

