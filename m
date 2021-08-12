Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087F0C4338F
	for <mm-commits@archiver.kernel.org>; Thu, 12 Aug 2021 21:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D642760F57
	for <mm-commits@archiver.kernel.org>; Thu, 12 Aug 2021 21:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234075AbhHLVnu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Aug 2021 17:43:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232353AbhHLVnr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Aug 2021 17:43:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B78DB60F00;
        Thu, 12 Aug 2021 21:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628804601;
        bh=NEEPjDTlfPtUbzGNmgGLh9oon89ekjcGGq7061ZaZCY=;
        h=Date:From:To:Subject:From;
        b=Zb2X3arXxcaqrk8un8bwuK7tStJV9lgyHFpkT6qwl6UJo8zOcCbn0gTiGSsQbaYV/
         5QbXw/YogaTrcFKOCl5cWc3uZRmQ4Puft0wsKW92bXqVHxkiMMHd1efEkgv09/FxtJ
         m+gZ5lJDftaXc/uYPgdAT86PNQmOWuVLBR7mRX4I=
Date:   Thu, 12 Aug 2021 14:43:21 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, peterz@infradead.org,
        mgorman@techsingularity.net, opendmb@gmail.com
Subject:  + mm-page_alloc-dont-corrupt-pcppage_migratetype.patch
 added to -mm tree
Message-ID: <20210812214321.Hjior%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: don't corrupt pcppage_migratetype
has been added to the -mm tree.  Its filename is
     mm-page_alloc-dont-corrupt-pcppage_migratetype.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-dont-corrupt-pcppage_migratetype.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-dont-corrupt-pcppage_migratetype.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Doug Berger <opendmb@gmail.com>
Subject: mm/page_alloc: don't corrupt pcppage_migratetype

When placing pages on a pcp list, migratetype values over MIGRATE_PCPTYPES
get added to the MIGRATE_MOVABLE pcp list.

However, the actual migratetype is preserved in the page and should not be
changed to MIGRATE_MOVABLE or the page may end up on the wrong free_list.

The impact is that HIGHATOMIC or CMA pages getting bulk freed from the PCP
lists could potentially end up on the wrong buddy list.  There are various
consequences but minimally NR_FREE_CMA_PAGES accounting could get screwed
up.

[mgorman@techsingularity.net: changelog update]
Link: https://lkml.kernel.org/r/20210811182917.2607994-1-opendmb@gmail.com
Fixes: df1acc856923 ("mm/page_alloc: avoid conflating IRQs disabled with zone->lock")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-dont-corrupt-pcppage_migratetype
+++ a/mm/page_alloc.c
@@ -3453,19 +3453,10 @@ void free_unref_page_list(struct list_he
 		 * comment in free_unref_page.
 		 */
 		migratetype = get_pcppage_migratetype(page);
-		if (unlikely(migratetype >= MIGRATE_PCPTYPES)) {
-			if (unlikely(is_migrate_isolate(migratetype))) {
-				list_del(&page->lru);
-				free_one_page(page_zone(page), page, pfn, 0,
-							migratetype, FPI_NONE);
-				continue;
-			}
-
-			/*
-			 * Non-isolated types over MIGRATE_PCPTYPES get added
-			 * to the MIGRATE_MOVABLE pcp list.
-			 */
-			set_pcppage_migratetype(page, MIGRATE_MOVABLE);
+		if (unlikely(is_migrate_isolate(migratetype))) {
+			list_del(&page->lru);
+			free_one_page(page_zone(page), page, pfn, 0, migratetype, FPI_NONE);
+			continue;
 		}
 
 		set_page_private(page, pfn);
@@ -3475,7 +3466,15 @@ void free_unref_page_list(struct list_he
 	list_for_each_entry_safe(page, next, list, lru) {
 		pfn = page_private(page);
 		set_page_private(page, 0);
+
+		/*
+		 * Non-isolated types over MIGRATE_PCPTYPES get added
+		 * to the MIGRATE_MOVABLE pcp list.
+		 */
 		migratetype = get_pcppage_migratetype(page);
+		if (unlikely(migratetype >= MIGRATE_PCPTYPES))
+			migratetype = MIGRATE_MOVABLE;
+
 		trace_mm_page_free_batched(page);
 		free_unref_page_commit(page, pfn, migratetype, 0);
 
_

Patches currently in -mm which might be from opendmb@gmail.com are

mm-page_alloc-dont-corrupt-pcppage_migratetype.patch

