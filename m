From: akpm@linux-foundation.org
Subject: [merged] coredump-remove-vm_alwaysdump-flag.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:38 -0700
Message-ID: <20120326193238.6C435A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:39425 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab2CZTcj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:39 -0400
Received: by mail-yw0-f74.google.com with SMTP id m50so834231yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@redhat.com, avi@redhat.com, cmetcalf@tilera.com, roland@hack.frob.com, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: remove VM_ALWAYSDUMP flag
has been removed from the -mm tree.  Its filename was
     coredump-remove-vm_alwaysdump-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jason Baron <jbaron@redhat.com>
Subject: coredump: remove VM_ALWAYSDUMP flag

The motivation for this patchset was that I was looking at a way for a
qemu-kvm process, to exclude the guest memory from its core dump, which
can be quite large.  There are already a number of filter flags in
/proc/<pid>/coredump_filter, however, these allow one to specify 'types'
of kernel memory, not specific address ranges (which is needed in this
case).

Since there are no more vma flags available, the first patch eliminates
the need for the 'VM_ALWAYSDUMP' flag.  The flag is used internally by the
kernel to mark vdso and vsyscall pages.  However, it is simple enough to
check if a vma covers a vdso or vsyscall page without the need for this
flag.

The second patch then replaces the 'VM_ALWAYSDUMP' flag with a new
'VM_NODUMP' flag, which can be set by userspace using new madvise flags:
'MADV_DONTDUMP', and unset via 'MADV_DODUMP'.  The core dump filters
continue to work the same as before unless 'MADV_DONTDUMP' is set on the
region.

The qemu code which implements this features is at:
http://people.redhat.com/~jbaron/qemu-dump/qemu-dump.patch

In my testing the qemu core dump shrunk from 383MB -> 13MB with this patch.

I also believe that the 'MADV_DONTDUMP' flag might be useful for security
sensitive apps, which might want to select which areas are dumped.


This patch:

The VM_ALWAYSDUMP flag is currently used by the coredump code to indicate
that a vma is part of a vsyscall or vdso section.  However, we can
determine if a vma is in one these sections by checking it against the
gate_vma and checking for a non-NULL return value from arch_vma_name(). 
Thus, freeing a valuable vma bit.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Roland McGrath <roland@hack.frob.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/process.c          |    3 +--
 arch/hexagon/kernel/vdso.c         |    3 +--
 arch/mips/kernel/vdso.c            |    3 +--
 arch/powerpc/kernel/vdso.c         |   10 ++--------
 arch/s390/kernel/vdso.c            |   10 ++--------
 arch/sh/kernel/vsyscall/vsyscall.c |    3 +--
 arch/tile/mm/elf.c                 |    8 +-------
 arch/unicore32/kernel/process.c    |    2 +-
 arch/x86/um/mem_32.c               |    8 --------
 arch/x86/um/vdso/vma.c             |    3 +--
 arch/x86/vdso/vdso32-setup.c       |   17 ++---------------
 arch/x86/vdso/vma.c                |    3 +--
 fs/binfmt_elf.c                    |   27 +++++++++++++++++++++++++--
 include/linux/mm.h                 |    1 -
 mm/memory.c                        |    8 +-------
 15 files changed, 40 insertions(+), 69 deletions(-)

diff -puN arch/arm/kernel/process.c~coredump-remove-vm_alwaysdump-flag arch/arm/kernel/process.c
--- a/arch/arm/kernel/process.c~coredump-remove-vm_alwaysdump-flag
+++ a/arch/arm/kernel/process.c
@@ -533,8 +533,7 @@ int vectors_user_mapping(void)
 	struct mm_struct *mm = current->mm;
 	return install_special_mapping(mm, 0xffff0000, PAGE_SIZE,
 				       VM_READ | VM_EXEC |
-				       VM_MAYREAD | VM_MAYEXEC |
-				       VM_ALWAYSDUMP | VM_RESERVED,
+				       VM_MAYREAD | VM_MAYEXEC | VM_RESERVED,
 				       NULL);
 }
 
