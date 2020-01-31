From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 106/118] fs/binfmt_elf.c: better codegen around
 current->mm
Date: Thu, 30 Jan 2020 22:16:58 -0800
Message-ID: <20200131061658.DSGltEEl1%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgAaGRA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:17:00 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fs/binfmt_elf.c: better codegen around current->mm

"current->mm" pointer is stable in general except few cases one of which
execve(2).  Compiler can't treat is as stable but it _is_ stable most of
the time.  During ELF loading process ->mm becomes stable right after
flush_old_exec().

Help compiler by caching current->mm, otherwise it continues to refetch it.

	add/remove: 0/0 grow/shrink: 0/2 up/down: 0/-141 (-141)
	Function                                     old     new   delta
	elf_core_dump                               5062    5039     -23
	load_elf_binary                             5426    5308    -118

Note: other cases are left as is because it is either pessimisation or no
change in binary size.

Link: http://lkml.kernel.org/r/20191215124755.GB21124@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   52 ++++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

--- a/fs/binfmt_elf.c~elf-better-codegen-around-current-mm
+++ a/fs/binfmt_elf.c
@@ -165,6 +165,7 @@ create_elf_tables(struct linux_binprm *b
 		unsigned long load_addr, unsigned long interp_load_addr,
 		unsigned long e_entry)
 {
+	struct mm_struct *mm = current->mm;
 	unsigned long p = bprm->p;
 	int argc = bprm->argc;
 	int envc = bprm->envc;
@@ -227,7 +228,7 @@ create_elf_tables(struct linux_binprm *b
 		return -EFAULT;
 
 	/* Create the ELF interpreter info */
-	elf_info = (elf_addr_t *)current->mm->saved_auxv;
+	elf_info = (elf_addr_t *)mm->saved_auxv;
 	/* update AT_VECTOR_SIZE_BASE if the number of NEW_AUX_ENT() changes */
 #define NEW_AUX_ENT(id, val) \
 	do { \
@@ -276,13 +277,13 @@ create_elf_tables(struct linux_binprm *b
 	}
 #undef NEW_AUX_ENT
 	/* AT_NULL is zero; clear the rest too */
-	memset(elf_info, 0, (char *)current->mm->saved_auxv +
-			sizeof(current->mm->saved_auxv) - (char *)elf_info);
+	memset(elf_info, 0, (char *)mm->saved_auxv +
+			sizeof(mm->saved_auxv) - (char *)elf_info);
 
 	/* And advance past the AT_NULL entry.  */
 	elf_info += 2;
 
-	ei_index = elf_info - (elf_addr_t *)current->mm->saved_auxv;
+	ei_index = elf_info - (elf_addr_t *)mm->saved_auxv;
 	sp = STACK_ADD(p, ei_index);
 
 	items = (argc + 1) + (envc + 1) + 1;
@@ -301,7 +302,7 @@ create_elf_tables(struct linux_binprm *b
 	 * Grow the stack manually; some architectures have a limit on how
 	 * far ahead a user-space access may be in order to grow the stack.
 	 */
-	vma = find_extend_vma(current->mm, bprm->p);
+	vma = find_extend_vma(mm, bprm->p);
 	if (!vma)
 		return -EFAULT;
 
@@ -310,7 +311,7 @@ create_elf_tables(struct linux_binprm *b
 		return -EFAULT;
 
 	/* Populate list of argv pointers back to argv strings. */
-	p = current->mm->arg_end = current->mm->arg_start;
+	p = mm->arg_end = mm->arg_start;
 	while (argc-- > 0) {
 		size_t len;
 		if (__put_user((elf_addr_t)p, sp++))
@@ -322,10 +323,10 @@ create_elf_tables(struct linux_binprm *b
 	}
 	if (__put_user(0, sp++))
 		return -EFAULT;
-	current->mm->arg_end = p;
+	mm->arg_end = p;
 
 	/* Populate list of envp pointers back to envp strings. */
-	current->mm->env_end = current->mm->env_start = p;
+	mm->env_end = mm->env_start = p;
 	while (envc-- > 0) {
 		size_t len;
 		if (__put_user((elf_addr_t)p, sp++))
@@ -337,10 +338,10 @@ create_elf_tables(struct linux_binprm *b
 	}
 	if (__put_user(0, sp++))
 		return -EFAULT;
-	current->mm->env_end = p;
+	mm->env_end = p;
 
 	/* Put the elf_info on the stack in the right place.  */
-	if (copy_to_user(sp, current->mm->saved_auxv, ei_index * sizeof(elf_addr_t)))
+	if (copy_to_user(sp, mm->saved_auxv, ei_index * sizeof(elf_addr_t)))
 		return -EFAULT;
 	return 0;
 }
@@ -701,6 +702,7 @@ static int load_elf_binary(struct linux_
 		struct elfhdr interp_elf_ex;
 	} *loc;
 	struct arch_elf_state arch_state = INIT_ARCH_ELF_STATE;
+	struct mm_struct *mm;
 	struct pt_regs *regs;
 
 	loc = kmalloc(sizeof(*loc), GFP_KERNEL);
@@ -1096,11 +1098,13 @@ out_free_interp:
 			  load_addr, interp_load_addr, e_entry);
 	if (retval < 0)
 		goto out;
-	current->mm->end_code = end_code;
-	current->mm->start_code = start_code;
-	current->mm->start_data = start_data;
-	current->mm->end_data = end_data;
-	current->mm->start_stack = bprm->p;
+
+	mm = current->mm;
+	mm->end_code = end_code;
+	mm->start_code = start_code;
+	mm->start_data = start_data;
+	mm->end_data = end_data;
+	mm->start_stack = bprm->p;
 
 	if ((current->flags & PF_RANDOMIZE) && (randomize_va_space > 1)) {
 		/*
@@ -1111,12 +1115,11 @@ out_free_interp:
 		 * growing down), and into the unused ELF_ET_DYN_BASE region.
 		 */
 		if (IS_ENABLED(CONFIG_ARCH_HAS_ELF_RANDOMIZE) &&
-		    elf_ex->e_type == ET_DYN && !interpreter)
-			current->mm->brk = current->mm->start_brk =
-				ELF_ET_DYN_BASE;
+		    elf_ex->e_type == ET_DYN && !interpreter) {
+			mm->brk = mm->start_brk = ELF_ET_DYN_BASE;
+		}
 
-		current->mm->brk = current->mm->start_brk =
-			arch_randomize_brk(current->mm);
+		mm->brk = mm->start_brk = arch_randomize_brk(mm);
 #ifdef compat_brk_randomized
 		current->brk_randomized = 1;
 #endif
@@ -1574,6 +1577,7 @@ static void fill_siginfo_note(struct mem
  */
 static int fill_files_note(struct memelfnote *note)
 {
+	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	unsigned count, size, names_ofs, remaining, n;
 	user_long_t *data;
@@ -1581,7 +1585,7 @@ static int fill_files_note(struct memelf
 	char *name_base, *name_curpos;
 
 	/* *Estimated* file count and total data size needed */
-	count = current->mm->map_count;
+	count = mm->map_count;
 	if (count > UINT_MAX / 64)
 		return -EINVAL;
 	size = count * 64;
@@ -1599,7 +1603,7 @@ static int fill_files_note(struct memelf
 	name_base = name_curpos = ((char *)data) + names_ofs;
 	remaining = size - names_ofs;
 	count = 0;
-	for (vma = current->mm->mmap; vma != NULL; vma = vma->vm_next) {
+	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
 		struct file *file;
 		const char *filename;
 
@@ -1633,10 +1637,10 @@ static int fill_files_note(struct memelf
 	data[0] = count;
 	data[1] = PAGE_SIZE;
 	/*
-	 * Count usually is less than current->mm->map_count,
+	 * Count usually is less than mm->map_count,
 	 * we need to move filenames down.
 	 */
-	n = current->mm->map_count - count;
+	n = mm->map_count - count;
 	if (n != 0) {
 		unsigned shift_bytes = n * 3 * sizeof(data[0]);
 		memmove(name_base - shift_bytes, name_base,
_
