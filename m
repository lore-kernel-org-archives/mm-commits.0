Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F102C43334
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jun 2022 20:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354346AbiFUUIh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 16:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354159AbiFUUI2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 16:08:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1177140CE
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 13:08:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50107617F5
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 20:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8087C3411C;
        Tue, 21 Jun 2022 20:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655842105;
        bh=E93jer764BBeV09XfssZGYaeBoJOAdyF+gwo6YaLtb8=;
        h=Date:To:From:Subject:From;
        b=XMqEccwADAAoWKSj3kXbyesskjYGkAjYV3zvC6RQVKPmCl9Fmf32n4dW4hvsOR9pa
         9iiTxbMvTvnUyfpovPw8F454603e3ialIvh3LH860ngAgepfHtFkx3r1wU9HVaplTX
         fiO2hLIzi82ZBGTx/FoTUfU4Kdy0ll4ngiQXfXk0=
Date:   Tue, 21 Jun 2022 13:08:17 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        longman@redhat.com, hannes@cmpxchg.org,
        duanxiongchun@bytedance.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe.patch added to mm-unstable branch
Message-Id: <20220621200823.B8087C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: make all the callers of {folio,page}_memcg() safe
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe.patch

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
Subject: mm: memcontrol: make all the callers of {folio,page}_memcg() safe
Date: Tue, 21 Jun 2022 20:56:54 +0800

When we use objcg APIs to charge the LRU pages, the page will not hold a
reference to the memcg associated with the page.  So the caller of the
{folio,page}_memcg() should hold an rcu read lock or obtain a reference to
the memcg associated with the page to protect memcg from being released. 
So introduce get_mem_cgroup_from_{page,folio}() to obtain a reference to
the memory cgroup associated with the page.

In this patch, make all the callers hold an rcu read lock or obtain a
reference to the memcg to protect memcg from being released when the LRU
pages reparented.

We do not need to adjust the callers of {folio,page}_memcg() during the
whole process of mem_cgroup_move_task().  Because the cgroup migration and
memory cgroup offlining are serialized by @cgroup_mutex.  In this routine,
the LRU pages cannot be reparented to its parent memory cgroup.  So
{folio,page}_memcg() is stable and cannot be released.

This is a preparation for reparenting the LRU pages.

Link: https://lkml.kernel.org/r/20220621125658.64935-8-songmuchun@bytedance.com
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

 fs/buffer.c                      |    4 -
 fs/fs-writeback.c                |   23 +++++----
 include/linux/memcontrol.h       |   66 +++++++++++++++++++++++++---
 include/trace/events/writeback.h |    5 ++
 mm/memcontrol.c                  |   68 +++++++++++++++++++++--------
 mm/migrate.c                     |    4 +
 mm/page_io.c                     |    5 +-
 7 files changed, 135 insertions(+), 40 deletions(-)

--- a/fs/buffer.c~mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe
+++ a/fs/buffer.c
@@ -819,8 +819,7 @@ struct buffer_head *alloc_page_buffers(s
 	if (retry)
 		gfp |= __GFP_NOFAIL;
 
-	/* The page lock pins the memcg */
-	memcg = page_memcg(page);
+	memcg = get_mem_cgroup_from_page(page);
 	old_memcg = set_active_memcg(memcg);
 
 	head = NULL;
@@ -840,6 +839,7 @@ struct buffer_head *alloc_page_buffers(s
 		set_bh_page(bh, page, offset);
 	}
 out:
+	mem_cgroup_put(memcg);
 	set_active_memcg(old_memcg);
 	return head;
 /*
--- a/fs/fs-writeback.c~mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe
+++ a/fs/fs-writeback.c
@@ -244,15 +244,13 @@ void __inode_attach_wb(struct inode *ino
 	if (inode_cgwb_enabled(inode)) {
 		struct cgroup_subsys_state *memcg_css;
 
-		if (page) {
-			memcg_css = mem_cgroup_css_from_page(page);
-			wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
-		} else {
-			/* must pin memcg_css, see wb_get_create() */
+		/* must pin memcg_css, see wb_get_create() */
+		if (page)
+			memcg_css = get_mem_cgroup_css_from_page(page);
+		else
 			memcg_css = task_get_css(current, memory_cgrp_id);
-			wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
-			css_put(memcg_css);
-		}
+		wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
+		css_put(memcg_css);
 	}
 
 	if (!wb)
