Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5288DC4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 01:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15F8D23105
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 01:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbgLPBlB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 20:41:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:60368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgLPBlB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 20:41:01 -0500
Date:   Tue, 15 Dec 2020 17:40:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608082803;
        bh=VxDbN7Q3R8M5hPZuGtmHAknOAI5zwOzBUwto+TN78Yw=;
        h=From:To:Subject:From;
        b=snNAb3B8jeXVbO05ZYi2bF1rB7fQhs0VUJFKVymTeVzdq4ZcSkwhGRtMHI9MzCJY3
         3Fg8JzaohtmHRiDCZCrSKXTd57lQgXL50HrYVKfSGX4I4fkua3uB3JNpKZsfdWLEzg
         Lm7QpJx/lXAAiHzyA7rfrgjMbILwBMeiUJYLCrl8=
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
Subject:  [merged]
 mm-swapc-fold-vm-event-pgrotated-into-pagevec_move_tail_fn.patch removed
 from -mm tree
Message-ID: <20201216014001.-V1sxZGot%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap.c: fold vm event PGROTATED into pagevec_move_tail_fn
has been removed from the -mm tree.  Its filename was
     mm-swapc-fold-vm-event-pgrotated-into-pagevec_move_tail_fn.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/swap.c: fold vm event PGROTATED into pagevec_move_tail_fn

Fold the PGROTATED event collection into pagevec_move_tail_fn call back
func like other funcs does in pagevec_lru_move_fn.  Thus we could save
func call pagevec_move_tail().  Now all usage of pagevec_lru_move_fn are
same and no needs of its 3rd parameter.

It's just simply the calling. No functional change.

[lkp@intel.com: found a build issue in the original patch, thanks]
Link: https://lkml.kernel.org/r/1604566549-62481-10-git-send-email-alex.shi=
@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: "Chen, Rong A" <rong.a.chen@intel.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mika Penttil=C3=A4 <mika.penttila@nextfour.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   65 ++++++++++++++++++----------------------------------
 1 file changed, 23 insertions(+), 42 deletions(-)

--- a/mm/swap.c~mm-swapc-fold-vm-event-pgrotated-into-pagevec_move_tail_fn
+++ a/mm/swap.c
@@ -204,8 +204,7 @@ int get_kernel_page(unsigned long start,
 EXPORT_SYMBOL_GPL(get_kernel_page);
=20
 static void pagevec_lru_move_fn(struct pagevec *pvec,
-	void (*move_fn)(struct page *page, struct lruvec *lruvec, void *arg),
-	void *arg)
+	void (*move_fn)(struct page *page, struct lruvec *lruvec))
 {
 	int i;
 	struct pglist_data *pgdat =3D NULL;
@@ -224,7 +223,7 @@ static void pagevec_lru_move_fn(struct p
 		}
=20
 		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
-		(*move_fn)(page, lruvec, arg);
+		(*move_fn)(page, lruvec);
 	}
 	if (pgdat)
 		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
@@ -232,35 +231,22 @@ static void pagevec_lru_move_fn(struct p
 	pagevec_reinit(pvec);
 }
=20
-static void pagevec_move_tail_fn(struct page *page, struct lruvec *lruvec,
-				 void *arg)
+static void pagevec_move_tail_fn(struct page *page, struct lruvec *lruvec)
 {
-	int *pgmoved =3D arg;
-
 	if (PageLRU(page) && !PageUnevictable(page)) {
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 		ClearPageActive(page);
 		add_page_to_lru_list_tail(page, lruvec, page_lru(page));
-		(*pgmoved) +=3D thp_nr_pages(page);
+		__count_vm_events(PGROTATED, thp_nr_pages(page));
 	}
 }
=20
 /*
- * pagevec_move_tail() must be called with IRQ disabled.
- * Otherwise this may cause nasty races.
- */
-static void pagevec_move_tail(struct pagevec *pvec)
-{
-	int pgmoved =3D 0;
-
-	pagevec_lru_move_fn(pvec, pagevec_move_tail_fn, &pgmoved);
-	__count_vm_events(PGROTATED, pgmoved);
-}
-
-/*
  * Writeback is about to end against a page which has been marked for imme=
diate
  * reclaim.  If it still appears to be reclaimable, move it to the tail of=
 the
  * inactive list.
+ *
+ * rotate_reclaimable_page() must disable IRQs, to prevent nasty races.
  */
 void rotate_reclaimable_page(struct page *page)
 {
@@ -273,7 +259,7 @@ void rotate_reclaimable_page(struct page
 		local_lock_irqsave(&lru_rotate.lock, flags);
 		pvec =3D this_cpu_ptr(&lru_rotate.pvec);
 		if (!pagevec_add(pvec, page) || PageCompound(page))
-			pagevec_move_tail(pvec);
+			pagevec_lru_move_fn(pvec, pagevec_move_tail_fn);
 		local_unlock_irqrestore(&lru_rotate.lock, flags);
 	}
 }
@@ -315,8 +301,7 @@ void lru_note_cost_page(struct page *pag
 		      page_is_file_lru(page), thp_nr_pages(page));
 }
=20
-static void __activate_page(struct page *page, struct lruvec *lruvec,
-			    void *arg)
+static void __activate_page(struct page *page, struct lruvec *lruvec)
 {
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		int lru =3D page_lru_base_type(page);
@@ -340,7 +325,7 @@ static void activate_page_drain(int cpu)
 	struct pagevec *pvec =3D &per_cpu(lru_pvecs.activate_page, cpu);
=20
 	if (pagevec_count(pvec))
-		pagevec_lru_move_fn(pvec, __activate_page, NULL);
+		pagevec_lru_move_fn(pvec, __activate_page);
 }
=20
 static bool need_activate_page_drain(int cpu)
