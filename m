From: akpm@linux-foundation.org
Subject: + i386-cleanup-flush_tlb_others-fn.patch added to -mm tree
Date: Sat, 07 Apr 2007 00:37:17 -0700
Message-ID: <200704070737.l377bH4o030088@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46872 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965475AbXDGHhW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 03:37:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anil.s.keshavamurthy@intel.com, ak@suse.de


The patch titled
     i386: clean up flush_tlb_others fn
has been added to the -mm tree.  Its filename is
     i386-cleanup-flush_tlb_others-fn.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: clean up flush_tlb_others fn
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

Cleanup flush_tlb_others(), no functional change.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/smp.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN arch/i386/kernel/smp.c~i386-cleanup-flush_tlb_others-fn arch/i386/kernel/smp.c
--- a/arch/i386/kernel/smp.c~i386-cleanup-flush_tlb_others-fn
+++ a/arch/i386/kernel/smp.c
@@ -382,17 +382,7 @@ static void flush_tlb_others(cpumask_t c
 	
 	flush_mm = mm;
 	flush_va = va;
-#if NR_CPUS <= BITS_PER_LONG
-	atomic_set_mask(cpumask, &flush_cpumask);
-#else
-	{
-		int k;
-		unsigned long *flush_mask = (unsigned long *)&flush_cpumask;
-		unsigned long *cpu_mask = (unsigned long *)&cpumask;
-		for (k = 0; k < BITS_TO_LONGS(NR_CPUS); ++k)
-			atomic_set_mask(cpu_mask[k], &flush_mask[k]);
-	}
-#endif
+	cpus_or(flush_cpumask, cpumask, flush_cpumask);
 	/*
 	 * We have to send the IPI only to
 	 * CPUs affected.
_

Patches currently in -mm which might be from anil.s.keshavamurthy@intel.com are

i386-avoid-checking-for-cpu-gone-when-config_hotplug_cpu-not-defined.patch
i386-cleanup-flush_tlb_others-fn.patch
kprobes-print-details-of-kretprobe-on-assertion-failure.patch
kprobes-use-hlist_for_each_entry.patch
kprobes-codingstyle-cleanups.patch
kprobes-kretprobes-simplifcations.patch
