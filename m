From: akpm@linux-foundation.org
Subject: - sgi-xp-prepare-xpc_rsvd_page-to-work-on-either-sn2-or-uv-hardware.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:16:27 -0700
Message-ID: <200807301916.m6UJGRVf011127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753487AbYG3TYP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:24:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-xp: prepare xpc_rsvd_page to work on either sn2 or uv hardware
has been removed from the -mm tree.  Its filename was
     sgi-xp-prepare-xpc_rsvd_page-to-work-on-either-sn2-or-uv-hardware.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp: prepare xpc_rsvd_page to work on either sn2 or uv hardware
From: Dean Nelson <dcn@sgi.com>

Prepare XPC's reserved page header to work for either sn2 or uv.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/Makefile        |    3 
 drivers/misc/sgi-xp/xp.h            |    5 
 drivers/misc/sgi-xp/xpc.h           |   57 ++++++---
 drivers/misc/sgi-xp/xpc_main.c      |   27 ++++
 drivers/misc/sgi-xp/xpc_partition.c |  149 +++++++-------------------
 drivers/misc/sgi-xp/xpc_sn2.c       |  111 +++++++++++++++++++
 drivers/misc/sgi-xp/xpc_uv.c        |   48 ++++++++
 7 files changed, 267 insertions(+), 133 deletions(-)

diff -puN drivers/misc/sgi-xp/Makefile~sgi-xp-prepare-xpc_rsvd_page-to-work-on-either-sn2-or-uv-hardware drivers/misc/sgi-xp/Makefile
--- a/drivers/misc/sgi-xp/Makefile~sgi-xp-prepare-xpc_rsvd_page-to-work-on-either-sn2-or-uv-hardware
+++ a/drivers/misc/sgi-xp/Makefile
@@ -7,6 +7,7 @@ xp-y				:= xp_main.o xp_uv.o
 xp-$(CONFIG_IA64)		+= xp_sn2.o xp_nofault.o
 
 obj-$(CONFIG_SGI_XP)		+= xpc.o
-xpc-y				:= xpc_main.o xpc_channel.o xpc_partition.o
+xpc-y				:= xpc_main.o xpc_uv.o xpc_channel.o xpc_partition.o
+xpc-$(CONFIG_IA64)		+= xpc_sn2.o
 
 obj-$(CONFIG_SGI_XP)		+= xpnet.o
