From: akpm@linux-foundation.org
Subject: + add-pfn_valid_within-helper-for-sub-max_order-hole-detection.patch added to -mm tree
Date: Wed, 21 Mar 2007 16:45:29 -0700
Message-ID: <200703212345.l2LNjUZJ007253@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59453 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933946AbXCUXpq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 19:45:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, bob.picco@hp.com, mel@csn.ul.ie


The patch titled
     add pfn_valid_within helper for sub-MAX_ORDER hole detection
has been added to the -mm tree.  Its filename is
     add-pfn_valid_within-helper-for-sub-max_order-hole-detection.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add pfn_valid_within helper for sub-MAX_ORDER hole detection
From: Andy Whitcroft <apw@shadowen.org>

Generally we work under the assumption that memory the mem_map array is
contigious and valid out to MAX_ORDER_NR_PAGES block of pages, ie.  that if we
have validated any page within this MAX_ORDER_NR_PAGES block we need not check
any other.  This is not true when CONFIG_HOLES_IN_ZONE is set and we must
check each and every reference we make from a pfn.

Add a pfn_valid_within() helper which should be used when scanning pages
within a MAX_ORDER_NR_PAGES block when we have already checked the validility
of the block normally with pfn_valid().  This can then be optimised away when
we do not have holes within a MAX_ORDER_NR_PAGES block of pages.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   12 ++++++++++++
 mm/page_alloc.c        |    8 ++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff -puN include/linux/mmzone.h~add-pfn_valid_within-helper-for-sub-max_order-hole-detection include/linux/mmzone.h
--- a/include/linux/mmzone.h~add-pfn_valid_within-helper-for-sub-max_order-hole-detection
+++ a/include/linux/mmzone.h
@@ -832,6 +832,18 @@ void sparse_init(void);
 void memory_present(int nid, unsigned long start, unsigned long end);
 unsigned long __init node_memmap_size_bytes(int, unsigned long, unsigned long);
 
+/*
+ * If it is possible to have holes within a MAX_ORDER_NR_PAGES, then we
+ * need to check pfn validility within that MAX_ORDER_NR_PAGES block.
+ * pfn_valid_within() should be used in this case; we optimise this away
+ * when we have no holes within a MAX_ORDER_NR_PAGES block.
+ */
+#ifdef CONFIG_HOLES_IN_ZONE
+#define pfn_valid_within(pfn) pfn_valid(pfn)
+#else
+#define pfn_valid_within(pfn) (1)
+#endif
+
 #endif /* !__ASSEMBLY__ */
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MMZONE_H */
diff -puN mm/page_alloc.c~add-pfn_valid_within-helper-for-sub-max_order-hole-detection mm/page_alloc.c
--- a/mm/page_alloc.c~add-pfn_valid_within-helper-for-sub-max_order-hole-detection
+++ a/mm/page_alloc.c
@@ -206,10 +206,8 @@ static int page_outside_zone_boundaries(
 
 static int page_is_consistent(struct zone *zone, struct page *page)
 {
-#ifdef CONFIG_HOLES_IN_ZONE
-	if (!pfn_valid(page_to_pfn(page)))
+	if (!pfn_valid_within(page_to_pfn(page)))
 		return 0;
-#endif
 	if (zone != page_zone(page))
 		return 0;
 
@@ -396,10 +394,8 @@ __find_combined_index(unsigned long page
 static inline int page_is_buddy(struct page *page, struct page *buddy,
 								int order)
 {
-#ifdef CONFIG_HOLES_IN_ZONE
-	if (!pfn_valid(page_to_pfn(buddy)))
+	if (!pfn_valid_within(page_to_pfn(buddy)))
 		return 0;
-#endif
 
 	if (page_zone_id(page) != page_zone_id(buddy))
 		return 0;
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
