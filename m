From: akpm@linux-foundation.org
Subject: - coredump-masking-elf-enable-core-dump-filtering.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:02:20 -0700
Message-ID: <200707192002.l6JK2Khp019656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37604 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932264AbXGSUai (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:30:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidehiro.kawai.ez@hitachi.com, alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, hugh@veritas.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     coredump masking: ELF: enable core dump filtering
has been removed from the -mm tree.  Its filename was
     coredump-masking-elf-enable-core-dump-filtering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 21 insertions(+), 9 deletions(-)

diff -puN fs/binfmt_elf.c~coredump-masking-elf-enable-core-dump-filtering fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~coredump-masking-elf-enable-core-dump-filtering
+++ a/fs/binfmt_elf.c
@@ -1262,7 +1262,7 @@ static int dump_seek(struct file *file, 
  *
  * I think we should skip something. But I am not sure how. H.J.
  */
-static int maydump(struct vm_area_struct *vma)
+static int maydump(struct vm_area_struct *vma, unsigned long mm_flags)
 {
 	/* The vma can be set up to tell us the answer directly.  */
 	if (vma->vm_flags & VM_ALWAYSDUMP)
@@ -1272,15 +1272,19 @@ static int maydump(struct vm_area_struct
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
@@ -1572,6 +1576,7 @@ static int elf_core_dump(long signr, str
 #endif
 	int thread_status_size = 0;
 	elf_addr_t *auxv;
+	unsigned long mm_flags;
 #ifdef ELF_CORE_WRITE_EXTRA_NOTES
 	int extra_notes_size;
 #endif
@@ -1715,6 +1720,13 @@ static int elf_core_dump(long signr, str
 
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
@@ -1727,7 +1739,7 @@ static int elf_core_dump(long signr, str
 		phdr.p_offset = offset;
 		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = maydump(vma) ? sz : 0;
+		phdr.p_filesz = maydump(vma, mm_flags) ? sz : 0;
 		phdr.p_memsz = sz;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
@@ -1771,7 +1783,7 @@ static int elf_core_dump(long signr, str
 			vma = next_vma(vma, gate_vma)) {
 		unsigned long addr;
 
-		if (!maydump(vma))
+		if (!maydump(vma, mm_flags))
 			continue;
 
 		for (addr = vma->vm_start;
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

origin.patch
