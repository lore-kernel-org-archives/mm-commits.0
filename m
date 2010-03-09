From: akpm@linux-foundation.org
Subject: [merged] elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:09:50 -0800
Message-ID: <201003091909.o29J9oq3031549__38817.5677661367$1268162615$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756079Ab0CITXF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:23:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, dhowells@redhat.com, gerg@snapgear.com, jdike@addtoit.com, linux-arch@vger.kernel.org, mingo@elte.hu, oleg@re


The patch titled
     elf coredump: make offset calculation process and writing process explicit
has been removed from the -mm tree.  Its filename was
     elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: elf coredump: make offset calculation process and writing process explicit
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>

By the next patch, elf_core_dump() and elf_fdpic_core_dump() will support
extended numbering and so will produce the corefiles with section header
table in a special case.

The problem is the process of writing a file header offset of the section
header table into e_shoff field of the ELF header.  ELF header is
positioned at the beginning of the corefile, while section header at the
end.  So, we need to take which of the following ways:

 1. Seek backward to retry writing operation for ELF header
    after writing process for a whole part

 2. Make offset calculation process and writing process
    totally sequential

The clause 1.  is not always possible: one cannot assume that file system
supports seek function.  Consider the no_llseek case.

Therefore, this patch adopts the clause 2.

Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c       |   27 ++++++++++++++++-----------
 fs/binfmt_elf_fdpic.c |   29 ++++++++++++++++-------------
 2 files changed, 32 insertions(+), 24 deletions(-)

diff -puN fs/binfmt_elf.c~elf-coredump-make-offset-calculation-process-and-writing-process-explicit fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~elf-coredump-make-offset-calculation-process-and-writing-process-explicit
+++ a/fs/binfmt_elf.c
@@ -1856,6 +1856,7 @@ static int elf_core_dump(struct coredump
 	loff_t offset = 0, dataoff, foffset;
 	unsigned long mm_flags;
 	struct elf_note_info info;
+	struct elf_phdr *phdr4note = NULL;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1898,28 +1899,22 @@ static int elf_core_dump(struct coredump
 	fs = get_fs();
 	set_fs(KERNEL_DS);
 
-	size += sizeof(*elf);
-	if (size > cprm->limit || !dump_write(cprm->file, elf, sizeof(*elf)))
-		goto end_coredump;
-
 	offset += sizeof(*elf);				/* Elf header */
 	offset += (segs + 1) * sizeof(struct elf_phdr); /* Program headers */
 	foffset = offset;
 
 	/* Write notes phdr entry */
 	{
-		struct elf_phdr phdr;
 		size_t sz = get_note_info_size(&info);
 
 		sz += elf_coredump_extra_notes_size();
 
-		fill_elf_note_phdr(&phdr, sz, offset);
-		offset += sz;
-
-		size += sizeof(phdr);
-		if (size > cprm->limit
-		    || !dump_write(cprm->file, &phdr, sizeof(phdr)))
+		phdr4note = kmalloc(sizeof(*phdr4note), GFP_KERNEL);
+		if (!phdr4note)
 			goto end_coredump;
+
+		fill_elf_note_phdr(phdr4note, sz, offset);
+		offset += sz;
 	}
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
@@ -1931,6 +1926,15 @@ static int elf_core_dump(struct coredump
 	 */
 	mm_flags = current->mm->flags;
 
+	size += sizeof(*elf);
+	if (size > cprm->limit || !dump_write(cprm->file, elf, sizeof(*elf)))
+		goto end_coredump;
+
+	size += sizeof(*phdr4note);
+	if (size > cprm->limit
+	    || !dump_write(cprm->file, phdr4note, sizeof(*phdr4note)))
+		goto end_coredump;
+
 	/* Write program headers for segments dump */
 	for (vma = first_vma(current, gate_vma); vma != NULL;
 			vma = next_vma(vma, gate_vma)) {
@@ -2004,6 +2008,7 @@ end_coredump:
 
 cleanup:
 	free_note_info(&info);
+	kfree(phdr4note);
 	kfree(elf);
 out:
 	return has_dumped;
diff -puN fs/binfmt_elf_fdpic.c~elf-coredump-make-offset-calculation-process-and-writing-process-explicit fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~elf-coredump-make-offset-calculation-process-and-writing-process-explicit
+++ a/fs/binfmt_elf_fdpic.c
@@ -1600,6 +1600,7 @@ static int elf_fdpic_core_dump(struct co
 	int thread_status_size = 0;
 	elf_addr_t *auxv;
 	unsigned long mm_flags;
+	struct elf_phdr *phdr4note = NULL;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1706,18 +1707,12 @@ static int elf_fdpic_core_dump(struct co
 	fs = get_fs();
 	set_fs(KERNEL_DS);
 
-	size += sizeof(*elf);
-	if (size > cprm->limit
-	    || !dump_write(cprm->file, elf, sizeof(*elf)))
-		goto end_coredump;
-
 	offset += sizeof(*elf);				/* Elf header */
 	offset += (segs+1) * sizeof(struct elf_phdr);	/* Program headers */
 	foffset = offset;
 
 	/* Write notes phdr entry */
 	{
-		struct elf_phdr phdr;
 		int sz = 0;
 
 		for (i = 0; i < numnote; i++)
@@ -1725,13 +1720,12 @@ static int elf_fdpic_core_dump(struct co
 
 		sz += thread_status_size;
 
-		fill_elf_note_phdr(&phdr, sz, offset);
-		offset += sz;
-
-		size += sizeof(phdr);
-		if (size > cprm->limit
-		    || !dump_write(cprm->file, &phdr, sizeof(phdr)))
+		phdr4note = kmalloc(sizeof(*phdr4note), GFP_KERNEL);
+		if (!phdr4note)
 			goto end_coredump;
+
+		fill_elf_note_phdr(phdr4note, sz, offset);
+		offset += sz;
 	}
 
 	/* Page-align dumped data */
@@ -1744,6 +1738,15 @@ static int elf_fdpic_core_dump(struct co
 	 */
 	mm_flags = current->mm->flags;
 
+	size += sizeof(*elf);
+	if (size > cprm->limit || !dump_write(cprm->file, elf, sizeof(*elf)))
+		goto end_coredump;
+
+	size += sizeof(*phdr4note);
+	if (size > cprm->limit
+	    || !dump_write(cprm->file, phdr4note, sizeof(*phdr4note)))
+		goto end_coredump;
+
 	/* write program headers for segments dump */
 	for (vma = current->mm->mmap; vma; vma = vma->vm_next) {
 		struct elf_phdr phdr;
@@ -1815,7 +1818,7 @@ cleanup:
 		list_del(tmp);
 		kfree(list_entry(tmp, struct elf_thread_status, list));
 	}
