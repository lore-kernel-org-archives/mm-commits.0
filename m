From: akpm@linux-foundation.org
Subject: [merged]
 elf-coredump-allocate-core-elf-header-on-stack.patch removed from -mm tree
Date: Fri, 31 Jan 2020 15:20:52 -0800
Message-ID: <20200131232052.IhTSq6Eim%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgAaXUy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:20:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf.c: coredump: allocate core ELF header on stack
has been removed from the -mm tree.  Its filename was
     elf-coredump-allocate-core-elf-header-on-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fs/binfmt_elf.c: coredump: allocate core ELF header on stack

Comment says ELF header is "too large to be on stack".  64 bytes on 64-bit
is not large by any means.

Link: http://lkml.kernel.org/r/20191222143850.GA24341@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/fs/binfmt_elf.c~elf-coredump-allocate-core-elf-header-on-stack
+++ a/fs/binfmt_elf.c
@@ -2186,7 +2186,7 @@ static int elf_core_dump(struct coredump
 	int segs, i;
 	size_t vma_data_size = 0;
 	struct vm_area_struct *vma, *gate_vma;
-	struct elfhdr *elf = NULL;
+	struct elfhdr elf;
 	loff_t offset = 0, dataoff;
 	struct elf_note_info info = { };
 	struct elf_phdr *phdr4note = NULL;
@@ -2207,10 +2207,6 @@ static int elf_core_dump(struct coredump
 	 * exists while dumping the mm->vm_next areas to the core file.
 	 */
   
-	/* alloc memory for large data structures: too large to be on stack */
-	elf = kmalloc(sizeof(*elf), GFP_KERNEL);
-	if (!elf)
-		goto out;
 	/*
 	 * The number of segs are recored into ELF header as 16bit value.
 	 * Please check DEFAULT_MAX_MAP_COUNT definition when you modify here.
@@ -2234,7 +2230,7 @@ static int elf_core_dump(struct coredump
 	 * Collect all the non-memory information about the process for the
 	 * notes.  This also sets up the file header.
 	 */
-	if (!fill_note_info(elf, e_phnum, &info, cprm->siginfo, cprm->regs))
+	if (!fill_note_info(&elf, e_phnum, &info, cprm->siginfo, cprm->regs))
 		goto cleanup;
 
 	has_dumped = 1;
@@ -2242,7 +2238,7 @@ static int elf_core_dump(struct coredump
 	fs = get_fs();
 	set_fs(KERNEL_DS);
 
-	offset += sizeof(*elf);				/* Elf header */
+	offset += sizeof(elf);				/* Elf header */
 	offset += segs * sizeof(struct elf_phdr);	/* Program headers */
 
 	/* Write notes phdr entry */
@@ -2285,12 +2281,12 @@ static int elf_core_dump(struct coredump
 		shdr4extnum = kmalloc(sizeof(*shdr4extnum), GFP_KERNEL);
 		if (!shdr4extnum)
 			goto end_coredump;
-		fill_extnum_info(elf, shdr4extnum, e_shoff, segs);
+		fill_extnum_info(&elf, shdr4extnum, e_shoff, segs);
 	}
 
 	offset = dataoff;
 
-	if (!dump_emit(cprm, elf, sizeof(*elf)))
+	if (!dump_emit(cprm, &elf, sizeof(elf)))
 		goto end_coredump;
 
 	if (!dump_emit(cprm, phdr4note, sizeof(*phdr4note)))
@@ -2374,8 +2370,6 @@ cleanup:
 	kfree(shdr4extnum);
 	kvfree(vma_filesz);
 	kfree(phdr4note);
-	kfree(elf);
-out:
 	return has_dumped;
 }
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

ramfs-support-o_tmpfile.patch
proc-decouple-proc-from-vfs-with-struct-proc_ops.patch
proc-convert-everything-to-struct-proc_ops.patch
