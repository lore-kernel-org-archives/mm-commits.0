Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CFDAC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 19:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243765AbiDYTFd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 15:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244844AbiDYTFc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 15:05:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A4412C8D4
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 12:02:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 549C5B819E8
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 19:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140EFC385A4;
        Mon, 25 Apr 2022 19:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650913334;
        bh=eiukYcyvUz/4ohbTqokckiGcwn1alp8vxlabWYK3B5k=;
        h=Date:To:From:Subject:From;
        b=cBLqq68moUrRYs+iR7zNYW2SIFFN2c5Pka6jGzIpzAQcsLQqYG4UqJT1hYrjaL/oa
         5QhFvhJgqIAyvsFEZLzpjpcHcA5BPdNYZzEf1ZXEj7extIkchOAEr3imO7TRlNsKLl
         r1KbCFdaYziyDKmj0BQEVuyzGsCFPxh/UXoORguc=
Date:   Mon, 25 Apr 2022 12:02:13 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@linux.ibm.com,
        renzhengeek@gmail.com, osalvador@suse.de, minchan@kernel.org,
        mgorman@techsingularity.net, lkp@intel.com, david@redhat.com,
        christophe.leroy@csgroup.eu, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-use-pageblock_order-as-the-single-alignment.patch added to -mm tree
Message-Id: <20220425190214.140EFC385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: use pageblock_order as the single alignment
has been added to the -mm tree.  Its filename is
     mm-cma-use-pageblock_order-as-the-single-alignment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-cma-use-pageblock_order-as-the-single-alignment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-use-pageblock_order-as-the-single-alignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -9014,8 +9014,8 @@ int __alloc_contig_migrate_range(struct
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

mm-page_alloc-simplify-pageblock-migratetype-check-in-__free_one_page.patch
mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation.patch
mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation-v4.patch
mm-page_isolation-move-has_unmovable_pages-to-mm-page_isolationc.patch
mm-page_isolation-check-specified-range-for-unmovable-pages.patch
mm-make-alloc_contig_range-work-at-pageblock-granularity.patch
mm-page_isolation-enable-arbitrary-range-page-isolation.patch
mm-cma-use-pageblock_order-as-the-single-alignment.patch
drivers-virtio_mem-use-pageblock-size-as-the-minimum-virtio_mem-size.patch

