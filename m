From: akpm@linux-foundation.org
Subject: - uml-improve-detection-of-host-cmov-checkpatch-fixes-fix.patch removed from -mm tree
Date: Sun, 03 Feb 2008 20:06:53 -0800
Message-ID: <200802040406.m1446YnD013105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41325 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754645AbYBDEGh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 23:06:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@linux.intel.com, magotari@gmail.com, mm-commits@vger.kernel.org


The patch titled
     uml-improve-detection-of-host-cmov-checkpatch-fixes-fix
has been removed from the -mm tree.  Its filename was
     uml-improve-detection-of-host-cmov-checkpatch-fixes-fix.patch

This patch was dropped because it was folded into uml-improve-detection-of-host-cmov.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml-improve-detection-of-host-cmov-checkpatch-fixes-fix
From: Jeff Dike <jdike@linux.intel.com>

Cc: Jeff Dike <jdike@linux.intel.com>
Cc: Karol Swietlicki <magotari@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/common-offsets.h |    1 +
 arch/um/sys-i386/bugs.c          |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/um/include/common-offsets.h~uml-improve-detection-of-host-cmov-checkpatch-fixes-fix arch/um/include/common-offsets.h
--- a/arch/um/include/common-offsets.h~uml-improve-detection-of-host-cmov-checkpatch-fixes-fix
+++ a/arch/um/include/common-offsets.h
@@ -18,6 +18,7 @@ DEFINE_STR(UM_KERN_WARNING, KERN_WARNING
 DEFINE_STR(UM_KERN_NOTICE, KERN_NOTICE);
 DEFINE_STR(UM_KERN_INFO, KERN_INFO);
 DEFINE_STR(UM_KERN_DEBUG, KERN_DEBUG);
+DEFINE_STR(UM_KERN_CONT, KERN_CONT);
 
 DEFINE(UM_ELF_CLASS, ELF_CLASS);
 DEFINE(UM_ELFCLASS32, ELFCLASS32);
diff -puN arch/um/sys-i386/bugs.c~uml-improve-detection-of-host-cmov-checkpatch-fixes-fix arch/um/sys-i386/bugs.c
--- a/arch/um/sys-i386/bugs.c~uml-improve-detection-of-host-cmov-checkpatch-fixes-fix
+++ a/arch/um/sys-i386/bugs.c
@@ -39,9 +39,9 @@ static void test_for_host_cmov(void)
 	if (setjmp(cmov_test_return) == 0) {
 		unsigned long foo = 0;
 		__asm__ __volatile__("cmovz %0, %1" : "=r" (foo) : "0" (foo));
-		printk(KERN_CONT "Yes\n");
+		printk(UM_KERN_CONT "Yes\n");
 	} else
-		printk(KERN_CONT "No\n");
+		printk(UM_KERN_CONT "No\n");
 
 	sigaction(SIGILL, &old, &new);
 }
_

Patches currently in -mm which might be from jdike@linux.intel.com are

origin.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-remove-xmm-checking-on-x86.patch
uml-code-tidying-under-arch-um-os-linux.patch
uml-implement-get_wchan.patch
uml-get-rid-of-asmlinkage.patch
uml-document-new-ubd-flag.patch
uml-fix-urls-in-kconfig-and-help-strings.patch
uml-improve-detection-of-host-cmov.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes-fix.patch
uml-remove-now-unused-code.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-const-and-other-tidying.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-gprof-needs-to-depend-on-frame_pointer.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
uml-remove-unused-variables-in-the-context-switcher.patch
uml-convert-functions-to-void.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-header-untangling-fix.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
uml-add-missing-space.patch
uml-clean-up-task_size-usage.patch
uml-cover-stubs-with-a-vma.patch
uml-fix-command-line-cflags-and-ldflags-support.patch
uml-style-fixes-in-arch-um-os-linux.patch
uml-remove-duplicate-config-symbol-and-unused-file-and-variables.patch
uml-fix-mconsole-stop.patch
uml-miscellaneous-code-cleanups.patch
uml-style-fixes-in-filec.patch
uml-64-bit-tlb-fixes.patch
uml-customize-tlbh.patch
uml-eliminate-setjmp_wrapper.patch
uml-install-panic-notifier-earlier.patch
uml-use-barrier-instead-of-mb.patch
uml-tidy-helper-code.patch
uml-dont-kill-pid-0.patch
uml-get-rid-of-syscall-counters.patch
uml-dont-allow-processes-to-call-into-stub.patch
uml-move-sig_handler_common_skas.patch
uml-clean-up-sig_handler_common_skas.patch
uml-style-fixes-in-arch-um-kernel.patch
uml-fix-hostfs-tv_usec-calculations.patch
uml-signal-handling-tidying.patch
uml-remove-init_irq_signals.patch
uml-smp-locking-commentary.patch
uml-implement-o_append.patch
uml-remove-fakehd.patch
uml-debug_shirq-fixes.patch
uml-add-back-config_hz.patch
uml-style-fixes-in-arch-um-sys-x86_64.patch
uml-add-newlines-to-printks.patch
uml-move-register-initialization.patch
uml-remove-unused-fields-from-mm_context.patch
uml-remove-topdir.patch
uml-spelling-fix.patch
uml-remove-map_cb.patch
uml-fix-infinite-mconsole-loop.patch
uml-use-of-a-public-mac-is-a-warning-not-an-error.patch
uml-ldt-mutex-conversion.patch
uml-mconsole-mutex-conversion.patch
uml-port-mutex-conversion.patch
uml-defconfig-tweaks.patch
uml-redo-the-calculation-of-nr_syscalls.patch
uml-make-mconsole_stack-namespace-aware.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
