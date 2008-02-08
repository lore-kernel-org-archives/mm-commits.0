From: akpm@linux-foundation.org
Subject: - aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:41:32 -0800
Message-ID: <200802080841.m188fDEi016044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53879 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbYBHImi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:42:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, dhowells@redhat.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: re-remove accidentally restored code
has been removed from the -mm tree.  Its filename was
     aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch

This patch was dropped because it was folded into aout-suppress-aout-library-support-if-config_arch_supports_aout.patch

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

origin.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
mount-options-fix-hostfs.patch
uml-runtime-host-vmsplit-detection.patch
uml-style-fixes-in-arch-um-os-linux.patch
uml-x86_64-should-copy-%fs-during-fork.patch
uml-fix-mm_context-memory-leak.patch
