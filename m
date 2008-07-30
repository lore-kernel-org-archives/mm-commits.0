From: akpm@linux-foundation.org
Subject: - sgi-xp-use-standard-bitops-macros-and-functions.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:17:00 -0700
Message-ID: <200807301917.m6UJH0OS011172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979AbYG3TRt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:17:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-xp: use standard bitops macros and functions
has been removed from the -mm tree.  Its filename was
     sgi-xp-use-standard-bitops-macros-and-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp: use standard bitops macros and functions
From: Dean Nelson <dcn@sgi.com>

Change sgi-xp to use the standard bitops macros and functions instead of
trying to invent its own mechanism.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xp.h            |    3 -
 drivers/misc/sgi-xp/xpc.h           |   43 +++++----------
 drivers/misc/sgi-xp/xpc_partition.c |   43 +++++++--------
 drivers/misc/sgi-xp/xpc_sn2.c       |   73 +++++++++++++-------------
 4 files changed, 76 insertions(+), 86 deletions(-)

diff -puN drivers/misc/sgi-xp/xp.h~sgi-xp-use-standard-bitops-macros-and-functions drivers/misc/sgi-xp/xp.h
--- a/drivers/misc/sgi-xp/xp.h~sgi-xp-use-standard-bitops-macros-and-functions
+++ a/drivers/misc/sgi-xp/xp.h
@@ -21,9 +21,6 @@
 #include <asm/sn/arch.h>
 #endif
 
-/* ??? Add this #define to some linux header file some day? */
-#define BYTES_PER_WORD	sizeof(void *)
-
 #ifdef USE_DBUG_ON
 #define DBUG_ON(condition)	BUG_ON(condition)
 #else
diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xp-use-standard-bitops-macros-and-functions drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xp-use-standard-bitops-macros-and-functions
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -35,23 +35,7 @@
 #define XPC_VERSION_MAJOR(_v)		((_v) >> 4)
 #define XPC_VERSION_MINOR(_v)		((_v) & 0xf)
 
-/*
- * The next macros define word or bit representations for given
- * C-brick nasid in either the SAL provided bit array representing
- * nasids in the partition/machine or the array of amo structures used
- * for inter-partition initiation communications.
- *
- * For SN2 machines, C-Bricks are alway even numbered NASIDs.  As
- * such, some space will be saved by insisting that nasid information
- * passed from SAL always be packed for C-Bricks and the
- * cross-partition interrupts use the same packing scheme.
- */
-#define XPC_NASID_W_INDEX(_n)	(((_n) / 64) / 2)
-#define XPC_NASID_B_INDEX(_n)	(((_n) / 2) & (64 - 1))
-#define XPC_NASID_IN_ARRAY(_n, _p) ((_p)[XPC_NASID_W_INDEX(_n)] & \
-				    (1UL << XPC_NASID_B_INDEX(_n)))
-#define XPC_NASID_FROM_W_B(_w, _b) (((_w) * 64 + (_b)) * 2)
-
+/* define frequency of the heartbeat and frequency how often it's checked */
 #define XPC_HB_DEFAULT_INTERVAL		5	/* incr HB every x secs */
 #define XPC_HB_CHECK_DEFAULT_INTERVAL	20	/* check HB every x secs */
 
@@ -86,11 +70,13 @@
  *     the actual nasids in the entire machine (mach_nasids). We're only
  *     interested in the even numbered nasids (which contain the processors
  *     and/or memory), so we only need half as many bits to represent the
- *     nasids. The part_nasids mask is located starting at the first cacheline
- *     following the reserved page header. The mach_nasids mask follows right
- *     after the part_nasids mask. The size in bytes of each mask is reflected
- *     by the reserved page header field 'SAL_nasids_size'. (Local partition's
- *     mask pointers are xpc_part_nasids and xpc_mach_nasids.)
+ *     nasids. When mapping nasid to bit in a mask (or bit to nasid) be sure
+ *     to either divide or multiply by 2. The part_nasids mask is located
+ *     starting at the first cacheline following the reserved page header. The
+ *     mach_nasids mask follows right after the part_nasids mask. The size in
+ *     bytes of each mask is reflected by the reserved page header field
+ *     'SAL_nasids_size'. (Local partition's mask pointers are xpc_part_nasids
+ *     and xpc_mach_nasids.)
  *
  *   vars	(ia64-sn2 only)
  *   vars part	(ia64-sn2 only)
@@ -194,10 +180,11 @@ struct xpc_vars_part_sn2 {
 #define XPC_RP_VARS_SIZE	L1_CACHE_ALIGN(sizeof(struct xpc_vars_sn2))
 
 #define XPC_RP_PART_NASIDS(_rp) ((u64 *)((u8 *)(_rp) + XPC_RP_HEADER_SIZE))
-#define XPC_RP_MACH_NASIDS(_rp) (XPC_RP_PART_NASIDS(_rp) + xpc_nasid_mask_words)
+#define XPC_RP_MACH_NASIDS(_rp) (XPC_RP_PART_NASIDS(_rp) + \
+				 xpc_nasid_mask_nlongs)
 #define XPC_RP_VARS(_rp)	((struct xpc_vars_sn2 *) \
 				 (XPC_RP_MACH_NASIDS(_rp) + \
-				  xpc_nasid_mask_words))
+				  xpc_nasid_mask_nlongs))
 
 /*
  * Functions registered by add_timer() or called by kernel_thread() only
@@ -695,9 +682,9 @@ extern void xpc_exit_uv(void);
 
 /* found in xpc_partition.c */
 extern int xpc_exiting;
-extern int xpc_nasid_mask_words;
+extern int xpc_nasid_mask_nlongs;
 extern struct xpc_rsvd_page *xpc_rsvd_page;
-extern u64 *xpc_mach_nasids;
+extern unsigned long *xpc_mach_nasids;
 extern struct xpc_partition *xpc_partitions;
 extern void *xpc_kmalloc_cacheline_aligned(size_t, gfp_t, void **);
 extern struct xpc_rsvd_page *xpc_setup_rsvd_page(void);
@@ -706,8 +693,8 @@ extern int xpc_partition_disengaged(stru
 extern enum xp_retval xpc_mark_partition_active(struct xpc_partition *);
 extern void xpc_mark_partition_inactive(struct xpc_partition *);
 extern void xpc_discovery(void);
-extern enum xp_retval xpc_get_remote_rp(int, u64 *, struct xpc_rsvd_page *,
-					u64 *);
+extern enum xp_retval xpc_get_remote_rp(int, unsigned long *,
+					struct xpc_rsvd_page *, u64 *);
 extern void xpc_deactivate_partition(const int, struct xpc_partition *,
 				     enum xp_retval);
 extern enum xp_retval xpc_initiate_partid_to_nasids(short, void *);
diff -puN drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-use-standard-bitops-macros-and-functions drivers/misc/sgi-xp/xpc_partition.c
--- a/drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-use-standard-bitops-macros-and-functions
+++ a/drivers/misc/sgi-xp/xpc_partition.c
@@ -31,11 +31,11 @@ int xpc_exiting;
 
 /* this partition's reserved page pointers */
 struct xpc_rsvd_page *xpc_rsvd_page;
-static u64 *xpc_part_nasids;
-u64 *xpc_mach_nasids;
+static unsigned long *xpc_part_nasids;
+unsigned long *xpc_mach_nasids;
 
-static int xpc_sizeof_nasid_mask;	/* actual size in bytes of nasid mask */
-int xpc_nasid_mask_words;	/* actual size in words of nasid mask */
+static int xpc_nasid_mask_nbytes;	/* #of bytes in nasid mask */
+int xpc_nasid_mask_nlongs;	/* #of longs in nasid mask */
 
 struct xpc_partition *xpc_partitions;
 
@@ -167,9 +167,9 @@ xpc_setup_rsvd_page(void)
 		/* SAL_version 1 didn't set the nasids_size field */
 		rp->SAL_nasids_size = 128;
 	}
-	xpc_sizeof_nasid_mask = rp->SAL_nasids_size;
-	xpc_nasid_mask_words = DIV_ROUND_UP(xpc_sizeof_nasid_mask,
-					    BYTES_PER_WORD);
+	xpc_nasid_mask_nbytes = rp->SAL_nasids_size;
+	xpc_nasid_mask_nlongs = BITS_TO_LONGS(rp->SAL_nasids_size *
+					      BITS_PER_BYTE);
 
 	/* setup the pointers to the various items in the reserved page */
 	xpc_part_nasids = XPC_RP_PART_NASIDS(rp);
@@ -199,10 +199,10 @@ xpc_setup_rsvd_page(void)
  * part_nasids mask.
  */
 enum xp_retval
