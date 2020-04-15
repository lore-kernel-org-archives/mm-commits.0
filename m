From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-both-instances-of-__vmalloc_node_flags.patch
 added to -mm tree
Date: Tue, 14 Apr 2020 21:48:05 -0700
Message-ID: <20200415044805.KR577Sk72%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393127AbgDOEsI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 00:48:08 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, benh@kernel.crashing.org, borntraeger@de.ibm.com, catalin.marinas@arm.com, christophe.leroy@c-s.fr, daniel.vetter@ffwll.ch, daniel@ffwll.ch, gor@linux.ibm.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, hannes@cmpxchg.org, hch@lst.de, heiko.carstens@de.ibm.com, kys@microsoft.com, labbott@redhat.com, mark.rutland@arm.com, mikelley@microsoft.com, minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org, paulus@ozlabs.org, peterz@infradead.org, robin.murphy@arm.com, sakari.ailus@linux.intel.com, sthemmin@microsoft.com, sumit.semwal@linaro.org, wei.liu@kernel.org, will@kernel.org, xiang@kernel.org


The patch titled
     Subject: mm: remove both instances of __vmalloc_node_flags
has been added to the -mm tree.  Its filename is
     mm-remove-both-instances-of-__vmalloc_node_flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-both-instances-of-__vmalloc_node_flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-both-instances-of-__vmalloc_node_flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove both instances of __vmalloc_node_flags

The real version just had a few callers that can open code it and remove
one layer of indirection.  The nommu stub was public but only had a single
caller, so remove it and avoid a CONFIG_MMU ifdef in vmalloc.h.

Link: http://lkml.kernel.org/r/20200414131348.444715-24-hch@lst.de
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

 include/linux/vmalloc.h |    9 ---------
 mm/nommu.c              |    3 ++-
 mm/vmalloc.c            |   20 ++++++--------------
 3 files changed, 8 insertions(+), 24 deletions(-)

--- a/include/linux/vmalloc.h~mm-remove-both-instances-of-__vmalloc_node_flags
+++ a/include/linux/vmalloc.h
@@ -115,17 +115,8 @@ extern void *__vmalloc_node_range(unsign
 			unsigned long start, unsigned long end, gfp_t gfp_mask,
 			pgprot_t prot, unsigned long vm_flags, int node,
 			const void *caller);
-#ifndef CONFIG_MMU
-extern void *__vmalloc_node_flags(unsigned long size, int node, gfp_t flags);
-static inline void *__vmalloc_node_flags_caller(unsigned long size, int node,
-						gfp_t flags, void *caller)
-{
-	return __vmalloc_node_flags(size, node, flags);
-}
-#else
 extern void *__vmalloc_node_flags_caller(unsigned long size,
 					 int node, gfp_t flags, void *caller);
-#endif
 
 extern void vfree(const void *addr);
 extern void vfree_atomic(const void *addr);
--- a/mm/nommu.c~mm-remove-both-instances-of-__vmalloc_node_flags
+++ a/mm/nommu.c
@@ -150,7 +150,8 @@ void *__vmalloc(unsigned long size, gfp_
 }
 EXPORT_SYMBOL(__vmalloc);
 
-void *__vmalloc_node_flags(unsigned long size, int node, gfp_t flags)
+void *__vmalloc_node_flags_caller(unsigned long size, int node, gfp_t flags,
+		void *caller)
 {
 	return __vmalloc(size, flags);
 }
--- a/mm/vmalloc.c~mm-remove-both-instances-of-__vmalloc_node_flags
+++ a/mm/vmalloc.c
@@ -2566,14 +2566,6 @@ void *__vmalloc(unsigned long size, gfp_
 }
 EXPORT_SYMBOL(__vmalloc);
 
-static inline void *__vmalloc_node_flags(unsigned long size,
-					int node, gfp_t flags)
-{
-	return __vmalloc_node(size, 1, flags, node,
-				__builtin_return_address(0));
-}
-
-
 void *__vmalloc_node_flags_caller(unsigned long size, int node, gfp_t flags,
 				  void *caller)
 {
@@ -2594,8 +2586,8 @@ void *__vmalloc_node_flags_caller(unsign
  */
 void *vmalloc(unsigned long size)
 {
-	return __vmalloc_node_flags(size, NUMA_NO_NODE,
-				    GFP_KERNEL);
+	return __vmalloc_node(size, 1, GFP_KERNEL, NUMA_NO_NODE,
+				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc);
 
@@ -2614,8 +2606,8 @@ EXPORT_SYMBOL(vmalloc);
  */
 void *vzalloc(unsigned long size)
 {
-	return __vmalloc_node_flags(size, NUMA_NO_NODE,
-				GFP_KERNEL | __GFP_ZERO);
+	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_ZERO, NUMA_NO_NODE,
+				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(vzalloc);
 
@@ -2670,8 +2662,8 @@ EXPORT_SYMBOL(vmalloc_node);
  */
 void *vzalloc_node(unsigned long size, int node)
 {
-	return __vmalloc_node_flags(size, node,
-			 GFP_KERNEL | __GFP_ZERO);
+	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_ZERO, node,
+				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(vzalloc_node);
 
_

Patches currently in -mm which might be from hch@lst.de are

x86-hyperv-use-vmalloc_exec-for-the-hypercall-page.patch
x86-fix-vmap-arguments-in-map_irq_stack.patch
staging-android-ion-use-vmap-instead-of-vm_map_ram.patch
staging-media-ipu3-use-vmap-instead-of-reimplementing-it.patch
dma-mapping-use-vmap-insted-of-reimplementing-it.patch
powerpc-add-an-ioremap_phb-helper.patch
powerpc-remove-__ioremap_at-and-__iounmap_at.patch
mm-remove-__get_vm_area.patch
mm-unexport-unmap_kernel_range_noflush.patch
mm-rename-config_pgtable_mapping-to-config_zsmalloc_pgtable_mapping.patch
mm-only-allow-page-table-mappings-for-built-in-zsmalloc.patch
mm-pass-addr-as-unsigned-long-to-vb_free.patch
mm-remove-vmap_page_range_noflush-and-vunmap_page_range.patch
mm-rename-vmap_page_range-to-map_kernel_range.patch
mm-dont-return-the-number-of-pages-from-map_kernel_range_noflush.patch
mm-remove-map_vm_range.patch
mm-remove-unmap_vmap_area.patch
mm-remove-the-prot-argument-from-vm_map_ram.patch
mm-enforce-that-vmap-cant-map-pages-executable.patch
gpu-drm-remove-the-powerpc-hack-in-drm_legacy_sg_alloc.patch
mm-remove-the-pgprot-argument-to-__vmalloc.patch
mm-remove-the-prot-argument-to-__vmalloc_node.patch
mm-remove-both-instances-of-__vmalloc_node_flags.patch
mm-remove-__vmalloc_node_flags_caller.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node.patch
mm-remove-vmalloc_user_node_flags.patch
arm64-use-__vmalloc_node-in-arch_alloc_vmap_stack.patch
powerpc-use-__vmalloc_node-in-alloc_vm_stack.patch
s390-use-__vmalloc_node-in-stack_alloc.patch
