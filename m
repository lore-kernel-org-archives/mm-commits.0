From: akpm@linux-foundation.org
Subject: - w1-allow-master-io-commands.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:50:54 -0800
Message-ID: <200901082250.n08Mosp5030039@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763213AbZAHWu6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:50:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zbr@ioremap.net, paul.alfille@gmail.com, mm-commits@vger.kernel.org


The patch titled
     w1: allow master IO commands
has been removed from the -mm tree.  Its filename was
     w1-allow-master-io-commands.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: reindent switch statements]
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Paul Alfille <paul.alfille@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1_netlink.c |  142 ++++++++++++++++++++------------------
 1 file changed, 77 insertions(+), 65 deletions(-)

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
 
@@ -176,35 +134,89 @@ static int w1_send_read_reply(struct w1_
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
+	switch (cmd->cmd) {
+	case W1_CMD_TOUCH:
+		w1_touch_block(dev, cmd->data, cmd->len);
+		w1_send_read_reply(msg, hdr, cmd);
+		break;
+	case W1_CMD_READ:
+		w1_read_block(dev, cmd->data, cmd->len);
+		w1_send_read_reply(msg, hdr, cmd);
+		break;
+	case W1_CMD_WRITE:
+		w1_write_block(dev, cmd->data, cmd->len);
+		break;
+	default:
+		err = -1;
+		break;
+	}
+
+	return err;
+}
+
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
 
 	switch (cmd->cmd) {
-		case W1_CMD_TOUCH:
-			w1_touch_block(sl->master, cmd->data, cmd->len);
-			w1_send_read_reply(sl, msg, hdr, cmd);
-			break;
-		case W1_CMD_READ:
-			w1_read_block(sl->master, cmd->data, cmd->len);
-			w1_send_read_reply(sl, msg, hdr, cmd);
-			break;
-		case W1_CMD_WRITE:
-			w1_write_block(sl->master, cmd->data, cmd->len);
-			break;
-		default:
-			err = -1;
-			break;
+	case W1_CMD_SEARCH:
+	case W1_CMD_ALARM_SEARCH:
+		err = w1_process_search_command(dev, msg,
+				PAGE_SIZE - msg->len - sizeof(struct cn_msg));
+		break;
+	case W1_CMD_READ:
+	case W1_CMD_WRITE:
+	case W1_CMD_TOUCH:
+		err = w1_process_command_io(dev, msg, hdr, cmd);
+		break;
+	default:
+		cmd->res = EINVAL;
+		cn_netlink_send(msg, 0, GFP_KERNEL);
+		break;
 	}
 
+	kfree(msg);
 	return err;
 }
 
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

origin.patch

