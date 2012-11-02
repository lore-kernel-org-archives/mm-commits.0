From: akpm@linux-foundation.org
Subject: + memcg-kmem-controller-infrastructure.patch added to -mm tree
Date: Thu, 01 Nov 2012 17:03:18 -0700
Message-ID: <20121102000318.D41285C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:41242 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759292Ab2KBADY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2012 20:03:24 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so194521eek.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Nov 2012 17:03:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org


The patch titled
     Subject: memcg: kmem controller infrastructure
has been added to the -mm tree.  Its filename is
     memcg-kmem-controller-infrastructure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: kmem controller infrastructure

Introduce infrastructure for tracking kernel memory pages to a given
memcg.  This will happen whenever the caller includes the flag
__GFP_KMEMCG flag, and the task belong to a memcg other than the root.

In memcontrol.h those functions are wrapped in inline acessors.  The idea
is to later on, patch those with static branches, so we don't incur any
overhead when no mem cgroups with limited kmem are being used.

Users of this functionality shall interact with the memcg core code
through the following functions:

memcg_kmem_newpage_charge: will return true if the group can handle the
                           allocation. At this point, struct page is not
                           yet allocated.

memcg_kmem_commit_charge: will either revert the charge, if struct page
                          allocation failed, or embed memcg information
                          into page_cgroup.

memcg_kmem_uncharge_page: called at free time, will revert the charge.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: JoonSoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |  110 ++++++++++++++++++++++
 mm/memcontrol.c            |  170 +++++++++++++++++++++++++++++++++++
 2 files changed, 280 insertions(+)

diff -puN include/linux/memcontrol.h~memcg-kmem-controller-infrastructure include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-kmem-controller-infrastructure
+++ a/include/linux/memcontrol.h
@@ -21,6 +21,7 @@
 #define _LINUX_MEMCONTROL_H
 #include <linux/cgroup.h>
 #include <linux/vm_event_item.h>
+#include <linux/hardirq.h>
 
 struct mem_cgroup;
 struct page_cgroup;
@@ -407,5 +408,114 @@ static inline void sock_release_memcg(st
 {
 }
 #endif /* CONFIG_INET && CONFIG_MEMCG_KMEM */
+
+#ifdef CONFIG_MEMCG_KMEM
+static inline bool memcg_kmem_enabled(void)
+{
+	return true;
+}
+
+/*
+ * In general, we'll do everything in our power to not incur in any overhead
+ * for non-memcg users for the kmem functions. Not even a function call, if we
+ * can avoid it.
+ *
+ * Therefore, we'll inline all those functions so that in the best case, we'll
+ * see that kmemcg is off for everybody and proceed quickly.  If it is on,
+ * we'll still do most of the flag checking inline. We check a lot of
+ * conditions, but because they are pretty simple, they are expected to be
+ * fast.
+ */
+bool __memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg,
+					int order);
+void __memcg_kmem_commit_charge(struct page *page,
+				       struct mem_cgroup *memcg, int order);
+void __memcg_kmem_uncharge_pages(struct page *page, int order);
+
+/**
+ * memcg_kmem_newpage_charge: verify if a new kmem allocation is allowed.
+ * @gfp: the gfp allocation flags.
+ * @memcg: a pointer to the memcg this was charged against.
+ * @order: allocation order.
+ *
+ * returns true if the memcg where the current task belongs can hold this
+ * allocation.
+ *
+ * We return true automatically if this allocation is not to be accounted to
+ * any memcg.
+ */
+static __always_inline bool
+memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg, int order)
+{
+	if (!memcg_kmem_enabled())
+		return true;
+
+	/*
+	 * __GFP_NOFAIL allocations will move on even if charging is not
+	 * possible. Therefore we don't even try, and have this allocation
+	 * unaccounted. We could in theory charge it with
+	 * res_counter_charge_nofail, but we hope those allocations are rare,
+	 * and won't be worth the trouble.
+	 */
+	if (!(gfp & __GFP_KMEMCG) || (gfp & __GFP_NOFAIL))
+		return true;
+	if (in_interrupt() || (!current->mm) || (current->flags & PF_KTHREAD))
+		return true;
+
+	/* If the test is dying, just let it go. */
+	if (unlikely(fatal_signal_pending(current)))
+		return true;
+
+	return __memcg_kmem_newpage_charge(gfp, memcg, order);
+}
+
+/**
+ * memcg_kmem_uncharge_pages: uncharge pages from memcg
+ * @page: pointer to struct page being freed
+ * @order: allocation order.
+ *
+ * there is no need to specify memcg here, since it is embedded in page_cgroup
+ */
+static __always_inline void
+memcg_kmem_uncharge_pages(struct page *page, int order)
+{
+	if (memcg_kmem_enabled())
+		__memcg_kmem_uncharge_pages(page, order);
+}
+
+/**
+ * memcg_kmem_commit_charge: embeds correct memcg in a page
+ * @page: pointer to struct page recently allocated
+ * @memcg: the memcg structure we charged against
+ * @order: allocation order.
+ *
+ * Needs to be called after memcg_kmem_newpage_charge, regardless of success or
+ * failure of the allocation. if @page is NULL, this function will revert the
+ * charges. Otherwise, it will commit the memcg given by @memcg to the
+ * corresponding page_cgroup.
+ */
+static __always_inline void
+memcg_kmem_commit_charge(struct page *page, struct mem_cgroup *memcg, int order)
+{
+	if (memcg_kmem_enabled() && memcg)
+		__memcg_kmem_commit_charge(page, memcg, order);
+}
+
+#else
+static inline bool
+memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg, int order)
+{
+	return true;
+}
+
+static inline void memcg_kmem_uncharge_pages(struct page *page, int order)
+{
+}
+
+static inline void
+memcg_kmem_commit_charge(struct page *page, struct mem_cgroup *memcg, int order)
+{
+}
+#endif /* CONFIG_MEMCG_KMEM */
 #endif /* _LINUX_MEMCONTROL_H */
 
