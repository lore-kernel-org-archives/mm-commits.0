From: akpm@linux-foundation.org
Subject: - pie-randomization.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:21 -0700
Message-ID: <200707162054.l6GKsL3M001793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38146 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752351AbXGPVg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:36:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: honza@jikos.cz, jakub@redhat.com, jkosina@suse.cz, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     PIE randomization
has been removed from the -mm tree.  Its filename was
     pie-randomization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PIE randomization
From: Jan Kratochvil <honza@jikos.cz>

This patch is using mmap()'s randomization functionality in such a way that
it maps the main executable of (specially compiled/linked -pie/-fpie)
ET_DYN binaries onto a random address (in cases in which mmap() is allowed
to perform a randomization).

Origin of this patch is in exec-shield
(http://people.redhat.com/mingo/exec-shield/)

[jkosina@suse.cz: pie randomization: fix BAD_ADDR macro]
Signed-off-by: Jan Kratochvil <honza@jikos.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/ia32/binfmt_elf32.c |    2 
 fs/binfmt_elf.c               |  109 +++++++++++++++++++++++++-------
 2 files changed, 87 insertions(+), 24 deletions(-)

diff -puN arch/ia64/ia32/binfmt_elf32.c~pie-randomization arch/ia64/ia32/binfmt_elf32.c
--- a/arch/ia64/ia32/binfmt_elf32.c~pie-randomization
+++ a/arch/ia64/ia32/binfmt_elf32.c
@@ -261,7 +261,7 @@ elf32_set_personality (void)
 }
 
 static unsigned long
-elf32_map (struct file *filep, unsigned long addr, struct elf_phdr *eppnt, int prot, int type)
+elf32_map (struct file *filep, unsigned long addr, struct elf_phdr *eppnt, int prot, int type, unsigned long unused)
 {
 	unsigned long pgoff = (eppnt->p_vaddr) & ~IA32_PAGE_MASK;
 
diff -puN fs/binfmt_elf.c~pie-randomization fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~pie-randomization
+++ a/fs/binfmt_elf.c
@@ -45,7 +45,7 @@
 
 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);
 static int load_elf_library(struct file *);
-static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int);
+static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int, unsigned long);
 
 /*
  * If we don't support core dumping, then supply a NULL so we
@@ -80,7 +80,7 @@ static struct linux_binfmt elf_format = 
 		.hasvdso	= 1
 };
 
-#define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
+#define BAD_ADDR(x) IS_ERR_VALUE(x)
 
 static int set_brk(unsigned long start, unsigned long end)
 {
@@ -285,33 +285,70 @@ create_elf_tables(struct linux_binprm *b
 #ifndef elf_map
 
 static unsigned long elf_map(struct file *filep, unsigned long addr,
-		struct elf_phdr *eppnt, int prot, int type)
+		struct elf_phdr *eppnt, int prot, int type,
+		unsigned long total_size)
 {
 	unsigned long map_addr;
-	unsigned long pageoffset = ELF_PAGEOFFSET(eppnt->p_vaddr);
+	unsigned long size = eppnt->p_filesz + ELF_PAGEOFFSET(eppnt->p_vaddr);
+	unsigned long off = eppnt->p_offset - ELF_PAGEOFFSET(eppnt->p_vaddr);
+	addr = ELF_PAGESTART(addr);
+	size = ELF_PAGEALIGN(size);
 
-	down_write(&current->mm->mmap_sem);
 	/* mmap() will return -EINVAL if given a zero size, but a
 	 * segment with zero filesize is perfectly valid */
-	if (eppnt->p_filesz + pageoffset)
-		map_addr = do_mmap(filep, ELF_PAGESTART(addr),
-				   eppnt->p_filesz + pageoffset, prot, type,
-				   eppnt->p_offset - pageoffset);
-	else
-		map_addr = ELF_PAGESTART(addr);
+	if (!size)
+		return addr;
+
+	down_write(&current->mm->mmap_sem);
+	/*
+	* total_size is the size of the ELF (interpreter) image.
+	* The _first_ mmap needs to know the full size, otherwise
+	* randomization might put this image into an overlapping
+	* position with the ELF binary image. (since size < total_size)
+	* So we first map the 'big' image - and unmap the remainder at
+	* the end. (which unmap is needed for ELF images with holes.)
+	*/
+	if (total_size) {
+		total_size = ELF_PAGEALIGN(total_size);
+		map_addr = do_mmap(filep, addr, total_size, prot, type, off);
+		if (!BAD_ADDR(map_addr))
+			do_munmap(current->mm, map_addr+size, total_size-size);
+	} else
+		map_addr = do_mmap(filep, addr, size, prot, type, off);
+
 	up_write(&current->mm->mmap_sem);
 	return(map_addr);
 }
 
 #endif /* !elf_map */
 
+static unsigned long total_mapping_size(struct elf_phdr *cmds, int nr)
+{
+	int i, first_idx = -1, last_idx = -1;
+
+	for (i = 0; i < nr; i++) {
+		if (cmds[i].p_type == PT_LOAD) {
+			last_idx = i;
+			if (first_idx == -1)
+				first_idx = i;
+		}
+	}
+	if (first_idx == -1)
+		return 0;
+
+	return cmds[last_idx].p_vaddr + cmds[last_idx].p_memsz -
+				ELF_PAGESTART(cmds[first_idx].p_vaddr);
+}
+
+
 /* This is much more generalized than the library routine read function,
    so we keep this separate.  Technically the library read function
    is only provided so that we can read a.out libraries that have
    an ELF header */
 
 static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
-		struct file *interpreter, unsigned long *interp_load_addr)
+		struct file *interpreter, unsigned long *interp_map_addr,
+		unsigned long no_base)
 {
 	struct elf_phdr *elf_phdata;
 	struct elf_phdr *eppnt;
@@ -319,6 +356,7 @@ static unsigned long load_elf_interp(str
 	int load_addr_set = 0;
 	unsigned long last_bss = 0, elf_bss = 0;
 	unsigned long error = ~0UL;
+	unsigned long total_size;
 	int retval, i, size;
 
 	/* First of all, some simple consistency checks */
@@ -357,6 +395,12 @@ static unsigned long load_elf_interp(str
 		goto out_close;
 	}
 
+	total_size = total_mapping_size(elf_phdata, interp_elf_ex->e_phnum);
+	if (!total_size) {
+		error = -EINVAL;
+		goto out_close;
+	}
+
 	eppnt = elf_phdata;
 	for (i = 0; i < interp_elf_ex->e_phnum; i++, eppnt++) {
 		if (eppnt->p_type == PT_LOAD) {
@@ -374,9 +418,14 @@ static unsigned long load_elf_interp(str
 			vaddr = eppnt->p_vaddr;
 			if (interp_elf_ex->e_type == ET_EXEC || load_addr_set)
 				elf_type |= MAP_FIXED;
+			else if (no_base && interp_elf_ex->e_type == ET_DYN)
+				load_addr = -vaddr;
 
 			map_addr = elf_map(interpreter, load_addr + vaddr,
-					   eppnt, elf_prot, elf_type);
+					   eppnt, elf_prot, elf_type, total_size);
+			total_size = 0;
+			if (!*interp_map_addr)
+				*interp_map_addr = map_addr;
 			error = map_addr;
 			if (BAD_ADDR(map_addr))
 				goto out_close;
@@ -442,8 +491,7 @@ static unsigned long load_elf_interp(str
 			goto out_close;
 	}
 
-	*interp_load_addr = load_addr;
-	error = ((unsigned long)interp_elf_ex->e_entry) + load_addr;
+	error = load_addr;
 
 out_close:
 	kfree(elf_phdata);
@@ -540,7 +588,8 @@ static int load_elf_binary(struct linux_
 	int elf_exec_fileno;
 	int retval, i;
 	unsigned int size;
-	unsigned long elf_entry, interp_load_addr = 0;
+	unsigned long elf_entry;
+	unsigned long interp_load_addr = 0;
 	unsigned long start_code, end_code, start_data, end_data;
 	unsigned long reloc_func_desc = 0;
 	char passed_fileno[6];
@@ -808,9 +857,7 @@ static int load_elf_binary(struct linux_
 	current->mm->start_stack = bprm->p;
 
 	/* Now we do a little grungy work by mmaping the ELF image into
-	   the correct location in memory.  At this point, we assume that
-	   the image should be loaded at fixed address, not at a variable
-	   address. */
+	   the correct location in memory. */
 	for(i = 0, elf_ppnt = elf_phdata;
 	    i < loc->elf_ex.e_phnum; i++, elf_ppnt++) {
 		int elf_prot = 0, elf_flags;
@@ -864,11 +911,15 @@ static int load_elf_binary(struct linux_
 			 * default mmap base, as well as whatever program they
 			 * might try to exec.  This is because the brk will
 			 * follow the loader, and is not movable.  */
+#ifdef CONFIG_X86
+			load_bias = 0;
+#else
 			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
+#endif
 		}
 
 		error = elf_map(bprm->file, load_bias + vaddr, elf_ppnt,
-				elf_prot, elf_flags);
+				elf_prot, elf_flags,0);
 		if (BAD_ADDR(error)) {
 			send_sig(SIGKILL, current, 0);
 			retval = IS_ERR((void *)error) ?
@@ -944,13 +995,25 @@ static int load_elf_binary(struct linux_
 	}
 
 	if (elf_interpreter) {
-		if (interpreter_type == INTERPRETER_AOUT)
+		if (interpreter_type == INTERPRETER_AOUT) {
 			elf_entry = load_aout_interp(&loc->interp_ex,
 						     interpreter);
-		else
+		} else {
+			unsigned long interp_map_addr;	/* unused */
+
 			elf_entry = load_elf_interp(&loc->interp_elf_ex,
 						    interpreter,
-						    &interp_load_addr);
+						    &interp_map_addr,
+						    load_bias);
+			if (!BAD_ADDR(elf_entry)) {
+				/*
+				 * load_elf_interp() returns relocation
+				 * adjustment
+				 */
+				interp_load_addr = elf_entry;
+				elf_entry += loc->interp_elf_ex.e_entry;
+			}
+		}
 		if (BAD_ADDR(elf_entry)) {
 			force_sig(SIGSEGV, current);
 			retval = IS_ERR((void *)elf_entry) ?
_

Patches currently in -mm which might be from honza@jikos.cz are

origin.patch
git-input.patch