diff -puN drivers/misc/sgi-xp/xp.h~sgi-xp-prepare-xpc_rsvd_page-to-work-on-either-sn2-or-uv-hardware drivers/misc/sgi-xp/xp.h
--- a/drivers/misc/sgi-xp/xp.h~sgi-xp-prepare-xpc_rsvd_page-to-work-on-either-sn2-or-uv-hardware
+++ a/drivers/misc/sgi-xp/xp.h
@@ -220,9 +220,10 @@ enum xp_retval {
 
 	xpBteCopyError,		/* 52: bte_copy() returned error */
 	xpSalError,		/* 53: sn SAL error */
+	xpRsvdPageNotSet,	/* 54: the reserved page is not set up */
 
-	xpUnsupported,		/* 54: unsupported functionality or resource */
-	xpUnknownReason		/* 55: unknown reason - must be last in enum */
+	xpUnsupported,		/* 55: unsupported functionality or resource */
+	xpUnknownReason		/* 56: unknown reason - must be last in enum */
 };
 
 /*
diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xp-prepare-xpc_rsvd_page-to-work-on-either-sn2-or-uv-hardware drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xp-prepare-xpc_rsvd_page-to-work-on-either-sn2-or-uv-hardware
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -71,11 +71,11 @@
  *
  *   reserved page header
  *
- *     The first cacheline of the reserved page contains the header
- *     (struct xpc_rsvd_page). Before SAL initialization has completed,
+ *     The first two 64-byte cachelines of the reserved page contain the
+ *     header (struct xpc_rsvd_page). Before SAL initialization has completed,
  *     SAL has set up the following fields of the reserved page header:
- *     SAL_signature, SAL_version, partid, and nasids_size. The other
- *     fields are set up by XPC. (xpc_rsvd_page points to the local
+ *     SAL_signature, SAL_version, SAL_partid, and SAL_nasids_size. The
+ *     other fields are set up by XPC. (xpc_rsvd_page points to the local
  *     partition's reserved page.)
  *
  *   part_nasids mask
@@ -89,11 +89,11 @@
  *     nasids. The part_nasids mask is located starting at the first cacheline
  *     following the reserved page header. The mach_nasids mask follows right
  *     after the part_nasids mask. The size in bytes of each mask is reflected
- *     by the reserved page header field 'nasids_size'. (Local partition's
+ *     by the reserved page header field 'SAL_nasids_size'. (Local partition's
  *     mask pointers are xpc_part_nasids and xpc_mach_nasids.)
  *
- *   vars
- *   vars part
+ *   vars	(ia64-sn2 only)
+ *   vars part	(ia64-sn2 only)
  *
  *     Immediately following the mach_nasids mask are the XPC variables
  *     required by other partitions. First are those that are generic to all
@@ -101,25 +101,31 @@
  *     which are partition specific (vars part). These are setup by XPC.
  *     (Local partition's vars pointers are xpc_vars and xpc_vars_part.)
  *
- * Note: Until vars_pa is set, the partition XPC code has not been initialized.
+ * Note: Until 'stamp' is set non-zero, the partition XPC code has not been
+ *       initialized.
  */
 struct xpc_rsvd_page {
 	u64 SAL_signature;	/* SAL: unique signature */
 	u64 SAL_version;	/* SAL: version */
-	u8 partid;		/* SAL: partition ID */
+	short SAL_partid;	/* SAL: partition ID */
+	short max_npartitions;	/* value of XPC_MAX_PARTITIONS */
 	u8 version;
-	u8 pad1[6];		/* align to next u64 in cacheline */
-	u64 vars_pa;		/* physical address of struct xpc_vars */
+	u8 pad1[3];		/* align to next u64 in 1st 64-byte cacheline */
+	union {
+		u64 vars_pa;	/* physical address of struct xpc_vars */
+		u64 activate_mq_gpa;	/* global phys address of activate_mq */
+	} sn;
 	struct timespec stamp;	/* time when reserved page was setup by XPC */
-	u64 pad2[9];		/* align to last u64 in cacheline */
-	u64 nasids_size;	/* SAL: size of each nasid mask in bytes */
+	u64 pad2[9];		/* align to last u64 in 2nd 64-byte cacheline */
+	u64 SAL_nasids_size;	/* SAL: size of each nasid mask in bytes */
 };
 
-#define XPC_RP_VERSION _XPC_VERSION(1, 1) /* version 1.1 of the reserved page */
+#define XPC_RP_VERSION _XPC_VERSION(2, 0) /* version 2.0 of the reserved page */
 
 #define XPC_SUPPORTS_RP_STAMP(_version) \
 			(_version >= _XPC_VERSION(1, 1))
 
