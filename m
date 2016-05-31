From: akpm@linux-foundation.org
Subject: [merged] ocfs2-o2hb-add-negotiate_approve-message.patch removed
 from -mm tree
Date: Tue, 31 May 2016 10:50:07 -0700
Message-ID: <574dcecf.oNMdal92NxE/nxYg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbcEaRuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 13:50:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, rwxybh@126.com, ryan.ding@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: o2hb: add NEGOTIATE_APPROVE message
has been removed from the -mm tree.  Its filename was
     ocfs2-o2hb-add-negotiate_approve-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: o2hb: add NEGOTIATE_APPROVE message

This message is used to re-queue write timeout timer and negotiate timer
when all nodes suffer a write hung to storage, this makes node not fence
self if storage down.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Gang He <ghe@suse.com>
Cc: rwxybh <rwxybh@126.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-add-negotiate_approve-message fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-add-negotiate_approve-message
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -294,6 +294,7 @@ struct o2hb_bio_wait_ctxt {
 
 enum {
 	O2HB_NEGO_TIMEOUT_MSG = 1,
+	O2HB_NEGO_APPROVE_MSG = 2,
 };
 
 struct o2hb_nego_msg {
@@ -388,7 +389,7 @@ again:
 static void o2hb_nego_timeout(struct work_struct *work)
 {
 	unsigned long live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
-	int master_node;
+	int master_node, i;
 	struct o2hb_region *reg;
 
 	reg = container_of(work, struct o2hb_region, hr_nego_timeout_work.work);
@@ -410,6 +411,17 @@ static void o2hb_nego_timeout(struct wor
 		}
 
 		/* approve negotiate timeout request. */
+		o2hb_arm_timeout(reg);
+
+		i = -1;
+		while ((i = find_next_bit(live_node_bitmap,
+				O2NM_MAX_NODES, i + 1)) < O2NM_MAX_NODES) {
+			if (i == master_node)
+				continue;
+
+			o2hb_send_nego_msg(reg->hr_key,
+					O2HB_NEGO_APPROVE_MSG, i);
+		}
 	} else {
 		/* negotiate timeout with master node. */
 		o2hb_send_nego_msg(reg->hr_key, O2HB_NEGO_TIMEOUT_MSG,
@@ -432,6 +444,13 @@ static int o2hb_nego_timeout_handler(str
 	return 0;
 }
 
+static int o2hb_nego_approve_handler(struct o2net_msg *msg, u32 len, void *data,
+				void **ret_data)
+{
+	o2hb_arm_timeout(data);
+	return 0;
+}
+
 static inline void o2hb_bio_wait_init(struct o2hb_bio_wait_ctxt *wc)
 {
 	atomic_set(&wc->wc_num_reqs, 1);
@@ -2099,6 +2118,13 @@ static struct config_item *o2hb_heartbea
 	if (ret)
 		goto free;
 
+	ret = o2net_register_handler(O2HB_NEGO_APPROVE_MSG, reg->hr_key,
+			sizeof(struct o2hb_nego_msg),
+			o2hb_nego_approve_handler,
+			reg, NULL, &reg->hr_handler_list);
+	if (ret)
+		goto unregister_handler;
+
 	ret = o2hb_debug_region_init(reg, o2hb_debug_dir);
 	if (ret) {
 		config_item_put(&reg->hr_item);
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are


