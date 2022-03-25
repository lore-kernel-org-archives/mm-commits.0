Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B07FC43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357405AbiCYBe5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357485AbiCYBdN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E04BF532
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2D8961947
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47503C340EC;
        Fri, 25 Mar 2022 01:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171884;
        bh=CrOf6OkR/Rc1TkCcIfPco4dcoKjCvfBEY6lgCIzktTw=;
        h=Date:To:From:Subject:From;
        b=IeNPQmS/Ggn3Job7rMbUV+r5w0Pgi+2s69R72zy2oW1sRwj/NRdk5kkVYY8BrpWti
         gJ/m7JWbsof2Jj51V9G9a9yb4ZrgA3fy7CJMXbZTvmprTQJrFsC70cBew2ehpdPwxj
         VKKliENwSN6Xi6gq67ecGEsiUnChkr6FM7h5y6P0=
Date:   Thu, 24 Mar 2022 18:31:23 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
        dave.hansen@linux.intel.com, brouer@redhat.com, aaron.lu@intel.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-page_alloc-fetch-the-correct-pcp-buddy-during-bulk-free.patch removed from -mm tree
Message-Id: <20220325013124.47503C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: fetch the correct pcp buddy during bulk free
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fetch-the-correct-pcp-buddy-during-bulk-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: fetch the correct pcp buddy during bulk free

Patch series "Follow-up on high-order PCP caching", v2.

Commit 44042b449872 ("mm/page_alloc: allow high-order pages to be stored
on the per-cpu lists") was primarily aimed at reducing the cost of SLUB
cache refills of high-order pages in two ways.  Firstly, zone lock
acquisitions was reduced and secondly, there were fewer buddy list
modifications.  This is a follow-up series fixing some issues that became
apparant after merging.

Patch 1 is a functional fix. It's harmless but inefficient.

Patches 2-5 reduce the overhead of bulk freeing of PCP pages.  While the
overhead is small, it's cumulative and noticable when truncating large
files.  The changelog for patch 4 includes results of a microbench that
deletes large sparse files with data in page cache.  Sparse files were
used to eliminate filesystem overhead.

Patch 6 addresses issues with high-order PCP pages being stored on PCP
lists for too long.  Pages freed on a CPU potentially may not be quickly
reused and in some cases this can increase cache miss rates.  Details are
included in the changelog.


This patch (of 6):

free_pcppages_bulk() prefetches buddies about to be freed but the order
must also be passed in as PCP lists store multiple orders.

Link: https://lkml.kernel.org/r/20220217002227.5739-1-mgorman@techsingularity.net
Link: https://lkml.kernel.org/r/20220217002227.5739-2-mgorman@techsingularity.net
Fixes: 44042b449872 ("mm/page_alloc: allow high-order pages to be stored on the per-cpu lists")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Aaron Lu <aaron.lu@intel.com>
Tested-by: Aaron Lu <aaron.lu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fetch-the-correct-pcp-buddy-during-bulk-free
+++ a/mm/page_alloc.c
@@ -1429,10 +1429,10 @@ static bool bulkfree_pcp_prepare(struct
 }
 #endif /* CONFIG_DEBUG_VM */
 
-static inline void prefetch_buddy(struct page *page)
+static inline void prefetch_buddy(struct page *page, unsigned int order)
 {
 	unsigned long pfn = page_to_pfn(page);
-	unsigned long buddy_pfn = __find_buddy_pfn(pfn, 0);
+	unsigned long buddy_pfn = __find_buddy_pfn(pfn, order);
 	struct page *buddy = page + (buddy_pfn - pfn);
 
 	prefetch(buddy);
@@ -1509,7 +1509,7 @@ static void free_pcppages_bulk(struct zo
 			 * prefetch buddy for the first pcp->batch nr of pages.
 			 */
 			if (prefetch_nr) {
-				prefetch_buddy(page);
+				prefetch_buddy(page, order);
 				prefetch_nr--;
 			}
 		} while (count > 0 && --batch_free && !list_empty(list));
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


