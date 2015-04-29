From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-meminit-minimise-number-of-pfn-page-lookups-during-initialisation.patch
 removed from -mm tree
Date: Wed, 29 Apr 2015 13:36:54 -0700
Message-ID: <554140e6.aGPnYCTHnMI2H6NP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbbD2Ugz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Apr 2015 16:36:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, daniel@numascale.com, dave.hansen@intel.com, holt@sgi.com, hpa@zytor.com, mingo@elte.hu, nzimmer@sgi.com, scott.norton@hp.com, tglx@linutronix.de, tony.luck@intel.com, waiman.long@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: meminit: minimise number of pfn->page lookups during initialisation
has been removed from the -mm tree.  Its filename was
     mm-meminit-minimise-number-of-pfn-page-lookups-during-initialisation.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: meminit: minimise number of pfn->page lookups during initialisation

Deferred struct page initialisation is using pfn_to_page() on every PFN
unnecessarily.  This patch minimises the number of lookups and scheduler
checks.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Daniel J Blueman <daniel@numascale.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Waiman Long <waiman.long@hp.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~mm-meminit-minimise-number-of-pfn-page-lookups-during-initialisation mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-minimise-number-of-pfn-page-lookups-during-initialisation
+++ a/mm/page_alloc.c
@@ -1080,6 +1080,7 @@ void __defermem_init deferred_init_memma
 
 		for_each_mem_pfn_range(i, nid, &walk_start, &walk_end, NULL) {
 			unsigned long pfn, end_pfn;
+			struct page *page = NULL;
 
 			end_pfn = min(walk_end, zone_end_pfn(zone));
 			pfn = first_init_pfn;
@@ -1089,13 +1090,32 @@ void __defermem_init deferred_init_memma
 				pfn = zone->zone_start_pfn;
 
 			for (; pfn < end_pfn; pfn++) {
-				struct page *page;
-
-				if (!pfn_valid(pfn))
+				if (!pfn_valid_within(pfn))
 					continue;
 
-				if (!meminit_pfn_in_nid(pfn, nid, &nid_init_state))
+				/*
+				 * Ensure pfn_valid is checked every
+				 * MAX_ORDER_NR_PAGES for memory holes
+				 */
+				if ((pfn & (MAX_ORDER_NR_PAGES - 1)) == 0) {
+					if (!pfn_valid(pfn)) {
+						page = NULL;
+						continue;
+					}
+				}
+
+				if (!meminit_pfn_in_nid(pfn, nid, &nid_init_state)) {
+					page = NULL;
 					continue;
+				}
+
+				/* Minimise pfn page lookups and scheduler checks */
+				if (page && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0) {
+					page++;
+				} else {
+					page = pfn_to_page(pfn);
+					cond_resched();
+				}
 
 				if (page->flags) {
 					VM_BUG_ON(page_zone(page) != zone);
@@ -1104,7 +1124,6 @@ void __defermem_init deferred_init_memma
 
 				__init_single_page(page, pfn, zid, nid);
 				__free_pages_boot_core(page, pfn, 0);
-				cond_resched();
 			}
 			first_init_pfn = max(end_pfn, first_init_pfn);
 		}
_

Patches currently in -mm which might be from mgorman@suse.de are

jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
thp-cleanup-how-khugepaged-enters-freezer.patch
mm-new-mm-hook-framework.patch
mm-new-arch_remap-hook.patch
powerpc-mm-tracking-vdso-remap.patch
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

