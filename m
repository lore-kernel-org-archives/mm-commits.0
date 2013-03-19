From: akpm@linux-foundation.org
Subject: + vmcore-check-if-vmcore-objects-satify-mmaps-page-size-boundary-requirement.patch added to -mm tree
Date: Tue, 19 Mar 2013 13:03:18 -0700
Message-ID: <20130319200318.9A9F55A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:42575 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496Ab3CSUDT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 16:03:19 -0400
Received: by mail-vb0-f74.google.com with SMTP id r6so85169vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 13:03:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com


The patch titled
     Subject: vmcore: check if vmcore objects satify mmap()'s page-size boundary requirement
has been added to the -mm tree.  Its filename is
     vmcore-check-if-vmcore-objects-satify-mmaps-page-size-boundary-requirement.patch

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
Subject: vmcore: check if vmcore objects satify mmap()'s page-size boundary requirement

If there's some vmcore object that doesn't satisfy page-size boundary
requirement, remap_pfn_range() fails to remap it to user-space.

Objects that possibly don't satisfy the requirement are ELF note segments
only.  The memory chunks corresponding to PT_LOAD entries are guaranteed
to satisfy page-size boundary requirement by the copy from old memory to
buffer in 2nd kernel done in later patch.

This patch doesn't copy each note segment into the 2nd kernel since they
amount to so large in total if there are multiple CPUs.  For example,
current maximum number of CPUs in x86_64 is 5120, where note segments
exceed 1MB with NT_PRSTATUS only.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN fs/proc/vmcore.c~vmcore-check-if-vmcore-objects-satify-mmaps-page-size-boundary-requirement fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-check-if-vmcore-objects-satify-mmaps-page-size-boundary-requirement
+++ a/fs/proc/vmcore.c
@@ -38,6 +38,8 @@ static u64 vmcore_size;
 
 static struct proc_dir_entry *proc_vmcore = NULL;
 
+static bool support_mmap_vmcore;
+
 /*
  * Returns > 0 for RAM pages, 0 for non-RAM pages, < 0 on error
  * The called function has to take care of module refcounting.
@@ -911,6 +913,7 @@ static int __init parse_crash_elf_header
 static int __init vmcore_init(void)
 {
 	int rc = 0;
+	struct vmcore *m;
 
 	/* If elfcorehdr= has been passed in cmdline, then capture the dump.*/
 	if (!(is_vmcore_usable()))
@@ -921,6 +924,25 @@ static int __init vmcore_init(void)
 		return rc;
 	}
 
+	/* If some object doesn't satisfy PAGE_SIZE boundary
+	 * requirement, mmap_vmcore() is not exported to
+	 * user-space. */
+	support_mmap_vmcore = true;
+	list_for_each_entry(m, &vmcore_list, list) {
+		u64 paddr;
+
+		if (m->flag & MEM_TYPE_CURRENT_KERNEL)
+			paddr = (u64)__pa(m->buf);
+		else
+			paddr = m->paddr;
+
+		if ((m->offset & ~PAGE_MASK) || (paddr & ~PAGE_MASK)
+		    || (m->size & ~PAGE_MASK)) {
+			support_mmap_vmcore = false;
+			break;
+		}
+	}
+
 	proc_vmcore = proc_create("vmcore", S_IRUSR, NULL, &proc_vmcore_operations);
 	if (proc_vmcore)
 		proc_vmcore->size = vmcore_size;
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

