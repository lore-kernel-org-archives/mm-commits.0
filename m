From: akpm@osdl.org
Subject: - i386-vdso-use-vm_alwaysdump.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:31:23 -0800
Message-ID: <200701270131.l0R1VNCI031831@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35542 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbXA0BcR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:32:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, ak@suse.de, benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     i386 vDSO: use VM_ALWAYSDUMP
has been removed from the -mm tree.  Its filename was
     i386-vdso-use-vm_alwaysdump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 vDSO: use VM_ALWAYSDUMP
From: Roland McGrath <roland@redhat.com>

This patch fixes core dumps to include the vDSO vma, which is left out now. 
It removes the special-case core writing macros, which were not doing the
right thing for the vDSO vma anyway.  Instead, it uses VM_ALWAYSDUMP in the
vma; there is no need for the fixmap page to be installed.  It handles the
CONFIG_COMPAT_VDSO case by making elf_core_dump use the fake vma from
get_gate_vma after real vmas in the same way the /proc/PID/maps code does.

This changes core dumps so they no longer include the non-PT_LOAD phdrs from
the vDSO.  I made the change to add them in the first place, but in turned out
that nothing ever wanted them there since the advent of NT_AUXV.  It's cleaner
to leave them out, and just let the phdrs inside the vDSO image speak for
themselves.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/sysenter.c |   12 +++++----
 fs/binfmt_elf.c             |   38 +++++++++++++++++++++++++++--
 include/asm-i386/elf.h      |   44 ----------------------------------
 mm/memory.c                 |    7 +++++
 4 files changed, 49 insertions(+), 52 deletions(-)

diff -puN arch/i386/kernel/sysenter.c~i386-vdso-use-vm_alwaysdump arch/i386/kernel/sysenter.c
--- a/arch/i386/kernel/sysenter.c~i386-vdso-use-vm_alwaysdump
+++ a/arch/i386/kernel/sysenter.c
@@ -79,11 +79,6 @@ int __init sysenter_setup(void)
 #ifdef CONFIG_COMPAT_VDSO
 	__set_fixmap(FIX_VDSO, __pa(syscall_page), PAGE_READONLY);
 	printk("Compat vDSO mapped to %08lx.\n", __fix_to_virt(FIX_VDSO));
