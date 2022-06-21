Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8106C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jun 2022 20:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353604AbiFUUHS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 16:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbiFUUHR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 16:07:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F55A63B0
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 13:07:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9534B81B29
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 20:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096C6C341C4;
        Tue, 21 Jun 2022 20:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655842033;
        bh=jHCi9q+wxD2At2o3tjVBF469of09G6QEiCqd9tbxiOg=;
        h=Date:To:From:Subject:From;
        b=Wm7FnBUrObOn+5nn7OHTnvUf3pJSpn2Ig63BA78hK6HvKX525VY9K7JMH5lbzLACm
         dFpsbTgMqcOqXcT4ERggRZkiFeASGIjqZV4oaFqjcRAa82KzIJqQ0XQ/QfdFjwEGGW
         gsJOYdUo6iubHVBMNNyrceT4HDVi1RY0hEktmisI=
Date:   Tue, 21 Jun 2022 13:06:58 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        longman@redhat.com, hannes@cmpxchg.org,
        duanxiongchun@bytedance.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-prepare-objcg-api-for-non-kmem-usage.patch added to mm-unstable branch
Message-Id: <20220621200711.096C6C341C4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: prepare objcg API for non-kmem usage
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-prepare-objcg-api-for-non-kmem-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-prepare-objcg-api-for-non-kmem-usage.patch

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
Subject: mm: memcontrol: prepare objcg API for non-kmem usage
Date: Tue, 21 Jun 2022 20:56:50 +0800

Pagecache pages are charged at the allocation time and holding a reference
to the original memory cgroup until being reclaimed.  Depending on the
memory pressure, specific patterns of the page sharing between different
cgroups and the cgroup creation and destruction rates, a large number of
dying memory cgroups can be pinned by pagecache pages.  It makes the page
reclaim less efficient and wastes memory.

We can convert LRU pages and most other raw memcg pins to the objcg
direction to fix this problem, and then the page->memcg will always point
to an object cgroup pointer.

Therefore, the infrastructure of objcg no longer only serves
CONFIG_MEMCG_KMEM.  In this patch, we move the infrastructure of the objcg
out of the scope of the CONFIG_MEMCG_KMEM so that the LRU pages can reuse
it to charge pages.

We know that the LRU pages are not accounted at the root level.  But the
page->memcg_data points to the root_mem_cgroup.  So the page->memcg_data
of the LRU pages always points to a valid pointer.  But the
root_mem_cgroup dose not have an object cgroup.  If we use obj_cgroup APIs
to charge the LRU pages, we should set the page->memcg_data to a root
object cgroup.  So we also allocate an object cgroup for the
root_mem_cgroup.

Link: https://lkml.kernel.org/r/20220621125658.64935-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 -
 mm/memcontrol.c            |   56 ++++++++++++++++++++---------------
 2 files changed, 34 insertions(+), 24 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-prepare-objcg-api-for-non-kmem-usage
