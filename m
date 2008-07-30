From: akpm@linux-foundation.org
Subject: - sgi-xp-isolate-activate-irqs-hardware-specific-components.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:16:38 -0700
Message-ID: <200807301916.m6UJGcrW011142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753618AbYG3TYP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:24:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-xp: isolate activate IRQ's hardware specific components
has been removed from the -mm tree.  Its filename was
     sgi-xp-isolate-activate-irqs-hardware-specific-components.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp: isolate activate IRQ's hardware specific components
From: Dean Nelson <dcn@sgi.com>

Isolate architecture specific code related to XPC's activate IRQ.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc.h           |   14 -
 drivers/misc/sgi-xp/xpc_main.c      |   96 +++--------
 drivers/misc/sgi-xp/xpc_partition.c |  121 --------------
 drivers/misc/sgi-xp/xpc_sn2.c       |  217 ++++++++++++++++++++++----
 4 files changed, 229 insertions(+), 219 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xp-isolate-activate-irqs-hardware-specific-components drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xp-isolate-activate-irqs-hardware-specific-components
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -480,7 +480,7 @@ struct xpc_partition {
 	u64 remote_amos_page_pa;	/* phys addr of partition's amos page */
 	int remote_act_nasid;	/* active part's act/deact nasid */
 	int remote_act_phys_cpuid;	/* active part's act/deact phys cpuid */
-	u32 act_IRQ_rcvd;	/* IRQs since activation */
+	u32 activate_IRQ_rcvd;	/* IRQs since activation */
 	spinlock_t act_lock;	/* protect updating of act_state */
 	u8 act_state;		/* from XPC HB viewpoint */
 	u8 remote_vars_version;	/* version# of partition's vars */
@@ -580,8 +580,8 @@ extern struct device *xpc_part;
 extern struct device *xpc_chan;
 extern int xpc_disengage_request_timelimit;
 extern int xpc_disengage_request_timedout;
-extern atomic_t xpc_act_IRQ_rcvd;
-extern wait_queue_head_t xpc_act_IRQ_wq;
+extern atomic_t xpc_activate_IRQ_rcvd;
+extern wait_queue_head_t xpc_activate_IRQ_wq;
 extern void *xpc_heartbeating_to_mask;
 extern irqreturn_t xpc_notify_IRQ_handler(int, void *);
 extern void xpc_dropped_IPI_check(struct xpc_partition *);
@@ -601,7 +601,7 @@ extern u64 (*xpc_get_IPI_flags) (struct 
 extern struct xpc_msg *(*xpc_get_deliverable_msg) (struct xpc_channel *);
 extern void (*xpc_initiate_partition_activation) (struct xpc_rsvd_page *, u64,
 						  int);
-extern void (*xpc_process_act_IRQ_rcvd) (int);
+extern void (*xpc_process_activate_IRQ_rcvd) (int);
 extern enum xp_retval (*xpc_setup_infrastructure) (struct xpc_partition *);
 extern void (*xpc_teardown_infrastructure) (struct xpc_partition *);
 extern void (*xpc_mark_partition_engaged) (struct xpc_partition *);
@@ -629,10 +629,12 @@ extern enum xp_retval (*xpc_send_msg) (s
 extern void (*xpc_received_msg) (struct xpc_channel *, struct xpc_msg *);
 
 /* found in xpc_sn2.c */
-extern void xpc_init_sn2(void);
+extern int xpc_init_sn2(void);
+extern void xpc_exit_sn2(void);
 
 /* found in xpc_uv.c */
 extern void xpc_init_uv(void);
+extern void xpc_exit_uv(void);
 
 /* found in xpc_partition.c */
 extern int xpc_exiting;
@@ -646,7 +648,7 @@ extern void *xpc_kmalloc_cacheline_align
 extern struct xpc_rsvd_page *xpc_setup_rsvd_page(void);
 extern void xpc_allow_IPI_ops(void);
 extern void xpc_restrict_IPI_ops(void);
-extern int xpc_identify_act_IRQ_sender(void);
+extern int xpc_identify_activate_IRQ_sender(void);
 extern int xpc_partition_disengaged(struct xpc_partition *);
 extern enum xp_retval xpc_mark_partition_active(struct xpc_partition *);
 extern void xpc_mark_partition_inactive(struct xpc_partition *);
diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-xp-isolate-activate-irqs-hardware-specific-components drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xp-isolate-activate-irqs-hardware-specific-components
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -147,11 +147,11 @@ static struct ctl_table_header *xpc_sysc
 /* non-zero if any remote partition disengage request was timed out */
 int xpc_disengage_request_timedout;
 
-/* #of IRQs received */
-atomic_t xpc_act_IRQ_rcvd;
+/* #of activate IRQs received */
+atomic_t xpc_activate_IRQ_rcvd = ATOMIC_INIT(0);
 
 /* IRQ handler notifies this wait queue on receipt of an IRQ */
-DECLARE_WAIT_QUEUE_HEAD(xpc_act_IRQ_wq);
+DECLARE_WAIT_QUEUE_HEAD(xpc_activate_IRQ_wq);
 
 static unsigned long xpc_hb_check_timeout;
 static struct timer_list xpc_hb_timer;
@@ -190,7 +190,7 @@ struct xpc_msg *(*xpc_get_deliverable_ms
 void (*xpc_initiate_partition_activation) (struct xpc_rsvd_page *remote_rp,
 					   u64 remote_rp_pa, int nasid);
 
-void (*xpc_process_act_IRQ_rcvd) (int n_IRQs_expected);
+void (*xpc_process_activate_IRQ_rcvd) (int n_IRQs_expected);
 enum xp_retval (*xpc_setup_infrastructure) (struct xpc_partition *part);
 void (*xpc_teardown_infrastructure) (struct xpc_partition *part);
 
@@ -239,17 +239,6 @@ xpc_timeout_partition_disengage_request(
 }
 
 /*
- * Notify the heartbeat check thread that an IRQ has been received.
- */
-static irqreturn_t
-xpc_act_IRQ_handler(int irq, void *dev_id)
-{
-	atomic_inc(&xpc_act_IRQ_rcvd);
-	wake_up_interruptible(&xpc_act_IRQ_wq);
-	return IRQ_HANDLED;
-}
-
-/*
  * Timer to produce the heartbeat.  The timer structures function is
  * already set when this is initially called.  A tunable is used to
  * specify when the next timeout should occur.
@@ -260,7 +249,7 @@ xpc_hb_beater(unsigned long dummy)
 	xpc_increment_heartbeat();
 
 	if (time_is_before_eq_jiffies(xpc_hb_check_timeout))
-		wake_up_interruptible(&xpc_act_IRQ_wq);
+		wake_up_interruptible(&xpc_activate_IRQ_wq);
 
 	xpc_hb_timer.expires = jiffies + (xpc_hb_interval * HZ);
 	add_timer(&xpc_hb_timer);
@@ -306,7 +295,7 @@ xpc_hb_checker(void *ignore)
 		dev_dbg(xpc_part, "woke up with %d ticks rem; %d IRQs have "
 			"been received\n",
 			(int)(xpc_hb_check_timeout - jiffies),
-			atomic_read(&xpc_act_IRQ_rcvd) - last_IRQ_count);
+			atomic_read(&xpc_activate_IRQ_rcvd) - last_IRQ_count);
 
 		/* checking of remote heartbeats is skewed by IRQ handling */
 		if (time_is_before_eq_jiffies(xpc_hb_check_timeout)) {
@@ -322,15 +311,15 @@ xpc_hb_checker(void *ignore)
 		}
 
 		/* check for outstanding IRQs */
-		new_IRQ_count = atomic_read(&xpc_act_IRQ_rcvd);
+		new_IRQ_count = atomic_read(&xpc_activate_IRQ_rcvd);
 		if (last_IRQ_count < new_IRQ_count || force_IRQ != 0) {
 			force_IRQ = 0;
 
 			dev_dbg(xpc_part, "found an IRQ to process; will be "
 				"resetting xpc_hb_check_timeout\n");
 
-			xpc_process_act_IRQ_rcvd(new_IRQ_count -
-						 last_IRQ_count);
+			xpc_process_activate_IRQ_rcvd(new_IRQ_count -
+						      last_IRQ_count);
 			last_IRQ_count = new_IRQ_count;
 
 			xpc_hb_check_timeout = jiffies +
@@ -338,9 +327,9 @@ xpc_hb_checker(void *ignore)
 		}
 
 		/* wait for IRQ or timeout */
-		(void)wait_event_interruptible(xpc_act_IRQ_wq,
-					       (last_IRQ_count <
-						atomic_read(&xpc_act_IRQ_rcvd)
+		(void)wait_event_interruptible(xpc_activate_IRQ_wq,
+					       (last_IRQ_count < atomic_read(
+						&xpc_activate_IRQ_rcvd)
 						|| time_is_before_eq_jiffies(
 						xpc_hb_check_timeout) ||
 						xpc_exiting));
@@ -884,10 +873,7 @@ xpc_do_exit(enum xp_retval reason)
 	 * the heartbeat checker thread in case it's sleeping.
 	 */
 	xpc_exiting = 1;
-	wake_up_interruptible(&xpc_act_IRQ_wq);
-
-	/* ignore all incoming interrupts */
-	free_irq(SGI_XPC_ACTIVATE, NULL);
+	wake_up_interruptible(&xpc_activate_IRQ_wq);
 
 	/* wait for the discovery thread to exit */
 	wait_for_completion(&xpc_discovery_exited);
@@ -968,9 +954,6 @@ xpc_do_exit(enum xp_retval reason)
 		(void)unregister_reboot_notifier(&xpc_reboot_notifier);
 	}
 
-	/* close down protections for IPI operations */
-	xpc_restrict_IPI_ops();
-
 	/* clear the interface to XPC's functions */
 	xpc_clear_interface();
 
@@ -979,6 +962,11 @@ xpc_do_exit(enum xp_retval reason)
 
 	kfree(xpc_partitions);
 	kfree(xpc_remote_copy_buffer_base);
+
+	if (is_shub())
+		xpc_exit_sn2();
+	else
+		xpc_exit_uv();
 }
 
 /*
@@ -1144,7 +1132,9 @@ xpc_init(void)
 		if (xp_max_npartitions != 64)
 			return -EINVAL;
 
-		xpc_init_sn2();
+		ret = xpc_init_sn2();
+		if (ret != 0)
+			return ret;
 
 	} else if (is_uv()) {
 		xpc_init_uv();
@@ -1163,7 +1153,8 @@ xpc_init(void)
 						  &xpc_remote_copy_buffer_base);
 	if (xpc_remote_copy_buffer == NULL) {
 		dev_err(xpc_part, "can't get memory for remote copy buffer\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_1;
 	}
 
 	xpc_partitions = kzalloc(sizeof(struct xpc_partition) *
@@ -1171,7 +1162,7 @@ xpc_init(void)
 	if (xpc_partitions == NULL) {
 		dev_err(xpc_part, "can't get memory for partition structure\n");
 		ret = -ENOMEM;
-		goto out_1;
+		goto out_2;
 	}
 
 	/*
@@ -1187,7 +1178,7 @@ xpc_init(void)
 
 		DBUG_ON((u64)part != L1_CACHE_ALIGN((u64)part));
 
-		part->act_IRQ_rcvd = 0;
+		part->activate_IRQ_rcvd = 0;
 		spin_lock_init(&part->act_lock);
 		part->act_state = XPC_P_INACTIVE;
 		XPC_SET_REASON(part, 0, 0);
@@ -1205,33 +1196,6 @@ xpc_init(void)
 	xpc_sysctl = register_sysctl_table(xpc_sys_dir);
 
 	/*
-	 * Open up protections for IPI operations (and AMO operations on
-	 * Shub 1.1 systems).
-	 */
-	xpc_allow_IPI_ops();
-
-	/*
-	 * Interrupts being processed will increment this atomic variable and
-	 * awaken the heartbeat thread which will process the interrupts.
-	 */
-	atomic_set(&xpc_act_IRQ_rcvd, 0);
-
-	/*
-	 * This is safe to do before the xpc_hb_checker thread has started
-	 * because the handler releases a wait queue.  If an interrupt is
-	 * received before the thread is waiting, it will not go to sleep,
-	 * but rather immediately process the interrupt.
-	 */
-	ret = request_irq(SGI_XPC_ACTIVATE, xpc_act_IRQ_handler, 0,
-			  "xpc hb", NULL);
-	if (ret != 0) {
-		dev_err(xpc_part, "can't register ACTIVATE IRQ handler, "
-			"errno=%d\n", -ret);
-		ret = -EBUSY;
-		goto out_2;
-	}
-
-	/*
 	 * Fill the partition reserved page with the information needed by
 	 * other partitions to discover we are alive and establish initial
 	 * communications.
@@ -1296,14 +1260,16 @@ out_4:
 	(void)unregister_die_notifier(&xpc_die_notifier);
 	(void)unregister_reboot_notifier(&xpc_reboot_notifier);
 out_3:
-	free_irq(SGI_XPC_ACTIVATE, NULL);
-out_2:
-	xpc_restrict_IPI_ops();
 	if (xpc_sysctl)
 		unregister_sysctl_table(xpc_sysctl);
 	kfree(xpc_partitions);
-out_1:
+out_2:
 	kfree(xpc_remote_copy_buffer_base);
+out_1:
+	if (is_shub())
+		xpc_exit_sn2();
+	else
+		xpc_exit_uv();
 	return ret;
 }
 
diff -puN drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-isolate-activate-irqs-hardware-specific-components drivers/misc/sgi-xp/xpc_partition.c
--- a/drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-isolate-activate-irqs-hardware-specific-components
+++ a/drivers/misc/sgi-xp/xpc_partition.c
@@ -29,16 +29,6 @@
 /* XPC is exiting flag */
 int xpc_exiting;
 
-/* SH_IPI_ACCESS shub register value on startup */
-static u64 xpc_sh1_IPI_access;
-static u64 xpc_sh2_IPI_access0;
-static u64 xpc_sh2_IPI_access1;
-static u64 xpc_sh2_IPI_access2;
-static u64 xpc_sh2_IPI_access3;
-
-/* original protection values for each node */
-u64 xpc_prot_vec[MAX_NUMNODES];
-
 /* this partition's reserved page pointers */
 struct xpc_rsvd_page *xpc_rsvd_page;
 static u64 *xpc_part_nasids;
@@ -211,117 +201,6 @@ xpc_setup_rsvd_page(void)
 }
 
 /*
- * Change protections to allow IPI operations (and AMO operations on
- * Shub 1.1 systems).
- */
-void
-xpc_allow_IPI_ops(void)
-{
-	int node;
-	int nasid;
-
-	/* >>> Change SH_IPI_ACCESS code to use SAL call once it is available */
-
-	if (is_shub2()) {
-		xpc_sh2_IPI_access0 =
-		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS0));
-		xpc_sh2_IPI_access1 =
-		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS1));
-		xpc_sh2_IPI_access2 =
-		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS2));
-		xpc_sh2_IPI_access3 =
-		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS3));
-
-		for_each_online_node(node) {
-			nasid = cnodeid_to_nasid(node);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS0),
-			      -1UL);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS1),
-			      -1UL);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS2),
-			      -1UL);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS3),
-			      -1UL);
-		}
-
-	} else {
-		xpc_sh1_IPI_access =
-		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH1_IPI_ACCESS));
-
-		for_each_online_node(node) {
-			nasid = cnodeid_to_nasid(node);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH1_IPI_ACCESS),
-			      -1UL);
-
-			/*
-			 * Since the BIST collides with memory operations on
-			 * SHUB 1.1 sn_change_memprotect() cannot be used.
-			 */
-			if (enable_shub_wars_1_1()) {
-				/* open up everything */
-				xpc_prot_vec[node] = (u64)HUB_L((u64 *)
-								GLOBAL_MMR_ADDR
-								(nasid,
-						  SH1_MD_DQLP_MMR_DIR_PRIVEC0));
-				HUB_S((u64 *)
-				      GLOBAL_MMR_ADDR(nasid,
-						   SH1_MD_DQLP_MMR_DIR_PRIVEC0),
-				      -1UL);
-				HUB_S((u64 *)
-				      GLOBAL_MMR_ADDR(nasid,
-						   SH1_MD_DQRP_MMR_DIR_PRIVEC0),
-				      -1UL);
-			}
-		}
-	}
-}
-
-/*
- * Restrict protections to disallow IPI operations (and AMO operations on
- * Shub 1.1 systems).
- */
-void
-xpc_restrict_IPI_ops(void)
-{
-	int node;
-	int nasid;
-
-	/* >>> Change SH_IPI_ACCESS code to use SAL call once it is available */
-
-	if (is_shub2()) {
-
-		for_each_online_node(node) {
-			nasid = cnodeid_to_nasid(node);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS0),
-			      xpc_sh2_IPI_access0);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS1),
-			      xpc_sh2_IPI_access1);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS2),
-			      xpc_sh2_IPI_access2);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS3),
-			      xpc_sh2_IPI_access3);
-		}
-
-	} else {
-
-		for_each_online_node(node) {
-			nasid = cnodeid_to_nasid(node);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH1_IPI_ACCESS),
-			      xpc_sh1_IPI_access);
-
-			if (enable_shub_wars_1_1()) {
-				HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid,
-						   SH1_MD_DQLP_MMR_DIR_PRIVEC0),
-				      xpc_prot_vec[node]);
-				HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid,
-						   SH1_MD_DQRP_MMR_DIR_PRIVEC0),
-				      xpc_prot_vec[node]);
-			}
-		}
-	}
-}
-
-/*
  * Get a copy of a portion of the remote partition's rsvd page.
  *
  * remote_rp points to a buffer that is cacheline aligned for BTE copies and
diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-isolate-activate-irqs-hardware-specific-components drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-isolate-activate-irqs-hardware-specific-components
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -22,6 +22,87 @@
 static struct xpc_vars_sn2 *xpc_vars;	/* >>> Add _sn2 suffix? */
 static struct xpc_vars_part_sn2 *xpc_vars_part; /* >>> Add _sn2 suffix? */
 
