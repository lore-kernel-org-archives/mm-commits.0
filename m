From: akpm@linux-foundation.org
Subject: + sgi-xp-support-runtime-selection-of-xp_max_npartitions.patch added to -mm tree
Date: Sun, 08 Jun 2008 17:17:58 -0700
Message-ID: <200806090017.m590HwHU027065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755764AbYFIASC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 20:18:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dcn@sgi.com


The patch titled
     sgi-xp: support runtime selection of xp_max_npartitions
has been added to the -mm tree.  Its filename is
     sgi-xp-support-runtime-selection-of-xp_max_npartitions.patch

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
Subject: sgi-xp: support runtime selection of xp_max_npartitions
From: Dean Nelson <dcn@sgi.com>

Support runtime selection of the max number of partitions based on the
hardware being run on.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/Makefile        |    3 
 drivers/misc/sgi-xp/xp.h            |   53 ++++++++-----
 drivers/misc/sgi-xp/xp_main.c       |   84 ++++++++-------------
 drivers/misc/sgi-xp/xp_sn2.c        |   92 +++++++++++++++++++++++
 drivers/misc/sgi-xp/xp_uv.c         |   30 +++++++
 drivers/misc/sgi-xp/xpc.h           |   12 +--
 drivers/misc/sgi-xp/xpc_channel.c   |   20 ++---
 drivers/misc/sgi-xp/xpc_main.c      |  103 ++++++++++++--------------
 drivers/misc/sgi-xp/xpc_partition.c |   16 +---
 drivers/misc/sgi-xp/xpnet.c         |    4 -
 10 files changed, 266 insertions(+), 151 deletions(-)

diff -puN drivers/misc/sgi-xp/Makefile~sgi-xp-support-runtime-selection-of-xp_max_npartitions drivers/misc/sgi-xp/Makefile
--- a/drivers/misc/sgi-xp/Makefile~sgi-xp-support-runtime-selection-of-xp_max_npartitions
+++ a/drivers/misc/sgi-xp/Makefile
@@ -3,7 +3,8 @@
 #
 
 obj-$(CONFIG_SGI_XP)		+= xp.o
-xp-y				:= xp_main.o xp_nofault.o
+xp-y				:= xp_main.o xp_uv.o
+xp-$(CONFIG_IA64)		+= xp_sn2.o xp_nofault.o
 
 obj-$(CONFIG_SGI_XP)		+= xpc.o
 xpc-y				:= xpc_main.o xpc_channel.o xpc_partition.o
diff -puN drivers/misc/sgi-xp/xp.h~sgi-xp-support-runtime-selection-of-xp_max_npartitions drivers/misc/sgi-xp/xp.h
--- a/drivers/misc/sgi-xp/xp.h~sgi-xp-support-runtime-selection-of-xp_max_npartitions
+++ a/drivers/misc/sgi-xp/xp.h
@@ -18,6 +18,9 @@
 #include <linux/mutex.h>
 #include <asm/sn/types.h>
 #include <asm/sn/bte.h>
+#ifdef CONFIG_IA64
+#include <asm/sn/arch.h>
+#endif
 
 /* >>> Add this #define to some linux header file some day. */
 #define BYTES_PER_WORD	sizeof(void *)
@@ -45,17 +48,18 @@
 #endif
 
 /*
- * Define the maximum number of logically defined partitions the system
- * can support. It is constrained by the maximum number of hardware
- * partitionable regions. The term 'region' in this context refers to the
- * minimum number of nodes that can comprise an access protection grouping.
- * The access protection is in regards to memory, IPI and IOI.
+ * Define the maximum number of partitions the system can possibly support.
+ * It is based on the maximum number of hardware partitionable regions. The
+ * term 'region' in this context refers to the minimum number of nodes that
+ * can comprise an access protection grouping. The access protection is in
+ * regards to memory, IPI and IOI.
  *
  * The maximum number of hardware partitionable regions is equal to the
  * maximum number of nodes in the entire system divided by the minimum number
  * of nodes that comprise an access protection grouping.
  */
