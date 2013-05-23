From: akpm@linux-foundation.org
Subject: +
 vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch added to
 -mm tree
Date: Thu, 23 May 2013 15:25:11 -0700
Message-ID: <519e9747.itpeUi42jKCWYhES%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759752Ab3EWWZg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 May 2013 18:25:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, vgoyal@redhat.com, lisa.mitchell@hp.com, kumagai-atsushi@mxc.nes.nec.co.jp, kosaki.motohiro@jp.fujitsu.com, d.hatayama@jp.fujitsu.com

Subject: + vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch added to -mm tree
To: d.hatayama@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,kumagai-atsushi@mxc.nes.nec.co.jp,lisa.mitchell@hp.com,vgoyal@redhat.com,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Thu, 23 May 2013 15:25:11 -0700


The patch titled
     Subject: vmcore: allow user process to remap ELF note segment buffer
has been added to the -mm tree.  Its filename is
     vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch

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
Subject: vmcore: allow user process to remap ELF note segment buffer

Now ELF note segment has been copied in the buffer on vmalloc memory.  To
allow user process to remap the ELF note segment buffer with
remap_vmalloc_page, the corresponding VM area object has to have
VM_USERMAP flag set.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: Lisa Mitchell <lisa.mitchell@hp.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN fs/proc/vmcore.c~vmcore-allow-user-process-to-remap-elf-note-segment-buffer fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-allow-user-process-to-remap-elf-note-segment-buffer
+++ a/fs/proc/vmcore.c
@@ -369,6 +369,7 @@ static int __init merge_note_headers_elf
 	Elf64_Ehdr *ehdr_ptr;
 	Elf64_Phdr phdr;
 	u64 phdr_sz = 0, note_off;
+	struct vm_struct *vm;
 
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
 
@@ -385,6 +386,12 @@ static int __init merge_note_headers_elf
 	if (!*notes_buf)
 		return -ENOMEM;
 
+	/* Allow users to remap ELF note segment buffer on vmalloc
+	 * memory using remap_vmalloc_range. */
+	vm = find_vm_area(*notes_buf);
+	BUG_ON(!vm);
+	vm->flags |= VM_USERMAP;
+
 	rc = copy_notes_elf64(ehdr_ptr, *notes_buf);
 	if (rc < 0)
 		return rc;
@@ -548,6 +555,7 @@ static int __init merge_note_headers_elf
 	Elf32_Ehdr *ehdr_ptr;
 	Elf32_Phdr phdr;
 	u64 phdr_sz = 0, note_off;
+	struct vm_struct *vm;
 
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
 
@@ -564,6 +572,12 @@ static int __init merge_note_headers_elf
 	if (!*notes_buf)
 		return -ENOMEM;
 
+	/* Allow users to remap ELF note segment buffer on vmalloc
+	 * memory using remap_vmalloc_range. */
+	vm = find_vm_area(*notes_buf);
+	BUG_ON(!vm);
+	vm->flags |= VM_USERMAP;
+
 	rc = copy_notes_elf32(ehdr_ptr, *notes_buf);
 	if (rc < 0)
 		return rc;
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

include-linux-mmh-add-page_aligned-helper.patch
vmcore-clean-up-read_vmcore.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmcore-treat-memory-chunks-referenced-by-pt_load-program-header-entries-in-page-size-boundary-in-vmcore_list.patch
vmalloc-make-find_vm_area-check-in-range.patch
vmalloc-introduce-remap_vmalloc_range_partial.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-calculate-vmcore-file-size-from-buffer-size-and-total-size-of-vmcore-objects.patch
vmcore-support-mmap-on-proc-vmcore.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch

