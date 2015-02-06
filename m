From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-fix-deadlock-of-segment-constructor-over-i_sync-flag.patch removed
 from -mm tree
Date: Fri, 06 Feb 2015 14:02:38 -0800
Message-ID: <54d539fe./TSFByi2D8Gr3O6w%akpm__33046.5721701787$1423260166$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbbBFWCj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2015 17:02:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix deadlock of segment constructor over I_SYNC flag
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-deadlock-of-segment-constructor-over-i_sync-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: fix deadlock of segment constructor over I_SYNC flag

Nilfs2 eventually hangs in a stress test with fsstress program.  This
issue was caused by the following deadlock over I_SYNC flag between
nilfs_segctor_thread() and writeback_sb_inodes():

  nilfs_segctor_thread()
    nilfs_segctor_thread_construct()
      nilfs_segctor_unlock()
        nilfs_dispose_list()
          iput()
            iput_final()
              evict()
                inode_wait_for_writeback()  * wait for I_SYNC flag

  writeback_sb_inodes()
     * set I_SYNC flag on inode->i_state
    __writeback_single_inode()
      do_writepages()
        nilfs_writepages()
          nilfs_construct_dsync_segment()
            nilfs_segctor_sync()
               * wait for completion of segment constructor
    inode_sync_complete()
       * clear I_SYNC flag after __writeback_single_inode() completed

writeback_sb_inodes() calls do_writepages() for dirty inodes after setting
I_SYNC flag on inode->i_state.  do_writepages() calls nilfs_writepages(),
which can run segment constructor and wait for its completion.  On the
other hand, segment constructor calls iput(), which can call evict() and
wait for the I_SYNC flag on inode_wait_for_writeback().

Since segment constructor doesn't know when I_SYNC will be set, it cannot
know whether iput() will block or not unless inode->i_nlink has a non-zero
count.  We can prevent evict() from being called in iput() by implementing
sop->drop_inode(), but it's not preferable to leave inodes with i_nlink ==
0 for long periods because it even defers file truncation and inode
deallocation.  So, this instead resolves the deadlock by calling iput()
asynchronously with a workqueue for inodes with i_nlink == 0.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/nilfs.h   |    2 -
 fs/nilfs2/segment.c |   44 +++++++++++++++++++++++++++++++++++++-----
 fs/nilfs2/segment.h |    5 ++++
 3 files changed, 44 insertions(+), 7 deletions(-)

