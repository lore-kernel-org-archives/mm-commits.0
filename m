Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6827ACA0ECE
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 03:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242577AbjILDRy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 23:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242232AbjILDRh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 23:17:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9B413C8DF;
        Mon, 11 Sep 2023 19:02:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7B0C433CD;
        Mon, 11 Sep 2023 21:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694466053;
        bh=ZsH1kV3lAUPP8ykkzVUlLE2mYT6JMcgSoplaVtsK1W8=;
        h=Date:To:From:Subject:From;
        b=q/9TcJPIm+cCSBtbfGfQniXDFl561K9HEEgvQhOeunCtWykkaTWzfjczP86wYeE9K
         j1wu8KaPAKvLmgb9mhfQIom0SlgSbSHmraP/2WdRBNsKBpuJ02iHS9TQA0qrRqSr7w
         BoURePMNDXXhXCw/9F7v0CB/ouO/BWSPAgTIQYCs=
Date:   Mon, 11 Sep 2023 14:00:52 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        joe.liu@mediatek.com, hannes@cmpxchg.org,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-free-pages-to-correct-buddy-list-after-pcp-lock-contention.patch added to mm-hotfixes-unstable branch
Message-Id: <20230911210053.8B7B0C433CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: free pages to correct buddy list after PCP lock contention
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-free-pages-to-correct-buddy-list-after-pcp-lock-contention.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-free-pages-to-correct-buddy-list-after-pcp-lock-contention.patch

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
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: page_alloc: free pages to correct buddy list after PCP lock contention
Date: Tue, 5 Sep 2023 10:09:22 +0100

Commit 4b23a68f9536 ("mm/page_alloc: protect PCP lists with a spinlock")
returns pages to the buddy list on PCP lock contention. However, for
migratetypes that are not MIGRATE_PCPTYPES, the migratetype may have
been clobbered already for pages that are not being isolated. In
practice, this means that CMA pages may be returned to the wrong
buddy list. While this might be harmless in some cases as it is
MIGRATE_MOVABLE, the pageblock could be reassigned in rmqueue_fallback
and prevent a future CMA allocation. Lookup the PCP migratetype
against unconditionally if the PCP lock is contended.

[lecopzer.chen@mediatek.com: CMA-specific fix]
Link: https://lkml.kernel.org/r/20230905090922.zy7srh33rg5c3zao@techsingularity.net
Fixes: 4b23a68f9536 ("mm/page_alloc: protect PCP lists with a spinlock")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Joe Liu <joe.liu@mediatek.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-free-pages-to-correct-buddy-list-after-pcp-lock-contention
+++ a/mm/page_alloc.c
@@ -2428,7 +2428,13 @@ void free_unref_page(struct page *page,
 		free_unref_page_commit(zone, pcp, page, migratetype, order);
 		pcp_spin_unlock(pcp);
 	} else {
-		free_one_page(zone, page, pfn, order, migratetype, FPI_NONE);
+		/*
+		 * The page migratetype may have been clobbered for types
+		 * (type >= MIGRATE_PCPTYPES && !is_migrate_isolate) so
+		 * must be rechecked.
+		 */
+		free_one_page(zone, page, pfn, order,
+			      get_pcppage_migratetype(page), FPI_NONE);
 	}
 	pcp_trylock_finish(UP_flags);
 }
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-free-pages-to-correct-buddy-list-after-pcp-lock-contention.patch

