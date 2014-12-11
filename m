From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-shorten-the-page-statistics-update-slowpath.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 10:57:25 -0800
Message-ID: <5489e915.wvKLbRgJt5RfVQET%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbaLKS50 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: shorten the page statistics update slowpath
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-shorten-the-page-statistics-update-slowpath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: shorten the page statistics update slowpath

While moving charges from one memcg to another, page stat updates must
acquire the old memcg's move_lock to prevent double accounting.  That
situation is denoted by an increased memcg->move_accounting.  However, the
charge moving code declares this way too early for now, even before
summing up the RSS and pre-allocating destination charges.

Shorten this slowpath mode by increasing memcg->move_accounting only right
before walking the task's address space with the intention of actually
moving the pages.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-shorten-the-page-statistics-update-slowpath mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-shorten-the-page-statistics-update-slowpath
+++ a/mm/memcontrol.c
@@ -5333,8 +5333,6 @@ static void __mem_cgroup_clear_mc(void)
 
 static void mem_cgroup_clear_mc(void)
 {
-	struct mem_cgroup *from = mc.from;
-
 	/*
 	 * we must clear moving_task before waking up waiters at the end of
 	 * task migration.
@@ -5345,8 +5343,6 @@ static void mem_cgroup_clear_mc(void)
 	mc.from = NULL;
 	mc.to = NULL;
 	spin_unlock(&mc.lock);
-
-	atomic_dec(&from->moving_account);
 }
 
 static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
@@ -5380,15 +5376,6 @@ static int mem_cgroup_can_attach(struct
 			VM_BUG_ON(mc.moved_charge);
 			VM_BUG_ON(mc.moved_swap);
 
-			/*
-			 * Signal mem_cgroup_begin_page_stat() to take
-			 * the memcg's move_lock while we're moving
-			 * its pages to another memcg.  Then wait for
-			 * already started RCU-only updates to finish.
-			 */
-			atomic_inc(&from->moving_account);
-			synchronize_rcu();
-
 			spin_lock(&mc.lock);
 			mc.from = from;
 			mc.to = memcg;
@@ -5520,6 +5507,13 @@ static void mem_cgroup_move_charge(struc
 	struct vm_area_struct *vma;
 
 	lru_add_drain_all();
+	/*
+	 * Signal mem_cgroup_begin_page_stat() to take the memcg's
+	 * move_lock while we're moving its pages to another memcg.
+	 * Then wait for already started RCU-only updates to finish.
+	 */
+	atomic_inc(&mc.from->moving_account);
+	synchronize_rcu();
 retry:
 	if (unlikely(!down_read_trylock(&mm->mmap_sem))) {
 		/*
@@ -5552,6 +5546,7 @@ retry:
 			break;
 	}
 	up_read(&mm->mmap_sem);
+	atomic_dec(&mc.from->moving_account);
 }
 
 static void mem_cgroup_move_task(struct cgroup_subsys_state *css,
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

