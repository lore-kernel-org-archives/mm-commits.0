From: akpm@linux-foundation.org
Subject: - uml-rename-pt_regs-general-purpose-register-file-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:47:46 -0700
Message-ID: <200710160447.l9G4lk73009475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43648 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752971AbXJPEru (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:47:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: refix ELF_CORE_COPY_REGS
has been removed from the -mm tree.  Its filename was
     uml-rename-pt_regs-general-purpose-register-file-fix.patch

This patch was dropped because it was folded into uml-rename-pt_regs-general-purpose-register-file.patch

------------------------------------------------------
Subject: uml: refix ELF_CORE_COPY_REGS
From: Jeff Dike <jdike@addtoit.com>

The former uml-fix-x86_64-core-dump-crash.patch expressed
ELF_CORE_COPY_REGS in terms of the pt_regs struct currently in -mm.  I
fast-tracked this to mainline, where it was wrong because the pt_regs
struct there hadn't been changed.  Fixing that then made the patch wrong
for -mm when it was rebased on -rc6.

This patch changes things back again to be right for -mm.  This should
go to mainline after uml-rename-pt_regs-general-purpose-register-file.patch

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/elf-x86_64.h |   42 +++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff -puN include/asm-um/elf-x86_64.h~uml-rename-pt_regs-general-purpose-register-file-fix include/asm-um/elf-x86_64.h
--- a/include/asm-um/elf-x86_64.h~uml-rename-pt_regs-general-purpose-register-file-fix
+++ a/include/asm-um/elf-x86_64.h
@@ -67,27 +67,27 @@ typedef struct { } elf_fpregset_t;
 } while (0)
 
 #define ELF_CORE_COPY_REGS(pr_reg, regs)		\
-	(pr_reg)[0] = (regs)->regs.skas.regs[0];			\
-	(pr_reg)[1] = (regs)->regs.skas.regs[1];			\
-	(pr_reg)[2] = (regs)->regs.skas.regs[2];			\
-	(pr_reg)[3] = (regs)->regs.skas.regs[3];			\
-	(pr_reg)[4] = (regs)->regs.skas.regs[4];			\
-	(pr_reg)[5] = (regs)->regs.skas.regs[5];			\
-	(pr_reg)[6] = (regs)->regs.skas.regs[6];			\
-	(pr_reg)[7] = (regs)->regs.skas.regs[7];			\
-	(pr_reg)[8] = (regs)->regs.skas.regs[8];			\
-	(pr_reg)[9] = (regs)->regs.skas.regs[9];			\
-	(pr_reg)[10] = (regs)->regs.skas.regs[10];			\
-	(pr_reg)[11] = (regs)->regs.skas.regs[11];			\
-	(pr_reg)[12] = (regs)->regs.skas.regs[12];			\
-	(pr_reg)[13] = (regs)->regs.skas.regs[13];			\
-	(pr_reg)[14] = (regs)->regs.skas.regs[14];			\
-	(pr_reg)[15] = (regs)->regs.skas.regs[15];			\
-	(pr_reg)[16] = (regs)->regs.skas.regs[16];			\
-	(pr_reg)[17] = (regs)->regs.skas.regs[17];			\
-	(pr_reg)[18] = (regs)->regs.skas.regs[18];			\
-	(pr_reg)[19] = (regs)->regs.skas.regs[19];			\
-	(pr_reg)[20] = (regs)->regs.skas.regs[20];			\
+	(pr_reg)[0] = (regs)->regs.gp[0];			\
+	(pr_reg)[1] = (regs)->regs.gp[1];			\
+	(pr_reg)[2] = (regs)->regs.gp[2];			\
+	(pr_reg)[3] = (regs)->regs.gp[3];			\
+	(pr_reg)[4] = (regs)->regs.gp[4];			\
+	(pr_reg)[5] = (regs)->regs.gp[5];			\
+	(pr_reg)[6] = (regs)->regs.gp[6];			\
+	(pr_reg)[7] = (regs)->regs.gp[7];			\
+	(pr_reg)[8] = (regs)->regs.gp[8];			\
+	(pr_reg)[9] = (regs)->regs.gp[9];			\
+	(pr_reg)[10] = (regs)->regs.gp[10];			\
+	(pr_reg)[11] = (regs)->regs.gp[11];			\
+	(pr_reg)[12] = (regs)->regs.gp[12];			\
+	(pr_reg)[13] = (regs)->regs.gp[13];			\
+	(pr_reg)[14] = (regs)->regs.gp[14];			\
+	(pr_reg)[15] = (regs)->regs.gp[15];			\
+	(pr_reg)[16] = (regs)->regs.gp[16];			\
+	(pr_reg)[17] = (regs)->regs.gp[17];			\
+	(pr_reg)[18] = (regs)->regs.gp[18];			\
+	(pr_reg)[19] = (regs)->regs.gp[19];			\
+	(pr_reg)[20] = (regs)->regs.gp[20];			\
 	(pr_reg)[21] = current->thread.arch.fs;			\
 	(pr_reg)[22] = 0;					\
 	(pr_reg)[23] = 0;					\
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
