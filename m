From: akpm@linux-foundation.org
Subject: - bluetooth-make-bnep_sock_cleanup-return-void.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:21:51 -0800
Message-ID: <200803062221.m26MLp35020748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752596AbYCFWWg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:22:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tklauser@distanz.ch, hidave.darkstar@gmail.com, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     bluetooth: make bnep_sock_cleanup() return void
has been removed from the -mm tree.  Its filename was
     bluetooth-make-bnep_sock_cleanup-return-void.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
