From: akpm@linux-foundation.org
Subject: + sgi-xpc-implement-opencomplete-messaging.patch added to -mm tree
Date: Tue, 07 Apr 2009 12:52:10 -0700
Message-ID: <200904071952.n37JqBwi030225@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754925AbZDGTy1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:54:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, dcn@sgi.com


The patch titled
     sgi-xpc: implement opencomplete messaging
has been added to the -mm tree.  Its filename is
     sgi-xpc-implement-opencomplete-messaging.patch

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
Subject: sgi-xpc: implement opencomplete messaging
From: Robin Holt <holt@sgi.com>

sgi-xpc has a window of failure where an open message can be sent and a
subsequent data message can get lost.  We have added a new message
(opencomplete) which closes that window.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc.h         |   58 ++++++++++------
 drivers/misc/sgi-xp/xpc_channel.c |   97 ++++++++++++++++------------
 drivers/misc/sgi-xp/xpc_main.c    |    2 
 drivers/misc/sgi-xp/xpc_sn2.c     |    8 ++
 drivers/misc/sgi-xp/xpc_uv.c      |   22 ++++++
 5 files changed, 125 insertions(+), 62 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xpc-implement-opencomplete-messaging drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xpc-implement-opencomplete-messaging
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -232,9 +232,10 @@ struct xpc_activate_mq_msghdr_uv {
 #define XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREPLY_UV		4
 #define XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREQUEST_UV	5
 #define XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREPLY_UV		6
+#define XPC_ACTIVATE_MQ_MSG_CHCTL_OPENCOMPLETE_UV	7
 
-#define XPC_ACTIVATE_MQ_MSG_MARK_ENGAGED_UV		7
-#define XPC_ACTIVATE_MQ_MSG_MARK_DISENGAGED_UV		8
+#define XPC_ACTIVATE_MQ_MSG_MARK_ENGAGED_UV		8
+#define XPC_ACTIVATE_MQ_MSG_MARK_DISENGAGED_UV		9
 
 struct xpc_activate_mq_msg_uv {
 	struct xpc_activate_mq_msghdr_uv hdr;
@@ -278,6 +279,11 @@ struct xpc_activate_mq_msg_chctl_openrep
 	unsigned long notify_gru_mq_desc_gpa;
 };
 
+struct xpc_activate_mq_msg_chctl_opencomplete_uv {
+	struct xpc_activate_mq_msghdr_uv hdr;
+	short ch_number;
+};
+
 /*
  * Functions registered by add_timer() or called by kernel_thread() only
  * allow for a single 64-bit argument. The following macros can be used to
@@ -583,30 +589,32 @@ struct xpc_channel {
 
 #define	XPC_C_WASCONNECTED	0x00000001	/* channel was connected */
 
-#define	XPC_C_ROPENREPLY	0x00000002	/* remote open channel reply */
-#define	XPC_C_OPENREPLY		0x00000004	/* local open channel reply */
-#define	XPC_C_ROPENREQUEST	0x00000008     /* remote open channel request */
-#define	XPC_C_OPENREQUEST	0x00000010	/* local open channel request */
+#define XPC_C_ROPENCOMPLETE	0x00000002    /* remote open channel complete */
+#define XPC_C_OPENCOMPLETE	0x00000004     /* local open channel complete */
+#define	XPC_C_ROPENREPLY	0x00000008	/* remote open channel reply */
+#define	XPC_C_OPENREPLY		0x00000010	/* local open channel reply */
+#define	XPC_C_ROPENREQUEST	0x00000020     /* remote open channel request */
+#define	XPC_C_OPENREQUEST	0x00000040	/* local open channel request */
 
-#define	XPC_C_SETUP		0x00000020 /* channel's msgqueues are alloc'd */
-#define	XPC_C_CONNECTEDCALLOUT	0x00000040     /* connected callout initiated */
+#define	XPC_C_SETUP		0x00000080 /* channel's msgqueues are alloc'd */
+#define	XPC_C_CONNECTEDCALLOUT	0x00000100     /* connected callout initiated */
 #define	XPC_C_CONNECTEDCALLOUT_MADE \
-				0x00000080     /* connected callout completed */
-#define	XPC_C_CONNECTED		0x00000100	/* local channel is connected */
-#define	XPC_C_CONNECTING	0x00000200	/* channel is being connected */
-
-#define	XPC_C_RCLOSEREPLY	0x00000400	/* remote close channel reply */
-#define	XPC_C_CLOSEREPLY	0x00000800	/* local close channel reply */
-#define	XPC_C_RCLOSEREQUEST	0x00001000    /* remote close channel request */
-#define	XPC_C_CLOSEREQUEST	0x00002000     /* local close channel request */
+				0x00000200     /* connected callout completed */
+#define	XPC_C_CONNECTED		0x00000400	/* local channel is connected */
+#define	XPC_C_CONNECTING	0x00000800	/* channel is being connected */
+
+#define	XPC_C_RCLOSEREPLY	0x00001000	/* remote close channel reply */
+#define	XPC_C_CLOSEREPLY	0x00002000	/* local close channel reply */
+#define	XPC_C_RCLOSEREQUEST	0x00004000    /* remote close channel request */
+#define	XPC_C_CLOSEREQUEST	0x00008000     /* local close channel request */
 
-#define	XPC_C_DISCONNECTED	0x00004000	/* channel is disconnected */
-#define	XPC_C_DISCONNECTING	0x00008000   /* channel is being disconnected */
+#define	XPC_C_DISCONNECTED	0x00010000	/* channel is disconnected */
+#define	XPC_C_DISCONNECTING	0x00020000   /* channel is being disconnected */
 #define	XPC_C_DISCONNECTINGCALLOUT \
-				0x00010000 /* disconnecting callout initiated */
+				0x00040000 /* disconnecting callout initiated */
 #define	XPC_C_DISCONNECTINGCALLOUT_MADE \
-				0x00020000 /* disconnecting callout completed */
-#define	XPC_C_WDISCONNECT	0x00040000  /* waiting for channel disconnect */
+				0x00080000 /* disconnecting callout completed */
+#define	XPC_C_WDISCONNECT	0x00100000  /* waiting for channel disconnect */
 
 /*
  * The channel control flags (chctl) union consists of a 64-bit variable which
@@ -625,11 +633,13 @@ union xpc_channel_ctl_flags {
 #define	XPC_CHCTL_CLOSEREPLY	0x02
 #define	XPC_CHCTL_OPENREQUEST	0x04
 #define	XPC_CHCTL_OPENREPLY	0x08
-#define	XPC_CHCTL_MSGREQUEST	0x10
+#define XPC_CHCTL_OPENCOMPLETE	0x10
+#define	XPC_CHCTL_MSGREQUEST	0x20
 
 #define XPC_OPENCLOSE_CHCTL_FLAGS \
 			(XPC_CHCTL_CLOSEREQUEST | XPC_CHCTL_CLOSEREPLY | \
-			 XPC_CHCTL_OPENREQUEST | XPC_CHCTL_OPENREPLY)
+			 XPC_CHCTL_OPENREQUEST | XPC_CHCTL_OPENREPLY | \
+			 XPC_CHCTL_OPENCOMPLETE)
 #define XPC_MSG_CHCTL_FLAGS	XPC_CHCTL_MSGREQUEST
 
 static inline int
@@ -866,6 +876,8 @@ extern void (*xpc_send_chctl_closereply)
 extern void (*xpc_send_chctl_openrequest) (struct xpc_channel *,
 					   unsigned long *);
 extern void (*xpc_send_chctl_openreply) (struct xpc_channel *, unsigned long *);
+extern void (*xpc_send_chctl_opencomplete) (struct xpc_channel *,
+					    unsigned long *);
 
 extern enum xp_retval (*xpc_save_remote_msgqueue_pa) (struct xpc_channel *,
 						      unsigned long);
diff -puN drivers/misc/sgi-xp/xpc_channel.c~sgi-xpc-implement-opencomplete-messaging drivers/misc/sgi-xp/xpc_channel.c
--- a/drivers/misc/sgi-xp/xpc_channel.c~sgi-xpc-implement-opencomplete-messaging
+++ a/drivers/misc/sgi-xp/xpc_channel.c
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (c) 2004-2008 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (c) 2004-2009 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
 /*
@@ -44,10 +44,10 @@ xpc_process_connect(struct xpc_channel *
 
 		if (ret != xpSuccess)
 			XPC_DISCONNECT_CHANNEL(ch, ret, irq_flags);
+		else
+			ch->flags |= XPC_C_SETUP;
 
-		ch->flags |= XPC_C_SETUP;
-
-		if (ch->flags & (XPC_C_CONNECTED | XPC_C_DISCONNECTING))
+		if (ch->flags & XPC_C_DISCONNECTING)
 			return;
 	}
 
@@ -59,14 +59,18 @@ xpc_process_connect(struct xpc_channel *
 	if (!(ch->flags & XPC_C_ROPENREPLY))
 		return;
 
-	ch->flags = (XPC_C_CONNECTED | XPC_C_SETUP);	/* clear all else */
+	if (!(ch->flags & XPC_C_OPENCOMPLETE)) {
+		ch->flags |= (XPC_C_OPENCOMPLETE | XPC_C_CONNECTED);
+		xpc_send_chctl_opencomplete(ch, irq_flags);
+	}
+
+	if (!(ch->flags & XPC_C_ROPENCOMPLETE))
+		return;
 
 	dev_info(xpc_chan, "channel %d to partition %d connected\n",
 		 ch->number, ch->partid);
 
-	spin_unlock_irqrestore(&ch->lock, *irq_flags);
-	xpc_create_kthreads(ch, 1, 0);
-	spin_lock_irqsave(&ch->lock, *irq_flags);
+	ch->flags = (XPC_C_CONNECTED | XPC_C_SETUP);	/* clear all else */
 }
 
 /*
@@ -184,6 +188,7 @@ xpc_process_openclose_chctl_flags(struct
 	struct xpc_channel *ch = &part->channels[ch_number];
 	enum xp_retval reason;
 	enum xp_retval ret;
+	int create_kthread = 0;
 
 	spin_lock_irqsave(&ch->lock, irq_flags);
 
@@ -196,8 +201,7 @@ again:
 		 * has had a chance to see that the channel is disconnected.
 		 */
 		ch->delayed_chctl_flags |= chctl_flags;
