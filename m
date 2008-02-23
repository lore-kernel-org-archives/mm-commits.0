From: akpm@linux-foundation.org
Subject: + bluetooth-put-hci-dev-after-del-conn.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:29:59 -0800
Message-ID: <200802230730.m1N7Umag017960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751686AbYBWHx5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:53:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, marcel@holt


The patch titled
     bluetooth: put hci dev after del conn
has been added to the -mm tree.  Its filename is
     bluetooth-put-hci-dev-after-del-conn.patch

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
Subject: bluetooth: put hci dev after del conn
From: Dave Young <hidave.darkstar@gmail.com>

Move hci_dev_put to del_conn to avoid hci dev going away before hci conn.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Marcel Holtmann <marcel@holt
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/hci_conn.c  |    1 -
 net/bluetooth/hci_sysfs.c |    5 ++++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN net/bluetooth/hci_conn.c~bluetooth-put-hci-dev-after-del-conn net/bluetooth/hci_conn.c
--- a/net/bluetooth/hci_conn.c~bluetooth-put-hci-dev-after-del-conn
+++ a/net/bluetooth/hci_conn.c
@@ -260,7 +260,6 @@ int hci_conn_del(struct hci_conn *conn)
 	tasklet_enable(&hdev->tx_task);
 	skb_queue_purge(&conn->data_q);
 	hci_conn_del_sysfs(conn);
-	hci_dev_put(hdev);
 
 	return 0;
 }
diff -puN net/bluetooth/hci_sysfs.c~bluetooth-put-hci-dev-after-del-conn net/bluetooth/hci_sysfs.c
--- a/net/bluetooth/hci_sysfs.c~bluetooth-put-hci-dev-after-del-conn
+++ a/net/bluetooth/hci_sysfs.c
@@ -333,15 +333,18 @@ static int __match_tty(struct device *de
 
 static void del_conn(struct work_struct *work)
 {
-	struct device *dev;
 	struct hci_conn *conn = container_of(work, struct hci_conn, work);
+	struct hci_dev *hdev = conn->hdev;
+	struct device *dev;
 
 	while (dev = device_find_child(&conn->dev, NULL, __match_tty)) {
 		device_move(dev, NULL);
 		put_device(dev);
 	}
+
 	device_del(&conn->dev);
 	put_device(&conn->dev);
+	hci_dev_put(hdev);
 }
 
 void hci_conn_del_sysfs(struct hci_conn *conn)
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

bluetooth-put-hci-dev-after-del-conn.patch
bluetooth-do-not-move-child-device-other-than-rfcomm.patch
bluetooth-hci_core-defer-hci_unregister_sysfs.patch
bluetooth-conwise-technology-based-adapters-with-buggy-sco-support-bugzilla-9027.patch
