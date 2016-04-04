From: akpm@linux-foundation.org
Subject: [merged]
 mm-rmap-batched-invalidations-should-use-existing-api.patch removed from
 -mm tree
Date: Mon, 04 Apr 2016 11:09:43 -0700
Message-ID: <5702ade7.Maf/TNVVvyDhfNRE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbcDDSJo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2016 14:09:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namit@vmware.com, dave.hansen@intel.com, mgorman@suse.de, mingo@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: batched invalidations should use existing api
has been removed from the -mm tree.  Its filename was
     mm-rmap-batched-invalidations-should-use-existing-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nadav Amit <namit@vmware.com>
Subject: mm/rmap: batched invalidations should use existing api

The recently introduced batched invalidations mechanism uses its own
mechanism for shootdown.  However, it does wrong accounting of interrupts
(e.g., inc_irq_stat is called for local invalidations), trace-points
(e.g., TLB_REMOTE_SHOOTDOWN for local invalidations) and may break some
platforms as it bypasses the invalidation mechanisms of Xen and SGI UV.

This patch reuses the existing TLB flushing mechnaisms instead.  We use
NULL as mm to indicate a global invalidation is required.

Fixes 72b252aed506b8 ("mm: send one IPI per CPU to TLB flush all entries after unmapping pages")
Signed-off-by: Nadav Amit <namit@vmware.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/tlbflush.h |    6 ------
 arch/x86/mm/tlb.c               |    2 +-
 mm/rmap.c                       |   28 +++++++---------------------
 3 files changed, 8 insertions(+), 28 deletions(-)

diff -puN arch/x86/include/asm/tlbflush.h~mm-rmap-batched-invalidations-should-use-existing-api arch/x86/include/asm/tlbflush.h
--- a/arch/x86/include/asm/tlbflush.h~mm-rmap-batched-invalidations-should-use-existing-api
+++ a/arch/x86/include/asm/tlbflush.h
@@ -319,12 +319,6 @@ static inline void reset_lazy_tlbstate(v
 
 #endif	/* SMP */
 
-/* Not inlined due to inc_irq_stat not being defined yet */
-#define flush_tlb_local() {		\
-	inc_irq_stat(irq_tlb_count);	\
-	local_flush_tlb();		\
-}
-
 #ifndef CONFIG_PARAVIRT
 #define flush_tlb_others(mask, mm, start, end)	\
 	native_flush_tlb_others(mask, mm, start, end)
diff -puN arch/x86/mm/tlb.c~mm-rmap-batched-invalidations-should-use-existing-api arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c~mm-rmap-batched-invalidations-should-use-existing-api
+++ a/arch/x86/mm/tlb.c
@@ -104,7 +104,7 @@ static void flush_tlb_func(void *info)
 
 	inc_irq_stat(irq_tlb_count);
 
-	if (f->flush_mm != this_cpu_read(cpu_tlbstate.active_mm))
+	if (f->flush_mm && f->flush_mm != this_cpu_read(cpu_tlbstate.active_mm))
 		return;
 
 	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
diff -puN mm/rmap.c~mm-rmap-batched-invalidations-should-use-existing-api mm/rmap.c
--- a/mm/rmap.c~mm-rmap-batched-invalidations-should-use-existing-api
+++ a/mm/rmap.c
@@ -569,19 +569,6 @@ void page_unlock_anon_vma_read(struct an
 }
 
 #ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
-static void percpu_flush_tlb_batch_pages(void *data)
-{
-	/*
-	 * All TLB entries are flushed on the assumption that it is
-	 * cheaper to flush all TLBs and let them be refilled than
-	 * flushing individual PFNs. Note that we do not track mm's
-	 * to flush as that might simply be multiple full TLB flushes
-	 * for no gain.
-	 */
-	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
-	flush_tlb_local();
-}
-
 /*
  * Flush TLB entries for recently unmapped pages from remote CPUs. It is
  * important if a PTE was dirty when it was unmapped that it's flushed
@@ -598,15 +585,14 @@ void try_to_unmap_flush(void)
 
 	cpu = get_cpu();
 
-	trace_tlb_flush(TLB_REMOTE_SHOOTDOWN, -1UL);
-
-	if (cpumask_test_cpu(cpu, &tlb_ubc->cpumask))
-		percpu_flush_tlb_batch_pages(&tlb_ubc->cpumask);