@@ -358,7 +343,7 @@ static void activate_page(struct page *p
 		pvec =3D this_cpu_ptr(&lru_pvecs.activate_page);
 		get_page(page);
 		if (!pagevec_add(pvec, page) || PageCompound(page))
-			pagevec_lru_move_fn(pvec, __activate_page, NULL);
+			pagevec_lru_move_fn(pvec, __activate_page);
 		local_unlock(&lru_pvecs.lock);
 	}
 }
@@ -374,7 +359,7 @@ static void activate_page(struct page *p
=20
 	page =3D compound_head(page);
 	spin_lock_irq(&pgdat->lru_lock);
-	__activate_page(page, mem_cgroup_page_lruvec(page, pgdat), NULL);
+	__activate_page(page, mem_cgroup_page_lruvec(page, pgdat));
 	spin_unlock_irq(&pgdat->lru_lock);
 }
 #endif
@@ -525,8 +510,7 @@ void lru_cache_add_inactive_or_unevictab
  * be write it out by flusher threads as this is much more effective
  * than the single-page writeout from reclaim.
  */
-static void lru_deactivate_file_fn(struct page *page, struct lruvec *lruve=
c,
-			      void *arg)
+static void lru_deactivate_file_fn(struct page *page, struct lruvec *lruve=
c)
 {
 	int lru;
 	bool active;
@@ -573,8 +557,7 @@ static void lru_deactivate_file_fn(struc
 	}
 }
=20
-static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec,
-			    void *arg)
+static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec)
 {
 	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
 		int lru =3D page_lru_base_type(page);
@@ -591,8 +574,7 @@ static void lru_deactivate_fn(struct pag
 	}
 }
=20
-static void lru_lazyfree_fn(struct page *page, struct lruvec *lruvec,
-			    void *arg)
+static void lru_lazyfree_fn(struct page *page, struct lruvec *lruvec)
 {
 	if (PageLRU(page) && PageAnon(page) && PageSwapBacked(page) &&
 	    !PageSwapCache(page) && !PageUnevictable(page)) {
@@ -636,21 +618,21 @@ void lru_add_drain_cpu(int cpu)
=20
 		/* No harm done if a racing interrupt already did this */
 		local_lock_irqsave(&lru_rotate.lock, flags);
-		pagevec_move_tail(pvec);
+		pagevec_lru_move_fn(pvec, pagevec_move_tail_fn);
 		local_unlock_irqrestore(&lru_rotate.lock, flags);
 	}
=20
 	pvec =3D &per_cpu(lru_pvecs.lru_deactivate_file, cpu);
 	if (pagevec_count(pvec))
-		pagevec_lru_move_fn(pvec, lru_deactivate_file_fn, NULL);
+		pagevec_lru_move_fn(pvec, lru_deactivate_file_fn);
=20
 	pvec =3D &per_cpu(lru_pvecs.lru_deactivate, cpu);
 	if (pagevec_count(pvec))
-		pagevec_lru_move_fn(pvec, lru_deactivate_fn, NULL);
+		pagevec_lru_move_fn(pvec, lru_deactivate_fn);
=20
 	pvec =3D &per_cpu(lru_pvecs.lru_lazyfree, cpu);
 	if (pagevec_count(pvec))
-		pagevec_lru_move_fn(pvec, lru_lazyfree_fn, NULL);
+		pagevec_lru_move_fn(pvec, lru_lazyfree_fn);
=20
 	activate_page_drain(cpu);
 }
@@ -679,7 +661,7 @@ void deactivate_file_page(struct page *p
 		pvec =3D this_cpu_ptr(&lru_pvecs.lru_deactivate_file);
=20
 		if (!pagevec_add(pvec, page) || PageCompound(page))
-			pagevec_lru_move_fn(pvec, lru_deactivate_file_fn, NULL);
+			pagevec_lru_move_fn(pvec, lru_deactivate_file_fn);
 		local_unlock(&lru_pvecs.lock);
 	}
 }
@@ -701,7 +683,7 @@ void deactivate_page(struct page *page)
 		pvec =3D this_cpu_ptr(&lru_pvecs.lru_deactivate);
 		get_page(page);
 		if (!pagevec_add(pvec, page) || PageCompound(page))
-			pagevec_lru_move_fn(pvec, lru_deactivate_fn, NULL);
+			pagevec_lru_move_fn(pvec, lru_deactivate_fn);
 		local_unlock(&lru_pvecs.lock);
 	}
 }
@@ -723,7 +705,7 @@ void mark_page_lazyfree(struct page *pag
 		pvec =3D this_cpu_ptr(&lru_pvecs.lru_lazyfree);
 		get_page(page);
 		if (!pagevec_add(pvec, page) || PageCompound(page))
-			pagevec_lru_move_fn(pvec, lru_lazyfree_fn, NULL);
+			pagevec_lru_move_fn(pvec, lru_lazyfree_fn);
 		local_unlock(&lru_pvecs.lock);
 	}
 }
@@ -977,8 +959,7 @@ void __pagevec_release(struct pagevec *p
 }
 EXPORT_SYMBOL(__pagevec_release);
=20
-static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
-				 void *arg)
+static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec)
 {
 	enum lru_list lru;
 	int was_unevictable =3D TestClearPageUnevictable(page);
@@ -1037,7 +1018,7 @@ static void __pagevec_lru_add_fn(struct
  */
 void __pagevec_lru_add(struct pagevec *pvec)
 {
-	pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn, NULL);
+	pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn);
 }
=20
 /**
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-vmscan-__isolate_lru_page_prepare-clean-up.patch
fs-nilfs2-remove-some-unused-macros-to-tame-gcc.patch
gcov-fix-kernel-doc-markup-issue.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix.patch

