From: akpm@linux-foundation.org
Subject: + revoke-core-code-rename-to-can_revoke_filevma.patch added to -mm tree
Date: Thu, 03 May 2007 13:17:52 -0700
Message-ID: <200705032017.l43KHqkA018824@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754399AbXECUT7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 16:19:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi


The patch titled
     revoke: rename to can_revoke_{file|vma}
has been added to the -mm tree.  Its filename is
     revoke-core-code-rename-to-can_revoke_filevma.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revoke: rename to can_revoke_{file|vma}
From: Pekka Enberg <penberg@cs.helsinki.fi>

The inode_matches and need_revoke functions have confusing names so rename
them to can_revoke_file and can_revoke_vma respectively.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/revoke.c |   33 ++++++++++++++++-----------------
 1 files changed, 16 insertions(+), 17 deletions(-)

diff -puN fs/revoke.c~revoke-core-code-rename-to-can_revoke_filevma fs/revoke.c
--- a/fs/revoke.c~revoke-core-code-rename-to-can_revoke_filevma
+++ a/fs/revoke.c
@@ -75,10 +75,13 @@ static struct file *get_revoked_file(voi
 	return NULL;
 }
 
-static inline int inode_matches(struct file *file, struct inode *inode,
-				struct file *to_exclude)
+static inline bool can_revoke_file(struct file *file, struct inode *inode,
+				   struct file *to_exclude)
 {
-	return file && file != to_exclude && file->f_dentry->d_inode == inode;
+	if (!file || file == to_exclude)
+		return false;
+
+	return file->f_dentry->d_inode == inode;
 }
 
 static inline bool revoke_table_is_full(struct revoke_table *table)
@@ -116,7 +119,7 @@ static int revoke_fds(struct task_struct
 		struct inode *new_inode;
 
 		filp = fcheck_files(files, fd);
-		if (!inode_matches(filp, inode, to_exclude))
+		if (!can_revoke_file(filp, inode, to_exclude))
 			continue;
 
 		if (!filp->f_op->revoke) {
@@ -159,22 +162,18 @@ static int revoke_fds(struct task_struct
 	return err;
 }
 
-static inline bool need_revoke(struct vm_area_struct *vma,
-			       struct inode *inode,
-			       struct file *to_exclude)
+static inline bool can_revoke_vma(struct vm_area_struct *vma,
+				  struct inode *inode, struct file *to_exclude)
 {
 	struct file *file = vma->vm_file;
 
 	if (vma->vm_flags & VM_REVOKED)
 		return false;
 
-	if (!file)
-		return false;
-
-	if (file->f_path.dentry->d_inode != inode)
+	if (!file || file == to_exclude)
 		return false;
 
-	return file != to_exclude;
+	return file->f_path.dentry->d_inode == inode;
 }
 
 static int __revoke_break_cow(struct task_struct *tsk, struct inode *inode,
@@ -191,7 +190,7 @@ static int __revoke_break_cow(struct tas
 		if (vma->vm_flags & VM_SHARED)
 			continue;
 
-		if (!need_revoke(vma, inode, to_exclude))
+		if (!can_revoke_vma(vma, inode, to_exclude))
 			continue;
 
 		ret = get_user_pages(tsk, tsk->mm, vma->vm_start,
@@ -287,7 +286,7 @@ static int revoke_mm(struct mm_struct *m
 		if (!(vma->vm_flags & VM_SHARED))
 			continue;
 
-		if (!need_revoke(vma, mapping->host, to_exclude))
+		if (!can_revoke_vma(vma, mapping->host, to_exclude))
 			continue;
 
 		err = revoke_vma(vma, &details);
@@ -320,7 +319,7 @@ static void revoke_mapping_tree(struct a
 		if (!(vma->vm_flags & VM_SHARED))
 			continue;
 
-		if (likely(!need_revoke(vma, mapping->host, to_exclude)))
+		if (likely(!can_revoke_vma(vma, mapping->host, to_exclude)))
 			continue;
 
 		err = revoke_mm(vma->vm_mm, mapping, to_exclude);
@@ -348,7 +347,7 @@ static void revoke_mapping_list(struct a
 	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list) {
 		int err;
 
-		if (likely(!need_revoke(vma, mapping->host, to_exclude)))
+		if (likely(!can_revoke_vma(vma, mapping->host, to_exclude)))
 			continue;
 
 		err = revoke_mm(vma->vm_mm, mapping, to_exclude);
@@ -470,7 +469,7 @@ static unsigned long inode_fds(struct in
 			struct file *file;
 
 			file = fcheck_files(files, fd);
-			if (inode_matches(file, inode, to_exclude)) {
+			if (can_revoke_file(file, inode, to_exclude)) {
 				nr_fds += fdt->max_fds;
 				break;
 			}
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

slab-introduce-krealloc.patch
slab-ensure-cache_alloc_refill-terminates.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
slab-dont-allocate-empty-shared-caches.patch
slab-numa-kmem_cache-diet.patch
slab-mark-set_up_list3s-__init.patch
slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
fault-injection-fix-failslab-with-config_numa.patch
increase-slab-redzone-to-64bits.patch
module-use-krealloc.patch
slab-use-cpu_lock_.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
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
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
