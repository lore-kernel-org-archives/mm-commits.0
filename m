From: akpm@linux-foundation.org
Subject: - w1-added-w1-reset-command.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:50:58 -0800
Message-ID: <200901082250.n08MowjL030103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763316AbZAHWvC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zbr@ioremap.net, paul.alfille@gmail.com, mm-commits@vger.kernel.org


The patch titled
     w1: added w1 reset command
has been removed from the -mm tree.  Its filename was
     w1-added-w1-reset-command.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
+	case W1_CMD_RESET:
+		err = w1_reset_bus(dev);
+		break;
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

origin.patch

