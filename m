From: akpm@linux-foundation.org
Subject: + aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch added to -mm tree
Date: Thu, 10 Jan 2008 00:02:57 -0800
Message-ID: <200801100802.m0A82bcs012009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33387 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752214AbYAJIDT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 03:03:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, dhowells@redhat.com, jdike@linux.intel.com


The patch titled
     uml: re-remove accidentally restored code
has been added to the -mm tree.  Its filename is
     aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: re-remove accidentally restored code
From: Jeff Dike <jdike@addtoit.com>

aout-suppress-aout-library-support-if-config_arch_supports_aout.patch restores
some code which had been deleted by uml-move-um_virt_to_phys.patch and
uml-add-virt_to_pte.patch, presumably due to a botched diff.

This patch gets rid of it again.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/process.c |   44 -------------------------------------
 1 file changed, 44 deletions(-)

diff -puN arch/um/kernel/process.c~aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code
+++ a/arch/um/kernel/process.c
@@ -6,7 +6,6 @@
 
 #include <linux/stddef.h>
 #include <linux/err.h>
-#include <linux/module.h>
 #include <linux/hardirq.h>
 #include <linux/gfp.h>
 #include <linux/mm.h>
@@ -259,49 +258,6 @@ void cpu_idle(void)
 	default_idle();
 }
 
-void *um_virt_to_phys(struct task_struct *task, unsigned long addr,
-		      pte_t *pte_out)
-{
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-	pte_t ptent;
-
-	if (task->mm == NULL)
-		return ERR_PTR(-EINVAL);
-	pgd = pgd_offset(task->mm, addr);
-	if (!pgd_present(*pgd))
-		return ERR_PTR(-EINVAL);
-
-	pud = pud_offset(pgd, addr);
-	if (!pud_present(*pud))
-		return ERR_PTR(-EINVAL);
-
-	pmd = pmd_offset(pud, addr);
-	if (!pmd_present(*pmd))
-		return ERR_PTR(-EINVAL);
-
-	pte = pte_offset_kernel(pmd, addr);
-	ptent = *pte;
-	if (!pte_present(ptent))
-		return ERR_PTR(-EINVAL);
-
-	if (pte_out != NULL)
-		*pte_out = ptent;
-	return (void *) (pte_val(ptent) & PAGE_MASK) + (addr & ~PAGE_MASK);
-}
-
-char *current_cmd(void)
-{
-#if defined(CONFIG_SMP) || defined(CONFIG_HIGHMEM)
-	return "(Unknown)";
-#else
-	void *addr = um_virt_to_phys(current, current->mm->arg_start, NULL);
-	return IS_ERR(addr) ? "(Unknown)": __va((unsigned long) addr);
-#endif
-}
-
 int __cant_sleep(void) {
 	return in_atomic() || irqs_disabled() || in_interrupt();
 	/* Is in_interrupt() really needed? */
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
git-x86.patch
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
fix-__const_udelay-declaration-and-definition-mismatches.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
