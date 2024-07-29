Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10D718E744
	for <mm-commits@vger.kernel.org>; Mon, 29 Jul 2024 22:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722290901; cv=none; b=PX5BRIUk2mVzemzeGcJNvF0Hi871rNeoTKuCixNHZuwV6OD5czlK0CI1+wAFDoxdDdvERhOINwvuU1L6yd3SxV1QU97zoBn9x/rEnsUe8ik12QlhM/wrfmxdBT0avEVHLMQEJdsEY8JEKte//Wdrb4/xGua6PVzhmfSmarZRHdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722290901; c=relaxed/simple;
	bh=S304lUYZhqa2umoEr+xWvyNJXsSode7xD//2IerCSWk=;
	h=Date:To:From:Subject:Message-Id; b=eEpyi43ZKKhroATynRtr7g8GUss5vF9yw/tsc+VR5VeLbuS/aDJk/0azOQ813xv8jGlFi66PMz4yDzJKsrERoN7ZlDQwgVZuK1UCi4uqXwASwDfhnPSVDv1etFyrzqr8wRenlWPYL3PxqAPEXeaRSy5k3j/th1Wc05pshkRhtuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DIwk9tP4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DIwk9tP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C68C32786;
	Mon, 29 Jul 2024 22:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722290900;
	bh=S304lUYZhqa2umoEr+xWvyNJXsSode7xD//2IerCSWk=;
	h=Date:To:From:Subject:From;
	b=DIwk9tP4eSQvQHiDLgXg7TQ7tOwhU6iURygaW7HVxd2SDxWeEqJIa1pu67MFogDLX
	 uaGcud/mYF81cs1G4t/tygx692Dy4bzIPh0xQwjYJTu3qzFp3H2dpryyvH2Fcz8gq0
	 zUQwmbogvgse6GqoyaE/AHlOf4VuKswqG2pn69W0=
Date: Mon, 29 Jul 2024 15:08:20 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shuah@kernel.org,rmoar@google.com,Liam.Howlett@oracle.com,kees@kernel.org,jack@suse.cz,ebiederm@xmission.com,davidgow@google.com,brendanhiggins@google.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-vma_shrink-vma_expand-to-internal-header.patch added to mm-unstable branch
Message-Id: <20240729220820.B2C68C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move vma_shrink(), vma_expand() to internal header
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-vma_shrink-vma_expand-to-internal-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-vma_shrink-vma_expand-to-internal-header.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: move vma_shrink(), vma_expand() to internal header
Date: Mon, 29 Jul 2024 12:50:37 +0100

The vma_shrink() and vma_expand() functions are internal VMA manipulation
functions which we ought to abstract for use outside of memory management
code.

To achieve this, we replace shift_arg_pages() in fs/exec.c with an
invocation of a new relocate_vma_down() function implemented in mm/mmap.c,
which enables us to also move move_page_tables() and vma_iter_prev_range()
to internal.h.

The purpose of doing this is to isolate key VMA manipulation functions in
order that we can both abstract them and later render them easily
testable.

Link: https://lkml.kernel.org/r/3cfcd9ec433e032a85f636fdc0d7d98fafbd19c5.1722251717.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Gow <davidgow@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kees Cook <kees@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rae Moar <rmoar@google.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c          |   81 +++----------------------------------------
 include/linux/mm.h |   17 ---------
 mm/internal.h      |   18 +++++++++
 mm/mmap.c          |   81 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 106 insertions(+), 91 deletions(-)

--- a/fs/exec.c~mm-move-vma_shrink-vma_expand-to-internal-header
+++ a/fs/exec.c
@@ -712,80 +712,6 @@ static int copy_strings_kernel(int argc,
 #ifdef CONFIG_MMU
 
 /*
- * During bprm_mm_init(), we create a temporary stack at STACK_TOP_MAX.  Once
- * the binfmt code determines where the new stack should reside, we shift it to
- * its final location.  The process proceeds as follows:
- *
- * 1) Use shift to calculate the new vma endpoints.
- * 2) Extend vma to cover both the old and new ranges.  This ensures the
- *    arguments passed to subsequent functions are consistent.
- * 3) Move vma's page tables to the new range.
- * 4) Free up any cleared pgd range.
- * 5) Shrink the vma to cover only the new range.
- */
-static int shift_arg_pages(struct vm_area_struct *vma, unsigned long shift)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	unsigned long old_start = vma->vm_start;
-	unsigned long old_end = vma->vm_end;
-	unsigned long length = old_end - old_start;
-	unsigned long new_start = old_start - shift;
-	unsigned long new_end = old_end - shift;
-	VMA_ITERATOR(vmi, mm, new_start);
-	struct vm_area_struct *next;
-	struct mmu_gather tlb;
-
-	BUG_ON(new_start > new_end);
-
-	/*
-	 * ensure there are no vmas between where we want to go
-	 * and where we are
-	 */
-	if (vma != vma_next(&vmi))
-		return -EFAULT;
-
-	vma_iter_prev_range(&vmi);
-	/*
-	 * cover the whole range: [new_start, old_end)
-	 */
-	if (vma_expand(&vmi, vma, new_start, old_end, vma->vm_pgoff, NULL))
-		return -ENOMEM;
-
-	/*
-	 * move the page tables downwards, on failure we rely on
-	 * process cleanup to remove whatever mess we made.
-	 */
-	if (length != move_page_tables(vma, old_start,
-				       vma, new_start, length, false, true))
-		return -ENOMEM;
-
-	lru_add_drain();
-	tlb_gather_mmu(&tlb, mm);
-	next = vma_next(&vmi);
-	if (new_end > old_start) {
-		/*
-		 * when the old and new regions overlap clear from new_end.
-		 */
-		free_pgd_range(&tlb, new_end, old_end, new_end,
-			next ? next->vm_start : USER_PGTABLES_CEILING);
-	} else {
-		/*
-		 * otherwise, clean from old_start; this is done to not touch
-		 * the address space in [new_end, old_start) some architectures
-		 * have constraints on va-space that make this illegal (IA64) -
-		 * for the others its just a little faster.
-		 */
-		free_pgd_range(&tlb, old_start, old_end, new_end,
-			next ? next->vm_start : USER_PGTABLES_CEILING);
-	}
-	tlb_finish_mmu(&tlb);
-
-	vma_prev(&vmi);
-	/* Shrink the vma to just the new range */
-	return vma_shrink(&vmi, vma, new_start, new_end, vma->vm_pgoff);
-}
-
-/*
  * Finalizes the stack vm_area_struct. The flags and permissions are updated,
  * the stack is optionally relocated, and some extra space is added.
  */
@@ -877,7 +803,12 @@ int setup_arg_pages(struct linux_binprm
 
 	/* Move stack pages down in memory. */
 	if (stack_shift) {
-		ret = shift_arg_pages(vma, stack_shift);
+		/*
+		 * During bprm_mm_init(), we create a temporary stack at STACK_TOP_MAX.  Once
+		 * the binfmt code determines where the new stack should reside, we shift it to
+		 * its final location.
+		 */
+		ret = relocate_vma_down(vma, stack_shift);
 		if (ret)
 			goto out_unlock;
 	}
--- a/include/linux/mm.h~mm-move-vma_shrink-vma_expand-to-internal-header
+++ a/include/linux/mm.h
@@ -1005,12 +1005,6 @@ static inline struct vm_area_struct *vma
 	return mas_prev(&vmi->mas, 0);
 }
 
-static inline
-struct vm_area_struct *vma_iter_prev_range(struct vma_iterator *vmi)
-{
-	return mas_prev_range(&vmi->mas, 0);
-}
-
 static inline unsigned long vma_iter_addr(struct vma_iterator *vmi)
 {
 	return vmi->mas.index;
@@ -2520,11 +2514,6 @@ int set_page_dirty_lock(struct page *pag
 
 int get_cmdline(struct task_struct *task, char *buffer, int buflen);
 
-extern unsigned long move_page_tables(struct vm_area_struct *vma,
-		unsigned long old_addr, struct vm_area_struct *new_vma,
-		unsigned long new_addr, unsigned long len,
-		bool need_rmap_locks, bool for_stack);
-
 /*
  * Flags used by change_protection().  For now we make it a bitmap so
  * that we can pass in multiple flags just like parameters.  However
@@ -3257,11 +3246,6 @@ void anon_vma_interval_tree_verify(struc
 
 /* mmap.c */
 extern int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin);
-extern int vma_expand(struct vma_iterator *vmi, struct vm_area_struct *vma,
-		      unsigned long start, unsigned long end, pgoff_t pgoff,
-		      struct vm_area_struct *next);
-extern int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
-		       unsigned long start, unsigned long end, pgoff_t pgoff);
 extern struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *);
 extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void unlink_file_vma(struct vm_area_struct *);
@@ -3269,6 +3253,7 @@ extern struct vm_area_struct *copy_vma(s
 	unsigned long addr, unsigned long len, pgoff_t pgoff,
 	bool *need_rmap_locks);
 extern void exit_mmap(struct mm_struct *);
+int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift);
 
 static inline int check_data_rlimit(unsigned long rlim,
 				    unsigned long new,
--- a/mm/internal.h~mm-move-vma_shrink-vma_expand-to-internal-header
+++ a/mm/internal.h
@@ -1305,6 +1305,12 @@ static inline struct vm_area_struct
 			  vma_policy(vma), new_ctx, anon_vma_name(vma));
 }
 
