From: akpm@linux-foundation.org
Subject: - sgi-xp-create-a-common-xp_remote_memcpy-function.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:16:25 -0700
Message-ID: <200807301916.m6UJGPU8011124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752892AbYG3TRO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:17:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-xp: create a common xp_remote_memcpy() function
has been removed from the -mm tree.  Its filename was
     sgi-xp-create-a-common-xp_remote_memcpy-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp: create a common xp_remote_memcpy() function
From: Dean Nelson <dcn@sgi.com>

Create a common remote memcpy function that maps to what the hardware
booted supports.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xp.h            |   43 --------------------
 drivers/misc/sgi-xp/xp_main.c       |    3 +
 drivers/misc/sgi-xp/xp_sn2.c        |   46 +++++++++++++++++++++
 drivers/misc/sgi-xp/xp_uv.c         |   11 +++++
 drivers/misc/sgi-xp/xpc.h           |    7 ---
 drivers/misc/sgi-xp/xpc_channel.c   |   20 +++------
 drivers/misc/sgi-xp/xpc_partition.c |   55 +++++++++++---------------
 drivers/misc/sgi-xp/xpnet.c         |   30 ++++++--------
 8 files changed, 108 insertions(+), 107 deletions(-)

diff -puN drivers/misc/sgi-xp/xp.h~sgi-xp-create-a-common-xp_remote_memcpy-function drivers/misc/sgi-xp/xp.h
--- a/drivers/misc/sgi-xp/xp.h~sgi-xp-create-a-common-xp_remote_memcpy-function
+++ a/drivers/misc/sgi-xp/xp.h
@@ -17,7 +17,6 @@
 #include <linux/hardirq.h>
 #include <linux/mutex.h>
 #include <asm/sn/types.h>
-#include <asm/sn/bte.h>
 #ifdef CONFIG_IA64
 #include <asm/sn/arch.h>
 #endif
