From: akpm@linux-foundation.org
Subject: [patch 02/19] ocfs2: o2hb: add NEGO_TIMEOUT message
Date: Fri, 27 May 2016 14:27:01 -0700
Message-ID: <5748bba5.6aQjEYOVWDNhjpKo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbcE0V1C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 17:27:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, junxiao.bi@oracle.com, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, rwxybh@126.com, ryan.ding@oracle.com

From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: o2hb: add NEGO_TIMEOUT message

This message is sent to master node when non-master nodes's negotiate
timer expired.  Master node records these nodes in a bitmap which is used
to do write timeout timer re-queue decision.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Gang He <ghe@suse.com>
Cc: rwxybh <rwxybh@126.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   66 ++++++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-add-nego_timeout-message fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-add-nego_timeout-message
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -280,6 +280,10 @@ struct o2hb_region {
 	 * being checked because we temporarily have to zero out the
 	 * crc field. */
 	struct o2hb_disk_heartbeat_block *hr_tmp_block;
+
+	/* Message key for negotiate timeout message. */
+	unsigned int		hr_key;
+	struct list_head	hr_handler_list;
 };
 
 struct o2hb_bio_wait_ctxt {
@@ -288,6 +292,14 @@ struct o2hb_bio_wait_ctxt {
 	int               wc_error;
 };
 
+enum {
+	O2HB_NEGO_TIMEOUT_MSG = 1,
+};
+
+struct o2hb_nego_msg {
+	u8 node_num;
+};
+
 static void o2hb_write_timeout(struct work_struct *work)
 {
 	int failed, quorum;
@@ -355,6 +367,24 @@ static void o2hb_disarm_timeout(struct o
 	cancel_delayed_work_sync(&reg->hr_nego_timeout_work);
 }
 
+static int o2hb_send_nego_msg(int key, int type, u8 target)
+{
+	struct o2hb_nego_msg msg;
+	int status, ret;
+
+	msg.node_num = o2nm_this_node();
+again:
+	ret = o2net_send_message(type, key, &msg, sizeof(msg),
+			target, &status);
+
+	if (ret == -EAGAIN || ret == -ENOMEM) {
+		msleep(100);
+		goto again;
+	}
+
+	return ret;
+}
+
 static void o2hb_nego_timeout(struct work_struct *work)
 {
 	unsigned long live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
@@ -382,8 +412,24 @@ static void o2hb_nego_timeout(struct wor
 		/* approve negotiate timeout request. */
 	} else {
 		/* negotiate timeout with master node. */
+		o2hb_send_nego_msg(reg->hr_key, O2HB_NEGO_TIMEOUT_MSG,
+			master_node);
 	}
+}
 
+static int o2hb_nego_timeout_handler(struct o2net_msg *msg, u32 len, void *data,
+				void **ret_data)
+{
+	struct o2hb_region *reg = data;
+	struct o2hb_nego_msg *nego_msg;
+
+	nego_msg = (struct o2hb_nego_msg *)msg->buf;
+	if (nego_msg->node_num < O2NM_MAX_NODES)
+		set_bit(nego_msg->node_num, reg->hr_nego_node_bitmap);
+	else
+		mlog(ML_ERROR, "got nego timeout message from bad node.\n");
+
+	return 0;
 }
 
 static inline void o2hb_bio_wait_init(struct o2hb_bio_wait_ctxt *wc)
@@ -1493,6 +1539,7 @@ static void o2hb_region_release(struct c
 	list_del(&reg->hr_all_item);
 	spin_unlock(&o2hb_live_lock);
 
+	o2net_unregister_handler_list(&reg->hr_handler_list);
 	kfree(reg);
 }
 
@@ -2038,13 +2085,30 @@ static struct config_item *o2hb_heartbea
 
 	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
 
+	/* this is the same way to generate msg key as dlm, for local heartbeat,
+	 * name is also the same, so make initial crc value different to avoid
+	 * message key conflict.
+	 */
+	reg->hr_key = crc32_le(reg->hr_region_num + O2NM_MAX_REGIONS,
+		name, strlen(name));
+	INIT_LIST_HEAD(&reg->hr_handler_list);
+	ret = o2net_register_handler(O2HB_NEGO_TIMEOUT_MSG, reg->hr_key,
+			sizeof(struct o2hb_nego_msg),
+			o2hb_nego_timeout_handler,
+			reg, NULL, &reg->hr_handler_list);
+	if (ret)
+		goto free;
+
 	ret = o2hb_debug_region_init(reg, o2hb_debug_dir);
 	if (ret) {
 		config_item_put(&reg->hr_item);
-		goto free;
+		goto unregister_handler;
 	}
 
 	return &reg->hr_item;
+
+unregister_handler:
+	o2net_unregister_handler_list(&reg->hr_handler_list);
 free:
 	kfree(reg);
 	return ERR_PTR(ret);
_
