Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A364AC10F05
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442955AbjLGAOE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442958AbjLGANt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151EFC9
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:49 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D830EC433CA;
        Thu,  7 Dec 2023 00:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701908028;
        bh=QjMBuDT4uRoDenV6E0rTvrTpcYWGfpIRrDnUHe0wwsg=;
        h=Date:To:From:Subject:From;
        b=t/13e0gUb5N5nds3/82h4Q6KmyHWWi32X800S9lev09r6Ai3ZBJEHS5klUvjvb9ww
         gPiRJ7YgDv5FjF1mLmzB6pBlbVhWNz4QLDNKa9sFMh08lA9GFLX6X//ZoW1e/8R2LV
         HOAj1JYtuvqQoMSTC99ta4DDiVUB/ZNIf8HM/bV4=
Date:   Wed, 06 Dec 2023 16:13:48 -0800
To:     mm-commits@vger.kernel.org, falcon@tinylab.org,
        wangjiexun@tinylab.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-madvise-add-cond_resched-in-madvise_cold_or_pageout_pte_range.patch removed from -mm tree
Message-Id: <20231207001348.D830EC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/madvise: add cond_resched() in madvise_cold_or_pageout_pte_range()
has been removed from the -mm tree.  Its filename was
     mm-madvise-add-cond_resched-in-madvise_cold_or_pageout_pte_range.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiexun Wang <wangjiexun@tinylab.org>
Subject: mm/madvise: add cond_resched() in madvise_cold_or_pageout_pte_range()
Date: Thu, 21 Sep 2023 20:27:51 +0800

I conducted real-time testing and observed that
madvise_cold_or_pageout_pte_range() causes significant latency under
memory pressure, which can be effectively reduced by adding cond_resched()
within the loop.

I tested on the LicheePi 4A board using Cylictest for latency testing and
Ftrace for latency tracing.  The board uses TH1520 processor and has a
memory size of 8GB.  The kernel version is 6.5.0 with the PREEMPT_RT patch
applied.

The script I tested is as follows:

echo wakeup_rt > /sys/kernel/tracing/current_tracer
echo 1 > /sys/kernel/tracing/tracing_on
echo 0 > /sys/kernel/tracing/tracing_max_latency
stress-ng --vm 8 --vm-bytes 2G &
cyclictest --mlockall --smp --priority=99 --distance=0 --duration=30m
echo 0 > /sys/kernel/tracing/tracing_on
cat /sys/kernel/tracing/trace 

The tracing results before modification are as follows:

# tracer: wakeup_rt
#
# wakeup_rt latency trace v1.1.5 on 6.5.0-rt6-r1208-00003-g999d221864bf
# --------------------------------------------------------------------
# latency: 2552 us, #6/6, CPU#3 | (M:preempt_rt VP:0, KP:0, SP:0 HP:0 #P:4)
#    -----------------
#    | task: cyclictest-196 (uid:0 nice:0 policy:1 rt_prio:99)
#    -----------------
#
#                    _--------=> CPU#
#                   / _-------=> irqs-off/BH-disabled
#                  | / _------=> need-resched
#                  || / _-----=> need-resched-lazy
#                  ||| / _----=> hardirq/softirq
#                  |||| / _---=> preempt-depth
#                  ||||| / _--=> preempt-lazy-depth
#                  |||||| / _-=> migrate-disable
#                  ||||||| /     delay
#  cmd     pid     |||||||| time  |   caller
#     \   /        ||||||||  \    |    /
stress-n-206       3dn.h512    2us :      206:120:R   + [003]     196:  0:R cyclictest
stress-n-206       3dn.h512    7us : <stack trace>
 => __ftrace_trace_stack
 => __trace_stack
 => probe_wakeup
 => ttwu_do_activate
 => try_to_wake_up
 => wake_up_process
 => hrtimer_wakeup
 => __hrtimer_run_queues
 => hrtimer_interrupt
 => riscv_timer_interrupt
 => handle_percpu_devid_irq
 => generic_handle_domain_irq
 => riscv_intc_irq
 => handle_riscv_irq
 => do_irq
stress-n-206       3dn.h512    9us#: 0
stress-n-206       3d...3.. 2544us : __schedule
stress-n-206       3d...3.. 2545us :      206:120:R ==> [003]     196:  0:R cyclictest
stress-n-206       3d...3.. 2551us : <stack trace>
 => __ftrace_trace_stack
 => __trace_stack
 => probe_wakeup_sched_switch
 => __schedule
 => preempt_schedule
 => migrate_enable
 => rt_spin_unlock
 => madvise_cold_or_pageout_pte_range
 => walk_pgd_range
 => __walk_page_range
 => walk_page_range
 => madvise_pageout
 => madvise_vma_behavior
 => do_madvise
 => sys_madvise
 => do_trap_ecall_u
 => ret_from_exception