@@ -72,46 +71,6 @@
 #define XP_NASID_MASK_WORDS	((XP_MAX_PHYSNODE_ID + 63) / 64)
 
 /*
- * Wrapper for bte_copy() that should it return a failure status will retry
- * the bte_copy() once in the hope that the failure was due to a temporary
- * aberration (i.e., the link going down temporarily).
- *
- * 	src - physical address of the source of the transfer.
- *	vdst - virtual address of the destination of the transfer.
- *	len - number of bytes to transfer from source to destination.
- *	mode - see bte_copy() for definition.
- *	notification - see bte_copy() for definition.
- *
- * Note: xp_bte_copy() should never be called while holding a spinlock.
- */
-static inline bte_result_t
-xp_bte_copy(u64 src, u64 vdst, u64 len, u64 mode, void *notification)
-{
-	bte_result_t ret;
-	u64 pdst = ia64_tpa(vdst);
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
-
-	ret = bte_copy(src, pdst, len, mode, notification);
-	if ((ret != BTE_SUCCESS) && BTE_ERROR_RETRY(ret)) {
-		if (!in_interrupt())
-			cond_resched();
-
-		ret = bte_copy(src, pdst, len, mode, notification);
-	}
-
-	return ret;
-}
-
-/*
  * XPC establishes channel connections between the local partition and any
  * other partition that is currently up. Over these channels, kernel-level
  * `users' can communicate with their counterparts on the other partitions.
@@ -408,6 +367,8 @@ xpc_partid_to_nasids(short partid, void 
 
 extern short xp_max_npartitions;
 
+extern enum xp_retval (*xp_remote_memcpy) (void *, const void *, size_t);
+
 extern u64 xp_nofault_PIOR_target;
 extern int xp_nofault_PIOR(void *);
 extern int xp_error_PIOR(void);
diff -puN drivers/misc/sgi-xp/xp_main.c~sgi-xp-create-a-common-xp_remote_memcpy-function drivers/misc/sgi-xp/xp_main.c
--- a/drivers/misc/sgi-xp/xp_main.c~sgi-xp-create-a-common-xp_remote_memcpy-function
+++ a/drivers/misc/sgi-xp/xp_main.c
@@ -36,6 +36,9 @@ struct device *xp = &xp_dbg_subname;
 short xp_max_npartitions;
 EXPORT_SYMBOL_GPL(xp_max_npartitions);
 
+enum xp_retval (*xp_remote_memcpy) (void *dst, const void *src, size_t len);
+EXPORT_SYMBOL_GPL(xp_remote_memcpy);
+
 /*
  * xpc_registrations[] keeps track of xpc_connect()'s done by the kernel-level
  * users of XPC.
diff -puN drivers/misc/sgi-xp/xp_sn2.c~sgi-xp-create-a-common-xp_remote_memcpy-function drivers/misc/sgi-xp/xp_sn2.c
--- a/drivers/misc/sgi-xp/xp_sn2.c~sgi-xp-create-a-common-xp_remote_memcpy-function
+++ a/drivers/misc/sgi-xp/xp_sn2.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/device.h>
+#include <asm/sn/bte.h>
 #include <asm/sn/sn_sal.h>
 #include "xp.h"
 
@@ -72,6 +73,49 @@ xp_unregister_nofault_code_sn2(void)
 				       err_func_addr, 1, 0);
 }
 
+/*
+ * Wrapper for bte_copy().
+ *
+ *	vdst - virtual address of the destination of the transfer.
+ *	psrc - physical address of the source of the transfer.
+ *	len - number of bytes to transfer from source to destination.
+ *
+ * Note: xp_remote_memcpy_sn2() should never be called while holding a spinlock.
+ */
+static enum xp_retval
+xp_remote_memcpy_sn2(void *vdst, const void *psrc, size_t len)
+{
+	bte_result_t ret;
+	u64 pdst = ia64_tpa(vdst);
+	/* >>> What are the rules governing the src and dst addresses passed in?
+	 * >>> Currently we're assuming that dst is a virtual address and src
+	 * >>> is a physical address, is this appropriate? Can we allow them to
+	 * >>> be whatever and we make the change here without damaging the
+	 * >>> addresses?
+	 */
+
+	/*
+	 * Ensure that the physically mapped memory is contiguous.
+	 *
+	 * We do this by ensuring that the memory is from region 7 only.
+	 * If the need should arise to use memory from one of the other
+	 * regions, then modify the BUG_ON() statement to ensure that the
+	 * memory from that region is always physically contiguous.
+	 */
+	BUG_ON(REGION_NUMBER(vdst) != RGN_KERNEL);
+
+	ret = bte_copy((u64)psrc, pdst, len, (BTE_NOTIFY | BTE_WACQUIRE), NULL);
+	if (ret == BTE_SUCCESS)
+		return xpSuccess;
+
+	if (is_shub2())
+		dev_err(xp, "bte_copy() on shub2 failed, error=0x%x\n", ret);
+	else
+		dev_err(xp, "bte_copy() failed, error=%d\n", ret);
+
+	return xpBteCopyError;
+}
+
 enum xp_retval
 xp_init_sn2(void)
 {
@@ -79,6 +123,8 @@ xp_init_sn2(void)
 
 	xp_max_npartitions = XP_MAX_NPARTITIONS_SN2;
 
+	xp_remote_memcpy = xp_remote_memcpy_sn2;
+
 	return xp_register_nofault_code_sn2();
 }
 
diff -puN drivers/misc/sgi-xp/xp_uv.c~sgi-xp-create-a-common-xp_remote_memcpy-function drivers/misc/sgi-xp/xp_uv.c
--- a/drivers/misc/sgi-xp/xp_uv.c~sgi-xp-create-a-common-xp_remote_memcpy-function
+++ a/drivers/misc/sgi-xp/xp_uv.c
@@ -15,12 +15,23 @@
 
 #include "xp.h"
 
+static enum xp_retval
+xp_remote_memcpy_uv(void *vdst, const void *psrc, size_t len)
+{
+	/* >>> this function needs fleshing out */
+	return xpUnsupported;
+}
+
 enum xp_retval
 xp_init_uv(void)
 {
 	BUG_ON(!is_uv());
 
 	xp_max_npartitions = XP_MAX_NPARTITIONS_UV;
+
+	xp_remote_memcpy = xp_remote_memcpy_uv;
+
+	return xpSuccess;
 }
 
 void
diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xp-create-a-common-xp_remote_memcpy-function drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xp-create-a-common-xp_remote_memcpy-function
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -20,7 +20,6 @@
 #include <linux/completion.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
