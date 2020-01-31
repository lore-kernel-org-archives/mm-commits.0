From: akpm@linux-foundation.org
Subject: [merged]
 elf-coredump-allow-process-with-empty-address-space-to-coredump.patch
 removed from -mm tree
Date: Fri, 31 Jan 2020 15:20:56 -0800
Message-ID: <20200131232056.JYnC0A8RU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbgAaXU5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:20:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf.c: coredump: allow process with empty address space to coredump
has been removed from the -mm tree.  Its filename was
     elf-coredump-allow-process-with-empty-address-space-to-coredump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fs/binfmt_elf.c: coredump: allow process with empty address space to coredump

Unmapping whole address space at once with

	munmap(0, (1ULL<<47) - 4096)

or equivalent will create empty coredump.

It is silly way to exit, however registers content may still be useful.

The right to coredump is fundamental right of a process!

Link: http://lkml.kernel.org/r/20191222150137.GA1277@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/binfmt_elf.c~elf-coredump-allow-process-with-empty-address-space-to-coredump
+++ a/fs/binfmt_elf.c
@@ -1595,6 +1595,10 @@ static int fill_files_note(struct memelf
 	if (size >= MAX_FILE_NOTE_SIZE) /* paranoia check */
 		return -EINVAL;
 	size = round_up(size, PAGE_SIZE);
+	/*
+	 * "size" can be 0 here legitimately.
+	 * Let it ENOMEM and omit NT_FILE section which will be empty anyway.
+	 */
 	data = kvmalloc(size, GFP_KERNEL);
 	if (ZERO_OR_NULL_PTR(data))
 		return -ENOMEM;
@@ -2257,9 +2261,13 @@ static int elf_core_dump(struct coredump
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
+	/*
+	 * Zero vma process will get ZERO_SIZE_PTR here.
+	 * Let coredump continue for register state at least.
+	 */
 	vma_filesz = kvmalloc(array_size(sizeof(*vma_filesz), (segs - 1)),
 			      GFP_KERNEL);
-	if (ZERO_OR_NULL_PTR(vma_filesz))
+	if (!vma_filesz)
 		goto end_coredump;
 
 	for (i = 0, vma = first_vma(current, gate_vma); vma != NULL;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

ramfs-support-o_tmpfile.patch
proc-decouple-proc-from-vfs-with-struct-proc_ops.patch
proc-convert-everything-to-struct-proc_ops.patch