diff -puN mm/memcontrol.c~memcg-kmem-controller-infrastructure mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-kmem-controller-infrastructure
+++ a/mm/memcontrol.c
@@ -10,6 +10,10 @@
  * Copyright (C) 2009 Nokia Corporation
  * Author: Kirill A. Shutemov
  *
+ * Kernel Memory Controller
+ * Copyright (C) 2012 Parallels Inc. and Google Inc.
+ * Authors: Glauber Costa and Suleiman Souhlal
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -2630,6 +2634,172 @@ static void __mem_cgroup_commit_charge(s
 	memcg_check_events(memcg, page);
 }
 
+#ifdef CONFIG_MEMCG_KMEM
+static inline bool memcg_can_account_kmem(struct mem_cgroup *memcg)
+{
+	return !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg) &&
+		(memcg->kmem_account_flags & KMEM_ACCOUNTED_MASK);
+}
+
+static int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, u64 size)
+{
+	struct res_counter *fail_res;
+	struct mem_cgroup *_memcg;
+	int ret = 0;
+	bool may_oom;
+
+	ret = res_counter_charge(&memcg->kmem, size, &fail_res);
+	if (ret)
+		return ret;
+
+	/*
+	 * Conditions under which we can wait for the oom_killer. Those are
+	 * the same conditions tested by the core page allocator
+	 */
+	may_oom = (gfp & __GFP_FS) && !(gfp & __GFP_NORETRY);
+
+	_memcg = memcg;
+	ret = __mem_cgroup_try_charge(NULL, gfp, size >> PAGE_SHIFT,
+				      &_memcg, may_oom);
+
+	if (ret == -EINTR)  {
+		/*
+		 * __mem_cgroup_try_charge() chosed to bypass to root due to
+		 * OOM kill or fatal signal.  Since our only options are to
+		 * either fail the allocation or charge it to this cgroup, do
+		 * it as a temporary condition. But we can't fail. From a
+		 * kmem/slab perspective, the cache has already been selected,
+		 * by mem_cgroup_kmem_get_cache(), so it is too late to change
+		 * our minds.
+		 *
+		 * This condition will only trigger if the task entered
+		 * memcg_charge_kmem in a sane state, but was OOM-killed during
+		 * __mem_cgroup_try_charge() above. Tasks that were already
+		 * dying when the allocation triggers should have been already
+		 * directed to the root cgroup in memcontrol.h
+		 */
+		res_counter_charge_nofail(&memcg->res, size, &fail_res);
+		if (do_swap_account)
+			res_counter_charge_nofail(&memcg->memsw, size,
+						  &fail_res);
+		ret = 0;
+	} else if (ret)
+		res_counter_uncharge(&memcg->kmem, size);
+
+	return ret;
+}
+
+static void memcg_uncharge_kmem(struct mem_cgroup *memcg, u64 size)
+{
+	res_counter_uncharge(&memcg->kmem, size);
+	res_counter_uncharge(&memcg->res, size);
+	if (do_swap_account)
+		res_counter_uncharge(&memcg->memsw, size);
+}
+
+/*
+ * We need to verify if the allocation against current->mm->owner's memcg is
+ * possible for the given order. But the page is not allocated yet, so we'll
+ * need a further commit step to do the final arrangements.
+ *
+ * It is possible for the task to switch cgroups in this mean time, so at
+ * commit time, we can't rely on task conversion any longer.  We'll then use
+ * the handle argument to return to the caller which cgroup we should commit
+ * against. We could also return the memcg directly and avoid the pointer
+ * passing, but a boolean return value gives better semantics considering
+ * the compiled-out case as well.
+ *
+ * Returning true means the allocation is possible.
+ */
+bool
+__memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **_memcg, int order)
+{
+	struct mem_cgroup *memcg;
+	int ret;
+
+	*_memcg = NULL;
+	memcg = try_get_mem_cgroup_from_mm(current->mm);
+
+	/*
+	 * very rare case described in mem_cgroup_from_task. Unfortunately there
+	 * isn't much we can do without complicating this too much, and it would
+	 * be gfp-dependent anyway. Just let it go
+	 */
+	if (unlikely(!memcg))
+		return true;
+
+	if (!memcg_can_account_kmem(memcg)) {
+		css_put(&memcg->css);
+		return true;
+	}
+
+	mem_cgroup_get(memcg);
+
+	ret = memcg_charge_kmem(memcg, gfp, PAGE_SIZE << order);
+	if (!ret)
+		*_memcg = memcg;
+	else
+		mem_cgroup_put(memcg);
+
+	css_put(&memcg->css);
+	return (ret == 0);
+}
+
+void __memcg_kmem_commit_charge(struct page *page, struct mem_cgroup *memcg,
+			      int order)
+{
+	struct page_cgroup *pc;
+
+	VM_BUG_ON(mem_cgroup_is_root(memcg));
+
+	/* The page allocation failed. Revert */
+	if (!page) {
+		memcg_uncharge_kmem(memcg, PAGE_SIZE << order);
+		mem_cgroup_put(memcg);
+		return;
+	}
+
+	pc = lookup_page_cgroup(page);
+	lock_page_cgroup(pc);
+	pc->mem_cgroup = memcg;
+	SetPageCgroupUsed(pc);
+	unlock_page_cgroup(pc);
+}
+
+void __memcg_kmem_uncharge_pages(struct page *page, int order)
+{
+	struct mem_cgroup *memcg = NULL;
+	struct page_cgroup *pc;
+
+
+	pc = lookup_page_cgroup(page);
+	/*
+	 * Fast unlocked return. Theoretically might have changed, have to
+	 * check again after locking.
+	 */
+	if (!PageCgroupUsed(pc))
+		return;
+
+	lock_page_cgroup(pc);
+	if (PageCgroupUsed(pc)) {
+		memcg = pc->mem_cgroup;
+		ClearPageCgroupUsed(pc);
+	}
+	unlock_page_cgroup(pc);
+
+	/*
+	 * We trust that only if there is a memcg associated with the page, it
+	 * is a valid allocation
+	 */
+	if (!memcg)
+		return;
+
+	VM_BUG_ON(mem_cgroup_is_root(memcg));
+	memcg_uncharge_kmem(memcg, PAGE_SIZE << order);
+	mem_cgroup_put(memcg);
+}
+#endif /* CONFIG_MEMCG_KMEM */
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
 #define PCGF_NOCOPY_AT_SPLIT (1 << PCG_LOCK | 1 << PCG_MIGRATION)
_

Patches currently in -mm which might be from glommer@parallels.com are

linux-next.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch

