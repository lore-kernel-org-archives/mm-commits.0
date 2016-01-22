From: akpm@linux-foundation.org
Subject: + ocfs2-o2hb-add-nego_timeout-message.patch added to -mm tree
Date: Thu, 21 Jan 2016 16:01:44 -0800
Message-ID: <56a17168.HwEbGzOLIJXAiVp1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcAVABp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 19:01:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, rwxybh@126.com, ryan.ding@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: o2hb: add NEGO_TIMEOUT message
has been added to the -mm tree.  Its filename is
     ocfs2-o2hb-add-nego_timeout-message.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-o2hb-add-nego_timeout-message.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-o2hb-add-nego_timeout-message.patch

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
Subject: ocfs2: o2hb: add NEGO_TIMEOUT message

This message is sent to master node when non-master nodes's negotiate
timer expired.  Master node records these nodes in a bitmap which is used
to do write timeout timer re-queue decision.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Ryan Ding <ryan.ding@oracle.com>
Cc: Gang He <ghe@suse.com>
Cc: rwxybh <rwxybh@126.com>
Cc: Mark Fasheh <mfasheh@suse.de>
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
@@ -356,6 +368,24 @@ static void o2hb_disarm_timeout(struct o
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
 	struct o2hb_region *reg =
@@ -384,8 +414,24 @@ static void o2hb_nego_timeout(struct wor
 		/* approve negotiate timeout request. */
 	} else {
 		/* negotiate timeout with master node. */
+		o2hb_send_nego_msg(reg->hr_key, O2HB_NEGO_TIMEOUT_MSG,
+			master_node);
 	}
+}
+
+static int o2hb_nego_timeout_handler(struct o2net_msg *msg, u32 len, void *data,
+				void **ret_data)
+{
+	struct o2hb_region *reg = (struct o2hb_region *)data;
+	struct o2hb_nego_msg *nego_msg;
 
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
 
@@ -2039,13 +2086,30 @@ static struct config_item *o2hb_heartbea
 
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
+		goto free_handler;
 	}
 
 	return &reg->hr_item;
+
+free_handler:
+	o2net_unregister_handler_list(&reg->hr_handler_list);
 free:
 	kfree(reg);
 	return ERR_PTR(ret);
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-o2hb-add-negotiate-timer.patch
ocfs2-o2hb-add-nego_timeout-message.patch
ocfs2-o2hb-add-negotiate_approve-message.patch
ocfs2-o2hb-add-some-user-debug-log.patch
ocfs2-o2hb-dont-negotiate-if-last-hb-fail.patch
ocfs2-o2hb-fix-hb-hung-time.patch

