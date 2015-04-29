From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init.patch removed from -mm tree
Date: Wed, 29 Apr 2015 13:37:02 -0700
Message-ID: <554140ee.Lgr9zGMMTJOVLb62%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbbD2UhD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Apr 2015 16:37:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, daniel@numascale.com, dave.hansen@intel.com, holt@sgi.com, hpa@zytor.com, mingo@elte.hu, nzimmer@sgi.com, scott.norton@hp.com, tglx@linutronix.de, tony.luck@intel.com, waiman.long@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: meminit: reduce number of times pageblocks are set during struct page init
has been removed from the -mm tree.  Its filename was
     mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: meminit: reduce number of times pageblocks are set during struct page init

During parallel sturct page initialisation, ranges are checked for every
PFN unnecessarily which increases boot times.  This patch alters when the
ranges are checked.

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

 mm/page_alloc.c |   45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff -puN mm/page_alloc.c~mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init
+++ a/mm/page_alloc.c
@@ -852,33 +852,12 @@ static int free_tail_pages_check(struct
 static void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid)
 {
-	struct zone *z = &NODE_DATA(nid)->node_zones[zone];
-
 	set_page_links(page, zone, nid, pfn);
 	mminit_verify_page_links(page, zone, nid, pfn);
 	init_page_count(page);
 	page_mapcount_reset(page);
 	page_cpupid_reset_last(page);
 
-	/*
-	 * Mark the block movable so that blocks are reserved for
-	 * movable at startup. This will force kernel allocations
-	 * to reserve their blocks rather than leaking throughout
-	 * the address space during boot when many long-lived
-	 * kernel allocations are made. Later some blocks near
-	 * the start are marked MIGRATE_RESERVE by
-	 * setup_zone_migrate_reserve()
-	 *
-	 * bitmap is created for zone's valid pfn range. but memmap
-	 * can be created for invalid pages (for alignment)
-	 * check here not to call set_pageblock_migratetype() against
-	 * pfn out of zone.
-	 */
-	if ((z->zone_start_pfn <= pfn)
-	    && (pfn < zone_end_pfn(z))
-	    && !(pfn & (pageblock_nr_pages - 1)))
-		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
-
 	INIT_LIST_HEAD(&page->lru);
 #ifdef WANT_PAGE_VIRTUAL
 	/* The shift won't overflow because ZONE_NORMAL is below 4G. */
@@ -1062,6 +1041,7 @@ void __defermem_init deferred_free_range
 	int i;
 
 	if (nr_pages == MAX_ORDER_NR_PAGES && (pfn & (MAX_ORDER_NR_PAGES-1)) == 0) {
+		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 		__free_pages_boot_core(page, pfn, MAX_ORDER-1);
 		return;
 	}
@@ -4513,7 +4493,28 @@ void __meminit memmap_init_zone(unsigned
 						&nr_initialised))
 				break;
 		}
-		__init_single_pfn(pfn, zone, nid);
+
+		/*
+		 * Mark the block movable so that blocks are reserved for
+		 * movable at startup. This will force kernel allocations
+		 * to reserve their blocks rather than leaking throughout
+		 * the address space during boot when many long-lived
+		 * kernel allocations are made. Later some blocks near
+		 * the start are marked MIGRATE_RESERVE by
+		 * setup_zone_migrate_reserve()
+		 *
+		 * bitmap is created for zone's valid pfn range. but memmap
+		 * can be created for invalid pages (for alignment)
+		 * check here not to call set_pageblock_migratetype() against
+		 * pfn out of zone.
+		 */
+		if (!(pfn & (pageblock_nr_pages - 1))) {
+			struct page *page = pfn_to_page(pfn);
+			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+			__init_single_page(page, pfn, zone, nid);
+		} else {
+			__init_single_pfn(pfn, zone, nid);
+		}
 	}
 }
 
_

Patches currently in -mm which might be from mgorman@suse.de are

jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
thp-cleanup-how-khugepaged-enters-freezer.patch
mm-new-mm-hook-framework.patch
mm-new-arch_remap-hook.patch
powerpc-mm-tracking-vdso-remap.patch
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

