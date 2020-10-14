Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86067C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 464592224D
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709175;
	bh=5RmFJmMn8eRU/OX/vN4sSpwlFvu7mU8QFViSTKclJG8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=s35TtgnWm2vzySwOmWhmwuCtjRa1MZ1qurcYPE/CtQ3G3bnAI8D8JwE1LnAMUyE0s
	 dLWBVDJqjWcD314JDhRxDPcen05hK7OXsk5WSGsdSXvCjWMp/YCGfopDZmgDoBhYXE
	 SFR5EEkQ7F+cUaabvurz6YtR0rCtYY2g+iOdfKuI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389499AbgJNU7f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389383AbgJNU7e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:59:34 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE1AE20725;
        Wed, 14 Oct 2020 20:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709174;
        bh=5RmFJmMn8eRU/OX/vN4sSpwlFvu7mU8QFViSTKclJG8=;
        h=Date:From:To:Subject:From;
        b=WKYIUVLINotnps+2l6RS0QJ84piaxhxUdiKJuhFMOolELca3V0D2GJeG05GIX/nBH
         3ErYRbF7uBWoim3SDk5xWlbCyuMypPukTlbHcxeVv7R96g17RFEe2bg3L4mqcZW/ay
         QQvmtGoN51vGXMayOKH06wU64JvCYDrZ6EVn6O4o=
Date:   Wed, 14 Oct 2020 13:59:33 -0700
From:   akpm@linux-foundation.org
To:     alexander.h.duyck@linux.intel.com, cai@lca.pw, david@redhat.com,
        hughd@google.com, iamjoonsoo.kim@lge.com,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com, shy828301@gmail.com,
        ying.huang@intel.com, yuzhao@google.com
Subject:  [merged] mm-remove-activate_page-from-unuse_pte.patch
 removed from -mm tree
Message-ID: <20201014205933.5raEK2Gic%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove activate_page() from unuse_pte()
has been removed from the -mm tree.  Its filename was
     mm-remove-activate_page-from-unuse_pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: remove activate_page() from unuse_pte()

We don't initially add anon pages to active lruvec after commit
b518154e59aa ("mm/vmscan: protect the workingset on anonymous LRU"). 
Remove activate_page() from unuse_pte(), which seems to be missed by the
commit.  And make the function static while we are at it.

Before the commit, we called lru_cache_add_active_or_unevictable() to add
new ksm pages to active lruvec.  Therefore, activate_page() wasn't
necessary for them in the first place.

Link: http://lkml.kernel.org/r/20200818184704.3625199-1-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 -
 mm/swap.c            |    4 ++--
 mm/swapfile.c        |    5 -----
 3 files changed, 2 insertions(+), 8 deletions(-)

--- a/include/linux/swap.h~mm-remove-activate_page-from-unuse_pte
+++ a/include/linux/swap.h
@@ -340,7 +340,6 @@ extern void lru_note_cost_page(struct pa
 extern void lru_cache_add(struct page *);
 extern void lru_add_page_tail(struct page *page, struct page *page_tail,
 			 struct lruvec *lruvec, struct list_head *head);
-extern void activate_page(struct page *);
 extern void mark_page_accessed(struct page *);
 extern void lru_add_drain(void);
 extern void lru_add_drain_cpu(int cpu);
--- a/mm/swap.c~mm-remove-activate_page-from-unuse_pte
+++ a/mm/swap.c
@@ -348,7 +348,7 @@ static bool need_activate_page_drain(int
 	return pagevec_count(&per_cpu(lru_pvecs.activate_page, cpu)) != 0;
 }
 
-void activate_page(struct page *page)
+static void activate_page(struct page *page)
 {
 	page = compound_head(page);
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
@@ -368,7 +368,7 @@ static inline void activate_page_drain(i
 {
 }
 
-void activate_page(struct page *page)
+static void activate_page(struct page *page)
 {
 	pg_data_t *pgdat = page_pgdat(page);
 
--- a/mm/swapfile.c~mm-remove-activate_page-from-unuse_pte
+++ a/mm/swapfile.c
@@ -1929,11 +1929,6 @@ static int unuse_pte(struct vm_area_stru
 		lru_cache_add_inactive_or_unevictable(page, vma);
 	}
 	swap_free(entry);
-	/*
-	 * Move the page to the active list so it is not
-	 * immediately swapped out again after swapon.
-	 */
-	activate_page(page);
 out:
 	pte_unmap_unlock(pte, ptl);
 	if (page != swapcache) {
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-use-self-explanatory-macros-rather-than-2.patch

