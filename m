From: akpm@linux-foundation.org
Subject: + cputime-clean-up-cputime_to_usecs-and-usecs_to_cputime-macros.patch added to -mm tree
Date: Wed, 24 Aug 2011 11:59:53 -0700
Message-ID: <201108241859.p7OIxrhA000453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753796Ab1HXTAW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Aug 2011 15:00:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, adobriyan@gmail.com, arnd@arndb.de, davej@redhat.com, tglx@linutronix.de


The patch titled
     cputime: clean up cputime_to_usecs and usecs_to_cputime macros
has been added to the -mm tree.  Its filename is
     cputime-clean-up-cputime_to_usecs-and-usecs_to_cputime-macros.patch

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
Subject: cputime: clean up cputime_to_usecs and usecs_to_cputime macros
From: Michal Hocko <mhocko@suse.cz>

This patchset aims at addressing /proc/stat issue which has been
introduced with tickless kernel.  In short, show_stat (proc handler)
relies on kstat_cpu(i).cpustat statistics which are updated periodically
so those numbers are more or less accurate.

This is, however, not true with tickless kernel for idle and iowait
counters because those are not updated while the cpu is in the tickless
state.  As the time when CPU might be tickless is not bounded, we can see
really outdated values.

The biggest problem is that tools which read /proc/stat interpret
unchanged idle/iowait numbers as 0% idle/iowait which might confuse those
who rely on them.

The first patch in this series is just a minor clean-up.

The second one changes update_ts_time_stat semantic.  The current
implementation updates idle counter regardless we are in iowait loop at
the moment.  I see it as an optimization because cpufreq drivers, which
are only users of those counters, care about busy vs.  non-busy states so
idle+iowait makes perfect sense.  This, however, makes idle counter
useless for others.

I think that using get_cpu_idle_time_us + get_cpu_iowait_time_us should
have the same meaning (at least this is what we do for jiffies variants).

The third patch changes get_cpu_{idle,iowait}_time_us semantic.  Both
functions call update_ts_time_stat so they update counters as a side
effect.  This should be OK most of the time as governors (the only users)
are singletons.  I can still see a potential problem because they might
race with IRQ:

irq_enter
  tick_check_idle
    tick_check_nohz
      tick_nohz_stop_idle

but this is a separate issue IMO.

Anyway, we shouldn't update those counters from other contexts so let's
make updating conditional based on the last_update_time parameter.

The final patch is the actual fix.  It uses get_cpu_{idle,iowait}_time_us
to get precise counters.  We still fall back to kstat_cpu if tickless
kernel is disabled.

The patchset is based on top of and gave it some testing (although I am
still not sure about the cpufreq part and possible side effects).  My
testing was quite trivial (8 CPU machine):

mount -t cgroup -o cpuset none /mnt/cgroup
mkdir /mnt/cgroup/a
echo 0-5 >  /mnt/cgroup/a/cpuset.cpus
echo 0 > /mnt/cgroup/a/cpuset.mems
for i in `cat /mnt/cgroup/tasks`; do echo $i > /mnt/cgroup/a/tasks; done
[only kernel threads will stay in the root cgroup]
mkdir /mnt/cgroup/b
echo 6,7 >  /mnt/cgroup/a/cpuset.cpus
echo 0 > /mnt/cgroup/a/cpuset.mems
[no task in that group so CPU6,7 should be idle most of the time]

Without the last patch I can see unchanged values for CPU[67] taking up to
several seconds.


This patch:


Get rid of semicolon so that those expressions can be used also somewhere
else than just in an assignment.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Jones <davej@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/cputime.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/cputime.h~cputime-clean-up-cputime_to_usecs-and-usecs_to_cputime-macros include/asm-generic/cputime.h
--- a/include/asm-generic/cputime.h~cputime-clean-up-cputime_to_usecs-and-usecs_to_cputime-macros
+++ a/include/asm-generic/cputime.h
@@ -38,8 +38,8 @@ typedef u64 cputime64_t;
 /*
  * Convert cputime to microseconds and back.
  */
-#define cputime_to_usecs(__ct)		jiffies_to_usecs(__ct);
-#define usecs_to_cputime(__msecs)	usecs_to_jiffies(__msecs);
+#define cputime_to_usecs(__ct)		jiffies_to_usecs(__ct)
+#define usecs_to_cputime(__msecs)	usecs_to_jiffies(__msecs)
 
 /*
  * Convert cputime to seconds and back.
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

