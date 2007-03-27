From: akpm@linux-foundation.org
Subject: + revoke-core-code-fix-shared-mapping-revoke-revoke-only-revoke-mappings-for-the-given-inode.patch added to -mm tree
Date: Tue, 27 Mar 2007 13:19:51 -0700
Message-ID: <200703272019.l2RKJplw026851@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41608 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964813AbXC0UT5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 16:19:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi


The patch titled
     revoke: only revoke mappings for the given inode
has been added to the -mm tree.  Its filename is
     revoke-core-code-fix-shared-mapping-revoke-revoke-only-revoke-mappings-for-the-given-inode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revoke: only revoke mappings for the given inode
From: Pekka Enberg <penberg@cs.helsinki.fi>

This fixes a bug that was introduced when we switched to rescanning all the
vmas of a mm.  We need to check that the vma host file points to the same
inode we are revoking; otherwise we end up revoking all shared mappings.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/revoke.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff -puN fs/revoke.c~revoke-core-code-fix-shared-mapping-revoke-revoke-only-revoke-mappings-for-the-given-inode fs/revoke.c
--- a/fs/revoke.c~revoke-core-code-fix-shared-mapping-revoke-revoke-only-revoke-mappings-for-the-given-inode
+++ a/fs/revoke.c
@@ -161,15 +161,24 @@ static int revoke_fds(struct task_struct
 }
 
 static inline bool need_revoke(struct vm_area_struct *vma,
+			       struct inode *inode,
 			       struct file *to_exclude)
 {
+	struct file *file = vma->vm_file;
+
 	if (vma->vm_flags & VM_REVOKED)
 		return false;
 
+	if (!file)
+		return false;
+
+	if (file->f_path.dentry->d_inode != inode)
+		return false;
+
 	if (!(vma->vm_flags & VM_SHARED))
 		return false;
 
-	return vma->vm_file != to_exclude;
+	return file != to_exclude;
 }
 
 /*
@@ -227,7 +236,7 @@ static int revoke_mm(struct mm_struct *m
 		goto out;
 	}
 	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
-		if (!need_revoke(vma, to_exclude))
+		if (!need_revoke(vma, mapping->host, to_exclude))
 			continue;
 
 		err = revoke_vma(vma, &details);
@@ -253,7 +262,7 @@ static void revoke_mapping_tree(struct a
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, ULONG_MAX) {
 		int err;
 
-		if (likely(!need_revoke(vma, to_exclude)))
+		if (likely(!need_revoke(vma, mapping->host, to_exclude)))
 			continue;
 
 		err = revoke_mm(vma->vm_mm, mapping, to_exclude);
@@ -283,7 +292,7 @@ static void revoke_mapping_list(struct a
 	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list) {
 		int err;
 
-		if (likely(!need_revoke(vma, to_exclude)))
+		if (likely(!need_revoke(vma, mapping->host, to_exclude)))
 			continue;
 
 		err = revoke_mm(vma->vm_mm, mapping, to_exclude);
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
unionfs-fix-slab-abuses-with-krealloc.patch
slab-ensure-cache_alloc_refill-terminates.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
slab-dont-allocate-empty-shared-caches.patch
slab-numa-kmem_cache-diet.patch
module-use-krealloc.patch
slab-use-cpu_lock_.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-core-code-misc-fixes.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-core-code-move-magic.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-fix-shared-mapping-revoke-revoke-only-revoke-mappings-for-the-given-inode.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
