Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF445C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 02:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376622AbiEMC5O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 22:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358819AbiEMC5K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 22:57:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE9553709
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 19:57:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79FD36212C
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 02:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC09C385B8;
        Fri, 13 May 2022 02:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652410621;
        bh=xO0BH06Z7xIYhCzN6D5Hnt6YmLrk3pemZc5x5spSEGg=;
        h=Date:To:From:Subject:From;
        b=ajbefzZIXme9xXxzpyFdoJ0BL0IPa6qyKYR7UtMzB1m4tAuw1+ysZ8tbjilSMhyb7
         p/GoClGyEkfXnkpD5RSUbJl7jNGfN67UoTLQjCdB1QttlG6YQ1YHvOMsrbe5gib/7I
         3gCZ0JpT6XoDPRIXXCZ5jJ0YqC8aCYSviOXkdDUI=
Date:   Thu, 12 May 2022 19:57:01 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, sfr@canb.auug.org.au,
        rppt@linux.ibm.com, renzhengeek@gmail.com,
        quic_qiancai@quicinc.com, osalvador@suse.de, minchan@kernel.org,
        mgorman@techsingularity.net, david@redhat.com,
        christophe.leroy@csgroup.eu, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-make-alloc_contig_range-work-at-pageblock-granularity-fix.patch removed from -mm tree
Message-Id: <20220513025701.CCC09C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-make-alloc_contig_range-work-at-pageblock-granularity-fix
has been removed from the -mm tree.  Its filename was
     mm-make-alloc_contig_range-work-at-pageblock-granularity-fix.patch

This patch was dropped because it was folded into mm-make-alloc_contig_range-work-at-pageblock-granularity.patch

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm-make-alloc_contig_range-work-at-pageblock-granularity-fix

Fix deadlock/crash at https://lore.kernel.org/linux-mm/20220426201855.GA1014@qian/

Link: https://lkml.kernel.org/r/23A7297E-6C84-4138-A9FE-3598234004E6@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Qian Cai <quic_qiancai@quicinc.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Ren <renzhengeek@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   89 +++++++++++++++++++++++-------------------
 1 file changed, 49 insertions(+), 40 deletions(-)

--- a/mm/page_isolation.c~mm-make-alloc_contig_range-work-at-pageblock-granularity-fix
+++ a/mm/page_isolation.c
@@ -367,58 +367,67 @@ static int isolate_single_pageblock(unsi
 		}
 		/*
 		 * migrate compound pages then let the free page handling code
-		 * above do the rest. If migration is not enabled, just fail.
+		 * above do the rest. If migration is not possible, just fail.
 		 */
-		if (PageHuge(page) || PageTransCompound(page)) {
-#if defined CONFIG_COMPACTION || defined CONFIG_CMA
+		if (PageCompound(page)) {
 			unsigned long nr_pages = compound_nr(page);
-			int order = compound_order(page);
 			struct page *head = compound_head(page);
 			unsigned long head_pfn = page_to_pfn(head);
-			int ret;
-			struct compact_control cc = {
-				.nr_migratepages = 0,
-				.order = -1,
-				.zone = page_zone(pfn_to_page(head_pfn)),
-				.mode = MIGRATE_SYNC,
-				.ignore_skip_hint = true,
-				.no_set_skip_hint = true,
-				.gfp_mask = gfp_flags,
-				.alloc_contig = true,
-			};
-			INIT_LIST_HEAD(&cc.migratepages);
 
 			if (head_pfn + nr_pages < boundary_pfn) {
-				pfn += nr_pages;
+				pfn = head_pfn + nr_pages;
 				continue;
 			}
-
-			ret = __alloc_contig_migrate_range(&cc, head_pfn,
-						head_pfn + nr_pages);
-
-			if (ret)
-				goto failed;
+#if defined CONFIG_COMPACTION || defined CONFIG_CMA
 			/*
-			 * reset pfn, let the free page handling code above
-			 * split the free page to the right migratetype list.
-			 *
-			 * head_pfn is not used here as a hugetlb page order
-			 * can be bigger than MAX_ORDER-1, but after it is
-			 * freed, the free page order is not. Use pfn within
-			 * the range to find the head of the free page and
-			 * reset order to 0 if a hugetlb page with
-			 * >MAX_ORDER-1 order is encountered.
+			 * hugetlb, lru compound (THP), and movable compound pages
+			 * can be migrated. Otherwise, fail the isolation.
 			 */
-			if (order > MAX_ORDER-1)
+			if (PageHuge(page) || PageLRU(page) || __PageMovable(page)) {
+				int order;
+				unsigned long outer_pfn;
+				int ret;
+				struct compact_control cc = {
+					.nr_migratepages = 0,
+					.order = -1,
+					.zone = page_zone(pfn_to_page(head_pfn)),
+					.mode = MIGRATE_SYNC,
+					.ignore_skip_hint = true,
+					.no_set_skip_hint = true,
+					.gfp_mask = gfp_flags,
+					.alloc_contig = true,
+				};
+				INIT_LIST_HEAD(&cc.migratepages);
+
+				ret = __alloc_contig_migrate_range(&cc, head_pfn,
+							head_pfn + nr_pages);
+
+				if (ret)
+					goto failed;
+				/*
+				 * reset pfn to the head of the free page, so
+				 * that the free page handling code above can split
+				 * the free page to the right migratetype list.
+				 *
+				 * head_pfn is not used here as a hugetlb page order
+				 * can be bigger than MAX_ORDER-1, but after it is
+				 * freed, the free page order is not. Use pfn within
+				 * the range to find the head of the free page.
+				 */
 				order = 0;
-			while (!PageBuddy(pfn_to_page(pfn))) {
-				order++;
-				pfn &= ~0UL << order;
-			}
-			continue;
-#else
-			goto failed;
+				outer_pfn = pfn;
+				while (!PageBuddy(pfn_to_page(outer_pfn))) {
+					if (++order >= MAX_ORDER) {
+						outer_pfn = pfn;
+						break;
+					}
+					outer_pfn &= ~0UL << order;
+				}
+				pfn = outer_pfn;
+				continue;
+			} else
 #endif
+				goto failed;
 		}
 
 		pfn++;
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_isolation-move-has_unmovable_pages-to-mm-page_isolationc.patch
mm-page_isolation-check-specified-range-for-unmovable-pages.patch
mm-make-alloc_contig_range-work-at-pageblock-granularity.patch
mm-page_isolation-enable-arbitrary-range-page-isolation.patch
mm-cma-use-pageblock_order-as-the-single-alignment.patch
drivers-virtio_mem-use-pageblock-size-as-the-minimum-virtio_mem-size.patch

