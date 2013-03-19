From: akpm@linux-foundation.org
Subject: + vmcore-clean-up-by-removing-unnecessary-variable.patch added to -mm tree
Date: Tue, 19 Mar 2013 13:02:46 -0700
Message-ID: <20130319200246.D0B7931C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:56411 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3CSUCs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 16:02:48 -0400
Received: by mail-qa0-f74.google.com with SMTP id o13so93683qaj.5
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 13:02:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com


The patch titled
     Subject: vmcore: clean up by removing unnecessary variable
has been added to the -mm tree.  Its filename is
     vmcore-clean-up-by-removing-unnecessary-variable.patch

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
Subject: vmcore: clean up by removing unnecessary variable

The variable j has int type but it's compared with u64 type.

Also, the purpose of the variable j is exactly what the variable real_sz
is used for now.  Replace the variable j by the variable real_sz and
remove the variable j.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-clean-up-by-removing-unnecessary-variable fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-clean-up-by-removing-unnecessary-variable
+++ a/fs/proc/vmcore.c
@@ -261,7 +261,6 @@ static int __init merge_note_headers_elf
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
 	phdr_ptr = (Elf64_Phdr*)(elfptr + ehdr_ptr->e_phoff);
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
-		int j;
 		void *notes_section;
 		struct vmcore *new;
 		u64 offset, max_sz, sz, real_sz = 0;
@@ -279,7 +278,7 @@ static int __init merge_note_headers_elf
 			return rc;
 		}
 		nhdr_ptr = notes_section;
-		for (j = 0; j < max_sz; j += sz) {
+		while (real_sz < max_sz) {
 			if (nhdr_ptr->n_namesz == 0)
 				break;
 			sz = sizeof(Elf64_Nhdr) +
@@ -342,7 +341,6 @@ static int __init merge_note_headers_elf
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
 	phdr_ptr = (Elf32_Phdr*)(elfptr + ehdr_ptr->e_phoff);
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
-		int j;
 		void *notes_section;
 		struct vmcore *new;
 		u64 offset, max_sz, sz, real_sz = 0;
@@ -360,7 +358,7 @@ static int __init merge_note_headers_elf
 			return rc;
 		}
 		nhdr_ptr = notes_section;
-		for (j = 0; j < max_sz; j += sz) {
+		while (real_sz < max_sz) {
 			if (nhdr_ptr->n_namesz == 0)
 				break;
 			sz = sizeof(Elf32_Nhdr) +
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

