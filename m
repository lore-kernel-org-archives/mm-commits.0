Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05845C388F9
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 21:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9468F223BF
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 21:57:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="AXH1kmOk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgKPV5x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 16:57:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:42866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727864AbgKPV5x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 16:57:53 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EDE4223AB;
        Mon, 16 Nov 2020 21:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605563870;
        bh=q7jBTXO8tMIjsM0L8SSIhiRrtUkuxiTuEZc8b0ahJr8=;
        h=Date:From:To:Subject:From;
        b=AXH1kmOkyv3NzwQANJqL49MYTYDiJhIzU1X5Bm3ClHENLN7cWvGxfhfQaYouPwuUR
         KRo/68jic/mGkAbbKtlEUUvCGgL8j1aE4x6zoDhAgWVXRdZjE+5FuOFp7CyliRpP9D
         1LXwSHFgtqwLh9+NZWuaFixaDexejqxTx2SST6CU=
Date:   Mon, 16 Nov 2020 13:57:48 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, alex.shi@linux.alibaba.com,
        alexander.duyck@gmail.com, aryabinin@virtuozzo.com,
        daniel.m.jordan@oracle.com, hannes@cmpxchg.org, hughd@google.com,
        iamjoonsoo.kim@lge.com, jannh@google.com,
        khlebnikov@yandex-team.ru, kirill.shutemov@linux.intel.com,
        kirill@shutemov.name, mgorman@techsingularity.net,
        mhocko@kernel.org, mhocko@suse.com, mika.penttila@nextfour.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, rong.a.chen@intel.com,
        shakeelb@google.com, tglx@linutronix.de, tj@kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, willy@infradead.org,
        yang.shi@linux.alibaba.com, ying.huang@intel.com
Subject:  + mm-lru-replace-pgdat-lru_lock-with-lruvec-lock.patch
 added to -mm tree
Message-ID: <20201116215748.Yk38422l-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/lru: replace pgdat lru_lock with lruvec lock
has been added to the -mm tree.  Its filename is
     mm-lru-replace-pgdat-lru_lock-with-lruvec-lock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-lru-replace-pgdat-lru_lock=
-with-lruvec-lock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-lru-replace-pgdat-lru_lock=
-with-lruvec-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/lru: replace pgdat lru_lock with lruvec lock

This patch moves per node lru_lock into lruvec, thus bring a lru_lock for
each of memcg per node.  So on a large machine, each of memcg don't have
to suffer from per node pgdat->lru_lock competition.  They could go fast
with their self lru_lock.

After move memcg charge before lru inserting, page isolation could
serialize page's memcg, then per memcg lruvec lock is stable and could
replace per node lru lock.

In isolate_migratepages_block(), compact_unlock_should_abort and
lock_page_lruvec_irqsave are open coded to work with compact_control.=20
Also add a debug func in locking which may give some clues if there are
sth out of hands.

Daniel Jordan's testing show 62% improvement on modified readtwice case on
his 2P * 10 core * 2 HT broadwell box.=20
https://lore.kernel.org/lkml/20200915165807.kpp7uhiw7l3loofu@ca-dmjordan1.u=
s.oracle.com/

On a large machine with memcg enabled but not used, the page's lruvec
seeking pass a few pointers, that may lead to lru_lock holding time
increase and a bit regression.

Hugh Dickins helped on the patch polish, thanks!

Link: https://lkml.kernel.org/r/1604566549-62481-18-git-send-email-alex.shi=
@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rong Chen <rong.a.chen@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mika Penttil=C3=A4 <mika.penttila@nextfour.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   58 +++++++++++++++++
 include/linux/mmzone.h     |    3=20
 mm/compaction.c            |   56 ++++++++++------
 mm/huge_memory.c           |   11 +--
 mm/memcontrol.c            |   73 +++++++++++++++++++++-
 mm/mlock.c                 |   22 ++++--
 mm/mmzone.c                |    1=20
 mm/page_alloc.c            |    1=20
 mm/swap.c                  |  116 +++++++++++++++++------------------
 mm/vmscan.c                |   55 +++++++---------
 10 files changed, 270 insertions(+), 126 deletions(-)

--- a/include/linux/memcontrol.h~mm-lru-replace-pgdat-lru_lock-with-lruvec-=
lock
+++ a/include/linux/memcontrol.h
@@ -491,6 +491,19 @@ struct mem_cgroup *get_mem_cgroup_from_m
=20
 struct mem_cgroup *get_mem_cgroup_from_page(struct page *page);
