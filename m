From: akpm@linux-foundation.org
Subject: - bluetooth-put-hci-dev-after-del-conn.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:22:17 -0800
Message-ID: <200802232022.m1NKMHMg013410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760897AbYBWU2g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, marcel@holt, mm-commits@vger.kernel.org


The patch titled
     bluetooth: put hci dev after del conn
has been removed from the -mm tree.  Its filename was
     bluetooth-put-hci-dev-after-del-conn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
bluetooth-make-hci_sock_cleanup-return-void.patch
bluetooth-hci_core-defer-hci_unregister_sysfs.patch
bluetooth-conwise-technology-based-adapters-with-buggy-sco-support-bugzilla-9027.patch
