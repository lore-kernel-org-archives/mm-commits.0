From: akpm@linux-foundation.org
Subject: + vmcore-rearrange-program-headers-without-assuming-consequtive-pt_note-entries.patch added to -mm tree
Date: Tue, 19 Mar 2013 13:02:48 -0700
Message-ID: <20130319200248.D72485A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:32975 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab3CSUCu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 16:02:50 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so85188qcs.5
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 13:02:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com


The patch titled
     Subject: vmcore: rearrange program headers without assuming consecutive PT_NOTE entries
has been added to the -mm tree.  Its filename is
     vmcore-rearrange-program-headers-without-assuming-consequtive-pt_note-entries.patch

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
Subject: vmcore: rearrange program headers without assuming consecutive PT_NOTE entries

Current code assumes all PT_NOTE headers are placed at the beginning of
program header table and they are consecutive.  But the assumption could
be broken by future changes on either kexec-tools or the 1st kernel.  This
patch removes the assumption and rearranges program headers as the
following conditions are satisfied:

- PT_NOTE entry is unique at the first entry,

- the order of program headers are unchanged during this
  rearrangement, only their positions are changed in positive
  direction.

- unused part that occurs in the bottom of program headers are filled
  with 0.

Also, this patch adds one exceptional case where the number of PT_NOTE
entries is somehow 0.  Then, immediately go out of the function.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   92 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 74 insertions(+), 18 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-rearrange-program-headers-without-assuming-consequtive-pt_note-entries fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-rearrange-program-headers-without-assuming-consequtive-pt_note-entries
+++ a/fs/proc/vmcore.c
@@ -251,8 +251,7 @@ static u64 __init get_vmcore_size_elf32(
 static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 						struct list_head *vc_list)
 {
-	int i, nr_ptnote=0, rc=0;
-	char *tmp;
+	int i, j, nr_ptnote=0, i_ptnote, rc=0;
 	Elf64_Ehdr *ehdr_ptr;
 	Elf64_Phdr phdr, *phdr_ptr;
 	Elf64_Nhdr *nhdr_ptr;
@@ -301,6 +300,39 @@ static int __init merge_note_headers_elf
 		kfree(notes_section);
 	}
 
+	if (nr_ptnote == 0)
+		goto out;
+
+	phdr_ptr = (Elf64_Phdr *)(elfptr + ehdr_ptr->e_phoff);
+
+	/* Remove unwanted PT_NOTE program headers. */
+
+        /* - 1st pass shifts non-PT_NOTE entries until the first
+	     PT_NOTE entry. */
+	i_ptnote = -1;
+	for (i = 0; i < ehdr_ptr->e_phnum; ++i) {
+		if (phdr_ptr[i].p_type == PT_NOTE) {
+			i_ptnote = i;
+			break;
+		}
+	}
+	BUG_ON(i_ptnote == -1); /* impossible case since nr_ptnote > 0. */
+	memmove(phdr_ptr + 1, phdr_ptr,	i_ptnote * sizeof(Elf64_Phdr));
+
+	/* - 2nd pass moves the remaining non-PT_NOTE entries under
+	     the first PT_NOTE entry. */
+	for (i = j = i_ptnote + 1; i < ehdr_ptr->e_phnum; i++) {
+		if (phdr_ptr[i].p_type != PT_NOTE) {
+			memmove(phdr_ptr + j, phdr_ptr + i,
+				sizeof(Elf64_Phdr));
+			j++;
+		}
+	}
+
+	/* - Finally, fill unused part with 0. */
+	memset(phdr_ptr + ehdr_ptr->e_phnum - (nr_ptnote - 1), 0,
+	       (nr_ptnote - 1) * sizeof(Elf64_Phdr));
+
 	/* Prepare merged PT_NOTE program header. */
 	phdr.p_type    = PT_NOTE;
 	phdr.p_flags   = 0;
@@ -312,18 +344,14 @@ static int __init merge_note_headers_elf
 	phdr.p_align   = 0;
 
 	/* Add merged PT_NOTE program header*/
