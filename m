From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 110/128] mm: remove the prot argument to
 __vmalloc_node
Date: Mon, 01 Jun 2020 21:51:45 -0700
Message-ID: <20200602045145.ZD2KLzf3o%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgFBEvr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:51:47 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, akpm@linux-foundation.org, benh@kernel.crashing.org, borntraeger@de.ibm.com, catalin.marinas@arm.com, christophe.leroy@c-s.fr, daniel.vetter@ffwll.ch, daniel@ffwll.ch, gor@linux.ibm.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, hannes@cmpxchg.org, hch@lst.de, heiko.carstens@de.ibm.com, kys@microsoft.com, labbott@redhat.com, linux-mm@kvack.org, mark.rutland@arm.com, mikelley@microsoft.com, minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org, paulus@ozlabs.org, peterz@infradead.org, robin.murphy@arm.com, sakari.ailus@linux.intel.com, sthemmin@microsoft.com, sumit.semwal@linaro.org, torvalds@linux-foundation.org, wei.liu@kernel.org, will@kernel.org, xiang@kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove the prot argument to __vmalloc_node

This is always PAGE_KERNEL now.

Link: http://lkml.kernel.org/r/20200414131348.444715-23-hch@lst.de
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

 mm/vmalloc.c |   35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

--- a/mm/vmalloc.c~mm-remove-the-prot-argument-to-__vmalloc_node
+++ a/mm/vmalloc.c
@@ -2402,8 +2402,7 @@ void *vmap(struct page **pages, unsigned
 EXPORT_SYMBOL(vmap);
 
 static void *__vmalloc_node(unsigned long size, unsigned long align,
-			    gfp_t gfp_mask, pgprot_t prot,
-			    int node, const void *caller);
+			    gfp_t gfp_mask, int node, const void *caller);
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, int node)
 {
@@ -2421,7 +2420,7 @@ static void *__vmalloc_area_node(struct
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
 		pages = __vmalloc_node(array_size, 1, nested_gfp|highmem_mask,
-				PAGE_KERNEL, node, area->caller);
+				node, area->caller);
 	} else {
 		pages = kmalloc_node(array_size, nested_gfp, node);
 	}
@@ -2540,13 +2539,11 @@ EXPORT_SYMBOL_GPL(__vmalloc_node_range);
  * @size:	    allocation size
  * @align:	    desired alignment
  * @gfp_mask:	    flags for the page level allocator
- * @prot:	    protection mask for the allocated pages
  * @node:	    node to use for allocation or NUMA_NO_NODE
  * @caller:	    caller's return address
  *
- * Allocate enough pages to cover @size from the page level
- * allocator with @gfp_mask flags.  Map them into contiguous
- * kernel virtual space, using a pagetable protection of @prot.
+ * Allocate enough pages to cover @size from the page level allocator with
+ * @gfp_mask flags.  Map them into contiguous kernel virtual space.
  *
  * Reclaim modifiers in @gfp_mask - __GFP_NORETRY, __GFP_RETRY_MAYFAIL
  * and __GFP_NOFAIL are not supported
@@ -2557,16 +2554,15 @@ EXPORT_SYMBOL_GPL(__vmalloc_node_range);
  * Return: pointer to the allocated memory or %NULL on error
  */
 static void *__vmalloc_node(unsigned long size, unsigned long align,
-			    gfp_t gfp_mask, pgprot_t prot,
-			    int node, const void *caller)
+			    gfp_t gfp_mask, int node, const void *caller)
 {
 	return __vmalloc_node_range(size, align, VMALLOC_START, VMALLOC_END,
-				gfp_mask, prot, 0, node, caller);
+				gfp_mask, PAGE_KERNEL, 0, node, caller);
 }
 
 void *__vmalloc(unsigned long size, gfp_t gfp_mask)
 {
-	return __vmalloc_node(size, 1, gfp_mask, PAGE_KERNEL, NUMA_NO_NODE,
+	return __vmalloc_node(size, 1, gfp_mask, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(__vmalloc);
@@ -2574,15 +2570,15 @@ EXPORT_SYMBOL(__vmalloc);
 static inline void *__vmalloc_node_flags(unsigned long size,
 					int node, gfp_t flags)
 {
-	return __vmalloc_node(size, 1, flags, PAGE_KERNEL,
-					node, __builtin_return_address(0));
+	return __vmalloc_node(size, 1, flags, node,
+				__builtin_return_address(0));
 }
 
 
 void *__vmalloc_node_flags_caller(unsigned long size, int node, gfp_t flags,
 				  void *caller)
 {
-	return __vmalloc_node(size, 1, flags, PAGE_KERNEL, node, caller);
+	return __vmalloc_node(size, 1, flags, node, caller);
 }
 
 /**
@@ -2657,8 +2653,8 @@ EXPORT_SYMBOL(vmalloc_user);
  */
 void *vmalloc_node(unsigned long size, int node)
 {
-	return __vmalloc_node(size, 1, GFP_KERNEL, PAGE_KERNEL,
-					node, __builtin_return_address(0));
+	return __vmalloc_node(size, 1, GFP_KERNEL, node,
+			__builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc_node);
 
@@ -2671,9 +2667,6 @@ EXPORT_SYMBOL(vmalloc_node);
  * allocator and map them into contiguous kernel virtual space.
  * The memory allocated is set to zero.
  *
- * For tight control over page level allocator and protection flags
- * use __vmalloc_node() instead.
- *
  * Return: pointer to the allocated memory or %NULL on error
  */
 void *vzalloc_node(unsigned long size, int node)
@@ -2746,8 +2739,8 @@ void *vmalloc_exec(unsigned long size)
  */
 void *vmalloc_32(unsigned long size)
 {
-	return __vmalloc_node(size, 1, GFP_VMALLOC32, PAGE_KERNEL,
-			      NUMA_NO_NODE, __builtin_return_address(0));
+	return __vmalloc_node(size, 1, GFP_VMALLOC32, NUMA_NO_NODE,
+			__builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc_32);
 
_
