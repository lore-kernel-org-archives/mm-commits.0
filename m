From: akpm@linux-foundation.org
Subject: [merged] x86-uv-update-xpc-to-handle-updated-bios-interface.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:39:54 -0800
Message-ID: <200912162039.nBGKdsou013567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965000AbZLPUkI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, mingo@elte.hu, steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     x86: uv: update XPC to handle updated BIOS interface
has been removed from the -mm tree.  Its filename was
     x86-uv-update-xpc-to-handle-updated-bios-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: uv: update XPC to handle updated BIOS interface
From: Robin Holt <holt@sgi.com>

The UV BIOS has moved the location of some of their pointers to the
"partition reserved page" from memory into a uv hub MMR.  The GRU does not
support bcopy operations from MMR space so we need to special case the MMR
addresses using VLOAD operations.

Additionally, the BIOS call for registering a message queue watchlist has
removed the 'blade' value and eliminated the structure that was being
passed in.  This is also reflected in this patch.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uv/bios.h      |   11 ----------
 arch/x86/kernel/bios_uv.c           |    8 +------
 drivers/misc/sgi-xp/xp_uv.c         |   23 ++++++++++++++++++++++
 drivers/misc/sgi-xp/xpc_partition.c |   13 ++++++++----
 drivers/misc/sgi-xp/xpc_uv.c        |   27 ++++++++++++++------------
 5 files changed, 50 insertions(+), 32 deletions(-)

diff -puN arch/x86/include/asm/uv/bios.h~x86-uv-update-xpc-to-handle-updated-bios-interface arch/x86/include/asm/uv/bios.h
--- a/arch/x86/include/asm/uv/bios.h~x86-uv-update-xpc-to-handle-updated-bios-interface
+++ a/arch/x86/include/asm/uv/bios.h
@@ -76,15 +76,6 @@ union partition_info_u {
 	};
 };
 
