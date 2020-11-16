Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1573EC63697
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 21:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C715E223AB
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 21:58:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="W8x6Fmw5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgKPV6G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 16:58:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:43124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730142AbgKPV6G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 16:58:06 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 375D92225B;
        Mon, 16 Nov 2020 21:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605563885;
        bh=3JaIWqKnP9JTdp7gPh1AJRGzxABMEz85N6ypb6K9KPU=;
        h=Date:From:To:Subject:From;
        b=W8x6Fmw5Czjar4QHQX/TQeQG72eyWq751Sv78q1qDhLoLqhsNekmZICDnqkueRF5x
         e6oHjqyMIzPnv2f34upzsXOtUi5eatqiif57+DhXFjsWJdg0ULo0fiG1xeFMc/MU1x
         vMASgFjeLJdLZdZLgmQSwXWlW1qqBmiibw1qqR0U=
Date:   Mon, 16 Nov 2020 13:58:03 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, alex.shi@linux.alibaba.com,
        alexander.h.duyck@linux.intel.com, aryabinin@virtuozzo.com,
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
Subject:  + mm-lru-introduce-the-relock_page_lruvec-function.patch
 added to -mm tree
Message-ID: <20201116215803.rwYWC9qXZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/lru: introduce relock_page_lruvec()
has been added to the -mm tree.  Its filename is
     mm-lru-introduce-the-relock_page_lruvec-function.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-lru-introduce-the-relock_p=
age_lruvec-function.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-lru-introduce-the-relock_p=
age_lruvec-function.patch

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
=46rom: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: mm/lru: introduce relock_page_lruvec()

Add relock_page_lruvec() to replace repeated same code, no functional
change.

When testing for relock we can avoid the need for RCU locking if we simply
compare the page pgdat and memcg pointers versus those that the lruvec is
holding.  By doing this we can avoid the extra pointer walks and accesses
of the memory cgroup.

In addition we can avoid the checks entirely if lruvec is currently NULL.

Link: https://lkml.kernel.org/r/1604566549-62481-19-git-send-email-alex.shi=
@linux.alibaba.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Chen, Rong A" <rong.a.chen@intel.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mika Penttil=C3=A4 <mika.penttila@nextfour.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   52 +++++++++++++++++++++++++++++++++++
 mm/mlock.c                 |   11 -------
 mm/swap.c                  |   31 ++++----------------
 mm/vmscan.c                |   12 +-------
 4 files changed, 61 insertions(+), 45 deletions(-)

--- a/include/linux/memcontrol.h~mm-lru-introduce-the-relock_page_lruvec-fu=
nction
+++ a/include/linux/memcontrol.h
@@ -485,6 +485,22 @@ out:
=20
 struct lruvec *mem_cgroup_page_lruvec(struct page *, struct pglist_data *);
=20
+static inline bool lruvec_holds_page_lru_lock(struct page *page,
+					      struct lruvec *lruvec)
+{
+	pg_data_t *pgdat =3D page_pgdat(page);
+	const struct mem_cgroup *memcg;
+	struct mem_cgroup_per_node *mz;
+
+	if (mem_cgroup_disabled())
+		return lruvec =3D=3D &pgdat->__lruvec;
+
+	mz =3D container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	memcg =3D page->mem_cgroup ? : root_mem_cgroup;
+
+	return lruvec->pgdat =3D=3D pgdat && mz->memcg =3D=3D memcg;
+}
+
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
=20
 struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
@@ -1023,6 +1039,14 @@ static inline struct lruvec *mem_cgroup_
 	return &pgdat->__lruvec;
 }
=20
+static inline bool lruvec_holds_page_lru_lock(struct page *page,
+					      struct lruvec *lruvec)
+{
+	pg_data_t *pgdat =3D page_pgdat(page);
+
+	return lruvec =3D=3D &pgdat->__lruvec;
+}
+
 static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memc=
g)
 {
 	return NULL;
@@ -1465,6 +1489,34 @@ static inline void unlock_page_lruvec_ir
 	spin_unlock_irqrestore(&lruvec->lru_lock, flags);
 }
=20
+/* Don't lock again iff page's lruvec locked */
+static inline struct lruvec *relock_page_lruvec_irq(struct page *page,
+		struct lruvec *locked_lruvec)
+{
+	if (locked_lruvec) {
+		if (lruvec_holds_page_lru_lock(page, locked_lruvec))
+			return locked_lruvec;
+
+		unlock_page_lruvec_irq(locked_lruvec);
+	}
+
+	return lock_page_lruvec_irq(page);
+}
+
+/* Don't lock again iff page's lruvec locked */
+static inline struct lruvec *relock_page_lruvec_irqsave(struct page *page,
+		struct lruvec *locked_lruvec, unsigned long *flags)
+{
+	if (locked_lruvec) {
+		if (lruvec_holds_page_lru_lock(page, locked_lruvec))
+			return locked_lruvec;
+
+		unlock_page_lruvec_irqrestore(locked_lruvec, *flags);
+	}
+
+	return lock_page_lruvec_irqsave(page, flags);
+}
+
 #ifdef CONFIG_CGROUP_WRITEBACK
=20
 struct wb_domain *mem_cgroup_wb_domain(struct bdi_writeback *wb);
