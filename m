From: akpm@linux-foundation.org
Subject: + tick-fix-update_ts_time_stat-idle-accounting.patch added to -mm tree
Date: Wed, 24 Aug 2011 11:59:55 -0700
Message-ID: <201108241859.p7OIxu6W000456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753796Ab1HXTAS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Aug 2011 15:00:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, adobriyan@gmail.com, arnd@arndb.de, davej@redhat.com, tglx@linutronix.de


The patch titled
     tick: fix update_ts_time_stat idle accounting
has been added to the -mm tree.  Its filename is
     tick-fix-update_ts_time_stat-idle-accounting.patch

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
Subject: tick: fix update_ts_time_stat idle accounting
From: Michal Hocko <mhocko@suse.cz>

update_ts_time_stat currently updates idle time even if we are in iowait
loop at the moment.  The only real users of the idle counter (via
get_cpu_idle_time_us) are CPU governors and they expect to get cumulative
time for both idle and iowait times.  The value (idle_sleeptime) is also
printed to userspace by print_cpu but it prints both idle and iowait times
so the idle part is misleading.

Let's clean this up and fix update_ts_time_stat to account both counters
properly and update consumers of idle to consider iowait time as well.  If
we do this we might use get_cpu_{idle,iowait}_time_us from other contexts
as well and we will get expected values.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Dave Jones <davej@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_conservative.c |    4 +++-
 drivers/cpufreq/cpufreq_ondemand.c     |    4 +++-
 kernel/time/tick-sched.c               |    8 ++++----
 3 files changed, 10 insertions(+), 6 deletions(-)

diff -puN drivers/cpufreq/cpufreq_conservative.c~tick-fix-update_ts_time_stat-idle-accounting drivers/cpufreq/cpufreq_conservative.c
--- a/drivers/cpufreq/cpufreq_conservative.c~tick-fix-update_ts_time_stat-idle-accounting
+++ a/drivers/cpufreq/cpufreq_conservative.c
@@ -120,10 +120,12 @@ static inline cputime64_t get_cpu_idle_t
 
 static inline cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall)
 {
-	u64 idle_time = get_cpu_idle_time_us(cpu, wall);
+	u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
 
 	if (idle_time == -1ULL)
 		return get_cpu_idle_time_jiffy(cpu, wall);
+	else
+		idle_time += get_cpu_iowait_time_us(cpu, wall);
 
 	return idle_time;
 }
diff -puN drivers/cpufreq/cpufreq_ondemand.c~tick-fix-update_ts_time_stat-idle-accounting drivers/cpufreq/cpufreq_ondemand.c
--- a/drivers/cpufreq/cpufreq_ondemand.c~tick-fix-update_ts_time_stat-idle-accounting
+++ a/drivers/cpufreq/cpufreq_ondemand.c
@@ -144,10 +144,12 @@ static inline cputime64_t get_cpu_idle_t
 
 static inline cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall)
 {
-	u64 idle_time = get_cpu_idle_time_us(cpu, wall);
+	u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
 
 	if (idle_time == -1ULL)
 		return get_cpu_idle_time_jiffy(cpu, wall);
+	else
+		idle_time += get_cpu_iowait_time_us(cpu, wall);
 
 	return idle_time;
 }
diff -puN kernel/time/tick-sched.c~tick-fix-update_ts_time_stat-idle-accounting kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~tick-fix-update_ts_time_stat-idle-accounting
+++ a/kernel/time/tick-sched.c
@@ -158,9 +158,10 @@ update_ts_time_stats(int cpu, struct tic
 
 	if (ts->idle_active) {
 		delta = ktime_sub(now, ts->idle_entrytime);
-		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 		if (nr_iowait_cpu(cpu) > 0)
 			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
+		else
+			ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 		ts->idle_entrytime = now;
 	}
 
@@ -199,8 +200,7 @@ static ktime_t tick_nohz_start_idle(int 
  * @last_update_time: variable to store update time in
  *
  * Return the cummulative idle time (since boot) for a given
- * CPU, in microseconds. The idle time returned includes
- * the iowait time (unlike what "top" and co report).
+ * CPU, in microseconds.
  *
  * This time is measured via accounting rather than sampling,
  * and is as accurate as ktime_get() is.
@@ -220,7 +220,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *l
 }
 EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 
-/*
+/**
  * get_cpu_iowait_time_us - get the total iowait time of a cpu
  * @cpu: CPU number to query
  * @last_update_time: variable to store update time in
_

Patches currently in -mm which might be from mhocko@suse.cz are

memcg-pin-execution-to-current-cpu-while-draining-stock.patch
memcg-make-oom_lock-0-and-1-based-rather-than-coutner.patch
linux-next.patch
cputime-clean-up-cputime_to_usecs-and-usecs_to_cputime-macros.patch
tick-fix-update_ts_time_stat-idle-accounting.patch
nohz-do-not-update-idle-iowait-counters-from-get_cpu_idleiowait_time_us-if-not-asked.patch
proc-consider-no_hz-when-printing-idle-and-iowait-times.patch
mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-migration-clean-up-unmap_and_move.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
oom-avoid-killing-kthreads-if-they-assume-the-oom-killed-threads-mm.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap.patch
mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch
memcg-rename-mem-variable-to-memcg.patch
memcg-fix-oom-schedule_timeout.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

