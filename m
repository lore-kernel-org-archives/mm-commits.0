From: akpm@linux-foundation.org
Subject: - revoke-core-code-fix-shared-mapping-revoke.patch removed from -mm tree
Date: Wed, 09 May 2007 02:55:40 -0700
Message-ID: <200705090955.l499teR1020515@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757189AbXEIJzp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:55:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     revoke: fix shared mapping revoke
has been removed from the -mm tree.  Its filename was
     revoke-core-code-fix-shared-mapping-revoke.patch

This patch was dropped because it was folded into revoke-core-code.patch

------------------------------------------------------
Subject: revoke: fix shared mapping revoke
From: Pekka Enberg <penberg@cs.helsinki.fi>

On 3/16/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> This all looks very strange.  If the calling process expires its timeslice,
> the entire system call fails?

This changes revoke_mapping() to restart after cond_resched() to fix an
obvious goof made by me.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/revoke.c |  130 ++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 105 insertions(+), 25 deletions(-)

diff -puN fs/revoke.c~revoke-core-code-fix-shared-mapping-revoke fs/revoke.c
--- a/fs/revoke.c~revoke-core-code-fix-shared-mapping-revoke
+++ a/fs/revoke.c
@@ -158,6 +158,22 @@ static int revoke_fds(struct task_struct
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
@@ -166,13 +182,6 @@ static int revoke_vma(struct vm_area_str
 	start_addr = vma->vm_start;
 	end_addr = vma->vm_end;
 
-	/*
- 	 * Not holding ->mmap_sem here but we must watch out for page
- 	 * faults and after the shared mappings have been taken down
- 	 * and sys_mmap() trying to remap the revoked range.
-	 */
-	vma->vm_flags |= VM_REVOKED;
-	smp_mb();
   again:
 	restart_addr = zap_page_range(vma, start_addr, end_addr - start_addr,
 				      details);
@@ -185,6 +194,7 @@ static int revoke_vma(struct vm_area_str
 		start_addr = restart_addr;
 		goto again;
 	}
+	vma->vm_flags |= VM_REVOKED;
 	return 0;
 
   out_need_break:
@@ -194,34 +204,108 @@ static int revoke_vma(struct vm_area_str
 	return -EINTR;
 }
 
-static int revoke_mapping(struct address_space *mapping, struct file *to_exclude)
+/*
+ *	LOCKING: spin_lock(&mapping->i_mmap_lock)
+ */
+static int revoke_mm(struct mm_struct *mm, struct address_space *mapping,
+		     struct file *to_exclude)
 {
 	struct vm_area_struct *vma;
-	struct prio_tree_iter iter;
 	struct zap_details details;
 	int err = 0;
 
 	details.i_mmap_lock = &mapping->i_mmap_lock;
 
-	spin_lock(&mapping->i_mmap_lock);
+	/*
+ 	 * If ->mmap_sem is under contention, we continue scanning other
+ 	 * mms and try again later.
+ 	 */
+	if (!down_write_trylock(&mm->mmap_sem)) {
+		err = -EAGAIN;
+		goto out;
+	}
+	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
+		if (!need_revoke(vma, to_exclude))
+			continue;
+
+		err = revoke_vma(vma, &details);
+		if (err)
+			break;
+	}
+	up_write(&mm->mmap_sem);
+  out:
+	return err;
+}
+
+/*
+ *	LOCKING: spin_lock(&mapping->i_mmap_lock)
+ */
+static void revoke_mapping_tree(struct address_space *mapping,
+				struct file *to_exclude)
+{
+	struct vm_area_struct *vma;
+	struct prio_tree_iter iter;
+	int try_again = 0;
+
+  restart:
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, ULONG_MAX) {
-		if ((vma->vm_flags & VM_SHARED) && vma->vm_file != to_exclude) {
-			err = revoke_vma(vma, &details);
-			if (err)
-				goto out;
+		int err;
+
+		if (likely(!need_revoke(vma, to_exclude)))
+			continue;
+
+		err = revoke_mm(vma->vm_mm, mapping, to_exclude);
+		if (err == -EAGAIN) {
+			try_again = 1;
+			continue;
 		}
+		if (err == -EINTR)
+			goto restart;
+	}
+	if (try_again) {
+		cond_resched();
+		goto restart;
 	}
+}
 
+/*
+ *	LOCKING: spin_lock(&mapping->i_mmap_lock)
+ */
+static void revoke_mapping_list(struct address_space *mapping,
+				struct file *to_exclude)
+{
+	struct vm_area_struct *vma;
+	int try_again = 0;
+
+  restart:
 	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list) {
-		if ((vma->vm_flags & VM_SHARED) && vma->vm_file != to_exclude) {
-			err = revoke_vma(vma, &details);
-			if (err)
-				goto out;
+		int err;
+
+		if (likely(!need_revoke(vma, to_exclude)))
+			continue;
+
+		err = revoke_mm(vma->vm_mm, mapping, to_exclude);
+		if (err == -EAGAIN) {
+			try_again = 1;
+			continue;
 		}
+		if (err == -EINTR)
+			goto restart;
 	}
-  out:
+	if (try_again) {
+		cond_resched();
+		goto restart;
+	}
+}
+
+static void revoke_mapping(struct address_space *mapping, struct file *to_exclude)
+{
+	spin_lock(&mapping->i_mmap_lock);
+	if (unlikely(!prio_tree_empty(&mapping->i_mmap)))
+		revoke_mapping_tree(mapping, to_exclude);
+	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
+		revoke_mapping_list(mapping, to_exclude);
 	spin_unlock(&mapping->i_mmap_lock);
-	return err;
 }
 
 static void restore_file(struct revokefs_inode_info *info)
@@ -441,11 +525,7 @@ static int do_revoke(struct inode *inode
 	/*
 	 * Take down shared memory mappings.
 	 */
-	err = revoke_mapping(inode->i_mapping, to_exclude);
-	if (err) {
-		restore_files(table);
-		goto out_free_table;
-	}
+	revoke_mapping(inode->i_mapping, to_exclude);
 
 	/*
 	 * Now, revoke the files for good.
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