--- a/mm/mlock.c~mm-lru-introduce-the-relock_page_lruvec-function
+++ a/mm/mlock.c
@@ -277,16 +277,7 @@ static void __munlock_pagevec(struct pag
 			 * so we can spare the get_page() here.
 			 */
 			if (TestClearPageLRU(page)) {
-				struct lruvec *new_lruvec;
-
-				new_lruvec =3D mem_cgroup_page_lruvec(page,
-						page_pgdat(page));
-				if (new_lruvec !=3D lruvec) {
-					if (lruvec)
-						unlock_page_lruvec_irq(lruvec);
-					lruvec =3D lock_page_lruvec_irq(page);
-				}
-
+				lruvec =3D relock_page_lruvec_irq(page, lruvec);
 				del_page_from_lru_list(page, lruvec,
 							page_lru(page));
 				continue;
--- a/mm/swap.c~mm-lru-introduce-the-relock_page_lruvec-function
+++ a/mm/swap.c
@@ -210,19 +210,12 @@ static void pagevec_lru_move_fn(struct p
=20
 	for (i =3D 0; i < pagevec_count(pvec); i++) {
 		struct page *page =3D pvec->pages[i];
-		struct lruvec *new_lruvec;
=20
 		/* block memcg migration during page moving between lru */
 		if (!TestClearPageLRU(page))
 			continue;
=20
-		new_lruvec =3D mem_cgroup_page_lruvec(page, page_pgdat(page));
-		if (lruvec !=3D new_lruvec) {
-			if (lruvec)
-				unlock_page_lruvec_irqrestore(lruvec, flags);
-			lruvec =3D lock_page_lruvec_irqsave(page, &flags);
-		}
-
+		lruvec =3D relock_page_lruvec_irqsave(page, lruvec, &flags);
 		(*move_fn)(page, lruvec);
=20
 		SetPageLRU(page);
@@ -918,17 +911,12 @@ void release_pages(struct page **pages,
 		}
=20
 		if (PageLRU(page)) {
-			struct lruvec *new_lruvec;
+			struct lruvec *prev_lruvec =3D lruvec;
=20
-			new_lruvec =3D mem_cgroup_page_lruvec(page,
-							page_pgdat(page));
-			if (new_lruvec !=3D lruvec) {
-				if (lruvec)
-					unlock_page_lruvec_irqrestore(lruvec,
-									flags);
+			lruvec =3D relock_page_lruvec_irqsave(page, lruvec,
+									&flags);
+			if (prev_lruvec !=3D lruvec)
 				lock_batch =3D 0;
-				lruvec =3D lock_page_lruvec_irqsave(page, &flags);
-			}
=20
 			VM_BUG_ON_PAGE(!PageLRU(page), page);
 			__ClearPageLRU(page);
@@ -1033,15 +1021,8 @@ void __pagevec_lru_add(struct pagevec *p
=20
 	for (i =3D 0; i < pagevec_count(pvec); i++) {
 		struct page *page =3D pvec->pages[i];
-		struct lruvec *new_lruvec;
-
-		new_lruvec =3D mem_cgroup_page_lruvec(page, page_pgdat(page));
-		if (lruvec !=3D new_lruvec) {
-			if (lruvec)
-				unlock_page_lruvec_irqrestore(lruvec, flags);
-			lruvec =3D lock_page_lruvec_irqsave(page, &flags);
-		}
=20
+		lruvec =3D relock_page_lruvec_irqsave(page, lruvec, &flags);
 		__pagevec_lru_add_fn(page, lruvec);
 	}
 	if (lruvec)
--- a/mm/vmscan.c~mm-lru-introduce-the-relock_page_lruvec-function
+++ a/mm/vmscan.c
@@ -1884,8 +1884,7 @@ static unsigned noinline_for_stack move_
 		 * All pages were isolated from the same lruvec (and isolation
 		 * inhibits memcg migration).
 		 */
-		VM_BUG_ON_PAGE(mem_cgroup_page_lruvec(page, page_pgdat(page))
-							!=3D lruvec, page);
+		VM_BUG_ON_PAGE(!lruvec_holds_page_lru_lock(page, lruvec), page);
 		lru =3D page_lru(page);
 		nr_pages =3D thp_nr_pages(page);
=20
@@ -4274,7 +4273,6 @@ void check_move_unevictable_pages(struct
 	for (i =3D 0; i < pvec->nr; i++) {
 		struct page *page =3D pvec->pages[i];
 		int nr_pages;
-		struct lruvec *new_lruvec;
=20
 		if (PageTransTail(page))
 			continue;
@@ -4286,13 +4284,7 @@ void check_move_unevictable_pages(struct
 		if (!TestClearPageLRU(page))
 			continue;
=20
-		new_lruvec =3D mem_cgroup_page_lruvec(page, page_pgdat(page));
-		if (lruvec !=3D new_lruvec) {
-			if (lruvec)
-				unlock_page_lruvec_irq(lruvec);
-			lruvec =3D lock_page_lruvec_irq(page);
-		}
-
+		lruvec =3D relock_page_lruvec_irq(page, lruvec);
 		if (page_evictable(page) && PageUnevictable(page)) {
 			enum lru_list lru =3D page_lru_base_type(page);
=20
_

Patches currently in -mm which might be from alexander.h.duyck@linux.intel.=
com are

mm-lru-introduce-the-relock_page_lruvec-function.patch

