From: akpm@linux-foundation.org
Subject: - i386-mcheck-p4-grotesque-and-needless-warning-fix.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:39:50 -0700
Message-ID: <200704252039.l3PKdokJ012345@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993178AbXDYU5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:57:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386 mcheck p4 grotesque and needless warning fix
has been removed from the -mm tree.  Its filename was
     i386-mcheck-p4-grotesque-and-needless-warning-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 mcheck p4 grotesque and needless warning fix
From: Zachary Amsden <zach@vmware.com>

No, just no.  You do not use goto to skip a code block.  You do not return an
obvious variable from a singly-inlined function and give the function a return
value.  You don't put unexplained comments about kmalloc in code which doesn't
do dynamic allocation.  And you don't leave stray warnings around for no good
reason.

Also, when possible, it is better to use block scoped variables because gcc
can sometime generate better code.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mcheck/p4.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff -puN arch/i386/kernel/cpu/mcheck/p4.c~i386-mcheck-p4-grotesque-and-needless-warning-fix arch/i386/kernel/cpu/mcheck/p4.c
--- a/arch/i386/kernel/cpu/mcheck/p4.c~i386-mcheck-p4-grotesque-and-needless-warning-fix
+++ a/arch/i386/kernel/cpu/mcheck/p4.c
@@ -124,13 +124,10 @@ static void intel_init_thermal(struct cp
 
 
 /* P4/Xeon Extended MCE MSR retrieval, return 0 if unsupported */
-static inline int intel_get_extended_msrs(struct intel_mce_extended_msrs *r)
+static inline void intel_get_extended_msrs(struct intel_mce_extended_msrs *r)
 {
 	u32 h;
 
-	if (mce_num_extended_msrs == 0)
-		goto done;
-
 	rdmsr (MSR_IA32_MCG_EAX, r->eax, h);
 	rdmsr (MSR_IA32_MCG_EBX, r->ebx, h);
 	rdmsr (MSR_IA32_MCG_ECX, r->ecx, h);
@@ -141,12 +138,6 @@ static inline int intel_get_extended_msr
 	rdmsr (MSR_IA32_MCG_ESP, r->esp, h);
 	rdmsr (MSR_IA32_MCG_EFLAGS, r->eflags, h);
 	rdmsr (MSR_IA32_MCG_EIP, r->eip, h);
-
-	/* can we rely on kmalloc to do a dynamic
-	 * allocation for the reserved registers?
-	 */
-done:
-	return mce_num_extended_msrs;
 }
 
 static fastcall void intel_machine_check(struct pt_regs * regs, long error_code)
@@ -155,7 +146,6 @@ static fastcall void intel_machine_check
 	u32 alow, ahigh, high, low;
 	u32 mcgstl, mcgsth;
 	int i;
-	struct intel_mce_extended_msrs dbg;
 
 	rdmsr (MSR_IA32_MCG_STATUS, mcgstl, mcgsth);
 	if (mcgstl & (1<<0))	/* Recoverable ? */
@@ -164,7 +154,9 @@ static fastcall void intel_machine_check
 	printk (KERN_EMERG "CPU %d: Machine Check Exception: %08x%08x\n",
 		smp_processor_id(), mcgsth, mcgstl);
 
-	if (intel_get_extended_msrs(&dbg)) {
+	if (mce_num_extended_msrs > 0) {
+		struct intel_mce_extended_msrs dbg;
+		intel_get_extended_msrs(&dbg);
 		printk (KERN_DEBUG "CPU %d: EIP: %08x EFLAGS: %08x\n",
 			smp_processor_id(), dbg.eip, dbg.eflags);
 		printk (KERN_DEBUG "\teax: %08x ebx: %08x ecx: %08x edx: %08x\n",
_

Patches currently in -mm which might be from zach@vmware.com are

fix-buslogic-to-stop-using-check_region.patch
i386-pte-clear-optimization.patch
i386-pte-xchg-optimization.patch
i386-pte-simplify-ops.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
