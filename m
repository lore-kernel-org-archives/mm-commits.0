From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-entry_32s-i386-too.patch added to -mm tree
Date: Wed, 15 Sep 2010 14:44:35 -0700
Message-ID: <201009152215.o8FMFPFw018395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123Ab0IOWQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Sep 2010 18:16:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, heukelum@fastmail.fm, hpa@zytor.com, jbeulich@novell.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     arch/x86/kernel/entry_32.S: i386 too!
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-entry_32s-i386-too.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/kernel/entry_32.S: i386 too!
From: Andrew Morton <akpm@linux-foundation.org>

arch/x86/kernel/entry_32.S: Assembler messages:
arch/x86/kernel/entry_32.S:385: Error: too many positional arguments
arch/x86/kernel/entry_32.S:391: Error: too many positional arguments
arch/x86/kernel/entry_32.S:398: Error: too many positional arguments
arch/x86/kernel/entry_32.S:586: Error: too many positional arguments
arch/x86/kernel/entry_32.S:760: Error: too many positional arguments
arch/x86/kernel/entry_32.S:1300: Error: too many positional arguments
arch/x86/kernel/entry_32.S:1352: Error: too many positional arguments
arch/x86/kernel/entry_32.S:1363: Error: too many positional arguments
arch/x86/kernel/entry_32.S:760: Error: too many positional arguments

Cc: Jan Beulich <jbeulich@novell.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/entry_32.S |  134 +++++++++++++++++------------------
 1 file changed, 67 insertions(+), 67 deletions(-)

diff -puN arch/x86/kernel/entry_32.S~arch-x86-kernel-entry_32s-i386-too arch/x86/kernel/entry_32.S
--- a/arch/x86/kernel/entry_32.S~arch-x86-kernel-entry_32s-i386-too
+++ a/arch/x86/kernel/entry_32.S
@@ -382,23 +382,23 @@ sysenter_past_esp:
 	 * enough kernel state to call TRACE_IRQS_OFF can be called - but
 	 * we immediately enable interrupts at that point anyway.
 	 */
-	pushl_cfi $(__USER_DS)
+	pushl $(__USER_DS)
 	/*CFI_REL_OFFSET ss, 0*/
 	pushl_cfi %ebp
 	CFI_REL_OFFSET esp, 0
 	pushfl_cfi
 	orl $X86_EFLAGS_IF, (%esp)
-	pushl_cfi $(__USER_CS)
+	pushl $(__USER_CS)
 	/*CFI_REL_OFFSET cs, 0*/
 	/*
 	 * Push current_thread_info()->sysenter_return to the stack.
 	 * A tiny bit of offset fixup is necessary - 4*4 means the 4 words
 	 * pushed above; +8 corresponds to copy_thread's esp0 setting.
 	 */
-	pushl_cfi (TI_sysenter_return-THREAD_SIZE+8+4*4)(%esp)
+	pushl (TI_sysenter_return-THREAD_SIZE+8+4*4)(%esp)
 	CFI_REL_OFFSET eip, 0
 
-	pushl_cfi %eax
+	pushl %eax
 	SAVE_ALL
 	ENABLE_INTERRUPTS(CLBR_NONE)
 
@@ -453,7 +453,7 @@ sysenter_audit:
 	movl %eax,%edx			/* 2nd arg: syscall number */
 	movl $AUDIT_ARCH_I386,%eax	/* 1st arg: audit arch */
 	call audit_syscall_entry
-	pushl_cfi %ebx
+	pushl %ebx
 	movl PT_EAX(%esp),%eax		/* reload syscall number */
 	jmp sysenter_do_call
 
@@ -495,7 +495,7 @@ ENDPROC(ia32_sysenter_target)
 	# system call handler stub
 ENTRY(system_call)
 	RING0_INT_FRAME			# can't unwind into user space anyway
-	pushl_cfi %eax			# save orig_eax
+	pushl %eax			# save orig_eax
 	SAVE_ALL
 	GET_THREAD_INFO(%ebp)
 					# system call tracing in operation / emulation
@@ -583,8 +583,8 @@ ldt_ss:
 	shr $16, %edx
 	mov %dl, GDT_ESPFIX_SS + 4 /* bits 16..23 */
 	mov %dh, GDT_ESPFIX_SS + 7 /* bits 24..31 */
-	pushl_cfi $__ESPFIX_SS
-	pushl_cfi %eax			/* new kernel esp */
+	pushl $__ESPFIX_SS
+	pushl %eax			/* new kernel esp */
 	/* Disable interrupts, but do not irqtrace this section: we
 	 * will soon execute iret and the tracer was already set to
 	 * the irqstate after the iret */
@@ -628,7 +628,7 @@ work_notifysig:				# deal with pending s
 
 	ALIGN
 work_notifysig_v86:
