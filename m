From: akpm@linux-foundation.org
Subject: - i386-cleanup-flush_tlb_others-fn.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:55:23 -0700
Message-ID: <200704281055.l3SAtNMS020173@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965749AbXD1Kz2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:55:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anil.s.keshavamurthy@intel.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386: clean up flush_tlb_others fn
has been removed from the -mm tree.  Its filename was
     i386-cleanup-flush_tlb_others-fn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -383,17 +383,7 @@ void native_flush_tlb_others(const cpuma
 	
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

kprobes-print-details-of-kretprobe-on-assertion-failure.patch
kprobes-use-hlist_for_each_entry.patch
kprobes-codingstyle-cleanups.patch
kprobes-kretprobes-simplifcations.patch
