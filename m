From: akpm@linux-foundation.org
Subject: + sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy.patch added to -mm tree
Date: Sat, 12 Jul 2008 23:10:42 -0700
Message-ID: <200807130610.m6D6AgCX007347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751999AbYGMGKq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 02:10:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dcn@sgi.com, steiner@sgi.com, tony.luck@intel.com


The patch titled
     sgi-xp: add usage of GRU driver by xpc_remote_memcpy()
has been added to the -mm tree.  Its filename is
     sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy.patch

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
Subject: sgi-xp: add usage of GRU driver by xpc_remote_memcpy()
From: Dean Nelson <dcn@sgi.com>

Add UV support to xpc_remote_memcpy(), which involves interfacing to the
GRU driver.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xp.h            |    8 ++-
 drivers/misc/sgi-xp/xp_main.c       |    6 +-
 drivers/misc/sgi-xp/xp_sn2.c        |   50 +++++++++----------
 drivers/misc/sgi-xp/xp_uv.c         |   27 +++++++++-
 drivers/misc/sgi-xp/xpc.h           |   44 ++++++++--------
 drivers/misc/sgi-xp/xpc_channel.c   |    5 -
 drivers/misc/sgi-xp/xpc_main.c      |    8 +--
 drivers/misc/sgi-xp/xpc_partition.c |   37 ++++++--------
 drivers/misc/sgi-xp/xpc_sn2.c       |   68 +++++++++++++-------------
 drivers/misc/sgi-xp/xpc_uv.c        |    2 
 drivers/misc/sgi-xp/xpnet.c         |   26 ++++-----
 11 files changed, 154 insertions(+), 127 deletions(-)

diff -puN drivers/misc/sgi-xp/xp.h~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy drivers/misc/sgi-xp/xp.h
--- a/drivers/misc/sgi-xp/xp.h~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy
+++ a/drivers/misc/sgi-xp/xp.h
@@ -207,7 +207,9 @@ enum xp_retval {
 	xpUnsupported,		/* 56: unsupported functionality or resource */
 	xpNeedMoreInfo,		/* 57: more info is needed by SAL */
 
-	xpUnknownReason		/* 58: unknown reason - must be last in enum */
+	xpGruCopyError,		/* 58: gru_copy_gru() returned error */
+
+	xpUnknownReason		/* 59: unknown reason - must be last in enum */
 };
 
 /*
@@ -349,7 +351,9 @@ extern short xp_max_npartitions;
 extern short xp_partition_id;
 extern u8 xp_region_size;
 
-extern enum xp_retval (*xp_remote_memcpy) (void *, const void *, size_t);
+extern unsigned long (*xp_pa) (void *);
+extern enum xp_retval (*xp_remote_memcpy) (unsigned long, const unsigned long,
+		       size_t);
 extern int (*xp_cpu_to_nasid) (int);
 
 extern u64 xp_nofault_PIOR_target;
diff -puN drivers/misc/sgi-xp/xp_main.c~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy drivers/misc/sgi-xp/xp_main.c
--- a/drivers/misc/sgi-xp/xp_main.c~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy
+++ a/drivers/misc/sgi-xp/xp_main.c
@@ -41,7 +41,11 @@ EXPORT_SYMBOL_GPL(xp_partition_id);
 u8 xp_region_size;
 EXPORT_SYMBOL_GPL(xp_region_size);
 
-enum xp_retval (*xp_remote_memcpy) (void *dst, const void *src, size_t len);
+unsigned long (*xp_pa) (void *addr);
+EXPORT_SYMBOL_GPL(xp_pa);
+
+enum xp_retval (*xp_remote_memcpy) (unsigned long dst_gpa,
+				    const unsigned long src_gpa, size_t len);
 EXPORT_SYMBOL_GPL(xp_remote_memcpy);
 
 int (*xp_cpu_to_nasid) (int cpuid);
diff -puN drivers/misc/sgi-xp/xp_sn2.c~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy drivers/misc/sgi-xp/xp_sn2.c
--- a/drivers/misc/sgi-xp/xp_sn2.c~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy
+++ a/drivers/misc/sgi-xp/xp_sn2.c
@@ -63,7 +63,7 @@ xp_register_nofault_code_sn2(void)
 	return xpSuccess;
 }
 
-void
+static void
 xp_unregister_nofault_code_sn2(void)
 {
 	u64 func_addr = *(u64 *)xp_nofault_PIOR;
@@ -75,44 +75,41 @@ xp_unregister_nofault_code_sn2(void)
 }
 
 /*
+ * Convert a virtual memory address to a physical memory address.
+ */
+static unsigned long
+xp_pa_sn2(void *addr)
+{
+	return __pa(addr);
+}
+
+/*
  * Wrapper for bte_copy().
  *
- *	vdst - virtual address of the destination of the transfer.
- *	psrc - physical address of the source of the transfer.
+ *	dst_pa - physical address of the destination of the transfer.
+ *	src_pa - physical address of the source of the transfer.
  *	len - number of bytes to transfer from source to destination.
  *
  * Note: xp_remote_memcpy_sn2() should never be called while holding a spinlock.
  */
 static enum xp_retval
