Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5FFC433DF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 23:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B2922074D
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 23:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598312180;
	bh=1mduovgEJ1KkDWBdDnZ1/NZjpjhKddeRvSfJhVOC+cM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=vVyp+Cxx12Egr56HJ16u6ZR9te9t3RVUI7Tl6g0euwYrXPfp0TvzL+XlDO7hu7PDq
	 h826Ogy0ig0H/EikMN1CqhG5vj03RIiR4v5sderua+iIvwDd7CgnYR2sRP2tk7quhN
	 uNGW4RHe2xvVGgGU46j2w/BQ78OXxroeKzR27+0c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgHXXgT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 19:36:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbgHXXgQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 19:36:16 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8CA62074D;
        Mon, 24 Aug 2020 23:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598312175;
        bh=1mduovgEJ1KkDWBdDnZ1/NZjpjhKddeRvSfJhVOC+cM=;
        h=Date:From:To:Subject:From;
        b=K4kecyf525bTEoiLOSj8BXKiAeOLap5S2odyN+bnvJ5yMH4CPnuiKb+lhf4yYnXvB
         uVLPPgQeUArHyKKXrv+nczONBZmfQIQr3AOgjfOPtnw/qKLawi83Ck5jCp7m7FerCt
         MUAvpIqwAZJ7wiGsOZ5EYPCBxjHGLejVttcP2wy8=
Date:   Mon, 24 Aug 2020 16:36:14 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, alex.shi@linux.alibaba.com, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, mhocko@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, sfr@canb.auug.org.au,
        vdavydov.dev@gmail.com, willy@infradead.org
Subject:  [to-be-updated]
 mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch removed from -mm
 tree
Message-ID: <20200824233614.Gg8DJbTkP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: move lru_add_page_tail func to huge_memory.c
has been removed from the -mm tree.  Its filename was
     mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/thp: move lru_add_page_tail func to huge_memory.c

The function is only used in huge_memory.c, defining it in other file with
a CONFIG_TRANSPARENT_HUGEPAGE macro restrict just looks weird.

Let's move it THP. And make it static as Hugh Dickin suggested.

Link: http://lkml.kernel.org/r/1597144232-11370-3-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 --
 mm/huge_memory.c     |   30 ++++++++++++++++++++++++++++++
 mm/swap.c            |   33 ---------------------------------
 3 files changed, 30 insertions(+), 35 deletions(-)

--- a/include/linux/swap.h~mm-thp-move-lru_add_page_tail-func-to-huge_memoryc
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
@@ -2313,6 +2313,36 @@ static void remap_page(struct page *page
 	}
 }
 
+static void lru_add_page_tail(struct page *page, struct page *page_tail,
+				struct lruvec *lruvec, struct list_head *list)
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
@@ -933,39 +933,6 @@ void __pagevec_release(struct pagevec *p
 }
 EXPORT_SYMBOL(__pagevec_release);
 
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

mm-thp-clean-up-lru_add_page_tail.patch
mm-thp-remove-code-path-which-never-got-into.patch
mm-thp-narrow-lru-locking.patch

