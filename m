From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-cluster-replace-the-interrupt-safe-spinlocks-with-common-ones.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:52:59 -0700
Message-ID: <56e9b99b.ODogTZWad/aY5Io6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38349 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbcCPTxA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:53:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangyiwen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/cluster: replace the interrupt safe spinlocks with common ones
has been removed from the -mm tree.  Its filename was
     ocfs2-cluster-replace-the-interrupt-safe-spinlocks-with-common-ones.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2/cluster: replace the interrupt safe spinlocks with common ones

There actually no hardware or software interrupts in the context
which using o2hb_live_lock, so we don't need to worry about race
conditions caused by irq/softirq with spinlock held. Turning off
irq is not good for system performance after all. Just replace
them with a non interrupt safe function.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-cluster-replace-the-interrupt-safe-spinlocks-with-common-ones fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-cluster-replace-the-interrupt-safe-spinlocks-with-common-ones
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -287,7 +287,6 @@ struct o2hb_bio_wait_ctxt {
 static void o2hb_write_timeout(struct work_struct *work)
 {
 	int failed, quorum;
-	unsigned long flags;
 	struct o2hb_region *reg =
 		container_of(work, struct o2hb_region,
 			     hr_write_timeout_work.work);
@@ -297,14 +296,14 @@ static void o2hb_write_timeout(struct wo
 	     jiffies_to_msecs(jiffies - reg->hr_last_timeout_start));
 
 	if (o2hb_global_heartbeat_active()) {
-		spin_lock_irqsave(&o2hb_live_lock, flags);
+		spin_lock(&o2hb_live_lock);
 		if (test_bit(reg->hr_region_num, o2hb_quorum_region_bitmap))
 			set_bit(reg->hr_region_num, o2hb_failed_region_bitmap);
 		failed = bitmap_weight(o2hb_failed_region_bitmap,
 					O2NM_MAX_REGIONS);
 		quorum = bitmap_weight(o2hb_quorum_region_bitmap,
 					O2NM_MAX_REGIONS);
-		spin_unlock_irqrestore(&o2hb_live_lock, flags);
+		spin_unlock(&o2hb_live_lock);
 
 		mlog(ML_HEARTBEAT, "Number of regions %d, failed regions %d\n",
 		     quorum, failed);
@@ -2425,11 +2424,10 @@ EXPORT_SYMBOL_GPL(o2hb_check_node_heartb
 int o2hb_check_node_heartbeating_no_sem(u8 node_num)
 {
 	unsigned long testing_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
-	unsigned long flags;
 
-	spin_lock_irqsave(&o2hb_live_lock, flags);
+	spin_lock(&o2hb_live_lock);
 	o2hb_fill_node_map_from_callback(testing_map, sizeof(testing_map));
-	spin_unlock_irqrestore(&o2hb_live_lock, flags);
+	spin_unlock(&o2hb_live_lock);
 	if (!test_bit(node_num, testing_map)) {
 		mlog(ML_HEARTBEAT,
 		     "node (%u) does not have heartbeating enabled.\n",
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local.patch
ocfs2-solve-a-problem-of-crossing-the-boundary-in-updating-backups.patch

