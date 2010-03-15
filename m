From: akpm@linux-foundation.org
Subject: [merged] mm-do-not-iterate-over-nr_cpus-in-__zone_pcp_update.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:52:51 -0400
Message-ID: <201003150653.o2F6rO8t015993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759709Ab0COGyF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:54:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, penberg@cs.helsinki.fi, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: do not iterate over NR_CPUS in __zone_pcp_update()
has been removed from the -mm tree.  Its filename was
     mm-do-not-iterate-over-nr_cpus-in-__zone_pcp_update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: do not iterate over NR_CPUS in __zone_pcp_update()
From: Thomas Gleixner <tglx@linutronix.de>

__zone_pcp_update() iterates over NR_CPUS instead of limiting the access
to the possible cpus.  This might result in access to uninitialized areas
as the per cpu allocator only populates the per cpu memory for possible
cpus.

This problem was created as a result of the dynamic allocation of pagesets
from percpu memory that went in during the merge window - commit
99dcc3e5a94ed491fbef402831d8c0bbb267f995 ("this_cpu: Page allocator
conversion").

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-do-not-iterate-over-nr_cpus-in-__zone_pcp_update mm/page_alloc.c
--- a/mm/page_alloc.c~mm-do-not-iterate-over-nr_cpus-in-__zone_pcp_update
+++ a/mm/page_alloc.c
@@ -3224,7 +3224,7 @@ static int __zone_pcp_update(void *data)
 	int cpu;
 	unsigned long batch = zone_batchsize(zone), flags;
 
-	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+	for_each_possible_cpu(cpu) {
 		struct per_cpu_pageset *pset;
 		struct per_cpu_pages *pcp;
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
linux-next.patch
arch-x86-kernel-hpetc-fix-bug-in-rtc-emulation.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
timers-introduce-the-concept-of-timer-slack-for-legacy-timers.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
cs5535-clockevt-free-timer-in-irq-setup-error-path.patch
timer-print-function-name-for-timer-callbacks-modifying-preemption-count.patch
time-clean-up-warp_clock.patch
time-clean-up-direct-xtime-usage-in-xen.patch
kernel-irq-procc-expose-the-irq_desc-node-in-proc-irq.patch
genirq-introduce-irqf_allow_nested-flag-for-request_irq.patch
xtensa-fix-unnecessary-setting-of-xtime.patch
sparsemem-on-no-vmemmap-path-put-mem_map-on-node-high-too.patch
improve-sys_personality-for-compat-architectures.patch
time-kill-off-config_generic_time.patch

