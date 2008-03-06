From: akpm@linux-foundation.org
Subject: - bluetooth-make-hci_sock_cleanup-return-void.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:21:47 -0800
Message-ID: <200803062221.m26MLlmB020744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344AbYCFWW2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:22:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tklauser@distanz.ch, hidave.darkstar@gmail.com, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     bluetooth: Make hci_sock_cleanup() return void
has been removed from the -mm tree.  Its filename was
     bluetooth-make-hci_sock_cleanup-return-void.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bluetooth: Make hci_sock_cleanup() return void
From: Tobias Klauser <tklauser@distanz.ch>

hci_sock_cleanup() always returns 0 and its return value isn't used
anywhere in the code.

Compile-tested with 'make allyesconfig && make net/bluetooth/bluetooth.ko'

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/bluetooth/bluetooth.h |    2 +-
 net/bluetooth/hci_sock.c          |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN include/net/bluetooth/bluetooth.h~bluetooth-make-hci_sock_cleanup-return-void include/net/bluetooth/bluetooth.h
--- a/include/net/bluetooth/bluetooth.h~bluetooth-make-hci_sock_cleanup-return-void
+++ a/include/net/bluetooth/bluetooth.h
@@ -170,7 +170,7 @@ static inline int skb_frags_no(struct sk
 int bt_err(__u16 code);
 
 extern int hci_sock_init(void);
-extern int hci_sock_cleanup(void);
+extern void hci_sock_cleanup(void);
 
 extern int bt_sysfs_init(void);
 extern void bt_sysfs_cleanup(void);
diff -puN net/bluetooth/hci_sock.c~bluetooth-make-hci_sock_cleanup-return-void net/bluetooth/hci_sock.c
--- a/net/bluetooth/hci_sock.c~bluetooth-make-hci_sock_cleanup-return-void
+++ a/net/bluetooth/hci_sock.c
@@ -734,7 +734,7 @@ error:
 	return err;
 }
 
-int __exit hci_sock_cleanup(void)
+void __exit hci_sock_cleanup(void)
 {
 	if (bt_sock_unregister(BTPROTO_HCI) < 0)
 		BT_ERR("HCI socket unregistration failed");
@@ -742,6 +742,4 @@ int __exit hci_sock_cleanup(void)
 	hci_unregister_notifier(&hci_sock_nblock);
 
 	proto_unregister(&hci_sk_proto);
