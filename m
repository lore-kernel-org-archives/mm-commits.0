Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39E539C80E
	for <mm-commits@vger.kernel.org>; Tue,  6 May 2025 00:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746492253; cv=none; b=cw8jSGpRTb8wad1q6Cr0fbX3ZhWndOFOwocFUxnBTrnXhjMIUQYNNnMQ87G7MjrNB59BCQ8a23TdeXZgun0c5rMe7bXKFdH84TJYsiqAxI6jpm0bEFLOHLzLoCQnGnm5jCU/xKZqyl1EG3+kelH2v3zmTJcY/km5NyriuW7/SgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746492253; c=relaxed/simple;
	bh=bV4e5YxBZn0oQmVuMD4C1kaHAeXQ6mLSstI2ZuTJjHc=;
	h=Date:To:From:Subject:Message-Id; b=eJ9U2mdBfZbte8zT3VvDYCgb9paNorPhmcCDbGrLPeCb+mPs4avs+qEybpYLSxinPe5EQ9s41HtAL90XFfcQzKrc5gae1XANXXgZKR5BResQKhjkEWFaGPmccZg+5ISeACk0E04DcEkdiublVMJh8p/kN+KViDOglYZy29YXKpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Eyr1b2qY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Eyr1b2qY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C2CC4CEEE;
	Tue,  6 May 2025 00:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746492252;
	bh=bV4e5YxBZn0oQmVuMD4C1kaHAeXQ6mLSstI2ZuTJjHc=;
	h=Date:To:From:Subject:From;
	b=Eyr1b2qY5oWv7zVk6orWdGVHxzMdd12VLqki44preuMPjBWNxpzt/UkvyWCTDpHgp
	 V3Rm6HbxGidNf3BPit9n7/nga1ugcg/gYJYa7dkQFF9/8vOtUf/krICt+x57dv5Sqs
	 O5sDc4ebPKcg91wnxefiH+HA509Xzqy/HH21B6N8=
Date: Mon, 05 May 2025 17:44:11 -0700
To: mm-commits@vger.kernel.org,vineethr@linux.ibm.com,tj@kernel.org,tim.c.chen@intel.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,mhocko@kernel.org,mgorman@suse.de,libo.chen@oracle.com,kprateek.nayak@amd.com,hannes@cmpxchg.org,corbet@lwn.net,aubrey.li@intel.com,yu.c.chen@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] sched-numa-add-statistics-of-numa-balance-task-migration-and-swap.patch removed from -mm tree
Message-Id: <20250506004412.16C2CC4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sched/numa: add statistics of numa balance task migration
has been removed from the -mm tree.  Its filename was
     sched-numa-add-statistics-of-numa-balance-task-migration-and-swap.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Chen Yu <yu.c.chen@intel.com>
Subject: sched/numa: add statistics of numa balance task migration
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

[yu.c.chen@intel.com: v3]
  Link: https://lkml.kernel.org/r/20250430103623.3349842-1-yu.c.chen@intel.com
Link: https://lkml.kernel.org/r/20250430103623.3349842-1-yu.c.chen@intel.com
Link: https://lkml.kernel.org/r/20250408101444.192519-1-yu.c.chen@intel.com
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: Madadi Vineeth Reddy <vineethr@linux.ibm.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Aubrey Li <aubrey.li@intel.com>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Libo Chen <libo.chen@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    6 ++++++
 include/linux/sched.h                   |    4 ++++
 include/linux/vm_event_item.h           |    2 ++
 kernel/sched/core.c                     |    7 +++++--
 kernel/sched/debug.c                    |    4 ++++
 mm/memcontrol.c                         |    2 ++
 mm/vmstat.c                             |    2 ++
 7 files changed, 25 insertions(+), 2 deletions(-)

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
@@ -3352,6 +3352,9 @@ void set_task_cpu(struct task_struct *p,
 #ifdef CONFIG_NUMA_BALANCING
 static void __migrate_swap_task(struct task_struct *p, int cpu)
 {
+	__schedstat_inc(p->stats.numa_task_swapped);
+	count_memcg_events_mm(p->mm, NUMA_TASK_SWAP, 1);
+
 	if (task_on_rq_queued(p)) {
 		struct rq *src_rq, *dst_rq;
 		struct rq_flags srf, drf;
@@ -7953,8 +7956,8 @@ int migrate_task_to(struct task_struct *
 	if (!cpumask_test_cpu(target_cpu, p->cpus_ptr))
 		return -EINVAL;
 
-	/* TODO: This is not properly updating schedstats */
-
+	__schedstat_inc(p->stats.numa_task_migrated);
+	count_memcg_events_mm(p->mm, NUMA_TASK_MIGRATE, 1);
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


