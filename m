From: akpm@linux-foundation.org
Subject: [merged] sgi-xp-fix-writing-past-the-end-of-kzallocd-space-v2.patch removed from -mm tree
Date: Fri, 06 Feb 2009 11:38:29 -0800
Message-ID: <200902061938.n16JcT6t012418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753989AbZBFTik (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 14:38:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sgi-xp: fix writing past the end of kzalloc()'d space
has been removed from the -mm tree.  Its filename was
     sgi-xp-fix-writing-past-the-end-of-kzallocd-space-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp: fix writing past the end of kzalloc()'d space
From: Dean Nelson <dcn@sgi.com>

A missing type cast results in writing way beyond the end of a kzalloc()'d
memory segment resulting in slab corruption. But it seems like the better
solution is to define ->recv_msg_slots as a 'void *' rather than a
'struct xpc_notify_mq_msg_uv *' and add the type cast.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc.h    |    5 +++--
 drivers/misc/sgi-xp/xpc_uv.c |   11 +++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xp-fix-writing-past-the-end-of-kzallocd-space-v2 drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xp-fix-writing-past-the-end-of-kzallocd-space-v2
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (c) 2004-2008 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (c) 2004-2009 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
 /*
@@ -514,7 +514,8 @@ struct xpc_channel_uv {
 						/* partition's notify mq */
 
 	struct xpc_send_msg_slot_uv *send_msg_slots;
-	struct xpc_notify_mq_msg_uv *recv_msg_slots;
+	void *recv_msg_slots;	/* each slot will hold a xpc_notify_mq_msg_uv */
+				/* structure plus the user's payload */
 
 	struct xpc_fifo_head_uv msg_slot_free_list;
 	struct xpc_fifo_head_uv recv_msg_list;	/* deliverable payloads */
diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-fix-writing-past-the-end-of-kzallocd-space-v2 drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-fix-writing-past-the-end-of-kzallocd-space-v2
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
+			msg_slot = ch_uv->recv_msg_slots +
+			    entry * ch->entry_size;
 
 			msg_slot->hdr.msg_slot_number = entry;
 		}
@@ -1308,9 +1308,8 @@ xpc_handle_notify_mq_msg_uv(struct xpc_p
 	/* we're dealing with a normal message sent via the notify_mq */
 	ch_uv = &ch->sn.uv;
 
-	msg_slot = (struct xpc_notify_mq_msg_uv *)((u64)ch_uv->recv_msg_slots +
-		    (msg->hdr.msg_slot_number % ch->remote_nentries) *
-		    ch->entry_size);
+	msg_slot = ch_uv->recv_msg_slots +
+	    (msg->hdr.msg_slot_number % ch->remote_nentries) * ch->entry_size;
 
 	BUG_ON(msg->hdr.msg_slot_number != msg_slot->hdr.msg_slot_number);
 	BUG_ON(msg_slot->hdr.size != 0);
_

Patches currently in -mm which might be from dcn@sgi.com are

origin.patch
linux-next.patch
sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts.patch