+/* SH_IPI_ACCESS shub register value on startup */
+static u64 xpc_sh1_IPI_access;
+static u64 xpc_sh2_IPI_access0;
+static u64 xpc_sh2_IPI_access1;
+static u64 xpc_sh2_IPI_access2;
+static u64 xpc_sh2_IPI_access3;
+
+/*
+ * Change protections to allow IPI operations.
+ */
+static void
+xpc_allow_IPI_ops_sn2(void)
+{
+	int node;
+	int nasid;
+
+	/* >>> The following should get moved into SAL. */
+	if (is_shub2()) {
+		xpc_sh2_IPI_access0 =
+		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS0));
+		xpc_sh2_IPI_access1 =
+		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS1));
+		xpc_sh2_IPI_access2 =
+		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS2));
+		xpc_sh2_IPI_access3 =
+		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS3));
+
+		for_each_online_node(node) {
+			nasid = cnodeid_to_nasid(node);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS0),
+			      -1UL);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS1),
+			      -1UL);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS2),
+			      -1UL);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS3),
+			      -1UL);
+		}
+	} else {
+		xpc_sh1_IPI_access =
+		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH1_IPI_ACCESS));
+
+		for_each_online_node(node) {
+			nasid = cnodeid_to_nasid(node);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH1_IPI_ACCESS),
+			      -1UL);
+		}
+	}
+}
+
+/*
+ * Restrict protections to disallow IPI operations.
+ */
+static void
+xpc_disallow_IPI_ops_sn2(void)
+{
+	int node;
+	int nasid;
+
+	/* >>> The following should get moved into SAL. */
+	if (is_shub2()) {
+		for_each_online_node(node) {
+			nasid = cnodeid_to_nasid(node);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS0),
+			      xpc_sh2_IPI_access0);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS1),
+			      xpc_sh2_IPI_access1);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS2),
+			      xpc_sh2_IPI_access2);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS3),
+			      xpc_sh2_IPI_access3);
+		}
+	} else {
+		for_each_online_node(node) {
+			nasid = cnodeid_to_nasid(node);
+			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH1_IPI_ACCESS),
+			      xpc_sh1_IPI_access);
+		}
+	}
+}
+
 /*
  * The following set of macros and functions are used for the sending and
  * receiving of IPIs (also known as IRQs). There are two flavors of IPIs,
@@ -74,6 +155,17 @@ xpc_IPI_init_sn2(int index)
  */
 
 /*
+ * Notify the heartbeat check thread that an activate IRQ has been received.
+ */
+static irqreturn_t
+xpc_handle_activate_IRQ_sn2(int irq, void *dev_id)
+{
+	atomic_inc(&xpc_activate_IRQ_rcvd);
+	wake_up_interruptible(&xpc_activate_IRQ_wq);
+	return IRQ_HANDLED;
+}
+
+/*
  * Flag the appropriate AMO variable and send an IPI to the specified node.
  */
 static void
