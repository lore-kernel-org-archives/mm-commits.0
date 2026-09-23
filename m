Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478BD317164
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 01:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790128297; cv=none; b=A5kkJDzTNt58Xm9ZFHHa8uacqd7CI+5tg2F6WyzMFQKfn0emsecPtD80v8ZpA+Ne7xotwei7xmrrKmbJcwoIhSY7nMrJSL3OIrXblLxmCjCirEv1ZdYicYmzvS2oqPly8Pns8p4uQUt5OUz8Pps4RgUttWWCOgc3cvfjVd/50TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790128297; c=relaxed/simple;
	bh=ZH4J5DSaSlF2WMTTf2BHeexbwNK5SCiFvw2LdkwJlcU=;
	h=Date:To:From:Subject:Message-Id; b=efSxvzKTfNTaqZRDoVXMoMswTZQAqm2yHz7NLW2NLQE2kizy+2dJF8Al01xgp/FfdRroRqKBwwCLV8ukbmLdlov0N9yRLhTu28qNGb30Kys2msmkH5vrouOgxNPl4Le3Kbcy14D27WOErCslCsWAUCVFmnKJKWt3YYhd50rJecs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AL63YkIG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AL63YkIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B161F000FF;
	Wed, 23 Sep 2026 01:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790128295;
	bh=A7qxGqBfQ/4Z18ZZkINc1BniYRB65dakyP5k/C1n6ZI=;
	h=Date:To:From:Subject;
	b=AL63YkIGPMFEMPaG9Ev/YpIosNde7bDE3zqk9wAtVf8j/HaRON4b4RICmf4/Klv04
	 AsCPkT8bq9ZsorM0AwDgllckFftspcT4zNcQx4v5N43+lyytg2gOLiexy1u/oHPoBb
	 bH06pDiwYXq7+r7FL8HaIdCFPa9n3kevs55Prtgw=
Date: Tue, 22 Sep 2026 18:51:35 -0700
To: mm-commits@vger.kernel.org,syzbot+a68ce48df87b8e36e915@syzkaller.appspotmail.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-possible-deadlock-between-nfs_sync_rwlock-and-fs_reclaim.patch added to mm-nonmm-unstable branch
Message-Id: <20260923015135.99B161F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix possible deadlock between nfs_sync_rwlock and fs_reclaim
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-possible-deadlock-between-nfs_sync_rwlock-and-fs_reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-possible-deadlock-between-nfs_sync_rwlock-and-fs_reclaim.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: fix possible deadlock between nfs_sync_rwlock and fs_reclaim
Date: Tue, 22 Sep 2026 17:34:37 +0800

syzbot detected a circular locking dependency on &osb->nfs_sync_rwlock:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]);
                               lock(fs_reclaim);
  rlock(&osb->nfs_sync_rwlock);

 *** DEADLOCK ***

Chain exists of:
  &osb->nfs_sync_rwlock --> &ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE] --> fs_reclaim

CPU0 is kswapd.  The dentry shrinker runs under fs_reclaim and reaches
ocfs2_delete_inode() through ->evict_inode():

kswapd
 balance_pgdat
  shrink_node
   shrink_slab
    super_cache_scan
     prune_dcache_sb
      shrink_dentry_list
       dentry_kill
        ocfs2_dentry_iput
         evict
          ocfs2_evict_inode
           ocfs2_delete_inode
            ocfs2_nfs_sync_lock
             down_read(&osb->nfs_sync_rwlock)      //C0: grabbing

CPU1 is a task deleting an inode.  It takes nfs_sync_rwlock first, then
the orphan dir and inode alloc system inode i_rwsems, and allocates the
metadata reservation with GFP_KERNEL while holding them:

