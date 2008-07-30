From: akpm@linux-foundation.org
Subject: - sgi-xp-cleanup-naming-of-partition-defines.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:17:12 -0700
Message-ID: <200807301917.m6UJHC5c011195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754047AbYG3T10 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:27:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, steiner@sgi.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     sgi-xp: cleanup naming of partition defines
has been removed from the -mm tree.  Its filename was
     sgi-xp-cleanup-naming-of-partition-defines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp: cleanup naming of partition defines
From: Dean Nelson <dcn@sgi.com>

Cleanup naming of partition defines.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc.h           |   22 ++++++++---------
 drivers/misc/sgi-xp/xpc_channel.c   |   10 ++++----
 drivers/misc/sgi-xp/xpc_main.c      |   32 +++++++++++++-------------
 drivers/misc/sgi-xp/xpc_partition.c |   18 +++++++-------
 drivers/misc/sgi-xp/xpc_sn2.c       |   20 ++++++++--------
 5 files changed, 51 insertions(+), 51 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xp-cleanup-naming-of-partition-defines drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xp-cleanup-naming-of-partition-defines
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -576,21 +576,21 @@ struct xpc_partition {
 
 /* struct xpc_partition act_state values (for XPC HB) */
 
-#define	XPC_P_INACTIVE		0x00	/* partition is not active */
-#define XPC_P_ACTIVATION_REQ	0x01	/* created thread to activate */
-#define XPC_P_ACTIVATING	0x02	/* activation thread started */
-#define XPC_P_ACTIVE		0x03	/* xpc_partition_up() was called */
-#define XPC_P_DEACTIVATING	0x04	/* partition deactivation initiated */
+#define	XPC_P_AS_INACTIVE	0x00	/* partition is not active */
+#define XPC_P_AS_ACTIVATION_REQ	0x01	/* created thread to activate */
+#define XPC_P_AS_ACTIVATING	0x02	/* activation thread started */
+#define XPC_P_AS_ACTIVE		0x03	/* xpc_partition_up() was called */
+#define XPC_P_AS_DEACTIVATING	0x04	/* partition deactivation initiated */
 
 #define XPC_DEACTIVATE_PARTITION(_p, _reason) \
 			xpc_deactivate_partition(__LINE__, (_p), (_reason))
 
 /* struct xpc_partition setup_state values */
 
-#define XPC_P_UNSET		0x00	/* infrastructure was never setup */
-#define XPC_P_SETUP		0x01	/* infrastructure is setup */
-#define XPC_P_WTEARDOWN		0x02	/* waiting to teardown infrastructure */
-#define XPC_P_TORNDOWN		0x03	/* infrastructure is torndown */
+#define XPC_P_SS_UNSET		0x00	/* infrastructure was never setup */
+#define XPC_P_SS_SETUP		0x01	/* infrastructure is setup */
+#define XPC_P_SS_WTEARDOWN	0x02	/* waiting to teardown infrastructure */
+#define XPC_P_SS_TORNDOWN	0x03	/* infrastructure is torndown */
 
 /*
  * struct xpc_partition_sn2's dropped notify IRQ timer is set to wait the
@@ -787,7 +787,7 @@ xpc_part_deref(struct xpc_partition *par
 	s32 refs = atomic_dec_return(&part->references);
 
 	DBUG_ON(refs < 0);
-	if (refs == 0 && part->setup_state == XPC_P_WTEARDOWN)
+	if (refs == 0 && part->setup_state == XPC_P_SS_WTEARDOWN)
 		wake_up(&part->teardown_wq);
 }
 
@@ -797,7 +797,7 @@ xpc_part_ref(struct xpc_partition *part)
 	int setup;
 
 	atomic_inc(&part->references);
-	setup = (part->setup_state == XPC_P_SETUP);
+	setup = (part->setup_state == XPC_P_SS_SETUP);
 	if (!setup)
 		xpc_part_deref(part);
 
diff -puN drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-cleanup-naming-of-partition-defines drivers/misc/sgi-xp/xpc_channel.c
--- a/drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-cleanup-naming-of-partition-defines
+++ a/drivers/misc/sgi-xp/xpc_channel.c
@@ -99,7 +99,7 @@ xpc_process_disconnect(struct xpc_channe
 	DBUG_ON((ch->flags & XPC_C_CONNECTEDCALLOUT_MADE) &&
 		!(ch->flags & XPC_C_DISCONNECTINGCALLOUT_MADE));
 
-	if (part->act_state == XPC_P_DEACTIVATING) {
+	if (part->act_state == XPC_P_AS_DEACTIVATING) {
 		/* can't proceed until the other side disengages from us */
 		if (xpc_partition_engaged(ch->partid))
 			return;
@@ -155,7 +155,7 @@ xpc_process_disconnect(struct xpc_channe
 		/* we won't lose the CPU since we're holding ch->lock */
 		complete(&ch->wdisconnect_wait);
 	} else if (ch->delayed_chctl_flags) {
-		if (part->act_state != XPC_P_DEACTIVATING) {
+		if (part->act_state != XPC_P_AS_DEACTIVATING) {
 			/* time to take action on any delayed chctl flags */
 			spin_lock(&part->chctl_lock);
 			part->chctl.flags[ch->number] |=
@@ -276,7 +276,7 @@ again:
 			"%d, channel=%d\n", ch->partid, ch->number);
 
 		if (ch->flags & XPC_C_DISCONNECTED) {
-			DBUG_ON(part->act_state != XPC_P_DEACTIVATING);
+			DBUG_ON(part->act_state != XPC_P_AS_DEACTIVATING);
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
 			return;
 		}
@@ -312,7 +312,7 @@ again:
 			"channel=%d\n", args->msg_size, args->local_nentries,
 			ch->partid, ch->number);
 
-		if (part->act_state == XPC_P_DEACTIVATING ||
+		if (part->act_state == XPC_P_AS_DEACTIVATING ||
 		    (ch->flags & XPC_C_ROPENREQUEST)) {
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
 			return;
@@ -546,7 +546,7 @@ xpc_process_sent_chctl_flags(struct xpc_
 			continue;
 		}
 
-		if (part->act_state == XPC_P_DEACTIVATING)
+		if (part->act_state == XPC_P_AS_DEACTIVATING)
 			continue;
 
 		if (!(ch_flags & XPC_C_CONNECTED)) {
diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-xp-cleanup-naming-of-partition-defines drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xp-cleanup-naming-of-partition-defines
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -290,8 +290,8 @@ xpc_check_remote_hb(void)
 
 		part = &xpc_partitions[partid];
 
-		if (part->act_state == XPC_P_INACTIVE ||
-		    part->act_state == XPC_P_DEACTIVATING) {
+		if (part->act_state == XPC_P_AS_INACTIVE ||
+		    part->act_state == XPC_P_AS_DEACTIVATING) {
 			continue;
 		}
 
@@ -406,7 +406,7 @@ xpc_initiate_discovery(void *ignore)
 static void
 xpc_channel_mgr(struct xpc_partition *part)
 {
-	while (part->act_state != XPC_P_DEACTIVATING ||
+	while (part->act_state != XPC_P_AS_DEACTIVATING ||
 	       atomic_read(&part->nchannels_active) > 0 ||
 	       !xpc_partition_disengaged(part)) {
 
@@ -429,7 +429,7 @@ xpc_channel_mgr(struct xpc_partition *pa
 		(void)wait_event_interruptible(part->channel_mgr_wq,
 				(atomic_read(&part->channel_mgr_requests) > 0 ||
 				 part->chctl.all_flags != 0 ||
-				 (part->act_state == XPC_P_DEACTIVATING &&
+				 (part->act_state == XPC_P_AS_DEACTIVATING &&
 				 atomic_read(&part->nchannels_active) == 0 &&
 				 xpc_partition_disengaged(part))));
 		atomic_set(&part->channel_mgr_requests, 1);
@@ -458,16 +458,16 @@ xpc_activating(void *__partid)
 
 	spin_lock_irqsave(&part->act_lock, irq_flags);
 
-	if (part->act_state == XPC_P_DEACTIVATING) {
-		part->act_state = XPC_P_INACTIVE;
+	if (part->act_state == XPC_P_AS_DEACTIVATING) {
+		part->act_state = XPC_P_AS_INACTIVE;
 		spin_unlock_irqrestore(&part->act_lock, irq_flags);
 		part->remote_rp_pa = 0;
 		return 0;
 	}
 
 	/* indicate the thread is activating */
-	DBUG_ON(part->act_state != XPC_P_ACTIVATION_REQ);
-	part->act_state = XPC_P_ACTIVATING;
+	DBUG_ON(part->act_state != XPC_P_AS_ACTIVATION_REQ);
+	part->act_state = XPC_P_AS_ACTIVATING;
 
 	XPC_SET_REASON(part, 0, 0);
 	spin_unlock_irqrestore(&part->act_lock, irq_flags);
@@ -509,9 +509,9 @@ xpc_activate_partition(struct xpc_partit
 
 	spin_lock_irqsave(&part->act_lock, irq_flags);
 
-	DBUG_ON(part->act_state != XPC_P_INACTIVE);
+	DBUG_ON(part->act_state != XPC_P_AS_INACTIVE);
 
-	part->act_state = XPC_P_ACTIVATION_REQ;
+	part->act_state = XPC_P_AS_ACTIVATION_REQ;
 	XPC_SET_REASON(part, xpCloneKThread, __LINE__);
 
 	spin_unlock_irqrestore(&part->act_lock, irq_flags);
@@ -520,7 +520,7 @@ xpc_activate_partition(struct xpc_partit
 			      partid);
 	if (IS_ERR(kthread)) {
 		spin_lock_irqsave(&part->act_lock, irq_flags);
-		part->act_state = XPC_P_INACTIVE;
+		part->act_state = XPC_P_AS_INACTIVE;
 		XPC_SET_REASON(part, xpCloneKThreadFailed, __LINE__);
 		spin_unlock_irqrestore(&part->act_lock, irq_flags);
 	}
@@ -786,7 +786,7 @@ xpc_disconnect_wait(int ch_number)
 		wakeup_channel_mgr = 0;
 
 		if (ch->delayed_chctl_flags) {
-			if (part->act_state != XPC_P_DEACTIVATING) {
+			if (part->act_state != XPC_P_AS_DEACTIVATING) {
 				spin_lock(&part->chctl_lock);
 				part->chctl.flags[ch->number] |=
 				    ch->delayed_chctl_flags;
@@ -846,7 +846,7 @@ xpc_do_exit(enum xp_retval reason)
 			part = &xpc_partitions[partid];
 
 			if (xpc_partition_disengaged(part) &&
-			    part->act_state == XPC_P_INACTIVE) {
+			    part->act_state == XPC_P_AS_INACTIVE) {
 				continue;
 			}
 
@@ -962,7 +962,7 @@ xpc_die_deactivate(void)
 		part = &xpc_partitions[partid];
 
 		if (xpc_partition_engaged(partid) ||
-		    part->act_state != XPC_P_INACTIVE) {
+		    part->act_state != XPC_P_AS_INACTIVE) {
 			xpc_request_partition_deactivation(part);
 			xpc_indicate_partition_disengaged(part);
 		}
@@ -1113,7 +1113,7 @@ xpc_init(void)
 
 		part->activate_IRQ_rcvd = 0;
 		spin_lock_init(&part->act_lock);
-		part->act_state = XPC_P_INACTIVE;
+		part->act_state = XPC_P_AS_INACTIVE;
 		XPC_SET_REASON(part, 0, 0);
 
 		init_timer(&part->disengage_timer);
@@ -1121,7 +1121,7 @@ xpc_init(void)
 		    xpc_timeout_partition_disengage;
 		part->disengage_timer.data = (unsigned long)part;
 
-		part->setup_state = XPC_P_UNSET;
+		part->setup_state = XPC_P_SS_UNSET;
 		init_waitqueue_head(&part->teardown_wq);
 		atomic_set(&part->references, 0);
 	}
diff -puN drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-cleanup-naming-of-partition-defines drivers/misc/sgi-xp/xpc_partition.c
--- a/drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-cleanup-naming-of-partition-defines
+++ a/drivers/misc/sgi-xp/xpc_partition.c
@@ -273,9 +273,9 @@ xpc_partition_disengaged(struct xpc_part
 		if (!in_interrupt())
 			del_singleshot_timer_sync(&part->disengage_timer);
 
-		DBUG_ON(part->act_state != XPC_P_DEACTIVATING &&
-			part->act_state != XPC_P_INACTIVE);
-		if (part->act_state != XPC_P_INACTIVE)
+		DBUG_ON(part->act_state != XPC_P_AS_DEACTIVATING &&
+			part->act_state != XPC_P_AS_INACTIVE);
+		if (part->act_state != XPC_P_AS_INACTIVE)
 			xpc_wakeup_channel_mgr(part);
 
 		xpc_cancel_partition_deactivation_request(part);
@@ -295,8 +295,8 @@ xpc_mark_partition_active(struct xpc_par
 	dev_dbg(xpc_part, "setting partition %d to ACTIVE\n", XPC_PARTID(part));
 
 	spin_lock_irqsave(&part->act_lock, irq_flags);
-	if (part->act_state == XPC_P_ACTIVATING) {
-		part->act_state = XPC_P_ACTIVE;
+	if (part->act_state == XPC_P_AS_ACTIVATING) {
+		part->act_state = XPC_P_AS_ACTIVE;
 		ret = xpSuccess;
 	} else {
 		DBUG_ON(part->reason == xpSuccess);
@@ -318,7 +318,7 @@ xpc_deactivate_partition(const int line,
 
 	spin_lock_irqsave(&part->act_lock, irq_flags);
 
-	if (part->act_state == XPC_P_INACTIVE) {
+	if (part->act_state == XPC_P_AS_INACTIVE) {
 		XPC_SET_REASON(part, reason, line);
 		spin_unlock_irqrestore(&part->act_lock, irq_flags);
 		if (reason == xpReactivating) {
@@ -327,7 +327,7 @@ xpc_deactivate_partition(const int line,
 		}
 		return;
 	}
-	if (part->act_state == XPC_P_DEACTIVATING) {
+	if (part->act_state == XPC_P_AS_DEACTIVATING) {
 		if ((part->reason == xpUnloading && reason != xpUnloading) ||
 		    reason == xpReactivating) {
 			XPC_SET_REASON(part, reason, line);
@@ -336,7 +336,7 @@ xpc_deactivate_partition(const int line,
 		return;
 	}
 
-	part->act_state = XPC_P_DEACTIVATING;
+	part->act_state = XPC_P_AS_DEACTIVATING;
 	XPC_SET_REASON(part, reason, line);
 
 	spin_unlock_irqrestore(&part->act_lock, irq_flags);
@@ -367,7 +367,7 @@ xpc_mark_partition_inactive(struct xpc_p
 		XPC_PARTID(part));
 
 	spin_lock_irqsave(&part->act_lock, irq_flags);
-	part->act_state = XPC_P_INACTIVE;
+	part->act_state = XPC_P_AS_INACTIVE;
 	spin_unlock_irqrestore(&part->act_lock, irq_flags);
 	part->remote_rp_pa = 0;
 }
diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-cleanup-naming-of-partition-defines drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-cleanup-naming-of-partition-defines
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -327,7 +327,7 @@ xpc_send_notify_IRQ_sn2(struct xpc_chann
 	union xpc_channel_ctl_flags chctl = { 0 };
 	enum xp_retval ret;
 
-	if (likely(part->act_state != XPC_P_DEACTIVATING)) {
+	if (likely(part->act_state != XPC_P_AS_DEACTIVATING)) {
 		chctl.flags[ch->number] = chctl_flag;
 		ret = xpc_send_IRQ_sn2(part_sn2->remote_chctl_amo_va,
 				       chctl.all_flags,
@@ -975,7 +975,7 @@ xpc_identify_activate_IRQ_req_sn2(int na
 		remote_vars->heartbeat, remote_vars->heartbeating_to_mask[0]);
 
 	if (xpc_partition_disengaged(part) &&
-	    part->act_state == XPC_P_INACTIVE) {
+	    part->act_state == XPC_P_AS_INACTIVE) {
 
 		xpc_update_partition_info_sn2(part, remote_rp_version,
 					      &remote_rp_ts_jiffies,
@@ -1257,10 +1257,10 @@ xpc_setup_infrastructure_sn2(struct xpc_
 	}
 
 	/*
-	 * With the setting of the partition setup_state to XPC_P_SETUP, we're
-	 * declaring that this partition is ready to go.
+	 * With the setting of the partition setup_state to XPC_P_SS_SETUP,
+	 * we're declaring that this partition is ready to go.
 	 */
-	part->setup_state = XPC_P_SETUP;
+	part->setup_state = XPC_P_SS_SETUP;
 
 	/*
 	 * Setup the per partition specific variables required by the
@@ -1323,8 +1323,8 @@ xpc_teardown_infrastructure_sn2(struct x
 
 	DBUG_ON(atomic_read(&part->nchannels_engaged) != 0);
 	DBUG_ON(atomic_read(&part->nchannels_active) != 0);
-	DBUG_ON(part->setup_state != XPC_P_SETUP);
-	part->setup_state = XPC_P_WTEARDOWN;
+	DBUG_ON(part->setup_state != XPC_P_SS_SETUP);
+	part->setup_state = XPC_P_SS_WTEARDOWN;
 
 	xpc_vars_part_sn2[partid].magic = 0;
 
@@ -1338,7 +1338,7 @@ xpc_teardown_infrastructure_sn2(struct x
 
 	/* now we can begin tearing down the infrastructure */
 
-	part->setup_state = XPC_P_TORNDOWN;
+	part->setup_state = XPC_P_SS_TORNDOWN;
 
 	/* in case we've still got outstanding timers registered... */
 	del_timer_sync(&part_sn2->dropped_notify_IRQ_timer);
@@ -1375,7 +1375,7 @@ xpc_pull_remote_cachelines_sn2(struct xp
 	DBUG_ON((unsigned long)dst != L1_CACHE_ALIGN((unsigned long)dst));
 	DBUG_ON(cnt != L1_CACHE_ALIGN(cnt));
 
-	if (part->act_state == XPC_P_DEACTIVATING)
+	if (part->act_state == XPC_P_AS_DEACTIVATING)
 		return part->reason;
 
 	ret = xp_remote_memcpy(xp_pa(dst), src_pa, cnt);
@@ -1534,7 +1534,7 @@ xpc_make_first_contact_sn2(struct xpc_pa
 		/* wait a 1/4 of a second or so */
 		(void)msleep_interruptible(250);
 
-		if (part->act_state == XPC_P_DEACTIVATING)
+		if (part->act_state == XPC_P_AS_DEACTIVATING)
 			return part->reason;
 	}
 
_

Patches currently in -mm which might be from dcn@sgi.com are

origin.patch

