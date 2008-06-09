From: akpm@linux-foundation.org
Subject: + sgi-xp-add-_sn2-suffix-to-a-few-variables.patch added to -mm tree
Date: Sun, 08 Jun 2008 17:18:29 -0700
Message-ID: <200806090018.m590IT3t027115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756417AbYFIASc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 20:18:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dcn@sgi.com


The patch titled
     sgi-xp: add _sn2 suffix to a few variables
has been added to the -mm tree.  Its filename is
     sgi-xp-add-_sn2-suffix-to-a-few-variables.patch

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
Subject: sgi-xp: add _sn2 suffix to a few variables
From: Dean Nelson <dcn@sgi.com>

Add an '_sn2' suffix to some variables found in xpc_sn2.c.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_sn2.c |  124 ++++++++++++++++----------------
 1 file changed, 65 insertions(+), 59 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-add-_sn2-suffix-to-a-few-variables drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-add-_sn2-suffix-to-a-few-variables
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -56,15 +56,15 @@
 static char *xpc_remote_copy_buffer_sn2;
 static void *xpc_remote_copy_buffer_base_sn2;
 
-static struct xpc_vars_sn2 *xpc_vars;	/* >>> Add _sn2 suffix? */
-static struct xpc_vars_part_sn2 *xpc_vars_part; /* >>> Add _sn2 suffix? */
+static struct xpc_vars_sn2 *xpc_vars_sn2;
+static struct xpc_vars_part_sn2 *xpc_vars_part_sn2;
 
 /* SH_IPI_ACCESS shub register value on startup */
-static u64 xpc_sh1_IPI_access;
-static u64 xpc_sh2_IPI_access0;
-static u64 xpc_sh2_IPI_access1;
-static u64 xpc_sh2_IPI_access2;
-static u64 xpc_sh2_IPI_access3;
+static u64 xpc_sh1_IPI_access_sn2;
+static u64 xpc_sh2_IPI_access0_sn2;
+static u64 xpc_sh2_IPI_access1_sn2;
+static u64 xpc_sh2_IPI_access2_sn2;
+static u64 xpc_sh2_IPI_access3_sn2;
 
 /*
  * Change protections to allow IPI operations.
@@ -77,13 +77,13 @@ xpc_allow_IPI_ops_sn2(void)
 
 	/* >>> The following should get moved into SAL. */
 	if (is_shub2()) {
-		xpc_sh2_IPI_access0 =
+		xpc_sh2_IPI_access0_sn2 =
 		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS0));
-		xpc_sh2_IPI_access1 =
+		xpc_sh2_IPI_access1_sn2 =
 		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS1));
-		xpc_sh2_IPI_access2 =
+		xpc_sh2_IPI_access2_sn2 =
 		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS2));
-		xpc_sh2_IPI_access3 =
+		xpc_sh2_IPI_access3_sn2 =
 		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS3));
 
 		for_each_online_node(node) {
@@ -98,7 +98,7 @@ xpc_allow_IPI_ops_sn2(void)
 			      -1UL);
 		}
 	} else {
-		xpc_sh1_IPI_access =
+		xpc_sh1_IPI_access_sn2 =
 		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH1_IPI_ACCESS));
 
 		for_each_online_node(node) {
@@ -123,19 +123,19 @@ xpc_disallow_IPI_ops_sn2(void)
 		for_each_online_node(node) {
 			nasid = cnodeid_to_nasid(node);
 			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS0),
-			      xpc_sh2_IPI_access0);
+			      xpc_sh2_IPI_access0_sn2);
 			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS1),
-			      xpc_sh2_IPI_access1);
+			      xpc_sh2_IPI_access1_sn2);
 			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS2),
-			      xpc_sh2_IPI_access2);
+			      xpc_sh2_IPI_access2_sn2);
 			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS3),
-			      xpc_sh2_IPI_access3);
+			      xpc_sh2_IPI_access3_sn2);
 		}
 	} else {
 		for_each_online_node(node) {
 			nasid = cnodeid_to_nasid(node);
 			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH1_IPI_ACCESS),
-			      xpc_sh1_IPI_access);
+			      xpc_sh1_IPI_access_sn2);
 		}
 	}
 }