-	pushl_cfi %ecx			# save ti_flags for do_notify_resume
+	pushl %ecx			# save ti_flags for do_notify_resume
 	call save_v86_state		# %eax contains pt_regs pointer
 	popl_cfi %ecx
 	movl %eax, %esp
@@ -712,7 +712,7 @@ ptregs_##name: \
 ptregs_##name: \
 	CFI_STARTPROC; \
 	leal 4(%esp),%eax; \
-	pushl_cfi %eax; \
+	pushl %eax; \
 	movl PT_EDX(%eax),%ecx; \
 	movl PT_ECX(%eax),%edx; \
 	movl PT_EBX(%eax),%eax; \
@@ -738,8 +738,8 @@ PTREGSCALL1(vm86old)
 ptregs_clone:
 	CFI_STARTPROC
 	leal 4(%esp),%eax
-	pushl_cfi %eax
-	pushl_cfi PT_EDI(%eax)
+	pushl %eax
+	pushl PT_EDI(%eax)
 	movl PT_EDX(%eax),%ecx
 	movl PT_ECX(%eax),%edx
 	movl PT_EBX(%eax),%eax
@@ -763,8 +763,8 @@ ENDPROC(ptregs_clone)
 	mov GDT_ESPFIX_SS + 7, %ah /* bits 24..31 */
 	shl $16, %eax
 	addl %esp, %eax			/* the adjusted stack pointer */
-	pushl_cfi $__KERNEL_DS
-	pushl_cfi %eax
+	pushl $__KERNEL_DS
+	pushl %eax
 	lss (%esp), %esp		/* switch to the normal stack segment */
 	CFI_ADJUST_CFA_OFFSET -8
 .endm
@@ -801,7 +801,7 @@ vector=FIRST_EXTERNAL_VECTOR
       .if vector <> FIRST_EXTERNAL_VECTOR
 	CFI_ADJUST_CFA_OFFSET -4
       .endif
-1:	pushl_cfi $(~vector+0x80)	/* Note: always in signed byte range */
+1:	pushl $(~vector+0x80)	/* Note: always in signed byte range */
       .if ((vector-FIRST_EXTERNAL_VECTOR)%7) <> 6
 	jmp 2f
       .endif
@@ -841,7 +841,7 @@ ENDPROC(common_interrupt)
 #define BUILD_INTERRUPT3(name, nr, fn)	\
 ENTRY(name)				\
 	RING0_INT_FRAME;		\
-	pushl_cfi $~(nr);		\
+	pushl $~(nr);		\
 	SAVE_ALL;			\
 	TRACE_IRQS_OFF			\
 	movl %esp,%eax;			\
@@ -857,18 +857,18 @@ ENDPROC(name)
 
 ENTRY(coprocessor_error)
 	RING0_INT_FRAME
-	pushl_cfi $0
-	pushl_cfi $do_coprocessor_error
+	pushl $0
+	pushl $do_coprocessor_error
 	jmp error_code
 	CFI_ENDPROC
 END(coprocessor_error)
 
 ENTRY(simd_coprocessor_error)
 	RING0_INT_FRAME
-	pushl_cfi $0
+	pushl $0
 #ifdef CONFIG_X86_INVD_BUG
 	/* AMD 486 bug: invd from userspace calls exception 19 instead of #GP */
-661:	pushl_cfi $do_general_protection
+661:	pushl $do_general_protection
 662:
 .section .altinstructions,"a"
 	.balign 4
@@ -883,7 +883,7 @@ ENTRY(simd_coprocessor_error)
 664:
 .previous
 #else
-	pushl_cfi $do_simd_coprocessor_error
+	pushl $do_simd_coprocessor_error
 #endif
 	jmp error_code
 	CFI_ENDPROC
@@ -891,8 +891,8 @@ END(simd_coprocessor_error)
 
 ENTRY(device_not_available)
 	RING0_INT_FRAME
-	pushl_cfi $-1			# mark this as an int
-	pushl_cfi $do_device_not_available
+	pushl $-1			# mark this as an int
+	pushl $do_device_not_available
 	jmp error_code
 	CFI_ENDPROC
 END(device_not_available)
@@ -914,68 +914,68 @@ END(native_irq_enable_sysexit)
 
 ENTRY(overflow)
 	RING0_INT_FRAME
-	pushl_cfi $0
-	pushl_cfi $do_overflow
+	pushl $0
+	pushl $do_overflow
 	jmp error_code
 	CFI_ENDPROC
 END(overflow)
 
 ENTRY(bounds)
 	RING0_INT_FRAME
-	pushl_cfi $0
-	pushl_cfi $do_bounds
+	pushl $0
+	pushl $do_bounds
 	jmp error_code
 	CFI_ENDPROC
 END(bounds)
 
 ENTRY(invalid_op)
 	RING0_INT_FRAME
