From: akpm@linux-foundation.org
Subject: [merged]
 fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing.patch removed from -mm tree
Date: Thu, 17 Oct 2013 11:12:09 -0700
Message-ID: <52602879.3/Ee0eHBsf7Xilhs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608Ab3JQSMK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:12:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, vda.linux@googlemail.com, stable@vger.kernel.org, mmokrejs@gmail.com, alonid@stratoscale.com

Subject: [merged] fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing.patch removed from -mm tree
To: alonid@stratoscale.com,mmokrejs@gmail.com,stable@vger.kernel.org,vda.linux@googlemail.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:12:09 -0700


The patch titled
     Subject: fs/binfmt_elf.c: prevent a coredump with a large vm_map_count from Oopsing
has been removed from the -mm tree.  Its filename was
     fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Aloni <alonid@stratoscale.com>
Subject: fs/binfmt_elf.c: prevent a coredump with a large vm_map_count from Oopsing

A high setting of max_map_count, and a process core-dumping with a large
enough vm_map_count could result in an NT_FILE note not being written, and
the kernel crashing immediately later because it has assumed otherwise.

Reproduction of the oops-causing bug described here:

    https://lkml.org/lkml/2013/8/30/50

Issue originating in 2aa362c49 ("coredump: extend core dump note section
to contain file names of mapped file") from Oct 4, 2012.

This patch make that section optional in that case.  fill_files_note()
should signify the error, and also let the info struct in elf_core_dump()
be zero-initialized so that we can check for the optionally written note.

[akpm@linux-foundation.org: avoid abusing E2BIG, remove a couple of not-really-needed local variables]
[akpm@linux-foundation.org: fix sparse warning]
Signed-off-by: Dan Aloni <alonid@stratoscale.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Reported-by: Martin MOKREJS <mmokrejs@gmail.com>
Tested-by: Martin MOKREJS <mmokrejs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff -puN fs/binfmt_elf.c~fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing
+++ a/fs/binfmt_elf.c
@@ -1413,7 +1413,7 @@ static void fill_siginfo_note(struct mem
  *   long file_ofs
  * followed by COUNT filenames in ASCII: "FILE1" NUL "FILE2" NUL...
  */
-static void fill_files_note(struct memelfnote *note)
+static int fill_files_note(struct memelfnote *note)
 {
 	struct vm_area_struct *vma;
 	unsigned count, size, names_ofs, remaining, n;
@@ -1428,11 +1428,11 @@ static void fill_files_note(struct memel
 	names_ofs = (2 + 3 * count) * sizeof(data[0]);
  alloc:
 	if (size >= MAX_FILE_NOTE_SIZE) /* paranoia check */
-		goto err;
+		return -EINVAL;
 	size = round_up(size, PAGE_SIZE);
 	data = vmalloc(size);
 	if (!data)
-		goto err;
+		return -ENOMEM;
 
 	start_end_ofs = data + 2;
 	name_base = name_curpos = ((char *)data) + names_ofs;
@@ -1485,7 +1485,7 @@ static void fill_files_note(struct memel
 
 	size = name_curpos - (char *)data;
 	fill_note(note, "CORE", NT_FILE, size, data);
- err: ;
+	return 0;
 }
 
 #ifdef CORE_DUMP_USE_REGSET
@@ -1686,8 +1686,8 @@ static int fill_note_info(struct elfhdr
 	fill_auxv_note(&info->auxv, current->mm);
 	info->size += notesize(&info->auxv);
 
-	fill_files_note(&info->files);
-	info->size += notesize(&info->files);
+	if (fill_files_note(&info->files) == 0)
+		info->size += notesize(&info->files);
 
 	return 1;
 }
@@ -1719,7 +1719,8 @@ static int write_note_info(struct elf_no
 			return 0;
 		if (first && !writenote(&info->auxv, file, foffset))
 			return 0;
-		if (first && !writenote(&info->files, file, foffset))
+		if (first && info->files.data &&
+				!writenote(&info->files, file, foffset))
 			return 0;
 
 		for (i = 1; i < info->thread_notes; ++i)
@@ -1806,6 +1807,7 @@ static int elf_dump_thread_status(long s
 
 struct elf_note_info {
 	struct memelfnote *notes;
+	struct memelfnote *notes_files;
 	struct elf_prstatus *prstatus;	/* NT_PRSTATUS */
 	struct elf_prpsinfo *psinfo;	/* NT_PRPSINFO */
 	struct list_head thread_list;
@@ -1896,9 +1898,12 @@ static int fill_note_info(struct elfhdr
 
 	fill_siginfo_note(info->notes + 2, &info->csigdata, siginfo);
 	fill_auxv_note(info->notes + 3, current->mm);
-	fill_files_note(info->notes + 4);
+	info->numnote = 4;
 
-	info->numnote = 5;
+	if (fill_files_note(info->notes + info->numnote) == 0) {
+		info->notes_files = info->notes + info->numnote;
+		info->numnote++;
+	}
 
 	/* Try to dump the FPU. */
 	info->prstatus->pr_fpvalid = elf_core_copy_task_fpregs(current, regs,
@@ -1960,8 +1965,9 @@ static void free_note_info(struct elf_no
 		kfree(list_entry(tmp, struct elf_thread_status, list));
 	}
 
-	/* Free data allocated by fill_files_note(): */
-	vfree(info->notes[4].data);
+	/* Free data possibly allocated by fill_files_note(): */
+	if (info->notes_files)
+		vfree(info->notes_files->data);
 
 	kfree(info->prstatus);
 	kfree(info->psinfo);
@@ -2044,7 +2050,7 @@ static int elf_core_dump(struct coredump
 	struct vm_area_struct *vma, *gate_vma;
 	struct elfhdr *elf = NULL;
 	loff_t offset = 0, dataoff, foffset;
-	struct elf_note_info info;
+	struct elf_note_info info = { };
 	struct elf_phdr *phdr4note = NULL;
 	struct elf_shdr *shdr4extnum = NULL;
 	Elf_Half e_phnum;
_

Patches currently in -mm which might be from alonid@stratoscale.com are


