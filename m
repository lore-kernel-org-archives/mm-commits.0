From: akpm@linux-foundation.org
Subject: - uml-correctly-handle-skb-allocation-failures-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:49:19 -0700
Message-ID: <200710160449.l9G4nJs5009521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34610 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754925AbXJPEtX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:49:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix locking in skb alloction failure fix
has been removed from the -mm tree.  Its filename was
     uml-correctly-handle-skb-allocation-failures-fix.patch

This patch was dropped because it was folded into uml-correctly-handle-skb-allocation-failures.patch

------------------------------------------------------
Subject: uml: fix locking in skb alloction failure fix
From: Jeff Dike <jdike@addtoit.com>

Add _irqsave/_irqrestore to the locking in update_drop_skb to keep
uml_net_rx out while the drop skb is being messed with.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/um/drivers/net_kern.c~uml-correctly-handle-skb-allocation-failures-fix arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-correctly-handle-skb-allocation-failures-fix
+++ a/arch/um/drivers/net_kern.c
@@ -49,9 +49,10 @@ static int drop_max;
 static int update_drop_skb(int max)
 {
 	struct sk_buff *new;
+	unsigned long flags;
 	int err = 0;
 
-	spin_lock(&drop_lock);
+	spin_lock_irqsave(&drop_lock, flags);
 
 	if (max <= drop_max)
 		goto out;
@@ -68,7 +69,7 @@ static int update_drop_skb(int max)
 	drop_max = max;
 	err = 0;
 out:
-	spin_unlock(&drop_lock);
+	spin_unlock_irqrestore(&drop_lock, flags);
 
 	return err;
 }
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
uml-tickless-support.patch
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
