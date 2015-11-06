From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-race-between-mount-and-delete-node-cluster.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:05:51 -0800
Message-ID: <563d081f.knyRFRgemvkpobv8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033242AbbKFUFv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:05:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix race between mount and delete node/cluster
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-race-between-mount-and-delete-node-cluster.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: fix race between mount and delete node/cluster

There is a race case between mount and delete node/cluster, which will
lead o2hb_thread to malfunctioning dead loop.

o2hb_thread
{
	o2nm_depend_this_node();
	<<<<<< race window, node may have already been deleted, and then
	       enter the loop, o2hb thread will be malfunctioning
	       because of no configured nodes found.
	while (!kthread_should_stop() &&
		!reg->hr_unclean_stop && !reg->hr_aborted_start) {
}

So check the return value of o2nm_depend_this_node() is needed.  If node
has been deleted, do not enter the loop and let mount fail.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-fix-race-between-mount-and-delete-node-cluster fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-fix-race-between-mount-and-delete-node-cluster
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -219,7 +219,8 @@ struct o2hb_region {
 	unsigned		hr_unclean_stop:1,
 				hr_aborted_start:1,
 				hr_item_pinned:1,
-				hr_item_dropped:1;
+				hr_item_dropped:1,
+				hr_node_deleted:1;
 
 	/* protected by the hr_callback_sem */
 	struct task_struct 	*hr_task;
@@ -1078,7 +1079,13 @@ static int o2hb_thread(void *data)
 	set_user_nice(current, MIN_NICE);
 
 	/* Pin node */
-	o2nm_depend_this_node();
+	ret = o2nm_depend_this_node();
+	if (ret) {
+		mlog(ML_ERROR, "Node has been deleted, ret = %d\n", ret);
+		reg->hr_node_deleted = 1;
+		wake_up(&o2hb_steady_queue);
+		return 0;
+	}
 
 	while (!kthread_should_stop() &&
 	       !reg->hr_unclean_stop && !reg->hr_aborted_start) {
@@ -1787,7 +1794,8 @@ static ssize_t o2hb_region_dev_write(str
 	spin_unlock(&o2hb_live_lock);
 
 	ret = wait_event_interruptible(o2hb_steady_queue,
-				atomic_read(&reg->hr_steady_iterations) == 0);
+				atomic_read(&reg->hr_steady_iterations) == 0 ||
+				reg->hr_node_deleted);
 	if (ret) {
 		atomic_set(&reg->hr_steady_iterations, 0);
 		reg->hr_aborted_start = 1;
@@ -1798,6 +1806,11 @@ static ssize_t o2hb_region_dev_write(str
 		goto out3;
 	}
 
+	if (reg->hr_node_deleted) {
+		ret = -EINVAL;
+		goto out3;
+	}
+
 	/* Ok, we were woken.  Make sure it wasn't by drop_item() */
 	spin_lock(&o2hb_live_lock);
 	hb_task = reg->hr_task;
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-dlm-fix-race-between-convert-and-recovery.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v3.patch
ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch

