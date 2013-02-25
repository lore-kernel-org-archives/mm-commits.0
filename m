From: akpm@linux-foundation.org
Subject: [merged] mm-init-report-on-last-nid-information-stored-in-page-flags.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:53:17 -0800
Message-ID: <20130225205317.9B78E5A4277@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:33980 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759737Ab3BYUxS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:53:18 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so347383vch.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:53:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: init: report on last-nid information stored in page->flags
has been removed from the -mm tree.  Its filename was
     mm-init-report-on-last-nid-information-stored-in-page-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-memmap_init_zone-performance-improvement.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch

