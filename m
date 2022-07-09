Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47414C43334
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jul 2022 02:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiGICbu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 22:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGICbr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 22:31:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4DA7A51A
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 19:31:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A580D6255A
        for <mm-commits@vger.kernel.org>; Sat,  9 Jul 2022 02:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D8DC341C0;
        Sat,  9 Jul 2022 02:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657333905;
        bh=oItFTszXI7RPSAvwKKzrLOlt0wYH0DHIBspj+vw6EXM=;
        h=Date:To:From:Subject:From;
        b=t6vZ0QlB/F47Xxkf8cpj/Pb6EA+DAs2p/+GqHVUqS4GeC+dJAscXC7w40ur5flIVp
         baxCoLFQP2COY8LV98ujBJmyp3ZsIUg92K7FhqteYLMrSTyO04bBXn2MFAxp9ErpwT
         aZoKHqqeAdsr87dr4IhAhu+appOB6+sv0yZT6Dho=
Date:   Fri, 08 Jul 2022 19:31:44 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        longman@redhat.com, hannes@cmpxchg.org,
        duanxiongchun@bytedance.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memcontrol-prepare-objcg-api-for-non-kmem-usage.patch removed from -mm tree
Message-Id: <20220709023145.05D8DC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcontrol: prepare objcg API for non-kmem usage
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-prepare-objcg-api-for-non-kmem-usage.patch

This patch was dropped because an updated version will be merged

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
@@ -251,9 +251,9 @@ struct mem_cgroup *vmpressure_to_memcg(s
 	return container_of(vmpr, struct mem_cgroup, vmpressure);
 }
 
-#ifdef CONFIG_MEMCG_KMEM
 static DEFINE_SPINLOCK(objcg_lock);
 
+#ifdef CONFIG_MEMCG_KMEM
 bool mem_cgroup_kmem_disabled(void)
 {
 	return cgroup_memory_nokmem;
@@ -262,12 +262,10 @@ bool mem_cgroup_kmem_disabled(void)
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
@@ -281,9 +279,9 @@ static void obj_cgroup_release(struct pe
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
@@ -295,6 +293,19 @@ static void obj_cgroup_release(struct pe
 
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
@@ -323,10 +334,10 @@ static struct obj_cgroup *obj_cgroup_all
 	return objcg;
 }
 
-static void memcg_reparent_objcgs(struct mem_cgroup *memcg,
-				  struct mem_cgroup *parent)
+static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
 {
 	struct obj_cgroup *objcg, *iter;
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 
 	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
 
@@ -345,6 +356,7 @@ static void memcg_reparent_objcgs(struct
 	percpu_ref_kill(&objcg->refcnt);
 }
 
+#ifdef CONFIG_MEMCG_KMEM
 /*
  * A lot of the calls to the cache allocation functions are expected to be
  * inlined by the compiler. Since the calls to memcg_slab_pre_alloc_hook() are
@@ -3650,21 +3662,12 @@ static u64 mem_cgroup_read_u64(struct cg
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
@@ -3674,17 +3677,13 @@ static int memcg_online_kmem(struct mem_
 
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
@@ -5189,8 +5188,8 @@ static struct mem_cgroup *mem_cgroup_all
 	memcg->socket_pressure = jiffies;
 #ifdef CONFIG_MEMCG_KMEM
 	memcg->kmemcg_id = -1;
-	INIT_LIST_HEAD(&memcg->objcg_list);
 #endif
+	INIT_LIST_HEAD(&memcg->objcg_list);
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
@@ -5255,6 +5254,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	struct obj_cgroup *objcg;
 
 	if (memcg_online_kmem(memcg))
 		goto remove_id;
@@ -5267,6 +5267,13 @@ static int mem_cgroup_css_online(struct
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
@@ -5275,6 +5282,8 @@ static int mem_cgroup_css_online(struct
 		queue_delayed_work(system_unbound_wq, &stats_flush_dwork,
 				   2UL*HZ);
 	return 0;
+free_shrinker:
+	free_shrinker_info(memcg);
 offline_kmem:
 	memcg_offline_kmem(memcg);
 remove_id:
@@ -5302,6 +5311,7 @@ static void mem_cgroup_css_offline(struc
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
 
+	memcg_reparent_objcgs(memcg);
 	memcg_offline_kmem(memcg);
 	reparent_shrinker_deferred(memcg);
 	wb_memcg_offline(memcg);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-fix-missing-wake-up-event-for-fsdax-pages.patch
mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented.patch
mm-vmscan-rework-move_pages_to_lru.patch
mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented.patch
mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe.patch
mm-memcontrol-introduce-memcg_reparent_ops.patch
mm-memcontrol-use-obj_cgroup-apis-to-charge-the-lru-pages.patch
mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-function.patch
mm-hugetlb_vmemmap-delete-hugetlb_optimize_vmemmap_enabled.patch
mm-hugetlb_vmemmap-optimize-vmemmap_optimize_mode-handling.patch
mm-hugetlb_vmemmap-introduce-the-name-hvo.patch
mm-hugetlb_vmemmap-move-vmemmap-code-related-to-hugetlb-to-hugetlb_vmemmapc.patch
mm-hugetlb_vmemmap-replace-early_param-with-core_param.patch
mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability.patch
mm-hugetlb_vmemmap-move-code-comments-to-vmemmap_deduprst.patch
mm-hugetlb_vmemmap-use-ptrs_per_pte-instead-of-pmd_size-page_size.patch

