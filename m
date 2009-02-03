From: akpm@linux-foundation.org
Subject: + bluetooth-config_debug_lock_alloc-ifdefs-remove.patch added to -mm tree
Date: Mon, 02 Feb 2009 16:41:54 -0800
Message-ID: <200902030041.n130fsgB001981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758366AbZBCAmL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 19:42:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, marcel@holtmann.org, mingo@elte.hu


The patch titled
     bluetooth: CONFIG_DEBUG_LOCK_ALLOC ifdefs remove
has been added to the -mm tree.  Its filename is
     bluetooth-config_debug_lock_alloc-ifdefs-remove.patch

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
Subject: bluetooth: CONFIG_DEBUG_LOCK_ALLOC ifdefs remove
From: Dave Young <hidave.darkstar@gmail.com>

Due to lockdep changes the CONFIG_DEBUG_LOCK_ALLOC ifdef is not needed
now, just remove it here.

The following commit fixed the !lockdep build warnings:

commit e8f6fbf62de37cbc2e179176ac7010d5f4396b67
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Nov 12 01:38:36 2008 +0000

    lockdep: include/linux/lockdep.h - fix warning in net/bluetooth/af_bluetooth.c

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/af_bluetooth.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN net/bluetooth/af_bluetooth.c~bluetooth-config_debug_lock_alloc-ifdefs-remove net/bluetooth/af_bluetooth.c
--- a/net/bluetooth/af_bluetooth.c~bluetooth-config_debug_lock_alloc-ifdefs-remove
+++ a/net/bluetooth/af_bluetooth.c
@@ -48,7 +48,6 @@
 static struct net_proto_family *bt_proto[BT_MAX_PROTO];
 static DEFINE_RWLOCK(bt_proto_lock);
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key bt_lock_key[BT_MAX_PROTO];
 static const char *bt_key_strings[BT_MAX_PROTO] = {
 	"sk_lock-AF_BLUETOOTH-BTPROTO_L2CAP",
@@ -86,11 +85,6 @@ static inline void bt_sock_reclassify_lo
 			bt_slock_key_strings[proto], &bt_slock_key[proto],
 				bt_key_strings[proto], &bt_lock_key[proto]);
 }
-#else
-static inline void bt_sock_reclassify_lock(struct socket *sock, int proto)
-{
-}
-#endif
 
 int bt_sock_register(int proto, struct net_proto_family *ops)
 {
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

bluetooth-bt3c-eliminate-a-sparse-warning.patch
bluetooth-config_debug_lock_alloc-ifdefs-remove.patch

