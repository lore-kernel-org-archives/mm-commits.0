From: akpm@linux-foundation.org
Subject: - xen-use-iret-directly-where-possible.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:28:30 -0700
Message-ID: <200706231928.l5NJSUpl022153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46858 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753407AbXFWTem (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:34:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     xen: use iret directly where possible
has been removed from the -mm tree.  Its filename was
     xen-use-iret-directly-where-possible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xen: use iret directly where possible
From: Jeremy Fitzhardinge <jeremy@goop.org>

Most of the time we can simply use the iret instruction to exit the kernel,
rather than having to use the iret hypercall - the only exception is if
we're returning into vm86 mode, or from delivering an NMI (which we don't
support yet).

When running native, iret has the behaviour of testing for a pending
interrupt atomically with re-enabling interrupts.  Unfortunately there's no
way to do this with Xen, so there's a window in which we could get a
recursive exception after enabling events but before actually returning to
userspace.

This causes a problem: if the nested interrupt causes one of the task's
TIF_WORK_MASK flags to be set, they will not be checked again before
returning to userspace.  This means that pending work may be left pending
indefinitely, until the process enters and leaves the kernel again.  The
net effect is that a pending signal or reschedule event could be delayed
for an unbounded amount of time.

To deal with this, the xen event upcall handler checks to see if the EIP is
within the critical section of the iret code, after events are
(potentially) enabled up to the iret itself.  If its within this range, it
calls the iret critical section fixup, which adjusts the stack to deal with
any unrestored registers, and then shifts the stack frame up to replace the
previous invocation.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/asm-offsets.c |    1 
 arch/i386/kernel/entry.S       |   16 ++
 arch/i386/xen/enlighten.c      |    1 
 arch/i386/xen/xen-asm.S        |  185 ++++++++++++++++++++++++++++++-
 arch/i386/xen/xen-ops.h        |    1 
 5 files changed, 199 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/asm-offsets.c~xen-use-iret-directly-where-possible arch/i386/kernel/asm-offsets.c
--- a/arch/i386/kernel/asm-offsets.c~xen-use-iret-directly-where-possible
+++ a/arch/i386/kernel/asm-offsets.c
@@ -60,6 +60,7 @@ void foo(void)
 	OFFSET(TI_addr_limit, thread_info, addr_limit);
 	OFFSET(TI_restart_block, thread_info, restart_block);
 	OFFSET(TI_sysenter_return, thread_info, sysenter_return);
+	OFFSET(TI_cpu, thread_info, cpu);
 	BLANK();
 
 	OFFSET(GDS_size, Xgt_desc_struct, size);
diff -puN arch/i386/kernel/entry.S~xen-use-iret-directly-where-possible arch/i386/kernel/entry.S
--- a/arch/i386/kernel/entry.S~xen-use-iret-directly-where-possible
+++ a/arch/i386/kernel/entry.S
@@ -1030,7 +1030,21 @@ ENTRY(xen_hypervisor_callback)
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
 	TRACE_IRQS_OFF
-	mov %esp, %eax
+
+	/* Check to see if we got the event in the critical
+	   region in xen_iret_direct, after we've reenabled
+	   events and checked for pending events.  This simulates
+	   iret instruction's behaviour where it delivers a
+	   pending interrupt when enabling interrupts. */
+	movl PT_EIP(%esp),%eax
+	cmpl $xen_iret_start_crit,%eax
+	jb   1f
+	cmpl $xen_iret_end_crit,%eax
+	jae  1f
+
+	call xen_iret_crit_fixup
+
+1:	mov %esp, %eax
 	call xen_evtchn_do_upcall
 	jmp  ret_from_intr
 	CFI_ENDPROC
diff -puN arch/i386/xen/enlighten.c~xen-use-iret-directly-where-possible arch/i386/xen/enlighten.c
--- a/arch/i386/xen/enlighten.c~xen-use-iret-directly-where-possible
+++ a/arch/i386/xen/enlighten.c
@@ -1092,6 +1092,7 @@ asmlinkage void __init xen_start_kernel(
 		paravirt_ops.irq_disable = xen_irq_disable_direct;
 		paravirt_ops.irq_enable = xen_irq_enable_direct;
 		paravirt_ops.read_cr2 = xen_read_cr2_direct;
+		paravirt_ops.iret = xen_iret_direct;
 	}
 
 	paravirt_ops.kernel_rpl = 1;
diff -puN arch/i386/xen/xen-asm.S~xen-use-iret-directly-where-possible arch/i386/xen/xen-asm.S
--- a/arch/i386/xen/xen-asm.S~xen-use-iret-directly-where-possible
+++ a/arch/i386/xen/xen-asm.S
@@ -12,15 +12,21 @@
  */
 
 #include <linux/linkage.h>
