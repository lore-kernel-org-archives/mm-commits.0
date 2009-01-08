From: akpm@linux-foundation.org
Subject: - w1-move-w1-commands-from-defines-to-enum.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:50:56 -0800
Message-ID: <200901082250.n08MouvU030086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763330AbZAHWvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zbr@ioremap.net, paul.alfille@gmail.com, mm-commits@vger.kernel.org


The patch titled
     w1: move w1 commands from defines to enum
has been removed from the -mm tree.  Its filename was
     w1-move-w1-commands-from-defines-to-enum.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