+int vma_expand(struct vma_iterator *vmi, struct vm_area_struct *vma,
+	      unsigned long start, unsigned long end, pgoff_t pgoff,
+	      struct vm_area_struct *next);
+int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
+	       unsigned long start, unsigned long end, pgoff_t pgoff);
+
 enum {
 	/* mark page accessed */
 	FOLL_TOUCH = 1 << 16,
@@ -1528,6 +1534,12 @@ static inline int vma_iter_store_gfp(str
 	return 0;
 }
 
+static inline
+struct vm_area_struct *vma_iter_prev_range(struct vma_iterator *vmi)
+{
+	return mas_prev_range(&vmi->mas, 0);
+}
+
 /*
  * VMA lock generalization
  */
@@ -1639,4 +1651,10 @@ void unlink_file_vma_batch_init(struct u
 void unlink_file_vma_batch_add(struct unlink_vma_file_batch *, struct vm_area_struct *);
 void unlink_file_vma_batch_final(struct unlink_vma_file_batch *);
 
+/* mremap.c */
+unsigned long move_page_tables(struct vm_area_struct *vma,
+	unsigned long old_addr, struct vm_area_struct *new_vma,
+	unsigned long new_addr, unsigned long len,
+	bool need_rmap_locks, bool for_stack);
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/mmap.c~mm-move-vma_shrink-vma_expand-to-internal-header
+++ a/mm/mmap.c
@@ -4088,3 +4088,84 @@ static int __meminit init_reserve_notifi
 	return 0;
 }
 subsys_initcall(init_reserve_notifier);
+
+/*
+ * Relocate a VMA downwards by shift bytes. There cannot be any VMAs between
+ * this VMA and its relocated range, which will now reside at [vma->vm_start -
+ * shift, vma->vm_end - shift).
+ *
+ * This function is almost certainly NOT what you want for anything other than
+ * early executable temporary stack relocation.
+ */
+int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
+{
+	/*
+	 * The process proceeds as follows:
+	 *
+	 * 1) Use shift to calculate the new vma endpoints.
+	 * 2) Extend vma to cover both the old and new ranges.  This ensures the
+	 *    arguments passed to subsequent functions are consistent.
+	 * 3) Move vma's page tables to the new range.
+	 * 4) Free up any cleared pgd range.
+	 * 5) Shrink the vma to cover only the new range.
+	 */
+
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long old_start = vma->vm_start;
+	unsigned long old_end = vma->vm_end;
+	unsigned long length = old_end - old_start;
+	unsigned long new_start = old_start - shift;
+	unsigned long new_end = old_end - shift;
+	VMA_ITERATOR(vmi, mm, new_start);
+	struct vm_area_struct *next;
+	struct mmu_gather tlb;
+
+	BUG_ON(new_start > new_end);
+
+	/*
+	 * ensure there are no vmas between where we want to go
+	 * and where we are
+	 */
+	if (vma != vma_next(&vmi))
+		return -EFAULT;
+
+	vma_iter_prev_range(&vmi);
+	/*
+	 * cover the whole range: [new_start, old_end)
+	 */
+	if (vma_expand(&vmi, vma, new_start, old_end, vma->vm_pgoff, NULL))
+		return -ENOMEM;
+
+	/*
+	 * move the page tables downwards, on failure we rely on
+	 * process cleanup to remove whatever mess we made.
+	 */
+	if (length != move_page_tables(vma, old_start,
+				       vma, new_start, length, false, true))
+		return -ENOMEM;
+
+	lru_add_drain();
+	tlb_gather_mmu(&tlb, mm);
+	next = vma_next(&vmi);
+	if (new_end > old_start) {
+		/*
+		 * when the old and new regions overlap clear from new_end.
+		 */
+		free_pgd_range(&tlb, new_end, old_end, new_end,
+			next ? next->vm_start : USER_PGTABLES_CEILING);
+	} else {
+		/*
+		 * otherwise, clean from old_start; this is done to not touch
+		 * the address space in [new_end, old_start) some architectures
+		 * have constraints on va-space that make this illegal (IA64) -
+		 * for the others its just a little faster.
+		 */
+		free_pgd_range(&tlb, old_start, old_end, new_end,
+			next ? next->vm_start : USER_PGTABLES_CEILING);
+	}
+	tlb_finish_mmu(&tlb);
+
+	vma_prev(&vmi);
+	/* Shrink the vma to just the new range */
+	return vma_shrink(&vmi, vma, new_start, new_end, vma->vm_pgoff);
+}
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch
mm-move-vma_modify-and-helpers-to-internal-header.patch
mm-move-vma_shrink-vma_expand-to-internal-header.patch
mm-move-internal-core-vma-manipulation-functions-to-own-file.patch
maintainers-add-entry-for-new-vma-files.patch
tools-separate-out-shared-radix-tree-components.patch
tools-add-skeleton-code-for-userland-testing-of-vma-logic.patch

