From: akpm@linux-foundation.org
Subject: [folded] arm-move-arm-over-to-generic-on_each_cpu_mask.patch removed from -mm tree
Date: Wed, 28 Mar 2012 14:28:22 -0700
Message-ID: <20120328212823.04754A0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:46153 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932969Ab2C1V2Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 17:28:24 -0400
Received: by yhgm50 with SMTP id m50so192145yhg.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 14:28:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gilad@benyossef.com, a.p.zijlstra@chello.nl, linux@arm.linux.org.uk, mina86@mina86.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: move arm over to generic on_each_cpu_mask
has been removed from the -mm tree.  Its filename was
     arm-move-arm-over-to-generic-on_each_cpu_mask.patch

This patch was dropped because it was folded into smp-introduce-a-generic-on_each_cpu_mask-function.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
Acked-by: Michal Nazarewicz <mina86@mina86.org>

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

Patches currently in -mm which might be from gilad@benyossef.com are

smp-introduce-a-generic-on_each_cpu_mask-function.patch
tile-move-tile-to-use-generic-on_each_cpu_mask.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
fs-only-send-ipi-to-invalidate-lru-bh-when-needed.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-update.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-v9.patch

