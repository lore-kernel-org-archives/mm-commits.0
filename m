From: akpm@linux-foundation.org
Subject: + vmcore-reference-e_phoff-member-explicitly-to-get-position-of-program-header-table.patch added to -mm tree
Date: Tue, 19 Mar 2013 13:02:44 -0700
Message-ID: <20130319200244.DDEC831C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:41609 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3CSUCr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 16:02:47 -0400
Received: by mail-ye0-f201.google.com with SMTP id m12so85071yen.2
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 13:02:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com


The patch titled
     Subject: vmcore: reference e_phoff member explicitly to get position of program header table
has been added to the -mm tree.  Its filename is
     vmcore-reference-e_phoff-member-explicitly-to-get-position-of-program-header-table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: vmcore: reference e_phoff member explicitly to get position of program header table

Currently, read to /proc/vmcore is done by read_oldmem() that uses
ioremap/iounmap per a single page.  For example, if memory is 1GB,
ioremap/iounmap is called (1GB / 4KB)-times, that is, 262144 times.  This
causes big performance degradation.

In particular, the current main user of this mmap() is makedumpfile, which
not only reads memory from /proc/vmcore but also does other processing
like filtering, compression and IO work.  Update of page table and the
following TLB flush makes such processing much slow; though I have yet to
make patch for makedumpfile and yet to confirm how it's improved.

To address the issue, this patch implements mmap() on /proc/vmcore to
improve read performance.  My simple benchmark shows the improvement from
200 [MiB/sec] to over 50.0 [GiB/sec].



This patch:

Currently, the code assumes that position of program header table is next
to ELF header.  But future change can break the assumption on kexec-tools
and the 1st kernel.  To avoid worst case, reference e_phoff member
explicitly to get position of program header table in file-offset.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   56 ++++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 20 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-reference-e_phoff-member-explicitly-to-get-position-of-program-header-table fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-reference-e_phoff-member-explicitly-to-get-position-of-program-header-table
+++ a/fs/proc/vmcore.c
@@ -221,8 +221,8 @@ static u64 __init get_vmcore_size_elf64(
 	Elf64_Phdr *phdr_ptr;
 
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
-	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr));
-	size = sizeof(Elf64_Ehdr) + ((ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr));
+	phdr_ptr = (Elf64_Phdr*)(elfptr + ehdr_ptr->e_phoff);
+	size = ehdr_ptr->e_phoff + ((ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr));
 	for (i = 0; i < ehdr_ptr->e_phnum; i++) {
 		size += phdr_ptr->p_memsz;
 		phdr_ptr++;
@@ -238,8 +238,8 @@ static u64 __init get_vmcore_size_elf32(
 	Elf32_Phdr *phdr_ptr;
 
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
-	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr));
-	size = sizeof(Elf32_Ehdr) + ((ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr));
+	phdr_ptr = (Elf32_Phdr*)(elfptr + ehdr_ptr->e_phoff);
+	size = ehdr_ptr->e_phoff + ((ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr));
 	for (i = 0; i < ehdr_ptr->e_phnum; i++) {
 		size += phdr_ptr->p_memsz;
 		phdr_ptr++;
@@ -259,7 +259,7 @@ static int __init merge_note_headers_elf
 	u64 phdr_sz = 0, note_off;
 
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
-	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr));
+	phdr_ptr = (Elf64_Phdr*)(elfptr + ehdr_ptr->e_phoff);
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
 		int j;
 		void *notes_section;
@@ -305,7 +305,7 @@ static int __init merge_note_headers_elf
 	/* Prepare merged PT_NOTE program header. */
 	phdr.p_type    = PT_NOTE;
 	phdr.p_flags   = 0;
-	note_off = sizeof(Elf64_Ehdr) +
+	note_off = ehdr_ptr->e_phoff +
 			(ehdr_ptr->e_phnum - nr_ptnote +1) * sizeof(Elf64_Phdr);
 	phdr.p_offset  = note_off;
 	phdr.p_vaddr   = phdr.p_paddr = 0;
@@ -313,14 +313,14 @@ static int __init merge_note_headers_elf
 	phdr.p_align   = 0;
 
 	/* Add merged PT_NOTE program header*/
