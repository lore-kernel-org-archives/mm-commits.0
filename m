From: akpm@linux-foundation.org
Subject: + arm-move-arm-over-to-generic-on_each_cpu_mask.patch added to -mm tree
Date: Fri, 27 Jan 2012 16:15:39 -0800
Message-ID: <20120128001539.CF6F7A043A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:62652 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab2A1APm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jan 2012 19:15:42 -0500
Received: by werb13 with SMTP id b13so141805wer.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2012 16:15:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gilad@benyossef.com, a.p.zijlstra@chello.nl, linux@arm.linux.org.uk


The patch titled
     Subject: arm: move arm over to generic on_each_cpu_mask
has been added to the -mm tree.  Its filename is
     arm-move-arm-over-to-generic-on_each_cpu_mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: arm: move arm over to generic on_each_cpu_mask

Note that the generic version is a little different then the Arm one:

1. It has the mask as first parameter
2. It calls the function on the calling CPU with interrupts disabled,
   but this should be OK since the function is called on the other CPUs
   with interrupts disabled anyway.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Russell King <linux@arm.linux.org.uk>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/smp_tlb.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff -puN arch/arm/kernel/smp_tlb.c~arm-move-arm-over-to-generic-on_each_cpu_mask arch/arm/kernel/smp_tlb.c
--- a/arch/arm/kernel/smp_tlb.c~arm-move-arm-over-to-generic-on_each_cpu_mask
+++ a/arch/arm/kernel/smp_tlb.c
@@ -13,18 +13,6 @@
 #include <asm/smp_plat.h>
 #include <asm/tlbflush.h>
 
-static void on_each_cpu_mask(void (*func)(void *), void *info, int wait,
-	const struct cpumask *mask)
-{
-	preempt_disable();
-
-	smp_call_function_many(mask, func, info, wait);
-	if (cpumask_test_cpu(smp_processor_id(), mask))
-		func(info);
-
-	preempt_enable();
-}
-
 /**********************************************************************/
 
 /*
@@ -87,7 +75,7 @@ void flush_tlb_all(void)
 void flush_tlb_mm(struct mm_struct *mm)
 {
 	if (tlb_ops_need_broadcast())
-		on_each_cpu_mask(ipi_flush_tlb_mm, mm, 1, mm_cpumask(mm));
+		on_each_cpu_mask(mm_cpumask(mm), ipi_flush_tlb_mm, mm, 1);
 	else
 		local_flush_tlb_mm(mm);
 }
@@ -98,7 +86,8 @@ void flush_tlb_page(struct vm_area_struc
 		struct tlb_args ta;
 		ta.ta_vma = vma;
 		ta.ta_start = uaddr;
-		on_each_cpu_mask(ipi_flush_tlb_page, &ta, 1, mm_cpumask(vma->vm_mm));
+		on_each_cpu_mask(mm_cpumask(vma->vm_mm), ipi_flush_tlb_page,
+					&ta, 1);
 	} else
 		local_flush_tlb_page(vma, uaddr);
 }
@@ -121,7 +110,8 @@ void flush_tlb_range(struct vm_area_stru
 		ta.ta_vma = vma;
 		ta.ta_start = start;
 		ta.ta_end = end;
-		on_each_cpu_mask(ipi_flush_tlb_range, &ta, 1, mm_cpumask(vma->vm_mm));
+		on_each_cpu_mask(mm_cpumask(vma->vm_mm), ipi_flush_tlb_range,
+					&ta, 1);
 	} else
 		local_flush_tlb_range(vma, start, end);
 }
_
Subject: Subject: arm: move arm over to generic on_each_cpu_mask

Patches currently in -mm which might be from gilad@benyossef.com are

smp-introduce-a-generic-on_each_cpu_mask-function.patch
arm-move-arm-over-to-generic-on_each_cpu_mask.patch
tile-move-tile-to-use-generic-on_each_cpu_mask.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
fs-only-send-ipi-to-invalidate-lru-bh-when-needed.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch

