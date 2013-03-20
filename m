From: akpm@linux-foundation.org
Subject: [nacked] vmcore-check-nt_vmcore_pad-as-a-mark-indicating-the-end-of-elf-note-buffer.patch removed from -mm tree
Date: Wed, 20 Mar 2013 16:33:05 -0700
Message-ID: <20130320233305.816E431C243@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:58671 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3CTXdH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 19:33:07 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so212040qen.0
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 16:33:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmcore: check NT_VMCORE_PAD as a mark indicating the end of ELF note buffer
has been removed from the -mm tree.  Its filename was
     vmcore-check-nt_vmcore_pad-as-a-mark-indicating-the-end-of-elf-note-buffer.patch

This patch was dropped because it was nacked

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

vmcore-check-if-vmcore-objects-satify-mmaps-page-size-boundary-requirement.patch
vmcore-round-up-offset-of-vmcore-object-in-page-size-boundary.patch
vmcore-count-holes-generated-by-round-up-operation-for-vmcore-size.patch
vmcore-introduce-mmap_vmcore.patch

