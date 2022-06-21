Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD2F1C43334
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jun 2022 20:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349676AbiFUUJO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 16:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbiFUUJO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 16:09:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EACA1AF00
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 13:09:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4F8FB81B21
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 20:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E40C3411C;
        Tue, 21 Jun 2022 20:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655842149;
        bh=ShKNcOcjyYn1eTGq+0BT0qmtC3CdZEKE7Rq2QFQq98E=;
        h=Date:To:From:Subject:From;
        b=zkRYb+1//NiQuiSGYnFipqAJYcHuZLbnYobMLI6KJ+Mc2wXIyYL/Pt0kyw2XCzDAj
         Mk/EUnJht1tWcc5B/X7o2fYDywceTVoA8rcaDRpoEdApagnM/hzQtDHNXDG5cYi69H
         uxiTw4oibb1giF4Pmzgi20TvqWTI5IdM/R+SdhmI=
Date:   Tue, 21 Jun 2022 13:08:59 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        longman@redhat.com, hannes@cmpxchg.org,
        duanxiongchun@bytedance.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-lru-use-lruvec-lock-to-serialize-memcg-changes.patch added to mm-unstable branch
Message-Id: <20220621200907.67E40C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: lru: use lruvec lock to serialize memcg changes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-lru-use-lruvec-lock-to-serialize-memcg-changes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-lru-use-lruvec-lock-to-serialize-memcg-changes.patch

This patch will later appear in the mm-unstable branch at
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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: lru: use lruvec lock to serialize memcg changes
Date: Tue, 21 Jun 2022 20:56:58 +0800