@@ -100,8 +192,8 @@ xpc_activate_IRQ_send_local_sn2(int from
 	/* fake the sending and receipt of an activate IRQ from remote nasid */
 	FETCHOP_STORE_OP(TO_AMO((u64)&amos[w_index].variable), FETCHOP_OR,
 			 (1UL << b_index));
-	atomic_inc(&xpc_act_IRQ_rcvd);
-	wake_up_interruptible(&xpc_act_IRQ_wq);
+	atomic_inc(&xpc_activate_IRQ_rcvd);
+	wake_up_interruptible(&xpc_activate_IRQ_wq);
 }
 
 static void
@@ -383,11 +475,65 @@ xpc_clear_partition_disengage_request_sn
 			 ~partid_mask);
 }
 
+/* original protection values for each node */
+static u64 xpc_prot_vec_sn2[MAX_NUMNODES];
+
+/*
+ * Change protections to allow AMO operations on non-Shub 1.1 systems.
+ */
+static enum xp_retval
+xpc_allow_AMO_ops_sn2(AMO_t *amos_page)
+{
+	u64 nasid_array = 0;
+	int ret;
+
+	/*
+	 * On SHUB 1.1, we cannot call sn_change_memprotect() since the BIST
+	 * collides with memory operations. On those systems we call
+	 * xpc_allow_AMO_ops_shub_wars_1_1_sn2() instead.
+	 */
+	if (!enable_shub_wars_1_1()) {
+		ret = sn_change_memprotect(ia64_tpa((u64)amos_page), PAGE_SIZE,
+					   SN_MEMPROT_ACCESS_CLASS_1,
+					   &nasid_array);
+		if (ret != 0)
+			return xpSalError;
+	}
+	return xpSuccess;
+}
+
+/*
+ * Change protections to allow AMO operations on Shub 1.1 systems.
+ */
+static void
+xpc_allow_AMO_ops_shub_wars_1_1_sn2(void)
+{
+	int node;
+	int nasid;
+
+	if (!enable_shub_wars_1_1())
+		return;
+
+	for_each_online_node(node) {
+		nasid = cnodeid_to_nasid(node);
+		/* save current protection values */
+		xpc_prot_vec_sn2[node] =
+		    (u64)HUB_L((u64 *)GLOBAL_MMR_ADDR(nasid,
+						  SH1_MD_DQLP_MMR_DIR_PRIVEC0));
+		/* open up everything */
+		HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid,
+					     SH1_MD_DQLP_MMR_DIR_PRIVEC0),
+		      -1UL);
+		HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid,
+					     SH1_MD_DQRP_MMR_DIR_PRIVEC0),
+		      -1UL);
+	}
+}
+
 static enum xp_retval
 xpc_rsvd_page_init_sn2(struct xpc_rsvd_page *rp)
 {
 	AMO_t *amos_page;
-	u64 nasid_array = 0;
 	int i;
 	int ret;
 
@@ -421,21 +567,15 @@ xpc_rsvd_page_init_sn2(struct xpc_rsvd_p
 		}
 
 		/*
-		 * Open up AMO-R/W to cpu.  This is done for Shub 1.1 systems
-		 * when xpc_allow_IPI_ops() is called via xpc_hb_init().
+		 * Open up AMO-R/W to cpu.  This is done on Shub 1.1 systems
+		 * when xpc_allow_AMO_ops_shub_wars_1_1_sn2() is called.
 		 */
-		if (!enable_shub_wars_1_1()) {
-			ret = sn_change_memprotect(ia64_tpa((u64)amos_page),
-						   PAGE_SIZE,
-						   SN_MEMPROT_ACCESS_CLASS_1,
-						   &nasid_array);
-			if (ret != 0) {
-				dev_err(xpc_part, "can't change memory "
-					"protections\n");
-				uncached_free_page(__IA64_UNCACHED_OFFSET |
-						   TO_PHYS((u64)amos_page), 1);
-				return xpSalError;
-			}
+		ret = xpc_allow_AMO_ops_sn2(amos_page);
+		if (ret != xpSuccess) {
+			dev_err(xpc_part, "can't allow AMO operations\n");
+			uncached_free_page(__IA64_UNCACHED_OFFSET |
+					   TO_PHYS((u64)amos_page), 1);
+			return ret;
 		}
 	}
 
@@ -656,7 +796,7 @@ xpc_update_partition_info_sn2(struct xpc
  * initialized reserved page.
  */
 static void
-xpc_identify_act_IRQ_req_sn2(int nasid)
+xpc_identify_activate_IRQ_req_sn2(int nasid)
 {
 	struct xpc_rsvd_page *remote_rp;
 	struct xpc_vars_sn2 *remote_vars;
@@ -702,10 +842,10 @@ xpc_identify_act_IRQ_req_sn2(int nasid)
 		return;
 	}
 
-	part->act_IRQ_rcvd++;
+	part->activate_IRQ_rcvd++;
 
 	dev_dbg(xpc_part, "partid for nasid %d is %d; IRQs = %d; HB = "
-		"%ld:0x%lx\n", (int)nasid, (int)partid, part->act_IRQ_rcvd,
+		"%ld:0x%lx\n", (int)nasid, (int)partid, part->activate_IRQ_rcvd,
 		remote_vars->heartbeat, remote_vars->heartbeating_to_mask[0]);
 
 	if (xpc_partition_disengaged(part) &&
@@ -831,7 +971,7 @@ xpc_identify_act_IRQ_req_sn2(int nasid)
  * Return #of IRQs detected.
  */
 int
-xpc_identify_act_IRQ_sender_sn2(void)
+xpc_identify_activate_IRQ_sender_sn2(void)
 {
 	int word, bit;
 	u64 nasid_mask;
@@ -872,7 +1012,7 @@ xpc_identify_act_IRQ_sender_sn2(void)
 				nasid = XPC_NASID_FROM_W_B(word, bit);
 				dev_dbg(xpc_part, "interrupt from nasid %ld\n",
 					nasid);
-				xpc_identify_act_IRQ_req_sn2(nasid);
+				xpc_identify_activate_IRQ_req_sn2(nasid);
 			}
 		}
 	}
@@ -880,14 +1020,14 @@ xpc_identify_act_IRQ_sender_sn2(void)
 }
 
 static void
