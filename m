Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED939C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236968AbiCYBeL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357530AbiCYBdP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60BBBF968
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F81CB826FE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFA7C340ED;
        Fri, 25 Mar 2022 01:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171895;
        bh=bjeRbf0zPnFwbjwENKQhBL3K5y0bRE/n1FMbZcg50qo=;
        h=Date:To:From:Subject:From;
        b=r3XPcOHLnVLCj3uILIXjbw75VuDibXct/l25io2lhXgIN6aFcAFw3vVkguPrpL+DU
         D298oEIMNl5DX45KGY565XoMyVdiN4CPH+8r2EjVqRnW88MSlnckFp4quaDsYeXJiK
         NfcWsDjhB6LikqEfmHvkZA7fjKW/I/cbvtfPhcMY=
Date:   Thu, 24 Mar 2022 18:31:34 -0700
To:     mm-commits@vger.kernel.org, weixugc@google.com, vbabka@suse.cz,
        shakeelb@google.com, rientjes@google.com, mhocko@kernel.org,
        hughd@google.com, gthelen@google.com, edumazet@google.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-page_alloc-check-high-order-pages-for-corruption-during-pcp-operations.patch removed from -mm tree
Message-Id: <20220325013135.3EFA7C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: check high-order pages for corruption during PCP operations
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-check-high-order-pages-for-corruption-during-pcp-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: check high-order pages for corruption during PCP operations

Eric Dumazet pointed out that commit 44042b449872 ("mm/page_alloc: allow
high-order pages to be stored on the per-cpu lists") only checks the head
page during PCP refill and allocation operations.  This was an oversight
and all pages should be checked.  This will incur a small performance
penalty but it's necessary for correctness.

Link: https://lkml.kernel.org/r/20220310092456.GJ15701@techsingularity.net
Fixes: 44042b449872 ("mm/page_alloc: allow high-order pages to be stored on the per-cpu lists")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Eric Dumazet <edumazet@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-check-high-order-pages-for-corruption-during-pcp-operations
+++ a/mm/page_alloc.c
@@ -2291,23 +2291,36 @@ static inline int check_new_page(struct
 	return 1;
 }
 
+static bool check_new_pages(struct page *page, unsigned int order)
+{
+	int i;
+	for (i = 0; i < (1 << order); i++) {
+		struct page *p = page + i;
+
+		if (unlikely(check_new_page(p)))
+			return true;
+	}
+
+	return false;
+}
+
 #ifdef CONFIG_DEBUG_VM
 /*
  * With DEBUG_VM enabled, order-0 pages are checked for expected state when
  * being allocated from pcp lists. With debug_pagealloc also enabled, they are
  * also checked when pcp lists are refilled from the free lists.
  */
-static inline bool check_pcp_refill(struct page *page)
+static inline bool check_pcp_refill(struct page *page, unsigned int order)
 {
 	if (debug_pagealloc_enabled_static())
-		return check_new_page(page);
+		return check_new_pages(page, order);
 	else
 		return false;
 }
 
-static inline bool check_new_pcp(struct page *page)
+static inline bool check_new_pcp(struct page *page, unsigned int order)
 {
-	return check_new_page(page);
+	return check_new_pages(page, order);
 }
 #else
 /*
@@ -2315,32 +2328,19 @@ static inline bool check_new_pcp(struct
  * when pcp lists are being refilled from the free lists. With debug_pagealloc
  * enabled, they are also checked when being allocated from the pcp lists.
  */
-static inline bool check_pcp_refill(struct page *page)
+static inline bool check_pcp_refill(struct page *page, unsigned int order)
 {
-	return check_new_page(page);
+	return check_new_pages(page, order);
 }
-static inline bool check_new_pcp(struct page *page)
+static inline bool check_new_pcp(struct page *page, unsigned int order)
 {
 	if (debug_pagealloc_enabled_static())
-		return check_new_page(page);
+		return check_new_pages(page, order);
 	else
 		return false;
 }
 #endif /* CONFIG_DEBUG_VM */
 
-static bool check_new_pages(struct page *page, unsigned int order)
-{
-	int i;
-	for (i = 0; i < (1 << order); i++) {
-		struct page *p = page + i;
-
-		if (unlikely(check_new_page(p)))
-			return true;
-	}
-
-	return false;
-}
-
 inline void post_alloc_hook(struct page *page, unsigned int order,
 				gfp_t gfp_flags)
 {
@@ -2982,7 +2982,7 @@ static int rmqueue_bulk(struct zone *zon
 		if (unlikely(page == NULL))
 			break;
 
-		if (unlikely(check_pcp_refill(page)))
+		if (unlikely(check_pcp_refill(page, order)))
 			continue;
 
 		/*
@@ -3600,7 +3600,7 @@ struct page *__rmqueue_pcplist(struct zo
 		page = list_first_entry(list, struct page, lru);
 		list_del(&page->lru);
 		pcp->count -= 1 << order;
-	} while (check_new_pcp(page));
+	} while (check_new_pcp(page, order));
 
 	return page;
 }
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


