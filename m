From: akpm@linux-foundation.org
Subject: [merged] sgi-xpc-ensure-flags-are-updated-before-bte_copy.patch removed from -mm tree
Date: Fri, 30 Jan 2009 11:13:34 -0800
Message-ID: <200901301913.n0UJDY0K026231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852AbZA3TOO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 14:14:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, dcn@sgi.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sgi-xpc: ensure flags are updated before bte_copy
has been removed from the -mm tree.  Its filename was
     sgi-xpc-ensure-flags-are-updated-before-bte_copy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xpc: ensure flags are updated before bte_copy
From: Robin Holt <holt@sgi.com>

The clearing of the msg->flags needs a barrier between it and the notify
of the channel threads that the messages are cleaned and ready for use.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Dean Nelson <dcn@sgi.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_sn2.c |    9 +++++----
 drivers/misc/sgi-xp/xpc_uv.c  |    2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xpc-ensure-flags-are-updated-before-bte_copy drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xpc-ensure-flags-are-updated-before-bte_copy
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -1836,6 +1836,7 @@ xpc_process_msg_chctl_flags_sn2(struct x
 		 */
 		xpc_clear_remote_msgqueue_flags_sn2(ch);
 
+		smp_wmb(); /* ensure flags have been cleared before bte_copy */
 		ch_sn2->w_remote_GP.put = ch_sn2->remote_GP.put;
 
 		dev_dbg(xpc_chan, "w_remote_GP.put changed to %ld, partid=%d, "
@@ -1934,7 +1935,7 @@ xpc_get_deliverable_payload_sn2(struct x
 			break;
 
 		get = ch_sn2->w_local_GP.get;
-		rmb();	/* guarantee that .get loads before .put */
+		smp_rmb();	/* guarantee that .get loads before .put */
 		if (get == ch_sn2->w_remote_GP.put)
 			break;
 
@@ -2053,7 +2054,7 @@ xpc_allocate_msg_sn2(struct xpc_channel 
 	while (1) {
 
 		put = ch_sn2->w_local_GP.put;
-		rmb();	/* guarantee that .put loads before .get */
+		smp_rmb();	/* guarantee that .put loads before .get */
 		if (put - ch_sn2->w_remote_GP.get < ch->local_nentries) {
 
 			/* There are available message entries. We need to try
@@ -2186,7 +2187,7 @@ xpc_send_payload_sn2(struct xpc_channel 
 	 * The preceding store of msg->flags must occur before the following
 	 * load of local_GP->put.
 	 */
-	mb();
+	smp_mb();
 
 	/* see if the message is next in line to be sent, if so send it */
 
@@ -2287,7 +2288,7 @@ xpc_received_payload_sn2(struct xpc_chan
 	 * The preceding store of msg->flags must occur before the following
 	 * load of local_GP->get.
 	 */
-	mb();
+	smp_mb();
 
 	/*
 	 * See if this message is next in line to be acknowledged as having
diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-xpc-ensure-flags-are-updated-before-bte_copy drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xpc-ensure-flags-are-updated-before-bte_copy
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -1423,7 +1423,7 @@ xpc_send_payload_uv(struct xpc_channel *
 		atomic_inc(&ch->n_to_notify);
 
 		msg_slot->key = key;
-		wmb(); /* a non-NULL func must hit memory after the key */
+		smp_wmb(); /* a non-NULL func must hit memory after the key */
 		msg_slot->func = func;
 
 		if (ch->flags & XPC_C_DISCONNECTING) {
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch
factor-out-ifdefs-from-kernel-spinlockc-to-lock_contended_flags.patch
allow-rwlocks-to-re-enable-interrupts.patch
ia64-implement-interrupt-enabling-rwlocks.patch

