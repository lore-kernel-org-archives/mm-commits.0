From: akpm@osdl.org
Subject: - x86_64-ia32-vdso-use-vm_alwaysdump.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:31:26 -0800
Message-ID: <200701270131.l0R1VQKe031834@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35534 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbXA0BcN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:32:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, ak@suse.de, benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     x86_64 ia32 vDSO: use VM_ALWAYSDUMP
has been removed from the -mm tree.  Its filename was
     x86_64-ia32-vdso-use-vm_alwaysdump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64 ia32 vDSO: use VM_ALWAYSDUMP
From: Roland McGrath <roland@redhat.com>

This patch fixes ia32 core dumps on x86_64 to include just one phdr for the
vDSO vma.  Currently it writes a confused format with two phdrs for the
address, one without contents and one with.  This patch removes the
special-case core writing macros for the ia32 vDSO.  Instead, it uses
VM_ALWAYSDUMP in the vma.  This changes core dumps so they no longer include
the non-PT_LOAD phdrs from the vDSO, consistent with fixed native i386 core
dumps.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/ia32/ia32_binfmt.c |   49 -------------------------------
 arch/x86_64/ia32/syscall32.c   |    7 ++++
 2 files changed, 7 insertions(+), 49 deletions(-)

diff -puN arch/x86_64/ia32/ia32_binfmt.c~x86_64-ia32-vdso-use-vm_alwaysdump arch/x86_64/ia32/ia32_binfmt.c
--- a/arch/x86_64/ia32/ia32_binfmt.c~x86_64-ia32-vdso-use-vm_alwaysdump
+++ a/arch/x86_64/ia32/ia32_binfmt.c
@@ -64,55 +64,6 @@ typedef unsigned int elf_greg_t;
 #define ELF_NGREG (sizeof (struct user_regs_struct32) / sizeof(elf_greg_t))
 typedef elf_greg_t elf_gregset_t[ELF_NGREG];
 
-/*
- * These macros parameterize elf_core_dump in fs/binfmt_elf.c to write out
- * extra segments containing the vsyscall DSO contents.  Dumping its
- * contents makes post-mortem fully interpretable later without matching up
- * the same kernel and hardware config to see what PC values meant.
- * Dumping its extra ELF program headers includes all the other information
- * a debugger needs to easily find how the vsyscall DSO was being used.
- */
-#define ELF_CORE_EXTRA_PHDRS	(find_vma(current->mm, VSYSCALL32_BASE) ?     \
-    (VSYSCALL32_EHDR->e_phnum) : 0)
-#define ELF_CORE_WRITE_EXTRA_PHDRS					      \
-do {									      \
-	if (find_vma(current->mm, VSYSCALL32_BASE)) { 			      \
-		const struct elf32_phdr *const vsyscall_phdrs =		      \
-			(const struct elf32_phdr *) (VSYSCALL32_BASE	      \
-						   + VSYSCALL32_EHDR->e_phoff);\
-		int i;							      \
-		Elf32_Off ofs = 0;					      \
-		for (i = 0; i < VSYSCALL32_EHDR->e_phnum; ++i) {	      \
-			struct elf32_phdr phdr = vsyscall_phdrs[i];	      \
-			if (phdr.p_type == PT_LOAD) {			      \
-				BUG_ON(ofs != 0);			      \
-				ofs = phdr.p_offset = offset;		      \
-				phdr.p_memsz = PAGE_ALIGN(phdr.p_memsz);      \
-				phdr.p_filesz = phdr.p_memsz;		      \
-				offset += phdr.p_filesz;		      \
-			}						      \
-			else						      \
-				phdr.p_offset += ofs;			      \
-			phdr.p_paddr = 0; /* match other core phdrs */	      \
-			DUMP_WRITE(&phdr, sizeof(phdr));		      \
-		}							      \
-	}								      \
-} while (0)
-#define ELF_CORE_WRITE_EXTRA_DATA					      \
-do {									      \
-	if (find_vma(current->mm, VSYSCALL32_BASE)) { 			      \
-		const struct elf32_phdr *const vsyscall_phdrs =		      \
-			(const struct elf32_phdr *) (VSYSCALL32_BASE	      \
-						   + VSYSCALL32_EHDR->e_phoff);      \
-		int i;							      \
-		for (i = 0; i < VSYSCALL32_EHDR->e_phnum; ++i) {	      \
-			if (vsyscall_phdrs[i].p_type == PT_LOAD)	      \
-				DUMP_WRITE((void *) (u64) vsyscall_phdrs[i].p_vaddr,\
-				    PAGE_ALIGN(vsyscall_phdrs[i].p_memsz));   \
-		}							      \
-	}								      \
-} while (0)
-
 struct elf_siginfo
 {
 	int	si_signo;			/* signal number */
diff -puN arch/x86_64/ia32/syscall32.c~x86_64-ia32-vdso-use-vm_alwaysdump arch/x86_64/ia32/syscall32.c
--- a/arch/x86_64/ia32/syscall32.c~x86_64-ia32-vdso-use-vm_alwaysdump
+++ a/arch/x86_64/ia32/syscall32.c
@@ -59,6 +59,13 @@ int syscall32_setup_pages(struct linux_b
 	vma->vm_end = VSYSCALL32_END;
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
 	vma->vm_ops = &syscall32_vm_ops;
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
