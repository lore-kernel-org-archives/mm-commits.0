From: akpm@linux-foundation.org
Subject: + lockstat-measure-lock-bouncing.patch added to -mm tree
Date: Tue, 12 Jun 2007 13:58:52 -0700
Message-ID: <200706122058.l5CKwqVm021028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46555 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778AbXFLU7I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 16:59:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu


The patch titled
     lockstat: measure lock bouncing
has been added to the -mm tree.  Its filename is
     lockstat-measure-lock-bouncing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lockstat: measure lock bouncing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

    __acquire
        |
       lock _____
        |        \
        |    __contended
        |         |
        |        wait
        | _______/
        |/
        |
   __acquired
        |
   __release
        |
     unlock

We measure acquisition and contention bouncing.

This is done by recording a cpu stamp in each lock instance.

Contention bouncing requires the cpu stamp to be set on acquisition. Hence we
move __acquired into the generic path.

__acquired is then used to measure acquisition bouncing by comparing the
current cpu with the old stamp before replacing it.

__contended is used to measure contention bouncing (only useful for preemptable
locks)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h |   17 ++++++++++++++++-
 kernel/lockdep.c        |   38 ++++++++++++++++++++++++++------------
 kernel/lockdep_proc.c   |   18 +++++++++++-------
 kernel/mutex.c          |    2 +-
 4 files changed, 54 insertions(+), 21 deletions(-)

diff -puN include/linux/lockdep.h~lockstat-measure-lock-bouncing include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockstat-measure-lock-bouncing
+++ a/include/linux/lockdep.h
@@ -130,12 +130,24 @@ struct lock_time {
 	unsigned long			nr;
 };
 
+enum bounce_type {
+	bounce_acquired_write,
+	bounce_acquired_read,
+	bounce_contended_write,
+	bounce_contended_read,
+	nr_bounce_types,
+
+	bounce_acquired = bounce_acquired_write,
+	bounce_contended = bounce_contended_write,
+};
+
 struct lock_class_stats {
 	unsigned long			contention_point[4];
 	struct lock_time		read_waittime;
 	struct lock_time		write_waittime;
 	struct lock_time		read_holdtime;
 	struct lock_time		write_holdtime;
+	unsigned long			bounces[nr_bounce_types];
 };
 
 struct lock_class_stats lock_stats(struct lock_class *class);
@@ -150,6 +162,9 @@ struct lockdep_map {
 	struct lock_class_key		*key;
 	struct lock_class		*class_cache;
 	const char			*name;
+#ifdef CONFIG_LOCK_STAT
+	int				cpu;
+#endif
 };
 
 /*
@@ -321,8 +336,8 @@ do {								\
 	if (!try(_lock)) {					\
 		lock_contended(&(_lock)->dep_map, _RET_IP_);	\
 		lock(_lock);					\
-		lock_acquired(&(_lock)->dep_map);		\
 	}							\
+	lock_acquired(&(_lock)->dep_map);			\
 } while (0)
 
 #else /* CONFIG_LOCK_STAT */
diff -puN kernel/lockdep.c~lockstat-measure-lock-bouncing kernel/lockdep.c
--- a/kernel/lockdep.c~lockstat-measure-lock-bouncing
+++ a/kernel/lockdep.c
@@ -177,6 +177,9 @@ struct lock_class_stats lock_stats(struc
 
 		lock_time_add(&pcs->read_holdtime, &stats.read_holdtime);
 		lock_time_add(&pcs->write_holdtime, &stats.write_holdtime);
+
+		for (i = 0; i < ARRAY_SIZE(stats.bounces); i++)
+			stats.bounces[i] += pcs->bounces[i];
 	}
 
 	return stats;
@@ -2325,6 +2328,9 @@ void lockdep_init_map(struct lockdep_map
 	lock->name = name;
 	lock->key = key;
 	lock->class_cache = NULL;
+#ifdef CONFIG_LOCK_STAT
+	lock->cpu = raw_smp_processor_id();
+#endif
 	if (subclass)
 		register_lock_class(lock, subclass, 1);
 }
@@ -2775,6 +2781,8 @@ found_it:
 	stats = get_lock_stats(hlock->class);
 	if (point < ARRAY_SIZE(stats->contention_point))
 		stats->contention_point[i]++;
+	if (lock->cpu != smp_processor_id())
+		stats->bounces[bounce_contended + !!hlock->read]++;
 	put_lock_stats(stats);
 }
 