-		spin_unlock_irqrestore(&ch->lock, irq_flags);
-		return;
+		goto out;
 	}
 
 	if (chctl_flags & XPC_CHCTL_CLOSEREQUEST) {
@@ -239,8 +243,7 @@ again:
 					    XPC_CHCTL_CLOSEREQUEST;
 					spin_unlock(&part->chctl_lock);
 				}
-				spin_unlock_irqrestore(&ch->lock, irq_flags);
-				return;
+				goto out;
 			}
 
 			XPC_SET_REASON(ch, 0, 0);
@@ -250,7 +253,8 @@ again:
 			ch->flags |= (XPC_C_CONNECTING | XPC_C_ROPENREQUEST);
 		}
 
-		chctl_flags &= ~(XPC_CHCTL_OPENREQUEST | XPC_CHCTL_OPENREPLY);
+		chctl_flags &= ~(XPC_CHCTL_OPENREQUEST | XPC_CHCTL_OPENREPLY |
+		    XPC_CHCTL_OPENCOMPLETE);
 
 		/*
 		 * The meaningful CLOSEREQUEST connection state fields are:
@@ -269,8 +273,7 @@ again:
 			XPC_DISCONNECT_CHANNEL(ch, reason, &irq_flags);
 
 			DBUG_ON(chctl_flags & XPC_CHCTL_CLOSEREPLY);
-			spin_unlock_irqrestore(&ch->lock, irq_flags);
-			return;
+			goto out;
 		}
 
 		xpc_process_disconnect(ch, &irq_flags);
@@ -283,8 +286,7 @@ again:
 
 		if (ch->flags & XPC_C_DISCONNECTED) {
 			DBUG_ON(part->act_state != XPC_P_AS_DEACTIVATING);
-			spin_unlock_irqrestore(&ch->lock, irq_flags);
-			return;
+			goto out;
 		}
 
 		DBUG_ON(!(ch->flags & XPC_C_CLOSEREQUEST));
@@ -299,8 +301,7 @@ again:
 				    XPC_CHCTL_CLOSEREPLY;
 				spin_unlock(&part->chctl_lock);
 			}
-			spin_unlock_irqrestore(&ch->lock, irq_flags);
-			return;
+			goto out;
 		}
 
 		ch->flags |= XPC_C_RCLOSEREPLY;
@@ -320,14 +321,12 @@ again:
 
 		if (part->act_state == XPC_P_AS_DEACTIVATING ||
 		    (ch->flags & XPC_C_ROPENREQUEST)) {
-			spin_unlock_irqrestore(&ch->lock, irq_flags);
-			return;
+			goto out;
 		}
 
 		if (ch->flags & (XPC_C_DISCONNECTING | XPC_C_WDISCONNECT)) {
 			ch->delayed_chctl_flags |= XPC_CHCTL_OPENREQUEST;
-			spin_unlock_irqrestore(&ch->lock, irq_flags);
-			return;
+			goto out;
 		}
 		DBUG_ON(!(ch->flags & (XPC_C_DISCONNECTED |
 				       XPC_C_OPENREQUEST)));
@@ -341,8 +340,7 @@ again:
 		 */
 		if (args->entry_size == 0 || args->local_nentries == 0) {
 			/* assume OPENREQUEST was delayed by mistake */
-			spin_unlock_irqrestore(&ch->lock, irq_flags);
-			return;
+			goto out;
 		}
 
 		ch->flags |= (XPC_C_ROPENREQUEST | XPC_C_CONNECTING);
