From: akpm@linux-foundation.org
Subject: + paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch added to -mm tree
Date: Fri, 06 Apr 2007 16:26:37 -0700
Message-ID: <200704062326.l36NQbOD022523@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38356 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933439AbXDFX0o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 19:26:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com


The patch titled
     paravirt_ops: Fix patch site clobbers to include return register
has been added to the -mm tree.  Its filename is
     paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

paravirt_ops-update-maintainers.patch
paravirt_ops-remove-config_debug_paravirt.patch
paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch
paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
paravirt_ops-hooks-to-set-up-initial-pagetable.patch
paravirt_ops-allocate-a-fixmap-slot.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-document-asm-i386-paravirth.patch
paravirt_ops-add-common-patching-machinery.patch
paravirt_ops-add-flush_tlb_others-paravirt_op.patch
paravirt_ops-revert-map_pt_hook.patch
paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
re-enable-vdso-by-default-with-paravirt.patch
remove-noreplacement-option.patch
remove-smp_alt_instructions.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
allow-boot-time-disable-of-smp-altinstructions.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
paravirt_ops-update-maintainers.patch
paravirt_ops-remove-config_debug_paravirt.patch
paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch
paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
paravirt_ops-hooks-to-set-up-initial-pagetable.patch
paravirt_ops-allocate-a-fixmap-slot.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-document-asm-i386-paravirth.patch
paravirt_ops-add-common-patching-machinery.patch
paravirt_ops-add-flush_tlb_others-paravirt_op.patch
paravirt_ops-revert-map_pt_hook.patch
paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
clean-up-elf-note-generation.patch
