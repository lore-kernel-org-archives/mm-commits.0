From: akpm@linux-foundation.org
Subject: [merged] mm-vmstats-tlb-flush-counters.patch removed from -mm
 tree
Date: Thu, 12 Sep 2013 12:42:27 -0700
Message-ID: <52321923.5evcYSGkzmBZFBtL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3ILTm2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, dave.hansen@linux.intel.com, a.p.zijlstra@chello.nl, dave@sr71.net

Subject: [merged] mm-vmstats-tlb-flush-counters.patch removed from -mm tree
To: dave@sr71.net,a.p.zijlstra@chello.nl,dave.hansen@linux.intel.com,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:27 -0700


The patch titled
     Subject: mm: vmstats: tlb flush counters
has been removed from the -mm tree.  Its filename was
     mm-vmstats-tlb-flush-counters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Hansen <dave@sr71.net>
Subject: mm: vmstats: tlb flush counters

I was investigating some TLB flush scaling issues and realized that we do
not have any good methods for figuring out how many TLB flushes we are
doing.

It would be nice to be able to do these in generic code, but the
arch-independent calls don't explicitly specify whether we actually need
to do remote flushes or not.  In the end, we really need to know if we
actually _did_ global vs.  local invalidations, so that leaves us with few
options other than to muck with the counters from arch-specific code.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/tlb.c             |   18 ++++++++++++++----
 include/linux/vm_event_item.h |    5 +++++
 mm/vmstat.c                   |    5 +++++
 3 files changed, 24 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/tlb.c~mm-vmstats-tlb-flush-counters arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c~mm-vmstats-tlb-flush-counters
+++ a/arch/x86/mm/tlb.c
@@ -103,6 +103,7 @@ static void flush_tlb_func(void *info)
 	if (f->flush_mm != this_cpu_read(cpu_tlbstate.active_mm))
 		return;
 
+	count_vm_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
 	if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
 		if (f->flush_end == TLB_FLUSH_ALL)
 			local_flush_tlb();
@@ -130,6 +131,7 @@ void native_flush_tlb_others(const struc
 	info.flush_start = start;
 	info.flush_end = end;
 
+	count_vm_event(NR_TLB_REMOTE_FLUSH);
 	if (is_uv_system()) {
 		unsigned int cpu;
 
@@ -149,6 +151,7 @@ void flush_tlb_current_task(void)
 
 	preempt_disable();
 
+	count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
 	local_flush_tlb();
 	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
 		flush_tlb_others(mm_cpumask(mm), mm, 0UL, TLB_FLUSH_ALL);
@@ -211,16 +214,19 @@ void flush_tlb_mm_range(struct mm_struct
 	act_entries = mm->total_vm > tlb_entries ? tlb_entries : mm->total_vm;
 
 	/* tlb_flushall_shift is on balance point, details in commit log */
-	if ((end - start) >> PAGE_SHIFT > act_entries >> tlb_flushall_shift)
+	if ((end - start) >> PAGE_SHIFT > act_entries >> tlb_flushall_shift) {
+		count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
 		local_flush_tlb();
-	else {
+	} else {
 		if (has_large_page(mm, start, end)) {
 			local_flush_tlb();
 			goto flush_all;
 		}
 		/* flush range by one by one 'invlpg' */
-		for (addr = start; addr < end;	addr += PAGE_SIZE)
+		for (addr = start; addr < end;	addr += PAGE_SIZE) {
+			count_vm_event(NR_TLB_LOCAL_FLUSH_ONE);
 			__flush_tlb_single(addr);
+		}
 
 		if (cpumask_any_but(mm_cpumask(mm),
 				smp_processor_id()) < nr_cpu_ids)
@@ -256,6 +262,7 @@ void flush_tlb_page(struct vm_area_struc
 
 static void do_flush_tlb_all(void *info)
 {
+	count_vm_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
 	__flush_tlb_all();
 	if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
 		leave_mm(smp_processor_id());
@@ -263,6 +270,7 @@ static void do_flush_tlb_all(void *info)
 
 void flush_tlb_all(void)
 {
+	count_vm_event(NR_TLB_REMOTE_FLUSH);
 	on_each_cpu(do_flush_tlb_all, NULL, 1);
 }
 
@@ -272,8 +280,10 @@ static void do_kernel_range_flush(void *
 	unsigned long addr;
 
 	/* flush range by one by one 'invlpg' */
-	for (addr = f->flush_start; addr < f->flush_end; addr += PAGE_SIZE)
+	for (addr = f->flush_start; addr < f->flush_end; addr += PAGE_SIZE) {
+		count_vm_event(NR_TLB_LOCAL_FLUSH_ONE_KERNEL);
 		__flush_tlb_single(addr);
+	}
 }
 
 void flush_tlb_kernel_range(unsigned long start, unsigned long end)
diff -puN include/linux/vm_event_item.h~mm-vmstats-tlb-flush-counters include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-vmstats-tlb-flush-counters
+++ a/include/linux/vm_event_item.h
@@ -70,6 +70,11 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_ZERO_PAGE_ALLOC,
 		THP_ZERO_PAGE_ALLOC_FAILED,
 #endif
+		NR_TLB_REMOTE_FLUSH,	/* cpu tried to flush others' tlbs */
+		NR_TLB_REMOTE_FLUSH_RECEIVED,/* cpu received ipi for flush */
+		NR_TLB_LOCAL_FLUSH_ALL,
+		NR_TLB_LOCAL_FLUSH_ONE,
+		NR_TLB_LOCAL_FLUSH_ONE_KERNEL,
 		NR_VM_EVENT_ITEMS
 };
 
diff -puN mm/vmstat.c~mm-vmstats-tlb-flush-counters mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstats-tlb-flush-counters
+++ a/mm/vmstat.c
@@ -817,6 +817,11 @@ const char * const vmstat_text[] = {
 	"thp_zero_page_alloc",
 	"thp_zero_page_alloc_failed",
 #endif
+	"nr_tlb_remote_flush",
+	"nr_tlb_remote_flush_received",
+	"nr_tlb_local_flush_all",
+	"nr_tlb_local_flush_one",
+	"nr_tlb_local_flush_one_kernel",
 
 #endif /* CONFIG_VM_EVENTS_COUNTERS */
 };
_

Patches currently in -mm which might be from dave@sr71.net are

origin.patch