-xp_remote_memcpy_sn2(void *vdst, const void *psrc, size_t len)
+xp_remote_memcpy_sn2(unsigned long dst_pa, const unsigned long src_pa,
+		     size_t len)
 {
 	bte_result_t ret;
-	u64 pdst = ia64_tpa(vdst);
-	/* ??? What are the rules governing the src and dst addresses passed in?
-	 * ??? Currently we're assuming that dst is a virtual address and src
-	 * ??? is a physical address, is this appropriate? Can we allow them to
-	 * ??? be whatever and we make the change here without damaging the
-	 * ??? addresses?
-	 */
-
-	/*
-	 * Ensure that the physically mapped memory is contiguous.
-	 *
-	 * We do this by ensuring that the memory is from region 7 only.
-	 * If the need should arise to use memory from one of the other
-	 * regions, then modify the BUG_ON() statement to ensure that the
-	 * memory from that region is always physically contiguous.
-	 */
-	BUG_ON(REGION_NUMBER(vdst) != RGN_KERNEL);
 
-	ret = bte_copy((u64)psrc, pdst, len, (BTE_NOTIFY | BTE_WACQUIRE), NULL);
+	ret = bte_copy(src_pa, dst_pa, len, (BTE_NOTIFY | BTE_WACQUIRE), NULL);
 	if (ret == BTE_SUCCESS)
 		return xpSuccess;
 
-	if (is_shub2())
-		dev_err(xp, "bte_copy() on shub2 failed, error=0x%x\n", ret);
-	else
-		dev_err(xp, "bte_copy() failed, error=%d\n", ret);
+	if (is_shub2()) {
+		dev_err(xp, "bte_copy() on shub2 failed, error=0x%x dst_pa="
+			"0x%016lx src_pa=0x%016lx len=%ld\\n", ret, dst_pa,
+			src_pa, len);
+	} else {
+		dev_err(xp, "bte_copy() failed, error=%d dst_pa=0x%016lx "
+			"src_pa=0x%016lx len=%ld\\n", ret, dst_pa, src_pa, len);
+	}
 
 	return xpBteCopyError;
 }
@@ -132,6 +129,7 @@ xp_init_sn2(void)
 	xp_partition_id = sn_partition_id;
 	xp_region_size = sn_region_size;
 
+	xp_pa = xp_pa_sn2;
 	xp_remote_memcpy = xp_remote_memcpy_sn2;
 	xp_cpu_to_nasid = xp_cpu_to_nasid_sn2;
 
diff -puN drivers/misc/sgi-xp/xp_uv.c~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy drivers/misc/sgi-xp/xp_uv.c
--- a/drivers/misc/sgi-xp/xp_uv.c~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy
+++ a/drivers/misc/sgi-xp/xp_uv.c
@@ -13,13 +13,33 @@
  *
  */
 
+#include <linux/device.h>
+#include <asm/uv/uv_hub.h>
+#include "../sgi-gru/grukservices.h"
 #include "xp.h"
 
+/*
+ * Convert a virtual memory address to a physical memory address.
+ */
+static unsigned long
+xp_pa_uv(void *addr)
+{
+	return uv_gpa(addr);
+}
+
 static enum xp_retval
-xp_remote_memcpy_uv(void *vdst, const void *psrc, size_t len)
+xp_remote_memcpy_uv(unsigned long dst_gpa, const unsigned long src_gpa,
+		    size_t len)
 {
-	/* !!! this function needs fleshing out */
-	return xpUnsupported;
+	int ret;
+
+	ret = gru_copy_gpa(dst_gpa, src_gpa, len);
+	if (ret == 0)
+		return xpSuccess;
+
+	dev_err(xp, "gru_copy_gpa() failed, dst_gpa=0x%016lx src_gpa=0x%016lx "
+		"len=%ld\n", dst_gpa, src_gpa, len);
+	return xpGruCopyError;
 }
 
 enum xp_retval
@@ -29,6 +49,7 @@ xp_init_uv(void)
 
 	xp_max_npartitions = XP_MAX_NPARTITIONS_UV;
 
+	xp_pa = xp_pa_uv;
 	xp_remote_memcpy = xp_remote_memcpy_uv;
 
 	return xpSuccess;
diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -91,8 +91,8 @@ struct xpc_rsvd_page {
 	u8 version;
 	u8 pad1[3];		/* align to next u64 in 1st 64-byte cacheline */
 	union {
-		u64 vars_pa;	/* physical address of struct xpc_vars */
-		u64 activate_mq_gpa;	/* global phys address of activate_mq */
+		unsigned long vars_pa;	/* phys address of struct xpc_vars */
+		unsigned long activate_mq_gpa; /* gru phy addr of activate_mq */
 	} sn;
 	unsigned long ts_jiffies; /* timestamp when rsvd pg was setup by XPC */
 	u64 pad2[10];		/* align to last u64 in 2nd 64-byte cacheline */
@@ -122,8 +122,8 @@ struct xpc_vars_sn2 {
 	u64 heartbeat_offline;	/* if 0, heartbeat should be changing */
 	int activate_IRQ_nasid;
 	int activate_IRQ_phys_cpuid;
-	u64 vars_part_pa;
-	u64 amos_page_pa;	/* paddr of page of amos from MSPEC driver */
+	unsigned long vars_part_pa;
+	unsigned long amos_page_pa;/* paddr of page of amos from MSPEC driver */
 	struct amo *amos_page;	/* vaddr of page of amos from MSPEC driver */
 };
 
@@ -142,10 +142,10 @@ struct xpc_vars_sn2 {
 struct xpc_vars_part_sn2 {
 	u64 magic;
 
-	u64 openclose_args_pa;	/* physical address of open and close args */
-	u64 GPs_pa;		/* physical address of Get/Put values */
+	unsigned long openclose_args_pa; /* phys addr of open and close args */
+	unsigned long GPs_pa;	/* physical address of Get/Put values */
 
-	u64 chctl_amo_pa;	/* physical address of chctl flags' amo */
+	unsigned long chctl_amo_pa; /* physical address of chctl flags' amo */
 
 	int notify_IRQ_nasid;	/* nasid of where to send notify IRQs */
 	int notify_IRQ_phys_cpuid;	/* CPUID of where to send notify IRQs */
@@ -213,7 +213,7 @@ struct xpc_openclose_args {
 	u16 msg_size;		/* sizeof each message entry */
 	u16 remote_nentries;	/* #of message entries in remote msg queue */
 	u16 local_nentries;	/* #of message entries in local msg queue */
-	u64 local_msgqueue_pa;	/* physical address of local message queue */
+	unsigned long local_msgqueue_pa; /* phys addr of local message queue */
 };
 
 #define XPC_OPENCLOSE_ARGS_SIZE \
@@ -366,8 +366,8 @@ struct xpc_channel {
 	void *remote_msgqueue_base;	/* base address of kmalloc'd space */
 	struct xpc_msg *remote_msgqueue; /* cached copy of remote partition's */
 					 /* local message queue */
-	u64 remote_msgqueue_pa;	/* phys addr of remote partition's */
-				/* local message queue */
+	unsigned long remote_msgqueue_pa; /* phys addr of remote partition's */
+					  /* local message queue */
 
 	atomic_t references;	/* #of external references to queues */
 
@@ -491,12 +491,12 @@ xpc_any_msg_chctl_flags_set(union xpc_ch
  */
 
 struct xpc_partition_sn2 {
-	u64 remote_amos_page_pa;	/* phys addr of partition's amos page */
+	unsigned long remote_amos_page_pa; /* paddr of partition's amos page */
 	int activate_IRQ_nasid;	/* active partition's act/deact nasid */
 	int activate_IRQ_phys_cpuid;	/* active part's act/deact phys cpuid */
 
-	u64 remote_vars_pa;	/* phys addr of partition's vars */
-	u64 remote_vars_part_pa;	/* phys addr of partition's vars part */
+	unsigned long remote_vars_pa;	/* phys addr of partition's vars */
+	unsigned long remote_vars_part_pa; /* paddr of partition's vars part */
 	u8 remote_vars_version;	/* version# of partition's vars */
 
 	void *local_GPs_base;	/* base address of kmalloc'd space */
@@ -504,10 +504,10 @@ struct xpc_partition_sn2 {
 	void *remote_GPs_base;	/* base address of kmalloc'd space */
 	struct xpc_gp_sn2 *remote_GPs;	/* copy of remote partition's local */
 					/* Get/Put values */
-	u64 remote_GPs_pa;	/* phys address of remote partition's local */
-				/* Get/Put values */
+	unsigned long remote_GPs_pa; /* phys addr of remote partition's local */
+				     /* Get/Put values */
 
-	u64 remote_openclose_args_pa;	/* phys addr of remote's args */
+	unsigned long remote_openclose_args_pa;	/* phys addr of remote's args */
 
 	int notify_IRQ_nasid;	/* nasid of where to send notify IRQs */
 	int notify_IRQ_phys_cpuid;	/* CPUID of where to send notify IRQs */
@@ -529,7 +529,7 @@ struct xpc_partition {
 
 	u8 remote_rp_version;	/* version# of partition's rsvd pg */
 	unsigned long remote_rp_ts_jiffies; /* timestamp when rsvd pg setup */
-	u64 remote_rp_pa;	/* phys addr of partition's rsvd pg */
+	unsigned long remote_rp_pa;	/* phys addr of partition's rsvd pg */
 	u64 last_heartbeat;	/* HB at last read */
 	u32 activate_IRQ_rcvd;	/* IRQs since activation */
 	spinlock_t act_lock;	/* protect updating of act_state */
@@ -623,7 +623,8 @@ extern void xpc_activate_partition(struc
 extern void xpc_activate_kthreads(struct xpc_channel *, int);
 extern void xpc_create_kthreads(struct xpc_channel *, int, int);
 extern void xpc_disconnect_wait(int);
-extern enum xp_retval (*xpc_get_partition_rsvd_page_pa) (u64, u64 *, u64 *,
+extern enum xp_retval (*xpc_get_partition_rsvd_page_pa) (void *, u64 *,
+							 unsigned long *,
 							 size_t *);
 extern enum xp_retval (*xpc_rsvd_page_init) (struct xpc_rsvd_page *);
 extern void (*xpc_heartbeat_init) (void);
@@ -640,8 +641,8 @@ extern void (*xpc_notify_senders_of_disc
 extern void (*xpc_process_msg_chctl_flags) (struct xpc_partition *, int);
 extern int (*xpc_n_of_deliverable_msgs) (struct xpc_channel *);
 extern struct xpc_msg *(*xpc_get_deliverable_msg) (struct xpc_channel *);
-extern void (*xpc_request_partition_activation) (struct xpc_rsvd_page *, u64,
-						 int);
+extern void (*xpc_request_partition_activation) (struct xpc_rsvd_page *,
+						 unsigned long, int);
 extern void (*xpc_request_partition_reactivation) (struct xpc_partition *);
 extern void (*xpc_request_partition_deactivation) (struct xpc_partition *);
 extern void (*xpc_cancel_partition_deactivation_request) (
@@ -690,7 +691,8 @@ extern enum xp_retval xpc_mark_partition
 extern void xpc_mark_partition_inactive(struct xpc_partition *);
 extern void xpc_discovery(void);
 extern enum xp_retval xpc_get_remote_rp(int, unsigned long *,
-					struct xpc_rsvd_page *, u64 *);
+					struct xpc_rsvd_page *,
+					unsigned long *);
 extern void xpc_deactivate_partition(const int, struct xpc_partition *,
 				     enum xp_retval);
 extern enum xp_retval xpc_initiate_partid_to_nasids(short, void *);
diff -puN drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy drivers/misc/sgi-xp/xpc_channel.c
--- a/drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy
+++ a/drivers/misc/sgi-xp/xpc_channel.c
@@ -366,9 +366,8 @@ again:
 		dev_dbg(xpc_chan, "XPC_CHCTL_OPENREPLY (local_msgqueue_pa="
 			"0x%lx, local_nentries=%d, remote_nentries=%d) "
 			"received from partid=%d, channel=%d\n",
-			(unsigned long)args->local_msgqueue_pa,
-			args->local_nentries, args->remote_nentries,
-			ch->partid, ch->number);
+			args->local_msgqueue_pa, args->local_nentries,
+			args->remote_nentries, ch->partid, ch->number);
 
 		if (ch->flags & (XPC_C_DISCONNECTING | XPC_C_DISCONNECTED)) {
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -169,8 +169,9 @@ static struct notifier_block xpc_die_not
 	.notifier_call = xpc_system_die,
 };
 
-enum xp_retval (*xpc_get_partition_rsvd_page_pa) (u64 buf, u64 *cookie,
-						  u64 *paddr, size_t *len);
+enum xp_retval (*xpc_get_partition_rsvd_page_pa) (void *buf, u64 *cookie,
+						  unsigned long *rp_pa,
+						  size_t *len);
 enum xp_retval (*xpc_rsvd_page_init) (struct xpc_rsvd_page *rp);
 void (*xpc_heartbeat_init) (void);
 void (*xpc_heartbeat_exit) (void);
@@ -189,7 +190,8 @@ int (*xpc_n_of_deliverable_msgs) (struct
 struct xpc_msg *(*xpc_get_deliverable_msg) (struct xpc_channel *ch);
 
 void (*xpc_request_partition_activation) (struct xpc_rsvd_page *remote_rp,
-					  u64 remote_rp_pa, int nasid);
+					  unsigned long remote_rp_pa,
+					  int nasid);
 void (*xpc_request_partition_reactivation) (struct xpc_partition *part);
 void (*xpc_request_partition_deactivation) (struct xpc_partition *part);
 void (*xpc_cancel_partition_deactivation_request) (struct xpc_partition *part);
diff -puN drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy drivers/misc/sgi-xp/xpc_partition.c
--- a/drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy
+++ a/drivers/misc/sgi-xp/xpc_partition.c
@@ -60,15 +60,15 @@ xpc_kmalloc_cacheline_aligned(size_t siz
  * Given a nasid, get the physical address of the  partition's reserved page
  * for that nasid. This function returns 0 on any error.
  */
-static u64
+static unsigned long
 xpc_get_rsvd_page_pa(int nasid)
 {
 	enum xp_retval ret;
 	u64 cookie = 0;
-	u64 rp_pa = nasid;	/* seed with nasid */
+	unsigned long rp_pa = nasid;	/* seed with nasid */
 	size_t len = 0;
-	u64 buf = buf;
-	u64 buf_len = 0;
+	size_t buf_len = 0;
+	void *buf = buf;
 	void *buf_base = NULL;
 
 	while (1) {
@@ -78,7 +78,7 @@ xpc_get_rsvd_page_pa(int nasid)
 
 		dev_dbg(xpc_part, "SAL returned with ret=%d, cookie=0x%016lx, "
 			"address=0x%016lx, len=0x%016lx\n", ret,
-			(unsigned long)cookie, (unsigned long)rp_pa, len);
+			(unsigned long)cookie, rp_pa, len);
 
 		if (ret != xpNeedMoreInfo)
 			break;
@@ -87,19 +87,17 @@ xpc_get_rsvd_page_pa(int nasid)
 		if (L1_CACHE_ALIGN(len) > buf_len) {
 			kfree(buf_base);
 			buf_len = L1_CACHE_ALIGN(len);
-			buf = (u64)xpc_kmalloc_cacheline_aligned(buf_len,
-								 GFP_KERNEL,
-								 &buf_base);
+			buf = xpc_kmalloc_cacheline_aligned(buf_len, GFP_KERNEL,
+							    &buf_base);
 			if (buf_base == NULL) {
 				dev_err(xpc_part, "unable to kmalloc "
-					"len=0x%016lx\n",
-					(unsigned long)buf_len);
+					"len=0x%016lx\n", buf_len);
 				ret = xpNoMemory;
 				break;
 			}
 		}
 
-		ret = xp_remote_memcpy((void *)buf, (void *)rp_pa, buf_len);
+		ret = xp_remote_memcpy(xp_pa(buf), rp_pa, buf_len);
 		if (ret != xpSuccess) {
 			dev_dbg(xpc_part, "xp_remote_memcpy failed %d\n", ret);
 			break;
@@ -111,8 +109,7 @@ xpc_get_rsvd_page_pa(int nasid)
 	if (ret != xpSuccess)
 		rp_pa = 0;
 
-	dev_dbg(xpc_part, "reserved page at phys address 0x%016lx\n",
-		(unsigned long)rp_pa);
+	dev_dbg(xpc_part, "reserved page at phys address 0x%016lx\n", rp_pa);
 	return rp_pa;
 }
 
@@ -125,7 +122,7 @@ struct xpc_rsvd_page *
 xpc_setup_rsvd_page(void)
 {
 	struct xpc_rsvd_page *rp;
-	u64 rp_pa;
+	unsigned long rp_pa;
 	unsigned long new_ts_jiffies;
 
 	/* get the local reserved page's address */
@@ -193,7 +190,7 @@ xpc_setup_rsvd_page(void)
  */
 enum xp_retval
 xpc_get_remote_rp(int nasid, unsigned long *discovered_nasids,
-		  struct xpc_rsvd_page *remote_rp, u64 *remote_rp_pa)
+		  struct xpc_rsvd_page *remote_rp, unsigned long *remote_rp_pa)
 {
 	int l;
 	enum xp_retval ret;
@@ -205,7 +202,7 @@ xpc_get_remote_rp(int nasid, unsigned lo
 		return xpNoRsvdPageAddr;
 
 	/* pull over the reserved page header and part_nasids mask */
-	ret = xp_remote_memcpy(remote_rp, (void *)*remote_rp_pa,
+	ret = xp_remote_memcpy(xp_pa(remote_rp), *remote_rp_pa,
 			       XPC_RP_HEADER_SIZE + xpc_nasid_mask_nbytes);
 	if (ret != xpSuccess)
 		return ret;
@@ -389,7 +386,7 @@ xpc_discovery(void)
 {
 	void *remote_rp_base;
 	struct xpc_rsvd_page *remote_rp;
-	u64 remote_rp_pa;
+	unsigned long remote_rp_pa;
 	int region;
 	int region_size;
 	int max_regions;
@@ -500,7 +497,7 @@ enum xp_retval
 xpc_initiate_partid_to_nasids(short partid, void *nasid_mask)
 {
 	struct xpc_partition *part;
-	u64 part_nasid_pa;
+	unsigned long part_nasid_pa;
 
 	part = &xpc_partitions[partid];
 	if (part->remote_rp_pa == 0)
@@ -508,8 +505,8 @@ xpc_initiate_partid_to_nasids(short part
 
 	memset(nasid_mask, 0, xpc_nasid_mask_nbytes);
 
-	part_nasid_pa = (u64)XPC_RP_PART_NASIDS(part->remote_rp_pa);
+	part_nasid_pa = (unsigned long)XPC_RP_PART_NASIDS(part->remote_rp_pa);
 
-	return xp_remote_memcpy(nasid_mask, (void *)part_nasid_pa,
+	return xp_remote_memcpy(xp_pa(nasid_mask), part_nasid_pa,
 				xpc_nasid_mask_nbytes);
 }
diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -207,8 +207,8 @@ xpc_handle_activate_IRQ_sn2(int irq, voi
  * Flag the appropriate amo variable and send an IRQ to the specified node.
  */
 static void
-xpc_send_activate_IRQ_sn2(u64 amos_page_pa, int from_nasid, int to_nasid,
-			  int to_phys_cpuid)
+xpc_send_activate_IRQ_sn2(unsigned long amos_page_pa, int from_nasid,
+			  int to_nasid, int to_phys_cpuid)
 {
 	struct amo *amos = (struct amo *)__va(amos_page_pa +
 					      (XPC_ACTIVATE_IRQ_AMOS_SN2 *
@@ -404,7 +404,7 @@ xpc_send_chctl_openreply_sn2(struct xpc_
 
 	args->remote_nentries = ch->remote_nentries;
 	args->local_nentries = ch->local_nentries;
-	args->local_msgqueue_pa = __pa(ch->local_msgqueue);
+	args->local_msgqueue_pa = xp_pa(ch->local_msgqueue);
 	XPC_SEND_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_OPENREPLY, irq_flags);
 }
 
@@ -577,13 +577,13 @@ xpc_allow_amo_ops_shub_wars_1_1_sn2(void
 }
 
 static enum xp_retval
-xpc_get_partition_rsvd_page_pa_sn2(u64 buf, u64 *cookie, u64 *paddr,
+xpc_get_partition_rsvd_page_pa_sn2(void *buf, u64 *cookie, unsigned long *rp_pa,
 				   size_t *len)
 {
 	s64 status;
 	enum xp_retval ret;
 
-	status = sn_partition_reserved_page_pa(buf, cookie, paddr, len);
+	status = sn_partition_reserved_page_pa((u64)buf, cookie, rp_pa, len);
 	if (status == SALRET_OK)
 		ret = xpSuccess;
 	else if (status == SALRET_MORE_PASSES)
@@ -604,7 +604,7 @@ xpc_rsvd_page_init_sn2(struct xpc_rsvd_p
 
 	xpc_vars_sn2 = XPC_RP_VARS(rp);
 
-	rp->sn.vars_pa = __pa(xpc_vars_sn2);
+	rp->sn.vars_pa = xp_pa(xpc_vars_sn2);
 
 	/* vars_part array follows immediately after vars */
 	xpc_vars_part_sn2 = (struct xpc_vars_part_sn2 *)((u8 *)XPC_RP_VARS(rp) +
@@ -649,7 +649,7 @@ xpc_rsvd_page_init_sn2(struct xpc_rsvd_p
 	xpc_vars_sn2->version = XPC_V_VERSION;
 	xpc_vars_sn2->activate_IRQ_nasid = cpuid_to_nasid(0);
 	xpc_vars_sn2->activate_IRQ_phys_cpuid = cpu_physical_id(0);
-	xpc_vars_sn2->vars_part_pa = __pa(xpc_vars_part_sn2);
+	xpc_vars_sn2->vars_part_pa = xp_pa(xpc_vars_part_sn2);
 	xpc_vars_sn2->amos_page_pa = ia64_tpa((u64)amos_page);
 	xpc_vars_sn2->amos_page = amos_page;	/* save for next load of XPC */
 
@@ -734,8 +734,8 @@ xpc_check_remote_hb_sn2(void)
 		}
 
 		/* pull the remote_hb cache line */
-		ret = xp_remote_memcpy(remote_vars,
-				       (void *)part->sn.sn2.remote_vars_pa,
+		ret = xp_remote_memcpy(xp_pa(remote_vars),
+				       part->sn.sn2.remote_vars_pa,
 				       XPC_RP_VARS_SIZE);
 		if (ret != xpSuccess) {
 			XPC_DEACTIVATE_PARTITION(part, ret);
@@ -768,7 +768,8 @@ xpc_check_remote_hb_sn2(void)
  * assumed to be of size XPC_RP_VARS_SIZE.
  */
 static enum xp_retval
-xpc_get_remote_vars_sn2(u64 remote_vars_pa, struct xpc_vars_sn2 *remote_vars)
+xpc_get_remote_vars_sn2(unsigned long remote_vars_pa,
+			struct xpc_vars_sn2 *remote_vars)
 {
 	enum xp_retval ret;
 
@@ -776,7 +777,7 @@ xpc_get_remote_vars_sn2(u64 remote_vars_
 		return xpVarsNotSet;
 
 	/* pull over the cross partition variables */
-	ret = xp_remote_memcpy(remote_vars, (void *)remote_vars_pa,
+	ret = xp_remote_memcpy(xp_pa(remote_vars), remote_vars_pa,
 			       XPC_RP_VARS_SIZE);
 	if (ret != xpSuccess)
 		return ret;
@@ -791,7 +792,7 @@ xpc_get_remote_vars_sn2(u64 remote_vars_
 
 static void
 xpc_request_partition_activation_sn2(struct xpc_rsvd_page *remote_rp,
-				     u64 remote_rp_pa, int nasid)
+				     unsigned long remote_rp_pa, int nasid)
 {
 	xpc_send_local_activate_IRQ_sn2(nasid);
 }
@@ -883,7 +884,8 @@ xpc_partition_deactivation_requested_sn2
 static void
 xpc_update_partition_info_sn2(struct xpc_partition *part, u8 remote_rp_version,
 			      unsigned long *remote_rp_ts_jiffies,
-			      u64 remote_rp_pa, u64 remote_vars_pa,
+			      unsigned long remote_rp_pa,
+			      unsigned long remote_vars_pa,
 			      struct xpc_vars_sn2 *remote_vars)
 {
 	struct xpc_partition_sn2 *part_sn2 = &part->sn.sn2;
@@ -948,8 +950,8 @@ xpc_identify_activate_IRQ_req_sn2(int na
 {
 	struct xpc_rsvd_page *remote_rp;
 	struct xpc_vars_sn2 *remote_vars;
-	u64 remote_rp_pa;
-	u64 remote_vars_pa;
+	unsigned long remote_rp_pa;
+	unsigned long remote_vars_pa;
 	int remote_rp_version;
 	int reactivate = 0;
 	unsigned long remote_rp_ts_jiffies = 0;
@@ -1291,11 +1293,11 @@ xpc_setup_infrastructure_sn2(struct xpc_
 	 * The setting of the magic # indicates that these per partition
 	 * specific variables are ready to be used.
 	 */
-	xpc_vars_part_sn2[partid].GPs_pa = __pa(part_sn2->local_GPs);
+	xpc_vars_part_sn2[partid].GPs_pa = xp_pa(part_sn2->local_GPs);
 	xpc_vars_part_sn2[partid].openclose_args_pa =
-	    __pa(part->local_openclose_args);
+	    xp_pa(part->local_openclose_args);
 	xpc_vars_part_sn2[partid].chctl_amo_pa =
-	    __pa(part_sn2->local_chctl_amo_va);
+	    xp_pa(part_sn2->local_chctl_amo_va);
 	cpuid = raw_smp_processor_id();	/* any CPU in this partition will do */
 	xpc_vars_part_sn2[partid].notify_IRQ_nasid = cpuid_to_nasid(cpuid);
 	xpc_vars_part_sn2[partid].notify_IRQ_phys_cpuid =
@@ -1382,25 +1384,25 @@ xpc_teardown_infrastructure_sn2(struct x
  * Create a wrapper that hides the underlying mechanism for pulling a cacheline
  * (or multiple cachelines) from a remote partition.
  *
- * src must be a cacheline aligned physical address on the remote partition.
+ * src_pa must be a cacheline aligned physical address on the remote partition.
  * dst must be a cacheline aligned virtual address on this partition.
  * cnt must be cacheline sized
  */
 /* ??? Replace this function by call to xp_remote_memcpy() or bte_copy()? */
 static enum xp_retval
 xpc_pull_remote_cachelines_sn2(struct xpc_partition *part, void *dst,
-			       const void *src, size_t cnt)
+			       const unsigned long src_pa, size_t cnt)
 {
 	enum xp_retval ret;
 
-	DBUG_ON((u64)src != L1_CACHE_ALIGN((u64)src));
-	DBUG_ON((u64)dst != L1_CACHE_ALIGN((u64)dst));
+	DBUG_ON(src_pa != L1_CACHE_ALIGN(src_pa));
+	DBUG_ON((unsigned long)dst != L1_CACHE_ALIGN((unsigned long)dst));
 	DBUG_ON(cnt != L1_CACHE_ALIGN(cnt));
 
 	if (part->act_state == XPC_P_DEACTIVATING)
 		return part->reason;
 
-	ret = xp_remote_memcpy(dst, src, cnt);
+	ret = xp_remote_memcpy(xp_pa(dst), src_pa, cnt);
 	if (ret != xpSuccess) {
 		dev_dbg(xpc_chan, "xp_remote_memcpy() from partition %d failed,"
 			" ret=%d\n", XPC_PARTID(part), ret);
@@ -1420,7 +1422,8 @@ xpc_pull_remote_vars_part_sn2(struct xpc
 	struct xpc_vars_part_sn2 *pulled_entry_cacheline =
 	    (struct xpc_vars_part_sn2 *)L1_CACHE_ALIGN((u64)buffer);
 	struct xpc_vars_part_sn2 *pulled_entry;
-	u64 remote_entry_cacheline_pa, remote_entry_pa;
+	unsigned long remote_entry_cacheline_pa;
+	unsigned long remote_entry_pa;
 	short partid = XPC_PARTID(part);
 	enum xp_retval ret;
 
@@ -1440,7 +1443,7 @@ xpc_pull_remote_vars_part_sn2(struct xpc
 						    (L1_CACHE_BYTES - 1)));
 
 	ret = xpc_pull_remote_cachelines_sn2(part, pulled_entry_cacheline,
-					     (void *)remote_entry_cacheline_pa,
+					     remote_entry_cacheline_pa,
 					     L1_CACHE_BYTES);
 	if (ret != xpSuccess) {
 		dev_dbg(xpc_chan, "failed to pull XPC vars_part from "
@@ -1587,7 +1590,7 @@ xpc_get_chctl_all_flags_sn2(struct xpc_p
 	if (xpc_any_openclose_chctl_flags_set(&chctl)) {
 		ret = xpc_pull_remote_cachelines_sn2(part, part->
 						     remote_openclose_args,
-						     (void *)part_sn2->
+						     part_sn2->
 						     remote_openclose_args_pa,
 						     XPC_OPENCLOSE_ARGS_SIZE);
 		if (ret != xpSuccess) {
@@ -1604,7 +1607,7 @@ xpc_get_chctl_all_flags_sn2(struct xpc_p
 
 	if (xpc_any_msg_chctl_flags_set(&chctl)) {
 		ret = xpc_pull_remote_cachelines_sn2(part, part_sn2->remote_GPs,
-						(void *)part_sn2->remote_GPs_pa,
+						     part_sn2->remote_GPs_pa,
 						     XPC_GP_SIZE);
 		if (ret != xpSuccess) {
 			XPC_DEACTIVATE_PARTITION(part, ret);
@@ -1971,8 +1974,10 @@ xpc_pull_remote_msg_sn2(struct xpc_chann
 {
 	struct xpc_partition *part = &xpc_partitions[ch->partid];
 	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	struct xpc_msg *remote_msg, *msg;
-	u32 msg_index, nmsgs;
+	unsigned long remote_msg_pa;
+	struct xpc_msg *msg;
+	u32 msg_index;
+	u32 nmsgs;
 	u64 msg_offset;
 	enum xp_retval ret;
 
@@ -1996,10 +2001,9 @@ xpc_pull_remote_msg_sn2(struct xpc_chann
 
 		msg_offset = msg_index * ch->msg_size;
 		msg = (struct xpc_msg *)((u64)ch->remote_msgqueue + msg_offset);
-		remote_msg = (struct xpc_msg *)(ch->remote_msgqueue_pa +
-						msg_offset);
+		remote_msg_pa = ch->remote_msgqueue_pa + msg_offset;
 
-		ret = xpc_pull_remote_cachelines_sn2(part, msg, remote_msg,
+		ret = xpc_pull_remote_cachelines_sn2(part, msg, remote_msg_pa,
 						     nmsgs * ch->msg_size);
 		if (ret != xpSuccess) {
 
diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -61,7 +61,7 @@ xpc_heartbeat_exit_uv(void)
 
 static void
 xpc_request_partition_activation_uv(struct xpc_rsvd_page *remote_rp,
-				    u64 remote_rp_pa, int nasid)
+				    unsigned long remote_rp_pa, int nasid)
 {
 	short partid = remote_rp->SAL_partid;
 	struct xpc_partition *part = &xpc_partitions[partid];
diff -puN drivers/misc/sgi-xp/xpnet.c~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy drivers/misc/sgi-xp/xpnet.c
--- a/drivers/misc/sgi-xp/xpnet.c~sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy
+++ a/drivers/misc/sgi-xp/xpnet.c
@@ -44,7 +44,7 @@ struct xpnet_message {
 	u16 version;		/* Version for this message */
 	u16 embedded_bytes;	/* #of bytes embedded in XPC message */
 	u32 magic;		/* Special number indicating this is xpnet */
-	u64 buf_pa;		/* phys address of buffer to retrieve */
+	unsigned long buf_pa;	/* phys address of buffer to retrieve */
 	u32 size;		/* #of bytes in buffer */
 	u8 leadin_ignore;	/* #of bytes to ignore at the beginning */
 	u8 tailout_ignore;	/* #of bytes to ignore at the end */
@@ -152,6 +152,7 @@ static void
 xpnet_receive(short partid, int channel, struct xpnet_message *msg)
 {
 	struct sk_buff *skb;
+	void *dst;
 	enum xp_retval ret;
 	struct xpnet_dev_private *priv =
 	    (struct xpnet_dev_private *)xpnet_device->priv;
@@ -166,9 +167,8 @@ xpnet_receive(short partid, int channel,
 
 		return;
 	}
-	dev_dbg(xpnet, "received 0x%lx, %d, %d, %d\n",
-		(unsigned long)msg->buf_pa, msg->size, msg->leadin_ignore,
-		msg->tailout_ignore);
+	dev_dbg(xpnet, "received 0x%lx, %d, %d, %d\n", msg->buf_pa, msg->size,
+		msg->leadin_ignore, msg->tailout_ignore);
 
 	/* reserve an extra cache line */
 	skb = dev_alloc_skb(msg->size + L1_CACHE_BYTES);
@@ -210,15 +210,12 @@ xpnet_receive(short partid, int channel,
 		skb_copy_to_linear_data(skb, &msg->data,
 					(size_t)msg->embedded_bytes);
 	} else {
+		dst = (void *)((u64)skb->data & ~(L1_CACHE_BYTES - 1));
 		dev_dbg(xpnet, "transferring buffer to the skb->data area;\n\t"
-			"xp_remote_memcpy(0x%p, 0x%p, %hu)\n", (void *)
-				       ((u64)skb->data & ~(L1_CACHE_BYTES - 1)),
+			"xp_remote_memcpy(0x%p, 0x%p, %hu)\n", dst,
 					  (void *)msg->buf_pa, msg->size);
 
-		ret = xp_remote_memcpy((void *)((u64)skb->data &
-						~(L1_CACHE_BYTES - 1)),
-				       (void *)msg->buf_pa, msg->size);
-
+		ret = xp_remote_memcpy(xp_pa(dst), msg->buf_pa, msg->size);
 		if (ret != xpSuccess) {
 			/*
 			 * !!! Need better way of cleaning skb.  Currently skb
@@ -226,8 +223,7 @@ xpnet_receive(short partid, int channel,
 			 * !!! dev_kfree_skb.
 			 */
 			dev_err(xpnet, "xp_remote_memcpy(0x%p, 0x%p, 0x%hx) "
-				"returned error=0x%x\n", (void *)
-				((u64)skb->data & ~(L1_CACHE_BYTES - 1)),
+				"returned error=0x%x\n", dst,
 				(void *)msg->buf_pa, msg->size, ret);
 
 			xpc_received(partid, channel, (void *)msg);
@@ -428,13 +424,13 @@ xpnet_send(struct sk_buff *skb, struct x
 	msg->size = end_addr - start_addr;
 	msg->leadin_ignore = (u64)skb->data - start_addr;
 	msg->tailout_ignore = end_addr - (u64)skb_tail_pointer(skb);
-	msg->buf_pa = __pa(start_addr);
+	msg->buf_pa = xp_pa((void *)start_addr);
 
 	dev_dbg(xpnet, "sending XPC message to %d:%d\n"
 		KERN_DEBUG "msg->buf_pa=0x%lx, msg->size=%u, "
 		"msg->leadin_ignore=%u, msg->tailout_ignore=%u\n",
-		dest_partid, XPC_NET_CHANNEL, (unsigned long)msg->buf_pa,
-		msg->size, msg->leadin_ignore, msg->tailout_ignore);
+		dest_partid, XPC_NET_CHANNEL, msg->buf_pa, msg->size,
+		msg->leadin_ignore, msg->tailout_ignore);
 
 	atomic_inc(&queued_msg->use_count);
 
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
sgi-xp-enable-building-of-xpc-xpnet-on-x86_64.patch
sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy.patch
sgi-xp-move-xpc_check_remote_hb-to-support-both-sn2-and-uv.patch
sgi-xp-cleanup-naming-of-partition-defines.patch
sgi-xp-setup-the-activate-gru-message-queue.patch
sgi-xp-setup-the-notify-gru-message-queue.patch

