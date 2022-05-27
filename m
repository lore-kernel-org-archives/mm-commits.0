Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08E4FC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243706AbiE0Qey (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiE0Qex (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:34:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF9052523
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:34:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 431B961DE3
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B13C385A9;
        Fri, 27 May 2022 16:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669291;
        bh=fkfWYm1VPaQjT6Zn9//2jOjHAF7B7LdnEffgYYF7HOU=;
        h=Date:To:From:Subject:From;
        b=VSedGj2SN8GbK69mflUW9+j+SL7H6j/Nn9FEaqPi/DFGFtSxLSvOvA6efd3IVVSi/
         A8mcO0tyktRUAVrJEltUdmcoE/Hd6Hn/qvNk6GaPRdBM4VBzaN/+bRPtb3ZN31YPhM
         BUcICLJ0kOYmpmCa/nUCXV/pNmrVFs+3h2pJ6kYE=
Date:   Fri, 27 May 2022 09:34:50 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        renzhengeek@gmail.com, quic_qiancai@quicinc.com, osalvador@suse.de,
        opendmb@gmail.com, m.szyprowski@samsung.com, michael@walle.cc,
        mgorman@techsingularity.net, david@redhat.com,
        christophe.leroy@csgroup.eu, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-split-free-page-with-properly-free-memory-accounting-and-without-race.patch removed from -mm tree
Message-Id: <20220527163451.88B13C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: split free page with properly free memory accounting and without race
has been removed from the -mm tree.  Its filename was
     mm-split-free-page-with-properly-free-memory-accounting-and-without-race.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: split free page with properly free memory accounting and without race
Date: Thu, 26 May 2022 19:15:31 -0400

In isolate_single_pageblock(), free pages are checked without holding zone
lock, but they can go away in split_free_page() when zone lock is held.
Check the free page and its order again in split_free_page() when zone lock
is held. Recheck the page if the free page is gone under zone lock.

In addition, in split_free_page(), the free page was deleted from the page
list without changing free page accounting. Add the missing free page
accounting code.

Fix the type of order parameter in split_free_page().

Link: https://lore.kernel.org/lkml/20220525103621.987185e2ca0079f7b97b856d@linux-foundation.org/
Link: https://lkml.kernel.org/r/20220526231531.2404977-2-zi.yan@sent.com
Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Doug Berger <opendmb@gmail.com>
  Link: https://lore.kernel.org/linux-mm/c3932a6f-77fe-29f7-0c29-fe6b1c67ab7b@gmail.com/
Cc: David Hildenbrand <david@redhat.com>
Cc: Qian Cai <quic_qiancai@quicinc.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Eric Ren <renzhengeek@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michael Walle <michael@walle.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h       |    4 ++--
 mm/page_alloc.c     |   24 ++++++++++++++++++++----
 mm/page_isolation.c |   10 +++++++---
 3 files changed, 29 insertions(+), 9 deletions(-)

--- a/mm/internal.h~mm-split-free-page-with-properly-free-memory-accounting-and-without-race
+++ a/mm/internal.h
@@ -374,8 +374,8 @@ extern void *memmap_alloc(phys_addr_t si
 			  phys_addr_t min_addr,
 			  int nid, bool exact_nid);
 
-void split_free_page(struct page *free_page,
-				int order, unsigned long split_pfn_offset);
+int split_free_page(struct page *free_page,
+			unsigned int order, unsigned long split_pfn_offset);
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
--- a/mm/page_alloc.c~mm-split-free-page-with-properly-free-memory-accounting-and-without-race
+++ a/mm/page_alloc.c
@@ -1100,30 +1100,44 @@ done_merging:
  * @order:		the order of the page
  * @split_pfn_offset:	split offset within the page
  *
+ * Return -ENOENT if the free page is changed, otherwise 0
+ *
  * It is used when the free page crosses two pageblocks with different migratetypes
  * at split_pfn_offset within the page. The split free page will be put into
  * separate migratetype lists afterwards. Otherwise, the function achieves
  * nothing.
  */
-void split_free_page(struct page *free_page,
-				int order, unsigned long split_pfn_offset)
+int split_free_page(struct page *free_page,
+			unsigned int order, unsigned long split_pfn_offset)
 {
 	struct zone *zone = page_zone(free_page);
 	unsigned long free_page_pfn = page_to_pfn(free_page);
 	unsigned long pfn;
 	unsigned long flags;
 	int free_page_order;
+	int mt;
+	int ret = 0;
 
 	if (split_pfn_offset == 0)
-		return;
+		return ret;
 
 	spin_lock_irqsave(&zone->lock, flags);
+
+	if (!PageBuddy(free_page) || buddy_order(free_page) != order) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	mt = get_pageblock_migratetype(free_page);
+	if (likely(!is_migrate_isolate(mt)))
+		__mod_zone_freepage_state(zone, -(1UL << order), mt);
+
 	del_page_from_free_list(free_page, zone, order);
 	for (pfn = free_page_pfn;
 	     pfn < free_page_pfn + (1UL << order);) {
 		int mt = get_pfnblock_migratetype(pfn_to_page(pfn), pfn);
 
-		free_page_order = min_t(int,
+		free_page_order = min_t(unsigned int,
 					pfn ? __ffs(pfn) : order,
 					__fls(split_pfn_offset));
 		__free_one_page(pfn_to_page(pfn), pfn, zone, free_page_order,
@@ -1134,7 +1148,9 @@ void split_free_page(struct page *free_p
 		if (split_pfn_offset == 0)
 			split_pfn_offset = (1UL << order) - (pfn - free_page_pfn);
 	}
+out:
 	spin_unlock_irqrestore(&zone->lock, flags);
+	return ret;
 }
 /*
  * A bad page could be due to a number of fields. Instead of multiple branches,
--- a/mm/page_isolation.c~mm-split-free-page-with-properly-free-memory-accounting-and-without-race
+++ a/mm/page_isolation.c
@@ -371,9 +371,13 @@ static int isolate_single_pageblock(unsi
 		if (PageBuddy(page)) {
 			int order = buddy_order(page);
 
-			if (pfn + (1UL << order) > boundary_pfn)
-				split_free_page(page, order, boundary_pfn - pfn);
-			pfn += (1UL << order);
+			if (pfn + (1UL << order) > boundary_pfn) {
+				/* free page changed before split, check it again */
+				if (split_free_page(page, order, boundary_pfn - pfn))
+					continue;
+			}
+
+			pfn += 1UL << order;
 			continue;
 		}
 		/*
_

Patches currently in -mm which might be from ziy@nvidia.com are


