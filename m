From: akpm@linux-foundation.org
Subject: [merged] mm-alloc_contig_range-allow-to-specify-gfp-mask.patch
 removed from -mm tree
Date: Mon, 27 Feb 2017 12:26:50 -0800
Message-ID: <58b48b8a.ha+lJMw6tcXhXZ+E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60398 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751760AbdB0U16 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:27:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: l.stach@pengutronix.de, agraf@suse.com, catalin.marinas@arm.com, chris@zankel.net, iamjoonsoo.kim@lge.com, mhocko@suse.com, pbonzini@redhat.com, ralf@linux-mips.org, rkrcmar@redhat.com, vbabka@suse.cz, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: alloc_contig_range: allow to specify GFP mask
has been removed from the -mm tree.  Its filename was
     mm-alloc_contig_range-allow-to-specify-gfp-mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lucas Stach <l.stach@pengutronix.de>
Subject: mm: alloc_contig_range: allow to specify GFP mask

Currently alloc_contig_range assumes that the compaction should be done
with the default GFP_KERNEL flags.  This is probably right for all current
uses of this interface, but may change as CMA is used in more use-cases
(including being the default DMA memory allocator on some platforms).

Change the function prototype, to allow for passing through the GFP mask
set by upper layers.

Also respect global restrictions by applying memalloc_noio_flags to the
passed in flags.

Link: http://lkml.kernel.org/r/20170127172328.18574-1-l.stach@pengutronix.de
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Radim Krcmar <rkrcmar@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexander Graf <agraf@suse.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 mm/cma.c            |    3 ++-
 mm/hugetlb.c        |    3 ++-
 mm/page_alloc.c     |    5 +++--
 4 files changed, 8 insertions(+), 5 deletions(-)

diff -puN include/linux/gfp.h~mm-alloc_contig_range-allow-to-specify-gfp-mask include/linux/gfp.h
--- a/include/linux/gfp.h~mm-alloc_contig_range-allow-to-specify-gfp-mask
+++ a/include/linux/gfp.h
@@ -541,7 +541,7 @@ static inline bool pm_suspended_storage(
 #if (defined(CONFIG_MEMORY_ISOLATION) && defined(CONFIG_COMPACTION)) || defined(CONFIG_CMA)
 /* The below functions must be run on a range from a single zone. */
 extern int alloc_contig_range(unsigned long start, unsigned long end,
-			      unsigned migratetype);
+			      unsigned migratetype, gfp_t gfp_mask);
 extern void free_contig_range(unsigned long pfn, unsigned nr_pages);
 #endif
 
diff -puN mm/cma.c~mm-alloc_contig_range-allow-to-specify-gfp-mask mm/cma.c
--- a/mm/cma.c~mm-alloc_contig_range-allow-to-specify-gfp-mask
+++ a/mm/cma.c
@@ -402,7 +402,8 @@ struct page *cma_alloc(struct cma *cma,
 
 		pfn = cma->base_pfn + (bitmap_no << cma->order_per_bit);
 		mutex_lock(&cma_mutex);
-		ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA);
+		ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA,
+					 GFP_KERNEL);
 		mutex_unlock(&cma_mutex);
 		if (ret == 0) {
 			page = pfn_to_page(pfn);
diff -puN mm/hugetlb.c~mm-alloc_contig_range-allow-to-specify-gfp-mask mm/hugetlb.c
--- a/mm/hugetlb.c~mm-alloc_contig_range-allow-to-specify-gfp-mask
+++ a/mm/hugetlb.c
@@ -1052,7 +1052,8 @@ static int __alloc_gigantic_page(unsigne
 				unsigned long nr_pages)
 {
 	unsigned long end_pfn = start_pfn + nr_pages;
-	return alloc_contig_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
+	return alloc_contig_range(start_pfn, end_pfn, MIGRATE_MOVABLE,
+				  GFP_KERNEL);
 }
 
 static bool pfn_range_valid_gigantic(struct zone *z,
diff -puN mm/page_alloc.c~mm-alloc_contig_range-allow-to-specify-gfp-mask mm/page_alloc.c
--- a/mm/page_alloc.c~mm-alloc_contig_range-allow-to-specify-gfp-mask
+++ a/mm/page_alloc.c
@@ -7399,6 +7399,7 @@ static int __alloc_contig_migrate_range(
  *			#MIGRATE_MOVABLE or #MIGRATE_CMA).  All pageblocks
  *			in range must have the same migratetype and it must
  *			be either of the two.
+ * @gfp_mask:	GFP mask to use during compaction
  *
  * The PFN range does not have to be pageblock or MAX_ORDER_NR_PAGES
  * aligned, however it's the caller's responsibility to guarantee that
@@ -7412,7 +7413,7 @@ static int __alloc_contig_migrate_range(
  * need to be freed with free_contig_range().
  */
 int alloc_contig_range(unsigned long start, unsigned long end,
-		       unsigned migratetype)
+		       unsigned migratetype, gfp_t gfp_mask)
 {
 	unsigned long outer_start, outer_end;
 	unsigned int order;
@@ -7424,7 +7425,7 @@ int alloc_contig_range(unsigned long sta
 		.zone = page_zone(pfn_to_page(start)),
 		.mode = MIGRATE_SYNC,
 		.ignore_skip_hint = true,
-		.gfp_mask = GFP_KERNEL,
+		.gfp_mask = memalloc_noio_flags(gfp_mask),
 	};
 	INIT_LIST_HEAD(&cc.migratepages);
 
_

Patches currently in -mm which might be from l.stach@pengutronix.de are


