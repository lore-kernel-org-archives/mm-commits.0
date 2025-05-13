Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F8F1EF0B4
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119311; cv=none; b=Lb2z+iKe88TmKMpbJInpsD/zFlYQ7s6Gg+DjYXHbOtlbaXH4BjqEyx+M+ESHMAkqUG8M+IS3Cb8QfhvBM24IR4QDiLF8b/ogzLzn3vIyrN5JD9SBECR/r+hC+iWjb/IA76P45xqA0Xa9nh5JNIkTGafMnRy4dYQiHsWfgMsQ5AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119311; c=relaxed/simple;
	bh=gRbs9d16wwYrTZh2aXXR7c72W9qA+HSPb4UEhgiBzhM=;
	h=Date:To:From:Subject:Message-Id; b=VFW6X1y7deYXo4XKXXSSz6nFThCKE6utOlHhEpkCzK0/hOKwv3jWwSuTbaHRA8uf0fGef+pdQKxkFiugDIkQO8QbAXHMjTpdKJ13is74EkbKN7Qrw1KFqCa2AyW/Em1D1OpvvsHwkR0HvUvDYhvFZBQMHstZmPvQL4WXRVpvHQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hItjnr4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hItjnr4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDE7C4CEE4;
	Tue, 13 May 2025 06:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119309;
	bh=gRbs9d16wwYrTZh2aXXR7c72W9qA+HSPb4UEhgiBzhM=;
	h=Date:To:From:Subject:From;
	b=hItjnr4yyKzQnPGwBiAMFf3K5d7YQ6qO5NbpXRr8Ei8EMebvZI2sPFyMq1B9wvdX3
	 tivjnZZc9Jx0K8H47YJegy9RoRc4otnPzFjsYRymXttAtWMC6DgZOZrOsWOtiTgblP
	 G4y9aoVCocHwhkoAATAMpxXL67rTgwpq5HOsPjtM=
Date: Mon, 12 May 2025 23:55:08 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,pfalcato@suse.de,Liam.Howlett@oracle.com,kees@kernel.org,jannh@google.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-dup_mmap-to-mm.patch removed from -mm tree
Message-Id: <20250513065509.5BDE7C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move dup_mmap() to mm
has been removed from the -mm tree.  Its filename was
     mm-move-dup_mmap-to-mm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: move dup_mmap() to mm
Date: Mon, 28 Apr 2025 16:28:16 +0100

This is a key step in our being able to abstract and isolate VMA
allocation and destruction logic.

This function is the last one where vm_area_free() and vm_area_dup() are
directly referenced outside of mmap, so having this in mm allows us to
isolate these.

We do the same for the nommu version which is substantially simpler.

We place the declaration for dup_mmap() in mm/internal.h and have
kernel/fork.c import this in order to prevent improper use of this
functionality elsewhere in the kernel.

While we're here, we remove the useless #ifdef CONFIG_MMU check around
mmap_read_lock_maybe_expand() in mmap.c, mmap.c is compiled only if
CONFIG_MMU is set.

Link: https://lkml.kernel.org/r/e49aad3d00212f5539d9fa5769bfda4ce451db3e.1745853549.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kees Cook <kees@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |  189 +-----------------------------------------------
 mm/internal.h |    2 
 mm/mmap.c     |  181 ++++++++++++++++++++++++++++++++++++++++++++-
 mm/nommu.c    |    8 ++
 4 files changed, 189 insertions(+), 191 deletions(-)

--- a/kernel/fork.c~mm-move-dup_mmap-to-mm
+++ a/kernel/fork.c
@@ -112,6 +112,9 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
+/* For dup_mmap(). */
+#include "../mm/internal.h"
+
 #include <trace/events/sched.h>
 
 #define CREATE_TRACE_POINTS
@@ -589,7 +592,7 @@ void free_task(struct task_struct *tsk)
 }
 EXPORT_SYMBOL(free_task);
 
