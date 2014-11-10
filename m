From: akpm@linux-foundation.org
Subject: [withdrawn]
 memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch removed from -mm
 tree
Date: Mon, 10 Nov 2014 14:17:04 -0800
Message-ID: <54613960.nAKllDYD7efGFWjz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaKJWRD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Nov 2014 17:17:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: turn memcg_kmem_skip_account into a bit field
has been removed from the -mm tree.  Its filename was
     memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: turn memcg_kmem_skip_account into a bit field

It isn't supposed to stack, so turn it into a bit-field to save 4 bytes on
the task_struct.

Also, remove the memcg_stop/resume_kmem_account helpers - it is clearer to
set/clear the flag inline.  Regarding the overwhelming comment to the
helpers, which is removed by this patch too, we already have a compact yet
accurate explanation in memcg_schedule_cache_create, no need in yet
another one.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    7 +++++--
 mm/memcontrol.c       |   35 ++---------------------------------
 2 files changed, 7 insertions(+), 35 deletions(-)

diff -puN include/linux/sched.h~memcg-turn-memcg_kmem_skip_account-into-a-bit-field include/linux/sched.h
--- a/include/linux/sched.h~memcg-turn-memcg_kmem_skip_account-into-a-bit-field
+++ a/include/linux/sched.h
@@ -1325,6 +1325,10 @@ struct task_struct {
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
 
+#ifdef CONFIG_MEMCG_KMEM
+	unsigned memcg_kmem_skip_account:1;
+#endif
+
 	unsigned long atomic_flags; /* Flags needing atomic access. */
 
 	pid_t pid;
@@ -1645,8 +1649,7 @@ struct task_struct {
 	/* bitmask and counter of trace recursion */
 	unsigned long trace_recursion;
 #endif /* CONFIG_TRACING */
-#ifdef CONFIG_MEMCG /* memcg uses this to do batch job */
-	unsigned int memcg_kmem_skip_account;
+#ifdef CONFIG_MEMCG
 	struct memcg_oom_info {
 		struct mem_cgroup *memcg;
 		gfp_t gfp_mask;
diff -puN mm/memcontrol.c~memcg-turn-memcg_kmem_skip_account-into-a-bit-field mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-turn-memcg_kmem_skip_account-into-a-bit-field
+++ a/mm/memcontrol.c
@@ -2575,37 +2575,6 @@ void memcg_update_array_size(int num)
 	memcg_limited_groups_array_size = num;
 }
 
-/*
- * During the creation a new cache, we need to disable our accounting mechanism
- * altogether. This is true even if we are not creating, but rather just
- * enqueing new caches to be created.
- *
- * This is because that process will trigger allocations; some visible, like
- * explicit kmallocs to auxiliary data structures, name strings and internal
- * cache structures; some well concealed, like INIT_WORK() that can allocate
- * objects during debug.
- *
- * If any allocation happens during memcg_kmem_get_cache, we will recurse back
- * to it. This may not be a bounded recursion: since the first cache creation
- * failed to complete (waiting on the allocation), we'll just try to create the
- * cache again, failing at the same point.
- *
- * memcg_kmem_get_cache is prepared to abort after seeing a positive count of
- * memcg_kmem_skip_account. So we enclose anything that might allocate memory
- * inside the following two functions.
- */
-static inline void memcg_stop_kmem_account(void)
-{
-	VM_BUG_ON(!current->mm);
-	current->memcg_kmem_skip_account++;
-}
-
-static inline void memcg_resume_kmem_account(void)
-{
-	VM_BUG_ON(!current->mm);
-	current->memcg_kmem_skip_account--;
-}
-
 struct memcg_cache_create_work {
 	struct mem_cgroup *memcg;
 	struct kmem_cache *cachep;
@@ -2660,9 +2629,9 @@ static void memcg_schedule_cache_create(
 	 * this point we can't allow ourselves back into memcg_kmem_get_cache,
 	 * the safest choice is to do it like this, wrapping the whole function.
 	 */
-	memcg_stop_kmem_account();
+	current->memcg_kmem_skip_account = 1;
 	__memcg_schedule_cache_create(memcg, cachep);
-	memcg_resume_kmem_account();
+	current->memcg_kmem_skip_account = 0;
 }
 
 /*
_

Patches currently in -mm which might be from vdavydov@parallels.com are

slab-print-slabinfo-header-in-seq-show.patch
mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
memcg-remove-activate_kmem_mutex.patch
mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-uncharge-pages-on-swapout-fix.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-inline-memcg-move_lock-locking.patch
mm-memcontrol-dont-pass-a-null-memcg-to-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-memcontrol-shorten-the-page-statistics-update-slowpath.patch
mm-memcontrol-remove-bogus-null-check-after-mem_cgroup_from_task.patch
mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree.patch
mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
linux-next.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch

