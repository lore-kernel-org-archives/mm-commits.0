From: akpm@linux-foundation.org
Subject: + setup-vma-vm_page_prot-by-vm_get_page_prot.patch added to -mm tree
Date: Wed, 17 Oct 2007 14:48:44 -0700
Message-ID: <200710172148.l9HLmiVZ010006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49602 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753573AbXJQVsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 17:48:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: coyli@suse.de, hugh@veritas.com, tony.luck@intel.com


The patch titled
     setup vma->vm_page_prot by vm_get_page_prot()
has been added to the -mm tree.  Its filename is
     setup-vma-vm_page_prot-by-vm_get_page_prot.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: setup vma->vm_page_prot by vm_get_page_prot()
From: Coly Li <coyli@suse.de>

This patch uses vm_get_page_prot() to setup vma->vm_page_prot.

Though inside vm_get_page_prot() the protection flags is AND with
(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED), it does not hurt correct code.

Signed-off-by: Coly Li <coyli@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c |    2 +-
 fs/exec.c           |    2 +-
 mm/mmap.c           |   11 ++++-------
 mm/mprotect.c       |    6 ++----
 4 files changed, 8 insertions(+), 13 deletions(-)

diff -puN arch/ia64/mm/init.c~setup-vma-vm_page_prot-by-vm_get_page_prot arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~setup-vma-vm_page_prot-by-vm_get_page_prot
+++ a/arch/ia64/mm/init.c
@@ -127,8 +127,8 @@ ia64_init_addr_space (void)
 		vma->vm_mm = current->mm;
 		vma->vm_start = current->thread.rbs_bot & PAGE_MASK;
 		vma->vm_end = vma->vm_start + PAGE_SIZE;
-		vma->vm_page_prot = protection_map[VM_DATA_DEFAULT_FLAGS & 0x7];
 		vma->vm_flags = VM_DATA_DEFAULT_FLAGS|VM_GROWSUP|VM_ACCOUNT;
+		vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 		down_write(&current->mm->mmap_sem);
 		if (insert_vm_struct(current->mm, vma)) {
 			up_write(&current->mm->mmap_sem);
diff -puN fs/exec.c~setup-vma-vm_page_prot-by-vm_get_page_prot fs/exec.c
--- a/fs/exec.c~setup-vma-vm_page_prot-by-vm_get_page_prot
+++ a/fs/exec.c
@@ -234,7 +234,7 @@ static int __bprm_mm_init(struct linux_b
 	vma->vm_start = vma->vm_end - PAGE_SIZE;
 
 	vma->vm_flags = VM_STACK_FLAGS;
-	vma->vm_page_prot = protection_map[vma->vm_flags & 0x7];
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	err = insert_vm_struct(mm, vma);
 	if (err) {
 		up_write(&mm->mmap_sem);
diff -puN mm/mmap.c~setup-vma-vm_page_prot-by-vm_get_page_prot mm/mmap.c
--- a/mm/mmap.c~setup-vma-vm_page_prot-by-vm_get_page_prot
+++ a/mm/mmap.c
@@ -1048,8 +1048,7 @@ int vma_wants_writenotify(struct vm_area
 
 	/* The open routine did something to the protections already? */
 	if (pgprot_val(vma->vm_page_prot) !=
-	    pgprot_val(protection_map[vm_flags &
-		    (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]))
+	    pgprot_val(vm_get_page_prot(vm_flags)))
 		return 0;
 
 	/* Specialty mapping? */
@@ -1130,8 +1129,7 @@ munmap_back:
 	vma->vm_start = addr;
 	vma->vm_end = addr + len;
 	vma->vm_flags = vm_flags;
-	vma->vm_page_prot = protection_map[vm_flags &
-				(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)];
+	vma->vm_page_prot = vm_get_page_prot(vm_flags);
 	vma->vm_pgoff = pgoff;
 
 	if (file) {
@@ -2002,8 +2000,7 @@ unsigned long do_brk(unsigned long addr,
 	vma->vm_end = addr + len;
 	vma->vm_pgoff = pgoff;
 	vma->vm_flags = flags;
-	vma->vm_page_prot = protection_map[flags &
-				(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)];
+	vma->vm_page_prot = vm_get_page_prot(flags);
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 out:
 	mm->total_vm += len >> PAGE_SHIFT;
@@ -2209,7 +2206,7 @@ int install_special_mapping(struct mm_st
 	vma->vm_end = addr + len;
 
 	vma->vm_flags = vm_flags | mm->def_flags;
-	vma->vm_page_prot = protection_map[vma->vm_flags & 7];
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 
 	vma->vm_ops = &special_mapping_vmops;
 	vma->vm_private_data = pages;
diff -puN mm/mprotect.c~setup-vma-vm_page_prot-by-vm_get_page_prot mm/mprotect.c
--- a/mm/mprotect.c~setup-vma-vm_page_prot-by-vm_get_page_prot
+++ a/mm/mprotect.c
@@ -192,11 +192,9 @@ success:
 	 * held in write mode.
 	 */
 	vma->vm_flags = newflags;
-	vma->vm_page_prot = protection_map[newflags &
-		(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)];
+	vma->vm_page_prot = vm_get_page_prot(newflags);
 	if (vma_wants_writenotify(vma)) {
-		vma->vm_page_prot = protection_map[newflags &
-			(VM_READ|VM_WRITE|VM_EXEC)];
+		vma->vm_page_prot = vm_get_page_prot(newflags);
 		dirty_accountable = 1;
 	}
 
_

Patches currently in -mm which might be from coyli@suse.de are

setup-vma-vm_page_prot-by-vm_get_page_prot.patch
use-vm_read-write-exec-to-set-vm_page_prot.patch
ext4-remove-obsolete-fragments.patch