@@ -182,7 +182,7 @@ xpc_send_IRQ_sn2(struct amo *amo, u64 fl
 static struct amo *
 xpc_init_IRQ_amo_sn2(int index)
 {
-	struct amo *amo = xpc_vars->amos_page + index;
+	struct amo *amo = xpc_vars_sn2->amos_page + index;
 
 	(void)xpc_receive_IRQ_amo_sn2(amo);	/* clear amo variable */
 	return amo;
@@ -225,7 +225,7 @@ xpc_send_local_activate_IRQ_sn2(int from
 {
 	int w_index = XPC_NASID_W_INDEX(from_nasid);
 	int b_index = XPC_NASID_B_INDEX(from_nasid);
-	struct amo *amos = (struct amo *)__va(xpc_vars->amos_page_pa +
+	struct amo *amos = (struct amo *)__va(xpc_vars_sn2->amos_page_pa +
 					      (XPC_ACTIVATE_IRQ_AMOS_SN2 *
 					      sizeof(struct amo)));
 
@@ -492,7 +492,8 @@ xpc_indicate_partition_disengaged_sn2(st
 static int
 xpc_partition_engaged_sn2(short partid)
 {
-	struct amo *amo = xpc_vars->amos_page + XPC_ENGAGED_PARTITIONS_AMO_SN2;
+	struct amo *amo = xpc_vars_sn2->amos_page +
+			  XPC_ENGAGED_PARTITIONS_AMO_SN2;
 
 	/* our partition's amo variable ANDed with partid mask */
 	return (FETCHOP_LOAD_OP(TO_AMO((u64)&amo->variable), FETCHOP_LOAD) &
@@ -502,7 +503,8 @@ xpc_partition_engaged_sn2(short partid)
 static int
 xpc_any_partition_engaged_sn2(void)
 {
-	struct amo *amo = xpc_vars->amos_page + XPC_ENGAGED_PARTITIONS_AMO_SN2;
+	struct amo *amo = xpc_vars_sn2->amos_page +
+			  XPC_ENGAGED_PARTITIONS_AMO_SN2;
 
 	/* our partition's amo variable */
 	return FETCHOP_LOAD_OP(TO_AMO((u64)&amo->variable), FETCHOP_LOAD) != 0;
@@ -511,7 +513,8 @@ xpc_any_partition_engaged_sn2(void)
 static void
 xpc_assume_partition_disengaged_sn2(short partid)
 {
-	struct amo *amo = xpc_vars->amos_page + XPC_ENGAGED_PARTITIONS_AMO_SN2;
+	struct amo *amo = xpc_vars_sn2->amos_page +
+			  XPC_ENGAGED_PARTITIONS_AMO_SN2;
 
 	/* clear bit(s) based on partid mask in our partition's amo */
 	FETCHOP_STORE_OP(TO_AMO((u64)&amo->variable), FETCHOP_AND,
@@ -580,27 +583,27 @@ xpc_rsvd_page_init_sn2(struct xpc_rsvd_p
 	int i;
 	int ret;
 
-	xpc_vars = XPC_RP_VARS(rp);
+	xpc_vars_sn2 = XPC_RP_VARS(rp);
 
-	rp->sn.vars_pa = __pa(xpc_vars);
+	rp->sn.vars_pa = __pa(xpc_vars_sn2);
 
 	/* vars_part array follows immediately after vars */
-	xpc_vars_part = (struct xpc_vars_part_sn2 *)((u8 *)XPC_RP_VARS(rp) +
-						     XPC_RP_VARS_SIZE);
+	xpc_vars_part_sn2 = (struct xpc_vars_part_sn2 *)((u8 *)XPC_RP_VARS(rp) +
+							 XPC_RP_VARS_SIZE);
 
 	/*
-	 * Before clearing xpc_vars, see if a page of amos had been previously
-	 * allocated. If not we'll need to allocate one and set permissions
-	 * so that cross-partition amos are allowed.
+	 * Before clearing xpc_vars_sn2, see if a page of amos had been
+	 * previously allocated. If not we'll need to allocate one and set
+	 * permissions so that cross-partition amos are allowed.
 	 *
 	 * The allocated amo page needs MCA reporting to remain disabled after
 	 * XPC has unloaded.  To make this work, we keep a copy of the pointer
-	 * to this page (i.e., amos_page) in the struct xpc_vars structure,
+	 * to this page (i.e., amos_page) in the struct xpc_vars_sn2 structure,
 	 * which is pointed to by the reserved page, and re-use that saved copy
 	 * on subsequent loads of XPC. This amo page is never freed, and its
 	 * memory protections are never restricted.
 	 */
-	amos_page = xpc_vars->amos_page;
+	amos_page = xpc_vars_sn2->amos_page;
 	if (amos_page == NULL) {
 		amos_page = (struct amo *)TO_AMO(uncached_alloc_page(0, 1));
 		if (amos_page == NULL) {
@@ -621,18 +624,18 @@ xpc_rsvd_page_init_sn2(struct xpc_rsvd_p
 		}
 	}
 
-	/* clear xpc_vars */
-	memset(xpc_vars, 0, sizeof(struct xpc_vars_sn2));
+	/* clear xpc_vars_sn2 */
+	memset(xpc_vars_sn2, 0, sizeof(struct xpc_vars_sn2));
 
-	xpc_vars->version = XPC_V_VERSION;
-	xpc_vars->activate_IRQ_nasid = cpuid_to_nasid(0);
-	xpc_vars->activate_IRQ_phys_cpuid = cpu_physical_id(0);
-	xpc_vars->vars_part_pa = __pa(xpc_vars_part);
-	xpc_vars->amos_page_pa = ia64_tpa((u64)amos_page);
-	xpc_vars->amos_page = amos_page;	/* save for next load of XPC */
+	xpc_vars_sn2->version = XPC_V_VERSION;
+	xpc_vars_sn2->activate_IRQ_nasid = cpuid_to_nasid(0);
+	xpc_vars_sn2->activate_IRQ_phys_cpuid = cpu_physical_id(0);
+	xpc_vars_sn2->vars_part_pa = __pa(xpc_vars_part_sn2);
+	xpc_vars_sn2->amos_page_pa = ia64_tpa((u64)amos_page);
+	xpc_vars_sn2->amos_page = amos_page;	/* save for next load of XPC */
 
-	/* clear xpc_vars_part */
-	memset((u64 *)xpc_vars_part, 0, sizeof(struct xpc_vars_part_sn2) *
+	/* clear xpc_vars_part_sn2 */
+	memset((u64 *)xpc_vars_part_sn2, 0, sizeof(struct xpc_vars_part_sn2) *
 	       xp_max_npartitions);
 
 	/* initialize the activate IRQ related amo variables */
@@ -649,30 +652,30 @@ xpc_rsvd_page_init_sn2(struct xpc_rsvd_p
 static void
 xpc_increment_heartbeat_sn2(void)
 {
-	xpc_vars->heartbeat++;
+	xpc_vars_sn2->heartbeat++;
 }
 
 static void
 xpc_offline_heartbeat_sn2(void)
 {
 	xpc_increment_heartbeat_sn2();
-	xpc_vars->heartbeat_offline = 1;
+	xpc_vars_sn2->heartbeat_offline = 1;
 }
 
 static void
 xpc_online_heartbeat_sn2(void)
 {
 	xpc_increment_heartbeat_sn2();
-	xpc_vars->heartbeat_offline = 0;
+	xpc_vars_sn2->heartbeat_offline = 0;
 }
 
 static void
 xpc_heartbeat_init_sn2(void)
 {
-	DBUG_ON(xpc_vars == NULL);
+	DBUG_ON(xpc_vars_sn2 == NULL);
 
-	bitmap_zero(xpc_vars->heartbeating_to_mask, XP_MAX_NPARTITIONS_SN2);
-	xpc_heartbeating_to_mask = &xpc_vars->heartbeating_to_mask[0];
+	bitmap_zero(xpc_vars_sn2->heartbeating_to_mask, XP_MAX_NPARTITIONS_SN2);
+	xpc_heartbeating_to_mask = &xpc_vars_sn2->heartbeating_to_mask[0];
 	xpc_online_heartbeat_sn2();
 }
 
@@ -845,7 +848,8 @@ xpc_cancel_partition_deactivation_reques
 static int
 xpc_partition_deactivation_requested_sn2(short partid)
 {
-	struct amo *amo = xpc_vars->amos_page + XPC_DEACTIVATE_REQUEST_AMO_SN2;
+	struct amo *amo = xpc_vars_sn2->amos_page +
+			  XPC_DEACTIVATE_REQUEST_AMO_SN2;
 
 	/* our partition's amo variable ANDed with partid mask */
 	return (FETCHOP_LOAD_OP(TO_AMO((u64)&amo->variable), FETCHOP_LOAD) &
@@ -1033,7 +1037,7 @@ xpc_identify_activate_IRQ_sender_sn2(voi
 	int n_IRQs_detected = 0;
 	struct amo *act_amos;
 
-	act_amos = xpc_vars->amos_page + XPC_ACTIVATE_IRQ_AMOS_SN2;
+	act_amos = xpc_vars_sn2->amos_page + XPC_ACTIVATE_IRQ_AMOS_SN2;
 
 	/* scan through act amo variable looking for non-zero entries */
 	for (word = 0; word < xpc_nasid_mask_words; word++) {
@@ -1261,15 +1265,17 @@ xpc_setup_infrastructure_sn2(struct xpc_
 	 * The setting of the magic # indicates that these per partition
 	 * specific variables are ready to be used.
 	 */
-	xpc_vars_part[partid].GPs_pa = __pa(part_sn2->local_GPs);
-	xpc_vars_part[partid].openclose_args_pa =
+	xpc_vars_part_sn2[partid].GPs_pa = __pa(part_sn2->local_GPs);
+	xpc_vars_part_sn2[partid].openclose_args_pa =
 	    __pa(part->local_openclose_args);
-	xpc_vars_part[partid].chctl_amo_pa = __pa(part_sn2->local_chctl_amo_va);
+	xpc_vars_part_sn2[partid].chctl_amo_pa =
+	    __pa(part_sn2->local_chctl_amo_va);
 	cpuid = raw_smp_processor_id();	/* any CPU in this partition will do */
-	xpc_vars_part[partid].notify_IRQ_nasid = cpuid_to_nasid(cpuid);
-	xpc_vars_part[partid].notify_IRQ_phys_cpuid = cpu_physical_id(cpuid);
-	xpc_vars_part[partid].nchannels = part->nchannels;
-	xpc_vars_part[partid].magic = XPC_VP_MAGIC1;
+	xpc_vars_part_sn2[partid].notify_IRQ_nasid = cpuid_to_nasid(cpuid);
+	xpc_vars_part_sn2[partid].notify_IRQ_phys_cpuid =
+	    cpu_physical_id(cpuid);
+	xpc_vars_part_sn2[partid].nchannels = part->nchannels;
+	xpc_vars_part_sn2[partid].magic = XPC_VP_MAGIC1;
 
 	return xpSuccess;
 
@@ -1316,7 +1322,7 @@ xpc_teardown_infrastructure_sn2(struct x
 	DBUG_ON(part->setup_state != XPC_P_SETUP);
 	part->setup_state = XPC_P_WTEARDOWN;
 
-	xpc_vars_part[partid].magic = 0;
+	xpc_vars_part_sn2[partid].magic = 0;
 
 	free_irq(SGI_XPC_NOTIFY, (void *)(u64)partid);
 
@@ -1432,7 +1438,7 @@ xpc_pull_remote_vars_part_sn2(struct xpc
 		return xpRetry;
 	}
 
-	if (xpc_vars_part[partid].magic == XPC_VP_MAGIC1) {
+	if (xpc_vars_part_sn2[partid].magic == XPC_VP_MAGIC1) {
 
 		/* validate the variables */
 
@@ -1462,7 +1468,7 @@ xpc_pull_remote_vars_part_sn2(struct xpc
 
 		/* let the other side know that we've pulled their variables */
 
-		xpc_vars_part[partid].magic = XPC_VP_MAGIC2;
+		xpc_vars_part_sn2[partid].magic = XPC_VP_MAGIC2;
 	}
 
 	if (pulled_entry->magic == XPC_VP_MAGIC1)
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