diff -puN arch/hexagon/kernel/vdso.c~coredump-remove-vm_alwaysdump-flag arch/hexagon/kernel/vdso.c
--- a/arch/hexagon/kernel/vdso.c~coredump-remove-vm_alwaysdump-flag
+++ a/arch/hexagon/kernel/vdso.c
@@ -78,8 +78,7 @@ int arch_setup_additional_pages(struct l
 	/* MAYWRITE to allow gdb to COW and set breakpoints. */
 	ret = install_special_mapping(mm, vdso_base, PAGE_SIZE,
 				      VM_READ|VM_EXEC|
-				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
-				      VM_ALWAYSDUMP,
+				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 				      &vdso_page);
 
 	if (ret)
diff -puN arch/mips/kernel/vdso.c~coredump-remove-vm_alwaysdump-flag arch/mips/kernel/vdso.c
--- a/arch/mips/kernel/vdso.c~coredump-remove-vm_alwaysdump-flag
+++ a/arch/mips/kernel/vdso.c
@@ -88,8 +88,7 @@ int arch_setup_additional_pages(struct l
 
 	ret = install_special_mapping(mm, addr, PAGE_SIZE,
 				      VM_READ|VM_EXEC|
-				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
-				      VM_ALWAYSDUMP,
+				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 				      &vdso_page);
 
 	if (ret)
diff -puN arch/powerpc/kernel/vdso.c~coredump-remove-vm_alwaysdump-flag arch/powerpc/kernel/vdso.c
--- a/arch/powerpc/kernel/vdso.c~coredump-remove-vm_alwaysdump-flag
+++ a/arch/powerpc/kernel/vdso.c
@@ -263,17 +263,11 @@ int arch_setup_additional_pages(struct l
 	 * the "data" page of the vDSO or you'll stop getting kernel updates
 	 * and your nice userland gettimeofday will be totally dead.
 	 * It's fine to use that for setting breakpoints in the vDSO code
-	 * pages though
-	 *
-	 * Make sure the vDSO gets into every core dump.
-	 * Dumping its contents makes post-mortem fully interpretable later
-	 * without matching up the same kernel and hardware config to see
-	 * what PC values meant.
+	 * pages though.
 	 */
 	rc = install_special_mapping(mm, vdso_base, vdso_pages << PAGE_SHIFT,
 				     VM_READ|VM_EXEC|
-				     VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
-				     VM_ALWAYSDUMP,
+				     VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 				     vdso_pagelist);
 	if (rc) {
 		current->mm->context.vdso_base = 0;
diff -puN arch/s390/kernel/vdso.c~coredump-remove-vm_alwaysdump-flag arch/s390/kernel/vdso.c
--- a/arch/s390/kernel/vdso.c~coredump-remove-vm_alwaysdump-flag
+++ a/arch/s390/kernel/vdso.c
@@ -241,17 +241,11 @@ int arch_setup_additional_pages(struct l
 	 * on the "data" page of the vDSO or you'll stop getting kernel
 	 * updates and your nice userland gettimeofday will be totally dead.
 	 * It's fine to use that for setting breakpoints in the vDSO code
-	 * pages though
-	 *
-	 * Make sure the vDSO gets into every core dump.
-	 * Dumping its contents makes post-mortem fully interpretable later
-	 * without matching up the same kernel and hardware config to see
-	 * what PC values meant.
+	 * pages though.
 	 */
 	rc = install_special_mapping(mm, vdso_base, vdso_pages << PAGE_SHIFT,
 				     VM_READ|VM_EXEC|
-				     VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
-				     VM_ALWAYSDUMP,
+				     VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 				     vdso_pagelist);
 	if (rc)
 		current->mm->context.vdso_base = 0;
diff -puN arch/sh/kernel/vsyscall/vsyscall.c~coredump-remove-vm_alwaysdump-flag arch/sh/kernel/vsyscall/vsyscall.c
--- a/arch/sh/kernel/vsyscall/vsyscall.c~coredump-remove-vm_alwaysdump-flag
+++ a/arch/sh/kernel/vsyscall/vsyscall.c
@@ -73,8 +73,7 @@ int arch_setup_additional_pages(struct l
 
 	ret = install_special_mapping(mm, addr, PAGE_SIZE,
 				      VM_READ | VM_EXEC |
-				      VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC |
-				      VM_ALWAYSDUMP,
+				      VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC,
 				      syscall_pages);
 	if (unlikely(ret))
 		goto up_fail;
diff -puN arch/tile/mm/elf.c~coredump-remove-vm_alwaysdump-flag arch/tile/mm/elf.c
--- a/arch/tile/mm/elf.c~coredump-remove-vm_alwaysdump-flag
+++ a/arch/tile/mm/elf.c
@@ -117,17 +117,11 @@ int arch_setup_additional_pages(struct l
 
 	/*
 	 * MAYWRITE to allow gdb to COW and set breakpoints
-	 *
-	 * Make sure the vDSO gets into every core dump.  Dumping its
-	 * contents makes post-mortem fully interpretable later
-	 * without matching up the same kernel and hardware config to
-	 * see what PC values meant.
 	 */
 	vdso_base = VDSO_BASE;
 	retval = install_special_mapping(mm, vdso_base, PAGE_SIZE,
 					 VM_READ|VM_EXEC|
-					 VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
-					 VM_ALWAYSDUMP,
+					 VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 					 vdso_pages);
 
 #ifndef __tilegx__
diff -puN arch/unicore32/kernel/process.c~coredump-remove-vm_alwaysdump-flag arch/unicore32/kernel/process.c
--- a/arch/unicore32/kernel/process.c~coredump-remove-vm_alwaysdump-flag
+++ a/arch/unicore32/kernel/process.c
@@ -381,7 +381,7 @@ int vectors_user_mapping(void)
 	return install_special_mapping(mm, 0xffff0000, PAGE_SIZE,
 				       VM_READ | VM_EXEC |
 				       VM_MAYREAD | VM_MAYEXEC |
-				       VM_ALWAYSDUMP | VM_RESERVED,
+				       VM_RESERVED,
 				       NULL);
 }
 
diff -puN arch/x86/um/mem_32.c~coredump-remove-vm_alwaysdump-flag arch/x86/um/mem_32.c
--- a/arch/x86/um/mem_32.c~coredump-remove-vm_alwaysdump-flag
+++ a/arch/x86/um/mem_32.c
@@ -23,14 +23,6 @@ static int __init gate_vma_init(void)
 	gate_vma.vm_flags = VM_READ | VM_MAYREAD | VM_EXEC | VM_MAYEXEC;
 	gate_vma.vm_page_prot = __P101;
 
-	/*
-	 * Make sure the vDSO gets into every core dump.
-	 * Dumping its contents makes post-mortem fully interpretable later
-	 * without matching up the same kernel and hardware config to see
-	 * what PC values meant.
-	 */
-	gate_vma.vm_flags |= VM_ALWAYSDUMP;
-
 	return 0;
 }
 __initcall(gate_vma_init);
diff -puN arch/x86/um/vdso/vma.c~coredump-remove-vm_alwaysdump-flag arch/x86/um/vdso/vma.c
--- a/arch/x86/um/vdso/vma.c~coredump-remove-vm_alwaysdump-flag
+++ a/arch/x86/um/vdso/vma.c
@@ -64,8 +64,7 @@ int arch_setup_additional_pages(struct l
 
 	err = install_special_mapping(mm, um_vdso_addr, PAGE_SIZE,
 		VM_READ|VM_EXEC|
-		VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
-		VM_ALWAYSDUMP,
+		VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 		vdsop);
 
 	up_write(&mm->mmap_sem);
diff -puN arch/x86/vdso/vdso32-setup.c~coredump-remove-vm_alwaysdump-flag arch/x86/vdso/vdso32-setup.c
--- a/arch/x86/vdso/vdso32-setup.c~coredump-remove-vm_alwaysdump-flag
+++ a/arch/x86/vdso/vdso32-setup.c
@@ -250,13 +250,7 @@ static int __init gate_vma_init(void)
 	gate_vma.vm_end = FIXADDR_USER_END;
 	gate_vma.vm_flags = VM_READ | VM_MAYREAD | VM_EXEC | VM_MAYEXEC;
 	gate_vma.vm_page_prot = __P101;
-	/*
-	 * Make sure the vDSO gets into every core dump.
-	 * Dumping its contents makes post-mortem fully interpretable later
-	 * without matching up the same kernel and hardware config to see
-	 * what PC values meant.
-	 */
-	gate_vma.vm_flags |= VM_ALWAYSDUMP;
+
 	return 0;
 }
 
@@ -343,17 +337,10 @@ int arch_setup_additional_pages(struct l
 	if (compat_uses_vma || !compat) {
 		/*
 		 * MAYWRITE to allow gdb to COW and set breakpoints
-		 *
-		 * Make sure the vDSO gets into every core dump.
-		 * Dumping its contents makes post-mortem fully
-		 * interpretable later without matching up the same
-		 * kernel and hardware config to see what PC values
-		 * meant.
 		 */
 		ret = install_special_mapping(mm, addr, PAGE_SIZE,
 					      VM_READ|VM_EXEC|
-					      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
-					      VM_ALWAYSDUMP,
+					      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 					      vdso32_pages);
 
 		if (ret)
diff -puN arch/x86/vdso/vma.c~coredump-remove-vm_alwaysdump-flag arch/x86/vdso/vma.c
--- a/arch/x86/vdso/vma.c~coredump-remove-vm_alwaysdump-flag
+++ a/arch/x86/vdso/vma.c
@@ -124,8 +124,7 @@ int arch_setup_additional_pages(struct l
 
 	ret = install_special_mapping(mm, addr, vdso_size,
 				      VM_READ|VM_EXEC|
-				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
-				      VM_ALWAYSDUMP,
+				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 				      vdso_pages);
 	if (ret) {
 		current->mm->context.vdso = NULL;
diff -puN fs/binfmt_elf.c~coredump-remove-vm_alwaysdump-flag fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~coredump-remove-vm_alwaysdump-flag
+++ a/fs/binfmt_elf.c
@@ -1093,6 +1093,29 @@ out:
  */
 
 /*
+ * The purpose of always_dump_vma() is to make sure that special kernel mappings
+ * that are useful for post-mortem analysis are included in every core dump.
+ * In that way we ensure that the core dump is fully interpretable later
+ * without matching up the same kernel and hardware config to see what PC values
+ * meant. These special mappings include - vDSO, vsyscall, and other
+ * architecture specific mappings
+ */
+static bool always_dump_vma(struct vm_area_struct *vma)
+{
+	/* Any vsyscall mappings? */
+	if (vma == get_gate_vma(vma->vm_mm))
+		return true;
+	/*
+	 * arch_vma_name() returns non-NULL for special architecture mappings,
+	 * such as vDSO sections.
+	 */
+	if (arch_vma_name(vma))
+		return true;
+
+	return false;
+}
+
+/*
  * Decide what to dump of a segment, part, all or none.
  */
 static unsigned long vma_dump_size(struct vm_area_struct *vma,
@@ -1100,8 +1123,8 @@ static unsigned long vma_dump_size(struc
 {
 #define FILTER(type)	(mm_flags & (1UL << MMF_DUMP_##type))
 
-	/* The vma can be set up to tell us the answer directly.  */
-	if (vma->vm_flags & VM_ALWAYSDUMP)
+	/* always dump the vdso and vsyscall sections */
+	if (always_dump_vma(vma))
 		goto whole;
 
 	/* Hugetlb memory check */
diff -puN include/linux/mm.h~coredump-remove-vm_alwaysdump-flag include/linux/mm.h
--- a/include/linux/mm.h~coredump-remove-vm_alwaysdump-flag
+++ a/include/linux/mm.h
@@ -111,7 +111,6 @@ extern unsigned int kobjsize(const void 
 #define VM_HUGEPAGE	0x01000000	/* MADV_HUGEPAGE marked this vma */
 #endif
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
-#define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
 
 #define VM_CAN_NONLINEAR 0x08000000	/* Has ->fault & does nonlinear pages */
 #define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
diff -puN mm/memory.c~coredump-remove-vm_alwaysdump-flag mm/memory.c
--- a/mm/memory.c~coredump-remove-vm_alwaysdump-flag
+++ a/mm/memory.c
@@ -3623,13 +3623,7 @@ static int __init gate_vma_init(void)
 	gate_vma.vm_end = FIXADDR_USER_END;
 	gate_vma.vm_flags = VM_READ | VM_MAYREAD | VM_EXEC | VM_MAYEXEC;
 	gate_vma.vm_page_prot = __P101;
-	/*
-	 * Make sure the vDSO gets into every core dump.
-	 * Dumping its contents makes post-mortem fully interpretable later
-	 * without matching up the same kernel and hardware config to see
-	 * what PC values meant.
-	 */
-	gate_vma.vm_flags |= VM_ALWAYSDUMP;
+
 	return 0;
 }
 __initcall(gate_vma_init);
_

Patches currently in -mm which might be from jbaron@redhat.com are

origin.patch
linux-next.patch

