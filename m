From: akpm@linux-foundation.org
Subject: - uml-stop-saving-process-fp-state-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:46:32 -0700
Message-ID: <200710160446.l9G4kWhk009435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42927 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbXJPEqm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:46:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     UML - Fix registers.c build
has been removed from the -mm tree.  Its filename was
     uml-stop-saving-process-fp-state-fix.patch

This patch was dropped because it was folded into uml-stop-saving-process-fp-state.patch

------------------------------------------------------
Subject: UML - Fix registers.c build
From: Jeff Dike <jdike@addtoit.com>

uml-stop-saving-process-fp-state.patch broke the UML/x86_64 build.

On x86_64, sys/ptrace.h has to be included before asm/ptrace.h.
Otherwise, the defines in asm/ptrace.h will ruin the parse of
sys/ptrace.h -
    asm/ptrace.h:
	#define PTRACE_GETREGS            12

    sys/ptrace.h:
	enum __ptrace_request
	{
	...
	   PTRACE_GETREGS = 12,
	...
	}

Also, errno.h was missing.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/sys-x86_64/registers.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/um/os-Linux/sys-x86_64/registers.c~uml-stop-saving-process-fp-state-fix arch/um/os-Linux/sys-x86_64/registers.c
--- a/arch/um/os-Linux/sys-x86_64/registers.c~uml-stop-saving-process-fp-state-fix
+++ a/arch/um/os-Linux/sys-x86_64/registers.c
@@ -3,9 +3,10 @@
  * Licensed under the GPL
  */
 
+#include <errno.h>
+#include <sys/ptrace.h>
 #define __FRAME_OFFSETS
 #include <asm/ptrace.h>
-#include <sys/ptrace.h>
 #include "longjmp.h"
 #include "user.h"
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-stop-saving-process-fp-state-fix.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-rename-pt_regs-general-purpose-register-file-fix.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
uml-fix-inlines.patch
uml-userspace-files-should-call-libc-directly.patch
uml-clean-up-tlb-flush-path.patch
uml-remove-unneeded-if-from-hostfs.patch
uml-fix-hostfs-style.patch
uml-dont-use-glibc-asm-userh.patch
uml-floating-point-signal-delivery-fixes.patch
uml-ptrace-floating-point-fixes.patch
uml-coredumping-floating-point-fixes.patch
uml-sysrq-and-mconsole-fixes.patch
uml-style-fixes-in-fp-code.patch
uml-eliminate-floating-point-state-from-register-file.patch
uml-remove-unused-file.patch
uml-more-idiomatic-parameter-parsing.patch
uml-eliminate-hz.patch
uml-fix-timer-switching.patch
uml-simplify-interval-setting.patch
uml-separate-timer-initialization.patch
uml-generic_time-support.patch
uml-generic_clockevents-support.patch
uml-clocksource-support.patch
uml-clocksource-support-fix.patch
uml-tickless-support.patch
uml-tickless-support-fix.patch
uml-eliminate-interrupts-in-the-idle-loop.patch
uml-time-build-fix.patch
uml-eliminate-sigalrm.patch
uml-use-sec_per_sec-constants.patch
uml-network-formatting.patch
uml-network-driver-mtu-cleanups.patch
uml-correctly-handle-skb-allocation-failures.patch
uml-correctly-handle-skb-allocation-failures-fix.patch
uml-fix-stub-address-calculations.patch
uml-fix-stub-address-calculations-checkpatch-fixes.patch
uml-arch-um-drivers-formatting.patch
uml-arch-um-drivers-formatting-checkpatch-fixes.patch
bitops-introduce-lock-ops.patch
