Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90714C2BBCD
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 20:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FF2A22CE3
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 20:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgLOUec (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 15:34:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:36352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728568AbgLOUeU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 15:34:20 -0500
Date:   Tue, 15 Dec 2020 12:33:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608064402;
        bh=GFplm+lU1SFITInB15APrDjZrs/kpaiI5eHDW8X8mh4=;
        h=From:To:Subject:In-Reply-To:From;
        b=T5NjQI1ngv/DCkjc2h2GsBFAaZIbblhpjJ70mMhJkGxT9XIhRkYJZ9PNdkdWJTkDi
         e/6y4HiCIocwDBof2RsztyuatBV3k4Gf2VlRAwSWjjacvSZXUh0KgBpdFPgocsEBz7
         3oQkoZsnb2aOX2EZWtMZOUWJCY24KA28aZD4LkI8=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        alex.shi@linux.alibaba.com, alexander.duyck@gmail.com,
        aryabinin@virtuozzo.com, daniel.m.jordan@oracle.com,
        hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com,
        jannh@google.com, khlebnikov@yandex-team.ru,
        kirill.shutemov@linux.intel.com, kirill@shutemov.name,
        linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org,
        mhocko@suse.com, mika.penttila@nextfour.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        rong.a.chen@intel.com, shakeelb@google.com, tglx@linutronix.de,
        tj@kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com, willy@infradead.org,
        yang.shi@linux.alibaba.com, ying.huang@intel.com
Subject:  [patch 01/19] mm/thp: move lru_add_page_tail() to
 huge_memory.c
Message-ID: <20201215203320.p3Xky-7P6%akpm@linux-foundation.org>
In-Reply-To: <20201215123253.954eca9a5ef4c0d52fd381fa@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/thp: move lru_add_page_tail() to huge_memory.c

Patch series "per memcg lru lock", v21.

This patchset includes 3 parts:

1, some code cleanup and minimum optimization as a preparation.=20
2, use TestCleanPageLRU as page isolation's precondition.
3, replace per node lru_lock with per memcg per node lru_lock.

Current lru_lock is one for each of node, pgdat->lru_lock, that guard for
lru lists, but now we had moved the lru lists into memcg for long time.=20
Still using per node lru_lock is clearly unscalable, pages on each of
memcgs have to compete each others for a whole lru_lock.  This patchset
try to use per lruvec/memcg lru_lock to repleace per node lru lock to
guard lru lists, make it scalable for memcgs and get performance gain.

Currently lru_lock still guards both lru list and page's lru bit, that's
ok.  but if we want to use specific lruvec lock on the page, we need to
pin down the page's lruvec/memcg during locking.  Just taking lruvec lock
first may be undermined by the page's memcg charge/migration.  To fix this
problem, we could take out the page's lru bit clear and use it as pin down
action to block the memcg changes.  That's the reason for new atomic func
TestClearPageLRU.  So now isolating a page need both actions:
TestClearPageLRU and hold the lru_lock.

The typical usage of this is isolate_migratepages_block() in compaction.c
we have to take lru bit before lru lock, that serialized the page
isolation in memcg page charge/migration which will change page's lruvec
and new lru_lock in it.

The above solution suggested by Johannes Weiner, and based on his new
memcg charge path, then have this patchset.  (Hugh Dickins tested and
contributed much code from compaction fix to general code polish, thanks a
lot!).

Daniel Jordan's testing show 62% improvement on modified readtwice case on
his 2P * 10 core * 2 HT broadwell box on v18, which has no much different
with this v20.=20
https://lore.kernel.org/lkml/20200915165807.kpp7uhiw7l3loofu@ca-dmjordan1.u=
s.oracle.com/

Thanks to Hugh Dickins and Konstantin Khlebnikov, they both brought this
idea 8 years ago, and others who gave comments as well: Daniel Jordan, Mel
Gorman, Shakeel Butt, Matthew Wilcox, Alexander Duyck etc.

Thanks for Testing support from Intel 0day and Rong Chen, Fengguang Wu,
and Yun Wang.  Hugh Dickins also shared his kbuild-swap case.


This patch (of 19):

lru_add_page_tail() is only used in huge_memory.c, defining it in other
file with a CONFIG_TRANSPARENT_HUGEPAGE macro restrict just looks weird.

Let's move it THP. And make it static as Hugh Dickins suggested.

Link: https://lkml.kernel.org/r/1604566549-62481-1-git-send-email-alex.shi@=
linux.alibaba.com
Link: https://lkml.kernel.org/r/1604566549-62481-2-git-send-email-alex.shi@=
linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: "Chen, Rong A" <rong.a.chen@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mika Penttil=C3=A4 <mika.penttila@nextfour.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 --
 mm/huge_memory.c     |   30 ++++++++++++++++++++++++++++++
 mm/swap.c            |   33 ---------------------------------
 3 files changed, 30 insertions(+), 35 deletions(-)

--- a/include/linux/swap.h~mm-thp-move-lru_add_page_tail-func-to-huge_memor=
yc
+++ a/include/linux/swap.h
@@ -338,8 +338,6 @@ extern void lru_note_cost(struct lruvec
 			  unsigned int nr_pages);
 extern void lru_note_cost_page(struct page *);
 extern void lru_cache_add(struct page *);
-extern void lru_add_page_tail(struct page *page, struct page *page_tail,
-			 struct lruvec *lruvec, struct list_head *head);
 extern void mark_page_accessed(struct page *);
 extern void lru_add_drain(void);
 extern void lru_add_drain_cpu(int cpu);
--- a/mm/huge_memory.c~mm-thp-move-lru_add_page_tail-func-to-huge_memoryc
+++ a/mm/huge_memory.c
@@ -2359,6 +2359,36 @@ static void remap_page(struct page *page
 	}
 }
