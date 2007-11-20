From: akpm@linux-foundation.org
Subject: + uml-move-um_virt_to_phys.patch added to -mm tree
Date: Mon, 19 Nov 2007 16:21:59 -0800
Message-ID: <200711200022.lAK0M0fC004152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40866 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836AbXKTAWg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 19:22:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: move um_virt_to_phys
has been added to the -mm tree.  Its filename is
     uml-move-um_virt_to_phys.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: move um_virt_to_phys
From: Jeff Dike <jdike@addtoit.com>

This patchset makes UML build and run with three-level page tables on
32-bit hosts.  This is an uncommon use case, but the code here needed
fixing and cleaning up, so 32-bit three-level pages tables were tested
to make sure the changes are good.

Patch 1 - code movement
Patch 2 - header untangling
Patch 3 - style fixups in files affected so far
Patch 4 - clean up use of current.h
Patch 5 - fix sizes of types that are different between 2 and 3-level
	page tables - three-level page table support should build at
	this point
Patch 6 - tidy (i.e. eliminate much of) the code that figures out how
	big the address space is
Patch 7 - change um_virt_to_phys into virt_to_pte, clean its
	interface, and clean its (so far) one caller
Patch 8 - the stub pages are covered with a VMA, allowing some nasty
	code to be thrown out - three-level page tables now work

This patch:

um_virt_to_phys only has one user, so it can be moved to the same file
and made static.  Its declarations in pgtable.h and ksyms.c are also
gone.

current_cmd was another apparent user, but it itself isn't used, so it
is deleted.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/ksyms.c        |    1 
 arch/um/kernel/process.c      |   43 --------------------------------
 arch/um/kernel/skas/uaccess.c |   34 +++++++++++++++++++++++--
 include/asm-um/pgtable.h      |    3 --
 4 files changed, 32 insertions(+), 49 deletions(-)

diff -puN arch/um/kernel/ksyms.c~uml-move-um_virt_to_phys arch/um/kernel/ksyms.c
--- a/arch/um/kernel/ksyms.c~uml-move-um_virt_to_phys
+++ a/arch/um/kernel/ksyms.c
@@ -25,7 +25,6 @@ EXPORT_SYMBOL(get_kmem_end);
 
 EXPORT_SYMBOL(high_physmem);
 EXPORT_SYMBOL(empty_zero_page);
-EXPORT_SYMBOL(um_virt_to_phys);
 EXPORT_SYMBOL(handle_page_fault);
 EXPORT_SYMBOL(find_iomem);
 
diff -puN arch/um/kernel/process.c~uml-move-um_virt_to_phys arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-move-um_virt_to_phys
+++ a/arch/um/kernel/process.c
@@ -256,49 +256,6 @@ void cpu_idle(void)
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
diff -puN arch/um/kernel/skas/uaccess.c~uml-move-um_virt_to_phys arch/um/kernel/skas/uaccess.c
--- a/arch/um/kernel/skas/uaccess.c~uml-move-um_virt_to_phys
+++ a/arch/um/kernel/skas/uaccess.c
@@ -12,8 +12,38 @@
 #include "kern_util.h"
 #include "os.h"
 
-extern void *um_virt_to_phys(struct task_struct *task, unsigned long addr,
-			     pte_t *pte_out);
+static void *um_virt_to_phys(struct task_struct *task, unsigned long addr,
+			     pte_t *pte_out)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+	pte_t ptent;
+
+	if (task->mm == NULL)
+		return ERR_PTR(-EINVAL);
+	pgd = pgd_offset(task->mm, addr);
+	if (!pgd_present(*pgd))
+		return ERR_PTR(-EINVAL);
+
+	pud = pud_offset(pgd, addr);
+	if (!pud_present(*pud))
+		return ERR_PTR(-EINVAL);
+
+	pmd = pmd_offset(pud, addr);
+	if (!pmd_present(*pmd))
+		return ERR_PTR(-EINVAL);
+
+	pte = pte_offset_kernel(pmd, addr);
+	ptent = *pte;
+	if (!pte_present(ptent))
+		return ERR_PTR(-EINVAL);
+
+	if (pte_out != NULL)
+		*pte_out = ptent;
+	return (void *) (pte_val(ptent) & PAGE_MASK) + (addr & ~PAGE_MASK);
+}
 
 static unsigned long maybe_map(unsigned long virt, int is_write)
 {
diff -puN include/asm-um/pgtable.h~uml-move-um_virt_to_phys include/asm-um/pgtable.h
--- a/include/asm-um/pgtable.h~uml-move-um_virt_to_phys
+++ a/include/asm-um/pgtable.h
@@ -31,9 +31,6 @@
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
-extern void *um_virt_to_phys(struct task_struct *task, unsigned long virt,
-			     pte_t *pte_out);
-
 /* zero page used for uninitialized stuff */
 extern unsigned long *empty_zero_page;
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
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
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-clean-up-task-size-calculation.patch
uml-add-virt_to_pte.patch
uml-cover-stubs-with-a-vma.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
