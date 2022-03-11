Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E00D8C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Mar 2022 03:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234969AbiCKDDs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Mar 2022 22:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345901AbiCKDDq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2022 22:03:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4477EB561D
        for <mm-commits@vger.kernel.org>; Thu, 10 Mar 2022 19:02:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B35E6127C
        for <mm-commits@vger.kernel.org>; Fri, 11 Mar 2022 03:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DCFC340EB;
        Fri, 11 Mar 2022 03:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646967757;
        bh=pd/+OSuqCF3biaya2IVpDcEf8o/spxImvBRxRzGUIYQ=;
        h=Date:To:From:Subject:From;
        b=dEQjbc7PmTyIq83nHlYoHHPulJ/Ut/aCM9DJ8TvZ16rYmZmTGdGFlGURi1zLKzrq8
         hiBpb7O0IhlA2fHib9P5B17NovCYvIZ6bHgHBPtf/YnNmfWWiXRwS61KLwcE20I1MW
         DwssjgXr1T7abFk0k9BSqkh0FZVu4fkfegT7hWTs=
Date:   Thu, 10 Mar 2022 19:02:36 -0800
To:     mm-commits@vger.kernel.org, weixugc@google.com, vbabka@suse.cz,
        shakeelb@google.com, rientjes@google.com, mhocko@kernel.org,
        hughd@google.com, gthelen@google.com, edumazet@google.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-check-high-order-pages-for-corruption-during-pcp-operations.patch added to -mm tree
Message-Id: <20220311030237.99DCFC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: check high-order pages for corruption during PCP operations
has been added to the -mm tree.  Its filename is
     mm-page_alloc-check-high-order-pages-for-corruption-during-pcp-operations.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-check-high-order-pages-for-corruption-during-pcp-operations.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-check-high-order-pages-for-corruption-during-pcp-operations.patch

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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
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

mm-page_alloc-fetch-the-correct-pcp-buddy-during-bulk-free.patch
mm-page_alloc-track-range-of-active-pcp-lists-during-bulk-free.patch
mm-page_alloc-simplify-how-many-pages-are-selected-per-pcp-list-during-bulk-free.patch
mm-page_alloc-drain-the-requested-list-first-during-bulk-free.patch
mm-page_alloc-free-pages-in-a-single-pass-during-bulk-free.patch
mm-page_alloc-limit-number-of-high-order-pages-on-pcp-during-bulk-free.patch
mm-page_alloc-do-not-prefetch-buddies-during-bulk-free.patch
mm-page_alloc-check-high-order-pages-for-corruption-during-pcp-operations.patch

