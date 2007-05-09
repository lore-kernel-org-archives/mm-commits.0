From: akpm@linux-foundation.org
Subject: - revoke-core-code-fix-shared-mapping-revoke-revoke-only-revoke-mappings-for-the-given-inode.patch removed from -mm tree
Date: Wed, 09 May 2007 02:55:49 -0700
Message-ID: <200705090955.l499tn0b020527@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757215AbXEIJzx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:55:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     revoke: only revoke mappings for the given inode
has been removed from the -mm tree.  Its filename was
     revoke-core-code-fix-shared-mapping-revoke-revoke-only-revoke-mappings-for-the-given-inode.patch

This patch was dropped because it was folded into revoke-core-code.patch

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

origin.patch
krealloc-fix-kerneldoc-comments.patch
slab-use-cpu_lock_.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
unionfs-fix-slab-abuses-with-krealloc.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
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
