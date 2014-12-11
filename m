From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:57:29 -0800
Message-ID: <5489e919.nxYHi3XCahe90s3r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758125AbaLKS5a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: pull the NULL check from __mem_cgroup_same_or_subtree()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: pull the NULL check from __mem_cgroup_same_or_subtree()

The NULL in mm_match_cgroup() comes from a possibly exiting mm->owner.  It
makes a lot more sense to check where it's looked up, rather than check
for it in __mem_cgroup_same_or_subtree() where it's unexpected.

No other callsite passes NULL to __mem_cgroup_same_or_subtree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +++--
 mm/memcontrol.c            |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree
+++ a/include/linux/memcontrol.h
@@ -83,11 +83,12 @@ static inline
 bool mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *task_memcg;
-	bool match;
+	bool match = false;
 
 	rcu_read_lock();
 	task_memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
-	match = __mem_cgroup_same_or_subtree(memcg, task_memcg);
+	if (task_memcg)
+		match = __mem_cgroup_same_or_subtree(memcg, task_memcg);
 	rcu_read_unlock();
 	return match;
 }
diff -puN mm/memcontrol.c~mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree
+++ a/mm/memcontrol.c
@@ -1337,7 +1337,7 @@ bool __mem_cgroup_same_or_subtree(const
 {
 	if (root_memcg == memcg)
 		return true;
-	if (!root_memcg->use_hierarchy || !memcg)
+	if (!root_memcg->use_hierarchy)
 		return false;
 	return cgroup_is_descendant(memcg->css.cgroup, root_memcg->css.cgroup);
 }
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

