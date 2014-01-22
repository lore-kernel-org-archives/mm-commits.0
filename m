From: akpm@linux-foundation.org
Subject: [merged]
 sched-add-tracepoints-related-to-numa-task-migration.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:14:46 -0800
Message-ID: <52e026b6.ui8My4UMboTTxoZp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbaAVUOr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:14:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, athorlton@sgi.com, mgorman@suse.de

Subject: [merged] sched-add-tracepoints-related-to-numa-task-migration.patch removed from -mm tree
To: mgorman@suse.de,athorlton@sgi.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:14:46 -0800


The patch titled
     Subject: sched: add tracepoints related to NUMA task migration
has been removed from the -mm tree.  Its filename was
     sched-add-tracepoints-related-to-numa-task-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: sched: add tracepoints related to NUMA task migration

This patch adds three tracepoints
 o trace_sched_move_numa	when a task is moved to a node
 o trace_sched_swap_numa	when a task is swapped with another task
 o trace_sched_stick_numa	when a numa-related migration fails

The tracepoints allow the NUMA scheduler activity to be monitored and the
following high-level metrics can be calculated

 o NUMA migrated stuck	 nr trace_sched_stick_numa
 o NUMA migrated idle	 nr trace_sched_move_numa
 o NUMA migrated swapped nr trace_sched_swap_numa
 o NUMA local swapped	 trace_sched_swap_numa src_nid == dst_nid (should never happen)
 o NUMA remote swapped	 trace_sched_swap_numa src_nid != dst_nid (should == NUMA migrated swapped)
 o NUMA group swapped	 trace_sched_swap_numa src_ngid == dst_ngid
			 Maybe a small number of these are acceptable
			 but a high number would be a major surprise.
			 It would be even worse if bounces are frequent.
 o NUMA avg task migs.	 Average number of migrations for tasks
 o NUMA stddev task mig	 Self-explanatory
 o NUMA max task migs.	 Maximum number of migrations for a single task

In general the intent of the tracepoints is to help diagnose problems
where automatic NUMA balancing appears to be doing an excessive amount of
useless work.

[akpm@linux-foundation.org: remove semicolon-after-if, repair coding-style]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/sched.h |   87 +++++++++++++++++++++++++++++++++
 kernel/sched/core.c          |    2 
 kernel/sched/fair.c          |    6 +-
 3 files changed, 94 insertions(+), 1 deletion(-)

diff -puN include/trace/events/sched.h~sched-add-tracepoints-related-to-numa-task-migration include/trace/events/sched.h
--- a/include/trace/events/sched.h~sched-add-tracepoints-related-to-numa-task-migration
+++ a/include/trace/events/sched.h
@@ -443,6 +443,93 @@ TRACE_EVENT(sched_process_hang,
 );
 #endif /* CONFIG_DETECT_HUNG_TASK */
 
