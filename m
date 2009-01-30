From: akpm@linux-foundation.org
Subject: [merged] sgi-xpc-fixup-stale-dbug_on-statements.patch removed from -mm tree
Date: Fri, 30 Jan 2009 11:13:38 -0800
Message-ID: <200901301913.n0UJDcOQ026353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470AbZA3TOL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 14:14:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, dcn@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-xpc: fix up stale DBUG_ON statements
has been removed from the -mm tree.  Its filename was
     sgi-xpc-fixup-stale-dbug_on-statements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xpc: fix up stale DBUG_ON statements
From: Robin Holt <holt@sgi.com>

Clean up the stale DBUG_ON checks and add a couple new ones.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_channel.c |    3 ---
 drivers/misc/sgi-xp/xpc_sn2.c     |   15 +++++++++++----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc_channel.c~sgi-xpc-fixup-stale-dbug_on-statements drivers/misc/sgi-xp/xpc_channel.c
--- a/drivers/misc/sgi-xp/xpc_channel.c~sgi-xpc-fixup-stale-dbug_on-statements
+++ a/drivers/misc/sgi-xp/xpc_channel.c
@@ -49,9 +49,6 @@ xpc_process_connect(struct xpc_channel *
 
 		if (ch->flags & (XPC_C_CONNECTED | XPC_C_DISCONNECTING))
 			return;
-
-		DBUG_ON(ch->local_msgqueue == NULL);
-		DBUG_ON(ch->remote_msgqueue == NULL);
 	}
 
 	if (!(ch->flags & XPC_C_OPENREPLY)) {
diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xpc-fixup-stale-dbug_on-statements drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xpc-fixup-stale-dbug_on-statements
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -1106,8 +1106,6 @@ xpc_process_activate_IRQ_rcvd_sn2(void)
 	int n_IRQs_expected;
 	int n_IRQs_detected;
 
-	DBUG_ON(xpc_activate_IRQ_rcvd == 0);
-
 	spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock, irq_flags);
 	n_IRQs_expected = xpc_activate_IRQ_rcvd;
 	xpc_activate_IRQ_rcvd = 0;
@@ -1726,6 +1724,7 @@ xpc_clear_local_msgqueue_flags_sn2(struc
 		msg = (struct xpc_msg_sn2 *)((u64)ch_sn2->local_msgqueue +
 					     (get % ch->local_nentries) *
 					     ch->entry_size);
+		DBUG_ON(!(msg->flags & XPC_M_SN2_READY));
 		msg->flags = 0;
 	} while (++get < ch_sn2->remote_GP.get);
 }
@@ -1740,11 +1739,18 @@ xpc_clear_remote_msgqueue_flags_sn2(stru
 	struct xpc_msg_sn2 *msg;
 	s64 put;
 
-	put = ch_sn2->w_remote_GP.put;
+	/* flags are zeroed when the buffer is allocated */
+	if (ch_sn2->remote_GP.put < ch->remote_nentries)
+		return;
+
+	put = max(ch_sn2->w_remote_GP.put, ch->remote_nentries);
 	do {
 		msg = (struct xpc_msg_sn2 *)((u64)ch_sn2->remote_msgqueue +
 					     (put % ch->remote_nentries) *
 					     ch->entry_size);
+		DBUG_ON(!(msg->flags & XPC_M_SN2_READY));
+		DBUG_ON(!(msg->flags & XPC_M_SN2_DONE));
+		DBUG_ON(msg->number != put - ch->remote_nentries);
 		msg->flags = 0;
 	} while (++put < ch_sn2->remote_GP.put);
 }
@@ -2280,8 +2286,9 @@ xpc_received_payload_sn2(struct xpc_chan
 	dev_dbg(xpc_chan, "msg=0x%p, msg_number=%ld, partid=%d, channel=%d\n",
 		(void *)msg, msg_number, ch->partid, ch->number);
 
-	DBUG_ON((((u64)msg - (u64)ch->remote_msgqueue) / ch->entry_size) !=
+	DBUG_ON((((u64)msg - (u64)ch->sn.sn2.remote_msgqueue) / ch->entry_size) !=
 		msg_number % ch->remote_nentries);
+	DBUG_ON(!(msg->flags & XPC_M_SN2_READY));
 	DBUG_ON(msg->flags & XPC_M_SN2_DONE);
 
 	msg->flags |= XPC_M_SN2_DONE;
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch
factor-out-ifdefs-from-kernel-spinlockc-to-lock_contended_flags.patch
allow-rwlocks-to-re-enable-interrupts.patch
ia64-implement-interrupt-enabling-rwlocks.patch

