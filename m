From: akpm@linux-foundation.org
Subject: - revoke-core-code-need-mmap_sem-to-modify-vma-vm_flags.patch removed from -mm tree
Date: Fri, 16 Mar 2007 03:55:19 -0800
Message-ID: <200703161155.l2GBtKG1010520@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43072 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965109AbXCPLzi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 07:55:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     revoke: need ->mmap_sem to modify vma->vm_flags
has been removed from the -mm tree.  Its filename was
     revoke-core-code-need-mmap_sem-to-modify-vma-vm_flags.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: revoke: need ->mmap_sem to modify vma->vm_flags
From: Pekka Enberg <penberg@cs.helsinki.fi>

As pointed out by Nick Piggin, modifying vma->vm_flags without ->mmap_sem
can corrupt the flags.  This changes revoke_mapping() to drop ->i_mmap_lock
and rescanning vmas of the parent mm under ->mmap_sem.

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/revoke.c |   86 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 60 insertions(+), 26 deletions(-)

diff -puN fs/revoke.c~revoke-core-code-need-mmap_sem-to-modify-vma-vm_flags fs/revoke.c
--- a/fs/revoke.c~revoke-core-code-need-mmap_sem-to-modify-vma-vm_flags
+++ a/fs/revoke.c
@@ -159,6 +159,22 @@ static int revoke_fds(struct task_struct
 	return err;
 }
 
+static inline bool need_revoke(struct vm_area_struct *vma,
+			       struct file *to_exclude)
+{
+	if (vma->vm_flags & VM_REVOKED)
+		return false;
+
+	if (!(vma->vm_flags & VM_SHARED))
+		return false;
+
+	return vma->vm_file != to_exclude;
+}
+
+/*
+ *	 LOCKING: down_write(&mm->mmap_sem)
+ *	 	    -> spin_lock(&mapping->i_mmap_lock)
+ */
 static int revoke_vma(struct vm_area_struct *vma, struct zap_details *details)
 {
 	unsigned long restart_addr, start_addr, end_addr;
@@ -167,13 +183,8 @@ static int revoke_vma(struct vm_area_str
 	start_addr = vma->vm_start;
 	end_addr = vma->vm_end;
 
-	/*
- 	 * Not holding ->mmap_sem here but we must watch out for page
- 	 * faults and after the shared mappings have been taken down
- 	 * and sys_mmap() trying to remap the revoked range.
-	 */
 	vma->vm_flags |= VM_REVOKED;
-	smp_mb();
+
   again:
 	restart_addr = zap_page_range(vma, start_addr, end_addr - start_addr,
 				      details);
@@ -195,48 +206,71 @@ static int revoke_vma(struct vm_area_str
 	return -EINTR;
 }
 
+/*
+ *	LOCKING: spin_lock(&mapping->i_mmap_lock)
+ */
+static void revoke_mm(struct mm_struct *mm, struct address_space *mapping,
+		      struct file *to_exclude)
+{
+	struct vm_area_struct *vma;
+	struct zap_details details;
+
+	details.i_mmap_lock = &mapping->i_mmap_lock;
+
+	spin_unlock(&mapping->i_mmap_lock);
+	down_write(&mm->mmap_sem);
+	spin_lock(&mapping->i_mmap_lock);
+  restart:
+	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
+		if (!(vma->vm_flags & VM_SHARED) || vma->vm_file == to_exclude)
+			continue;
+
+		if (revoke_vma(vma, &details))
+			goto restart;
+	}
+	up_write(&mm->mmap_sem);
+}
+
+/*
+ *	LOCKING: spin_lock(&mapping->i_mmap_lock)
+ */
 static void revoke_mapping_tree(struct address_space *mapping,
-				struct file *to_exclude,
-				struct zap_details *details)
+				struct file *to_exclude)
 {
 	struct vm_area_struct *vma;
 	struct prio_tree_iter iter;
 
-  restart:
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, ULONG_MAX) {
-		if ((vma->vm_flags & VM_SHARED) && vma->vm_file != to_exclude) {
-			if (revoke_vma(vma, details))
-				goto restart;
-		}
+		if (likely(!need_revoke(vma, to_exclude)))
+			continue;
+
+		revoke_mm(vma->vm_mm, mapping, to_exclude);
 	}
 }
 
+/*
+ *	LOCKING: spin_lock(&mapping->i_mmap_lock)
+ */
 static void revoke_mapping_list(struct address_space *mapping,
-				struct file *to_exclude,
-				struct zap_details *details)
+				struct file *to_exclude)
 {
 	struct vm_area_struct *vma;
 
-  restart:
 	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list) {
-		if ((vma->vm_flags & VM_SHARED) && vma->vm_file != to_exclude) {
-			if (revoke_vma(vma, details))
-				goto restart;
-		}
+		if (likely(!need_revoke(vma, to_exclude)))
+			continue;
+
+		revoke_mm(vma->vm_mm, mapping, to_exclude);
 	}
 }
 
 static void revoke_mapping(struct address_space *mapping, struct file *to_exclude)
 {
-	struct zap_details details;
-
-	details.i_mmap_lock = &mapping->i_mmap_lock;
-
 	spin_lock(&mapping->i_mmap_lock);
 	if (unlikely(!prio_tree_empty(&mapping->i_mmap)))
-		revoke_mapping_tree(mapping, to_exclude, &details);
+		revoke_mapping_tree(mapping, to_exclude);
 	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
-		revoke_mapping_list(mapping, to_exclude, &details);
+		revoke_mapping_list(mapping, to_exclude);
 	spin_unlock(&mapping->i_mmap_lock);
 }
 
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
revoke-core-code-need-mmap_sem-to-modify-vma-vm_flags.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