+#define ZERO_STAMP	((struct timespec){0, 0})
 /*
  * compare stamps - the return value is:
  *
@@ -218,10 +224,10 @@ xpc_disallow_hb(short partid, struct xpc
  *
  * An array of these structures, one per partition, will be defined. As a
  * partition becomes active XPC will copy the array entry corresponding to
- * itself from that partition. It is desirable that the size of this
- * structure evenly divide into a cacheline, such that none of the entries
- * in this array crosses a cacheline boundary. As it is now, each entry
- * occupies half a cacheline.
+ * itself from that partition. It is desirable that the size of this structure
+ * evenly divides into a 128-byte cacheline, such that none of the entries in
+ * this array crosses a 128-byte cacheline boundary. As it is now, each entry
+ * occupies a 64-byte cacheline.
  */
 struct xpc_vars_part {
 	u64 magic;
@@ -632,16 +638,25 @@ extern void xpc_activate_kthreads(struct
 extern void xpc_create_kthreads(struct xpc_channel *, int, int);
 extern void xpc_disconnect_wait(int);
 
+extern enum xp_retval (*xpc_rsvd_page_init) (struct xpc_rsvd_page *);
+
+/* found in xpc_sn2.c */
+extern void xpc_init_sn2(void);
+extern struct xpc_vars *xpc_vars;		/*>>> eliminate from here */
+extern struct xpc_vars_part *xpc_vars_part;	/*>>> eliminate from here */
+
+/* found in xpc_uv.c */
+extern void xpc_init_uv(void);
+
 /* found in xpc_partition.c */
 extern int xpc_exiting;
-extern struct xpc_vars *xpc_vars;
+extern int xp_nasid_mask_words;
 extern struct xpc_rsvd_page *xpc_rsvd_page;
-extern struct xpc_vars_part *xpc_vars_part;
 extern struct xpc_partition *xpc_partitions;
 extern char *xpc_remote_copy_buffer;
 extern void *xpc_remote_copy_buffer_base;
 extern void *xpc_kmalloc_cacheline_aligned(size_t, gfp_t, void **);
-extern struct xpc_rsvd_page *xpc_rsvd_page_init(void);
+extern struct xpc_rsvd_page *xpc_setup_rsvd_page(void);
 extern void xpc_allow_IPI_ops(void);
 extern void xpc_restrict_IPI_ops(void);
 extern int xpc_identify_act_IRQ_sender(void);
diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-xp-prepare-xpc_rsvd_page-to-work-on-either-sn2-or-uv-hardware drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xp-prepare-xpc_rsvd_page-to-work-on-either-sn2-or-uv-hardware
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -175,6 +175,8 @@ static struct notifier_block xpc_die_not
 	.notifier_call = xpc_system_die,
 };
 
+enum xp_retval (*xpc_rsvd_page_init) (struct xpc_rsvd_page *rp);
+
 /*
  * Timer function to enforce the timelimit on the partition disengage request.
  */
@@ -949,7 +951,7 @@ xpc_do_exit(enum xp_retval reason)
 	DBUG_ON(xpc_partition_engaged(-1UL));
 
 	/* indicate to others that our reserved page is uninitialized */
-	xpc_rsvd_page->vars_pa = 0;
+	xpc_rsvd_page->stamp = ZERO_STAMP;
 
 	/* now it's time to eliminate our heartbeat */
 	del_timer_sync(&xpc_hb_timer);
@@ -1128,8 +1130,24 @@ xpc_init(void)
 	struct task_struct *kthread;
 	size_t buf_size;
 
-	if (!ia64_platform_is("sn2"))
+	if (is_shub()) {
+		/*
+		 * The ia64-sn2 architecture supports at most 64 partitions.
+		 * And the inability to unregister remote AMOs restricts us
+		 * further to only support exactly 64 partitions on this
+		 * architecture, no less.
+		 */
+		if (xp_max_npartitions != 64)
+			return -EINVAL;
+
+		xpc_init_sn2();
+
+	} else if (is_uv()) {
+		xpc_init_uv();
+
+	} else {
 		return -ENODEV;
+	}
 
 	snprintf(xpc_part->bus_id, BUS_ID_SIZE, "part");
 	snprintf(xpc_chan->bus_id, BUS_ID_SIZE, "chan");
@@ -1214,7 +1232,7 @@ xpc_init(void)
 	 * other partitions to discover we are alive and establish initial
 	 * communications.
 	 */
-	xpc_rsvd_page = xpc_rsvd_page_init();
+	xpc_rsvd_page = xpc_setup_rsvd_page();
 	if (xpc_rsvd_page == NULL) {
 		dev_err(xpc_part, "can't setup our reserved page\n");
 		ret = -EBUSY;
@@ -1273,7 +1291,8 @@ xpc_init(void)
 	/* initialization was not successful */
 out_4:
 	/* indicate to others that our reserved page is uninitialized */
-	xpc_rsvd_page->vars_pa = 0;
+	xpc_rsvd_page->stamp = ZERO_STAMP;
+
 	del_timer_sync(&xpc_hb_timer);
 	(void)unregister_die_notifier(&xpc_die_notifier);
 	(void)unregister_reboot_notifier(&xpc_reboot_notifier);
diff -puN drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-prepare-xpc_rsvd_page-to-work-on-either-sn2-or-uv-hardware drivers/misc/sgi-xp/xpc_partition.c
--- a/drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-prepare-xpc_rsvd_page-to-work-on-either-sn2-or-uv-hardware
+++ a/drivers/misc/sgi-xp/xpc_partition.c
@@ -20,7 +20,6 @@
 #include <linux/cache.h>
 #include <linux/mmzone.h>
 #include <linux/nodemask.h>
-#include <asm/uncached.h>
 #include <asm/sn/intr.h>
 #include <asm/sn/sn_sal.h>
 #include <asm/sn/nodepda.h>
@@ -44,11 +43,10 @@ u64 xpc_prot_vec[MAX_NUMNODES];
 struct xpc_rsvd_page *xpc_rsvd_page;
 static u64 *xpc_part_nasids;
 static u64 *xpc_mach_nasids;
-struct xpc_vars *xpc_vars;
-struct xpc_vars_part *xpc_vars_part;
 
-static int xp_nasid_mask_bytes;	/* actual size in bytes of nasid mask */
-static int xp_nasid_mask_words;	/* actual size in words of nasid mask */
+/* >>> next two variables should be 'xpc_' if they remain here */
+static int xp_sizeof_nasid_mask;	/* actual size in bytes of nasid mask */
+int xp_nasid_mask_words;	/* actual size in words of nasid mask */
 
 struct xpc_partition *xpc_partitions;
 
@@ -150,12 +148,10 @@ xpc_get_rsvd_page_pa(int nasid)
  * communications.
  */
 struct xpc_rsvd_page *
-xpc_rsvd_page_init(void)
+xpc_setup_rsvd_page(void)
 {
 	struct xpc_rsvd_page *rp;
-	AMO_t *amos_page;
-	u64 rp_pa, nasid_array = 0;
-	int i, ret;
+	u64 rp_pa;
 
 	/* get the local reserved page's address */
 
@@ -168,110 +164,44 @@ xpc_rsvd_page_init(void)
 	}
 	rp = (struct xpc_rsvd_page *)__va(rp_pa);
 
-	if (rp->partid != sn_partition_id) {
-		dev_err(xpc_part, "the reserved page's partid of %d should be "
-			"%d\n", rp->partid, sn_partition_id);
+	if (rp->SAL_version < 3) {
+		/* SAL_versions < 3 had a SAL_partid defined as a u8 */
+		rp->SAL_partid &= 0xff;
+	}
+	BUG_ON(rp->SAL_partid != sn_partition_id);
+
+	if (rp->SAL_partid < 0 || rp->SAL_partid >= xp_max_npartitions) {
+		dev_err(xpc_part, "the reserved page's partid of %d is outside "
+			"supported range (< 0 || >= %d)\n", rp->SAL_partid,
+			xp_max_npartitions);
 		return NULL;
 	}
 
 	rp->version = XPC_RP_VERSION;
+	rp->max_npartitions = xp_max_npartitions;
 
 	/* establish the actual sizes of the nasid masks */
 	if (rp->SAL_version == 1) {
 		/* SAL_version 1 didn't set the nasids_size field */
-		rp->nasids_size = 128;
+		rp->SAL_nasids_size = 128;
 	}
-	xp_nasid_mask_bytes = rp->nasids_size;
-	xp_nasid_mask_words = xp_nasid_mask_bytes / 8;
+	xp_sizeof_nasid_mask = rp->SAL_nasids_size;
+	xp_nasid_mask_words = DIV_ROUND_UP(xp_sizeof_nasid_mask,
+					   BYTES_PER_WORD);
 
 	/* setup the pointers to the various items in the reserved page */
 	xpc_part_nasids = XPC_RP_PART_NASIDS(rp);
 	xpc_mach_nasids = XPC_RP_MACH_NASIDS(rp);
-	xpc_vars = XPC_RP_VARS(rp);
-	xpc_vars_part = XPC_RP_VARS_PART(rp);
 
-	/*
-	 * Before clearing xpc_vars, see if a page of AMOs had been previously
-	 * allocated. If not we'll need to allocate one and set permissions
-	 * so that cross-partition AMOs are allowed.
-	 *
-	 * The allocated AMO page needs MCA reporting to remain disabled after
-	 * XPC has unloaded.  To make this work, we keep a copy of the pointer
-	 * to this page (i.e., amos_page) in the struct xpc_vars structure,
-	 * which is pointed to by the reserved page, and re-use that saved copy
-	 * on subsequent loads of XPC. This AMO page is never freed, and its
-	 * memory protections are never restricted.
-	 */
-	amos_page = xpc_vars->amos_page;
-	if (amos_page == NULL) {
-		amos_page = (AMO_t *)TO_AMO(uncached_alloc_page(0, 1));
-		if (amos_page == NULL) {
-			dev_err(xpc_part, "can't allocate page of AMOs\n");
-			return NULL;
-		}
-
-		/*
-		 * Open up AMO-R/W to cpu.  This is done for Shub 1.1 systems
-		 * when xpc_allow_IPI_ops() is called via xpc_hb_init().
-		 */
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
-				return NULL;
-			}
-		}
-	} else if (!IS_AMO_ADDRESS((u64)amos_page)) {
-		/*
-		 * EFI's XPBOOT can also set amos_page in the reserved page,
-		 * but it happens to leave it as an uncached physical address
-		 * and we need it to be an uncached virtual, so we'll have to
-		 * convert it.
-		 */
-		if (!IS_AMO_PHYS_ADDRESS((u64)amos_page)) {
-			dev_err(xpc_part, "previously used amos_page address "
-				"is bad = 0x%p\n", (void *)amos_page);
-			return NULL;
-		}
-		amos_page = (AMO_t *)TO_AMO((u64)amos_page);
-	}
-
-	/* clear xpc_vars */
-	memset(xpc_vars, 0, sizeof(struct xpc_vars));
-
-	xpc_vars->version = XPC_V_VERSION;
-	xpc_vars->act_nasid = cpuid_to_nasid(0);
-	xpc_vars->act_phys_cpuid = cpu_physical_id(0);
-	xpc_vars->vars_part_pa = __pa(xpc_vars_part);
-	xpc_vars->amos_page_pa = ia64_tpa((u64)amos_page);
-	xpc_vars->amos_page = amos_page;	/* save for next load of XPC */
-
-	/* clear xpc_vars_part */
-	memset((u64 *)xpc_vars_part, 0, sizeof(struct xpc_vars_part) *
-	       xp_max_npartitions);
-
-	/* initialize the activate IRQ related AMO variables */
-	for (i = 0; i < xp_nasid_mask_words; i++)
-		(void)xpc_IPI_init(XPC_ACTIVATE_IRQ_AMOS + i);
-
-	/* initialize the engaged remote partitions related AMO variables */
-	(void)xpc_IPI_init(XPC_ENGAGED_PARTITIONS_AMO);
-	(void)xpc_IPI_init(XPC_DISENGAGE_REQUEST_AMO);
-
-	/* timestamp of when reserved page was setup by XPC */
-	rp->stamp = CURRENT_TIME;
+	if (xpc_rsvd_page_init(rp) != xpSuccess)
+		return NULL;
 
 	/*
+	 * Set timestamp of when reserved page was setup by XPC.
 	 * This signifies to the remote partition that our reserved
 	 * page is initialized.
 	 */
-	rp->vars_pa = __pa(xpc_vars);
+	rp->stamp = CURRENT_TIME;
 
 	return rp;
 }