@@ -352,8 +350,7 @@ again:
 			if (args->entry_size != ch->entry_size) {
 				XPC_DISCONNECT_CHANNEL(ch, xpUnequalMsgSizes,
 						       &irq_flags);
-				spin_unlock_irqrestore(&ch->lock, irq_flags);
-				return;
+				goto out;
 			}
 		} else {
 			ch->entry_size = args->entry_size;
@@ -375,15 +372,13 @@ again:
 			args->local_msgqueue_pa, args->local_nentries,
 			args->remote_nentries, ch->partid, ch->number);
 
-		if (ch->flags & (XPC_C_DISCONNECTING | XPC_C_DISCONNECTED)) {
-			spin_unlock_irqrestore(&ch->lock, irq_flags);
-			return;
-		}
+		if (ch->flags & (XPC_C_DISCONNECTING | XPC_C_DISCONNECTED))
+			goto out;
+
 		if (!(ch->flags & XPC_C_OPENREQUEST)) {
 			XPC_DISCONNECT_CHANNEL(ch, xpOpenCloseError,
 					       &irq_flags);
-			spin_unlock_irqrestore(&ch->lock, irq_flags);
-			return;
+			goto out;
 		}
 
 		DBUG_ON(!(ch->flags & XPC_C_ROPENREQUEST));