-xpc_process_act_IRQ_rcvd_sn2(int n_IRQs_expected)
+xpc_process_activate_IRQ_rcvd_sn2(int n_IRQs_expected)
 {
 	int n_IRQs_detected;
 
-	n_IRQs_detected = xpc_identify_act_IRQ_sender_sn2();
+	n_IRQs_detected = xpc_identify_activate_IRQ_sender_sn2();
 	if (n_IRQs_detected < n_IRQs_expected) {
 		/* retry once to help avoid missing AMO */
-		(void)xpc_identify_act_IRQ_sender_sn2();
+		(void)xpc_identify_activate_IRQ_sender_sn2();
 	}
 }
 
@@ -1775,9 +1915,11 @@ xpc_received_msg_sn2(struct xpc_channel 
 		xpc_acknowledge_msgs_sn2(ch, get, msg->flags);
 }
 
-void
+int
 xpc_init_sn2(void)
 {
+	int ret;
+
 	xpc_rsvd_page_init = xpc_rsvd_page_init_sn2;
 	xpc_increment_heartbeat = xpc_increment_heartbeat_sn2;
 	xpc_offline_heartbeat = xpc_offline_heartbeat_sn2;
@@ -1788,7 +1930,7 @@ xpc_init_sn2(void)
 
 	xpc_initiate_partition_activation =
 	    xpc_initiate_partition_activation_sn2;
-	xpc_process_act_IRQ_rcvd = xpc_process_act_IRQ_rcvd_sn2;
+	xpc_process_activate_IRQ_rcvd = xpc_process_activate_IRQ_rcvd_sn2;
 	xpc_setup_infrastructure = xpc_setup_infrastructure_sn2;
 	xpc_teardown_infrastructure = xpc_teardown_infrastructure_sn2;
 	xpc_make_first_contact = xpc_make_first_contact_sn2;
@@ -1819,9 +1961,30 @@ xpc_init_sn2(void)
 
 	xpc_send_msg = xpc_send_msg_sn2;
 	xpc_received_msg = xpc_received_msg_sn2;
+
+	/* open up protections for IPI and [potentially] AMO operations */
+	xpc_allow_IPI_ops_sn2();
+	xpc_allow_AMO_ops_shub_wars_1_1_sn2();
+
+	/*
+	 * This is safe to do before the xpc_hb_checker thread has started
+	 * because the handler releases a wait queue.  If an interrupt is
+	 * received before the thread is waiting, it will not go to sleep,
+	 * but rather immediately process the interrupt.
+	 */
+	ret = request_irq(SGI_XPC_ACTIVATE, xpc_handle_activate_IRQ_sn2, 0,
+			  "xpc hb", NULL);
+	if (ret != 0) {
+		dev_err(xpc_part, "can't register ACTIVATE IRQ handler, "
+			"errno=%d\n", -ret);
+		xpc_disallow_IPI_ops_sn2();
+	}
+	return ret;
 }
 
 void
 xpc_exit_sn2(void)
 {
+	free_irq(SGI_XPC_ACTIVATE, NULL);
+	xpc_disallow_IPI_ops_sn2();
 }
_

Patches currently in -mm which might be from dcn@sgi.com are

origin.patch