-	tmp = elfptr + sizeof(Elf64_Ehdr);
+	tmp = elfptr + ehdr_ptr->e_phoff;
 	memcpy(tmp, &phdr, sizeof(phdr));
 	tmp += sizeof(phdr);
 
 	/* Remove unwanted PT_NOTE program headers. */
 	i = (nr_ptnote - 1) * sizeof(Elf64_Phdr);
 	*elfsz = *elfsz - i;
-	memmove(tmp, tmp+i, ((*elfsz)-sizeof(Elf64_Ehdr)-sizeof(Elf64_Phdr)));
+	memmove(tmp, tmp+i, ((*elfsz)-ehdr_ptr->e_phoff-sizeof(Elf64_Phdr)));
 
 	/* Modify e_phnum to reflect merged headers. */
 	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
@@ -340,7 +340,7 @@ static int __init merge_note_headers_elf
 	u64 phdr_sz = 0, note_off;
 
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
-	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr));
+	phdr_ptr = (Elf32_Phdr*)(elfptr + ehdr_ptr->e_phoff);
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
 		int j;
 		void *notes_section;
@@ -386,7 +386,7 @@ static int __init merge_note_headers_elf
 	/* Prepare merged PT_NOTE program header. */
 	phdr.p_type    = PT_NOTE;
 	phdr.p_flags   = 0;
-	note_off = sizeof(Elf32_Ehdr) +
+	note_off = ehdr_ptr->e_phoff +
 			(ehdr_ptr->e_phnum - nr_ptnote +1) * sizeof(Elf32_Phdr);
 	phdr.p_offset  = note_off;
 	phdr.p_vaddr   = phdr.p_paddr = 0;
@@ -394,14 +394,14 @@ static int __init merge_note_headers_elf
 	phdr.p_align   = 0;
 
 	/* Add merged PT_NOTE program header*/
-	tmp = elfptr + sizeof(Elf32_Ehdr);
+	tmp = elfptr + ehdr_ptr->e_phoff;
 	memcpy(tmp, &phdr, sizeof(phdr));
 	tmp += sizeof(phdr);
 
 	/* Remove unwanted PT_NOTE program headers. */
 	i = (nr_ptnote - 1) * sizeof(Elf32_Phdr);
 	*elfsz = *elfsz - i;
-	memmove(tmp, tmp+i, ((*elfsz)-sizeof(Elf32_Ehdr)-sizeof(Elf32_Phdr)));
+	memmove(tmp, tmp+i, ((*elfsz)-ehdr_ptr->e_phoff-sizeof(Elf32_Phdr)));
 
 	/* Modify e_phnum to reflect merged headers. */
 	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
@@ -422,10 +422,10 @@ static int __init process_ptload_program
 	struct vmcore *new;
 
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
-	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr)); /* PT_NOTE hdr */
+	phdr_ptr = (Elf64_Phdr*)(elfptr + ehdr_ptr->e_phoff); /* PT_NOTE hdr */
 
 	/* First program header is PT_NOTE header. */
-	vmcore_off = sizeof(Elf64_Ehdr) +
+	vmcore_off = ehdr_ptr->e_phoff +
 			(ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr) +
 			phdr_ptr->p_memsz; /* Note sections */
 
@@ -459,10 +459,10 @@ static int __init process_ptload_program
 	struct vmcore *new;
 
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
-	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr)); /* PT_NOTE hdr */
+	phdr_ptr = (Elf32_Phdr*)(elfptr + ehdr_ptr->e_phoff); /* PT_NOTE hdr */
 
 	/* First program header is PT_NOTE header. */
-	vmcore_off = sizeof(Elf32_Ehdr) +
+	vmcore_off = ehdr_ptr->e_phoff +
 			(ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr) +
 			phdr_ptr->p_memsz; /* Note sections */
 
@@ -496,7 +496,7 @@ static void __init set_vmcore_list_offse
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
 
 	/* Skip Elf header and program headers. */
