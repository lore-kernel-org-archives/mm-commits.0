Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3211C6FD1D
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 21:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjCUV2M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 17:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbjCUV2H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 17:28:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1783A113E9
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 14:28:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1CE5B81A3A
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 21:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3DEC433EF;
        Tue, 21 Mar 2023 21:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679434083;
        bh=J03ylho3skj81wI4UpJSREtvt/gNv04f7oOrlrGfr8M=;
        h=Date:To:From:Subject:From;
        b=EAMfYbwW3pUzSlHiiE6NTK0NjpbwQ17wDVTlvbZxWYAPNsWubDmDIG8/7PWSIfswl
         mo3f0VUcdvq/wdmU6ItdsBB9nQS+j2EpDAzVXyRC3eDbgwRaXUcfg9W5Z29YUbb7UA
         4DuCMPEI3aCYUfsmd+wcpdLQGvh0fx4c4uoEQE04=
Date:   Tue, 21 Mar 2023 14:28:02 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mgorman@suse.de,
        david@redhat.com, kirill.shutemov@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-make-deferred-page-init-free-pages-in-max_order-blocks.patch added to mm-unstable branch
Message-Id: <20230321212803.5F3DEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: make deferred page init free pages in MAX_ORDER blocks
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-make-deferred-page-init-free-pages-in-max_order-blocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-make-deferred-page-init-free-pages-in-max_order-blocks.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/page_alloc: make deferred page init free pages in MAX_ORDER blocks
Date: Tue, 21 Mar 2023 03:24:15 +0300

Normal page init path frees pages during the boot in MAX_ORDER chunks, but
deferred page init path does it in pageblock blocks.

Change deferred page init path to work in MAX_ORDER blocks.

For cases when MAX_ORDER is larger than pageblock, set migrate type to
MIGRATE_MOVABLE for all pageblocks covered by the page.

Link: https://lkml.kernel.org/r/20230321002415.20843-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/mm_init.c           |   19 ++++++++++---------
 2 files changed, 12 insertions(+), 9 deletions(-)

--- a/include/linux/mmzone.h~mm-page_alloc-make-deferred-page-init-free-pages-in-max_order-blocks
+++ a/include/linux/mmzone.h
@@ -32,6 +32,8 @@
 #endif
 #define MAX_ORDER_NR_PAGES (1 << MAX_ORDER)
 
+#define IS_MAX_ORDER_ALIGNED(pfn) IS_ALIGNED(pfn, MAX_ORDER_NR_PAGES)
+
 /*
  * PAGE_ALLOC_COSTLY_ORDER is the order at which allocations are deemed
  * costly to service.  That is between allocation orders which should
--- a/mm/mm_init.c~mm-page_alloc-make-deferred-page-init-free-pages-in-max_order-blocks
+++ a/mm/mm_init.c
@@ -1951,9 +1951,10 @@ static void __init deferred_free_range(u
 	page = pfn_to_page(pfn);
 
 	/* Free a large naturally-aligned chunk if possible */
-	if (nr_pages == pageblock_nr_pages && pageblock_aligned(pfn)) {
-		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
-		__free_pages_core(page, pageblock_order);
+	if (nr_pages == MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
+		for (i = 0; i < nr_pages; i += pageblock_nr_pages)
+			set_pageblock_migratetype(page + i, MIGRATE_MOVABLE);
+		__free_pages_core(page, MAX_ORDER);
 		return;
 	}
 
@@ -1977,19 +1978,19 @@ static inline void __init pgdat_init_rep
 /*
  * Returns true if page needs to be initialized or freed to buddy allocator.
  *
- * We check if a current large page is valid by only checking the validity
+ * We check if a current MAX_ORDER block is valid by only checking the validity
  * of the head pfn.
  */
 static inline bool __init deferred_pfn_valid(unsigned long pfn)
 {
-	if (pageblock_aligned(pfn) && !pfn_valid(pfn))
+	if (IS_MAX_ORDER_ALIGNED(pfn) && !pfn_valid(pfn))
 		return false;
 	return true;
 }
 
 /*
  * Free pages to buddy allocator. Try to free aligned pages in
- * pageblock_nr_pages sizes.
+ * MAX_ORDER_NR_PAGES sizes.
  */
 static void __init deferred_free_pages(unsigned long pfn,
 				       unsigned long end_pfn)
@@ -2000,7 +2001,7 @@ static void __init deferred_free_pages(u
 		if (!deferred_pfn_valid(pfn)) {
 			deferred_free_range(pfn - nr_free, nr_free);
 			nr_free = 0;
-		} else if (pageblock_aligned(pfn)) {
+		} else if (IS_MAX_ORDER_ALIGNED(pfn)) {
 			deferred_free_range(pfn - nr_free, nr_free);
 			nr_free = 1;
 		} else {
@@ -2013,7 +2014,7 @@ static void __init deferred_free_pages(u
 
 /*
  * Initialize struct pages.  We minimize pfn page lookups and scheduler checks
- * by performing it only once every pageblock_nr_pages.
+ * by performing it only once every MAX_ORDER_NR_PAGES.
  * Return number of pages initialized.
  */
 static unsigned long  __init deferred_init_pages(struct zone *zone,
@@ -2029,7 +2030,7 @@ static unsigned long  __init deferred_in
 		if (!deferred_pfn_valid(pfn)) {
 			page = NULL;
 			continue;
-		} else if (!page || pageblock_aligned(pfn)) {
+		} else if (!page || IS_MAX_ORDER_ALIGNED(pfn)) {
 			page = pfn_to_page(pfn);
 		} else {
 			page++;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

sparc-mm-fix-max_order-usage-in-tsb_grow.patch
um-fix-max_order-usage-in-linux_main.patch
floppy-fix-max_order-usage.patch
drm-i915-fix-max_order-usage-in-i915_gem_object_get_pages_internal.patch
genwqe-fix-max_order-usage.patch
perf-core-fix-max_order-usage-in-rb_alloc_aux_page.patch
mm-page_reporting-fix-max_order-usage-in-page_reporting_register.patch
mm-slub-fix-max_order-usage-in-calculate_order.patch
iommu-fix-max_order-usage-in-__iommu_dma_alloc_pages.patch
mm-treewide-redefine-max_order-sanely.patch
mm-page_alloc-make-deferred-page-init-free-pages-in-max_order-blocks.patch

