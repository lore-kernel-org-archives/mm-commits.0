From: akpm@linux-foundation.org
Subject: - uml-implement-get_wchan-fix.patch removed from -mm tree
Date: Sun, 03 Feb 2008 20:06:08 -0800
Message-ID: <200802040405.m1445nu8013084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38211 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754538AbYBDEF7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 23:05:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: get_wchan fixes
has been removed from the -mm tree.  Its filename was
     uml-implement-get_wchan-fix.patch

This patch was dropped because it was folded into uml-implement-get_wchan.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: get_wchan fixes
From: Jeff Dike <jdike@addtoit.com>

The previous get_wchan patch needed some more work.  Joe Perches suggested the
use of bool where I was using a counter.  It also turned out not to work so
well on x86_64, so I changed the algorithm a bit.  Instead of skipping one
frame and looking for the next non-sched symbol, it now looks for at least one
scheduler frame, then returns the first symbol seen above that.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/process.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN arch/um/kernel/process.c~uml-implement-get_wchan-fix arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-implement-get_wchan-fix
+++ a/arch/um/kernel/process.c
@@ -462,7 +462,8 @@ unsigned long arch_align_stack(unsigned 
 
 unsigned long get_wchan(struct task_struct *p)
 {
-	unsigned long stack_page, sp, ip, count = 0;
+	unsigned long stack_page, sp, ip;
+	bool seen_sched = 0;
 
 	if ((p == NULL) || (p == current) || (p->state == TASK_RUNNING))
 		return 0;
@@ -482,14 +483,11 @@ unsigned long get_wchan(struct task_stru
 
 	while (sp < stack_page + THREAD_SIZE) {
 		ip = *((unsigned long *) sp);
-		if (kernel_text_address(ip) && !in_sched_functions(ip)) {
-			/*
-			 * Skip one valid IP, which will be the low-level UML
-			 * context switcher.
-			 */
-			if (count++ == 1)
-				return ip;
-		}
+		if (in_sched_functions(ip))
+			/* Ignore everything until we're above the scheduler */
+			seen_sched = 1;
+		else if (kernel_text_address(ip) && seen_sched)
+			return ip;
 
 		sp += sizeof(unsigned long);
 	}
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
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
uml-clean-up-task_size-usage.patch
uml-cover-stubs-with-a-vma.patch
uml-fix-command-line-cflags-and-ldflags-support.patch
uml-style-fixes-in-arch-um-os-linux.patch
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
uml-remove-map_cb.patch
uml-use-of-a-public-mac-is-a-warning-not-an-error.patch
uml-defconfig-tweaks.patch
uml-redo-the-calculation-of-nr_syscalls.patch
uml-make-mconsole_stack-namespace-aware.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