-static void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm)
+void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm)
 {
 	struct file *exe_file;
 
@@ -604,183 +607,6 @@ static void dup_mm_exe_file(struct mm_st
 }
 
 #ifdef CONFIG_MMU
-static __latent_entropy int dup_mmap(struct mm_struct *mm,
-					struct mm_struct *oldmm)
-{
-	struct vm_area_struct *mpnt, *tmp;
-	int retval;
-	unsigned long charge = 0;
-	LIST_HEAD(uf);
-	VMA_ITERATOR(vmi, mm, 0);
-
-	if (mmap_write_lock_killable(oldmm))
-		return -EINTR;
-	flush_cache_dup_mm(oldmm);
-	uprobe_dup_mmap(oldmm, mm);
-	/*
-	 * Not linked in yet - no deadlock potential:
-	 */
-	mmap_write_lock_nested(mm, SINGLE_DEPTH_NESTING);
-
-	/* No ordering required: file already has been exposed. */
-	dup_mm_exe_file(mm, oldmm);
-
-	mm->total_vm = oldmm->total_vm;
-	mm->data_vm = oldmm->data_vm;
-	mm->exec_vm = oldmm->exec_vm;
-	mm->stack_vm = oldmm->stack_vm;
-
-	/* Use __mt_dup() to efficiently build an identical maple tree. */
-	retval = __mt_dup(&oldmm->mm_mt, &mm->mm_mt, GFP_KERNEL);
-	if (unlikely(retval))
-		goto out;
-
-	mt_clear_in_rcu(vmi.mas.tree);
-	for_each_vma(vmi, mpnt) {
-		struct file *file;
-
-		vma_start_write(mpnt);
-		if (mpnt->vm_flags & VM_DONTCOPY) {
-			retval = vma_iter_clear_gfp(&vmi, mpnt->vm_start,
-						    mpnt->vm_end, GFP_KERNEL);
-			if (retval)
-				goto loop_out;
-
-			vm_stat_account(mm, mpnt->vm_flags, -vma_pages(mpnt));
-			continue;
-		}
-		charge = 0;
-		/*
-		 * Don't duplicate many vmas if we've been oom-killed (for
-		 * example)
-		 */
-		if (fatal_signal_pending(current)) {
-			retval = -EINTR;
-			goto loop_out;
-		}
-		if (mpnt->vm_flags & VM_ACCOUNT) {
-			unsigned long len = vma_pages(mpnt);
-
-			if (security_vm_enough_memory_mm(oldmm, len)) /* sic */
-				goto fail_nomem;
-			charge = len;
-		}
-		tmp = vm_area_dup(mpnt);
-		if (!tmp)
-			goto fail_nomem;
-
-		/* track_pfn_copy() will later take care of copying internal state. */
-		if (unlikely(tmp->vm_flags & VM_PFNMAP))
-			untrack_pfn_clear(tmp);
-
-		retval = vma_dup_policy(mpnt, tmp);
-		if (retval)
-			goto fail_nomem_policy;
-		tmp->vm_mm = mm;
-		retval = dup_userfaultfd(tmp, &uf);
-		if (retval)
-			goto fail_nomem_anon_vma_fork;
-		if (tmp->vm_flags & VM_WIPEONFORK) {
-			/*
-			 * VM_WIPEONFORK gets a clean slate in the child.
-			 * Don't prepare anon_vma until fault since we don't
-			 * copy page for current vma.
-			 */
-			tmp->anon_vma = NULL;
-		} else if (anon_vma_fork(tmp, mpnt))
-			goto fail_nomem_anon_vma_fork;
-		vm_flags_clear(tmp, VM_LOCKED_MASK);
-		/*
-		 * Copy/update hugetlb private vma information.
-		 */
-		if (is_vm_hugetlb_page(tmp))
-			hugetlb_dup_vma_private(tmp);
-
-		/*
-		 * Link the vma into the MT. After using __mt_dup(), memory
-		 * allocation is not necessary here, so it cannot fail.
-		 */
-		vma_iter_bulk_store(&vmi, tmp);
-
-		mm->map_count++;
-
-		if (tmp->vm_ops && tmp->vm_ops->open)
-			tmp->vm_ops->open(tmp);
-
-		file = tmp->vm_file;
-		if (file) {
-			struct address_space *mapping = file->f_mapping;
-
-			get_file(file);
-			i_mmap_lock_write(mapping);
-			if (vma_is_shared_maywrite(tmp))
-				mapping_allow_writable(mapping);
-			flush_dcache_mmap_lock(mapping);
-			/* insert tmp into the share list, just after mpnt */
-			vma_interval_tree_insert_after(tmp, mpnt,
-					&mapping->i_mmap);
-			flush_dcache_mmap_unlock(mapping);
-			i_mmap_unlock_write(mapping);
-		}
-
-		if (!(tmp->vm_flags & VM_WIPEONFORK))
-			retval = copy_page_range(tmp, mpnt);
-
-		if (retval) {
-			mpnt = vma_next(&vmi);
-			goto loop_out;
-		}
-	}
-	/* a new mm has just been created */
-	retval = arch_dup_mmap(oldmm, mm);
-loop_out:
-	vma_iter_free(&vmi);
-	if (!retval) {
-		mt_set_in_rcu(vmi.mas.tree);
-		ksm_fork(mm, oldmm);
-		khugepaged_fork(mm, oldmm);
-	} else {
-
-		/*
-		 * The entire maple tree has already been duplicated. If the
-		 * mmap duplication fails, mark the failure point with
-		 * XA_ZERO_ENTRY. In exit_mmap(), if this marker is encountered,
-		 * stop releasing VMAs that have not been duplicated after this
-		 * point.
-		 */
-		if (mpnt) {
-			mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
-			mas_store(&vmi.mas, XA_ZERO_ENTRY);
-			/* Avoid OOM iterating a broken tree */
-			set_bit(MMF_OOM_SKIP, &mm->flags);
-		}
-		/*
-		 * The mm_struct is going to exit, but the locks will be dropped
-		 * first.  Set the mm_struct as unstable is advisable as it is
-		 * not fully initialised.
-		 */
-		set_bit(MMF_UNSTABLE, &mm->flags);
-	}
-out:
-	mmap_write_unlock(mm);
-	flush_tlb_mm(oldmm);
-	mmap_write_unlock(oldmm);
-	if (!retval)
-		dup_userfaultfd_complete(&uf);
-	else
-		dup_userfaultfd_fail(&uf);
-	return retval;
-
-fail_nomem_anon_vma_fork:
-	mpol_put(vma_policy(tmp));
-fail_nomem_policy:
-	vm_area_free(tmp);
-fail_nomem:
-	retval = -ENOMEM;
-	vm_unacct_memory(charge);
-	goto loop_out;
-}
-
 static inline int mm_alloc_pgd(struct mm_struct *mm)
 {
 	mm->pgd = pgd_alloc(mm);
@@ -794,13 +620,6 @@ static inline void mm_free_pgd(struct mm
 	pgd_free(mm, mm->pgd);
 }
 #else
-static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
-{
-	mmap_write_lock(oldmm);
-	dup_mm_exe_file(mm, oldmm);
-	mmap_write_unlock(oldmm);
-	return 0;
-}
 #define mm_alloc_pgd(mm)	(0)
 #define mm_free_pgd(mm)
 #endif /* CONFIG_MMU */
--- a/mm/internal.h~mm-move-dup_mmap-to-mm
+++ a/mm/internal.h
@@ -1624,5 +1624,7 @@ static inline bool reclaim_pt_is_enabled
 }
 #endif /* CONFIG_PT_RECLAIM */
 
+void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm);
+int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
 
 #endif	/* __MM_INTERNAL_H */
