From: akpm@linux-foundation.org
Subject: + cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems.patch added to -mm tree
Date: Tue, 04 May 2010 17:34:32 -0700
Message-ID: <201005050034.o450YW2O028051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933808Ab0EEAfP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 20:35:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miaox@cn.fujitsu.com, andi@firstfloor.org, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, kiran@scalex86.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, menage@google.com, npiggin@suse.de, rientjes@google.com


The patch titled
     cpuset,mm: fix no node to alloc memory when changing cpuset's mems
has been added to the -mm tree.  Its filename is
     cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset,mm: fix no node to alloc memory when changing cpuset's mems
From: Miao Xie <miaox@cn.fujitsu.com>

Before applying this patch, cpuset updates task->mems_allowed and
mempolicy by setting all new bits in the nodemask first, and clearing all
old unallowed bits later.  But in the way, the allocator may find that
there is no node to alloc memory.

The reason is that cpuset rebinds the task's mempolicy, it cleans the
nodes which the allocater can alloc pages on, for example:

(mpol: mempolicy)
	task1			task1's mpol	task2
	alloc page		1
	  alloc on node0? NO	1
				1		change mems from 1 to 0
				1		rebind task1's mpol
				0-1		  set new bits
				0	  	  clear disallowed bits
	  alloc on node1? NO	0
	  ...
	can't alloc page
	  goto oom

This patch fixes this problem by expanding the nodes range first(set newly
allowed bits) and shrink it lazily(clear newly disallowed bits).  So we
use a variable to tell the write-side task that read-side task is reading
nodemask, and the write-side task clears newly disallowed nodes after
read-side task ends the current memory allocation.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Paul Menage <menage@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |   43 ++++++++++++++++++++++++++++
 include/linux/sched.h  |    1 
 kernel/cpuset.c        |   59 +++++++++++++++++++++++++++++++++------
 kernel/exit.c          |    3 +
 kernel/fork.c          |    1 
 mm/filemap.c           |   10 +++++-
 mm/hugetlb.c           |   12 +++++--
 mm/mempolicy.c         |   24 +++++++++++++--
 mm/page_alloc.c        |    6 +++
 mm/slab.c              |    4 ++
 mm/slub.c              |    6 +++
 mm/vmscan.c            |    2 +
 12 files changed, 151 insertions(+), 20 deletions(-)

diff -puN include/linux/cpuset.h~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems include/linux/cpuset.h
--- a/include/linux/cpuset.h~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems
+++ a/include/linux/cpuset.h
@@ -86,9 +86,44 @@ extern void rebuild_sched_domains(void);
 
 extern void cpuset_print_task_mems_allowed(struct task_struct *p);
 
+/*
+ * reading current mems_allowed and mempolicy in the fastpath must protected
+ * by get_mems_allowed()
+ */
+static inline void get_mems_allowed(void)
+{
+	current->mems_allowed_change_disable++;
+
+	/*
+	 * ensure that reading mems_allowed and mempolicy happens after the
+	 * update of ->mems_allowed_change_disable.
+	 *
+	 * the write-side task finds ->mems_allowed_change_disable is not 0,
+	 * and knows the read-side task is reading mems_allowed or mempolicy,
+	 * so it will clear old bits lazily.
+	 */
+	smp_mb();
+}
+
+static inline void put_mems_allowed(void)
+{
+	/*
+	 * ensure that reading mems_allowed and mempolicy before reducing
+	 * mems_allowed_change_disable.
+	 *
+	 * the write-side task will know that the read-side task is still
+	 * reading mems_allowed or mempolicy, don't clears old bits in the
+	 * nodemask.
+	 */
+	smp_mb();
+	--ACCESS_ONCE(current->mems_allowed_change_disable);
+}
+
 static inline void set_mems_allowed(nodemask_t nodemask)
 {
+	task_lock(current);
 	current->mems_allowed = nodemask;
+	task_unlock(current);
 }
 
 #else /* !CONFIG_CPUSETS */
