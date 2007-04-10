From: akpm@linux-foundation.org
Subject: + i386-mcheck-p4-grotesque-and-needless-warning-fix.patch added to -mm tree
Date: Mon, 09 Apr 2007 22:18:04 -0700
Message-ID: <200704100518.l3A5I4db032077@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44469 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966059AbXDJFSI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 01:18:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach@vmware.com, ak@suse.de


The patch titled
     i386 mcheck p4 grotesque and needless warning fix
has been added to the -mm tree.  Its filename is
     i386-mcheck-p4-grotesque-and-needless-warning-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
paravirt_ops-update-maintainers.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-add-common-patching-machinery.patch
paravirt_ops-revert-map_pt_hook.patch
paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages.patch
i386-relocate-vdso-elf-headers-to-match-mapped-location-with-compat_vdso.patch
i386-make-compat_vdso-runtime-selectable.patch
i386-sysenter-arch-pages-fix.patch
i386-acpi-remove-earlyquirk-warning.patch
i386-mcheck-p4-grotesque-and-needless-warning-fix.patch
i386-pgd-clone-under-lock-fix.patch
vmi-supports-compat-vdso.patch
resurrect-the-vmi-lazy-mode-fixes.patch
vmi-kmap_atomic_pte-fix.patch
vmi-timer-update.patch
fix-buslogic-to-stop-using-check_region.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
