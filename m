From: akpm@linux-foundation.org
Subject: - sh-vdso-use-install_special_mappingpatch.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:22:58 -0800
Message-ID: <200702100523.l1A5Mw46004512@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36627 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137AbXBJFXP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:23:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     SH vdso: use install_special_mapping()
has been removed from the -mm tree.  Its filename was
     sh-vdso-use-install_special_mappingpatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SH vdso: use install_special_mapping()
From: Paul Mundt <lethal@linux-sh.org>

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/vsyscall/vsyscall.c |   58 ++++-----------------------
 1 files changed, 9 insertions(+), 49 deletions(-)

diff -puN arch/sh/kernel/vsyscall/vsyscall.c~sh-vdso-use-install_special_mappingpatch arch/sh/kernel/vsyscall/vsyscall.c
--- a/arch/sh/kernel/vsyscall/vsyscall.c~sh-vdso-use-install_special_mappingpatch
+++ a/arch/sh/kernel/vsyscall/vsyscall.c
@@ -37,11 +37,12 @@ __setup("vdso=", vdso_setup);
  * of the ELF DSO images included therein.
  */
 extern const char vsyscall_trapa_start, vsyscall_trapa_end;
-static void *syscall_page;
+static struct page *syscall_pages[1];
 
 int __init vsyscall_init(void)
 {
-	syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
+	void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
+	syscall_pages[0] = virt_to_page(syscall_page);
 
 	/*
 	 * XXX: Map this page to a fixmap entry if we get around
@@ -55,37 +56,10 @@ int __init vsyscall_init(void)
 	return 0;
 }
 
-static struct page *syscall_vma_nopage(struct vm_area_struct *vma,
-				       unsigned long address, int *type)
-{
-	unsigned long offset = address - vma->vm_start;
-	struct page *page;
-
-	if (address < vma->vm_start || address > vma->vm_end)
-		return NOPAGE_SIGBUS;
-
-	page = virt_to_page(syscall_page + offset);
-
-	get_page(page);
-
-	return page;
-}
-
-/* Prevent VMA merging */
-static void syscall_vma_close(struct vm_area_struct *vma)
-{
-}
-
-static struct vm_operations_struct syscall_vm_ops = {
-	.nopage	= syscall_vma_nopage,
-	.close	= syscall_vma_close,
-};
-
 /* Setup a VMA at program startup for the vsyscall page */
 int arch_setup_additional_pages(struct linux_binprm *bprm,
 				int executable_stack)
 {
-	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
 	int ret;
@@ -97,30 +71,16 @@ int arch_setup_additional_pages(struct l
 		goto up_fail;
 	}
 
-	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
-	if (!vma) {
-		ret = -ENOMEM;
+	ret = install_special_mapping(mm, addr, PAGE_SIZE,
+				      VM_READ | VM_EXEC |
+				      VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC |
+				      VM_ALWAYSDUMP,
+				      syscall_pages);
+	if (unlikely(ret))
 		goto up_fail;
-	}
-
-	vma->vm_start = addr;
-	vma->vm_end = addr + PAGE_SIZE;
-	/* MAYWRITE to allow gdb to COW and set breakpoints */
-	vma->vm_flags = VM_READ|VM_EXEC|VM_MAYREAD|VM_MAYEXEC|VM_MAYWRITE;
-	vma->vm_flags |= mm->def_flags;
-	vma->vm_page_prot = protection_map[vma->vm_flags & 7];
-	vma->vm_ops = &syscall_vm_ops;
-	vma->vm_mm = mm;
-
-	ret = insert_vm_struct(mm, vma);
-	if (unlikely(ret)) {
-		kmem_cache_free(vm_area_cachep, vma);
-		goto up_fail;
-	}
 
 	current->mm->context.vdso = (void *)addr;
 
-	mm->total_vm++;
 up_fail:
 	up_write(&mm->mmap_sem);
 	return ret;
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
make-aout-executables-work-again.patch
git-sh.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
introduce-config_zone_dma.patch
optional-zone_dma-in-the-vm.patch
remove-zone_dma-remains-from-sh-sh64.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
simplify-the-stacktrace-code.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-sh.patch
dynamic-kernel-command-line-sh64.patch
sysctl-c99-convert-arch-sh64-kernel-trapsc-and-remove-abi-breakage.patch
