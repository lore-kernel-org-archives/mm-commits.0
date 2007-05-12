From: akpm@linux-foundation.org
Subject: - revert-paravirt-add-startup-infrastructure-for-paravirtualization.patch removed from -mm tree
Date: Fri, 11 May 2007 22:15:23 -0700
Message-ID: <200705120515.l4C5FNvJ001746@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756656AbXELFQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:16:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, ak@suse.de, chrisw@sous-sol.org, hpa@zytor.com, jeremy@goop.org, rusty@rustcorp.com.au, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     Revert "[PATCH] paravirt: Add startup infrastructure for paravirtualization"
has been removed from the -mm tree.  Its filename was
     revert-paravirt-add-startup-infrastructure-for-paravirtualization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Revert "[PATCH] paravirt: Add startup infrastructure for paravirtualization"
From: Eric W. Biederman <ebiederm@xmission.com>

This reverts commit c9ccf30d77f04064fe5436027ab9d2230c7cdd94.

Entering the kernel at startup_32 without passing our real mode data in
%esi, and without guaranteeing that physical and virtual addresses are
identity mapped makes head.S impossible to maintain.

The only user of this infrastructure is lguest which is not merged so
nothing we currently support will break by removing this over designed
nightmare, and only the pending lguest patches will be affected.  The
pending Xen patches have a different entry point that they use.

We are currently discussing what Xen and lguest need to do to boot the
kernel in a more normal fashion so using startup_32 in this weird manner is
clearly not their long term direction.

So let's remove this code in head.S before it causes brain damage to people
trying to maintain head.S

Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Zachary Amsden <zach@vmware.com>
CC: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/head.S        |   38 -------------------------------
 arch/i386/kernel/paravirt.c    |    1 
 arch/i386/kernel/vmlinux.lds.S |    6 ----
 include/asm-i386/paravirt.h    |    5 ----
 4 files changed, 50 deletions(-)

diff -puN arch/i386/kernel/head.S~revert-paravirt-add-startup-infrastructure-for-paravirtualization arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S~revert-paravirt-add-startup-infrastructure-for-paravirtualization
+++ a/arch/i386/kernel/head.S
@@ -71,12 +71,6 @@ INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + 
 .section .text.head,"ax",@progbits
 ENTRY(startup_32)
 
-#ifdef CONFIG_PARAVIRT
-        movl %cs, %eax
-        testl $0x3, %eax
-        jnz startup_paravirt
-#endif
-
 /*
  * Set segments to known values.
  */
@@ -501,38 +495,6 @@ ignore_int:
 	iret
 
 .section .text
-#ifdef CONFIG_PARAVIRT
-startup_paravirt:
-	cld
- 	movl $(init_thread_union+THREAD_SIZE),%esp
-
-	/* We take pains to preserve all the regs. */
-	pushl	%edx
-	pushl	%ecx
-	pushl	%eax
-
-	pushl	$__start_paravirtprobe
-1:
-	movl	0(%esp), %eax
-	cmpl	$__stop_paravirtprobe, %eax
-	je	unhandled_paravirt
-	pushl	(%eax)
-	movl	8(%esp), %eax
-	call	*(%esp)
-	popl	%eax
-
-	movl	4(%esp), %eax
-	movl	8(%esp), %ecx
-	movl	12(%esp), %edx
-
-	addl	$4, (%esp)
-	jmp	1b
-
-unhandled_paravirt:
-	/* Nothing wanted us: we're screwed. */
-	ud2
-#endif
-
 /*
  * Real beginning of normal "text" segment
  */
diff -puN arch/i386/kernel/paravirt.c~revert-paravirt-add-startup-infrastructure-for-paravirtualization arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~revert-paravirt-add-startup-infrastructure-for-paravirtualization
+++ a/arch/i386/kernel/paravirt.c
@@ -19,7 +19,6 @@
 #include <linux/module.h>
 #include <linux/efi.h>
 #include <linux/bcd.h>
-#include <linux/start_kernel.h>
 #include <linux/highmem.h>
 
 #include <asm/bug.h>
diff -puN arch/i386/kernel/vmlinux.lds.S~revert-paravirt-add-startup-infrastructure-for-paravirtualization arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S~revert-paravirt-add-startup-infrastructure-for-paravirtualization
+++ a/arch/i386/kernel/vmlinux.lds.S
@@ -78,12 +78,6 @@ SECTIONS
 	CONSTRUCTORS
 	} :data
 
-  .paravirtprobe : AT(ADDR(.paravirtprobe) - LOAD_OFFSET) {
-  	__start_paravirtprobe = .;
-	*(.paravirtprobe)
-  	__stop_paravirtprobe = .;
-  }
-
   . = ALIGN(4096);
   .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
   	__nosave_begin = .;
diff -puN include/asm-i386/paravirt.h~revert-paravirt-add-startup-infrastructure-for-paravirtualization include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~revert-paravirt-add-startup-infrastructure-for-paravirtualization
+++ a/include/asm-i386/paravirt.h
@@ -222,11 +222,6 @@ struct paravirt_ops
 	void (*iret)(void);
 };
 
-/* Mark a paravirt probe function. */
-#define paravirt_probe(fn)						\
- static asmlinkage void (*__paravirtprobe_##fn)(void) __attribute_used__ \
-		__attribute__((__section__(".paravirtprobe"))) = fn
-
 extern struct paravirt_ops paravirt_ops;
 
 #define PARAVIRT_PATCH(x)					\
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
x86_64-display-more-intutive-error-message-if-kernel-is-not-2mb-aligned.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
iop13xx-msi-support-rev6.patch
dvb_en_50221-convert-to-kthread-api.patch
fix-i-oat-for-kexec.patch
pci-disable-msi-by-default-on-systems-with-serverworks-ht1000-chips.patch
x86-use-elfnoteh-to-generate-vsyscall-notes.patch
i386-efi-fix-proc-iomem-type-for-kexec-tools.patch
i386-move-common-parts-of-smp-into-their-own-file.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-potential-race-between-refrigerator-and-thaw_tasks.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
freezer-fix-pf_nofreeze-vs-freezeable-race.patch
freezer-move-frozen_process-to-kernel-power-processc.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
