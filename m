From: akpm@linux-foundation.org
Subject: + sgi-xp-clean-up-numerous-globals.patch added to -mm tree
Date: Tue, 07 Apr 2009 21:48:19 -0700
Message-ID: <200904080448.n384mJ9e032263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871AbZDHEuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Apr 2009 00:50:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, dcn@sgi.com


The patch titled
     sgi-xp: clean up numerous globals
has been added to the -mm tree.  Its filename is
     sgi-xp-clean-up-numerous-globals.patch

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
Subject: sgi-xp: clean up numerous globals
From: Robin Holt <holt@sgi.com>

Introduce xpc_arch_ops and eliminate numerous individual global definitions.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc.h           |  112 +++++++++++-----------
 drivers/misc/sgi-xp/xpc_channel.c   |   43 ++++----
 drivers/misc/sgi-xp/xpc_main.c      |  130 +++++++-------------------
 drivers/misc/sgi-xp/xpc_partition.c |   20 ++--
 drivers/misc/sgi-xp/xpc_sn2.c       |  122 ++++++++++++------------
 drivers/misc/sgi-xp/xpc_uv.c        |  122 ++++++++++++------------
 6 files changed, 254 insertions(+), 295 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xp-clean-up-numerous-globals drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xp-clean-up-numerous-globals
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -780,6 +780,62 @@ struct xpc_partition {
 
 } ____cacheline_aligned;
 
+struct xpc_arch_operations {
+	int (*setup_partitions) (void);
+	void (*teardown_partitions) (void);
+	void (*process_activate_IRQ_rcvd) (void);
+	enum xp_retval (*get_partition_rsvd_page_pa)
+		(void *, u64 *, unsigned long *, size_t *);
+	int (*setup_rsvd_page) (struct xpc_rsvd_page *);
+
+	void (*allow_hb) (short);
+	void (*disallow_hb) (short);
+	void (*disallow_all_hbs) (void);
+	void (*increment_heartbeat) (void);
+	void (*offline_heartbeat) (void);
+	void (*online_heartbeat) (void);
+	void (*heartbeat_init) (void);
+	void (*heartbeat_exit) (void);
+	enum xp_retval (*get_remote_heartbeat) (struct xpc_partition *);
+
+	void (*request_partition_activation) (struct xpc_rsvd_page *,
+						 unsigned long, int);
+	void (*request_partition_reactivation) (struct xpc_partition *);
+	void (*request_partition_deactivation) (struct xpc_partition *);
+	void (*cancel_partition_deactivation_request) (struct xpc_partition *);
+	enum xp_retval (*setup_ch_structures) (struct xpc_partition *);
+	void (*teardown_ch_structures) (struct xpc_partition *);
+
+	enum xp_retval (*make_first_contact) (struct xpc_partition *);
+
+	u64 (*get_chctl_all_flags) (struct xpc_partition *);
+	void (*send_chctl_closerequest) (struct xpc_channel *, unsigned long *);
+	void (*send_chctl_closereply) (struct xpc_channel *, unsigned long *);
+	void (*send_chctl_openrequest) (struct xpc_channel *, unsigned long *);
+	void (*send_chctl_openreply) (struct xpc_channel *, unsigned long *);
+	void (*send_chctl_opencomplete) (struct xpc_channel *, unsigned long *);
+	void (*process_msg_chctl_flags) (struct xpc_partition *, int);
+
+	enum xp_retval (*save_remote_msgqueue_pa) (struct xpc_channel *,
+						      unsigned long);
+
+	enum xp_retval (*setup_msg_structures) (struct xpc_channel *);
+	void (*teardown_msg_structures) (struct xpc_channel *);
+
+	void (*indicate_partition_engaged) (struct xpc_partition *);
+	void (*indicate_partition_disengaged) (struct xpc_partition *);
+	void (*assume_partition_disengaged) (short);
+	int (*partition_engaged) (short);
+	int (*any_partition_engaged) (void);
+
+	int (*n_of_deliverable_payloads) (struct xpc_channel *);
+	enum xp_retval (*send_payload) (struct xpc_channel *, u32, void *,
+					   u16, u8, xpc_notify_func, void *);
+	void *(*get_deliverable_payload) (struct xpc_channel *);
+	void (*received_payload) (struct xpc_channel *, void *);
+	void (*notify_senders_of_disconnect) (struct xpc_channel *);
+};
+
 /* struct xpc_partition act_state values (for XPC HB) */
 
 #define	XPC_P_AS_INACTIVE	0x00	/* partition is not active */
@@ -820,6 +876,7 @@ extern struct xpc_registration xpc_regis
 /* found in xpc_main.c */
 extern struct device *xpc_part;
 extern struct device *xpc_chan;
+extern struct xpc_arch_operations xpc_arch_ops;
 extern int xpc_disengage_timelimit;
 extern int xpc_disengage_timedout;
 extern int xpc_activate_IRQ_rcvd;
