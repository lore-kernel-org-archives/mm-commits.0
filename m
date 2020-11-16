Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416EAC388F9
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 21:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE174222EC
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 21:56:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="jVc61jVu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbgKPV4k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 16:56:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:41412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728884AbgKPV4k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 16:56:40 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97A172225B;
        Mon, 16 Nov 2020 21:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605563799;
        bh=xw/CUCdYwZmWLWVjKEtOMY1mjtTlddkDE0DyAPB+Mko=;
        h=Date:From:To:Subject:From;
        b=jVc61jVuE50I4Ev2N4wJxYybQdtt1mn6h1Mz0dsx8qdwss+1YbJDnB1L0S0iyczXH
         mD/X7gvoUYRhPW/k8PDgn+SNNNs1G1c/S3wOtEdST59DxUDGFBECPhvH1X6Rr6YqXf
         FyJm11oTeDoJSz/BTYKXVanviAyT5RxmmLBszqjk=
Date:   Mon, 16 Nov 2020 13:56:36 -0800
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
Subject:  +
 mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch added to -mm tree
Message-ID: <20201116215636.Aq6ijtbCU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: move lru_add_page_tail() to huge_memory.c
has been added to the -mm tree.  Its filename is
     mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-move-lru_add_page_tail=
-func-to-huge_memoryc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-move-lru_add_page_tail=
-func-to-huge_memoryc.patch

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
@@ -2345,6 +2345,36 @@ static void remap_page(struct page *page
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