@@ -2786,8 +2794,8 @@ __lock_acquired(struct lockdep_map *lock
 	struct lock_class_stats *stats;
 	unsigned int depth;
 	u64 now;
-	s64 waittime;
-	int i;
+	s64 waittime = 0;
+	int i, cpu;
 
 	depth = curr->lockdep_depth;
 	if (DEBUG_LOCKS_WARN_ON(!depth))
@@ -2809,19 +2817,25 @@ __lock_acquired(struct lockdep_map *lock
 	return;
 
 found_it:
-	if (!hlock->waittime_stamp)
-		return;
-
-	now = sched_clock();
-	waittime = now - hlock->waittime_stamp;
-	hlock->holdtime_stamp = now;
+	cpu = smp_processor_id();
+	if (hlock->waittime_stamp) {
+		now = sched_clock();
+		waittime = now - hlock->waittime_stamp;
+		hlock->holdtime_stamp = now;
+	}
 
 	stats = get_lock_stats(hlock->class);
-	if (hlock->read)
-		lock_time_inc(&stats->read_waittime, waittime);
-	else
-		lock_time_inc(&stats->write_waittime, waittime);
+	if (waittime) {
+		if (hlock->read)
+			lock_time_inc(&stats->read_waittime, waittime);
+		else
+			lock_time_inc(&stats->write_waittime, waittime);
+	}
+	if (lock->cpu != cpu)
+		stats->bounces[bounce_acquired + !!hlock->read]++;
 	put_lock_stats(stats);
+
+	lock->cpu = cpu;
 }
 
 void lock_contended(struct lockdep_map *lock, unsigned long ip)
diff -puN kernel/lockdep_proc.c~lockstat-measure-lock-bouncing kernel/lockdep_proc.c
--- a/kernel/lockdep_proc.c~lockstat-measure-lock-bouncing
+++ a/kernel/lockdep_proc.c
@@ -430,16 +430,18 @@ static void seq_stats(struct seq_file *m
 		else
 			seq_printf(m, "%40s:", name);
 
+		seq_printf(m, "%14lu ", stats->bounces[bounce_contended_write]);
 		seq_lock_time(m, &stats->write_waittime);
-		seq_puts(m, " ");
+		seq_printf(m, " %14lu ", stats->bounces[bounce_acquired_write]);
 		seq_lock_time(m, &stats->write_holdtime);
 		seq_puts(m, "\n");
 	}
 
 	if (stats->read_holdtime.nr) {
 		seq_printf(m, "%38s-R:", name);
+		seq_printf(m, "%14lu ", stats->bounces[bounce_contended_read]);
 		seq_lock_time(m, &stats->read_waittime);
-		seq_puts(m, " ");
+		seq_printf(m, " %14lu ", stats->bounces[bounce_acquired_read]);
 		seq_lock_time(m, &stats->read_holdtime);
 		seq_puts(m, "\n");
 	}
@@ -469,26 +471,28 @@ static void seq_stats(struct seq_file *m
 	}
 	if (i) {
 		seq_puts(m, "\n");
-		seq_line(m, '.', 0, 40 + 1 + 8 * (14 + 1));
+		seq_line(m, '.', 0, 40 + 1 + 10 * (14 + 1));
 		seq_puts(m, "\n");
 	}
 }
 
 static void seq_header(struct seq_file *m)
 {
-	seq_printf(m, "lock_stat version 0.1\n");
-	seq_line(m, '-', 0, 40 + 1 + 8 * (14 + 1));
-	seq_printf(m, "%40s %14s %14s %14s %14s %14s %14s %14s %14s\n",
+	seq_printf(m, "lock_stat version 0.2\n");
+	seq_line(m, '-', 0, 40 + 1 + 10 * (14 + 1));
+	seq_printf(m, "%40s %14s %14s %14s %14s %14s %14s %14s %14s %14s %14s\n",
 			"class name",
+			"con-bounces",
 			"contentions",
 			"waittime-min",
 			"waittime-max",
 			"waittime-total",
+			"acq-bounces",
 			"acquisitions",
 			"holdtime-min",
 			"holdtime-max",
 			"holdtime-total");
-	seq_line(m, '-', 0, 40 + 1 + 8 * (14 + 1));
+	seq_line(m, '-', 0, 40 + 1 + 10 * (14 + 1));
 	seq_printf(m, "\n");
 }
 
diff -puN kernel/mutex.c~lockstat-measure-lock-bouncing kernel/mutex.c
--- a/kernel/mutex.c~lockstat-measure-lock-bouncing
+++ a/kernel/mutex.c
@@ -180,8 +180,8 @@ __mutex_lock_common(struct mutex *lock, 
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
 
-	lock_acquired(&lock->dep_map);
 done:
+	lock_acquired(&lock->dep_map);
 	/* got the lock - rejoice! */
 	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
 	debug_mutex_set_owner(lock, task_thread_info(task));
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
lockstat-core-infrastructure-fix-fix-fix.patch
lockstat-human-readability-tweaks.patch
lockstat-human-readability-tweaks-fix.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
lockdep-various-fixes.patch
lockdep-various-fixes-checkpatch.patch
lockdep-fixup-sk_callback_lock-annotation.patch
lockstat-measure-lock-bouncing.patch
lockstat-measure-lock-bouncing-checkpatch.patch
lockstat-better-class-name-representation.patch
