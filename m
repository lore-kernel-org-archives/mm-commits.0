Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 770FFC433B4
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4827261040
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhEJEdL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 00:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhEJEdL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 00:33:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF502610C9;
        Mon, 10 May 2021 04:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620621127;
        bh=+p/YcPm5rZayWnMqQvaX0xmJtyq15hiAt1WRJLZSjA0=;
        h=Date:From:To:Subject:From;
        b=s1SEL3pPXBC+AZojqWv/McDrOkSKn8vUpV43MJaOKHy69MPm1lXPZ9HrKTxK+H0YK
         Q89N/55w5k7qeyriTZH/MP11Qq5ypLBXtaor6c5haVFAm84wrSKYuJqjjRQLL0lPuK
         BRsoZMyouyMtve1xlFRrFgRUR3nG0WRGw6GIvucc=
Date:   Sun, 09 May 2021 21:32:06 -0700
From:   akpm@linux-foundation.org
To:     duanxiongchun@bytedance.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  +
 mm-memcontrol-remove-the-pgdata-parameter-of-mem_cgroup_page_lruvec.patch
 added to -mm tree
Message-ID: <20210510043206.s0X5a40gN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove the pgdata parameter of mem_cgroup_page_lruvec
has been added to the -mm tree.  Its filename is
     mm-memcontrol-remove-the-pgdata-parameter-of-mem_cgroup_page_lruvec.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-remove-the-pgdata-parameter-of-mem_cgroup_page_lruvec.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-remove-the-pgdata-parameter-of-mem_cgroup_page_lruvec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memcontrol-fix-root_mem_cgroup-charging.patch
mm-memcontrol-fix-page-charging-in-page-replacement.patch
mm-memcontrol-bail-out-early-when-mm-in-get_mem_cgroup_from_mm.patch
mm-memcontrol-remove-the-pgdata-parameter-of-mem_cgroup_page_lruvec.patch
mm-memcontrol-simplify-lruvec_holds_page_lru_lock.patch
mm-memcontrol-rename-lruvec_holds_page_lru_lock-to-page_matches_lruvec.patch
mm-memcontrol-simplify-the-logic-of-objcg-pinning-memcg.patch
mm-memcontrol-move-obj_cgroup_uncharge_pages-out-of-css_set_lock.patch
mm-vmscan-remove-noinline_for_stack.patch
mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc.patch
mm-hugetlb-introduce-a-new-config-hugetlb_page_free_vmemmap.patch
mm-hugetlb-gather-discrete-indexes-of-tail-page.patch
mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-defer-freeing-of-hugetlb-pages.patch
mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-add-a-kernel-parameter-hugetlb_free_vmemmap.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled.patch
mm-hugetlb-introduce-nr_free_vmemmap_pages-in-the-struct-hstate.patch

