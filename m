Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05989C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D799F61C78
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbhGFTOW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:14:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231857AbhGFTOT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:14:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EE0A61C72;
        Tue,  6 Jul 2021 19:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598700;
        bh=xJKOEquFYOGMwNUVBfiWtV+vUnjV5Q5VsAe6HQemGbk=;
        h=Date:From:To:Subject:From;
        b=nILKl2WtWZKPTlDtWTUCdwbO6o41DE+o39shXpqdzLE97XjM70qP0ifj7bFgKusye
         3RHA6UnsuNfOZZLolCBh9jDeKNKlGVI/n5wkfPnW4KilnRmnEeTkO54qjSMw9qKVOY
         DnxmvoHbKjuVRYREDGGAjRKPOxNJz3aTZUIvS8dw=
Date:   Tue, 06 Jul 2021 12:11:40 -0700
From:   akpm@linux-foundation.org
To:     duanxiongchun@bytedance.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-remove-the-pgdata-parameter-of-mem_cgroup_page_lruvec.patch
 removed from -mm tree
Message-ID: <20210706191140.-jFibzs1F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove the pgdata parameter of mem_cgroup_page_lruvec
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-the-pgdata-parameter-of-mem_cgroup_page_lruvec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: remove the pgdata parameter of mem_cgroup_page_lruvec

All the callers of mem_cgroup_page_lruvec() just pass page_pgdat(page) as
the 2nd parameter to it (except isolate_migratepages_block()).  But for
isolate_migratepages_block(), the page_pgdat(page) is also equal to the
local variable of @pgdat.  So mem_cgroup_page_lruvec() do not need the
pgdat parameter.  Just remove it to simplify the code.

Link: https://lkml.kernel.org/r/20210417043538.9793-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 +++++-----
 mm/compaction.c            |    2 +-
 mm/memcontrol.c            |    9 +++------
 mm/swap.c                  |    2 +-
 mm/workingset.c            |    2 +-
 5 files changed, 11 insertions(+), 14 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-remove-the-pgdata-parameter-of-mem_cgroup_page_lruvec
+++ a/include/linux/memcontrol.h
@@ -743,13 +743,12 @@ out:
 /**
  * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU page
  * @page: the page
- * @pgdat: pgdat of the page
  *
  * This function relies on page->mem_cgroup being stable.
  */
-static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page,
-						struct pglist_data *pgdat)
+static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page)
 {
+	pg_data_t *pgdat = page_pgdat(page);
 	struct mem_cgroup *memcg = page_memcg(page);
 
 	VM_WARN_ON_ONCE_PAGE(!memcg && !mem_cgroup_disabled(), page);
@@ -1221,9 +1220,10 @@ static inline struct lruvec *mem_cgroup_
 	return &pgdat->__lruvec;
 }
 
-static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page,
-						    struct pglist_data *pgdat)
+static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page)
 {
+	pg_data_t *pgdat = page_pgdat(page);
+
 	return &pgdat->__lruvec;
 }
 
--- a/mm/compaction.c~mm-memcontrol-remove-the-pgdata-parameter-of-mem_cgroup_page_lruvec
+++ a/mm/compaction.c
@@ -1028,7 +1028,7 @@ isolate_migratepages_block(struct compac
 		if (!TestClearPageLRU(page))
 			goto isolate_fail_put;
 
-		lruvec = mem_cgroup_page_lruvec(page, pgdat);
+		lruvec = mem_cgroup_page_lruvec(page);
 
 		/* If we already hold the lock, we can skip some rechecking */
 		if (lruvec != locked) {
--- a/mm/memcontrol.c~mm-memcontrol-remove-the-pgdata-parameter-of-mem_cgroup_page_lruvec
+++ a/mm/memcontrol.c
@@ -1199,9 +1199,8 @@ void lruvec_memcg_debug(struct lruvec *l
 struct lruvec *lock_page_lruvec(struct page *page)
 {
 	struct lruvec *lruvec;
-	struct pglist_data *pgdat = page_pgdat(page);
 
-	lruvec = mem_cgroup_page_lruvec(page, pgdat);
+	lruvec = mem_cgroup_page_lruvec(page);
 	spin_lock(&lruvec->lru_lock);
 
 	lruvec_memcg_debug(lruvec, page);
@@ -1212,9 +1211,8 @@ struct lruvec *lock_page_lruvec(struct p
 struct lruvec *lock_page_lruvec_irq(struct page *page)
 {
 	struct lruvec *lruvec;
-	struct pglist_data *pgdat = page_pgdat(page);
 
-	lruvec = mem_cgroup_page_lruvec(page, pgdat);
+	lruvec = mem_cgroup_page_lruvec(page);
 	spin_lock_irq(&lruvec->lru_lock);
 
 	lruvec_memcg_debug(lruvec, page);
@@ -1225,9 +1223,8 @@ struct lruvec *lock_page_lruvec_irq(stru
 struct lruvec *lock_page_lruvec_irqsave(struct page *page, unsigned long *flags)
 {
 	struct lruvec *lruvec;
-	struct pglist_data *pgdat = page_pgdat(page);
 
-	lruvec = mem_cgroup_page_lruvec(page, pgdat);
+	lruvec = mem_cgroup_page_lruvec(page);
 	spin_lock_irqsave(&lruvec->lru_lock, *flags);
 
 	lruvec_memcg_debug(lruvec, page);
--- a/mm/swap.c~mm-memcontrol-remove-the-pgdata-parameter-of-mem_cgroup_page_lruvec
+++ a/mm/swap.c
@@ -313,7 +313,7 @@ void lru_note_cost(struct lruvec *lruvec
 
 void lru_note_cost_page(struct page *page)
 {
-	lru_note_cost(mem_cgroup_page_lruvec(page, page_pgdat(page)),
+	lru_note_cost(mem_cgroup_page_lruvec(page),
 		      page_is_file_lru(page), thp_nr_pages(page));
 }
 
--- a/mm/workingset.c~mm-memcontrol-remove-the-pgdata-parameter-of-mem_cgroup_page_lruvec
+++ a/mm/workingset.c
@@ -408,7 +408,7 @@ void workingset_activation(struct page *
 	memcg = page_memcg_rcu(page);
 	if (!mem_cgroup_disabled() && !memcg)
 		goto out;
-	lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
+	lruvec = mem_cgroup_page_lruvec(page);
 	workingset_age_nonresident(lruvec, thp_nr_pages(page));
 out:
 	rcu_read_unlock();
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


