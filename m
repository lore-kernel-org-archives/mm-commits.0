From: akpm@linux-foundation.org
Subject: - update-x86_64-mm-xen-use-iret-directly-where-possible.patch removed from -mm tree
Date: Wed, 18 Jul 2007 11:52:38 -0700
Message-ID: <200707181852.l6IIqcTw023694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42137 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934470AbXGRSzL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 14:55:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@suse.de, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     update x86_64-mm-xen-use-iret-directly-where-possible
has been removed from the -mm tree.  Its filename was
     update-x86_64-mm-xen-use-iret-directly-where-possible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: update x86_64-mm-xen-use-iret-directly-where-possible
From: Jeremy Fitzhardinge <jeremy@goop.org>

There's only a minor code change from the version you've got, but the
comments are more accurate.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/xen/xen-asm.S |   56 +++++++++++++++++++++++++-------------
 1 files changed, 37 insertions(+), 19 deletions(-)

diff -puN arch/i386/xen/xen-asm.S~update-x86_64-mm-xen-use-iret-directly-where-possible arch/i386/xen/xen-asm.S
--- a/arch/i386/xen/xen-asm.S~update-x86_64-mm-xen-use-iret-directly-where-possible
+++ a/arch/i386/xen/xen-asm.S
@@ -108,14 +108,28 @@ ENDPATCH(xen_restore_fl_direct)
 	      4: cs
 	esp-> 0: eip
 
-	This attempts to make sure that any pending events are dealt with
-	on return to usermode, but there is a small window in which an event
-	can happen just before entering usermode.  This has three effects:
-	 - There can be interrupt recursion on the stack, which is
-	   unbounded in theory (but very unlikely in practice)
-	 - New softirq events can be queued up, but they won't get
-	   processed until the cpu next enters and leaves the kernel.
-	 - Signals likewise.
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
 
 	Non-direct iret could be done in the same way, but it would
 	require an annoying amount of code duplication.  We'll assume
@@ -127,9 +141,6 @@ ENTRY(xen_iret_direct)
 	testl $(X86_EFLAGS_VM | XEN_EFLAGS_NMI), 8(%esp)
 	jnz hyper_iret
 
-	/* check IF state we're restoring */
-	testb $X86_EFLAGS_IF>>8, 8+1(%esp)
-
 	push %eax
 	ESP_OFFSET=4	# bytes pushed onto stack
 
@@ -144,6 +155,9 @@ ENTRY(xen_iret_direct)
 	movl $per_cpu__xen_vcpu_info, %eax
 #endif
 
+	/* check IF state we're restoring */
+	testb $X86_EFLAGS_IF>>8, 8+1+ESP_OFFSET(%esp)
+
 	/* Maybe enable events.  Once this happens we could get a
 	   recursive event, so the critical region starts immediately
 	   afterwards.  However, if that happens we don't end up
@@ -187,7 +201,7 @@ hyper_iret:
 
    The stack format at this point is:
 	----------------
-	 ss		:
+	 ss		: (ss/esp may be present if we came from usermode)
 	 esp		:
 	 eflags		}  outer exception info
 	 cs		}
@@ -219,17 +233,21 @@ hyper_iret:
    The only caveat is that if the outer eax hasn't been
    restored yet (ie, it's still on stack), we need to insert
    its value into the SAVE_ALL state before going on, since
-   its usermode state which we eventually need to restore.
+   it's usermode state which we eventually need to restore.
  */
 ENTRY(xen_iret_crit_fixup)
 	/* offsets +4 for return address */
 
-	/* Paranoia: make sure we're really coming from userspace.
-	   Once could imagine a case where userspace jumps into
-	   the critical range address, but just before the CPU
-	   delivers a GP, it decides to deliver an interrupt
-	   instead.  Unlikely?  Definitely.  Easy to avoid?
-	   Yes. (Some virtual environments get this wrong.) */
+	/*
+	   Paranoia: Make sure we're really coming from userspace.
+	   One could imagine a case where userspace jumps into the
+	   critical range address, but just before the CPU delivers a GP,
+	   it decides to deliver an interrupt instead.  Unlikely?
+	   Definitely.  Easy to avoid?  Yes.  The Intel documents
+	   explicitly say that the reported EIP for a bad jump is the
+	   jump instruction itself, not the destination, but some virtual
+	   environments get this wrong.
+	 */
 	movl PT_CS+4(%esp), %ecx
 	andl $SEGMENT_RPL_MASK, %ecx
 	cmpl $USER_RPL, %ecx
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
fix-the-softlockup-watchdog-to-actually-work.patch
git-kbuild.patch
fix-x86_64-mm-xen-xen-smp-guest-support.patch
fix-x86_64-mm-xen-xen-event-channels.patch
i386-minor-nx-handling-adjustment.patch
x86-fix-iounmaps-use-of-vm_structs-size-field.patch
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
lguest-the-guest-code.patch