-#include <asm/sn/bte.h>
 #include <asm/sn/clksupport.h>
 #include <asm/sn/addrs.h>
 #include <asm/sn/mspec.h>
@@ -1125,12 +1124,6 @@ xpc_IPI_init(int index)
 	return amo;
 }
 
-static inline enum xp_retval
-xpc_map_bte_errors(bte_result_t error)
-{
-	return ((error == BTE_SUCCESS) ? xpSuccess : xpBteCopyError);
-}
-
 /*
  * Check to see if there is any channel activity to/from the specified
  * partition.
diff -puN drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-create-a-common-xp_remote_memcpy-function drivers/misc/sgi-xp/xpc_channel.c
--- a/drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-create-a-common-xp_remote_memcpy-function
+++ a/drivers/misc/sgi-xp/xpc_channel.c
@@ -21,7 +21,6 @@
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
 #include <linux/completion.h>
-#include <asm/sn/bte.h>
 #include <asm/sn/sn_sal.h>
 #include "xpc.h"
 
@@ -252,13 +251,13 @@ xpc_setup_infrastructure(struct xpc_part
  *
  * src must be a cacheline aligned physical address on the remote partition.
  * dst must be a cacheline aligned virtual address on this partition.
- * cnt must be an cacheline sized
+ * cnt must be cacheline sized
  */
 static enum xp_retval
 xpc_pull_remote_cachelines(struct xpc_partition *part, void *dst,
 			   const void *src, size_t cnt)
 {
-	bte_result_t bte_ret;
+	enum xp_retval ret;
 
 	DBUG_ON((u64)src != L1_CACHE_ALIGN((u64)src));
 	DBUG_ON((u64)dst != L1_CACHE_ALIGN((u64)dst));
@@ -267,15 +266,12 @@ xpc_pull_remote_cachelines(struct xpc_pa
 	if (part->act_state == XPC_P_DEACTIVATING)
 		return part->reason;
 
-	bte_ret = xp_bte_copy((u64)src, (u64)dst, (u64)cnt,
-			      (BTE_NORMAL | BTE_WACQUIRE), NULL);
-	if (bte_ret == BTE_SUCCESS)
-		return xpSuccess;
-
-	dev_dbg(xpc_chan, "xp_bte_copy() from partition %d failed, ret=%d\n",
-		XPC_PARTID(part), bte_ret);
-
-	return xpc_map_bte_errors(bte_ret);
+	ret = xp_remote_memcpy(dst, src, cnt);
+	if (ret != xpSuccess) {
+		dev_dbg(xpc_chan, "xp_remote_memcpy() from partition %d failed,"
+			" ret=%d\n", XPC_PARTID(part), ret);
+	}
+	return ret;
 }
 
 /*
diff -puN drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-create-a-common-xp_remote_memcpy-function drivers/misc/sgi-xp/xpc_partition.c
--- a/drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-create-a-common-xp_remote_memcpy-function
+++ a/drivers/misc/sgi-xp/xpc_partition.c
@@ -21,7 +21,6 @@
 #include <linux/mmzone.h>
 #include <linux/nodemask.h>
 #include <asm/uncached.h>
-#include <asm/sn/bte.h>
 #include <asm/sn/intr.h>
 #include <asm/sn/sn_sal.h>
 #include <asm/sn/nodepda.h>
@@ -92,7 +91,7 @@ xpc_kmalloc_cacheline_aligned(size_t siz
 static u64
 xpc_get_rsvd_page_pa(int nasid)
 {
-	bte_result_t bte_res;
+	enum xp_retval ret;
 	s64 status;
 	u64 cookie = 0;
 	u64 rp_pa = nasid;	/* seed with nasid */
@@ -113,6 +112,7 @@ xpc_get_rsvd_page_pa(int nasid)
 		if (status != SALRET_MORE_PASSES)
 			break;
 
+		/* >>> L1_CACHE_ALIGN() is only a sn2-bte_copy requirement */
 		if (L1_CACHE_ALIGN(len) > buf_len) {
 			kfree(buf_base);
 			buf_len = L1_CACHE_ALIGN(len);
@@ -127,10 +127,9 @@ xpc_get_rsvd_page_pa(int nasid)
 			}
 		}
 
