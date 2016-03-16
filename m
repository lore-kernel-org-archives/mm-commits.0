From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-a-tiny-race-that-leads-file-system-read-only.patch removed from
 -mm tree
Date: Wed, 16 Mar 2016 12:53:20 -0700
Message-ID: <56e9b9b0.mPpPEeHMCfS4BKW+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38385 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996AbcCPTxV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:53:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix a tiny race that leads file system read-only
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-a-tiny-race-that-leads-file-system-read-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiufei Xue <xuejiufei@huawei.com>
Subject: ocfs2: fix a tiny race that leads file system read-only

when o2hb detect a node down, it first set the dead node to recovery map
and create ocfs2rec which will replay journal for dead node.  o2hb thread
then call dlm_do_local_recovery_cleanup() to delete the lock for dead
node.  After the lock of dead node is gone, locks for other nodes can be
granted and may modify the meta data without replaying journal of the dead
node.  The detail is described as follows.

     N1                         N2                   N3(master)
modify the extent tree of
inode, and commit
dirty metadata to journal,
then goes down.
                                                 o2hb thread detects
                                                 N1 goes down, set
                                                 recovery map and
                                                 delete the lock of N1.

                                                 dlm_thread flush ast
                                                 for the lock of N2.
                        do not detect the death
                        of N1, so recovery map is
                        empty.

                        read inode from disk
                        without replaying
                        the journal of N1 and
                        modify the extent tree
                        of the inode that N1
                        had modified.
                                                 ocfs2rec recover the
                                                 journal of N1.
                                                 The modification of N2
                                                 is lost.

The modification of N1 and N2 are not serial, and it will lead to
read-only file system.  We can set recovery_waiting flag to the lock
resource after delete the lock for dead node to prevent other node from
getting the lock before dlm recovery.  After dlm recovery, the recovery
map on N2 is not empty, ocfs2_inode_lock_full_nested() will wait for ocfs2
recovery.

Signed-off-by: Jiufei Xue <xuejiufei@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmcommon.h   |    5 ++++-
 fs/ocfs2/dlm/dlmmaster.c   |    3 ++-
 fs/ocfs2/dlm/dlmrecovery.c |    8 ++++++++
 fs/ocfs2/dlm/dlmthread.c   |    6 ++++--
 4 files changed, 18 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/dlm/dlmcommon.h~ocfs2-fix-a-tiny-race-that-leads-file-system-read-only fs/ocfs2/dlm/dlmcommon.h
--- a/fs/ocfs2/dlm/dlmcommon.h~ocfs2-fix-a-tiny-race-that-leads-file-system-read-only
+++ a/fs/ocfs2/dlm/dlmcommon.h
@@ -282,6 +282,7 @@ static inline void __dlm_set_joining_nod
 #define DLM_LOCK_RES_DROPPING_REF         0x00000040
 #define DLM_LOCK_RES_BLOCK_DIRTY          0x00001000
 #define DLM_LOCK_RES_SETREF_INPROG        0x00002000
+#define DLM_LOCK_RES_RECOVERY_WAITING     0x00004000
 
 /* max milliseconds to wait to sync up a network failure with a node death */
 #define DLM_NODE_DEATH_WAIT_MAX (5 * 1000)
@@ -804,7 +805,8 @@ __dlm_lockres_state_to_status(struct dlm
 
 	assert_spin_locked(&res->spinlock);
 
-	if (res->state & DLM_LOCK_RES_RECOVERING)
+	if (res->state & (DLM_LOCK_RES_RECOVERING|
+			DLM_LOCK_RES_RECOVERY_WAITING))
 		status = DLM_RECOVERING;
 	else if (res->state & DLM_LOCK_RES_MIGRATING)
 		status = DLM_MIGRATING;
@@ -1026,6 +1028,7 @@ static inline void __dlm_wait_on_lockres
 {
 	__dlm_wait_on_lockres_flags(res, (DLM_LOCK_RES_IN_PROGRESS|
 				    	  DLM_LOCK_RES_RECOVERING|
+					  DLM_LOCK_RES_RECOVERY_WAITING|
 					  DLM_LOCK_RES_MIGRATING));
 }
 
diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-fix-a-tiny-race-that-leads-file-system-read-only fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-fix-a-tiny-race-that-leads-file-system-read-only
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2550,7 +2550,8 @@ static int dlm_is_lockres_migrateable(st
 		return 0;
 
 	/* delay migration when the lockres is in RECOCERING state */
-	if (res->state & DLM_LOCK_RES_RECOVERING)
+	if (res->state & (DLM_LOCK_RES_RECOVERING|
+			DLM_LOCK_RES_RECOVERY_WAITING))
 		return 0;
 
 	if (res->owner != dlm->node_num)
diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-fix-a-tiny-race-that-leads-file-system-read-only fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-fix-a-tiny-race-that-leads-file-system-read-only
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2175,6 +2175,13 @@ static void dlm_finish_local_lockres_rec
 	for (i = 0; i < DLM_HASH_BUCKETS; i++) {
 		bucket = dlm_lockres_hash(dlm, i);
 		hlist_for_each_entry(res, bucket, hash_node) {
+			if (res->state & DLM_LOCK_RES_RECOVERY_WAITING) {
+				spin_lock(&res->spinlock);
+				res->state &= ~DLM_LOCK_RES_RECOVERY_WAITING;
+				spin_unlock(&res->spinlock);
+				wake_up(&res->wq);
+			}
+
 			if (!(res->state & DLM_LOCK_RES_RECOVERING))
 				continue;
 
@@ -2312,6 +2319,7 @@ static void dlm_free_dead_locks(struct d
 			     res->lockname.len, res->lockname.name, freed, dead_node);
 			__dlm_print_one_lock_resource(res);
 		}
+		res->state |= DLM_LOCK_RES_RECOVERY_WAITING;
 		dlm_lockres_clear_refmap_bit(dlm, res, dead_node);
 	} else if (test_bit(dead_node, res->refmap)) {
 		mlog(0, "%s:%.*s: dead node %u had a ref, but had "
diff -puN fs/ocfs2/dlm/dlmthread.c~ocfs2-fix-a-tiny-race-that-leads-file-system-read-only fs/ocfs2/dlm/dlmthread.c
--- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-fix-a-tiny-race-that-leads-file-system-read-only
+++ a/fs/ocfs2/dlm/dlmthread.c
@@ -106,7 +106,8 @@ int __dlm_lockres_unused(struct dlm_lock
 	if (!list_empty(&res->dirty) || res->state & DLM_LOCK_RES_DIRTY)
 		return 0;
 
-	if (res->state & DLM_LOCK_RES_RECOVERING)
+	if (res->state & (DLM_LOCK_RES_RECOVERING|
+			DLM_LOCK_RES_RECOVERY_WAITING))
 		return 0;
 
 	/* Another node has this resource with this node as the master */
@@ -707,7 +708,8 @@ static int dlm_thread(void *data)
 			 * dirty for a short while. */
 			BUG_ON(res->state & DLM_LOCK_RES_MIGRATING);
 			if (res->state & (DLM_LOCK_RES_IN_PROGRESS |
-					  DLM_LOCK_RES_RECOVERING)) {
+					  DLM_LOCK_RES_RECOVERING |
+					  DLM_LOCK_RES_RECOVERY_WAITING)) {
 				/* move it to the tail and keep going */
 				res->state &= ~DLM_LOCK_RES_DIRTY;
 				spin_unlock(&res->spinlock);
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert.patch