@@ -403,8 +398,7 @@ again:
 		ret = xpc_save_remote_msgqueue_pa(ch, args->local_msgqueue_pa);
 		if (ret != xpSuccess) {
 			XPC_DISCONNECT_CHANNEL(ch, ret, &irq_flags);
-			spin_unlock_irqrestore(&ch->lock, irq_flags);
-			return;
+			goto out;
 		}
 		ch->flags |= XPC_C_ROPENREPLY;
 
@@ -430,7 +424,36 @@ again:
 		xpc_process_connect(ch, &irq_flags);
 	}
 
+	if (chctl_flags & XPC_CHCTL_OPENCOMPLETE) {
+
+		dev_dbg(xpc_chan, "XPC_CHCTL_OPENCOMPLETE received from "
+			"partid=%d, channel=%d\n", ch->partid, ch->number);
+
+		if (ch->flags & (XPC_C_DISCONNECTING | XPC_C_DISCONNECTED))
+			goto out;
+
+		if (!(ch->flags & XPC_C_OPENREQUEST) ||
+		    !(ch->flags & XPC_C_OPENREPLY)) {
+			XPC_DISCONNECT_CHANNEL(ch, xpOpenCloseError,
+					       &irq_flags);
+			goto out;
+		}
+
+		DBUG_ON(!(ch->flags & XPC_C_ROPENREQUEST));
+		DBUG_ON(!(ch->flags & XPC_C_ROPENREPLY));
+		DBUG_ON(!(ch->flags & XPC_C_CONNECTED));
+
+		ch->flags |= XPC_C_ROPENCOMPLETE;
+
+		xpc_process_connect(ch, &irq_flags);
+		create_kthread = 1;
+	}
+
+out:
 	spin_unlock_irqrestore(&ch->lock, irq_flags);
