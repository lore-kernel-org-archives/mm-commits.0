From: akpm@linux-foundation.org
Subject: + gcc-46-perf-fix-set-but-unused-variables-in-perf.patch added to -mm tree
Date: Fri, 18 Jun 2010 16:31:21 -0700
Message-ID: <201006182331.o5INVLau029524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097Ab0FRXbw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 19:31:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, a.p.zijlstra@chello.nl, ak@linux.intel.com, mingo@elte.hu


The patch titled
     gcc-4.6: perf: fix set but unused variables in perf
has been added to the -mm tree.  Its filename is
     gcc-46-perf-fix-set-but-unused-variables-in-perf.patch

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
Subject: gcc-4.6: perf: fix set but unused variables in perf
From: Andi Kleen <andi@firstfloor.org>

Just dead code I believe

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/perf_event.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN arch/x86/kernel/cpu/perf_event.c~gcc-46-perf-fix-set-but-unused-variables-in-perf arch/x86/kernel/cpu/perf_event.c
--- a/arch/x86/kernel/cpu/perf_event.c~gcc-46-perf-fix-set-but-unused-variables-in-perf
+++ a/arch/x86/kernel/cpu/perf_event.c
@@ -953,12 +953,9 @@ static void x86_pmu_enable_event(struct 
 static int x86_pmu_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct hw_perf_event *hwc;
 	int assign[X86_PMC_IDX_MAX];
 	int n, n0, ret;
 
-	hwc = &event->hw;
-
 	n0 = cpuc->n_events;
 	n = collect_events(cpuc, event, false);
 	if (n < 0)
@@ -1122,7 +1119,6 @@ static int x86_pmu_handle_irq(struct pt_
 	struct perf_sample_data data;
 	struct cpu_hw_events *cpuc;
 	struct perf_event *event;
-	struct hw_perf_event *hwc;
 	int idx, handled = 0;
 	u64 val;
 
@@ -1135,7 +1131,6 @@ static int x86_pmu_handle_irq(struct pt_
 			continue;
 
 		event = cpuc->events[idx];
-		hwc = &event->hw;
 
 		val = x86_perf_event_update(event);
 		if (val & (1ULL << (x86_pmu.cntval_bits - 1)))
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
modpost-support-objects-with-more-than-64k-sections.patch
kernelh-add-hw_err-printk-prefix-for-hardware-error-logging.patch
x86-use-hw_err-in-mce-handler.patch
gcc-46-irq-move-alloc_desk_mask-variables-inside-ifdef.patch
gcc-46-x86-avoid-unused-by-set-variables-in-rdmsr.patch
gcc-46-pagemap-avoid-unused-but-set-variable.patch
gcc-46-perf-fix-set-but-unused-variables-in-perf.patch
gcc-46-x86-fix-set-but-not-read-variables.patch
gcc-46-kgdb-remove-set-but-unused-newpc.patch
gcc-46-printk-use-stable-variable-to-dump-kmsg-buffer.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
gcc-46-btrfs-clean-up-unused-variables-nonbugs.patch
gcc-46-nfsd-fix-initialized-but-not-read-warnings.patch
gcc-46-acpi-fix-unused-but-set-variables-in-acpi.patch
gcc-46-mm-fix-unused-but-set-warnings.patch
gcc-46-kernel-fix-unused-but-set-warnings.patch
gcc-46-block-fix-unused-but-set-variables-in-blk-merge.patch
gcc-46-fs-fix-unused-but-set-warnings.patch

