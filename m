Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1EEC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 17 Feb 2022 01:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiBQB1T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Feb 2022 20:27:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiBQB1S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Feb 2022 20:27:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2331C24BE
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 17:27:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1652B81002
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 01:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8F2C004E1;
        Thu, 17 Feb 2022 01:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645061221;
        bh=14jSV94dd3xMwmXKhNBbFVrqo9ZaUa2W9jNHLOtwcQI=;
        h=Date:To:From:Subject:From;
        b=jok5xUeoCYzd2Qm8d3QiCbIOf/TJSA9VAXlUr0LaFOnGPWPQOL+lv+bYK54HO2BCD
         36c6kdhK+IahTIRfI6RnjP6AL+h/Uk8fy2OJBxMqSmKvLRQ7YhtOreDjrN1yOPB8la
         1I2sYkEODJiKY/WGlN2QJSfXVI92msyr9sF8zsOU=
Date:   Wed, 16 Feb 2022 17:27:00 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
        dave.hansen@linux.intel.com, brouer@redhat.com, aaron.lu@intel.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fetch-the-correct-pcp-buddy-during-bulk-free.patch added to -mm tree
Message-Id: <20220217012701.4E8F2C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: fetch the correct pcp buddy during bulk free
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fetch-the-correct-pcp-buddy-during-bulk-free.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fetch-the-correct-pcp-buddy-during-bulk-free.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fetch-the-correct-pcp-buddy-during-bulk-free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fetch-the-correct-pcp-buddy-during-bulk-free
+++ a/mm/page_alloc.c
@@ -1432,10 +1432,10 @@ static bool bulkfree_pcp_prepare(struct
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
@@ -1512,7 +1512,7 @@ static void free_pcppages_bulk(struct zo
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

mm-page_alloc-fetch-the-correct-pcp-buddy-during-bulk-free.patch
mm-page_alloc-track-range-of-active-pcp-lists-during-bulk-free.patch
mm-page_alloc-simplify-how-many-pages-are-selected-per-pcp-list-during-bulk-free.patch
mm-page_alloc-drain-the-requested-list-first-during-bulk-free.patch
mm-page_alloc-free-pages-in-a-single-pass-during-bulk-free.patch
mm-page_alloc-limit-number-of-high-order-pages-on-pcp-during-bulk-free.patch

