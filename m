From: akpm@linux-foundation.org
Subject: + vmcore-check-nt_vmcore_pad-as-a-mark-indicating-the-end-of-elf-note-buffer.patch added to -mm tree
Date: Tue, 19 Mar 2013 13:03:16 -0700
Message-ID: <20130319200316.D284F5A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:63516 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496Ab3CSUDS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 16:03:18 -0400
Received: by mail-vb0-f73.google.com with SMTP id fj18so85158vbb.2
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 13:03:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com


The patch titled
     Subject: vmcore: check NT_VMCORE_PAD as a mark indicating the end of ELF note buffer
has been added to the -mm tree.  Its filename is
     vmcore-check-nt_vmcore_pad-as-a-mark-indicating-the-end-of-elf-note-buffer.patch

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
Subject: vmcore: check NT_VMCORE_PAD as a mark indicating the end of ELF note buffer

Modern kernel marks the end of ELF note buffer with NT_VMCORE_PAD type
note in order to make the buffer satisfy mmap()'s page-size boundary
requirement.  This patch makes finishing reading each buffer if the note
type now being read is NT_VMCORE_PAD type.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN fs/proc/vmcore.c~vmcore-check-nt_vmcore_pad-as-a-mark-indicating-the-end-of-elf-note-buffer fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-check-nt_vmcore_pad-as-a-mark-indicating-the-end-of-elf-note-buffer
+++ a/fs/proc/vmcore.c
@@ -258,12 +258,24 @@ static int __init merge_note_headers_elf
 		}
 		nhdr_ptr = notes_section;
 		while (real_sz < max_sz) {
+			char *name;
+
+			/* Old kernel marks the end of ELF note buffer
+			 * with empty header. */
 			if (nhdr_ptr->n_namesz == 0)
 				break;
 			sz = sizeof(Elf64_Nhdr) +
 				((nhdr_ptr->n_namesz + 3) & ~3) +
 				((nhdr_ptr->n_descsz + 3) & ~3);
 			real_sz += sz;
+
+			/* Modern kernel marks the end of ELF note
+			 * buffer with NT_VMCORE_PAD type note. */
+			name = (char *)(nhdr_ptr + 1);
+			if (strncmp(name, VMCOREINFO_NOTE_NAME,
+				    sizeof(VMCOREINFO_NOTE_NAME)) == 0
+			    && nhdr_ptr->n_type == NT_VMCORE_PAD)
+				break;
 			nhdr_ptr = (Elf64_Nhdr*)((char*)nhdr_ptr + sz);
 		}
 
@@ -367,12 +379,24 @@ static int __init merge_note_headers_elf
 		}
 		nhdr_ptr = notes_section;
 		while (real_sz < max_sz) {
+			char *name;
+
+			/* Old kernel marks the end of ELF note buffer
+			 * with empty header. */
 			if (nhdr_ptr->n_namesz == 0)
 				break;
 			sz = sizeof(Elf32_Nhdr) +
 				((nhdr_ptr->n_namesz + 3) & ~3) +
 				((nhdr_ptr->n_descsz + 3) & ~3);
 			real_sz += sz;
+
+			/* Modern kernel marks the end of ELF note
+			 * buffer with NT_VMCORE_PAD type note. */
+			name = (char *)(nhdr_ptr + 1);
+			if (strncmp(name, VMCOREINFO_NOTE_NAME,
+				    sizeof(VMCOREINFO_NOTE_NAME)) == 0
+			    && nhdr_ptr->n_type == NT_VMCORE_PAD)
+				break;
 			nhdr_ptr = (Elf32_Nhdr*)((char*)nhdr_ptr + sz);
 		}
 
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

