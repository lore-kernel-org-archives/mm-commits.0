Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45CCEC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3257861D04
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhF2Ck1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:32904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231700AbhF2Ck1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:40:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 548BA61A2B;
        Tue, 29 Jun 2021 02:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934280;
        bh=u62vXx7t1Sk/Hm10uyOa//xiOOvnLxu8jRwI1USytXs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=w8lF5IXWP1wC2oUF3gR8UhTgqlvziYANANAjDIxG2YRqNH1rC65RSZkO+GOMArWz2
         mXP3EXfke1Rmx/6t5znQOorrCj6xFBKnEzrMxG95xZoSe4eZckKIUkXZW4ofvs58nX
         mNYzJiaU3YT+VJJOr8ab14KwqsCG8X+h0K/toiA4=
Date:   Mon, 28 Jun 2021 19:37:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, duanxiongchun@bytedance.com,
        guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 089/192] mm: memcontrol: rename
 lruvec_holds_page_lru_lock to page_matches_lruvec
Message-ID: <20210629023759.mFyLtjQWp%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: rename lruvec_holds_page_lru_lock to page_matches_lruvec

lruvec_holds_page_lru_lock() doesn't check anything about locking and is
used to check whether the page belongs to the lruvec.  So rename it to
page_matches_lruvec().

Link: https://lkml.kernel.org/r/20210417043538.9793-6-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    8 ++++----
 mm/vmscan.c                |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-rename-lruvec_holds_page_lru_lock-to-page_matches_lruvec
+++ a/include/linux/memcontrol.h
@@ -1492,8 +1492,8 @@ static inline void unlock_page_lruvec_ir
 	spin_unlock_irqrestore(&lruvec->lru_lock, flags);
 }
 
-static inline bool lruvec_holds_page_lru_lock(struct page *page,
-					      struct lruvec *lruvec)
+/* Test requires a stable page->memcg binding, see page_memcg() */
+static inline bool page_matches_lruvec(struct page *page, struct lruvec *lruvec)
 {
 	return lruvec_pgdat(lruvec) == page_pgdat(page) &&
 	       lruvec_memcg(lruvec) == page_memcg(page);
@@ -1504,7 +1504,7 @@ static inline struct lruvec *relock_page
 		struct lruvec *locked_lruvec)
 {
 	if (locked_lruvec) {
-		if (lruvec_holds_page_lru_lock(page, locked_lruvec))
+		if (page_matches_lruvec(page, locked_lruvec))
 			return locked_lruvec;
 
 		unlock_page_lruvec_irq(locked_lruvec);
@@ -1518,7 +1518,7 @@ static inline struct lruvec *relock_page
 		struct lruvec *locked_lruvec, unsigned long *flags)
 {
 	if (locked_lruvec) {
-		if (lruvec_holds_page_lru_lock(page, locked_lruvec))
+		if (page_matches_lruvec(page, locked_lruvec))
 			return locked_lruvec;
 
 		unlock_page_lruvec_irqrestore(locked_lruvec, *flags);
--- a/mm/vmscan.c~mm-memcontrol-rename-lruvec_holds_page_lru_lock-to-page_matches_lruvec
+++ a/mm/vmscan.c
@@ -2063,7 +2063,7 @@ static unsigned noinline_for_stack move_
 		 * All pages were isolated from the same lruvec (and isolation
 		 * inhibits memcg migration).
 		 */
-		VM_BUG_ON_PAGE(!lruvec_holds_page_lru_lock(page, lruvec), page);
+		VM_BUG_ON_PAGE(!page_matches_lruvec(page, lruvec), page);
 		add_page_to_lru_list(page, lruvec);
 		nr_pages = thp_nr_pages(page);
 		nr_moved += nr_pages;
_
