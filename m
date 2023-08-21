Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA88EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbjHUUmc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbjHUUlc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:41:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA4CE7A
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A4E2649CB
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2C2C433C8;
        Mon, 21 Aug 2023 20:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650454;
        bh=muEbMVEvT1XRHKQM/FBMkYWzq+3xIV5NMsclNtbNqm0=;
        h=Date:To:From:Subject:From;
        b=YAn2T/8IM5uqc2JKaFezmyl4QqszFH/2aNWIBEUBKe3PrAE2NMKO6Oib0WsBDdpTr
         DO7s7Qj6EcG6NkDxePzQIAArYjtkdOUZNUaxNJmZsdftCyFhpHFQEzNeP9yDWz2VUX
         PiTYuzppNz7EhU39NWd2oOoU0UMr0qmiairjAHTw=
Date:   Mon, 21 Aug 2023 13:40:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-track-of-active-pcp-lists-range-in-bulk-free.patch removed from -mm tree
Message-Id: <20230821204054.AF2C2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: remove track of active PCP lists range in bulk free
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-track-of-active-pcp-lists-range-in-bulk-free.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_alloc: remove track of active PCP lists range in bulk free
Date: Wed, 9 Aug 2023 18:07:53 +0800

Patch series "Two minor cleanups for pcp list in page_alloc".

There are two minor cleanups for pcp list in page_alloc. More details
can be found in respective patches.


This patch (of 2):

After commit fd56eef258a17 ("mm/page_alloc: simplify how many pages are
selected per pcp list during bulk free"), we will drain all pages in
selected pcp list.  And we ensured passed count is < pcp->count.  Then,
the search will finish before wrap-around and track of active PCP lists
range intended for wrap-around case is no longer needed.

Link: https://lkml.kernel.org/r/20230809100754.3094517-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20230809100754.3094517-2-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-track-of-active-pcp-lists-range-in-bulk-free
+++ a/mm/page_alloc.c
@@ -1207,8 +1207,6 @@ static void free_pcppages_bulk(struct zo
 					int pindex)
 {
 	unsigned long flags;
-	int min_pindex = 0;
-	int max_pindex = NR_PCP_LISTS - 1;
 	unsigned int order;
 	bool isolated_pageblocks;
 	struct page *page;
@@ -1231,17 +1229,10 @@ static void free_pcppages_bulk(struct zo
 
 		/* Remove pages from lists in a round-robin fashion. */
 		do {
-			if (++pindex > max_pindex)
-				pindex = min_pindex;
+			if (++pindex > NR_PCP_LISTS - 1)
+				pindex = 0;
 			list = &pcp->lists[pindex];
-			if (!list_empty(list))
-				break;
-
-			if (pindex == max_pindex)
-				max_pindex--;
-			if (pindex == min_pindex)
-				min_pindex++;
-		} while (1);
+		} while (list_empty(list));
 
 		order = pindex_to_order(pindex);
 		nr_pages = 1 << order;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