@@ -465,7 +395,7 @@ xpc_get_remote_rp(int nasid, u64 *discov
 
 	/* pull over the reserved page header and part_nasids mask */
 	ret = xp_remote_memcpy(remote_rp, (void *)*remote_rp_pa,
-			       XPC_RP_HEADER_SIZE + xp_nasid_mask_bytes);
+			       XPC_RP_HEADER_SIZE + xp_sizeof_nasid_mask);
 	if (ret != xpSuccess)
 		return ret;
 
@@ -476,19 +406,28 @@ xpc_get_remote_rp(int nasid, u64 *discov
 			discovered_nasids[i] |= remote_part_nasids[i];
 	}
 
-	/* check that the partid is for another partition */
+	/* check that the partid is valid and is for another partition */
 
-	if (remote_rp->partid < 0 || remote_rp->partid >= xp_max_npartitions)
+	if (remote_rp->SAL_partid < 0 ||
+	    remote_rp->SAL_partid >= xp_max_npartitions) {
 		return xpInvalidPartid;
+	}
 
-	if (remote_rp->partid == sn_partition_id)
+	if (remote_rp->SAL_partid == sn_partition_id)
 		return xpLocalPartid;
 
+	/* see if the rest of the reserved page has been set up by XPC */
+	if (timespec_equal(&remote_rp->stamp, &ZERO_STAMP))
+		return xpRsvdPageNotSet;
+
 	if (XPC_VERSION_MAJOR(remote_rp->version) !=
 	    XPC_VERSION_MAJOR(XPC_RP_VERSION)) {
 		return xpBadVersion;
 	}
 