-xpc_get_remote_rp(int nasid, u64 *discovered_nasids,
+xpc_get_remote_rp(int nasid, unsigned long *discovered_nasids,
 		  struct xpc_rsvd_page *remote_rp, u64 *remote_rp_pa)
 {
-	int i;
+	int l;
 	enum xp_retval ret;
 
 	/* get the reserved page's physical address */
@@ -213,15 +213,16 @@ xpc_get_remote_rp(int nasid, u64 *discov
 
 	/* pull over the reserved page header and part_nasids mask */
 	ret = xp_remote_memcpy(remote_rp, (void *)*remote_rp_pa,
-			       XPC_RP_HEADER_SIZE + xpc_sizeof_nasid_mask);
+			       XPC_RP_HEADER_SIZE + xpc_nasid_mask_nbytes);
 	if (ret != xpSuccess)
 		return ret;
 
 	if (discovered_nasids != NULL) {
-		u64 *remote_part_nasids = XPC_RP_PART_NASIDS(remote_rp);
+		unsigned long *remote_part_nasids =
+		    XPC_RP_PART_NASIDS(remote_rp);
 
-		for (i = 0; i < xpc_nasid_mask_words; i++)
-			discovered_nasids[i] |= remote_part_nasids[i];
+		for (l = 0; l < xpc_nasid_mask_nlongs; l++)
+			discovered_nasids[l] |= remote_part_nasids[l];
 	}
 
 	/* see if the reserved page has been set up by XPC */
@@ -401,16 +402,16 @@ xpc_discovery(void)
 	int max_regions;
 	int nasid;
 	struct xpc_rsvd_page *rp;
-	u64 *discovered_nasids;
+	unsigned long *discovered_nasids;
 	enum xp_retval ret;
 
 	remote_rp = xpc_kmalloc_cacheline_aligned(XPC_RP_HEADER_SIZE +
-						  xpc_sizeof_nasid_mask,
+						  xpc_nasid_mask_nbytes,
 						  GFP_KERNEL, &remote_rp_base);
 	if (remote_rp == NULL)
 		return;
 
-	discovered_nasids = kzalloc(sizeof(u64) * xpc_nasid_mask_words,
+	discovered_nasids = kzalloc(sizeof(long) * xpc_nasid_mask_nlongs,
 				    GFP_KERNEL);
 	if (discovered_nasids == NULL) {
 		kfree(remote_rp_base);
@@ -453,21 +454,21 @@ xpc_discovery(void)
 
 			dev_dbg(xpc_part, "checking nasid %d\n", nasid);
 
-			if (XPC_NASID_IN_ARRAY(nasid, xpc_part_nasids)) {
+			if (test_bit(nasid / 2, xpc_part_nasids)) {
 				dev_dbg(xpc_part, "PROM indicates Nasid %d is "
 					"part of the local partition; skipping "
 					"region\n", nasid);
 				break;
 			}
 
-			if (!(XPC_NASID_IN_ARRAY(nasid, xpc_mach_nasids))) {
+			if (!(test_bit(nasid / 2, xpc_mach_nasids))) {
 				dev_dbg(xpc_part, "PROM indicates Nasid %d was "
 					"not on Numa-Link network at reset\n",
 					nasid);
 				continue;
 			}
 
-			if (XPC_NASID_IN_ARRAY(nasid, discovered_nasids)) {
+			if (test_bit(nasid / 2, discovered_nasids)) {
 				dev_dbg(xpc_part, "Nasid %d is part of a "
 					"partition which was previously "
 					"discovered\n", nasid);
@@ -512,10 +513,10 @@ xpc_initiate_partid_to_nasids(short part
 	if (part->remote_rp_pa == 0)
 		return xpPartitionDown;
 
-	memset(nasid_mask, 0, xpc_sizeof_nasid_mask);
+	memset(nasid_mask, 0, xpc_nasid_mask_nbytes);
 
 	part_nasid_pa = (u64)XPC_RP_PART_NASIDS(part->remote_rp_pa);
 
 	return xp_remote_memcpy(nasid_mask, (void *)part_nasid_pa,
-				xpc_sizeof_nasid_mask);
+				xpc_nasid_mask_nbytes);
 }
diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-use-standard-bitops-macros-and-functions drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-use-standard-bitops-macros-and-functions
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -210,28 +210,26 @@ static void
 xpc_send_activate_IRQ_sn2(u64 amos_page_pa, int from_nasid, int to_nasid,
 			  int to_phys_cpuid)
 {
-	int w_index = XPC_NASID_W_INDEX(from_nasid);
-	int b_index = XPC_NASID_B_INDEX(from_nasid);
 	struct amo *amos = (struct amo *)__va(amos_page_pa +
 					      (XPC_ACTIVATE_IRQ_AMOS_SN2 *
 					      sizeof(struct amo)));
 
-	(void)xpc_send_IRQ_sn2(&amos[w_index], (1UL << b_index), to_nasid,
+	(void)xpc_send_IRQ_sn2(&amos[BIT_WORD(from_nasid / 2)],
+			       BIT_MASK(from_nasid / 2), to_nasid,
 			       to_phys_cpuid, SGI_XPC_ACTIVATE);
 }
 
 static void
 xpc_send_local_activate_IRQ_sn2(int from_nasid)
 {
-	int w_index = XPC_NASID_W_INDEX(from_nasid);
-	int b_index = XPC_NASID_B_INDEX(from_nasid);
 	struct amo *amos = (struct amo *)__va(xpc_vars_sn2->amos_page_pa +
 					      (XPC_ACTIVATE_IRQ_AMOS_SN2 *
 					      sizeof(struct amo)));
 
 	/* fake the sending and receipt of an activate IRQ from remote nasid */
-	FETCHOP_STORE_OP(TO_AMO((u64)&amos[w_index].variable), FETCHOP_OR,
-			 (1UL << b_index));
+	FETCHOP_STORE_OP(TO_AMO((u64)&amos[BIT_WORD(from_nasid / 2)].variable),
+			 FETCHOP_OR, BIT_MASK(from_nasid / 2));
+
 	atomic_inc(&xpc_activate_IRQ_rcvd);
 	wake_up_interruptible(&xpc_activate_IRQ_wq);
 }
@@ -439,7 +437,8 @@ xpc_indicate_partition_engaged_sn2(struc
 
 	/* set bit corresponding to our partid in remote partition's amo */
 	FETCHOP_STORE_OP(TO_AMO((u64)&amo->variable), FETCHOP_OR,
-			 (1UL << sn_partition_id));
+			 BIT(sn_partition_id));
+
 	/*
 	 * We must always use the nofault function regardless of whether we
 	 * are on a Shub 1.1 system or a Shub 1.2 slice 0xc processor. If we
@@ -466,7 +465,8 @@ xpc_indicate_partition_disengaged_sn2(st
 
 	/* clear bit corresponding to our partid in remote partition's amo */
 	FETCHOP_STORE_OP(TO_AMO((u64)&amo->variable), FETCHOP_AND,
-			 ~(1UL << sn_partition_id));
+			 ~BIT(sn_partition_id));
+
 	/*
 	 * We must always use the nofault function regardless of whether we
 	 * are on a Shub 1.1 system or a Shub 1.2 slice 0xc processor. If we
@@ -497,7 +497,7 @@ xpc_partition_engaged_sn2(short partid)
 
 	/* our partition's amo variable ANDed with partid mask */
 	return (FETCHOP_LOAD_OP(TO_AMO((u64)&amo->variable), FETCHOP_LOAD) &
-		(1UL << partid)) != 0;
+		BIT(partid)) != 0;
 }
 
 static int
@@ -518,7 +518,7 @@ xpc_assume_partition_disengaged_sn2(shor
 
 	/* clear bit(s) based on partid mask in our partition's amo */
 	FETCHOP_STORE_OP(TO_AMO((u64)&amo->variable), FETCHOP_AND,
-			 ~(1UL << partid));
+			 ~BIT(partid));
 }
 
 /* original protection values for each node */
@@ -639,7 +639,7 @@ xpc_rsvd_page_init_sn2(struct xpc_rsvd_p
 	       xp_max_npartitions);
 
 	/* initialize the activate IRQ related amo variables */
-	for (i = 0; i < xpc_nasid_mask_words; i++)
+	for (i = 0; i < xpc_nasid_mask_nlongs; i++)
 		(void)xpc_init_IRQ_amo_sn2(XPC_ACTIVATE_IRQ_AMOS_SN2 + i);
 
 	/* initialize the engaged remote partitions related amo variables */
@@ -796,7 +796,8 @@ xpc_request_partition_deactivation_sn2(s
 
 	/* set bit corresponding to our partid in remote partition's amo */
 	FETCHOP_STORE_OP(TO_AMO((u64)&amo->variable), FETCHOP_OR,
-			 (1UL << sn_partition_id));
+			 BIT(sn_partition_id));
+
 	/*
 	 * We must always use the nofault function regardless of whether we
 	 * are on a Shub 1.1 system or a Shub 1.2 slice 0xc processor. If we
@@ -831,7 +832,8 @@ xpc_cancel_partition_deactivation_reques
 
 	/* clear bit corresponding to our partid in remote partition's amo */
 	FETCHOP_STORE_OP(TO_AMO((u64)&amo->variable), FETCHOP_AND,
-			 ~(1UL << sn_partition_id));
+			 ~BIT(sn_partition_id));
+
 	/*
 	 * We must always use the nofault function regardless of whether we
 	 * are on a Shub 1.1 system or a Shub 1.2 slice 0xc processor. If we
@@ -853,7 +855,7 @@ xpc_partition_deactivation_requested_sn2
 
 	/* our partition's amo variable ANDed with partid mask */
 	return (FETCHOP_LOAD_OP(TO_AMO((u64)&amo->variable), FETCHOP_LOAD) &
-		(1UL << partid)) != 0;
+		BIT(partid)) != 0;
 }
 
 /*
@@ -1031,28 +1033,31 @@ xpc_identify_activate_IRQ_req_sn2(int na
 int
 xpc_identify_activate_IRQ_sender_sn2(void)
 {
-	int word, bit;
-	u64 nasid_mask;
+	int l;
+	int b;
+	unsigned long nasid_mask_long;
 	u64 nasid;		/* remote nasid */
 	int n_IRQs_detected = 0;
 	struct amo *act_amos;
 
 	act_amos = xpc_vars_sn2->amos_page + XPC_ACTIVATE_IRQ_AMOS_SN2;
 
-	/* scan through act amo variable looking for non-zero entries */
-	for (word = 0; word < xpc_nasid_mask_words; word++) {
+	/* scan through activate amo variables looking for non-zero entries */
+	for (l = 0; l < xpc_nasid_mask_nlongs; l++) {
 
 		if (xpc_exiting)
 			break;
 
-		nasid_mask = xpc_receive_IRQ_amo_sn2(&act_amos[word]);
-		if (nasid_mask == 0) {
-			/* no IRQs from nasids in this variable */
+		nasid_mask_long = xpc_receive_IRQ_amo_sn2(&act_amos[l]);
+
+		b = find_first_bit(&nasid_mask_long, BITS_PER_LONG);
+		if (b >= BITS_PER_LONG) {
+			/* no IRQs from nasids in this amo variable */
 			continue;
 		}
 
-		dev_dbg(xpc_part, "amo[%d] gave back 0x%lx\n", word,
-			nasid_mask);
+		dev_dbg(xpc_part, "amo[%d] gave back 0x%lx\n", l,
+			nasid_mask_long);
 
 		/*
 		 * If this nasid has been added to the machine since
@@ -1060,19 +1065,19 @@ xpc_identify_activate_IRQ_sender_sn2(voi
 		 * remote nasid in our reserved pages machine mask.
 		 * This is used in the event of module reload.
 		 */
-		xpc_mach_nasids[word] |= nasid_mask;
+		xpc_mach_nasids[l] |= nasid_mask_long;
 
 		/* locate the nasid(s) which sent interrupts */
 
-		for (bit = 0; bit < (8 * sizeof(u64)); bit++) {
-			if (nasid_mask & (1UL << bit)) {
-				n_IRQs_detected++;
-				nasid = XPC_NASID_FROM_W_B(word, bit);
-				dev_dbg(xpc_part, "interrupt from nasid %ld\n",
-					nasid);
-				xpc_identify_activate_IRQ_req_sn2(nasid);
-			}
-		}
+		do {
+			n_IRQs_detected++;
+			nasid = (l * BITS_PER_LONG + b) * 2;
+			dev_dbg(xpc_part, "interrupt from nasid %ld\n", nasid);
+			xpc_identify_activate_IRQ_req_sn2(nasid);
+
+			b = find_next_bit(&nasid_mask_long, BITS_PER_LONG,
+					  b + 1);
+		} while (b < BITS_PER_LONG);
 	}
 	return n_IRQs_detected;
 }
_

Patches currently in -mm which might be from dcn@sgi.com are

origin.patch

