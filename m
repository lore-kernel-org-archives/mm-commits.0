From: akpm@linux-foundation.org
Subject: + mm-meminit-free-pages-in-large-chunks-where-possible.patch
 added to -mm tree
Date: Wed, 29 Apr 2015 14:19:47 -0700
Message-ID: <55414af3.pvI+uNzDlodALDJ6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbbD2VTs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Apr 2015 17:19:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, daniel@numascale.com, dave.hansen@intel.com, hpa@zytor.com, mingo@elte.hu, nzimmer@sgi.com, penberg@kernel.org, robinmholt@gmail.com, scott.norton@hp.com, tglx@linutronix.de, tony.luck@intel.com, waiman.long@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: meminit: free pages in large chunks where possible
has been added to the -mm tree.  Its filename is
     mm-meminit-free-pages-in-large-chunks-where-possible.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-meminit-free-pages-in-large-chunks-where-possible.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-meminit-free-pages-in-large-chunks-where-possible.patch

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
Subject: mm: meminit: free pages in large chunks where possible

Parallel struct page frees pages one at a time. Try free pages as single
large pages where possible.

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

 mm/page_alloc.c |   55 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 49 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~mm-meminit-free-pages-in-large-chunks-where-possible mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-free-pages-in-large-chunks-where-possible
+++ a/mm/page_alloc.c
@@ -1063,6 +1063,25 @@ void __defer_init __free_pages_bootmem(s
 }
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+static void __defermem_init deferred_free_range(struct page *page,
+					unsigned long pfn, int nr_pages)
+{
+	int i;
+
+	if (!page)
+		return;
+
+	/* Free a large naturally-aligned chunk if possible */
+	if (nr_pages == MAX_ORDER_NR_PAGES &&
+	    (pfn & (MAX_ORDER_NR_PAGES-1)) == 0) {
+		__free_pages_boot_core(page, pfn, MAX_ORDER-1);
+		return;
+	}
+
+	for (i = 0; i < nr_pages; i++, page++, pfn++)
+		__free_pages_boot_core(page, pfn, 0);
+}
+
 /* Initialise remaining memory on a node */
 void __defermem_init deferred_init_memmap(int nid)
 {
@@ -1093,6 +1112,9 @@ void __defermem_init deferred_init_memma
 	for_each_mem_pfn_range(i, nid, &walk_start, &walk_end, NULL) {
 		unsigned long pfn, end_pfn;
 		struct page *page = NULL;
+		struct page *free_base_page = NULL;
+		unsigned long free_base_pfn = 0;
+		int nr_to_free = 0;
 
 		end_pfn = min(walk_end, zone_end_pfn(zone));
 		pfn = first_init_pfn;
@@ -1103,7 +1125,7 @@ void __defermem_init deferred_init_memma
 
 		for (; pfn < end_pfn; pfn++) {
 			if (!pfn_valid_within(pfn))
-				continue;
+				goto free_range;
 
 			/*
 			 * Ensure pfn_valid is checked every
@@ -1112,32 +1134,53 @@ void __defermem_init deferred_init_memma
 			if ((pfn & (MAX_ORDER_NR_PAGES - 1)) == 0) {
 				if (!pfn_valid(pfn)) {
 					page = NULL;
-					continue;
+					goto free_range;
 				}
 			}
 
 			if (!meminit_pfn_in_nid(pfn, nid, &nid_init_state)) {
 				page = NULL;
-				continue;
+				goto free_range;
 			}
 
 			/* Minimise pfn page lookups and scheduler checks */
 			if (page && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0) {
 				page++;
 			} else {
+				nr_pages += nr_to_free;
+				deferred_free_range(free_base_page,
+						free_base_pfn, nr_to_free);
+				free_base_page = NULL;
+				free_base_pfn = nr_to_free = 0;
+
 				page = pfn_to_page(pfn);
 				cond_resched();
 			}
 
 			if (page->flags) {
 				VM_BUG_ON(page_zone(page) != zone);
-				continue;
+				goto free_range;
 			}
 
 			__init_single_page(page, pfn, zid, nid);
-			__free_pages_boot_core(page, pfn, 0);
-			nr_pages++;
+			if (!free_base_page) {
+				free_base_page = page;
+				free_base_pfn = pfn;
+				nr_to_free = 0;
+			}
+			nr_to_free++;
+
+			/* Where possible, batch up pages for a single free */
+			continue;
+free_range:
+			/* Free the current block of pages to allocator */
+			nr_pages += nr_to_free;
+			deferred_free_range(free_base_page, free_base_pfn,
+								nr_to_free);
+			free_base_page = NULL;
+			free_base_pfn = nr_to_free = 0;
 		}
+
 		first_init_pfn = max(end_pfn, first_init_pfn);
 	}
 
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

