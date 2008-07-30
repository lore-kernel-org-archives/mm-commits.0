From: akpm@linux-foundation.org
Subject: - sgi-xp-separate-chctl_flags-from-xpcs-notify-irq.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:16:43 -0700
Message-ID: <200807301916.m6UJGh35011148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752101AbYG3TRc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:17:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-xp: separate chctl_flags from XPC's notify IRQ
has been removed from the -mm tree.  Its filename was
     sgi-xp-separate-chctl_flags-from-xpcs-notify-irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp: separate chctl_flags from XPC's notify IRQ
From: Dean Nelson <dcn@sgi.com>

Tie current IPI references to either XPC's notify IRQ or channel control
flags.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc.h         |  124 ++++++-----
 drivers/misc/sgi-xp/xpc_channel.c |  133 ++++++------
 drivers/misc/sgi-xp/xpc_main.c    |   59 ++---
 drivers/misc/sgi-xp/xpc_sn2.c     |  303 ++++++++++++++--------------
 drivers/misc/sgi-xp/xpc_uv.c      |   10 
 5 files changed, 327 insertions(+), 302 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xp-separate-chctl_flags-from-xpcs-notify-irq drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xp-separate-chctl_flags-from-xpcs-notify-irq
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -186,9 +186,10 @@ struct xpc_vars_part_sn2 {
 	u64 openclose_args_pa;	/* physical address of open and close args */
 	u64 GPs_pa;		/* physical address of Get/Put values */
 
-	u64 IPI_amo_pa;		/* physical address of IPI AMO_t structure */
-	int IPI_nasid;		/* nasid of where to send IPIs */
-	int IPI_phys_cpuid;	/* physical CPU ID of where to send IPIs */
+	u64 chctl_amo_pa;	/* physical address of chctl flags' AMO_t */
+
+	int notify_IRQ_nasid;	/* nasid of where to send notify IRQs */
+	int notify_IRQ_phys_cpuid;	/* CPUID of where to send notify IRQs */
 
 	u8 nchannels;		/* #of defined channels supported */
 
@@ -407,7 +408,7 @@ struct xpc_channel {
 	atomic_t n_on_msg_allocate_wq;	/* #on msg allocation wait queue */
 	wait_queue_head_t msg_allocate_wq;	/* msg allocation wait queue */
 
-	u8 delayed_IPI_flags;	/* IPI flags received, but delayed */
+	u8 delayed_chctl_flags;	/* chctl flags received, but delayed */
 				/* action until channel disconnected */
 
 	/* queue of msg senders who want to be notified when msg received */
@@ -470,6 +471,54 @@ struct xpc_channel {
 #define	XPC_C_WDISCONNECT	0x00040000  /* waiting for channel disconnect */
 
 /*
+ * The channel control flags (chctl) union consists of a 64-bit variable which
+ * is divided up into eight bytes, ordered from right to left. Byte zero
+ * pertains to channel 0, byte one to channel 1, and so on. Each channel's byte
+ * can have one or more of the chctl flags set in it.
+ */
+
+union xpc_channel_ctl_flags {
+	u64 all_flags;
+	u8 flags[XPC_MAX_NCHANNELS];
+};
+
+/* chctl flags */
+#define	XPC_CHCTL_CLOSEREQUEST	0x01
+#define	XPC_CHCTL_CLOSEREPLY	0x02
+#define	XPC_CHCTL_OPENREQUEST	0x04
+#define	XPC_CHCTL_OPENREPLY	0x08
+#define	XPC_CHCTL_MSGREQUEST	0x10
+
+#define XPC_OPENCLOSE_CHCTL_FLAGS \
+			(XPC_CHCTL_CLOSEREQUEST | XPC_CHCTL_CLOSEREPLY | \
+			 XPC_CHCTL_OPENREQUEST | XPC_CHCTL_OPENREPLY)
+#define XPC_MSG_CHCTL_FLAGS	XPC_CHCTL_MSGREQUEST
+
+static inline int
+xpc_any_openclose_chctl_flags_set(union xpc_channel_ctl_flags *chctl)
+{
+	int ch_number;
+
+	for (ch_number = 0; ch_number < XPC_MAX_NCHANNELS; ch_number++) {
+		if (chctl->flags[ch_number] & XPC_OPENCLOSE_CHCTL_FLAGS)
+			return 1;
+	}
+	return 0;
+}
+
+static inline int
+xpc_any_msg_chctl_flags_set(union xpc_channel_ctl_flags *chctl)
+{
+	int ch_number;
+
+	for (ch_number = 0; ch_number < XPC_MAX_NCHANNELS; ch_number++) {
+		if (chctl->flags[ch_number] & XPC_MSG_CHCTL_FLAGS)
+			return 1;
+	}
+	return 0;
+}
+
+/*
  * Manages channels on a partition basis. There is one of these structures
  * for each partition (a partition will never utilize the structure that
  * represents itself).
@@ -494,12 +543,12 @@ struct xpc_partition_sn2 {
 
 	u64 remote_openclose_args_pa;	/* phys addr of remote's args */
 
-	int remote_IPI_nasid;	/* nasid of where to send IPIs */
-	int remote_IPI_phys_cpuid;	/* phys CPU ID of where to send IPIs */
-	char IPI_owner[8];	/* IPI owner's name */
+	int notify_IRQ_nasid;	/* nasid of where to send notify IRQs */
+	int notify_IRQ_phys_cpuid;	/* CPUID of where to send notify IRQs */
+	char notify_IRQ_owner[8];	/* notify IRQ's owner's name */
 
-	AMO_t *remote_IPI_amo_va;    /* address of remote IPI AMO_t structure */
-	AMO_t *local_IPI_amo_va;	/* address of IPI AMO_t structure */
+	AMO_t *remote_chctl_amo_va; /* address of remote chctl flags' AMO_t */
+	AMO_t *local_chctl_amo_va;	/* address of chctl flags' AMO_t */
 
 	struct timer_list dropped_notify_IRQ_timer;	/* dropped IRQ timer */
 };
@@ -536,7 +585,10 @@ struct xpc_partition {
 	atomic_t nchannels_engaged;  /* #of channels engaged with remote part */
 	struct xpc_channel *channels;	/* array of channel structures */
 
-	/* fields used to pass args when opening or closing a channel */
+	/* fields used for managing channel avialability and activity */
+
+	union xpc_channel_ctl_flags chctl; /* chctl flags yet to be processed */
+	spinlock_t chctl_lock;	/* chctl flags lock */
 
 	void *local_openclose_args_base;   /* base address of kmalloc'd space */
 	struct xpc_openclose_args *local_openclose_args;      /* local's args */
@@ -544,11 +596,6 @@ struct xpc_partition {
 	struct xpc_openclose_args *remote_openclose_args; /* copy of remote's */
 							  /* args */
 
-	/* IPI sending, receiving and handling related fields */
-
-	u64 local_IPI_amo;	/* IPI amo flags yet to be handled */
-	spinlock_t IPI_lock;	/* IPI handler lock */
-
 	/* channel manager related fields */
 
 	atomic_t channel_mgr_requests;	/* #of requests to activate chan mgr */
@@ -580,11 +627,12 @@ struct xpc_partition {
 #define XPC_P_TORNDOWN		0x03	/* infrastructure is torndown */
 
 /*
- * struct xpc_partition IPI_timer #of seconds to wait before checking for
- * dropped IPIs. These occur whenever an IPI amo write doesn't complete until
- * after the IPI was received.
+ * struct xpc_partition_sn2's dropped notify IRQ timer is set to wait the
+ * following interval #of seconds before checking for dropped notify IRQs.
+ * These can occur whenever an IRQ's associated amo write doesn't complete
+ * until after the IRQ was received.
  */
-#define XPC_P_DROPPED_IPI_WAIT_INTERVAL	(0.25 * HZ)
+#define XPC_DROPPED_NOTIFY_IRQ_WAIT_INTERVAL	(0.25 * HZ)
 
 /* number of seconds to wait for other partitions to disengage */
 #define XPC_DISENGAGE_DEFAULT_TIMELIMIT		90
@@ -617,9 +665,9 @@ extern void (*xpc_offline_heartbeat) (vo
 extern void (*xpc_online_heartbeat) (void);
 extern void (*xpc_check_remote_hb) (void);
 extern enum xp_retval (*xpc_make_first_contact) (struct xpc_partition *);
-extern u64 (*xpc_get_IPI_flags) (struct xpc_partition *);
+extern u64 (*xpc_get_chctl_all_flags) (struct xpc_partition *);
 extern void (*xpc_notify_senders_of_disconnect) (struct xpc_channel *);
-extern void (*xpc_process_msg_IPI) (struct xpc_partition *, int);
+extern void (*xpc_process_msg_chctl_flags) (struct xpc_partition *, int);
 extern int (*xpc_n_of_deliverable_msgs) (struct xpc_channel *);
 extern struct xpc_msg *(*xpc_get_deliverable_msg) (struct xpc_channel *);
 extern void (*xpc_request_partition_activation) (struct xpc_rsvd_page *, u64,
@@ -638,14 +686,13 @@ extern int (*xpc_any_partition_engaged) 
 extern void (*xpc_indicate_partition_disengaged) (struct xpc_partition *);
 extern void (*xpc_assume_partition_disengaged) (short);
 
-extern void (*xpc_send_channel_closerequest) (struct xpc_channel *,
-					      unsigned long *);
-extern void (*xpc_send_channel_closereply) (struct xpc_channel *,
+extern void (*xpc_send_chctl_closerequest) (struct xpc_channel *,
 					    unsigned long *);
-extern void (*xpc_send_channel_openrequest) (struct xpc_channel *,
-					     unsigned long *);
-extern void (*xpc_send_channel_openreply) (struct xpc_channel *,
+extern void (*xpc_send_chctl_closereply) (struct xpc_channel *,
+					  unsigned long *);
+extern void (*xpc_send_chctl_openrequest) (struct xpc_channel *,
 					   unsigned long *);
+extern void (*xpc_send_chctl_openreply) (struct xpc_channel *, unsigned long *);
 
 extern enum xp_retval (*xpc_send_msg) (struct xpc_channel *, u32, void *, u16,
 				       u8, xpc_notify_func, void *);
@@ -689,7 +736,7 @@ extern enum xp_retval xpc_initiate_send(
 extern enum xp_retval xpc_initiate_send_notify(short, int, u32, void *, u16,
 					       xpc_notify_func, void *);
 extern void xpc_initiate_received(short, int, void *);
-extern void xpc_process_channel_activity(struct xpc_partition *);
+extern void xpc_process_sent_chctl_flags(struct xpc_partition *);
 extern void xpc_connected_callout(struct xpc_channel *);
 extern void xpc_deliver_msg(struct xpc_channel *);
 extern void xpc_disconnect_channel(const int, struct xpc_channel *,
@@ -799,25 +846,4 @@ xpc_part_ref(struct xpc_partition *part)
 		(_p)->reason_line = _line; \
 	}
 
-/*
- * The sending and receiving of IPIs includes the setting of an >>>AMO variable
- * to indicate the reason the IPI was sent. The 64-bit variable is divided
- * up into eight bytes, ordered from right to left. Byte zero pertains to
- * channel 0, byte one to channel 1, and so on. Each byte is described by
- * the following IPI flags.
- */
-
-#define	XPC_IPI_CLOSEREQUEST	0x01
-#define	XPC_IPI_CLOSEREPLY	0x02
-#define	XPC_IPI_OPENREQUEST	0x04
-#define	XPC_IPI_OPENREPLY	0x08
-#define	XPC_IPI_MSGREQUEST	0x10
-
-/* given an >>>AMO variable and a channel#, get its associated IPI flags */
-#define XPC_GET_IPI_FLAGS(_amo, _c)	((u8) (((_amo) >> ((_c) * 8)) & 0xff))
-#define XPC_SET_IPI_FLAGS(_amo, _c, _f)	(_amo) |= ((u64) (_f) << ((_c) * 8))
-
-#define	XPC_ANY_OPENCLOSE_IPI_FLAGS_SET(_amo) ((_amo) & 0x0f0f0f0f0f0f0f0fUL)
-#define XPC_ANY_MSG_IPI_FLAGS_SET(_amo)       ((_amo) & 0x1010101010101010UL)
-
 #endif /* _DRIVERS_MISC_SGIXP_XPC_H */
diff -puN drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-separate-chctl_flags-from-xpcs-notify-irq drivers/misc/sgi-xp/xpc_channel.c
--- a/drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-separate-chctl_flags-from-xpcs-notify-irq
+++ a/drivers/misc/sgi-xp/xpc_channel.c
@@ -201,7 +201,7 @@ xpc_process_connect(struct xpc_channel *
 
 	if (!(ch->flags & XPC_C_OPENREPLY)) {
 		ch->flags |= XPC_C_OPENREPLY;
-		xpc_send_channel_openreply(ch, irq_flags);
+		xpc_send_chctl_openreply(ch, irq_flags);
 	}
 
 	if (!(ch->flags & XPC_C_ROPENREPLY))
@@ -307,7 +307,7 @@ xpc_process_disconnect(struct xpc_channe
 
 		if (!(ch->flags & XPC_C_CLOSEREPLY)) {
 			ch->flags |= XPC_C_CLOSEREPLY;
-			xpc_send_channel_closereply(ch, irq_flags);
+			xpc_send_chctl_closereply(ch, irq_flags);
 		}
 
 		if (!(ch->flags & XPC_C_RCLOSEREPLY))
@@ -344,15 +344,15 @@ xpc_process_disconnect(struct xpc_channe
 	if (ch->flags & XPC_C_WDISCONNECT) {
 		/* we won't lose the CPU since we're holding ch->lock */
 		complete(&ch->wdisconnect_wait);
-	} else if (ch->delayed_IPI_flags) {
+	} else if (ch->delayed_chctl_flags) {
 		if (part->act_state != XPC_P_DEACTIVATING) {
-			/* time to take action on any delayed IPI flags */
-			spin_lock(&part->IPI_lock);
-			XPC_SET_IPI_FLAGS(part->local_IPI_amo, ch->number,
-					  ch->delayed_IPI_flags);
-			spin_unlock(&part->IPI_lock);
+			/* time to take action on any delayed chctl flags */
+			spin_lock(&part->chctl_lock);
+			part->chctl.flags[ch->number] |=
+			    ch->delayed_chctl_flags;
+			spin_unlock(&part->chctl_lock);
 		}
-		ch->delayed_IPI_flags = 0;
+		ch->delayed_chctl_flags = 0;
 	}
 }
 
@@ -360,8 +360,8 @@ xpc_process_disconnect(struct xpc_channe
  * Process a change in the channel's remote connection state.
  */
 static void
-xpc_process_openclose_IPI(struct xpc_partition *part, int ch_number,
-			  u8 IPI_flags)
+xpc_process_openclose_chctl_flags(struct xpc_partition *part, int ch_number,
+				  u8 chctl_flags)
 {
 	unsigned long irq_flags;
 	struct xpc_openclose_args *args =
@@ -376,24 +376,24 @@ again:
 	if ((ch->flags & XPC_C_DISCONNECTED) &&
 	    (ch->flags & XPC_C_WDISCONNECT)) {
 		/*
-		 * Delay processing IPI flags until thread waiting disconnect
+		 * Delay processing chctl flags until thread waiting disconnect
 		 * has had a chance to see that the channel is disconnected.
 		 */
-		ch->delayed_IPI_flags |= IPI_flags;
+		ch->delayed_chctl_flags |= chctl_flags;
 		spin_unlock_irqrestore(&ch->lock, irq_flags);
 		return;
 	}
 
-	if (IPI_flags & XPC_IPI_CLOSEREQUEST) {
+	if (chctl_flags & XPC_CHCTL_CLOSEREQUEST) {
 
-		dev_dbg(xpc_chan, "XPC_IPI_CLOSEREQUEST (reason=%d) received "
+		dev_dbg(xpc_chan, "XPC_CHCTL_CLOSEREQUEST (reason=%d) received "
 			"from partid=%d, channel=%d\n", args->reason,
 			ch->partid, ch->number);
 
 		/*
 		 * If RCLOSEREQUEST is set, we're probably waiting for
 		 * RCLOSEREPLY. We should find it and a ROPENREQUEST packed
-		 * with this RCLOSEREQUEST in the IPI_flags.
+		 * with this RCLOSEREQUEST in the chctl_flags.
 		 */
 
 		if (ch->flags & XPC_C_RCLOSEREQUEST) {
@@ -402,8 +402,8 @@ again:
 			DBUG_ON(!(ch->flags & XPC_C_CLOSEREPLY));
 			DBUG_ON(ch->flags & XPC_C_RCLOSEREPLY);
 
-			DBUG_ON(!(IPI_flags & XPC_IPI_CLOSEREPLY));
-			IPI_flags &= ~XPC_IPI_CLOSEREPLY;
+			DBUG_ON(!(chctl_flags & XPC_CHCTL_CLOSEREPLY));
+			chctl_flags &= ~XPC_CHCTL_CLOSEREPLY;
 			ch->flags |= XPC_C_RCLOSEREPLY;
 
 			/* both sides have finished disconnecting */
@@ -413,17 +413,15 @@ again:
 		}
 
 		if (ch->flags & XPC_C_DISCONNECTED) {
-			if (!(IPI_flags & XPC_IPI_OPENREQUEST)) {
-				if ((XPC_GET_IPI_FLAGS(part->local_IPI_amo,
-						       ch_number) &
-				     XPC_IPI_OPENREQUEST)) {
-
-					DBUG_ON(ch->delayed_IPI_flags != 0);
-					spin_lock(&part->IPI_lock);
-					XPC_SET_IPI_FLAGS(part->local_IPI_amo,
-							  ch_number,
-							  XPC_IPI_CLOSEREQUEST);
-					spin_unlock(&part->IPI_lock);
+			if (!(chctl_flags & XPC_CHCTL_OPENREQUEST)) {
+				if (part->chctl.flags[ch_number] &
+				    XPC_CHCTL_OPENREQUEST) {
+
+					DBUG_ON(ch->delayed_chctl_flags != 0);
+					spin_lock(&part->chctl_lock);
+					part->chctl.flags[ch_number] |=
+					    XPC_CHCTL_CLOSEREQUEST;
+					spin_unlock(&part->chctl_lock);
 				}
 				spin_unlock_irqrestore(&ch->lock, irq_flags);
 				return;
@@ -436,7 +434,7 @@ again:
 			ch->flags |= (XPC_C_CONNECTING | XPC_C_ROPENREQUEST);
 		}
 
-		IPI_flags &= ~(XPC_IPI_OPENREQUEST | XPC_IPI_OPENREPLY);
+		chctl_flags &= ~(XPC_CHCTL_OPENREQUEST | XPC_CHCTL_OPENREPLY);
 
 		/*
 		 * The meaningful CLOSEREQUEST connection state fields are:
@@ -454,7 +452,7 @@ again:
 
 			XPC_DISCONNECT_CHANNEL(ch, reason, &irq_flags);
 
-			DBUG_ON(IPI_flags & XPC_IPI_CLOSEREPLY);
+			DBUG_ON(chctl_flags & XPC_CHCTL_CLOSEREPLY);
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
 			return;
 		}
@@ -462,10 +460,10 @@ again:
 		xpc_process_disconnect(ch, &irq_flags);
 	}
 
-	if (IPI_flags & XPC_IPI_CLOSEREPLY) {
+	if (chctl_flags & XPC_CHCTL_CLOSEREPLY) {
 
-		dev_dbg(xpc_chan, "XPC_IPI_CLOSEREPLY received from partid=%d,"
-			" channel=%d\n", ch->partid, ch->number);
+		dev_dbg(xpc_chan, "XPC_CHCTL_CLOSEREPLY received from partid="
+			"%d, channel=%d\n", ch->partid, ch->number);
 
 		if (ch->flags & XPC_C_DISCONNECTED) {
 			DBUG_ON(part->act_state != XPC_P_DEACTIVATING);
@@ -476,15 +474,14 @@ again:
 		DBUG_ON(!(ch->flags & XPC_C_CLOSEREQUEST));
 
 		if (!(ch->flags & XPC_C_RCLOSEREQUEST)) {
-			if ((XPC_GET_IPI_FLAGS(part->local_IPI_amo, ch_number)
-			     & XPC_IPI_CLOSEREQUEST)) {
+			if (part->chctl.flags[ch_number] &
+			    XPC_CHCTL_CLOSEREQUEST) {
 
-				DBUG_ON(ch->delayed_IPI_flags != 0);
-				spin_lock(&part->IPI_lock);
-				XPC_SET_IPI_FLAGS(part->local_IPI_amo,
-						  ch_number,
-						  XPC_IPI_CLOSEREPLY);
-				spin_unlock(&part->IPI_lock);
+				DBUG_ON(ch->delayed_chctl_flags != 0);
+				spin_lock(&part->chctl_lock);
+				part->chctl.flags[ch_number] |=
+				    XPC_CHCTL_CLOSEREPLY;
+				spin_unlock(&part->chctl_lock);
 			}
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
 			return;
@@ -498,9 +495,9 @@ again:
 		}
 	}
 
-	if (IPI_flags & XPC_IPI_OPENREQUEST) {
+	if (chctl_flags & XPC_CHCTL_OPENREQUEST) {
 
-		dev_dbg(xpc_chan, "XPC_IPI_OPENREQUEST (msg_size=%d, "
+		dev_dbg(xpc_chan, "XPC_CHCTL_OPENREQUEST (msg_size=%d, "
 			"local_nentries=%d) received from partid=%d, "
 			"channel=%d\n", args->msg_size, args->local_nentries,
 			ch->partid, ch->number);
@@ -512,7 +509,7 @@ again:
 		}
 
 		if (ch->flags & (XPC_C_DISCONNECTING | XPC_C_WDISCONNECT)) {
-			ch->delayed_IPI_flags |= XPC_IPI_OPENREQUEST;
+			ch->delayed_chctl_flags |= XPC_CHCTL_OPENREQUEST;
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
 			return;
 		}
@@ -554,13 +551,13 @@ again:
 		xpc_process_connect(ch, &irq_flags);
 	}
 
-	if (IPI_flags & XPC_IPI_OPENREPLY) {
+	if (chctl_flags & XPC_CHCTL_OPENREPLY) {
 
-		dev_dbg(xpc_chan, "XPC_IPI_OPENREPLY (local_msgqueue_pa=0x%lx, "
-			"local_nentries=%d, remote_nentries=%d) received from "
-			"partid=%d, channel=%d\n", args->local_msgqueue_pa,
-			args->local_nentries, args->remote_nentries,
-			ch->partid, ch->number);
+		dev_dbg(xpc_chan, "XPC_CHCTL_OPENREPLY (local_msgqueue_pa="
+			"0x%lx, local_nentries=%d, remote_nentries=%d) "
+			"received from partid=%d, channel=%d\n",
+			args->local_msgqueue_pa, args->local_nentries,
+			args->remote_nentries, ch->partid, ch->number);
 
 		if (ch->flags & (XPC_C_DISCONNECTING | XPC_C_DISCONNECTED)) {
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
@@ -591,7 +588,7 @@ again:
 		ch->remote_msgqueue_pa = args->local_msgqueue_pa;
 
 		if (args->local_nentries < ch->remote_nentries) {
-			dev_dbg(xpc_chan, "XPC_IPI_OPENREPLY: new "
+			dev_dbg(xpc_chan, "XPC_CHCTL_OPENREPLY: new "
 				"remote_nentries=%d, old remote_nentries=%d, "
 				"partid=%d, channel=%d\n",
 				args->local_nentries, ch->remote_nentries,
@@ -600,7 +597,7 @@ again:
 			ch->remote_nentries = args->local_nentries;
 		}
 		if (args->remote_nentries < ch->local_nentries) {
-			dev_dbg(xpc_chan, "XPC_IPI_OPENREPLY: new "
+			dev_dbg(xpc_chan, "XPC_CHCTL_OPENREPLY: new "
 				"local_nentries=%d, old local_nentries=%d, "
 				"partid=%d, channel=%d\n",
 				args->remote_nentries, ch->local_nentries,
@@ -690,7 +687,7 @@ xpc_connect_channel(struct xpc_channel *
 	/* initiate the connection */
 
 	ch->flags |= (XPC_C_OPENREQUEST | XPC_C_CONNECTING);
-	xpc_send_channel_openrequest(ch, &irq_flags);
+	xpc_send_chctl_openrequest(ch, &irq_flags);
 
 	xpc_process_connect(ch, &irq_flags);
 
@@ -700,15 +697,15 @@ xpc_connect_channel(struct xpc_channel *
 }
 
 void
-xpc_process_channel_activity(struct xpc_partition *part)
+xpc_process_sent_chctl_flags(struct xpc_partition *part)
 {
 	unsigned long irq_flags;
-	u64 IPI_amo, IPI_flags;
+	union xpc_channel_ctl_flags chctl;
 	struct xpc_channel *ch;
 	int ch_number;
 	u32 ch_flags;
 
-	IPI_amo = xpc_get_IPI_flags(part);
+	chctl.all_flags = xpc_get_chctl_all_flags(part);
 
 	/*
 	 * Initiate channel connections for registered channels.
@@ -721,14 +718,14 @@ xpc_process_channel_activity(struct xpc_
 		ch = &part->channels[ch_number];
 
 		/*
-		 * Process any open or close related IPI flags, and then deal
+		 * Process any open or close related chctl flags, and then deal
 		 * with connecting or disconnecting the channel as required.
 		 */
 
-		IPI_flags = XPC_GET_IPI_FLAGS(IPI_amo, ch_number);
-
-		if (XPC_ANY_OPENCLOSE_IPI_FLAGS_SET(IPI_flags))
-			xpc_process_openclose_IPI(part, ch_number, IPI_flags);
+		if (chctl.flags[ch_number] & XPC_OPENCLOSE_CHCTL_FLAGS) {
+			xpc_process_openclose_chctl_flags(part, ch_number,
+							chctl.flags[ch_number]);
+		}
 
 		ch_flags = ch->flags;	/* need an atomic snapshot of flags */
 
@@ -755,13 +752,13 @@ xpc_process_channel_activity(struct xpc_
 		}
 
 		/*
-		 * Process any message related IPI flags, this may involve the
-		 * activation of kthreads to deliver any pending messages sent
-		 * from the other partition.
+		 * Process any message related chctl flags, this may involve
+		 * the activation of kthreads to deliver any pending messages
+		 * sent from the other partition.
 		 */
 
-		if (XPC_ANY_MSG_IPI_FLAGS_SET(IPI_flags))
-			xpc_process_msg_IPI(part, ch_number);
+		if (chctl.flags[ch_number] & XPC_MSG_CHCTL_FLAGS)
+			xpc_process_msg_chctl_flags(part, ch_number);
 	}
 }
 
@@ -937,7 +934,7 @@ xpc_disconnect_channel(const int line, s
 		       XPC_C_ROPENREQUEST | XPC_C_ROPENREPLY |
 		       XPC_C_CONNECTING | XPC_C_CONNECTED);
 
-	xpc_send_channel_closerequest(ch, irq_flags);
+	xpc_send_chctl_closerequest(ch, irq_flags);
 
 	if (channel_was_connected)
 		ch->flags |= XPC_C_WASCONNECTED;
diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-xp-separate-chctl_flags-from-xpcs-notify-irq drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xp-separate-chctl_flags-from-xpcs-notify-irq
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -25,18 +25,18 @@
  *
  *	Caveats:
  *
- *	  . We currently have no way to determine which nasid an IPI came
- *	    from. Thus, >>> xpc_IPI_send() does a remote AMO write followed by
- *	    an IPI. The AMO indicates where data is to be pulled from, so
- *	    after the IPI arrives, the remote partition checks the AMO word.
- *	    The IPI can actually arrive before the AMO however, so other code
- *	    must periodically check for this case. Also, remote AMO operations
- *	    do not reliably time out. Thus we do a remote PIO read solely to
- *	    know whether the remote partition is down and whether we should
- *	    stop sending IPIs to it. This remote PIO read operation is set up
- *	    in a special nofault region so SAL knows to ignore (and cleanup)
- *	    any errors due to the remote AMO write, PIO read, and/or PIO
- *	    write operations.
+ *	  . Currently on sn2, we have no way to determine which nasid an IRQ
+ *	    came from. Thus, xpc_send_IRQ_sn2() does a remote AMO write
+ *	    followed by an IPI. The AMO indicates where data is to be pulled
+ *	    from, so after the IPI arrives, the remote partition checks the AMO
+ *	    word. The IPI can actually arrive before the AMO however, so other
+ *	    code must periodically check for this case. Also, remote AMO
+ *	    operations do not reliably time out. Thus we do a remote PIO read
+ *	    solely to know whether the remote partition is down and whether we
+ *	    should stop sending IPIs to it. This remote PIO read operation is
+ *	    set up in a special nofault region so SAL knows to ignore (and
+ *	    cleanup) any errors due to the remote AMO write, PIO read, and/or
+ *	    PIO write operations.
  *
  *	    If/when new hardware solves this IPI problem, we should abandon
  *	    the current approach.
@@ -185,8 +185,8 @@ void (*xpc_check_remote_hb) (void);
 
 enum xp_retval (*xpc_make_first_contact) (struct xpc_partition *part);
 void (*xpc_notify_senders_of_disconnect) (struct xpc_channel *ch);
-u64 (*xpc_get_IPI_flags) (struct xpc_partition *part);
-void (*xpc_process_msg_IPI) (struct xpc_partition *part, int ch_number);
+u64 (*xpc_get_chctl_all_flags) (struct xpc_partition *part);
+void (*xpc_process_msg_chctl_flags) (struct xpc_partition *part, int ch_number);
 int (*xpc_n_of_deliverable_msgs) (struct xpc_channel *ch);
 struct xpc_msg *(*xpc_get_deliverable_msg) (struct xpc_channel *ch);
 
@@ -206,14 +206,14 @@ int (*xpc_any_partition_engaged) (void);
 void (*xpc_indicate_partition_disengaged) (struct xpc_partition *part);
 void (*xpc_assume_partition_disengaged) (short partid);
 
-void (*xpc_send_channel_closerequest) (struct xpc_channel *ch,
-				       unsigned long *irq_flags);
-void (*xpc_send_channel_closereply) (struct xpc_channel *ch,
+void (*xpc_send_chctl_closerequest) (struct xpc_channel *ch,
 				     unsigned long *irq_flags);
-void (*xpc_send_channel_openrequest) (struct xpc_channel *ch,
-				      unsigned long *irq_flags);
-void (*xpc_send_channel_openreply) (struct xpc_channel *ch,
+void (*xpc_send_chctl_closereply) (struct xpc_channel *ch,
+				   unsigned long *irq_flags);
+void (*xpc_send_chctl_openrequest) (struct xpc_channel *ch,
 				    unsigned long *irq_flags);
+void (*xpc_send_chctl_openreply) (struct xpc_channel *ch,
+				  unsigned long *irq_flags);
 
 enum xp_retval (*xpc_send_msg) (struct xpc_channel *ch, u32 flags,
 				void *payload, u16 payload_size, u8 notify_type,
@@ -302,7 +302,7 @@ xpc_hb_checker(void *ignore)
 
 			/*
 			 * We need to periodically recheck to ensure no
-			 * IPI/AMO pairs have been missed.  That check
+			 * IRQ/AMO pairs have been missed.  That check
 			 * must always reset xpc_hb_check_timeout.
 			 */
 			force_IRQ = 1;
@@ -378,7 +378,7 @@ xpc_channel_mgr(struct xpc_partition *pa
 	       atomic_read(&part->nchannels_active) > 0 ||
 	       !xpc_partition_disengaged(part)) {
 
-		xpc_process_channel_activity(part);
+		xpc_process_sent_chctl_flags(part);
 
 		/*
 		 * Wait until we've been requested to activate kthreads or
@@ -396,7 +396,7 @@ xpc_channel_mgr(struct xpc_partition *pa
 		atomic_dec(&part->channel_mgr_requests);
 		(void)wait_event_interruptible(part->channel_mgr_wq,
 				(atomic_read(&part->channel_mgr_requests) > 0 ||
-				 part->local_IPI_amo != 0 ||
+				 part->chctl.all_flags != 0 ||
 				 (part->act_state == XPC_P_DEACTIVATING &&
 				 atomic_read(&part->nchannels_active) == 0 &&
 				 xpc_partition_disengaged(part))));
@@ -753,16 +753,15 @@ xpc_disconnect_wait(int ch_number)
 		DBUG_ON(!(ch->flags & XPC_C_DISCONNECTED));
 		wakeup_channel_mgr = 0;
 
-		if (ch->delayed_IPI_flags) {
+		if (ch->delayed_chctl_flags) {
 			if (part->act_state != XPC_P_DEACTIVATING) {
-				spin_lock(&part->IPI_lock);
-				XPC_SET_IPI_FLAGS(part->local_IPI_amo,
-						  ch->number,
-						  ch->delayed_IPI_flags);
-				spin_unlock(&part->IPI_lock);
+				spin_lock(&part->chctl_lock);
+				part->chctl.flags[ch->number] |=
+				    ch->delayed_chctl_flags;
+				spin_unlock(&part->chctl_lock);
 				wakeup_channel_mgr = 1;
 			}
-			ch->delayed_IPI_flags = 0;
+			ch->delayed_chctl_flags = 0;
 		}
 
 		ch->flags &= ~XPC_C_WDISCONNECT;
diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-separate-chctl_flags-from-xpcs-notify-irq drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-separate-chctl_flags-from-xpcs-notify-irq
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -104,20 +104,20 @@ xpc_disallow_IPI_ops_sn2(void)
 }
 
 /*
- * The following set of macros and functions are used for the sending and
- * receiving of IPIs (also known as IRQs). There are two flavors of IPIs,
- * one that is associated with partition activity (SGI_XPC_ACTIVATE) and
- * the other that is associated with channel activity (SGI_XPC_NOTIFY).
+ * The following set of functions are used for the sending and receiving of
+ * IRQs (also known as IPIs). There are two flavors of IRQs, one that is
+ * associated with partition activity (SGI_XPC_ACTIVATE) and the other that
+ * is associated with channel activity (SGI_XPC_NOTIFY).
  */
 
 static u64
-xpc_IPI_receive_sn2(AMO_t *amo)
+xpc_receive_IRQ_amo_sn2(AMO_t *amo)
 {
 	return FETCHOP_LOAD_OP(TO_AMO((u64)&amo->variable), FETCHOP_CLEAR);
 }
 
 static enum xp_retval
-xpc_IPI_send_sn2(AMO_t *amo, u64 flag, int nasid, int phys_cpuid, int vector)
+xpc_send_IRQ_sn2(AMO_t *amo, u64 flag, int nasid, int phys_cpuid, int vector)
 {
 	int ret = 0;
 	unsigned long irq_flags;
@@ -131,7 +131,7 @@ xpc_IPI_send_sn2(AMO_t *amo, u64 flag, i
 	 * We must always use the nofault function regardless of whether we
 	 * are on a Shub 1.1 system or a Shub 1.2 slice 0xc processor. If we
 	 * didn't, we'd never know that the other partition is down and would
-	 * keep sending IPIs and AMOs to it until the heartbeat times out.
+	 * keep sending IRQs and AMOs to it until the heartbeat times out.
 	 */
 	ret = xp_nofault_PIOR((u64 *)GLOBAL_MMR_ADDR(NASID_GET(&amo->variable),
 						     xp_nofault_PIOR_target));
@@ -142,16 +142,16 @@ xpc_IPI_send_sn2(AMO_t *amo, u64 flag, i
 }
 
 static AMO_t *
-xpc_IPI_init_sn2(int index)
+xpc_init_IRQ_amo_sn2(int index)
 {
 	AMO_t *amo = xpc_vars->amos_page + index;
 
-	(void)xpc_IPI_receive_sn2(amo);	/* clear AMO variable */
+	(void)xpc_receive_IRQ_amo_sn2(amo);	/* clear AMO variable */
 	return amo;
 }
 
 /*
- * IPIs associated with SGI_XPC_ACTIVATE IRQ.
+ * Functions associated with SGI_XPC_ACTIVATE IRQ.
  */
 
 /*
@@ -166,23 +166,23 @@ xpc_handle_activate_IRQ_sn2(int irq, voi
 }
 
 /*
- * Flag the appropriate AMO variable and send an IPI to the specified node.
+ * Flag the appropriate AMO variable and send an IRQ to the specified node.
  */
 static void
-xpc_activate_IRQ_send_sn2(u64 amos_page_pa, int from_nasid, int to_nasid,
-		      int to_phys_cpuid)
+xpc_send_activate_IRQ_sn2(u64 amos_page_pa, int from_nasid, int to_nasid,
+			  int to_phys_cpuid)
 {
 	int w_index = XPC_NASID_W_INDEX(from_nasid);
 	int b_index = XPC_NASID_B_INDEX(from_nasid);
 	AMO_t *amos = (AMO_t *)__va(amos_page_pa +
 				    (XPC_ACTIVATE_IRQ_AMOS * sizeof(AMO_t)));
 
-	(void)xpc_IPI_send_sn2(&amos[w_index], (1UL << b_index), to_nasid,
+	(void)xpc_send_IRQ_sn2(&amos[w_index], (1UL << b_index), to_nasid,
 			       to_phys_cpuid, SGI_XPC_ACTIVATE);
 }
 
 static void
-xpc_activate_IRQ_send_local_sn2(int from_nasid)
+xpc_send_local_activate_IRQ_sn2(int from_nasid)
 {
 	int w_index = XPC_NASID_W_INDEX(from_nasid);
 	int b_index = XPC_NASID_B_INDEX(from_nasid);
@@ -197,29 +197,29 @@ xpc_activate_IRQ_send_local_sn2(int from
 }
 
 /*
- * IPIs associated with SGI_XPC_NOTIFY IRQ.
+ * Functions associated with SGI_XPC_NOTIFY IRQ.
  */
 
 /*
- * Check to see if there is any channel activity to/from the specified
- * partition.
+ * Check to see if any chctl flags were sent from the specified partition.
  */
 static void
-xpc_check_for_channel_activity_sn2(struct xpc_partition *part)
+xpc_check_for_sent_chctl_flags_sn2(struct xpc_partition *part)
 {
-	u64 IPI_amo;
+	union xpc_channel_ctl_flags chctl;
 	unsigned long irq_flags;
 
-	IPI_amo = xpc_IPI_receive_sn2(part->sn.sn2.local_IPI_amo_va);
-	if (IPI_amo == 0)
+	chctl.all_flags = xpc_receive_IRQ_amo_sn2(part->sn.sn2.
+						  local_chctl_amo_va);
+	if (chctl.all_flags == 0)
 		return;
 
-	spin_lock_irqsave(&part->IPI_lock, irq_flags);
-	part->local_IPI_amo |= IPI_amo;
-	spin_unlock_irqrestore(&part->IPI_lock, irq_flags);
+	spin_lock_irqsave(&part->chctl_lock, irq_flags);
+	part->chctl.all_flags |= chctl.all_flags;
+	spin_unlock_irqrestore(&part->chctl_lock, irq_flags);
 
-	dev_dbg(xpc_chan, "received IPI from partid=%d, IPI_amo=0x%lx\n",
-		XPC_PARTID(part), IPI_amo);
+	dev_dbg(xpc_chan, "received notify IRQ from partid=%d, chctl.all_flags="
+		"0x%lx\n", XPC_PARTID(part), chctl.all_flags);
 
 	xpc_wakeup_channel_mgr(part);
 }
@@ -228,17 +228,17 @@ xpc_check_for_channel_activity_sn2(struc
  * Handle the receipt of a SGI_XPC_NOTIFY IRQ by seeing whether the specified
  * partition actually sent it. Since SGI_XPC_NOTIFY IRQs may be shared by more
  * than one partition, we use an AMO_t structure per partition to indicate
- * whether a partition has sent an IPI or not.  If it has, then wake up the
+ * whether a partition has sent an IRQ or not.  If it has, then wake up the
  * associated kthread to handle it.
  *
- * All SGI_XPC_NOTIFY IRQs received by XPC are the result of IPIs sent by XPC
+ * All SGI_XPC_NOTIFY IRQs received by XPC are the result of IRQs sent by XPC
  * running on other partitions.
  *
  * Noteworthy Arguments:
  *
  *	irq - Interrupt ReQuest number. NOT USED.
  *
- *	dev_id - partid of IPI's potential sender.
+ *	dev_id - partid of IRQ's potential sender.
  */
 static irqreturn_t
 xpc_handle_notify_IRQ_sn2(int irq, void *dev_id)
@@ -249,7 +249,7 @@ xpc_handle_notify_IRQ_sn2(int irq, void 
 	DBUG_ON(partid < 0 || partid >= xp_max_npartitions);
 
 	if (xpc_part_ref(part)) {
-		xpc_check_for_channel_activity_sn2(part);
+		xpc_check_for_sent_chctl_flags_sn2(part);
 
 		xpc_part_deref(part);
 	}
@@ -257,45 +257,47 @@ xpc_handle_notify_IRQ_sn2(int irq, void 
 }
 
 /*
- * Check to see if xpc_handle_notify_IRQ_sn2() dropped any IPIs on the floor
- * because the write to their associated IPI amo completed after the IRQ/IPI
+ * Check to see if xpc_handle_notify_IRQ_sn2() dropped any IRQs on the floor
+ * because the write to their associated amo variable completed after the IRQ
  * was received.
  */
 static void
-xpc_dropped_notify_IRQ_check_sn2(struct xpc_partition *part)
+xpc_check_for_dropped_notify_IRQ_sn2(struct xpc_partition *part)
 {
 	struct xpc_partition_sn2 *part_sn2 = &part->sn.sn2;
 
 	if (xpc_part_ref(part)) {
-		xpc_check_for_channel_activity_sn2(part);
+		xpc_check_for_sent_chctl_flags_sn2(part);
 
 		part_sn2->dropped_notify_IRQ_timer.expires = jiffies +
-		    XPC_P_DROPPED_IPI_WAIT_INTERVAL;
+		    XPC_DROPPED_NOTIFY_IRQ_WAIT_INTERVAL;
 		add_timer(&part_sn2->dropped_notify_IRQ_timer);
 		xpc_part_deref(part);
 	}
 }
 
 /*
- * Send an IPI to the remote partition that is associated with the
+ * Send a notify IRQ to the remote partition that is associated with the
  * specified channel.
  */
 static void
-xpc_notify_IRQ_send_sn2(struct xpc_channel *ch, u8 ipi_flag,
-			char *ipi_flag_string, unsigned long *irq_flags)
+xpc_send_notify_IRQ_sn2(struct xpc_channel *ch, u8 chctl_flag,
+			char *chctl_flag_string, unsigned long *irq_flags)
 {
 	struct xpc_partition *part = &xpc_partitions[ch->partid];
 	struct xpc_partition_sn2 *part_sn2 = &part->sn.sn2;
+	union xpc_channel_ctl_flags chctl = { 0 };
 	enum xp_retval ret;
 
 	if (likely(part->act_state != XPC_P_DEACTIVATING)) {
-		ret = xpc_IPI_send_sn2(part_sn2->remote_IPI_amo_va,
-				       (u64)ipi_flag << (ch->number * 8),
-				       part_sn2->remote_IPI_nasid,
-				       part_sn2->remote_IPI_phys_cpuid,
+		chctl.flags[ch->number] = chctl_flag;
+		ret = xpc_send_IRQ_sn2(part_sn2->remote_chctl_amo_va,
+				       chctl.all_flags,
+				       part_sn2->notify_IRQ_nasid,
+				       part_sn2->notify_IRQ_phys_cpuid,
 				       SGI_XPC_NOTIFY);
 		dev_dbg(xpc_chan, "%s sent to partid=%d, channel=%d, ret=%d\n",
-			ipi_flag_string, ch->partid, ch->number, ret);
+			chctl_flag_string, ch->partid, ch->number, ret);
 		if (unlikely(ret != xpSuccess)) {
 			if (irq_flags != NULL)
 				spin_unlock_irqrestore(&ch->lock, *irq_flags);
@@ -306,78 +308,78 @@ xpc_notify_IRQ_send_sn2(struct xpc_chann
 	}
 }
 
-#define XPC_NOTIFY_IRQ_SEND_SN2(_ch, _ipi_f, _irq_f) \
-		xpc_notify_IRQ_send_sn2(_ch, _ipi_f, #_ipi_f, _irq_f)
+#define XPC_SEND_NOTIFY_IRQ_SN2(_ch, _ipi_f, _irq_f) \
+		xpc_send_notify_IRQ_sn2(_ch, _ipi_f, #_ipi_f, _irq_f)
 
 /*
  * Make it look like the remote partition, which is associated with the
- * specified channel, sent us an IPI. This faked IPI will be handled
- * by xpc_dropped_notify_IRQ_check_sn2().
+ * specified channel, sent us a notify IRQ. This faked IRQ will be handled
+ * by xpc_check_for_dropped_notify_IRQ_sn2().
  */
 static void
-xpc_notify_IRQ_send_local_sn2(struct xpc_channel *ch, u8 ipi_flag,
-			      char *ipi_flag_string)
+xpc_send_local_notify_IRQ_sn2(struct xpc_channel *ch, u8 chctl_flag,
+			      char *chctl_flag_string)
 {
 	struct xpc_partition *part = &xpc_partitions[ch->partid];
+	union xpc_channel_ctl_flags chctl = { 0 };
 
-	FETCHOP_STORE_OP(TO_AMO((u64)&part->sn.sn2.local_IPI_amo_va->variable),
-			 FETCHOP_OR, ((u64)ipi_flag << (ch->number * 8)));
+	chctl.flags[ch->number] = chctl_flag;
+	FETCHOP_STORE_OP(TO_AMO((u64)&part->sn.sn2.local_chctl_amo_va->
+				variable), FETCHOP_OR, chctl.all_flags);
 	dev_dbg(xpc_chan, "%s sent local from partid=%d, channel=%d\n",
-		ipi_flag_string, ch->partid, ch->number);
+		chctl_flag_string, ch->partid, ch->number);
 }
 
-#define XPC_NOTIFY_IRQ_SEND_LOCAL_SN2(_ch, _ipi_f) \
-		xpc_notify_IRQ_send_local_sn2(_ch, _ipi_f, #_ipi_f)
+#define XPC_SEND_LOCAL_NOTIFY_IRQ_SN2(_ch, _ipi_f) \
+		xpc_send_local_notify_IRQ_sn2(_ch, _ipi_f, #_ipi_f)
 
 static void
-xpc_send_channel_closerequest_sn2(struct xpc_channel *ch,
-				  unsigned long *irq_flags)
+xpc_send_chctl_closerequest_sn2(struct xpc_channel *ch,
+				unsigned long *irq_flags)
 {
 	struct xpc_openclose_args *args = ch->local_openclose_args;
 
 	args->reason = ch->reason;
-	XPC_NOTIFY_IRQ_SEND_SN2(ch, XPC_IPI_CLOSEREQUEST, irq_flags);
+	XPC_SEND_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_CLOSEREQUEST, irq_flags);
 }
 
 static void
-xpc_send_channel_closereply_sn2(struct xpc_channel *ch,
-				unsigned long *irq_flags)
+xpc_send_chctl_closereply_sn2(struct xpc_channel *ch, unsigned long *irq_flags)
 {
-	XPC_NOTIFY_IRQ_SEND_SN2(ch, XPC_IPI_CLOSEREPLY, irq_flags);
+	XPC_SEND_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_CLOSEREPLY, irq_flags);
 }
 
 static void
-xpc_send_channel_openrequest_sn2(struct xpc_channel *ch,
-				 unsigned long *irq_flags)
+xpc_send_chctl_openrequest_sn2(struct xpc_channel *ch, unsigned long *irq_flags)
 {
 	struct xpc_openclose_args *args = ch->local_openclose_args;
 
 	args->msg_size = ch->msg_size;
 	args->local_nentries = ch->local_nentries;
-	XPC_NOTIFY_IRQ_SEND_SN2(ch, XPC_IPI_OPENREQUEST, irq_flags);
+	XPC_SEND_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_OPENREQUEST, irq_flags);
 }
 
 static void
-xpc_send_channel_openreply_sn2(struct xpc_channel *ch, unsigned long *irq_flags)
+xpc_send_chctl_openreply_sn2(struct xpc_channel *ch, unsigned long *irq_flags)
 {
 	struct xpc_openclose_args *args = ch->local_openclose_args;
 
 	args->remote_nentries = ch->remote_nentries;
 	args->local_nentries = ch->local_nentries;
 	args->local_msgqueue_pa = __pa(ch->local_msgqueue);
-	XPC_NOTIFY_IRQ_SEND_SN2(ch, XPC_IPI_OPENREPLY, irq_flags);
+	XPC_SEND_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_OPENREPLY, irq_flags);
 }
 
 static void
-xpc_send_channel_msgrequest_sn2(struct xpc_channel *ch)
+xpc_send_chctl_msgrequest_sn2(struct xpc_channel *ch)
 {
-	XPC_NOTIFY_IRQ_SEND_SN2(ch, XPC_IPI_MSGREQUEST, NULL);
+	XPC_SEND_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_MSGREQUEST, NULL);
 }
 
 static void
-xpc_send_channel_local_msgrequest_sn2(struct xpc_channel *ch)
+xpc_send_chctl_local_msgrequest_sn2(struct xpc_channel *ch)
 {
-	XPC_NOTIFY_IRQ_SEND_LOCAL_SN2(ch, XPC_IPI_MSGREQUEST);
+	XPC_SEND_LOCAL_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_MSGREQUEST);
 }
 
 /*
@@ -402,7 +404,7 @@ xpc_indicate_partition_engaged_sn2(struc
 	 * We must always use the nofault function regardless of whether we
 	 * are on a Shub 1.1 system or a Shub 1.2 slice 0xc processor. If we
 	 * didn't, we'd never know that the other partition is down and would
-	 * keep sending IPIs and AMOs to it until the heartbeat times out.
+	 * keep sending IRQs and AMOs to it until the heartbeat times out.
 	 */
 	(void)xp_nofault_PIOR((u64 *)GLOBAL_MMR_ADDR(NASID_GET(&amo->
 							       variable),
@@ -429,7 +431,7 @@ xpc_indicate_partition_disengaged_sn2(st
 	 * We must always use the nofault function regardless of whether we
 	 * are on a Shub 1.1 system or a Shub 1.2 slice 0xc processor. If we
 	 * didn't, we'd never know that the other partition is down and would
-	 * keep sending IPIs and AMOs to it until the heartbeat times out.
+	 * keep sending IRQs and AMOs to it until the heartbeat times out.
 	 */
 	(void)xp_nofault_PIOR((u64 *)GLOBAL_MMR_ADDR(NASID_GET(&amo->
 							       variable),
@@ -441,7 +443,7 @@ xpc_indicate_partition_disengaged_sn2(st
 	 * Send activate IRQ to get other side to see that we've cleared our
 	 * bit in their engaged partitions AMO.
 	 */
-	xpc_activate_IRQ_send_sn2(part_sn2->remote_amos_page_pa,
+	xpc_send_activate_IRQ_sn2(part_sn2->remote_amos_page_pa,
 				  cnodeid_to_nasid(0),
 				  part_sn2->activate_IRQ_nasid,
 				  part_sn2->activate_IRQ_phys_cpuid);
@@ -595,11 +597,11 @@ xpc_rsvd_page_init_sn2(struct xpc_rsvd_p
 
 	/* initialize the activate IRQ related AMO variables */
 	for (i = 0; i < xp_nasid_mask_words; i++)
-		(void)xpc_IPI_init_sn2(XPC_ACTIVATE_IRQ_AMOS + i);
+		(void)xpc_init_IRQ_amo_sn2(XPC_ACTIVATE_IRQ_AMOS + i);
 
 	/* initialize the engaged remote partitions related AMO variables */
-	(void)xpc_IPI_init_sn2(XPC_ENGAGED_PARTITIONS_AMO);
-	(void)xpc_IPI_init_sn2(XPC_DEACTIVATE_REQUEST_AMO);
+	(void)xpc_init_IRQ_amo_sn2(XPC_ENGAGED_PARTITIONS_AMO);
+	(void)xpc_init_IRQ_amo_sn2(XPC_DEACTIVATE_REQUEST_AMO);
 
 	return xpSuccess;
 }
@@ -729,13 +731,13 @@ static void
 xpc_request_partition_activation_sn2(struct xpc_rsvd_page *remote_rp,
 				     u64 remote_rp_pa, int nasid)
 {
-	xpc_activate_IRQ_send_local_sn2(nasid);
+	xpc_send_local_activate_IRQ_sn2(nasid);
 }
 
 static void
 xpc_request_partition_reactivation_sn2(struct xpc_partition *part)
 {
-	xpc_activate_IRQ_send_local_sn2(part->sn.sn2.activate_IRQ_nasid);
+	xpc_send_local_activate_IRQ_sn2(part->sn.sn2.activate_IRQ_nasid);
 }
 
 static void
@@ -755,7 +757,7 @@ xpc_request_partition_deactivation_sn2(s
 	 * We must always use the nofault function regardless of whether we
 	 * are on a Shub 1.1 system or a Shub 1.2 slice 0xc processor. If we
 	 * didn't, we'd never know that the other partition is down and would
-	 * keep sending IPIs and AMOs to it until the heartbeat times out.
+	 * keep sending IRQs and AMOs to it until the heartbeat times out.
 	 */
 	(void)xp_nofault_PIOR((u64 *)GLOBAL_MMR_ADDR(NASID_GET(&amo->
 							       variable),
@@ -767,7 +769,7 @@ xpc_request_partition_deactivation_sn2(s
 	 * Send activate IRQ to get other side to see that we've set our
 	 * bit in their deactivate request AMO.
 	 */
-	xpc_activate_IRQ_send_sn2(part_sn2->remote_amos_page_pa,
+	xpc_send_activate_IRQ_sn2(part_sn2->remote_amos_page_pa,
 				  cnodeid_to_nasid(0),
 				  part_sn2->activate_IRQ_nasid,
 				  part_sn2->activate_IRQ_phys_cpuid);
@@ -789,7 +791,7 @@ xpc_cancel_partition_deactivation_reques
 	 * We must always use the nofault function regardless of whether we
 	 * are on a Shub 1.1 system or a Shub 1.2 slice 0xc processor. If we
 	 * didn't, we'd never know that the other partition is down and would
-	 * keep sending IPIs and AMOs to it until the heartbeat times out.
+	 * keep sending IRQs and AMOs to it until the heartbeat times out.
 	 */
 	(void)xp_nofault_PIOR((u64 *)GLOBAL_MMR_ADDR(NASID_GET(&amo->
 							       variable),
@@ -861,11 +863,11 @@ xpc_update_partition_info_sn2(struct xpc
 }
 
 /*
- * Prior code has determined the nasid which generated an IPI.  Inspect
- * that nasid to determine if its partition needs to be activated or
- * deactivated.
+ * Prior code has determined the nasid which generated a activate IRQ.
+ * Inspect that nasid to determine if its partition needs to be activated
+ * or deactivated.
  *
- * A partition is consider "awaiting activation" if our partition
+ * A partition is considered "awaiting activation" if our partition
  * flags indicate it is not active and it has a heartbeat.  A
  * partition is considered "awaiting deactivation" if our partition
  * flags indicate it is active but it has no heartbeat or it is not
@@ -997,7 +999,7 @@ xpc_identify_activate_IRQ_sender_sn2(voi
 		if (xpc_exiting)
 			break;
 
-		nasid_mask = xpc_IPI_receive_sn2(&act_amos[word]);
+		nasid_mask = xpc_receive_IRQ_amo_sn2(&act_amos[word]);
 		if (nasid_mask == 0) {
 			/* no IRQs from nasids in this variable */
 			continue;
@@ -1117,20 +1119,20 @@ xpc_setup_infrastructure_sn2(struct xpc_
 
 	part_sn2->remote_openclose_args_pa = 0;
 
-	part_sn2->local_IPI_amo_va = xpc_IPI_init_sn2(partid);
-	part->local_IPI_amo = 0;
-	spin_lock_init(&part->IPI_lock);
-
-	part_sn2->remote_IPI_nasid = 0;
-	part_sn2->remote_IPI_phys_cpuid = 0;
-	part_sn2->remote_IPI_amo_va = NULL;
+	part_sn2->local_chctl_amo_va = xpc_init_IRQ_amo_sn2(partid);
+	part->chctl.all_flags = 0;
+	spin_lock_init(&part->chctl_lock);
+
+	part_sn2->notify_IRQ_nasid = 0;
+	part_sn2->notify_IRQ_phys_cpuid = 0;
+	part_sn2->remote_chctl_amo_va = NULL;
 
 	atomic_set(&part->channel_mgr_requests, 1);
 	init_waitqueue_head(&part->channel_mgr_wq);
 
-	sprintf(part_sn2->IPI_owner, "xpc%02d", partid);
+	sprintf(part_sn2->notify_IRQ_owner, "xpc%02d", partid);
 	ret = request_irq(SGI_XPC_NOTIFY, xpc_handle_notify_IRQ_sn2,
-			  IRQF_SHARED, part_sn2->IPI_owner,
+			  IRQF_SHARED, part_sn2->notify_IRQ_owner,
 			  (void *)(u64)partid);
 	if (ret != 0) {
 		dev_err(xpc_chan, "can't register NOTIFY IRQ handler, "
@@ -1139,13 +1141,13 @@ xpc_setup_infrastructure_sn2(struct xpc_
 		goto out_5;
 	}
 
-	/* Setup a timer to check for dropped IPIs */
+	/* Setup a timer to check for dropped notify IRQs */
 	timer = &part_sn2->dropped_notify_IRQ_timer;
 	init_timer(timer);
 	timer->function =
-	    (void (*)(unsigned long))xpc_dropped_notify_IRQ_check_sn2;
+	    (void (*)(unsigned long))xpc_check_for_dropped_notify_IRQ_sn2;
 	timer->data = (unsigned long)part;
-	timer->expires = jiffies + XPC_P_DROPPED_IPI_WAIT_INTERVAL;
+	timer->expires = jiffies + XPC_DROPPED_NOTIFY_IRQ_WAIT_INTERVAL;
 	add_timer(timer);
 
 	part->nchannels = XPC_MAX_NCHANNELS;
@@ -1196,10 +1198,10 @@ xpc_setup_infrastructure_sn2(struct xpc_
 	xpc_vars_part[partid].GPs_pa = __pa(part_sn2->local_GPs);
 	xpc_vars_part[partid].openclose_args_pa =
 	    __pa(part->local_openclose_args);
-	xpc_vars_part[partid].IPI_amo_pa = __pa(part_sn2->local_IPI_amo_va);
+	xpc_vars_part[partid].chctl_amo_pa = __pa(part_sn2->local_chctl_amo_va);
 	cpuid = raw_smp_processor_id();	/* any CPU in this partition will do */
-	xpc_vars_part[partid].IPI_nasid = cpuid_to_nasid(cpuid);
-	xpc_vars_part[partid].IPI_phys_cpuid = cpu_physical_id(cpuid);
+	xpc_vars_part[partid].notify_IRQ_nasid = cpuid_to_nasid(cpuid);
+	xpc_vars_part[partid].notify_IRQ_phys_cpuid = cpu_physical_id(cpuid);
 	xpc_vars_part[partid].nchannels = part->nchannels;
 	xpc_vars_part[partid].magic = XPC_VP_MAGIC1;
 
@@ -1239,7 +1241,7 @@ xpc_teardown_infrastructure_sn2(struct x
 	 * processes by marking it as no longer setup. Then we make it
 	 * inaccessible to remote processes by clearing the XPC per partition
 	 * specific variable's magic # (which indicates that these variables
-	 * are no longer valid) and by ignoring all XPC notify IPIs sent to
+	 * are no longer valid) and by ignoring all XPC notify IRQs sent to
 	 * this partition.
 	 */
 
@@ -1275,7 +1277,7 @@ xpc_teardown_infrastructure_sn2(struct x
 	part_sn2->local_GPs = NULL;
 	kfree(part->channels);
 	part->channels = NULL;
-	part_sn2->local_IPI_amo_va = NULL;
+	part_sn2->local_chctl_amo_va = NULL;
 }
 
 /*
@@ -1370,7 +1372,7 @@ xpc_pull_remote_vars_part_sn2(struct xpc
 
 		if (pulled_entry->GPs_pa == 0 ||
 		    pulled_entry->openclose_args_pa == 0 ||
-		    pulled_entry->IPI_amo_pa == 0) {
+		    pulled_entry->chctl_amo_pa == 0) {
 
 			dev_err(xpc_chan, "partition %d's XPC vars_part for "
 				"partition %d are not valid\n", partid,
@@ -1383,10 +1385,11 @@ xpc_pull_remote_vars_part_sn2(struct xpc
 		part_sn2->remote_GPs_pa = pulled_entry->GPs_pa;
 		part_sn2->remote_openclose_args_pa =
 		    pulled_entry->openclose_args_pa;
-		part_sn2->remote_IPI_amo_va =
-		    (AMO_t *)__va(pulled_entry->IPI_amo_pa);
-		part_sn2->remote_IPI_nasid = pulled_entry->IPI_nasid;
-		part_sn2->remote_IPI_phys_cpuid = pulled_entry->IPI_phys_cpuid;
+		part_sn2->remote_chctl_amo_va =
+		    (AMO_t *)__va(pulled_entry->chctl_amo_pa);
+		part_sn2->notify_IRQ_nasid = pulled_entry->notify_IRQ_nasid;
+		part_sn2->notify_IRQ_phys_cpuid =
+		    pulled_entry->notify_IRQ_phys_cpuid;
 
 		if (part->nchannels > pulled_entry->nchannels)
 			part->nchannels = pulled_entry->nchannels;
@@ -1437,7 +1440,7 @@ xpc_make_first_contact_sn2(struct xpc_pa
 	 * Send activate IRQ to get other side to activate if they've not
 	 * already begun to do so.
 	 */
-	xpc_activate_IRQ_send_sn2(part_sn2->remote_amos_page_pa,
+	xpc_send_activate_IRQ_sn2(part_sn2->remote_amos_page_pa,
 				  cnodeid_to_nasid(0),
 				  part_sn2->activate_IRQ_nasid,
 				  part_sn2->activate_IRQ_phys_cpuid);
@@ -1462,28 +1465,28 @@ xpc_make_first_contact_sn2(struct xpc_pa
 }
 
 /*
- * Get the IPI flags and pull the openclose args and/or remote GPs as needed.
+ * Get the chctl flags and pull the openclose args and/or remote GPs as needed.
  */
 static u64
-xpc_get_IPI_flags_sn2(struct xpc_partition *part)
+xpc_get_chctl_all_flags_sn2(struct xpc_partition *part)
 {
 	struct xpc_partition_sn2 *part_sn2 = &part->sn.sn2;
 	unsigned long irq_flags;
-	u64 IPI_amo;
+	union xpc_channel_ctl_flags chctl;
 	enum xp_retval ret;
 
 	/*
-	 * See if there are any IPI flags to be handled.
+	 * See if there are any chctl flags to be handled.
 	 */
 
-	spin_lock_irqsave(&part->IPI_lock, irq_flags);
-	IPI_amo = part->local_IPI_amo;
-	if (IPI_amo != 0)
-		part->local_IPI_amo = 0;
+	spin_lock_irqsave(&part->chctl_lock, irq_flags);
+	chctl = part->chctl;
+	if (chctl.all_flags != 0)
+		part->chctl.all_flags = 0;
 
-	spin_unlock_irqrestore(&part->IPI_lock, irq_flags);
+	spin_unlock_irqrestore(&part->chctl_lock, irq_flags);
 
-	if (XPC_ANY_OPENCLOSE_IPI_FLAGS_SET(IPI_amo)) {
+	if (xpc_any_openclose_chctl_flags_set(&chctl)) {
 		ret = xpc_pull_remote_cachelines_sn2(part, part->
 						     remote_openclose_args,
 						     (void *)part_sn2->
@@ -1496,12 +1499,12 @@ xpc_get_IPI_flags_sn2(struct xpc_partiti
 				"partition %d, ret=%d\n", XPC_PARTID(part),
 				ret);
 
-			/* don't bother processing IPIs anymore */
-			IPI_amo = 0;
+			/* don't bother processing chctl flags anymore */
+			chctl.all_flags = 0;
 		}
 	}
 
-	if (XPC_ANY_MSG_IPI_FLAGS_SET(IPI_amo)) {
+	if (xpc_any_msg_chctl_flags_set(&chctl)) {
 		ret = xpc_pull_remote_cachelines_sn2(part, part_sn2->remote_GPs,
 						(void *)part_sn2->remote_GPs_pa,
 						     XPC_GP_SIZE);
@@ -1511,12 +1514,12 @@ xpc_get_IPI_flags_sn2(struct xpc_partiti
 			dev_dbg(xpc_chan, "failed to pull GPs from partition "
 				"%d, ret=%d\n", XPC_PARTID(part), ret);
 
-			/* don't bother processing IPIs anymore */
-			IPI_amo = 0;
+			/* don't bother processing chctl flags anymore */
+			chctl.all_flags = 0;
 		}
 	}
 
-	return IPI_amo;
+	return chctl.all_flags;
 }
 
 /*
@@ -1610,7 +1613,7 @@ xpc_clear_remote_msgqueue_flags_sn2(stru
 }
 
 static void
-xpc_process_msg_IPI_sn2(struct xpc_partition *part, int ch_number)
+xpc_process_msg_chctl_flags_sn2(struct xpc_partition *part, int ch_number)
 {
 	struct xpc_channel *ch = &part->channels[ch_number];
 	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
@@ -1827,8 +1830,8 @@ xpc_get_deliverable_msg_sn2(struct xpc_c
 
 /*
  * Now we actually send the messages that are ready to be sent by advancing
- * the local message queue's Put value and then send an IPI to the recipient
- * partition.
+ * the local message queue's Put value and then send a chctl msgrequest to the
+ * recipient partition.
  */
 static void
 xpc_send_msgs_sn2(struct xpc_channel *ch, s64 initial_put)
@@ -1836,7 +1839,7 @@ xpc_send_msgs_sn2(struct xpc_channel *ch
 	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
 	struct xpc_msg *msg;
 	s64 put = initial_put + 1;
-	int send_IPI = 0;
+	int send_msgrequest = 0;
 
 	while (1) {
 
@@ -1871,7 +1874,7 @@ xpc_send_msgs_sn2(struct xpc_channel *ch
 		dev_dbg(xpc_chan, "local_GP->put changed to %ld, partid=%d, "
 			"channel=%d\n", put, ch->partid, ch->number);
 
-		send_IPI = 1;
+		send_msgrequest = 1;
 
 		/*
 		 * We need to ensure that the message referenced by
@@ -1881,8 +1884,8 @@ xpc_send_msgs_sn2(struct xpc_channel *ch
 		initial_put = put;
 	}
 
-	if (send_IPI)
-		xpc_send_channel_msgrequest_sn2(ch);
+	if (send_msgrequest)
+		xpc_send_chctl_msgrequest_sn2(ch);
 }
 
 /*
@@ -1929,13 +1932,13 @@ xpc_allocate_msg_sn2(struct xpc_channel 
 		 * There aren't any available msg entries at this time.
 		 *
 		 * In waiting for a message entry to become available,
-		 * we set a timeout in case the other side is not
-		 * sending completion IPIs. This lets us fake an IPI
-		 * that will cause the IPI handler to fetch the latest
-		 * GP values as if an IPI was sent by the other side.
+		 * we set a timeout in case the other side is not sending
+		 * completion interrupts. This lets us fake a notify IRQ
+		 * that will cause the notify IRQ handler to fetch the latest
+		 * GP values as if an interrupt was sent by the other side.
 		 */
 		if (ret == xpTimeout)
-			xpc_send_channel_local_msgrequest_sn2(ch);
+			xpc_send_chctl_local_msgrequest_sn2(ch);
 
 		if (flags & XPC_NOWAIT)
 			return xpNoWait;
@@ -1962,8 +1965,8 @@ xpc_allocate_msg_sn2(struct xpc_channel 
 
 /*
  * Common code that does the actual sending of the message by advancing the
- * local message queue's Put value and sends an IPI to the partition the
- * message is being sent to.
+ * local message queue's Put value and sends a chctl msgrequest to the
+ * partition the message is being sent to.
  */
 static enum xp_retval
 xpc_send_msg_sn2(struct xpc_channel *ch, u32 flags, void *payload,
@@ -2055,7 +2058,7 @@ out_1:
 /*
  * Now we actually acknowledge the messages that have been delivered and ack'd
  * by advancing the cached remote message queue's Get value and if requested
- * send an IPI to the message sender's partition.
+ * send a chctl msgrequest to the message sender's partition.
  */
 static void
 xpc_acknowledge_msgs_sn2(struct xpc_channel *ch, s64 initial_get, u8 msg_flags)
@@ -2063,7 +2066,7 @@ xpc_acknowledge_msgs_sn2(struct xpc_chan
 	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
 	struct xpc_msg *msg;
 	s64 get = initial_get + 1;
-	int send_IPI = 0;
+	int send_msgrequest = 0;
 
 	while (1) {
 
@@ -2099,7 +2102,7 @@ xpc_acknowledge_msgs_sn2(struct xpc_chan
 		dev_dbg(xpc_chan, "local_GP->get changed to %ld, partid=%d, "
 			"channel=%d\n", get, ch->partid, ch->number);
 
-		send_IPI = (msg_flags & XPC_M_INTERRUPT);
+		send_msgrequest = (msg_flags & XPC_M_INTERRUPT);
 
 		/*
 		 * We need to ensure that the message referenced by
@@ -2109,8 +2112,8 @@ xpc_acknowledge_msgs_sn2(struct xpc_chan
 		initial_get = get;
 	}
 
-	if (send_IPI)
-		xpc_send_channel_msgrequest_sn2(ch);
+	if (send_msgrequest)
+		xpc_send_chctl_msgrequest_sn2(ch);
 }
 
 static void
@@ -2168,9 +2171,9 @@ xpc_init_sn2(void)
 	xpc_setup_infrastructure = xpc_setup_infrastructure_sn2;
 	xpc_teardown_infrastructure = xpc_teardown_infrastructure_sn2;
 	xpc_make_first_contact = xpc_make_first_contact_sn2;
-	xpc_get_IPI_flags = xpc_get_IPI_flags_sn2;
+	xpc_get_chctl_all_flags = xpc_get_chctl_all_flags_sn2;
 	xpc_notify_senders_of_disconnect = xpc_notify_senders_of_disconnect_sn2;
-	xpc_process_msg_IPI = xpc_process_msg_IPI_sn2;
+	xpc_process_msg_chctl_flags = xpc_process_msg_chctl_flags_sn2;
 	xpc_n_of_deliverable_msgs = xpc_n_of_deliverable_msgs_sn2;
 	xpc_get_deliverable_msg = xpc_get_deliverable_msg_sn2;
 
@@ -2181,10 +2184,10 @@ xpc_init_sn2(void)
 	    xpc_indicate_partition_disengaged_sn2;
 	xpc_assume_partition_disengaged = xpc_assume_partition_disengaged_sn2;
 
-	xpc_send_channel_closerequest = xpc_send_channel_closerequest_sn2;
-	xpc_send_channel_closereply = xpc_send_channel_closereply_sn2;
-	xpc_send_channel_openrequest = xpc_send_channel_openrequest_sn2;
-	xpc_send_channel_openreply = xpc_send_channel_openreply_sn2;
+	xpc_send_chctl_closerequest = xpc_send_chctl_closerequest_sn2;
+	xpc_send_chctl_closereply = xpc_send_chctl_closereply_sn2;
+	xpc_send_chctl_openrequest = xpc_send_chctl_openrequest_sn2;
+	xpc_send_chctl_openreply = xpc_send_chctl_openreply_sn2;
 
 	xpc_send_msg = xpc_send_msg_sn2;
 	xpc_received_msg = xpc_received_msg_sn2;
diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-separate-chctl_flags-from-xpcs-notify-irq drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-separate-chctl_flags-from-xpcs-notify-irq
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -26,7 +26,7 @@ static DECLARE_BITMAP(xpc_heartbeating_t
 static void *xpc_activate_mq;
 
 static void
-xpc_IPI_send_local_activate_uv(struct xpc_partition *part)
+xpc_send_local_activate_IRQ_uv(struct xpc_partition *part)
 {
 	/*
 	 * >>> make our side think that the remote parition sent an activate
@@ -75,13 +75,13 @@ xpc_request_partition_activation_uv(stru
  * >>>	part->sn.uv.activate_mq_gpa = remote_rp->sn.activate_mq_gpa;
  */
 
-	xpc_IPI_send_local_activate_uv(part);
+	xpc_send_local_activate_IRQ_uv(part);
 }
 
 static void
 xpc_request_partition_reactivation_uv(struct xpc_partition *part)
 {
-	xpc_IPI_send_local_activate_uv(part);
+	xpc_send_local_activate_IRQ_uv(part);
 }
 
 /*
@@ -114,7 +114,7 @@ xpc_make_first_contact_uv(struct xpc_par
 }
 
 static u64
-xpc_get_IPI_flags_uv(struct xpc_partition *part)
+xpc_get_chctl_all_flags_uv(struct xpc_partition *part)
 {
 	/* >>> this function needs fleshing out */
 	return 0UL;
@@ -140,7 +140,7 @@ xpc_init_uv(void)
 	xpc_setup_infrastructure = xpc_setup_infrastructure_uv;
 	xpc_teardown_infrastructure = xpc_teardown_infrastructure_uv;
 	xpc_make_first_contact = xpc_make_first_contact_uv;
-	xpc_get_IPI_flags = xpc_get_IPI_flags_uv;
+	xpc_get_chctl_all_flags = xpc_get_chctl_all_flags_uv;
 	xpc_get_deliverable_msg = xpc_get_deliverable_msg_uv;
 }
 
_

Patches currently in -mm which might be from dcn@sgi.com are

origin.patch

