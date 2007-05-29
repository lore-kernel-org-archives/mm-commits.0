From: akpm@linux-foundation.org
Subject: + coredump-masking-elf-fdpic-enable-core-dump-filtering.patch added to -mm tree
Date: Tue, 29 May 2007 14:40:26 -0700
Message-ID: <200705292140.l4TLeQ6R012330@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177AbXE2Vkn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:40:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidehiro.kawai.ez@hitachi.com, alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, hugh@veritas.com, nickpiggin@yahoo.com.au


The patch titled
     coredump masking: ELF-FDPIC: enable core dump filtering
has been added to the -mm tree.  Its filename is
     coredump-masking-elf-fdpic-enable-core-dump-filtering.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: coredump masking: ELF-FDPIC: enable core dump filtering
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>

This patch enables core dump filtering for ELF-FDPIC-formatted core file.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |   52 ++++++++++++++++++++++++++--------------
 1 files changed, 35 insertions(+), 17 deletions(-)

diff -puN fs/binfmt_elf_fdpic.c~coredump-masking-elf-fdpic-enable-core-dump-filtering fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~coredump-masking-elf-fdpic-enable-core-dump-filtering
+++ a/fs/binfmt_elf_fdpic.c
@@ -1181,8 +1181,10 @@ static int dump_seek(struct file *file, 
  *
  * I think we should skip something. But I am not sure how. H.J.
  */
-static int maydump(struct vm_area_struct *vma)
+static int maydump(struct vm_area_struct *vma, unsigned long mm_flags)
 {
+	int dump_ok;
+
 	/* Do not dump I/O mapped devices or special mappings */
 	if (vma->vm_flags & (VM_IO | VM_RESERVED)) {
 		kdcore("%08lx: %08lx: no (IO)", vma->vm_start, vma->vm_flags);
@@ -1197,27 +1199,35 @@ static int maydump(struct vm_area_struct
 		return 0;
 	}
 
-	/* Dump shared memory only if mapped from an anonymous file. */
+	/* By default, dump shared memory if mapped from an anonymous file. */
 	if (vma->vm_flags & VM_SHARED) {
 		if (vma->vm_file->f_path.dentry->d_inode->i_nlink == 0) {
-			kdcore("%08lx: %08lx: no (share)", vma->vm_start, vma->vm_flags);
-			return 1;
+			dump_ok = test_bit(MMF_DUMP_ANON_SHARED, &mm_flags);
+			kdcore("%08lx: %08lx: %s (share)", vma->vm_start,
+			       vma->vm_flags, dump_ok ? "yes" : "no");
+			return dump_ok;
 		}
 
-		kdcore("%08lx: %08lx: no (share)", vma->vm_start, vma->vm_flags);
-		return 0;
+		dump_ok = test_bit(MMF_DUMP_MAPPED_SHARED, &mm_flags);
+		kdcore("%08lx: %08lx: %s (share)", vma->vm_start,
+		       vma->vm_flags, dump_ok ? "yes" : "no");
+		return dump_ok;
 	}
 
 #ifdef CONFIG_MMU
-	/* If it hasn't been written to, don't write it out */
+	/* By default, if it hasn't been written to, don't write it out */
 	if (!vma->anon_vma) {
-		kdcore("%08lx: %08lx: no (!anon)", vma->vm_start, vma->vm_flags);
-		return 0;
+		dump_ok = test_bit(MMF_DUMP_MAPPED_PRIVATE, &mm_flags);
+		kdcore("%08lx: %08lx: %s (!anon)", vma->vm_start,
+		       vma->vm_flags, dump_ok ? "yes" : "no");
+		return dump_ok;
 	}
 #endif
 
-	kdcore("%08lx: %08lx: yes", vma->vm_start, vma->vm_flags);
-	return 1;
+	dump_ok = test_bit(MMF_DUMP_ANON_PRIVATE, &mm_flags);
+	kdcore("%08lx: %08lx: %s", vma->vm_start, vma->vm_flags,
+	       dump_ok ? "yes" : "no");
+	return dump_ok;
 }
 
 /* An ELF note in memory */
@@ -1457,14 +1467,14 @@ static int elf_dump_thread_status(long s
  */
 #ifdef CONFIG_MMU
 static int elf_fdpic_dump_segments(struct file *file, size_t *size,
-				   unsigned long *limit)
+			   unsigned long *limit, unsigned long mm_flags)
 {
 	struct vm_area_struct *vma;
 
 	for (vma = current->mm->mmap; vma; vma = vma->vm_next) {
 		unsigned long addr;
 
-		if (!maydump(vma))
+		if (!maydump(vma, mm_flags))
 			continue;
 
 		for (addr = vma->vm_start;
@@ -1512,14 +1522,14 @@ end_coredump:
  */
 #ifndef CONFIG_MMU
 static int elf_fdpic_dump_segments(struct file *file, size_t *size,
-				   unsigned long *limit)
+			   unsigned long *limit, unsigned long mm_flags)
 {
 	struct vm_list_struct *vml;
 
 	for (vml = current->mm->context.vmlist; vml; vml = vml->next) {
 	struct vm_area_struct *vma = vml->vma;
 
-		if (!maydump(vma))
+		if (!maydump(vma, mm_flags))
 			continue;
 
 		if ((*size += PAGE_SIZE) > *limit)
@@ -1570,6 +1580,7 @@ static int elf_fdpic_core_dump(long sign
 	struct vm_list_struct *vml;
 #endif
 	elf_addr_t *auxv;
+	unsigned long mm_flags;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1707,6 +1718,13 @@ static int elf_fdpic_core_dump(long sign
 	/* Page-align dumped data */
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
+	/*
+	 * We must use the same mm->flags while dumping core to avoid
+	 * inconsistency between the program headers and bodies, otherwise an
+	 * unusable core file can be generated.
+	 */
+	mm_flags = current->mm->flags;
+
 	/* write program headers for segments dump */
 	for (
 #ifdef CONFIG_MMU
@@ -1728,7 +1746,7 @@ static int elf_fdpic_core_dump(long sign
 		phdr.p_offset = offset;
 		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = maydump(vma) ? sz : 0;
+		phdr.p_filesz = maydump(vma, mm_flags) ? sz : 0;
 		phdr.p_memsz = sz;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
@@ -1762,7 +1780,7 @@ static int elf_fdpic_core_dump(long sign
 
 	DUMP_SEEK(dataoff);
 
-	if (elf_fdpic_dump_segments(file, current->mm, &size, &limit) < 0)
+	if (elf_fdpic_dump_segments(file, &size, &limit, mm_flags) < 0)
 		goto end_coredump;
 
 #ifdef ELF_CORE_WRITE_EXTRA_DATA
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
