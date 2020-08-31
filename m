Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99359C433E6
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 01:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C4C72076D
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 01:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598837439;
	bh=3q5zx5NrN7iJiCtEsbxwOApIA4HEf9AdROpBGBl/dls=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=H3vy9VmXwBPeGLPpUhnGsY6Qa1BGBoy2o83bPt3j1L0h/7n3kaWxHfcjqefcgnuPs
	 +OW3XZgeVvKUDN99aN3ndFtteR0MIBITAf5zNxKRVIUjOSQC2KQc9Gk+elO+aRIS9B
	 XJztd2byQ9b2f1tnlQk0CB1XFzfy0UDTrk/X0mmY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgHaBaj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 21:30:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727814AbgHaBa3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 21:30:29 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F34C820E65;
        Mon, 31 Aug 2020 01:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598837428;
        bh=3q5zx5NrN7iJiCtEsbxwOApIA4HEf9AdROpBGBl/dls=;
        h=Date:From:To:Subject:From;
        b=gI0qNJ0XQR4hidCdzhaDw/8DlDMnOJWrL4/OoTEOIyFr+eFI9BouaCvPzdD2lMCnB
         qOSikouZhake5t6KZLMfBoYOla2Tg/6SAN9cW9/PGdHxtIBvSFrZYh4C3EEpWRFaXN
         xZK8AXUuW20Hn9csOq+JvpDfdFtvxlSNWu2Nc94c=
Date:   Sun, 30 Aug 2020 18:30:27 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        mike.kravetz@oracle.com, mhocko@suse.com, hannes@cmpxchg.org,
        cai@lca.pw, alex.shi@linux.alibaba.com, hughd@google.com
Subject:  + mlock-fix-unevictable_pgs-event-counts-on-thp.patch added
 to -mm tree
Message-ID: <20200831013027.XS2QG%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mlock: fix unevictable_pgs event counts on THP
has been added to the -mm tree.  Its filename is
     mlock-fix-unevictable_pgs-event-counts-on-thp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mlock-fix-unevictable_pgs-event-counts-on-thp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mlock-fix-unevictable_pgs-event-counts-on-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Shakeel Butt <shakeelb@google.com>
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

ksm-reinstate-memcg-charge-on-copied-pages.patch
mm-migration-of-hugetlbfs-page-skip-memcg.patch
shmem-shmem_writepage-split-unlikely-i915-thp.patch
mm-fix-check_move_unevictable_pages-on-thp.patch
mlock-fix-unevictable_pgs-event-counts-on-thp.patch