As described by commit fc574c23558c ("mm/swap.c: serialize memcg changes
in pagevec_lru_move_fn"), TestClearPageLRU() aims to serialize
mem_cgroup_move_account() during pagevec_lru_move_fn().  Now
folio_lruvec_lock*() has the ability to detect whether page memcg has been
changed.  So we can use lruvec lock to serialize mem_cgroup_move_account()
during pagevec_lru_move_fn().  This change is a partial revert of the
commit fc574c23558c ("mm/swap.c: serialize memcg changes in
pagevec_lru_move_fn").

And pagevec_lru_move_fn() is more hot compare with
mem_cgroup_move_account(), removing an atomic operation would be an
optimization.  Also this change would not dirty cacheline for a page which
isn't on the LRU.

Link: https://lkml.kernel.org/r/20220621125658.64935-12-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   34 ++++++++++++++++++++++++++++++++++
 mm/swap.c       |   32 +++++++++++++++-----------------
 mm/vmscan.c     |   16 +++++++---------
 3 files changed, 56 insertions(+), 26 deletions(-)

--- a/mm/memcontrol.c~mm-lru-use-lruvec-lock-to-serialize-memcg-changes
+++ a/mm/memcontrol.c
@@ -1330,10 +1330,39 @@ retry:
 	lruvec = folio_lruvec(folio);
 	spin_lock(&lruvec->lru_lock);
 
+	/*
+	 * The memcg of the page can be changed by any the following routines:
+	 *
+	 * 1) mem_cgroup_move_account() or
+	 * 2) memcg_reparent_objcgs()
+	 *
+	 * The possible bad scenario would like:
+	 *
+	 * CPU0:                CPU1:                CPU2:
+	 * lruvec = folio_lruvec()
+	 *
+	 *                      if (!isolate_lru_page())
+	 *                              mem_cgroup_move_account()
+	 *
+	 *                                           memcg_reparent_objcgs()
+	 *
+	 * spin_lock(&lruvec->lru_lock)
+	 *                ^^^^^^
+	 *              wrong lock
+	 *
+	 * Either CPU1 or CPU2 can change page memcg, so we need to check
+	 * whether page memcg is changed, if so, we should reacquire the
+	 * new lruvec lock.
+	 */
 	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
 		spin_unlock(&lruvec->lru_lock);
 		goto retry;
 	}
+
+	/*
+	 * When we reach here, it means that the folio_memcg(folio) is
+	 * stable.
+	 */
 	rcu_read_unlock();
 
 	return lruvec;
@@ -1361,6 +1390,7 @@ retry:
 	lruvec = folio_lruvec(folio);
 	spin_lock_irq(&lruvec->lru_lock);
 
+	/* See the comments in folio_lruvec_lock(). */
 	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
 		spin_unlock_irq(&lruvec->lru_lock);
 		goto retry;
@@ -1394,6 +1424,7 @@ retry:
 	lruvec = folio_lruvec(folio);
 	spin_lock_irqsave(&lruvec->lru_lock, *flags);
 
+	/* See the comments in folio_lruvec_lock(). */
 	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
 		spin_unlock_irqrestore(&lruvec->lru_lock, *flags);
 		goto retry;
@@ -5809,7 +5840,10 @@ static int mem_cgroup_move_account(struc
 	obj_cgroup_put(rcu_dereference(from->objcg));
 	rcu_read_unlock();
 
+	/* See the comments in folio_lruvec_lock(). */
+	spin_lock(&from_vec->lru_lock);
 	folio->memcg_data = (unsigned long)rcu_access_pointer(to->objcg);
+	spin_unlock(&from_vec->lru_lock);
 
 	__folio_memcg_unlock(from);
 
--- a/mm/swap.c~mm-lru-use-lruvec-lock-to-serialize-memcg-changes
+++ a/mm/swap.c
@@ -196,6 +196,7 @@ static void lru_add_fn(struct lruvec *lr
 
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
+	folio_set_lru(folio);
 	/*
 	 * Is an smp_mb__after_atomic() still required here, before
 	 * folio_evictable() tests the mlocked flag, to rule out the possibility
@@ -238,14 +239,8 @@ static void folio_batch_move_lru(struct
 	for (i = 0; i < folio_batch_count(fbatch); i++) {
 		struct folio *folio = fbatch->folios[i];
 
-		/* block memcg migration while the folio moves between lru */
-		if (move_fn != lru_add_fn && !folio_test_clear_lru(folio))
-			continue;
-
 		lruvec = folio_lruvec_relock_irqsave(folio, lruvec, &flags);
 		move_fn(lruvec, folio);
-
-		folio_set_lru(folio);
 	}
 
 	if (lruvec)
@@ -265,7 +260,7 @@ static void folio_batch_add_and_move(str
 
 static void lru_move_tail_fn(struct lruvec *lruvec, struct folio *folio)
 {
-	if (!folio_test_unevictable(folio)) {
+	if (folio_test_lru(folio) && !folio_test_unevictable(folio)) {
 		lruvec_del_folio(lruvec, folio);
 		folio_clear_active(folio);
 		lruvec_add_folio_tail(lruvec, folio);
@@ -348,7 +343,8 @@ void lru_note_cost_folio(struct folio *f
 
 static void folio_activate_fn(struct lruvec *lruvec, struct folio *folio)
 {
-	if (!folio_test_active(folio) && !folio_test_unevictable(folio)) {
+	if (folio_test_lru(folio) && !folio_test_active(folio) &&
+	    !folio_test_unevictable(folio)) {
 		long nr_pages = folio_nr_pages(folio);
 
 		lruvec_del_folio(lruvec, folio);
@@ -394,12 +390,9 @@ static void folio_activate(struct folio
 {
 	struct lruvec *lruvec;
 
-	if (folio_test_clear_lru(folio)) {
-		lruvec = folio_lruvec_lock_irq(folio);
-		folio_activate_fn(lruvec, folio);
-		lruvec_unlock_irq(lruvec);
-		folio_set_lru(folio);
-	}
+	lruvec = folio_lruvec_lock_irq(folio);
+	folio_activate_fn(lruvec, folio);
+	lruvec_unlock_irq(lruvec);
 }
 #endif
 
@@ -542,6 +535,9 @@ static void lru_deactivate_file_fn(struc
 	bool active = folio_test_active(folio);
 	long nr_pages = folio_nr_pages(folio);
 
+	if (!folio_test_lru(folio))
+		return;
+
 	if (folio_test_unevictable(folio))
 		return;
 
@@ -580,7 +576,8 @@ static void lru_deactivate_file_fn(struc
 
 static void lru_deactivate_fn(struct lruvec *lruvec, struct folio *folio)
 {
-	if (folio_test_active(folio) && !folio_test_unevictable(folio)) {
+	if (folio_test_lru(folio) && folio_test_active(folio) &&
+	    !folio_test_unevictable(folio)) {
 		long nr_pages = folio_nr_pages(folio);
 
 		lruvec_del_folio(lruvec, folio);
@@ -596,8 +593,9 @@ static void lru_deactivate_fn(struct lru
 
 static void lru_lazyfree_fn(struct lruvec *lruvec, struct folio *folio)
 {
-	if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
-	    !folio_test_swapcache(folio) && !folio_test_unevictable(folio)) {
+	if (folio_test_lru(folio) && folio_test_anon(folio) &&
+	    folio_test_swapbacked(folio) && !folio_test_swapcache(folio) &&
+	    !folio_test_unevictable(folio)) {
 		long nr_pages = folio_nr_pages(folio);
 
 		lruvec_del_folio(lruvec, folio);
--- a/mm/vmscan.c~mm-lru-use-lruvec-lock-to-serialize-memcg-changes
+++ a/mm/vmscan.c
@@ -4864,21 +4864,19 @@ void check_move_unevictable_pages(struct
 		if (PageTransTail(page))
 			continue;
 
-		nr_pages = thp_nr_pages(page);
+		nr_pages = folio_nr_pages(folio);
 		pgscanned += nr_pages;
 
-		/* block memcg migration during page moving between lru */
-		if (!TestClearPageLRU(page))
+		lruvec = folio_lruvec_relock_irq(folio, lruvec);
+		if (!folio_test_lru(folio) || !folio_test_unevictable(folio))
 			continue;
 
-		lruvec = folio_lruvec_relock_irq(folio, lruvec);
-		if (page_evictable(page) && PageUnevictable(page)) {
-			del_page_from_lru_list(page, lruvec);
-			ClearPageUnevictable(page);
-			add_page_to_lru_list(page, lruvec);
+		if (folio_evictable(folio)) {
+			lruvec_del_folio(lruvec, folio);
+			folio_clear_unevictable(folio);
+			lruvec_add_folio(lruvec, folio);
 			pgrescued += nr_pages;
 		}
-		SetPageLRU(page);
 	}
 
 	if (lruvec) {
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memory_hotplug-enumerate-all-supported-section-flags.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory.patch
mm-hugetlb-remove-minimum_order-variable.patch
mm-memcontrol-remove-dead-code-and-comments.patch
mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore.patch
mm-memcontrol-prepare-objcg-api-for-non-kmem-usage.patch
mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented.patch
mm-vmscan-rework-move_pages_to_lru.patch
mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented.patch
mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe.patch
mm-memcontrol-introduce-memcg_reparent_ops.patch
mm-memcontrol-use-obj_cgroup-apis-to-charge-the-lru-pages.patch
mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-function.patch
mm-lru-use-lruvec-lock-to-serialize-memcg-changes.patch

