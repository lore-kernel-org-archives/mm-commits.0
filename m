From: akpm@linux-foundation.org
Subject: - yet-another-function-to-load-cr3-register.patch removed from -mm tree
Date: Wed, 28 Mar 2007 13:29:19 -0700
Message-ID: <200703282029.l2SKTK2B019367@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58548 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965786AbXC1U3c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 16:29:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gcosta@redhat.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Yet another function to load cr3 register
has been removed from the -mm tree.  Its filename was
     yet-another-function-to-load-cr3-register.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Yet another function to load cr3 register
From: Glauber de Oliveira Costa <gcosta@redhat.com>

There is (was) yet another function to load something into
the cr3 register. We don't need it.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/smp.c         |    2 +-
 include/asm-x86_64/mmu_context.h |    9 ++-------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff -puN arch/x86_64/kernel/smp.c~yet-another-function-to-load-cr3-register arch/x86_64/kernel/smp.c
--- a/arch/x86_64/kernel/smp.c~yet-another-function-to-load-cr3-register
+++ a/arch/x86_64/kernel/smp.c
@@ -76,7 +76,7 @@ static inline void leave_mm(int cpu)
 	if (read_pda(mmu_state) == TLBSTATE_OK)
 		BUG();
 	cpu_clear(cpu, read_pda(active_mm)->cpu_vm_mask);
-	load_cr3(swapper_pg_dir);
+	write_cr3(__pa(swapper_pg_dir));
 }
 
 /*
diff -puN include/asm-x86_64/mmu_context.h~yet-another-function-to-load-cr3-register include/asm-x86_64/mmu_context.h
--- a/include/asm-x86_64/mmu_context.h~yet-another-function-to-load-cr3-register
+++ a/include/asm-x86_64/mmu_context.h
@@ -22,11 +22,6 @@ static inline void enter_lazy_tlb(struct
 #endif
 }
 
-static inline void load_cr3(pgd_t *pgd)
-{
-	asm volatile("movq %0,%%cr3" :: "r" (__pa(pgd)) : "memory");
-}
-
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next, 
 			     struct task_struct *tsk)
 {
@@ -39,7 +34,7 @@ static inline void switch_mm(struct mm_s
 		write_pda(active_mm, next);
 #endif
 		cpu_set(cpu, next->cpu_vm_mask);
-		load_cr3(next->pgd);
+		write_cr3(__pa(next->pgd));
 
 		if (unlikely(next->context.ldt != prev->context.ldt)) 
 			load_LDT_nolock(&next->context, cpu);
@@ -54,7 +49,7 @@ static inline void switch_mm(struct mm_s
 			 * tlb flush IPI delivery. We must reload CR3
 			 * to make sure to use no freed page tables.
 			 */
-			load_cr3(next->pgd);
+			write_cr3(__pa(next->pgd));
 			load_LDT_nolock(&next->context, cpu);
 		}
 	}
_

Patches currently in -mm which might be from gcosta@redhat.com are

x86_64-remove-duplicated-code-for-reading-control-registers.patch
yet-another-function-to-load-cr3-register.patch
