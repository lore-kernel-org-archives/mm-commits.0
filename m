From: akpm@linux-foundation.org
Subject: + anti-fragmentation-switch-over-to-pfn_valid_within.patch added to -mm tree
Date: Wed, 21 Mar 2007 16:45:32 -0700
Message-ID: <200703212345.l2LNjWDH007257@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59454 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934011AbXCUXpr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 19:45:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, andyw@uk.ibm.com, bob.picco@hp.com, mel@csn.ul.ie


The patch titled
     anti-fragmentation: switch over to pfn_valid_within()
has been added to the -mm tree.  Its filename is
     anti-fragmentation-switch-over-to-pfn_valid_within.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: anti-fragmentation: switch over to pfn_valid_within()
From: Andy Whitcroft <apw@shadowen.org>

Move to using pfn_valid_within().

Signed-off-by: Andy Whitcroft <andyw@uk.ibm.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/page_alloc.c~anti-fragmentation-switch-over-to-pfn_valid_within mm/page_alloc.c
--- a/mm/page_alloc.c~anti-fragmentation-switch-over-to-pfn_valid_within
+++ a/mm/page_alloc.c
@@ -700,12 +700,10 @@ int move_freepages(struct zone *zone,
 #endif
 
 	for (page = start_page; page < end_page;) {
-#ifdef CONFIG_HOLES_IN_ZONE
-		if (!pfn_valid(page_to_pfn(page))) {
+		if (!pfn_valid_within(page_to_pfn(page))) {
 			page++;
 			continue;
 		}
-#endif
 
 		if (!PageBuddy(page)) {
 			page++;
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
