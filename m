Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78CFEC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40E2820721
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgLODMg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:12:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727936AbgLODMY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:24 -0500
Date:   Mon, 14 Dec 2020 19:10:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001822;
        bh=Sn2VuewULcsT5vPcwzccgonNP9ND1pJ8ArhJG3kyGsk=;
        h=From:To:Subject:In-Reply-To:From;
        b=Ys28lq3UVxijhijs/pyAQv+E8zkP4ekIZimXtCkuwuM1lqIeHdBYOg+7M3zRfoymU
         9Ctm1laRQQ0KwW6LlbiRJw43rsw6245FJKbYX5Y4ymbam4scx58Q9ZDkTeuH+xxsmD
         dq/aXph3Al2bPECuz7NjjkqMIW417QE2Z6VI23b0=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aou@eecs.berkeley.edu,
        benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de,
        catalin.marinas@arm.com, cl@linux.com, dave.hansen@linux.intel.com,
        davem@davemloft.net, david@redhat.com, gor@linux.ibm.com,
        hca@linux.ibm.com, hpa@zytor.com, iamjoonsoo.kim@lge.com,
        kirill.shutemov@linux.intel.com, len.brown@intel.com,
        linux-mm@kvack.org, luto@kernel.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, palmer@dabbelt.com,
        paul.walmsley@sifive.com, paulus@samba.org, pavel@ucw.cz,
        penberg@kernel.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rick.p.edgecombe@intel.com,
        rientjes@google.com, rjw@rjwysocki.net, rppt@linux.ibm.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz,
        will@kernel.org
Subject:  [patch 119/200] mm: introduce
 debug_pagealloc_{map,unmap}_pages() helpers
Message-ID: <20201215031020.R9KaM5WPA%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -2943,12 +2943,27 @@ kernel_map_pages(struct page *page, int
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
@@ -1273,8 +1273,7 @@ static __always_inline bool free_pages_p
 	 */
 	arch_free_page(page, order);
 
-	if (debug_pagealloc_enabled_static())
-		kernel_map_pages(page, 1 << order, 0);
+	debug_pagealloc_unmap_pages(page, 1 << order);
 
 	kasan_free_nondeferred_pages(page, order);
 
@@ -2279,8 +2278,7 @@ inline void post_alloc_hook(struct page
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
@@ -1435,7 +1435,7 @@ static void slab_kernel_map(struct kmem_
 	if (!is_debug_pagealloc_cache(cachep))
 		return;
 
-	kernel_map_pages(virt_to_page(objp), cachep->size / PAGE_SIZE, map);
+	__kernel_map_pages(virt_to_page(objp), cachep->size / PAGE_SIZE, map);
 }
 
 #else
_
