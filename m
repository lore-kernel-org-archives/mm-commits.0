From: akpm@linux-foundation.org
Subject: + w1-allow-master-io-commands.patch added to -mm tree
Date: Wed, 17 Dec 2008 14:23:57 -0800
Message-ID: <200812172223.mBHMNwxd006792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094AbYLQWYc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 17:24:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zbr@ioremap.net, paul.alfille@gmail.com


The patch titled
     w1: allow master IO commands
has been added to the -mm tree.  Its filename is
     w1-allow-master-io-commands.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: allow master IO commands
From: Evgeniy Polyakov <zbr@ioremap.net>

This small patchset extendes existing commands with reset, master IO and
status messages.  Reset is used to reset the bus for given master device,
master IO command allows to initiate IO against bus itself not selecting
slave device first, which can be used to probe the device for example. 
And status messages carry command completion status back to the userspace
(namely very useful to get -ENODEV from when requested device was not
found).

Great thanks to Paul Alfille of OWFS for testing and commands suggestions.


This patch:

Allow starting of IO not against already found slave devices, but against
the bus itself, which can be used for example to probe devices.

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Paul Alfille <paul.alfille@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1_netlink.c |  126 ++++++++++++++++++++------------------
 1 file changed, 69 insertions(+), 57 deletions(-)

diff -puN drivers/w1/w1_netlink.c~w1-allow-master-io-commands drivers/w1/w1_netlink.c
--- a/drivers/w1/w1_netlink.c~w1-allow-master-io-commands
+++ a/drivers/w1/w1_netlink.c
@@ -95,51 +95,8 @@ static int w1_process_search_command(str
 	return 0;
 }
 