@@ -869,16 +867,16 @@ void wbc_account_cgroup_owner(struct wri
 	if (!wbc->wb || wbc->no_cgroup_owner)
 		return;
 
-	css = mem_cgroup_css_from_page(page);
+	css = get_mem_cgroup_css_from_page(page);
 	/* dead cgroups shouldn't contribute to inode ownership arbitration */
 	if (!(css->flags & CSS_ONLINE))
-		return;
+		goto out;
 
 	id = css->id;
 
 	if (id == wbc->wb_id) {
 		wbc->wb_bytes += bytes;
-		return;
+		goto out;
 	}
 
 	if (id == wbc->wb_lcand_id)
@@ -891,6 +889,9 @@ void wbc_account_cgroup_owner(struct wri
 		wbc->wb_tcand_bytes += bytes;
 	else
 		wbc->wb_tcand_bytes -= min(bytes, wbc->wb_tcand_bytes);
+
+out:
+	css_put(css);
 }
 EXPORT_SYMBOL_GPL(wbc_account_cgroup_owner);
 
--- a/include/linux/memcontrol.h~mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe
+++ a/include/linux/memcontrol.h
@@ -379,7 +379,7 @@ static inline bool folio_memcg_kmem(stru
  * a valid memcg, but can be atomically swapped to the parent memcg.
  *
  * The caller must ensure that the returned memcg won't be released:
- * e.g. acquire the rcu_read_lock or css_set_lock.
+ * e.g. acquire the rcu_read_lock or objcg_lock or cgroup_mutex.
  */
 static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
 {
@@ -445,8 +445,8 @@ static inline struct obj_cgroup *__folio
  * - lock_page_memcg()
  * - exclusive reference
  *
- * For a kmem folio a caller should hold an rcu read lock to protect memcg
- * associated with a kmem folio from being released.
+ * Note: The caller should hold an rcu read lock to protect memcg associated
+ * with a folio from being released.
  */
 static inline struct mem_cgroup *folio_memcg(struct folio *folio)
 {
@@ -455,12 +455,48 @@ static inline struct mem_cgroup *folio_m
 	return __folio_memcg(folio);
 }
 
+/*
+ * page_memcg - Get the memory cgroup associated with a page.
+ * @page: Pointer to the page.
+ *
+ * See the cooments in folio_memcg().
+ */
 static inline struct mem_cgroup *page_memcg(struct page *page)
 {
 	return folio_memcg(page_folio(page));
 }
 
-/**
+/*
+ * get_mem_cgroup_from_folio - Obtain a reference on the memory cgroup
+ *			       associated with a folio.
+ * @folio: Pointer to the folio.
+ *
+ * Returns a pointer to the memory cgroup (and obtain a reference on it)
+ * associated with the folio, or NULL. This function assumes that the
+ * folio is known to have a proper memory cgroup pointer. It's not safe
+ * to call this function against some type of pages, e.g. slab pages or
+ * ex-slab pages.
+ */
+static inline struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+retry:
+	memcg = folio_memcg(folio);
+	if (unlikely(memcg && !css_tryget(&memcg->css)))
+		goto retry;
+	rcu_read_unlock();
+
+	return memcg;
+}
+
+static inline struct mem_cgroup *get_mem_cgroup_from_page(struct page *page)
+{
+	return get_mem_cgroup_from_folio(page_folio(page));
+}
+
+/*
  * folio_memcg_rcu - Locklessly get the memory cgroup associated with a folio.
  * @folio: Pointer to the folio.
  *
@@ -888,7 +924,7 @@ static inline bool mm_match_cgroup(struc
 	return match;
 }
 
-struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page);
+struct cgroup_subsys_state *get_mem_cgroup_css_from_page(struct page *page);
 ino_t page_cgroup_ino(struct page *page);
 
 static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
@@ -1058,19 +1094,25 @@ static inline void count_memcg_events(st
 static inline void count_memcg_page_event(struct page *page,
 					  enum vm_event_item idx)
 {
-	struct mem_cgroup *memcg = page_memcg(page);
+	struct mem_cgroup *memcg;
 
+	rcu_read_lock();
+	memcg = page_memcg(page);
 	if (memcg)
 		count_memcg_events(memcg, idx, 1);
+	rcu_read_unlock();
 }
 
 static inline void count_memcg_folio_events(struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg;
 
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
 	if (memcg)
 		count_memcg_events(memcg, idx, nr);
+	rcu_read_unlock();
 }
 
 static inline void count_memcg_event_mm(struct mm_struct *mm,
@@ -1148,6 +1190,16 @@ static inline struct mem_cgroup *page_me
 {
 	return NULL;
 }
+
+static inline struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
+{
+	return NULL;
+}
+
+static inline struct mem_cgroup *get_mem_cgroup_from_page(struct page *page)
+{
+	return NULL;
+}
 
 static inline struct mem_cgroup *folio_memcg_rcu(struct folio *folio)
 {
--- a/include/trace/events/writeback.h~mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe
+++ a/include/trace/events/writeback.h
@@ -258,6 +258,11 @@ TRACE_EVENT(track_foreign_dirty,
 		__entry->ino		= inode ? inode->i_ino : 0;
 		__entry->memcg_id	= wb->memcg_css->id;
 		__entry->cgroup_ino	= __trace_wb_assign_cgroup(wb);
+		/*
+		 * TP_fast_assign() is under preemption disabled which can
+		 * serve as an RCU read-side critical section so that the
+		 * memcg returned by folio_memcg() cannot be freed.
+		 */
 		__entry->page_cgroup_ino = cgroup_ino(folio_memcg(folio)->css.cgroup);
 	),
 
--- a/mm/memcontrol.c~mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe
+++ a/mm/memcontrol.c
@@ -369,7 +369,7 @@ EXPORT_SYMBOL(memcg_kmem_enabled_key);
 #endif
 
 /**
- * mem_cgroup_css_from_page - css of the memcg associated with a page
+ * get_mem_cgroup_css_from_page - get css of the memcg associated with a page
  * @page: page of interest
  *
  * If memcg is bound to the default hierarchy, css of the memcg associated
@@ -379,13 +379,15 @@ EXPORT_SYMBOL(memcg_kmem_enabled_key);
  * If memcg is bound to a traditional hierarchy, the css of root_mem_cgroup
  * is returned.
  */
-struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page)
+struct cgroup_subsys_state *get_mem_cgroup_css_from_page(struct page *page)
 {
 	struct mem_cgroup *memcg;
 
-	memcg = page_memcg(page);
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return &root_mem_cgroup->css;
 
-	if (!memcg || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	memcg = get_mem_cgroup_from_page(page);
+	if (!memcg)
 		memcg = root_mem_cgroup;
 
 	return &memcg->css;
@@ -768,13 +770,13 @@ void __mod_lruvec_state(struct lruvec *l
 void __mod_lruvec_page_state(struct page *page, enum node_stat_item idx,
 			     int val)
 {
-	struct page *head = compound_head(page); /* rmap on tail pages */
+	struct folio *folio = page_folio(page); /* rmap on tail pages */
 	struct mem_cgroup *memcg;
 	pg_data_t *pgdat = page_pgdat(page);
 	struct lruvec *lruvec;
 
 	rcu_read_lock();
-	memcg = page_memcg(head);
+	memcg = folio_memcg(folio);
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
 	if (!memcg) {
 		rcu_read_unlock();
@@ -2056,7 +2058,9 @@ void folio_memcg_lock(struct folio *foli
 	 * The RCU lock is held throughout the transaction.  The fast
 	 * path can get away without acquiring the memcg->move_lock
 	 * because page moving starts with an RCU grace period.
-         */
+	 *
+	 * The RCU lock also protects the memcg from being freed.
+	 */
 	rcu_read_lock();
 
 	if (mem_cgroup_disabled())
@@ -3353,7 +3357,7 @@ void obj_cgroup_uncharge(struct obj_cgro
 void split_page_memcg(struct page *head, unsigned int nr)
 {
 	struct folio *folio = page_folio(head);
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg = get_mem_cgroup_from_folio(folio);
 	int i;
 
 	if (mem_cgroup_disabled() || !memcg)
@@ -3366,6 +3370,8 @@ void split_page_memcg(struct page *head,
 		obj_cgroup_get_many(__folio_objcg(folio), nr - 1);
 	else
 		css_get_many(&memcg->css, nr - 1);
+
+	css_put(&memcg->css);
 }
 
 #ifdef CONFIG_MEMCG_SWAP
@@ -4558,7 +4564,7 @@ void mem_cgroup_wb_stats(struct bdi_writ
 void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 					     struct bdi_writeback *wb)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg = get_mem_cgroup_from_folio(folio);
 	struct memcg_cgwb_frn *frn;
 	u64 now = get_jiffies_64();
 	u64 oldest_at = now;
@@ -4605,6 +4611,7 @@ void mem_cgroup_track_foreign_dirty_slow
 		frn->memcg_id = wb->memcg_css->id;
 		frn->at = now;
 	}
+	css_put(&memcg->css);
 }
 
 /* issue foreign writeback flushes for recorded foreign dirtying events */
@@ -6167,6 +6174,14 @@ retry:
 	atomic_dec(&mc.from->moving_account);
 }
 
+/*
+ * The cgroup migration and memory cgroup offlining are serialized by
+ * @cgroup_mutex. If we reach here, it means that the LRU pages cannot
+ * be reparented to its parent memory cgroup. So during the whole process
+ * of mem_cgroup_move_task(), page_memcg(page) is stable. So we do not
+ * need to worry about the memcg (returned from page_memcg()) being
+ * released even if we do not hold an rcu read lock.
+ */
 static void mem_cgroup_move_task(void)
 {
 	if (mc.to) {
@@ -7025,7 +7040,7 @@ void mem_cgroup_migrate(struct folio *ol
 	if (folio_memcg(new))
 		return;
 
-	memcg = folio_memcg(old);
+	memcg = get_mem_cgroup_from_folio(old);
 	VM_WARN_ON_ONCE_FOLIO(!memcg, old);
 	if (!memcg)
 		return;
@@ -7044,6 +7059,8 @@ void mem_cgroup_migrate(struct folio *ol
 	mem_cgroup_charge_statistics(memcg, nr_pages);
 	memcg_check_events(memcg, folio_nid(new));
 	local_irq_restore(flags);
+
+	css_put(&memcg->css);
 }
 
 DEFINE_STATIC_KEY_FALSE(memcg_sockets_enabled_key);
@@ -7228,6 +7245,10 @@ void mem_cgroup_swapout(struct folio *fo
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
+	/*
+	 * Interrupts should be disabled by the caller (see the comments below),
+	 * which can serve as RCU read-side critical sections.
+	 */
 	memcg = folio_memcg(folio);
 
 	VM_WARN_ON_ONCE_FOLIO(!memcg, folio);
@@ -7289,19 +7310,21 @@ int __mem_cgroup_try_charge_swap(struct
 	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	unsigned short oldid;
+	int ret = 0;
 
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return 0;
 
+	rcu_read_lock();
 	memcg = folio_memcg(folio);
 
 	VM_WARN_ON_ONCE_FOLIO(!memcg, folio);
 	if (!memcg)
-		return 0;
+		goto out;
 
 	if (!entry.val) {
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		return 0;
+		goto out;
 	}
 
 	memcg = mem_cgroup_id_get_online(memcg);
@@ -7311,7 +7334,8 @@ int __mem_cgroup_try_charge_swap(struct
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		mem_cgroup_id_put(memcg);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	/* Get references for the tail pages, too */
@@ -7320,8 +7344,10 @@ int __mem_cgroup_try_charge_swap(struct
 	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg), nr_pages);
 	VM_BUG_ON_FOLIO(oldid, folio);
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
+out:
+	rcu_read_unlock();
 
-	return 0;
+	return ret;
 }
 
 /**
@@ -7366,6 +7392,7 @@ long mem_cgroup_get_nr_swap_pages(struct
 bool mem_cgroup_swap_full(struct page *page)
 {
 	struct mem_cgroup *memcg;
+	bool ret = false;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
@@ -7374,19 +7401,24 @@ bool mem_cgroup_swap_full(struct page *p
 	if (cgroup_memory_noswap || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return false;
 
+	rcu_read_lock();
 	memcg = page_memcg(page);
 	if (!memcg)
-		return false;
+		goto out;
 
 	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg)) {
 		unsigned long usage = page_counter_read(&memcg->swap);
 
 		if (usage * 2 >= READ_ONCE(memcg->swap.high) ||
-		    usage * 2 >= READ_ONCE(memcg->swap.max))
-			return true;
+		    usage * 2 >= READ_ONCE(memcg->swap.max)) {
+			ret = true;
+			goto out;
+		}
 	}
+out:
+	rcu_read_unlock();
 
-	return false;
+	return ret;
 }
 
 static int __init setup_swap_account(char *s)
--- a/mm/migrate.c~mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe
+++ a/mm/migrate.c
@@ -451,6 +451,10 @@ int folio_migrate_mapping(struct address
 		struct lruvec *old_lruvec, *new_lruvec;
 		struct mem_cgroup *memcg;
 
+		/*
+		 * Irq is disabled, which can serve as RCU read-side critical
+		 * sections.
+		 */
 		memcg = folio_memcg(folio);
 		old_lruvec = mem_cgroup_lruvec(memcg, oldzone->zone_pgdat);
 		new_lruvec = mem_cgroup_lruvec(memcg, newzone->zone_pgdat);
--- a/mm/page_io.c~mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe
+++ a/mm/page_io.c
@@ -222,13 +222,14 @@ static void bio_associate_blkg_from_page
 	struct cgroup_subsys_state *css;
 	struct mem_cgroup *memcg;
 
+	rcu_read_lock();
 	memcg = page_memcg(page);
 	if (!memcg)
-		return;
+		goto out;
 
-	rcu_read_lock();
 	css = cgroup_e_css(memcg->css.cgroup, &io_cgrp_subsys);
 	bio_associate_blkg_from_css(bio, css);
+out:
 	rcu_read_unlock();
 }
 #else
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

