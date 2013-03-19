From: akpm@linux-foundation.org
Subject: + vmcore-round-up-buffer-size-of-elf-headers-by-page_size.patch added to -mm tree
Date: Tue, 19 Mar 2013 13:02:54 -0700
Message-ID: <20130319200254.D193B5A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:58441 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183Ab3CSUC5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 16:02:57 -0400
Received: by mail-gh0-f201.google.com with SMTP id z19so84916ghb.2
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 13:02:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com


The patch titled
     Subject: vmcore: round up buffer size of ELF headers by PAGE_SIZE
has been added to the -mm tree.  Its filename is
     vmcore-round-up-buffer-size-of-elf-headers-by-page_size.patch

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
Subject: vmcore: round up buffer size of ELF headers by PAGE_SIZE

To satisfy mmap() page-size boundary requirement, round up buffer size of
ELF headers by PAGE_SIZE.  The resulting value becomes offset of ELF note
segments and it's assigned in unique PT_NOTE program header entry.

Also, some part that assumes past ELF headers' size is replaced by this
new rounded-up value.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-round-up-buffer-size-of-elf-headers-by-page_size fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-round-up-buffer-size-of-elf-headers-by-page_size
+++ a/fs/proc/vmcore.c
@@ -339,7 +339,7 @@ static int __init merge_note_headers_elf
 	phdr.p_flags   = 0;
 	note_off = ehdr_ptr->e_phoff +
 			(ehdr_ptr->e_phnum - nr_ptnote +1) * sizeof(Elf64_Phdr);
-	phdr.p_offset  = note_off;
+	phdr.p_offset  = roundup(note_off, PAGE_SIZE);
 	phdr.p_vaddr   = phdr.p_paddr = 0;
 	phdr.p_filesz  = phdr.p_memsz = phdr_sz;
 	phdr.p_align   = 0;
@@ -352,6 +352,7 @@ static int __init merge_note_headers_elf
 	/* Modify e_phnum to reflect merged headers. */
 	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
 
+	*elfsz = roundup(*elfsz, PAGE_SIZE);
 out:
 	return 0;
 }
@@ -447,7 +448,7 @@ static int __init merge_note_headers_elf
 	phdr.p_flags   = 0;
 	note_off = ehdr_ptr->e_phoff +
 			(ehdr_ptr->e_phnum - nr_ptnote +1) * sizeof(Elf32_Phdr);
-	phdr.p_offset  = note_off;
+	phdr.p_offset  = roundup(note_off, PAGE_SIZE);
 	phdr.p_vaddr   = phdr.p_paddr = 0;
 	phdr.p_filesz  = phdr.p_memsz = phdr_sz;
 	phdr.p_align   = 0;
@@ -460,6 +461,7 @@ static int __init merge_note_headers_elf
 	/* Modify e_phnum to reflect merged headers. */
 	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
 
+	*elfsz = roundup(*elfsz, PAGE_SIZE);
 out:
 	return 0;
 }
@@ -480,9 +482,8 @@ static int __init process_ptload_program
 	phdr_ptr = (Elf64_Phdr*)(elfptr + ehdr_ptr->e_phoff); /* PT_NOTE hdr */
 
 	/* First program header is PT_NOTE header. */
-	vmcore_off = ehdr_ptr->e_phoff +
-			(ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr) +
-			phdr_ptr->p_memsz; /* Note sections */
+	vmcore_off = phdr_ptr->p_offset + roundup(phdr_ptr->p_memsz,
+						  PAGE_SIZE);
 
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
 		if (phdr_ptr->p_type != PT_LOAD)
@@ -517,9 +518,8 @@ static int __init process_ptload_program
 	phdr_ptr = (Elf32_Phdr*)(elfptr + ehdr_ptr->e_phoff); /* PT_NOTE hdr */
 
 	/* First program header is PT_NOTE header. */
-	vmcore_off = ehdr_ptr->e_phoff +
-			(ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr) +
-			phdr_ptr->p_memsz; /* Note sections */
+	vmcore_off = phdr_ptr->p_offset + roundup(phdr_ptr->p_memsz,
+						 PAGE_SIZE);
 
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
 		if (phdr_ptr->p_type != PT_LOAD)
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

