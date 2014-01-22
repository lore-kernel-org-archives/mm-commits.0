From: akpm@linux-foundation.org
Subject: [merged] memcg-oom-lock-mem_cgroup_print_oom_info.patch removed
 from -mm tree
Date: Wed, 22 Jan 2014 12:14:48 -0800
Message-ID: <52e026b8.qeJu9xJz6S29y1ro%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaAVUOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:14:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, mhocko@suse.cz

Subject: [merged] memcg-oom-lock-mem_cgroup_print_oom_info.patch removed from -mm tree
To: mhocko@suse.cz,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:14:48 -0800


The patch titled
     Subject: memcg, oom: lock mem_cgroup_print_oom_info
has been removed from the -mm tree.  Its filename was
     memcg-oom-lock-mem_cgroup_print_oom_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg, oom: lock mem_cgroup_print_oom_info

mem_cgroup_print_oom_info uses a static buffer (memcg_name) to store the
name of the cgroup.  This is not safe as pointed out by David Rientjes
because memcg oom is locked only for its hierarchy and nothing prevents
another parallel hierarchy to trigger oom as well and overwrite the
already in-use buffer.

This patch introduces oom_info_lock hidden inside
mem_cgroup_print_oom_info which is held throughout the function.  It makes
access to memcg_name safe and as a bonus it also prevents parallel memcg
ooms to interleave their statistics which would make the printed data hard
to analyze otherwise.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-oom-lock-mem_cgroup_print_oom_info mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-oom-lock-mem_cgroup_print_oom_info
+++ a/mm/memcontrol.c
@@ -1647,13 +1647,13 @@ static void move_unlock_mem_cgroup(struc
  */
 void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 {
-	struct cgroup *task_cgrp;
-	struct cgroup *mem_cgrp;
 	/*
-	 * Need a buffer in BSS, can't rely on allocations. The code relies
-	 * on the assumption that OOM is serialized for memory controller.
-	 * If this assumption is broken, revisit this code.
+	 * protects memcg_name and makes sure that parallel ooms do not
+	 * interleave
 	 */
+	static DEFINE_SPINLOCK(oom_info_lock);
+	struct cgroup *task_cgrp;
+	struct cgroup *mem_cgrp;
 	static char memcg_name[PATH_MAX];
 	int ret;
 	struct mem_cgroup *iter;
@@ -1662,6 +1662,7 @@ void mem_cgroup_print_oom_info(struct me
 	if (!p)
 		return;
 
+	spin_lock(&oom_info_lock);
 	rcu_read_lock();
 
 	mem_cgrp = memcg->css.cgroup;
@@ -1730,6 +1731,7 @@ done:
 
 		pr_cont("\n");
 	}
+	spin_unlock(&oom_info_lock);
 }
 
 /*
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
memcg-do-not-use-vmalloc-for-mem_cgroup-allocations.patch
slab-clean-up-kmem_cache_create_memcg-error-handling.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch
memcg-slab-clean-up-memcg-cache-initialization-destruction.patch
memcg-slab-fix-barrier-usage-when-accessing-memcg_caches.patch
memcg-fix-possible-null-deref-while-traversing-memcg_slab_caches-list.patch
memcg-slab-fix-races-in-per-memcg-cache-creation-destruction.patch
memcg-get-rid-of-kmem_cache_dup.patch
slab-do-not-panic-if-we-fail-to-create-memcg-cache.patch
memcg-slab-rcu-protect-memcg_params-for-root-caches.patch
memcg-remove-kmem_accounted_activated-flag.patch
memcg-rework-memcg_update_kmem_limit-synchronization.patch
mm-new_vma_page-cannot-see-null-vma-for-hugetlb-pages.patch
mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-vmscan-shrink-all-slab-objects-if-tight-on-memory.patch
mm-vmscan-call-numa-unaware-shrinkers-irrespective-of-nodemask.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-show-message-when-updating-min_free_kbytes-in-thp.patch
mm-memcg-fix-last_dead_count-memory-wastage.patch
mm-memcg-iteration-skip-memcgs-not-yet-fully-initialized.patch
mm-oom-prefer-thread-group-leaders-for-display-purposes.patch
mm-oom-prefer-thread-group-leaders-for-display-purposes-fix.patch
memcg-fix-endless-loop-caused-by-mem_cgroup_iter.patch
memcg-fix-css-reference-leak-and-endless-loop-in-mem_cgroup_iter.patch
memcg-remove-unused-code-from-kmem_cache_destroy_work_func.patch
proc-fix-the-potential-use-after-free-in-first_tid.patch
proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread.patch
proc-dont-abuse-group_leader-in-proc_task_readdir-paths.patch
proc-fix-f_pos-overflows-in-first_tid.patch
linux-next.patch

