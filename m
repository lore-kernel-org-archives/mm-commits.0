From: akpm@linux-foundation.org
Subject: + w1-list-slaves-commands.patch added to -mm tree
Date: Mon, 08 Dec 2008 14:00:39 -0800
Message-ID: <200812082200.mB8M0dvi020968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbYLHWBN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 17:01:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zbr@ioremap.net


The patch titled
     w1: list slaves commands
has been added to the -mm tree.  Its filename is
     w1-list-slaves-commands.patch

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
Subject: w1: list slaves commands
From: Evgeniy Polyakov <zbr@ioremap.net>

Initiates search (or alarm search) and returns all found devices to
userspace.  Found devices are not added into the system (i.e.  they are
not attached to family devices or bus masters), it will be done via (if
was not done yet) usual timed searching.

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1_netlink.c |  102 +++++++++++++++++++++++++++++++-------
 1 file changed, 85 insertions(+), 17 deletions(-)

diff -puN drivers/w1/w1_netlink.c~w1-list-slaves-commands drivers/w1/w1_netlink.c
--- a/drivers/w1/w1_netlink.c~w1-list-slaves-commands
+++ a/drivers/w1/w1_netlink.c
@@ -47,19 +47,97 @@ void w1_netlink_send(struct w1_master *d
 	cn_netlink_send(m, 0, GFP_KERNEL);
 }
 
-static int w1_process_command_master(struct w1_master *dev, struct cn_msg *msg,
-		struct w1_netlink_msg *hdr, struct w1_netlink_cmd *cmd)
+static void w1_send_slave(struct w1_master *dev, u64 rn)
 {
-	dev_dbg(&dev->dev, "%s: %s: cmd=%02x, len=%u.\n",
-		__func__, dev->name, cmd->cmd, cmd->len);
+	struct cn_msg *msg = dev->priv;
+	struct w1_netlink_msg *hdr = (struct w1_netlink_msg *)(msg + 1);
+	struct w1_netlink_cmd *cmd = (struct w1_netlink_cmd *)(hdr + 1);
+	int avail;
+
+	avail = dev->priv_size - cmd->len;
+
+	if (avail > 8) {
+		u64 *data = (void *)(cmd + 1) + cmd->len;
+
+		*data = rn;
+		cmd->len += 8;
+		hdr->len += 8;
+		msg->len += 8;
+		return;
+	}
+
+	msg->ack++;
+	cn_netlink_send(msg, 0, GFP_KERNEL);
+
+	msg->len = sizeof(struct w1_netlink_msg) + sizeof(struct w1_netlink_cmd);
+	hdr->len = sizeof(struct w1_netlink_cmd);
+	cmd->len = 0;
+}
+
+static int w1_process_search_command(struct w1_master *dev, struct cn_msg *msg,
+		unsigned int avail)
+{
+	struct w1_netlink_msg *hdr = (struct w1_netlink_msg *)(msg + 1);
+	struct w1_netlink_cmd *cmd = (struct w1_netlink_cmd *)(hdr + 1);
+	int search_type = (cmd->cmd == W1_CMD_ALARM_SEARCH)?W1_ALARM_SEARCH:W1_SEARCH;
+
+	dev->priv = msg;
+	dev->priv_size = avail;
+
+	w1_search_devices(dev, search_type, w1_send_slave);
 
-	if (cmd->cmd != W1_CMD_SEARCH && cmd->cmd != W1_CMD_ALARM_SEARCH)
-		return -EINVAL;
+	msg->ack = 0;
+	cn_netlink_send(msg, 0, GFP_KERNEL);
+
+	dev->priv = NULL;
+	dev->priv_size = 0;
 
-	w1_search_process(dev, (cmd->cmd == W1_CMD_ALARM_SEARCH)?W1_ALARM_SEARCH:W1_SEARCH);
 	return 0;
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
 static int w1_send_read_reply(struct w1_slave *sl, struct cn_msg *msg,
 		struct w1_netlink_msg *hdr, struct w1_netlink_cmd *cmd)
 {
@@ -119,11 +197,6 @@ static int w1_process_command_slave(stru
 		case W1_CMD_WRITE:
 			w1_write_block(sl->master, cmd->data, cmd->len);
 			break;
-		case W1_CMD_SEARCH:
-		case W1_CMD_ALARM_SEARCH:
-			w1_search_process(sl->master,
-					(cmd->cmd == W1_CMD_ALARM_SEARCH)?W1_ALARM_SEARCH:W1_SEARCH);
-			break;
 		default:
 			err = -1;
 			break;
@@ -270,11 +343,6 @@ out_cont:
 		if (err == -ENODEV)
 			err = 0;
 	}
-#if 0
-	if (err) {
-		printk("%s: malformed message. Dropping.\n", __func__);
-	}
-#endif
 }
 
 int w1_init_netlink(void)
_

Patches currently in -mm which might be from zbr@ioremap.net are

mx2-add-w1-device-resources.patch
mx31-add-w1-platform_device-and-resources.patch
mx2-pcm038-add-1-wire-master-support.patch
pcm037-add-1wire-support.patch
w1-add-1-wire-master-driver-for-imx27-imx31.patch
w1-add-1-wire-master-driver-for-imx27-imx31-update.patch
w1-add-list-masters-w1-command.patch
w1-add-touch-block-command.patch
w1-list-slaves-commands.patch
w1-documentation-update.patch

