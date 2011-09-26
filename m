From: akpm@google.com
Subject: + x86-tlb-flush-avoid-superflous-leave_mm.patch added to -mm tree
Date: Mon, 26 Sep 2011 15:54:24 -0700
Message-ID: <201109262254.p8QMsTrp006783@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:17641 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab1IZWyr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2011 18:54:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de


The patch titled
     Subject: x86: tlb flush avoid superflous leave_mm()
has been added to the -mm tree.  Its filename is
     x86-tlb-flush-avoid-superflous-leave_mm.patch

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
From: Shaohua Li <shaohua.li@intel.com>
Subject: x86: tlb flush avoid superflous leave_mm()

If just one page VA tlb is required to be flushed and current task is in
lazy TLB state, doing leave_mm() is superfluous because it flushes the
whole TLB.  This can reduce some TLB miss.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 arch/x86/mm/tlb.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN arch/x86/mm/tlb.c~x86-tlb-flush-avoid-superflous-leave_mm arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c~x86-tlb-flush-avoid-superflous-leave_mm
+++ a/arch/x86/mm/tlb.c
@@ -155,13 +155,13 @@ void smp_invalidate_interrupt(struct pt_
 		 */
 
 	if (f->flush_mm == percpu_read(cpu_tlbstate.active_mm)) {
-		if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
-			if (f->flush_va == TLB_FLUSH_ALL)
+		if (f->flush_va == TLB_FLUSH_ALL) {
+			if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
 				local_flush_tlb();
 			else
-				__flush_tlb_one(f->flush_va);
+				leave_mm(cpu);
 		} else
-			leave_mm(cpu);
+			__flush_tlb_one(f->flush_va);
 	}
 out:
 	ack_APIC_irq();
@@ -309,12 +309,8 @@ void flush_tlb_page(struct vm_area_struc
 
 	preempt_disable();
 
-	if (current->active_mm == mm) {
-		if (current->mm)
-			__flush_tlb_one(va);
-		else
-			leave_mm(smp_processor_id());
-	}
+	if (current->active_mm == mm)
+		__flush_tlb_one(va);
 
 	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
 		flush_tlb_others(mm_cpumask(mm), mm, va);
_
Subject: Subject: x86: tlb flush avoid superflous leave_mm()

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
x86-tlb-flush-avoid-superflous-leave_mm.patch
vmscan-add-block-plug-for-page-reclaim.patch
vmscan-count-pages-into-balanced-for-zone-with-good-watermark.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch

