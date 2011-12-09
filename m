From: akpm@linux-foundation.org
Subject: [merged] proc-do-not-overflow-get_idleiowait_time-for-nohz.patch removed from -mm tree
Date: Fri, 09 Dec 2011 12:08:41 -0800
Message-ID: <201112092008.pB9K8f8u014816@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:51009 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab1LIUIn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 15:08:43 -0500
Received: by yenm5 with SMTP id m5so433165yen.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 12:08:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, adobriyan@gmail.com, arnd@arndb.de, davej@redhat.com, t.artem@mailcity.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: do not overflow get_{idle,iowait}_time for nohz
has been removed from the -mm tree.  Its filename was
     proc-do-not-overflow-get_idleiowait_time-for-nohz.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: procfs: do not overflow get_{idle,iowait}_time for nohz

Since a25cac51 ("proc: Consider NO_HZ when printing idle and iowait
times") we are reporting idle/io_wait time also while a CPU is tickless. 
We rely on get_{idle,iowait}_time functions to retrieve proper data.

These functions, however, use usecs_to_cputime to translate micro seconds
time to cputime64_t.  This is just an alias to usecs_to_jiffies which
reduces the data type from u64 to unsigned int and also checks whether the
given parameter overflows jiffies_to_usecs(MAX_JIFFY_OFFSET) and returns
MAX_JIFFY_OFFSET in that case.

When do we overflow depends on CONFIG_HZ but especially for CONFIG_HZ_300
it is quite low (1431649781) so we are getting MAX_JIFFY_OFFSET for
>3000s!  until we overflow unsigned int.  Just for reference CONFIG_HZ_100
has an overflow window around 20s, CONFIG_HZ_250 ~8s and CONFIG_HZ_1000
~2s.

This results in a bug when people saw [h]top going mad reporting 100% CPU
usage even though there was basically no CPU load.  The reason was simply
that /proc/stat stopped reporting idle/io_wait changes (and reported
MAX_JIFFY_OFFSET) and so the only change happening was for user system
time.

Let's use nsecs_to_jiffies64 instead which doesn't reduce the precision to
32b type and it is much more appropriate for cumulative time values
(unlike usecs_to_jiffies which intended for timeout calculations).

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Tested-by: Artem S. Tashkinov <t.artem@mailcity.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/stat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/stat.c~proc-do-not-overflow-get_idleiowait_time-for-nohz fs/proc/stat.c
--- a/fs/proc/stat.c~proc-do-not-overflow-get_idleiowait_time-for-nohz
+++ a/fs/proc/stat.c
@@ -32,7 +32,7 @@ static cputime64_t get_idle_time(int cpu
 		idle = kstat_cpu(cpu).cpustat.idle;
 		idle = cputime64_add(idle, arch_idle_time(cpu));
 	} else
-		idle = usecs_to_cputime(idle_time);
+		idle = nsecs_to_jiffies64(1000 * idle_time);
 
 	return idle;
 }
@@ -46,7 +46,7 @@ static cputime64_t get_iowait_time(int c
 		/* !NO_HZ so we can rely on cpustat.iowait */
 		iowait = kstat_cpu(cpu).cpustat.iowait;
 	else
-		iowait = usecs_to_cputime(iowait_time);
+		iowait = nsecs_to_jiffies64(1000 * iowait_time);
 
 	return iowait;
 }
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
linux-next.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-writeback-cleanups-in-preparation-for-per-zone-dirty-limits.patch
mm-try-to-distribute-dirty-pages-fairly-across-zones.patch
mm-filemap-pass-__gfp_write-from-grab_cache_page_write_begin.patch
btrfs-pass-__gfp_write-for-buffered-write-page-allocations.patch
mm-fix-off-by-two-in-__zone_watermark_ok.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
memcg-fix-pgpgin-pgpgout-documentation.patch
mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch
mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch
mm-memcg-clean-up-fault-accounting.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch
mm-memcg-remove-unneeded-checks-from-newpage_charge.patch
mm-memcg-remove-unneeded-checks-from-uncharge_page.patch
page_cgroup-add-helper-function-to-get-swap_cgroup.patch

