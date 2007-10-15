From: akpm@linux-foundation.org
Subject: + uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch added to -mm tree
Date: Mon, 15 Oct 2007 14:56:32 -0700
Message-ID: <200710152156.l9FLuW8G027071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43492 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755709AbXJOV4t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 17:56:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, davem@davemloft.net, jdike@linux.intel.com, shemminger@linux-foundation.org


The patch titled
     uml: header_ops conversion needed for non-ethernet drivers
has been added to the -mm tree.  Its filename is
     uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: header_ops conversion needed for non-ethernet drivers
From: Jeff Dike <jdike@addtoit.com>

UML's two non-ethernet drivers need some header_ops conversion.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Stephen Hemminger <shemminger@osdl.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/slip_kern.c  |    4 +---
 arch/um/drivers/slirp_kern.c |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff -puN arch/um/drivers/slip_kern.c~uml-header_ops-conversion-needed-for-non-ethernet-drivers arch/um/drivers/slip_kern.c
--- a/arch/um/drivers/slip_kern.c~uml-header_ops-conversion-needed-for-non-ethernet-drivers
+++ a/arch/um/drivers/slip_kern.c
@@ -30,10 +30,8 @@ void slip_init(struct net_device *dev, v
 	slip_proto_init(&spri->slip);
 
 	dev->init = NULL;
-	dev->header_cache_update = NULL;
-	dev->hard_header_cache = NULL;
-	dev->hard_header = NULL;
 	dev->hard_header_len = 0;
+	dev->header_ops = NULL;
 	dev->addr_len = 0;
 	dev->type = ARPHRD_SLIP;
 	dev->tx_queue_len = 256;
diff -puN arch/um/drivers/slirp_kern.c~uml-header_ops-conversion-needed-for-non-ethernet-drivers arch/um/drivers/slirp_kern.c
--- a/arch/um/drivers/slirp_kern.c~uml-header_ops-conversion-needed-for-non-ethernet-drivers
+++ a/arch/um/drivers/slirp_kern.c
@@ -31,9 +31,7 @@ void slirp_init(struct net_device *dev, 
 
 	dev->init = NULL;
 	dev->hard_header_len = 0;
-	dev->header_cache_update = NULL;
-	dev->hard_header_cache = NULL;
-	dev->hard_header = NULL;
+	dev->header_ops = NULL;
 	dev->addr_len = 0;
 	dev->type = ARPHRD_SLIP;
 	dev->tx_queue_len = 256;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
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