-	tmp = elfptr + ehdr_ptr->e_phoff;
-	memcpy(tmp, &phdr, sizeof(phdr));
-	tmp += sizeof(phdr);
+	memcpy(phdr_ptr, &phdr, sizeof(Elf64_Phdr));
 
-	/* Remove unwanted PT_NOTE program headers. */
-	i = (nr_ptnote - 1) * sizeof(Elf64_Phdr);
-	*elfsz = *elfsz - i;
-	memmove(tmp, tmp+i, ((*elfsz)-ehdr_ptr->e_phoff-sizeof(Elf64_Phdr)));
+	*elfsz = *elfsz - (nr_ptnote - 1) * sizeof(Elf64_Phdr);
 
 	/* Modify e_phnum to reflect merged headers. */
 	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
 
+out:
 	return 0;
 }
 
@@ -331,8 +359,7 @@ static int __init merge_note_headers_elf
 static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
 						struct list_head *vc_list)
 {
-	int i, nr_ptnote=0, rc=0;
-	char *tmp;
+	int i, j, nr_ptnote=0, i_ptnote, rc=0;
 	Elf32_Ehdr *ehdr_ptr;
 	Elf32_Phdr phdr, *phdr_ptr;
 	Elf32_Nhdr *nhdr_ptr;
@@ -381,6 +408,39 @@ static int __init merge_note_headers_elf
 		kfree(notes_section);
 	}
 
+	if (nr_ptnote == 0)
+		goto out;
+
+	phdr_ptr = (Elf32_Phdr *)(elfptr + ehdr_ptr->e_phoff);
+
+	/* Remove unwanted PT_NOTE program headers. */
+
+	/* - 1st pass shifts non-PT_NOTE entries until the first
+	     PT_NOTE entry. */
+	i_ptnote = -1;
+	for (i = 0; i < ehdr_ptr->e_phnum; ++i) {
+		if (phdr_ptr[i].p_type == PT_NOTE) {
+			i_ptnote = i;
+			break;
+		}
+	}
+	BUG_ON(i_ptnote == -1); /* impossible case since nr_ptnote > 0. */
+	memmove(phdr_ptr + 1, phdr_ptr, i_ptnote * sizeof(Elf32_Phdr));
+
+	/* - 2nd pass moves the remaining non-PT_NOTE entries under
+	     the first PT_NOTE entry. */
+	for (i = j = i_ptnote + 1; i < ehdr_ptr->e_phnum; i++) {
+		if (phdr_ptr[i].p_type != PT_NOTE) {
+			memmove(phdr_ptr + j, phdr_ptr + i,
+				sizeof(Elf32_Phdr));
+			j++;
+		}
+	}
+
+	/* - Finally, fill unused part with 0. */
+	memset(phdr_ptr + ehdr_ptr->e_phnum - (nr_ptnote - 1), 0,
+	       (nr_ptnote - 1) * sizeof(Elf32_Phdr));
+
 	/* Prepare merged PT_NOTE program header. */
 	phdr.p_type    = PT_NOTE;
 	phdr.p_flags   = 0;
@@ -392,18 +452,14 @@ static int __init merge_note_headers_elf
 	phdr.p_align   = 0;
 
 	/* Add merged PT_NOTE program header*/
-	tmp = elfptr + ehdr_ptr->e_phoff;
-	memcpy(tmp, &phdr, sizeof(phdr));
-	tmp += sizeof(phdr);
+	memcpy(phdr_ptr, &phdr, sizeof(Elf32_Phdr));
 
-	/* Remove unwanted PT_NOTE program headers. */
-	i = (nr_ptnote - 1) * sizeof(Elf32_Phdr);
-	*elfsz = *elfsz - i;
-	memmove(tmp, tmp+i, ((*elfsz)-ehdr_ptr->e_phoff-sizeof(Elf32_Phdr)));
+	*elfsz = *elfsz - (nr_ptnote - 1) * sizeof(Elf32_Phdr);
 
 	/* Modify e_phnum to reflect merged headers. */
 	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
 
+out:
 	return 0;
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