-	pushl_cfi $0
-	pushl_cfi $do_invalid_op
+	pushl $0
+	pushl $do_invalid_op
 	jmp error_code
 	CFI_ENDPROC
 END(invalid_op)
 
 ENTRY(coprocessor_segment_overrun)
 	RING0_INT_FRAME
-	pushl_cfi $0
-	pushl_cfi $do_coprocessor_segment_overrun
+	pushl $0
+	pushl $do_coprocessor_segment_overrun
 	jmp error_code
 	CFI_ENDPROC
 END(coprocessor_segment_overrun)
 
 ENTRY(invalid_TSS)
 	RING0_EC_FRAME
-	pushl_cfi $do_invalid_TSS
+	pushl $do_invalid_TSS
 	jmp error_code
 	CFI_ENDPROC
 END(invalid_TSS)
 
 ENTRY(segment_not_present)
 	RING0_EC_FRAME
-	pushl_cfi $do_segment_not_present
+	pushl $do_segment_not_present
 	jmp error_code
 	CFI_ENDPROC
 END(segment_not_present)
 
 ENTRY(stack_segment)
 	RING0_EC_FRAME
-	pushl_cfi $do_stack_segment
+	pushl $do_stack_segment
 	jmp error_code
 	CFI_ENDPROC
 END(stack_segment)
 
 ENTRY(alignment_check)
 	RING0_EC_FRAME
-	pushl_cfi $do_alignment_check
+	pushl $do_alignment_check
 	jmp error_code
 	CFI_ENDPROC
 END(alignment_check)
 
 ENTRY(divide_error)
 	RING0_INT_FRAME
-	pushl_cfi $0			# no error code
-	pushl_cfi $do_divide_error
+	pushl $0			# no error code
+	pushl $do_divide_error
 	jmp error_code
 	CFI_ENDPROC
 END(divide_error)
@@ -983,8 +983,8 @@ END(divide_error)
 #ifdef CONFIG_X86_MCE
 ENTRY(machine_check)
 	RING0_INT_FRAME
-	pushl_cfi $0
-	pushl_cfi machine_check_vector
+	pushl $0
+	pushl machine_check_vector
 	jmp error_code
 	CFI_ENDPROC
 END(machine_check)
@@ -992,8 +992,8 @@ END(machine_check)
 
 ENTRY(spurious_interrupt_bug)
 	RING0_INT_FRAME
-	pushl_cfi $0
-	pushl_cfi $do_spurious_interrupt_bug
+	pushl $0
+	pushl $do_spurious_interrupt_bug
 	jmp error_code
 	CFI_ENDPROC
 END(spurious_interrupt_bug)
@@ -1024,7 +1024,7 @@ ENTRY(xen_sysenter_target)
 
 ENTRY(xen_hypervisor_callback)
 	CFI_STARTPROC
-	pushl_cfi $0
+	pushl $0
 	SAVE_ALL
 	TRACE_IRQS_OFF
 
@@ -1060,7 +1060,7 @@ ENDPROC(xen_hypervisor_callback)
 # We distinguish between categories by maintaining a status value in EAX.
 ENTRY(xen_failsafe_callback)
 	CFI_STARTPROC
-	pushl_cfi %eax
+	pushl %eax
 	movl $1,%eax
 1:	mov 4(%esp),%ds
 2:	mov 8(%esp),%es
@@ -1073,7 +1073,7 @@ ENTRY(xen_failsafe_callback)
 	jz 5f
 	addl $16,%esp
 	jmp iret_exc		# EAX != 0 => Category 2 (Bad IRET)
-5:	pushl_cfi $0		# EAX == 0 => Category 1 (Bad segment)
+5:	pushl $0		# EAX == 0 => Category 1 (Bad segment)
 	SAVE_ALL
 	jmp ret_from_exception
 	CFI_ENDPROC
@@ -1223,29 +1223,29 @@ syscall_table_size=(.-sys_call_table)
 
 ENTRY(page_fault)
 	RING0_EC_FRAME
-	pushl_cfi $do_page_fault
+	pushl $do_page_fault
 	ALIGN
 error_code:
 	/* the function address is in %gs's slot on the stack */
-	pushl_cfi %fs
+	pushl %fs
 	/*CFI_REL_OFFSET fs, 0*/
-	pushl_cfi %es
+	pushl %es
 	/*CFI_REL_OFFSET es, 0*/
-	pushl_cfi %ds
+	pushl %ds
 	/*CFI_REL_OFFSET ds, 0*/
-	pushl_cfi %eax
+	pushl %eax
 	CFI_REL_OFFSET eax, 0
-	pushl_cfi %ebp
+	pushl %ebp
 	CFI_REL_OFFSET ebp, 0
