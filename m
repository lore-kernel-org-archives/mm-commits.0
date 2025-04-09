Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC42EC5
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 00:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744158547; cv=none; b=gwJ8BtvDDnV1swUx9MiwgOxfXTJdz5pi2IrLxpYLXS96owB4mxJTJ/7mJ1kPwXH6lJ4Clt7ed7/BquCBRMdllZ/vU+daYkr5B2dt7tLV/g4+S8VDtdNqac9kylTZ6c669PKTXlB0jxmzet5W5EmxC7V7yrf+rEwYr4ONIGCLj2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744158547; c=relaxed/simple;
	bh=3/UkQVMRNGGVG7cMEfnor91Pkme2WQVbwPM077PcQls=;
	h=Date:To:From:Subject:Message-Id; b=HnERPt33OVvMlfs8FTsI7Kov66ZYH67bHALHrvxKkBGtjo+Ljxzc4n0uVIVIwpCBfYTZwndiWk6sbfg9lMVJjPU857Y/R5JSFmyaFrszLpxoJdOJP7VbgNJT0fj7aIiJYSc0dBDK2QYA1f9bdaCeE1JWizT7XlBe+DT9NfJrW9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oOiX5TEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oOiX5TEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D1CC4CEE5;
	Wed,  9 Apr 2025 00:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744158547;
	bh=3/UkQVMRNGGVG7cMEfnor91Pkme2WQVbwPM077PcQls=;
	h=Date:To:From:Subject:From;
	b=oOiX5TEjq5OGhO/Acwk+IR72hE2k/iqCZPSztpbxIQw4KFXyfkKvLt28yNZM631xP
	 t+617zkshIEOOLCHJ9D+bWe1YW3H6E4fYtKZ+gKgFi3KdRziuRKkwtYcoLaQeceWOe
	 6xKJoM648Zwn1Ka229DSOP7qMQ+eIyf4HZMfqgeA=
Date: Tue, 08 Apr 2025 17:29:06 -0700
To: mm-commits@vger.kernel.org,vineethr@linux.ibm.com,tj@kernel.org,tim.c.chen@intel.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,mhocko@kernel.org,mgorman@suse.de,kprateek.nayak@amd.com,hannes@cmpxchg.org,corbet@lwn.net,aubrey.li@intel.com,yu.c.chen@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-numa-add-statistics-of-numa-balance-task-migration-and-swap.patch added to mm-new branch
Message-Id: <20250409002907.39D1CC4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sched/numa: add statistics of numa balance task migration and swap
has been added to the -mm mm-new branch.  Its filename is
     sched-numa-add-statistics-of-numa-balance-task-migration-and-swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sched-numa-add-statistics-of-numa-balance-task-migration-and-swap.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Chen Yu <yu.c.chen@intel.com>
Subject: sched/numa: add statistics of numa balance task migration and swap
Date: Tue, 8 Apr 2025 18:14:44 +0800

On systems with NUMA balancing enabled, it is found that tracking the task
activities due to NUMA balancing is helpful.  NUMA balancing has two
mechanisms for task migration: one is to migrate the task to an idle CPU
in its preferred node, the other is to swap tasks on different nodes if
they are on each other's preferred node.

The kernel already has NUMA page migration statistics in
/sys/fs/cgroup/mytest/memory.stat and /proc/{PID}/sched, but does not have
statistics for task migration/swap.  Add the task migration and swap count
accordingly.

The following two new fields:

numa_task_migrated
numa_task_swapped

will be displayed in both
/sys/fs/cgroup/{GROUP}/memory.stat and /proc/{PID}/sched

Introducing both pertask and permemcg NUMA balancing statistics helps to
quickly evaluate the performance and resource usage of the target
workload.  For example, the user can first identify the container which
has high NUMA balance activity and then narrow down to a specific task
within that group, and tune the memory policy of that task.  In summary,
it is plausible to iterate the /proc/$pid/sched to find the offending
task, but the introduction of per memcg tasks' Numa balancing aggregated
activity can further help users identify the task in a divide-and-conquer
way.

Link: https://lkml.kernel.org/r/20250408101444.192519-1-yu.c.chen@intel.com
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: Madadi Vineeth Reddy <vineethr@linux.ibm.com>
Cc: Aubrey Li <aubrey.li@intel.com>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    6 ++++++
 include/linux/sched.h                   |    4 ++++
 include/linux/vm_event_item.h           |    2 ++
 kernel/sched/core.c                     |   10 ++++++++--
 kernel/sched/debug.c                    |    4 ++++
 mm/memcontrol.c                         |    2 ++
 mm/vmstat.c                             |    2 ++
 7 files changed, 28 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~sched-numa-add-statistics-of-numa-balance-task-migration-and-swap
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1670,6 +1670,12 @@ The following nested keys are defined.
 	  numa_hint_faults (npn)
 		Number of NUMA hinting faults.
 
