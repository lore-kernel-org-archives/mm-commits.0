From: akpm@linux-foundation.org
Subject: + mm-page_alloc-pass-pfn-to-__free_pages_bootmem.patch added to
 -mm tree
Date: Wed, 29 Apr 2015 14:19:31 -0700
Message-ID: <55414ae3.nVfH8XqsSNs45a9a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbbD2VTc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Apr 2015 17:19:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, daniel@numascale.com, dave.hansen@intel.com, hpa@zytor.com, mingo@elte.hu, nzimmer@sgi.com, penberg@kernel.org, robinmholt@gmail.com, scott.norton@hp.com, tglx@linutronix.de, tony.luck@intel.com, waiman.long@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: pass PFN to __free_pages_bootmem
has been added to the -mm tree.  Its filename is
     mm-page_alloc-pass-pfn-to-__free_pages_bootmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-pass-pfn-to-__free_pages_bootmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-pass-pfn-to-__free_pages_bootmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: page_alloc: pass PFN to __free_pages_bootmem

__free_pages_bootmem prepares a page for release to the buddy allocator
and assumes that the struct page is initialised.  Parallel initialisation
of struct pages defers initialisation and __free_pages_bootmem can be
called for struct pages that cannot yet map struct page to PFN.  This
patch passes PFN to __free_pages_bootmem with no other functional change.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Tested-by: Nate Zimmer <nzimmer@sgi.com>
Tested-by: Waiman Long <waiman.long@hp.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Nate Zimmer <nzimmer@sgi.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Waiman Long <waiman.long@hp.com>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Daniel J Blueman <daniel@numascale.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c    |    8 ++++----
 mm/internal.h   |    3 ++-
 mm/memblock.c   |    2 +-
 mm/nobootmem.c  |    4 ++--
 mm/page_alloc.c |    3 ++-
 5 files changed, 11 insertions(+), 9 deletions(-)

diff -puN mm/bootmem.c~mm-page_alloc-pass-pfn-to-__free_pages_bootmem mm/bootmem.c
--- a/mm/bootmem.c~mm-page_alloc-pass-pfn-to-__free_pages_bootmem
+++ a/mm/bootmem.c
@@ -164,7 +164,7 @@ void __init free_bootmem_late(unsigned l
 	end = PFN_DOWN(physaddr + size);
 
 	for (; cursor < end; cursor++) {
-		__free_pages_bootmem(pfn_to_page(cursor), 0);
+		__free_pages_bootmem(pfn_to_page(cursor), cursor, 0);
 		totalram_pages++;
 	}
 }
@@ -210,7 +210,7 @@ static unsigned long __init free_all_boo
 		if (IS_ALIGNED(start, BITS_PER_LONG) && vec == ~0UL) {
 			int order = ilog2(BITS_PER_LONG);
 
-			__free_pages_bootmem(pfn_to_page(start), order);
+			__free_pages_bootmem(pfn_to_page(start), start, order);
 			count += BITS_PER_LONG;
 			start += BITS_PER_LONG;
 		} else {
@@ -220,7 +220,7 @@ static unsigned long __init free_all_boo
 			while (vec && cur != start) {
 				if (vec & 1) {
 					page = pfn_to_page(cur);
-					__free_pages_bootmem(page, 0);
+					__free_pages_bootmem(page, cur, 0);
 					count++;
 				}
 				vec >>= 1;
@@ -234,7 +234,7 @@ static unsigned long __init free_all_boo
 	pages = bootmem_bootmap_pages(pages);
 	count += pages;
 	while (pages--)
-		__free_pages_bootmem(page++, 0);
+		__free_pages_bootmem(page++, cur++, 0);
 
 	bdebug("nid=%td released=%lx\n", bdata - bootmem_node_data, count);
 
diff -puN mm/internal.h~mm-page_alloc-pass-pfn-to-__free_pages_bootmem mm/internal.h
--- a/mm/internal.h~mm-page_alloc-pass-pfn-to-__free_pages_bootmem
+++ a/mm/internal.h
@@ -155,7 +155,8 @@ __find_buddy_index(unsigned long page_id
 }
 
 extern int __isolate_free_page(struct page *page, unsigned int order);
-extern void __free_pages_bootmem(struct page *page, unsigned int order);
+extern void __free_pages_bootmem(struct page *page, unsigned long pfn,
+					unsigned int order);
 extern void prep_compound_page(struct page *page, unsigned long order);
 #ifdef CONFIG_MEMORY_FAILURE
 extern bool is_free_buddy_page(struct page *page);
diff -puN mm/memblock.c~mm-page_alloc-pass-pfn-to-__free_pages_bootmem mm/memblock.c
--- a/mm/memblock.c~mm-page_alloc-pass-pfn-to-__free_pages_bootmem
+++ a/mm/memblock.c
@@ -1348,7 +1348,7 @@ void __init __memblock_free_late(phys_ad
 	end = PFN_DOWN(base + size);
 
 	for (; cursor < end; cursor++) {
-		__free_pages_bootmem(pfn_to_page(cursor), 0);
+		__free_pages_bootmem(pfn_to_page(cursor), cursor, 0);
 		totalram_pages++;
 	}
 }
diff -puN mm/nobootmem.c~mm-page_alloc-pass-pfn-to-__free_pages_bootmem mm/nobootmem.c
--- a/mm/nobootmem.c~mm-page_alloc-pass-pfn-to-__free_pages_bootmem
+++ a/mm/nobootmem.c
@@ -77,7 +77,7 @@ void __init free_bootmem_late(unsigned l
 	end = PFN_DOWN(addr + size);
 
 	for (; cursor < end; cursor++) {
-		__free_pages_bootmem(pfn_to_page(cursor), 0);
+		__free_pages_bootmem(pfn_to_page(cursor), cursor, 0);
 		totalram_pages++;
 	}
 }
@@ -92,7 +92,7 @@ static void __init __free_pages_memory(u
 		while (start + (1UL << order) > end)
 			order--;
 
-		__free_pages_bootmem(pfn_to_page(start), order);
+		__free_pages_bootmem(pfn_to_page(start), start, order);
 
 		start += (1UL << order);
 	}
diff -puN mm/page_alloc.c~mm-page_alloc-pass-pfn-to-__free_pages_bootmem mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-pass-pfn-to-__free_pages_bootmem
+++ a/mm/page_alloc.c
@@ -892,7 +892,8 @@ static void __free_pages_ok(struct page
 	local_irq_restore(flags);
 }
 
-void __init __free_pages_bootmem(struct page *page, unsigned int order)
+void __init __free_pages_bootmem(struct page *page, unsigned long pfn,
+							unsigned int order)
 {
 	unsigned int nr_pages = 1 << order;
 	struct page *p = page;
_

Patches currently in -mm which might be from mgorman@suse.de are

jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
thp-cleanup-how-khugepaged-enters-freezer.patch
mm-new-mm-hook-framework.patch
mm-new-arch_remap-hook.patch
powerpc-mm-tracking-vdso-remap.patch
memblock-introduce-a-for_each_reserved_mem_region-iterator.patch
mm-meminit-move-page-initialization-into-a-separate-function.patch
mm-meminit-only-set-page-reserved-in-the-memblock-region.patch
mm-page_alloc-pass-pfn-to-__free_pages_bootmem.patch
mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid.patch
mm-meminit-inline-some-helper-functions.patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set.patch
mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd.patch
mm-meminit-minimise-number-of-pfn-page-lookups-during-initialisation.patch
x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
mm-meminit-free-pages-in-large-chunks-where-possible.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init.patch
mm-meminit-remove-mminit_verify_page_links.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

