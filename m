From: akpm@linux-foundation.org
Subject: - paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:30:16 -0700
Message-ID: <200704132330.l3DNUGnH012726@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60629 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030896AbXDMXaY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:30:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     paravirt_ops: Fix patch site clobbers to include return register
has been removed from the -mm tree.  Its filename was
     paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: paravirt_ops: Fix patch site clobbers to include return register
From: Jeremy Fitzhardinge <jeremy@goop.org>

Fix a few clobbers to include the return register.  The clobbers set is the
set of all registers modified (or may be modified) by the code snippet,
regardless of whether it was deliberate or accidental.

Also, make sure that callsites which are used in contexts which don't allow
clobbers actually save and restore all clobberable registers.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/entry.S    |    2 +-
 include/asm-i386/paravirt.h |   18 ++++++++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff -puN arch/i386/kernel/entry.S~paravirt_ops-fix-patch-site-clobbers-to-include-return-register arch/i386/kernel/entry.S
--- a/arch/i386/kernel/entry.S~paravirt_ops-fix-patch-site-clobbers-to-include-return-register
+++ a/arch/i386/kernel/entry.S
@@ -342,7 +342,7 @@ sysenter_past_esp:
 	jae syscall_badsys
 	call *sys_call_table(,%eax,4)
 	movl %eax,PT_EAX(%esp)
-	DISABLE_INTERRUPTS(CLBR_ECX|CLBR_EDX)
+	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF
 	movl TI_flags(%ebp), %ecx
 	testw $_TIF_ALLWORK_MASK, %cx
diff -puN include/asm-i386/paravirt.h~paravirt_ops-fix-patch-site-clobbers-to-include-return-register include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~paravirt_ops-fix-patch-site-clobbers-to-include-return-register
+++ a/include/asm-i386/paravirt.h
@@ -532,7 +532,7 @@ static inline unsigned long __raw_local_
 				  "popl %%edx; popl %%ecx")
 		     : "=a"(f)
 		     : paravirt_type(save_fl),
-		       paravirt_clobber(CLBR_NONE)
+		       paravirt_clobber(CLBR_EAX)
 		     : "memory", "cc");
 	return f;
 }
@@ -617,27 +617,29 @@ static inline unsigned long __raw_local_
 	.popsection
 
 #define INTERRUPT_RETURN					\
-	PARA_SITE(PARA_PATCH(PARAVIRT_iret), CLBR_ANY,		\
+	PARA_SITE(PARA_PATCH(PARAVIRT_iret), CLBR_NONE,		\
 		  jmp *%cs:paravirt_ops+PARAVIRT_iret)
 
 #define DISABLE_INTERRUPTS(clobbers)					\
 	PARA_SITE(PARA_PATCH(PARAVIRT_irq_disable), clobbers,		\
-		  pushl %ecx; pushl %edx;				\
+		  pushl %eax; pushl %ecx; pushl %edx;			\
 		  call *%cs:paravirt_ops+PARAVIRT_irq_disable;		\
-		  popl %edx; popl %ecx)					\
+		  popl %edx; popl %ecx; popl %eax)			\
 
 #define ENABLE_INTERRUPTS(clobbers)					\
 	PARA_SITE(PARA_PATCH(PARAVIRT_irq_enable), clobbers,		\
-		  pushl %ecx; pushl %edx;				\
+		  pushl %eax; pushl %ecx; pushl %edx;			\
 		  call *%cs:paravirt_ops+PARAVIRT_irq_enable;		\
-		  popl %edx; popl %ecx)
+		  popl %edx; popl %ecx; popl %eax)
 
 #define ENABLE_INTERRUPTS_SYSEXIT					\
-	PARA_SITE(PARA_PATCH(PARAVIRT_irq_enable_sysexit), CLBR_ANY,	\
+	PARA_SITE(PARA_PATCH(PARAVIRT_irq_enable_sysexit), CLBR_NONE,	\
 		  jmp *%cs:paravirt_ops+PARAVIRT_irq_enable_sysexit)
 
 #define GET_CR0_INTO_EAX			\
-	call *paravirt_ops+PARAVIRT_read_cr0
+	push %ecx; push %edx;			\
+	call *paravirt_ops+PARAVIRT_read_cr0;	\
+	pop %edx; pop %ecx
 
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_PARAVIRT */
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
revert-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
x86-clean-up-identify_cpu-update.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
clean-up-elf-note-generation.patch
deflate-stack-usage-in-lib-inflatec.patch
