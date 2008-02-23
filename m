From: akpm@linux-foundation.org
Subject: + bluetooth-do-not-move-child-device-other-than-rfcomm.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:30:02 -0800
Message-ID: <200802230730.m1N7UpKp017963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbYBWHx5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:53:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, marcel@holt


The patch titled
     bluetooth: do not move child device other than rfcomm
has been added to the -mm tree.  Its filename is
     bluetooth-do-not-move-child-device-other-than-rfcomm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

bluetooth-put-hci-dev-after-del-conn.patch
bluetooth-do-not-move-child-device-other-than-rfcomm.patch
bluetooth-hci_core-defer-hci_unregister_sysfs.patch
bluetooth-conwise-technology-based-adapters-with-buggy-sco-support-bugzilla-9027.patch
