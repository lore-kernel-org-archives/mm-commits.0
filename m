From: akpm@linux-foundation.org
Subject: + sgi-xp-isolate-xpc_vars_part-structure-to-sn2-only.patch added to -mm tree
Date: Sun, 08 Jun 2008 17:18:04 -0700
Message-ID: <200806090018.m590I4Hx027080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756242AbYFIASJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 20:18:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dcn@sgi.com


The patch titled
     sgi-xp: isolate xpc_vars_part structure to sn2 only
has been added to the -mm tree.  Its filename is
     sgi-xp-isolate-xpc_vars_part-structure-to-sn2-only.patch

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
Subject: sgi-xp: isolate xpc_vars_part structure to sn2 only
From: Dean Nelson <dcn@sgi.com>

Isolate the xpc_vars_part structure of XPC's reserved page to sn2 only.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc.h           |   26 -
 drivers/misc/sgi-xp/xpc_channel.c   |  538 ------------------------
 drivers/misc/sgi-xp/xpc_main.c      |   97 +---
 drivers/misc/sgi-xp/xpc_partition.c |    1 
 drivers/misc/sgi-xp/xpc_sn2.c       |  563 +++++++++++++++++++++++++-
 drivers/misc/sgi-xp/xpc_uv.c        |   48 ++
 6 files changed, 644 insertions(+), 629 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xp-isolate-xpc_vars_part-structure-to-sn2-only drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xp-isolate-xpc_vars_part-structure-to-sn2-only
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -227,9 +227,9 @@ xpc_disallow_hb(short partid, struct xpc
  * itself from that partition. It is desirable that the size of this structure
  * evenly divides into a 128-byte cacheline, such that none of the entries in
  * this array crosses a 128-byte cacheline boundary. As it is now, each entry
- * occupies a 64-byte cacheline.
+ * occupies 64-bytes.
  */
-struct xpc_vars_part {
+struct xpc_vars_part_sn2 {
 	u64 magic;
 
 	u64 openclose_args_pa;	/* physical address of open and close args */
@@ -265,8 +265,6 @@ struct xpc_vars_part {
 #define XPC_RP_MACH_NASIDS(_rp) (XPC_RP_PART_NASIDS(_rp) + xp_nasid_mask_words)
 #define XPC_RP_VARS(_rp)	((struct xpc_vars *)(XPC_RP_MACH_NASIDS(_rp) + \
 				    xp_nasid_mask_words))
-#define XPC_RP_VARS_PART(_rp)	((struct xpc_vars_part *) \
-				    ((u8 *)XPC_RP_VARS(_rp) + XPC_RP_VARS_SIZE))
 
 /*
  * Functions registered by add_timer() or called by kernel_thread() only
@@ -541,13 +539,6 @@ struct xpc_partition {
 	wait_queue_head_t teardown_wq;	/* kthread waiting to teardown infra */
 	atomic_t references;	/* #of references to infrastructure */
 
-	/*
-	 * NONE OF THE PRECEDING FIELDS OF THIS STRUCTURE WILL BE CLEARED WHEN
-	 * XPC SETS UP THE NECESSARY INFRASTRUCTURE TO SUPPORT CROSS PARTITION
-	 * COMMUNICATION. ALL OF THE FOLLOWING FIELDS WILL BE CLEARED. (THE
-	 * 'nchannels' FIELD MUST BE THE FIRST OF THE FIELDS TO BE CLEARED.)
-	 */
-
 	u8 nchannels;		/* #of defined channels supported */
 	atomic_t nchannels_active;  /* #of channels that are not DISCONNECTED */
 	atomic_t nchannels_engaged;  /* #of channels engaged with remote part */
@@ -613,7 +604,7 @@ struct xpc_partition {
  * dropped IPIs. These occur whenever an IPI amo write doesn't complete until
  * after the IPI was received.
  */
-#define XPC_P_DROPPED_IPI_WAIT	(0.25 * HZ)
+#define XPC_P_DROPPED_IPI_WAIT_INTERVAL	(0.25 * HZ)
 
 /* number of seconds to wait for other partitions to disengage */
 #define XPC_DISENGAGE_REQUEST_DEFAULT_TIMELIMIT	90
@@ -637,13 +628,16 @@ extern void xpc_activate_partition(struc
 extern void xpc_activate_kthreads(struct xpc_channel *, int);
 extern void xpc_create_kthreads(struct xpc_channel *, int, int);
 extern void xpc_disconnect_wait(int);
-
 extern enum xp_retval (*xpc_rsvd_page_init) (struct xpc_rsvd_page *);
+extern enum xp_retval (*xpc_make_first_contact) (struct xpc_partition *);
+extern u64 (*xpc_get_IPI_flags) (struct xpc_partition *);
+extern struct xpc_msg *(*xpc_get_deliverable_msg) (struct xpc_channel *);
+extern enum xp_retval (*xpc_setup_infrastructure) (struct xpc_partition *);
+extern void (*xpc_teardown_infrastructure) (struct xpc_partition *);
 
 /* found in xpc_sn2.c */
 extern void xpc_init_sn2(void);
 extern struct xpc_vars *xpc_vars;		/*>>> eliminate from here */
-extern struct xpc_vars_part *xpc_vars_part;	/*>>> eliminate from here */
 
 /* found in xpc_uv.c */
 extern void xpc_init_uv(void);
@@ -670,6 +664,7 @@ extern void xpc_deactivate_partition(con
 extern enum xp_retval xpc_initiate_partid_to_nasids(short, void *);
 
 /* found in xpc_channel.c */
+extern void *xpc_kzalloc_cacheline_aligned(size_t, gfp_t, void **);
 extern void xpc_initiate_connect(int);
 extern void xpc_initiate_disconnect(int);
 extern enum xp_retval xpc_initiate_allocate(short, int, u32, void **);
@@ -677,8 +672,6 @@ extern enum xp_retval xpc_initiate_send(
 extern enum xp_retval xpc_initiate_send_notify(short, int, void *,
 					       xpc_notify_func, void *);
 extern void xpc_initiate_received(short, int, void *);
-extern enum xp_retval xpc_setup_infrastructure(struct xpc_partition *);
-extern enum xp_retval xpc_pull_remote_vars_part(struct xpc_partition *);
 extern void xpc_process_channel_activity(struct xpc_partition *);
 extern void xpc_connected_callout(struct xpc_channel *);
 extern void xpc_deliver_msg(struct xpc_channel *);
@@ -686,7 +679,6 @@ extern void xpc_disconnect_channel(const
 				   enum xp_retval, unsigned long *);
 extern void xpc_disconnect_callout(struct xpc_channel *, enum xp_retval);
 extern void xpc_partition_going_down(struct xpc_partition *, enum xp_retval);
-extern void xpc_teardown_infrastructure(struct xpc_partition *);
 
 static inline void
 xpc_wakeup_channel_mgr(struct xpc_partition *part)
diff -puN drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-isolate-xpc_vars_part-structure-to-sn2-only drivers/misc/sgi-xp/xpc_channel.c
--- a/drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-isolate-xpc_vars_part-structure-to-sn2-only
+++ a/drivers/misc/sgi-xp/xpc_channel.c
@@ -27,7 +27,7 @@
 /*
  * Guarantee that the kzalloc'd memory is cacheline aligned.
  */
-static void *
+void *
 xpc_kzalloc_cacheline_aligned(size_t size, gfp_t flags, void **base)
 {
 	/* see if kzalloc will give us cachline aligned memory by default */
@@ -49,382 +49,6 @@ xpc_kzalloc_cacheline_aligned(size_t siz
 }
 
 /*
- * Set up the initial values for the XPartition Communication channels.
- */
-static void
-xpc_initialize_channels(struct xpc_partition *part, short partid)
-{
-	int ch_number;
-	struct xpc_channel *ch;
-
-	for (ch_number = 0; ch_number < part->nchannels; ch_number++) {
-		ch = &part->channels[ch_number];
-
-		ch->partid = partid;
-		ch->number = ch_number;
-		ch->flags = XPC_C_DISCONNECTED;
-
-		ch->local_GP = &part->local_GPs[ch_number];
-		ch->local_openclose_args =
-		    &part->local_openclose_args[ch_number];
-
-		atomic_set(&ch->kthreads_assigned, 0);
-		atomic_set(&ch->kthreads_idle, 0);
-		atomic_set(&ch->kthreads_active, 0);
-
-		atomic_set(&ch->references, 0);
-		atomic_set(&ch->n_to_notify, 0);
-
-		spin_lock_init(&ch->lock);
-		mutex_init(&ch->msg_to_pull_mutex);
-		init_completion(&ch->wdisconnect_wait);
-
-		atomic_set(&ch->n_on_msg_allocate_wq, 0);
-		init_waitqueue_head(&ch->msg_allocate_wq);
-		init_waitqueue_head(&ch->idle_wq);
-	}
-}
-
-/*
- * Setup the infrastructure necessary to support XPartition Communication
- * between the specified remote partition and the local one.
- */
-enum xp_retval
-xpc_setup_infrastructure(struct xpc_partition *part)
-{
-	int ret, cpuid;
-	struct timer_list *timer;
-	short partid = XPC_PARTID(part);
-
-	/*
-	 * Zero out MOST of the entry for this partition. Only the fields
-	 * starting with `nchannels' will be zeroed. The preceding fields must
-	 * remain `viable' across partition ups and downs, since they may be
-	 * referenced during this memset() operation.
-	 */
-	memset(&part->nchannels, 0, sizeof(struct xpc_partition) -
-	       offsetof(struct xpc_partition, nchannels));
-
-	/*
-	 * Allocate all of the channel structures as a contiguous chunk of
-	 * memory.
-	 */
-	part->channels = kzalloc(sizeof(struct xpc_channel) * XPC_MAX_NCHANNELS,
-				 GFP_KERNEL);
-	if (part->channels == NULL) {
-		dev_err(xpc_chan, "can't get memory for channels\n");
-		return xpNoMemory;
-	}
-
-	part->nchannels = XPC_MAX_NCHANNELS;
-
-	/* allocate all the required GET/PUT values */
-
-	part->local_GPs = xpc_kzalloc_cacheline_aligned(XPC_GP_SIZE,
-							GFP_KERNEL,
-							&part->local_GPs_base);
-	if (part->local_GPs == NULL) {
-		kfree(part->channels);
-		part->channels = NULL;
-		dev_err(xpc_chan, "can't get memory for local get/put "
-			"values\n");
-		return xpNoMemory;
-	}
-
-	part->remote_GPs = xpc_kzalloc_cacheline_aligned(XPC_GP_SIZE,
-							 GFP_KERNEL,
-							 &part->
-							 remote_GPs_base);
-	if (part->remote_GPs == NULL) {
-		dev_err(xpc_chan, "can't get memory for remote get/put "
-			"values\n");
-		kfree(part->local_GPs_base);
-		part->local_GPs = NULL;
-		kfree(part->channels);
-		part->channels = NULL;
-		return xpNoMemory;
-	}
-
-	/* allocate all the required open and close args */
-
-	part->local_openclose_args =
-	    xpc_kzalloc_cacheline_aligned(XPC_OPENCLOSE_ARGS_SIZE, GFP_KERNEL,
-					  &part->local_openclose_args_base);
-	if (part->local_openclose_args == NULL) {
-		dev_err(xpc_chan, "can't get memory for local connect args\n");
-		kfree(part->remote_GPs_base);
-		part->remote_GPs = NULL;
-		kfree(part->local_GPs_base);
-		part->local_GPs = NULL;
-		kfree(part->channels);
-		part->channels = NULL;
-		return xpNoMemory;
-	}
-
-	part->remote_openclose_args =
-	    xpc_kzalloc_cacheline_aligned(XPC_OPENCLOSE_ARGS_SIZE, GFP_KERNEL,
-					  &part->remote_openclose_args_base);
-	if (part->remote_openclose_args == NULL) {
-		dev_err(xpc_chan, "can't get memory for remote connect args\n");
-		kfree(part->local_openclose_args_base);
-		part->local_openclose_args = NULL;
-		kfree(part->remote_GPs_base);
-		part->remote_GPs = NULL;
-		kfree(part->local_GPs_base);
-		part->local_GPs = NULL;
-		kfree(part->channels);
-		part->channels = NULL;
-		return xpNoMemory;
-	}
-
-	xpc_initialize_channels(part, partid);
-
-	atomic_set(&part->nchannels_active, 0);
-	atomic_set(&part->nchannels_engaged, 0);
-
-	/* local_IPI_amo were set to 0 by an earlier memset() */
-
-	/* Initialize this partitions AMO_t structure */
-	part->local_IPI_amo_va = xpc_IPI_init(partid);
-
-	spin_lock_init(&part->IPI_lock);
-
-	atomic_set(&part->channel_mgr_requests, 1);
-	init_waitqueue_head(&part->channel_mgr_wq);
-
-	sprintf(part->IPI_owner, "xpc%02d", partid);
-	ret = request_irq(SGI_XPC_NOTIFY, xpc_notify_IRQ_handler, IRQF_SHARED,
-			  part->IPI_owner, (void *)(u64)partid);
-	if (ret != 0) {
-		dev_err(xpc_chan, "can't register NOTIFY IRQ handler, "
-			"errno=%d\n", -ret);
-		kfree(part->remote_openclose_args_base);
-		part->remote_openclose_args = NULL;
-		kfree(part->local_openclose_args_base);
-		part->local_openclose_args = NULL;
-		kfree(part->remote_GPs_base);
-		part->remote_GPs = NULL;
-		kfree(part->local_GPs_base);
-		part->local_GPs = NULL;
-		kfree(part->channels);
-		part->channels = NULL;
-		return xpLackOfResources;
-	}
-
-	/* Setup a timer to check for dropped IPIs */
-	timer = &part->dropped_IPI_timer;
-	init_timer(timer);
-	timer->function = (void (*)(unsigned long))xpc_dropped_IPI_check;
-	timer->data = (unsigned long)part;
-	timer->expires = jiffies + XPC_P_DROPPED_IPI_WAIT;
-	add_timer(timer);
-
-	/*
-	 * With the setting of the partition setup_state to XPC_P_SETUP, we're
-	 * declaring that this partition is ready to go.
-	 */
-	part->setup_state = XPC_P_SETUP;
-
-	/*
-	 * Setup the per partition specific variables required by the
-	 * remote partition to establish channel connections with us.
-	 *
-	 * The setting of the magic # indicates that these per partition
-	 * specific variables are ready to be used.
-	 */
-	xpc_vars_part[partid].GPs_pa = __pa(part->local_GPs);
-	xpc_vars_part[partid].openclose_args_pa =
-	    __pa(part->local_openclose_args);
-	xpc_vars_part[partid].IPI_amo_pa = __pa(part->local_IPI_amo_va);
-	cpuid = raw_smp_processor_id();	/* any CPU in this partition will do */
-	xpc_vars_part[partid].IPI_nasid = cpuid_to_nasid(cpuid);
-	xpc_vars_part[partid].IPI_phys_cpuid = cpu_physical_id(cpuid);
-	xpc_vars_part[partid].nchannels = part->nchannels;
-	xpc_vars_part[partid].magic = XPC_VP_MAGIC1;
-
-	return xpSuccess;
-}
-
-/*
- * Create a wrapper that hides the underlying mechanism for pulling a cacheline
- * (or multiple cachelines) from a remote partition.
- *
- * src must be a cacheline aligned physical address on the remote partition.
- * dst must be a cacheline aligned virtual address on this partition.
- * cnt must be cacheline sized
- */
-static enum xp_retval
-xpc_pull_remote_cachelines(struct xpc_partition *part, void *dst,
-			   const void *src, size_t cnt)
-{
-	enum xp_retval ret;
-
-	DBUG_ON((u64)src != L1_CACHE_ALIGN((u64)src));
-	DBUG_ON((u64)dst != L1_CACHE_ALIGN((u64)dst));
-	DBUG_ON(cnt != L1_CACHE_ALIGN(cnt));
-
-	if (part->act_state == XPC_P_DEACTIVATING)
-		return part->reason;
-
-	ret = xp_remote_memcpy(dst, src, cnt);
-	if (ret != xpSuccess) {
-		dev_dbg(xpc_chan, "xp_remote_memcpy() from partition %d failed,"
-			" ret=%d\n", XPC_PARTID(part), ret);
-	}
-	return ret;
-}
-
-/*
- * Pull the remote per partition specific variables from the specified
- * partition.
- */
-enum xp_retval
-xpc_pull_remote_vars_part(struct xpc_partition *part)
-{
-	u8 buffer[L1_CACHE_BYTES * 2];
-	struct xpc_vars_part *pulled_entry_cacheline =
-	    (struct xpc_vars_part *)L1_CACHE_ALIGN((u64)buffer);
-	struct xpc_vars_part *pulled_entry;
-	u64 remote_entry_cacheline_pa, remote_entry_pa;
-	short partid = XPC_PARTID(part);
-	enum xp_retval ret;
-
-	/* pull the cacheline that contains the variables we're interested in */
-
-	DBUG_ON(part->remote_vars_part_pa !=
-		L1_CACHE_ALIGN(part->remote_vars_part_pa));
-	DBUG_ON(sizeof(struct xpc_vars_part) != L1_CACHE_BYTES / 2);
-
-	remote_entry_pa = part->remote_vars_part_pa +
-	    sn_partition_id * sizeof(struct xpc_vars_part);
-
-	remote_entry_cacheline_pa = (remote_entry_pa & ~(L1_CACHE_BYTES - 1));
-
-	pulled_entry = (struct xpc_vars_part *)((u64)pulled_entry_cacheline +
-						(remote_entry_pa &
-						 (L1_CACHE_BYTES - 1)));
-
-	ret = xpc_pull_remote_cachelines(part, pulled_entry_cacheline,
-					 (void *)remote_entry_cacheline_pa,
-					 L1_CACHE_BYTES);
-	if (ret != xpSuccess) {
-		dev_dbg(xpc_chan, "failed to pull XPC vars_part from "
-			"partition %d, ret=%d\n", partid, ret);
-		return ret;
-	}
-
-	/* see if they've been set up yet */
-
-	if (pulled_entry->magic != XPC_VP_MAGIC1 &&
-	    pulled_entry->magic != XPC_VP_MAGIC2) {
-
-		if (pulled_entry->magic != 0) {
-			dev_dbg(xpc_chan, "partition %d's XPC vars_part for "
-				"partition %d has bad magic value (=0x%lx)\n",
-				partid, sn_partition_id, pulled_entry->magic);
-			return xpBadMagic;
-		}
-
-		/* they've not been initialized yet */
-		return xpRetry;
-	}
-
-	if (xpc_vars_part[partid].magic == XPC_VP_MAGIC1) {
-
-		/* validate the variables */
-
-		if (pulled_entry->GPs_pa == 0 ||
-		    pulled_entry->openclose_args_pa == 0 ||
-		    pulled_entry->IPI_amo_pa == 0) {
-
-			dev_err(xpc_chan, "partition %d's XPC vars_part for "
-				"partition %d are not valid\n", partid,
-				sn_partition_id);
-			return xpInvalidAddress;
-		}
-
-		/* the variables we imported look to be valid */
-
-		part->remote_GPs_pa = pulled_entry->GPs_pa;
-		part->remote_openclose_args_pa =
-		    pulled_entry->openclose_args_pa;
-		part->remote_IPI_amo_va =
-		    (AMO_t *)__va(pulled_entry->IPI_amo_pa);
-		part->remote_IPI_nasid = pulled_entry->IPI_nasid;
-		part->remote_IPI_phys_cpuid = pulled_entry->IPI_phys_cpuid;
-
-		if (part->nchannels > pulled_entry->nchannels)
-			part->nchannels = pulled_entry->nchannels;
-
-		/* let the other side know that we've pulled their variables */
-
-		xpc_vars_part[partid].magic = XPC_VP_MAGIC2;
-	}
-
-	if (pulled_entry->magic == XPC_VP_MAGIC1)
-		return xpRetry;
-
-	return xpSuccess;
-}
-
-/*
- * Get the IPI flags and pull the openclose args and/or remote GPs as needed.
- */
-static u64
-xpc_get_IPI_flags(struct xpc_partition *part)
-{
-	unsigned long irq_flags;
-	u64 IPI_amo;
-	enum xp_retval ret;
-
-	/*
-	 * See if there are any IPI flags to be handled.
-	 */
-
-	spin_lock_irqsave(&part->IPI_lock, irq_flags);
-	IPI_amo = part->local_IPI_amo;
-	if (IPI_amo != 0)
-		part->local_IPI_amo = 0;
-
-	spin_unlock_irqrestore(&part->IPI_lock, irq_flags);
-
-	if (XPC_ANY_OPENCLOSE_IPI_FLAGS_SET(IPI_amo)) {
-		ret = xpc_pull_remote_cachelines(part,
-						 part->remote_openclose_args,
-						 (void *)part->
-						 remote_openclose_args_pa,
-						 XPC_OPENCLOSE_ARGS_SIZE);
-		if (ret != xpSuccess) {
-			XPC_DEACTIVATE_PARTITION(part, ret);
-
-			dev_dbg(xpc_chan, "failed to pull openclose args from "
-				"partition %d, ret=%d\n", XPC_PARTID(part),
-				ret);
-
-			/* don't bother processing IPIs anymore */
-			IPI_amo = 0;
-		}
-	}
-
-	if (XPC_ANY_MSG_IPI_FLAGS_SET(IPI_amo)) {
-		ret = xpc_pull_remote_cachelines(part, part->remote_GPs,
-						 (void *)part->remote_GPs_pa,
-						 XPC_GP_SIZE);
-		if (ret != xpSuccess) {
-			XPC_DEACTIVATE_PARTITION(part, ret);
-
-			dev_dbg(xpc_chan, "failed to pull GPs from partition "
-				"%d, ret=%d\n", XPC_PARTID(part), ret);
-
-			/* don't bother processing IPIs anymore */
-			IPI_amo = 0;
-		}
-	}
-
-	return IPI_amo;
-}
-
-/*
  * Allocate the local message queue and the notify queue.
  */
 static enum xp_retval
@@ -1365,59 +989,6 @@ xpc_partition_going_down(struct xpc_part
 }
 
 /*
- * Teardown the infrastructure necessary to support XPartition Communication
- * between the specified remote partition and the local one.
- */
-void
-xpc_teardown_infrastructure(struct xpc_partition *part)
-{
-	short partid = XPC_PARTID(part);
-
-	/*
-	 * We start off by making this partition inaccessible to local
-	 * processes by marking it as no longer setup. Then we make it
-	 * inaccessible to remote processes by clearing the XPC per partition
-	 * specific variable's magic # (which indicates that these variables
-	 * are no longer valid) and by ignoring all XPC notify IPIs sent to
-	 * this partition.
-	 */
-
-	DBUG_ON(atomic_read(&part->nchannels_engaged) != 0);
-	DBUG_ON(atomic_read(&part->nchannels_active) != 0);
-	DBUG_ON(part->setup_state != XPC_P_SETUP);
-	part->setup_state = XPC_P_WTEARDOWN;
-
-	xpc_vars_part[partid].magic = 0;
-
-	free_irq(SGI_XPC_NOTIFY, (void *)(u64)partid);
-
-	/*
-	 * Before proceeding with the teardown we have to wait until all
-	 * existing references cease.
-	 */
-	wait_event(part->teardown_wq, (atomic_read(&part->references) == 0));
-
-	/* now we can begin tearing down the infrastructure */
-
-	part->setup_state = XPC_P_TORNDOWN;
-
-	/* in case we've still got outstanding timers registered... */
-	del_timer_sync(&part->dropped_IPI_timer);
-
-	kfree(part->remote_openclose_args_base);
-	part->remote_openclose_args = NULL;
-	kfree(part->local_openclose_args_base);
-	part->local_openclose_args = NULL;
-	kfree(part->remote_GPs_base);
-	part->remote_GPs = NULL;
-	kfree(part->local_GPs_base);
-	part->local_GPs = NULL;
-	kfree(part->channels);
-	part->channels = NULL;
-	part->local_IPI_amo_va = NULL;
-}
-
-/*
  * Called by XP at the time of channel connection registration to cause
  * XPC to establish connections to all currently active partitions.
  */
@@ -1974,113 +1545,6 @@ xpc_initiate_send_notify(short partid, i
 	return ret;
 }
 
-static struct xpc_msg *
-xpc_pull_remote_msg(struct xpc_channel *ch, s64 get)
-{
-	struct xpc_partition *part = &xpc_partitions[ch->partid];
-	struct xpc_msg *remote_msg, *msg;
-	u32 msg_index, nmsgs;
-	u64 msg_offset;
-	enum xp_retval ret;
-
-	if (mutex_lock_interruptible(&ch->msg_to_pull_mutex) != 0) {
-		/* we were interrupted by a signal */
-		return NULL;
-	}
-
-	while (get >= ch->next_msg_to_pull) {
-
-		/* pull as many messages as are ready and able to be pulled */
-
-		msg_index = ch->next_msg_to_pull % ch->remote_nentries;
-
-		DBUG_ON(ch->next_msg_to_pull >= ch->w_remote_GP.put);
-		nmsgs = ch->w_remote_GP.put - ch->next_msg_to_pull;
-		if (msg_index + nmsgs > ch->remote_nentries) {
-			/* ignore the ones that wrap the msg queue for now */
-			nmsgs = ch->remote_nentries - msg_index;
-		}
-
-		msg_offset = msg_index * ch->msg_size;
-		msg = (struct xpc_msg *)((u64)ch->remote_msgqueue + msg_offset);
-		remote_msg = (struct xpc_msg *)(ch->remote_msgqueue_pa +
-						msg_offset);
-
-		ret = xpc_pull_remote_cachelines(part, msg, remote_msg,
-						 nmsgs * ch->msg_size);
-		if (ret != xpSuccess) {
-
-			dev_dbg(xpc_chan, "failed to pull %d msgs starting with"
-				" msg %ld from partition %d, channel=%d, "
-				"ret=%d\n", nmsgs, ch->next_msg_to_pull,
-				ch->partid, ch->number, ret);
-
-			XPC_DEACTIVATE_PARTITION(part, ret);
-
-			mutex_unlock(&ch->msg_to_pull_mutex);
-			return NULL;
-		}
-
-		ch->next_msg_to_pull += nmsgs;
-	}
-
-	mutex_unlock(&ch->msg_to_pull_mutex);
-
-	/* return the message we were looking for */
-	msg_offset = (get % ch->remote_nentries) * ch->msg_size;
-	msg = (struct xpc_msg *)((u64)ch->remote_msgqueue + msg_offset);
-
-	return msg;
-}
-
-/*
- * Get a message to be delivered.
- */
-static struct xpc_msg *
-xpc_get_deliverable_msg(struct xpc_channel *ch)
-{
-	struct xpc_msg *msg = NULL;
-	s64 get;
-
-	do {
-		if (ch->flags & XPC_C_DISCONNECTING)
-			break;
-
-		get = ch->w_local_GP.get;
-		rmb();	/* guarantee that .get loads before .put */
-		if (get == ch->w_remote_GP.put)
-			break;
-
-		/* There are messages waiting to be pulled and delivered.
-		 * We need to try to secure one for ourselves. We'll do this
-		 * by trying to increment w_local_GP.get and hope that no one
-		 * else beats us to it. If they do, we'll we'll simply have
-		 * to try again for the next one.
-		 */
-
-		if (cmpxchg(&ch->w_local_GP.get, get, get + 1) == get) {
-			/* we got the entry referenced by get */
-
-			dev_dbg(xpc_chan, "w_local_GP.get changed to %ld, "
-				"partid=%d, channel=%d\n", get + 1,
-				ch->partid, ch->number);
-
-			/* pull the message from the remote partition */
-
-			msg = xpc_pull_remote_msg(ch, get);
-
-			DBUG_ON(msg != NULL && msg->number != get);
-			DBUG_ON(msg != NULL && (msg->flags & XPC_M_DONE));
-			DBUG_ON(msg != NULL && !(msg->flags & XPC_M_READY));
-
-			break;
-		}
-
-	} while (1);
-
-	return msg;
-}
-
 /*
  * Deliver a message to its intended recipient.
  */
diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-xp-isolate-xpc_vars_part-structure-to-sn2-only drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xp-isolate-xpc_vars_part-structure-to-sn2-only
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -176,6 +176,12 @@ static struct notifier_block xpc_die_not
 };
 
 enum xp_retval (*xpc_rsvd_page_init) (struct xpc_rsvd_page *rp);
+enum xp_retval (*xpc_make_first_contact) (struct xpc_partition *part);
+u64 (*xpc_get_IPI_flags) (struct xpc_partition *part);
+struct xpc_msg *(*xpc_get_deliverable_msg) (struct xpc_channel *ch);
+enum xp_retval (*xpc_setup_infrastructure) (struct xpc_partition *part);
+void (*xpc_teardown_infrastructure) (struct xpc_partition *part);
+
 
 /*
  * Timer function to enforce the timelimit on the partition disengage request.
@@ -313,37 +319,8 @@ xpc_initiate_discovery(void *ignore)
 }
 
 /*
- * Establish first contact with the remote partititon. This involves pulling
- * the XPC per partition variables from the remote partition and waiting for
- * the remote partition to pull ours.
- */
-static enum xp_retval
-xpc_make_first_contact(struct xpc_partition *part)
-{
-	enum xp_retval ret;
-
-	while ((ret = xpc_pull_remote_vars_part(part)) != xpSuccess) {
-		if (ret != xpRetry) {
-			XPC_DEACTIVATE_PARTITION(part, ret);
-			return ret;
-		}
-
-		dev_dbg(xpc_chan, "waiting to make first contact with "
-			"partition %d\n", XPC_PARTID(part));
-
-		/* wait a 1/4 of a second or so */
-		(void)msleep_interruptible(250);
-
-		if (part->act_state == XPC_P_DEACTIVATING)
-			return part->reason;
-	}
-
-	return xpc_mark_partition_active(part);
-}
-
-/*
  * The first kthread assigned to a newly activated partition is the one
- * created by XPC HB with which it calls xpc_partition_up(). XPC hangs on to
+ * created by XPC HB with which it calls xpc_activating(). XPC hangs on to
  * that kthread until the partition is brought down, at which time that kthread
  * returns back to XPC HB. (The return of that kthread will signify to XPC HB
  * that XPC has dismantled all communication infrastructure for the associated
@@ -393,41 +370,10 @@ xpc_channel_mgr(struct xpc_partition *pa
  * upped partition.
  *
  * The kthread that was created by XPC HB and which setup the XPC
- * infrastructure will remain assigned to the partition until the partition
- * goes down. At which time the kthread will teardown the XPC infrastructure
- * and then exit.
- *
- * XPC HB will put the remote partition's XPC per partition specific variables
- * physical address into xpc_partitions[partid].remote_vars_part_pa prior to
- * calling xpc_partition_up().
+ * infrastructure will remain assigned to the partition becoming the channel
+ * manager for that partition until the partition is deactivating, at which
+ * time the kthread will teardown the XPC infrastructure and then exit.
  */
-static void
-xpc_partition_up(struct xpc_partition *part)
-{
-	DBUG_ON(part->channels != NULL);
-
-	dev_dbg(xpc_chan, "activating partition %d\n", XPC_PARTID(part));
-
-	if (xpc_setup_infrastructure(part) != xpSuccess)
-		return;
-
-	/*
-	 * The kthread that XPC HB called us with will become the
-	 * channel manager for this partition. It will not return
-	 * back to XPC HB until the partition's XPC infrastructure
-	 * has been dismantled.
-	 */
-
-	(void)xpc_part_ref(part);	/* this will always succeed */
-
-	if (xpc_make_first_contact(part) == xpSuccess)
-		xpc_channel_mgr(part);
-
-	xpc_part_deref(part);
-
-	xpc_teardown_infrastructure(part);
-}
-
 static int
 xpc_activating(void *__partid)
 {
@@ -453,7 +399,7 @@ xpc_activating(void *__partid)
 	XPC_SET_REASON(part, 0, 0);
 	spin_unlock_irqrestore(&part->act_lock, irq_flags);
 
-	dev_dbg(xpc_part, "bringing partition %d up\n", partid);
+	dev_dbg(xpc_part, "activating partition %d\n", partid);
 
 	/*
 	 * Register the remote partition's AMOs with SAL so it can handle
@@ -467,7 +413,7 @@ xpc_activating(void *__partid)
 	 */
 	if (sn_register_xp_addr_region(part->remote_amos_page_pa,
 				       PAGE_SIZE, 1) < 0) {
-		dev_warn(xpc_part, "xpc_partition_up(%d) failed to register "
+		dev_warn(xpc_part, "xpc_activating(%d) failed to register "
 			 "xp_addr region\n", partid);
 
 		spin_lock_irqsave(&part->act_lock, irq_flags);
@@ -481,11 +427,18 @@ xpc_activating(void *__partid)
 	xpc_allow_hb(partid, xpc_vars);
 	xpc_IPI_send_activated(part);
 
-	/*
-	 * xpc_partition_up() holds this thread and marks this partition as
-	 * XPC_P_ACTIVE by calling xpc_hb_mark_active().
-	 */
-	(void)xpc_partition_up(part);
+	if (xpc_setup_infrastructure(part) == xpSuccess) {
+		(void)xpc_part_ref(part);	/* this will always succeed */
+
+		if (xpc_make_first_contact(part) == xpSuccess) {
+			xpc_mark_partition_active(part);
+			xpc_channel_mgr(part);
+			/* won't return until partition is deactivating */
+		}
+
+		xpc_part_deref(part);
+		xpc_teardown_infrastructure(part);
+	}
 
 	xpc_disallow_hb(partid, xpc_vars);
 	xpc_mark_partition_inactive(part);
@@ -568,7 +521,7 @@ xpc_dropped_IPI_check(struct xpc_partiti
 		xpc_check_for_channel_activity(part);
 
 		part->dropped_IPI_timer.expires = jiffies +
-		    XPC_P_DROPPED_IPI_WAIT;
+		    XPC_P_DROPPED_IPI_WAIT_INTERVAL;
 		add_timer(&part->dropped_IPI_timer);
 		xpc_part_deref(part);
 	}
diff -puN drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-isolate-xpc_vars_part-structure-to-sn2-only drivers/misc/sgi-xp/xpc_partition.c
--- a/drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-isolate-xpc_vars_part-structure-to-sn2-only
+++ a/drivers/misc/sgi-xp/xpc_partition.c
@@ -486,6 +486,7 @@ xpc_update_partition_info(struct xpc_par
 	dev_dbg(xpc_part, "  last_heartbeat = 0x%016lx\n",
 		part->last_heartbeat);
 
+/* >>> remote_vars_part_pa and vars_part_pa are sn2 only!!! */
 	part->remote_vars_part_pa = remote_vars->vars_part_pa;
 	dev_dbg(xpc_part, "  remote_vars_part_pa = 0x%016lx\n",
 		part->remote_vars_part_pa);
diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-isolate-xpc_vars_part-structure-to-sn2-only drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-isolate-xpc_vars_part-structure-to-sn2-only
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -14,12 +14,13 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/delay.h>
 #include <asm/uncached.h>
 #include <asm/sn/sn_sal.h>
 #include "xpc.h"
 
 struct xpc_vars *xpc_vars;
-struct xpc_vars_part *xpc_vars_part;
+static struct xpc_vars_part_sn2 *xpc_vars_part; /* >>> Add _sn2 suffix? */
 
 static enum xp_retval
 xpc_rsvd_page_init_sn2(struct xpc_rsvd_page *rp)
@@ -33,7 +34,10 @@ xpc_rsvd_page_init_sn2(struct xpc_rsvd_p
 
 	rp->sn.vars_pa = __pa(xpc_vars);
 
-	xpc_vars_part = XPC_RP_VARS_PART(rp);
+	/* vars_part array follows immediately after vars */
+	xpc_vars_part = (struct xpc_vars_part_sn2 *)((u8 *)XPC_RP_VARS(rp) +
+						     XPC_RP_VARS_SIZE);
+
 
 	/*
 	 * Before clearing xpc_vars, see if a page of AMOs had been previously
@@ -85,7 +89,7 @@ xpc_rsvd_page_init_sn2(struct xpc_rsvd_p
 	xpc_vars->amos_page = amos_page;	/* save for next load of XPC */
 
 	/* clear xpc_vars_part */
-	memset((u64 *)xpc_vars_part, 0, sizeof(struct xpc_vars_part) *
+	memset((u64 *)xpc_vars_part, 0, sizeof(struct xpc_vars_part_sn2) *
 	       xp_max_npartitions);
 
 	/* initialize the activate IRQ related AMO variables */
@@ -99,10 +103,563 @@ xpc_rsvd_page_init_sn2(struct xpc_rsvd_p
 	return xpSuccess;
 }
 
+/*
+ * Setup the infrastructure necessary to support XPartition Communication
+ * between the specified remote partition and the local one.
+ */
+static enum xp_retval
+xpc_setup_infrastructure_sn2(struct xpc_partition *part)
+{
+	enum xp_retval retval;
+	int ret;
+	int cpuid;
+	int ch_number;
+	struct xpc_channel *ch;
+	struct timer_list *timer;
+	short partid = XPC_PARTID(part);
+
+	/*
+	 * Allocate all of the channel structures as a contiguous chunk of
+	 * memory.
+	 */
+	DBUG_ON(part->channels != NULL);
+	part->channels = kzalloc(sizeof(struct xpc_channel) * XPC_MAX_NCHANNELS,
+				 GFP_KERNEL);
+	if (part->channels == NULL) {
+		dev_err(xpc_chan, "can't get memory for channels\n");
+		return xpNoMemory;
+	}
+
+	/* allocate all the required GET/PUT values */
+
+	part->local_GPs = xpc_kzalloc_cacheline_aligned(XPC_GP_SIZE,
+							GFP_KERNEL,
+							&part->local_GPs_base);
+	if (part->local_GPs == NULL) {
+		dev_err(xpc_chan, "can't get memory for local get/put "
+			"values\n");
+		retval = xpNoMemory;
+		goto out_1;
+	}
+
+	part->remote_GPs = xpc_kzalloc_cacheline_aligned(XPC_GP_SIZE,
+							 GFP_KERNEL,
+							 &part->
+							 remote_GPs_base);
+	if (part->remote_GPs == NULL) {
+		dev_err(xpc_chan, "can't get memory for remote get/put "
+			"values\n");
+		retval = xpNoMemory;
+		goto out_2;
+	}
+
+	part->remote_GPs_pa = 0;
+
+	/* allocate all the required open and close args */
+
+	part->local_openclose_args =
+	    xpc_kzalloc_cacheline_aligned(XPC_OPENCLOSE_ARGS_SIZE, GFP_KERNEL,
+					  &part->local_openclose_args_base);
+	if (part->local_openclose_args == NULL) {
+		dev_err(xpc_chan, "can't get memory for local connect args\n");
+		retval = xpNoMemory;
+		goto out_3;
+	}
+
+	part->remote_openclose_args =
+	    xpc_kzalloc_cacheline_aligned(XPC_OPENCLOSE_ARGS_SIZE, GFP_KERNEL,
+					  &part->remote_openclose_args_base);
+	if (part->remote_openclose_args == NULL) {
+		dev_err(xpc_chan, "can't get memory for remote connect args\n");
+		retval = xpNoMemory;
+		goto out_4;
+	}
+
+	part->remote_openclose_args_pa = 0;
+
+	part->local_IPI_amo_va = xpc_IPI_init(partid);
+	part->local_IPI_amo = 0;
+	spin_lock_init(&part->IPI_lock);
+
+	part->remote_IPI_nasid = 0;
+	part->remote_IPI_phys_cpuid = 0;
+	part->remote_IPI_amo_va = NULL;
+
+	atomic_set(&part->channel_mgr_requests, 1);
+	init_waitqueue_head(&part->channel_mgr_wq);
+
+	sprintf(part->IPI_owner, "xpc%02d", partid);
+	ret = request_irq(SGI_XPC_NOTIFY, xpc_notify_IRQ_handler, IRQF_SHARED,
+			  part->IPI_owner, (void *)(u64)partid);
+	if (ret != 0) {
+		dev_err(xpc_chan, "can't register NOTIFY IRQ handler, "
+			"errno=%d\n", -ret);
+		retval = xpLackOfResources;
+		goto out_5;
+	}
+
+	/* Setup a timer to check for dropped IPIs */
+	timer = &part->dropped_IPI_timer;
+	init_timer(timer);
+	timer->function = (void (*)(unsigned long))xpc_dropped_IPI_check;
+	timer->data = (unsigned long)part;
+	timer->expires = jiffies + XPC_P_DROPPED_IPI_WAIT_INTERVAL;
+	add_timer(timer);
+
+	part->nchannels = XPC_MAX_NCHANNELS;
+
+	atomic_set(&part->nchannels_active, 0);
+	atomic_set(&part->nchannels_engaged, 0);
+
+	for (ch_number = 0; ch_number < part->nchannels; ch_number++) {
+		ch = &part->channels[ch_number];
+
+		ch->partid = partid;
+		ch->number = ch_number;
+		ch->flags = XPC_C_DISCONNECTED;
+
+		ch->local_GP = &part->local_GPs[ch_number];
+		ch->local_openclose_args =
+		    &part->local_openclose_args[ch_number];
+
+		atomic_set(&ch->kthreads_assigned, 0);
+		atomic_set(&ch->kthreads_idle, 0);
+		atomic_set(&ch->kthreads_active, 0);
+
+		atomic_set(&ch->references, 0);
+		atomic_set(&ch->n_to_notify, 0);
+
+		spin_lock_init(&ch->lock);
+		mutex_init(&ch->msg_to_pull_mutex);
+		init_completion(&ch->wdisconnect_wait);
+
+		atomic_set(&ch->n_on_msg_allocate_wq, 0);
+		init_waitqueue_head(&ch->msg_allocate_wq);
+		init_waitqueue_head(&ch->idle_wq);
+	}
+
+	/*
+	 * With the setting of the partition setup_state to XPC_P_SETUP, we're
+	 * declaring that this partition is ready to go.
+	 */
+	part->setup_state = XPC_P_SETUP;
+
+	/*
+	 * Setup the per partition specific variables required by the
+	 * remote partition to establish channel connections with us.
+	 *
+	 * The setting of the magic # indicates that these per partition
+	 * specific variables are ready to be used.
+	 */
+	xpc_vars_part[partid].GPs_pa = __pa(part->local_GPs);
+	xpc_vars_part[partid].openclose_args_pa =
+	    __pa(part->local_openclose_args);
+	xpc_vars_part[partid].IPI_amo_pa = __pa(part->local_IPI_amo_va);
+	cpuid = raw_smp_processor_id();	/* any CPU in this partition will do */
+	xpc_vars_part[partid].IPI_nasid = cpuid_to_nasid(cpuid);
+	xpc_vars_part[partid].IPI_phys_cpuid = cpu_physical_id(cpuid);
+	xpc_vars_part[partid].nchannels = part->nchannels;
+	xpc_vars_part[partid].magic = XPC_VP_MAGIC1;
+
+	return xpSuccess;
+
+	/* setup of infrastructure failed */
+out_5:
+	kfree(part->remote_openclose_args_base);
+	part->remote_openclose_args = NULL;
+out_4:
+	kfree(part->local_openclose_args_base);
+	part->local_openclose_args = NULL;
+out_3:
+	kfree(part->remote_GPs_base);
+	part->remote_GPs = NULL;
+out_2:
+	kfree(part->local_GPs_base);
+	part->local_GPs = NULL;
+out_1:
+	kfree(part->channels);
+	part->channels = NULL;
+	return retval;
+}
+
+/*
+ * Teardown the infrastructure necessary to support XPartition Communication
+ * between the specified remote partition and the local one.
+ */
+static void
+xpc_teardown_infrastructure_sn2(struct xpc_partition *part)
+{
+	short partid = XPC_PARTID(part);
+
+	/*
+	 * We start off by making this partition inaccessible to local
+	 * processes by marking it as no longer setup. Then we make it
+	 * inaccessible to remote processes by clearing the XPC per partition
+	 * specific variable's magic # (which indicates that these variables
+	 * are no longer valid) and by ignoring all XPC notify IPIs sent to
+	 * this partition.
+	 */
+
+	DBUG_ON(atomic_read(&part->nchannels_engaged) != 0);
+	DBUG_ON(atomic_read(&part->nchannels_active) != 0);
+	DBUG_ON(part->setup_state != XPC_P_SETUP);
+	part->setup_state = XPC_P_WTEARDOWN;
+
+	xpc_vars_part[partid].magic = 0;
+
+	free_irq(SGI_XPC_NOTIFY, (void *)(u64)partid);
+
+	/*
+	 * Before proceeding with the teardown we have to wait until all
+	 * existing references cease.
+	 */
+	wait_event(part->teardown_wq, (atomic_read(&part->references) == 0));
+
+	/* now we can begin tearing down the infrastructure */
+
+	part->setup_state = XPC_P_TORNDOWN;
+
+	/* in case we've still got outstanding timers registered... */
+	del_timer_sync(&part->dropped_IPI_timer);
+
+	kfree(part->remote_openclose_args_base);
+	part->remote_openclose_args = NULL;
+	kfree(part->local_openclose_args_base);
+	part->local_openclose_args = NULL;
+	kfree(part->remote_GPs_base);
+	part->remote_GPs = NULL;
+	kfree(part->local_GPs_base);
+	part->local_GPs = NULL;
+	kfree(part->channels);
+	part->channels = NULL;
+	part->local_IPI_amo_va = NULL;
+}
+
+/*
+ * Create a wrapper that hides the underlying mechanism for pulling a cacheline
+ * (or multiple cachelines) from a remote partition.
+ *
+ * src must be a cacheline aligned physical address on the remote partition.
+ * dst must be a cacheline aligned virtual address on this partition.
+ * cnt must be cacheline sized
+ */
+/* >>> Replace this function by call to xp_remote_memcpy() or bte_copy()? */
+static enum xp_retval
+xpc_pull_remote_cachelines_sn2(struct xpc_partition *part, void *dst,
+			       const void *src, size_t cnt)
+{
+	enum xp_retval ret;
+
+	DBUG_ON((u64)src != L1_CACHE_ALIGN((u64)src));
+	DBUG_ON((u64)dst != L1_CACHE_ALIGN((u64)dst));
+	DBUG_ON(cnt != L1_CACHE_ALIGN(cnt));
+
+	if (part->act_state == XPC_P_DEACTIVATING)
+		return part->reason;
+
+	ret = xp_remote_memcpy(dst, src, cnt);
+	if (ret != xpSuccess) {
+		dev_dbg(xpc_chan, "xp_remote_memcpy() from partition %d failed,"
+			" ret=%d\n", XPC_PARTID(part), ret);
+	}
+	return ret;
+}
+
+/*
+ * Pull the remote per partition specific variables from the specified
+ * partition.
+ */
+static enum xp_retval
+xpc_pull_remote_vars_part_sn2(struct xpc_partition *part)
+{
+	u8 buffer[L1_CACHE_BYTES * 2];
+	struct xpc_vars_part_sn2 *pulled_entry_cacheline =
+	    (struct xpc_vars_part_sn2 *)L1_CACHE_ALIGN((u64)buffer);
+	struct xpc_vars_part_sn2 *pulled_entry;
+	u64 remote_entry_cacheline_pa, remote_entry_pa;
+	short partid = XPC_PARTID(part);
+	enum xp_retval ret;
+
+	/* pull the cacheline that contains the variables we're interested in */
+
+	DBUG_ON(part->remote_vars_part_pa !=
+		L1_CACHE_ALIGN(part->remote_vars_part_pa));
+	DBUG_ON(sizeof(struct xpc_vars_part_sn2) != L1_CACHE_BYTES / 2);
+
+	remote_entry_pa = part->remote_vars_part_pa +
+	    sn_partition_id * sizeof(struct xpc_vars_part_sn2);
+
+	remote_entry_cacheline_pa = (remote_entry_pa & ~(L1_CACHE_BYTES - 1));
+
+	pulled_entry = (struct xpc_vars_part_sn2 *)((u64)pulled_entry_cacheline
+						    + (remote_entry_pa &
+						    (L1_CACHE_BYTES - 1)));
+
+	ret = xpc_pull_remote_cachelines_sn2(part, pulled_entry_cacheline,
+					     (void *)remote_entry_cacheline_pa,
+					     L1_CACHE_BYTES);
+	if (ret != xpSuccess) {
+		dev_dbg(xpc_chan, "failed to pull XPC vars_part from "
+			"partition %d, ret=%d\n", partid, ret);
+		return ret;
+	}
+
+	/* see if they've been set up yet */
+
+	if (pulled_entry->magic != XPC_VP_MAGIC1 &&
+	    pulled_entry->magic != XPC_VP_MAGIC2) {
+
+		if (pulled_entry->magic != 0) {
+			dev_dbg(xpc_chan, "partition %d's XPC vars_part for "
+				"partition %d has bad magic value (=0x%lx)\n",
+				partid, sn_partition_id, pulled_entry->magic);
+			return xpBadMagic;
+		}
+
+		/* they've not been initialized yet */
+		return xpRetry;
+	}
+
+	if (xpc_vars_part[partid].magic == XPC_VP_MAGIC1) {
+
+		/* validate the variables */
+
+		if (pulled_entry->GPs_pa == 0 ||
+		    pulled_entry->openclose_args_pa == 0 ||
+		    pulled_entry->IPI_amo_pa == 0) {
+
+			dev_err(xpc_chan, "partition %d's XPC vars_part for "
+				"partition %d are not valid\n", partid,
+				sn_partition_id);
+			return xpInvalidAddress;
+		}
+
+		/* the variables we imported look to be valid */
+
+		part->remote_GPs_pa = pulled_entry->GPs_pa;
+		part->remote_openclose_args_pa =
+		    pulled_entry->openclose_args_pa;
+		part->remote_IPI_amo_va =
+		    (AMO_t *)__va(pulled_entry->IPI_amo_pa);
+		part->remote_IPI_nasid = pulled_entry->IPI_nasid;
+		part->remote_IPI_phys_cpuid = pulled_entry->IPI_phys_cpuid;
+
+		if (part->nchannels > pulled_entry->nchannels)
+			part->nchannels = pulled_entry->nchannels;
+
+		/* let the other side know that we've pulled their variables */
+
+		xpc_vars_part[partid].magic = XPC_VP_MAGIC2;
+	}
+
+	if (pulled_entry->magic == XPC_VP_MAGIC1)
+		return xpRetry;
+
+	return xpSuccess;
+}
+
+/*
+ * Establish first contact with the remote partititon. This involves pulling
+ * the XPC per partition variables from the remote partition and waiting for
+ * the remote partition to pull ours.
+ */
+static enum xp_retval
+xpc_make_first_contact_sn2(struct xpc_partition *part)
+{
+	enum xp_retval ret;
+
+	while ((ret = xpc_pull_remote_vars_part_sn2(part)) != xpSuccess) {
+		if (ret != xpRetry) {
+			XPC_DEACTIVATE_PARTITION(part, ret);
+			return ret;
+		}
+
+		dev_dbg(xpc_part, "waiting to make first contact with "
+			"partition %d\n", XPC_PARTID(part));
+
+		/* wait a 1/4 of a second or so */
+		(void)msleep_interruptible(250);
+
+		if (part->act_state == XPC_P_DEACTIVATING)
+			return part->reason;
+	}
+
+	return xpSuccess;
+}
+
+/*
+ * Get the IPI flags and pull the openclose args and/or remote GPs as needed.
+ */
+static u64
+xpc_get_IPI_flags_sn2(struct xpc_partition *part)
+{
+	unsigned long irq_flags;
+	u64 IPI_amo;
+	enum xp_retval ret;
+
+	/*
+	 * See if there are any IPI flags to be handled.
+	 */
+
+	spin_lock_irqsave(&part->IPI_lock, irq_flags);
+	IPI_amo = part->local_IPI_amo;
+	if (IPI_amo != 0)
+		part->local_IPI_amo = 0;
+
+	spin_unlock_irqrestore(&part->IPI_lock, irq_flags);
+
+	if (XPC_ANY_OPENCLOSE_IPI_FLAGS_SET(IPI_amo)) {
+		ret = xpc_pull_remote_cachelines_sn2(part,
+						    part->remote_openclose_args,
+						     (void *)part->
+						     remote_openclose_args_pa,
+						     XPC_OPENCLOSE_ARGS_SIZE);
+		if (ret != xpSuccess) {
+			XPC_DEACTIVATE_PARTITION(part, ret);
+
+			dev_dbg(xpc_chan, "failed to pull openclose args from "
+				"partition %d, ret=%d\n", XPC_PARTID(part),
+				ret);
+
+			/* don't bother processing IPIs anymore */
+			IPI_amo = 0;
+		}
+	}
+
+	if (XPC_ANY_MSG_IPI_FLAGS_SET(IPI_amo)) {
+		ret = xpc_pull_remote_cachelines_sn2(part, part->remote_GPs,
+						    (void *)part->remote_GPs_pa,
+						     XPC_GP_SIZE);
+		if (ret != xpSuccess) {
+			XPC_DEACTIVATE_PARTITION(part, ret);
+
+			dev_dbg(xpc_chan, "failed to pull GPs from partition "
+				"%d, ret=%d\n", XPC_PARTID(part), ret);
+
+			/* don't bother processing IPIs anymore */
+			IPI_amo = 0;
+		}
+	}
+
+	return IPI_amo;
+}
+
+static struct xpc_msg *
+xpc_pull_remote_msg_sn2(struct xpc_channel *ch, s64 get)
+{
+	struct xpc_partition *part = &xpc_partitions[ch->partid];
+	struct xpc_msg *remote_msg, *msg;
+	u32 msg_index, nmsgs;
+	u64 msg_offset;
+	enum xp_retval ret;
+
+	if (mutex_lock_interruptible(&ch->msg_to_pull_mutex) != 0) {
+		/* we were interrupted by a signal */
+		return NULL;
+	}
+
+	while (get >= ch->next_msg_to_pull) {
+
+		/* pull as many messages as are ready and able to be pulled */
+
+		msg_index = ch->next_msg_to_pull % ch->remote_nentries;
+
+		DBUG_ON(ch->next_msg_to_pull >= ch->w_remote_GP.put);
+		nmsgs = ch->w_remote_GP.put - ch->next_msg_to_pull;
+		if (msg_index + nmsgs > ch->remote_nentries) {
+			/* ignore the ones that wrap the msg queue for now */
+			nmsgs = ch->remote_nentries - msg_index;
+		}
+
+		msg_offset = msg_index * ch->msg_size;
+		msg = (struct xpc_msg *)((u64)ch->remote_msgqueue + msg_offset);
+		remote_msg = (struct xpc_msg *)(ch->remote_msgqueue_pa +
+						msg_offset);
+
+		ret = xpc_pull_remote_cachelines_sn2(part, msg, remote_msg,
+						     nmsgs * ch->msg_size);
+		if (ret != xpSuccess) {
+
+			dev_dbg(xpc_chan, "failed to pull %d msgs starting with"
+				" msg %ld from partition %d, channel=%d, "
+				"ret=%d\n", nmsgs, ch->next_msg_to_pull,
+				ch->partid, ch->number, ret);
+
+			XPC_DEACTIVATE_PARTITION(part, ret);
+
+			mutex_unlock(&ch->msg_to_pull_mutex);
+			return NULL;
+		}
+
+		ch->next_msg_to_pull += nmsgs;
+	}
+
+	mutex_unlock(&ch->msg_to_pull_mutex);
+
+	/* return the message we were looking for */
+	msg_offset = (get % ch->remote_nentries) * ch->msg_size;
+	msg = (struct xpc_msg *)((u64)ch->remote_msgqueue + msg_offset);
+
+	return msg;
+}
+
+/*
+ * Get a message to be delivered.
+ */
+static struct xpc_msg *
+xpc_get_deliverable_msg_sn2(struct xpc_channel *ch)
+{
+	struct xpc_msg *msg = NULL;
+	s64 get;
+
+	do {
+		if (ch->flags & XPC_C_DISCONNECTING)
+			break;
+
+		get = ch->w_local_GP.get;
+		rmb();	/* guarantee that .get loads before .put */
+		if (get == ch->w_remote_GP.put)
+			break;
+
+		/* There are messages waiting to be pulled and delivered.
+		 * We need to try to secure one for ourselves. We'll do this
+		 * by trying to increment w_local_GP.get and hope that no one
+		 * else beats us to it. If they do, we'll we'll simply have
+		 * to try again for the next one.
+		 */
+
+		if (cmpxchg(&ch->w_local_GP.get, get, get + 1) == get) {
+			/* we got the entry referenced by get */
+
+			dev_dbg(xpc_chan, "w_local_GP.get changed to %ld, "
+				"partid=%d, channel=%d\n", get + 1,
+				ch->partid, ch->number);
+
+			/* pull the message from the remote partition */
+
+			msg = xpc_pull_remote_msg_sn2(ch, get);
+
+			DBUG_ON(msg != NULL && msg->number != get);
+			DBUG_ON(msg != NULL && (msg->flags & XPC_M_DONE));
+			DBUG_ON(msg != NULL && !(msg->flags & XPC_M_READY));
+
+			break;
+		}
+
+	} while (1);
+
+	return msg;
+}
+
 void
 xpc_init_sn2(void)
 {
 	xpc_rsvd_page_init = xpc_rsvd_page_init_sn2;
+	xpc_setup_infrastructure = xpc_setup_infrastructure_sn2;
+	xpc_teardown_infrastructure = xpc_teardown_infrastructure_sn2;
+	xpc_make_first_contact = xpc_make_first_contact_sn2;
+	xpc_get_IPI_flags = xpc_get_IPI_flags_sn2;
+	xpc_get_deliverable_msg = xpc_get_deliverable_msg_sn2;
 }
 
 void
diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-isolate-xpc_vars_part-structure-to-sn2-only drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-isolate-xpc_vars_part-structure-to-sn2-only
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -36,10 +36,58 @@ xpc_rsvd_page_init_uv(struct xpc_rsvd_pa
 	return xpSuccess;
 }
 
+/*
+ * Setup the infrastructure necessary to support XPartition Communication
+ * between the specified remote partition and the local one.
+ */
+static enum xp_retval
+xpc_setup_infrastructure_uv(struct xpc_partition *part)
+{
+	/* >>> this function needs fleshing out */
+	return xpUnsupported;
+}
+
+/*
+ * Teardown the infrastructure necessary to support XPartition Communication
+ * between the specified remote partition and the local one.
+ */
+static void
+xpc_teardown_infrastructure_uv(struct xpc_partition *part)
+{
+	/* >>> this function needs fleshing out */
+	return;
+}
+
+static enum xp_retval
+xpc_make_first_contact_uv(struct xpc_partition *part)
+{
+	/* >>> this function needs fleshing out */
+	return xpUnsupported;
+}
+
+static u64
+xpc_get_IPI_flags_uv(struct xpc_partition *part)
+{
+	/* >>> this function needs fleshing out */
+	return 0UL;
+}
+
+static struct xpc_msg *
+xpc_get_deliverable_msg_uv(struct xpc_channel *ch)
+{
+	/* >>> this function needs fleshing out */
+	return NULL;
+}
+
 void
 xpc_init_uv(void)
 {
 	xpc_rsvd_page_init = xpc_rsvd_page_init_uv;
+	xpc_setup_infrastructure = xpc_setup_infrastructure_uv;
+	xpc_teardown_infrastructure = xpc_teardown_infrastructure_uv;
+	xpc_make_first_contact = xpc_make_first_contact_uv;
+	xpc_get_IPI_flags = xpc_get_IPI_flags_uv;
+	xpc_get_deliverable_msg = xpc_get_deliverable_msg_uv;
 }
 
 void
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

