From: akpm@linux-foundation.org
Subject: [to-be-updated] binfmt-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch removed from -mm tree
Date: Tue, 01 Dec 2009 16:18:51 -0800
Message-ID: <200912020018.nB20IpGJ028322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754835AbZLBATP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 19:19:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, dhowells@redhat.com, hidehiro.kawai.ez@hitachi.com, lethal@linux-sh.org, mingo@elte.hu, oleg@redhat.com, roland@redhat.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     binfmt: pass mm->flags as a coredump parameter for consistency
has been removed from the -mm tree.  Its filename was
     binfmt-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: binfmt: pass mm->flags as a coredump parameter for consistency
From: Masami Hiramatsu <mhiramat@redhat.com>

Pass mm->flags as a coredump parameter for consistency.

 ---
1787         if (mm->core_state || !get_dumpable(mm)) {  <- (1)
1788                 up_write(&mm->mmap_sem);
1789                 put_cred(cred);
1790                 goto fail;
1791         }
1792
[...]
1798         if (get_dumpable(mm) == 2) {    /* Setuid core dump mode */ <-(2)
1799                 flag = O_EXCL;          /* Stop rewrite attacks */
1800                 cred->fsuid = 0;        /* Dump root private */
1801         }
 ---

Since dumpable bits are not protected by lock, there is a chance to change
these bits between (1) and (2).  A race condition can be caused by prctl
from another thread.

To solve this issue, this patch copies mm->flags to
coredump_params.mm_flags at the beginning of do_coredump() and uses it
instead of get_dumpable() while dumping core.

This copy is also passed to binfmt->core_dump, since elf*_core_dump() uses
dump_filter bits in mm->flags.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Reviewed-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c         |   12 ++----------
 fs/binfmt_elf_fdpic.c   |   12 ++----------
 fs/exec.c               |   20 ++++++++++++++++----
 include/linux/binfmts.h |    1 +
 4 files changed, 21 insertions(+), 24 deletions(-)

