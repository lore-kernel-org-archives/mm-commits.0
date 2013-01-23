From: akpm@linux-foundation.org
Subject: + mm-init-report-on-last-nid-information-stored-in-page-flags.patch added to -mm tree
Date: Wed, 23 Jan 2013 13:57:35 -0800
Message-ID: <20130123215735.99D4431C00F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:35068 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3AWV5g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jan 2013 16:57:36 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so907835vbi.3
        for <mm-commits@vger.kernel.org>; Wed, 23 Jan 2013 13:57:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de


The patch titled
     Subject: mm: init: report on last-nid information stored in page->flags
has been added to the -mm tree.  Its filename is
     mm-init-report-on-last-nid-information-stored-in-page-flags.patch

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
Subject: mm: init: report on last-nid information stored in page->flags

Answering the question "how much space remains in the page->flags" is
time-consuming.  mminit_loglevel can help answer the question but it does
not take last_nid information into account.  This patch corrects it and
while there it corrects the messages related to page flag usage, pgshifts
and node/zone id.  When applied the relevant output looks something like
this but will depend on the kernel configuration.

[    0.000000] mminit::pageflags_layout_widths Section 0 Node 9 Zone 2 Lastnid 9 Flags 25
[    0.000000] mminit::pageflags_layout_shifts Section 19 Node 9 Zone 2 Lastnid 9
[    0.000000] mminit::pageflags_layout_pgshifts Section 0 Node 55 Zone 53 Lastnid 44
[    0.000000] mminit::pageflags_layout_nodezoneid Node/Zone ID: 64 -> 53
[    0.000000] mminit::pageflags_layout_usage location: 64 -> 44 layout 44 -> 25 unused 25 -> 0 page-flags

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff -puN mm/mm_init.c~mm-init-report-on-last-nid-information-stored-in-page-flags mm/mm_init.c
--- a/mm/mm_init.c~mm-init-report-on-last-nid-information-stored-in-page-flags
+++ a/mm/mm_init.c
@@ -69,34 +69,41 @@ void __init mminit_verify_pageflags_layo
 	unsigned long or_mask, add_mask;
 
 	shift = 8 * sizeof(unsigned long);
-	width = shift - SECTIONS_WIDTH - NODES_WIDTH - ZONES_WIDTH;
+	width = shift - SECTIONS_WIDTH - NODES_WIDTH - ZONES_WIDTH - LAST_NID_SHIFT;
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_widths",
-		"Section %d Node %d Zone %d Flags %d\n",
+		"Section %d Node %d Zone %d Lastnid %d Flags %d\n",
 		SECTIONS_WIDTH,
 		NODES_WIDTH,
 		ZONES_WIDTH,
+		LAST_NID_WIDTH,
 		NR_PAGEFLAGS);
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_shifts",
-		"Section %d Node %d Zone %d\n",
+		"Section %d Node %d Zone %d Lastnid %d\n",
 		SECTIONS_SHIFT,
 		NODES_SHIFT,
-		ZONES_SHIFT);
-	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_offsets",
-		"Section %lu Node %lu Zone %lu\n",
+		ZONES_SHIFT,
+		LAST_NID_SHIFT);
+	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_pgshifts",
+		"Section %lu Node %lu Zone %lu Lastnid %lu\n",
 		(unsigned long)SECTIONS_PGSHIFT,
 		(unsigned long)NODES_PGSHIFT,
-		(unsigned long)ZONES_PGSHIFT);
-	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_zoneid",
-		"Zone ID: %lu -> %lu\n",
-		(unsigned long)ZONEID_PGOFF,
-		(unsigned long)(ZONEID_PGOFF + ZONEID_SHIFT));
+		(unsigned long)ZONES_PGSHIFT,
+		(unsigned long)LAST_NID_PGSHIFT);
+	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_nodezoneid",
+		"Node/Zone ID: %lu -> %lu\n",
+		(unsigned long)(ZONEID_PGOFF + ZONEID_SHIFT),
+		(unsigned long)ZONEID_PGOFF);
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_usage",
-		"location: %d -> %d unused %d -> %d flags %d -> %d\n",
+		"location: %d -> %d layout %d -> %d unused %d -> %d page-flags\n",
 		shift, width, width, NR_PAGEFLAGS, NR_PAGEFLAGS, 0);
 #ifdef NODE_NOT_IN_PAGE_FLAGS
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_nodeflags",
 		"Node not in page flags");
 #endif
+#ifdef LAST_NID_NOT_IN_PAGE_FLAGS
+	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_nodeflags",
+		"Last nid not in page flags");
+#endif
 
 	if (SECTIONS_WIDTH) {
 		shift -= SECTIONS_WIDTH;
_

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-compaction-do-not-accidentally-skip-pageblocks-in-the-migrate-scanner.patch
mm-huge_memory-use-new-hashtable-implementation.patch
mmksm-use-new-hashtable-implementation.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-avoid-calling-pgdat_balanced-needlessly.patch
mm-dont-wait-on-congested-zones-in-balance_pgdat.patch
mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate.patch
mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch
mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch
mm-numa-fix-minor-typo-in-numa_next_scan.patch
mm-numa-take-thp-into-account-when-migrating-pages-for-numa-balancing.patch
mm-numa-handle-side-effects-in-count_vm_numa_events-for-config_numa_balancing.patch
mm-move-page-flags-layout-to-separate-header.patch
mm-fold-page-_last_nid-into-page-flags-where-possible.patch
mm-numa-cleanup-flow-of-transhuge-page-migration.patch
mm-uninline-page_xchg_last_nid.patch
mm-init-report-on-last-nid-information-stored-in-page-flags.patch
mm-memmap_init_zone-performance-improvement.patch

