From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 113/128] mm: switch the test_vmalloc module to use
 __vmalloc_node
Date: Mon, 01 Jun 2020 21:51:57 -0700
Message-ID: <20200602045157.Befdx_43r%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgFBEwA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:52:00 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, akpm@linux-foundation.org, benh@kernel.crashing.org, borntraeger@de.ibm.com, catalin.marinas@arm.com, christophe.leroy@c-s.fr, daniel.vetter@ffwll.ch, daniel@ffwll.ch, gor@linux.ibm.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, hannes@cmpxchg.org, hch@lst.de, heiko.carstens@de.ibm.com, kys@microsoft.com, labbott@redhat.com, linux-mm@kvack.org, mark.rutland@arm.com, mikelley@microsoft.com, minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org, paulus@ozlabs.org, peterz@infradead.org, robin.murphy@arm.com, sakari.ailus@linux.intel.com, sthemmin@microsoft.com, sumit.semwal@linaro.org, torvalds@linux-foundation.org, wei.liu@kernel.org, will@kernel.org, xiang@kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: mm: switch the test_vmalloc module to use __vmalloc_node

No need to export the very low-level __vmalloc_node_range when the test
module can use a slightly higher level variant.

[akpm@linux-foundation.org: add missing `node' arg]
[akpm@linux-foundation.org: fix riscv nommu build]
Link: http://lkml.kernel.org/r/20200414131348.444715-26-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Kelley <mikelley@microsoft.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/pgtable.h |    4 ++--
 lib/test_vmalloc.c               |   26 +++++++-------------------
 mm/vmalloc.c                     |   17 ++++++++---------
 3 files changed, 17 insertions(+), 30 deletions(-)

--- a/arch/riscv/include/asm/pgtable.h~mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node
+++ a/arch/riscv/include/asm/pgtable.h
@@ -473,9 +473,9 @@ static inline int ptep_clear_flush_young
 #define PAGE_SHARED		__pgprot(0)
 #define PAGE_KERNEL		__pgprot(0)
 #define swapper_pg_dir		NULL
+#define TASK_SIZE		0xffffffffUL
 #define VMALLOC_START		0
-
-#define TASK_SIZE 0xffffffffUL
+#define VMALLOC_END		TASK_SIZE
 
 static inline void __kernel_map_pages(struct page *page, int numpages, int enable) {}
 
--- a/lib/test_vmalloc.c~mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node
+++ a/lib/test_vmalloc.c
@@ -91,12 +91,8 @@ static int random_size_align_alloc_test(
 		 */
 		size = ((rnd % 10) + 1) * PAGE_SIZE;
 
-		ptr = __vmalloc_node_range(size, align,
-		   VMALLOC_START, VMALLOC_END,
-		   GFP_KERNEL | __GFP_ZERO,
-		   PAGE_KERNEL,
-		   0, 0, __builtin_return_address(0));
-
+		ptr = __vmalloc_node(size, align, GFP_KERNEL | __GFP_ZERO, 0,
+				__builtin_return_address(0));
 		if (!ptr)
 			return -1;
 
@@ -118,12 +114,8 @@ static int align_shift_alloc_test(void)
 	for (i = 0; i < BITS_PER_LONG; i++) {
 		align = ((unsigned long) 1) << i;
 
-		ptr = __vmalloc_node_range(PAGE_SIZE, align,
-			VMALLOC_START, VMALLOC_END,
-			GFP_KERNEL | __GFP_ZERO,
-			PAGE_KERNEL,
-			0, 0, __builtin_return_address(0));
-
+		ptr = __vmalloc_node(PAGE_SIZE, align, GFP_KERNEL|__GFP_ZERO, 0,
+				__builtin_return_address(0));
 		if (!ptr)
 			return -1;
 
@@ -139,13 +131,9 @@ static int fix_align_alloc_test(void)
 	int i;
 
 	for (i = 0; i < test_loop_count; i++) {
-		ptr = __vmalloc_node_range(5 * PAGE_SIZE,
-			THREAD_ALIGN << 1,
-			VMALLOC_START, VMALLOC_END,
-			GFP_KERNEL | __GFP_ZERO,
-			PAGE_KERNEL,
-			0, 0, __builtin_return_address(0));
-
+		ptr = __vmalloc_node(5 * PAGE_SIZE, THREAD_ALIGN << 1,
+				GFP_KERNEL | __GFP_ZERO, 0,
+				__builtin_return_address(0));
 		if (!ptr)
 			return -1;
 
--- a/mm/vmalloc.c~mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node
+++ a/mm/vmalloc.c
@@ -2523,15 +2523,6 @@ fail:
 	return NULL;
 }
 
-/*
- * This is only for performance analysis of vmalloc and stress purpose.
- * It is required by vmalloc test module, therefore do not use it other
- * than that.
- */
-#ifdef CONFIG_TEST_VMALLOC_MODULE
-EXPORT_SYMBOL_GPL(__vmalloc_node_range);
-#endif
