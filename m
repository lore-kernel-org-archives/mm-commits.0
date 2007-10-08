From: akpm@linux-foundation.org
Subject: + fix-vm_can_nonlinear-check-in-sys_remap_file_pages.patch added to -mm tree
Date: Mon, 08 Oct 2007 10:05:40 -0700
Message-ID: <200710081705.l98H5eoj009691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58542 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643AbXJHRGQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2007 13:06:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yanzheng@21cn.com


The patch titled
     fix VM_CAN_NONLINEAR check in sys_remap_file_pages
has been added to the -mm tree.  Its filename is
     fix-vm_can_nonlinear-check-in-sys_remap_file_pages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix VM_CAN_NONLINEAR check in sys_remap_file_pages
From: "Yan Zheng" <yanzheng@21cn.com>

The test for VM_CAN_NONLINEAR always fails

Signed-off-by: Yan Zheng<yanzheng@21cn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/fremap.c~fix-vm_can_nonlinear-check-in-sys_remap_file_pages mm/fremap.c
--- a/mm/fremap.c~fix-vm_can_nonlinear-check-in-sys_remap_file_pages
+++ a/mm/fremap.c
@@ -160,7 +160,7 @@ asmlinkage long sys_remap_file_pages(uns
 	if (vma->vm_private_data && !(vma->vm_flags & VM_NONLINEAR))
 		goto out;
 
-	if (!vma->vm_flags & VM_CAN_NONLINEAR)
+	if (!(vma->vm_flags & VM_CAN_NONLINEAR))
 		goto out;
 
 	if (end <= start || start < vma->vm_start || end > vma->vm_end)
_

Patches currently in -mm which might be from yanzheng@21cn.com are

fix-vm_can_nonlinear-check-in-sys_remap_file_pages.patch
anon-inodes-use-open-coded-atomic_inc-for-the-shared-inode.patch
