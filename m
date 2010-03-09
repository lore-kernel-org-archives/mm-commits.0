From: akpm@linux-foundation.org
Subject: + mm-do-not-iterate-over-nr_cpus-in-__zone_pcp_update.patch added to -mm tree
Date: Tue, 09 Mar 2010 12:23:06 -0800
Message-ID: <201003092023.o29KN6GL003003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754383Ab0CIUYJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 15:24:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, penberg@cs.helsinki.fi, tj@kernel.org


The patch titled
     mm: do not iterate over NR_CPUS in __zone_pcp_update()
has been added to the -mm tree.  Its filename is
     mm-do-not-iterate-over-nr_cpus-in-__zone_pcp_update.patch

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
Subject: mm: do not iterate over NR_CPUS in __zone_pcp_update()
From: Thomas Gleixner <tglx@linutronix.de>

__zone_pcp_update() iterates over NR_CPUS instead of limiting the access
to the possible cpus.  This might result in access to uninitialized areas
as the per cpu allocator only populates the per cpu memory for possible
cpus.

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
@@ -3243,7 +3243,7 @@ static int __zone_pcp_update(void *data)
 	int cpu;
 	unsigned long batch = zone_batchsize(zone), flags;
 
-	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+	for_each_possible_cpu(cpu) {
 		struct per_cpu_pageset *pset;
 		struct per_cpu_pages *pcp;
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

linux-next.patch
mm-do-not-iterate-over-nr_cpus-in-__zone_pcp_update.patch
arch-x86-kernel-rebootc-add-imac91-to-pci_reboot_dmi_table.patch
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
core-kernel-make-sparse-work-with-inline-spinlocks-and-rwlocks.patch
kernel-irq-procc-expose-the-irq_desc-node-in-proc-irq.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch
genirq-introduce-irqf_allow_nested-flag-for-request_irq.patch
xtensa-fix-unnecessary-setting-of-xtime.patch
add-generic-sys_old_select.patch
add-generic-sys_old_mmap.patch
add-generic-sys_ipc-wrapper.patch
add-generic-sys_ipc-wrapper-fix.patch
improve-sys_personality-for-compat-architectures.patch
improve-sys_newuname-for-compat-architectures.patch
add-generic-sys_olduname.patch
documentation-timers-split-txt-and-source-files.patch
sysctl-extern-cleanup-rtmutex.patch
sysctl-extern-cleanup-lockdep.patch
pci-dma-add-include-linux-pci-dmah.patch
pci-dma-x86-use-include-linux-pci-dmah.patch
time-kill-off-config_generic_time.patch