-#define XP_MAX_PARTITIONS	64
+#define XP_MAX_NPARTITIONS_SN2	64
+#define XP_MAX_NPARTITIONS_UV	256
 
 /*
  * Define the number of u64s required to represent all the C-brick nasids
@@ -112,24 +116,28 @@ xp_bte_copy(u64 src, u64 vdst, u64 len, 
  * other partition that is currently up. Over these channels, kernel-level
  * `users' can communicate with their counterparts on the other partitions.
  *
- * The maxinum number of channels is limited to eight. For performance reasons,
- * the internal cross partition structures require sixteen bytes per channel,
- * and eight allows all of this interface-shared info to fit in one cache line.
+>>> The following described limitation of a max of eight channels possible
+>>> pertains only to ia64-sn2. THIS ISN'T TRUE SINCE I'M PLANNING TO JUST
+>>> TIE INTO THE EXISTING MECHANISM ONCE THE CHANNEL MESSAGES ARE RECEIVED.
+>>> THE 128-BYTE CACHELINE PERFORMANCE ISSUE IS TIED TO IA64-SN2.
  *
- * XPC_NCHANNELS reflects the total number of channels currently defined.
  * If the need for additional channels arises, one can simply increase
- * XPC_NCHANNELS accordingly. If the day should come where that number
- * exceeds the MAXIMUM number of channels allowed (eight), then one will need
- * to make changes to the XPC code to allow for this.
+ * XPC_MAX_NCHANNELS accordingly. If the day should come where that number
+ * exceeds the absolute MAXIMUM number of channels possible (eight), then one
+ * will need to make changes to the XPC code to accommodate for this.
+ *
+ * The absolute maximum number of channels possible is currently limited to
+ * eight for performance reasons. The internal cross partition structures
+ * require sixteen bytes per channel, and eight allows all of this
+ * interface-shared info to fit in one 128-byte cacheline.
  */
 #define XPC_MEM_CHANNEL		0	/* memory channel number */
 #define	XPC_NET_CHANNEL		1	/* network channel number */
 
-#define	XPC_NCHANNELS		2	/* #of defined channels */
-#define XPC_MAX_NCHANNELS	8	/* max #of channels allowed */
+#define XPC_MAX_NCHANNELS	2	/* max #of channels allowed */
 
-#if XPC_NCHANNELS > XPC_MAX_NCHANNELS
-#error	XPC_NCHANNELS exceeds MAXIMUM allowed.
+#if XPC_MAX_NCHANNELS > 8
+#error	XPC_MAX_NCHANNELS exceeds absolute MAXIMUM possible.
 #endif
 
 /*
@@ -254,7 +262,8 @@ enum xp_retval {
 	xpBteCopyError,		/* 52: bte_copy() returned error */
 	xpSalError,		/* 53: sn SAL error */
 
-	xpUnknownReason		/* 54: unknown reason - must be last in enum */
+	xpUnsupported,		/* 54: unsupported functionality or resource */
+	xpUnknownReason		/* 55: unknown reason - must be last in enum */
 };
 
 /*
@@ -397,8 +406,16 @@ xpc_partid_to_nasids(short partid, void 
 	return xpc_interface.partid_to_nasids(partid, nasids);
 }
 
+extern short xp_max_npartitions;
+
 extern u64 xp_nofault_PIOR_target;
 extern int xp_nofault_PIOR(void *);
 extern int xp_error_PIOR(void);
 
+extern struct device *xp;
+extern enum xp_retval xp_init_sn2(void);
+extern enum xp_retval xp_init_uv(void);
+extern void xp_exit_sn2(void);
+extern void xp_exit_uv(void);
+
 #endif /* _DRIVERS_MISC_SGIXP_XP_H */
diff -puN drivers/misc/sgi-xp/xp_main.c~sgi-xp-support-runtime-selection-of-xp_max_npartitions drivers/misc/sgi-xp/xp_main.c
--- a/drivers/misc/sgi-xp/xp_main.c~sgi-xp-support-runtime-selection-of-xp_max_npartitions
+++ a/drivers/misc/sgi-xp/xp_main.c
@@ -15,28 +15,32 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/interrupt.h>
 #include <linux/module.h>
-#include <linux/mutex.h>
-#include <asm/sn/intr.h>
-#include <asm/sn/sn_sal.h>
+#include <linux/device.h>
 #include "xp.h"
 
-/*
- * The export of xp_nofault_PIOR needs to happen here since it is defined
- * in drivers/misc/sgi-xp/xp_nofault.S. The target of the nofault read is
- * defined here.
- */
-EXPORT_SYMBOL_GPL(xp_nofault_PIOR);
+/* define the XP debug device structures to be used with dev_dbg() et al */
 
-u64 xp_nofault_PIOR_target;
-EXPORT_SYMBOL_GPL(xp_nofault_PIOR_target);
+struct device_driver xp_dbg_name = {
+	.name = "xp"
+};
+
+struct device xp_dbg_subname = {
+	.bus_id = {0},		/* set to "" */
+	.driver = &xp_dbg_name
+};
+
+struct device *xp = &xp_dbg_subname;
+
+/* max #of partitions possible */
+short xp_max_npartitions;
+EXPORT_SYMBOL_GPL(xp_max_npartitions);
 
 /*
  * xpc_registrations[] keeps track of xpc_connect()'s done by the kernel-level
  * users of XPC.
  */
-struct xpc_registration xpc_registrations[XPC_NCHANNELS];
+struct xpc_registration xpc_registrations[XPC_MAX_NCHANNELS];
 EXPORT_SYMBOL_GPL(xpc_registrations);
 
 /*
@@ -135,7 +139,7 @@ xpc_connect(int ch_number, xpc_channel_f
 {
 	struct xpc_registration *registration;
 
-	DBUG_ON(ch_number < 0 || ch_number >= XPC_NCHANNELS);
+	DBUG_ON(ch_number < 0 || ch_number >= XPC_MAX_NCHANNELS);
 	DBUG_ON(payload_size == 0 || nentries == 0);
 	DBUG_ON(func == NULL);
 	DBUG_ON(assigned_limit == 0 || idle_limit > assigned_limit);
@@ -185,7 +189,7 @@ xpc_disconnect(int ch_number)
 {
 	struct xpc_registration *registration;
 
-	DBUG_ON(ch_number < 0 || ch_number >= XPC_NCHANNELS);
+	DBUG_ON(ch_number < 0 || ch_number >= XPC_MAX_NCHANNELS);
 
 	registration = &xpc_registrations[ch_number];
 
@@ -221,39 +225,21 @@ EXPORT_SYMBOL_GPL(xpc_disconnect);
 int __init
 xp_init(void)
 {
-	int ret, ch_number;
-	u64 func_addr = *(u64 *)xp_nofault_PIOR;
-	u64 err_func_addr = *(u64 *)xp_error_PIOR;
-
-	if (!ia64_platform_is("sn2"))
-		return -ENODEV;
+	enum xp_retval ret;
+	int ch_number;
 
-	/*
-	 * Register a nofault code region which performs a cross-partition
-	 * PIO read. If the PIO read times out, the MCA handler will consume
-	 * the error and return to a kernel-provided instruction to indicate
-	 * an error. This PIO read exists because it is guaranteed to timeout
-	 * if the destination is down (AMO operations do not timeout on at
-	 * least some CPUs on Shubs <= v1.2, which unfortunately we have to
-	 * work around).
-	 */
-	ret = sn_register_nofault_code(func_addr, err_func_addr, err_func_addr,
-				       1, 1);
-	if (ret != 0) {
-		printk(KERN_ERR "XP: can't register nofault code, error=%d\n",
-		       ret);
-	}
-	/*
-	 * Setup the nofault PIO read target. (There is no special reason why
-	 * SH_IPI_ACCESS was selected.)
-	 */
-	if (is_shub2())
-		xp_nofault_PIOR_target = SH2_IPI_ACCESS0;
+	if (is_shub())
+		ret = xp_init_sn2();
+	else if (is_uv())
+		ret = xp_init_uv();
 	else
-		xp_nofault_PIOR_target = SH1_IPI_ACCESS;
+		ret = xpUnsupported;
+
+	if (ret != xpSuccess)
+		return -ENODEV;
 
 	/* initialize the connection registration mutex */
-	for (ch_number = 0; ch_number < XPC_NCHANNELS; ch_number++)
+	for (ch_number = 0; ch_number < XPC_MAX_NCHANNELS; ch_number++)
 		mutex_init(&xpc_registrations[ch_number].mutex);
 
 	return 0;
@@ -264,12 +250,10 @@ module_init(xp_init);
 void __exit
 xp_exit(void)
 {
-	u64 func_addr = *(u64 *)xp_nofault_PIOR;
-	u64 err_func_addr = *(u64 *)xp_error_PIOR;
-
-	/* unregister the PIO read nofault code region */
-	(void)sn_register_nofault_code(func_addr, err_func_addr,
-				       err_func_addr, 1, 0);
+	if (is_shub())
+		xp_exit_sn2();
+	else if (is_uv())
+		xp_exit_uv();
 }
 
 module_exit(xp_exit);
