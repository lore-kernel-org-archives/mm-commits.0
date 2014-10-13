From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-deadlock-between-o2hb-thread-and-o2net_wq.patch removed from -mm
 tree
Date: Mon, 13 Oct 2014 11:17:49 -0700
Message-ID: <543c174d.7AvxvR5/V9pSX+uq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaJMSRt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:17:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jiangyiwen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix deadlock between o2hb thread and o2net_wq
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-deadlock-between-o2hb-thread-and-o2net_wq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: fix deadlock between o2hb thread and o2net_wq

The following case may lead to o2net_wq and o2hb thread deadlock on
o2hb_callback_sem.
Currently there are 2 nodes say N1, N2 in the cluster. And N2 down, at
the same time, N3 tries to join the cluster. So N1 will handle node
down (N2) and join (N3) simultaneously.
    o2hb                               o2net_wq
    ->o2hb_do_disk_heartbeat
    ->o2hb_check_slot
    ->o2hb_run_event_list
    ->o2hb_fire_callbacks
    ->down_write(&o2hb_callback_sem)
    ->o2net_hb_node_down_cb
    ->flush_workqueue(o2net_wq)
                                       ->o2net_process_message
                                       ->dlm_query_join_handler
                                       ->o2hb_check_node_heartbeating
                                       ->o2hb_fill_node_map
                                       ->down_read(&o2hb_callback_sem)

No need to take o2hb_callback_sem in dlm_query_join_handler,
o2hb_live_lock is enough to protect live node map.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: xMark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: jiangyiwen <jiangyiwen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   19 +++++++++++++++++++
 fs/ocfs2/cluster/heartbeat.h |    1 +
 fs/ocfs2/dlm/dlmdomain.c     |    2 +-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-fix-deadlock-between-o2hb-thread-and-o2net_wq fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-fix-deadlock-between-o2hb-thread-and-o2net_wq
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -2572,6 +2572,25 @@ int o2hb_check_node_heartbeating(u8 node
 }
 EXPORT_SYMBOL_GPL(o2hb_check_node_heartbeating);
 
+int o2hb_check_node_heartbeating_no_sem(u8 node_num)
+{
+	unsigned long testing_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
+	unsigned long flags;
+
+	spin_lock_irqsave(&o2hb_live_lock, flags);
+	o2hb_fill_node_map_from_callback(testing_map, sizeof(testing_map));
+	spin_unlock_irqrestore(&o2hb_live_lock, flags);
+	if (!test_bit(node_num, testing_map)) {
+		mlog(ML_HEARTBEAT,
+		     "node (%u) does not have heartbeating enabled.\n",
+		     node_num);
+		return 0;
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(o2hb_check_node_heartbeating_no_sem);
+
 int o2hb_check_node_heartbeating_from_callback(u8 node_num)
 {
 	unsigned long testing_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
diff -puN fs/ocfs2/cluster/heartbeat.h~ocfs2-fix-deadlock-between-o2hb-thread-and-o2net_wq fs/ocfs2/cluster/heartbeat.h
--- a/fs/ocfs2/cluster/heartbeat.h~ocfs2-fix-deadlock-between-o2hb-thread-and-o2net_wq
+++ a/fs/ocfs2/cluster/heartbeat.h
@@ -80,6 +80,7 @@ void o2hb_fill_node_map(unsigned long *m
 void o2hb_exit(void);
 int o2hb_init(void);
 int o2hb_check_node_heartbeating(u8 node_num);
+int o2hb_check_node_heartbeating_no_sem(u8 node_num);
 int o2hb_check_node_heartbeating_from_callback(u8 node_num);
 int o2hb_check_local_node_heartbeating(void);
 void o2hb_stop_all_regions(void);
diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-fix-deadlock-between-o2hb-thread-and-o2net_wq fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-fix-deadlock-between-o2hb-thread-and-o2net_wq
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -839,7 +839,7 @@ static int dlm_query_join_handler(struct
 	 * to back off and try again.  This gives heartbeat a chance
 	 * to catch up.
 	 */
-	if (!o2hb_check_node_heartbeating(query->node_idx)) {
+	if (!o2hb_check_node_heartbeating_no_sem(query->node_idx)) {
 		mlog(0, "node %u is not in our live map yet\n",
 		     query->node_idx);
 
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker.patch

