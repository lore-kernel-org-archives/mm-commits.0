From: akpm@linux-foundation.org
Subject: - uml-move-um_virt_to_phys.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:36:26 -0800
Message-ID: <200802052236.m15Ma7A8012682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41985 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762543AbYBEWls (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: move um_virt_to_phys
has been removed from the -mm tree.  Its filename was
     uml-move-um_virt_to_phys.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -26,7 +26,6 @@ EXPORT_SYMBOL(get_kmem_end);
 
 EXPORT_SYMBOL(high_physmem);
 EXPORT_SYMBOL(empty_zero_page);
-EXPORT_SYMBOL(um_virt_to_phys);
 EXPORT_SYMBOL(handle_page_fault);
 EXPORT_SYMBOL(find_iomem);
 
diff -puN arch/um/kernel/process.c~uml-move-um_virt_to_phys arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-move-um_virt_to_phys
+++ a/arch/um/kernel/process.c
@@ -255,49 +255,6 @@ void cpu_idle(void)
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
 void dump_thread(struct pt_regs *regs, struct user *u)
 {
 }
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

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
