From: akpm@linux-foundation.org
Subject: + bluetooth-make-hci_sock_cleanup-return-void.patch added to -mm tree
Date: Sat, 23 Feb 2008 11:22:05 -0800
Message-ID: <200802231922.m1NJM5SF011192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056AbYBWTWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 14:22:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tklauser@distanz.ch, hidave.darkstar@gmail.com, marcel@holtmann.org


The patch titled
     bluetooth: Make hci_sock_cleanup() return void
has been added to the -mm tree.  Its filename is
     bluetooth-make-hci_sock_cleanup-return-void.patch

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
-
-	return 0;
 }
_

Patches currently in -mm which might be from tklauser@distanz.ch are

bluetooth-make-hci_sock_cleanup-return-void.patch