diff -puN /dev/null drivers/misc/sgi-xp/xp_sn2.c
--- /dev/null
+++ a/drivers/misc/sgi-xp/xp_sn2.c
@@ -0,0 +1,92 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ */
+
+/*
+ * Cross Partition (XP) sn2-based functions.
+ *
+ *      Architecture specific implementation of common functions.
+ */
+
+#include <linux/device.h>
+#include <asm/sn/sn_sal.h>
+#include "xp.h"
+
+/*
+ * The export of xp_nofault_PIOR needs to happen here since it is defined
+ * in drivers/misc/sgi-xp/xp_nofault.S. The target of the nofault read is
+ * defined here.
+ */
+EXPORT_SYMBOL_GPL(xp_nofault_PIOR);
+
+u64 xp_nofault_PIOR_target;
+EXPORT_SYMBOL_GPL(xp_nofault_PIOR_target);
+
+/*
+ * Register a nofault code region which performs a cross-partition PIO read.
+ * If the PIO read times out, the MCA handler will consume the error and
+ * return to a kernel-provided instruction to indicate an error. This PIO read
+ * exists because it is guaranteed to timeout if the destination is down
+ * (AMO operations do not timeout on at least some CPUs on Shubs <= v1.2,
+ * which unfortunately we have to work around).
+ */
+static enum xp_retval
+xp_register_nofault_code_sn2(void)
+{
+	int ret;
+	u64 func_addr;
+	u64 err_func_addr;
+
+	func_addr = *(u64 *)xp_nofault_PIOR;
+	err_func_addr = *(u64 *)xp_error_PIOR;
+	ret = sn_register_nofault_code(func_addr, err_func_addr, err_func_addr,
+				       1, 1);
+	if (ret != 0) {
+		dev_err(xp, "can't register nofault code, error=%d\n", ret);
+		return xpSalError;
+	}
+	/*
+	 * Setup the nofault PIO read target. (There is no special reason why
+	 * SH_IPI_ACCESS was selected.)
+	 */
+	if (is_shub1())
+		xp_nofault_PIOR_target = SH1_IPI_ACCESS;
+	else if (is_shub2())
+		xp_nofault_PIOR_target = SH2_IPI_ACCESS0;
+
+	return xpSuccess;
+}
+
+void
+xp_unregister_nofault_code_sn2(void)
+{
+	u64 func_addr = *(u64 *)xp_nofault_PIOR;
+	u64 err_func_addr = *(u64 *)xp_error_PIOR;
+
+	/* unregister the PIO read nofault code region */
+	(void)sn_register_nofault_code(func_addr, err_func_addr,
+				       err_func_addr, 1, 0);
+}
+
+enum xp_retval
+xp_init_sn2(void)
+{
+	BUG_ON(!is_shub());
+
+	xp_max_npartitions = XP_MAX_NPARTITIONS_SN2;
+
+	return xp_register_nofault_code_sn2();
+}
+
+void
+xp_exit_sn2(void)
+{
+	BUG_ON(!is_shub());
+
+	xp_unregister_nofault_code_sn2();
+}
+
diff -puN /dev/null drivers/misc/sgi-xp/xp_uv.c
--- /dev/null
+++ a/drivers/misc/sgi-xp/xp_uv.c
@@ -0,0 +1,30 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ */
+
+/*
+ * Cross Partition (XP) uv-based functions.
+ *
+ *      Architecture specific implementation of common functions.
+ *
+ */
+
+#include "xp.h"
+
+enum xp_retval
+xp_init_uv(void)
+{
+	BUG_ON(!is_uv());
+
+	xp_max_npartitions = XP_MAX_NPARTITIONS_UV;
+}
+
+void
+xp_exit_uv(void)
+{
+	BUG_ON(!is_uv());
+}
diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xp-support-runtime-selection-of-xp_max_npartitions drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xp-support-runtime-selection-of-xp_max_npartitions
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -210,7 +210,7 @@ xpc_disallow_hb(short partid, struct xpc
  * the XPC running on the remote partition).
  */
 #define XPC_NOTIFY_IRQ_AMOS	   0
-#define XPC_ACTIVATE_IRQ_AMOS	   (XPC_NOTIFY_IRQ_AMOS + XP_MAX_PARTITIONS)
+#define XPC_ACTIVATE_IRQ_AMOS	   (XPC_NOTIFY_IRQ_AMOS + XP_MAX_NPARTITIONS_SN2)
 #define XPC_ENGAGED_PARTITIONS_AMO (XPC_ACTIVATE_IRQ_AMOS + XP_NASID_MASK_WORDS)
 #define XPC_DISENGAGE_REQUEST_AMO  (XPC_ENGAGED_PARTITIONS_AMO + 1)
 
@@ -285,7 +285,7 @@ struct xpc_gp {
 };
 
 #define XPC_GP_SIZE \
-		L1_CACHE_ALIGN(sizeof(struct xpc_gp) * XPC_NCHANNELS)
+		L1_CACHE_ALIGN(sizeof(struct xpc_gp) * XPC_MAX_NCHANNELS)
 
 /*
  * Define a structure that contains arguments associated with opening and
@@ -300,7 +300,8 @@ struct xpc_openclose_args {
 };
 
 #define XPC_OPENCLOSE_ARGS_SIZE \
-	      L1_CACHE_ALIGN(sizeof(struct xpc_openclose_args) * XPC_NCHANNELS)
+	      L1_CACHE_ALIGN(sizeof(struct xpc_openclose_args) * \
+	      XPC_MAX_NCHANNELS)
 
 /* struct xpc_msg flags */
 
