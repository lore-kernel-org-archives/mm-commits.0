Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9497C388F7
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 20:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CC622074B
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 20:59:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ME0WIURY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgKJU7m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 15:59:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:60522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbgKJU7l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 15:59:41 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A863D20665;
        Tue, 10 Nov 2020 20:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605041980;
        bh=YQUuYGG8aum6c/d2CY3RseI9l8j5cLcpfHhKK1tQPCk=;
        h=Date:From:To:Subject:From;
        b=ME0WIURYrBO3utLD6iF6V/ODWQzSVbbPdGCR9WVrBuJDbRu8mWij2Dg0YZmPmBEwI
         aQCS8NwsaSCK/5st2IcvUNMwBTzzyoKY8ZOMhxgBDkuv1Wz6oNE+6zqGcE5DaHCVh+
         k6gIjTHiFh9TSnyUViQGirARg52Lxq6VaC4x4sv4=
Date:   Tue, 10 Nov 2020 12:59:38 -0800
From:   akpm@linux-foundation.org
To:     aou@eecs.berkeley.edu, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com,
        cl@linux.com, dave.hansen@linux.intel.com, davem@davemloft.net,
        david@redhat.com, gor@linux.ibm.com, hca@linux.ibm.com,
        hpa@zytor.com, iamjoonsoo.kim@lge.com,
        kirill.shutemov@linux.intel.com, len.brown@intel.com,
        luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com,
        paulus@samba.org, pavel@ucw.cz, penberg@kernel.org,
        peterz@infradead.org, rafael.j.wysocki@intel.com,
        rick.p.edgecombe@intel.com, rientjes@google.com, rjw@rjwysocki.net,
        rppt@linux.ibm.com, tglx@linutronix.de, vbabka@suse.cz,
        will@kernel.org
Subject:  +
 mm-introduce-debug_pagealloc_mapunmap_pages-helpers.patch added to -mm tree
Message-ID: <20201110205938.UsnEu8lM-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce debug_pagealloc_{map,unmap}_pages() helpers
has been added to the -mm tree.  Its filename is
     mm-introduce-debug_pagealloc_mapunmap_pages-helpers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-debug_pagealloc_mapunmap_pages-helpers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-debug_pagealloc_mapunmap_pages-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: introduce debug_pagealloc_{map,unmap}_pages() helpers

Patch series "arch, mm: improve robustness of direct map manipulation", v7.

During recent discussion about KVM protected memory, David raised a
concern about usage of __kernel_map_pages() outside of DEBUG_PAGEALLOC
scope [1].

Indeed, for architectures that define CONFIG_ARCH_HAS_SET_DIRECT_MAP it is
possible that __kernel_map_pages() would fail, but since this function is
void, the failure will go unnoticed.

Moreover, there's lack of consistency of __kernel_map_pages() semantics
across architectures as some guard this function with #ifdef
DEBUG_PAGEALLOC, some refuse to update the direct map if page allocation
debugging is disabled at run time and some allow modifying the direct map
regardless of DEBUG_PAGEALLOC settings.

This set straightens this out by restoring dependency of
__kernel_map_pages() on DEBUG_PAGEALLOC and updating the call sites
accordingly.  

Since currently the only user of __kernel_map_pages() outside
DEBUG_PAGEALLOC is hibernation, it is updated to make direct map accesses
there more explicit.

[1] https://lore.kernel.org/lkml/2759b4bf-e1e3-d006-7d86-78a40348269d@redhat.com


This patch (of 4):

When CONFIG_DEBUG_PAGEALLOC is enabled, it unmaps pages from the kernel
direct mapping after free_pages().  The pages than need to be mapped back
before they could be used.  Theese mapping operations use
__kernel_map_pages() guarded with with debug_pagealloc_enabled().

The only place that calls __kernel_map_pages() without checking whether
DEBUG_PAGEALLOC is enabled is the hibernation code that presumes
availability of this function when ARCH_HAS_SET_DIRECT_MAP is set.  Still,
on arm64, __kernel_map_pages() will bail out when DEBUG_PAGEALLOC is not
enabled but set_direct_map_invalid_noflush() may render some pages not
present in the direct map and hibernation code won't be able to save such
pages.

To make page allocation debugging and hibernation interaction more robust,
the dependency on DEBUG_PAGEALLOC or ARCH_HAS_SET_DIRECT_MAP has to be
made more explicit.

Start with combining the guard condition and the call to
__kernel_map_pages() into debug_pagealloc_map_pages() and
debug_pagealloc_unmap_pages() functions to emphasize that
__kernel_map_pages() should not be called without DEBUG_PAGEALLOC and use
these new functions to map/unmap pages when page allocation debugging is
enabled.

Link: https://lkml.kernel.org/r/20201109192128.960-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20201109192128.960-2-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |   15 +++++++++++++++
 mm/memory_hotplug.c |    3 +--
 mm/page_alloc.c     |    6 ++----
 mm/slab.c           |    2 +-
 4 files changed, 19 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h~mm-introduce-debug_pagealloc_mapunmap_pages-helpers
+++ a/include/linux/mm.h
@@ -2921,12 +2921,27 @@ kernel_map_pages(struct page *page, int
 {
 	__kernel_map_pages(page, numpages, enable);
 }
+
+static inline void debug_pagealloc_map_pages(struct page *page, int numpages)
+{
+	if (debug_pagealloc_enabled_static())
+		__kernel_map_pages(page, numpages, 1);
+}
+
+static inline void debug_pagealloc_unmap_pages(struct page *page, int numpages)
+{
+	if (debug_pagealloc_enabled_static())
+		__kernel_map_pages(page, numpages, 0);
+}
+
 #ifdef CONFIG_HIBERNATION
 extern bool kernel_page_present(struct page *page);
 #endif	/* CONFIG_HIBERNATION */
 #else	/* CONFIG_DEBUG_PAGEALLOC || CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 static inline void
 kernel_map_pages(struct page *page, int numpages, int enable) {}
+static inline void debug_pagealloc_map_pages(struct page *page, int numpages) {}
+static inline void debug_pagealloc_unmap_pages(struct page *page, int numpages) {}
 #ifdef CONFIG_HIBERNATION
 static inline bool kernel_page_present(struct page *page) { return true; }
 #endif	/* CONFIG_HIBERNATION */
--- a/mm/memory_hotplug.c~mm-introduce-debug_pagealloc_mapunmap_pages-helpers
+++ a/mm/memory_hotplug.c
@@ -596,8 +596,7 @@ void generic_online_page(struct page *pa
 	 * so we should map it first. This is better than introducing a special
 	 * case in page freeing fast path.
 	 */
-	if (debug_pagealloc_enabled_static())
-		kernel_map_pages(page, 1 << order, 1);
+	debug_pagealloc_map_pages(page, 1 << order);
 	__free_pages_core(page, order);
 	totalram_pages_add(1UL << order);
 #ifdef CONFIG_HIGHMEM
--- a/mm/page_alloc.c~mm-introduce-debug_pagealloc_mapunmap_pages-helpers
+++ a/mm/page_alloc.c
@@ -1272,8 +1272,7 @@ static __always_inline bool free_pages_p
 	 */
 	arch_free_page(page, order);
 
-	if (debug_pagealloc_enabled_static())
-		kernel_map_pages(page, 1 << order, 0);
+	debug_pagealloc_unmap_pages(page, 1 << order);
 
 	kasan_free_nondeferred_pages(page, order);
 
@@ -2278,8 +2277,7 @@ inline void post_alloc_hook(struct page
 	set_page_refcounted(page);
 
 	arch_alloc_page(page, order);
-	if (debug_pagealloc_enabled_static())
-		kernel_map_pages(page, 1 << order, 1);
+	debug_pagealloc_map_pages(page, 1 << order);
 	kasan_alloc_pages(page, order);
 	kernel_poison_pages(page, 1 << order, 1);
 	set_page_owner(page, order, gfp_flags);
--- a/mm/slab.c~mm-introduce-debug_pagealloc_mapunmap_pages-helpers
+++ a/mm/slab.c
@@ -1434,7 +1434,7 @@ static void slab_kernel_map(struct kmem_
 	if (!is_debug_pagealloc_cache(cachep))
 		return;
 
-	kernel_map_pages(virt_to_page(objp), cachep->size / PAGE_SIZE, map);
+	__kernel_map_pages(virt_to_page(objp), cachep->size / PAGE_SIZE, map);
 }
 
 #else
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

alpha-switch-from-discontigmem-to-sparsemem.patch
ia64-remove-custom-__early_pfn_to_nid.patch
ia64-remove-ifdef-config_zone_dma32-statements.patch
ia64-discontig-paging_init-remove-local-max_pfn-calculation.patch
ia64-split-virtual-map-initialization-out-of-paging_init.patch
ia64-forbid-using-virtual_mem_map-with-flatmem.patch
ia64-make-sparsemem-default-and-disable-discontigmem.patch
arm-remove-config_arch_has_holes_memorymodel.patch
arm-arm64-move-free_unused_memmap-to-generic-mm.patch
arc-use-flatmem-with-freeing-of-unused-memory-map-instead-of-discontigmem.patch
m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem.patch
m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem.patch
m68k-deprecate-discontigmem.patch
mm-introduce-debug_pagealloc_mapunmap_pages-helpers.patch
pm-hibernate-make-direct-map-manipulations-more-explicit.patch
arch-mm-restore-dependency-of-__kernel_map_pages-on-debug_pagealloc.patch
arch-mm-make-kernel_page_present-always-available.patch