@@ -187,6 +222,14 @@ static inline void set_mems_allowed(node
 {
 }
 
+static inline void get_mems_allowed(void)
+{
+}
+
+static inline void put_mems_allowed(void)
+{
+}
+
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
diff -puN include/linux/sched.h~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems include/linux/sched.h
--- a/include/linux/sched.h~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems
+++ a/include/linux/sched.h
@@ -1422,6 +1422,7 @@ struct task_struct {
 #endif
 #ifdef CONFIG_CPUSETS
 	nodemask_t mems_allowed;	/* Protected by alloc_lock */
+	int mems_allowed_change_disable;
 	int cpuset_mem_spread_rotor;
 #endif
 #ifdef CONFIG_CGROUPS
diff -puN kernel/cpuset.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems kernel/cpuset.c
--- a/kernel/cpuset.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems
+++ a/kernel/cpuset.c
@@ -946,16 +946,63 @@ static void cpuset_migrate_mm(struct mm_
  * In order to avoid seeing no nodes if the old and new nodes are disjoint,
  * we structure updates as setting all new allowed nodes, then clearing newly
  * disallowed ones.
- *
- * Called with task's alloc_lock held
  */
 static void cpuset_change_task_nodemask(struct task_struct *tsk,
 					nodemask_t *newmems)
 {
+repeat:
+	/*
+	 * Allow tasks that have access to memory reserves because they have
+	 * been OOM killed to get memory anywhere.
+	 */
+	if (unlikely(test_thread_flag(TIF_MEMDIE)))
+		return;
+	if (current->flags & PF_EXITING) /* Let dying task have memory */
+		return;
+
+	task_lock(tsk);
 	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
-	mpol_rebind_task(tsk, &tsk->mems_allowed, MPOL_REBIND_ONCE);
-	mpol_rebind_task(tsk, newmems, MPOL_REBIND_ONCE);
+	mpol_rebind_task(tsk, newmems, MPOL_REBIND_STEP1);
+	task_unlock(tsk);
+
+
+	/*
+	 * ensure checking ->mems_allowed_change_disable after setting all new
+	 * allowed nodes.
+	 *
+	 * the read-side task can see an nodemask with new allowed nodes and
+	 * old allowed nodes. and if it allocates page when cpuset clears newly
+	 * disallowed ones continuous, it can see the new allowed bits.
+	 *
+	 * And if setting all new allowed nodes is after the checking, setting
+	 * all new allowed nodes and clearing newly disallowed ones will be done
+	 * continuous, and the read-side task may find no node to alloc page.
+	 */
+	smp_mb();
+
+	/*
+	 * Allocating of memory is very fast, we needn't sleep when waitting
+	 * for the read-side.
+	 */
+	while (ACCESS_ONCE(tsk->mems_allowed_change_disable)) {
+		if (!task_curr(tsk))
+			yield();
+		goto repeat;
+	}
+
+	/*
+	 * ensure checking ->mems_allowed_change_disable before clearing all new
+	 * disallowed nodes.
+	 *
+	 * if clearing newly disallowed bits before the checking, the read-side
+	 * task may find no node to alloc page.
+	 */
+	smp_mb();
+
+	task_lock(tsk);
+	mpol_rebind_task(tsk, newmems, MPOL_REBIND_STEP2);
 	tsk->mems_allowed = *newmems;
+	task_unlock(tsk);
 }
 
 /*
@@ -978,9 +1025,7 @@ static void cpuset_change_nodemask(struc
 	cs = cgroup_cs(scan->cg);
 	guarantee_online_mems(cs, newmems);
 
-	task_lock(p);
 	cpuset_change_task_nodemask(p, newmems);
-	task_unlock(p);
 
 	NODEMASK_FREE(newmems);
 
@@ -1383,9 +1428,7 @@ static void cpuset_attach_task(struct ta
 	err = set_cpus_allowed_ptr(tsk, cpus_attach);
 	WARN_ON_ONCE(err);
 
-	task_lock(tsk);
 	cpuset_change_task_nodemask(tsk, to);
-	task_unlock(tsk);
 	cpuset_update_task_spread_flag(cs, tsk);
 
 }
diff -puN kernel/exit.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems kernel/exit.c
--- a/kernel/exit.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems
+++ a/kernel/exit.c
@@ -16,6 +16,7 @@
 #include <linux/key.h>
 #include <linux/security.h>
 #include <linux/cpu.h>
+#include <linux/cpuset.h>
 #include <linux/acct.h>
 #include <linux/tsacct_kern.h>
 #include <linux/file.h>
@@ -697,8 +698,10 @@ static void exit_mm(struct task_struct *
 	/* We don't want this task to be frozen prematurely */
 	clear_freeze_flag(tsk);
 #ifdef CONFIG_NUMA
+	task_lock(tsk);
 	mpol_put(tsk->mempolicy);
 	tsk->mempolicy = NULL;
+	task_unlock(tsk);
 #endif
 	task_unlock(tsk);
 	mm_update_next_owner(mm);
diff -puN kernel/fork.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems kernel/fork.c
--- a/kernel/fork.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems
+++ a/kernel/fork.c
@@ -31,6 +31,7 @@
 #include <linux/nsproxy.h>
 #include <linux/capability.h>
 #include <linux/cpu.h>
+#include <linux/cpuset.h>
 #include <linux/cgroup.h>
 #include <linux/security.h>
 #include <linux/hugetlb.h>
diff -puN mm/filemap.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems mm/filemap.c
--- a/mm/filemap.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems
+++ a/mm/filemap.c
@@ -461,9 +461,15 @@ EXPORT_SYMBOL_GPL(add_to_page_cache_lru)
 #ifdef CONFIG_NUMA
 struct page *__page_cache_alloc(gfp_t gfp)
 {
+	int n;
+	struct page *page;
+
 	if (cpuset_do_page_mem_spread()) {
-		int n = cpuset_mem_spread_node();
-		return alloc_pages_exact_node(n, gfp, 0);
+		get_mems_allowed();
+		n = cpuset_mem_spread_node();
+		page = alloc_pages_exact_node(n, gfp, 0);
+		put_mems_allowed();
+		return page;
 	}
 	return alloc_pages(gfp, 0);
 }
diff -puN mm/hugetlb.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems mm/hugetlb.c
--- a/mm/hugetlb.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems
+++ a/mm/hugetlb.c
@@ -465,11 +465,13 @@ static struct page *dequeue_huge_page_vm
 	struct page *page = NULL;
 	struct mempolicy *mpol;
 	nodemask_t *nodemask;
-	struct zonelist *zonelist = huge_zonelist(vma, address,
-					htlb_alloc_mask, &mpol, &nodemask);
+	struct zonelist *zonelist;
 	struct zone *zone;
 	struct zoneref *z;
 
+	get_mems_allowed();
+	zonelist = huge_zonelist(vma, address,
+					htlb_alloc_mask, &mpol, &nodemask);
 	/*
 	 * A child process with MAP_PRIVATE mappings created by their parent
 	 * have no page reserves. This check ensures that reservations are
@@ -477,11 +479,11 @@ static struct page *dequeue_huge_page_vm
 	 */
 	if (!vma_has_reserves(vma) &&
 			h->free_huge_pages - h->resv_huge_pages == 0)
-		return NULL;
+		goto err;
 
 	/* If reserves cannot be used, ensure enough pages are in the pool */
 	if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
-		return NULL;
+		goto err;;
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 						MAX_NR_ZONES - 1, nodemask) {
@@ -500,7 +502,9 @@ static struct page *dequeue_huge_page_vm
 			break;
 		}
 	}
+err:
 	mpol_cond_put(mpol);
+	put_mems_allowed();
 	return page;
 }
 