--- a/mm/mmap.c~mm-move-dup_mmap-to-mm
+++ a/mm/mmap.c
@@ -1675,7 +1675,6 @@ static int __meminit init_reserve_notifi
 }
 subsys_initcall(init_reserve_notifier);
 
-#ifdef CONFIG_MMU
 /*
  * Obtain a read lock on mm->mmap_lock, if the specified address is below the
  * start of the VMA, the intent is to perform a write, and it is a
@@ -1719,10 +1718,180 @@ bool mmap_read_lock_maybe_expand(struct
 	mmap_write_downgrade(mm);
 	return true;
 }
-#else
-bool mmap_read_lock_maybe_expand(struct mm_struct *mm, struct vm_area_struct *vma,
-				 unsigned long addr, bool write)
+
+__latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 {
-	return false;
+	struct vm_area_struct *mpnt, *tmp;
+	int retval;
+	unsigned long charge = 0;
+	LIST_HEAD(uf);
+	VMA_ITERATOR(vmi, mm, 0);
+
+	if (mmap_write_lock_killable(oldmm))
+		return -EINTR;
+	flush_cache_dup_mm(oldmm);
+	uprobe_dup_mmap(oldmm, mm);
+	/*
+	 * Not linked in yet - no deadlock potential:
+	 */
+	mmap_write_lock_nested(mm, SINGLE_DEPTH_NESTING);
+
+	/* No ordering required: file already has been exposed. */
+	dup_mm_exe_file(mm, oldmm);
+
+	mm->total_vm = oldmm->total_vm;
+	mm->data_vm = oldmm->data_vm;
+	mm->exec_vm = oldmm->exec_vm;
+	mm->stack_vm = oldmm->stack_vm;
+
+	/* Use __mt_dup() to efficiently build an identical maple tree. */
+	retval = __mt_dup(&oldmm->mm_mt, &mm->mm_mt, GFP_KERNEL);
+	if (unlikely(retval))
+		goto out;
+
+	mt_clear_in_rcu(vmi.mas.tree);
+	for_each_vma(vmi, mpnt) {
+		struct file *file;
+
+		vma_start_write(mpnt);
+		if (mpnt->vm_flags & VM_DONTCOPY) {
+			retval = vma_iter_clear_gfp(&vmi, mpnt->vm_start,
+						    mpnt->vm_end, GFP_KERNEL);
+			if (retval)
+				goto loop_out;
+
+			vm_stat_account(mm, mpnt->vm_flags, -vma_pages(mpnt));
+			continue;
+		}
+		charge = 0;
+		/*
+		 * Don't duplicate many vmas if we've been oom-killed (for
+		 * example)
+		 */
+		if (fatal_signal_pending(current)) {
+			retval = -EINTR;
+			goto loop_out;
+		}
+		if (mpnt->vm_flags & VM_ACCOUNT) {
+			unsigned long len = vma_pages(mpnt);
+
+			if (security_vm_enough_memory_mm(oldmm, len)) /* sic */
+				goto fail_nomem;
+			charge = len;
+		}
+
+		tmp = vm_area_dup(mpnt);
+		if (!tmp)
+			goto fail_nomem;
+
+		/* track_pfn_copy() will later take care of copying internal state. */
+		if (unlikely(tmp->vm_flags & VM_PFNMAP))
+			untrack_pfn_clear(tmp);
+
+		retval = vma_dup_policy(mpnt, tmp);
+		if (retval)
+			goto fail_nomem_policy;
+		tmp->vm_mm = mm;
+		retval = dup_userfaultfd(tmp, &uf);
+		if (retval)
+			goto fail_nomem_anon_vma_fork;
+		if (tmp->vm_flags & VM_WIPEONFORK) {
+			/*
+			 * VM_WIPEONFORK gets a clean slate in the child.
+			 * Don't prepare anon_vma until fault since we don't
+			 * copy page for current vma.
+			 */
+			tmp->anon_vma = NULL;
+		} else if (anon_vma_fork(tmp, mpnt))
+			goto fail_nomem_anon_vma_fork;
+		vm_flags_clear(tmp, VM_LOCKED_MASK);
+		/*
+		 * Copy/update hugetlb private vma information.
+		 */
+		if (is_vm_hugetlb_page(tmp))
+			hugetlb_dup_vma_private(tmp);
+
+		/*
+		 * Link the vma into the MT. After using __mt_dup(), memory
+		 * allocation is not necessary here, so it cannot fail.
+		 */
+		vma_iter_bulk_store(&vmi, tmp);
+
+		mm->map_count++;
+
+		if (tmp->vm_ops && tmp->vm_ops->open)
+			tmp->vm_ops->open(tmp);
+
+		file = tmp->vm_file;
+		if (file) {
+			struct address_space *mapping = file->f_mapping;
+
+			get_file(file);
+			i_mmap_lock_write(mapping);
+			if (vma_is_shared_maywrite(tmp))
+				mapping_allow_writable(mapping);
+			flush_dcache_mmap_lock(mapping);
+			/* insert tmp into the share list, just after mpnt */
+			vma_interval_tree_insert_after(tmp, mpnt,
+					&mapping->i_mmap);
+			flush_dcache_mmap_unlock(mapping);
+			i_mmap_unlock_write(mapping);
+		}
+
+		if (!(tmp->vm_flags & VM_WIPEONFORK))
+			retval = copy_page_range(tmp, mpnt);
+
+		if (retval) {
+			mpnt = vma_next(&vmi);
+			goto loop_out;
+		}
+	}
+	/* a new mm has just been created */
+	retval = arch_dup_mmap(oldmm, mm);
+loop_out:
+	vma_iter_free(&vmi);
+	if (!retval) {
+		mt_set_in_rcu(vmi.mas.tree);
+		ksm_fork(mm, oldmm);
+		khugepaged_fork(mm, oldmm);
+	} else {
+
+		/*
+		 * The entire maple tree has already been duplicated. If the
+		 * mmap duplication fails, mark the failure point with
+		 * XA_ZERO_ENTRY. In exit_mmap(), if this marker is encountered,
+		 * stop releasing VMAs that have not been duplicated after this
+		 * point.
+		 */
+		if (mpnt) {
+			mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
+			mas_store(&vmi.mas, XA_ZERO_ENTRY);
+			/* Avoid OOM iterating a broken tree */
+			set_bit(MMF_OOM_SKIP, &mm->flags);
+		}
+		/*
+		 * The mm_struct is going to exit, but the locks will be dropped
+		 * first.  Set the mm_struct as unstable is advisable as it is
+		 * not fully initialised.
+		 */
+		set_bit(MMF_UNSTABLE, &mm->flags);
+	}
+out:
+	mmap_write_unlock(mm);
+	flush_tlb_mm(oldmm);
+	mmap_write_unlock(oldmm);
+	if (!retval)
+		dup_userfaultfd_complete(&uf);
+	else
+		dup_userfaultfd_fail(&uf);
+	return retval;
+
+fail_nomem_anon_vma_fork:
+	mpol_put(vma_policy(tmp));
+fail_nomem_policy:
+	vm_area_free(tmp);
+fail_nomem:
+	retval = -ENOMEM;
+	vm_unacct_memory(charge);
+	goto loop_out;
 }
-#endif
--- a/mm/nommu.c~mm-move-dup_mmap-to-mm
+++ a/mm/nommu.c
@@ -1874,3 +1874,11 @@ static int __meminit init_admin_reserve(
 	return 0;
 }
 subsys_initcall(init_admin_reserve);
+
+int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
+{
+	mmap_write_lock(oldmm);
+	dup_mm_exe_file(mm, oldmm);
+	mmap_write_unlock(oldmm);
+	return 0;
+}
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-update-page-allocator-section.patch
maintainers-add-mm-reclaim-section.patch

