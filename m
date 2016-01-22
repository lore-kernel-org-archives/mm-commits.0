From: akpm@linux-foundation.org
Subject: + ocfs2-o2hb-add-some-user-debug-log.patch added to -mm tree
Date: Thu, 21 Jan 2016 16:01:48 -0800
Message-ID: <56a1716c.KM9Y/gon7lcHh6Yr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcAVABt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 19:01:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, rwxybh@126.com, ryan.ding@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: o2hb: add some user/debug log
has been added to the -mm tree.  Its filename is
     ocfs2-o2hb-add-some-user-debug-log.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-o2hb-add-some-user-debug-log.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-o2hb-add-some-user-debug-log.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: o2hb: add some user/debug log

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Ryan Ding <ryan.ding@oracle.com>
Cc: Gang He <ghe@suse.com>
Cc: rwxybh <rwxybh@126.com>
Cc: Mark Fasheh <mfasheh@suse.de>
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
@@ -359,7 +361,7 @@ static void o2hb_arm_timeout(struct o2hb
 	cancel_delayed_work(&reg->hr_nego_timeout_work);
 	/* negotiate timeout must be less than write timeout. */
 	schedule_delayed_work(&reg->hr_nego_timeout_work,
-			      msecs_to_jiffies(O2HB_MAX_WRITE_TIMEOUT_MS)/2);
+			      msecs_to_jiffies(O2HB_NEGO_TIMEOUT_MS));
 	memset(reg->hr_nego_node_bitmap, 0, sizeof(reg->hr_nego_node_bitmap));
 }
 
@@ -393,14 +395,19 @@ static void o2hb_nego_timeout(struct wor
 		container_of(work, struct o2hb_region,
 			     hr_nego_timeout_work.work);
 	unsigned long live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
-	int master_node, i;
+	int master_node, i, ret;
 
 	o2hb_fill_node_map(live_node_bitmap, sizeof(live_node_bitmap));
 	/* lowest node as master node to make negotiate decision. */
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
@@ -412,6 +419,8 @@ static void o2hb_nego_timeout(struct wor
 			return;
 		}
 
+		printk(KERN_NOTICE "o2hb: all nodes hb write hung, maybe region %s (%s) is down.\n",
+			config_item_name(&reg->hr_item), reg->hr_dev_name);
 		/* approve negotiate timeout request. */
 		o2hb_arm_timeout(reg);
 
@@ -421,13 +430,23 @@ static void o2hb_nego_timeout(struct wor
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
 
@@ -438,6 +457,8 @@ static int o2hb_nego_timeout_handler(str
 	struct o2hb_nego_msg *nego_msg;
 
 	nego_msg = (struct o2hb_nego_msg *)msg->buf;
+	printk(KERN_NOTICE "o2hb: receive negotiate timeout message from node %d on region %s (%s).\n",
+		nego_msg->node_num, config_item_name(&reg->hr_item), reg->hr_dev_name);
 	if (nego_msg->node_num < O2NM_MAX_NODES)
 		set_bit(nego_msg->node_num, reg->hr_nego_node_bitmap);
 	else
@@ -449,7 +470,11 @@ static int o2hb_nego_timeout_handler(str
 static int o2hb_nego_approve_handler(struct o2net_msg *msg, u32 len, void *data,
 				void **ret_data)
 {
-	o2hb_arm_timeout((struct o2hb_region *)data);
+	struct o2hb_region *reg = (struct o2hb_region *)data;
+
+	printk(KERN_NOTICE "o2hb: negotiate timeout approved by master node on region %s (%s).\n",
+		config_item_name(&reg->hr_item), reg->hr_dev_name);
+	o2hb_arm_timeout(reg);
 	return 0;
 }
 
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-o2hb-add-negotiate-timer.patch
ocfs2-o2hb-add-nego_timeout-message.patch
ocfs2-o2hb-add-negotiate_approve-message.patch
ocfs2-o2hb-add-some-user-debug-log.patch
ocfs2-o2hb-dont-negotiate-if-last-hb-fail.patch
ocfs2-o2hb-fix-hb-hung-time.patch

