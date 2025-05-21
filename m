Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FCF22D4E9
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846616; cv=none; b=rKa+xMDxvr9nx0hpOEw1kTwQs3gIGFtliN3MYGrmLapsVTgrHGI/Wzk9Cnq7XTUbmCinzO6tl9qOUwuCboQiGVPTu8AqQkk25q7zeQvOf8ZPIRAuXuLrVoiYB89ZgOMY0I5qQN9MK8fwb2QUzpdOuetNhaMw5Zs/XTFhrV1Oqh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846616; c=relaxed/simple;
	bh=0E4RrJt1A8CAI7oCKfI0LL3TcSyuS7nAUdCsXUeD/FU=;
	h=Date:To:From:Subject:Message-Id; b=sY+6qjeE3Um2JG2NxjBHo7Z+kHSx+yN7K66W38/BYlTmpZmX8t/OrI+djmtUz5tZYHtHjMNNAHagxC6ZsL6+2BAGVihKxlcFZyoPSV/zQtO21xSmj8yb2X8dJX9Sa/h2wi7lBWZddlm80bGqvkAkz809vvOrAThrs1R5T/tCDoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2AOrUw5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2AOrUw5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A43C4CEE7;
	Wed, 21 May 2025 16:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846614;
	bh=0E4RrJt1A8CAI7oCKfI0LL3TcSyuS7nAUdCsXUeD/FU=;
	h=Date:To:From:Subject:From;
	b=2AOrUw5zvLqXL2Ns5DqjMY0Vf7fYZttIgM9mc/qO/Y86mSEET0/Ll8z3h7thsfZg7
	 tIznOrc1z+KEd42cBxLkKYwwtpeezsiFfIA+Xu5SeuhSK9UaxkEBNBT/vH7tTzkOSs
	 MJQflNabAe6gTeNzkvOpZpnqBJuUiHgVyKpasZhQ=
Date: Wed, 21 May 2025 09:56:54 -0700
To: mm-commits@vger.kernel.org,vineethr@linux.ibm.com,venkat88@linux.ibm.com,tj@kernel.org,tim.c.chen@intel.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,mhocko@kernel.org,mgorman@suse.de,libo.chen@oracle.com,kprateek.nayak@amd.com,hannes@cmpxchg.org,corbet@lwn.net,Ayush.jain3@amd.com,aubrey.li@intel.com,yu.c.chen@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sched-numa-add-statistics-of-numa-balance-task-migration.patch removed from -mm tree
Message-Id: <20250521165654.C2A43C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sched/numa: add statistics of numa balance task migration
has been removed from the -mm tree.  Its filename was
     sched-numa-add-statistics-of-numa-balance-task-migration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chen Yu <yu.c.chen@intel.com>
Subject: sched/numa: add statistics of numa balance task migration
Date: Wed, 7 May 2025 19:17:53 +0800

On systems with NUMA balancing enabled, it has been found that tracking
task activities resulting from NUMA balancing is beneficial.  NUMA
balancing employs two mechanisms for task migration: one is to migrate a
task to an idle CPU within its preferred node, and the other is to swap
tasks located on different nodes when they are on each other's preferred
nodes.

The kernel already provides NUMA page migration statistics in
/sys/fs/cgroup/mytest/memory.stat and /proc/{PID}/sched.  However, it
lacks statistics regarding task migration and swapping.  Therefore,
relevant counts for task migration and swapping should be added.

The following two new fields:

numa_task_migrated
numa_task_swapped

will be shown in /sys/fs/cgroup/{GROUP}/memory.stat, /proc/{PID}/sched
and /proc/vmstat

Introducing both per-task and per-memory cgroup (memcg) NUMA balancing
statistics facilitates a rapid evaluation of the performance and resource
utilization of the target workload.  For instance, users can first
identify the container with high NUMA balancing activity and then further
pinpoint a specific task within that group, and subsequently adjust the
memory policy for that task.  In short, although it is possible to iterate
through /proc/$pid/sched to locate the problematic task, the introduction
of aggregated NUMA balancing activity for tasks within each memcg can
assist users in identifying the task more efficiently through a
divide-and-conquer approach.

As Libo Chen pointed out, the memcg event relies on the text names in
vmstat_text, and /proc/vmstat generates corresponding items based on
vmstat_text.  Thus, the relevant task migration and swapping events
introduced in vmstat_text also need to be populated by
count_vm_numa_event(), otherwise these values are zero in /proc/vmstat.

Link: https://lkml.kernel.org/r/b285978a61e9796b503fd2f0a785306d59f01a43.1746611892.git.yu.c.chen@intel.com
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: Madadi Vineeth Reddy <vineethr@linux.ibm.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Aubrey Li <aubrey.li@intel.com>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Libo Chen <libo.chen@oracle.com>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ayush Jain <Ayush.jain3@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    6 ++++++
 include/linux/sched.h                   |    4 ++++
 include/linux/vm_event_item.h           |    2 ++
 kernel/sched/core.c                     |    9 +++++++--
 kernel/sched/debug.c                    |    4 ++++
 mm/memcontrol.c                         |    2 ++
 mm/vmstat.c                             |    2 ++
 7 files changed, 27 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~sched-numa-add-statistics-of-numa-balance-task-migration
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1697,6 +1697,12 @@ The following nested keys are defined.
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
 
--- a/include/linux/sched.h~sched-numa-add-statistics-of-numa-balance-task-migration
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
--- a/include/linux/vm_event_item.h~sched-numa-add-statistics-of-numa-balance-task-migration
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
--- a/kernel/sched/core.c~sched-numa-add-statistics-of-numa-balance-task-migration
+++ a/kernel/sched/core.c
@@ -3352,6 +3352,10 @@ void set_task_cpu(struct task_struct *p,
 #ifdef CONFIG_NUMA_BALANCING
 static void __migrate_swap_task(struct task_struct *p, int cpu)
 {
+	__schedstat_inc(p->stats.numa_task_swapped);
+	count_vm_numa_event(NUMA_TASK_SWAP);
+	count_memcg_event_mm(p->mm, NUMA_TASK_SWAP);
+
 	if (task_on_rq_queued(p)) {
 		struct rq *src_rq, *dst_rq;
 		struct rq_flags srf, drf;
@@ -7953,8 +7957,9 @@ int migrate_task_to(struct task_struct *
 	if (!cpumask_test_cpu(target_cpu, p->cpus_ptr))
 		return -EINVAL;
 
-	/* TODO: This is not properly updating schedstats */
-
+	__schedstat_inc(p->stats.numa_task_migrated);
+	count_vm_numa_event(NUMA_TASK_MIGRATE);
+	count_memcg_event_mm(p->mm, NUMA_TASK_MIGRATE);
 	trace_sched_move_numa(p, curr_cpu, target_cpu);
 	return stop_one_cpu(curr_cpu, migration_cpu_stop, &arg);
 }
--- a/kernel/sched/debug.c~sched-numa-add-statistics-of-numa-balance-task-migration
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
--- a/mm/memcontrol.c~sched-numa-add-statistics-of-numa-balance-task-migration
+++ a/mm/memcontrol.c
@@ -474,6 +474,8 @@ static const unsigned int memcg_vm_event
 	NUMA_PAGE_MIGRATE,
 	NUMA_PTE_UPDATES,
 	NUMA_HINT_FAULTS,
+	NUMA_TASK_MIGRATE,
+	NUMA_TASK_SWAP,
 #endif
 };
 
--- a/mm/vmstat.c~sched-numa-add-statistics-of-numa-balance-task-migration
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


