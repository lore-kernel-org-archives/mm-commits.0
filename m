Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87658C433E1
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 23:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62A9C20738
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 23:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597792143;
	bh=YdTDCc60lxy11h46A7ujs7PnpEQj0PDWktB3QEmMaO4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Re9/dgZ2mpO1Ng6rvCAEc5+k12Xp5MwiVSGUQL50ufvZ3buu3KHZ6yAQVyOlwiDAI
	 CkCMkD7z3AzeVuOxPX3KcO8ikk2VusVa7BLn/CU6pEpu0/c8f1fBq6+PF/uHfCcSKo
	 zB3+BGfO85TtFNyMu/IA+lbkJrcJxP2Wjc6qo6Mo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgHRXJD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 19:09:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgHRXJC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 19:09:02 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14D542065D;
        Tue, 18 Aug 2020 23:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597792141;
        bh=YdTDCc60lxy11h46A7ujs7PnpEQj0PDWktB3QEmMaO4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=adJpSDBBaU06pf/J8FwJtS89/+EXButwbBOA4yUY/SVilnv8TlD1GwJw1ilHM90Zk
         lS/jgSbAEnSuPoHU93Ys8XQmg0mhHZuF90/nFZ/Ji61RObRbDQUuZgxlslWGpj57HX
         gcTD9IBtl+qCDYA37+d3IvbEIs/YBO8dFrXllPpQ=
Date:   Tue, 18 Aug 2020 16:09:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     alexander.h.duyck@linux.intel.com, cai@lca.pw, david@redhat.com,
        hughd@google.com, iamjoonsoo.kim@lge.com,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        yang.shi@linux.alibaba.com, ying.huang@intel.com, yuzhao@google.com
Subject:  + mm-remove-activate_page-from-unuse_pte.patch added to
 -mm tree
Message-ID: <20200818230900.p-PIhl5fn%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove activate_page() from unuse_pte()
has been added to the -mm tree.  Its filename is
     mm-remove-activate_page-from-unuse_pte.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-activate_page-from-unuse_pte.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-activate_page-from-unuse_pte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
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
@@ -1925,11 +1925,6 @@ static int unuse_pte(struct vm_area_stru
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

mm-remove-activate_page-from-unuse_pte.patch
mm-remove-superfluous-__clearpageactive.patch
mm-remove-superfluous-__clearpagewaiters.patch

