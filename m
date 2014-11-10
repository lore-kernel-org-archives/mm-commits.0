From: akpm@linux-foundation.org
Subject: [withdrawn] memcg-zap-kmem_account_flags.patch removed from -mm
 tree
Date: Mon, 10 Nov 2014 14:17:01 -0800
Message-ID: <5461395d.yL3B5tkPN6/cCA/m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaKJWRB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Nov 2014 17:17:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: zap kmem_account_flags
has been removed from the -mm tree.  Its filename was
     memcg-zap-kmem_account_flags.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: zap kmem_account_flags

The only such flag is KMEM_ACCOUNTED_ACTIVE, but it's set iff
mem_cgroup->kmemcg_id >= 0, so we can check kmemcg_id instead of having a
separate flags field.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff -puN mm/memcontrol.c~memcg-zap-kmem_account_flags mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-zap-kmem_account_flags
+++ a/mm/memcontrol.c
@@ -296,7 +296,6 @@ struct mem_cgroup {
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
 	bool use_hierarchy;
-	unsigned long kmem_account_flags; /* See KMEM_ACCOUNTED_*, below */
 
 	bool		oom_lock;
 	atomic_t	under_oom;
@@ -363,22 +362,11 @@ struct mem_cgroup {
 	/* WARNING: nodeinfo must be the last member here */
 };
 
-/* internal only representation about the status of kmem accounting. */
-enum {
-	KMEM_ACCOUNTED_ACTIVE, /* accounted by this cgroup itself */
-};
-
 #ifdef CONFIG_MEMCG_KMEM
-static inline void memcg_kmem_set_active(struct mem_cgroup *memcg)
-{
-	set_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
-}
-
 static bool memcg_kmem_is_active(struct mem_cgroup *memcg)
 {
-	return test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
+	return memcg->kmemcg_id >= 0;
 }
-
 #endif
 
 /* Stuffs for move charges at task migration. */
@@ -3471,22 +3459,21 @@ static int memcg_activate_kmem(struct me
 		goto out;
 	}
 
-	memcg->kmemcg_id = memcg_id;
-
 	/*
-	 * We couldn't have accounted to this cgroup, because it hasn't got the
-	 * active bit set yet, so this should succeed.
+	 * We couldn't have accounted to this cgroup, because it hasn't got
+	 * activated yet, so this should succeed.
 	 */
 	err = page_counter_limit(&memcg->kmem, nr_pages);
 	VM_BUG_ON(err);
 
 	static_key_slow_inc(&memcg_kmem_enabled_key);
 	/*
-	 * Setting the active bit after enabling static branching will
+	 * A memory cgroup is considered kmem-active as soon as it gets
+	 * kmemcg_id. Setting the id after enabling static branching will
 	 * guarantee no one starts accounting before all call sites are
 	 * patched.
 	 */
-	memcg_kmem_set_active(memcg);
+	memcg->kmemcg_id = memcg_id;
 out:
 	memcg_resume_kmem_account();
 	return err;
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
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
linux-next.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch

