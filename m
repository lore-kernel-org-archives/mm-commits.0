From: akpm@linux-foundation.org
Subject: - revoke-core-code-misc-fixes.patch removed from -mm tree
Date: Wed, 09 May 2007 02:55:37 -0700
Message-ID: <200705090955.l499tbke020512@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757188AbXEIJzo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:55:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     revoke: misc fixes
has been removed from the -mm tree.  Its filename was
     revoke-core-code-misc-fixes.patch

This patch was dropped because it was folded into revoke-core-code.patch

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
@@ -609,7 +609,7 @@ asmlinkage long sys_eventfd(unsigned int
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
-asmlinkage int sys_revokeat(int dfd, const char __user *filename);
-asmlinkage int sys_frevoke(unsigned int fd);
+asmlinkage long sys_revokeat(int dfd, const char __user *filename);
+asmlinkage long sys_frevoke(unsigned int fd);
 
 #endif
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
krealloc-fix-kerneldoc-comments.patch
slab-use-cpu_lock_.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
unionfs-fix-slab-abuses-with-krealloc.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-core-code-misc-fixes.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-core-code-move-magic.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-fix-shared-mapping-revoke-revoke-only-revoke-mappings-for-the-given-inode.patch
revoke-core-code-break-cow-for-private-mappings.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
revoke-core-code-break-cow-fixes.patch
revoke-core-code-mapping-revocation.patch
revoke-core-code-only-fput-unused-files.patch
revoke-core-code-rename-to-can_revoke_filevma.patch
revoke-core-code-change-revoke_table-to-fileset-and-revoke_details.patch
revoke-core-code-do_revoke-error-handling.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
