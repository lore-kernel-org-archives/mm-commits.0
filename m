From: akpm@linux-foundation.org
Subject: + uml-add-virt_to_pte.patch added to -mm tree
Date: Mon, 19 Nov 2007 16:22:13 -0800
Message-ID: <200711200022.lAK0MDrA004184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58562 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752210AbXKTAWu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 19:22:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: add virt_to_pte
has been added to the -mm tree.  Its filename is
     uml-add-virt_to_pte.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: add virt_to_pte
From: Jeff Dike <jdike@addtoit.com>

Turn um_virt_to_phys into virt_to_pte, cleaning up a horrid interface.

It's also made non-static and declared in pgtable.h because it'll be
needed when the stubs get a vma.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/skas/uaccess.c |   56 +++++++++++++-------------------
 include/asm-um/pgtable.h      |    3 +
 2 files changed, 26 insertions(+), 33 deletions(-)

diff -puN arch/um/kernel/skas/uaccess.c~uml-add-virt_to_pte arch/um/kernel/skas/uaccess.c
--- a/arch/um/kernel/skas/uaccess.c~uml-add-virt_to_pte
+++ a/arch/um/kernel/skas/uaccess.c
@@ -13,70 +13,60 @@
 #include "kern_util.h"
 #include "os.h"
 
-static void *um_virt_to_phys(struct task_struct *task, unsigned long addr,
-			     pte_t *pte_out)
+pte_t *virt_to_pte(struct mm_struct *mm, unsigned long addr)
 {
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
-	pte_t *pte;
-	pte_t ptent;
 
-	if (task->mm == NULL)
-		return ERR_PTR(-EINVAL);
-	pgd = pgd_offset(task->mm, addr);
+	if (mm == NULL)
+		return NULL;
+
+	pgd = pgd_offset(mm, addr);
 	if (!pgd_present(*pgd))
-		return ERR_PTR(-EINVAL);
+		return NULL;
 
 	pud = pud_offset(pgd, addr);
 	if (!pud_present(*pud))
-		return ERR_PTR(-EINVAL);
+		return NULL;
 
 	pmd = pmd_offset(pud, addr);
 	if (!pmd_present(*pmd))
-		return ERR_PTR(-EINVAL);
-
-	pte = pte_offset_kernel(pmd, addr);
-	ptent = *pte;
-	if (!pte_present(ptent))
-		return ERR_PTR(-EINVAL);
+		return NULL;
 
-	if (pte_out != NULL)
-		*pte_out = ptent;
-	return (void *) (pte_val(ptent) & PAGE_MASK) + (addr & ~PAGE_MASK);
+	return pte_offset_kernel(pmd, addr);
 }
 
-static unsigned long maybe_map(unsigned long virt, int is_write)
+static pte_t *maybe_map(unsigned long virt, int is_write)
 {
-	pte_t pte;
-	int err;
+	pte_t *pte = virt_to_pte(current->mm, virt);
+	int err, dummy_code;
 
-	void *phys = um_virt_to_phys(current, virt, &pte);
-	int dummy_code;
-
-	if (IS_ERR(phys) || (is_write && !pte_write(pte))) {
+	if ((pte == NULL) || !pte_present(*pte) ||
+	    (is_write && !pte_write(*pte))) {
 		err = handle_page_fault(virt, 0, is_write, 1, &dummy_code);
 		if (err)
-			return -1UL;
-		phys = um_virt_to_phys(current, virt, NULL);
+			return NULL;
+		pte = virt_to_pte(current->mm, virt);
 	}
-	if (IS_ERR(phys))
-		phys = (void *) -1;
+	if (!pte_present(*pte))
+		pte = NULL;
 
-	return (unsigned long) phys;
+	return pte;
 }
 
 static int do_op_one_page(unsigned long addr, int len, int is_write,
 		 int (*op)(unsigned long addr, int len, void *arg), void *arg)
 {
 	struct page *page;
+	pte_t *pte;
 	int n;
 
-	addr = maybe_map(addr, is_write);
-	if (addr == -1UL)
+	pte = maybe_map(addr, is_write);
+	if (pte == NULL)
 		return -1;
 
-	page = phys_to_page(addr);
+	page = pte_page(*pte);
 	addr = (unsigned long) kmap_atomic(page, KM_UML_USERCOPY) +
 		(addr & ~PAGE_MASK);
 
diff -puN include/asm-um/pgtable.h~uml-add-virt_to_pte include/asm-um/pgtable.h
--- a/include/asm-um/pgtable.h~uml-add-virt_to_pte
+++ a/include/asm-um/pgtable.h
@@ -323,6 +323,9 @@ static inline pte_t pte_modify(pte_t pte
 #define pte_unmap(pte) do { } while (0)
 #define pte_unmap_nested(pte) do { } while (0)
 
+struct mm_struct;
+extern pte_t *virt_to_pte(struct mm_struct *mm, unsigned long addr);
+
 #define update_mmu_cache(vma,address,pte) do ; while (0)
 
 /* Encode and de-code a swap entry */
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