+
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
 #include <asm/percpu.h>
-#include <asm/asm-offsets.h>
 #include <asm/processor-flags.h>
+#include <asm/segment.h>
+
+#include <xen/interface/xen.h>
 
 #define RELOC(x, v)	.globl x##_reloc; x##_reloc=v
 #define ENDPATCH(x)	.globl x##_end; x##_end=.
 
+/* Pseudo-flag used for virtual NMI, which we don't implement yet */
+#define XEN_EFLAGS_NMI	0x80000000
+
 /*
 	Enable events.  This clears the event mask and tests the pending
 	event status with one and operation.  If there are pending
@@ -81,13 +87,12 @@ ENDPATCH(xen_save_fl_direct)
  */
 ENTRY(xen_restore_fl_direct)
 	testb $X86_EFLAGS_IF>>8, %ah
-	setz %al
-	movb %al, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_mask
+	setz PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_mask
 	/* Preempt here doesn't matter because that will deal with
 	   any pending interrupts.  The pending check may end up being
 	   run on the wrong CPU, but that doesn't hurt. */
 
-	/* check for pending but unmasked */
+	/* check for unmasked and pending */
 	cmpw $0x0001, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_pending
 	jz 1f
 2:	call check_events
@@ -97,6 +102,178 @@ ENDPATCH(xen_restore_fl_direct)
 	ENDPROC(xen_restore_fl_direct)
 	RELOC(xen_restore_fl_direct, 2b+1)
 
