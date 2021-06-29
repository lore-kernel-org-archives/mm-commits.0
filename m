Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 628C0C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A86661D04
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbhF2CkZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:32858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231682AbhF2CkY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:40:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31DA761D06;
        Tue, 29 Jun 2021 02:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934277;
        bh=l1Dnlo15wLXVZ9m/5w0RYDgT25kmSjQyPCgROHx5LeU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pb/30BVFrUAPtwXFHYh7lyQVzXFhruFNaE9lLtkYtSt38zJ+0sGepu2cG5l7jJbyH
         lK0MvekszcGx0lffal9Fvn07YQxXvTkUX1n1Tem4hZieD4GJSJuLt5GNI794qudLGp
         DvaAhJ4piyAD/5punc7xlO3imXXXYNKK/rIcfk0o=
Date:   Mon, 28 Jun 2021 19:37:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, duanxiongchun@bytedance.com,
        guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 088/192] mm: memcontrol: simplify
 lruvec_holds_page_lru_lock
Message-ID: <20210629023756.Iz8-E-7mq%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: simplify lruvec_holds_page_lru_lock

We already have a helper lruvec_memcg() to get the memcg from lruvec, we
do not need to do it ourselves in the lruvec_holds_page_lru_lock().  So
use lruvec_memcg() instead.  And if mem_cgroup_disabled() returns false,
the page_memcg(page) (the LRU pages) cannot be NULL.  So remove the odd
logic of "memcg = page_memcg(page) ?  : root_mem_cgroup".  And use
lruvec_pgdat to simplify the code.  We can have a single definition for
this function that works for !CONFIG_MEMCG, CONFIG_MEMCG +
mem_cgroup_disabled() and CONFIG_MEMCG.

Link: https://lkml.kernel.org/r/20210417043538.9793-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-simplify-lruvec_holds_page_lru_lock
+++ a/include/linux/memcontrol.h
@@ -755,22 +755,6 @@ static inline struct lruvec *mem_cgroup_
 	return mem_cgroup_lruvec(memcg, pgdat);
 }
 
-static inline bool lruvec_holds_page_lru_lock(struct page *page,
-					      struct lruvec *lruvec)
-{
-	pg_data_t *pgdat = page_pgdat(page);
-	const struct mem_cgroup *memcg;
-	struct mem_cgroup_per_node *mz;
-
-	if (mem_cgroup_disabled())
-		return lruvec == &pgdat->__lruvec;
-
-	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	memcg = page_memcg(page) ? : root_mem_cgroup;
-
-	return lruvec->pgdat == pgdat && mz->memcg == memcg;
-}
-
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
 struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
@@ -1227,14 +1211,6 @@ static inline struct lruvec *mem_cgroup_
 	return &pgdat->__lruvec;
 }
 
-static inline bool lruvec_holds_page_lru_lock(struct page *page,
-					      struct lruvec *lruvec)
-{
-	pg_data_t *pgdat = page_pgdat(page);
-
-	return lruvec == &pgdat->__lruvec;
-}
-
 static inline void lruvec_memcg_debug(struct lruvec *lruvec, struct page *page)
 {
 }
@@ -1516,6 +1492,13 @@ static inline void unlock_page_lruvec_ir
 	spin_unlock_irqrestore(&lruvec->lru_lock, flags);
 }
 
+static inline bool lruvec_holds_page_lru_lock(struct page *page,
+					      struct lruvec *lruvec)
+{
+	return lruvec_pgdat(lruvec) == page_pgdat(page) &&
+	       lruvec_memcg(lruvec) == page_memcg(page);
+}
+
 /* Don't lock again iff page's lruvec locked */
 static inline struct lruvec *relock_page_lruvec_irq(struct page *page,
 		struct lruvec *locked_lruvec)
_
