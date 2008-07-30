From: akpm@linux-foundation.org
Subject: - sgi-xp-move-xpc_allocate-into-xpc_send-xpc_send_notify.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:16:36 -0700
Message-ID: <200807301916.m6UJGar9011139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470AbYG3TYN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:24:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-xp: move xpc_allocate() into xpc_send()/xpc_send_notify()
has been removed from the -mm tree.  Its filename was
     sgi-xp-move-xpc_allocate-into-xpc_send-xpc_send_notify.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp: move xpc_allocate() into xpc_send()/xpc_send_notify()
From: Dean Nelson <dcn@sgi.com>

Move xpc_allocate() functionality into xpc_send()/xpc_send_notify() so
xpc_allocate() no longer needs to be called by XPNET.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xp.h          |   44 ++++-------
 drivers/misc/sgi-xp/xp_main.c     |   23 ++---
 drivers/misc/sgi-xp/xpc.h         |    9 --
 drivers/misc/sgi-xp/xpc_channel.c |  112 +++++++++-------------------
 drivers/misc/sgi-xp/xpc_main.c    |   14 +--
 drivers/misc/sgi-xp/xpc_sn2.c     |   64 +++++++---------
 drivers/misc/sgi-xp/xpnet.c       |   11 +-
 7 files changed, 106 insertions(+), 171 deletions(-)

diff -puN drivers/misc/sgi-xp/xp.h~sgi-xp-move-xpc_allocate-into-xpc_send-xpc_send_notify drivers/misc/sgi-xp/xp.h
--- a/drivers/misc/sgi-xp/xp.h~sgi-xp-move-xpc_allocate-into-xpc_send-xpc_send_notify
+++ a/drivers/misc/sgi-xp/xp.h
@@ -116,12 +116,6 @@
  * The size of the payload is defined by the user via xpc_connect(). A user-
  * defined message resides in the payload area.
  *
- * The user should have no dealings with the message header, but only the
- * message's payload. When a message entry is allocated (via xpc_allocate())
- * a pointer to the payload area is returned and not the actual beginning of
- * the XPC message. The user then constructs a message in the payload area
- * and passes that pointer as an argument on xpc_send() or xpc_send_notify().
- *
  * The size of a message entry (within a message queue) must be a cacheline
  * sized multiple in order to facilitate the BTE transfer of messages from one
  * message queue to another. A macro, XPC_MSG_SIZE(), is provided for the user
