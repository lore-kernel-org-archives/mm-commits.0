From: akpm@linux-foundation.org
Subject: + sgi-xp-setup-the-notify-gru-message-queue.patch added to -mm tree
Date: Sat, 12 Jul 2008 23:10:52 -0700
Message-ID: <200807130610.m6D6Aqos007359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014AbYGMGK5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 02:10:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dcn@sgi.com, steiner@sgi.com, tony.luck@intel.com


The patch titled
     sgi-xp: setup the notify GRU message queue
has been added to the -mm tree.  Its filename is
     sgi-xp-setup-the-notify-gru-message-queue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp: setup the notify GRU message queue
From: Dean Nelson <dcn@sgi.com>

Setup the notify GRU message queue that is used for sending user messages
on UV systems.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xp.h          |   45 -
 drivers/misc/sgi-xp/xp_main.c     |    7 
 drivers/misc/sgi-xp/xpc.h         |  140 +++-
 drivers/misc/sgi-xp/xpc_channel.c |   63 -
 drivers/misc/sgi-xp/xpc_main.c    |   21 
 drivers/misc/sgi-xp/xpc_sn2.c     |  178 ++---
 drivers/misc/sgi-xp/xpc_uv.c      |  943 ++++++++++++++++++++++------
 drivers/misc/sgi-xp/xpnet.c       |   11 
 8 files changed, 1028 insertions(+), 380 deletions(-)

diff -puN drivers/misc/sgi-xp/xp.h~sgi-xp-setup-the-notify-gru-message-queue drivers/misc/sgi-xp/xp.h
--- a/drivers/misc/sgi-xp/xp.h~sgi-xp-setup-the-notify-gru-message-queue
+++ a/drivers/misc/sgi-xp/xp.h
@@ -87,39 +87,18 @@
 #endif
 
 /*
- * The format of an XPC message is as follows:
- *
- *      +-------+--------------------------------+
- *      | flags |////////////////////////////////|
- *      +-------+--------------------------------+
- *      |             message #                  |
- *      +----------------------------------------+
- *      |     payload (user-defined message)     |
- *      |                                        |
- *         		:
- *      |                                        |
- *      +----------------------------------------+
- *
- * The size of the payload is defined by the user via xpc_connect(). A user-
- * defined message resides in the payload area.
- *
- * The size of a message entry (within a message queue) must be a cacheline
- * sized multiple in order to facilitate the BTE transfer of messages from one
- * message queue to another. A macro, XPC_MSG_SIZE(), is provided for the user
+ * Define macro, XPC_MSG_SIZE(), is provided for the user
  * that wants to fit as many msg entries as possible in a given memory size
  * (e.g. a memory page).
  */
-struct xpc_msg {
-	u8 flags;		/* FOR XPC INTERNAL USE ONLY */
-	u8 reserved[7];		/* FOR XPC INTERNAL USE ONLY */
-	s64 number;		/* FOR XPC INTERNAL USE ONLY */
-
-	u64 payload;		/* user defined portion of message */
-};
+#define XPC_MSG_MAX_SIZE	128
+#define XPC_MSG_HDR_MAX_SIZE	16
+#define XPC_MSG_PAYLOAD_MAX_SIZE (XPC_MSG_MAX_SIZE - XPC_MSG_HDR_MAX_SIZE)
 
-#define XPC_MSG_PAYLOAD_OFFSET	(u64) (&((struct xpc_msg *)0)->payload)
 #define XPC_MSG_SIZE(_payload_size) \
-		L1_CACHE_ALIGN(XPC_MSG_PAYLOAD_OFFSET + (_payload_size))
+				ALIGN(XPC_MSG_HDR_MAX_SIZE + (_payload_size), \
+				      is_uv() ? 64 : 128)
+
 
 /*
  * Define the return values and values passed to user's callout functions.
@@ -210,7 +189,10 @@ enum xp_retval {
 	xpGruCopyError,		/* 58: gru_copy_gru() returned error */
 	xpGruSendMqError,	/* 59: gru send message queue related error */
 
-	xpUnknownReason		/* 60: unknown reason - must be last in enum */
+	xpBadChannelNumber,	/* 60: invalid channel number */
+	xpBadMsgType,		/* 60: invalid message type */
+
+	xpUnknownReason		/* 61: unknown reason - must be last in enum */
 };
 
 /*
@@ -261,6 +243,9 @@ typedef void (*xpc_channel_func) (enum x
  * calling xpc_received().
  *
  * All other reason codes indicate failure.
+ *
+ * NOTE: The user defined function must be callable by an interrupt handler
+ *       and thus cannot block.
  */
 typedef void (*xpc_notify_func) (enum xp_retval reason, short partid,
 				 int ch_number, void *key);
@@ -284,7 +269,7 @@ struct xpc_registration {
 	xpc_channel_func func;	/* function to call */
 	void *key;		/* pointer to user's key */
 	u16 nentries;		/* #of msg entries in local msg queue */
-	u16 msg_size;		/* message queue's message size */
+	u16 entry_size;		/* message queue's message entry size */
 	u32 assigned_limit;	/* limit on #of assigned kthreads */
 	u32 idle_limit;		/* limit on #of idle kthreads */
 } ____cacheline_aligned;
