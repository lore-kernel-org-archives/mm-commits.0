From: akpm@linux-foundation.org
Subject: - sgi-xp-isolate-allocation-of-xpcs-msgqueues-to-sn2-only.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:16:48 -0700
Message-ID: <200807301916.m6UJGmdT011154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753481AbYG3TYL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:24:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-xp: isolate allocation of XPC's msgqueues to sn2 only
has been removed from the -mm tree.  Its filename was
     sgi-xp-isolate-allocation-of-xpcs-msgqueues-to-sn2-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp: isolate allocation of XPC's msgqueues to sn2 only
From: Dean Nelson <dcn@sgi.com>

Move the allocation of XPC's msgqueues to xpc_sn2.c.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc.h         |    3 
 drivers/misc/sgi-xp/xpc_channel.c |  197 --------------------------
 drivers/misc/sgi-xp/xpc_main.c    |    2 
 drivers/misc/sgi-xp/xpc_sn2.c     |  205 ++++++++++++++++++++++++++--
 4 files changed, 204 insertions(+), 203 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xp-isolate-allocation-of-xpcs-msgqueues-to-sn2-only drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xp-isolate-allocation-of-xpcs-msgqueues-to-sn2-only
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -666,6 +666,8 @@ extern void (*xpc_online_heartbeat) (voi
 extern void (*xpc_check_remote_hb) (void);
 extern enum xp_retval (*xpc_make_first_contact) (struct xpc_partition *);
 extern u64 (*xpc_get_chctl_all_flags) (struct xpc_partition *);
+extern enum xp_retval (*xpc_allocate_msgqueues) (struct xpc_channel *);
+extern void (*xpc_free_msgqueues) (struct xpc_channel *);
 extern void (*xpc_notify_senders_of_disconnect) (struct xpc_channel *);
 extern void (*xpc_process_msg_chctl_flags) (struct xpc_partition *, int);
 extern int (*xpc_n_of_deliverable_msgs) (struct xpc_channel *);
@@ -728,7 +730,6 @@ extern void xpc_deactivate_partition(con
 extern enum xp_retval xpc_initiate_partid_to_nasids(short, void *);
 
 /* found in xpc_channel.c */
-extern void *xpc_kzalloc_cacheline_aligned(size_t, gfp_t, void **);
 extern void xpc_initiate_connect(int);
 extern void xpc_initiate_disconnect(int);
 extern enum xp_retval xpc_allocate_msg_wait(struct xpc_channel *);
diff -puN drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-isolate-allocation-of-xpcs-msgqueues-to-sn2-only drivers/misc/sgi-xp/xpc_channel.c
--- a/drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-isolate-allocation-of-xpcs-msgqueues-to-sn2-only
+++ a/drivers/misc/sgi-xp/xpc_channel.c
@@ -25,145 +25,6 @@
 #include "xpc.h"
 
 /*
- * Guarantee that the kzalloc'd memory is cacheline aligned.
- */
-void *
-xpc_kzalloc_cacheline_aligned(size_t size, gfp_t flags, void **base)
-{
-	/* see if kzalloc will give us cachline aligned memory by default */
-	*base = kzalloc(size, flags);
-	if (*base == NULL)
-		return NULL;
-
-	if ((u64)*base == L1_CACHE_ALIGN((u64)*base))
-		return *base;
-
-	kfree(*base);
-
-	/* nope, we'll have to do it ourselves */
-	*base = kzalloc(size + L1_CACHE_BYTES, flags);
-	if (*base == NULL)
-		return NULL;
-
-	return (void *)L1_CACHE_ALIGN((u64)*base);
-}
-
-/*
- * Allocate the local message queue and the notify queue.
- */
-static enum xp_retval
-xpc_allocate_local_msgqueue(struct xpc_channel *ch)
-{
-	unsigned long irq_flags;
-	int nentries;
-	size_t nbytes;
-
-	for (nentries = ch->local_nentries; nentries > 0; nentries--) {
-
-		nbytes = nentries * ch->msg_size;
-		ch->local_msgqueue = xpc_kzalloc_cacheline_aligned(nbytes,
-								   GFP_KERNEL,
-						      &ch->local_msgqueue_base);
-		if (ch->local_msgqueue == NULL)
-			continue;
-
-		nbytes = nentries * sizeof(struct xpc_notify);
-		ch->notify_queue = kzalloc(nbytes, GFP_KERNEL);
-		if (ch->notify_queue == NULL) {
-			kfree(ch->local_msgqueue_base);
-			ch->local_msgqueue = NULL;
-			continue;
-		}
-
-		spin_lock_irqsave(&ch->lock, irq_flags);
-		if (nentries < ch->local_nentries) {
-			dev_dbg(xpc_chan, "nentries=%d local_nentries=%d, "
-				"partid=%d, channel=%d\n", nentries,
-				ch->local_nentries, ch->partid, ch->number);
-
-			ch->local_nentries = nentries;
-		}
-		spin_unlock_irqrestore(&ch->lock, irq_flags);
-		return xpSuccess;
-	}
-
-	dev_dbg(xpc_chan, "can't get memory for local message queue and notify "
-		"queue, partid=%d, channel=%d\n", ch->partid, ch->number);
-	return xpNoMemory;
-}
-
-/*
- * Allocate the cached remote message queue.
- */
-static enum xp_retval
-xpc_allocate_remote_msgqueue(struct xpc_channel *ch)
-{
-	unsigned long irq_flags;
-	int nentries;
-	size_t nbytes;
-
-	DBUG_ON(ch->remote_nentries <= 0);
-
-	for (nentries = ch->remote_nentries; nentries > 0; nentries--) {
-
-		nbytes = nentries * ch->msg_size;
-		ch->remote_msgqueue = xpc_kzalloc_cacheline_aligned(nbytes,
-								    GFP_KERNEL,
-						     &ch->remote_msgqueue_base);
-		if (ch->remote_msgqueue == NULL)
-			continue;
-
-		spin_lock_irqsave(&ch->lock, irq_flags);
-		if (nentries < ch->remote_nentries) {
-			dev_dbg(xpc_chan, "nentries=%d remote_nentries=%d, "
-				"partid=%d, channel=%d\n", nentries,
-				ch->remote_nentries, ch->partid, ch->number);
-
-			ch->remote_nentries = nentries;
-		}
-		spin_unlock_irqrestore(&ch->lock, irq_flags);
-		return xpSuccess;
-	}
-
-	dev_dbg(xpc_chan, "can't get memory for cached remote message queue, "
-		"partid=%d, channel=%d\n", ch->partid, ch->number);
-	return xpNoMemory;
-}
-
-/*
- * Allocate message queues and other stuff associated with a channel.
- *
- * Note: Assumes all of the channel sizes are filled in.
- */
-static enum xp_retval
-xpc_allocate_msgqueues(struct xpc_channel *ch)
-{
-	unsigned long irq_flags;
-	enum xp_retval ret;
-
-	DBUG_ON(ch->flags & XPC_C_SETUP);
-
-	ret = xpc_allocate_local_msgqueue(ch);
-	if (ret != xpSuccess)
-		return ret;
-
-	ret = xpc_allocate_remote_msgqueue(ch);
-	if (ret != xpSuccess) {
-		kfree(ch->local_msgqueue_base);
-		ch->local_msgqueue = NULL;
-		kfree(ch->notify_queue);
-		ch->notify_queue = NULL;
-		return ret;
-	}
-
-	spin_lock_irqsave(&ch->lock, irq_flags);
-	ch->flags |= XPC_C_SETUP;
-	spin_unlock_irqrestore(&ch->lock, irq_flags);
-
-	return xpSuccess;
-}
-
-/*
  * Process a connect message from a remote partition.
  *
  * Note: xpc_process_connect() is expecting to be called with the
@@ -191,10 +52,11 @@ xpc_process_connect(struct xpc_channel *
 		if (ret != xpSuccess)
 			XPC_DISCONNECT_CHANNEL(ch, ret, irq_flags);
 
+		ch->flags |= XPC_C_SETUP;
+
 		if (ch->flags & (XPC_C_CONNECTED | XPC_C_DISCONNECTING))
 			return;
 
-		DBUG_ON(!(ch->flags & XPC_C_SETUP));
 		DBUG_ON(ch->local_msgqueue == NULL);
 		DBUG_ON(ch->remote_msgqueue == NULL);
 	}
@@ -220,55 +82,6 @@ xpc_process_connect(struct xpc_channel *
 }
 
 /*
- * Free up message queues and other stuff that were allocated for the specified
- * channel.
- *
- * Note: ch->reason and ch->reason_line are left set for debugging purposes,
- * they're cleared when XPC_C_DISCONNECTED is cleared.
- */
-static void
-xpc_free_msgqueues(struct xpc_channel *ch)
-{
-	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-
-	DBUG_ON(!spin_is_locked(&ch->lock));
-	DBUG_ON(atomic_read(&ch->n_to_notify) != 0);
-
-	ch->remote_msgqueue_pa = 0;
-	ch->func = NULL;
-	ch->key = NULL;
-	ch->msg_size = 0;
-	ch->local_nentries = 0;
-	ch->remote_nentries = 0;
-	ch->kthreads_assigned_limit = 0;
-	ch->kthreads_idle_limit = 0;
-
-	ch_sn2->local_GP->get = 0;
-	ch_sn2->local_GP->put = 0;
-	ch_sn2->remote_GP.get = 0;
-	ch_sn2->remote_GP.put = 0;
-	ch_sn2->w_local_GP.get = 0;
-	ch_sn2->w_local_GP.put = 0;
-	ch_sn2->w_remote_GP.get = 0;
-	ch_sn2->w_remote_GP.put = 0;
-	ch_sn2->next_msg_to_pull = 0;
-
-	if (ch->flags & XPC_C_SETUP) {
-		ch->flags &= ~XPC_C_SETUP;
-
-		dev_dbg(xpc_chan, "ch->flags=0x%x, partid=%d, channel=%d\n",
-			ch->flags, ch->partid, ch->number);
-
-		kfree(ch->local_msgqueue_base);
-		ch->local_msgqueue = NULL;
-		kfree(ch->remote_msgqueue_base);
-		ch->remote_msgqueue = NULL;
-		kfree(ch->notify_queue);
-		ch->notify_queue = NULL;
-	}
-}
-
-/*
  * spin_lock_irqsave() is expected to be held on entry.
  */
 static void
@@ -331,7 +144,11 @@ xpc_process_disconnect(struct xpc_channe
 	/* it's now safe to free the channel's message queues */
 	xpc_free_msgqueues(ch);
 
-	/* mark disconnected, clear all other flags except XPC_C_WDISCONNECT */
+	/*
+	 * Mark the channel disconnected and clear all other flags, including
+	 * XPC_C_SETUP (because of call to xpc_free_msgqueues()) but not
+	 * including XPC_C_WDISCONNECT (if it was set).
+	 */
 	ch->flags = (XPC_C_DISCONNECTED | (ch->flags & XPC_C_WDISCONNECT));
 
 	atomic_dec(&part->nchannels_active);
diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-xp-isolate-allocation-of-xpcs-msgqueues-to-sn2-only drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xp-isolate-allocation-of-xpcs-msgqueues-to-sn2-only
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -186,6 +186,8 @@ void (*xpc_check_remote_hb) (void);
 enum xp_retval (*xpc_make_first_contact) (struct xpc_partition *part);
 void (*xpc_notify_senders_of_disconnect) (struct xpc_channel *ch);
 u64 (*xpc_get_chctl_all_flags) (struct xpc_partition *part);
+enum xp_retval (*xpc_allocate_msgqueues) (struct xpc_channel *ch);
+void (*xpc_free_msgqueues) (struct xpc_channel *ch);
 void (*xpc_process_msg_chctl_flags) (struct xpc_partition *part, int ch_number);
 int (*xpc_n_of_deliverable_msgs) (struct xpc_channel *ch);
 struct xpc_msg *(*xpc_get_deliverable_msg) (struct xpc_channel *ch);
diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-isolate-allocation-of-xpcs-msgqueues-to-sn2-only drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-isolate-allocation-of-xpcs-msgqueues-to-sn2-only
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -1049,6 +1049,30 @@ xpc_process_activate_IRQ_rcvd_sn2(int n_
 }
 
 /*
+ * Guarantee that the kzalloc'd memory is cacheline aligned.
+ */
+static void *
+xpc_kzalloc_cacheline_aligned_sn2(size_t size, gfp_t flags, void **base)
+{
+	/* see if kzalloc will give us cachline aligned memory by default */
+	*base = kzalloc(size, flags);
+	if (*base == NULL)
+		return NULL;
+
+	if ((u64)*base == L1_CACHE_ALIGN((u64)*base))
+		return *base;
+
+	kfree(*base);
+
+	/* nope, we'll have to do it ourselves */
+	*base = kzalloc(size + L1_CACHE_BYTES, flags);
+	if (*base == NULL)
+		return NULL;
+
+	return (void *)L1_CACHE_ALIGN((u64)*base);
+}
+
+/*
  * Setup the infrastructure necessary to support XPartition Communication
  * between the specified remote partition and the local one.
  */
@@ -1078,10 +1102,9 @@ xpc_setup_infrastructure_sn2(struct xpc_
 
 	/* allocate all the required GET/PUT values */
 
-	part_sn2->local_GPs = xpc_kzalloc_cacheline_aligned(XPC_GP_SIZE,
-							    GFP_KERNEL,
-							    &part_sn2->
-							    local_GPs_base);
+	part_sn2->local_GPs =
+	    xpc_kzalloc_cacheline_aligned_sn2(XPC_GP_SIZE, GFP_KERNEL,
+					      &part_sn2->local_GPs_base);
 	if (part_sn2->local_GPs == NULL) {
 		dev_err(xpc_chan, "can't get memory for local get/put "
 			"values\n");
@@ -1089,10 +1112,9 @@ xpc_setup_infrastructure_sn2(struct xpc_
 		goto out_1;
 	}
 
-	part_sn2->remote_GPs = xpc_kzalloc_cacheline_aligned(XPC_GP_SIZE,
-							     GFP_KERNEL,
-							     &part_sn2->
-							     remote_GPs_base);
+	part_sn2->remote_GPs =
+	    xpc_kzalloc_cacheline_aligned_sn2(XPC_GP_SIZE, GFP_KERNEL,
+					      &part_sn2->remote_GPs_base);
 	if (part_sn2->remote_GPs == NULL) {
 		dev_err(xpc_chan, "can't get memory for remote get/put "
 			"values\n");
@@ -1105,8 +1127,9 @@ xpc_setup_infrastructure_sn2(struct xpc_
 	/* allocate all the required open and close args */
 
 	part->local_openclose_args =
-	    xpc_kzalloc_cacheline_aligned(XPC_OPENCLOSE_ARGS_SIZE, GFP_KERNEL,
-					  &part->local_openclose_args_base);
+	    xpc_kzalloc_cacheline_aligned_sn2(XPC_OPENCLOSE_ARGS_SIZE,
+					      GFP_KERNEL,
+					      &part->local_openclose_args_base);
 	if (part->local_openclose_args == NULL) {
 		dev_err(xpc_chan, "can't get memory for local connect args\n");
 		retval = xpNoMemory;
@@ -1114,8 +1137,9 @@ xpc_setup_infrastructure_sn2(struct xpc_
 	}
 
 	part->remote_openclose_args =
-	    xpc_kzalloc_cacheline_aligned(XPC_OPENCLOSE_ARGS_SIZE, GFP_KERNEL,
-					  &part->remote_openclose_args_base);
+	    xpc_kzalloc_cacheline_aligned_sn2(XPC_OPENCLOSE_ARGS_SIZE,
+					      GFP_KERNEL,
+					     &part->remote_openclose_args_base);
 	if (part->remote_openclose_args == NULL) {
 		dev_err(xpc_chan, "can't get memory for remote connect args\n");
 		retval = xpNoMemory;
@@ -1528,6 +1552,161 @@ xpc_get_chctl_all_flags_sn2(struct xpc_p
 }
 
 /*
+ * Allocate the local message queue and the notify queue.
+ */
+static enum xp_retval
+xpc_allocate_local_msgqueue_sn2(struct xpc_channel *ch)
+{
+	unsigned long irq_flags;
+	int nentries;
+	size_t nbytes;
+
+	for (nentries = ch->local_nentries; nentries > 0; nentries--) {
+
+		nbytes = nentries * ch->msg_size;
+		ch->local_msgqueue =
+		    xpc_kzalloc_cacheline_aligned_sn2(nbytes, GFP_KERNEL,
+						      &ch->local_msgqueue_base);
+		if (ch->local_msgqueue == NULL)
+			continue;
+
+		nbytes = nentries * sizeof(struct xpc_notify);
+		ch->notify_queue = kzalloc(nbytes, GFP_KERNEL);
+		if (ch->notify_queue == NULL) {
+			kfree(ch->local_msgqueue_base);
+			ch->local_msgqueue = NULL;
+			continue;
+		}
+
+		spin_lock_irqsave(&ch->lock, irq_flags);
+		if (nentries < ch->local_nentries) {
+			dev_dbg(xpc_chan, "nentries=%d local_nentries=%d, "
+				"partid=%d, channel=%d\n", nentries,
+				ch->local_nentries, ch->partid, ch->number);
+
+			ch->local_nentries = nentries;
+		}
+		spin_unlock_irqrestore(&ch->lock, irq_flags);
+		return xpSuccess;
+	}
+
+	dev_dbg(xpc_chan, "can't get memory for local message queue and notify "
+		"queue, partid=%d, channel=%d\n", ch->partid, ch->number);
+	return xpNoMemory;
+}
+
+/*
+ * Allocate the cached remote message queue.
+ */
+static enum xp_retval
+xpc_allocate_remote_msgqueue_sn2(struct xpc_channel *ch)
+{
+	unsigned long irq_flags;
+	int nentries;
+	size_t nbytes;
+
+	DBUG_ON(ch->remote_nentries <= 0);
+
+	for (nentries = ch->remote_nentries; nentries > 0; nentries--) {
+
+		nbytes = nentries * ch->msg_size;
+		ch->remote_msgqueue =
+		    xpc_kzalloc_cacheline_aligned_sn2(nbytes, GFP_KERNEL,
+						     &ch->remote_msgqueue_base);
+		if (ch->remote_msgqueue == NULL)
+			continue;
+
+		spin_lock_irqsave(&ch->lock, irq_flags);
+		if (nentries < ch->remote_nentries) {
+			dev_dbg(xpc_chan, "nentries=%d remote_nentries=%d, "
+				"partid=%d, channel=%d\n", nentries,
+				ch->remote_nentries, ch->partid, ch->number);
+
+			ch->remote_nentries = nentries;
+		}
+		spin_unlock_irqrestore(&ch->lock, irq_flags);
+		return xpSuccess;
+	}
+
+	dev_dbg(xpc_chan, "can't get memory for cached remote message queue, "
+		"partid=%d, channel=%d\n", ch->partid, ch->number);
+	return xpNoMemory;
+}
+
+/*
+ * Allocate message queues and other stuff associated with a channel.
+ *
+ * Note: Assumes all of the channel sizes are filled in.
+ */
+static enum xp_retval
+xpc_allocate_msgqueues_sn2(struct xpc_channel *ch)
+{
+	enum xp_retval ret;
+
+	DBUG_ON(ch->flags & XPC_C_SETUP);
+
+	ret = xpc_allocate_local_msgqueue_sn2(ch);
+	if (ret == xpSuccess) {
+
+		ret = xpc_allocate_remote_msgqueue_sn2(ch);
+		if (ret != xpSuccess) {
+			kfree(ch->local_msgqueue_base);
+			ch->local_msgqueue = NULL;
+			kfree(ch->notify_queue);
+			ch->notify_queue = NULL;
+		}
+	}
+	return ret;
+}
+
+/*
+ * Free up message queues and other stuff that were allocated for the specified
+ * channel.
+ *
+ * Note: ch->reason and ch->reason_line are left set for debugging purposes,
+ * they're cleared when XPC_C_DISCONNECTED is cleared.
+ */
+static void
+xpc_free_msgqueues_sn2(struct xpc_channel *ch)
+{
+	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
+
+	DBUG_ON(!spin_is_locked(&ch->lock));
+	DBUG_ON(atomic_read(&ch->n_to_notify) != 0);
+
+	ch->remote_msgqueue_pa = 0;
+	ch->func = NULL;
+	ch->key = NULL;
+	ch->msg_size = 0;
+	ch->local_nentries = 0;
+	ch->remote_nentries = 0;
+	ch->kthreads_assigned_limit = 0;
+	ch->kthreads_idle_limit = 0;
+
+	ch_sn2->local_GP->get = 0;
+	ch_sn2->local_GP->put = 0;
+	ch_sn2->remote_GP.get = 0;
+	ch_sn2->remote_GP.put = 0;
+	ch_sn2->w_local_GP.get = 0;
+	ch_sn2->w_local_GP.put = 0;
+	ch_sn2->w_remote_GP.get = 0;
+	ch_sn2->w_remote_GP.put = 0;
+	ch_sn2->next_msg_to_pull = 0;
+
+	if (ch->flags & XPC_C_SETUP) {
+		dev_dbg(xpc_chan, "ch->flags=0x%x, partid=%d, channel=%d\n",
+			ch->flags, ch->partid, ch->number);
+
+		kfree(ch->local_msgqueue_base);
+		ch->local_msgqueue = NULL;
+		kfree(ch->remote_msgqueue_base);
+		ch->remote_msgqueue = NULL;
+		kfree(ch->notify_queue);
+		ch->notify_queue = NULL;
+	}
+}
+
+/*
  * Notify those who wanted to be notified upon delivery of their message.
  */
 static void
@@ -2177,6 +2356,8 @@ xpc_init_sn2(void)
 	xpc_teardown_infrastructure = xpc_teardown_infrastructure_sn2;
 	xpc_make_first_contact = xpc_make_first_contact_sn2;
 	xpc_get_chctl_all_flags = xpc_get_chctl_all_flags_sn2;
+	xpc_allocate_msgqueues = xpc_allocate_msgqueues_sn2;
+	xpc_free_msgqueues = xpc_free_msgqueues_sn2;
 	xpc_notify_senders_of_disconnect = xpc_notify_senders_of_disconnect_sn2;
 	xpc_process_msg_chctl_flags = xpc_process_msg_chctl_flags_sn2;
 	xpc_n_of_deliverable_msgs = xpc_n_of_deliverable_msgs_sn2;
_

Patches currently in -mm which might be from dcn@sgi.com are

origin.patch

