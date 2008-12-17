From: akpm@linux-foundation.org
Subject: + w1-send-status-messages-after-command-processing.patch added to -mm tree
Date: Wed, 17 Dec 2008 14:24:04 -0800
Message-ID: <200812172224.mBHMO4St006844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbYLQWYi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 17:24:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zbr@ioremap.net, paul.alfille@gmail.com


The patch titled
     w1: send status messages after command processing
has been added to the -mm tree.  Its filename is
     w1-send-status-messages-after-command-processing.patch

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
Subject: w1: send status messages after command processing
From: Evgeniy Polyakov <zbr@ioremap.net>

Send completion status of the commands to the userspace.  Message and
protocol are described in the documentation.

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Paul Alfille <paul.alfille@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/w1/w1.netlink |   29 ++++++++++++++++++
 drivers/w1/w1_netlink.c     |   53 +++++++++++++++++++++++++++++-----
 drivers/w1/w1_netlink.h     |    2 -
 3 files changed, 76 insertions(+), 8 deletions(-)

diff -puN Documentation/w1/w1.netlink~w1-send-status-messages-after-command-processing Documentation/w1/w1.netlink
--- a/Documentation/w1/w1.netlink~w1-send-status-messages-after-command-processing
+++ a/Documentation/w1/w1.netlink
@@ -118,6 +118,35 @@ W1 reset command.
   	id is equal to the bus master id to use for searching]
   [w1_netlink_cmd cmd = W1_CMD_RESET]
 
+
+Command status replies.
+======================
+
+Each command (either root, master or slave with or without w1_netlink_cmd
+structure) will be 'acked' by the w1 core. Format of the reply is the same
+as request message except that length parameters do not account for data
+requested by the user, i.e. read/write/touch IO requests will not contain
+data, so w1_netlink_cmd.len will be 0, w1_netlink_msg.len will be size
+of the w1_netlink_cmd structure and cn_msg.len will be equal to the sum
+of the sizeof(struct w1_netlink_msg) and sizeof(struct w1_netlink_cmd).
+If reply is generated for master or root command (which do not have
+w1_netlink_cmd attached), reply will contain only cn_msg and w1_netlink_msg
+structires.
+
+w1_netlink_msg.status field will carry positive error value
+(EINVAL for example) or zero in case of success.
+
+All other fields in every structure will mirror the same parameters in the
+request message (except lengths as described above).
+
+Status reply is generated for every w1_netlink_cmd embedded in the
+w1_netlink_msg, if there are no w1_netlink_cmd structures,
+reply will be generated for the w1_netlink_msg.
+
+All w1_netlink_cmd command structures are handled in every w1_netlink_msg,
+even if there were errors, only length mismatch interrupts message processing.
+
+
 Operation steps in w1 core when new command is received.
 =======================================================
 
diff -puN drivers/w1/w1_netlink.c~w1-send-status-messages-after-command-processing drivers/w1/w1_netlink.c
--- a/drivers/w1/w1_netlink.c~w1-send-status-messages-after-command-processing
+++ a/drivers/w1/w1_netlink.c
@@ -152,7 +152,7 @@ static int w1_process_command_io(struct 
 			w1_write_block(dev, cmd->data, cmd->len);
 			break;
 		default:
-			err = -1;
+			err = -EINVAL;
 			break;
 	}
 
@@ -195,14 +195,13 @@ static int w1_process_command_master(str
 		case W1_CMD_READ:
 		case W1_CMD_WRITE:
 		case W1_CMD_TOUCH:
-			err = w1_process_command_io(dev, msg, hdr, cmd);
+			err = w1_process_command_io(dev, req_msg, req_hdr, req_cmd);
 			break;
 		case W1_CMD_RESET:
 			err = w1_reset_bus(dev);
 			break;
 		default:
-			cmd->res = EINVAL;
-			cn_netlink_send(msg, 0, GFP_KERNEL);
+			err = -EINVAL;
 			break;
 	}
 
@@ -246,7 +245,7 @@ static int w1_process_command_root(struc
 	w = (struct w1_netlink_msg *)(cn + 1);
 
 	w->type = W1_LIST_MASTERS;
-	w->reserved = 0;
+	w->status = 0;
 	w->len = 0;
 	id = (u32 *)(w + 1);
 
@@ -273,6 +272,40 @@ static int w1_process_command_root(struc
 	return 0;
 }
 
+static int w1_netlink_send_error(struct cn_msg *rcmsg, struct w1_netlink_msg *rmsg,
+		struct w1_netlink_cmd *rcmd, int error)
+{
+	struct cn_msg *cmsg;
+	struct w1_netlink_msg *msg;
+	struct w1_netlink_cmd *cmd;
+
+	cmsg = kzalloc(sizeof(*msg) + sizeof(*cmd) + sizeof(*cmsg), GFP_KERNEL);
+	if (!cmsg)
+		return -ENOMEM;
+
+	msg = (struct w1_netlink_msg *)(cmsg + 1);
+	cmd = (struct w1_netlink_cmd *)(msg + 1);
+
+	memcpy(cmsg, rcmsg, sizeof(*cmsg));
+	cmsg->len = sizeof(*msg);
+
+	memcpy(msg, rmsg, sizeof(*msg));
+	msg->len = 0;
+	msg->status = (short)-error;
+
+	if (rcmd) {
+		memcpy(cmd, rcmd, sizeof(*cmd));
+		cmd->len = 0;
+		msg->len += sizeof(*cmd);
+		cmsg->len += sizeof(*cmd);
+	}
+
+	error = cn_netlink_send(cmsg, 0, GFP_KERNEL);
+	kfree(cmsg);
+
+	return error;
+}
+
 static void w1_cn_callback(void *data)
 {
 	struct cn_msg *msg = data;
@@ -289,6 +322,7 @@ static void w1_cn_callback(void *data)
 
 		dev = NULL;
 		sl = NULL;
+		cmd = NULL;
 
 		memcpy(&id, m->id.id, sizeof(id));
 #if 0
@@ -336,9 +370,12 @@ static void w1_cn_callback(void *data)
 			}
 
 			if (sl)
-				w1_process_command_slave(sl, msg, m, cmd);
+				err = w1_process_command_slave(sl, msg, m, cmd);
 			else
-				w1_process_command_master(dev, msg, m, cmd);
+				err = w1_process_command_master(dev, msg, m, cmd);
+
+			w1_netlink_send_error(msg, m, cmd, err);
+			err = 0;
 
 			cmd_data += cmd->len + sizeof(struct w1_netlink_cmd);
 			mlen -= cmd->len + sizeof(struct w1_netlink_cmd);
@@ -349,6 +386,8 @@ out_up:
 			atomic_dec(&sl->refcnt);
 		mutex_unlock(&dev->mutex);
 out_cont:
+		if (!cmd || err)
+			w1_netlink_send_error(msg, m, cmd, err);
 		msg->len -= sizeof(struct w1_netlink_msg) + m->len;
 		m = (struct w1_netlink_msg *)(((u8 *)m) + sizeof(struct w1_netlink_msg) + m->len);
 
diff -puN drivers/w1/w1_netlink.h~w1-send-status-messages-after-command-processing drivers/w1/w1_netlink.h
--- a/drivers/w1/w1_netlink.h~w1-send-status-messages-after-command-processing
+++ a/drivers/w1/w1_netlink.h
@@ -40,7 +40,7 @@ enum w1_netlink_message_types {
 struct w1_netlink_msg
 {
 	__u8				type;
-	__u8				reserved;
+	__u8				status;
 	__u16				len;
 	union {
 		__u8			id[8];
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

