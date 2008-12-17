From: akpm@linux-foundation.org
Subject: + w1-move-w1-commands-from-defines-to-enum.patch added to -mm tree
Date: Wed, 17 Dec 2008 14:24:00 -0800
Message-ID: <200812172224.mBHMO0Se006821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232AbYLQWYc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 17:24:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zbr@ioremap.net, paul.alfille@gmail.com


The patch titled
     w1: move w1 commands from defines to enum
has been added to the -mm tree.  Its filename is
     w1-move-w1-commands-from-defines-to-enum.patch

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
Subject: w1: move w1 commands from defines to enum
From: Evgeniy Polyakov <zbr@ioremap.net>

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Paul Alfille <paul.alfille@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1_netlink.h |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/w1/w1_netlink.h~w1-move-w1-commands-from-defines-to-enum drivers/w1/w1_netlink.h
--- a/drivers/w1/w1_netlink.h~w1-move-w1-commands-from-defines-to-enum
+++ a/drivers/w1/w1_netlink.h
@@ -52,11 +52,14 @@ struct w1_netlink_msg
 	__u8				data[0];
 };
 
-#define W1_CMD_READ		0x0
-#define W1_CMD_WRITE		0x1
-#define W1_CMD_SEARCH		0x2
-#define W1_CMD_ALARM_SEARCH	0x3
-#define W1_CMD_TOUCH		0x4
+enum w1_commands {
+	W1_CMD_READ = 0,
+	W1_CMD_WRITE,
+	W1_CMD_SEARCH,
+	W1_CMD_ALARM_SEARCH,
+	W1_CMD_TOUCH,
+	W1_CMD_MAX,
+};
 
 struct w1_netlink_cmd
 {
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