-	pushl_cfi %edi
+	pushl %edi
 	CFI_REL_OFFSET edi, 0
-	pushl_cfi %esi
+	pushl %esi
 	CFI_REL_OFFSET esi, 0
-	pushl_cfi %edx
+	pushl %edx
 	CFI_REL_OFFSET edx, 0
-	pushl_cfi %ecx
+	pushl %ecx
 	CFI_REL_OFFSET ecx, 0
-	pushl_cfi %ebx
+	pushl %ebx
 	CFI_REL_OFFSET ebx, 0
 	cld
 	movl $(__KERNEL_PERCPU), %ecx
@@ -1288,8 +1288,8 @@ END(page_fault)
 	CFI_DEF_CFA esp, 0
 	CFI_UNDEFINED eip
 	pushfl_cfi
-	pushl_cfi $__KERNEL_CS
-	pushl_cfi $sysenter_past_esp
+	pushl $__KERNEL_CS
+	pushl $sysenter_past_esp
 	CFI_REL_OFFSET eip, 0
 .endm
 
@@ -1299,7 +1299,7 @@ ENTRY(debug)
 	jne debug_stack_correct
 	FIX_STACK 12, debug_stack_correct, debug_esp_fix_insn
 debug_stack_correct:
-	pushl_cfi $-1			# mark this as an int
+	pushl $-1			# mark this as an int
 	SAVE_ALL
 	TRACE_IRQS_OFF
 	xorl %edx,%edx			# error code 0
@@ -1319,14 +1319,14 @@ END(debug)
  */
 ENTRY(nmi)
 	RING0_INT_FRAME
-	pushl_cfi %eax
+	pushl %eax
 	movl %ss, %eax
 	cmpw $__ESPFIX_SS, %ax
 	popl_cfi %eax
 	je nmi_espfix_stack
 	cmpl $ia32_sysenter_target,(%esp)
 	je nmi_stack_fixup
-	pushl_cfi %eax
+	pushl %eax
 	movl %esp,%eax
 	/* Do not access memory above the end of our stack page,
 	 * it might not exist.
@@ -1339,7 +1339,7 @@ ENTRY(nmi)
 	je nmi_debug_stack_check
 nmi_stack_correct:
 	/* We have a RING0_INT_FRAME here */
-	pushl_cfi %eax
+	pushl %eax
 	SAVE_ALL
 	xorl %edx,%edx		# zero error code
 	movl %esp,%eax		# pt_regs pointer
@@ -1368,14 +1368,14 @@ nmi_espfix_stack:
 	 *
 	 * create the pointer to lss back
 	 */
-	pushl_cfi %ss
-	pushl_cfi %esp
+	pushl %ss
+	pushl %esp
 	addl $4, (%esp)
 	/* copy the iret frame of 12 bytes */
 	.rept 3
-	pushl_cfi 16(%esp)
+	pushl 16(%esp)
 	.endr
-	pushl_cfi %eax
+	pushl %eax
 	SAVE_ALL
 	FIXUP_ESPFIX_STACK		# %eax == %esp
 	xorl %edx,%edx			# zero error code
@@ -1389,7 +1389,7 @@ END(nmi)
 
 ENTRY(int3)
 	RING0_INT_FRAME
-	pushl_cfi $-1			# mark this as an int
+	pushl $-1			# mark this as an int
 	SAVE_ALL
 	TRACE_IRQS_OFF
 	xorl %edx,%edx		# zero error code
@@ -1401,7 +1401,7 @@ END(int3)
 
 ENTRY(general_protection)
 	RING0_EC_FRAME
-	pushl_cfi $do_general_protection
+	pushl $do_general_protection
 	jmp error_code
 	CFI_ENDPROC
 END(general_protection)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
efifb-support-the-efi-framebuffer-on-more-apple-hardware-checkpatch-fixes.patch
mm-vmap-area-cache.patch
acpi-apei-fix-erst-move_data-instruction-implementation.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
fs-notify-fanotify-fanotify_userc-fix-warnings.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
sctp-prevent-reading-out-of-bounds-memory-cleanup.patch
drivers-net-tulip-de4x5c-fix-copy-length-in-de4x5_ioctl-checkpatch-fixes.patch
serial-add-sc16is7x2-driver-update-fix.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
drivers-message-fusion-mptsasc-fix-warning.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernelh-add-minmax3-macros-fix.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
mmc_test-move-files-from-sysfs-to-debugfs-checkpatch-fixes.patch
mmc-move-regulator-handling-closer-to-core-v3-fix.patch
sdhci-get-rid-of-card-detect-work-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
drivers-char-hvc_consolec-remove-unneeded-__set_current_statetask_running.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
arch-x86-kernel-entry_32s-i386-too.patch

