Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74782C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383830AbiEMTWV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383767AbiEMTVb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C7A38783
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6F156CE330E
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF10C34100;
        Fri, 13 May 2022 19:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469686;
        bh=zPwDwHjAIxSiyMXBDicKlP/PDoXlIRvEWfq8bJl3Yy8=;
        h=Date:To:From:Subject:From;
        b=gAVqZzsOEn0Un7JBwWosAbOloFdn2aXC2wtZVn/FheQzPgbBNoJP8j+2qq5n3RFaY
         Qi2mSIan0Te5T6cTtBYFAmKAbeTYboBD4DYdUbxLhvxuifPOYQv6v8VqR7uKyIznxa
         NFJFkYA1gegFT6XJLipe/VlXN4brd4+1UwfCu/Lg=
Date:   Fri, 13 May 2022 12:21:26 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@linux.ibm.com,
        renzhengeek@gmail.com, osalvador@suse.de, minchan@kernel.org,
        mgorman@techsingularity.net, lkp@intel.com, david@redhat.com,
        christophe.leroy@csgroup.eu, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-use-pageblock_order-as-the-single-alignment.patch removed from -mm tree
Message-Id: <20220513192126.CCF10C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: cma: use pageblock_order as the single alignment
has been removed from the -mm tree.  Its filename was
     mm-cma-use-pageblock_order-as-the-single-alignment.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: cma: use pageblock_order as the single alignment

Now alloc_contig_range() works at pageblock granularity.  Change CMA
allocation, which uses alloc_contig_range(), to use pageblock_nr_pages
alignment.

Link: https://lkml.kernel.org/r/20220425143118.2850746-6-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Ren <renzhengeek@gmail.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h    |    4 ++--
 include/linux/mmzone.h |    5 +----
 mm/page_alloc.c        |    4 ++--
 3 files changed, 5 insertions(+), 8 deletions(-)

--- a/include/linux/cma.h~mm-cma-use-pageblock_order-as-the-single-alignment
+++ a/include/linux/cma.h
@@ -17,11 +17,11 @@
 #define CMA_MAX_NAME 64
 
 /*
- * TODO: once the buddy -- especially pageblock merging and alloc_contig_range()
+ *  the buddy -- especially pageblock merging and alloc_contig_range()
  * -- can deal with only some pageblocks of a higher-order page being
  *  MIGRATE_CMA, we can use pageblock_nr_pages.
  */
-#define CMA_MIN_ALIGNMENT_PAGES MAX_ORDER_NR_PAGES
+#define CMA_MIN_ALIGNMENT_PAGES pageblock_nr_pages
 #define CMA_MIN_ALIGNMENT_BYTES (PAGE_SIZE * CMA_MIN_ALIGNMENT_PAGES)
 
 struct cma;
--- a/include/linux/mmzone.h~mm-cma-use-pageblock_order-as-the-single-alignment
+++ a/include/linux/mmzone.h
@@ -54,10 +54,7 @@ enum migratetype {
 	 *
 	 * The way to use it is to change migratetype of a range of
 	 * pageblocks to MIGRATE_CMA which can be done by
-	 * __free_pageblock_cma() function.  What is important though
-	 * is that a range of pageblocks must be aligned to
-	 * MAX_ORDER_NR_PAGES should biggest page be bigger than
-	 * a single pageblock.
+	 * __free_pageblock_cma() function.
 	 */
 	MIGRATE_CMA,
 #endif
--- a/mm/page_alloc.c~mm-cma-use-pageblock_order-as-the-single-alignment
+++ a/mm/page_alloc.c
@@ -9046,8 +9046,8 @@ int __alloc_contig_migrate_range(struct
  *			be either of the two.
  * @gfp_mask:	GFP mask to use during compaction
  *
- * The PFN range does not have to be pageblock or MAX_ORDER_NR_PAGES
- * aligned.  The PFN range must belong to a single zone.
+ * The PFN range does not have to be pageblock aligned. The PFN range must
+ * belong to a single zone.
  *
  * The first thing this routine does is attempt to MIGRATE_ISOLATE all
  * pageblocks in the range.  Once isolated, the pageblocks should not
_

Patches currently in -mm which might be from ziy@nvidia.com are


