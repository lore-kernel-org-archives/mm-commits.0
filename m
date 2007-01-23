From: akpm@osdl.org
Subject: + x86_64-ia32-vdso-use-install_special_mapping.patch added to -mm tree
Date: Tue, 23 Jan 2007 11:49:19 -0800
Message-ID: <200701231949.l0NJnJpx029475@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51769 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965467AbXAWTuZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 14:50:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de, benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org


The patch titled
     x86_64 ia32 vDSO: use install_special_mapping
has been added to the -mm tree.  Its filename is
     x86_64-ia32-vdso-use-install_special_mapping.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64 ia32 vDSO: use install_special_mapping
From: Roland McGrath <roland@redhat.com>

This patch uses install_special_mapping for the ia32 vDSO setup, consolidating
duplicated code.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/ia32/syscall32.c |   59 +++++++--------------------------
 include/asm-x86_64/proto.h   |    1 
 2 files changed, 13 insertions(+), 47 deletions(-)

diff -puN arch/x86_64/ia32/syscall32.c~x86_64-ia32-vdso-use-install_special_mapping arch/x86_64/ia32/syscall32.c
--- a/arch/x86_64/ia32/syscall32.c~x86_64-ia32-vdso-use-install_special_mapping
+++ a/arch/x86_64/ia32/syscall32.c
@@ -18,68 +18,34 @@ extern unsigned char syscall32_syscall[]
 extern unsigned char syscall32_sysenter[], syscall32_sysenter_end[];
 extern int sysctl_vsyscall32;
 
-char *syscall32_page; 
+static struct page *syscall32_pages[1];
 static int use_sysenter = -1;
 
-static struct page *
-syscall32_nopage(struct vm_area_struct *vma, unsigned long adr, int *type)
-{
-	struct page *p = virt_to_page(adr - vma->vm_start + syscall32_page);
-	get_page(p);
-	return p;
-}
-
-/* Prevent VMA merging */
-static void syscall32_vma_close(struct vm_area_struct *vma)
-{
-}
-
-static struct vm_operations_struct syscall32_vm_ops = {
-	.close = syscall32_vma_close,
-	.nopage = syscall32_nopage,
-};
-
 struct linux_binprm;
 
 /* Setup a VMA at program startup for the vsyscall page */
 int syscall32_setup_pages(struct linux_binprm *bprm, int exstack)
 {
-	int npages = (VSYSCALL32_END - VSYSCALL32_BASE) >> PAGE_SHIFT;
-	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
 	int ret;
 
-	vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
-	if (!vma)
-		return -ENOMEM;
-
-	memset(vma, 0, sizeof(struct vm_area_struct));
-	/* Could randomize here */
-	vma->vm_start = VSYSCALL32_BASE;
-	vma->vm_end = VSYSCALL32_END;
-	/* MAYWRITE to allow gdb to COW and set breakpoints */
-	vma->vm_flags = VM_READ|VM_EXEC|VM_MAYREAD|VM_MAYEXEC|VM_MAYWRITE;
+	down_write(&mm->mmap_sem);
 	/*
+	 * MAYWRITE to allow gdb to COW and set breakpoints
+	 *
 	 * Make sure the vDSO gets into every core dump.
 	 * Dumping its contents makes post-mortem fully interpretable later
 	 * without matching up the same kernel and hardware config to see
 	 * what PC values meant.
 	 */
-	vma->vm_flags |= VM_ALWAYSDUMP;
-	vma->vm_flags |= mm->def_flags;
-	vma->vm_page_prot = protection_map[vma->vm_flags & 7];
-	vma->vm_ops = &syscall32_vm_ops;
-	vma->vm_mm = mm;
-
-	down_write(&mm->mmap_sem);
-	if ((ret = insert_vm_struct(mm, vma))) {
-		up_write(&mm->mmap_sem);
-		kmem_cache_free(vm_area_cachep, vma);
-		return ret;
-	}
-	mm->total_vm += npages;
+	/* Could randomize here */
+	ret = install_special_mapping(mm, VSYSCALL32_BASE, PAGE_SIZE,
+				      VM_READ|VM_EXEC|
+				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
+				      VM_ALWAYSDUMP,
+				      syscall32_pages);
 	up_write(&mm->mmap_sem);
-	return 0;
+	return ret;
 }
 
 const char *arch_vma_name(struct vm_area_struct *vma)
@@ -92,9 +58,10 @@ const char *arch_vma_name(struct vm_area
 
 static int __init init_syscall32(void)
 { 
-	syscall32_page = (void *)get_zeroed_page(GFP_KERNEL); 
+	char *syscall32_page = (void *)get_zeroed_page(GFP_KERNEL);
 	if (!syscall32_page) 
 		panic("Cannot allocate syscall32 page"); 
+	syscall32_pages[0] = virt_to_page(syscall32_page);
  	if (use_sysenter > 0) {
  		memcpy(syscall32_page, syscall32_sysenter,
  		       syscall32_sysenter_end - syscall32_sysenter);
diff -puN include/asm-x86_64/proto.h~x86_64-ia32-vdso-use-install_special_mapping include/asm-x86_64/proto.h
--- a/include/asm-x86_64/proto.h~x86_64-ia32-vdso-use-install_special_mapping
+++ a/include/asm-x86_64/proto.h
@@ -81,7 +81,6 @@ extern void swap_low_mappings(void);
 extern void __show_regs(struct pt_regs * regs);
 extern void show_regs(struct pt_regs * regs);
 
-extern char *syscall32_page;
 extern void syscall32_cpu_init(void);
 
 extern void setup_node_bootmem(int nodeid, unsigned long start, unsigned long end);
_

Patches currently in -mm which might be from roland@redhat.com are

fix-config_compat_vdso.patch
fix-gate_vmavm_flags.patch
add-vm_alwaysdump.patch
i386-vdso-use-vm_alwaysdump.patch
i386-vdso-use-vm_alwaysdump-tidy.patch
x86_64-ia32-vdso-use-vm_alwaysdump.patch
powerpc-vdso-use-vm_alwaysdump.patch
x86_64-ia32-vdso-define-arch_vma_name.patch
add-install_special_mapping.patch
i386-vdso-use-install_special_mapping.patch
x86_64-ia32-vdso-use-install_special_mapping.patch
powerpc-vdso-use-install_special_mapping.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
