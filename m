From: akpm@linux-foundation.org
Subject: + bluetooth-make-bnep_sock_cleanup-return-void.patch added to -mm tree
Date: Sat, 23 Feb 2008 13:34:15 -0800
Message-ID: <200802232134.m1NLYFlm016039@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754276AbYBWVe2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 16:34:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tklauser@distanz.ch, hidave.darkstar@gmail.com, marcel@holtmann.org


The patch titled
     bluetooth: make bnep_sock_cleanup() return void
has been added to the -mm tree.  Its filename is
     bluetooth-make-bnep_sock_cleanup-return-void.patch

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
Subject: bluetooth: make bnep_sock_cleanup() return void
From: Tobias Klauser <tklauser@distanz.ch>

bnep_sock_cleanup() always returns 0 and its return value isn't used
anywhere in the code.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/bnep/bnep.h |    2 +-
 net/bluetooth/bnep/sock.c |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN net/bluetooth/bnep/bnep.h~bluetooth-make-bnep_sock_cleanup-return-void net/bluetooth/bnep/bnep.h
--- a/net/bluetooth/bnep/bnep.h~bluetooth-make-bnep_sock_cleanup-return-void
+++ a/net/bluetooth/bnep/bnep.h
@@ -174,7 +174,7 @@ struct bnep_session {
 
 void bnep_net_setup(struct net_device *dev);
 int bnep_sock_init(void);
-int bnep_sock_cleanup(void);
+void bnep_sock_cleanup(void);
 
 static inline int bnep_mc_hash(__u8 *addr)
 {
diff -puN net/bluetooth/bnep/sock.c~bluetooth-make-bnep_sock_cleanup-return-void net/bluetooth/bnep/sock.c
--- a/net/bluetooth/bnep/sock.c~bluetooth-make-bnep_sock_cleanup-return-void
+++ a/net/bluetooth/bnep/sock.c
@@ -257,12 +257,10 @@ error:
 	return err;
 }
 
-int __exit bnep_sock_cleanup(void)
+void __exit bnep_sock_cleanup(void)
 {
 	if (bt_sock_unregister(BTPROTO_BNEP) < 0)
 		BT_ERR("Can't unregister BNEP socket");
 
 	proto_unregister(&bnep_proto);
-
-	return 0;
 }
_

Patches currently in -mm which might be from tklauser@distanz.ch are

origin.patch
bluetooth-make-hci_sock_cleanup-return-void.patch
bluetooth-make-bnep_sock_cleanup-return-void.patch
