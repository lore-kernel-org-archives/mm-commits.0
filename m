From: akpm@linux-foundation.org
Subject: + nohz-do-not-update-idle-iowait-counters-from-get_cpu_idleiowait_time_us-if-not-asked.patch added to -mm tree
Date: Wed, 24 Aug 2011 11:59:57 -0700
Message-ID: <201108241859.p7OIxv0A000459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753796Ab1HXTAQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Aug 2011 15:00:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, adobriyan@gmail.com, arnd@arndb.de, davej@redhat.com, tglx@linutronix.de


The patch titled
     nohz: do not update idle/iowait counters from get_cpu_{idle,iowait}_time_us if not asked
has been added to the -mm tree.  Its filename is
     nohz-do-not-update-idle-iowait-counters-from-get_cpu_idleiowait_time_us-if-not-asked.patch

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
Subject: nohz: do not update idle/iowait counters from get_cpu_{idle,iowait}_time_us if not asked
From: Michal Hocko <mhocko@suse.cz>

get_cpu_{idle,iowait}_time_us update idle/iowait counters unconditionally
if the given CPU is in the idle loop.  This doesn't work well outside of
CPU governors which are singletons so nobody (except for IRQ) can race
with them.

We will need to use both functions from /proc/stat handler to properly
handle nohz idle/iowait times.

Let's update those counters only if the given last_update_time parameter
is non-NULL which means that the caller is interested in updating.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Dave Jones <davej@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |   37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff -puN kernel/time/tick-sched.c~nohz-do-not-update-idle-iowait-counters-from-get_cpu_idleiowait_time_us-if-not-asked kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~nohz-do-not-update-idle-iowait-counters-from-get_cpu_idleiowait_time_us-if-not-asked
+++ a/kernel/time/tick-sched.c
@@ -197,7 +197,8 @@ static ktime_t tick_nohz_start_idle(int 
 /**
  * get_cpu_idle_time_us - get the total idle time of a cpu
  * @cpu: CPU number to query
- * @last_update_time: variable to store update time in
+ * @last_update_time: variable to store update time in. Do not update
+ * counters if NULL.
  *
  * Return the cummulative idle time (since boot) for a given
  * CPU, in microseconds.
@@ -210,20 +211,33 @@ static ktime_t tick_nohz_start_idle(int 
 u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t now, idle;
 
 	if (!tick_nohz_enabled)
 		return -1;
 
-	update_ts_time_stats(cpu, ts, ktime_get(), last_update_time);
+	now = ktime_get();
+	if (last_update_time) {
+		update_ts_time_stats(cpu, ts, now, last_update_time);
+		idle = ts->idle_sleeptime;
+	} else {
+		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
+			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+			idle = ktime_add(ts->idle_sleeptime, delta);
+		} else
+			idle = ts->idle_sleeptime;
+	}
+
+	return ktime_to_us(idle);
 
-	return ktime_to_us(ts->idle_sleeptime);
 }
 EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 
 /**
  * get_cpu_iowait_time_us - get the total iowait time of a cpu
  * @cpu: CPU number to query
- * @last_update_time: variable to store update time in
+ * @last_update_time: variable to store update time in. Do not update
+ * counters if NULL.
  *
  * Return the cummulative iowait time (since boot) for a given
  * CPU, in microseconds.
@@ -236,13 +250,24 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t now, iowait;
 
 	if (!tick_nohz_enabled)
 		return -1;
 
-	update_ts_time_stats(cpu, ts, ktime_get(), last_update_time);
+	now = ktime_get();
+	if (last_update_time) {
+		update_ts_time_stats(cpu, ts, now, last_update_time);
+		iowait = ts->iowait_sleeptime;
+	} else {
+		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
+			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+			iowait = ktime_add(ts->iowait_sleeptime, delta);
+		} else
+			iowait = ts->iowait_sleeptime;
+	}
 
-	return ktime_to_us(ts->iowait_sleeptime);
+	return ktime_to_us(iowait);
 }
 EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
 
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