+	if (remote_rp->max_npartitions <= sn_partition_id)
+		return xpInvalidPartid;
+
 	return xpSuccess;
 }
 
@@ -592,7 +531,7 @@ xpc_identify_act_IRQ_req(int nasid)
 	int remote_rp_version;
 	int reactivate = 0;
 	int stamp_diff;
-	struct timespec remote_rp_stamp = { 0, 0 };
+	struct timespec remote_rp_stamp = { 0, 0 }; /*>>> ZERO_STAMP */
 	short partid;
 	struct xpc_partition *part;
 	enum xp_retval ret;
@@ -608,12 +547,12 @@ xpc_identify_act_IRQ_req(int nasid)
 		return;
 	}
 
-	remote_vars_pa = remote_rp->vars_pa;
+	remote_vars_pa = remote_rp->sn.vars_pa;
 	remote_rp_version = remote_rp->version;
 	if (XPC_SUPPORTS_RP_STAMP(remote_rp_version))
 		remote_rp_stamp = remote_rp->stamp;
 
-	partid = remote_rp->partid;
+	partid = remote_rp->SAL_partid;
 	part = &xpc_partitions[partid];
 
 	/* pull over the cross partition variables */
@@ -977,7 +916,7 @@ xpc_discovery(void)
 	enum xp_retval ret;
 
 	remote_rp = xpc_kmalloc_cacheline_aligned(XPC_RP_HEADER_SIZE +
-						  xp_nasid_mask_bytes,
+						  xp_sizeof_nasid_mask,
 						  GFP_KERNEL, &remote_rp_base);
 	if (remote_rp == NULL)
 		return;
