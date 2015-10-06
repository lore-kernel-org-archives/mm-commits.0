From: akpm@linux-foundation.org
Subject: + ocfs2-fix-race-between-mount-and-delete-node-cluster.patch
 added to -mm tree
Date: Tue, 06 Oct 2015 12:54:14 -0700
Message-ID: <561426e6.JoJJ+25kvlMrEqI3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbbJFTyP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2015 15:54:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix race between mount and delete node/cluster
has been added to the -mm tree.  Its filename is
     ocfs2-fix-race-between-mount-and-delete-node-cluster.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-race-between-mount-and-delete-node-cluster.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-race-between-mount-and-delete-node-cluster.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-improve-performance-for-localalloc.patch
ocfs2-do-not-include-dio-entry-in-case-of-orphan-scan.patch
ocfs2-only-take-lock-if-dio-entry-when-recover-orphans.patch
ocfs2-fix-race-between-mount-and-delete-node-cluster.patch
ocfs2-dlm-fix-race-between-convert-and-recovery.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v3.patch
ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch

