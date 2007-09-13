From: akpm@linux-foundation.org
Subject: + use-vm_read-write-exec-to-set-vm_page_prot.patch added to -mm tree
Date: Thu, 13 Sep 2007 00:56:03 -0700
Message-ID: <200709130756.l8D7u3P8008700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34706 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbXIMH4o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 03:56:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: coyli@suse.de, hugh@veritas.com, tony.luck@intel.com


The patch titled
     use VM_READ/WRITE/EXEC to set vm_page_prot
has been added to the -mm tree.  Its filename is
     use-vm_read-write-exec-to-set-vm_page_prot.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use VM_READ/WRITE/EXEC to set vm_page_prot
From: Coly Li <coyli@suse.de>

When setup vm_page_prot, some code use 0x7 instead of (VM_READ|VM_WRITE|=
VM_EXEC).  It does works well, but it will be better if we use the
VM_READ/WRITE/EXEC MACRO :-)

This patch uses (VM_READ|VM_WRITE|VM_EXEC) to replace 0x7 in vm_page_prot=
setup.

Signed-off-by: Coly Li <coyli@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c |    3 ++-
 fs/exec.c           |    3 ++-
 mm/mmap.c           |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff -puN arch/ia64/mm/init.c~use-vm_read-write-exec-to-set-vm_page_prot arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~use-vm_read-write-exec-to-set-vm_page_prot
+++ a/arch/ia64/mm/init.c
@@ -130,7 +130,8 @@ ia64_init_addr_space (void)
 		vma->vm_mm = current->mm;
 		vma->vm_start = current->thread.rbs_bot & PAGE_MASK;
 		vma->vm_end = vma->vm_start + PAGE_SIZE;
-		vma->vm_page_prot = protection_map[VM_DATA_DEFAULT_FLAGS & 0x7];
+		vma->vm_page_prot = protection_map[VM_DATA_DEFAULT_FLAGS &
+					(VM_READ|VM_WRITE|VM_EXEC)];
 		vma->vm_flags = VM_DATA_DEFAULT_FLAGS|VM_GROWSUP|VM_ACCOUNT;
 		down_write(&current->mm->mmap_sem);
 		if (insert_vm_struct(current->mm, vma)) {
diff -puN fs/exec.c~use-vm_read-write-exec-to-set-vm_page_prot fs/exec.c
--- a/fs/exec.c~use-vm_read-write-exec-to-set-vm_page_prot
+++ a/fs/exec.c
@@ -261,7 +261,8 @@ static int __bprm_mm_init(struct linux_b
 	vma->vm_start = vma->vm_end - PAGE_SIZE;
 
 	vma->vm_flags = VM_STACK_FLAGS;
-	vma->vm_page_prot = protection_map[vma->vm_flags & 0x7];
+	vma->vm_page_prot = protection_map[vma->vm_flags &
+				(VM_READ|VM_WRITE|VM_EXEC)];
 	err = insert_vm_struct(mm, vma);
 	if (err) {
 		up_write(&mm->mmap_sem);
diff -puN mm/mmap.c~use-vm_read-write-exec-to-set-vm_page_prot mm/mmap.c
--- a/mm/mmap.c~use-vm_read-write-exec-to-set-vm_page_prot
+++ a/mm/mmap.c
@@ -2210,7 +2210,8 @@ int install_special_mapping(struct mm_st
 	vma->vm_end = addr + len;
 
 	vma->vm_flags = vm_flags | mm->def_flags;
-	vma->vm_page_prot = protection_map[vma->vm_flags & 7];
+	vma->vm_page_prot = protection_map[vma->vm_flags &
+				(VM_READ|VM_WRITE|VM_EXEC)];
 
 	vma->vm_ops = &special_mapping_vmops;
 	vma->vm_private_data = pages;
_

Patches currently in -mm which might be from coyli@suse.de are

use-vm_read-write-exec-to-set-vm_page_prot.patch
ext4-remove-obsolete-fragments.patch