-		bte_res = xp_bte_copy(rp_pa, buf, buf_len,
-				      (BTE_NOTIFY | BTE_WACQUIRE), NULL);
-		if (bte_res != BTE_SUCCESS) {
-			dev_dbg(xpc_part, "xp_bte_copy failed %i\n", bte_res);
+		ret = xp_remote_memcpy((void *)buf, (void *)rp_pa, buf_len);
+		if (ret != xpSuccess) {
+			dev_dbg(xpc_part, "xp_remote_memcpy failed %d\n", ret);
 			status = SALRET_ERROR;
 			break;
 		}
@@ -398,7 +397,7 @@ xpc_check_remote_hb(void)
 	struct xpc_vars *remote_vars;
 	struct xpc_partition *part;
 	short partid;
-	bte_result_t bres;
+	enum xp_retval ret;
 
 	remote_vars = (struct xpc_vars *)xpc_remote_copy_buffer;
 
@@ -418,13 +417,11 @@ xpc_check_remote_hb(void)
 		}
 
 		/* pull the remote_hb cache line */
-		bres = xp_bte_copy(part->remote_vars_pa,
-				   (u64)remote_vars,
-				   XPC_RP_VARS_SIZE,
-				   (BTE_NOTIFY | BTE_WACQUIRE), NULL);
-		if (bres != BTE_SUCCESS) {
-			XPC_DEACTIVATE_PARTITION(part,
-						 xpc_map_bte_errors(bres));
+		ret = xp_remote_memcpy(remote_vars,
+				       (void *)part->remote_vars_pa,
+				       XPC_RP_VARS_SIZE);
+		if (ret != xpSuccess) {
+			XPC_DEACTIVATE_PARTITION(part, ret);
 			continue;
 		}
 
@@ -457,7 +454,8 @@ static enum xp_retval
 xpc_get_remote_rp(int nasid, u64 *discovered_nasids,
 		  struct xpc_rsvd_page *remote_rp, u64 *remote_rp_pa)
 {
-	int bres, i;
+	int i;
+	enum xp_retval ret;
 
 	/* get the reserved page's physical address */
 
@@ -466,11 +464,10 @@ xpc_get_remote_rp(int nasid, u64 *discov
 		return xpNoRsvdPageAddr;
 
 	/* pull over the reserved page header and part_nasids mask */
-	bres = xp_bte_copy(*remote_rp_pa, (u64)remote_rp,
-			   XPC_RP_HEADER_SIZE + xp_nasid_mask_bytes,
-			   (BTE_NOTIFY | BTE_WACQUIRE), NULL);
-	if (bres != BTE_SUCCESS)
-		return xpc_map_bte_errors(bres);
+	ret = xp_remote_memcpy(remote_rp, (void *)*remote_rp_pa,
+			       XPC_RP_HEADER_SIZE + xp_nasid_mask_bytes);
+	if (ret != xpSuccess)
+		return ret;
 
 	if (discovered_nasids != NULL) {
 		u64 *remote_part_nasids = XPC_RP_PART_NASIDS(remote_rp);
@@ -504,16 +501,16 @@ xpc_get_remote_rp(int nasid, u64 *discov
 static enum xp_retval
 xpc_get_remote_vars(u64 remote_vars_pa, struct xpc_vars *remote_vars)
 {
-	int bres;
+	enum xp_retval ret;
 
 	if (remote_vars_pa == 0)
 		return xpVarsNotSet;
 
 	/* pull over the cross partition variables */
-	bres = xp_bte_copy(remote_vars_pa, (u64)remote_vars, XPC_RP_VARS_SIZE,
-			   (BTE_NOTIFY | BTE_WACQUIRE), NULL);
-	if (bres != BTE_SUCCESS)
-		return xpc_map_bte_errors(bres);
+	ret = xp_remote_memcpy(remote_vars, (void *)remote_vars_pa,
+			       XPC_RP_VARS_SIZE);
+	if (ret != xpSuccess)
+		return ret;
 
 	if (XPC_VERSION_MAJOR(remote_vars->version) !=
 	    XPC_VERSION_MAJOR(XPC_V_VERSION)) {
@@ -1148,7 +1145,6 @@ xpc_initiate_partid_to_nasids(short part
 {
 	struct xpc_partition *part;
 	u64 part_nasid_pa;
-	int bte_res;
 
 	part = &xpc_partitions[partid];
 	if (part->remote_rp_pa == 0)
@@ -1158,9 +1154,6 @@ xpc_initiate_partid_to_nasids(short part
 
 	part_nasid_pa = (u64)XPC_RP_PART_NASIDS(part->remote_rp_pa);
 
-	bte_res = xp_bte_copy(part_nasid_pa, (u64)nasid_mask,
-			      xp_nasid_mask_bytes, (BTE_NOTIFY | BTE_WACQUIRE),
-			      NULL);
-
-	return xpc_map_bte_errors(bte_res);
+	return xp_remote_memcpy(nasid_mask, (void *)part_nasid_pa,
+				xp_nasid_mask_bytes);
 }
diff -puN drivers/misc/sgi-xp/xpnet.c~sgi-xp-create-a-common-xp_remote_memcpy-function drivers/misc/sgi-xp/xpnet.c
--- a/drivers/misc/sgi-xp/xpnet.c~sgi-xp-create-a-common-xp_remote_memcpy-function
+++ a/drivers/misc/sgi-xp/xpnet.c
@@ -32,7 +32,6 @@
 #include <linux/mii.h>
 #include <linux/smp.h>
 #include <linux/string.h>
-#include <asm/sn/bte.h>
 #include <asm/sn/io.h>
 #include <asm/sn/sn_sal.h>
 #include <asm/atomic.h>
@@ -169,7 +168,7 @@ static void
 xpnet_receive(short partid, int channel, struct xpnet_message *msg)
 {
 	struct sk_buff *skb;
-	bte_result_t bret;
+	enum xp_retval ret;
 	struct xpnet_dev_private *priv =
 	    (struct xpnet_dev_private *)xpnet_device->priv;
 
@@ -201,7 +200,7 @@ xpnet_receive(short partid, int channel,
 
 	/*
 	 * The allocated skb has some reserved space.
-	 * In order to use bte_copy, we need to get the
+	 * In order to use xp_remote_memcpy(), we need to get the
 	 * skb->data pointer moved forward.
 	 */
 	skb_reserve(skb, (L1_CACHE_BYTES - ((u64)skb->data &
@@ -227,25 +226,24 @@ xpnet_receive(short partid, int channel,
 					(size_t)msg->embedded_bytes);
 	} else {
 		dev_dbg(xpnet, "transferring buffer to the skb->data area;\n\t"
-			"bte_copy(0x%p, 0x%p, %hu)\n", (void *)msg->buf_pa,
-			(void *)__pa((u64)skb->data & ~(L1_CACHE_BYTES - 1)),
-			msg->size);
-
-		bret = bte_copy(msg->buf_pa,
-				__pa((u64)skb->data & ~(L1_CACHE_BYTES - 1)),
-				msg->size, (BTE_NOTIFY | BTE_WACQUIRE), NULL);
+			"xp_remote_memcpy(0x%p, 0x%p, %hu)\n", (void *)
+				       ((u64)skb->data & ~(L1_CACHE_BYTES - 1)),
+					  (void *)msg->buf_pa, msg->size);
+
+		ret = xp_remote_memcpy((void *)((u64)skb->data &
+				                ~(L1_CACHE_BYTES - 1)),
+				       (void *)msg->buf_pa, msg->size);
 
-		if (bret != BTE_SUCCESS) {
+		if (ret != xpSuccess) {
 			/*
 			 * >>> Need better way of cleaning skb.  Currently skb
 			 * >>> appears in_use and we can't just call
 			 * >>> dev_kfree_skb.
 			 */
-			dev_err(xpnet, "bte_copy(0x%p, 0x%p, 0x%hx) returned "
-				"error=0x%x\n", (void *)msg->buf_pa,
-				(void *)__pa((u64)skb->data &
-					     ~(L1_CACHE_BYTES - 1)),
-				msg->size, bret);
+			dev_err(xpnet, "xp_remote_memcpy(0x%p, 0x%p, 0x%hx) "
+				"returned error=0x%x\n", (void *)
+				((u64)skb->data & ~(L1_CACHE_BYTES - 1)),
+				(void *)msg->buf_pa, msg->size, ret);
 
 			xpc_received(partid, channel, (void *)msg);
 
_

Patches currently in -mm which might be from dcn@sgi.com are

origin.patch