diff -puN fs/nilfs2/nilfs.h~nilfs2-fix-deadlock-of-segment-constructor-over-i_sync-flag fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~nilfs2-fix-deadlock-of-segment-constructor-over-i_sync-flag
+++ a/fs/nilfs2/nilfs.h
@@ -141,7 +141,6 @@ enum {
  * @ti_save: Backup of journal_info field of task_struct
  * @ti_flags: Flags
  * @ti_count: Nest level
- * @ti_garbage:	List of inode to be put when releasing semaphore
  */
 struct nilfs_transaction_info {
 	u32			ti_magic;
@@ -150,7 +149,6 @@ struct nilfs_transaction_info {
 				   one of other filesystems has a bug. */
 	unsigned short		ti_flags;
 	unsigned short		ti_count;
-	struct list_head	ti_garbage;
 };
 
 /* ti_magic */
diff -puN fs/nilfs2/segment.c~nilfs2-fix-deadlock-of-segment-constructor-over-i_sync-flag fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-fix-deadlock-of-segment-constructor-over-i_sync-flag
+++ a/fs/nilfs2/segment.c
@@ -305,7 +305,6 @@ static void nilfs_transaction_lock(struc
 	ti->ti_count = 0;
 	ti->ti_save = cur_ti;
 	ti->ti_magic = NILFS_TI_MAGIC;
-	INIT_LIST_HEAD(&ti->ti_garbage);
 	current->journal_info = ti;
 
 	for (;;) {
@@ -332,8 +331,6 @@ static void nilfs_transaction_unlock(str
 
 	up_write(&nilfs->ns_segctor_sem);
 	current->journal_info = ti->ti_save;
-	if (!list_empty(&ti->ti_garbage))
-		nilfs_dispose_list(nilfs, &ti->ti_garbage, 0);
 }
 
 static void *nilfs_segctor_map_segsum_entry(struct nilfs_sc_info *sci,
@@ -746,6 +743,15 @@ static void nilfs_dispose_list(struct th
 	}
 }
 
+static void nilfs_iput_work_func(struct work_struct *work)
+{
+	struct nilfs_sc_info *sci = container_of(work, struct nilfs_sc_info,
+						 sc_iput_work);
+	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
+
+	nilfs_dispose_list(nilfs, &sci->sc_iput_queue, 0);
+}
+
 static int nilfs_test_metadata_dirty(struct the_nilfs *nilfs,
 				     struct nilfs_root *root)
 {
@@ -1900,8 +1906,8 @@ static int nilfs_segctor_collect_dirty_f
 static void nilfs_segctor_drop_written_files(struct nilfs_sc_info *sci,
 					     struct the_nilfs *nilfs)
 {
-	struct nilfs_transaction_info *ti = current->journal_info;
 	struct nilfs_inode_info *ii, *n;
+	int defer_iput = false;
 
 	spin_lock(&nilfs->ns_inode_lock);
 	list_for_each_entry_safe(ii, n, &sci->sc_dirty_files, i_dirty) {
@@ -1912,9 +1918,24 @@ static void nilfs_segctor_drop_written_f
 		clear_bit(NILFS_I_BUSY, &ii->i_state);
 		brelse(ii->i_bh);
 		ii->i_bh = NULL;
-		list_move_tail(&ii->i_dirty, &ti->ti_garbage);
+		list_del_init(&ii->i_dirty);
+		if (!ii->vfs_inode.i_nlink) {
+			/*
+			 * Defer calling iput() to avoid a deadlock
+			 * over I_SYNC flag for inodes with i_nlink == 0
+			 */
+			list_add_tail(&ii->i_dirty, &sci->sc_iput_queue);
+			defer_iput = true;
+		} else {
+			spin_unlock(&nilfs->ns_inode_lock);
+			iput(&ii->vfs_inode);
+			spin_lock(&nilfs->ns_inode_lock);
+		}
 	}
 	spin_unlock(&nilfs->ns_inode_lock);
+
+	if (defer_iput)
+		schedule_work(&sci->sc_iput_work);
 }
 
 /*
@@ -2583,6 +2604,8 @@ static struct nilfs_sc_info *nilfs_segct
 	INIT_LIST_HEAD(&sci->sc_segbufs);
 	INIT_LIST_HEAD(&sci->sc_write_logs);
 	INIT_LIST_HEAD(&sci->sc_gc_inodes);
+	INIT_LIST_HEAD(&sci->sc_iput_queue);
+	INIT_WORK(&sci->sc_iput_work, nilfs_iput_work_func);
 	init_timer(&sci->sc_timer);
 
 	sci->sc_interval = HZ * NILFS_SC_DEFAULT_TIMEOUT;
@@ -2609,6 +2632,8 @@ static void nilfs_segctor_write_out(stru
 		ret = nilfs_segctor_construct(sci, SC_LSEG_SR);
 		nilfs_transaction_unlock(sci->sc_super);
 
+		flush_work(&sci->sc_iput_work);
+
 	} while (ret && retrycount-- > 0);
 }
 
@@ -2633,6 +2658,9 @@ static void nilfs_segctor_destroy(struct
 		|| sci->sc_seq_request != sci->sc_seq_done);
 	spin_unlock(&sci->sc_state_lock);
 
+	if (flush_work(&sci->sc_iput_work))
+		flag = true;
+
 	if (flag || !nilfs_segctor_confirm(sci))
 		nilfs_segctor_write_out(sci);
 
@@ -2642,6 +2670,12 @@ static void nilfs_segctor_destroy(struct
 		nilfs_dispose_list(nilfs, &sci->sc_dirty_files, 1);
 	}
 
+	if (!list_empty(&sci->sc_iput_queue)) {
+		nilfs_warning(sci->sc_super, __func__,
+			      "iput queue is not empty\n");
+		nilfs_dispose_list(nilfs, &sci->sc_iput_queue, 1);
+	}
+
 	WARN_ON(!list_empty(&sci->sc_segbufs));
 	WARN_ON(!list_empty(&sci->sc_write_logs));
 
diff -puN fs/nilfs2/segment.h~nilfs2-fix-deadlock-of-segment-constructor-over-i_sync-flag fs/nilfs2/segment.h
--- a/fs/nilfs2/segment.h~nilfs2-fix-deadlock-of-segment-constructor-over-i_sync-flag
+++ a/fs/nilfs2/segment.h
@@ -26,6 +26,7 @@
 #include <linux/types.h>
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
+#include <linux/workqueue.h>
 #include <linux/nilfs2_fs.h>
 #include "nilfs.h"
 
@@ -92,6 +93,8 @@ struct nilfs_segsum_pointer {
  * @sc_nblk_inc: Block count of current generation
  * @sc_dirty_files: List of files to be written
  * @sc_gc_inodes: List of GC inodes having blocks to be written
+ * @sc_iput_queue: list of inodes for which iput should be done
+ * @sc_iput_work: work struct to defer iput call
  * @sc_freesegs: array of segment numbers to be freed
  * @sc_nfreesegs: number of segments on @sc_freesegs
  * @sc_dsync_inode: inode whose data pages are written for a sync operation
@@ -135,6 +138,8 @@ struct nilfs_sc_info {
 
 	struct list_head	sc_dirty_files;
 	struct list_head	sc_gc_inodes;
+	struct list_head	sc_iput_queue;
+	struct work_struct	sc_iput_work;
 
 	__u64		       *sc_freesegs;
 	size_t			sc_nfreesegs;
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch
linux-next.patch