@@ -830,61 +887,6 @@ extern void xpc_activate_partition(struc
 extern void xpc_activate_kthreads(struct xpc_channel *, int);
 extern void xpc_create_kthreads(struct xpc_channel *, int, int);
 extern void xpc_disconnect_wait(int);
-extern int (*xpc_setup_partitions_sn) (void);
-extern void (*xpc_teardown_partitions_sn) (void);
-extern enum xp_retval (*xpc_get_partition_rsvd_page_pa) (void *, u64 *,
-							 unsigned long *,
-							 size_t *);
-extern int (*xpc_setup_rsvd_page_sn) (struct xpc_rsvd_page *);
-extern void (*xpc_heartbeat_init) (void);
-extern void (*xpc_heartbeat_exit) (void);
-extern void (*xpc_increment_heartbeat) (void);
-extern void (*xpc_offline_heartbeat) (void);
-extern void (*xpc_online_heartbeat) (void);
-extern enum xp_retval (*xpc_get_remote_heartbeat) (struct xpc_partition *);
-extern void (*xpc_allow_hb) (short);
-extern void (*xpc_disallow_hb) (short);
-extern void (*xpc_disallow_all_hbs) (void);
-extern enum xp_retval (*xpc_make_first_contact) (struct xpc_partition *);
-extern u64 (*xpc_get_chctl_all_flags) (struct xpc_partition *);
-extern enum xp_retval (*xpc_setup_msg_structures) (struct xpc_channel *);
-extern void (*xpc_teardown_msg_structures) (struct xpc_channel *);
-extern void (*xpc_notify_senders_of_disconnect) (struct xpc_channel *);
-extern void (*xpc_process_msg_chctl_flags) (struct xpc_partition *, int);
-extern int (*xpc_n_of_deliverable_payloads) (struct xpc_channel *);
-extern void *(*xpc_get_deliverable_payload) (struct xpc_channel *);
-extern void (*xpc_request_partition_activation) (struct xpc_rsvd_page *,
-						 unsigned long, int);
-extern void (*xpc_request_partition_reactivation) (struct xpc_partition *);
-extern void (*xpc_request_partition_deactivation) (struct xpc_partition *);
-extern void (*xpc_cancel_partition_deactivation_request) (
-							struct xpc_partition *);
-extern void (*xpc_process_activate_IRQ_rcvd) (void);
-extern enum xp_retval (*xpc_setup_ch_structures_sn) (struct xpc_partition *);
-extern void (*xpc_teardown_ch_structures_sn) (struct xpc_partition *);
-
-extern void (*xpc_indicate_partition_engaged) (struct xpc_partition *);
-extern int (*xpc_partition_engaged) (short);
-extern int (*xpc_any_partition_engaged) (void);
-extern void (*xpc_indicate_partition_disengaged) (struct xpc_partition *);
-extern void (*xpc_assume_partition_disengaged) (short);
-
-extern void (*xpc_send_chctl_closerequest) (struct xpc_channel *,
-					    unsigned long *);
-extern void (*xpc_send_chctl_closereply) (struct xpc_channel *,
-					  unsigned long *);
-extern void (*xpc_send_chctl_openrequest) (struct xpc_channel *,
-					   unsigned long *);
-extern void (*xpc_send_chctl_openreply) (struct xpc_channel *, unsigned long *);
-extern void (*xpc_send_chctl_opencomplete) (struct xpc_channel *,
-					    unsigned long *);
-
-extern enum xp_retval (*xpc_save_remote_msgqueue_pa) (struct xpc_channel *,
-						      unsigned long);
-
-extern enum xp_retval (*xpc_send_payload) (struct xpc_channel *, u32, void *,
-					   u16, u8, xpc_notify_func, void *);
-extern void (*xpc_received_payload) (struct xpc_channel *, void *);
 
 /* found in xpc_sn2.c */
 extern int xpc_init_sn2(void);
diff -puN drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-clean-up-numerous-globals drivers/misc/sgi-xp/xpc_channel.c
--- a/drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-clean-up-numerous-globals
+++ a/drivers/misc/sgi-xp/xpc_channel.c
@@ -39,7 +39,7 @@ xpc_process_connect(struct xpc_channel *
 
 	if (!(ch->flags & XPC_C_SETUP)) {
 		spin_unlock_irqrestore(&ch->lock, *irq_flags);
-		ret = xpc_setup_msg_structures(ch);
+		ret = xpc_arch_ops.setup_msg_structures(ch);
 		spin_lock_irqsave(&ch->lock, *irq_flags);
 
 		if (ret != xpSuccess)
@@ -53,7 +53,7 @@ xpc_process_connect(struct xpc_channel *
 
 	if (!(ch->flags & XPC_C_OPENREPLY)) {
 		ch->flags |= XPC_C_OPENREPLY;
-		xpc_send_chctl_openreply(ch, irq_flags);
+		xpc_arch_ops.send_chctl_openreply(ch, irq_flags);
 	}
 
 	if (!(ch->flags & XPC_C_ROPENREPLY))
@@ -61,7 +61,7 @@ xpc_process_connect(struct xpc_channel *
 
 	if (!(ch->flags & XPC_C_OPENCOMPLETE)) {
 		ch->flags |= (XPC_C_OPENCOMPLETE | XPC_C_CONNECTED);
-		xpc_send_chctl_opencomplete(ch, irq_flags);
+		xpc_arch_ops.send_chctl_opencomplete(ch, irq_flags);
 	}
 
 	if (!(ch->flags & XPC_C_ROPENCOMPLETE))
@@ -100,7 +100,7 @@ xpc_process_disconnect(struct xpc_channe
 
 	if (part->act_state == XPC_P_AS_DEACTIVATING) {
 		/* can't proceed until the other side disengages from us */
-		if (xpc_partition_engaged(ch->partid))
+		if (xpc_arch_ops.partition_engaged(ch->partid))
 			return;
 
 	} else {
@@ -112,7 +112,7 @@ xpc_process_disconnect(struct xpc_channe
 
 		if (!(ch->flags & XPC_C_CLOSEREPLY)) {
 			ch->flags |= XPC_C_CLOSEREPLY;
-			xpc_send_chctl_closereply(ch, irq_flags);
+			xpc_arch_ops.send_chctl_closereply(ch, irq_flags);
 		}
 
 		if (!(ch->flags & XPC_C_RCLOSEREPLY))
@@ -122,7 +122,7 @@ xpc_process_disconnect(struct xpc_channe
 	/* wake those waiting for notify completion */
 	if (atomic_read(&ch->n_to_notify) > 0) {
 		/* we do callout while holding ch->lock, callout can't block */
-		xpc_notify_senders_of_disconnect(ch);
+		xpc_arch_ops.notify_senders_of_disconnect(ch);
 	}
 
 	/* both sides are disconnected now */
@@ -136,7 +136,7 @@ xpc_process_disconnect(struct xpc_channe
 	DBUG_ON(atomic_read(&ch->n_to_notify) != 0);
 
 	/* it's now safe to free the channel's message queues */
-	xpc_teardown_msg_structures(ch);
+	xpc_arch_ops.teardown_msg_structures(ch);
 
 	ch->func = NULL;
 	ch->key = NULL;
@@ -148,8 +148,9 @@ xpc_process_disconnect(struct xpc_channe
 
 	/*
 	 * Mark the channel disconnected and clear all other flags, including
-	 * XPC_C_SETUP (because of call to xpc_teardown_msg_structures()) but
-	 * not including XPC_C_WDISCONNECT (if it was set).
+	 * XPC_C_SETUP (because of call to
+	 * xpc_arch_ops.teardown_msg_structures()) but not including
+	 * XPC_C_WDISCONNECT (if it was set).
 	 */
 	ch->flags = (XPC_C_DISCONNECTED | (ch->flags & XPC_C_WDISCONNECT));
 
@@ -395,7 +396,8 @@ again:
 		DBUG_ON(args->local_nentries == 0);
 		DBUG_ON(args->remote_nentries == 0);
 
-		ret = xpc_save_remote_msgqueue_pa(ch, args->local_msgqueue_pa);
+		ret = xpc_arch_ops.save_remote_msgqueue_pa(ch,
+						      args->local_msgqueue_pa);
 		if (ret != xpSuccess) {
 			XPC_DISCONNECT_CHANNEL(ch, ret, &irq_flags);
 			goto out;
@@ -531,7 +533,7 @@ xpc_connect_channel(struct xpc_channel *
 	/* initiate the connection */
 
 	ch->flags |= (XPC_C_OPENREQUEST | XPC_C_CONNECTING);
-	xpc_send_chctl_openrequest(ch, &irq_flags);
+	xpc_arch_ops.send_chctl_openrequest(ch, &irq_flags);
 
 	xpc_process_connect(ch, &irq_flags);
 
@@ -549,7 +551,7 @@ xpc_process_sent_chctl_flags(struct xpc_
 	int ch_number;
 	u32 ch_flags;
 
-	chctl.all_flags = xpc_get_chctl_all_flags(part);
+	chctl.all_flags = xpc_arch_ops.get_chctl_all_flags(part);
 
 	/*
 	 * Initiate channel connections for registered channels.
@@ -598,7 +600,7 @@ xpc_process_sent_chctl_flags(struct xpc_
 		 */
 
 		if (chctl.flags[ch_number] & XPC_MSG_CHCTL_FLAGS)
-			xpc_process_msg_chctl_flags(part, ch_number);
+			xpc_arch_ops.process_msg_chctl_flags(part, ch_number);
 	}
 }
 
@@ -774,7 +776,7 @@ xpc_disconnect_channel(const int line, s
 		       XPC_C_ROPENREQUEST | XPC_C_ROPENREPLY |
 		       XPC_C_CONNECTING | XPC_C_CONNECTED);
 
-	xpc_send_chctl_closerequest(ch, irq_flags);
+	xpc_arch_ops.send_chctl_closerequest(ch, irq_flags);
 
 	if (channel_was_connected)
 		ch->flags |= XPC_C_WASCONNECTED;
@@ -881,8 +883,8 @@ xpc_initiate_send(short partid, int ch_n
 	DBUG_ON(payload == NULL);
 
 	if (xpc_part_ref(part)) {
-		ret = xpc_send_payload(&part->channels[ch_number], flags,
-				       payload, payload_size, 0, NULL, NULL);
+		ret = xpc_arch_ops.send_payload(&part->channels[ch_number],
+				  flags, payload, payload_size, 0, NULL, NULL);
 		xpc_part_deref(part);
 	}
 
@@ -933,9 +935,8 @@ xpc_initiate_send_notify(short partid, i
 	DBUG_ON(func == NULL);
 
 	if (xpc_part_ref(part)) {
-		ret = xpc_send_payload(&part->channels[ch_number], flags,
-				       payload, payload_size, XPC_N_CALL, func,
-				       key);
+		ret = xpc_arch_ops.send_payload(&part->channels[ch_number],
+			  flags, payload, payload_size, XPC_N_CALL, func, key);
 		xpc_part_deref(part);
 	}
 	return ret;
@@ -949,7 +950,7 @@ xpc_deliver_payload(struct xpc_channel *
 {
 	void *payload;
 
-	payload = xpc_get_deliverable_payload(ch);
+	payload = xpc_arch_ops.get_deliverable_payload(ch);
 	if (payload != NULL) {
 
 		/*
@@ -1003,7 +1004,7 @@ xpc_initiate_received(short partid, int 
 	DBUG_ON(ch_number < 0 || ch_number >= part->nchannels);
 
 	ch = &part->channels[ch_number];
-	xpc_received_payload(ch, payload);
+	xpc_arch_ops.received_payload(ch, payload);
 
 	/* the call to xpc_msgqueue_ref() was done by xpc_deliver_payload()  */
 	xpc_msgqueue_deref(ch);
diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-xp-clean-up-numerous-globals drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xp-clean-up-numerous-globals
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -169,68 +169,7 @@ static struct notifier_block xpc_die_not
 	.notifier_call = xpc_system_die,
 };
 
-int (*xpc_setup_partitions_sn) (void);
-void (*xpc_teardown_partitions_sn) (void);
-enum xp_retval (*xpc_get_partition_rsvd_page_pa) (void *buf, u64 *cookie,
-						  unsigned long *rp_pa,
-						  size_t *len);
-int (*xpc_setup_rsvd_page_sn) (struct xpc_rsvd_page *rp);
-
-void (*xpc_allow_hb) (short partid);
-void (*xpc_disallow_hb) (short partid);
-void (*xpc_disallow_all_hbs) (void);
-void (*xpc_heartbeat_init) (void);
-void (*xpc_heartbeat_exit) (void);
-void (*xpc_increment_heartbeat) (void);
-void (*xpc_offline_heartbeat) (void);
-void (*xpc_online_heartbeat) (void);
-enum xp_retval (*xpc_get_remote_heartbeat) (struct xpc_partition *part);
-
-enum xp_retval (*xpc_make_first_contact) (struct xpc_partition *part);
-void (*xpc_notify_senders_of_disconnect) (struct xpc_channel *ch);
-u64 (*xpc_get_chctl_all_flags) (struct xpc_partition *part);
-enum xp_retval (*xpc_setup_msg_structures) (struct xpc_channel *ch);
-void (*xpc_teardown_msg_structures) (struct xpc_channel *ch);
-void (*xpc_process_msg_chctl_flags) (struct xpc_partition *part, int ch_number);
-int (*xpc_n_of_deliverable_payloads) (struct xpc_channel *ch);
-void *(*xpc_get_deliverable_payload) (struct xpc_channel *ch);
-
-void (*xpc_request_partition_activation) (struct xpc_rsvd_page *remote_rp,
-					  unsigned long remote_rp_pa,
-					  int nasid);
-void (*xpc_request_partition_reactivation) (struct xpc_partition *part);
-void (*xpc_request_partition_deactivation) (struct xpc_partition *part);
-void (*xpc_cancel_partition_deactivation_request) (struct xpc_partition *part);
-
-void (*xpc_process_activate_IRQ_rcvd) (void);
-enum xp_retval (*xpc_setup_ch_structures_sn) (struct xpc_partition *part);
-void (*xpc_teardown_ch_structures_sn) (struct xpc_partition *part);
-
-void (*xpc_indicate_partition_engaged) (struct xpc_partition *part);
-int (*xpc_partition_engaged) (short partid);
-int (*xpc_any_partition_engaged) (void);
-void (*xpc_indicate_partition_disengaged) (struct xpc_partition *part);
-void (*xpc_assume_partition_disengaged) (short partid);
-
-void (*xpc_send_chctl_closerequest) (struct xpc_channel *ch,
-				     unsigned long *irq_flags);
-void (*xpc_send_chctl_closereply) (struct xpc_channel *ch,
-				   unsigned long *irq_flags);
-void (*xpc_send_chctl_openrequest) (struct xpc_channel *ch,
-				    unsigned long *irq_flags);
-void (*xpc_send_chctl_openreply) (struct xpc_channel *ch,
-				  unsigned long *irq_flags);
-void (*xpc_send_chctl_opencomplete) (struct xpc_channel *ch,
-				  unsigned long *irq_flags);
-
-enum xp_retval (*xpc_save_remote_msgqueue_pa) (struct xpc_channel *ch,
-					       unsigned long msgqueue_pa);
-
-enum xp_retval (*xpc_send_payload) (struct xpc_channel *ch, u32 flags,
-				    void *payload, u16 payload_size,
-				    u8 notify_type, xpc_notify_func func,
-				    void *key);
-void (*xpc_received_payload) (struct xpc_channel *ch, void *payload);
+struct xpc_arch_operations xpc_arch_ops;
 
 /*
  * Timer function to enforce the timelimit on the partition disengage.
@@ -245,7 +184,7 @@ xpc_timeout_partition_disengage(unsigned
 	(void)xpc_partition_disengaged(part);
 
 	DBUG_ON(part->disengage_timeout != 0);
-	DBUG_ON(xpc_partition_engaged(XPC_PARTID(part)));
+	DBUG_ON(xpc_arch_ops.partition_engaged(XPC_PARTID(part)));
 }
 
 /*
@@ -256,7 +195,7 @@ xpc_timeout_partition_disengage(unsigned
 static void
 xpc_hb_beater(unsigned long dummy)
 {
-	xpc_increment_heartbeat();
+	xpc_arch_ops.increment_heartbeat();
 
 	if (time_is_before_eq_jiffies(xpc_hb_check_timeout))
 		wake_up_interruptible(&xpc_activate_IRQ_wq);
@@ -268,7 +207,7 @@ xpc_hb_beater(unsigned long dummy)
 static void
 xpc_start_hb_beater(void)
 {
-	xpc_heartbeat_init();
+	xpc_arch_ops.heartbeat_init();
 	init_timer(&xpc_hb_timer);
 	xpc_hb_timer.function = xpc_hb_beater;
 	xpc_hb_beater(0);
@@ -278,7 +217,7 @@ static void
 xpc_stop_hb_beater(void)
 {
 	del_timer_sync(&xpc_hb_timer);
-	xpc_heartbeat_exit();
+	xpc_arch_ops.heartbeat_exit();
 }
 
 /*
@@ -307,7 +246,7 @@ xpc_check_remote_hb(void)
 			continue;
 		}
 
-		ret = xpc_get_remote_heartbeat(part);
+		ret = xpc_arch_ops.get_remote_heartbeat(part);
 		if (ret != xpSuccess)
 			XPC_DEACTIVATE_PARTITION(part, ret);
 	}
@@ -358,7 +297,7 @@ xpc_hb_checker(void *ignore)
 			force_IRQ = 0;
 			dev_dbg(xpc_part, "processing activate IRQs "
 				"received\n");
-			xpc_process_activate_IRQ_rcvd();
+			xpc_arch_ops.process_activate_IRQ_rcvd();
 		}
 
 		/* wait for IRQ or timeout */
@@ -533,7 +472,7 @@ xpc_setup_ch_structures(struct xpc_parti
 		init_waitqueue_head(&ch->idle_wq);
 	}
 
-	ret = xpc_setup_ch_structures_sn(part);
+	ret = xpc_arch_ops.setup_ch_structures(part);
 	if (ret != xpSuccess)
 		goto out_2;
 
@@ -577,7 +516,7 @@ xpc_teardown_ch_structures(struct xpc_pa
 
 	/* now we can begin tearing down the infrastructure */
 
-	xpc_teardown_ch_structures_sn(part);
+	xpc_arch_ops.teardown_ch_structures(part);
 
 	kfree(part->remote_openclose_args_base);
 	part->remote_openclose_args = NULL;
@@ -625,12 +564,12 @@ xpc_activating(void *__partid)
 
 	dev_dbg(xpc_part, "activating partition %d\n", partid);
 
-	xpc_allow_hb(partid);
+	xpc_arch_ops.allow_hb(partid);
 
 	if (xpc_setup_ch_structures(part) == xpSuccess) {
 		(void)xpc_part_ref(part);	/* this will always succeed */
 
-		if (xpc_make_first_contact(part) == xpSuccess) {
+		if (xpc_arch_ops.make_first_contact(part) == xpSuccess) {
 			xpc_mark_partition_active(part);
 			xpc_channel_mgr(part);
 			/* won't return until partition is deactivating */
@@ -640,12 +579,12 @@ xpc_activating(void *__partid)
 		xpc_teardown_ch_structures(part);
 	}
 
-	xpc_disallow_hb(partid);
+	xpc_arch_ops.disallow_hb(partid);
 	xpc_mark_partition_inactive(part);
 
 	if (part->reason == xpReactivating) {
 		/* interrupting ourselves results in activating partition */
-		xpc_request_partition_reactivation(part);
+		xpc_arch_ops.request_partition_reactivation(part);
 	}
 
 	return 0;
@@ -718,10 +657,13 @@ xpc_activate_kthreads(struct xpc_channel
 static void
 xpc_kthread_waitmsgs(struct xpc_partition *part, struct xpc_channel *ch)
 {
+	int (*n_of_deliverable_payloads) (struct xpc_channel *) =
+		xpc_arch_ops.n_of_deliverable_payloads;
+
 	do {
 		/* deliver messages to their intended recipients */
 
-		while (xpc_n_of_deliverable_payloads(ch) > 0 &&
+		while (n_of_deliverable_payloads(ch) > 0 &&
 		       !(ch->flags & XPC_C_DISCONNECTING)) {
 			xpc_deliver_payload(ch);
 		}
@@ -737,7 +679,7 @@ xpc_kthread_waitmsgs(struct xpc_partitio
 			"wait_event_interruptible_exclusive()\n");
 
 		(void)wait_event_interruptible_exclusive(ch->idle_wq,
-				(xpc_n_of_deliverable_payloads(ch) > 0 ||
+				(n_of_deliverable_payloads(ch) > 0 ||
 				 (ch->flags & XPC_C_DISCONNECTING)));
 
 		atomic_dec(&ch->kthreads_idle);
@@ -754,6 +696,8 @@ xpc_kthread_start(void *args)
 	struct xpc_channel *ch;
 	int n_needed;
 	unsigned long irq_flags;
+	int (*n_of_deliverable_payloads) (struct xpc_channel *) =
+		xpc_arch_ops.n_of_deliverable_payloads;
 
 	dev_dbg(xpc_chan, "kthread starting, partid=%d, channel=%d\n",
 		partid, ch_number);
@@ -782,7 +726,7 @@ xpc_kthread_start(void *args)
 			 * additional kthreads to help deliver them. We only
 			 * need one less than total #of messages to deliver.
 			 */
-			n_needed = xpc_n_of_deliverable_payloads(ch) - 1;
+			n_needed = n_of_deliverable_payloads(ch) - 1;
 			if (n_needed > 0 && !(ch->flags & XPC_C_DISCONNECTING))
 				xpc_activate_kthreads(ch, n_needed);
 
@@ -810,7 +754,7 @@ xpc_kthread_start(void *args)
 
 	if (atomic_dec_return(&ch->kthreads_assigned) == 0 &&
 	    atomic_dec_return(&part->nchannels_engaged) == 0) {
-		xpc_indicate_partition_disengaged(part);
+		xpc_arch_ops.indicate_partition_disengaged(part);
 	}
 
 	xpc_msgqueue_deref(ch);
@@ -842,6 +786,8 @@ xpc_create_kthreads(struct xpc_channel *
 	u64 args = XPC_PACK_ARGS(ch->partid, ch->number);
 	struct xpc_partition *part = &xpc_partitions[ch->partid];
 	struct task_struct *kthread;
+	void (*indicate_partition_disengaged) (struct xpc_partition *) =
+		xpc_arch_ops.indicate_partition_disengaged;
 
 	while (needed-- > 0) {
 
@@ -863,7 +809,7 @@ xpc_create_kthreads(struct xpc_channel *
 
 		} else if (atomic_inc_return(&ch->kthreads_assigned) == 1 &&
 			   atomic_inc_return(&part->nchannels_engaged) == 1) {
-				xpc_indicate_partition_engaged(part);
+			xpc_arch_ops.indicate_partition_engaged(part);
 		}
 		(void)xpc_part_ref(part);
 		xpc_msgqueue_ref(ch);
@@ -885,7 +831,7 @@ xpc_create_kthreads(struct xpc_channel *
 
 			if (atomic_dec_return(&ch->kthreads_assigned) == 0 &&
 			    atomic_dec_return(&part->nchannels_engaged) == 0) {
-				xpc_indicate_partition_disengaged(part);
+				indicate_partition_disengaged(part);
 			}
 			xpc_msgqueue_deref(ch);
 			xpc_part_deref(part);
@@ -998,13 +944,13 @@ xpc_setup_partitions(void)
 		atomic_set(&part->references, 0);
 	}
 
-	return xpc_setup_partitions_sn();
+	return xpc_arch_ops.setup_partitions();
 }
 
 static void
 xpc_teardown_partitions(void)
 {
-	xpc_teardown_partitions_sn();
+	xpc_arch_ops.teardown_partitions();
 	kfree(xpc_partitions);
 }
 
@@ -1060,7 +1006,7 @@ xpc_do_exit(enum xp_retval reason)
 				disengage_timeout = part->disengage_timeout;
 		}
 
-		if (xpc_any_partition_engaged()) {
+		if (xpc_arch_ops.any_partition_engaged()) {
 			if (time_is_before_jiffies(printmsg_time)) {
 				dev_info(xpc_part, "waiting for remote "
 					 "partitions to deactivate, timeout in "
@@ -1091,7 +1037,7 @@ xpc_do_exit(enum xp_retval reason)
 
 	} while (1);
 
-	DBUG_ON(xpc_any_partition_engaged());
+	DBUG_ON(xpc_arch_ops.any_partition_engaged());
 
 	xpc_teardown_rsvd_page();
 
@@ -1156,15 +1102,15 @@ xpc_die_deactivate(void)
 	/* keep xpc_hb_checker thread from doing anything (just in case) */
 	xpc_exiting = 1;
 
-	xpc_disallow_all_hbs();	/*indicate we're deactivated */
+	xpc_arch_ops.disallow_all_hbs();   /*indicate we're deactivated */
 
 	for (partid = 0; partid < xp_max_npartitions; partid++) {
 		part = &xpc_partitions[partid];
 
-		if (xpc_partition_engaged(partid) ||
+		if (xpc_arch_ops.partition_engaged(partid) ||
 		    part->act_state != XPC_P_AS_INACTIVE) {
-			xpc_request_partition_deactivation(part);
-			xpc_indicate_partition_disengaged(part);
+			xpc_arch_ops.request_partition_deactivation(part);
+			xpc_arch_ops.indicate_partition_disengaged(part);
 		}
 	}
 
@@ -1181,7 +1127,7 @@ xpc_die_deactivate(void)
 	wait_to_print = XPC_DEACTIVATE_PRINTMSG_INTERVAL * 1000 * 5;
 
 	while (1) {
-		any_engaged = xpc_any_partition_engaged();
+		any_engaged = xpc_arch_ops.any_partition_engaged();
 		if (!any_engaged) {
 			dev_info(xpc_part, "all partitions have deactivated\n");
 			break;
@@ -1190,7 +1136,7 @@ xpc_die_deactivate(void)
 		if (!keep_waiting--) {
 			for (partid = 0; partid < xp_max_npartitions;
 			     partid++) {
-				if (xpc_partition_engaged(partid)) {
+				if (xpc_arch_ops.partition_engaged(partid)) {
 					dev_info(xpc_part, "deactivate from "
 						 "remote partition %d timed "
 						 "out\n", partid);
@@ -1237,7 +1183,7 @@ xpc_system_die(struct notifier_block *nb
 		/* fall through */
 	case DIE_MCA_MONARCH_ENTER:
 	case DIE_INIT_MONARCH_ENTER:
-		xpc_offline_heartbeat();
+		xpc_arch_ops.offline_heartbeat();
 		break;
 
 	case DIE_KDEBUG_LEAVE:
@@ -1248,7 +1194,7 @@ xpc_system_die(struct notifier_block *nb
 		/* fall through */
 	case DIE_MCA_MONARCH_LEAVE:
 	case DIE_INIT_MONARCH_LEAVE:
-		xpc_online_heartbeat();
+		xpc_arch_ops.online_heartbeat();
 		break;
 	}
 #else
diff -puN drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-clean-up-numerous-globals drivers/misc/sgi-xp/xpc_partition.c
--- a/drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-clean-up-numerous-globals
+++ a/drivers/misc/sgi-xp/xpc_partition.c
@@ -70,6 +70,9 @@ xpc_get_rsvd_page_pa(int nasid)
 	size_t buf_len = 0;
 	void *buf = buf;
 	void *buf_base = NULL;
+	enum xp_retval (*get_partition_rsvd_page_pa)
+		(void *, u64 *, unsigned long *, size_t *) =
+		xpc_arch_ops.get_partition_rsvd_page_pa;
 
 	while (1) {
 
@@ -79,8 +82,7 @@ xpc_get_rsvd_page_pa(int nasid)
 		 * ??? function or have two versions? Rename rp_pa for UV to
 		 * ??? rp_gpa?
 		 */
-		ret = xpc_get_partition_rsvd_page_pa(buf, &cookie, &rp_pa,
-						     &len);
+		ret = get_partition_rsvd_page_pa(buf, &cookie, &rp_pa, &len);
 
 		dev_dbg(xpc_part, "SAL returned with ret=%d, cookie=0x%016lx, "
 			"address=0x%016lx, len=0x%016lx\n", ret,
@@ -172,7 +174,7 @@ xpc_setup_rsvd_page(void)
 	xpc_part_nasids = XPC_RP_PART_NASIDS(rp);
 	xpc_mach_nasids = XPC_RP_MACH_NASIDS(rp);
 
-	ret = xpc_setup_rsvd_page_sn(rp);
+	ret = xpc_arch_ops.setup_rsvd_page(rp);
 	if (ret != 0)
 		return ret;
 
@@ -264,7 +266,7 @@ xpc_partition_disengaged(struct xpc_part
 	short partid = XPC_PARTID(part);
 	int disengaged;
 
-	disengaged = !xpc_partition_engaged(partid);
+	disengaged = !xpc_arch_ops.partition_engaged(partid);
 	if (part->disengage_timeout) {
 		if (!disengaged) {
 			if (time_is_after_jiffies(part->disengage_timeout)) {
@@ -280,7 +282,7 @@ xpc_partition_disengaged(struct xpc_part
 			dev_info(xpc_part, "deactivate request to remote "
 				 "partition %d timed out\n", partid);
 			xpc_disengage_timedout = 1;
-			xpc_assume_partition_disengaged(partid);
+			xpc_arch_ops.assume_partition_disengaged(partid);
 			disengaged = 1;
 		}
 		part->disengage_timeout = 0;
@@ -294,7 +296,7 @@ xpc_partition_disengaged(struct xpc_part
 		if (part->act_state != XPC_P_AS_INACTIVE)
 			xpc_wakeup_channel_mgr(part);
 
-		xpc_cancel_partition_deactivation_request(part);
+		xpc_arch_ops.cancel_partition_deactivation_request(part);
 	}
 	return disengaged;
 }
@@ -339,7 +341,7 @@ xpc_deactivate_partition(const int line,
 		spin_unlock_irqrestore(&part->act_lock, irq_flags);
 		if (reason == xpReactivating) {
 			/* we interrupt ourselves to reactivate partition */
-			xpc_request_partition_reactivation(part);
+			xpc_arch_ops.request_partition_reactivation(part);
 		}
 		return;
 	}
@@ -358,7 +360,7 @@ xpc_deactivate_partition(const int line,
 	spin_unlock_irqrestore(&part->act_lock, irq_flags);
 
 	/* ask remote partition to deactivate with regard to us */
-	xpc_request_partition_deactivation(part);
+	xpc_arch_ops.request_partition_deactivation(part);
 
 	/* set a timelimit on the disengage phase of the deactivation request */
 	part->disengage_timeout = jiffies + (xpc_disengage_timelimit * HZ);
@@ -496,7 +498,7 @@ xpc_discovery(void)
 				continue;
 			}
 
-			xpc_request_partition_activation(remote_rp,
+			xpc_arch_ops.request_partition_activation(remote_rp,
 							 remote_rp_pa, nasid);
 		}
 	}
diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-clean-up-numerous-globals drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-clean-up-numerous-globals
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -60,14 +60,14 @@ static struct xpc_vars_sn2 *xpc_vars_sn2
 static struct xpc_vars_part_sn2 *xpc_vars_part_sn2;
 
 static int
-xpc_setup_partitions_sn_sn2(void)
+xpc_setup_partitions_sn2(void)
 {
 	/* nothing needs to be done */
 	return 0;
 }
 
 static void
-xpc_teardown_partitions_sn_sn2(void)
+xpc_teardown_partitions_sn2(void)
 {
 	/* nothing needs to be done */
 }
@@ -628,7 +628,7 @@ xpc_get_partition_rsvd_page_pa_sn2(void 
 
 
 static int
-xpc_setup_rsvd_page_sn_sn2(struct xpc_rsvd_page *rp)
+xpc_setup_rsvd_page_sn2(struct xpc_rsvd_page *rp)
 {
 	struct amo *amos_page;
 	int i;
@@ -1162,7 +1162,7 @@ xpc_process_activate_IRQ_rcvd_sn2(void)
  * Setup the channel structures that are sn2 specific.
  */
 static enum xp_retval
-xpc_setup_ch_structures_sn_sn2(struct xpc_partition *part)
+xpc_setup_ch_structures_sn2(struct xpc_partition *part)
 {
 	struct xpc_partition_sn2 *part_sn2 = &part->sn.sn2;
 	struct xpc_channel_sn2 *ch_sn2;
@@ -1284,7 +1284,7 @@ out_1:
  * Teardown the channel structures that are sn2 specific.
  */
 static void
-xpc_teardown_ch_structures_sn_sn2(struct xpc_partition *part)
+xpc_teardown_ch_structures_sn2(struct xpc_partition *part)
 {
 	struct xpc_partition_sn2 *part_sn2 = &part->sn.sn2;
 	short partid = XPC_PARTID(part);
@@ -2348,66 +2348,70 @@ xpc_received_payload_sn2(struct xpc_chan
 		xpc_acknowledge_msgs_sn2(ch, get, msg->flags);
 }
 
+static struct xpc_arch_operations xpc_arch_ops_sn2 = {
+	.setup_partitions = xpc_setup_partitions_sn2,
+	.teardown_partitions = xpc_teardown_partitions_sn2,
+	.process_activate_IRQ_rcvd = xpc_process_activate_IRQ_rcvd_sn2,
+	.get_partition_rsvd_page_pa = xpc_get_partition_rsvd_page_pa_sn2,
+	.setup_rsvd_page = xpc_setup_rsvd_page_sn2,
+
+	.allow_hb = xpc_allow_hb_sn2,
+	.disallow_hb = xpc_disallow_hb_sn2,
+	.disallow_all_hbs = xpc_disallow_all_hbs_sn2,
+	.increment_heartbeat = xpc_increment_heartbeat_sn2,
+	.offline_heartbeat = xpc_offline_heartbeat_sn2,
+	.online_heartbeat = xpc_online_heartbeat_sn2,
+	.heartbeat_init = xpc_heartbeat_init_sn2,
+	.heartbeat_exit = xpc_heartbeat_exit_sn2,
+	.get_remote_heartbeat = xpc_get_remote_heartbeat_sn2,
+
+	.request_partition_activation =
+		xpc_request_partition_activation_sn2,
+	.request_partition_reactivation =
+		xpc_request_partition_reactivation_sn2,
+	.request_partition_deactivation =
+		xpc_request_partition_deactivation_sn2,
+	.cancel_partition_deactivation_request =
+		xpc_cancel_partition_deactivation_request_sn2,
+
+	.setup_ch_structures = xpc_setup_ch_structures_sn2,
+	.teardown_ch_structures = xpc_teardown_ch_structures_sn2,
+
+	.make_first_contact = xpc_make_first_contact_sn2,
+
+	.get_chctl_all_flags = xpc_get_chctl_all_flags_sn2,
+	.send_chctl_closerequest = xpc_send_chctl_closerequest_sn2,
+	.send_chctl_closereply = xpc_send_chctl_closereply_sn2,
+	.send_chctl_openrequest = xpc_send_chctl_openrequest_sn2,
+	.send_chctl_openreply = xpc_send_chctl_openreply_sn2,
+	.send_chctl_opencomplete = xpc_send_chctl_opencomplete_sn2,
+	.process_msg_chctl_flags = xpc_process_msg_chctl_flags_sn2,
+
+	.save_remote_msgqueue_pa = xpc_save_remote_msgqueue_pa_sn2,
+
+	.setup_msg_structures = xpc_setup_msg_structures_sn2,
+	.teardown_msg_structures = xpc_teardown_msg_structures_sn2,
+
+	.indicate_partition_engaged = xpc_indicate_partition_engaged_sn2,
+	.indicate_partition_disengaged = xpc_indicate_partition_disengaged_sn2,
+	.partition_engaged = xpc_partition_engaged_sn2,
+	.any_partition_engaged = xpc_any_partition_engaged_sn2,
+	.assume_partition_disengaged = xpc_assume_partition_disengaged_sn2,
+
+	.n_of_deliverable_payloads = xpc_n_of_deliverable_payloads_sn2,
+	.send_payload = xpc_send_payload_sn2,
+	.get_deliverable_payload = xpc_get_deliverable_payload_sn2,
+	.received_payload = xpc_received_payload_sn2,
+	.notify_senders_of_disconnect = xpc_notify_senders_of_disconnect_sn2,
+};
+
 int
 xpc_init_sn2(void)
 {
 	int ret;
 	size_t buf_size;
 
-	xpc_setup_partitions_sn = xpc_setup_partitions_sn_sn2;
-	xpc_teardown_partitions_sn = xpc_teardown_partitions_sn_sn2;
-	xpc_get_partition_rsvd_page_pa = xpc_get_partition_rsvd_page_pa_sn2;
-	xpc_setup_rsvd_page_sn = xpc_setup_rsvd_page_sn_sn2;
-
-	xpc_allow_hb = xpc_allow_hb_sn2;
-	xpc_disallow_hb = xpc_disallow_hb_sn2;
-	xpc_disallow_all_hbs = xpc_disallow_all_hbs_sn2;
-	xpc_increment_heartbeat = xpc_increment_heartbeat_sn2;
-	xpc_offline_heartbeat = xpc_offline_heartbeat_sn2;
-	xpc_online_heartbeat = xpc_online_heartbeat_sn2;
-	xpc_heartbeat_init = xpc_heartbeat_init_sn2;
-	xpc_heartbeat_exit = xpc_heartbeat_exit_sn2;
-	xpc_get_remote_heartbeat = xpc_get_remote_heartbeat_sn2;
-
-	xpc_request_partition_activation = xpc_request_partition_activation_sn2;
-	xpc_request_partition_reactivation =
-	    xpc_request_partition_reactivation_sn2;
-	xpc_request_partition_deactivation =
-	    xpc_request_partition_deactivation_sn2;
-	xpc_cancel_partition_deactivation_request =
-	    xpc_cancel_partition_deactivation_request_sn2;
-
-	xpc_process_activate_IRQ_rcvd = xpc_process_activate_IRQ_rcvd_sn2;
-	xpc_setup_ch_structures_sn = xpc_setup_ch_structures_sn_sn2;
-	xpc_teardown_ch_structures_sn = xpc_teardown_ch_structures_sn_sn2;
-	xpc_make_first_contact = xpc_make_first_contact_sn2;
-
-	xpc_get_chctl_all_flags = xpc_get_chctl_all_flags_sn2;
-	xpc_send_chctl_closerequest = xpc_send_chctl_closerequest_sn2;
-	xpc_send_chctl_closereply = xpc_send_chctl_closereply_sn2;
-	xpc_send_chctl_openrequest = xpc_send_chctl_openrequest_sn2;
-	xpc_send_chctl_openreply = xpc_send_chctl_openreply_sn2;
-	xpc_send_chctl_opencomplete = xpc_send_chctl_opencomplete_sn2;
-
-	xpc_save_remote_msgqueue_pa = xpc_save_remote_msgqueue_pa_sn2;
-
-	xpc_setup_msg_structures = xpc_setup_msg_structures_sn2;
-	xpc_teardown_msg_structures = xpc_teardown_msg_structures_sn2;
-
-	xpc_notify_senders_of_disconnect = xpc_notify_senders_of_disconnect_sn2;
-	xpc_process_msg_chctl_flags = xpc_process_msg_chctl_flags_sn2;
-	xpc_n_of_deliverable_payloads = xpc_n_of_deliverable_payloads_sn2;
-	xpc_get_deliverable_payload = xpc_get_deliverable_payload_sn2;
-
-	xpc_indicate_partition_engaged = xpc_indicate_partition_engaged_sn2;
-	xpc_indicate_partition_disengaged =
-	    xpc_indicate_partition_disengaged_sn2;
-	xpc_partition_engaged = xpc_partition_engaged_sn2;
-	xpc_any_partition_engaged = xpc_any_partition_engaged_sn2;
-	xpc_assume_partition_disengaged = xpc_assume_partition_disengaged_sn2;
-
-	xpc_send_payload = xpc_send_payload_sn2;
-	xpc_received_payload = xpc_received_payload_sn2;
+	xpc_arch_ops = xpc_arch_ops_sn2;
 
 	if (offsetof(struct xpc_msg_sn2, payload) > XPC_MSG_HDR_MAX_SIZE) {
 		dev_err(xpc_part, "header portion of struct xpc_msg_sn2 is "
diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-clean-up-numerous-globals drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-clean-up-numerous-globals
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -62,7 +62,7 @@ static struct xpc_gru_mq_uv *xpc_activat
 static struct xpc_gru_mq_uv *xpc_notify_mq_uv;
 
 static int
-xpc_setup_partitions_sn_uv(void)
+xpc_setup_partitions_uv(void)
 {
 	short partid;
 	struct xpc_partition_uv *part_uv;
@@ -78,7 +78,7 @@ xpc_setup_partitions_sn_uv(void)
 }
 
 static void
-xpc_teardown_partitions_sn_uv(void)
+xpc_teardown_partitions_uv(void)
 {
 	short partid;
 	struct xpc_partition_uv *part_uv;
@@ -782,7 +782,7 @@ xpc_get_partition_rsvd_page_pa_uv(void *
 }
 
 static int
-xpc_setup_rsvd_page_sn_uv(struct xpc_rsvd_page *rp)
+xpc_setup_rsvd_page_uv(struct xpc_rsvd_page *rp)
 {
 	xpc_heartbeat_uv =
 	    &xpc_partitions[sn_partition_id].sn.uv.cached_heartbeat;
@@ -980,7 +980,7 @@ xpc_n_of_fifo_entries_uv(struct xpc_fifo
  * Setup the channel structures that are uv specific.
  */
 static enum xp_retval
-xpc_setup_ch_structures_sn_uv(struct xpc_partition *part)
+xpc_setup_ch_structures_uv(struct xpc_partition *part)
 {
 	struct xpc_channel_uv *ch_uv;
 	int ch_number;
@@ -999,7 +999,7 @@ xpc_setup_ch_structures_sn_uv(struct xpc
  * Teardown the channel structures that are uv specific.
  */
 static void
-xpc_teardown_ch_structures_sn_uv(struct xpc_partition *part)
+xpc_teardown_ch_structures_uv(struct xpc_partition *part)
 {
 	/* nothing needs to be done */
 	return;
@@ -1649,63 +1649,67 @@ xpc_received_payload_uv(struct xpc_chann
 	msg->hdr.msg_slot_number += ch->remote_nentries;
 }
 
+static struct xpc_arch_operations xpc_arch_ops_uv = {
+	.setup_partitions = xpc_setup_partitions_uv,
+	.teardown_partitions = xpc_teardown_partitions_uv,
+	.process_activate_IRQ_rcvd = xpc_process_activate_IRQ_rcvd_uv,
+	.get_partition_rsvd_page_pa = xpc_get_partition_rsvd_page_pa_uv,
+	.setup_rsvd_page = xpc_setup_rsvd_page_uv,
+
+	.allow_hb = xpc_allow_hb_uv,
+	.disallow_hb = xpc_disallow_hb_uv,
+	.disallow_all_hbs = xpc_disallow_all_hbs_uv,
+	.increment_heartbeat = xpc_increment_heartbeat_uv,
+	.offline_heartbeat = xpc_offline_heartbeat_uv,
+	.online_heartbeat = xpc_online_heartbeat_uv,
+	.heartbeat_init = xpc_heartbeat_init_uv,
+	.heartbeat_exit = xpc_heartbeat_exit_uv,
+	.get_remote_heartbeat = xpc_get_remote_heartbeat_uv,
+
+	.request_partition_activation =
+		xpc_request_partition_activation_uv,
+	.request_partition_reactivation =
+		xpc_request_partition_reactivation_uv,
+	.request_partition_deactivation =
+		xpc_request_partition_deactivation_uv,
+	.cancel_partition_deactivation_request =
+		xpc_cancel_partition_deactivation_request_uv,
+
+	.setup_ch_structures = xpc_setup_ch_structures_uv,
+	.teardown_ch_structures = xpc_teardown_ch_structures_uv,
+
+	.make_first_contact = xpc_make_first_contact_uv,
+
+	.get_chctl_all_flags = xpc_get_chctl_all_flags_uv,
+	.send_chctl_closerequest = xpc_send_chctl_closerequest_uv,
+	.send_chctl_closereply = xpc_send_chctl_closereply_uv,
+	.send_chctl_openrequest = xpc_send_chctl_openrequest_uv,
+	.send_chctl_openreply = xpc_send_chctl_openreply_uv,
+	.send_chctl_opencomplete = xpc_send_chctl_opencomplete_uv,
+	.process_msg_chctl_flags = xpc_process_msg_chctl_flags_uv,
+
+	.save_remote_msgqueue_pa = xpc_save_remote_msgqueue_pa_uv,
+
+	.setup_msg_structures = xpc_setup_msg_structures_uv,
+	.teardown_msg_structures = xpc_teardown_msg_structures_uv,
+
+	.indicate_partition_engaged = xpc_indicate_partition_engaged_uv,
+	.indicate_partition_disengaged = xpc_indicate_partition_disengaged_uv,
+	.assume_partition_disengaged = xpc_assume_partition_disengaged_uv,
+	.partition_engaged = xpc_partition_engaged_uv,
+	.any_partition_engaged = xpc_any_partition_engaged_uv,
+
+	.n_of_deliverable_payloads = xpc_n_of_deliverable_payloads_uv,
+	.send_payload = xpc_send_payload_uv,
+	.get_deliverable_payload = xpc_get_deliverable_payload_uv,
+	.received_payload = xpc_received_payload_uv,
+	.notify_senders_of_disconnect = xpc_notify_senders_of_disconnect_uv,
+};
+
 int
 xpc_init_uv(void)
 {
-	xpc_setup_partitions_sn = xpc_setup_partitions_sn_uv;
-	xpc_teardown_partitions_sn = xpc_teardown_partitions_sn_uv;
-	xpc_process_activate_IRQ_rcvd = xpc_process_activate_IRQ_rcvd_uv;
-	xpc_get_partition_rsvd_page_pa = xpc_get_partition_rsvd_page_pa_uv;
-	xpc_setup_rsvd_page_sn = xpc_setup_rsvd_page_sn_uv;
-
-	xpc_allow_hb = xpc_allow_hb_uv;
-	xpc_disallow_hb = xpc_disallow_hb_uv;
-	xpc_disallow_all_hbs = xpc_disallow_all_hbs_uv;
-	xpc_increment_heartbeat = xpc_increment_heartbeat_uv;
-	xpc_offline_heartbeat = xpc_offline_heartbeat_uv;
-	xpc_online_heartbeat = xpc_online_heartbeat_uv;
-	xpc_heartbeat_init = xpc_heartbeat_init_uv;
-	xpc_heartbeat_exit = xpc_heartbeat_exit_uv;
-	xpc_get_remote_heartbeat = xpc_get_remote_heartbeat_uv;
-
-	xpc_request_partition_activation = xpc_request_partition_activation_uv;
-	xpc_request_partition_reactivation =
-	    xpc_request_partition_reactivation_uv;
-	xpc_request_partition_deactivation =
-	    xpc_request_partition_deactivation_uv;
-	xpc_cancel_partition_deactivation_request =
-	    xpc_cancel_partition_deactivation_request_uv;
-
-	xpc_setup_ch_structures_sn = xpc_setup_ch_structures_sn_uv;
-	xpc_teardown_ch_structures_sn = xpc_teardown_ch_structures_sn_uv;
-
-	xpc_make_first_contact = xpc_make_first_contact_uv;
-
-	xpc_get_chctl_all_flags = xpc_get_chctl_all_flags_uv;
-	xpc_send_chctl_closerequest = xpc_send_chctl_closerequest_uv;
-	xpc_send_chctl_closereply = xpc_send_chctl_closereply_uv;
-	xpc_send_chctl_openrequest = xpc_send_chctl_openrequest_uv;
-	xpc_send_chctl_openreply = xpc_send_chctl_openreply_uv;
-	xpc_send_chctl_opencomplete = xpc_send_chctl_opencomplete_uv;
-
-	xpc_save_remote_msgqueue_pa = xpc_save_remote_msgqueue_pa_uv;
-
-	xpc_setup_msg_structures = xpc_setup_msg_structures_uv;
-	xpc_teardown_msg_structures = xpc_teardown_msg_structures_uv;
-
-	xpc_indicate_partition_engaged = xpc_indicate_partition_engaged_uv;
-	xpc_indicate_partition_disengaged =
-	    xpc_indicate_partition_disengaged_uv;
-	xpc_assume_partition_disengaged = xpc_assume_partition_disengaged_uv;
-	xpc_partition_engaged = xpc_partition_engaged_uv;
-	xpc_any_partition_engaged = xpc_any_partition_engaged_uv;