@@ -637,7 +638,7 @@ extern int xpc_exiting;
 extern struct xpc_vars *xpc_vars;
 extern struct xpc_rsvd_page *xpc_rsvd_page;
 extern struct xpc_vars_part *xpc_vars_part;
-extern struct xpc_partition xpc_partitions[XP_MAX_PARTITIONS + 1];
+extern struct xpc_partition *xpc_partitions;
 extern char *xpc_remote_copy_buffer;
 extern void *xpc_remote_copy_buffer_base;
 extern void *xpc_kmalloc_cacheline_aligned(size_t, gfp_t, void **);
@@ -1104,13 +1105,14 @@ xpc_IPI_send_local_msgrequest(struct xpc
 }
 
 /*
+>>> this block comment needs to be moved and re-written.
  * Memory for XPC's AMO variables is allocated by the MSPEC driver. These
  * pages are located in the lowest granule. The lowest granule uses 4k pages
  * for cached references and an alternate TLB handler to never provide a
  * cacheable mapping for the entire region. This will prevent speculative
  * reading of cached copies of our lines from being issued which will cause
  * a PI FSB Protocol error to be generated by the SHUB. For XPC, we need 64
- * AMO variables (based on XP_MAX_PARTITIONS) for message notification and an
+ * AMO variables (based on xp_max_npartitions) for message notification and an
  * additional 128 AMO variables (based on XP_NASID_MASK_WORDS) for partition
  * activation and 2 AMO variables for partition deactivation.
  */
