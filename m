From: akpm@linux-foundation.org
Subject: [merged] x86-uv-xpc-receive-message-reuse-triggers-invalid-bug_on.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:40:03 -0800
Message-ID: <200912162040.nBGKe3uO013581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965007AbZLPUkQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, mingo@elte.hu, steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     x86: uv: XPC receive message reuse triggers invalid BUG_ON()
has been removed from the -mm tree.  Its filename was
     x86-uv-xpc-receive-message-reuse-triggers-invalid-bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: uv: XPC receive message reuse triggers invalid BUG_ON()
From: Robin Holt <holt@sgi.com>

This was a difficult bug to trip.  XPC was in the middle of sending an
acknowledgement for a received message.

In xpc_received_payload_uv():
.
        ret = xpc_send_gru_msg(ch->sn.uv.cached_notify_gru_mq_desc, msg,
                               sizeof(struct xpc_notify_mq_msghdr_uv));
        if (ret != xpSuccess)
                XPC_DEACTIVATE_PARTITION(&xpc_partitions[ch->partid], ret);

        msg->hdr.msg_slot_number += ch->remote_nentries;

at the point in xpc_send_gru_msg() where the hardware has dispatched the
acknowledgement, the remote side is able to reuse the message structure
and send a message with a different slot number.  This problem is made
worse by interrupts.

The adjustment of msg_slot_number and the BUG_ON in
xpc_handle_notify_mq_msg_uv() which verifies the msg_slot_number is
consistent are only used for debug purposes.  Since a fix for this that
preserves the debug functionality would either have to infringe upon the
payload or allocate another structure just for debug, I decided to remove
it entirely.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_uv.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc_uv.c~x86-uv-xpc-receive-message-reuse-triggers-invalid-bug_on drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~x86-uv-xpc-receive-message-reuse-triggers-invalid-bug_on
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -1428,7 +1428,6 @@ xpc_handle_notify_mq_msg_uv(struct xpc_p
 	msg_slot = ch_uv->recv_msg_slots +
 	    (msg->hdr.msg_slot_number % ch->remote_nentries) * ch->entry_size;
 
-	BUG_ON(msg->hdr.msg_slot_number != msg_slot->hdr.msg_slot_number);
 	BUG_ON(msg_slot->hdr.size != 0);
 
 	memcpy(msg_slot, msg, msg->hdr.size);
@@ -1652,8 +1651,6 @@ xpc_received_payload_uv(struct xpc_chann
 			       sizeof(struct xpc_notify_mq_msghdr_uv));
 	if (ret != xpSuccess)
 		XPC_DEACTIVATE_PARTITION(&xpc_partitions[ch->partid], ret);