+/*
+	This is run where a normal iret would be run, with the same stack setup:
+	      8: eflags
+	      4: cs
+	esp-> 0: eip
+
+	This attempts to make sure that any pending events are dealt
+	with on return to usermode, but there is a small window in
+	which an event can happen just before entering usermode.  If
+	the nested interrupt ends up setting one of the TIF_WORK_MASK
+	pending work flags, they will not be tested again before
+	returning to usermode. This means that a process can end up
+	with pending work, which will be unprocessed until the process
+	enters and leaves the kernel again, which could be an
+	unbounded amount of time.  This means that a pending signal or
+	reschedule event could be indefinitely delayed.
+
+	The fix is to notice a nested interrupt in the critical
+	window, and if one occurs, then fold the nested interrupt into
+	the current interrupt stack frame, and re-process it
+	iteratively rather than recursively.  This means that it will
+	exit via the normal path, and all pending work will be dealt
+	with appropriately.
+
+	Because the nested interrupt handler needs to deal with the
+	current stack state in whatever form its in, we keep things
+	simple by only using a single register which is pushed/popped
+	on the stack.
+
+	Non-direct iret could be done in the same way, but it would
+	require an annoying amount of code duplication.  We'll assume
+	that direct mode will be the common case once the hypervisor
+	support becomes commonplace.
+ */
+ENTRY(xen_iret_direct)
+	/* test eflags for special cases */
+	testl $(X86_EFLAGS_VM | XEN_EFLAGS_NMI), 8(%esp)
+	jnz hyper_iret
+
+	push %eax
+	ESP_OFFSET=4	# bytes pushed onto stack
+
+	/* Store vcpu_info pointer for easy access.  Do it this
+	   way to avoid having to reload %fs */
+#ifdef CONFIG_SMP
+	GET_THREAD_INFO(%eax)
+	movl TI_cpu(%eax),%eax
+	movl __per_cpu_offset(,%eax,4),%eax
+	lea per_cpu__xen_vcpu_info(%eax),%eax
+#else
+	movl $per_cpu__xen_vcpu_info, %eax
+#endif
+
+	/* check IF state we're restoring */
+	testb $X86_EFLAGS_IF>>8, 8+1+ESP_OFFSET(%esp)
+
+	/* Maybe enable events.  Once this happens we could get a
+	   recursive event, so the critical region starts immediately
+	   afterwards.  However, if that happens we don't end up
+	   resuming the code, so we don't have to be worried about
+	   being preempted to another CPU. */
+	setz XEN_vcpu_info_mask(%eax)
+xen_iret_start_crit:
+
+	/* check for unmasked and pending */
+	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
+
+	/* If there's something pending, mask events again so we
+	   can jump back into xen_hypervisor_callback */
+	sete XEN_vcpu_info_mask(%eax)
+
+	popl %eax
+
+	/* From this point on the registers are restored and the stack
+	   updated, so we don't need to worry about it if we're preempted */
+iret_restore_end:
+
+	/* Jump to hypervisor_callback after fixing up the stack.
+	   Events are masked, so jumping out of the critical
+	   region is OK. */
+	je xen_hypervisor_callback
+
+	iret
+xen_iret_end_crit:
+
+hyper_iret:
+	/* put this out of line since its very rarely used */
+	jmp hypercall_page + __HYPERVISOR_iret * 32
+
+	.globl xen_iret_start_crit, xen_iret_end_crit
+
+/*
+   This is called by xen_hypervisor_callback in entry.S when it sees
+   that the EIP at the time of interrupt was between xen_iret_start_crit
+   and xen_iret_end_crit.  We're passed the EIP in %eax so we can do
+   a more refined determination of what to do.
+
+   The stack format at this point is:
+	----------------
+	 ss		: (ss/esp may be present if we came from usermode)
+	 esp		:
+	 eflags		}  outer exception info
+	 cs		}
+	 eip		}
+	---------------- <- edi (copy dest)
+	 eax		:  outer eax if it hasn't been restored
+	----------------
+	 eflags		}  nested exception info
+	 cs		}   (no ss/esp because we're nested
+	 eip		}    from the same ring)
+	 orig_eax	}<- esi (copy src)
+	 - - - - - - - -
+	 fs		}
+	 es		}
+	 ds		}  SAVE_ALL state
+	 eax		}
+	  :		:
+	 ebx		}
+	----------------
+	 return addr	 <- esp
+	----------------
+
+   In order to deliver the nested exception properly, we need to shift
+   everything from the return addr up to the error code so it
+   sits just under the outer exception info.  This means that when we
+   handle the exception, we do it in the context of the outer exception
+   rather than starting a new one.
+
+   The only caveat is that if the outer eax hasn't been
+   restored yet (ie, it's still on stack), we need to insert
+   its value into the SAVE_ALL state before going on, since
+   it's usermode state which we eventually need to restore.
+ */
+ENTRY(xen_iret_crit_fixup)
+	/* offsets +4 for return address */
+
+	/*
+	   Paranoia: Make sure we're really coming from userspace.
+	   Once could imagine a case where userspace jumps into the
+	   critical range address, but just before the CPU delivers a GP,
+	   it decides to deliver an interrupt instead.  Unlikely?
+	   Definitely.  Easy to avoid?  Yes.  The Intel documents
+	   explicitly say that the reported EIP for a bad jump is the
+	   jump instruction itself, not the destination, but some virtual
+	   environments get this wrong.
+	 */
+	movl PT_CS+4(%esp), %ecx
+	andl $SEGMENT_RPL_MASK, %ecx
+	cmpl $USER_RPL, %ecx
+	je 2f
+
+	lea PT_ORIG_EAX+4(%esp), %esi
+	lea PT_EFLAGS+4(%esp), %edi
+
+	/* If eip is before iret_restore_end then stack
+	   hasn't been restored yet. */
+	cmp $iret_restore_end, %eax
+	jae 1f
+
+	movl 0+4(%edi),%eax		/* copy EAX */
+	movl %eax, PT_EAX+4(%esp)
+
+	lea ESP_OFFSET(%edi),%edi	/* move dest up over saved regs */
+
+	/* set up the copy */
+1:	std
+	mov $(PT_EIP+4) / 4, %ecx	/* copy ret+saved regs up to orig_eax */
+	rep movsl
+	cld
+
+	lea 4(%edi),%esp		/* point esp to new frame */
+2:	ret
 
 
 /*
diff -puN arch/i386/xen/xen-ops.h~xen-use-iret-directly-where-possible arch/i386/xen/xen-ops.h
--- a/arch/i386/xen/xen-ops.h~xen-use-iret-directly-where-possible
+++ a/arch/i386/xen/xen-ops.h
@@ -67,4 +67,5 @@ DECL_ASM(void, xen_irq_disable_direct, v
 DECL_ASM(unsigned long, xen_save_fl_direct, void);
 DECL_ASM(void, xen_restore_fl_direct, unsigned long);
 
+void xen_iret_direct(void);
 #endif /* XEN_OPS_H */
_

Patches currently in -mm which might be from jeremy@goop.org are

git-kbuild.patch
add-kstrndup-fix.patch
xen-build-fix.patch
fix-x86_64-mm-xen-xen-smp-guest-support.patch
more-fix-x86_64-mm-xen-xen-smp-guest-support.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
fix-x86_64-mm-add-common-orderly_poweroff.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
paravirt-helper-to-disable-all-io-space-fix-2.patch
paravirt-helper-to-disable-all-io-space-fix-3.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
tidy-up-usermode-helper-waiting-a-bit-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
lguest-the-guest-code.patch
