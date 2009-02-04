From: akpm@linux-foundation.org
Subject: [to-be-updated] sgi-xp-add-type-cast-to-kzallocd-space-to-avoid-slab-corruption.patch removed from -mm tree
Date: Wed, 04 Feb 2009 11:57:56 -0800
Message-ID: <200902041957.n14Jvu10018929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758379AbZBDT6H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Feb 2009 14:58:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sgi-xp: add type cast to kzalloc()'d space to avoid slab corruption
has been removed from the -mm tree.  Its filename was
     sgi-xp-add-type-cast-to-kzallocd-space-to-avoid-slab-corruption.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp: add type cast to kzalloc()'d space to avoid slab corruption
From: Dean Nelson <dcn@sgi.com>

A missing type cast results in writing way beyond the end of a kzalloc()'d
memory segment resulting in slab corruption.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_uv.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-add-type-cast-to-kzallocd-space-to-avoid-slab-corruption drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-add-type-cast-to-kzallocd-space-to-avoid-slab-corruption
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (c) 2008-2009 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
 /*
@@ -1010,8 +1010,8 @@ xpc_allocate_recv_msg_slot_uv(struct xpc
 			continue;
 
 		for (entry = 0; entry < nentries; entry++) {
-			msg_slot = ch_uv->recv_msg_slots + entry *
-			    ch->entry_size;
+			msg_slot = (struct xpc_notify_mq_msg_uv *)((u8 *)
+			    ch_uv->recv_msg_slots + entry * ch->entry_size);
 
 			msg_slot->hdr.msg_slot_number = entry;
 		}
@@ -1308,7 +1308,7 @@ xpc_handle_notify_mq_msg_uv(struct xpc_p
 	/* we're dealing with a normal message sent via the notify_mq */
 	ch_uv = &ch->sn.uv;
 
-	msg_slot = (struct xpc_notify_mq_msg_uv *)((u64)ch_uv->recv_msg_slots +
+	msg_slot = (struct xpc_notify_mq_msg_uv *)((u8 *)ch_uv->recv_msg_slots +
 		    (msg->hdr.msg_slot_number % ch->remote_nentries) *
 		    ch->entry_size);
 
_

Patches currently in -mm which might be from dcn@sgi.com are

origin.patch
sgi-xp-add-type-cast-to-kzallocd-space-to-avoid-slab-corruption.patch
linux-next.patch
sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts.patch

