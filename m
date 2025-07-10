Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041FD1A285
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752120567; cv=none; b=dy5dW8s1Ki3ip8Mfxc0Q+HDIxFKk8ehp8nyE1Ke9kVZDXGB/c5vGJzwNUwDAaE3LPriV0ocWEZ8KK69GWnEXA3Ufzt0kVCBptcfXoYqY6FJ7IP4noyIAMBndNccj44EZ/d/pO44QMKFQksgMmoh/GW1BhxCyqYDCEBp3JIDsGQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752120567; c=relaxed/simple;
	bh=SJu6aG5EmCZw+OeTZF/SJWKzDxnQ46gWFJM/2BAC+7E=;
	h=Date:To:From:Subject:Message-Id; b=ENIgsjyrbS3LxSlVqrDgkSqc5rO7/IBnSc02RwEqun8VOMwM5DjrVhw2e1b46a4ZnS7MC9HDs7SXb45Jx+X5U2tXm2fu2ScXmSMLOewa3e+8KFOfGU3dRQCjldYU0DCjne3BYXZ7jmk8j9P3nUlISjMN7eKAeaa51y/3FGmgE5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eHSRsQLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eHSRsQLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD100C4CEE3;
	Thu, 10 Jul 2025 04:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752120566;
	bh=SJu6aG5EmCZw+OeTZF/SJWKzDxnQ46gWFJM/2BAC+7E=;
	h=Date:To:From:Subject:From;
	b=eHSRsQLzJ9be8qSwLipXICdzecwxRPoLOUcaOgO49ELwTMKXsLdWJT/s+iDXZnlJg
	 /R3gCeMcYhTqEjC5WRNVlBKZg74qYCLs4mujN16wzLZetv3gX6+HmoQgfY7XeUGYen
	 LlS+KrvrInE5C7vaUH8Yn9/tqhiskqpVCYrFB8WY=
Date: Wed, 09 Jul 2025 21:09:25 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,Suneeth.D@amd.com,Srikanth.Aithal@amd.com,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,libo.chen@oracle.com,jhladky@redhat.com,bp@alien8.de,yu.c.chen@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-sched-numa-add-statistics-of-numa-balance-task.patch removed from -mm tree
Message-Id: <20250710040926.CD100C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "sched/numa: add statistics of numa balance task"
has been removed from the -mm tree.  Its filename was
     revert-sched-numa-add-statistics-of-numa-balance-task.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chen Yu <yu.c.chen@intel.com>
Subject: Revert "sched/numa: add statistics of numa balance task"
Date: Fri, 4 Jul 2025 21:56:20 +0800

This reverts commit ad6b26b6a0a79166b53209df2ca1cf8636296382.

This commit introduces per-memcg/task NUMA balance statistics, but
unfortunately it introduced a NULL pointer exception due to the following
race condition: After a swap task candidate was chosen, its mm_struct
pointer was set to NULL due to task exit.  Later, when performing the
actual task swapping, the p->mm caused the problem.

