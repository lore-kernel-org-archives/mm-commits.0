From: akpm@linux-foundation.org
Subject: - uml-fix-signal-frame-alignment.patch removed from -mm tree
Date: Fri, 02 Feb 2007 13:37:32 -0800
Message-ID: <200702022137.l12LbWvb018513@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41736 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946135AbXBBVmE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 16:42:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, antoine@nagafix.co.uk, blaisorblade@yahoo.it, bunk@stusta.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     uml: fix signal frame alignment
has been removed from the -mm tree.  Its filename was
     uml-fix-signal-frame-alignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix signal frame alignment
From: Jeff Dike <jdike@addtoit.com>

Use the same signal frame alignment calculations as the underlying
architecture.  x86_64 appeared to do this, but the "- 8" was really
subtracting 8 * sizeof(struct rt_sigframe) rather than 8 bytes.

UML/i386 might have been OK, but I changed the calculation to match
i386 just to be sure.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: <stable@kernel.org>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Acked-by: Antoine Martin <antoine@nagafix.co.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/sys-i386/signal.c   |    3 ++-
 arch/um/sys-x86_64/signal.c |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN arch/um/sys-i386/signal.c~uml-fix-signal-frame-alignment arch/um/sys-i386/signal.c
--- a/arch/um/sys-i386/signal.c~uml-fix-signal-frame-alignment
+++ a/arch/um/sys-i386/signal.c
@@ -219,7 +219,8 @@ int setup_signal_stack_sc(unsigned long 
 	unsigned long save_sp = PT_REGS_SP(regs);
 	int err = 0;
 
-	stack_top &= -8UL;
+	/* This is the same calculation as i386 - ((sp + 4) & 15) == 0 */
+	stack_top = ((stack_top + 4) & -16UL) - 4;
 	frame = (struct sigframe __user *) stack_top - 1;
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return 1;
diff -puN arch/um/sys-x86_64/signal.c~uml-fix-signal-frame-alignment arch/um/sys-x86_64/signal.c
--- a/arch/um/sys-x86_64/signal.c~uml-fix-signal-frame-alignment
+++ a/arch/um/sys-x86_64/signal.c
@@ -191,8 +191,9 @@ int setup_signal_stack_si(unsigned long 
 	struct task_struct *me = current;
 
 	frame = (struct rt_sigframe __user *)
-		round_down(stack_top - sizeof(struct rt_sigframe), 16) - 8;
-        frame = (struct rt_sigframe __user *) ((unsigned long) frame - 128);
+		round_down(stack_top - sizeof(struct rt_sigframe), 16);
+	/* Subtract 128 for a red zone and 8 for proper alignment */
+        frame = (struct rt_sigframe __user *) ((unsigned long) frame - 128 - 8);
 
 	if (!access_ok(VERIFY_WRITE, fp, sizeof(struct _fpstate)))
 		goto out;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
x86_64-32-bit-ptrace-mangles-sixth-system-call-argument.patch
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
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
proc-remove-useless-and-buggy-nlink-settings.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