-#else
-	/*
-	 * In the non-compat case the ELF coredumping code needs the fixmap:
-	 */
-	__set_fixmap(FIX_VDSO, __pa(syscall_page), PAGE_KERNEL_RO);
 #endif
 
 	if (!boot_cpu_has(X86_FEATURE_SEP)) {
@@ -147,6 +142,13 @@ int arch_setup_additional_pages(struct l
 	vma->vm_end = addr + PAGE_SIZE;
 	/* MAYWRITE to allow gdb to COW and set breakpoints */
 	vma->vm_flags = VM_READ|VM_EXEC|VM_MAYREAD|VM_MAYEXEC|VM_MAYWRITE;
+	/*
+	 * Make sure the vDSO gets into every core dump.
+	 * Dumping its contents makes post-mortem fully interpretable later
+	 * without matching up the same kernel and hardware config to see
+	 * what PC values meant.
+	 */
+	vma->vm_flags |= VM_ALWAYSDUMP;
 	vma->vm_flags |= mm->def_flags;
 	vma->vm_page_prot = protection_map[vma->vm_flags & 7];
 	vma->vm_ops = &syscall_vm_ops;
diff -puN fs/binfmt_elf.c~i386-vdso-use-vm_alwaysdump fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~i386-vdso-use-vm_alwaysdump
+++ a/fs/binfmt_elf.c
@@ -1428,6 +1428,32 @@ static int elf_dump_thread_status(long s
 	return sz;
 }
 
+static struct vm_area_struct *first_vma(struct task_struct *tsk,
+					struct vm_area_struct *gate_vma)
+{
+	struct vm_area_struct *ret = tsk->mm->mmap;
+
+	if (ret)
+		return ret;
+	return gate_vma;
+}
+/*
+ * Helper function for iterating across a vma list.  It ensures that the caller
+ * will visit `gate_vma' prior to terminating the search.
+ */
+static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
+					struct vm_area_struct *gate_vma)
+{
+	struct vm_area_struct *ret;
+
+	ret = this_vma->vm_next;
+	if (ret)
+		return ret;
+	if (this_vma == gate_vma)
+		return NULL;
+	return gate_vma;
+}
+
 /*
  * Actual dumper
  *
@@ -1443,7 +1469,7 @@ static int elf_core_dump(long signr, str
 	int segs;
 	size_t size = 0;
 	int i;
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma, *gate_vma;
 	struct elfhdr *elf = NULL;
 	loff_t offset = 0, dataoff, foffset;
 	unsigned long limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
@@ -1529,6 +1555,10 @@ static int elf_core_dump(long signr, str
 	segs += ELF_CORE_EXTRA_PHDRS;
 #endif
 
+	gate_vma = get_gate_vma(current);
+	if (gate_vma != NULL)
+		segs++;
+
 	/* Set up header */
 	fill_elf_header(elf, segs + 1);	/* including notes section */
 
@@ -1596,7 +1626,8 @@ static int elf_core_dump(long signr, str
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
 	/* Write program headers for segments dump */
-	for (vma = current->mm->mmap; vma != NULL; vma = vma->vm_next) {
+	for (vma = first_vma(current, gate_vma); vma != NULL;
+			vma = next_vma(vma, gate_vma)) {
 		struct elf_phdr phdr;
 		size_t sz;
 
@@ -1645,7 +1676,8 @@ static int elf_core_dump(long signr, str
 	/* Align to page */
 	DUMP_SEEK(dataoff - foffset);
 
-	for (vma = current->mm->mmap; vma != NULL; vma = vma->vm_next) {
+	for (vma = first_vma(current, gate_vma); vma != NULL;
+			vma = next_vma(vma, gate_vma)) {
 		unsigned long addr;
 
 		if (!maydump(vma))
diff -puN include/asm-i386/elf.h~i386-vdso-use-vm_alwaysdump include/asm-i386/elf.h
--- a/include/asm-i386/elf.h~i386-vdso-use-vm_alwaysdump
+++ a/include/asm-i386/elf.h
@@ -168,50 +168,6 @@ do if (vdso_enabled) {						\
 		NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_COMPAT_BASE);	\
 } while (0)
 
-/*
- * These macros parameterize elf_core_dump in fs/binfmt_elf.c to write out
- * extra segments containing the vsyscall DSO contents.  Dumping its
- * contents makes post-mortem fully interpretable later without matching up
- * the same kernel and hardware config to see what PC values meant.
- * Dumping its extra ELF program headers includes all the other information
- * a debugger needs to easily find how the vsyscall DSO was being used.
- */
-#define ELF_CORE_EXTRA_PHDRS		(VDSO_HIGH_EHDR->e_phnum)
-#define ELF_CORE_WRITE_EXTRA_PHDRS					      \
-do {									      \
-	const struct elf_phdr *const vsyscall_phdrs =			      \
-		(const struct elf_phdr *) (VDSO_HIGH_BASE		      \
-					   + VDSO_HIGH_EHDR->e_phoff);    \
-	int i;								      \
-	Elf32_Off ofs = 0;						      \
-	for (i = 0; i < VDSO_HIGH_EHDR->e_phnum; ++i) {		      \
-		struct elf_phdr phdr = vsyscall_phdrs[i];		      \
-		if (phdr.p_type == PT_LOAD) {				      \
-			BUG_ON(ofs != 0);				      \
-			ofs = phdr.p_offset = offset;			      \
-			phdr.p_memsz = PAGE_ALIGN(phdr.p_memsz);	      \
-			phdr.p_filesz = phdr.p_memsz;			      \
-			offset += phdr.p_filesz;			      \
-		}							      \
-		else							      \
-			phdr.p_offset += ofs;				      \
-		phdr.p_paddr = 0; /* match other core phdrs */		      \
-		DUMP_WRITE(&phdr, sizeof(phdr));			      \
-	}								      \
-} while (0)
-#define ELF_CORE_WRITE_EXTRA_DATA					      \
-do {									      \
-	const struct elf_phdr *const vsyscall_phdrs =			      \
-		(const struct elf_phdr *) (VDSO_HIGH_BASE		      \
-					   + VDSO_HIGH_EHDR->e_phoff);    \
-	int i;								      \
-	for (i = 0; i < VDSO_HIGH_EHDR->e_phnum; ++i) {		      \
-		if (vsyscall_phdrs[i].p_type == PT_LOAD)		      \
-			DUMP_WRITE((void *) vsyscall_phdrs[i].p_vaddr,	      \
-				   PAGE_ALIGN(vsyscall_phdrs[i].p_memsz));    \
-	}								      \
-} while (0)
-
 #endif
 
 #endif
diff -puN mm/memory.c~i386-vdso-use-vm_alwaysdump mm/memory.c
--- a/mm/memory.c~i386-vdso-use-vm_alwaysdump
+++ a/mm/memory.c
@@ -2608,6 +2608,13 @@ static int __init gate_vma_init(void)
 	gate_vma.vm_end = FIXADDR_USER_END;
 	gate_vma.vm_flags = VM_READ | VM_MAYREAD | VM_EXEC | VM_MAYEXEC;
 	gate_vma.vm_page_prot = __P101;
+	/*
+	 * Make sure the vDSO gets into every core dump.
+	 * Dumping its contents makes post-mortem fully interpretable later
+	 * without matching up the same kernel and hardware config to see
+	 * what PC values meant.
+	 */
+	gate_vma.vm_flags |= VM_ALWAYSDUMP;
 	return 0;
 }
 __initcall(gate_vma_init);
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
add-install_special_mapping.patch
i386-vdso-use-install_special_mapping.patch
x86_64-ia32-vdso-use-install_special_mapping.patch
powerpc-vdso-use-install_special_mapping.patch
sh-vdso-use-install_special_mappingpatch.patch
arch-i386-kernel-ptracec-trivial-whitespace-cleanup.patch
i386-kwatch-kernel-watchpoints-using-cpu-debug-registers.patch
i386-kwatch-kernel-watchpoints-using-cpu-debug-registers-fix.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
