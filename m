From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-remove-bogus-null-check-after-mem_cgroup_from_task.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:57:27 -0800
Message-ID: <5489e917.BedSLUtZzq1TQ2EJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758125AbaLKS52 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove bogus NULL check after mem_cgroup_from_task()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-bogus-null-check-after-mem_cgroup_from_task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: remove bogus NULL check after mem_cgroup_from_task()

That function acts like a typecast - unless NULL is passed in, no NULL can
come out.  task_in_mem_cgroup() callers don't pass NULL tasks.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-remove-bogus-null-check-after-mem_cgroup_from_task mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-remove-bogus-null-check-after-mem_cgroup_from_task
+++ a/mm/memcontrol.c
@@ -1356,7 +1356,7 @@ static bool mem_cgroup_same_or_subtree(c
 bool task_in_mem_cgroup(struct task_struct *task,
 			const struct mem_cgroup *memcg)
 {
-	struct mem_cgroup *curr = NULL;
+	struct mem_cgroup *curr;
 	struct task_struct *p;
 	bool ret;
 
@@ -1372,8 +1372,7 @@ bool task_in_mem_cgroup(struct task_stru
 		 */
 		rcu_read_lock();
 		curr = mem_cgroup_from_task(task);
-		if (curr)
-			css_get(&curr->css);
+		css_get(&curr->css);
 		rcu_read_unlock();
 	}
 	/*
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