=20
+struct lruvec *lock_page_lruvec(struct page *page);
+struct lruvec *lock_page_lruvec_irq(struct page *page);
+struct lruvec *lock_page_lruvec_irqsave(struct page *page,
+						unsigned long *flags);
+
+#ifdef CONFIG_DEBUG_VM
+void lruvec_memcg_debug(struct lruvec *lruvec, struct page *page);
+#else
+static inline void lruvec_memcg_debug(struct lruvec *lruvec, struct page *=
page)
+{
+}
+#endif
+
 static inline
 struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css){
 	return css ? container_of(css, struct mem_cgroup, css) : NULL;
@@ -1035,6 +1048,31 @@ static inline void mem_cgroup_put(struct
 {
 }
=20
+static inline struct lruvec *lock_page_lruvec(struct page *page)
+{
+	struct pglist_data *pgdat =3D page_pgdat(page);
+
+	spin_lock(&pgdat->__lruvec.lru_lock);
+	return &pgdat->__lruvec;
+}
+
+static inline struct lruvec *lock_page_lruvec_irq(struct page *page)
+{
+	struct pglist_data *pgdat =3D page_pgdat(page);
+
+	spin_lock_irq(&pgdat->__lruvec.lru_lock);
+	return &pgdat->__lruvec;
+}
+
+static inline struct lruvec *lock_page_lruvec_irqsave(struct page *page,
+		unsigned long *flagsp)
+{
+	struct pglist_data *pgdat =3D page_pgdat(page);
+
+	spin_lock_irqsave(&pgdat->__lruvec.lru_lock, *flagsp);
+	return &pgdat->__lruvec;
+}
+
 static inline struct mem_cgroup *
 mem_cgroup_iter(struct mem_cgroup *root,
 		struct mem_cgroup *prev,
@@ -1278,6 +1316,10 @@ static inline
 void count_memcg_event_mm(struct mm_struct *mm, enum vm_event_item idx)
 {
 }
+
+static inline void lruvec_memcg_debug(struct lruvec *lruvec, struct page *=
page)
+{
+}
 #endif /* CONFIG_MEMCG */
=20
 /* idx can be of type enum memcg_stat_item or node_stat_item */
@@ -1407,6 +1449,22 @@ static inline struct lruvec *parent_lruv
 	return mem_cgroup_lruvec(memcg, lruvec_pgdat(lruvec));
 }
=20
+static inline void unlock_page_lruvec(struct lruvec *lruvec)
+{
+	spin_unlock(&lruvec->lru_lock);
+}
+
+static inline void unlock_page_lruvec_irq(struct lruvec *lruvec)
+{
+	spin_unlock_irq(&lruvec->lru_lock);
+}
+
+static inline void unlock_page_lruvec_irqrestore(struct lruvec *lruvec,
+		unsigned long flags)
+{
+	spin_unlock_irqrestore(&lruvec->lru_lock, flags);
+}
+
 #ifdef CONFIG_CGROUP_WRITEBACK
=20
 struct wb_domain *mem_cgroup_wb_domain(struct bdi_writeback *wb);
--- a/include/linux/mmzone.h~mm-lru-replace-pgdat-lru_lock-with-lruvec-lock
+++ a/include/linux/mmzone.h
@@ -276,6 +276,8 @@ enum lruvec_flags {
=20
 struct lruvec {
 	struct list_head		lists[NR_LRU_LISTS];
+	/* per lruvec lru_lock for memcg */
+	spinlock_t			lru_lock;
 	/*
 	 * These track the cost of reclaiming one LRU - file or anon -
 	 * over the other. As the observed cost of reclaiming one LRU
@@ -796,7 +798,6 @@ typedef struct pglist_data {
=20
 	/* Write-intensive fields used by page reclaim */
 	ZONE_PADDING(_pad1_)
-	spinlock_t		lru_lock;
=20
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 	/*
--- a/mm/compaction.c~mm-lru-replace-pgdat-lru_lock-with-lruvec-lock
+++ a/mm/compaction.c
@@ -804,7 +804,7 @@ isolate_migratepages_block(struct compac
 	unsigned long nr_scanned =3D 0, nr_isolated =3D 0;
 	struct lruvec *lruvec;
 	unsigned long flags =3D 0;
-	bool locked =3D false;
+	struct lruvec *locked =3D NULL;
 	struct page *page =3D NULL, *valid_page =3D NULL;
 	unsigned long start_pfn =3D low_pfn;
 	bool skip_on_failure =3D false;
@@ -868,11 +868,20 @@ isolate_migratepages_block(struct compac
 		 * contention, to give chance to IRQs. Abort completely if
 		 * a fatal signal is pending.
 		 */
-		if (!(low_pfn % SWAP_CLUSTER_MAX)
-		    && compact_unlock_should_abort(&pgdat->lru_lock,
-					    flags, &locked, cc)) {
-			low_pfn =3D 0;
-			goto fatal_pending;
+		if (!(low_pfn % SWAP_CLUSTER_MAX)) {
+			if (locked) {
+				unlock_page_lruvec_irqrestore(locked, flags);
+				locked =3D NULL;
+			}
+
+			if (fatal_signal_pending(current)) {
+				cc->contended =3D true;
+
+				low_pfn =3D 0;
+				goto fatal_pending;
+			}
+
+			cond_resched();
 		}
=20
 		if (!pfn_valid_within(low_pfn))
@@ -944,9 +953,8 @@ isolate_migratepages_block(struct compac
 			if (unlikely(__PageMovable(page)) &&
 					!PageIsolated(page)) {
 				if (locked) {
-					spin_unlock_irqrestore(&pgdat->lru_lock,
-									flags);
-					locked =3D false;
+					unlock_page_lruvec_irqrestore(locked, flags);
+					locked =3D NULL;
 				}
=20
 				if (!isolate_movable_page(page, isolate_mode))
@@ -987,10 +995,19 @@ isolate_migratepages_block(struct compac
 		if (!TestClearPageLRU(page))
 			goto isolate_fail_put;
=20
+		rcu_read_lock();
+		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
+
 		/* If we already hold the lock, we can skip some rechecking */
-		if (!locked) {
-			locked =3D compact_lock_irqsave(&pgdat->lru_lock,
-								&flags, cc);
+		if (lruvec !=3D locked) {
+			if (locked)
+				unlock_page_lruvec_irqrestore(locked, flags);
+
+			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
+			locked =3D lruvec;
+			rcu_read_unlock();
+
+			lruvec_memcg_debug(lruvec, page);
=20
 			/* Try get exclusive access under lock */
 			if (!skip_updated) {
@@ -1009,9 +1026,8 @@ isolate_migratepages_block(struct compac
 				SetPageLRU(page);
 				goto isolate_fail_put;
 			}
-		}
-
-		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
+		} else
+			rcu_read_unlock();
=20
 		/* The whole page is taken off the LRU; skip the tail pages. */
 		if (PageCompound(page))
@@ -1045,8 +1061,8 @@ isolate_success:
 isolate_fail_put:
 		/* Avoid potential deadlock in freeing page under lru_lock */
 		if (locked) {
-			spin_unlock_irqrestore(&pgdat->lru_lock, flags);
-			locked =3D false;
+			unlock_page_lruvec_irqrestore(locked, flags);
+			locked =3D NULL;
 		}
 		put_page(page);
=20
@@ -1061,8 +1077,8 @@ isolate_fail:
 		 */
 		if (nr_isolated) {
 			if (locked) {
-				spin_unlock_irqrestore(&pgdat->lru_lock, flags);
-				locked =3D false;
+				unlock_page_lruvec_irqrestore(locked, flags);
+				locked =3D NULL;
 			}
 			putback_movable_pages(&cc->migratepages);
 			cc->nr_migratepages =3D 0;
@@ -1090,7 +1106,7 @@ isolate_fail:
=20
 isolate_abort:
 	if (locked)
-		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+		unlock_page_lruvec_irqrestore(locked, flags);
 	if (page) {
 		SetPageLRU(page);
 		put_page(page);
--- a/mm/huge_memory.c~mm-lru-replace-pgdat-lru_lock-with-lruvec-lock
+++ a/mm/huge_memory.c
@@ -2351,7 +2351,7 @@ static void lru_add_page_tail(struct pag
 	VM_BUG_ON_PAGE(!PageHead(head), head);
 	VM_BUG_ON_PAGE(PageCompound(tail), head);
 	VM_BUG_ON_PAGE(PageLRU(tail), head);
-	lockdep_assert_held(&lruvec_pgdat(lruvec)->lru_lock);
+	lockdep_assert_held(&lruvec->lru_lock);
=20
 	if (list) {
 		/* page reclaim is reclaiming a huge page */
@@ -2435,7 +2435,6 @@ static void __split_huge_page(struct pag
 		pgoff_t end)
 {
 	struct page *head =3D compound_head(page);
-	pg_data_t *pgdat =3D page_pgdat(head);
 	struct lruvec *lruvec;
 	struct address_space *swap_cache =3D NULL;
 	unsigned long offset =3D 0;
@@ -2453,10 +2452,8 @@ static void __split_huge_page(struct pag
 		xa_lock(&swap_cache->i_pages);
 	}
=20
-	/* prevent PageLRU to go away from under us, and freeze lru stats */
-	spin_lock(&pgdat->lru_lock);
-
-	lruvec =3D mem_cgroup_page_lruvec(head, pgdat);
+	/* lock lru list/PageCompound, ref freezed by page_ref_freeze */
+	lruvec =3D lock_page_lruvec(head);
=20
 	for (i =3D nr - 1; i >=3D 1; i--) {
 		__split_huge_page_tail(head, i, lruvec, list);
@@ -2477,7 +2474,7 @@ static void __split_huge_page(struct pag
 	}
=20
 	ClearPageCompound(head);
-	spin_unlock(&pgdat->lru_lock);
+	unlock_page_lruvec(lruvec);
 	/* Caller disabled irqs, so they are still disabled here */
=20
 	split_page_owner(head, nr);
--- a/mm/memcontrol.c~mm-lru-replace-pgdat-lru_lock-with-lruvec-lock
+++ a/mm/memcontrol.c
@@ -20,6 +20,9 @@
  * Lockless page tracking & accounting
  * Unified hierarchy configuration model
  * Copyright (C) 2015 Red Hat, Inc., Johannes Weiner
+ *
+ * Per memcg lru locking
+ * Copyright (C) 2020 Alibaba, Inc, Alex Shi
  */
=20
 #include <linux/page_counter.h>
@@ -1312,6 +1315,19 @@ int mem_cgroup_scan_tasks(struct mem_cgr
 	return ret;
 }
=20
+#ifdef CONFIG_DEBUG_VM
+void lruvec_memcg_debug(struct lruvec *lruvec, struct page *page)
+{
+	if (mem_cgroup_disabled())
+		return;
+
+	if (!page->mem_cgroup)
+		VM_BUG_ON_PAGE(lruvec_memcg(lruvec) !=3D root_mem_cgroup, page);
+	else
+		VM_BUG_ON_PAGE(lruvec_memcg(lruvec) !=3D page->mem_cgroup, page);
+}
+#endif
+
 /**
  * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU page
  * @page: the page
@@ -1353,6 +1369,59 @@ out:
 }
=20
 /**
+ * lock_page_lruvec - lock and return lruvec for a given page.
+ * @page: the page
+ *
+ * This series functions should be used in either conditions:
+ * PageLRU is cleared or unset
+ * or page is locked.
+ */
+struct lruvec *lock_page_lruvec(struct page *page)
+{
+	struct lruvec *lruvec;
+	struct pglist_data *pgdat =3D page_pgdat(page);
+
+	rcu_read_lock();
+	lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
+	spin_lock(&lruvec->lru_lock);
+	rcu_read_unlock();
+
+	lruvec_memcg_debug(lruvec, page);
+
+	return lruvec;
+}
+
+struct lruvec *lock_page_lruvec_irq(struct page *page)
+{
+	struct lruvec *lruvec;
+	struct pglist_data *pgdat =3D page_pgdat(page);
+
+	rcu_read_lock();
+	lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
+	spin_lock_irq(&lruvec->lru_lock);
+	rcu_read_unlock();
+
+	lruvec_memcg_debug(lruvec, page);
+
+	return lruvec;
+}
+
+struct lruvec *lock_page_lruvec_irqsave(struct page *page, unsigned long *=
flags)
+{
+	struct lruvec *lruvec;
+	struct pglist_data *pgdat =3D page_pgdat(page);
+
+	rcu_read_lock();
+	lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
+	spin_lock_irqsave(&lruvec->lru_lock, *flags);
+	rcu_read_unlock();
+
+	lruvec_memcg_debug(lruvec, page);
+
+	return lruvec;
+}
+
+/**
  * mem_cgroup_update_lru_size - account for adding or removing an lru page
  * @lruvec: mem_cgroup per zone lru vector
  * @lru: index of lru list the page is sitting on
@@ -3262,10 +3331,8 @@ void obj_cgroup_uncharge(struct obj_cgro
 #endif /* CONFIG_MEMCG_KMEM */
=20
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-
 /*
- * Because tail pages are not marked as "used", set it. We're under
- * pgdat->lru_lock and migration entries setup in all page mappings.
+ * Because page->mem_cgroup is not set on compound tails, set it now.
  */
 void mem_cgroup_split_huge_fixup(struct page *head)
 {
--- a/mm/mlock.c~mm-lru-replace-pgdat-lru_lock-with-lruvec-lock
+++ a/mm/mlock.c
@@ -262,12 +262,12 @@ static void __munlock_pagevec(struct pag
 	int nr =3D pagevec_count(pvec);
 	int delta_munlocked =3D -nr;
 	struct pagevec pvec_putback;
+	struct lruvec *lruvec =3D NULL;
 	int pgrescued =3D 0;
=20
 	pagevec_init(&pvec_putback);
=20
 	/* Phase 1: page isolation */
-	spin_lock_irq(&zone->zone_pgdat->lru_lock);
 	for (i =3D 0; i < nr; i++) {
 		struct page *page =3D pvec->pages[i];
=20
@@ -277,10 +277,16 @@ static void __munlock_pagevec(struct pag
 			 * so we can spare the get_page() here.
 			 */
 			if (TestClearPageLRU(page)) {
-				struct lruvec *lruvec;
+				struct lruvec *new_lruvec;
+
+				new_lruvec =3D mem_cgroup_page_lruvec(page,
+						page_pgdat(page));
+				if (new_lruvec !=3D lruvec) {
+					if (lruvec)
+						unlock_page_lruvec_irq(lruvec);
+					lruvec =3D lock_page_lruvec_irq(page);
+				}
=20
-				lruvec =3D mem_cgroup_page_lruvec(page,
-							page_pgdat(page));
 				del_page_from_lru_list(page, lruvec,
 							page_lru(page));
 				continue;
@@ -299,8 +305,12 @@ static void __munlock_pagevec(struct pag
 		pagevec_add(&pvec_putback, pvec->pages[i]);
 		pvec->pages[i] =3D NULL;
 	}
-	__mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
-	spin_unlock_irq(&zone->zone_pgdat->lru_lock);
+	if (lruvec) {
+		__mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
+		unlock_page_lruvec_irq(lruvec);
+	} else if (delta_munlocked) {
+		mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
+	}
=20
 	/* Now we can release pins of pages that we are not munlocking */
 	pagevec_release(&pvec_putback);
--- a/mm/mmzone.c~mm-lru-replace-pgdat-lru_lock-with-lruvec-lock
+++ a/mm/mmzone.c
@@ -91,6 +91,7 @@ void lruvec_init(struct lruvec *lruvec)
 	enum lru_list lru;
=20
 	memset(lruvec, 0, sizeof(struct lruvec));
+	spin_lock_init(&lruvec->lru_lock);
=20
 	for_each_lru(lru)
 		INIT_LIST_HEAD(&lruvec->lists[lru]);
--- a/mm/page_alloc.c~mm-lru-replace-pgdat-lru_lock-with-lruvec-lock
+++ a/mm/page_alloc.c
@@ -6791,7 +6791,6 @@ static void __meminit pgdat_init_interna
 	init_waitqueue_head(&pgdat->pfmemalloc_wait);
=20
 	pgdat_page_ext_init(pgdat);
-	spin_lock_init(&pgdat->lru_lock);
 	lruvec_init(&pgdat->__lruvec);
 }
=20
--- a/mm/swap.c~mm-lru-replace-pgdat-lru_lock-with-lruvec-lock
+++ a/mm/swap.c
@@ -79,16 +79,14 @@ static DEFINE_PER_CPU(struct lru_pvecs,
 static void __page_cache_release(struct page *page)
 {
 	if (PageLRU(page)) {
-		pg_data_t *pgdat =3D page_pgdat(page);
 		struct lruvec *lruvec;
 		unsigned long flags;
=20
-		spin_lock_irqsave(&pgdat->lru_lock, flags);
-		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
+		lruvec =3D lock_page_lruvec_irqsave(page, &flags);
 		VM_BUG_ON_PAGE(!PageLRU(page), page);
 		__ClearPageLRU(page);
 		del_page_from_lru_list(page, lruvec, page_off_lru(page));
-		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+		unlock_page_lruvec_irqrestore(lruvec, flags);
 	}
 	__ClearPageWaiters(page);
 }
@@ -207,32 +205,30 @@ static void pagevec_lru_move_fn(struct p
 	void (*move_fn)(struct page *page, struct lruvec *lruvec))
 {
 	int i;
-	struct pglist_data *pgdat =3D NULL;
-	struct lruvec *lruvec;
+	struct lruvec *lruvec =3D NULL;
 	unsigned long flags =3D 0;
=20
 	for (i =3D 0; i < pagevec_count(pvec); i++) {
 		struct page *page =3D pvec->pages[i];
-		struct pglist_data *pagepgdat =3D page_pgdat(page);
-
-		if (pagepgdat !=3D pgdat) {
-			if (pgdat)
-				spin_unlock_irqrestore(&pgdat->lru_lock, flags);
-			pgdat =3D pagepgdat;
-			spin_lock_irqsave(&pgdat->lru_lock, flags);
-		}
+		struct lruvec *new_lruvec;
=20
 		/* block memcg migration during page moving between lru */
 		if (!TestClearPageLRU(page))
 			continue;
=20
-		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
+		new_lruvec =3D mem_cgroup_page_lruvec(page, page_pgdat(page));
+		if (lruvec !=3D new_lruvec) {
+			if (lruvec)
+				unlock_page_lruvec_irqrestore(lruvec, flags);
+			lruvec =3D lock_page_lruvec_irqsave(page, &flags);
+		}
+
 		(*move_fn)(page, lruvec);
=20
 		SetPageLRU(page);
 	}
-	if (pgdat)
-		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+	if (lruvec)
+		unlock_page_lruvec_irqrestore(lruvec, flags);
 	release_pages(pvec->pages, pvec->nr);
 	pagevec_reinit(pvec);
 }
@@ -274,9 +270,15 @@ void lru_note_cost(struct lruvec *lruvec
 {
 	do {
 		unsigned long lrusize;
-		struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
=20
-		spin_lock_irq(&pgdat->lru_lock);
+		/*
+		 * Hold lruvec->lru_lock is safe here, since
+		 * 1) The pinned lruvec in reclaim, or
+		 * 2) From a pre-LRU page during refault (which also holds the
+		 *    rcu lock, so would be safe even if the page was on the LRU
+		 *    and could move simultaneously to a new lruvec).
+		 */
+		spin_lock_irq(&lruvec->lru_lock);
 		/* Record cost event */
 		if (file)
 			lruvec->file_cost +=3D nr_pages;
@@ -300,7 +302,7 @@ void lru_note_cost(struct lruvec *lruvec
 			lruvec->file_cost /=3D 2;
 			lruvec->anon_cost /=3D 2;
 		}
-		spin_unlock_irq(&pgdat->lru_lock);
+		spin_unlock_irq(&lruvec->lru_lock);
 	} while ((lruvec =3D parent_lruvec(lruvec)));
 }
=20
@@ -364,13 +366,15 @@ static inline void activate_page_drain(i
=20
 static void activate_page(struct page *page)
 {
-	pg_data_t *pgdat =3D page_pgdat(page);
+	struct lruvec *lruvec;
=20
 	page =3D compound_head(page);
-	spin_lock_irq(&pgdat->lru_lock);
-	if (PageLRU(page))
-		__activate_page(page, mem_cgroup_page_lruvec(page, pgdat));
-	spin_unlock_irq(&pgdat->lru_lock);
+	if (TestClearPageLRU(page)) {
+		lruvec =3D lock_page_lruvec_irq(page);
+		__activate_page(page, lruvec);
+		unlock_page_lruvec_irq(lruvec);
+		SetPageLRU(page);
+	}
 }
 #endif
=20
@@ -860,8 +864,7 @@ void release_pages(struct page **pages,
 {
 	int i;
 	LIST_HEAD(pages_to_free);
-	struct pglist_data *locked_pgdat =3D NULL;
-	struct lruvec *lruvec;
+	struct lruvec *lruvec =3D NULL;
 	unsigned long flags;
 	unsigned int lock_batch;
=20
@@ -871,11 +874,11 @@ void release_pages(struct page **pages,
 		/*
 		 * Make sure the IRQ-safe lock-holding time does not get
 		 * excessive with a continuous string of pages from the
-		 * same pgdat. The lock is held only if pgdat !=3D NULL.
+		 * same lruvec. The lock is held only if lruvec !=3D NULL.
 		 */
-		if (locked_pgdat && ++lock_batch =3D=3D SWAP_CLUSTER_MAX) {
-			spin_unlock_irqrestore(&locked_pgdat->lru_lock, flags);
-			locked_pgdat =3D NULL;
+		if (lruvec && ++lock_batch =3D=3D SWAP_CLUSTER_MAX) {
+			unlock_page_lruvec_irqrestore(lruvec, flags);
+			lruvec =3D NULL;
 		}
=20
 		page =3D compound_head(page);
@@ -883,10 +886,9 @@ void release_pages(struct page **pages,
 			continue;
=20
 		if (is_zone_device_page(page)) {
-			if (locked_pgdat) {
-				spin_unlock_irqrestore(&locked_pgdat->lru_lock,
-						       flags);
-				locked_pgdat =3D NULL;
+			if (lruvec) {
+				unlock_page_lruvec_irqrestore(lruvec, flags);
+				lruvec =3D NULL;
 			}
 			/*
 			 * ZONE_DEVICE pages that return 'false' from
@@ -907,27 +909,27 @@ void release_pages(struct page **pages,
 			continue;
=20
 		if (PageCompound(page)) {
-			if (locked_pgdat) {
-				spin_unlock_irqrestore(&locked_pgdat->lru_lock, flags);
-				locked_pgdat =3D NULL;
+			if (lruvec) {
+				unlock_page_lruvec_irqrestore(lruvec, flags);
+				lruvec =3D NULL;
 			}
 			__put_compound_page(page);
 			continue;
 		}
=20
 		if (PageLRU(page)) {
-			struct pglist_data *pgdat =3D page_pgdat(page);
+			struct lruvec *new_lruvec;
=20
-			if (pgdat !=3D locked_pgdat) {
-				if (locked_pgdat)
-					spin_unlock_irqrestore(&locked_pgdat->lru_lock,
+			new_lruvec =3D mem_cgroup_page_lruvec(page,
+							page_pgdat(page));
+			if (new_lruvec !=3D lruvec) {
+				if (lruvec)
+					unlock_page_lruvec_irqrestore(lruvec,
 									flags);
 				lock_batch =3D 0;
-				locked_pgdat =3D pgdat;
-				spin_lock_irqsave(&locked_pgdat->lru_lock, flags);
+				lruvec =3D lock_page_lruvec_irqsave(page, &flags);
 			}
=20
-			lruvec =3D mem_cgroup_page_lruvec(page, locked_pgdat);
 			VM_BUG_ON_PAGE(!PageLRU(page), page);
 			__ClearPageLRU(page);
 			del_page_from_lru_list(page, lruvec, page_off_lru(page));
@@ -937,8 +939,8 @@ void release_pages(struct page **pages,
=20
 		list_add(&page->lru, &pages_to_free);
 	}
-	if (locked_pgdat)
-		spin_unlock_irqrestore(&locked_pgdat->lru_lock, flags);
+	if (lruvec)
+		unlock_page_lruvec_irqrestore(lruvec, flags);
=20
 	mem_cgroup_uncharge_list(&pages_to_free);
 	free_unref_page_list(&pages_to_free);
@@ -1026,26 +1028,24 @@ static void __pagevec_lru_add_fn(struct
 void __pagevec_lru_add(struct pagevec *pvec)
 {
 	int i;
-	struct pglist_data *pgdat =3D NULL;
-	struct lruvec *lruvec;
+	struct lruvec *lruvec =3D NULL;
 	unsigned long flags =3D 0;
=20
 	for (i =3D 0; i < pagevec_count(pvec); i++) {
 		struct page *page =3D pvec->pages[i];
-		struct pglist_data *pagepgdat =3D page_pgdat(page);
+		struct lruvec *new_lruvec;
=20
-		if (pagepgdat !=3D pgdat) {
-			if (pgdat)
-				spin_unlock_irqrestore(&pgdat->lru_lock, flags);
-			pgdat =3D pagepgdat;
-			spin_lock_irqsave(&pgdat->lru_lock, flags);
+		new_lruvec =3D mem_cgroup_page_lruvec(page, page_pgdat(page));
+		if (lruvec !=3D new_lruvec) {
+			if (lruvec)
+				unlock_page_lruvec_irqrestore(lruvec, flags);
+			lruvec =3D lock_page_lruvec_irqsave(page, &flags);
 		}
=20
-		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
 		__pagevec_lru_add_fn(page, lruvec);
 	}
-	if (pgdat)
-		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+	if (lruvec)
+		unlock_page_lruvec_irqrestore(lruvec, flags);
 	release_pages(pvec->pages, pvec->nr);
 	pagevec_reinit(pvec);
 }
--- a/mm/vmscan.c~mm-lru-replace-pgdat-lru_lock-with-lruvec-lock
+++ a/mm/vmscan.c
@@ -1765,14 +1765,12 @@ int isolate_lru_page(struct page *page)
 	WARN_RATELIMIT(PageTail(page), "trying to isolate tail page");
=20
 	if (TestClearPageLRU(page)) {
-		pg_data_t *pgdat =3D page_pgdat(page);
 		struct lruvec *lruvec;
=20
 		get_page(page);
-		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
-		spin_lock_irq(&pgdat->lru_lock);
+		lruvec =3D lock_page_lruvec_irq(page);
 		del_page_from_lru_list(page, lruvec, page_lru(page));
-		spin_unlock_irq(&pgdat->lru_lock);
+		unlock_page_lruvec_irq(lruvec);
 		ret =3D 0;
 	}
=20
@@ -1839,7 +1837,6 @@ static int too_many_isolated(struct pgli
 static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
 						     struct list_head *list)
 {
-	struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
 	int nr_pages, nr_moved =3D 0;
 	LIST_HEAD(pages_to_free);
 	struct page *page;
@@ -1850,9 +1847,9 @@ static unsigned noinline_for_stack move_
 		VM_BUG_ON_PAGE(PageLRU(page), page);
 		list_del(&page->lru);
 		if (unlikely(!page_evictable(page))) {
-			spin_unlock_irq(&pgdat->lru_lock);
+			spin_unlock_irq(&lruvec->lru_lock);
 			putback_lru_page(page);
-			spin_lock_irq(&pgdat->lru_lock);
+			spin_lock_irq(&lruvec->lru_lock);
 			continue;
 		}
=20
@@ -1874,9 +1871,9 @@ static unsigned noinline_for_stack move_
 			__ClearPageActive(page);
=20
 			if (unlikely(PageCompound(page))) {
-				spin_unlock_irq(&pgdat->lru_lock);
+				spin_unlock_irq(&lruvec->lru_lock);
 				destroy_compound_page(page);
-				spin_lock_irq(&pgdat->lru_lock);
+				spin_lock_irq(&lruvec->lru_lock);
 			} else
 				list_add(&page->lru, &pages_to_free);
=20
@@ -1953,7 +1950,7 @@ shrink_inactive_list(unsigned long nr_to
=20
 	lru_add_drain();
=20
-	spin_lock_irq(&pgdat->lru_lock);
+	spin_lock_irq(&lruvec->lru_lock);
=20
 	nr_taken =3D isolate_lru_pages(nr_to_scan, lruvec, &page_list,
 				     &nr_scanned, sc, lru);
@@ -1965,14 +1962,14 @@ shrink_inactive_list(unsigned long nr_to
 	__count_memcg_events(lruvec_memcg(lruvec), item, nr_scanned);
 	__count_vm_events(PGSCAN_ANON + file, nr_scanned);
=20
-	spin_unlock_irq(&pgdat->lru_lock);
+	spin_unlock_irq(&lruvec->lru_lock);
=20
 	if (nr_taken =3D=3D 0)
 		return 0;
=20
 	nr_reclaimed =3D shrink_page_list(&page_list, pgdat, sc, &stat, false);
=20
-	spin_lock_irq(&pgdat->lru_lock);
+	spin_lock_irq(&lruvec->lru_lock);
 	move_pages_to_lru(lruvec, &page_list);
=20
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
@@ -1981,7 +1978,7 @@ shrink_inactive_list(unsigned long nr_to
 		__count_vm_events(item, nr_reclaimed);
 	__count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
 	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
-	spin_unlock_irq(&pgdat->lru_lock);
+	spin_unlock_irq(&lruvec->lru_lock);
=20
 	lru_note_cost(lruvec, file, stat.nr_pageout);
 	mem_cgroup_uncharge_list(&page_list);
@@ -2034,7 +2031,7 @@ static void shrink_active_list(unsigned
=20
 	lru_add_drain();
=20
-	spin_lock_irq(&pgdat->lru_lock);
+	spin_lock_irq(&lruvec->lru_lock);
=20
 	nr_taken =3D isolate_lru_pages(nr_to_scan, lruvec, &l_hold,
 				     &nr_scanned, sc, lru);
@@ -2045,7 +2042,7 @@ static void shrink_active_list(unsigned
 		__count_vm_events(PGREFILL, nr_scanned);
 	__count_memcg_events(lruvec_memcg(lruvec), PGREFILL, nr_scanned);
=20
-	spin_unlock_irq(&pgdat->lru_lock);
+	spin_unlock_irq(&lruvec->lru_lock);
=20
 	while (!list_empty(&l_hold)) {
 		cond_resched();
@@ -2091,7 +2088,7 @@ static void shrink_active_list(unsigned
 	/*
 	 * Move pages back to the lru list.
 	 */
-	spin_lock_irq(&pgdat->lru_lock);
+	spin_lock_irq(&lruvec->lru_lock);
=20
 	nr_activate =3D move_pages_to_lru(lruvec, &l_active);
 	nr_deactivate =3D move_pages_to_lru(lruvec, &l_inactive);
@@ -2102,7 +2099,7 @@ static void shrink_active_list(unsigned
 	__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
=20
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
-	spin_unlock_irq(&pgdat->lru_lock);
+	spin_unlock_irq(&lruvec->lru_lock);
=20
 	mem_cgroup_uncharge_list(&l_active);
 	free_unref_page_list(&l_active);
@@ -2690,10 +2687,10 @@ again:
 	/*
 	 * Determine the scan balance between anon and file LRUs.
 	 */
-	spin_lock_irq(&pgdat->lru_lock);
+	spin_lock_irq(&target_lruvec->lru_lock);
 	sc->anon_cost =3D target_lruvec->anon_cost;
 	sc->file_cost =3D target_lruvec->file_cost;
-	spin_unlock_irq(&pgdat->lru_lock);
+	spin_unlock_irq(&target_lruvec->lru_lock);
=20
 	/*
 	 * Target desirable inactive:active list ratios for the anon
@@ -4269,16 +4266,15 @@ int node_reclaim(struct pglist_data *pgd
  */
 void check_move_unevictable_pages(struct pagevec *pvec)
 {
-	struct lruvec *lruvec;
-	struct pglist_data *pgdat =3D NULL;
+	struct lruvec *lruvec =3D NULL;
 	int pgscanned =3D 0;
 	int pgrescued =3D 0;
 	int i;
=20
 	for (i =3D 0; i < pvec->nr; i++) {
 		struct page *page =3D pvec->pages[i];
-		struct pglist_data *pagepgdat =3D page_pgdat(page);
 		int nr_pages;
+		struct lruvec *new_lruvec;
=20
 		if (PageTransTail(page))
 			continue;
@@ -4290,13 +4286,12 @@ void check_move_unevictable_pages(struct
 		if (!TestClearPageLRU(page))
 			continue;
=20
-		if (pagepgdat !=3D pgdat) {
-			if (pgdat)
-				spin_unlock_irq(&pgdat->lru_lock);
-			pgdat =3D pagepgdat;
-			spin_lock_irq(&pgdat->lru_lock);
+		new_lruvec =3D mem_cgroup_page_lruvec(page, page_pgdat(page));
+		if (lruvec !=3D new_lruvec) {
+			if (lruvec)
+				unlock_page_lruvec_irq(lruvec);
+			lruvec =3D lock_page_lruvec_irq(page);
 		}
-		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
=20
 		if (page_evictable(page) && PageUnevictable(page)) {
 			enum lru_list lru =3D page_lru_base_type(page);
@@ -4310,10 +4305,10 @@ void check_move_unevictable_pages(struct
 		SetPageLRU(page);
 	}
=20
-	if (pgdat) {
+	if (lruvec) {
 		__count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
 		__count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
-		spin_unlock_irq(&pgdat->lru_lock);
+		unlock_page_lruvec_irq(lruvec);
 	} else if (pgscanned) {
 		count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
 	}
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
fs-ntfs-remove-unused-varibles.patch
fs-ntfs-remove-unused-varible-attr_len.patch
mm-memcg-update-page-struct-member-in-comments.patch
mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch
mm-thp-use-head-for-head-page-in-lru_add_page_tail.patch
mm-thp-simplify-lru_add_page_tail.patch
mm-thp-narrow-lru-locking.patch
mm-vmscan-remove-unnecessary-lruvec-adding.patch
mm-rmap-stop-store-reordering-issue-on-page-mapping.patch
mm-rmap-stop-store-reordering-issue-on-page-mapping-fix.patch
mm-memcg-add-debug-checking-in-lock_page_memcg.patch
mm-swapc-fold-vm-event-pgrotated-into-pagevec_move_tail_fn.patch
mm-lru-move-lock-into-lru_note_cost.patch
mm-vmscan-remove-lruvec-reget-in-move_pages_to_lru.patch
mm-mlock-remove-lru_lock-on-testclearpagemlocked.patch
mm-mlock-remove-__munlock_isolate_lru_page.patch
mm-lru-introduce-testclearpagelru.patch
mm-compaction-do-page-isolation-first-in-compaction.patch
mm-swapc-serialize-memcg-changes-in-pagevec_lru_move_fn.patch
mm-lru-replace-pgdat-lru_lock-with-lruvec-lock.patch
mm-lru-replace-pgdat-lru_lock-with-lruvec-lock-fix.patch
mm-lru-replace-pgdat-lru_lock-with-lruvec-lock-fix-2.patch
mm-lru-introduce-the-relock_page_lruvec-function-fix.patch
docs-vm-remove-unused-3-items-explanation-for-proc-vmstat.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch

