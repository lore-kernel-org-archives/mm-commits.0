From: akpm@linux-foundation.org
Subject: + proc-consider-no_hz-when-printing-idle-and-iowait-times.patch added to -mm tree
Date: Wed, 24 Aug 2011 11:59:59 -0700
Message-ID: <201108241859.p7OIxxM7000467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753796Ab1HXTAW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Aug 2011 15:00:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, adobriyan@gmail.com, arnd@arndb.de, davej@redhat.com, tglx@linutronix.de


The patch titled
     proc: consider NO_HZ when printing idle and iowait times
has been added to the -mm tree.  Its filename is
     proc-consider-no_hz-when-printing-idle-and-iowait-times.patch

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
Subject: proc: consider NO_HZ when printing idle and iowait times
From: Michal Hocko <mhocko@suse.cz>

show_stat handler of the /proc/stat file relies on kstat_cpu(cpu)
statistics when priting information about idle and iowait times.  This is
OK if we are not using tickless kernel (CONFIG_NO_HZ) because counters are
updated periodically.

With NO_HZ things got more tricky because we are not doing idle/iowait
accounting while we are tickless so the value might get outdated.  Users
of /proc/stat will notice that by unchanged idle/iowait values which is
then interpreted as 0% idle/iowait time.  From the user space POV this is
an unexpected behavior and a change of the interface.

Let's fix this by using get_cpu_{idle,iowait}_time_us which accounts the
total idle/iowait time since boot and it doesn't rely on sampling or any
other periodic activity.  Fall back to the previous behavior if NO_HZ is
disabled or not configured.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Dave Jones <davej@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/stat.c |   41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff -puN fs/proc/stat.c~proc-consider-no_hz-when-printing-idle-and-iowait-times fs/proc/stat.c
--- a/fs/proc/stat.c~proc-consider-no_hz-when-printing-idle-and-iowait-times
+++ a/fs/proc/stat.c
@@ -10,6 +10,7 @@
 #include <linux/time.h>
 #include <linux/irqnr.h>
 #include <asm/cputime.h>
+#include <linux/tick.h>
 
 #ifndef arch_irq_stat_cpu
 #define arch_irq_stat_cpu(cpu) 0
@@ -21,6 +22,35 @@
 #define arch_idle_time(cpu) 0
 #endif
 
+static cputime64_t get_idle_time(int cpu)
+{
+	u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
+	cputime64_t idle;
+
+	if (idle_time == -1ULL) {
+		/* !NO_HZ so we can rely on cpustat.idle */
+		idle = kstat_cpu(cpu).cpustat.idle;
+		idle = cputime64_add(idle, arch_idle_time(cpu));
+	} else
+		idle = usecs_to_cputime(idle_time);
+
+	return idle;
+}
+
+static cputime64_t get_iowait_time(int cpu)
+{
+	u64 iowait_time = get_cpu_iowait_time_us(cpu, NULL);
+	cputime64_t iowait;
+
+	if (iowait_time == -1ULL)
+		/* !NO_HZ so we can rely on cpustat.iowait */
+		iowait = kstat_cpu(cpu).cpustat.iowait;
+	else
+		iowait = usecs_to_cputime(iowait_time);
+
+	return iowait;
+}
+
 static int show_stat(struct seq_file *p, void *v)
 {
 	int i, j;
@@ -42,9 +72,8 @@ static int show_stat(struct seq_file *p,
 		user = cputime64_add(user, kstat_cpu(i).cpustat.user);
 		nice = cputime64_add(nice, kstat_cpu(i).cpustat.nice);
 		system = cputime64_add(system, kstat_cpu(i).cpustat.system);
-		idle = cputime64_add(idle, kstat_cpu(i).cpustat.idle);
-		idle = cputime64_add(idle, arch_idle_time(i));
-		iowait = cputime64_add(iowait, kstat_cpu(i).cpustat.iowait);
+		idle = cputime64_add(idle, get_idle_time(i));
+		iowait = cputime64_add(iowait, get_iowait_time(i));
 		irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
@@ -76,14 +105,12 @@ static int show_stat(struct seq_file *p,
 		(unsigned long long)cputime64_to_clock_t(guest),
 		(unsigned long long)cputime64_to_clock_t(guest_nice));
 	for_each_online_cpu(i) {
-
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
 		user = kstat_cpu(i).cpustat.user;
 		nice = kstat_cpu(i).cpustat.nice;
 		system = kstat_cpu(i).cpustat.system;
-		idle = kstat_cpu(i).cpustat.idle;
-		idle = cputime64_add(idle, arch_idle_time(i));
-		iowait = kstat_cpu(i).cpustat.iowait;
+		idle = get_idle_time(i);
+		iowait = get_iowait_time(i);
 		irq = kstat_cpu(i).cpustat.irq;
 		softirq = kstat_cpu(i).cpustat.softirq;
 		steal = kstat_cpu(i).cpustat.steal;
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

