Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A952ECA0ED0
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 03:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbjILDTz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 23:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242323AbjILDLX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 23:11:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4719F900D3;
        Mon, 11 Sep 2023 19:07:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E798DC433D9;
        Mon, 11 Sep 2023 21:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694466057;
        bh=643GfPbprEsbqWcpIfBHQtKx2WQZ0BbufwN2QRQ1Czo=;
        h=Date:To:From:Subject:From;
        b=XwkQb32jsM844VD4aqikPBRWIwLOBfz1dreWNIKNT7jQNsDt1iC2fJHCfdOm+sI1t
         bGaJBf/DgQiSG+lWdKwxf2iftbg1lad9IAyBJn6y3NAqsBI1CLgBoYcy4c/kfoBj9+
         e4cEQ4rX33wYBl08P/T5AyYrk6nCoUyCJPGZIIUg=
Date:   Mon, 11 Sep 2023 14:00:56 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        joe.liu@mediatek.com, hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-cma-and-highatomic-landing-on-the-wrong-buddy-list.patch added to mm-hotfixes-unstable branch
Message-Id: <20230911210056.E798DC433D9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: fix CMA and HIGHATOMIC landing on the wrong buddy list
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-fix-cma-and-highatomic-landing-on-the-wrong-buddy-list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-cma-and-highatomic-landing-on-the-wrong-buddy-list.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: fix CMA and HIGHATOMIC landing on the wrong buddy list
Date: Mon, 11 Sep 2023 14:11:08 -0400

Commit 4b23a68f9536 ("mm/page_alloc: protect PCP lists with a spinlock")
bypasses the pcplist on lock contention and returns the page directly to
the buddy list of the page's migratetype.

For pages that don't have their own pcplist, such as CMA and HIGHATOMIC,
the migratetype is temporarily updated such that the page can hitch a ride
on the MOVABLE pcplist.  Their true type is later reassessed when flushing
in free_pcppages_bulk().  However, when lock contention is detected after
the type was already overriden, the bypass will then put the page on the
wrong buddy list.

Once on the MOVABLE buddy list, the page becomes eligible for fallbacks
and even stealing.  In the case of HIGHATOMIC, otherwise ineligible
allocations can dip into the highatomic reserves.  In the case of CMA, the
page can be lost from the CMA region permanently.

Use a separate pcpmigratetype variable for the pcplist override.  Use the
original migratetype when going directly to the buddy.  This fixes the bug
and should make the intentions more obvious in the code.

Originally sent here to address the HIGHATOMIC case:
https://lore.kernel.org/lkml/20230821183733.106619-4-hannes@cmpxchg.org/

Changelog updated in response to the CMA-specific bug report.

[mgorman@techsingularity.net: updated changelog]
Link: https://lkml.kernel.org/r/20230911181108.GA104295@cmpxchg.org
Fixes: 4b23a68f9536 ("mm/page_alloc: protect PCP lists with a spinlock")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Joe Liu <joe.liu@mediatek.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-cma-and-highatomic-landing-on-the-wrong-buddy-list
+++ a/mm/page_alloc.c
@@ -2400,7 +2400,7 @@ void free_unref_page(struct page *page,
 	struct per_cpu_pages *pcp;
 	struct zone *zone;
 	unsigned long pfn = page_to_pfn(page);
-	int migratetype;
+	int migratetype, pcpmigratetype;
 
 	if (!free_unref_page_prepare(page, pfn, order))
 		return;
@@ -2408,24 +2408,24 @@ void free_unref_page(struct page *page,
 	/*
 	 * We only track unmovable, reclaimable and movable on pcp lists.
 	 * Place ISOLATE pages on the isolated list because they are being
-	 * offlined but treat HIGHATOMIC as movable pages so we can get those
-	 * areas back if necessary. Otherwise, we may have to free
+	 * offlined but treat HIGHATOMIC and CMA as movable pages so we can
+	 * get those areas back if necessary. Otherwise, we may have to free
 	 * excessively into the page allocator
 	 */
-	migratetype = get_pcppage_migratetype(page);
+	migratetype = pcpmigratetype = get_pcppage_migratetype(page);
 	if (unlikely(migratetype >= MIGRATE_PCPTYPES)) {
 		if (unlikely(is_migrate_isolate(migratetype))) {
 			free_one_page(page_zone(page), page, pfn, order, migratetype, FPI_NONE);
 			return;
 		}
-		migratetype = MIGRATE_MOVABLE;
+		pcpmigratetype = MIGRATE_MOVABLE;
 	}
 
 	zone = page_zone(page);
 	pcp_trylock_prepare(UP_flags);
 	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (pcp) {
-		free_unref_page_commit(zone, pcp, page, migratetype, order);
+		free_unref_page_commit(zone, pcp, page, pcpmigratetype, order);
 		pcp_spin_unlock(pcp);
 	} else {
 		/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-fix-cma-and-highatomic-landing-on-the-wrong-buddy-list.patch
mm-page_alloc-remove-pcppage-migratetype-caching.patch
mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch
mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch
mm-page_alloc-fix-move_freepages_block-range-error.patch
mm-page_alloc-fix-freelist-movement-during-block-conversion.patch
mm-page_alloc-consolidate-free-page-accounting.patch