-union uv_watchlist_u {
-	u64	val;
-	struct {
-		u64	blade	: 16,
-			size	: 32,
-			filler	: 16;
-	};
-};
-
 enum uv_memprotect {
 	UV_MEMPROT_RESTRICT_ACCESS,
 	UV_MEMPROT_ALLOW_AMO,
@@ -100,7 +91,7 @@ extern s64 uv_bios_call_reentrant(enum u
 
 extern s64 uv_bios_get_sn_info(int, int *, long *, long *, long *);
 extern s64 uv_bios_freq_base(u64, u64 *);
-extern int uv_bios_mq_watchlist_alloc(int, unsigned long, unsigned int,
+extern int uv_bios_mq_watchlist_alloc(unsigned long, unsigned int,
 					unsigned long *);
 extern int uv_bios_mq_watchlist_free(int, int);
 extern s64 uv_bios_change_memprotect(u64, u64, enum uv_memprotect);
diff -puN arch/x86/kernel/bios_uv.c~x86-uv-update-xpc-to-handle-updated-bios-interface arch/x86/kernel/bios_uv.c
--- a/arch/x86/kernel/bios_uv.c~x86-uv-update-xpc-to-handle-updated-bios-interface
+++ a/arch/x86/kernel/bios_uv.c
@@ -101,21 +101,17 @@ s64 uv_bios_get_sn_info(int fc, int *uvt
 }
 
 int
-uv_bios_mq_watchlist_alloc(int blade, unsigned long addr, unsigned int mq_size,
+uv_bios_mq_watchlist_alloc(unsigned long addr, unsigned int mq_size,
 			   unsigned long *intr_mmr_offset)
 {
-	union uv_watchlist_u size_blade;
 	u64 watchlist;
 	s64 ret;
 
-	size_blade.size = mq_size;
-	size_blade.blade = blade;
-
 	/*
 	 * bios returns watchlist number or negative error number.
 	 */
 	ret = (int)uv_bios_call_irqsave(UV_BIOS_WATCHLIST_ALLOC, addr,
-			size_blade.val, (u64)intr_mmr_offset,
+			mq_size, (u64)intr_mmr_offset,
 			(u64)&watchlist, 0);
 	if (ret < BIOS_STATUS_SUCCESS)
 		return ret;
diff -puN drivers/misc/sgi-xp/xp_uv.c~x86-uv-update-xpc-to-handle-updated-bios-interface drivers/misc/sgi-xp/xp_uv.c
--- a/drivers/misc/sgi-xp/xp_uv.c~x86-uv-update-xpc-to-handle-updated-bios-interface
+++ a/drivers/misc/sgi-xp/xp_uv.c
@@ -42,11 +42,34 @@ xp_socket_pa_uv(unsigned long gpa)
 }
 
 static enum xp_retval
+xp_remote_mmr_read(unsigned long dst_gpa, const unsigned long src_gpa,
+		   size_t len)
+{
+	int ret;
+	unsigned long *dst_va = __va(uv_gpa_to_soc_phys_ram(dst_gpa));
+
+	BUG_ON(!uv_gpa_in_mmr_space(src_gpa));
+	BUG_ON(len != 8);
+
+	ret = gru_read_gpa(dst_va, src_gpa);
+	if (ret == 0)
+		return xpSuccess;
+
+	dev_err(xp, "gru_read_gpa() failed, dst_gpa=0x%016lx src_gpa=0x%016lx "
+		"len=%ld\n", dst_gpa, src_gpa, len);
+	return xpGruCopyError;
+}
+
+
+static enum xp_retval
 xp_remote_memcpy_uv(unsigned long dst_gpa, const unsigned long src_gpa,
 		    size_t len)
 {
 	int ret;
 
+	if (uv_gpa_in_mmr_space(src_gpa))
+		return xp_remote_mmr_read(dst_gpa, src_gpa, len);
+
 	ret = gru_copy_gpa(dst_gpa, src_gpa, len);
 	if (ret == 0)
 		return xpSuccess;
diff -puN drivers/misc/sgi-xp/xpc_partition.c~x86-uv-update-xpc-to-handle-updated-bios-interface drivers/misc/sgi-xp/xpc_partition.c
--- a/drivers/misc/sgi-xp/xpc_partition.c~x86-uv-update-xpc-to-handle-updated-bios-interface
+++ a/drivers/misc/sgi-xp/xpc_partition.c
@@ -18,6 +18,7 @@
 #include <linux/device.h>
 #include <linux/hardirq.h>
 #include "xpc.h"
+#include <asm/uv/uv_hub.h>
 
 /* XPC is exiting flag */
 int xpc_exiting;
@@ -92,8 +93,12 @@ xpc_get_rsvd_page_pa(int nasid)
 			break;
 
 		/* !!! L1_CACHE_ALIGN() is only a sn2-bte_copy requirement */
-		if (L1_CACHE_ALIGN(len) > buf_len) {
-			kfree(buf_base);
+		if (is_shub())
+			len = L1_CACHE_ALIGN(len);
+
+		if (len > buf_len) {
+			if (buf_base != NULL)
+				kfree(buf_base);
 			buf_len = L1_CACHE_ALIGN(len);
 			buf = xpc_kmalloc_cacheline_aligned(buf_len, GFP_KERNEL,
 							    &buf_base);
@@ -105,7 +110,7 @@ xpc_get_rsvd_page_pa(int nasid)
 			}
 		}
 
-		ret = xp_remote_memcpy(xp_pa(buf), rp_pa, buf_len);
+		ret = xp_remote_memcpy(xp_pa(buf), rp_pa, len);
 		if (ret != xpSuccess) {
 			dev_dbg(xpc_part, "xp_remote_memcpy failed %d\n", ret);
 			break;
@@ -143,7 +148,7 @@ xpc_setup_rsvd_page(void)
 		dev_err(xpc_part, "SAL failed to locate the reserved page\n");
 		return -ESRCH;
 	}
-	rp = (struct xpc_rsvd_page *)__va(rp_pa);
+	rp = (struct xpc_rsvd_page *)__va(xp_socket_pa(rp_pa));
 
 	if (rp->SAL_version < 3) {
 		/* SAL_versions < 3 had a SAL_partid defined as a u8 */
diff -puN drivers/misc/sgi-xp/xpc_uv.c~x86-uv-update-xpc-to-handle-updated-bios-interface drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~x86-uv-update-xpc-to-handle-updated-bios-interface
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -157,22 +157,24 @@ xpc_gru_mq_watchlist_alloc_uv(struct xpc
 {
 	int ret;
 
-#if defined CONFIG_X86_64
-	ret = uv_bios_mq_watchlist_alloc(mq->mmr_blade, uv_gpa(mq->address),
-					 mq->order, &mq->mmr_offset);
-	if (ret < 0) {
-		dev_err(xpc_part, "uv_bios_mq_watchlist_alloc() failed, "
-			"ret=%d\n", ret);
-		return ret;
-	}
-#elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
-	ret = sn_mq_watchlist_alloc(mq->mmr_blade, (void *)uv_gpa(mq->address),
+#if defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
+	int mmr_pnode = uv_blade_to_pnode(mq->mmr_blade);
+
+	ret = sn_mq_watchlist_alloc(mmr_pnode, (void *)uv_gpa(mq->address),
 				    mq->order, &mq->mmr_offset);
 	if (ret < 0) {
 		dev_err(xpc_part, "sn_mq_watchlist_alloc() failed, ret=%d\n",
 			ret);
 		return -EBUSY;
 	}
+#elif defined CONFIG_X86_64
+	ret = uv_bios_mq_watchlist_alloc(uv_gpa(mq->address),
+					 mq->order, &mq->mmr_offset);
+	if (ret < 0) {
+		dev_err(xpc_part, "uv_bios_mq_watchlist_alloc() failed, "
+			"ret=%d\n", ret);
+		return ret;
+	}
 #else
 	#error not a supported configuration
 #endif
@@ -185,12 +187,13 @@ static void
 xpc_gru_mq_watchlist_free_uv(struct xpc_gru_mq_uv *mq)
 {
 	int ret;
+	int mmr_pnode = uv_blade_to_pnode(mq->mmr_blade);
 
 #if defined CONFIG_X86_64
-	ret = uv_bios_mq_watchlist_free(mq->mmr_blade, mq->watchlist_num);
+	ret = uv_bios_mq_watchlist_free(mmr_pnode, mq->watchlist_num);
 	BUG_ON(ret != BIOS_STATUS_SUCCESS);
 #elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
-	ret = sn_mq_watchlist_free(mq->mmr_blade, mq->watchlist_num);
+	ret = sn_mq_watchlist_free(mmr_pnode, mq->watchlist_num);
 	BUG_ON(ret != SALRET_OK);
 #else
 	#error not a supported configuration
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch

