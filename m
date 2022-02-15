Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB76C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 15 Feb 2022 21:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242772AbiBOVfb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 16:35:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234566AbiBOVf3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 16:35:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F639AD87
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 13:35:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B289A618F8
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 21:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061DCC340EC;
        Tue, 15 Feb 2022 21:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644960918;
        bh=5swR1KjhbPQa8H53qvgxZIViQvz1DAV8n0dlUEaqegA=;
        h=Date:To:From:Subject:From;
        b=ME/pShpy/5MlKjQLiCBcDv8YGFVUrCMhnPv7MT6UmY7CXubt+Uj6GWGjcMng18S7b
         z+sBqIG10FDcbdG1mg7UP4A+PRDbDqvDK5hWJUabF/UzIUZK2zLmuEuDDUkpeLODaK
         aOA94MMEaCXUajl29bn30TfMK0Edvhu3ATJpXKAw=
Date:   Tue, 15 Feb 2022 13:35:17 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
        dave.hansen@linux.intel.com, brouer@redhat.com, aaron.lu@intel.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fetch-the-correct-pcp-buddy-during-bulk-free.patch added to -mm tree
Message-Id: <20220215213518.061DCC340EC@smtp.kernel.org>
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

Patch series "Follow-up on high-order PCP caching".

Commit 44042b449872 ("mm/page_alloc: allow high-order pages to be stored
on the per-cpu lists") was primarily aimed at reducing the cost of SLUB
cache refills of high-order pages in two ways.  Firstly, zone lock
acquisitions was reduced and secondly, there were fewer buddy list
modifications.  This is a follow-up series fixing some issues that became
apparant after merging.

Patch 1 is a functional fix.  It's harmless but inefficient.

Patches 2-4 reduce the overhead of bulk freeing of PCP pages.  While the
overhead is small, it's cumulative and noticable when truncating large
files.  The changelog for patch 4 includes results of a microbench that
deletes large sparse files with data in page cache.  Sparse files were
used to eliminate filesystem overhead.

Patch 5 addresses issues with high-order PCP pages being stored on PCP
lists for too long.  Pages freed on a CPU potentially may not be quickly
reused and in some cases this can increase cache miss rates.  Details are
included in the changelog.


This patch (of 5):

free_pcppages_bulk() prefetches buddies about to be freed but the order
must also be passed in as PCP lists store multiple orders.

Link: https://lkml.kernel.org/r/20220215145111.27082-1-mgorman@techsingularity.net
Link: https://lkml.kernel.org/r/20220215145111.27082-2-mgorman@techsingularity.net
Fixes: 44042b449872 ("mm/page_alloc: allow high-order pages to be stored on the per-cpu lists")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
mm-page_alloc-free-pages-in-a-single-pass-during-bulk-free.patch
mm-page_alloc-limit-number-of-high-order-pages-on-pcp-during-bulk-free.patch

