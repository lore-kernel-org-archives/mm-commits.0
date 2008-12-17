From: akpm@linux-foundation.org
Subject: + w1-added-w1-reset-command.patch added to -mm tree
Date: Wed, 17 Dec 2008 14:24:02 -0800
Message-ID: <200812172224.mBHMO2QK006841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080AbYLQWYf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 17:24:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zbr@ioremap.net, paul.alfille@gmail.com


The patch titled
     w1: added w1 reset command
has been added to the -mm tree.  Its filename is
     w1-added-w1-reset-command.patch

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
Subject: w1: added w1 reset command
From: Evgeniy Polyakov <zbr@ioremap.net>

Command which allows to reset the bus.

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Paul Alfille <paul.alfille@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/w1/w1.netlink |    6 ++++++
 drivers/w1/w1_netlink.c     |    3 +++
 drivers/w1/w1_netlink.h     |    1 +
 3 files changed, 10 insertions(+)

diff -puN Documentation/w1/w1.netlink~w1-added-w1-reset-command Documentation/w1/w1.netlink
--- a/Documentation/w1/w1.netlink~w1-added-w1-reset-command
+++ a/Documentation/w1/w1.netlink
@@ -112,6 +112,12 @@ cn_msg->len = sizeof(struct w1_netlink_m
 	      sizeof(struct w1_netlink_cmd) +
 	      N*8;
 
+W1 reset command.
+[cn_msg]
+  [w1_netlink_msg type = W1_MASTER_CMD
+  	id is equal to the bus master id to use for searching]
+  [w1_netlink_cmd cmd = W1_CMD_RESET]
+
 Operation steps in w1 core when new command is received.
 =======================================================
 
diff -puN drivers/w1/w1_netlink.c~w1-added-w1-reset-command drivers/w1/w1_netlink.c
--- a/drivers/w1/w1_netlink.c~w1-added-w1-reset-command
+++ a/drivers/w1/w1_netlink.c
@@ -197,6 +197,9 @@ static int w1_process_command_master(str
 		case W1_CMD_TOUCH:
 			err = w1_process_command_io(dev, msg, hdr, cmd);
 			break;
+		case W1_CMD_RESET:
+			err = w1_reset_bus(dev);
+			break;
 		default:
 			cmd->res = EINVAL;
 			cn_netlink_send(msg, 0, GFP_KERNEL);
diff -puN drivers/w1/w1_netlink.h~w1-added-w1-reset-command drivers/w1/w1_netlink.h
--- a/drivers/w1/w1_netlink.h~w1-added-w1-reset-command
+++ a/drivers/w1/w1_netlink.h
@@ -58,6 +58,7 @@ enum w1_commands {
 	W1_CMD_SEARCH,
 	W1_CMD_ALARM_SEARCH,
 	W1_CMD_TOUCH,
+	W1_CMD_RESET,
 	W1_CMD_MAX,
 };
 
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

