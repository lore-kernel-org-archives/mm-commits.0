From: akpm@linux-foundation.org
Subject: - bluetooth-do-not-move-child-device-other-than-rfcomm.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:22:19 -0800
Message-ID: <200802232022.m1NKMJcn013413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759671AbYBWU2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, marcel@holt, mm-commits@vger.kernel.org


The patch titled
     bluetooth: do not move child device other than rfcomm
has been removed from the -mm tree.  Its filename was
     bluetooth-do-not-move-child-device-other-than-rfcomm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bluetooth: do not move child device other than rfcomm
From: Dave Young <hidave.darkstar@gmail.com>

hci conn child devices other than rfcomm tty should not be moved here.  This
is my lost, thanks for Barnaby's reporting and testing.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Marcel Holtmann <marcel@holt
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/hci_sysfs.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN net/bluetooth/hci_sysfs.c~bluetooth-do-not-move-child-device-other-than-rfcomm net/bluetooth/hci_sysfs.c
--- a/net/bluetooth/hci_sysfs.c~bluetooth-do-not-move-child-device-other-than-rfcomm
+++ a/net/bluetooth/hci_sysfs.c
@@ -320,15 +320,14 @@ void hci_conn_add_sysfs(struct hci_conn 
 	queue_work(btaddconn, &conn->work);
 }
 
+/*
+ * The rfcomm tty device will possibly retain even when conn
+ * is down, and sysfs doesn't support move zombie device,
+ * so we should move the device before conn device is destroyed.
+ */
 static int __match_tty(struct device *dev, void *data)
 {
-	/* The rfcomm tty device will possibly retain even when conn
-	 * is down, and sysfs doesn't support move zombie device,
-	 * so we should move the device before conn device is destroyed.
-	 * Due to the only child device of hci_conn dev is rfcomm
-	 * tty_dev, here just return 1
-	 */
-	return 1;
+	return !strncmp(dev->bus_id, "rfcomm", 6);
 }
 
 static void del_conn(struct work_struct *work)
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
bluetooth-make-hci_sock_cleanup-return-void.patch
bluetooth-hci_core-defer-hci_unregister_sysfs.patch
bluetooth-conwise-technology-based-adapters-with-buggy-sco-support-bugzilla-9027.patch
