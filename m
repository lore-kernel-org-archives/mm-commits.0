From: akpm@linux-foundation.org
Subject: + sgi-xp-add-jiffies-to-reserved-pages-timestamp-name.patch added to -mm tree
Date: Tue, 10 Jun 2008 14:03:07 -0700
Message-ID: <200806102103.m5AL37oQ029217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758662AbYFJVDK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jun 2008 17:03:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dcn@sgi.com


The patch titled
     sgi-xp: add 'jiffies' to reserved page's timestamp name
has been added to the -mm tree.  Its filename is
     sgi-xp-add-jiffies-to-reserved-pages-timestamp-name.patch

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
Subject: sgi-xp: add 'jiffies' to reserved page's timestamp name
From: Dean Nelson <dcn@sgi.com>

Rename XPC's reserved page's timestamp member to reflect the units of time
involved.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc.h           |    6 +++---
 drivers/misc/sgi-xp/xpc_main.c      |    8 ++++----
 drivers/misc/sgi-xp/xpc_partition.c |   14 +++++++-------
 drivers/misc/sgi-xp/xpc_sn2.c       |   26 ++++++++++++++------------
 4 files changed, 28 insertions(+), 26 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xp-add-jiffies-to-reserved-pages-timestamp-name drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xp-add-jiffies-to-reserved-pages-timestamp-name
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -87,7 +87,7 @@
  *     which are partition specific (vars part). These are setup by XPC.
  *     (Local partition's vars pointers are xpc_vars and xpc_vars_part.)
  *
- * Note: Until 'stamp' is set non-zero, the partition XPC code has not been
+ * Note: Until 'ts_jiffies' is set non-zero, the partition XPC code has not been
  *       initialized.
  */
 struct xpc_rsvd_page {
@@ -101,7 +101,7 @@ struct xpc_rsvd_page {
 		u64 vars_pa;	/* physical address of struct xpc_vars */
 		u64 activate_mq_gpa;	/* global phys address of activate_mq */
 	} sn;
-	unsigned long stamp;	/* time when reserved page was setup by XPC */
+	unsigned long ts_jiffies; /* timestamp when rsvd pg was setup by XPC */
 	u64 pad2[10];		/* align to last u64 in 2nd 64-byte cacheline */
 	u64 SAL_nasids_size;	/* SAL: size of each nasid mask in bytes */
 };
@@ -534,7 +534,7 @@ struct xpc_partition {
 	/* XPC HB infrastructure */
 
 	u8 remote_rp_version;	/* version# of partition's rsvd pg */
-	unsigned long remote_rp_stamp; /* time when rsvd pg was initialized */
+	unsigned long remote_rp_ts_jiffies; /* timestamp when rsvd pg setup */
 	u64 remote_rp_pa;	/* phys addr of partition's rsvd pg */
 	u64 last_heartbeat;	/* HB at last read */
 	u32 activate_IRQ_rcvd;	/* IRQs since activation */
diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-xp-add-jiffies-to-reserved-pages-timestamp-name drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xp-add-jiffies-to-reserved-pages-timestamp-name
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -862,8 +862,8 @@ xpc_do_exit(enum xp_retval reason)
 	DBUG_ON(xpc_any_partition_engaged());
 	DBUG_ON(xpc_any_hbs_allowed() != 0);
 
-	/* indicate to others that our reserved page is uninitialized */
-	xpc_rsvd_page->stamp = 0;
+	/* a zero timestamp indicates our rsvd page is not initialized */
+	xpc_rsvd_page->ts_jiffies = 0;
 
 	if (reason == xpUnloading) {
 		(void)unregister_die_notifier(&xpc_die_notifier);
@@ -1152,8 +1152,8 @@ xpc_init(void)
 
 	/* initialization was not successful */
 out_3:
-	/* indicate to others that our reserved page is uninitialized */
-	xpc_rsvd_page->stamp = 0;
+	/* a zero timestamp indicates our rsvd page is not initialized */
+	xpc_rsvd_page->ts_jiffies = 0;
 
 	(void)unregister_die_notifier(&xpc_die_notifier);
 	(void)unregister_reboot_notifier(&xpc_reboot_notifier);
diff -puN drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-add-jiffies-to-reserved-pages-timestamp-name drivers/misc/sgi-xp/xpc_partition.c
--- a/drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-add-jiffies-to-reserved-pages-timestamp-name
+++ a/drivers/misc/sgi-xp/xpc_partition.c
@@ -133,7 +133,7 @@ xpc_setup_rsvd_page(void)
 {
 	struct xpc_rsvd_page *rp;
 	u64 rp_pa;
-	unsigned long new_stamp;
+	unsigned long new_ts_jiffies;
 
 	/* get the local reserved page's address */
 
@@ -183,10 +183,10 @@ xpc_setup_rsvd_page(void)
 	 * This signifies to the remote partition that our reserved
 	 * page is initialized.
 	 */
-	new_stamp = jiffies;
-	if (new_stamp == 0 || new_stamp == rp->stamp)
-		new_stamp++;
-	rp->stamp = new_stamp;
+	new_ts_jiffies = jiffies;
+	if (new_ts_jiffies == 0 || new_ts_jiffies == rp->ts_jiffies)
+		new_ts_jiffies++;
+	rp->ts_jiffies = new_ts_jiffies;
 
 	return rp;
 }
@@ -225,8 +225,8 @@ xpc_get_remote_rp(int nasid, unsigned lo
 			discovered_nasids[l] |= remote_part_nasids[l];
 	}
 
-	/* see if the reserved page has been set up by XPC */
-	if (remote_rp->stamp == 0)
+	/* zero timestamp indicates the reserved page has not been setup */
+	if (remote_rp->ts_jiffies == 0)
 		return xpRsvdPageNotSet;
 
 	if (XPC_VERSION_MAJOR(remote_rp->version) !=
diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-add-jiffies-to-reserved-pages-timestamp-name drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-add-jiffies-to-reserved-pages-timestamp-name
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -863,8 +863,8 @@ xpc_partition_deactivation_requested_sn2
  */
 static void
 xpc_update_partition_info_sn2(struct xpc_partition *part, u8 remote_rp_version,
-			      unsigned long *remote_rp_stamp, u64 remote_rp_pa,
-			      u64 remote_vars_pa,
+			      unsigned long *remote_rp_ts_jiffies,
+			      u64 remote_rp_pa, u64 remote_vars_pa,
 			      struct xpc_vars_sn2 *remote_vars)
 {
 	struct xpc_partition_sn2 *part_sn2 = &part->sn.sn2;
@@ -873,9 +873,9 @@ xpc_update_partition_info_sn2(struct xpc
 	dev_dbg(xpc_part, "  remote_rp_version = 0x%016x\n",
 		part->remote_rp_version);
 
-	part->remote_rp_stamp = *remote_rp_stamp;
-	dev_dbg(xpc_part, "  remote_rp_stamp = 0x%016lx\n",
-		part->remote_rp_stamp);
+	part->remote_rp_ts_jiffies = *remote_rp_ts_jiffies;
+	dev_dbg(xpc_part, "  remote_rp_ts_jiffies = 0x%016lx\n",
+		part->remote_rp_ts_jiffies);
 
 	part->remote_rp_pa = remote_rp_pa;
 	dev_dbg(xpc_part, "  remote_rp_pa = 0x%016lx\n", part->remote_rp_pa);
@@ -933,7 +933,7 @@ xpc_identify_activate_IRQ_req_sn2(int na
 	u64 remote_vars_pa;
 	int remote_rp_version;
 	int reactivate = 0;
-	unsigned long remote_rp_stamp = 0;
+	unsigned long remote_rp_ts_jiffies = 0;
 	short partid;
 	struct xpc_partition *part;
 	struct xpc_partition_sn2 *part_sn2;
@@ -952,7 +952,7 @@ xpc_identify_activate_IRQ_req_sn2(int na
 
 	remote_vars_pa = remote_rp->sn.vars_pa;
 	remote_rp_version = remote_rp->version;
-	remote_rp_stamp = remote_rp->stamp;
+	remote_rp_ts_jiffies = remote_rp->ts_jiffies;
 
 	partid = remote_rp->SAL_partid;
 	part = &xpc_partitions[partid];
@@ -981,8 +981,9 @@ xpc_identify_activate_IRQ_req_sn2(int na
 	    part->act_state == XPC_P_INACTIVE) {
 
 		xpc_update_partition_info_sn2(part, remote_rp_version,
-					      &remote_rp_stamp, remote_rp_pa,
-					      remote_vars_pa, remote_vars);
+					      &remote_rp_ts_jiffies,
+					      remote_rp_pa, remote_vars_pa,
+					      remote_vars);
 
 		if (xpc_partition_deactivation_requested_sn2(partid)) {
 			/*
@@ -999,7 +1000,7 @@ xpc_identify_activate_IRQ_req_sn2(int na
 	DBUG_ON(part->remote_rp_version == 0);
 	DBUG_ON(part_sn2->remote_vars_version == 0);
 
-	if (remote_rp_stamp != part->remote_rp_stamp) {
+	if (remote_rp_ts_jiffies != part->remote_rp_ts_jiffies) {
 
 		/* the other side rebooted */
 
@@ -1007,8 +1008,9 @@ xpc_identify_activate_IRQ_req_sn2(int na
 		DBUG_ON(xpc_partition_deactivation_requested_sn2(partid));
 
 		xpc_update_partition_info_sn2(part, remote_rp_version,
-					      &remote_rp_stamp, remote_rp_pa,
-					      remote_vars_pa, remote_vars);
+					      &remote_rp_ts_jiffies,
+					      remote_rp_pa, remote_vars_pa,
+					      remote_vars);
 		reactivate = 1;
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