evict
 ocfs2_evict_inode
  ocfs2_delete_inode
  + ocfs2_nfs_sync_lock
  |  down_read(&osb->nfs_sync_rwlock)              //C1: hold
  + ocfs2_wipe_inode
     + inode_lock(orphan_dir_inode)                //C1: hold
     + ocfs2_truncate_for_delete
     |  ocfs2_commit_truncate
     |   ocfs2_remove_btree_range
     |    ocfs2_reserve_blocks_for_rec_trunc
     |     ocfs2_reserve_new_metadata_blocks
     |      kzalloc_obj()                          //C1: grabbing
     |      // GFP_KERNEL -> might_alloc -> fs_reclaim_acquire
     + ocfs2_remove_inode
        inode_lock(inode_alloc_inode)

jbd2 pins allocations to GFP_NOFS for the lifetime of a transaction
handle, but these reservations are made before ocfs2_start_trans(), so
fs_reclaim is acquired with ocfs2 locks still held and the cycle closes.

The same cycle is reachable from ocfs2_get_dentry() and
ocfs2_get_parent(), which hold nfs_sync_rwlock for write across
ocfs2_test_inode_bit() and ocfs2_iget().

This is more than a lockdep artifact.  A GFP_KERNEL allocation under the
orphan dir i_rwsem enters direct reclaim, which runs the shrinkers, which
can evict another ocfs2 inode and re-enter ocfs2_wipe_inode() on the same
task; the second inode_lock() on the singleton orphan dir inode then
self-deadlocks, since i_rwsem is not recursive.

Establish a GFP_NOFS allocation context for the whole nfs_sync_rwlock
critical section so that nothing holding it can recurse into filesystem
reclaim.  Do it in ocfs2_nfs_sync_lock()/ocfs2_nfs_sync_unlock() rather
than at the call sites, so that future callers cannot forget it.

Link: https://lore.kernel.org/20260922093437.954127-1-joseph.qi@linux.alibaba.com
Fixes: 6ca497a83e59 ("ocfs2: fix rare stale inode errors when exporting via nfs")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: syzbot+a68ce48df87b8e36e915@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a68ce48df87b8e36e915
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Heming Zhao <heming.zhao@suse.com>
---

 fs/ocfs2/dlmglue.c |   29 +++++++++++++++++++++++++----
 fs/ocfs2/dlmglue.h |    5 +++--
 fs/ocfs2/export.c  |   10 ++++++----
 fs/ocfs2/inode.c   |    5 +++--
 4 files changed, 37 insertions(+), 12 deletions(-)

--- a/fs/ocfs2/dlmglue.c~ocfs2-fix-possible-deadlock-between-nfs_sync_rwlock-and-fs_reclaim
+++ a/fs/ocfs2/dlmglue.c
@@ -18,6 +18,7 @@
 #include <linux/time.h>
 #include <linux/delay.h>
 #include <linux/quotaops.h>
+#include <linux/sched/mm.h>
 #include <linux/sched/signal.h>
 #include <linux/string_choices.h>
 
@@ -2861,21 +2862,34 @@ void ocfs2_rename_unlock(struct ocfs2_su
 		ocfs2_cluster_unlock(osb, lockres, DLM_LOCK_EX);
 }
 
-int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex)
+int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex, unsigned int *nofs_flag)
 {
 	int status;
+	unsigned int flags;
 	struct ocfs2_lock_res *lockres = &osb->osb_nfs_sync_lockres;
 
 	if (ocfs2_is_hard_readonly(osb))
 		return -EROFS;
 
+	/*
+	 * ocfs2_delete_inode() takes this lock from ->evict_inode(), which the
+	 * dentry shrinker reaches while holding fs_reclaim.  Anything allocated
+	 * under the lock must therefore stay out of filesystem reclaim, or
+	 * reclaim recurses back into the shrinker and tries to take this lock
+	 * again.  Cover the whole critical section, including the cluster lock
+	 * and the sysfile inode locks the callers take below it.
+	 */
+	flags = memalloc_nofs_save();
+
 	if (ex)
 		down_write(&osb->nfs_sync_rwlock);
 	else
 		down_read(&osb->nfs_sync_rwlock);
 
-	if (ocfs2_mount_local(osb))
+	if (ocfs2_mount_local(osb)) {
+		*nofs_flag = flags;
 		return 0;
+	}
 
 	status = ocfs2_cluster_lock(osb, lockres, ex ? LKM_EXMODE : LKM_PRMODE,
 				    0, 0);
@@ -2886,12 +2900,17 @@ int ocfs2_nfs_sync_lock(struct ocfs2_sup
 			up_write(&osb->nfs_sync_rwlock);
 		else
 			up_read(&osb->nfs_sync_rwlock);
+		memalloc_nofs_restore(flags);
+		return status;
 	}
 
-	return status;
+	*nofs_flag = flags;
+
+	return 0;
 }
 
