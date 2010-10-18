From: akpm@linux-foundation.org
Subject: + sgi-zp-incoming-xpc-channel-messages-can-come-in-after-the-channels-partition-structures-have-been-torn-down.patch added to -mm tree
Date: Mon, 18 Oct 2010 13:13:21 -0700
Message-ID: <201010182013.o9IKDLwI031638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756086Ab0JRUN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Oct 2010 16:13:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, stable@kernel.org


The patch titled
     sgi-xp: incoming XPC channel messages can come in after the channel's partition structures have been torn down.
has been added to the -mm tree.  Its filename is
     sgi-zp-incoming-xpc-channel-messages-can-come-in-after-the-channels-partition-structures-have-been-torn-down.patch

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
Subject: sgi-xp: incoming XPC channel messages can come in after the channel's partition structures have been torn down.
From: Robin Holt <holt@sgi.com>

Under some workloads, some channel messages have been observed being
delayed on the sending side past the point where the receiving side has
been able to tear down its partition structures.

This condition is already detected in xpc_handle_activate_IRQ_uv(), but
that information is not given to xpc_handle_activate_mq_msg_uv().  As a
result, xpc_handle_activate_mq_msg_uv() assumes the structures still exist
and references them, causing a NULL-pointer deref.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_uv.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-zp-incoming-xpc-channel-messages-can-come-in-after-the-channels-partition-structures-have-been-torn-down drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-zp-incoming-xpc-channel-messages-can-come-in-after-the-channels-partition-structures-have-been-torn-down
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -417,6 +417,7 @@ xpc_process_activate_IRQ_rcvd_uv(void)
 static void
 xpc_handle_activate_mq_msg_uv(struct xpc_partition *part,
 			      struct xpc_activate_mq_msghdr_uv *msg_hdr,
+			      int part_setup,
 			      int *wakeup_hb_checker)
 {
 	unsigned long irq_flags;
@@ -481,6 +482,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc
 	case XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREQUEST_UV: {
 		struct xpc_activate_mq_msg_chctl_closerequest_uv *msg;
 
+		if (!part_setup)
+			break;
+
 		msg = container_of(msg_hdr, struct
 				   xpc_activate_mq_msg_chctl_closerequest_uv,
 				   hdr);
@@ -497,6 +501,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc
 	case XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREPLY_UV: {
 		struct xpc_activate_mq_msg_chctl_closereply_uv *msg;
 
+		if (!part_setup)
+			break;
+
 		msg = container_of(msg_hdr, struct
 				   xpc_activate_mq_msg_chctl_closereply_uv,
 				   hdr);
@@ -511,6 +518,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc
 	case XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREQUEST_UV: {
 		struct xpc_activate_mq_msg_chctl_openrequest_uv *msg;
 
+		if (!part_setup)
+			break;
+
 		msg = container_of(msg_hdr, struct
 				   xpc_activate_mq_msg_chctl_openrequest_uv,
 				   hdr);
@@ -528,6 +538,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc
 	case XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREPLY_UV: {
 		struct xpc_activate_mq_msg_chctl_openreply_uv *msg;
 
+		if (!part_setup)
+			break;
+
 		msg = container_of(msg_hdr, struct
 				   xpc_activate_mq_msg_chctl_openreply_uv, hdr);
 		args = &part->remote_openclose_args[msg->ch_number];
@@ -545,6 +558,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc
 	case XPC_ACTIVATE_MQ_MSG_CHCTL_OPENCOMPLETE_UV: {
 		struct xpc_activate_mq_msg_chctl_opencomplete_uv *msg;
 
+		if (!part_setup)
+			break;
+
 		msg = container_of(msg_hdr, struct
 				xpc_activate_mq_msg_chctl_opencomplete_uv, hdr);
 		spin_lock_irqsave(&part->chctl_lock, irq_flags);
@@ -621,6 +637,7 @@ xpc_handle_activate_IRQ_uv(int irq, void
 
 			part_referenced = xpc_part_ref(part);
 			xpc_handle_activate_mq_msg_uv(part, msg_hdr,
+						      part_referenced,
 						      &wakeup_hb_checker);
 			if (part_referenced)
 				xpc_part_deref(part);
_

Patches currently in -mm which might be from holt@sgi.com are

sgi-zp-incoming-xpc-channel-messages-can-come-in-after-the-channels-partition-structures-have-been-torn-down.patch
linux-next.patch
net-avoid-limits-overflow.patch
fs-allow-for-more-than-231-files.patch

