From: akpm@linux-foundation.org
Subject: [merged]
 vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:25:26 -0700
Message-ID: <51db1226.znLkRnT/S0z1HchU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab3GHTZm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, vgoyal@redhat.com, lisa.mitchell@hp.com, kumagai-atsushi@mxc.nes.nec.co.jp, kosaki.motohiro@jp.fujitsu.com, d.hatayama@jp.fujitsu.com

Subject: [merged] vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch removed from -mm tree
To: d.hatayama@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,kumagai-atsushi@mxc.nes.nec.co.jp,lisa.mitchell@hp.com,vgoyal@redhat.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:26 -0700


The patch titled
     Subject: vmcore: allow user process to remap ELF note segment buffer
has been removed from the -mm tree.  Its filename was
     vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: vmcore: allow user process to remap ELF note segment buffer

Now ELF note segment has been copied in the buffer on vmalloc memory.  To
allow user process to remap the ELF note segment buffer with
remap_vmalloc_page, the corresponding VM area object has to have
VM_USERMAP flag set.

[akpm@linux-foundation.org: use the conventional comment layout]
Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: Lisa Mitchell <lisa.mitchell@hp.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN fs/proc/vmcore.c~vmcore-allow-user-process-to-remap-elf-note-segment-buffer fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-allow-user-process-to-remap-elf-note-segment-buffer
+++ a/fs/proc/vmcore.c
@@ -369,6 +369,7 @@ static int __init merge_note_headers_elf
 	Elf64_Ehdr *ehdr_ptr;
 	Elf64_Phdr phdr;
 	u64 phdr_sz = 0, note_off;
+	struct vm_struct *vm;
 
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
 
@@ -385,6 +386,14 @@ static int __init merge_note_headers_elf
 	if (!*notes_buf)
 		return -ENOMEM;
 
+	/*
+	 * Allow users to remap ELF note segment buffer on vmalloc memory using
+	 * remap_vmalloc_range.()
+	 */
+	vm = find_vm_area(*notes_buf);
+	BUG_ON(!vm);
+	vm->flags |= VM_USERMAP;
+
 	rc = copy_notes_elf64(ehdr_ptr, *notes_buf);
 	if (rc < 0)
 		return rc;
@@ -548,6 +557,7 @@ static int __init merge_note_headers_elf
 	Elf32_Ehdr *ehdr_ptr;
 	Elf32_Phdr phdr;
 	u64 phdr_sz = 0, note_off;
+	struct vm_struct *vm;
 
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
 
@@ -564,6 +574,14 @@ static int __init merge_note_headers_elf
 	if (!*notes_buf)
 		return -ENOMEM;
 
+	/*
+	 * Allow users to remap ELF note segment buffer on vmalloc memory using
+	 * remap_vmalloc_range()
+	 */
+	vm = find_vm_area(*notes_buf);
+	BUG_ON(!vm);
+	vm->flags |= VM_USERMAP;
+
 	rc = copy_notes_elf32(ehdr_ptr, *notes_buf);
 	if (rc < 0)
 		return rc;
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

origin.patch