+++ a/include/linux/memcontrol.h
@@ -321,10 +321,10 @@ struct mem_cgroup {
 
 #ifdef CONFIG_MEMCG_KMEM
 	int kmemcg_id;
+#endif
 	struct obj_cgroup __rcu *objcg;
 	/* list of inherited objcgs, protected by objcg_lock */
 	struct list_head objcg_list;
-#endif
 
 	MEMCG_PADDING(_pad2_);
 
--- a/mm/memcontrol.c~mm-memcontrol-prepare-objcg-api-for-non-kmem-usage
+++ a/mm/memcontrol.c
@@ -252,9 +252,9 @@ struct mem_cgroup *vmpressure_to_memcg(s
 	return container_of(vmpr, struct mem_cgroup, vmpressure);
 }
 
-#ifdef CONFIG_MEMCG_KMEM
 static DEFINE_SPINLOCK(objcg_lock);
 
+#ifdef CONFIG_MEMCG_KMEM
 bool mem_cgroup_kmem_disabled(void)
 {
 	return cgroup_memory_nokmem;
@@ -263,12 +263,10 @@ bool mem_cgroup_kmem_disabled(void)
 static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 				      unsigned int nr_pages);
 
-static void obj_cgroup_release(struct percpu_ref *ref)
+static void obj_cgroup_release_bytes(struct obj_cgroup *objcg)
 {
-	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
 	unsigned int nr_bytes;
 	unsigned int nr_pages;
-	unsigned long flags;
 
 	/*
 	 * At this point all allocated objects are freed, and
@@ -282,9 +280,9 @@ static void obj_cgroup_release(struct pe
 	 * 3) CPU1: a process from another memcg is allocating something,
 	 *          the stock if flushed,
 	 *          objcg->nr_charged_bytes = PAGE_SIZE - 92
-	 * 5) CPU0: we do release this object,
+	 * 4) CPU0: we do release this object,
 	 *          92 bytes are added to stock->nr_bytes
-	 * 6) CPU0: stock is flushed,
+	 * 5) CPU0: stock is flushed,
 	 *          92 bytes are added to objcg->nr_charged_bytes
 	 *
 	 * In the result, nr_charged_bytes == PAGE_SIZE.
@@ -296,6 +294,19 @@ static void obj_cgroup_release(struct pe
 
 	if (nr_pages)
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
+}
+#else
+static inline void obj_cgroup_release_bytes(struct obj_cgroup *objcg)
+{
+}
+#endif
+
+static void obj_cgroup_release(struct percpu_ref *ref)
+{
+	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
+	unsigned long flags;
+
+	obj_cgroup_release_bytes(objcg);
 
 	spin_lock_irqsave(&objcg_lock, flags);
 	list_del(&objcg->list);
@@ -324,10 +335,10 @@ static struct obj_cgroup *obj_cgroup_all
 	return objcg;
 }
 
-static void memcg_reparent_objcgs(struct mem_cgroup *memcg,
-				  struct mem_cgroup *parent)
+static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
 {
 	struct obj_cgroup *objcg, *iter;
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 
 	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
 
@@ -346,6 +357,7 @@ static void memcg_reparent_objcgs(struct
 	percpu_ref_kill(&objcg->refcnt);
 }
 
+#ifdef CONFIG_MEMCG_KMEM
 /*
  * A lot of the calls to the cache allocation functions are expected to be
  * inlined by the compiler. Since the calls to memcg_slab_pre_alloc_hook() are
@@ -3651,21 +3663,12 @@ static u64 mem_cgroup_read_u64(struct cg
 #ifdef CONFIG_MEMCG_KMEM
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
-	struct obj_cgroup *objcg;
-
 	if (cgroup_memory_nokmem)
 		return 0;
 
 	if (unlikely(mem_cgroup_is_root(memcg)))
 		return 0;
 
-	objcg = obj_cgroup_alloc();
-	if (!objcg)
-		return -ENOMEM;
-
-	objcg->memcg = memcg;
-	rcu_assign_pointer(memcg->objcg, objcg);
-
 	static_branch_enable(&memcg_kmem_enabled_key);
 
 	memcg->kmemcg_id = memcg->id.id;
@@ -3675,17 +3678,13 @@ static int memcg_online_kmem(struct mem_
 
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
 {
-	struct mem_cgroup *parent;
-
 	if (cgroup_memory_nokmem)
 		return;
 
 	if (unlikely(mem_cgroup_is_root(memcg)))
 		return;
 
-	parent = parent_mem_cgroup(memcg);
-	memcg_reparent_objcgs(memcg, parent);
-	memcg_reparent_list_lrus(memcg, parent);
+	memcg_reparent_list_lrus(memcg, parent_mem_cgroup(memcg));
 }
 #else
 static int memcg_online_kmem(struct mem_cgroup *memcg)
@@ -5190,8 +5189,8 @@ static struct mem_cgroup *mem_cgroup_all
 	memcg->socket_pressure = jiffies;
 #ifdef CONFIG_MEMCG_KMEM
 	memcg->kmemcg_id = -1;
-	INIT_LIST_HEAD(&memcg->objcg_list);
 #endif
+	INIT_LIST_HEAD(&memcg->objcg_list);
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
@@ -5256,6 +5255,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	struct obj_cgroup *objcg;
 
 	if (memcg_online_kmem(memcg))
 		goto remove_id;
@@ -5268,6 +5268,13 @@ static int mem_cgroup_css_online(struct
 	if (alloc_shrinker_info(memcg))
 		goto offline_kmem;
 
+	objcg = obj_cgroup_alloc();
+	if (!objcg)
+		goto free_shrinker;
+
+	objcg->memcg = memcg;
+	rcu_assign_pointer(memcg->objcg, objcg);
+
 	/* Online state pins memcg ID, memcg ID pins CSS */
 	refcount_set(&memcg->id.ref, 1);
 	css_get(css);
@@ -5276,6 +5283,8 @@ static int mem_cgroup_css_online(struct
 		queue_delayed_work(system_unbound_wq, &stats_flush_dwork,
 				   2UL*HZ);
 	return 0;
+free_shrinker:
+	free_shrinker_info(memcg);
 offline_kmem:
 	memcg_offline_kmem(memcg);
 remove_id:
@@ -5303,6 +5312,7 @@ static void mem_cgroup_css_offline(struc
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
 
+	memcg_reparent_objcgs(memcg);
 	memcg_offline_kmem(memcg);
 	reparent_shrinker_deferred(memcg);
 	wb_memcg_offline(memcg);
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