+DECLARE_EVENT_CLASS(sched_move_task_template,
+
+	TP_PROTO(struct task_struct *tsk, int src_cpu, int dst_cpu),
+
+	TP_ARGS(tsk, src_cpu, dst_cpu),
+
+	TP_STRUCT__entry(
+		__field( pid_t,	pid			)
+		__field( pid_t,	tgid			)
+		__field( pid_t,	ngid			)
+		__field( int,	src_cpu			)
+		__field( int,	src_nid			)
+		__field( int,	dst_cpu			)
+		__field( int,	dst_nid			)
+	),
+
+	TP_fast_assign(
+		__entry->pid		= task_pid_nr(tsk);
+		__entry->tgid		= task_tgid_nr(tsk);
+		__entry->ngid		= task_numa_group_id(tsk);
+		__entry->src_cpu	= src_cpu;
+		__entry->src_nid	= cpu_to_node(src_cpu);
+		__entry->dst_cpu	= dst_cpu;
+		__entry->dst_nid	= cpu_to_node(dst_cpu);
+	),
+
+	TP_printk("pid=%d tgid=%d ngid=%d src_cpu=%d src_nid=%d dst_cpu=%d dst_nid=%d",
+			__entry->pid, __entry->tgid, __entry->ngid,
+			__entry->src_cpu, __entry->src_nid,
+			__entry->dst_cpu, __entry->dst_nid)
+);
+
+/*
+ * Tracks migration of tasks from one runqueue to another. Can be used to
+ * detect if automatic NUMA balancing is bouncing between nodes
+ */
+DEFINE_EVENT(sched_move_task_template, sched_move_numa,
+	TP_PROTO(struct task_struct *tsk, int src_cpu, int dst_cpu),
+
+	TP_ARGS(tsk, src_cpu, dst_cpu)
+);
+
+DEFINE_EVENT(sched_move_task_template, sched_stick_numa,
+	TP_PROTO(struct task_struct *tsk, int src_cpu, int dst_cpu),
+
+	TP_ARGS(tsk, src_cpu, dst_cpu)
+);
+
+TRACE_EVENT(sched_swap_numa,
+
+	TP_PROTO(struct task_struct *src_tsk, int src_cpu,
+		 struct task_struct *dst_tsk, int dst_cpu),
+
+	TP_ARGS(src_tsk, src_cpu, dst_tsk, dst_cpu),
+
+	TP_STRUCT__entry(
+		__field( pid_t,	src_pid			)
+		__field( pid_t,	src_tgid		)
+		__field( pid_t,	src_ngid		)
+		__field( int,	src_cpu			)
+		__field( int,	src_nid			)
+		__field( pid_t,	dst_pid			)
+		__field( pid_t,	dst_tgid		)
+		__field( pid_t,	dst_ngid		)
+		__field( int,	dst_cpu			)
+		__field( int,	dst_nid			)
+	),
+
+	TP_fast_assign(
+		__entry->src_pid	= task_pid_nr(src_tsk);
+		__entry->src_tgid	= task_tgid_nr(src_tsk);
+		__entry->src_ngid	= task_numa_group_id(src_tsk);
+		__entry->src_cpu	= src_cpu;
+		__entry->src_nid	= cpu_to_node(src_cpu);
+		__entry->dst_pid	= task_pid_nr(dst_tsk);
+		__entry->dst_tgid	= task_tgid_nr(dst_tsk);
+		__entry->dst_ngid	= task_numa_group_id(dst_tsk);
+		__entry->dst_cpu	= dst_cpu;
+		__entry->dst_nid	= cpu_to_node(dst_cpu);
+	),
+
+	TP_printk("src_pid=%d src_tgid=%d src_ngid=%d src_cpu=%d src_nid=%d dst_pid=%d dst_tgid=%d dst_ngid=%d dst_cpu=%d dst_nid=%d",
+			__entry->src_pid, __entry->src_tgid, __entry->src_ngid,
+			__entry->src_cpu, __entry->src_nid,
+			__entry->dst_pid, __entry->dst_tgid, __entry->dst_ngid,
+			__entry->dst_cpu, __entry->dst_nid)
+);
 #endif /* _TRACE_SCHED_H */
 
 /* This part must be outside protection */
diff -puN kernel/sched/core.c~sched-add-tracepoints-related-to-numa-task-migration kernel/sched/core.c
--- a/kernel/sched/core.c~sched-add-tracepoints-related-to-numa-task-migration
+++ a/kernel/sched/core.c
@@ -1108,6 +1108,7 @@ int migrate_swap(struct task_struct *cur
 	if (!cpumask_test_cpu(arg.src_cpu, tsk_cpus_allowed(arg.dst_task)))
 		goto out;
 
+	trace_sched_swap_numa(cur, arg.src_cpu, p, arg.dst_cpu);
 	ret = stop_two_cpus(arg.dst_cpu, arg.src_cpu, migrate_swap_stop, &arg);
 
 out:
@@ -4603,6 +4604,7 @@ int migrate_task_to(struct task_struct *
 
 	/* TODO: This is not properly updating schedstats */
 
+	trace_sched_move_numa(p, curr_cpu, target_cpu);
 	return stop_one_cpu(curr_cpu, migration_cpu_stop, &arg);
 }
 
diff -puN kernel/sched/fair.c~sched-add-tracepoints-related-to-numa-task-migration kernel/sched/fair.c
--- a/kernel/sched/fair.c~sched-add-tracepoints-related-to-numa-task-migration
+++ a/kernel/sched/fair.c
@@ -1250,11 +1250,15 @@ static int task_numa_migrate(struct task
 	p->numa_scan_period = task_scan_min(p);
 
 	if (env.best_task == NULL) {
-		int ret = migrate_task_to(p, env.best_cpu);
+		ret = migrate_task_to(p, env.best_cpu);
+		if (ret != 0)
+			trace_sched_stick_numa(p, env.src_cpu, env.best_cpu);
 		return ret;
 	}
 
 	ret = migrate_swap(p, env.best_task);
+	if (ret != 0)
+		trace_sched_stick_numa(p, env.src_cpu, task_cpu(env.best_task));
 	put_task_struct(env.best_task);
 	return ret;
 }
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
x86-mm-account-for-tlb-flushes-only-when-debugging.patch
x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch
x86-mm-eliminate-redundant-page-table-walk-during-tlb-range-flushing.patch
x86-mm-change-tlb_flushall_shift-for-ivybridge.patch
mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
numa-add-a-sysctl-for-numa_balancing.patch
numa-add-a-sysctl-for-numa_balancing-fix.patch
mm-vmscan-shrink-all-slab-objects-if-tight-on-memory.patch
mm-vmscan-call-numa-unaware-shrinkers-irrespective-of-nodemask.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-show-message-when-updating-min_free_kbytes-in-thp.patch
mm-improve-documentation-of-page_order-v2.patch
mm-improve-documentation-of-page_order-v2-fix.patch
linux-next.patch
mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch

