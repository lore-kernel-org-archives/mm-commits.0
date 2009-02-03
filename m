From: akpm@linux-foundation.org
Subject: + sgi-xp-add-type-cast-to-kzallocd-space-to-avoid-slab-corruption.patch added to -mm tree
Date: Tue, 03 Feb 2009 12:02:10 -0800
Message-ID: <200902032002.n13K2AxV004962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752294AbZBCUCU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 15:02:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dcn@sgi.com, stable@kernel.org


The patch titled
     sgi-xp: add type cast to kzalloc()'d space to avoid slab corruption
has been added to the -mm tree.  Its filename is
     sgi-xp-add-type-cast-to-kzallocd-space-to-avoid-slab-corruption.patch

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