diff -puN drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-support-runtime-selection-of-xp_max_npartitions drivers/misc/sgi-xp/xpc_channel.c
--- a/drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-support-runtime-selection-of-xp_max_npartitions
+++ a/drivers/misc/sgi-xp/xpc_channel.c
@@ -110,14 +110,14 @@ xpc_setup_infrastructure(struct xpc_part
 	 * Allocate all of the channel structures as a contiguous chunk of
 	 * memory.
 	 */
-	part->channels = kzalloc(sizeof(struct xpc_channel) * XPC_NCHANNELS,
+	part->channels = kzalloc(sizeof(struct xpc_channel) * XPC_MAX_NCHANNELS,
 				 GFP_KERNEL);
 	if (part->channels == NULL) {
 		dev_err(xpc_chan, "can't get memory for channels\n");
 		return xpNoMemory;
 	}
 
-	part->nchannels = XPC_NCHANNELS;
+	part->nchannels = XPC_MAX_NCHANNELS;
 
 	/* allocate all the required GET/PUT values */
 
@@ -1432,9 +1432,9 @@ xpc_initiate_connect(int ch_number)
 	struct xpc_partition *part;
 	struct xpc_channel *ch;
 
-	DBUG_ON(ch_number < 0 || ch_number >= XPC_NCHANNELS);
+	DBUG_ON(ch_number < 0 || ch_number >= XPC_MAX_NCHANNELS);
 
-	for (partid = 1; partid < XP_MAX_PARTITIONS; partid++) {
+	for (partid = 0; partid < xp_max_npartitions; partid++) {
 		part = &xpc_partitions[partid];
 
 		if (xpc_part_ref(part)) {
@@ -1488,10 +1488,10 @@ xpc_initiate_disconnect(int ch_number)
 	struct xpc_partition *part;
 	struct xpc_channel *ch;
 
-	DBUG_ON(ch_number < 0 || ch_number >= XPC_NCHANNELS);
+	DBUG_ON(ch_number < 0 || ch_number >= XPC_MAX_NCHANNELS);
 
 	/* initiate the channel disconnect for every active partition */
-	for (partid = 1; partid < XP_MAX_PARTITIONS; partid++) {
+	for (partid = 0; partid < xp_max_npartitions; partid++) {
 		part = &xpc_partitions[partid];
 
 		if (xpc_part_ref(part)) {
@@ -1734,7 +1734,7 @@ xpc_initiate_allocate(short partid, int 
 	enum xp_retval ret = xpUnknownReason;
 	struct xpc_msg *msg = NULL;
 
-	DBUG_ON(partid <= 0 || partid >= XP_MAX_PARTITIONS);
+	DBUG_ON(partid < 0 || partid >= xp_max_npartitions);
 	DBUG_ON(ch_number < 0 || ch_number >= part->nchannels);
 
 	*payload = NULL;
@@ -1918,7 +1918,7 @@ xpc_initiate_send(short partid, int ch_n
 	dev_dbg(xpc_chan, "msg=0x%p, partid=%d, channel=%d\n", (void *)msg,
 		partid, ch_number);
 
-	DBUG_ON(partid <= 0 || partid >= XP_MAX_PARTITIONS);
+	DBUG_ON(partid < 0 || partid >= xp_max_npartitions);
 	DBUG_ON(ch_number < 0 || ch_number >= part->nchannels);
 	DBUG_ON(msg == NULL);
 
@@ -1968,7 +1968,7 @@ xpc_initiate_send_notify(short partid, i
 	dev_dbg(xpc_chan, "msg=0x%p, partid=%d, channel=%d\n", (void *)msg,
 		partid, ch_number);
 
-	DBUG_ON(partid <= 0 || partid >= XP_MAX_PARTITIONS);
+	DBUG_ON(partid < 0 || partid >= xp_max_npartitions);
 	DBUG_ON(ch_number < 0 || ch_number >= part->nchannels);
 	DBUG_ON(msg == NULL);
 	DBUG_ON(func == NULL);
@@ -2210,7 +2210,7 @@ xpc_initiate_received(short partid, int 
 	struct xpc_msg *msg = XPC_MSG_ADDRESS(payload);
 	s64 get, msg_number = msg->number;
 
-	DBUG_ON(partid <= 0 || partid >= XP_MAX_PARTITIONS);
+	DBUG_ON(partid < 0 || partid >= xp_max_npartitions);
 	DBUG_ON(ch_number < 0 || ch_number >= part->nchannels);
 
 	ch = &part->channels[ch_number];
diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-xp-support-runtime-selection-of-xp_max_npartitions drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xp-support-runtime-selection-of-xp_max_npartitions
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -433,7 +433,7 @@ xpc_activating(void *__partid)
 	struct xpc_partition *part = &xpc_partitions[partid];
 	unsigned long irq_flags;
 
-	DBUG_ON(partid <= 0 || partid >= XP_MAX_PARTITIONS);
+	DBUG_ON(partid < 0 || partid >= xp_max_npartitions);
 
 	spin_lock_irqsave(&part->act_lock, irq_flags);
 
@@ -544,7 +544,7 @@ xpc_notify_IRQ_handler(int irq, void *de
 	short partid = (short)(u64)dev_id;
 	struct xpc_partition *part = &xpc_partitions[partid];
 
-	DBUG_ON(partid <= 0 || partid >= XP_MAX_PARTITIONS);
+	DBUG_ON(partid < 0 || partid >= xp_max_npartitions);
 
 	if (xpc_part_ref(part)) {
 		xpc_check_for_channel_activity(part);
@@ -815,7 +815,7 @@ xpc_disconnect_wait(int ch_number)
 	int wakeup_channel_mgr;
 
 	/* now wait for all callouts to the caller's function to cease */
-	for (partid = 1; partid < XP_MAX_PARTITIONS; partid++) {
+	for (partid = 0; partid < xp_max_npartitions; partid++) {
 		part = &xpc_partitions[partid];
 
 		if (!xpc_part_ref(part))
@@ -895,7 +895,7 @@ xpc_do_exit(enum xp_retval reason)
 	do {
 		active_part_count = 0;
 
-		for (partid = 1; partid < XP_MAX_PARTITIONS; partid++) {
+		for (partid = 0; partid < xp_max_npartitions; partid++) {
 			part = &xpc_partitions[partid];
 
 			if (xpc_partition_disengaged(part) &&
@@ -956,11 +956,8 @@ xpc_do_exit(enum xp_retval reason)
 	DBUG_ON(xpc_vars->heartbeating_to_mask != 0);
 
 	if (reason == xpUnloading) {
-		/* take ourselves off of the reboot_notifier_list */
-		(void)unregister_reboot_notifier(&xpc_reboot_notifier);
-
-		/* take ourselves off of the die_notifier list */
 		(void)unregister_die_notifier(&xpc_die_notifier);
+		(void)unregister_reboot_notifier(&xpc_reboot_notifier);
 	}
 
 	/* close down protections for IPI operations */
@@ -972,6 +969,7 @@ xpc_do_exit(enum xp_retval reason)
 	if (xpc_sysctl)
 		unregister_sysctl_table(xpc_sysctl);
 
+	kfree(xpc_partitions);
 	kfree(xpc_remote_copy_buffer_base);
 }
 
@@ -1017,7 +1015,7 @@ xpc_die_disengage(void)
 
 	xpc_vars->heartbeating_to_mask = 0;	/* indicate we're deactivated */
 
-	for (partid = 1; partid < XP_MAX_PARTITIONS; partid++) {
+	for (partid = 0; partid < xp_max_npartitions; partid++) {
 		part = &xpc_partitions[partid];
 
 		if (!XPC_SUPPORTS_DISENGAGE_REQUEST(part->
@@ -1053,7 +1051,8 @@ xpc_die_disengage(void)
 
 		time = rtc_time();
 		if (time >= disengage_request_timeout) {
-			for (partid = 1; partid < XP_MAX_PARTITIONS; partid++) {
+			for (partid = 0; partid < xp_max_npartitions;
+			     partid++) {
 				if (engaged & (1UL << partid)) {
 					dev_info(xpc_part, "disengage from "
 						 "remote partition %d timed "
@@ -1132,18 +1131,26 @@ xpc_init(void)
 	if (!ia64_platform_is("sn2"))
 		return -ENODEV;
 
+	snprintf(xpc_part->bus_id, BUS_ID_SIZE, "part");
+	snprintf(xpc_chan->bus_id, BUS_ID_SIZE, "chan");
+
 	buf_size = max(XPC_RP_VARS_SIZE,
 		       XPC_RP_HEADER_SIZE + XP_NASID_MASK_BYTES);
 	xpc_remote_copy_buffer = xpc_kmalloc_cacheline_aligned(buf_size,
 							       GFP_KERNEL,
 						  &xpc_remote_copy_buffer_base);
-	if (xpc_remote_copy_buffer == NULL)
+	if (xpc_remote_copy_buffer == NULL) {
+		dev_err(xpc_part, "can't get memory for remote copy buffer\n");
 		return -ENOMEM;
+	}
 
-	snprintf(xpc_part->bus_id, BUS_ID_SIZE, "part");
-	snprintf(xpc_chan->bus_id, BUS_ID_SIZE, "chan");
-
-	xpc_sysctl = register_sysctl_table(xpc_sys_dir);
+	xpc_partitions = kzalloc(sizeof(struct xpc_partition) *
+				 xp_max_npartitions, GFP_KERNEL);
+	if (xpc_partitions == NULL) {
+		dev_err(xpc_part, "can't get memory for partition structure\n");
+		ret = -ENOMEM;
+		goto out_1;
+	}
 
 	/*
 	 * The first few fields of each entry of xpc_partitions[] need to
@@ -1153,7 +1160,7 @@ xpc_init(void)
 	 * ENTRIES ARE MEANINGFUL UNTIL AFTER AN ENTRY'S CORRESPONDING
 	 * PARTITION HAS BEEN ACTIVATED.
 	 */
-	for (partid = 1; partid < XP_MAX_PARTITIONS; partid++) {
+	for (partid = 0; partid < xp_max_npartitions; partid++) {
 		part = &xpc_partitions[partid];
 
 		DBUG_ON((u64)part != L1_CACHE_ALIGN((u64)part));
@@ -1173,6 +1180,8 @@ xpc_init(void)
 		atomic_set(&part->references, 0);
 	}
 
+	xpc_sysctl = register_sysctl_table(xpc_sys_dir);
+
 	/*
 	 * Open up protections for IPI operations (and AMO operations on
 	 * Shub 1.1 systems).
@@ -1196,14 +1205,8 @@ xpc_init(void)
 	if (ret != 0) {
 		dev_err(xpc_part, "can't register ACTIVATE IRQ handler, "
 			"errno=%d\n", -ret);
-
-		xpc_restrict_IPI_ops();
-
-		if (xpc_sysctl)
-			unregister_sysctl_table(xpc_sysctl);
-
-		kfree(xpc_remote_copy_buffer_base);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out_2;
 	}
 
 	/*
@@ -1213,16 +1216,9 @@ xpc_init(void)
 	 */
 	xpc_rsvd_page = xpc_rsvd_page_init();
 	if (xpc_rsvd_page == NULL) {
-		dev_err(xpc_part, "could not setup our reserved page\n");
-
-		free_irq(SGI_XPC_ACTIVATE, NULL);
-		xpc_restrict_IPI_ops();
-
-		if (xpc_sysctl)
-			unregister_sysctl_table(xpc_sysctl);
-
-		kfree(xpc_remote_copy_buffer_base);
-		return -EBUSY;
+		dev_err(xpc_part, "can't setup our reserved page\n");
+		ret = -EBUSY;
+		goto out_3;
 	}
 
 	/* add ourselves to the reboot_notifier_list */
@@ -1245,25 +1241,8 @@ xpc_init(void)
 	kthread = kthread_run(xpc_hb_checker, NULL, XPC_HB_CHECK_THREAD_NAME);
 	if (IS_ERR(kthread)) {
 		dev_err(xpc_part, "failed while forking hb check thread\n");
-
-		/* indicate to others that our reserved page is uninitialized */
-		xpc_rsvd_page->vars_pa = 0;
-
-		/* take ourselves off of the reboot_notifier_list */
-		(void)unregister_reboot_notifier(&xpc_reboot_notifier);
-
-		/* take ourselves off of the die_notifier list */
-		(void)unregister_die_notifier(&xpc_die_notifier);
-
-		del_timer_sync(&xpc_hb_timer);
-		free_irq(SGI_XPC_ACTIVATE, NULL);
-		xpc_restrict_IPI_ops();
-
-		if (xpc_sysctl)
-			unregister_sysctl_table(xpc_sysctl);
-
-		kfree(xpc_remote_copy_buffer_base);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out_4;
 	}
 
 	/*
@@ -1290,6 +1269,24 @@ xpc_init(void)
 			  xpc_initiate_partid_to_nasids);
 
 	return 0;
+
+	/* initialization was not successful */
+out_4:
+	/* indicate to others that our reserved page is uninitialized */
+	xpc_rsvd_page->vars_pa = 0;
+	del_timer_sync(&xpc_hb_timer);
+	(void)unregister_die_notifier(&xpc_die_notifier);
+	(void)unregister_reboot_notifier(&xpc_reboot_notifier);
+out_3:
+	free_irq(SGI_XPC_ACTIVATE, NULL);
+out_2:
+	xpc_restrict_IPI_ops();
+	if (xpc_sysctl)
+		unregister_sysctl_table(xpc_sysctl);
+	kfree(xpc_partitions);
+out_1:
+	kfree(xpc_remote_copy_buffer_base);
+	return ret;
 }
 
 module_init(xpc_init);
diff -puN drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-support-runtime-selection-of-xp_max_npartitions drivers/misc/sgi-xp/xpc_partition.c
--- a/drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-support-runtime-selection-of-xp_max_npartitions
+++ a/drivers/misc/sgi-xp/xpc_partition.c
@@ -51,13 +51,7 @@ struct xpc_vars_part *xpc_vars_part;
 static int xp_nasid_mask_bytes;	/* actual size in bytes of nasid mask */
 static int xp_nasid_mask_words;	/* actual size in words of nasid mask */
 
-/*
- * For performance reasons, each entry of xpc_partitions[] is cacheline
- * aligned. And xpc_partitions[] is padded with an additional entry at the
- * end so that the last legitimate entry doesn't share its cacheline with
- * another variable.
- */
-struct xpc_partition xpc_partitions[XP_MAX_PARTITIONS + 1];
+struct xpc_partition *xpc_partitions;
 
 /*
  * Generic buffer used to store a local copy of portions of a remote
@@ -261,7 +255,7 @@ xpc_rsvd_page_init(void)
 
 	/* clear xpc_vars_part */
 	memset((u64 *)xpc_vars_part, 0, sizeof(struct xpc_vars_part) *
-	       XP_MAX_PARTITIONS);
+	       xp_max_npartitions);
 
 	/* initialize the activate IRQ related AMO variables */
 	for (i = 0; i < xp_nasid_mask_words; i++)
@@ -408,7 +402,7 @@ xpc_check_remote_hb(void)
 
 	remote_vars = (struct xpc_vars *)xpc_remote_copy_buffer;
 
-	for (partid = 1; partid < XP_MAX_PARTITIONS; partid++) {
+	for (partid = 0; partid < xp_max_npartitions; partid++) {
 
 		if (xpc_exiting)
 			break;
@@ -487,10 +481,8 @@ xpc_get_remote_rp(int nasid, u64 *discov
 
 	/* check that the partid is for another partition */
 
-	if (remote_rp->partid < 1 ||
-	    remote_rp->partid > (XP_MAX_PARTITIONS - 1)) {
+	if (remote_rp->partid < 0 || remote_rp->partid >= xp_max_npartitions)
 		return xpInvalidPartid;
-	}
 
 	if (remote_rp->partid == sn_partition_id)
 		return xpLocalPartid;
diff -puN drivers/misc/sgi-xp/xpnet.c~sgi-xp-support-runtime-selection-of-xp_max_npartitions drivers/misc/sgi-xp/xpnet.c
--- a/drivers/misc/sgi-xp/xpnet.c~sgi-xp-support-runtime-selection-of-xp_max_npartitions
+++ a/drivers/misc/sgi-xp/xpnet.c
@@ -287,7 +287,7 @@ xpnet_connection_activity(enum xp_retval
 {
 	long bp;
 
-	DBUG_ON(partid <= 0 || partid >= XP_MAX_PARTITIONS);
+	DBUG_ON(partid < 0 || partid >= xp_max_npartitions);
 	DBUG_ON(channel != XPC_NET_CHANNEL);
 
 	switch (reason) {
@@ -513,7 +513,7 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 	/*
 	 * Main send loop.
 	 */
-	for (dest_partid = 1; dp && dest_partid < XP_MAX_PARTITIONS;
+	for (dest_partid = 0; dp && dest_partid < xp_max_npartitions;
 	     dest_partid++) {
 
 		if (!(dp & (1UL << (dest_partid - 1)))) {
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