-static int w1_process_command_master(struct w1_master *dev, struct cn_msg *req_msg,
-		struct w1_netlink_msg *req_hdr, struct w1_netlink_cmd *req_cmd)
-{
-	int err = -EINVAL;
-	struct cn_msg *msg;
-	struct w1_netlink_msg *hdr;
-	struct w1_netlink_cmd *cmd;
-
-	msg = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
-
-	msg->id = req_msg->id;
-	msg->seq = req_msg->seq;
-	msg->ack = 0;
-	msg->len = sizeof(struct w1_netlink_msg) + sizeof(struct w1_netlink_cmd);
-
-	hdr = (struct w1_netlink_msg *)(msg + 1);
-	cmd = (struct w1_netlink_cmd *)(hdr + 1);
-
-	hdr->type = W1_MASTER_CMD;
-	hdr->id = req_hdr->id;
-	hdr->len = sizeof(struct w1_netlink_cmd);
-
-	cmd->cmd = req_cmd->cmd;
-	cmd->len = 0;
-
-	switch (cmd->cmd) {
-		case W1_CMD_SEARCH:
-		case W1_CMD_ALARM_SEARCH:
-			err = w1_process_search_command(dev, msg,
-				PAGE_SIZE - msg->len - sizeof(struct cn_msg));
-			break;
-		default:
-			cmd->res = EINVAL;
-			cn_netlink_send(msg, 0, GFP_KERNEL);
-			break;
-	}
-
-	kfree(msg);
-	return err;
-}
-
-static int w1_send_read_reply(struct w1_slave *sl, struct cn_msg *msg,
-		struct w1_netlink_msg *hdr, struct w1_netlink_cmd *cmd)
+static int w1_send_read_reply(struct cn_msg *msg, struct w1_netlink_msg *hdr,
+		struct w1_netlink_cmd *cmd)
 {
 	void *data;
 	struct w1_netlink_msg *h;
@@ -163,7 +120,8 @@ static int w1_send_read_reply(struct w1_
 	memcpy(c, cmd, sizeof(struct w1_netlink_cmd));
 
 	cm->ack = msg->seq+1;
-	cm->len = sizeof(struct w1_netlink_msg) + sizeof(struct w1_netlink_cmd) + cmd->len;
+	cm->len = sizeof(struct w1_netlink_msg) +
+		sizeof(struct w1_netlink_cmd) + cmd->len;
 
 	h->len = sizeof(struct w1_netlink_cmd) + cmd->len;
 
@@ -176,26 +134,22 @@ static int w1_send_read_reply(struct w1_
 	return err;
 }
 
-static int w1_process_command_slave(struct w1_slave *sl, struct cn_msg *msg,
+static int w1_process_command_io(struct w1_master *dev, struct cn_msg *msg,
 		struct w1_netlink_msg *hdr, struct w1_netlink_cmd *cmd)
 {
 	int err = 0;
 
-	dev_dbg(&sl->master->dev, "%s: %02x.%012llx.%02x: cmd=%02x, len=%u.\n",
-		__func__, sl->reg_num.family, (unsigned long long)sl->reg_num.id, sl->reg_num.crc,
-		cmd->cmd, cmd->len);
-
 	switch (cmd->cmd) {
 		case W1_CMD_TOUCH:
-			w1_touch_block(sl->master, cmd->data, cmd->len);
-			w1_send_read_reply(sl, msg, hdr, cmd);
+			w1_touch_block(dev, cmd->data, cmd->len);
+			w1_send_read_reply(msg, hdr, cmd);
 			break;
 		case W1_CMD_READ:
-			w1_read_block(sl->master, cmd->data, cmd->len);
-			w1_send_read_reply(sl, msg, hdr, cmd);
+			w1_read_block(dev, cmd->data, cmd->len);
+			w1_send_read_reply(msg, hdr, cmd);
 			break;
 		case W1_CMD_WRITE:
-			w1_write_block(sl->master, cmd->data, cmd->len);
+			w1_write_block(dev, cmd->data, cmd->len);
 			break;
 		default:
 			err = -1;
@@ -205,6 +159,64 @@ static int w1_process_command_slave(stru
 	return err;
 }
 
+static int w1_process_command_master(struct w1_master *dev, struct cn_msg *req_msg,
+		struct w1_netlink_msg *req_hdr, struct w1_netlink_cmd *req_cmd)
+{
+	int err = -EINVAL;
+	struct cn_msg *msg;
+	struct w1_netlink_msg *hdr;
+	struct w1_netlink_cmd *cmd;
+
+	msg = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	msg->id = req_msg->id;
+	msg->seq = req_msg->seq;
+	msg->ack = 0;
+	msg->len = sizeof(struct w1_netlink_msg) + sizeof(struct w1_netlink_cmd);
+
+	hdr = (struct w1_netlink_msg *)(msg + 1);
+	cmd = (struct w1_netlink_cmd *)(hdr + 1);
+
+	hdr->type = W1_MASTER_CMD;
+	hdr->id = req_hdr->id;
+	hdr->len = sizeof(struct w1_netlink_cmd);
+
+	cmd->cmd = req_cmd->cmd;
+	cmd->len = 0;
+
+	switch (cmd->cmd) {
+		case W1_CMD_SEARCH:
+		case W1_CMD_ALARM_SEARCH:
+			err = w1_process_search_command(dev, msg,
+				PAGE_SIZE - msg->len - sizeof(struct cn_msg));
+			break;
+		case W1_CMD_READ:
+		case W1_CMD_WRITE:
+		case W1_CMD_TOUCH:
+			err = w1_process_command_io(dev, msg, hdr, cmd);
+			break;
+		default:
+			cmd->res = EINVAL;
+			cn_netlink_send(msg, 0, GFP_KERNEL);
+			break;
+	}
+
+	kfree(msg);
+	return err;
+}
+
+static int w1_process_command_slave(struct w1_slave *sl, struct cn_msg *msg,
+		struct w1_netlink_msg *hdr, struct w1_netlink_cmd *cmd)
+{
+	dev_dbg(&sl->master->dev, "%s: %02x.%012llx.%02x: cmd=%02x, len=%u.\n",
+		__func__, sl->reg_num.family, (unsigned long long)sl->reg_num.id,
+		sl->reg_num.crc, cmd->cmd, cmd->len);
+
+	return w1_process_command_io(sl->master, msg, hdr, cmd);
+}
+
 static int w1_process_command_root(struct cn_msg *msg, struct w1_netlink_msg *mcmd)
 {
 	struct w1_master *m;
@@ -214,7 +226,7 @@ static int w1_process_command_root(struc
 
 	if (mcmd->type != W1_LIST_MASTERS) {
 		printk(KERN_NOTICE "%s: msg: %x.%x, wrong type: %u, len: %u.\n",
-				__func__, msg->id.idx, msg->id.val, mcmd->type, mcmd->len);
+			__func__, msg->id.idx, msg->id.val, mcmd->type, mcmd->len);
 		return -EPROTO;
 	}
 
_

Patches currently in -mm which might be from zbr@ioremap.net are

linux-next.patch
w1-add-1-wire-master-driver-for-imx27-imx31.patch
w1-add-1-wire-master-driver-for-imx27-imx31-update.patch
w1-add-list-masters-w1-command.patch
w1-add-touch-block-command.patch
w1-list-slaves-commands.patch
w1-documentation-update.patch
w1-allow-master-io-commands.patch
w1-move-w1-commands-from-defines-to-enum.patch
w1-added-w1-reset-command.patch
w1-send-status-messages-after-command-processing.patch

