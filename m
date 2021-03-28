Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C090C433C1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 18:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 769AF6196C
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 18:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbhC1ScL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 14:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231355AbhC1Sbd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 14:31:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7674C61966;
        Sun, 28 Mar 2021 18:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616956292;
        bh=NvJp8Umq4o22YL7nE7bIXbIMwm5RU9u/It+oibNA9e4=;
        h=Date:From:To:Subject:From;
        b=X+vEZxE+rw5MPtLhNUSj3i6ZDVXkwA/rTRLbGClkfPaQPjOkD08pWY8do9o8Mcwj9
         UE/7hX9f6dyFGLy2P8NB0HeaA5MuFfedNWZD8aLVdNcRzOVru2M7YaKZUxQMOdNyxB
         /6Dzds5tQsnljVB0gPAl5hYal5oWj+gEnwNW99F8=
Date:   Sun, 28 Mar 2021 11:31:31 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        willy@infradead.org, zhouguanghui1@huawei.com, ziy@nvidia.com
Subject:  [obsolete]
 mm-page_alloc-fix-allocation-imbalances-from-speculative-cache-lookup.patch
 removed from -mm tree
Message-ID: <20210328183131.4VrVz_0Me%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-fix-allocation-imbalances-from-speculative-cache-lookup
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-allocation-imbalances-from-speculative-cache-lookup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-page_alloc-fix-allocation-imbalances-from-speculative-cache-lookup

fixes suggested by Hugh

Link: https://lkml.kernel.org/r/YFo7SOni0s0TbXUm@cmpxchg.org
Fixes: e320d3012d25 mm/page_alloc.c: fix freeing non-compound pages
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Hugh Dickins <hughd@google.com>
Reported-by: Matthew Wilcox <willy@infradead.org>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Zhou Guanghui <zhouguanghui1@huawei.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-allocation-imbalances-from-speculative-cache-lookup
+++ a/mm/page_alloc.c
@@ -5083,6 +5083,8 @@ static inline void free_the_page(struct
  */
 void __free_pages(struct page *page, unsigned int order)
 {
+	bool compound = PageHead(page);
+
 	/*
 	 * Drop the base reference from __alloc_pages and free. In
 	 * case there is an outstanding speculative reference, from
@@ -5094,18 +5096,24 @@ void __free_pages(struct page *page, uns
 	}
 
 	/*
-	 * The speculative reference will put and free the page.
+	 * Ok, the speculative reference will put and free the page.
+	 *
+	 * - If this was an order-0 page, we're done.
+	 *
+	 * - If the page was compound, the other side will free the
+	 *   entire page and we're done here as well. Just note that
+	 *   freeing clears PG_head, so it can only be read reliably
+	 *   before the put_page_testzero().
 	 *
-	 * However, if the speculation was into a higher-order page
-	 * chunk that isn't marked compound, the other side will know
-	 * nothing about our buddy pages and only free the order-0
-	 * page at the start of our chunk! We must split off and free
-	 * the buddy pages here.
+	 * - If the page was of higher order but NOT marked compound,
+	 *   the other side will know nothing about our buddy pages
+	 *   and only free the order-0 page at the start of our block.
+	 *   We must split off and free the buddy pages here.
 	 *
-	 * The buddy pages aren't individually refcounted, so they
-	 * can't have any pending speculative references themselves.
+	 *   The buddy pages aren't individually refcounted, so they
+	 *   can't have any pending speculative references themselves.
 	 */
-	if (!PageHead(page) && order > 0) {
+	if (order > 0 && !compound) {
 		split_page_memcg(page, 1 << order);
 		while (order-- > 0)
 			free_the_page(page + (1 << order), order);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page-writeback-simplify-memcg-handling-in-test_clear_page_writeback.patch
mm-memcontrol-fix-cpuhotplug-statistics-flushing.patch
mm-memcontrol-kill-mem_cgroup_nodeinfo.patch
mm-memcontrol-privatize-memcg_page_state-query-functions.patch
cgroup-rstat-support-cgroup1.patch
cgroup-rstat-punt-root-level-optimization-to-individual-controllers.patch
mm-memcontrol-switch-to-rstat.patch
mm-memcontrol-switch-to-rstat-fix-2.patch
mm-memcontrol-consolidate-lruvec-stat-flushing.patch
kselftests-cgroup-update-kmem-test-for-new-vmstat-implementation.patch

