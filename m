From: akpm@linux-foundation.org
Subject: + coredump-masking-elf-enable-core-dump-filtering.patch added to -mm tree
Date: Tue, 29 May 2007 14:40:22 -0700
Message-ID: <200705292140.l4TLeMJ0012323@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188AbXE2Vkh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:40:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidehiro.kawai.ez@hitachi.com, alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, hugh@veritas.com, nickpiggin@yahoo.com.au


The patch titled
     coredump masking: ELF: enable core dump filtering
has been added to the -mm tree.  Its filename is
     coredump-masking-elf-enable-core-dump-filtering.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: coredump masking: ELF: enable core dump filtering
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>

This patch enables core dump filtering for ELF-formatted core file.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   30 +++++++++++++++++++++---------
 1 files changed, 21 insertions(+), 9 deletions(-)

diff -puN fs/binfmt_elf.c~coredump-masking-elf-enable-core-dump-filtering fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~coredump-masking-elf-enable-core-dump-filtering
+++ a/fs/binfmt_elf.c
@@ -1252,7 +1252,7 @@ static int dump_seek(struct file *file, 
  *
  * I think we should skip something. But I am not sure how. H.J.
  */
-static int maydump(struct vm_area_struct *vma)
+static int maydump(struct vm_area_struct *vma, unsigned long mm_flags)
 {
 	/* The vma can be set up to tell us the answer directly.  */
 	if (vma->vm_flags & VM_ALWAYSDUMP)
@@ -1262,15 +1262,19 @@ static int maydump(struct vm_area_struct
 	if (vma->vm_flags & (VM_IO | VM_RESERVED))
 		return 0;
 
-	/* Dump shared memory only if mapped from an anonymous file. */
-	if (vma->vm_flags & VM_SHARED)
-		return vma->vm_file->f_path.dentry->d_inode->i_nlink == 0;
+	/* By default, dump shared memory if mapped from an anonymous file. */
+	if (vma->vm_flags & VM_SHARED) {
+		if (vma->vm_file->f_path.dentry->d_inode->i_nlink == 0)
+			return test_bit(MMF_DUMP_ANON_SHARED, &mm_flags);
+		else
+			return test_bit(MMF_DUMP_MAPPED_SHARED, &mm_flags);
+	}
 
-	/* If it hasn't been written to, don't write it out */
+	/* By default, if it hasn't been written to, don't write it out. */
 	if (!vma->anon_vma)
-		return 0;
+		return test_bit(MMF_DUMP_MAPPED_PRIVATE, &mm_flags);
 
-	return 1;
+	return test_bit(MMF_DUMP_ANON_PRIVATE, &mm_flags);
 }
 
 /* An ELF note in memory */
@@ -1562,6 +1566,7 @@ static int elf_core_dump(long signr, str
 #endif
 	int thread_status_size = 0;
 	elf_addr_t *auxv;
+	unsigned long mm_flags;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1701,6 +1706,13 @@ static int elf_core_dump(long signr, str
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
+	/*
+	 * We must use the same mm->flags while dumping core to avoid
+	 * inconsistency between the program headers and bodies, otherwise an
+	 * unusable core file can be generated.
+	 */
+	mm_flags = current->mm->flags;
+
 	/* Write program headers for segments dump */
 	for (vma = first_vma(current, gate_vma); vma != NULL;
 			vma = next_vma(vma, gate_vma)) {
@@ -1713,7 +1725,7 @@ static int elf_core_dump(long signr, str
 		phdr.p_offset = offset;
 		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = maydump(vma) ? sz : 0;
+		phdr.p_filesz = maydump(vma, mm_flags) ? sz : 0;
 		phdr.p_memsz = sz;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
@@ -1756,7 +1768,7 @@ static int elf_core_dump(long signr, str
 			vma = next_vma(vma, gate_vma)) {
 		unsigned long addr;
 
-		if (!maydump(vma))
+		if (!maydump(vma, mm_flags))
 			continue;
 
 		for (addr = vma->vm_start;
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
