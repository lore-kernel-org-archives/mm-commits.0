Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85FEBC4363A
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53B9A22201
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633142;
	bh=3Oh9NoQfOfeuqoJnuHiHWrmYR6Nn6zNwERHM9YBzDL4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=R6DKRsatqzcDNQJyjLevIASVNc4a15gNevYnopQVwmk+aQn5HYM9Q3PeZ4KRFDdDr
	 K1ROjVZ7BqGV1OUi3bu7uPbwFb9EoQ1MFgt0K69UcrJVc/Dklphf/InnYoAeVOYqBw
	 2tuVO4m2O017irR2gmyh5DE2AzUYHtF94Pl7JHMQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbgJMXwV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:52:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbgJMXwJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:52:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C1E4221FF;
        Tue, 13 Oct 2020 23:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633129;
        bh=3Oh9NoQfOfeuqoJnuHiHWrmYR6Nn6zNwERHM9YBzDL4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=R97dwIHxseoA0RgCSzYdqDNoB8rxKklkqntgQu+HGvFuAs4l4aeLj3RfF0g0Dxpzw
         ObrwWQa9mWVODt3O1q5+S5xIvfrvw1UqU4r817wsEFmYKWAO3uMB0r8LtNFIUfshjv
         Xcva0Y8w5yaB9TVzVRqeHJT8Cl/IMAwGBQTE+bpg=
Date:   Tue, 13 Oct 2020 16:52:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        cai@lca.pw, david@redhat.com, hughd@google.com,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com, shy828301@gmail.com,
        torvalds@linux-foundation.org, ying.huang@intel.com,
        yuzhao@google.com
Subject:  [patch 069/181] mm: remove activate_page() from
 unuse_pte()
Message-ID: <20201013235208.LREX_xdii%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
