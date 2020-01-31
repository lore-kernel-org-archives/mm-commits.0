From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 110/118] fs/binfmt_elf.c: coredump: allow process
 with empty address space to coredump
Date: Thu, 30 Jan 2020 22:17:10 -0800
Message-ID: <20200131061710.rGdjO2hok%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgAaGRL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:17:11 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
