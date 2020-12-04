Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27CCCC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 22:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF05122D49
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 22:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgLDWzs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Dec 2020 17:55:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725986AbgLDWzs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Dec 2020 17:55:48 -0500
Date:   Fri, 04 Dec 2020 14:55:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607122506;
        bh=ci6Au8xYKmqgj43KvuMlBSak6MTI5Ny6ehlQHWkduz0=;
        h=From:To:Subject:From;
        b=sfQBEgqB1zbYFObD+GlnYx7SfDOQnp586tE0+X+tgDvU9RiSvpdwUDhmAIqPbfurp
         2cWK752/7e0JA550lEz74DYWh63O9/1+VpB01RbyNvx23VLPgPuFvC0wgykTukkE0Z
         QX6wEyAVNLrPlGfj6CDW1m1LEmHMBIOXbS89Rq/0=
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  [merged]
 mm-memcontrol-use-helpers-to-read-pages-memcg-data.patch removed from -mm
 tree
Message-ID: <20201204225506.8rI646ARP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: use helpers to read page's memcg data
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-use-helpers-to-read-pages-memcg-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcontrol: use helpers to read page's memcg data

Patch series "mm: allow mapping accounted kernel pages to userspace", v6.

Currently a non-slab kernel page which has been charged to a memory cgroup
can't be mapped to userspace.  The underlying reason is simple: PageKmemcg
flag is defined as a page type (like buddy, offline, etc), so it takes a
bit from a page->mapped counter.  Pages with a type set can't be mapped to
userspace.

But in general the kmemcg flag has nothing to do with mapping to
userspace.  It only means that the page has been accounted by the page
allocator, so it has to be properly uncharged on release.

Some bpf maps are mapping the vmalloc-based memory to userspace, and their
memory can't be accounted because of this implementation detail.

This patchset removes this limitation by moving the PageKmemcg flag into
one of the free bits of the page->mem_cgroup pointer.  Also it formalizes
accesses to the page->mem_cgroup and page->obj_cgroups using new helpers,
adds several checks and removes a couple of obsolete functions.  As the
result the code became more robust with fewer open-coded bit tricks.


This patch (of 4):

Currently there are many open-coded reads of the page->mem_cgroup pointer,
as well as a couple of read helpers, which are barely used.

It creates an obstacle on a way to reuse some bits of the pointer for
storing additional bits of information.  In fact, we already do this for
slab pages, where the last bit indicates that a pointer has an attached
vector of objcg pointers instead of a regular memcg pointer.

This commits uses 2 existing helpers and introduces a new helper to
converts all read sides to calls of these helpers:
  struct mem_cgroup *page_memcg(struct page *page);
  struct mem_cgroup *page_memcg_rcu(struct page *page);
  struct mem_cgroup *page_memcg_check(struct page *page);

page_memcg_check() is intended to be used in cases when the page can be a
slab page and have a memcg pointer pointing at objcg vector.  It does
check the lowest bit, and if set, returns NULL.  page_memcg() contains a
VM_BUG_ON_PAGE() check for the page not being a slab page.

To make sure nobody uses a direct access, struct page's
mem_cgroup/obj_cgroups is converted to unsigned long memcg_data.

Link: https://lkml.kernel.org/r/20201027001657.3398190-1-guro@fb.com
Link: https://lkml.kernel.org/r/20201027001657.3398190-2-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                      |    2 
 fs/iomap/buffered-io.c           |    2 
 include/linux/memcontrol.h       |  109 +++++++++++++++++++++++--
 include/linux/mm.h               |   22 -----
 include/linux/mm_types.h         |    5 -
 include/trace/events/writeback.h |    2 
 kernel/fork.c                    |    7 -
 mm/debug.c                       |    4 
 mm/huge_memory.c                 |    4 
 mm/memcontrol.c                  |  126 +++++++++++++----------------
 mm/page_alloc.c                  |    4 
 mm/page_io.c                     |    6 -
 mm/slab.h                        |    9 --
 mm/workingset.c                  |    2 
 14 files changed, 184 insertions(+), 120 deletions(-)

--- a/fs/buffer.c~mm-memcontrol-use-helpers-to-read-pages-memcg-data
+++ a/fs/buffer.c
@@ -657,7 +657,7 @@ int __set_page_dirty_buffers(struct page
 		} while (bh != head);
 	}
 	/*
-	 * Lock out page->mem_cgroup migration to keep PageDirty
+	 * Lock out page's memcg migration to keep PageDirty
 	 * synchronized with per-memcg dirty page counters.
 	 */
 	lock_page_memcg(page);
--- a/fs/iomap/buffered-io.c~mm-memcontrol-use-helpers-to-read-pages-memcg-data
+++ a/fs/iomap/buffered-io.c
@@ -650,7 +650,7 @@ iomap_set_page_dirty(struct page *page)
 		return !TestSetPageDirty(page);
 
 	/*
-	 * Lock out page->mem_cgroup migration to keep PageDirty
+	 * Lock out page's memcg migration to keep PageDirty
 	 * synchronized with per-memcg dirty page counters.
 	 */
 	lock_page_memcg(page);
--- a/include/linux/memcontrol.h~mm-memcontrol-use-helpers-to-read-pages-memcg-data
+++ a/include/linux/memcontrol.h
@@ -337,6 +337,79 @@ struct mem_cgroup {
 
 extern struct mem_cgroup *root_mem_cgroup;
 
+/*
+ * page_memcg - get the memory cgroup associated with a page
+ * @page: a pointer to the page struct
+ *
+ * Returns a pointer to the memory cgroup associated with the page,
+ * or NULL. This function assumes that the page is known to have a
+ * proper memory cgroup pointer. It's not safe to call this function
+ * against some type of pages, e.g. slab pages or ex-slab pages.
+ *
+ * Any of the following ensures page and memcg binding stability:
+ * - the page lock
+ * - LRU isolation
+ * - lock_page_memcg()
+ * - exclusive reference
+ */
+static inline struct mem_cgroup *page_memcg(struct page *page)
+{
+	VM_BUG_ON_PAGE(PageSlab(page), page);
+	return (struct mem_cgroup *)page->memcg_data;
+}
+
+/*
+ * page_memcg_rcu - locklessly get the memory cgroup associated with a page
+ * @page: a pointer to the page struct
+ *
+ * Returns a pointer to the memory cgroup associated with the page,
+ * or NULL. This function assumes that the page is known to have a
+ * proper memory cgroup pointer. It's not safe to call this function
+ * against some type of pages, e.g. slab pages or ex-slab pages.
+ */
+static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
+{
+	VM_BUG_ON_PAGE(PageSlab(page), page);
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
+	return (struct mem_cgroup *)READ_ONCE(page->memcg_data);
+}
+
+/*
+ * page_memcg_check - get the memory cgroup associated with a page
+ * @page: a pointer to the page struct
+ *
+ * Returns a pointer to the memory cgroup associated with the page,
+ * or NULL. This function unlike page_memcg() can take any  page
+ * as an argument. It has to be used in cases when it's not known if a page
+ * has an associated memory cgroup pointer or an object cgroups vector.
+ *
+ * Any of the following ensures page and memcg binding stability:
+ * - the page lock
+ * - LRU isolation
+ * - lock_page_memcg()
+ * - exclusive reference
+ */
+static inline struct mem_cgroup *page_memcg_check(struct page *page)
+{
+	/*
+	 * Because page->memcg_data might be changed asynchronously
+	 * for slab pages, READ_ONCE() should be used here.
+	 */
+	unsigned long memcg_data = READ_ONCE(page->memcg_data);
+
+	/*
+	 * The lowest bit set means that memcg isn't a valid
+	 * memcg pointer, but a obj_cgroups pointer.
+	 * In this case the page is shared and doesn't belong
+	 * to any specific memory cgroup.
+	 */
+	if (memcg_data & 0x1UL)
+		return NULL;
+
+	return (struct mem_cgroup *)memcg_data;
+}
+
 static __always_inline bool memcg_stat_item_in_bytes(int idx)
 {
 	if (idx == MEMCG_PERCPU_B)
@@ -764,15 +837,19 @@ static inline void mod_memcg_state(struc
 static inline void __mod_memcg_page_state(struct page *page,
 					  int idx, int val)
 {
-	if (page->mem_cgroup)
-		__mod_memcg_state(page->mem_cgroup, idx, val);
+	struct mem_cgroup *memcg = page_memcg(page);
+
+	if (memcg)
+		__mod_memcg_state(memcg, idx, val);
 }
 
 static inline void mod_memcg_page_state(struct page *page,
 					int idx, int val)
 {
-	if (page->mem_cgroup)
-		mod_memcg_state(page->mem_cgroup, idx, val);
+	struct mem_cgroup *memcg = page_memcg(page);
+
+	if (memcg)
+		mod_memcg_state(memcg, idx, val);
 }
 
 static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
@@ -858,8 +935,10 @@ static inline void count_memcg_events(st
 static inline void count_memcg_page_event(struct page *page,
 					  enum vm_event_item idx)
 {
-	if (page->mem_cgroup)
-		count_memcg_events(page->mem_cgroup, idx, 1);
+	struct mem_cgroup *memcg = page_memcg(page);
+
+	if (memcg)
+		count_memcg_events(memcg, idx, 1);
 }
 
 static inline void count_memcg_event_mm(struct mm_struct *mm,
@@ -928,6 +1007,22 @@ void mem_cgroup_split_huge_fixup(struct
 
 struct mem_cgroup;
 
+static inline struct mem_cgroup *page_memcg(struct page *page)
+{
+	return NULL;
+}
+
+static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
+{
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	return NULL;
+}
+
+static inline struct mem_cgroup *page_memcg_check(struct page *page)
+{
+	return NULL;
+}
+
 static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 {
 	return true;
@@ -1422,7 +1517,7 @@ static inline void mem_cgroup_track_fore
 	if (mem_cgroup_disabled())
 		return;
 
-	if (unlikely(&page->mem_cgroup->css != wb->memcg_css))
+	if (unlikely(&page_memcg(page)->css != wb->memcg_css))
 		mem_cgroup_track_foreign_dirty_slowpath(page, wb);
 }
 
--- a/include/linux/mm.h~mm-memcontrol-use-helpers-to-read-pages-memcg-data
+++ a/include/linux/mm.h
@@ -1492,28 +1492,6 @@ static inline void set_page_links(struct
 #endif
 }
 
-#ifdef CONFIG_MEMCG
-static inline struct mem_cgroup *page_memcg(struct page *page)
-{
-	return page->mem_cgroup;
-}
-static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
-{
-	WARN_ON_ONCE(!rcu_read_lock_held());
-	return READ_ONCE(page->mem_cgroup);
-}
-#else
-static inline struct mem_cgroup *page_memcg(struct page *page)
-{
-	return NULL;
-}
-static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
-{
-	WARN_ON_ONCE(!rcu_read_lock_held());
-	return NULL;
-}
-#endif
-
 /*
  * Some inline functions in vmstat.h depend on page_zone()
  */
--- a/include/linux/mm_types.h~mm-memcontrol-use-helpers-to-read-pages-memcg-data
+++ a/include/linux/mm_types.h
@@ -200,10 +200,7 @@ struct page {
 	atomic_t _refcount;
 
 #ifdef CONFIG_MEMCG
-	union {
-		struct mem_cgroup *mem_cgroup;
-		struct obj_cgroup **obj_cgroups;
-	};
+	unsigned long memcg_data;
 #endif
 
 	/*
--- a/include/trace/events/writeback.h~mm-memcontrol-use-helpers-to-read-pages-memcg-data
+++ a/include/trace/events/writeback.h
@@ -257,7 +257,7 @@ TRACE_EVENT(track_foreign_dirty,
 		__entry->ino		= inode ? inode->i_ino : 0;
 		__entry->memcg_id	= wb->memcg_css->id;
 		__entry->cgroup_ino	= __trace_wb_assign_cgroup(wb);
-		__entry->page_cgroup_ino = cgroup_ino(page->mem_cgroup->css.cgroup);
+		__entry->page_cgroup_ino = cgroup_ino(page_memcg(page)->css.cgroup);
 	),
 
 	TP_printk("bdi %s[%llu]: ino=%lu memcg_id=%u cgroup_ino=%lu page_cgroup_ino=%lu",
--- a/kernel/fork.c~mm-memcontrol-use-helpers-to-read-pages-memcg-data
+++ a/kernel/fork.c
@@ -405,9 +405,10 @@ static int memcg_charge_kernel_stack(str
 
 		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
 			/*
-			 * If memcg_kmem_charge_page() fails, page->mem_cgroup
-			 * pointer is NULL, and memcg_kmem_uncharge_page() in
-			 * free_thread_stack() will ignore this page.
+			 * If memcg_kmem_charge_page() fails, page's
+			 * memory cgroup pointer is NULL, and
+			 * memcg_kmem_uncharge_page() in free_thread_stack()
+			 * will ignore this page.
 			 */
 			ret = memcg_kmem_charge_page(vm->pages[i], GFP_KERNEL,
 						     0);
--- a/mm/debug.c~mm-memcontrol-use-helpers-to-read-pages-memcg-data
+++ a/mm/debug.c
@@ -182,8 +182,8 @@ hex_only:
 		pr_warn("page dumped because: %s\n", reason);
 
 #ifdef CONFIG_MEMCG
-	if (!page_poisoned && page->mem_cgroup)
-		pr_warn("page->mem_cgroup:%px\n", page->mem_cgroup);
+	if (!page_poisoned && page->memcg_data)
+		pr_warn("pages's memcg:%lx\n", page->memcg_data);
 #endif
 }
 
--- a/mm/huge_memory.c~mm-memcontrol-use-helpers-to-read-pages-memcg-data
+++ a/mm/huge_memory.c
@@ -484,7 +484,7 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struc
 #ifdef CONFIG_MEMCG
 static inline struct deferred_split *get_deferred_split_queue(struct page *page)
 {
-	struct mem_cgroup *memcg = compound_head(page)->mem_cgroup;
+	struct mem_cgroup *memcg = page_memcg(compound_head(page));
 	struct pglist_data *pgdat = NODE_DATA(page_to_nid(page));
 
 	if (memcg)
@@ -2799,7 +2799,7 @@ void deferred_split_huge_page(struct pag
 {
 	struct deferred_split *ds_queue = get_deferred_split_queue(page);
 #ifdef CONFIG_MEMCG
-	struct mem_cgroup *memcg = compound_head(page)->mem_cgroup;
+	struct mem_cgroup *memcg = page_memcg(compound_head(page));
 #endif
 	unsigned long flags;
 
--- a/mm/memcontrol.c~mm-memcontrol-use-helpers-to-read-pages-memcg-data
+++ a/mm/memcontrol.c
@@ -536,7 +536,7 @@ struct cgroup_subsys_state *mem_cgroup_c
 {
 	struct mem_cgroup *memcg;
 
-	memcg = page->mem_cgroup;
+	memcg = page_memcg(page);
 
 	if (!memcg || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		memcg = root_mem_cgroup;
@@ -563,16 +563,7 @@ ino_t page_cgroup_ino(struct page *page)
 	unsigned long ino = 0;
 
 	rcu_read_lock();
-	memcg = page->mem_cgroup;
-
-	/*
-	 * The lowest bit set means that memcg isn't a valid
-	 * memcg pointer, but a obj_cgroups pointer.
-	 * In this case the page is shared and doesn't belong
-	 * to any specific memory cgroup.
-	 */
-	if ((unsigned long) memcg & 0x1UL)
-		memcg = NULL;
+	memcg = page_memcg_check(page);
 
 	while (memcg && !(memcg->css.flags & CSS_ONLINE))
 		memcg = parent_mem_cgroup(memcg);
@@ -860,16 +851,17 @@ void __mod_lruvec_page_state(struct page
 			     int val)
 {
 	struct page *head = compound_head(page); /* rmap on tail pages */
+	struct mem_cgroup *memcg = page_memcg(head);
 	pg_data_t *pgdat = page_pgdat(page);
 	struct lruvec *lruvec;
 
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
-	if (!head->mem_cgroup) {
+	if (!memcg) {
 		__mod_node_page_state(pgdat, idx, val);
 		return;
 	}
 
-	lruvec = mem_cgroup_lruvec(head->mem_cgroup, pgdat);
+	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	__mod_lruvec_state(lruvec, idx, val);
 }
 
@@ -1059,7 +1051,7 @@ EXPORT_SYMBOL(get_mem_cgroup_from_mm);
  */
 struct mem_cgroup *get_mem_cgroup_from_page(struct page *page)
 {
-	struct mem_cgroup *memcg = page->mem_cgroup;
+	struct mem_cgroup *memcg = page_memcg(page);
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -1368,7 +1360,7 @@ struct lruvec *mem_cgroup_page_lruvec(st
 		goto out;
 	}
 
-	memcg = page->mem_cgroup;
+	memcg = page_memcg(page);
 	/*
 	 * Swapcache readahead pages are added to the LRU - and
 	 * possibly migrated - before they are charged.
@@ -2203,7 +2195,7 @@ void mem_cgroup_print_oom_group(struct m
 }
 
 /**
- * lock_page_memcg - lock a page->mem_cgroup binding
+ * lock_page_memcg - lock a page and memcg binding
  * @page: the page
  *
  * This function protects unlocked LRU pages from being moved to
@@ -2235,7 +2227,7 @@ struct mem_cgroup *lock_page_memcg(struc
 	if (mem_cgroup_disabled())
 		return NULL;
 again:
-	memcg = head->mem_cgroup;
+	memcg = page_memcg(head);
 	if (unlikely(!memcg))
 		return NULL;
 
@@ -2249,7 +2241,7 @@ again:
 		return memcg;
 
 	spin_lock_irqsave(&memcg->move_lock, flags);
-	if (memcg != head->mem_cgroup) {
+	if (memcg != page_memcg(head)) {
 		spin_unlock_irqrestore(&memcg->move_lock, flags);
 		goto again;
 	}
@@ -2287,14 +2279,14 @@ void __unlock_page_memcg(struct mem_cgro
 }
 
 /**
- * unlock_page_memcg - unlock a page->mem_cgroup binding
+ * unlock_page_memcg - unlock a page and memcg binding
  * @page: the page
  */
 void unlock_page_memcg(struct page *page)
 {
 	struct page *head = compound_head(page);
 
-	__unlock_page_memcg(head->mem_cgroup);
+	__unlock_page_memcg(page_memcg(head));
 }
 EXPORT_SYMBOL(unlock_page_memcg);
 
@@ -2984,7 +2976,7 @@ static void cancel_charge(struct mem_cgr
 
 static void commit_charge(struct page *page, struct mem_cgroup *memcg)
 {
-	VM_BUG_ON_PAGE(page->mem_cgroup, page);
+	VM_BUG_ON_PAGE(page_memcg(page), page);
 	/*
 	 * Any of the following ensures page's memcg stability:
 	 *
@@ -2993,7 +2985,7 @@ static void commit_charge(struct page *p
 	 * - lock_page_memcg()
 	 * - exclusive reference
 	 */
-	page->mem_cgroup = memcg;
+	page->memcg_data = (unsigned long)memcg;
 }
 
 #ifdef CONFIG_MEMCG_KMEM
@@ -3008,8 +3000,7 @@ int memcg_alloc_page_obj_cgroups(struct
 	if (!vec)
 		return -ENOMEM;
 
-	if (cmpxchg(&page->obj_cgroups, NULL,
-		    (struct obj_cgroup **) ((unsigned long)vec | 0x1UL)))
+	if (cmpxchg(&page->memcg_data, 0, (unsigned long)vec | 0x1UL))
 		kfree(vec);
 	else
 		kmemleak_not_leak(vec);
@@ -3020,6 +3011,12 @@ int memcg_alloc_page_obj_cgroups(struct
 /*
  * Returns a pointer to the memory cgroup to which the kernel object is charged.
  *
+ * A passed kernel object can be a slab object or a generic kernel page, so
+ * different mechanisms for getting the memory cgroup pointer should be used.
+ * In certain cases (e.g. kernel stacks or large kmallocs with SLUB) the caller
+ * can not know for sure how the kernel object is implemented.
+ * mem_cgroup_from_obj() can be safely used in such cases.
+ *
  * The caller must ensure the memcg lifetime, e.g. by taking rcu_read_lock(),
  * cgroup_mutex, etc.
  */
@@ -3033,17 +3030,6 @@ struct mem_cgroup *mem_cgroup_from_obj(v
 	page = virt_to_head_page(p);
 
 	/*
-	 * If page->mem_cgroup is set, it's either a simple mem_cgroup pointer
-	 * or a pointer to obj_cgroup vector. In the latter case the lowest
-	 * bit of the pointer is set.
-	 * The page->mem_cgroup pointer can be asynchronously changed
-	 * from NULL to (obj_cgroup_vec | 0x1UL), but can't be changed
-	 * from a valid memcg pointer to objcg vector or back.
-	 */
-	if (!page->mem_cgroup)
-		return NULL;
-
-	/*
 	 * Slab objects are accounted individually, not per-page.
 	 * Memcg membership data for each individual object is saved in
 	 * the page->obj_cgroups.
@@ -3060,8 +3046,14 @@ struct mem_cgroup *mem_cgroup_from_obj(v
 		return NULL;
 	}
 
-	/* All other pages use page->mem_cgroup */
-	return page->mem_cgroup;
+	/*
+	 * page_memcg_check() is used here, because page_has_obj_cgroups()
+	 * check above could fail because the object cgroups vector wasn't set
+	 * at that moment, but it can be set concurrently.
+	 * page_memcg_check(page) will guarantee that a proper memory
+	 * cgroup pointer or NULL will be returned.
+	 */
+	return page_memcg_check(page);
 }
 
 __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
@@ -3200,7 +3192,7 @@ int __memcg_kmem_charge_page(struct page
 	if (memcg && !mem_cgroup_is_root(memcg)) {
 		ret = __memcg_kmem_charge(memcg, gfp, 1 << order);
 		if (!ret) {
-			page->mem_cgroup = memcg;
+			page->memcg_data = (unsigned long)memcg;
 			__SetPageKmemcg(page);
 			return 0;
 		}
@@ -3216,7 +3208,7 @@ int __memcg_kmem_charge_page(struct page
  */
 void __memcg_kmem_uncharge_page(struct page *page, int order)
 {
-	struct mem_cgroup *memcg = page->mem_cgroup;
+	struct mem_cgroup *memcg = page_memcg(page);
 	unsigned int nr_pages = 1 << order;
 
 	if (!memcg)
@@ -3224,7 +3216,7 @@ void __memcg_kmem_uncharge_page(struct p
 
 	VM_BUG_ON_PAGE(mem_cgroup_is_root(memcg), page);
 	__memcg_kmem_uncharge(memcg, nr_pages);
-	page->mem_cgroup = NULL;
+	page->memcg_data = 0;
 	css_put(&memcg->css);
 
 	/* slab pages do not have PageKmemcg flag set */
@@ -3375,7 +3367,7 @@ void obj_cgroup_uncharge(struct obj_cgro
  */
 void mem_cgroup_split_huge_fixup(struct page *head)
 {
-	struct mem_cgroup *memcg = head->mem_cgroup;
+	struct mem_cgroup *memcg = page_memcg(head);
 	int i;
 
 	if (mem_cgroup_disabled())
@@ -3383,7 +3375,7 @@ void mem_cgroup_split_huge_fixup(struct
 
 	for (i = 1; i < HPAGE_PMD_NR; i++) {
 		css_get(&memcg->css);
-		head[i].mem_cgroup = memcg;
+		head[i].memcg_data = (unsigned long)memcg;
 	}
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
@@ -4724,7 +4716,7 @@ void mem_cgroup_wb_stats(struct bdi_writ
 void mem_cgroup_track_foreign_dirty_slowpath(struct page *page,
 					     struct bdi_writeback *wb)
 {
-	struct mem_cgroup *memcg = page->mem_cgroup;
+	struct mem_cgroup *memcg = page_memcg(page);
 	struct memcg_cgwb_frn *frn;
 	u64 now = get_jiffies_64();
 	u64 oldest_at = now;
@@ -5685,14 +5677,14 @@ static int mem_cgroup_move_account(struc
 
 	/*
 	 * Prevent mem_cgroup_migrate() from looking at
-	 * page->mem_cgroup of its source page while we change it.
+	 * page's memory cgroup of its source page while we change it.
 	 */
 	ret = -EBUSY;
 	if (!trylock_page(page))
 		goto out;
 
 	ret = -EINVAL;
-	if (page->mem_cgroup != from)
+	if (page_memcg(page) != from)
 		goto out_unlock;
 
 	pgdat = page_pgdat(page);
@@ -5747,13 +5739,13 @@ static int mem_cgroup_move_account(struc
 	/*
 	 * All state has been migrated, let's switch to the new memcg.
 	 *
-	 * It is safe to change page->mem_cgroup here because the page
+	 * It is safe to change page's memcg here because the page
 	 * is referenced, charged, isolated, and locked: we can't race
 	 * with (un)charging, migration, LRU putback, or anything else
-	 * that would rely on a stable page->mem_cgroup.
+	 * that would rely on a stable page's memory cgroup.
 	 *
 	 * Note that lock_page_memcg is a memcg lock, not a page lock,
-	 * to save space. As soon as we switch page->mem_cgroup to a
+	 * to save space. As soon as we switch page's memory cgroup to a
 	 * new memcg that isn't locked, the above state can change
 	 * concurrently again. Make sure we're truly done with it.
 	 */
@@ -5762,7 +5754,7 @@ static int mem_cgroup_move_account(struc
 	css_get(&to->css);
 	css_put(&from->css);
 
-	page->mem_cgroup = to;
+	page->memcg_data = (unsigned long)to;
 
 	__unlock_page_memcg(from);
 
@@ -5828,7 +5820,7 @@ static enum mc_target_type get_mctgt_typ
 		 * mem_cgroup_move_account() checks the page is valid or
 		 * not under LRU exclusion.
 		 */
-		if (page->mem_cgroup == mc.from) {
+		if (page_memcg(page) == mc.from) {
 			ret = MC_TARGET_PAGE;
 			if (is_device_private_page(page))
 				ret = MC_TARGET_DEVICE;
@@ -5872,7 +5864,7 @@ static enum mc_target_type get_mctgt_typ
 	VM_BUG_ON_PAGE(!page || !PageHead(page), page);
 	if (!(mc.flags & MOVE_ANON))
 		return ret;
-	if (page->mem_cgroup == mc.from) {
+	if (page_memcg(page) == mc.from) {
 		ret = MC_TARGET_PAGE;
 		if (target) {
 			get_page(page);
@@ -6799,12 +6791,12 @@ int mem_cgroup_charge(struct page *page,
 		/*
 		 * Every swap fault against a single page tries to charge the
 		 * page, bail as early as possible.  shmem_unuse() encounters
-		 * already charged pages, too.  page->mem_cgroup is protected
-		 * by the page lock, which serializes swap cache removal, which
-		 * in turn serializes uncharging.
+		 * already charged pages, too.  page and memcg binding is
+		 * protected by the page lock, which serializes swap cache
+		 * removal, which in turn serializes uncharging.
 		 */
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
-		if (compound_head(page)->mem_cgroup)
+		if (page_memcg(compound_head(page)))
 			goto out;
 
 		id = lookup_swap_cgroup_id(ent);
@@ -6888,21 +6880,21 @@ static void uncharge_page(struct page *p
 
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 
-	if (!page->mem_cgroup)
+	if (!page_memcg(page))
 		return;
 
 	/*
 	 * Nobody should be changing or seriously looking at
-	 * page->mem_cgroup at this point, we have fully
+	 * page_memcg(page) at this point, we have fully
 	 * exclusive access to the page.
 	 */
 
-	if (ug->memcg != page->mem_cgroup) {
+	if (ug->memcg != page_memcg(page)) {
 		if (ug->memcg) {
 			uncharge_batch(ug);
 			uncharge_gather_clear(ug);
 		}
-		ug->memcg = page->mem_cgroup;
+		ug->memcg = page_memcg(page);
 
 		/* pairs with css_put in uncharge_batch */
 		css_get(&ug->memcg->css);
@@ -6919,7 +6911,7 @@ static void uncharge_page(struct page *p
 	}
 
 	ug->dummy_page = page;
-	page->mem_cgroup = NULL;
+	page->memcg_data = 0;
 	css_put(&ug->memcg->css);
 }
 
@@ -6962,7 +6954,7 @@ void mem_cgroup_uncharge(struct page *pa
 		return;
 
 	/* Don't touch page->lru of any random page, pre-check: */
-	if (!page->mem_cgroup)
+	if (!page_memcg(page))
 		return;
 
 	uncharge_gather_clear(&ug);
@@ -7012,10 +7004,10 @@ void mem_cgroup_migrate(struct page *old
 		return;
 
 	/* Page cache replacement: new page already charged? */
-	if (newpage->mem_cgroup)
+	if (page_memcg(newpage))
 		return;
 
-	memcg = oldpage->mem_cgroup;
+	memcg = page_memcg(oldpage);
 	if (!memcg)
 		return;
 
@@ -7210,7 +7202,7 @@ void mem_cgroup_swapout(struct page *pag
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
-	memcg = page->mem_cgroup;
+	memcg = page_memcg(page);
 
 	/* Readahead page, never charged */
 	if (!memcg)
@@ -7231,7 +7223,7 @@ void mem_cgroup_swapout(struct page *pag
 	VM_BUG_ON_PAGE(oldid, page);
 	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
 
-	page->mem_cgroup = NULL;
+	page->memcg_data = 0;
 
 	if (!mem_cgroup_is_root(memcg))
 		page_counter_uncharge(&memcg->memory, nr_entries);
@@ -7274,7 +7266,7 @@ int mem_cgroup_try_charge_swap(struct pa
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return 0;
 
-	memcg = page->mem_cgroup;
+	memcg = page_memcg(page);
 
 	/* Readahead page, never charged */
 	if (!memcg)
@@ -7355,7 +7347,7 @@ bool mem_cgroup_swap_full(struct page *p
 	if (cgroup_memory_noswap || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return false;
 
-	memcg = page->mem_cgroup;
+	memcg = page_memcg(page);
 	if (!memcg)
 		return false;
 
--- a/mm/page_alloc.c~mm-memcontrol-use-helpers-to-read-pages-memcg-data
+++ a/mm/page_alloc.c
@@ -1101,7 +1101,7 @@ static inline bool page_expected_state(s
 	if (unlikely((unsigned long)page->mapping |
 			page_ref_count(page) |
 #ifdef CONFIG_MEMCG
-			(unsigned long)page->mem_cgroup |
+			(unsigned long)page_memcg(page) |
 #endif
 			(page->flags & check_flags)))
 		return false;
@@ -1126,7 +1126,7 @@ static const char *page_bad_reason(struc
 			bad_reason = "PAGE_FLAGS_CHECK_AT_FREE flag(s) set";
 	}
 #ifdef CONFIG_MEMCG
-	if (unlikely(page->mem_cgroup))
+	if (unlikely(page_memcg(page)))
 		bad_reason = "page still charged to cgroup";
 #endif
 	return bad_reason;
--- a/mm/page_io.c~mm-memcontrol-use-helpers-to-read-pages-memcg-data
+++ a/mm/page_io.c
@@ -291,12 +291,14 @@ static inline void count_swpout_vm_event
 static void bio_associate_blkg_from_page(struct bio *bio, struct page *page)
 {
 	struct cgroup_subsys_state *css;
+	struct mem_cgroup *memcg;
 
-	if (!page->mem_cgroup)
+	memcg = page_memcg(page);
+	if (!memcg)
 		return;
 
 	rcu_read_lock();
-	css = cgroup_e_css(page->mem_cgroup->css.cgroup, &io_cgrp_subsys);
+	css = cgroup_e_css(memcg->css.cgroup, &io_cgrp_subsys);
 	bio_associate_blkg_from_css(bio, css);
 	rcu_read_unlock();
 }
--- a/mm/slab.h~mm-memcontrol-use-helpers-to-read-pages-memcg-data
+++ a/mm/slab.h
@@ -242,18 +242,17 @@ static inline bool kmem_cache_debug_flag
 static inline struct obj_cgroup **page_obj_cgroups(struct page *page)
 {
 	/*
-	 * page->mem_cgroup and page->obj_cgroups are sharing the same
+	 * Page's memory cgroup and obj_cgroups vector are sharing the same
 	 * space. To distinguish between them in case we don't know for sure
 	 * that the page is a slab page (e.g. page_cgroup_ino()), let's
 	 * always set the lowest bit of obj_cgroups.
 	 */
-	return (struct obj_cgroup **)
-		((unsigned long)page->obj_cgroups & ~0x1UL);
+	return (struct obj_cgroup **)(page->memcg_data & ~0x1UL);
 }
 
 static inline bool page_has_obj_cgroups(struct page *page)
 {
-	return ((unsigned long)page->obj_cgroups & 0x1UL);
+	return page->memcg_data & 0x1UL;
 }
 
 int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
@@ -262,7 +261,7 @@ int memcg_alloc_page_obj_cgroups(struct
 static inline void memcg_free_page_obj_cgroups(struct page *page)
 {
 	kfree(page_obj_cgroups(page));
-	page->obj_cgroups = NULL;
+	page->memcg_data = 0;
 }
 
 static inline size_t obj_full_size(struct kmem_cache *s)
--- a/mm/workingset.c~mm-memcontrol-use-helpers-to-read-pages-memcg-data
+++ a/mm/workingset.c
@@ -257,7 +257,7 @@ void *workingset_eviction(struct page *p
 	struct lruvec *lruvec;
 	int memcgid;
 
-	/* Page is fully exclusive and pins page->mem_cgroup */
+	/* Page is fully exclusive and pins page's memory cgroup pointer */
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 	VM_BUG_ON_PAGE(page_count(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-slab-fix-obj_cgroup_charge-return-value-handling.patch
mm-memcg-fix-obsolete-code-comments.patch
mm-memcg-deprecate-the-non-hierarchical-mode.patch
docs-cgroup-v1-reflect-the-deprecation-of-the-non-hierarchical-mode.patch
cgroup-remove-obsoleted-broken_hierarchy-and-warned_broken_hierarchy.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch
mm-slub-call-account_slab_page-after-slab-page-initialization.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-v2.patch