@@ -221,9 +215,10 @@ enum xp_retval {
 	xpBteCopyError,		/* 52: bte_copy() returned error */
 	xpSalError,		/* 53: sn SAL error */
 	xpRsvdPageNotSet,	/* 54: the reserved page is not set up */
+	xpPayloadTooBig,	/* 55: payload too large for message slot */
 
-	xpUnsupported,		/* 55: unsupported functionality or resource */
-	xpUnknownReason		/* 56: unknown reason - must be last in enum */
+	xpUnsupported,		/* 56: unsupported functionality or resource */
+	xpUnknownReason		/* 57: unknown reason - must be last in enum */
 };
 
 /*
@@ -304,16 +299,15 @@ struct xpc_registration {
 
 #define XPC_CHANNEL_REGISTERED(_c)	(xpc_registrations[_c].func != NULL)
 
-/* the following are valid xpc_allocate() flags */
+/* the following are valid xpc_send() or xpc_send_notify() flags */
 #define XPC_WAIT	0	/* wait flag */
 #define XPC_NOWAIT	1	/* no wait flag */
 
 struct xpc_interface {
 	void (*connect) (int);
 	void (*disconnect) (int);
-	enum xp_retval (*allocate) (short, int, u32, void **);
-	enum xp_retval (*send) (short, int, void *);
-	enum xp_retval (*send_notify) (short, int, void *,
+	enum xp_retval (*send) (short, int, u32, void *, u16);
+	enum xp_retval (*send_notify) (short, int, u32, void *, u16,
 					xpc_notify_func, void *);
 	void (*received) (short, int, void *);
 	enum xp_retval (*partid_to_nasids) (short, void *);
@@ -323,10 +317,9 @@ extern struct xpc_interface xpc_interfac
 
 extern void xpc_set_interface(void (*)(int),
 			      void (*)(int),
-			      enum xp_retval (*)(short, int, u32, void **),
-			      enum xp_retval (*)(short, int, void *),
-			      enum xp_retval (*)(short, int, void *,
-						  xpc_notify_func, void *),
+			      enum xp_retval (*)(short, int, u32, void *, u16),
+			      enum xp_retval (*)(short, int, u32, void *, u16,
+						 xpc_notify_func, void *),
 			      void (*)(short, int, void *),
 			      enum xp_retval (*)(short, void *));
 extern void xpc_clear_interface(void);
@@ -336,22 +329,19 @@ extern enum xp_retval xpc_connect(int, x
 extern void xpc_disconnect(int);
 
 static inline enum xp_retval
-xpc_allocate(short partid, int ch_number, u32 flags, void **payload)
-{
-	return xpc_interface.allocate(partid, ch_number, flags, payload);
-}
-
-static inline enum xp_retval
-xpc_send(short partid, int ch_number, void *payload)
+xpc_send(short partid, int ch_number, u32 flags, void *payload,
+	 u16 payload_size)
 {
-	return xpc_interface.send(partid, ch_number, payload);
+	return xpc_interface.send(partid, ch_number, flags, payload,
+				  payload_size);
 }
 
 static inline enum xp_retval
-xpc_send_notify(short partid, int ch_number, void *payload,
-		xpc_notify_func func, void *key)
+xpc_send_notify(short partid, int ch_number, u32 flags, void *payload,
+		u16 payload_size, xpc_notify_func func, void *key)
 {
-	return xpc_interface.send_notify(partid, ch_number, payload, func, key);
+	return xpc_interface.send_notify(partid, ch_number, flags, payload,
+					 payload_size, func, key);
 }
 
 static inline void
diff -puN drivers/misc/sgi-xp/xp_main.c~sgi-xp-move-xpc_allocate-into-xpc_send-xpc_send_notify drivers/misc/sgi-xp/xp_main.c
--- a/drivers/misc/sgi-xp/xp_main.c~sgi-xp-move-xpc_allocate-into-xpc_send-xpc_send_notify
+++ a/drivers/misc/sgi-xp/xp_main.c
@@ -58,10 +58,9 @@ xpc_notloaded(void)
 struct xpc_interface xpc_interface = {
 	(void (*)(int))xpc_notloaded,
 	(void (*)(int))xpc_notloaded,
-	(enum xp_retval(*)(short, int, u32, void **))xpc_notloaded,
-	(enum xp_retval(*)(short, int, void *))xpc_notloaded,
-	(enum xp_retval(*)(short, int, void *, xpc_notify_func, void *))
-	    xpc_notloaded,
+	(enum xp_retval(*)(short, int, u32, void *, u16))xpc_notloaded,
+	(enum xp_retval(*)(short, int, u32, void *, u16, xpc_notify_func,
+			   void *))xpc_notloaded,
 	(void (*)(short, int, void *))xpc_notloaded,
 	(enum xp_retval(*)(short, void *))xpc_notloaded
 };
@@ -73,16 +72,14 @@ EXPORT_SYMBOL_GPL(xpc_interface);
 void
 xpc_set_interface(void (*connect) (int),
 		  void (*disconnect) (int),
-		  enum xp_retval (*allocate) (short, int, u32, void **),
-		  enum xp_retval (*send) (short, int, void *),
-		  enum xp_retval (*send_notify) (short, int, void *,
+		  enum xp_retval (*send) (short, int, u32, void *, u16),
+		  enum xp_retval (*send_notify) (short, int, u32, void *, u16,
 						  xpc_notify_func, void *),
 		  void (*received) (short, int, void *),
 		  enum xp_retval (*partid_to_nasids) (short, void *))
 {
 	xpc_interface.connect = connect;
 	xpc_interface.disconnect = disconnect;
-	xpc_interface.allocate = allocate;
 	xpc_interface.send = send;
 	xpc_interface.send_notify = send_notify;
 	xpc_interface.received = received;
@@ -98,13 +95,11 @@ xpc_clear_interface(void)
 {
 	xpc_interface.connect = (void (*)(int))xpc_notloaded;
 	xpc_interface.disconnect = (void (*)(int))xpc_notloaded;
-	xpc_interface.allocate = (enum xp_retval(*)(short, int, u32,
-						     void **))xpc_notloaded;
-	xpc_interface.send = (enum xp_retval(*)(short, int, void *))
+	xpc_interface.send = (enum xp_retval(*)(short, int, u32, void *, u16))
 	    xpc_notloaded;
-	xpc_interface.send_notify = (enum xp_retval(*)(short, int, void *,
-							xpc_notify_func,
-							void *))xpc_notloaded;
+	xpc_interface.send_notify = (enum xp_retval(*)(short, int, u32, void *,
+						       u16, xpc_notify_func,
+						       void *))xpc_notloaded;
 	xpc_interface.received = (void (*)(short, int, void *))
 	    xpc_notloaded;
 	xpc_interface.partid_to_nasids = (enum xp_retval(*)(short, void *))
diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xp-move-xpc_allocate-into-xpc_send-xpc_send_notify drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xp-move-xpc_allocate-into-xpc_send-xpc_send_notify
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -624,9 +624,7 @@ extern void (*xpc_IPI_send_closereply) (
 extern void (*xpc_IPI_send_openrequest) (struct xpc_channel *, unsigned long *);
 extern void (*xpc_IPI_send_openreply) (struct xpc_channel *, unsigned long *);
 
-extern enum xp_retval (*xpc_allocate_msg) (struct xpc_channel *, u32,
-					   struct xpc_msg **);
-extern enum xp_retval (*xpc_send_msg) (struct xpc_channel *, struct xpc_msg *,
+extern enum xp_retval (*xpc_send_msg) (struct xpc_channel *, u32, void *, u16,
 				       u8, xpc_notify_func, void *);
 extern void (*xpc_received_msg) (struct xpc_channel *, struct xpc_msg *);
 
@@ -664,9 +662,8 @@ extern void *xpc_kzalloc_cacheline_align
 extern void xpc_initiate_connect(int);
 extern void xpc_initiate_disconnect(int);
 extern enum xp_retval xpc_allocate_msg_wait(struct xpc_channel *);
-extern enum xp_retval xpc_initiate_allocate(short, int, u32, void **);
-extern enum xp_retval xpc_initiate_send(short, int, void *);
-extern enum xp_retval xpc_initiate_send_notify(short, int, void *,
+extern enum xp_retval xpc_initiate_send(short, int, u32, void *, u16);
+extern enum xp_retval xpc_initiate_send_notify(short, int, u32, void *, u16,
 					       xpc_notify_func, void *);
 extern void xpc_initiate_received(short, int, void *);
 extern void xpc_process_channel_activity(struct xpc_partition *);
diff -puN drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-move-xpc_allocate-into-xpc_send-xpc_send_notify drivers/misc/sgi-xp/xpc_channel.c
--- a/drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-move-xpc_allocate-into-xpc_send-xpc_send_notify
+++ a/drivers/misc/sgi-xp/xpc_channel.c
@@ -1192,87 +1192,54 @@ xpc_allocate_msg_wait(struct xpc_channel
 }
 
 /*
- * Allocate an entry for a message from the message queue associated with the
- * specified channel. NOTE that this routine can sleep waiting for a message
- * entry to become available. To not sleep, pass in the XPC_NOWAIT flag.
+ * Send a message that contains the user's payload on the specified channel
+ * connected to the specified partition.
  *
- * Arguments:
+ * NOTE that this routine can sleep waiting for a message entry to become
+ * available. To not sleep, pass in the XPC_NOWAIT flag.
  *
- *	partid - ID of partition to which the channel is connected.
- *	ch_number - channel #.
- *	flags - see xpc.h for valid flags.
- *	payload - address of the allocated payload area pointer (filled in on
- * 	          return) in which the user-defined message is constructed.
- */
-enum xp_retval
-xpc_initiate_allocate(short partid, int ch_number, u32 flags, void **payload)
-{
-	struct xpc_partition *part = &xpc_partitions[partid];
-	enum xp_retval ret = xpUnknownReason;
-	struct xpc_msg *msg = NULL;
-
-	DBUG_ON(partid < 0 || partid >= xp_max_npartitions);
-	DBUG_ON(ch_number < 0 || ch_number >= part->nchannels);
-
-	*payload = NULL;
-
-	if (xpc_part_ref(part)) {
-		ret = xpc_allocate_msg(&part->channels[ch_number], flags, &msg);
-		xpc_part_deref(part);
-
-		if (msg != NULL)
-			*payload = &msg->payload;
-	}
-
-	return ret;
-}
-
-/*
- * Send a message previously allocated using xpc_initiate_allocate() on the
- * specified channel connected to the specified partition.
- *
- * This routine will not wait for the message to be received, nor will
- * notification be given when it does happen. Once this routine has returned
- * the message entry allocated via xpc_initiate_allocate() is no longer
- * accessable to the caller.
- *
- * This routine, although called by users, does not call xpc_part_ref() to
- * ensure that the partition infrastructure is in place. It relies on the
- * fact that we called xpc_msgqueue_ref() in xpc_allocate_msg().
+ * Once sent, this routine will not wait for the message to be received, nor
+ * will notification be given when it does happen.
  *
  * Arguments:
  *
  *	partid - ID of partition to which the channel is connected.
  *	ch_number - channel # to send message on.
- *	payload - pointer to the payload area allocated via
- *			xpc_initiate_allocate().
+ *	flags - see xp.h for valid flags.
+ *	payload - pointer to the payload which is to be sent.
+ *	payload_size - size of the payload in bytes.
  */
 enum xp_retval
-xpc_initiate_send(short partid, int ch_number, void *payload)
+xpc_initiate_send(short partid, int ch_number, u32 flags, void *payload,
+		  u16 payload_size)
 {
 	struct xpc_partition *part = &xpc_partitions[partid];
-	struct xpc_msg *msg = XPC_MSG_ADDRESS(payload);
-	enum xp_retval ret;
+	enum xp_retval ret = xpUnknownReason;
 
-	dev_dbg(xpc_chan, "msg=0x%p, partid=%d, channel=%d\n", (void *)msg,
+	dev_dbg(xpc_chan, "payload=0x%p, partid=%d, channel=%d\n", payload,
 		partid, ch_number);
 
 	DBUG_ON(partid < 0 || partid >= xp_max_npartitions);
 	DBUG_ON(ch_number < 0 || ch_number >= part->nchannels);
-	DBUG_ON(msg == NULL);
+	DBUG_ON(payload == NULL);
 
-	ret = xpc_send_msg(&part->channels[ch_number], msg, 0, NULL, NULL);
+	if (xpc_part_ref(part)) {
+		ret = xpc_send_msg(&part->channels[ch_number], flags, payload,
+				   payload_size, 0, NULL, NULL);
+		xpc_part_deref(part);
+	}
 
 	return ret;
 }
 
 /*
- * Send a message previously allocated using xpc_initiate_allocate on the
- * specified channel connected to the specified partition.
+ * Send a message that contains the user's payload on the specified channel
+ * connected to the specified partition.
  *
- * This routine will not wait for the message to be sent. Once this routine
- * has returned the message entry allocated via xpc_initiate_allocate() is no
- * longer accessable to the caller.
+ * NOTE that this routine can sleep waiting for a message entry to become
+ * available. To not sleep, pass in the XPC_NOWAIT flag.
+ *
+ * This routine will not wait for the message to be sent or received.
  *
  * Once the remote end of the channel has received the message, the function
  * passed as an argument to xpc_initiate_send_notify() will be called. This
@@ -1282,38 +1249,37 @@ xpc_initiate_send(short partid, int ch_n
  *
  * If this routine returns an error, the caller's function will NOT be called.
  *
- * This routine, although called by users, does not call xpc_part_ref() to
- * ensure that the partition infrastructure is in place. It relies on the
- * fact that we called xpc_msgqueue_ref() in xpc_allocate_msg().
- *
  * Arguments:
  *
  *	partid - ID of partition to which the channel is connected.
  *	ch_number - channel # to send message on.
- *	payload - pointer to the payload area allocated via
- *			xpc_initiate_allocate().
+ *	flags - see xp.h for valid flags.
+ *	payload - pointer to the payload which is to be sent.
+ *	payload_size - size of the payload in bytes.
  *	func - function to call with asynchronous notification of message
  *		  receipt. THIS FUNCTION MUST BE NON-BLOCKING.
  *	key - user-defined key to be passed to the function when it's called.
  */
 enum xp_retval
-xpc_initiate_send_notify(short partid, int ch_number, void *payload,
-			 xpc_notify_func func, void *key)
+xpc_initiate_send_notify(short partid, int ch_number, u32 flags, void *payload,
+			 u16 payload_size, xpc_notify_func func, void *key)
 {
 	struct xpc_partition *part = &xpc_partitions[partid];
-	struct xpc_msg *msg = XPC_MSG_ADDRESS(payload);
-	enum xp_retval ret;
+	enum xp_retval ret = xpUnknownReason;
 
-	dev_dbg(xpc_chan, "msg=0x%p, partid=%d, channel=%d\n", (void *)msg,
+	dev_dbg(xpc_chan, "payload=0x%p, partid=%d, channel=%d\n", payload,
 		partid, ch_number);
 
 	DBUG_ON(partid < 0 || partid >= xp_max_npartitions);
 	DBUG_ON(ch_number < 0 || ch_number >= part->nchannels);
-	DBUG_ON(msg == NULL);
+	DBUG_ON(payload == NULL);
 	DBUG_ON(func == NULL);
 
-	ret = xpc_send_msg(&part->channels[ch_number], msg, XPC_N_CALL,
-			   func, key);
+	if (xpc_part_ref(part)) {
+		ret = xpc_send_msg(&part->channels[ch_number], flags, payload,
+				   payload_size, XPC_N_CALL, func, key);
+		xpc_part_deref(part);
+	}
 	return ret;
 }
 
@@ -1372,7 +1338,7 @@ xpc_deliver_msg(struct xpc_channel *ch)
  *	partid - ID of partition to which the channel is connected.
  *	ch_number - channel # message received on.
  *	payload - pointer to the payload area allocated via
- *			xpc_initiate_allocate().
+ *			xpc_initiate_send() or xpc_initiate_send_notify().
  */
 void
 xpc_initiate_received(short partid, int ch_number, void *payload)
diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-xp-move-xpc_allocate-into-xpc_send-xpc_send_notify drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xp-move-xpc_allocate-into-xpc_send-xpc_send_notify
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -217,12 +217,9 @@ void (*xpc_IPI_send_openrequest) (struct
 void (*xpc_IPI_send_openreply) (struct xpc_channel *ch,
 				unsigned long *irq_flags);
 
-enum xp_retval (*xpc_allocate_msg) (struct xpc_channel *ch, u32 flags,
-				    struct xpc_msg **address_of_msg);
-
-enum xp_retval (*xpc_send_msg) (struct xpc_channel *ch, struct xpc_msg *msg,
-				u8 notify_type, xpc_notify_func func,
-				void *key);
+enum xp_retval (*xpc_send_msg) (struct xpc_channel *ch, u32 flags,
+				void *payload, u16 payload_size, u8 notify_type,
+				xpc_notify_func func, void *key);
 void (*xpc_received_msg) (struct xpc_channel *ch, struct xpc_msg *msg);
 
 /*
@@ -1286,9 +1283,8 @@ xpc_init(void)
 
 	/* set the interface to point at XPC's functions */
 	xpc_set_interface(xpc_initiate_connect, xpc_initiate_disconnect,
-			  xpc_initiate_allocate, xpc_initiate_send,
-			  xpc_initiate_send_notify, xpc_initiate_received,
-			  xpc_initiate_partid_to_nasids);
+			  xpc_initiate_send, xpc_initiate_send_notify,
+			  xpc_initiate_received, xpc_initiate_partid_to_nasids);
 
 	return 0;
 
diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-move-xpc_allocate-into-xpc_send-xpc_send_notify drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-move-xpc_allocate-into-xpc_send-xpc_send_notify
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -1532,18 +1532,6 @@ xpc_allocate_msg_sn2(struct xpc_channel 
 	enum xp_retval ret;
 	s64 put;
 
-	/* this reference will be dropped in xpc_send_msg_sn2() */
-	xpc_msgqueue_ref(ch);
-
-	if (ch->flags & XPC_C_DISCONNECTING) {
-		xpc_msgqueue_deref(ch);
-		return ch->reason;
-	}
-	if (!(ch->flags & XPC_C_CONNECTED)) {
-		xpc_msgqueue_deref(ch);
-		return xpNotConnected;
-	}
-
 	/*
 	 * Get the next available message entry from the local message queue.
 	 * If none are available, we'll make sure that we grab the latest
@@ -1582,16 +1570,12 @@ xpc_allocate_msg_sn2(struct xpc_channel 
 		if (ret == xpTimeout)
 			xpc_IPI_send_local_msgrequest_sn2(ch);
 
-		if (flags & XPC_NOWAIT) {
-			xpc_msgqueue_deref(ch);
+		if (flags & XPC_NOWAIT)
 			return xpNoWait;
-		}
 
 		ret = xpc_allocate_msg_wait(ch);
-		if (ret != xpInterrupted && ret != xpTimeout) {
-			xpc_msgqueue_deref(ch);
+		if (ret != xpInterrupted && ret != xpTimeout)
 			return ret;
-		}
 	}
 
 	/* get the message's address and initialize it */
@@ -1606,7 +1590,6 @@ xpc_allocate_msg_sn2(struct xpc_channel 
 		(void *)msg, msg->number, ch->partid, ch->number);
 
 	*address_of_msg = msg;
-
 	return xpSuccess;
 }
 
@@ -1616,23 +1599,37 @@ xpc_allocate_msg_sn2(struct xpc_channel 
  * message is being sent to.
  */
 static enum xp_retval
-xpc_send_msg_sn2(struct xpc_channel *ch, struct xpc_msg *msg, u8 notify_type,
-		 xpc_notify_func func, void *key)
+xpc_send_msg_sn2(struct xpc_channel *ch, u32 flags, void *payload,
+		 u16 payload_size, u8 notify_type, xpc_notify_func func,
+		 void *key)
 {
 	enum xp_retval ret = xpSuccess;
+	struct xpc_msg *msg = msg;
 	struct xpc_notify *notify = notify;
-	s64 put, msg_number = msg->number;
+	s64 msg_number;
+	s64 put;
 
 	DBUG_ON(notify_type == XPC_N_CALL && func == NULL);
-	DBUG_ON((((u64)msg - (u64)ch->local_msgqueue) / ch->msg_size) !=
-		msg_number % ch->local_nentries);
-	DBUG_ON(msg->flags & XPC_M_READY);
+
+	if (XPC_MSG_SIZE(payload_size) > ch->msg_size)
+		return xpPayloadTooBig;
+
+	xpc_msgqueue_ref(ch);
 
 	if (ch->flags & XPC_C_DISCONNECTING) {
-		/* drop the reference grabbed in xpc_allocate_msg_sn2() */
-		xpc_msgqueue_deref(ch);
-		return ch->reason;
+		ret = ch->reason;
+		goto out_1;
 	}
+	if (!(ch->flags & XPC_C_CONNECTED)) {
+		ret = xpNotConnected;
+		goto out_1;
+	}
+
+	ret = xpc_allocate_msg_sn2(ch, flags, &msg);
+	if (ret != xpSuccess)
+		goto out_1;
+
+	msg_number = msg->number;
 
 	if (notify_type != 0) {
 		/*
@@ -1663,13 +1660,12 @@ xpc_send_msg_sn2(struct xpc_channel *ch,
 				atomic_dec(&ch->n_to_notify);
 				ret = ch->reason;
 			}
-
-			/* drop reference grabbed in xpc_allocate_msg_sn2() */
-			xpc_msgqueue_deref(ch);
-			return ret;
+			goto out_1;
 		}
 	}
 
+	memcpy(&msg->payload, payload, payload_size);
+
 	msg->flags |= XPC_M_READY;
 
 	/*
@@ -1684,7 +1680,7 @@ xpc_send_msg_sn2(struct xpc_channel *ch,
 	if (put == msg_number)
 		xpc_send_msgs_sn2(ch, put);
 
-	/* drop the reference grabbed in xpc_allocate_msg_sn2() */
+out_1:
 	xpc_msgqueue_deref(ch);
 	return ret;
 }
@@ -1821,8 +1817,6 @@ xpc_init_sn2(void)
 	xpc_IPI_send_openrequest = xpc_IPI_send_openrequest_sn2;
 	xpc_IPI_send_openreply = xpc_IPI_send_openreply_sn2;
 
-	xpc_allocate_msg = xpc_allocate_msg_sn2;
-
 	xpc_send_msg = xpc_send_msg_sn2;
 	xpc_received_msg = xpc_received_msg_sn2;
 }
diff -puN drivers/misc/sgi-xp/xpnet.c~sgi-xp-move-xpc_allocate-into-xpc_send-xpc_send_notify drivers/misc/sgi-xp/xpnet.c
--- a/drivers/misc/sgi-xp/xpnet.c~sgi-xp-move-xpc_allocate-into-xpc_send-xpc_send_notify
+++ a/drivers/misc/sgi-xp/xpnet.c
@@ -438,7 +438,8 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 {
 	struct xpnet_pending_msg *queued_msg;
 	enum xp_retval ret;
-	struct xpnet_message *msg;
+	u8 msg_buffer[XPNET_MSG_SIZE];
+	struct xpnet_message *msg = (struct xpnet_message *)&msg_buffer[0];
 	u64 start_addr, end_addr;
 	long dp;
 	u8 second_mac_octet;
@@ -524,11 +525,6 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 
 		/* found a partition to send to */
 
-		ret = xpc_allocate(dest_partid, XPC_NET_CHANNEL,
-				   XPC_NOWAIT, (void **)&msg);
-		if (unlikely(ret != xpSuccess))
-			continue;