CPU0                                   CPU1
:
...
task_numa_migrate
     task_numa_find_cpu
      task_numa_compare
        # a normal task p is chosen
        env->best_task = p

                                          # p exit:
                                          exit_signals(p);
                                             p->flags |= PF_EXITING
                                          exit_mm
                                             p->mm = NULL;

      migrate_swap_stop
        __migrate_swap_task((arg->src_task, arg->dst_cpu)
         count_memcg_event_mm(p->mm, NUMA_TASK_SWAP)# p->mm is NULL

task_lock() should be held and the PF_EXITING flag needs to be checked to
prevent this from happening.  After discussion, the conclusion was that
adding a lock is not worthwhile for some statistics calculations.  Revert
the change and rely on the tracepoint for this purpose.

Link: https://lkml.kernel.org/r/20250704135620.685752-1-yu.c.chen@intel.com
Link: https://lkml.kernel.org/r/20250708064917.BBD13C4CEED@smtp.kernel.org
Fixes: ad6b26b6a0a7 ("sched/numa: add statistics of numa balance task")
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Reported-by: Jirka Hladky <jhladky@redhat.com>
Closes: https://lore.kernel.org/all/CAE4VaGBLJxpd=NeRJXpSCuw=REhC5LWJpC29kDy-Zh2ZDyzQZA@mail.gmail.com/
Reported-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
Reported-by: Suneeth D <Suneeth.D@amd.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Hladky <jhladky@redhat.com>
Cc: Libo Chen <libo.chen@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    6 ------
 include/linux/sched.h                   |    4 ----
 include/linux/vm_event_item.h           |    2 --
 kernel/sched/core.c                     |    9 ++-------
 kernel/sched/debug.c                    |    4 ----
 mm/memcontrol.c                         |    2 --
 mm/vmstat.c                             |    2 --
 7 files changed, 2 insertions(+), 27 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~revert-sched-numa-add-statistics-of-numa-balance-task
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1732,12 +1732,6 @@ The following nested keys are defined.
 	  numa_hint_faults (npn)
 		Number of NUMA hinting faults.
 
-	  numa_task_migrated (npn)
-		Number of task migration by NUMA balancing.
-
-	  numa_task_swapped (npn)
-		Number of task swap by NUMA balancing.
-
 	  pgdemote_kswapd
 		Number of pages demoted by kswapd.
 
--- a/include/linux/sched.h~revert-sched-numa-add-statistics-of-numa-balance-task
+++ a/include/linux/sched.h
@@ -548,10 +548,6 @@ struct sched_statistics {
 	u64				nr_failed_migrations_running;
 	u64				nr_failed_migrations_hot;
 	u64				nr_forced_migrations;
-#ifdef CONFIG_NUMA_BALANCING
-	u64				numa_task_migrated;
-	u64				numa_task_swapped;
-#endif
 
 	u64				nr_wakeups;
 	u64				nr_wakeups_sync;
--- a/include/linux/vm_event_item.h~revert-sched-numa-add-statistics-of-numa-balance-task
+++ a/include/linux/vm_event_item.h
@@ -66,8 +66,6 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		NUMA_HINT_FAULTS,
 		NUMA_HINT_FAULTS_LOCAL,
 		NUMA_PAGE_MIGRATE,
-		NUMA_TASK_MIGRATE,
-		NUMA_TASK_SWAP,
 #endif
 #ifdef CONFIG_MIGRATION
 		PGMIGRATE_SUCCESS, PGMIGRATE_FAIL,
--- a/kernel/sched/core.c~revert-sched-numa-add-statistics-of-numa-balance-task
+++ a/kernel/sched/core.c
@@ -3362,10 +3362,6 @@ void set_task_cpu(struct task_struct *p,
 #ifdef CONFIG_NUMA_BALANCING
 static void __migrate_swap_task(struct task_struct *p, int cpu)
 {
-	__schedstat_inc(p->stats.numa_task_swapped);
-	count_vm_numa_event(NUMA_TASK_SWAP);
-	count_memcg_event_mm(p->mm, NUMA_TASK_SWAP);
-
 	if (task_on_rq_queued(p)) {
 		struct rq *src_rq, *dst_rq;
 		struct rq_flags srf, drf;
@@ -7939,9 +7935,8 @@ int migrate_task_to(struct task_struct *
 	if (!cpumask_test_cpu(target_cpu, p->cpus_ptr))
 		return -EINVAL;
 
-	__schedstat_inc(p->stats.numa_task_migrated);
-	count_vm_numa_event(NUMA_TASK_MIGRATE);
-	count_memcg_event_mm(p->mm, NUMA_TASK_MIGRATE);
+	/* TODO: This is not properly updating schedstats */
+
 	trace_sched_move_numa(p, curr_cpu, target_cpu);
 	return stop_one_cpu(curr_cpu, migration_cpu_stop, &arg);
 }
--- a/kernel/sched/debug.c~revert-sched-numa-add-statistics-of-numa-balance-task
+++ a/kernel/sched/debug.c
@@ -1210,10 +1210,6 @@ void proc_sched_show_task(struct task_st
 		P_SCHEDSTAT(nr_failed_migrations_running);
 		P_SCHEDSTAT(nr_failed_migrations_hot);
 		P_SCHEDSTAT(nr_forced_migrations);
-#ifdef CONFIG_NUMA_BALANCING
-		P_SCHEDSTAT(numa_task_migrated);
-		P_SCHEDSTAT(numa_task_swapped);
-#endif
 		P_SCHEDSTAT(nr_wakeups);
 		P_SCHEDSTAT(nr_wakeups_sync);
 		P_SCHEDSTAT(nr_wakeups_migrate);
--- a/mm/memcontrol.c~revert-sched-numa-add-statistics-of-numa-balance-task
+++ a/mm/memcontrol.c
@@ -474,8 +474,6 @@ static const unsigned int memcg_vm_event
 	NUMA_PAGE_MIGRATE,
 	NUMA_PTE_UPDATES,
 	NUMA_HINT_FAULTS,
-	NUMA_TASK_MIGRATE,
-	NUMA_TASK_SWAP,
 #endif
 };
 
--- a/mm/vmstat.c~revert-sched-numa-add-statistics-of-numa-balance-task
+++ a/mm/vmstat.c
@@ -1346,8 +1346,6 @@ const char * const vmstat_text[] = {
 	"numa_hint_faults",
 	"numa_hint_faults_local",
 	"numa_pages_migrated",
-	"numa_task_migrated",
-	"numa_task_swapped",
 #endif
 #ifdef CONFIG_MIGRATION
 	"pgmigrate_success",
_

Patches currently in -mm which might be from yu.c.chen@intel.com are


