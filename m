From: akpm@linux-foundation.org
Subject: [patch 04/19] ocfs2: o2hb: add some user/debug log
Date: Fri, 27 May 2016 14:27:07 -0700
Message-ID: <5748bbab.+F4D7Abc84x4wgxb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684AbcE0V1I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 17:27:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, junxiao.bi@oracle.com, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, rwxybh@126.com, ryan.ding@oracle.com

From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: o2hb: add some user/debug log

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Gang He <ghe@suse.com>
Cc: rwxybh <rwxybh@126.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   39 +++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-add-some-user-debug-log fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-add-some-user-debug-log
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -292,6 +292,8 @@ struct o2hb_bio_wait_ctxt {
 	int               wc_error;
 };
 
+#define O2HB_NEGO_TIMEOUT_MS (O2HB_MAX_WRITE_TIMEOUT_MS/2)
+
 enum {
 	O2HB_NEGO_TIMEOUT_MSG = 1,
 	O2HB_NEGO_APPROVE_MSG = 2,
@@ -358,7 +360,7 @@ static void o2hb_arm_timeout(struct o2hb
 	cancel_delayed_work(&reg->hr_nego_timeout_work);
 	/* negotiate timeout must be less than write timeout. */
 	schedule_delayed_work(&reg->hr_nego_timeout_work,
-			      msecs_to_jiffies(O2HB_MAX_WRITE_TIMEOUT_MS)/2);
+			      msecs_to_jiffies(O2HB_NEGO_TIMEOUT_MS));
 	memset(reg->hr_nego_node_bitmap, 0, sizeof(reg->hr_nego_node_bitmap));
 }
 
@@ -389,7 +391,7 @@ again:
 static void o2hb_nego_timeout(struct work_struct *work)
 {
 	unsigned long live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
-	int master_node, i;
+	int master_node, i, ret;
 	struct o2hb_region *reg;
 
 	reg = container_of(work, struct o2hb_region, hr_nego_timeout_work.work);
@@ -398,7 +400,12 @@ static void o2hb_nego_timeout(struct wor
 	master_node = find_next_bit(live_node_bitmap, O2NM_MAX_NODES, 0);
 
 	if (master_node == o2nm_this_node()) {
-		set_bit(master_node, reg->hr_nego_node_bitmap);
+		if (!test_bit(master_node, reg->hr_nego_node_bitmap)) {
+			printk(KERN_NOTICE "o2hb: node %d hb write hung for %ds on region %s (%s).\n",
+				o2nm_this_node(), O2HB_NEGO_TIMEOUT_MS/1000,
+				config_item_name(&reg->hr_item), reg->hr_dev_name);
+			set_bit(master_node, reg->hr_nego_node_bitmap);
+		}
 		if (memcmp(reg->hr_nego_node_bitmap, live_node_bitmap,
 				sizeof(reg->hr_nego_node_bitmap))) {
 			/* check negotiate bitmap every second to do timeout
@@ -410,6 +417,8 @@ static void o2hb_nego_timeout(struct wor
 			return;
 		}
 
+		printk(KERN_NOTICE "o2hb: all nodes hb write hung, maybe region %s (%s) is down.\n",
+			config_item_name(&reg->hr_item), reg->hr_dev_name);
 		/* approve negotiate timeout request. */
 		o2hb_arm_timeout(reg);
 
@@ -419,13 +428,23 @@ static void o2hb_nego_timeout(struct wor
 			if (i == master_node)
 				continue;
 
-			o2hb_send_nego_msg(reg->hr_key,
+			mlog(ML_HEARTBEAT, "send NEGO_APPROVE msg to node %d\n", i);
+			ret = o2hb_send_nego_msg(reg->hr_key,
 					O2HB_NEGO_APPROVE_MSG, i);
+			if (ret)
+				mlog(ML_ERROR, "send NEGO_APPROVE msg to node %d fail %d\n",
+					i, ret);
 		}
 	} else {
 		/* negotiate timeout with master node. */
-		o2hb_send_nego_msg(reg->hr_key, O2HB_NEGO_TIMEOUT_MSG,
-			master_node);
+		printk(KERN_NOTICE "o2hb: node %d hb write hung for %ds on region %s (%s), negotiate timeout with node %d.\n",
+			o2nm_this_node(), O2HB_NEGO_TIMEOUT_MS/1000, config_item_name(&reg->hr_item),
+			reg->hr_dev_name, master_node);
+		ret = o2hb_send_nego_msg(reg->hr_key, O2HB_NEGO_TIMEOUT_MSG,
+				master_node);
+		if (ret)
+			mlog(ML_ERROR, "send NEGO_TIMEOUT msg to node %d fail %d\n",
+				master_node, ret);
 	}
 }
 
@@ -436,6 +455,8 @@ static int o2hb_nego_timeout_handler(str
 	struct o2hb_nego_msg *nego_msg;
 
 	nego_msg = (struct o2hb_nego_msg *)msg->buf;
+	printk(KERN_NOTICE "o2hb: receive negotiate timeout message from node %d on region %s (%s).\n",
+		nego_msg->node_num, config_item_name(&reg->hr_item), reg->hr_dev_name);
 	if (nego_msg->node_num < O2NM_MAX_NODES)
 		set_bit(nego_msg->node_num, reg->hr_nego_node_bitmap);
 	else
@@ -447,7 +468,11 @@ static int o2hb_nego_timeout_handler(str
 static int o2hb_nego_approve_handler(struct o2net_msg *msg, u32 len, void *data,
 				void **ret_data)
 {
-	o2hb_arm_timeout(data);
+	struct o2hb_region *reg = data;
+
+	printk(KERN_NOTICE "o2hb: negotiate timeout approved by master node on region %s (%s).\n",
+		config_item_name(&reg->hr_item), reg->hr_dev_name);
+	o2hb_arm_timeout(reg);
 	return 0;
 }
 
_