The tracing results after modification are as follows:

# tracer: wakeup_rt
#
# wakeup_rt latency trace v1.1.5 on 6.5.0-rt6-r1208-00004-gca3876fc69a6-dirty
# --------------------------------------------------------------------
# latency: 1689 us, #6/6, CPU#0 | (M:preempt_rt VP:0, KP:0, SP:0 HP:0 #P:4)
#    -----------------
#    | task: cyclictest-217 (uid:0 nice:0 policy:1 rt_prio:99)
#    -----------------
#
#                    _--------=> CPU#
#                   / _-------=> irqs-off/BH-disabled
#                  | / _------=> need-resched
#                  || / _-----=> need-resched-lazy
#                  ||| / _----=> hardirq/softirq
#                  |||| / _---=> preempt-depth
#                  ||||| / _--=> preempt-lazy-depth
#                  |||||| / _-=> migrate-disable
#                  ||||||| /     delay
#  cmd     pid     |||||||| time  |   caller
#     \   /        ||||||||  \    |    /
stress-n-232       0dn.h413    1us+:      232:120:R   + [000]     217:  0:R cyclictest
stress-n-232       0dn.h413   12us : <stack trace>
 => __ftrace_trace_stack
 => __trace_stack
 => probe_wakeup
 => ttwu_do_activate
 => try_to_wake_up
 => wake_up_process
 => hrtimer_wakeup
 => __hrtimer_run_queues
 => hrtimer_interrupt
 => riscv_timer_interrupt
 => handle_percpu_devid_irq
 => generic_handle_domain_irq
 => riscv_intc_irq
 => handle_riscv_irq
 => do_irq
stress-n-232       0dn.h413   19us#: 0
stress-n-232       0d...3.. 1671us : __schedule
stress-n-232       0d...3.. 1676us+:      232:120:R ==> [000]     217:  0:R cyclictest
stress-n-232       0d...3.. 1687us : <stack trace>
 => __ftrace_trace_stack
 => __trace_stack
 => probe_wakeup_sched_switch
 => __schedule
 => preempt_schedule
 => migrate_enable
 => free_unref_page_list
 => release_pages
 => free_pages_and_swap_cache
 => tlb_batch_pages_flush
 => tlb_flush_mmu
 => unmap_page_range
 => unmap_vmas
 => unmap_region
 => do_vmi_align_munmap.constprop.0
 => do_vmi_munmap
 => __vm_munmap
 => sys_munmap
 => do_trap_ecall_u
 => ret_from_exception

After the modification, the cause of maximum latency is no longer
madvise_cold_or_pageout_pte_range(), so this modification can reduce the
latency caused by madvise_cold_or_pageout_pte_range().


Currently the madvise_cold_or_pageout_pte_range() function exhibits
significant latency under memory pressure, which can be effectively
reduced by adding cond_resched() within the loop.

When the batch_count reaches SWAP_CLUSTER_MAX, we reschedule
the task to ensure fairness and avoid long lock holding times.

Link: https://lkml.kernel.org/r/85363861af65fac66c7a98c251906afc0d9c8098.1695291046.git.wangjiexun@tinylab.org
Signed-off-by: Jiexun Wang <wangjiexun@tinylab.org>
Cc: Zhangjin Wu <falcon@tinylab.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/madvise.c~mm-madvise-add-cond_resched-in-madvise_cold_or_pageout_pte_range
+++ a/mm/madvise.c
@@ -335,6 +335,7 @@ static int madvise_cold_or_pageout_pte_r
 	struct folio *folio = NULL;
 	LIST_HEAD(folio_list);
 	bool pageout_anon_only_filter;
+	unsigned int batch_count = 0;
 
 	if (fatal_signal_pending(current))
 		return -EINTR;
@@ -416,6 +417,7 @@ huge_unlock:
 regular_folio:
 #endif
 	tlb_change_page_size(tlb, PAGE_SIZE);
+restart:
 	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	if (!start_pte)
 		return 0;
@@ -424,6 +426,15 @@ regular_folio:
 	for (; addr < end; pte++, addr += PAGE_SIZE) {
 		ptent = ptep_get(pte);
 
+		if (++batch_count == SWAP_CLUSTER_MAX) {
+			batch_count = 0;
+			if (need_resched()) {
+				pte_unmap_unlock(start_pte, ptl);
+				cond_resched();
+				goto restart;
+			}
+		}
+
 		if (pte_none(ptent))
 			continue;
 
_

Patches currently in -mm which might be from wangjiexun@tinylab.org are


