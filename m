From: akpm@linux-foundation.org
Subject: [merged] m32r-remove-redundant-declaration.patch removed from -mm tree
Date: Fri, 27 May 2011 12:56:56 -0700
Message-ID: <201105271955.p4RJt1vo017417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411Ab1E0Tzo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:55:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r: remove redundant declaration
has been removed from the -mm tree.  Its filename was
     m32r-remove-redundant-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m32r: remove redundant declaration
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

They have no meaning.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/smp.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN arch/m32r/kernel/smp.c~m32r-remove-redundant-declaration arch/m32r/kernel/smp.c
--- a/arch/m32r/kernel/smp.c~m32r-remove-redundant-declaration
+++ a/arch/m32r/kernel/smp.c
@@ -30,6 +30,7 @@
 #include <asm/io.h>
 #include <asm/mmu_context.h>
 #include <asm/m32r.h>
+#include <asm/tlbflush.h>
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 /* Data structures and variables                                             */
@@ -61,27 +62,17 @@ extern spinlock_t ipi_lock[];
 /* Function Prototypes                                                       */
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 
-void smp_send_reschedule(int);
 void smp_reschedule_interrupt(void);
-
-void smp_flush_cache_all(void);
 void smp_flush_cache_all_interrupt(void);
 
-void smp_flush_tlb_all(void);
 static void flush_tlb_all_ipi(void *);
-
-void smp_flush_tlb_mm(struct mm_struct *);
-void smp_flush_tlb_range(struct vm_area_struct *, unsigned long, \
-	unsigned long);
-void smp_flush_tlb_page(struct vm_area_struct *, unsigned long);
 static void flush_tlb_others(cpumask_t, struct mm_struct *,
 	struct vm_area_struct *, unsigned long);
+
 void smp_invalidate_interrupt(void);
 
-void smp_send_stop(void);
 static void stop_this_cpu(void *);
 
-void smp_send_timer(void);
 void smp_ipi_timer_interrupt(struct pt_regs *);
 void smp_local_timer_interrupt(void);
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mm-increase-reclaim_distance-to-30.patch
slab-use-numa_no_node.patch
vmscanmemcg-memcg-aware-swap-token.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

