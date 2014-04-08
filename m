From: akpm@linux-foundation.org
Subject: [merged] mm-mempolicy-remove-per-process-flag.patch removed from
 -mm tree
Date: Tue, 08 Apr 2014 13:46:03 -0700
Message-ID: <5344600b.DX3CRUgxHRqAh9aQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525AbaDHUqE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:46:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wujianguo@huawei.com, tj@kernel.org, thockin@google.com, riel@redhat.com, penberg@kernel.org, oleg@redhat.com, mhocko@suse.cz, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, cl@linux.com, cl@linux-foundation.org, rientjes@google.com

Subject: [merged] mm-mempolicy-remove-per-process-flag.patch removed from -mm tree
To: rientjes@google.com,cl@linux-foundation.org,cl@linux.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mgorman@suse.de,mhocko@suse.cz,oleg@redhat.com,penberg@kernel.org,riel@redhat.com,thockin@google.com,tj@kernel.org,wujianguo@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:46:03 -0700


The patch titled
     Subject: mm, mempolicy: remove per-process flag
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-remove-per-process-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, mempolicy: remove per-process flag

PF_MEMPOLICY is an unnecessary optimization for CONFIG_SLAB users. 
There's no significant performance degradation to checking
current->mempolicy rather than current->flags & PF_MEMPOLICY in the
allocation path, especially since this is considered unlikely().

Running TCP_RR with netperf-2.4.5 through localhost on 16 cpu machine with
64GB of memory and without a mempolicy:

	threads		before		after
	16		1249409		1244487
	32		1281786		1246783
	48		1239175		1239138
	64		1244642		1241841
	80		1244346		1248918
	96		1266436		1254316
	112		1307398		1312135
	128		1327607		1326502

Per-process flags are a scarce resource so we should free them up whenever
possible and make them available.  We'll be using it shortly for memcg oom
reserves.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Tim Hockin <thockin@google.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    1 -
 include/linux/sched.h     |    1 -
 kernel/fork.c             |    1 -
 mm/mempolicy.c            |   31 -------------------------------
 mm/slab.c                 |    4 ++--
 5 files changed, 2 insertions(+), 36 deletions(-)

diff -puN include/linux/mempolicy.h~mm-mempolicy-remove-per-process-flag include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-mempolicy-remove-per-process-flag
+++ a/include/linux/mempolicy.h
@@ -143,7 +143,6 @@ extern void numa_policy_init(void);
 extern void mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new,
 				enum mpol_rebind_step step);
 extern void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new);
-extern void mpol_fix_fork_child_flag(struct task_struct *p);
 
 extern struct zonelist *huge_zonelist(struct vm_area_struct *vma,
 				unsigned long addr, gfp_t gfp_flags,
diff -puN include/linux/sched.h~mm-mempolicy-remove-per-process-flag include/linux/sched.h
--- a/include/linux/sched.h~mm-mempolicy-remove-per-process-flag
+++ a/include/linux/sched.h
@@ -1851,7 +1851,6 @@ extern void thread_group_cputime_adjuste
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
 #define PF_NO_SETAFFINITY 0x04000000	/* Userland is not allowed to meddle with cpus_allowed */
 #define PF_MCE_EARLY    0x08000000      /* Early kill for mce process policy */
-#define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
 #define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezable */
 #define PF_SUSPEND_TASK 0x80000000      /* this thread called freeze_processes and should not be frozen */
diff -puN kernel/fork.c~mm-mempolicy-remove-per-process-flag kernel/fork.c
--- a/kernel/fork.c~mm-mempolicy-remove-per-process-flag
+++ a/kernel/fork.c
@@ -1276,7 +1276,6 @@ static struct task_struct *copy_process(
 		p->mempolicy = NULL;
 		goto bad_fork_cleanup_threadgroup_lock;
 	}
-	mpol_fix_fork_child_flag(p);
 #endif
 #ifdef CONFIG_CPUSETS
 	p->cpuset_mem_spread_rotor = NUMA_NO_NODE;
diff -puN mm/mempolicy.c~mm-mempolicy-remove-per-process-flag mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-remove-per-process-flag
+++ a/mm/mempolicy.c
@@ -795,36 +795,6 @@ static int mbind_range(struct mm_struct
 	return err;
 }
 
-/*
- * Update task->flags PF_MEMPOLICY bit: set iff non-default
- * mempolicy.  Allows more rapid checking of this (combined perhaps
- * with other PF_* flag bits) on memory allocation hot code paths.
- *
- * If called from outside this file, the task 'p' should -only- be
- * a newly forked child not yet visible on the task list, because
- * manipulating the task flags of a visible task is not safe.
- *
- * The above limitation is why this routine has the funny name
- * mpol_fix_fork_child_flag().
- *
- * It is also safe to call this with a task pointer of current,
- * which the static wrapper mpol_set_task_struct_flag() does,
- * for use within this file.
- */
-
-void mpol_fix_fork_child_flag(struct task_struct *p)
-{
-	if (p->mempolicy)
-		p->flags |= PF_MEMPOLICY;
-	else
-		p->flags &= ~PF_MEMPOLICY;
-}
-
-static void mpol_set_task_struct_flag(void)
-{
-	mpol_fix_fork_child_flag(current);
-}
-
 /* Set the process memory policy */
 static long do_set_mempolicy(unsigned short mode, unsigned short flags,
 			     nodemask_t *nodes)
@@ -861,7 +831,6 @@ static long do_set_mempolicy(unsigned sh
 	}
 	old = current->mempolicy;
 	current->mempolicy = new;
-	mpol_set_task_struct_flag();
 	if (new && new->mode == MPOL_INTERLEAVE &&
 	    nodes_weight(new->v.nodes))
 		current->il_next = first_node(new->v.nodes);
diff -puN mm/slab.c~mm-mempolicy-remove-per-process-flag mm/slab.c
--- a/mm/slab.c~mm-mempolicy-remove-per-process-flag
+++ a/mm/slab.c
@@ -3027,7 +3027,7 @@ out:
 
 #ifdef CONFIG_NUMA
 /*
- * Try allocating on another node if PF_SPREAD_SLAB|PF_MEMPOLICY.
+ * Try allocating on another node if PF_SPREAD_SLAB is a mempolicy is set.
  *
  * If we are in_interrupt, then process context, including cpusets and
  * mempolicy, may not apply and should not be used for allocation policy.
@@ -3259,7 +3259,7 @@ __do_cache_alloc(struct kmem_cache *cach
 {
 	void *objp;
 
-	if (unlikely(current->flags & (PF_SPREAD_SLAB | PF_MEMPOLICY))) {
+	if (current->mempolicy || unlikely(current->flags & PF_SPREAD_SLAB)) {
 		objp = alternate_node_alloc(cache, flags);
 		if (objp)
 			goto out;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
arch-x86-mm-kmemcheck-kmemcheckc-use-kstrtoint-instead-of-sscanf.patch