diff -puN drivers/misc/sgi-xp/xp_main.c~sgi-xp-setup-the-notify-gru-message-queue drivers/misc/sgi-xp/xp_main.c
--- a/drivers/misc/sgi-xp/xp_main.c~sgi-xp-setup-the-notify-gru-message-queue
+++ a/drivers/misc/sgi-xp/xp_main.c
@@ -154,6 +154,9 @@ xpc_connect(int ch_number, xpc_channel_f
 	DBUG_ON(func == NULL);
 	DBUG_ON(assigned_limit == 0 || idle_limit > assigned_limit);
 
+	if (XPC_MSG_SIZE(payload_size) > XPC_MSG_MAX_SIZE)
+		return xpPayloadTooBig;
+
 	registration = &xpc_registrations[ch_number];
 
 	if (mutex_lock_interruptible(&registration->mutex) != 0)
@@ -166,7 +169,7 @@ xpc_connect(int ch_number, xpc_channel_f
 	}
 
 	/* register the channel for connection */
-	registration->msg_size = XPC_MSG_SIZE(payload_size);
+	registration->entry_size = XPC_MSG_SIZE(payload_size);
 	registration->nentries = nentries;
 	registration->assigned_limit = assigned_limit;
 	registration->idle_limit = idle_limit;
@@ -220,7 +223,7 @@ xpc_disconnect(int ch_number)
 	registration->func = NULL;
 	registration->key = NULL;
 	registration->nentries = 0;
-	registration->msg_size = 0;
+	registration->entry_size = 0;
 	registration->assigned_limit = 0;
 	registration->idle_limit = 0;
 
diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xp-setup-the-notify-gru-message-queue drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xp-setup-the-notify-gru-message-queue
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -181,8 +181,8 @@ struct xpc_vars_part_sn2 {
 				  xpc_nasid_mask_nlongs))
 
 /*
- * The activate_mq is used to send/receive messages that affect XPC's heartbeat,
- * partition active state, and channel state. This is UV only.
+ * The activate_mq is used to send/receive GRU messages that affect XPC's
+ * heartbeat, partition active state, and channel state. This is UV only.
  */
 struct xpc_activate_mq_msghdr_uv {
 	short partid;		/* sender's partid */
@@ -209,45 +209,45 @@ struct xpc_activate_mq_msghdr_uv {
 #define XPC_ACTIVATE_MQ_MSG_MARK_DISENGAGED_UV		11
 
 struct xpc_activate_mq_msg_uv {
-	struct xpc_activate_mq_msghdr_uv header;
+	struct xpc_activate_mq_msghdr_uv hdr;
 };
 
 struct xpc_activate_mq_msg_heartbeat_req_uv {
-	struct xpc_activate_mq_msghdr_uv header;
+	struct xpc_activate_mq_msghdr_uv hdr;
 	u64 heartbeat;
 };
 
 struct xpc_activate_mq_msg_activate_req_uv {
-	struct xpc_activate_mq_msghdr_uv header;
+	struct xpc_activate_mq_msghdr_uv hdr;
 	unsigned long rp_gpa;
 	unsigned long activate_mq_gpa;
 };
 
 struct xpc_activate_mq_msg_deactivate_req_uv {
-	struct xpc_activate_mq_msghdr_uv header;
+	struct xpc_activate_mq_msghdr_uv hdr;
 	enum xp_retval reason;
 };
 
 struct xpc_activate_mq_msg_chctl_closerequest_uv {
-	struct xpc_activate_mq_msghdr_uv header;
+	struct xpc_activate_mq_msghdr_uv hdr;
 	short ch_number;
 	enum xp_retval reason;
 };
 
 struct xpc_activate_mq_msg_chctl_closereply_uv {
-	struct xpc_activate_mq_msghdr_uv header;
+	struct xpc_activate_mq_msghdr_uv hdr;
 	short ch_number;
 };
 
 struct xpc_activate_mq_msg_chctl_openrequest_uv {
-	struct xpc_activate_mq_msghdr_uv header;
+	struct xpc_activate_mq_msghdr_uv hdr;
 	short ch_number;
-	short msg_size;		/* size of notify_mq's messages */
+	short entry_size;	/* size of notify_mq's GRU messages */
 	short local_nentries;	/* ??? Is this needed? What is? */
 };
 
 struct xpc_activate_mq_msg_chctl_openreply_uv {
-	struct xpc_activate_mq_msghdr_uv header;
+	struct xpc_activate_mq_msghdr_uv hdr;
 	short ch_number;
 	short remote_nentries;	/* ??? Is this needed? What is? */
 	short local_nentries;	/* ??? Is this needed? What is? */
@@ -284,7 +284,7 @@ struct xpc_gp_sn2 {
  */
 struct xpc_openclose_args {
 	u16 reason;		/* reason why channel is closing */
-	u16 msg_size;		/* sizeof each message entry */
+	u16 entry_size;		/* sizeof each message entry */
 	u16 remote_nentries;	/* #of message entries in remote msg queue */
 	u16 local_nentries;	/* #of message entries in local msg queue */
 	unsigned long local_msgqueue_pa; /* phys addr of local message queue */
@@ -294,22 +294,79 @@ struct xpc_openclose_args {
 	      L1_CACHE_ALIGN(sizeof(struct xpc_openclose_args) * \
 	      XPC_MAX_NCHANNELS)
 
-/* struct xpc_msg flags */
 
-#define	XPC_M_DONE		0x01	/* msg has been received/consumed */
-#define	XPC_M_READY		0x02	/* msg is ready to be sent */
-#define	XPC_M_INTERRUPT		0x04	/* send interrupt when msg consumed */
+/*
+ * Structures to define a fifo singly-linked list.
+ */
+
+struct xpc_fifo_entry_uv {
+	struct xpc_fifo_entry_uv *next;
+};
+
+struct xpc_fifo_head_uv {
+	struct xpc_fifo_entry_uv *first;
+	struct xpc_fifo_entry_uv *last;
+	spinlock_t lock;
+	int n_entries;
+};
+
+/*
+ * Define a sn2 styled message.
+ *
+ * A user-defined message resides in the payload area. The max size of the
+ * payload is defined by the user via xpc_connect().
+ *
+ * The size of a message entry (within a message queue) must be a 128-byte
+ * cacheline sized multiple in order to facilitate the BTE transfer of messages
+ * from one message queue to another.
+ */
+struct xpc_msg_sn2 {
+	u8 flags;		/* FOR XPC INTERNAL USE ONLY */
+	u8 reserved[7];		/* FOR XPC INTERNAL USE ONLY */
+	s64 number;		/* FOR XPC INTERNAL USE ONLY */
+
+	u64 payload;		/* user defined portion of message */
+};
+
+/* struct xpc_msg_sn2 flags */
+
+#define	XPC_M_SN2_DONE		0x01	/* msg has been received/consumed */
+#define	XPC_M_SN2_READY		0x02	/* msg is ready to be sent */
+#define	XPC_M_SN2_INTERRUPT	0x04	/* send interrupt when msg consumed */
+
+/*
+ * The format of a uv XPC notify_mq GRU message is as follows:
+ *
+ * A user-defined message resides in the payload area. The max size of the
+ * payload is defined by the user via xpc_connect().
+ *
+ * The size of a message (payload and header) sent via the GRU must be either 1
+ * or 2 GRU_CACHE_LINE_BYTES in length.
+ */
 
-#define XPC_MSG_ADDRESS(_payload) \
-		((struct xpc_msg *)((u8 *)(_payload) - XPC_MSG_PAYLOAD_OFFSET))
+struct xpc_notify_mq_msghdr_uv {
+	union {
+		unsigned int gru_msg_hdr;	/* FOR GRU INTERNAL USE ONLY */
+		struct xpc_fifo_entry_uv next;	/* FOR XPC INTERNAL USE ONLY */
+	} u;
+	short partid;		/* FOR XPC INTERNAL USE ONLY */
+	u8 ch_number;		/* FOR XPC INTERNAL USE ONLY */
+	u8 size;		/* FOR XPC INTERNAL USE ONLY */
+	unsigned int msg_slot_number;	/* FOR XPC INTERNAL USE ONLY */
+};
+
+struct xpc_notify_mq_msg_uv {
+	struct xpc_notify_mq_msghdr_uv hdr;
+	unsigned long payload;
+};
 
 /*
- * Defines notify entry.
+ * Define sn2's notify entry.
  *
  * This is used to notify a message's sender that their message was received
  * and consumed by the intended recipient.
  */
-struct xpc_notify {
+struct xpc_notify_sn2 {
 	u8 type;		/* type of notification */
 
 	/* the following two fields are only used if type == XPC_N_CALL */
@@ -317,9 +374,20 @@ struct xpc_notify {
 	void *key;		/* pointer to user's key */
 };
 
-/* struct xpc_notify type of notification */
+/* struct xpc_notify_sn2 type of notification */
 
-#define	XPC_N_CALL		0x01	/* notify function provided by user */
+#define	XPC_N_CALL	0x01	/* notify function provided by user */
+
+/*
+ * Define uv's version of the notify entry. It additionally is used to allocate
+ * a msg slot on the remote partition into which is copied a sent message.
+ */
+struct xpc_send_msg_slot_uv {
+	struct xpc_fifo_entry_uv next;
+	unsigned int msg_slot_number;
+	xpc_notify_func func;	/* user's notify function */
+	void *key;		/* pointer to user's key */
+};
 
 /*
  * Define the structure that manages all the stuff required by a channel. In
@@ -409,14 +477,14 @@ struct xpc_channel_sn2 {
 					     /* opening or closing of channel */
 
 	void *local_msgqueue_base;	/* base address of kmalloc'd space */
-	struct xpc_msg *local_msgqueue;	/* local message queue */
+	struct xpc_msg_sn2 *local_msgqueue;	/* local message queue */
 	void *remote_msgqueue_base;	/* base address of kmalloc'd space */
-	struct xpc_msg *remote_msgqueue; /* cached copy of remote partition's */
-					 /* local message queue */
+	struct xpc_msg_sn2 *remote_msgqueue; /* cached copy of remote */
+					   /* partition's local message queue */
 	unsigned long remote_msgqueue_pa; /* phys addr of remote partition's */
 					  /* local message queue */
 
-	struct xpc_notify *notify_queue;    /* notify queue for messages sent */
+	struct xpc_notify_sn2 *notify_queue;/* notify queue for messages sent */
 
 	/* various flavors of local and remote Get/Put values */
 
@@ -432,6 +500,12 @@ struct xpc_channel_sn2 {
 struct xpc_channel_uv {
 	unsigned long remote_notify_mq_gpa;	/* gru phys address of remote */
 						/* partition's notify mq */
+
+	struct xpc_send_msg_slot_uv *send_msg_slots;
+	struct xpc_notify_mq_msg_uv *recv_msg_slots;
+
+	struct xpc_fifo_head_uv msg_slot_free_list;
+	struct xpc_fifo_head_uv recv_msg_list;	/* deliverable payloads */
 };
 
 struct xpc_channel {
@@ -444,7 +518,7 @@ struct xpc_channel {
 
 	u16 number;		/* channel # */
 
-	u16 msg_size;		/* sizeof each msg entry */
+	u16 entry_size;		/* sizeof each msg entry */
 	u16 local_nentries;	/* #of msg entries in local msg queue */
 	u16 remote_nentries;	/* #of msg entries in remote msg queue */
 
@@ -733,8 +807,8 @@ extern enum xp_retval (*xpc_setup_msg_st
 extern void (*xpc_teardown_msg_structures) (struct xpc_channel *);
 extern void (*xpc_notify_senders_of_disconnect) (struct xpc_channel *);
 extern void (*xpc_process_msg_chctl_flags) (struct xpc_partition *, int);
-extern int (*xpc_n_of_deliverable_msgs) (struct xpc_channel *);
-extern struct xpc_msg *(*xpc_get_deliverable_msg) (struct xpc_channel *);
+extern int (*xpc_n_of_deliverable_payloads) (struct xpc_channel *);
+extern void *(*xpc_get_deliverable_payload) (struct xpc_channel *);
 extern void (*xpc_request_partition_activation) (struct xpc_rsvd_page *,
 						 unsigned long, int);
 extern void (*xpc_request_partition_reactivation) (struct xpc_partition *);
@@ -762,9 +836,9 @@ extern void (*xpc_send_chctl_openreply) 
 extern void (*xpc_save_remote_msgqueue_pa) (struct xpc_channel *,
 					    unsigned long);
 
-extern enum xp_retval (*xpc_send_msg) (struct xpc_channel *, u32, void *, u16,
-				       u8, xpc_notify_func, void *);
-extern void (*xpc_received_msg) (struct xpc_channel *, struct xpc_msg *);
+extern enum xp_retval (*xpc_send_payload) (struct xpc_channel *, u32, void *,
+					   u16, u8, xpc_notify_func, void *);
+extern void (*xpc_received_payload) (struct xpc_channel *, void *);
 
 /* found in xpc_sn2.c */
 extern int xpc_init_sn2(void);
@@ -805,7 +879,7 @@ extern enum xp_retval xpc_initiate_send_
 extern void xpc_initiate_received(short, int, void *);
 extern void xpc_process_sent_chctl_flags(struct xpc_partition *);
 extern void xpc_connected_callout(struct xpc_channel *);
-extern void xpc_deliver_msg(struct xpc_channel *);
+extern void xpc_deliver_payload(struct xpc_channel *);
 extern void xpc_disconnect_channel(const int, struct xpc_channel *,
 				   enum xp_retval, unsigned long *);
 extern void xpc_disconnect_callout(struct xpc_channel *, enum xp_retval);
diff -puN drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-setup-the-notify-gru-message-queue drivers/misc/sgi-xp/xpc_channel.c
--- a/drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-setup-the-notify-gru-message-queue
+++ a/drivers/misc/sgi-xp/xpc_channel.c
@@ -139,7 +139,7 @@ xpc_process_disconnect(struct xpc_channe
 
 	ch->func = NULL;
 	ch->key = NULL;
-	ch->msg_size = 0;
+	ch->entry_size = 0;
 	ch->local_nentries = 0;
 	ch->remote_nentries = 0;
 	ch->kthreads_assigned_limit = 0;
@@ -315,9 +315,9 @@ again:
 
 	if (chctl_flags & XPC_CHCTL_OPENREQUEST) {
 
-		dev_dbg(xpc_chan, "XPC_CHCTL_OPENREQUEST (msg_size=%d, "
+		dev_dbg(xpc_chan, "XPC_CHCTL_OPENREQUEST (entry_size=%d, "
 			"local_nentries=%d) received from partid=%d, "
-			"channel=%d\n", args->msg_size, args->local_nentries,
+			"channel=%d\n", args->entry_size, args->local_nentries,
 			ch->partid, ch->number);
 
 		if (part->act_state == XPC_P_AS_DEACTIVATING ||
@@ -338,10 +338,10 @@ again:
 
 		/*
 		 * The meaningful OPENREQUEST connection state fields are:
-		 *      msg_size = size of channel's messages in bytes
+		 *      entry_size = size of channel's messages in bytes
 		 *      local_nentries = remote partition's local_nentries
 		 */
-		if (args->msg_size == 0 || args->local_nentries == 0) {
+		if (args->entry_size == 0 || args->local_nentries == 0) {
 			/* assume OPENREQUEST was delayed by mistake */
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
 			return;
@@ -351,14 +351,14 @@ again:
 		ch->remote_nentries = args->local_nentries;
 
 		if (ch->flags & XPC_C_OPENREQUEST) {
-			if (args->msg_size != ch->msg_size) {
+			if (args->entry_size != ch->entry_size) {
 				XPC_DISCONNECT_CHANNEL(ch, xpUnequalMsgSizes,
 						       &irq_flags);
 				spin_unlock_irqrestore(&ch->lock, irq_flags);
 				return;
 			}
 		} else {
-			ch->msg_size = args->msg_size;
+			ch->entry_size = args->entry_size;
 
 			XPC_SET_REASON(ch, 0, 0);
 			ch->flags &= ~XPC_C_DISCONNECTED;
@@ -473,7 +473,7 @@ xpc_connect_channel(struct xpc_channel *
 	ch->local_nentries = registration->nentries;
 
 	if (ch->flags & XPC_C_ROPENREQUEST) {
-		if (registration->msg_size != ch->msg_size) {
+		if (registration->entry_size != ch->entry_size) {
 			/* the local and remote sides aren't the same */
 
 			/*
@@ -492,7 +492,7 @@ xpc_connect_channel(struct xpc_channel *
 			return xpUnequalMsgSizes;
 		}
 	} else {
-		ch->msg_size = registration->msg_size;
+		ch->entry_size = registration->entry_size;
 
 		XPC_SET_REASON(ch, 0, 0);
 		ch->flags &= ~XPC_C_DISCONNECTED;
@@ -859,8 +859,8 @@ xpc_initiate_send(short partid, int ch_n
 	DBUG_ON(payload == NULL);
 
 	if (xpc_part_ref(part)) {
-		ret = xpc_send_msg(&part->channels[ch_number], flags, payload,
-				   payload_size, 0, NULL, NULL);
+		ret = xpc_send_payload(&part->channels[ch_number], flags,
+				       payload, payload_size, 0, NULL, NULL);
 		xpc_part_deref(part);
 	}
 
@@ -911,23 +911,24 @@ xpc_initiate_send_notify(short partid, i
 	DBUG_ON(func == NULL);
 
 	if (xpc_part_ref(part)) {
-		ret = xpc_send_msg(&part->channels[ch_number], flags, payload,
-				   payload_size, XPC_N_CALL, func, key);
+		ret = xpc_send_payload(&part->channels[ch_number], flags,
+				       payload, payload_size, XPC_N_CALL, func,
+				       key);
 		xpc_part_deref(part);
 	}
 	return ret;
 }
 
 /*
- * Deliver a message to its intended recipient.
+ * Deliver a message's payload to its intended recipient.
  */
 void
-xpc_deliver_msg(struct xpc_channel *ch)
+xpc_deliver_payload(struct xpc_channel *ch)
 {
-	struct xpc_msg *msg;
+	void *payload;
 
-	msg = xpc_get_deliverable_msg(ch);
-	if (msg != NULL) {
+	payload = xpc_get_deliverable_payload(ch);
+	if (payload != NULL) {
 
 		/*
 		 * This ref is taken to protect the payload itself from being
@@ -939,18 +940,16 @@ xpc_deliver_msg(struct xpc_channel *ch)
 		atomic_inc(&ch->kthreads_active);
 
 		if (ch->func != NULL) {
-			dev_dbg(xpc_chan, "ch->func() called, msg=0x%p, "
-				"msg_number=%ld, partid=%d, channel=%d\n",
-				msg, (signed long)msg->number, ch->partid,
+			dev_dbg(xpc_chan, "ch->func() called, payload=0x%p "
+				"partid=%d channel=%d\n", payload, ch->partid,
 				ch->number);
 
 			/* deliver the message to its intended recipient */
-			ch->func(xpMsgReceived, ch->partid, ch->number,
-				 &msg->payload, ch->key);
+			ch->func(xpMsgReceived, ch->partid, ch->number, payload,
+				 ch->key);
 
-			dev_dbg(xpc_chan, "ch->func() returned, msg=0x%p, "
-				"msg_number=%ld, partid=%d, channel=%d\n",
-				msg, (signed long)msg->number, ch->partid,
+			dev_dbg(xpc_chan, "ch->func() returned, payload=0x%p "
+				"partid=%d channel=%d\n", payload, ch->partid,
 				ch->number);
 		}
 
@@ -959,14 +958,11 @@ xpc_deliver_msg(struct xpc_channel *ch)
 }
 
 /*
- * Acknowledge receipt of a delivered message.
- *
- * If a message has XPC_M_INTERRUPT set, send an interrupt to the partition
- * that sent the message.
+ * Acknowledge receipt of a delivered message's payload.
  *
  * This function, although called by users, does not call xpc_part_ref() to
  * ensure that the partition infrastructure is in place. It relies on the
- * fact that we called xpc_msgqueue_ref() in xpc_deliver_msg().
+ * fact that we called xpc_msgqueue_ref() in xpc_deliver_payload().
  *
  * Arguments:
  *
@@ -980,14 +976,13 @@ xpc_initiate_received(short partid, int 
 {
 	struct xpc_partition *part = &xpc_partitions[partid];
 	struct xpc_channel *ch;
-	struct xpc_msg *msg = XPC_MSG_ADDRESS(payload);
 
 	DBUG_ON(partid < 0 || partid >= xp_max_npartitions);
 	DBUG_ON(ch_number < 0 || ch_number >= part->nchannels);
 
 	ch = &part->channels[ch_number];
-	xpc_received_msg(ch, msg);
+	xpc_received_payload(ch, payload);
 
-	/* the call to xpc_msgqueue_ref() was done by xpc_deliver_msg()  */
+	/* the call to xpc_msgqueue_ref() was done by xpc_deliver_payload()  */
 	xpc_msgqueue_deref(ch);
 }
diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-xp-setup-the-notify-gru-message-queue drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xp-setup-the-notify-gru-message-queue
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -188,8 +188,8 @@ u64 (*xpc_get_chctl_all_flags) (struct x
 enum xp_retval (*xpc_setup_msg_structures) (struct xpc_channel *ch);
 void (*xpc_teardown_msg_structures) (struct xpc_channel *ch);
 void (*xpc_process_msg_chctl_flags) (struct xpc_partition *part, int ch_number);
-int (*xpc_n_of_deliverable_msgs) (struct xpc_channel *ch);
-struct xpc_msg *(*xpc_get_deliverable_msg) (struct xpc_channel *ch);
+int (*xpc_n_of_deliverable_payloads) (struct xpc_channel *ch);
+void *(*xpc_get_deliverable_payload) (struct xpc_channel *ch);
 
 void (*xpc_request_partition_activation) (struct xpc_rsvd_page *remote_rp,
 					  unsigned long remote_rp_pa,
@@ -220,10 +220,11 @@ void (*xpc_send_chctl_openreply) (struct
 void (*xpc_save_remote_msgqueue_pa) (struct xpc_channel *ch,
 				     unsigned long msgqueue_pa);
 
-enum xp_retval (*xpc_send_msg) (struct xpc_channel *ch, u32 flags,
-				void *payload, u16 payload_size, u8 notify_type,
-				xpc_notify_func func, void *key);
-void (*xpc_received_msg) (struct xpc_channel *ch, struct xpc_msg *msg);
+enum xp_retval (*xpc_send_payload) (struct xpc_channel *ch, u32 flags,
+				    void *payload, u16 payload_size,
+				    u8 notify_type, xpc_notify_func func,
+				    void *key);
+void (*xpc_received_payload) (struct xpc_channel *ch, void *payload);
 
 /*
  * Timer function to enforce the timelimit on the partition disengage.
@@ -714,9 +715,9 @@ xpc_kthread_waitmsgs(struct xpc_partitio
 	do {
 		/* deliver messages to their intended recipients */
 
-		while (xpc_n_of_deliverable_msgs(ch) > 0 &&
+		while (xpc_n_of_deliverable_payloads(ch) > 0 &&
 		       !(ch->flags & XPC_C_DISCONNECTING)) {
-			xpc_deliver_msg(ch);
+			xpc_deliver_payload(ch);
 		}
 
 		if (atomic_inc_return(&ch->kthreads_idle) >
@@ -730,7 +731,7 @@ xpc_kthread_waitmsgs(struct xpc_partitio
 			"wait_event_interruptible_exclusive()\n");
 
 		(void)wait_event_interruptible_exclusive(ch->idle_wq,
-				(xpc_n_of_deliverable_msgs(ch) > 0 ||
+				(xpc_n_of_deliverable_payloads(ch) > 0 ||
 				 (ch->flags & XPC_C_DISCONNECTING)));
 
 		atomic_dec(&ch->kthreads_idle);
@@ -775,7 +776,7 @@ xpc_kthread_start(void *args)
 			 * additional kthreads to help deliver them. We only
 			 * need one less than total #of messages to deliver.
 			 */
-			n_needed = xpc_n_of_deliverable_msgs(ch) - 1;
+			n_needed = xpc_n_of_deliverable_payloads(ch) - 1;
 			if (n_needed > 0 && !(ch->flags & XPC_C_DISCONNECTING))
 				xpc_activate_kthreads(ch, n_needed);
 
diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-setup-the-notify-gru-message-queue drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-setup-the-notify-gru-message-queue
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -408,7 +408,7 @@ xpc_send_chctl_openrequest_sn2(struct xp
 {
 	struct xpc_openclose_args *args = ch->sn.sn2.local_openclose_args;
 
-	args->msg_size = ch->msg_size;
+	args->entry_size = ch->entry_size;
 	args->local_nentries = ch->local_nentries;
 	XPC_SEND_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_OPENREQUEST, irq_flags);
 }
@@ -1531,14 +1531,14 @@ xpc_allocate_local_msgqueue_sn2(struct x
 
 	for (nentries = ch->local_nentries; nentries > 0; nentries--) {
 
-		nbytes = nentries * ch->msg_size;
+		nbytes = nentries * ch->entry_size;
 		ch_sn2->local_msgqueue =
 		    xpc_kzalloc_cacheline_aligned(nbytes, GFP_KERNEL,
 						  &ch_sn2->local_msgqueue_base);
 		if (ch_sn2->local_msgqueue == NULL)
 			continue;
 
-		nbytes = nentries * sizeof(struct xpc_notify);
+		nbytes = nentries * sizeof(struct xpc_notify_sn2);
 		ch_sn2->notify_queue = kzalloc(nbytes, GFP_KERNEL);
 		if (ch_sn2->notify_queue == NULL) {
 			kfree(ch_sn2->local_msgqueue_base);
@@ -1578,7 +1578,7 @@ xpc_allocate_remote_msgqueue_sn2(struct 
 
 	for (nentries = ch->remote_nentries; nentries > 0; nentries--) {
 
-		nbytes = nentries * ch->msg_size;
+		nbytes = nentries * ch->entry_size;
 		ch_sn2->remote_msgqueue =
 		    xpc_kzalloc_cacheline_aligned(nbytes, GFP_KERNEL, &ch_sn2->
 						  remote_msgqueue_base);
@@ -1632,9 +1632,6 @@ xpc_setup_msg_structures_sn2(struct xpc_
 /*
  * Free up message queues and other stuff that were allocated for the specified
  * channel.
- *
- * Note: ch->reason and ch->reason_line are left set for debugging purposes,
- * they're cleared when XPC_C_DISCONNECTED is cleared.
  */
 static void
 xpc_teardown_msg_structures_sn2(struct xpc_channel *ch)
@@ -1674,7 +1671,7 @@ xpc_teardown_msg_structures_sn2(struct x
 static void
 xpc_notify_senders_sn2(struct xpc_channel *ch, enum xp_retval reason, s64 put)
 {
-	struct xpc_notify *notify;
+	struct xpc_notify_sn2 *notify;
 	u8 notify_type;
 	s64 get = ch->sn.sn2.w_remote_GP.get - 1;
 
@@ -1699,17 +1696,16 @@ xpc_notify_senders_sn2(struct xpc_channe
 		atomic_dec(&ch->n_to_notify);
 
 		if (notify->func != NULL) {
-			dev_dbg(xpc_chan, "notify->func() called, notify=0x%p, "
-				"msg_number=%ld, partid=%d, channel=%d\n",
+			dev_dbg(xpc_chan, "notify->func() called, notify=0x%p "
+				"msg_number=%ld partid=%d channel=%d\n",
 				(void *)notify, get, ch->partid, ch->number);
 
 			notify->func(reason, ch->partid, ch->number,
 				     notify->key);
 
-			dev_dbg(xpc_chan, "notify->func() returned, "
-				"notify=0x%p, msg_number=%ld, partid=%d, "
-				"channel=%d\n", (void *)notify, get,
-				ch->partid, ch->number);
+			dev_dbg(xpc_chan, "notify->func() returned, notify=0x%p"
+				" msg_number=%ld partid=%d channel=%d\n",
+				(void *)notify, get, ch->partid, ch->number);
 		}
 	}
 }
@@ -1727,14 +1723,14 @@ static inline void
 xpc_clear_local_msgqueue_flags_sn2(struct xpc_channel *ch)
 {
 	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	struct xpc_msg *msg;
+	struct xpc_msg_sn2 *msg;
 	s64 get;
 
 	get = ch_sn2->w_remote_GP.get;
 	do {
-		msg = (struct xpc_msg *)((u64)ch_sn2->local_msgqueue +
-					 (get % ch->local_nentries) *
-					 ch->msg_size);
+		msg = (struct xpc_msg_sn2 *)((u64)ch_sn2->local_msgqueue +
+					     (get % ch->local_nentries) *
+					     ch->entry_size);
 		msg->flags = 0;
 	} while (++get < ch_sn2->remote_GP.get);
 }
@@ -1746,24 +1742,30 @@ static inline void
 xpc_clear_remote_msgqueue_flags_sn2(struct xpc_channel *ch)
 {
 	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	struct xpc_msg *msg;
+	struct xpc_msg_sn2 *msg;
 	s64 put;
 
 	put = ch_sn2->w_remote_GP.put;
 	do {
-		msg = (struct xpc_msg *)((u64)ch_sn2->remote_msgqueue +
-					 (put % ch->remote_nentries) *
-					 ch->msg_size);
+		msg = (struct xpc_msg_sn2 *)((u64)ch_sn2->remote_msgqueue +
+					     (put % ch->remote_nentries) *
+					     ch->entry_size);
 		msg->flags = 0;
 	} while (++put < ch_sn2->remote_GP.put);
 }
 
+static int
+xpc_n_of_deliverable_payloads_sn2(struct xpc_channel *ch)
+{
+	return ch->sn.sn2.w_remote_GP.put - ch->sn.sn2.w_local_GP.get;
+}
+
 static void
 xpc_process_msg_chctl_flags_sn2(struct xpc_partition *part, int ch_number)
 {
 	struct xpc_channel *ch = &part->channels[ch_number];
 	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	int nmsgs_sent;
+	int npayloads_sent;
 
 	ch_sn2->remote_GP = part->sn.sn2.remote_GPs[ch_number];
 
@@ -1835,7 +1837,7 @@ xpc_process_msg_chctl_flags_sn2(struct x
 	if (ch_sn2->w_remote_GP.put != ch_sn2->remote_GP.put) {
 		/*
 		 * Clear msg->flags in previously received messages, so that
-		 * they're ready for xpc_get_deliverable_msg().
+		 * they're ready for xpc_get_deliverable_payload_sn2().
 		 */
 		xpc_clear_remote_msgqueue_flags_sn2(ch);
 
@@ -1845,27 +1847,27 @@ xpc_process_msg_chctl_flags_sn2(struct x
 			"channel=%d\n", ch_sn2->w_remote_GP.put, ch->partid,
 			ch->number);
 
-		nmsgs_sent = ch_sn2->w_remote_GP.put - ch_sn2->w_local_GP.get;
-		if (nmsgs_sent > 0) {
+		npayloads_sent = xpc_n_of_deliverable_payloads_sn2(ch);
+		if (npayloads_sent > 0) {
 			dev_dbg(xpc_chan, "msgs waiting to be copied and "
 				"delivered=%d, partid=%d, channel=%d\n",
-				nmsgs_sent, ch->partid, ch->number);
+				npayloads_sent, ch->partid, ch->number);
 
 			if (ch->flags & XPC_C_CONNECTEDCALLOUT_MADE)
-				xpc_activate_kthreads(ch, nmsgs_sent);
+				xpc_activate_kthreads(ch, npayloads_sent);
 		}
 	}
 
 	xpc_msgqueue_deref(ch);
 }
 
-static struct xpc_msg *
+static struct xpc_msg_sn2 *
 xpc_pull_remote_msg_sn2(struct xpc_channel *ch, s64 get)
 {
 	struct xpc_partition *part = &xpc_partitions[ch->partid];
 	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
 	unsigned long remote_msg_pa;
-	struct xpc_msg *msg;
+	struct xpc_msg_sn2 *msg;
 	u32 msg_index;
 	u32 nmsgs;
 	u64 msg_offset;
@@ -1889,13 +1891,13 @@ xpc_pull_remote_msg_sn2(struct xpc_chann
 			nmsgs = ch->remote_nentries - msg_index;
 		}
 
-		msg_offset = msg_index * ch->msg_size;
-		msg = (struct xpc_msg *)((u64)ch_sn2->remote_msgqueue +
+		msg_offset = msg_index * ch->entry_size;
+		msg = (struct xpc_msg_sn2 *)((u64)ch_sn2->remote_msgqueue +
 		    msg_offset);
 		remote_msg_pa = ch_sn2->remote_msgqueue_pa + msg_offset;
 
 		ret = xpc_pull_remote_cachelines_sn2(part, msg, remote_msg_pa,
-						     nmsgs * ch->msg_size);
+						     nmsgs * ch->entry_size);
 		if (ret != xpSuccess) {
 
 			dev_dbg(xpc_chan, "failed to pull %d msgs starting with"
@@ -1915,26 +1917,21 @@ xpc_pull_remote_msg_sn2(struct xpc_chann
 	mutex_unlock(&ch_sn2->msg_to_pull_mutex);
 
 	/* return the message we were looking for */
-	msg_offset = (get % ch->remote_nentries) * ch->msg_size;
-	msg = (struct xpc_msg *)((u64)ch_sn2->remote_msgqueue + msg_offset);
+	msg_offset = (get % ch->remote_nentries) * ch->entry_size;
+	msg = (struct xpc_msg_sn2 *)((u64)ch_sn2->remote_msgqueue + msg_offset);
 
 	return msg;
 }
 
-static int
-xpc_n_of_deliverable_msgs_sn2(struct xpc_channel *ch)
-{
-	return ch->sn.sn2.w_remote_GP.put - ch->sn.sn2.w_local_GP.get;
-}
-
 /*
- * Get a message to be delivered.
+ * Get the next deliverable message's payload.
  */
-static struct xpc_msg *
-xpc_get_deliverable_msg_sn2(struct xpc_channel *ch)
+static void *
+xpc_get_deliverable_payload_sn2(struct xpc_channel *ch)
 {
 	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	struct xpc_msg *msg = NULL;
+	struct xpc_msg_sn2 *msg;
+	void *payload = NULL;
 	s64 get;
 
 	do {
@@ -1965,15 +1962,16 @@ xpc_get_deliverable_msg_sn2(struct xpc_c
 			msg = xpc_pull_remote_msg_sn2(ch, get);
 
 			DBUG_ON(msg != NULL && msg->number != get);
-			DBUG_ON(msg != NULL && (msg->flags & XPC_M_DONE));
-			DBUG_ON(msg != NULL && !(msg->flags & XPC_M_READY));
+			DBUG_ON(msg != NULL && (msg->flags & XPC_M_SN2_DONE));
+			DBUG_ON(msg != NULL && !(msg->flags & XPC_M_SN2_READY));
 
+			payload = &msg->payload;
 			break;
 		}
 
 	} while (1);
 
-	return msg;
+	return payload;
 }
 
 /*
@@ -1985,7 +1983,7 @@ static void
 xpc_send_msgs_sn2(struct xpc_channel *ch, s64 initial_put)
 {
 	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	struct xpc_msg *msg;
+	struct xpc_msg_sn2 *msg;
 	s64 put = initial_put + 1;
 	int send_msgrequest = 0;
 
@@ -1995,11 +1993,12 @@ xpc_send_msgs_sn2(struct xpc_channel *ch
 			if (put == ch_sn2->w_local_GP.put)
 				break;
 
-			msg = (struct xpc_msg *)((u64)ch_sn2->local_msgqueue +
-						 (put % ch->local_nentries) *
-						 ch->msg_size);
+			msg = (struct xpc_msg_sn2 *)((u64)ch_sn2->
+						     local_msgqueue + (put %
+						     ch->local_nentries) *
+						     ch->entry_size);
 
-			if (!(msg->flags & XPC_M_READY))
+			if (!(msg->flags & XPC_M_SN2_READY))
 				break;
 
 			put++;
@@ -2026,7 +2025,7 @@ xpc_send_msgs_sn2(struct xpc_channel *ch
 
 		/*
 		 * We need to ensure that the message referenced by
-		 * local_GP->put is not XPC_M_READY or that local_GP->put
+		 * local_GP->put is not XPC_M_SN2_READY or that local_GP->put
 		 * equals w_local_GP.put, so we'll go have a look.
 		 */
 		initial_put = put;
@@ -2042,10 +2041,10 @@ xpc_send_msgs_sn2(struct xpc_channel *ch
  */
 static enum xp_retval
 xpc_allocate_msg_sn2(struct xpc_channel *ch, u32 flags,
-		     struct xpc_msg **address_of_msg)
+		     struct xpc_msg_sn2 **address_of_msg)
 {
 	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	struct xpc_msg *msg;
+	struct xpc_msg_sn2 *msg;
 	enum xp_retval ret;
 	s64 put;
 
@@ -2097,8 +2096,9 @@ xpc_allocate_msg_sn2(struct xpc_channel 
 	}
 
 	/* get the message's address and initialize it */
-	msg = (struct xpc_msg *)((u64)ch_sn2->local_msgqueue +
-				 (put % ch->local_nentries) * ch->msg_size);
+	msg = (struct xpc_msg_sn2 *)((u64)ch_sn2->local_msgqueue +
+				     (put % ch->local_nentries) *
+				     ch->entry_size);
 
 	DBUG_ON(msg->flags != 0);
 	msg->number = put;
@@ -2117,20 +2117,20 @@ xpc_allocate_msg_sn2(struct xpc_channel 
  * partition the message is being sent to.
  */
 static enum xp_retval
-xpc_send_msg_sn2(struct xpc_channel *ch, u32 flags, void *payload,
-		 u16 payload_size, u8 notify_type, xpc_notify_func func,
-		 void *key)
+xpc_send_payload_sn2(struct xpc_channel *ch, u32 flags, void *payload,
+		     u16 payload_size, u8 notify_type, xpc_notify_func func,
+		     void *key)
 {
 	enum xp_retval ret = xpSuccess;
 	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	struct xpc_msg *msg = msg;
-	struct xpc_notify *notify = notify;
+	struct xpc_msg_sn2 *msg = msg;
+	struct xpc_notify_sn2 *notify = notify;
 	s64 msg_number;
 	s64 put;
 
 	DBUG_ON(notify_type == XPC_N_CALL && func == NULL);
 
-	if (XPC_MSG_SIZE(payload_size) > ch->msg_size)
+	if (XPC_MSG_SIZE(payload_size) > ch->entry_size)
 		return xpPayloadTooBig;
 
 	xpc_msgqueue_ref(ch);
@@ -2155,7 +2155,7 @@ xpc_send_msg_sn2(struct xpc_channel *ch,
 		 * Tell the remote side to send an ACK interrupt when the
 		 * message has been delivered.
 		 */
-		msg->flags |= XPC_M_INTERRUPT;
+		msg->flags |= XPC_M_SN2_INTERRUPT;
 
 		atomic_inc(&ch->n_to_notify);
 
@@ -2185,7 +2185,7 @@ xpc_send_msg_sn2(struct xpc_channel *ch,
 
 	memcpy(&msg->payload, payload, payload_size);
 
-	msg->flags |= XPC_M_READY;
+	msg->flags |= XPC_M_SN2_READY;
 
 	/*
 	 * The preceding store of msg->flags must occur before the following
@@ -2208,12 +2208,15 @@ out_1:
  * Now we actually acknowledge the messages that have been delivered and ack'd
  * by advancing the cached remote message queue's Get value and if requested
  * send a chctl msgrequest to the message sender's partition.
+ *
+ * If a message has XPC_M_SN2_INTERRUPT set, send an interrupt to the partition
+ * that sent the message.
  */
 static void
 xpc_acknowledge_msgs_sn2(struct xpc_channel *ch, s64 initial_get, u8 msg_flags)
 {
 	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	struct xpc_msg *msg;
+	struct xpc_msg_sn2 *msg;
 	s64 get = initial_get + 1;
 	int send_msgrequest = 0;
 
@@ -2223,11 +2226,12 @@ xpc_acknowledge_msgs_sn2(struct xpc_chan
 			if (get == ch_sn2->w_local_GP.get)
 				break;
 
-			msg = (struct xpc_msg *)((u64)ch_sn2->remote_msgqueue +
-						 (get % ch->remote_nentries) *
-						 ch->msg_size);
+			msg = (struct xpc_msg_sn2 *)((u64)ch_sn2->
+						     remote_msgqueue + (get %
+						     ch->remote_nentries) *
+						     ch->entry_size);
 
-			if (!(msg->flags & XPC_M_DONE))
+			if (!(msg->flags & XPC_M_SN2_DONE))
 				break;
 
 			msg_flags |= msg->flags;
@@ -2251,11 +2255,11 @@ xpc_acknowledge_msgs_sn2(struct xpc_chan
 		dev_dbg(xpc_chan, "local_GP->get changed to %ld, partid=%d, "
 			"channel=%d\n", get, ch->partid, ch->number);
 
-		send_msgrequest = (msg_flags & XPC_M_INTERRUPT);
+		send_msgrequest = (msg_flags & XPC_M_SN2_INTERRUPT);
 
 		/*
 		 * We need to ensure that the message referenced by
-		 * local_GP->get is not XPC_M_DONE or that local_GP->get
+		 * local_GP->get is not XPC_M_SN2_DONE or that local_GP->get
 		 * equals w_local_GP.get, so we'll go have a look.
 		 */
 		initial_get = get;
@@ -2266,19 +2270,23 @@ xpc_acknowledge_msgs_sn2(struct xpc_chan
 }
 
 static void
-xpc_received_msg_sn2(struct xpc_channel *ch, struct xpc_msg *msg)
+xpc_received_payload_sn2(struct xpc_channel *ch, void *payload)
 {
+	struct xpc_msg_sn2 *msg;
+	s64 msg_number;
 	s64 get;
-	s64 msg_number = msg->number;
+
+	msg = container_of(payload, struct xpc_msg_sn2, payload);
+	msg_number = msg->number;
 
 	dev_dbg(xpc_chan, "msg=0x%p, msg_number=%ld, partid=%d, channel=%d\n",
 		(void *)msg, msg_number, ch->partid, ch->number);
 
-	DBUG_ON((((u64)msg - (u64)ch->remote_msgqueue) / ch->msg_size) !=
+	DBUG_ON((((u64)msg - (u64)ch->remote_msgqueue) / ch->entry_size) !=
 		msg_number % ch->remote_nentries);
-	DBUG_ON(msg->flags & XPC_M_DONE);
+	DBUG_ON(msg->flags & XPC_M_SN2_DONE);
 
-	msg->flags |= XPC_M_DONE;
+	msg->flags |= XPC_M_SN2_DONE;
 
 	/*
 	 * The preceding store of msg->flags must occur before the following
@@ -2337,8 +2345,8 @@ xpc_init_sn2(void)
 
 	xpc_notify_senders_of_disconnect = xpc_notify_senders_of_disconnect_sn2;
 	xpc_process_msg_chctl_flags = xpc_process_msg_chctl_flags_sn2;
-	xpc_n_of_deliverable_msgs = xpc_n_of_deliverable_msgs_sn2;
-	xpc_get_deliverable_msg = xpc_get_deliverable_msg_sn2;
+	xpc_n_of_deliverable_payloads = xpc_n_of_deliverable_payloads_sn2;
+	xpc_get_deliverable_payload = xpc_get_deliverable_payload_sn2;
 
 	xpc_indicate_partition_engaged = xpc_indicate_partition_engaged_sn2;
 	xpc_indicate_partition_disengaged =
@@ -2347,8 +2355,14 @@ xpc_init_sn2(void)
 	xpc_any_partition_engaged = xpc_any_partition_engaged_sn2;
 	xpc_assume_partition_disengaged = xpc_assume_partition_disengaged_sn2;
 
-	xpc_send_msg = xpc_send_msg_sn2;
-	xpc_received_msg = xpc_received_msg_sn2;
+	xpc_send_payload = xpc_send_payload_sn2;
+	xpc_received_payload = xpc_received_payload_sn2;
+
+	if (offsetof(struct xpc_msg_sn2, payload) > XPC_MSG_HDR_MAX_SIZE) {
+		dev_err(xpc_part, "header portion of struct xpc_msg_sn2 is "
+			"larger than %d\n", XPC_MSG_HDR_MAX_SIZE);
+		return -E2BIG;
+	}
 
 	buf_size = max(XPC_RP_VARS_SIZE,
 		       XPC_RP_HEADER_SIZE + XP_NASID_MASK_BYTES_SN2);
diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-setup-the-notify-gru-message-queue drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-setup-the-notify-gru-message-queue
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -66,8 +66,11 @@ xpc_create_gru_mq_uv(unsigned int mq_siz
 	mq_order = get_order(mq_size);
 	page = alloc_pages_node(nid, GFP_KERNEL | __GFP_ZERO | GFP_THISNODE,
 				mq_order);
-	if (page == NULL)
+	if (page == NULL) {
+		dev_err(xpc_part, "xpc_create_gru_mq_uv() failed to alloc %d "
+			"bytes of memory on nid=%d for GRU mq\n", mq_size, nid);
 		return NULL;
+	}
 
 	mq = page_address(page);
 	ret = gru_create_message_queue(mq, mq_size);
@@ -193,202 +196,226 @@ xpc_process_activate_IRQ_rcvd_uv(void)
 
 }
 
-static irqreturn_t
-xpc_handle_activate_IRQ_uv(int irq, void *dev_id)
+static void
+xpc_handle_activate_mq_msg_uv(struct xpc_partition *part,
+			      struct xpc_activate_mq_msghdr_uv *msg_hdr,
+			      int *wakeup_hb_checker)
 {
 	unsigned long irq_flags;
-	struct xpc_activate_mq_msghdr_uv *msg_hdr;
-	short partid;
-	struct xpc_partition *part;
-	struct xpc_partition_uv *part_uv;
+	struct xpc_partition_uv *part_uv = &part->sn.uv;
 	struct xpc_openclose_args *args;
-	int wakeup_hb_checker = 0;
 
-	while ((msg_hdr = gru_get_next_message(xpc_activate_mq_uv)) != NULL) {
+	part_uv->remote_act_state = msg_hdr->act_state;
 
-		partid = msg_hdr->partid;
-		if (partid < 0 || partid >= XP_MAX_NPARTITIONS_UV) {
-			dev_err(xpc_part, "xpc_handle_activate_IRQ_uv() invalid"
-				"partid=0x%x passed in message\n", partid);
-			gru_free_message(xpc_activate_mq_uv, msg_hdr);
-			continue;
-		}
-		part = &xpc_partitions[partid];
-		part_uv = &part->sn.uv;
+	switch (msg_hdr->type) {
+	case XPC_ACTIVATE_MQ_MSG_SYNC_ACT_STATE_UV:
+		/* syncing of remote_act_state was just done above */
+		break;
+
+	case XPC_ACTIVATE_MQ_MSG_INC_HEARTBEAT_UV: {
+		struct xpc_activate_mq_msg_heartbeat_req_uv *msg;
+
+		msg = container_of(msg_hdr,
+				   struct xpc_activate_mq_msg_heartbeat_req_uv,
+				   hdr);
+		part_uv->heartbeat = msg->heartbeat;
+		break;
+	}
+	case XPC_ACTIVATE_MQ_MSG_OFFLINE_HEARTBEAT_UV: {
+		struct xpc_activate_mq_msg_heartbeat_req_uv *msg;
 
-		part_uv->remote_act_state = msg_hdr->act_state;
+		msg = container_of(msg_hdr,
+				   struct xpc_activate_mq_msg_heartbeat_req_uv,
+				   hdr);
+		part_uv->heartbeat = msg->heartbeat;
+
+		spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
+		part_uv->flags |= XPC_P_HEARTBEAT_OFFLINE_UV;
+		spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
+		break;
+	}
+	case XPC_ACTIVATE_MQ_MSG_ONLINE_HEARTBEAT_UV: {
+		struct xpc_activate_mq_msg_heartbeat_req_uv *msg;
 
-		switch (msg_hdr->type) {
-		case XPC_ACTIVATE_MQ_MSG_SYNC_ACT_STATE_UV:
-			/* syncing of remote_act_state was just done above */
-			break;
+		msg = container_of(msg_hdr,
+				   struct xpc_activate_mq_msg_heartbeat_req_uv,
+				   hdr);
+		part_uv->heartbeat = msg->heartbeat;
+
+		spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
+		part_uv->flags &= ~XPC_P_HEARTBEAT_OFFLINE_UV;
+		spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
+		break;
+	}
+	case XPC_ACTIVATE_MQ_MSG_ACTIVATE_REQ_UV: {
+		struct xpc_activate_mq_msg_activate_req_uv *msg;
 
-		case XPC_ACTIVATE_MQ_MSG_INC_HEARTBEAT_UV: {
-			struct xpc_activate_mq_msg_heartbeat_req_uv *msg;
+		/*
+		 * ??? Do we deal here with ts_jiffies being different
+		 * ??? if act_state != XPC_P_AS_INACTIVE instead of
+		 * ??? below?
+		 */
+		msg = container_of(msg_hdr, struct
+				   xpc_activate_mq_msg_activate_req_uv, hdr);
 
-			msg = (struct xpc_activate_mq_msg_heartbeat_req_uv *)
-			    msg_hdr;
-			part_uv->heartbeat = msg->heartbeat;
-			break;
-		}
-		case XPC_ACTIVATE_MQ_MSG_OFFLINE_HEARTBEAT_UV: {
-			struct xpc_activate_mq_msg_heartbeat_req_uv *msg;
+		spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock, irq_flags);
+		if (part_uv->act_state_req == 0)
+			xpc_activate_IRQ_rcvd++;
+		part_uv->act_state_req = XPC_P_ASR_ACTIVATE_UV;
+		part->remote_rp_pa = msg->rp_gpa; /* !!! _pa is _gpa */
+		part->remote_rp_ts_jiffies = msg_hdr->rp_ts_jiffies;
+		part_uv->remote_activate_mq_gpa = msg->activate_mq_gpa;
+		spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock, irq_flags);
 
-			msg = (struct xpc_activate_mq_msg_heartbeat_req_uv *)
-			    msg_hdr;
-			part_uv->heartbeat = msg->heartbeat;
-			spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
-			part_uv->flags |= XPC_P_HEARTBEAT_OFFLINE_UV;
-			spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
-			break;
-		}
-		case XPC_ACTIVATE_MQ_MSG_ONLINE_HEARTBEAT_UV: {
-			struct xpc_activate_mq_msg_heartbeat_req_uv *msg;
+		(*wakeup_hb_checker)++;
+		break;
+	}
+	case XPC_ACTIVATE_MQ_MSG_DEACTIVATE_REQ_UV: {
+		struct xpc_activate_mq_msg_deactivate_req_uv *msg;
 
-			msg = (struct xpc_activate_mq_msg_heartbeat_req_uv *)
-			    msg_hdr;
-			part_uv->heartbeat = msg->heartbeat;
-			spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
-			part_uv->flags &= ~XPC_P_HEARTBEAT_OFFLINE_UV;
-			spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
-			break;
-		}
-		case XPC_ACTIVATE_MQ_MSG_ACTIVATE_REQ_UV: {
-			struct xpc_activate_mq_msg_activate_req_uv *msg;
+		msg = container_of(msg_hdr, struct
+				   xpc_activate_mq_msg_deactivate_req_uv, hdr);
 
-			/*
-			 * ??? Do we deal here with ts_jiffies being different
-			 * ??? if act_state != XPC_P_AS_INACTIVE instead of
-			 * ??? below?
-			 */
-			msg = (struct xpc_activate_mq_msg_activate_req_uv *)
-			    msg_hdr;
-			spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock,
-					  irq_flags);
-			if (part_uv->act_state_req == 0)
-				xpc_activate_IRQ_rcvd++;
-			part_uv->act_state_req = XPC_P_ASR_ACTIVATE_UV;
-			part->remote_rp_pa = msg->rp_gpa; /* !!! _pa is _gpa */
-			part->remote_rp_ts_jiffies = msg_hdr->rp_ts_jiffies;
-			part_uv->remote_activate_mq_gpa = msg->activate_mq_gpa;
-			spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock,
-					       irq_flags);
-			wakeup_hb_checker++;
-			break;
-		}
-		case XPC_ACTIVATE_MQ_MSG_DEACTIVATE_REQ_UV: {
-			struct xpc_activate_mq_msg_deactivate_req_uv *msg;
+		spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock, irq_flags);
+		if (part_uv->act_state_req == 0)
+			xpc_activate_IRQ_rcvd++;
+		part_uv->act_state_req = XPC_P_ASR_DEACTIVATE_UV;
+		part_uv->reason = msg->reason;
+		spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock, irq_flags);
 
-			msg = (struct xpc_activate_mq_msg_deactivate_req_uv *)
-			    msg_hdr;
-			spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock,
-					  irq_flags);
-			if (part_uv->act_state_req == 0)
-				xpc_activate_IRQ_rcvd++;
-			part_uv->act_state_req = XPC_P_ASR_DEACTIVATE_UV;
-			part_uv->reason = msg->reason;
-			spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock,
-					       irq_flags);
-			wakeup_hb_checker++;
-			break;
-		}
-		case XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREQUEST_UV: {
-			struct xpc_activate_mq_msg_chctl_closerequest_uv *msg;
+		(*wakeup_hb_checker)++;
+		return;
+	}
+	case XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREQUEST_UV: {
+		struct xpc_activate_mq_msg_chctl_closerequest_uv *msg;
 
-			msg = (struct xpc_activate_mq_msg_chctl_closerequest_uv
-			    *)msg_hdr;
-			args = &part->remote_openclose_args[msg->ch_number];
-			args->reason = msg->reason;
-
-			spin_lock_irqsave(&part->chctl_lock, irq_flags);
-			part->chctl.flags[msg->ch_number] |=
-			    XPC_CHCTL_CLOSEREQUEST;
-			spin_unlock_irqrestore(&part->chctl_lock, irq_flags);
+		msg = container_of(msg_hdr, struct
+				   xpc_activate_mq_msg_chctl_closerequest_uv,
+				   hdr);
+		args = &part->remote_openclose_args[msg->ch_number];
+		args->reason = msg->reason;
+
+		spin_lock_irqsave(&part->chctl_lock, irq_flags);
+		part->chctl.flags[msg->ch_number] |= XPC_CHCTL_CLOSEREQUEST;
+		spin_unlock_irqrestore(&part->chctl_lock, irq_flags);
 
-			xpc_wakeup_channel_mgr(part);
-			break;
-		}
-		case XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREPLY_UV: {
-			struct xpc_activate_mq_msg_chctl_closereply_uv *msg;
+		xpc_wakeup_channel_mgr(part);
+		break;
+	}
+	case XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREPLY_UV: {
+		struct xpc_activate_mq_msg_chctl_closereply_uv *msg;
 
-			msg = (struct xpc_activate_mq_msg_chctl_closereply_uv *)
-			    msg_hdr;
+		msg = container_of(msg_hdr, struct
+				   xpc_activate_mq_msg_chctl_closereply_uv,
+				   hdr);
+
+		spin_lock_irqsave(&part->chctl_lock, irq_flags);
+		part->chctl.flags[msg->ch_number] |= XPC_CHCTL_CLOSEREPLY;
+		spin_unlock_irqrestore(&part->chctl_lock, irq_flags);
 
-			spin_lock_irqsave(&part->chctl_lock, irq_flags);
-			part->chctl.flags[msg->ch_number] |=
-			    XPC_CHCTL_CLOSEREPLY;
-			spin_unlock_irqrestore(&part->chctl_lock, irq_flags);
+		xpc_wakeup_channel_mgr(part);
+		break;
+	}
+	case XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREQUEST_UV: {
+		struct xpc_activate_mq_msg_chctl_openrequest_uv *msg;
 
-			xpc_wakeup_channel_mgr(part);
-			break;
-		}
-		case XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREQUEST_UV: {
-			struct xpc_activate_mq_msg_chctl_openrequest_uv *msg;
+		msg = container_of(msg_hdr, struct
+				   xpc_activate_mq_msg_chctl_openrequest_uv,
+				   hdr);
+		args = &part->remote_openclose_args[msg->ch_number];
+		args->entry_size = msg->entry_size;
+		args->local_nentries = msg->local_nentries;
+
+		spin_lock_irqsave(&part->chctl_lock, irq_flags);
+		part->chctl.flags[msg->ch_number] |= XPC_CHCTL_OPENREQUEST;
+		spin_unlock_irqrestore(&part->chctl_lock, irq_flags);
 
-			msg = (struct xpc_activate_mq_msg_chctl_openrequest_uv
-			    *)msg_hdr;
-			args = &part->remote_openclose_args[msg->ch_number];
-			args->msg_size = msg->msg_size;
-			args->local_nentries = msg->local_nentries;
-
-			spin_lock_irqsave(&part->chctl_lock, irq_flags);
-			part->chctl.flags[msg->ch_number] |=
-			    XPC_CHCTL_OPENREQUEST;
-			spin_unlock_irqrestore(&part->chctl_lock, irq_flags);
+		xpc_wakeup_channel_mgr(part);
+		break;
+	}
+	case XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREPLY_UV: {
+		struct xpc_activate_mq_msg_chctl_openreply_uv *msg;
 
-			xpc_wakeup_channel_mgr(part);
-			break;
-		}
-		case XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREPLY_UV: {
-			struct xpc_activate_mq_msg_chctl_openreply_uv *msg;
+		msg = container_of(msg_hdr, struct
+				   xpc_activate_mq_msg_chctl_openreply_uv, hdr);
+		args = &part->remote_openclose_args[msg->ch_number];
+		args->remote_nentries = msg->remote_nentries;
+		args->local_nentries = msg->local_nentries;
+		args->local_msgqueue_pa = msg->local_notify_mq_gpa;
+
+		spin_lock_irqsave(&part->chctl_lock, irq_flags);
+		part->chctl.flags[msg->ch_number] |= XPC_CHCTL_OPENREPLY;
+		spin_unlock_irqrestore(&part->chctl_lock, irq_flags);
 
-			msg = (struct xpc_activate_mq_msg_chctl_openreply_uv *)
-			    msg_hdr;
-			args = &part->remote_openclose_args[msg->ch_number];
-			args->remote_nentries = msg->remote_nentries;
-			args->local_nentries = msg->local_nentries;
-			args->local_msgqueue_pa = msg->local_notify_mq_gpa;
-
-			spin_lock_irqsave(&part->chctl_lock, irq_flags);
-			part->chctl.flags[msg->ch_number] |=
-			    XPC_CHCTL_OPENREPLY;
-			spin_unlock_irqrestore(&part->chctl_lock, irq_flags);
+		xpc_wakeup_channel_mgr(part);
+		break;
+	}
+	case XPC_ACTIVATE_MQ_MSG_MARK_ENGAGED_UV:
+		spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
+		part_uv->flags |= XPC_P_ENGAGED_UV;
+		spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
+		break;
+
+	case XPC_ACTIVATE_MQ_MSG_MARK_DISENGAGED_UV:
+		spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
+		part_uv->flags &= ~XPC_P_ENGAGED_UV;
+		spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
+		break;
+
+	default:
+		dev_err(xpc_part, "received unknown activate_mq msg type=%d "
+			"from partition=%d\n", msg_hdr->type, XPC_PARTID(part));
 
-			xpc_wakeup_channel_mgr(part);
-			break;
-		}
-		case XPC_ACTIVATE_MQ_MSG_MARK_ENGAGED_UV:
-			spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
-			part_uv->flags |= XPC_P_ENGAGED_UV;
-			spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
-			break;
+		/* get hb checker to deactivate from the remote partition */
+		spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock, irq_flags);
+		if (part_uv->act_state_req == 0)
+			xpc_activate_IRQ_rcvd++;
+		part_uv->act_state_req = XPC_P_ASR_DEACTIVATE_UV;
+		part_uv->reason = xpBadMsgType;
+		spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock, irq_flags);
 
-		case XPC_ACTIVATE_MQ_MSG_MARK_DISENGAGED_UV:
-			spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
-			part_uv->flags &= ~XPC_P_ENGAGED_UV;
-			spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
-			break;
+		(*wakeup_hb_checker)++;
+		return;
+	}
 
-		default:
-			dev_err(xpc_part, "received unknown activate_mq msg "
-				"type=%d from partition=%d\n", msg_hdr->type,
-				partid);
-		}
+	if (msg_hdr->rp_ts_jiffies != part->remote_rp_ts_jiffies &&
+	    part->remote_rp_ts_jiffies != 0) {
+		/*
+		 * ??? Does what we do here need to be sensitive to
+		 * ??? act_state or remote_act_state?
+		 */
+		spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock, irq_flags);
+		if (part_uv->act_state_req == 0)
+			xpc_activate_IRQ_rcvd++;
+		part_uv->act_state_req = XPC_P_ASR_REACTIVATE_UV;
+		spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock, irq_flags);
+
+		(*wakeup_hb_checker)++;
+	}
+}
+
+static irqreturn_t
+xpc_handle_activate_IRQ_uv(int irq, void *dev_id)
+{
+	struct xpc_activate_mq_msghdr_uv *msg_hdr;
+	short partid;
+	struct xpc_partition *part;
+	int wakeup_hb_checker = 0;
 
-		if (msg_hdr->rp_ts_jiffies != part->remote_rp_ts_jiffies &&
-		    part->remote_rp_ts_jiffies != 0) {
-			/*
-			 * ??? Does what we do here need to be sensitive to
-			 * ??? act_state or remote_act_state?
-			 */
-			spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock,
-					  irq_flags);
-			if (part_uv->act_state_req == 0)
-				xpc_activate_IRQ_rcvd++;
-			part_uv->act_state_req = XPC_P_ASR_REACTIVATE_UV;
-			spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock,
-					       irq_flags);
-			wakeup_hb_checker++;
+	while ((msg_hdr = gru_get_next_message(xpc_activate_mq_uv)) != NULL) {
+
+		partid = msg_hdr->partid;
+		if (partid < 0 || partid >= XP_MAX_NPARTITIONS_UV) {
+			dev_err(xpc_part, "xpc_handle_activate_IRQ_uv() "
+				"received invalid partid=0x%x in message\n",
+				partid);
+		} else {
+			part = &xpc_partitions[partid];
+			if (xpc_part_ref(part)) {
+				xpc_handle_activate_mq_msg_uv(part, msg_hdr,
+							    &wakeup_hb_checker);
+				xpc_part_deref(part);
+			}
 		}
 
 		gru_free_message(xpc_activate_mq_uv, msg_hdr);
@@ -616,14 +643,82 @@ xpc_request_partition_deactivation_uv(st
 	}
 }
 
+static void
+xpc_cancel_partition_deactivation_request_uv(struct xpc_partition *part)
+{
+	/* nothing needs to be done */
+	return;
+}
+
+static void
+xpc_init_fifo_uv(struct xpc_fifo_head_uv *head)
+{
+	head->first = NULL;
+	head->last = NULL;
+	spin_lock_init(&head->lock);
+	head->n_entries = 0;
+}
+
+static void *
+xpc_get_fifo_entry_uv(struct xpc_fifo_head_uv *head)
+{
+	unsigned long irq_flags;
+	struct xpc_fifo_entry_uv *first;
+
+	spin_lock_irqsave(&head->lock, irq_flags);
+	first = head->first;
+	if (head->first != NULL) {
+		head->first = first->next;
+		if (head->first == NULL)
+			head->last = NULL;
+	}
+	head->n_entries++;
+	spin_unlock_irqrestore(&head->lock, irq_flags);
+	first->next = NULL;
+	return first;
+}
+
+static void
+xpc_put_fifo_entry_uv(struct xpc_fifo_head_uv *head,
+		      struct xpc_fifo_entry_uv *last)
+{
+	unsigned long irq_flags;
+
+	last->next = NULL;
+	spin_lock_irqsave(&head->lock, irq_flags);
+	if (head->last != NULL)
+		head->last->next = last;
+	else
+		head->first = last;
+	head->last = last;
+	head->n_entries--;
+	BUG_ON(head->n_entries < 0);
+	spin_unlock_irqrestore(&head->lock, irq_flags);
+}
+
+static int
+xpc_n_of_fifo_entries_uv(struct xpc_fifo_head_uv *head)
+{
+	return head->n_entries;
+}
+
 /*
  * Setup the channel structures that are uv specific.
  */
 static enum xp_retval
 xpc_setup_ch_structures_sn_uv(struct xpc_partition *part)
 {
-	/* !!! this function needs fleshing out */
-	return xpUnsupported;
+	struct xpc_channel_uv *ch_uv;
+	int ch_number;
+
+	for (ch_number = 0; ch_number < part->nchannels; ch_number++) {
+		ch_uv = &part->channels[ch_number].sn.uv;
+
+		xpc_init_fifo_uv(&ch_uv->msg_slot_free_list);
+		xpc_init_fifo_uv(&ch_uv->recv_msg_list);
+	}
+
+	return xpSuccess;
 }
 
 /*
@@ -632,7 +727,7 @@ xpc_setup_ch_structures_sn_uv(struct xpc
 static void
 xpc_teardown_ch_structures_sn_uv(struct xpc_partition *part)
 {
-	/* !!! this function needs fleshing out */
+	/* nothing needs to be done */
 	return;
 }
 
@@ -680,20 +775,114 @@ xpc_get_chctl_all_flags_uv(struct xpc_pa
 }
 
 static enum xp_retval
+xpc_allocate_send_msg_slot_uv(struct xpc_channel *ch)
+{
+	struct xpc_channel_uv *ch_uv = &ch->sn.uv;
+	struct xpc_send_msg_slot_uv *msg_slot;
+	unsigned long irq_flags;
+	int nentries;
+	int entry;
+	size_t nbytes;
+
+	for (nentries = ch->local_nentries; nentries > 0; nentries--) {
+		nbytes = nentries * sizeof(struct xpc_send_msg_slot_uv);
+		ch_uv->send_msg_slots = kzalloc(nbytes, GFP_KERNEL);
+		if (ch_uv->send_msg_slots == NULL)
+			continue;
+
+		for (entry = 0; entry < nentries; entry++) {
+			msg_slot = &ch_uv->send_msg_slots[entry];
+
+			msg_slot->msg_slot_number = entry;
+			xpc_put_fifo_entry_uv(&ch_uv->msg_slot_free_list,
+					      &msg_slot->next);
+		}
+
+		spin_lock_irqsave(&ch->lock, irq_flags);
+		if (nentries < ch->local_nentries)
+			ch->local_nentries = nentries;
+		spin_unlock_irqrestore(&ch->lock, irq_flags);
+		return xpSuccess;
+	}
+
+	return xpNoMemory;
+}
+
+static enum xp_retval
+xpc_allocate_recv_msg_slot_uv(struct xpc_channel *ch)
+{
+	struct xpc_channel_uv *ch_uv = &ch->sn.uv;
+	struct xpc_notify_mq_msg_uv *msg_slot;
+	unsigned long irq_flags;
+	int nentries;
+	int entry;
+	size_t nbytes;
+
+	for (nentries = ch->remote_nentries; nentries > 0; nentries--) {
+		nbytes = nentries * ch->entry_size;
+		ch_uv->recv_msg_slots = kzalloc(nbytes, GFP_KERNEL);
+		if (ch_uv->recv_msg_slots == NULL)
+			continue;
+
+		for (entry = 0; entry < nentries; entry++) {
+			msg_slot = ch_uv->recv_msg_slots + entry *
+			    ch->entry_size;
+
+			msg_slot->hdr.msg_slot_number = entry;
+		}
+
+		spin_lock_irqsave(&ch->lock, irq_flags);
+		if (nentries < ch->remote_nentries)
+			ch->remote_nentries = nentries;
+		spin_unlock_irqrestore(&ch->lock, irq_flags);
+		return xpSuccess;
+	}
+
+	return xpNoMemory;
+}
+
+/*
+ * Allocate msg_slots associated with the channel.
+ */
+static enum xp_retval
 xpc_setup_msg_structures_uv(struct xpc_channel *ch)
 {
-	/* !!! this function needs fleshing out */
-	return xpUnsupported;
+	static enum xp_retval ret;
+	struct xpc_channel_uv *ch_uv = &ch->sn.uv;
+
+	DBUG_ON(ch->flags & XPC_C_SETUP);
+
+	ret = xpc_allocate_send_msg_slot_uv(ch);
+	if (ret == xpSuccess) {
+
+		ret = xpc_allocate_recv_msg_slot_uv(ch);
+		if (ret != xpSuccess) {
+			kfree(ch_uv->send_msg_slots);
+			xpc_init_fifo_uv(&ch_uv->msg_slot_free_list);
+		}
+	}
+	return ret;
 }
 
+/*
+ * Free up msg_slots and clear other stuff that were setup for the specified
+ * channel.
+ */
 static void
 xpc_teardown_msg_structures_uv(struct xpc_channel *ch)
 {
 	struct xpc_channel_uv *ch_uv = &ch->sn.uv;
 
+	DBUG_ON(!spin_is_locked(&ch->lock));
+
 	ch_uv->remote_notify_mq_gpa = 0;
 
-	/* !!! this function needs fleshing out */
+	if (ch->flags & XPC_C_SETUP) {
+		xpc_init_fifo_uv(&ch_uv->msg_slot_free_list);
+		kfree(ch_uv->send_msg_slots);
+		xpc_init_fifo_uv(&ch_uv->recv_msg_list);
+		kfree(ch_uv->recv_msg_slots);
+	}
 }
 
 static void
@@ -723,7 +912,7 @@ xpc_send_chctl_openrequest_uv(struct xpc
 	struct xpc_activate_mq_msg_chctl_openrequest_uv msg;
 
 	msg.ch_number = ch->number;
-	msg.msg_size = ch->msg_size;
+	msg.entry_size = ch->entry_size;
 	msg.local_nentries = ch->local_nentries;
 	xpc_send_activate_IRQ_ch_uv(ch, irq_flags, &msg, sizeof(msg),
 				    XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREQUEST_UV);
@@ -743,6 +932,18 @@ xpc_send_chctl_openreply_uv(struct xpc_c
 }
 
 static void
+xpc_send_chctl_local_msgrequest_uv(struct xpc_partition *part, int ch_number)
+{
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&part->chctl_lock, irq_flags);
+	part->chctl.flags[ch_number] |= XPC_CHCTL_MSGREQUEST;
+	spin_unlock_irqrestore(&part->chctl_lock, irq_flags);
+
+	xpc_wakeup_channel_mgr(part);
+}
+
+static void
 xpc_save_remote_msgqueue_pa_uv(struct xpc_channel *ch,
 			       unsigned long msgqueue_pa)
 {
@@ -798,11 +999,358 @@ xpc_any_partition_engaged_uv(void)
 	return 0;
 }
 
-static struct xpc_msg *
-xpc_get_deliverable_msg_uv(struct xpc_channel *ch)
+static enum xp_retval
+xpc_allocate_msg_slot_uv(struct xpc_channel *ch, u32 flags,
+			 struct xpc_send_msg_slot_uv **address_of_msg_slot)
+{
+	enum xp_retval ret;
+	struct xpc_send_msg_slot_uv *msg_slot;
+	struct xpc_fifo_entry_uv *entry;
+
+	while (1) {
+		entry = xpc_get_fifo_entry_uv(&ch->sn.uv.msg_slot_free_list);
+		if (entry != NULL)
+			break;
+
+		if (flags & XPC_NOWAIT)
+			return xpNoWait;
+
+		ret = xpc_allocate_msg_wait(ch);
+		if (ret != xpInterrupted && ret != xpTimeout)
+			return ret;
+	}
+
+	msg_slot = container_of(entry, struct xpc_send_msg_slot_uv, next);
+	*address_of_msg_slot = msg_slot;
+	return xpSuccess;
+}
+
+static void
+xpc_free_msg_slot_uv(struct xpc_channel *ch,
+		     struct xpc_send_msg_slot_uv *msg_slot)
+{
+	xpc_put_fifo_entry_uv(&ch->sn.uv.msg_slot_free_list, &msg_slot->next);
+
+	/* wakeup anyone waiting for a free msg slot */
+	if (atomic_read(&ch->n_on_msg_allocate_wq) > 0)
+		wake_up(&ch->msg_allocate_wq);
+}
+
+static void
+xpc_notify_sender_uv(struct xpc_channel *ch,
+		     struct xpc_send_msg_slot_uv *msg_slot,
+		     enum xp_retval reason)
+{
+	xpc_notify_func func = msg_slot->func;
+
+	if (func != NULL && cmpxchg(&msg_slot->func, func, NULL) == func) {
+
+		atomic_dec(&ch->n_to_notify);
+
+		dev_dbg(xpc_chan, "msg_slot->func() called, msg_slot=0x%p "
+			"msg_slot_number=%d partid=%d channel=%d\n", msg_slot,
+			msg_slot->msg_slot_number, ch->partid, ch->number);
+
+		func(reason, ch->partid, ch->number, msg_slot->key);
+
+		dev_dbg(xpc_chan, "msg_slot->func() returned, msg_slot=0x%p "
+			"msg_slot_number=%d partid=%d channel=%d\n", msg_slot,
+			msg_slot->msg_slot_number, ch->partid, ch->number);
+	}
+}
+
+static void
+xpc_handle_notify_mq_ack_uv(struct xpc_channel *ch,
+			    struct xpc_notify_mq_msg_uv *msg)
+{
+	struct xpc_send_msg_slot_uv *msg_slot;
+	int entry = msg->hdr.msg_slot_number % ch->local_nentries;
+
+	msg_slot = &ch->sn.uv.send_msg_slots[entry];
+
+	BUG_ON(msg_slot->msg_slot_number != msg->hdr.msg_slot_number);
+	msg_slot->msg_slot_number += ch->local_nentries;
+
+	if (msg_slot->func != NULL)
+		xpc_notify_sender_uv(ch, msg_slot, xpMsgDelivered);
+
+	xpc_free_msg_slot_uv(ch, msg_slot);
+}
+
+static void
+xpc_handle_notify_mq_msg_uv(struct xpc_partition *part,
+			    struct xpc_notify_mq_msg_uv *msg)
+{
+	struct xpc_partition_uv *part_uv = &part->sn.uv;
+	struct xpc_channel *ch;
+	struct xpc_channel_uv *ch_uv;
+	struct xpc_notify_mq_msg_uv *msg_slot;
+	unsigned long irq_flags;
+	int ch_number = msg->hdr.ch_number;
+
+	if (unlikely(ch_number >= part->nchannels)) {
+		dev_err(xpc_part, "xpc_handle_notify_IRQ_uv() received invalid "
+			"channel number=0x%x in message from partid=%d\n",
+			ch_number, XPC_PARTID(part));
+
+		/* get hb checker to deactivate from the remote partition */
+		spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock, irq_flags);
+		if (part_uv->act_state_req == 0)
+			xpc_activate_IRQ_rcvd++;
+		part_uv->act_state_req = XPC_P_ASR_DEACTIVATE_UV;
+		part_uv->reason = xpBadChannelNumber;
+		spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock, irq_flags);
+
+		wake_up_interruptible(&xpc_activate_IRQ_wq);
+		return;
+	}
+
+	ch = &part->channels[ch_number];
+	xpc_msgqueue_ref(ch);
+
+	if (!(ch->flags & XPC_C_CONNECTED)) {
+		xpc_msgqueue_deref(ch);
+		return;
+	}
+
+	/* see if we're really dealing with an ACK for a previously sent msg */
+	if (msg->hdr.size == 0) {
+		xpc_handle_notify_mq_ack_uv(ch, msg);
+		xpc_msgqueue_deref(ch);
+		return;
+	}
+
+	/* we're dealing with a normal message sent via the notify_mq */
+	ch_uv = &ch->sn.uv;
+
+	msg_slot = (struct xpc_notify_mq_msg_uv *)((u64)ch_uv->recv_msg_slots +
+		    (msg->hdr.msg_slot_number % ch->remote_nentries) *
+		    ch->entry_size);
+
+	BUG_ON(msg->hdr.msg_slot_number != msg_slot->hdr.msg_slot_number);
+	BUG_ON(msg_slot->hdr.size != 0);
+
+	memcpy(msg_slot, msg, msg->hdr.size);
+
+	xpc_put_fifo_entry_uv(&ch_uv->recv_msg_list, &msg_slot->hdr.u.next);
+
+	if (ch->flags & XPC_C_CONNECTEDCALLOUT_MADE) {
+		/*
+		 * If there is an existing idle kthread get it to deliver
+		 * the payload, otherwise we'll have to get the channel mgr
+		 * for this partition to create a kthread to do the delivery.
+		 */
+		if (atomic_read(&ch->kthreads_idle) > 0)
+			wake_up_nr(&ch->idle_wq, 1);
+		else
+			xpc_send_chctl_local_msgrequest_uv(part, ch->number);
+	}
+	xpc_msgqueue_deref(ch);
+}
+
+static irqreturn_t
+xpc_handle_notify_IRQ_uv(int irq, void *dev_id)
+{
+	struct xpc_notify_mq_msg_uv *msg;
+	short partid;
+	struct xpc_partition *part;
+
+	while ((msg = gru_get_next_message(xpc_notify_mq_uv)) != NULL) {
+
+		partid = msg->hdr.partid;
+		if (partid < 0 || partid >= XP_MAX_NPARTITIONS_UV) {
+			dev_err(xpc_part, "xpc_handle_notify_IRQ_uv() received "
+				"invalid partid=0x%x in message\n", partid);
+		} else {
+			part = &xpc_partitions[partid];
+
+			if (xpc_part_ref(part)) {
+				xpc_handle_notify_mq_msg_uv(part, msg);
+				xpc_part_deref(part);
+			}
+		}
+
+		gru_free_message(xpc_notify_mq_uv, msg);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int
+xpc_n_of_deliverable_payloads_uv(struct xpc_channel *ch)
+{
+	return xpc_n_of_fifo_entries_uv(&ch->sn.uv.recv_msg_list);
+}
+
+static void
+xpc_process_msg_chctl_flags_uv(struct xpc_partition *part, int ch_number)
+{
+	struct xpc_channel *ch = &part->channels[ch_number];
+	int ndeliverable_payloads;
+
+	xpc_msgqueue_ref(ch);
+
+	ndeliverable_payloads = xpc_n_of_deliverable_payloads_uv(ch);
+
+	if (ndeliverable_payloads > 0 &&
+	    (ch->flags & XPC_C_CONNECTED) &&
+	    (ch->flags & XPC_C_CONNECTEDCALLOUT_MADE)) {
+
+		xpc_activate_kthreads(ch, ndeliverable_payloads);
+	}
+
+	xpc_msgqueue_deref(ch);
+}
+
+static enum xp_retval
+xpc_send_payload_uv(struct xpc_channel *ch, u32 flags, void *payload,
+		    u16 payload_size, u8 notify_type, xpc_notify_func func,
+		    void *key)
+{
+	enum xp_retval ret = xpSuccess;
+	struct xpc_send_msg_slot_uv *msg_slot = NULL;
+	struct xpc_notify_mq_msg_uv *msg;
+	u8 msg_buffer[XPC_NOTIFY_MSG_SIZE_UV];
+	size_t msg_size;
+
+	DBUG_ON(notify_type != XPC_N_CALL);
+
+	msg_size = sizeof(struct xpc_notify_mq_msghdr_uv) + payload_size;
+	if (msg_size > ch->entry_size)
+		return xpPayloadTooBig;
+
+	xpc_msgqueue_ref(ch);
+
+	if (ch->flags & XPC_C_DISCONNECTING) {
+		ret = ch->reason;
+		goto out_1;
+	}
+	if (!(ch->flags & XPC_C_CONNECTED)) {
+		ret = xpNotConnected;
+		goto out_1;
+	}
+
+	ret = xpc_allocate_msg_slot_uv(ch, flags, &msg_slot);
+	if (ret != xpSuccess)
+		goto out_1;
+
+	if (func != NULL) {
+		atomic_inc(&ch->n_to_notify);
+
+		msg_slot->key = key;
+		wmb(); /* a non-NULL func must hit memory after the key */
+		msg_slot->func = func;
+
+		if (ch->flags & XPC_C_DISCONNECTING) {
+			ret = ch->reason;
+			goto out_2;
+		}
+	}
+
+	msg = (struct xpc_notify_mq_msg_uv *)&msg_buffer;
+	msg->hdr.partid = xp_partition_id;
+	msg->hdr.ch_number = ch->number;
+	msg->hdr.size = msg_size;
+	msg->hdr.msg_slot_number = msg_slot->msg_slot_number;
+	memcpy(&msg->payload, payload, payload_size);
+
+	ret = xpc_send_gru_msg(ch->sn.uv.remote_notify_mq_gpa, msg, msg_size);
+	if (ret == xpSuccess)
+		goto out_1;
+
+	XPC_DEACTIVATE_PARTITION(&xpc_partitions[ch->partid], ret);
+out_2:
+	if (func != NULL) {
+		/*
+		 * Try to NULL the msg_slot's func field. If we fail, then
+		 * xpc_notify_senders_of_disconnect_uv() beat us to it, in which
+		 * case we need to pretend we succeeded to send the message
+		 * since the user will get a callout for the disconnect error
+		 * by xpc_notify_senders_of_disconnect_uv(), and to also get an
+		 * error returned here will confuse them. Additionally, since
+		 * in this case the channel is being disconnected we don't need
+		 * to put the the msg_slot back on the free list.
+		 */
+		if (cmpxchg(&msg_slot->func, func, NULL) != func) {
+			ret = xpSuccess;
+			goto out_1;
+		}
+
+		msg_slot->key = NULL;
+		atomic_dec(&ch->n_to_notify);
+	}
+	xpc_free_msg_slot_uv(ch, msg_slot);
+out_1:
+	xpc_msgqueue_deref(ch);
+	return ret;
+}
+
+/*
+ * Tell the callers of xpc_send_notify() that the status of their payloads
+ * is unknown because the channel is now disconnecting.
+ *
+ * We don't worry about putting these msg_slots on the free list since the
+ * msg_slots themselves are about to be kfree'd.
+ */
+static void
+xpc_notify_senders_of_disconnect_uv(struct xpc_channel *ch)
+{
+	struct xpc_send_msg_slot_uv *msg_slot;
+	int entry;
+
+	DBUG_ON(!(ch->flags & XPC_C_DISCONNECTING));
+
+	for (entry = 0; entry < ch->local_nentries; entry++) {
+
+		if (atomic_read(&ch->n_to_notify) == 0)
+			break;
+
+		msg_slot = &ch->sn.uv.send_msg_slots[entry];
+		if (msg_slot->func != NULL)
+			xpc_notify_sender_uv(ch, msg_slot, ch->reason);
+	}
+}
+
+/*
+ * Get the next deliverable message's payload.
+ */
+static void *
+xpc_get_deliverable_payload_uv(struct xpc_channel *ch)
+{
+	struct xpc_fifo_entry_uv *entry;
+	struct xpc_notify_mq_msg_uv *msg;
+	void *payload = NULL;
+
+	if (!(ch->flags & XPC_C_DISCONNECTING)) {
+		entry = xpc_get_fifo_entry_uv(&ch->sn.uv.recv_msg_list);
+		if (entry != NULL) {
+			msg = container_of(entry, struct xpc_notify_mq_msg_uv,
+					   hdr.u.next);
+			payload = &msg->payload;
+		}
+	}
+	return payload;
+}
+
+static void
+xpc_received_payload_uv(struct xpc_channel *ch, void *payload)
 {
-	/* !!! this function needs fleshing out */
-	return NULL;
+	struct xpc_notify_mq_msg_uv *msg;
+	enum xp_retval ret;
+
+	msg = container_of(payload, struct xpc_notify_mq_msg_uv, payload);
+
+	/* return an ACK to the sender of this message */
+
+	msg->hdr.partid = xp_partition_id;
+	msg->hdr.size = 0;	/* size of zero indicates this is an ACK */
+
+	ret = xpc_send_gru_msg(ch->sn.uv.remote_notify_mq_gpa, msg,
+			       sizeof(struct xpc_notify_mq_msghdr_uv));
+	if (ret != xpSuccess)
+		XPC_DEACTIVATE_PARTITION(&xpc_partitions[ch->partid], ret);
+
+	msg->hdr.msg_slot_number += ch->remote_nentries;
 }
 
 int
@@ -824,6 +1372,8 @@ xpc_init_uv(void)
 	    xpc_request_partition_reactivation_uv;
 	xpc_request_partition_deactivation =
 	    xpc_request_partition_deactivation_uv;
+	xpc_cancel_partition_deactivation_request =
+	    xpc_cancel_partition_deactivation_request_uv;
 
 	xpc_setup_ch_structures_sn = xpc_setup_ch_structures_sn_uv;
 	xpc_teardown_ch_structures_sn = xpc_teardown_ch_structures_sn_uv;
@@ -848,7 +1398,18 @@ xpc_init_uv(void)
 	xpc_partition_engaged = xpc_partition_engaged_uv;
 	xpc_any_partition_engaged = xpc_any_partition_engaged_uv;
 
-	xpc_get_deliverable_msg = xpc_get_deliverable_msg_uv;
+	xpc_n_of_deliverable_payloads = xpc_n_of_deliverable_payloads_uv;
+	xpc_process_msg_chctl_flags = xpc_process_msg_chctl_flags_uv;
+	xpc_send_payload = xpc_send_payload_uv;
+	xpc_notify_senders_of_disconnect = xpc_notify_senders_of_disconnect_uv;
+	xpc_get_deliverable_payload = xpc_get_deliverable_payload_uv;
+	xpc_received_payload = xpc_received_payload_uv;
+
+	if (sizeof(struct xpc_notify_mq_msghdr_uv) > XPC_MSG_HDR_MAX_SIZE) {
+		dev_err(xpc_part, "xpc_notify_mq_msghdr_uv is larger than %d\n",
+			XPC_MSG_HDR_MAX_SIZE);
+		return -E2BIG;
+	}
 
 	/* ??? The cpuid argument's value is 0, is that what we want? */
 	/* !!! The irq argument's value isn't correct. */
@@ -857,6 +1418,17 @@ xpc_init_uv(void)
 	if (xpc_activate_mq_uv == NULL)
 		return -ENOMEM;
 
+	/* ??? The cpuid argument's value is 0, is that what we want? */
+	/* !!! The irq argument's value isn't correct. */
+	xpc_notify_mq_uv = xpc_create_gru_mq_uv(XPC_NOTIFY_MQ_SIZE_UV, 0, 0,
+						xpc_handle_notify_IRQ_uv);
+	if (xpc_notify_mq_uv == NULL) {
+		/* !!! The irq argument's value isn't correct. */
+		xpc_destroy_gru_mq_uv(xpc_activate_mq_uv,
+				      XPC_ACTIVATE_MQ_SIZE_UV, 0);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
@@ -864,5 +1436,8 @@ void
 xpc_exit_uv(void)
 {
 	/* !!! The irq argument's value isn't correct. */
+	xpc_destroy_gru_mq_uv(xpc_notify_mq_uv, XPC_NOTIFY_MQ_SIZE_UV, 0);
+
+	/* !!! The irq argument's value isn't correct. */
 	xpc_destroy_gru_mq_uv(xpc_activate_mq_uv, XPC_ACTIVATE_MQ_SIZE_UV, 0);
 }
diff -puN drivers/misc/sgi-xp/xpnet.c~sgi-xp-setup-the-notify-gru-message-queue drivers/misc/sgi-xp/xpnet.c
--- a/drivers/misc/sgi-xp/xpnet.c~sgi-xp-setup-the-notify-gru-message-queue
+++ a/drivers/misc/sgi-xp/xpnet.c
@@ -57,11 +57,10 @@ struct xpnet_message {
  *
  * XPC expects each message to exist in an individual cacheline.
  */
-#define XPNET_MSG_SIZE		(L1_CACHE_BYTES - XPC_MSG_PAYLOAD_OFFSET)
+#define XPNET_MSG_SIZE		XPC_MSG_PAYLOAD_MAX_SIZE
 #define XPNET_MSG_DATA_MAX	\
-		(XPNET_MSG_SIZE - (u64)(&((struct xpnet_message *)0)->data))
-#define XPNET_MSG_ALIGNED_SIZE	(L1_CACHE_ALIGN(XPNET_MSG_SIZE))
-#define XPNET_MSG_NENTRIES	(PAGE_SIZE / XPNET_MSG_ALIGNED_SIZE)
+		(XPNET_MSG_SIZE - offsetof(struct xpnet_message, data))
+#define XPNET_MSG_NENTRIES	(PAGE_SIZE / XPC_MSG_MAX_SIZE)
 
 #define XPNET_MAX_KTHREADS	(XPNET_MSG_NENTRIES + 1)
 #define XPNET_MAX_IDLE_KTHREADS	(XPNET_MSG_NENTRIES + 1)
@@ -408,6 +407,7 @@ xpnet_send(struct sk_buff *skb, struct x
 {
 	u8 msg_buffer[XPNET_MSG_SIZE];
 	struct xpnet_message *msg = (struct xpnet_message *)&msg_buffer;
+	u16 msg_size = sizeof(struct xpnet_message);
 	enum xp_retval ret;
 
 	msg->embedded_bytes = embedded_bytes;
@@ -417,6 +417,7 @@ xpnet_send(struct sk_buff *skb, struct x
 			&msg->data, skb->data, (size_t)embedded_bytes);
 		skb_copy_from_linear_data(skb, &msg->data,
 					  (size_t)embedded_bytes);
+		msg_size += embedded_bytes - 1;
 	} else {
 		msg->version = XPNET_VERSION;
 	}
@@ -435,7 +436,7 @@ xpnet_send(struct sk_buff *skb, struct x
 	atomic_inc(&queued_msg->use_count);
 
 	ret = xpc_send_notify(dest_partid, XPC_NET_CHANNEL, XPC_NOWAIT, msg,
-			      XPNET_MSG_SIZE, xpnet_send_completed, queued_msg);
+			      msg_size, xpnet_send_completed, queued_msg);
 	if (unlikely(ret != xpSuccess))
 		atomic_dec(&queued_msg->use_count);
 }
_

Patches currently in -mm which might be from dcn@sgi.com are

sgi-xp-define-is_shub-and-is_uv-macros.patch
sgi-xp-define-xpsalerror-reason-code.patch
sgi-xp-define-bytes_per_word.patch
sgi-xp-support-runtime-selection-of-xp_max_npartitions.patch
sgi-xp-create-a-common-xp_remote_memcpy-function.patch
sgi-xp-prepare-xpc_rsvd_page-to-work-on-either-sn2-or-uv-hardware.patch
sgi-xp-isolate-xpc_vars_part-structure-to-sn2-only.patch
sgi-xp-isolate-xpc_vars-structure-to-sn2-only.patch
sgi-xp-base-xpc_rsvd_pages-timestamp-on-jiffies.patch
sgi-xp-move-xpc_allocate-into-xpc_send-xpc_send_notify.patch
sgi-xp-isolate-activate-irqs-hardware-specific-components.patch
sgi-xp-isolate-additional-sn2-specific-code.patch
sgi-xp-separate-chctl_flags-from-xpcs-notify-irq.patch
sgi-xp-replace-amo_t-typedef-by-struct-amo.patch
sgi-xp-isolate-allocation-of-xpcs-msgqueues-to-sn2-only.patch
sgi-xp-enable-xpnet-to-handle-more-than-64-partitions.patch
sgi-xp-isolate-remote-copy-buffer-to-sn2-only.patch
sgi-xp-add-_sn2-suffix-to-a-few-variables.patch
sgi-xp-eliminate-in-comments.patch
sgi-xp-use-standard-bitops-macros-and-functions.patch
sgi-xp-add-jiffies-to-reserved-pages-timestamp-name.patch
sgi-xp-enable-building-of-xpc-xpnet-on-x86_64.patch
sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy.patch
sgi-xp-move-xpc_check_remote_hb-to-support-both-sn2-and-uv.patch
sgi-xp-cleanup-naming-of-partition-defines.patch
sgi-xp-setup-the-activate-gru-message-queue.patch
sgi-xp-setup-the-notify-gru-message-queue.patch