=20
+static void lru_add_page_tail(struct page *page, struct page *page_tail,
+		struct lruvec *lruvec, struct list_head *list)
+{
+	VM_BUG_ON_PAGE(!PageHead(page), page);
+	VM_BUG_ON_PAGE(PageCompound(page_tail), page);
+	VM_BUG_ON_PAGE(PageLRU(page_tail), page);
+	lockdep_assert_held(&lruvec_pgdat(lruvec)->lru_lock);
+
+	if (!list)
+		SetPageLRU(page_tail);
+
+	if (likely(PageLRU(page)))
+		list_add_tail(&page_tail->lru, &page->lru);
+	else if (list) {
+		/* page reclaim is reclaiming a huge page */
+		get_page(page_tail);
+		list_add_tail(&page_tail->lru, list);
+	} else {
+		/*
+		 * Head page has not yet been counted, as an hpage,
+		 * so we must account for each subpage individually.
+		 *
+		 * Put page_tail on the list at the correct position
+		 * so they all end up in order.
+		 */
+		add_page_to_lru_list_tail(page_tail, lruvec,
+					  page_lru(page_tail));
+	}
+}
+
 static void __split_huge_page_tail(struct page *head, int tail,
 		struct lruvec *lruvec, struct list_head *list)
 {
--- a/mm/swap.c~mm-thp-move-lru_add_page_tail-func-to-huge_memoryc
+++ a/mm/swap.c
@@ -977,39 +977,6 @@ void __pagevec_release(struct pagevec *p
 }
 EXPORT_SYMBOL(__pagevec_release);
=20
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-/* used by __split_huge_page_refcount() */
-void lru_add_page_tail(struct page *page, struct page *page_tail,
-		       struct lruvec *lruvec, struct list_head *list)
-{
-	VM_BUG_ON_PAGE(!PageHead(page), page);
-	VM_BUG_ON_PAGE(PageCompound(page_tail), page);
-	VM_BUG_ON_PAGE(PageLRU(page_tail), page);
-	lockdep_assert_held(&lruvec_pgdat(lruvec)->lru_lock);
-
-	if (!list)
-		SetPageLRU(page_tail);
-
-	if (likely(PageLRU(page)))
-		list_add_tail(&page_tail->lru, &page->lru);
-	else if (list) {
-		/* page reclaim is reclaiming a huge page */
-		get_page(page_tail);
-		list_add_tail(&page_tail->lru, list);
-	} else {
-		/*
-		 * Head page has not yet been counted, as an hpage,
-		 * so we must account for each subpage individually.
-		 *
-		 * Put page_tail on the list at the correct position
-		 * so they all end up in order.
-		 */
-		add_page_to_lru_list_tail(page_tail, lruvec,
-					  page_lru(page_tail));
-	}
-}
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-
 static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
 				 void *arg)
 {
_