diff -puN fs/binfmt_elf.c~binfmt-pass-mm-flags-as-a-coredump-parameter-for-consistency fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt-pass-mm-flags-as-a-coredump-parameter-for-consistency
+++ a/fs/binfmt_elf.c
@@ -1911,7 +1911,6 @@ static int elf_core_dump(struct coredump
 	struct vm_area_struct *vma, *gate_vma;
 	struct elfhdr *elf = NULL;
 	loff_t offset = 0, dataoff, foffset;
-	unsigned long mm_flags;
 	struct elf_note_info info;
 
 	/*
@@ -1982,13 +1981,6 @@ static int elf_core_dump(struct coredump
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
-	/*
-	 * We must use the same mm->flags while dumping core to avoid
-	 * inconsistency between the program headers and bodies, otherwise an
-	 * unusable core file can be generated.
-	 */
-	mm_flags = current->mm->flags;
-
 	/* Write program headers for segments dump */
 	for (vma = first_vma(current, gate_vma); vma != NULL;
 			vma = next_vma(vma, gate_vma)) {
@@ -1998,7 +1990,7 @@ static int elf_core_dump(struct coredump
 		phdr.p_offset = offset;
 		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = vma_dump_size(vma, mm_flags);
+		phdr.p_filesz = vma_dump_size(vma, cprm->mm_flags);
 		phdr.p_memsz = vma->vm_end - vma->vm_start;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
@@ -2034,7 +2026,7 @@ static int elf_core_dump(struct coredump
 		unsigned long addr;
 		unsigned long end;
 
-		end = vma->vm_start + vma_dump_size(vma, mm_flags);
+		end = vma->vm_start + vma_dump_size(vma, cprm->mm_flags);
 
 		for (addr = vma->vm_start; addr < end; addr += PAGE_SIZE) {
 			struct page *page;
diff -puN fs/binfmt_elf_fdpic.c~binfmt-pass-mm-flags-as-a-coredump-parameter-for-consistency fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~binfmt-pass-mm-flags-as-a-coredump-parameter-for-consistency
+++ a/fs/binfmt_elf_fdpic.c
@@ -1605,7 +1605,6 @@ static int elf_fdpic_core_dump(struct co
 #endif
 	int thread_status_size = 0;
 	elf_addr_t *auxv;
-	unsigned long mm_flags;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1736,13 +1735,6 @@ static int elf_fdpic_core_dump(struct co
 	/* Page-align dumped data */
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
-	/*
-	 * We must use the same mm->flags while dumping core to avoid
-	 * inconsistency between the program headers and bodies, otherwise an
-	 * unusable core file can be generated.
-	 */
-	mm_flags = current->mm->flags;
-
 	/* write program headers for segments dump */
 	for (vma = current->mm->mmap; vma; vma = vma->vm_next) {
 		struct elf_phdr phdr;
@@ -1754,7 +1746,7 @@ static int elf_fdpic_core_dump(struct co
 		phdr.p_offset = offset;
 		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = maydump(vma, mm_flags) ? sz : 0;
+		phdr.p_filesz = maydump(vma, cprm->mm_flags) ? sz : 0;
 		phdr.p_memsz = sz;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
@@ -1790,7 +1782,7 @@ static int elf_fdpic_core_dump(struct co
 		goto end_coredump;
 
 	if (elf_fdpic_dump_segments(cprm->file, &size, &cprm->limit,
-				    mm_flags) < 0)
+				    cprm->mm_flags) < 0)
 		goto end_coredump;
 
 #ifdef ELF_CORE_WRITE_EXTRA_DATA
diff -puN fs/exec.c~binfmt-pass-mm-flags-as-a-coredump-parameter-for-consistency fs/exec.c
--- a/fs/exec.c~binfmt-pass-mm-flags-as-a-coredump-parameter-for-consistency
+++ a/fs/exec.c
@@ -1723,14 +1723,19 @@ void set_dumpable(struct mm_struct *mm, 
 	}
 }
 
-int get_dumpable(struct mm_struct *mm)
+static int __get_dumpable(unsigned long mm_flags)
 {
 	int ret;
 
-	ret = mm->flags & 0x3;
+	ret = mm_flags & MMF_DUMPABLE_MASK;
 	return (ret >= 2) ? 2 : ret;
 }
 
+int get_dumpable(struct mm_struct *mm)
+{
+	return __get_dumpable(mm->flags);
+}
+
 static void wait_for_dump_helpers(struct file *file)
 {
 	struct pipe_inode_info *pipe;
@@ -1774,6 +1779,12 @@ void do_coredump(long signr, int exit_co
 		.signr = signr,
 		.regs = regs,
 		.limit = current->signal->rlim[RLIMIT_CORE].rlim_cur,
+		/*
+		 * We must use the same mm->flags while dumping core to avoid
+		 * inconsistency of bit flags, since this flag is not protected
+		 * by any locks.
+		 */
+		.mm_flags = mm->flags,
 	};
 
 	audit_core_dumps(signr);
@@ -1792,7 +1803,7 @@ void do_coredump(long signr, int exit_co
 	/*
 	 * If another thread got here first, or we are not dumpable, bail out.
 	 */
-	if (mm->core_state || !get_dumpable(mm)) {
+	if (mm->core_state || !__get_dumpable(cprm.mm_flags)) {
 		up_write(&mm->mmap_sem);
 		put_cred(cred);
 		goto fail;
@@ -1803,7 +1814,8 @@ void do_coredump(long signr, int exit_co
 	 *	process nor do we know its entire history. We only know it
 	 *	was tainted so we dump it as root in mode 2.
 	 */
-	if (get_dumpable(mm) == 2) {	/* Setuid core dump mode */
+	if (__get_dumpable(cprm.mm_flags) == 2) {
+		/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
 		cred->fsuid = 0;	/* Dump root private */
 	}
diff -puN include/linux/binfmts.h~binfmt-pass-mm-flags-as-a-coredump-parameter-for-consistency include/linux/binfmts.h
--- a/include/linux/binfmts.h~binfmt-pass-mm-flags-as-a-coredump-parameter-for-consistency
+++ a/include/linux/binfmts.h
@@ -74,6 +74,7 @@ struct coredump_params {
 	struct pt_regs *regs;
 	struct file *file;
 	unsigned long limit;
+	unsigned long mm_flags;
 };
 
 /*
_

Patches currently in -mm which might be from mhiramat@redhat.com are

linux-next.patch
binfmt-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch

