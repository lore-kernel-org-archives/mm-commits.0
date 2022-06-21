Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E953DC43334
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jun 2022 20:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236071AbiFUUIT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 16:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiFUUIS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 16:08:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46D264C5
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 13:08:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62B9C617D6
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 20:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3B5C3411C;
        Tue, 21 Jun 2022 20:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655842095;
        bh=nQDagaArZog397HdBCM0QcSlIGBWZDKEody2Wgp/baQ=;
        h=Date:To:From:Subject:From;
        b=V/mO85wfJusvhTgPCkNHhb3vaP+vpg1fsW0Gr/uU3KDw2YhYqouAooZAP8uj/uUsN
         41/Pn3V0Q7KEsia3LVNoatQ2izesVdn5xyicuOkq6zoD8mCVmEM9QEXJvzVyRcPyCD
         NWc/RUQFh7ezEJyoFrlZjvJONKUmXiQNQDCG5cuE=
Date:   Tue, 21 Jun 2022 13:07:49 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        longman@redhat.com, hannes@cmpxchg.org,
        duanxiongchun@bytedance.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented.patch added to mm-unstable branch
Message-Id: <20220621200804.9E3B5C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: make split queue lock safe when LRU pages are reparented
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: thp: make split queue lock safe when LRU pages are reparented
Date: Tue, 21 Jun 2022 20:56:53 +0800

Similar to the lruvec lock, we use the same approach to make the split
queue lock safe when LRU pages are reparented.

Link: https://lkml.kernel.org/r/20220621125658.64935-7-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 +++
 mm/huge_memory.c           |  116 +++++++++++++++++++++++++++--------
 2 files changed, 100 insertions(+), 26 deletions(-)

--- a/include/linux/memcontrol.h~mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented
+++ a/include/linux/memcontrol.h
@@ -1691,6 +1691,11 @@ int alloc_shrinker_info(struct mem_cgrou
 void free_shrinker_info(struct mem_cgroup *memcg);
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
 void reparent_shrinker_deferred(struct mem_cgroup *memcg);
+
+static inline int shrinker_id(struct shrinker *shrinker)
+{
+	return shrinker->id;
+}
 #else
 #define mem_cgroup_sockets_enabled 0
 static inline void mem_cgroup_sk_alloc(struct sock *sk) { };
@@ -1704,6 +1709,11 @@ static inline void set_shrinker_bit(stru
 				    int nid, int shrinker_id)
 {
 }
+
+static inline int shrinker_id(struct shrinker *shrinker)
+{
+	return -1;
+}
 #endif
 
 #ifdef CONFIG_MEMCG_KMEM
--- a/mm/huge_memory.c~mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented
+++ a/mm/huge_memory.c
@@ -558,25 +558,90 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struc
 }
 
 #ifdef CONFIG_MEMCG
-static inline struct deferred_split *get_deferred_split_queue(struct page *page)
+static inline struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
+		struct deferred_split *queue)
 {
-	struct mem_cgroup *memcg = page_memcg(compound_head(page));
-	struct pglist_data *pgdat = NODE_DATA(page_to_nid(page));
+	if (mem_cgroup_disabled())
+		return NULL;
+	if (&NODE_DATA(folio_nid(folio))->deferred_split_queue == queue)
+		return NULL;
+	return container_of(queue, struct mem_cgroup, deferred_split_queue);
+}
 
-	if (memcg)
-		return &memcg->deferred_split_queue;
-	else
-		return &pgdat->deferred_split_queue;
+static inline struct deferred_split *folio_memcg_split_queue(struct folio *folio)
+{
+	struct mem_cgroup *memcg = folio_memcg(folio);
+
+	return memcg ? &memcg->deferred_split_queue : NULL;
 }
 #else
-static inline struct deferred_split *get_deferred_split_queue(struct page *page)
+static inline struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
+		struct deferred_split *queue)
 {
-	struct pglist_data *pgdat = NODE_DATA(page_to_nid(page));
+	return NULL;
+}
 
-	return &pgdat->deferred_split_queue;
+static inline struct deferred_split *folio_memcg_split_queue(struct folio *folio)
+{
+	return NULL;
 }
 #endif
 
+static struct deferred_split *folio_split_queue(struct folio *folio)
+{
+	struct deferred_split *queue = folio_memcg_split_queue(folio);
+
+	return queue ? : &NODE_DATA(folio_nid(folio))->deferred_split_queue;
+}
+
+static struct deferred_split *folio_split_queue_lock(struct folio *folio)
+{
+	struct deferred_split *queue;
+
+	rcu_read_lock();
+retry:
+	queue = folio_split_queue(folio);
+	spin_lock(&queue->split_queue_lock);
+
+	if (unlikely(folio_split_queue_memcg(folio, queue) != folio_memcg(folio))) {
+		spin_unlock(&queue->split_queue_lock);
+		goto retry;
+	}
+	rcu_read_unlock();
+
+	return queue;
+}
+
+static struct deferred_split *
+folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
+{
+	struct deferred_split *queue;
+
+	rcu_read_lock();
+retry:
+	queue = folio_split_queue(folio);
+	spin_lock_irqsave(&queue->split_queue_lock, *flags);
+
+	if (unlikely(folio_split_queue_memcg(folio, queue) != folio_memcg(folio))) {
+		spin_unlock_irqrestore(&queue->split_queue_lock, *flags);
+		goto retry;
+	}
+	rcu_read_unlock();
+
+	return queue;
+}
+
+static inline void split_queue_unlock(struct deferred_split *queue)
+{
+	spin_unlock(&queue->split_queue_lock);
+}
+
+static inline void split_queue_unlock_irqrestore(struct deferred_split *queue,
+						 unsigned long flags)
+{
+	spin_unlock_irqrestore(&queue->split_queue_lock, flags);
+}
+
 void prep_transhuge_page(struct page *page)
 {
 	/*
@@ -2600,7 +2665,7 @@ int split_huge_page_to_list(struct page
 {
 	struct folio *folio = page_folio(page);
 	struct page *head = &folio->page;
-	struct deferred_split *ds_queue = get_deferred_split_queue(head);
+	struct deferred_split *ds_queue;
 	XA_STATE(xas, &head->mapping->i_pages, head->index);
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
@@ -2692,13 +2757,13 @@ int split_huge_page_to_list(struct page
 	}
 
 	/* Prevent deferred_split_scan() touching ->_refcount */
-	spin_lock(&ds_queue->split_queue_lock);
+	ds_queue = folio_split_queue_lock(folio);
 	if (page_ref_freeze(head, 1 + extra_pins)) {
 		if (!list_empty(page_deferred_list(head))) {
 			ds_queue->split_queue_len--;
 			list_del(page_deferred_list(head));
 		}
-		spin_unlock(&ds_queue->split_queue_lock);
+		split_queue_unlock(ds_queue);
 		if (mapping) {
 			int nr = thp_nr_pages(head);
 
@@ -2716,7 +2781,7 @@ int split_huge_page_to_list(struct page
 		__split_huge_page(page, list, end);
 		ret = 0;
 	} else {
-		spin_unlock(&ds_queue->split_queue_lock);
+		split_queue_unlock(ds_queue);
 fail:
 		if (mapping)
 			xas_unlock(&xas);
@@ -2740,25 +2805,23 @@ out:
 
 void free_transhuge_page(struct page *page)
 {
-	struct deferred_split *ds_queue = get_deferred_split_queue(page);
+	struct deferred_split *ds_queue;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	ds_queue = folio_split_queue_lock_irqsave(page_folio(page), &flags);
 	if (!list_empty(page_deferred_list(page))) {
 		ds_queue->split_queue_len--;
 		list_del(page_deferred_list(page));
 	}
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
+	split_queue_unlock_irqrestore(ds_queue, flags);
 	free_compound_page(page);
 }
 
 void deferred_split_huge_page(struct page *page)
 {
-	struct deferred_split *ds_queue = get_deferred_split_queue(page);
-#ifdef CONFIG_MEMCG
-	struct mem_cgroup *memcg = page_memcg(compound_head(page));
-#endif
+	struct deferred_split *ds_queue;
 	unsigned long flags;
+	struct folio *folio = page_folio(page);
 
 	VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 
@@ -2775,18 +2838,19 @@ void deferred_split_huge_page(struct pag
 	if (PageSwapCache(page))
 		return;
 
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
 	if (list_empty(page_deferred_list(page))) {
+		struct mem_cgroup *memcg;
+
+		memcg = folio_split_queue_memcg(folio, ds_queue);
 		count_vm_event(THP_DEFERRED_SPLIT_PAGE);
 		list_add_tail(page_deferred_list(page), &ds_queue->split_queue);
 		ds_queue->split_queue_len++;
-#ifdef CONFIG_MEMCG
 		if (memcg)
 			set_shrinker_bit(memcg, page_to_nid(page),
-					 deferred_split_shrinker.id);
-#endif
+					 shrinker_id(&deferred_split_shrinker));
 	}
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
+	split_queue_unlock_irqrestore(ds_queue, flags);
 }
 
 static unsigned long deferred_split_count(struct shrinker *shrink,
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memory_hotplug-enumerate-all-supported-section-flags.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory.patch
mm-hugetlb-remove-minimum_order-variable.patch
mm-memcontrol-remove-dead-code-and-comments.patch
mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore.patch
mm-memcontrol-prepare-objcg-api-for-non-kmem-usage.patch
mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented.patch
mm-vmscan-rework-move_pages_to_lru.patch
mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented.patch
mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe.patch
mm-memcontrol-introduce-memcg_reparent_ops.patch
mm-memcontrol-use-obj_cgroup-apis-to-charge-the-lru-pages.patch
mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-function.patch
mm-lru-use-lruvec-lock-to-serialize-memcg-changes.patch

