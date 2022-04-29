Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9C8C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 16:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359269AbiD2QlW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235788AbiD2QlV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 12:41:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309F1D95E0
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 09:38:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E595B83698
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 16:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBAAC385A4;
        Fri, 29 Apr 2022 16:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651250278;
        bh=f1+dAiuJj5mzpU/1xdBqKLgTi3f/22+apzU3Ok+SgyM=;
        h=Date:To:From:Subject:From;
        b=JpT0r4e3SHnXPgY3q1F+fJ8gLCRkmjczoLRI6AeRCaOpg6qdvDRYntGmwGZsY+fdo
         Xps3oyC9gadANTZAdYzZcwYAdyBvZa1aSuCXrjRQwRLUE87ihycBptsUv37mpzzu95
         bO+hEnez8li1M1j5tvaTyIhx3gTCoAY7rXK6g+RA=
Date:   Fri, 29 Apr 2022 09:37:57 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, sfr@canb.auug.org.au,
        rppt@linux.ibm.com, renzhengeek@gmail.com,
        quic_qiancai@quicinc.com, osalvador@suse.de, minchan@kernel.org,
        mgorman@techsingularity.net, david@redhat.com,
        christophe.leroy@csgroup.eu, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-alloc_contig_range-work-at-pageblock-granularity-fix.patch added to mm-unstable branch
Message-Id: <20220429163758.8EBAAC385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-make-alloc_contig_range-work-at-pageblock-granularity-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-alloc_contig_range-work-at-pageblock-granularity-fix.patch

This patch should soon appear in the mm-unstable branch at
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
mm-make-alloc_contig_range-work-at-pageblock-granularity-fix.patch
mm-page_isolation-enable-arbitrary-range-page-isolation.patch
mm-cma-use-pageblock_order-as-the-single-alignment.patch
drivers-virtio_mem-use-pageblock-size-as-the-minimum-virtio_mem-size.patch