@@ -1063,9 +1002,9 @@ xpc_discovery(void)
 				continue;
 			}
 
-			remote_vars_pa = remote_rp->vars_pa;
+			remote_vars_pa = remote_rp->sn.vars_pa;
 
-			partid = remote_rp->partid;
+			partid = remote_rp->SAL_partid;
 			part = &xpc_partitions[partid];
 
 			/* pull over the cross partition variables */
@@ -1155,5 +1094,5 @@ xpc_initiate_partid_to_nasids(short part
 	part_nasid_pa = (u64)XPC_RP_PART_NASIDS(part->remote_rp_pa);
 
 	return xp_remote_memcpy(nasid_mask, (void *)part_nasid_pa,
-				xp_nasid_mask_bytes);
+				xp_sizeof_nasid_mask);
 }
diff -puN /dev/null drivers/misc/sgi-xp/xpc_sn2.c
--- /dev/null
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -0,0 +1,111 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ */
+
+/*
+ * Cross Partition Communication (XPC) sn2-based functions.
+ *
+ *     Architecture specific implementation of common functions.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <asm/uncached.h>
+#include <asm/sn/sn_sal.h>
+#include "xpc.h"
+
+struct xpc_vars *xpc_vars;
+struct xpc_vars_part *xpc_vars_part;
+
+static enum xp_retval
+xpc_rsvd_page_init_sn2(struct xpc_rsvd_page *rp)
+{
+	AMO_t *amos_page;
+	u64 nasid_array = 0;
+	int i;
+	int ret;
+
+	xpc_vars = XPC_RP_VARS(rp);
+
+	rp->sn.vars_pa = __pa(xpc_vars);
+
+	xpc_vars_part = XPC_RP_VARS_PART(rp);
+
+	/*
+	 * Before clearing xpc_vars, see if a page of AMOs had been previously
+	 * allocated. If not we'll need to allocate one and set permissions
+	 * so that cross-partition AMOs are allowed.
+	 *
+	 * The allocated AMO page needs MCA reporting to remain disabled after
+	 * XPC has unloaded.  To make this work, we keep a copy of the pointer
+	 * to this page (i.e., amos_page) in the struct xpc_vars structure,
+	 * which is pointed to by the reserved page, and re-use that saved copy
+	 * on subsequent loads of XPC. This AMO page is never freed, and its
+	 * memory protections are never restricted.
+	 */
+	amos_page = xpc_vars->amos_page;
+	if (amos_page == NULL) {
+		amos_page = (AMO_t *)TO_AMO(uncached_alloc_page(0, 1));
+		if (amos_page == NULL) {
+			dev_err(xpc_part, "can't allocate page of AMOs\n");
+			return xpNoMemory;
+		}
+
+		/*
+		 * Open up AMO-R/W to cpu.  This is done for Shub 1.1 systems
+		 * when xpc_allow_IPI_ops() is called via xpc_hb_init().
+		 */
+		if (!enable_shub_wars_1_1()) {
+			ret = sn_change_memprotect(ia64_tpa((u64)amos_page),
+						   PAGE_SIZE,
+						   SN_MEMPROT_ACCESS_CLASS_1,
+						   &nasid_array);
+			if (ret != 0) {
+				dev_err(xpc_part, "can't change memory "
+					"protections\n");
+				uncached_free_page(__IA64_UNCACHED_OFFSET |
+						   TO_PHYS((u64)amos_page), 1);
+				return xpSalError;
+			}
+		}
+	}
+
+	/* clear xpc_vars */
+	memset(xpc_vars, 0, sizeof(struct xpc_vars));
+
+	xpc_vars->version = XPC_V_VERSION;
+	xpc_vars->act_nasid = cpuid_to_nasid(0);
+	xpc_vars->act_phys_cpuid = cpu_physical_id(0);
+	xpc_vars->vars_part_pa = __pa(xpc_vars_part);
+	xpc_vars->amos_page_pa = ia64_tpa((u64)amos_page);
+	xpc_vars->amos_page = amos_page;	/* save for next load of XPC */
+
+	/* clear xpc_vars_part */
+	memset((u64 *)xpc_vars_part, 0, sizeof(struct xpc_vars_part) *
+	       xp_max_npartitions);
+
+	/* initialize the activate IRQ related AMO variables */
+	for (i = 0; i < xp_nasid_mask_words; i++)
+		(void)xpc_IPI_init(XPC_ACTIVATE_IRQ_AMOS + i);
+
+	/* initialize the engaged remote partitions related AMO variables */
+	(void)xpc_IPI_init(XPC_ENGAGED_PARTITIONS_AMO);
+	(void)xpc_IPI_init(XPC_DISENGAGE_REQUEST_AMO);
+
+	return xpSuccess;
+}
+
+void
+xpc_init_sn2(void)
+{
+	xpc_rsvd_page_init = xpc_rsvd_page_init_sn2;
+}
+
+void
+xpc_exit_sn2(void)
+{
+}
diff -puN /dev/null drivers/misc/sgi-xp/xpc_uv.c
--- /dev/null
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -0,0 +1,48 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ */
+
+/*
+ * Cross Partition Communication (XPC) uv-based functions.
+ *
+ *     Architecture specific implementation of common functions.
+ *
+ */
+
+#include <linux/kernel.h>
+
+/* >>> #include <gru/grukservices.h> */
+/* >>> uv_gpa() is defined in <gru/grukservices.h> */
+#define uv_gpa(_a)		((unsigned long)_a)
+
+/* >>> temporarily define next three items for xpc.h */
+#define	SGI_XPC_ACTIVATE	23
+#define	SGI_XPC_NOTIFY		24
+#define sn_send_IPI_phys(_a, _b, _c, _d)
+
+#include "xpc.h"
+
+static void *xpc_activate_mq;
+
+static enum xp_retval
+xpc_rsvd_page_init_uv(struct xpc_rsvd_page *rp)
+{
+	/* >>> need to have established xpc_activate_mq earlier */
+	rp->sn.activate_mq_gpa = uv_gpa(xpc_activate_mq);
+	return xpSuccess;
+}
+
+void
+xpc_init_uv(void)
+{
+	xpc_rsvd_page_init = xpc_rsvd_page_init_uv;
+}
+
+void
+xpc_exit_uv(void)
+{
+}
_

Patches currently in -mm which might be from dcn@sgi.com are

origin.patch