-	vmcore_off = sizeof(Elf64_Ehdr) +
+	vmcore_off = ehdr_ptr->e_phoff +
 			(ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr);
 
 	list_for_each_entry(m, vc_list, list) {
@@ -516,7 +516,7 @@ static void __init set_vmcore_list_offse
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
 
 	/* Skip Elf header and program headers. */
-	vmcore_off = sizeof(Elf32_Ehdr) +
+	vmcore_off = ehdr_ptr->e_phoff +
 			(ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr);
 
 	list_for_each_entry(m, vc_list, list) {
@@ -558,11 +558,19 @@ static int __init parse_crash_elf64_head
 	if (!elfcorebuf)
 		return -ENOMEM;
 	addr = elfcorehdr_addr;
-	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz, &addr, 0);
+	rc = read_from_oldmem(elfcorebuf, sizeof(Elf64_Ehdr), &addr, 0);
 	if (rc < 0) {
 		kfree(elfcorebuf);
 		return rc;
 	}
+	addr = elfcorehdr_addr + ehdr.e_phoff;
+	rc = read_from_oldmem(elfcorebuf + sizeof(Elf64_Ehdr),
+			      ehdr.e_phnum * sizeof(Elf64_Phdr), &addr, 0);
+	if (rc < 0) {
+		kfree(elfcorebuf);
+		return rc;
+	}
+	((Elf64_Ehdr *)elfcorebuf)->e_phoff = sizeof(Elf64_Ehdr);
 
 	/* Merge all PT_NOTE headers into one. */
 	rc = merge_note_headers_elf64(elfcorebuf, &elfcorebuf_sz, &vmcore_list);
@@ -613,11 +621,19 @@ static int __init parse_crash_elf32_head
 	if (!elfcorebuf)
 		return -ENOMEM;
 	addr = elfcorehdr_addr;
-	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz, &addr, 0);
+	rc = read_from_oldmem(elfcorebuf, sizeof(Elf32_Ehdr), &addr, 0);
+	if (rc < 0) {
+		kfree(elfcorebuf);
+		return rc;
+	}
+	addr = elfcorehdr_addr + ehdr.e_phoff;
+	rc = read_from_oldmem(elfcorebuf + sizeof(Elf32_Ehdr),
+			      ehdr.e_phnum * sizeof(Elf32_Phdr), &addr, 0);
 	if (rc < 0) {
 		kfree(elfcorebuf);
 		return rc;
 	}
+	((Elf32_Ehdr *)elfcorebuf)->e_phoff = sizeof(Elf32_Ehdr);
 
 	/* Merge all PT_NOTE headers into one. */
 	rc = merge_note_headers_elf32(elfcorebuf, &elfcorebuf_sz, &vmcore_list);
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

vmcore-reference-e_phoff-member-explicitly-to-get-position-of-program-header-table.patch
vmcore-clean-up-by-removing-unnecessary-variable.patch
vmcore-rearrange-program-headers-without-assuming-consequtive-pt_note-entries.patch
vmcore-sysfs-export-elf-note-segment-size-instead-of-vmcoreinfo-data-size.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch
vmcore-round-up-buffer-size-of-elf-headers-by-page_size.patch
vmcore-procfs-introduce-a-flag-to-distinguish-objects-copied-in-2nd-kernel.patch
vmcore-copy-non-page-size-aligned-head-and-tail-pages-in-2nd-kernel.patch
vmcore-modify-vmcore-clean-up-function-to-free-buffer-on-2nd-kernel.patch
vmcore-clean-up-read_vmcore.patch
vmcore-read-buffers-for-vmcore-objects-copied-from-old-memory.patch
vmcore-allocate-per-cpu-crash_notes-objects-on-page-size-boundary.patch
kexec-allocate-vmcoreinfo-note-buffer-on-page-size-boundary.patch
kexec-elf-introduce-nt_vmcore_debuginfo-note-type.patch
elf-introduce-nt_vmcore_pad-type.patch
kexec-fill-note-buffers-by-nt_vmcore_pad-notes-in-page-size-boundary.patch
vmcore-check-nt_vmcore_pad-as-a-mark-indicating-the-end-of-elf-note-buffer.patch
vmcore-check-if-vmcore-objects-satify-mmaps-page-size-boundary-requirement.patch
vmcore-round-up-offset-of-vmcore-object-in-page-size-boundary.patch
vmcore-count-holes-generated-by-round-up-operation-for-vmcore-size.patch
vmcore-introduce-mmap_vmcore.patch

