From: akpm@osdl.org
Subject: + i386-vdso-use-install_special_mapping.patch added to -mm tree
Date: Tue, 23 Jan 2007 11:49:17 -0800
Message-ID: <200701231949.l0NJnHvT029472@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51775 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965469AbXAWTua (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 14:50:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de, benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org


The patch titled
     i386 vDSO: use install_special_mapping
has been added to the -mm tree.  Its filename is
     i386-vdso-use-install_special_mapping.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386 vDSO: use install_special_mapping
From: Roland McGrath <roland@redhat.com>

This patch uses install_special_mapping for the i386 vDSO setup, consolidating
duplicated code.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/sysenter.c |   53 +++++++---------------------------
 1 files changed, 11 insertions(+), 42 deletions(-)

diff -puN arch/i386/kernel/sysenter.c~i386-vdso-use-install_special_mapping arch/i386/kernel/sysenter.c
--- a/arch/i386/kernel/sysenter.c~i386-vdso-use-install_special_mapping
+++ a/arch/i386/kernel/sysenter.c
@@ -70,11 +70,12 @@ void enable_sep_cpu(void)
  */
 extern const char vsyscall_int80_start, vsyscall_int80_end;
 extern const char vsyscall_sysenter_start, vsyscall_sysenter_end;
-static void *syscall_page;
+static struct page *syscall_pages[1];
 
 int __init sysenter_setup(void)
 {
-	syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
+	void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
+	syscall_pages[0] = virt_to_page(syscall_page);
 
 #ifdef CONFIG_COMPAT_VDSO
 	__set_fixmap(FIX_VDSO, __pa(syscall_page), PAGE_READONLY);
@@ -96,31 +97,12 @@ int __init sysenter_setup(void)
 }
 
 #ifndef CONFIG_COMPAT_VDSO
-static struct page *syscall_nopage(struct vm_area_struct *vma,
-				unsigned long adr, int *type)
-{
-	struct page *p = virt_to_page(adr - vma->vm_start + syscall_page);
-	get_page(p);
-	return p;
-}
-
-/* Prevent VMA merging */
-static void syscall_vma_close(struct vm_area_struct *vma)
-{
-}
-
-static struct vm_operations_struct syscall_vm_ops = {
-	.close = syscall_vma_close,
-	.nopage = syscall_nopage,
-};
-
 /* Defined in vsyscall-sysenter.S */
 extern void SYSENTER_RETURN;
 
 /* Setup a VMA at program startup for the vsyscall page */
 int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
 {
-	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
 	int ret;
@@ -132,38 +114,25 @@ int arch_setup_additional_pages(struct l
 		goto up_fail;
 	}
 
-	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
-	if (!vma) {
-		ret = -ENOMEM;
-		goto up_fail;
-	}
-
-	vma->vm_start = addr;
-	vma->vm_end = addr + PAGE_SIZE;
-	/* MAYWRITE to allow gdb to COW and set breakpoints */
-	vma->vm_flags = VM_READ|VM_EXEC|VM_MAYREAD|VM_MAYEXEC|VM_MAYWRITE;
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
-	vma->vm_ops = &syscall_vm_ops;
-	vma->vm_mm = mm;
-
-	ret = insert_vm_struct(mm, vma);
-	if (unlikely(ret)) {
-		kmem_cache_free(vm_area_cachep, vma);
+	ret = install_special_mapping(mm, addr, PAGE_SIZE,
+				      VM_READ|VM_EXEC|
+				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
+				      VM_ALWAYSDUMP,
+				      syscall_pages);
+	if (ret)
 		goto up_fail;
-	}
 
 	current->mm->context.vdso = (void *)addr;
 	current_thread_info()->sysenter_return =
 				    (void *)VDSO_SYM(&SYSENTER_RETURN);
-	mm->total_vm++;
 up_fail:
 	up_write(&mm->mmap_sem);
 	return ret;
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