-void ocfs2_nfs_sync_unlock(struct ocfs2_super *osb, int ex)
+void ocfs2_nfs_sync_unlock(struct ocfs2_super *osb, int ex,
+			   unsigned int nofs_flag)
 {
 	struct ocfs2_lock_res *lockres = &osb->osb_nfs_sync_lockres;
 
@@ -2902,6 +2921,8 @@ void ocfs2_nfs_sync_unlock(struct ocfs2_
 		up_write(&osb->nfs_sync_rwlock);
 	else
 		up_read(&osb->nfs_sync_rwlock);
+
+	memalloc_nofs_restore(nofs_flag);
 }
 
 int ocfs2_trim_fs_lock(struct ocfs2_super *osb,
--- a/fs/ocfs2/dlmglue.h~ocfs2-fix-possible-deadlock-between-nfs_sync_rwlock-and-fs_reclaim
+++ a/fs/ocfs2/dlmglue.h
@@ -161,8 +161,9 @@ void ocfs2_orphan_scan_unlock(struct ocf
 
 int ocfs2_rename_lock(struct ocfs2_super *osb);
 void ocfs2_rename_unlock(struct ocfs2_super *osb);
-int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex);
-void ocfs2_nfs_sync_unlock(struct ocfs2_super *osb, int ex);
+int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex, unsigned int *nofs_flag);
+void ocfs2_nfs_sync_unlock(struct ocfs2_super *osb, int ex,
+			   unsigned int nofs_flag);
 void ocfs2_trim_fs_lock_res_init(struct ocfs2_super *osb);
 void ocfs2_trim_fs_lock_res_uninit(struct ocfs2_super *osb);
 int ocfs2_trim_fs_lock(struct ocfs2_super *osb,
--- a/fs/ocfs2/export.c~ocfs2-fix-possible-deadlock-between-nfs_sync_rwlock-and-fs_reclaim
+++ a/fs/ocfs2/export.c
@@ -37,6 +37,7 @@ static struct dentry *ocfs2_get_dentry(s
 	struct inode *inode;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 	u64 blkno = handle->ih_blkno;
+	unsigned int nofs_flag = 0;
 	int status, set;
 	struct dentry *result;
 
@@ -59,7 +60,7 @@ static struct dentry *ocfs2_get_dentry(s
 	 * This will synchronize us against ocfs2_delete_inode() on
 	 * all nodes
 	 */
-	status = ocfs2_nfs_sync_lock(osb, 1);
+	status = ocfs2_nfs_sync_lock(osb, 1, &nofs_flag);
 	if (status < 0) {
 		mlog(ML_ERROR, "getting nfs sync lock(EX) failed %d\n", status);
 		goto check_err;
@@ -90,7 +91,7 @@ static struct dentry *ocfs2_get_dentry(s
 	inode = ocfs2_iget(osb, blkno, 0, 0);
 
 unlock_nfs_sync:
-	ocfs2_nfs_sync_unlock(osb, 1);
+	ocfs2_nfs_sync_unlock(osb, 1, nofs_flag);
 
 check_err:
 	if (status < 0) {
@@ -133,12 +134,13 @@ static struct dentry *ocfs2_get_parent(s
 	u64 blkno;
 	struct dentry *parent;
 	struct inode *dir = d_inode(child);
+	unsigned int nofs_flag = 0;
 	int set;
 
 	trace_ocfs2_get_parent(child, child->d_name.len, child->d_name.name,
 			       (unsigned long long)OCFS2_I(dir)->ip_blkno);
 
-	status = ocfs2_nfs_sync_lock(OCFS2_SB(dir->i_sb), 1);
+	status = ocfs2_nfs_sync_lock(OCFS2_SB(dir->i_sb), 1, &nofs_flag);
 	if (status < 0) {
 		mlog(ML_ERROR, "getting nfs sync lock(EX) failed %d\n", status);
 		parent = ERR_PTR(status);
@@ -183,7 +185,7 @@ bail_unlock:
 	ocfs2_inode_unlock(dir, 0);
 
 unlock_nfs_sync:
-	ocfs2_nfs_sync_unlock(OCFS2_SB(dir->i_sb), 1);
+	ocfs2_nfs_sync_unlock(OCFS2_SB(dir->i_sb), 1, nofs_flag);
 
 bail:
 	trace_ocfs2_get_parent_end(parent);
--- a/fs/ocfs2/inode.c~ocfs2-fix-possible-deadlock-between-nfs_sync_rwlock-and-fs_reclaim
+++ a/fs/ocfs2/inode.c
@@ -1109,6 +1109,7 @@ static void ocfs2_delete_inode(struct in
 {
 	int wipe, status;
 	sigset_t oldset;
+	unsigned int nofs_flag = 0;
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_dinode *di = NULL;
 
@@ -1143,7 +1144,7 @@ static void ocfs2_delete_inode(struct in
 	 * shared mode so that all nodes can still concurrently
 	 * process deletes.
 	 */
-	status = ocfs2_nfs_sync_lock(OCFS2_SB(inode->i_sb), 0);
+	status = ocfs2_nfs_sync_lock(OCFS2_SB(inode->i_sb), 0, &nofs_flag);
 	if (status < 0) {
 		mlog(ML_ERROR, "getting nfs sync lock(PR) failed %d\n", status);
 		ocfs2_cleanup_delete_inode(inode, 0);
@@ -1215,7 +1216,7 @@ bail_unlock_inode:
 	brelse(di_bh);
 
 bail_unlock_nfs_sync:
-	ocfs2_nfs_sync_unlock(OCFS2_SB(inode->i_sb), 0);
+	ocfs2_nfs_sync_unlock(OCFS2_SB(inode->i_sb), 0, nofs_flag);
 
 bail_unblock:
 	ocfs2_unblock_signals(&oldset);
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-fix-deadlock-in-inline-data-truncate-transactions.patch
ocfs2-exit-recovery-thread-on-mount-error-path.patch
ocfs2-free-replay-slots-in-ocfs2_recovery_exit.patch
ocfs2-defer-suballocator-block-group-reclaim-to-workqueue.patch
ocfs2-restrict-ocfs2_invalid_slot-suballoc-slot-to-system-inodes.patch
ocfs2-validate-suballoc-bit-during-inode-read.patch
ocfs2-validate-suballoc-slot-and-bit-of-xattr-and-dir-index-blocks.patch
ocfs2-validate-suballoc-slot-and-bit-of-extent-and-refcount-blocks.patch
ocfs2-allow-xattr-bucket-entries-to-span-multiple-blocks.patch
ocfs2-reject-inconsistent-xattr-bucket-during-defrag.patch
ocfs2-skip-uninitialized-lockres-in-ocfs2_mark_lockres_freeing.patch
ocfs2-validate-dr_fs_generation-of-dir-index-root-blocks.patch
ocfs2-validate-dl_blkno-and-dl_fs_generation-of-dir-index-leaf-blocks.patch
ocfs2-restore-erange-check-in-ocfs2_xattr_tree_list_index_block.patch
ocfs2-fix-possible-deadlock-between-nfs_sync_rwlock-and-fs_reclaim.patch

