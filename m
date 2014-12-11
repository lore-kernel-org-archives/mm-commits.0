From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 10:57:14 -0800
Message-ID: <5489e90a.e0Kwf8KXnHDKgTuf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbaLKS5P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fold mem_cgroup_start_move()/mem_cgroup_end_move()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: fold mem_cgroup_start_move()/mem_cgroup_end_move()

Having these functions and their documentation split out and somewhere
makes it harder, not easier, to follow what's going on.

Inline them directly where charge moving is prepared and finished, and put
an explanation right next to it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   40 ++++++++++++----------------------------
 1 file changed, 12 insertions(+), 28 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move
+++ a/mm/memcontrol.c
@@ -1447,32 +1447,6 @@ int mem_cgroup_swappiness(struct mem_cgr
 }
 
 /*
- * memcg->moving_account is used for checking possibility that some thread is
- * calling move_account(). When a thread on CPU-A starts moving pages under
- * a memcg, other threads should check memcg->moving_account under
- * rcu_read_lock(), like this:
- *
- *         CPU-A                                    CPU-B
- *                                              rcu_read_lock()
- *         memcg->moving_account+1              if (memcg->mocing_account)
- *                                                   take heavy locks.
- *         synchronize_rcu()                    update something.
- *                                              rcu_read_unlock()
- *         start move here.
- */
-
-static void mem_cgroup_start_move(struct mem_cgroup *memcg)
-{
-	atomic_inc(&memcg->moving_account);
-	synchronize_rcu();
-}
-
-static void mem_cgroup_end_move(struct mem_cgroup *memcg)
-{
-	atomic_dec(&memcg->moving_account);
-}
-
-/*
  * A routine for checking "mem" is under move_account() or not.
  *
  * Checking a cgroup is mc.from or mc.to or under hierarchy of
@@ -5431,7 +5405,8 @@ static void mem_cgroup_clear_mc(void)
 	mc.from = NULL;
 	mc.to = NULL;
 	spin_unlock(&mc.lock);
-	mem_cgroup_end_move(from);
+
+	atomic_dec(&from->moving_account);
 }
 
 static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
@@ -5464,7 +5439,16 @@ static int mem_cgroup_can_attach(struct
 			VM_BUG_ON(mc.precharge);
 			VM_BUG_ON(mc.moved_charge);
 			VM_BUG_ON(mc.moved_swap);
-			mem_cgroup_start_move(from);
+
+			/*
+			 * Signal mem_cgroup_begin_page_stat() to take
+			 * the memcg's move_lock while we're moving
+			 * its pages to another memcg.  Then wait for
+			 * already started RCU-only updates to finish.
+			 */
+			atomic_inc(&from->moving_account);
+			synchronize_rcu();
+
 			spin_lock(&mc.lock);
 			mc.from = from;
 			mc.to = memcg;
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

