Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3096CC4727E
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCF372087D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601085483;
	bh=X1suQsqxf3jTqYi3Mw+OHK6cZjqUk9AGRM+/OXFh39E=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=YpjlpUK8NkXRXHVUQ+N3zhH064SwFA+mGcgJXGf5nuQNm+lO2dTuuq/Ccx5RaS4Jp
	 f2oqRtpUiegg5y5BpQ3wJeH4V9aN07BOxyTo92pmyDsYuvQQDdLiDwDqybBHU50thv
	 pGix9X9g+ZeCeLXtDxcs3d5RN6ZBnW9q62G8wWdM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbgIZB6D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 21:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgIZB6D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 21:58:03 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9514120BED;
        Sat, 26 Sep 2020 01:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601085482;
        bh=X1suQsqxf3jTqYi3Mw+OHK6cZjqUk9AGRM+/OXFh39E=;
        h=Date:From:To:Subject:From;
        b=whA+8zFwFSQgAC8XMIUp/EfpnGOszi2hbxXCZlS39gDIgKYoYt70WmPC7KzGhGZ8I
         JBYLh59D7XQbGlA9uoVkmQDVVH277Xv1qhZJJuATSkpRspCGe2HKS0hinclPxzNK5H
         Krd3TZaV8tOjDdEzLeBZuP1+Z7VRqRpcR/XorE94=
Date:   Fri, 25 Sep 2020 18:58:02 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, cai@lca.pw, hannes@cmpxchg.org,
        hughd@google.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com
Subject:  [merged]
 mlock-fix-unevictable_pgs-event-counts-on-thp.patch removed from -mm tree
Message-ID: <20200926015802.xKBSXyAbc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mlock: fix unevictable_pgs event counts on THP
has been removed from the -mm tree.  Its filename was
     mlock-fix-unevictable_pgs-event-counts-on-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mlock: fix unevictable_pgs event counts on THP

5.8 commit 5d91f31faf8e ("mm: swap: fix vmstats for huge page") has
established that vm_events should count every subpage of a THP, including
unevictable_pgs_culled and unevictable_pgs_rescued; but
lru_cache_add_inactive_or_unevictable() was not doing so for
unevictable_pgs_mlocked, and mm/mlock.c was not doing so for
unevictable_pgs mlocked, munlocked, cleared and stranded.

Fix them; but THPs don't go the pagevec way in mlock.c, so no fixes needed
on that path.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008301408230.5954@eggly.anvils
Fixes: 5d91f31faf8e ("mm: swap: fix vmstats for huge page")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   24 +++++++++++++++---------
 mm/swap.c  |    6 +++---
 2 files changed, 18 insertions(+), 12 deletions(-)

--- a/mm/mlock.c~mlock-fix-unevictable_pgs-event-counts-on-thp
+++ a/mm/mlock.c
@@ -58,11 +58,14 @@ EXPORT_SYMBOL(can_do_mlock);
  */
 void clear_page_mlock(struct page *page)
 {
+	int nr_pages;
+
 	if (!TestClearPageMlocked(page))
 		return;
 
-	mod_zone_page_state(page_zone(page), NR_MLOCK, -thp_nr_pages(page));
-	count_vm_event(UNEVICTABLE_PGCLEARED);
+	nr_pages = thp_nr_pages(page);
+	mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
+	count_vm_events(UNEVICTABLE_PGCLEARED, nr_pages);
 	/*
 	 * The previous TestClearPageMlocked() corresponds to the smp_mb()
 	 * in __pagevec_lru_add_fn().
@@ -76,7 +79,7 @@ void clear_page_mlock(struct page *page)
 		 * We lost the race. the page already moved to evictable list.
 		 */
 		if (PageUnevictable(page))
-			count_vm_event(UNEVICTABLE_PGSTRANDED);
+			count_vm_events(UNEVICTABLE_PGSTRANDED, nr_pages);
 	}
 }
 
@@ -93,9 +96,10 @@ void mlock_vma_page(struct page *page)
 	VM_BUG_ON_PAGE(PageCompound(page) && PageDoubleMap(page), page);
 
 	if (!TestSetPageMlocked(page)) {
-		mod_zone_page_state(page_zone(page), NR_MLOCK,
-				    thp_nr_pages(page));
-		count_vm_event(UNEVICTABLE_PGMLOCKED);
+		int nr_pages = thp_nr_pages(page);
+
+		mod_zone_page_state(page_zone(page), NR_MLOCK, nr_pages);
+		count_vm_events(UNEVICTABLE_PGMLOCKED, nr_pages);
 		if (!isolate_lru_page(page))
 			putback_lru_page(page);
 	}
@@ -138,7 +142,7 @@ static void __munlock_isolated_page(stru
 
 	/* Did try_to_unlock() succeed or punt? */
 	if (!PageMlocked(page))
-		count_vm_event(UNEVICTABLE_PGMUNLOCKED);
+		count_vm_events(UNEVICTABLE_PGMUNLOCKED, thp_nr_pages(page));
 
 	putback_lru_page(page);
 }
@@ -154,10 +158,12 @@ static void __munlock_isolated_page(stru
  */
 static void __munlock_isolation_failed(struct page *page)
 {
+	int nr_pages = thp_nr_pages(page);
+
 	if (PageUnevictable(page))
-		__count_vm_event(UNEVICTABLE_PGSTRANDED);
+		__count_vm_events(UNEVICTABLE_PGSTRANDED, nr_pages);
 	else
-		__count_vm_event(UNEVICTABLE_PGMUNLOCKED);
+		__count_vm_events(UNEVICTABLE_PGMUNLOCKED, nr_pages);
 }
 
 /**
--- a/mm/swap.c~mlock-fix-unevictable_pgs-event-counts-on-thp
+++ a/mm/swap.c
@@ -494,14 +494,14 @@ void lru_cache_add_inactive_or_unevictab
 
 	unevictable = (vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED;
 	if (unlikely(unevictable) && !TestSetPageMlocked(page)) {
+		int nr_pages = thp_nr_pages(page);
 		/*
 		 * We use the irq-unsafe __mod_zone_page_stat because this
 		 * counter is not modified from interrupt context, and the pte
 		 * lock is held(spinlock), which implies preemption disabled.
 		 */
-		__mod_zone_page_state(page_zone(page), NR_MLOCK,
-				    thp_nr_pages(page));
-		count_vm_event(UNEVICTABLE_PGMLOCKED);
+		__mod_zone_page_state(page_zone(page), NR_MLOCK, nr_pages);
+		count_vm_events(UNEVICTABLE_PGMLOCKED, nr_pages);
 	}
 	lru_cache_add(page);
 }
_

Patches currently in -mm which might be from hughd@google.com are