+
+	if (create_kthread)
+		xpc_create_kthreads(ch, 1, 0);
 }
 
 /*
@@ -564,10 +587,6 @@ xpc_process_sent_chctl_flags(struct xpc_
 			if (!(ch_flags & XPC_C_OPENREQUEST)) {
 				DBUG_ON(ch_flags & XPC_C_SETUP);
 				(void)xpc_connect_channel(ch);
-			} else {
-				spin_lock_irqsave(&ch->lock, irq_flags);
-				xpc_process_connect(ch, &irq_flags);
-				spin_unlock_irqrestore(&ch->lock, irq_flags);
 			}
 			continue;
 		}
diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-xpc-implement-opencomplete-messaging drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xpc-implement-opencomplete-messaging
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -220,6 +220,8 @@ void (*xpc_send_chctl_openrequest) (stru
 				    unsigned long *irq_flags);
 void (*xpc_send_chctl_openreply) (struct xpc_channel *ch,
 				  unsigned long *irq_flags);
+void (*xpc_send_chctl_opencomplete) (struct xpc_channel *ch,
+				  unsigned long *irq_flags);
 
 enum xp_retval (*xpc_save_remote_msgqueue_pa) (struct xpc_channel *ch,
 					       unsigned long msgqueue_pa);
diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xpc-implement-opencomplete-messaging drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xpc-implement-opencomplete-messaging
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -431,6 +431,13 @@ xpc_send_chctl_openreply_sn2(struct xpc_
 }
 
 static void
+xpc_send_chctl_opencomplete_sn2(struct xpc_channel *ch,
+				unsigned long *irq_flags)
+{
+	XPC_SEND_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_OPENCOMPLETE, irq_flags);
+}
+
+static void
 xpc_send_chctl_msgrequest_sn2(struct xpc_channel *ch)
 {
 	XPC_SEND_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_MSGREQUEST, NULL);
@@ -2380,6 +2387,7 @@ xpc_init_sn2(void)
 	xpc_send_chctl_closereply = xpc_send_chctl_closereply_sn2;
 	xpc_send_chctl_openrequest = xpc_send_chctl_openrequest_sn2;
 	xpc_send_chctl_openreply = xpc_send_chctl_openreply_sn2;
+	xpc_send_chctl_opencomplete = xpc_send_chctl_opencomplete_sn2;
 
 	xpc_save_remote_msgqueue_pa = xpc_save_remote_msgqueue_pa_sn2;
 
diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-xpc-implement-opencomplete-messaging drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xpc-implement-opencomplete-messaging
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -534,6 +534,17 @@ xpc_handle_activate_mq_msg_uv(struct xpc
 		xpc_wakeup_channel_mgr(part);
 		break;
 	}
+	case XPC_ACTIVATE_MQ_MSG_CHCTL_OPENCOMPLETE_UV: {
+		struct xpc_activate_mq_msg_chctl_opencomplete_uv *msg;
+
+		msg = container_of(msg_hdr, struct
+				xpc_activate_mq_msg_chctl_opencomplete_uv, hdr);
+		spin_lock_irqsave(&part->chctl_lock, irq_flags);
+		part->chctl.flags[msg->ch_number] |= XPC_CHCTL_OPENCOMPLETE;
+		spin_unlock_irqrestore(&part->chctl_lock, irq_flags);
+
+		xpc_wakeup_channel_mgr(part);
+	}
 	case XPC_ACTIVATE_MQ_MSG_MARK_ENGAGED_UV:
 		spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
 		part_uv->flags |= XPC_P_ENGAGED_UV;
@@ -1202,6 +1213,16 @@ xpc_send_chctl_openreply_uv(struct xpc_c
 }
 
 static void
+xpc_send_chctl_opencomplete_uv(struct xpc_channel *ch, unsigned long *irq_flags)
+{
+	struct xpc_activate_mq_msg_chctl_opencomplete_uv msg;
+
+	msg.ch_number = ch->number;
+	xpc_send_activate_IRQ_ch_uv(ch, irq_flags, &msg, sizeof(msg),
+				    XPC_ACTIVATE_MQ_MSG_CHCTL_OPENCOMPLETE_UV);
+}
+
+static void
 xpc_send_chctl_local_msgrequest_uv(struct xpc_partition *part, int ch_number)
 {
 	unsigned long irq_flags;
@@ -1665,6 +1686,7 @@ xpc_init_uv(void)
 	xpc_send_chctl_closereply = xpc_send_chctl_closereply_uv;
 	xpc_send_chctl_openrequest = xpc_send_chctl_openrequest_uv;
 	xpc_send_chctl_openreply = xpc_send_chctl_openreply_uv;
+	xpc_send_chctl_opencomplete = xpc_send_chctl_opencomplete_uv;
 
 	xpc_save_remote_msgqueue_pa = xpc_save_remote_msgqueue_pa_uv;
 
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch
sgi-xpc-update-sgi-xp-xpc-xpnet-maintainer.patch
sgi-xpc-prevent-false-heartbeat-failures.patch
sgi-xpc-implement-opencomplete-messaging.patch

