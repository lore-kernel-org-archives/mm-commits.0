From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-inline-memcg-move_lock-locking.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:57:10 -0800
Message-ID: <5489e906.7IjLMDg4+skOZw+M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338AbaLKS5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: inline memcg->move_lock locking
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-inline-memcg-move_lock-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: inline memcg->move_lock locking

The wrappers around taking and dropping the memcg->move_lock spinlock add
nothing of value.  Inline the spinlock calls into the callsites.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-inline-memcg-move_lock-locking mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-inline-memcg-move_lock-locking
+++ a/mm/memcontrol.c
@@ -1522,23 +1522,6 @@ static bool mem_cgroup_wait_acct_move(st
 	return false;
 }
 
-/*
- * Take this lock when
- * - a code tries to modify page's memcg while it's USED.
- * - a code tries to modify page state accounting in a memcg.
- */
-static void move_lock_mem_cgroup(struct mem_cgroup *memcg,
-				  unsigned long *flags)
-{
-	spin_lock_irqsave(&memcg->move_lock, *flags);
-}
-
-static void move_unlock_mem_cgroup(struct mem_cgroup *memcg,
-				unsigned long *flags)
-{
-	spin_unlock_irqrestore(&memcg->move_lock, *flags);
-}
-
 #define K(x) ((x) << (PAGE_SHIFT-10))
 /**
  * mem_cgroup_print_oom_info: Print OOM information relevant to memory controller.
@@ -2156,9 +2139,9 @@ again:
 	if (atomic_read(&memcg->moving_account) <= 0)
 		return memcg;
 
-	move_lock_mem_cgroup(memcg, flags);
+	spin_lock_irqsave(&memcg->move_lock, *flags);
 	if (memcg != pc->mem_cgroup) {
-		move_unlock_mem_cgroup(memcg, flags);
+		spin_unlock_irqrestore(&memcg->move_lock, *flags);
 		goto again;
 	}
 	*locked = true;
@@ -2176,7 +2159,7 @@ void mem_cgroup_end_page_stat(struct mem
 			      unsigned long flags)
 {
 	if (memcg && locked)
-		move_unlock_mem_cgroup(memcg, &flags);
+		spin_unlock_irqrestore(&memcg->move_lock, flags);
 
 	rcu_read_unlock();
 }
@@ -3219,7 +3202,7 @@ static int mem_cgroup_move_account(struc
 	if (pc->mem_cgroup != from)
 		goto out_unlock;
 
-	move_lock_mem_cgroup(from, &flags);
+	spin_lock_irqsave(&from->move_lock, flags);
 
 	if (!PageAnon(page) && page_mapped(page)) {
 		__this_cpu_sub(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED],
@@ -3243,7 +3226,8 @@ static int mem_cgroup_move_account(struc
 
 	/* caller should have done css_get */
 	pc->mem_cgroup = to;
-	move_unlock_mem_cgroup(from, &flags);
+	spin_unlock_irqrestore(&from->move_lock, flags);
+
 	ret = 0;
 
 	local_irq_disable();
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-mincore-add-hwpoison-page-handle.patch
memcg-zap-kmem_account_flags.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
mm-move-swp_entry_t-definition-to-include-linux-mm_typesh.patch
mm-gfp-escalatedly-define-gfp_highuser-and-gfp_highuser_movable.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging-fix.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone-fix.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch
memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch
mm-memcontrolc-cleaning-up-function-that-are-not-used-anywhere.patch

