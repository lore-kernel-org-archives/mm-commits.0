From: akpm@linux-foundation.org
Subject: + revoke-core-code-misc-fixes.patch added to -mm tree
Date: Fri, 16 Mar 2007 03:28:30 -0800
Message-ID: <200703161128.l2GBSU5t009954@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41789 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbXCPL2i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 07:28:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi


The patch titled
     revoke: misc fixes
has been added to the -mm tree.  Its filename is
     revoke-core-code-misc-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revoke: misc fixes
From: Pekka Enberg <penberg@cs.helsinki.fi>

This is a rollup patch of the following fixes to address some of Andrew's
review comments:

  - Fix return value type of system calls to long
  - Add comment for vma->vm_flag barrier
  - No need for GFP_NOFS for inode allocation, use GFP_KERNEL instead
  - Remove unnecessary line break before EXPORT_SYMBOL

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/revoke.c              |    9 +++++----
 include/linux/syscalls.h |    4 ++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/revoke.c~revoke-core-code-misc-fixes fs/revoke.c
--- a/fs/revoke.c~revoke-core-code-misc-fixes
+++ a/fs/revoke.c
@@ -167,7 +167,9 @@ static int revoke_vma(struct vm_area_str
 	end_addr = vma->vm_end;
 
 	/*
- 	 * Not holding ->mmap_sem here.
+ 	 * Not holding ->mmap_sem here but we must watch out for page
+ 	 * faults and after the shared mappings have been taken down
+ 	 * and sys_mmap() trying to remap the revoked range.
 	 */
 	vma->vm_flags |= VM_REVOKED;
 	smp_mb();
@@ -455,7 +457,7 @@ static int do_revoke(struct inode *inode
 	return err;
 }
 
-asmlinkage int sys_revokeat(int dfd, const char __user * filename)
+asmlinkage long sys_revokeat(int dfd, const char __user * filename)
 {
 	struct nameidata nd;
 	int err;
@@ -499,7 +501,6 @@ int generic_file_revoke(struct file *fil
   out:
 	return err;
 }
-
 EXPORT_SYMBOL(generic_file_revoke);
 
 /*
@@ -510,7 +511,7 @@ static struct inode *revokefs_alloc_inod
 {
 	struct revokefs_inode_info *info;
 
-	info = kmem_cache_alloc(revokefs_inode_cache, GFP_NOFS);
+	info = kmem_cache_alloc(revokefs_inode_cache, GFP_KERNEL);
 	if (!info)
 		return NULL;
 
diff -puN include/linux/syscalls.h~revoke-core-code-misc-fixes include/linux/syscalls.h
--- a/include/linux/syscalls.h~revoke-core-code-misc-fixes
+++ a/include/linux/syscalls.h
@@ -605,7 +605,7 @@ asmlinkage long sys_getcpu(unsigned __us
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
-asmlinkage int sys_revokeat(int dfd, const char __user *filename);
-asmlinkage int sys_frevoke(unsigned int fd);
+asmlinkage long sys_revokeat(int dfd, const char __user *filename);
+asmlinkage long sys_frevoke(unsigned int fd);
 
 #endif
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
unionfs-fix-slab-abuses-with-krealloc.patch
slab-ensure-cache_alloc_refill-terminates.patch
module-use-krealloc.patch
slab-use-cpu_lock_.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-core-code-misc-fixes.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-core-code-move-magic.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