+	  numa_task_migrated (npn)
+		Number of task migration by NUMA balancing.
+
+	  numa_task_swapped (npn)
+		Number of task swap by NUMA balancing.
+
 	  pgdemote_kswapd
 		Number of pages demoted by kswapd.
 
--- a/include/linux/sched.h~sched-numa-add-statistics-of-numa-balance-task-migration-and-swap
+++ a/include/linux/sched.h
@@ -549,6 +549,10 @@ struct sched_statistics {
 	u64				nr_failed_migrations_running;
 	u64				nr_failed_migrations_hot;
 	u64				nr_forced_migrations;
+#ifdef CONFIG_NUMA_BALANCING
+	u64				numa_task_migrated;
+	u64				numa_task_swapped;
+#endif
 
 	u64				nr_wakeups;
 	u64				nr_wakeups_sync;
--- a/include/linux/vm_event_item.h~sched-numa-add-statistics-of-numa-balance-task-migration-and-swap
+++ a/include/linux/vm_event_item.h
@@ -66,6 +66,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		NUMA_HINT_FAULTS,
 		NUMA_HINT_FAULTS_LOCAL,
 		NUMA_PAGE_MIGRATE,
+		NUMA_TASK_MIGRATE,
+		NUMA_TASK_SWAP,
 #endif
 #ifdef CONFIG_MIGRATION
 		PGMIGRATE_SUCCESS, PGMIGRATE_FAIL,
--- a/kernel/sched/core.c~sched-numa-add-statistics-of-numa-balance-task-migration-and-swap
+++ a/kernel/sched/core.c
@@ -3352,6 +3352,11 @@ void set_task_cpu(struct task_struct *p,
 #ifdef CONFIG_NUMA_BALANCING
 static void __migrate_swap_task(struct task_struct *p, int cpu)
 {
+	__schedstat_inc(p->stats.numa_task_swapped);
+
+	if (p->mm)
+		count_memcg_events_mm(p->mm, NUMA_TASK_SWAP, 1);
+
 	if (task_on_rq_queued(p)) {
 		struct rq *src_rq, *dst_rq;
 		struct rq_flags srf, drf;
@@ -7953,8 +7958,9 @@ int migrate_task_to(struct task_struct *
 	if (!cpumask_test_cpu(target_cpu, p->cpus_ptr))
 		return -EINVAL;
 
-	/* TODO: This is not properly updating schedstats */
-
+	__schedstat_inc(p->stats.numa_task_migrated);
+	if (p->mm)
+		count_memcg_events_mm(p->mm, NUMA_TASK_MIGRATE, 1);
 	trace_sched_move_numa(p, curr_cpu, target_cpu);
 	return stop_one_cpu(curr_cpu, migration_cpu_stop, &arg);
 }
--- a/kernel/sched/debug.c~sched-numa-add-statistics-of-numa-balance-task-migration-and-swap
+++ a/kernel/sched/debug.c
@@ -1206,6 +1206,10 @@ void proc_sched_show_task(struct task_st
 		P_SCHEDSTAT(nr_failed_migrations_running);
 		P_SCHEDSTAT(nr_failed_migrations_hot);
 		P_SCHEDSTAT(nr_forced_migrations);
+#ifdef CONFIG_NUMA_BALANCING
+		P_SCHEDSTAT(numa_task_migrated);
+		P_SCHEDSTAT(numa_task_swapped);
+#endif
 		P_SCHEDSTAT(nr_wakeups);
 		P_SCHEDSTAT(nr_wakeups_sync);
 		P_SCHEDSTAT(nr_wakeups_migrate);
--- a/mm/memcontrol.c~sched-numa-add-statistics-of-numa-balance-task-migration-and-swap
+++ a/mm/memcontrol.c
@@ -470,6 +470,8 @@ static const unsigned int memcg_vm_event
 	NUMA_PAGE_MIGRATE,
 	NUMA_PTE_UPDATES,
 	NUMA_HINT_FAULTS,
+	NUMA_TASK_MIGRATE,
+	NUMA_TASK_SWAP,
 #endif
 };
 
--- a/mm/vmstat.c~sched-numa-add-statistics-of-numa-balance-task-migration-and-swap
+++ a/mm/vmstat.c
@@ -1347,6 +1347,8 @@ const char * const vmstat_text[] = {
 	"numa_hint_faults",
 	"numa_hint_faults_local",
 	"numa_pages_migrated",
+	"numa_task_migrated",
+	"numa_task_swapped",
 #endif
 #ifdef CONFIG_MIGRATION
 	"pgmigrate_success",
_

Patches currently in -mm which might be from yu.c.chen@intel.com are

sched-numa-add-statistics-of-numa-balance-task-migration-and-swap.patch

