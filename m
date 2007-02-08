From: akpm@linux-foundation.org
Subject: - x86_64-32-bit-ptrace-mangles-sixth-system-call-argument.patch removed from -mm tree
Date: Thu, 08 Feb 2007 13:53:32 -0800
Message-ID: <200702082153.l18LrW40027747@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41555 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423475AbXBHVxl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 16:53:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: 32-bit ptrace mangles sixth system call argument
has been removed from the -mm tree.  Its filename was
     x86_64-32-bit-ptrace-mangles-sixth-system-call-argument.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: 32-bit ptrace mangles sixth system call argument
From: Jeff Dike <jdike@addtoit.com>

The 32-bit sysenter entry point mangles the sixth system call argument for
both 32-bit and 64-bit ptrace.  In both cases, strace shows the frame
pointer (ebp) as the sixth argument.

Here's a snippet of a 64-bit strace of a 32-bit test program which
calls mmap through sysenter:

mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0xfff00fcc) = 0xfffffffff7f7a000
fstat64(0x1, 0xfff008d8)                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0xfff0089c) = 0xfffffffff7f79000
write(1, "mmap returns 0xf7f7a000\n", 24mmap returns 0xf7f7a000
) = 24

Here's a 32-bit strace of the same program:

mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0xffc224ec) = 0xf7fcb000
fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 1), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0xffc21dbc) = 0xf7fca000
write(1, "mmap returns 0xf7fcb000\n", 24mmap returns 0xf7fcb000
) = 24

The first mmap is the one made by the test - its final argument (the
offset) is 0, but strace shows 0xfff00fcc, which is the value of ebp.
The second is a guilty bystander which is also showing the bug.

The patch below copies %r9 (where the sixth argument has been
stashed) into the RBP slot of pt_regs before syscall_trace_enter is
called.  This fixes ptrace.

To allow a successful return to userspace, the original value of rbp
must be restored.  This is done by storing the current value of rbp
into the RBP slot of pt_regs before the RESTORE_REST.

With this patch, the straces now look like this:

64-bit:

mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xfffffffff7f5a000
fstat64(0x1, 0xff926ee8)                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xfffffffff7f59000
write(1, "mmap returns 0xf7f5a000\n", 24mmap returns 0xf7f5a000
) = 24

32-bit:

mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xf7fa9000
fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 1), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xf7fa8000
write(1, "mmap returns 0xf7fa9000\n", 24mmap returns 0xf7fa9000
) = 24

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/ia32/ia32entry.S |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN arch/x86_64/ia32/ia32entry.S~x86_64-32-bit-ptrace-mangles-sixth-system-call-argument arch/x86_64/ia32/ia32entry.S
--- a/arch/x86_64/ia32/ia32entry.S~x86_64-32-bit-ptrace-mangles-sixth-system-call-argument
+++ a/arch/x86_64/ia32/ia32entry.S
@@ -148,11 +148,23 @@ sysenter_do_call:	
 sysenter_tracesys:
 	CFI_RESTORE_STATE
 	SAVE_REST
+	/*
+	 * We need the 6th system call argument to be in regs->rbp at
+	 * this point so that ptrace will see it.  It's in r9 now, so copy
+	 * it to the rbp slot now.
+	 */
+	movq	%r9, RBP(%rsp)
 	CLEAR_RREGS
 	movq	$-ENOSYS,RAX(%rsp)	/* really needed? */
 	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
 	call	syscall_trace_enter
 	LOAD_ARGS ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	/*
+	 * Now, we need the correct value of rbp to be restored.  It
+	 * was never munged, so we can save it to the rbp slot and
+	 * just have it restored.
+	 */
+	movq	%rbp, RBP(%rsp)
 	RESTORE_REST
 	movl	%ebp, %ebp
 	/* no need to do an access_ok check here because rbp has been
_

Patches currently in -mm which might be from jdike@addtoit.com are

optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs-fix.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-initialize-a-list-head.patch
uml-make-time-data-per-cpu.patch
uml-delete-unused-file.patch
uml-remove-unused-variable-and-function.patch
uml-make-signal-handlers-static.patch
uml-const-a-variable.patch
uml-remove-code-controlled-by-non-existent-config-option.patch
uml-add-per-device-queues-and-locks-to-ubd-driver.patch
uml-locking-fixes-in-the-ubd-driver.patch
uml-locking-comments-in-memory-and-tempfile-code.patch
uml-locking-comments-in-startup-code.patch
uml-style-fixes-in-startup-code.patch
uml-libc-dependent-code-should-call-libc-directly.patch
uml-fix-style-violations.patch
uml-fix-apparent-config_64_bit-typo.patch
uml-irq-handler-tidying.patch
uml-sigio-locking-comment.patch
uml-sigio-formatting-fixes.patch
uml-umid-tidying.patch
uml-elf-locking-commentary.patch
uml-register-handling-formatting-fixes.patch
uml-aio-locking-and-tidying.patch
uml-fix-prototypes.patch
proc-remove-useless-and-buggy-nlink-settings.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