diff -puN mm/mempolicy.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems mm/mempolicy.c
--- a/mm/mempolicy.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems
+++ a/mm/mempolicy.c
@@ -1639,6 +1639,8 @@ static inline unsigned interleave_nid(st
  * to the struct mempolicy for conditional unref after allocation.
  * If the effective policy is 'BIND, returns a pointer to the mempolicy's
  * @nodemask for filtering the zonelist.
+ *
+ * Must be protected by get_mems_allowed()
  */
 struct zonelist *huge_zonelist(struct vm_area_struct *vma, unsigned long addr,
 				gfp_t gfp_flags, struct mempolicy **mpol,
@@ -1684,6 +1686,7 @@ bool init_nodemask_of_mempolicy(nodemask
 	if (!(mask && current->mempolicy))
 		return false;
 
+	task_lock(current);
 	mempolicy = current->mempolicy;
 	switch (mempolicy->mode) {
 	case MPOL_PREFERRED:
@@ -1703,6 +1706,7 @@ bool init_nodemask_of_mempolicy(nodemask
 	default:
 		BUG();
 	}
+	task_unlock(current);
 
 	return true;
 }
@@ -1794,13 +1798,17 @@ alloc_page_vma(gfp_t gfp, struct vm_area
 {
 	struct mempolicy *pol = get_vma_policy(current, vma, addr);
 	struct zonelist *zl;
+	struct page *page;
 
+	get_mems_allowed();
 	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
 		unsigned nid;
 
 		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT);
 		mpol_cond_put(pol);
-		return alloc_page_interleave(gfp, 0, nid);
+		page = alloc_page_interleave(gfp, 0, nid);
+		put_mems_allowed();
+		return page;
 	}
 	zl = policy_zonelist(gfp, pol);
 	if (unlikely(mpol_needs_cond_ref(pol))) {
@@ -1810,12 +1818,15 @@ alloc_page_vma(gfp_t gfp, struct vm_area
 		struct page *page =  __alloc_pages_nodemask(gfp, 0,
 						zl, policy_nodemask(gfp, pol));
 		__mpol_put(pol);
+		put_mems_allowed();
 		return page;
 	}
 	/*
 	 * fast path:  default or task policy
 	 */
-	return __alloc_pages_nodemask(gfp, 0, zl, policy_nodemask(gfp, pol));
+	page = __alloc_pages_nodemask(gfp, 0, zl, policy_nodemask(gfp, pol));
+	put_mems_allowed();
+	return page;
 }
 
 /**
@@ -1840,18 +1851,23 @@ alloc_page_vma(gfp_t gfp, struct vm_area
 struct page *alloc_pages_current(gfp_t gfp, unsigned order)
 {
 	struct mempolicy *pol = current->mempolicy;
+	struct page *page;
 
 	if (!pol || in_interrupt() || (gfp & __GFP_THISNODE))
 		pol = &default_policy;
 
+	get_mems_allowed();
 	/*
 	 * No reference counting needed for current->mempolicy
 	 * nor system default_policy
 	 */
 	if (pol->mode == MPOL_INTERLEAVE)
-		return alloc_page_interleave(gfp, order, interleave_nodes(pol));
-	return __alloc_pages_nodemask(gfp, order,
+		page = alloc_page_interleave(gfp, order, interleave_nodes(pol));
+	else
+		page = __alloc_pages_nodemask(gfp, order,
 			policy_zonelist(gfp, pol), policy_nodemask(gfp, pol));
+	put_mems_allowed();
+	return page;
 }
 EXPORT_SYMBOL(alloc_pages_current);
 
diff -puN mm/page_alloc.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems mm/page_alloc.c
--- a/mm/page_alloc.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems
+++ a/mm/page_alloc.c
@@ -2001,10 +2001,13 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	if (unlikely(!zonelist->_zonerefs->zone))
 		return NULL;
 
+	get_mems_allowed();
 	/* The preferred zone is used for statistics later */
 	first_zones_zonelist(zonelist, high_zoneidx, nodemask, &preferred_zone);
-	if (!preferred_zone)
+	if (!preferred_zone) {
+		put_mems_allowed();
 		return NULL;
+	}
 
 	/* First allocation attempt */
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
@@ -2014,6 +2017,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 		page = __alloc_pages_slowpath(gfp_mask, order,
 				zonelist, high_zoneidx, nodemask,
 				preferred_zone, migratetype);
+	put_mems_allowed();
 
 	trace_mm_page_alloc(page, order, gfp_mask, migratetype);
 	return page;
diff -puN mm/slab.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems mm/slab.c
--- a/mm/slab.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems
+++ a/mm/slab.c
@@ -3241,10 +3241,12 @@ static void *alternate_node_alloc(struct
 	if (in_interrupt() || (flags & __GFP_THISNODE))
 		return NULL;
 	nid_alloc = nid_here = numa_node_id();
+	get_mems_allowed();
 	if (cpuset_do_slab_mem_spread() && (cachep->flags & SLAB_MEM_SPREAD))
 		nid_alloc = cpuset_mem_spread_node();
 	else if (current->mempolicy)
 		nid_alloc = slab_node(current->mempolicy);
+	put_mems_allowed();
 	if (nid_alloc != nid_here)
 		return ____cache_alloc_node(cachep, flags, nid_alloc);
 	return NULL;
@@ -3271,6 +3273,7 @@ static void *fallback_alloc(struct kmem_
 	if (flags & __GFP_THISNODE)
 		return NULL;
 
+	get_mems_allowed();
 	zonelist = node_zonelist(slab_node(current->mempolicy), flags);
 	local_flags = flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
 
@@ -3326,6 +3329,7 @@ retry:
 			}
 		}
 	}
+	put_mems_allowed();
 	return obj;
 }
 
diff -puN mm/slub.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems mm/slub.c
--- a/mm/slub.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems
+++ a/mm/slub.c
@@ -1368,6 +1368,7 @@ static struct page *get_any_partial(stru
 			get_cycles() % 1024 > s->remote_node_defrag_ratio)
 		return NULL;
 
+	get_mems_allowed();
 	zonelist = node_zonelist(slab_node(current->mempolicy), flags);
 	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 		struct kmem_cache_node *n;
@@ -1377,10 +1378,13 @@ static struct page *get_any_partial(stru
 		if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
 				n->nr_partial > s->min_partial) {
 			page = get_partial_node(n);
-			if (page)
+			if (page) {
+				put_mems_allowed();
 				return page;
+			}
 		}
 	}
+	put_mems_allowed();
 #endif
 	return NULL;
 }
diff -puN mm/vmscan.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems mm/vmscan.c
--- a/mm/vmscan.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems
+++ a/mm/vmscan.c
@@ -1774,6 +1774,7 @@ static unsigned long do_try_to_free_page
 	enum zone_type high_zoneidx = gfp_zone(sc->gfp_mask);
 	unsigned long writeback_threshold;
 
+	get_mems_allowed();
 	delayacct_freepages_start();
 
 	if (scanning_global_lru(sc))
@@ -1857,6 +1858,7 @@ out:
 		mem_cgroup_record_reclaim_priority(sc->mem_cgroup, priority);
 
 	delayacct_freepages_end();
+	put_mems_allowed();
 
 	return ret;
 }
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

mempolicy-restructure-rebinding-mempolicy-functions.patch
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems.patch

