From: akpm@linux-foundation.org
Subject: + lumpy-move-to-using-pfn_valid_within.patch added to -mm tree
Date: Wed, 21 Mar 2007 16:45:34 -0700
Message-ID: <200703212345.l2LNjY7D007260@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59455 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195AbXCUXps (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 19:45:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, bob.picco@hp.com, mel@csn.ul.ie


The patch titled
     lumpy: move to using pfn_valid_within()
has been added to the -mm tree.  Its filename is
     lumpy-move-to-using-pfn_valid_within.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lumpy: move to using pfn_valid_within()
From: Andy Whitcroft <apw@shadowen.org>

Switch to using pfn_valid_within() in lumpy reclaim.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~lumpy-move-to-using-pfn_valid_within mm/vmscan.c
--- a/mm/vmscan.c~lumpy-move-to-using-pfn_valid_within
+++ a/mm/vmscan.c
@@ -717,11 +717,10 @@ static unsigned long isolate_lru_pages(u
 			/* The target page is in the block, ignore it. */
 			if (unlikely(pfn == page_pfn))
 				continue;
-#ifdef CONFIG_HOLES_IN_ZONE
+
 			/* Avoid holes within the zone. */
-			if (unlikely(!pfn_valid(pfn)))
+			if (unlikely(!pfn_valid_within(pfn)))
 				break;
-#endif
 
 			cursor_page = pfn_to_page(pfn);
 			/* Check that we have not crossed a zone boundary. */
_

Patches currently in -mm which might be from apw@shadowen.org are

pci-device-ensure-sysdata-initialised-v2.patch
move-free-pages-between-lists-on-steal-fix.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
lumpy-reclaim-v4.patch
lumpy-back-out-removal-of-active-check-in-isolate_lru_pages.patch
lumpy-only-count-taken-pages-as-scanned.patch
add-pfn_valid_within-helper-for-sub-max_order-hole-detection.patch
anti-fragmentation-switch-over-to-pfn_valid_within.patch
lumpy-move-to-using-pfn_valid_within.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
