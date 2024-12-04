Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4E51372
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 00:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733272836; cv=none; b=tEEAaxbE3XuCMK0KbukQq7IWIX50RFdO/+gNX9vVOjbT+EyVXw54uoj4Hqz/LL++VufPaQQ/sEj9qugxAL3cshAWSBwdzlbitUMBsxNqgSXna0MFCG5m1GX1V+N69sqW5urcF/YvAjlfIj6CcYN8Mv+0RoWdR7uHUhVfZZZTnrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733272836; c=relaxed/simple;
	bh=PwJitzn+spEJY79QL7/OeA5mdDpV7Ri/DPcRO6rn+Tw=;
	h=Date:To:From:Subject:Message-Id; b=kLcK5N0h2+mxgmcnvCyAoiGLor71oNXhc6BSKsOUixE3WUgltdaUNRvSCJLLT8B5sJOnpeMk0UYg3u+3N6ar2Hf68pCYCVVkbIRcC/hVHJmHSbAr95kEHUvz/B+5708Ne/ZGQasQcMvMOpzxAh+CjjP5lZeOFevNCwMIpE/QFcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qTzpRIDS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qTzpRIDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3976DC4CEDC;
	Wed,  4 Dec 2024 00:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733272833;
	bh=PwJitzn+spEJY79QL7/OeA5mdDpV7Ri/DPcRO6rn+Tw=;
	h=Date:To:From:Subject:From;
	b=qTzpRIDSPGG5Yx+Qw+W6ANSd2b7BYHZM3Se7VjcagNJCN2W9vfjnru77dXNjLAAXV
	 hSleSTJTcG9Sq1AhRvjojTynRn8Y4HlnJA5LGA+93W2w+fc9QItEsX52t0ViZiUwdp
	 TV55Rx3YqdkDe5zjn+xckXeQvHrMT5VSy1pAV69c=
Date: Tue, 03 Dec 2024 16:40:32 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,Liam.Howlett@Oracle.com,kees@kernel.org,jannh@google.com,jack@suse.cz,ebiederm@xmission.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-move-stack-expansion-logic-to-mm-vmac.patch added to mm-unstable branch
Message-Id: <20241204004033.3976DC4CEDC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: move stack expansion logic to mm/vma.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-move-stack-expansion-logic-to-mm-vmac.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-move-stack-expansion-logic-to-mm-vmac.patch

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
Subject: mm/vma: move stack expansion logic to mm/vma.c
Date: Tue, 3 Dec 2024 18:05:11 +0000

We build on previous work making expand_downwards() an entirely internal
function.

This logic is subtle and so it is highly useful to get it into vma.c so we
can then userland unit test.

We must additionally move acct_stack_growth() to vma.c as it is a helper
function used by both expand_downwards() and expand_upwards().

We are also then able to mark anon_vma_interval_tree_pre_update_vma() and
anon_vma_interval_tree_post_update_vma() static as these are no longer
used by anything else.

Link: https://lkml.kernel.org/r/0feb104eff85922019d4fb29280f3afb130c5204.1733248985.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c                        |  205 ----------------------
 mm/vma.c                         |  269 +++++++++++++++++++++++++----
 mm/vma.h                         |   12 -
 tools/testing/vma/vma.c          |    5 
 tools/testing/vma/vma_internal.h |   62 ++++++
 5 files changed, 310 insertions(+), 243 deletions(-)

--- a/mm/mmap.c~mm-vma-move-stack-expansion-logic-to-mm-vmac
+++ a/mm/mmap.c
@@ -879,211 +879,6 @@ find_vma_prev(struct mm_struct *mm, unsi
 	return vma;
 }
 
-/*
- * Verify that the stack growth is acceptable and
- * update accounting. This is shared with both the
- * grow-up and grow-down cases.
- */
-static int acct_stack_growth(struct vm_area_struct *vma,
-			     unsigned long size, unsigned long grow)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	unsigned long new_start;
-
-	/* address space limit tests */
-	if (!may_expand_vm(mm, vma->vm_flags, grow))
-		return -ENOMEM;
-
-	/* Stack limit test */
-	if (size > rlimit(RLIMIT_STACK))
-		return -ENOMEM;
-
-	/* mlock limit tests */
-	if (!mlock_future_ok(mm, vma->vm_flags, grow << PAGE_SHIFT))
-		return -ENOMEM;
-
-	/* Check to ensure the stack will not grow into a hugetlb-only region */
-	new_start = (vma->vm_flags & VM_GROWSUP) ? vma->vm_start :
-			vma->vm_end - size;
-	if (is_hugepage_only_range(vma->vm_mm, new_start, size))
-		return -EFAULT;
-
-	/*
-	 * Overcommit..  This must be the final test, as it will
-	 * update security statistics.
-	 */
-	if (security_vm_enough_memory_mm(mm, grow))
-		return -ENOMEM;
-
-	return 0;
-}
-
-#if defined(CONFIG_STACK_GROWSUP)
-/*
- * PA-RISC uses this for its stack.
- * vma is the last one with address > vma->vm_end.  Have to extend vma.
- */
-static int expand_upwards(struct vm_area_struct *vma, unsigned long address)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	struct vm_area_struct *next;
-	unsigned long gap_addr;
-	int error = 0;
-	VMA_ITERATOR(vmi, mm, vma->vm_start);
-
-	if (!(vma->vm_flags & VM_GROWSUP))
-		return -EFAULT;
-
-	mmap_assert_write_locked(mm);
-
-	/* Guard against exceeding limits of the address space. */
-	address &= PAGE_MASK;
-	if (address >= (TASK_SIZE & PAGE_MASK))
-		return -ENOMEM;
-	address += PAGE_SIZE;
-
-	/* Enforce stack_guard_gap */
-	gap_addr = address + stack_guard_gap;
-
-	/* Guard against overflow */
-	if (gap_addr < address || gap_addr > TASK_SIZE)
-		gap_addr = TASK_SIZE;
-
-	next = find_vma_intersection(mm, vma->vm_end, gap_addr);
-	if (next && vma_is_accessible(next)) {
-		if (!(next->vm_flags & VM_GROWSUP))
-			return -ENOMEM;
-		/* Check that both stack segments have the same anon_vma? */
-	}
-
-	if (next)
-		vma_iter_prev_range_limit(&vmi, address);
-
-	vma_iter_config(&vmi, vma->vm_start, address);
-	if (vma_iter_prealloc(&vmi, vma))
-		return -ENOMEM;
-
-	/* We must make sure the anon_vma is allocated. */
-	if (unlikely(anon_vma_prepare(vma))) {
-		vma_iter_free(&vmi);
-		return -ENOMEM;
-	}
-
-	/* Lock the VMA before expanding to prevent concurrent page faults */
-	vma_start_write(vma);
-	/* We update the anon VMA tree. */
-	anon_vma_lock_write(vma->anon_vma);
-
-	/* Somebody else might have raced and expanded it already */
-	if (address > vma->vm_end) {
-		unsigned long size, grow;
-
-		size = address - vma->vm_start;
-		grow = (address - vma->vm_end) >> PAGE_SHIFT;
-
-		error = -ENOMEM;
-		if (vma->vm_pgoff + (size >> PAGE_SHIFT) >= vma->vm_pgoff) {
-			error = acct_stack_growth(vma, size, grow);
-			if (!error) {
-				if (vma->vm_flags & VM_LOCKED)
-					mm->locked_vm += grow;
-				vm_stat_account(mm, vma->vm_flags, grow);
-				anon_vma_interval_tree_pre_update_vma(vma);
-				vma->vm_end = address;
-				/* Overwrite old entry in mtree. */
-				vma_iter_store(&vmi, vma);
-				anon_vma_interval_tree_post_update_vma(vma);
-
-				perf_event_mmap(vma);
-			}
-		}
-	}
-	anon_vma_unlock_write(vma->anon_vma);
-	vma_iter_free(&vmi);
-	validate_mm(mm);
-	return error;
-}
-#endif /* CONFIG_STACK_GROWSUP */
-
-/*
- * vma is the first one with address < vma->vm_start.  Have to extend vma.
- * mmap_lock held for writing.
- */
-static int expand_downwards(struct vm_area_struct *vma, unsigned long address)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	struct vm_area_struct *prev;
-	int error = 0;
-	VMA_ITERATOR(vmi, mm, vma->vm_start);
-
-	if (!(vma->vm_flags & VM_GROWSDOWN))
-		return -EFAULT;
-
-	mmap_assert_write_locked(mm);
-
-	address &= PAGE_MASK;
-	if (address < mmap_min_addr || address < FIRST_USER_ADDRESS)
-		return -EPERM;
-
-	/* Enforce stack_guard_gap */
-	prev = vma_prev(&vmi);
-	/* Check that both stack segments have the same anon_vma? */
-	if (prev) {
-		if (!(prev->vm_flags & VM_GROWSDOWN) &&
-		    vma_is_accessible(prev) &&
-		    (address - prev->vm_end < stack_guard_gap))
-			return -ENOMEM;
-	}
-
-	if (prev)
-		vma_iter_next_range_limit(&vmi, vma->vm_start);
-
-	vma_iter_config(&vmi, address, vma->vm_end);
-	if (vma_iter_prealloc(&vmi, vma))
-		return -ENOMEM;
-
-	/* We must make sure the anon_vma is allocated. */
-	if (unlikely(anon_vma_prepare(vma))) {
-		vma_iter_free(&vmi);
-		return -ENOMEM;
-	}
-
-	/* Lock the VMA before expanding to prevent concurrent page faults */
-	vma_start_write(vma);
-	/* We update the anon VMA tree. */
-	anon_vma_lock_write(vma->anon_vma);
-
-	/* Somebody else might have raced and expanded it already */
-	if (address < vma->vm_start) {
-		unsigned long size, grow;
-
-		size = vma->vm_end - address;
-		grow = (vma->vm_start - address) >> PAGE_SHIFT;
-
-		error = -ENOMEM;
-		if (grow <= vma->vm_pgoff) {
-			error = acct_stack_growth(vma, size, grow);
-			if (!error) {
-				if (vma->vm_flags & VM_LOCKED)
-					mm->locked_vm += grow;
-				vm_stat_account(mm, vma->vm_flags, grow);
-				anon_vma_interval_tree_pre_update_vma(vma);
-				vma->vm_start = address;
-				vma->vm_pgoff -= grow;
-				/* Overwrite old entry in mtree. */
-				vma_iter_store(&vmi, vma);
-				anon_vma_interval_tree_post_update_vma(vma);
-
-				perf_event_mmap(vma);
-			}
-		}
-	}
-	anon_vma_unlock_write(vma->anon_vma);
-	vma_iter_free(&vmi);
-	validate_mm(mm);
-	return error;
-}
-
 /* enforced gap between the expanding stack and other mappings. */
 unsigned long stack_guard_gap = 256UL<<PAGE_SHIFT;
 
--- a/mm/vma.c~mm-vma-move-stack-expansion-logic-to-mm-vmac
+++ a/mm/vma.c
@@ -203,6 +203,38 @@ static void __remove_shared_vm_struct(st
 }
 
 /*
+ * vma has some anon_vma assigned, and is already inserted on that
+ * anon_vma's interval trees.
+ *
+ * Before updating the vma's vm_start / vm_end / vm_pgoff fields, the
+ * vma must be removed from the anon_vma's interval trees using
+ * anon_vma_interval_tree_pre_update_vma().
+ *
+ * After the update, the vma will be reinserted using
+ * anon_vma_interval_tree_post_update_vma().
+ *
+ * The entire update must be protected by exclusive mmap_lock and by
+ * the root anon_vma's mutex.
+ */
+static void
+anon_vma_interval_tree_pre_update_vma(struct vm_area_struct *vma)
+{
+	struct anon_vma_chain *avc;
+
+	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
+		anon_vma_interval_tree_remove(avc, &avc->anon_vma->rb_root);
+}
+
+static void
+anon_vma_interval_tree_post_update_vma(struct vm_area_struct *vma)
+{
+	struct anon_vma_chain *avc;
+
+	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
+		anon_vma_interval_tree_insert(avc, &avc->anon_vma->rb_root);
+}
+
+/*
  * vma_prepare() - Helper function for handling locking VMAs prior to altering
  * @vp: The initialized vma_prepare struct
  */
@@ -511,38 +543,6 @@ static int split_vma(struct vma_iterator
 }
 
 /*
- * vma has some anon_vma assigned, and is already inserted on that
- * anon_vma's interval trees.
- *
- * Before updating the vma's vm_start / vm_end / vm_pgoff fields, the
- * vma must be removed from the anon_vma's interval trees using
- * anon_vma_interval_tree_pre_update_vma().
- *
- * After the update, the vma will be reinserted using
- * anon_vma_interval_tree_post_update_vma().
- *
- * The entire update must be protected by exclusive mmap_lock and by
- * the root anon_vma's mutex.
- */
-void
-anon_vma_interval_tree_pre_update_vma(struct vm_area_struct *vma)
-{
-	struct anon_vma_chain *avc;
-
-	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-		anon_vma_interval_tree_remove(avc, &avc->anon_vma->rb_root);
-}
-
-void
-anon_vma_interval_tree_post_update_vma(struct vm_area_struct *vma)
-{
-	struct anon_vma_chain *avc;
-
-	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-		anon_vma_interval_tree_insert(avc, &avc->anon_vma->rb_root);
-}
-
-/*
  * dup_anon_vma() - Helper function to duplicate anon_vma
  * @dst: The destination VMA
  * @src: The source VMA
@@ -2669,3 +2669,208 @@ retry:
 
 	return gap;
 }
+
+/*
+ * Verify that the stack growth is acceptable and
+ * update accounting. This is shared with both the
+ * grow-up and grow-down cases.
+ */
+static int acct_stack_growth(struct vm_area_struct *vma,
+			     unsigned long size, unsigned long grow)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long new_start;
+
+	/* address space limit tests */
+	if (!may_expand_vm(mm, vma->vm_flags, grow))
+		return -ENOMEM;
+
+	/* Stack limit test */
+	if (size > rlimit(RLIMIT_STACK))
+		return -ENOMEM;
+
+	/* mlock limit tests */
+	if (!mlock_future_ok(mm, vma->vm_flags, grow << PAGE_SHIFT))
+		return -ENOMEM;
+
+	/* Check to ensure the stack will not grow into a hugetlb-only region */
+	new_start = (vma->vm_flags & VM_GROWSUP) ? vma->vm_start :
+			vma->vm_end - size;
+	if (is_hugepage_only_range(vma->vm_mm, new_start, size))
+		return -EFAULT;
+
+	/*
+	 * Overcommit..  This must be the final test, as it will
+	 * update security statistics.
+	 */
+	if (security_vm_enough_memory_mm(mm, grow))
+		return -ENOMEM;
+
+	return 0;
+}
+
+#if defined(CONFIG_STACK_GROWSUP)
+/*
+ * PA-RISC uses this for its stack.
+ * vma is the last one with address > vma->vm_end.  Have to extend vma.
+ */
+int expand_upwards(struct vm_area_struct *vma, unsigned long address)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct vm_area_struct *next;
+	unsigned long gap_addr;
+	int error = 0;
+	VMA_ITERATOR(vmi, mm, vma->vm_start);
+
+	if (!(vma->vm_flags & VM_GROWSUP))
+		return -EFAULT;
+
+	mmap_assert_write_locked(mm);
+
+	/* Guard against exceeding limits of the address space. */
+	address &= PAGE_MASK;
+	if (address >= (TASK_SIZE & PAGE_MASK))
+		return -ENOMEM;
+	address += PAGE_SIZE;
+
+	/* Enforce stack_guard_gap */
+	gap_addr = address + stack_guard_gap;
+
+	/* Guard against overflow */
+	if (gap_addr < address || gap_addr > TASK_SIZE)
+		gap_addr = TASK_SIZE;
+
+	next = find_vma_intersection(mm, vma->vm_end, gap_addr);
+	if (next && vma_is_accessible(next)) {
+		if (!(next->vm_flags & VM_GROWSUP))
+			return -ENOMEM;
+		/* Check that both stack segments have the same anon_vma? */
+	}
+
+	if (next)
+		vma_iter_prev_range_limit(&vmi, address);
+
+	vma_iter_config(&vmi, vma->vm_start, address);
+	if (vma_iter_prealloc(&vmi, vma))
+		return -ENOMEM;
+
+	/* We must make sure the anon_vma is allocated. */
+	if (unlikely(anon_vma_prepare(vma))) {
+		vma_iter_free(&vmi);
+		return -ENOMEM;
+	}
+
+	/* Lock the VMA before expanding to prevent concurrent page faults */
+	vma_start_write(vma);
+	/* We update the anon VMA tree. */
+	anon_vma_lock_write(vma->anon_vma);
+
+	/* Somebody else might have raced and expanded it already */
+	if (address > vma->vm_end) {
+		unsigned long size, grow;
+
+		size = address - vma->vm_start;
+		grow = (address - vma->vm_end) >> PAGE_SHIFT;
+
+		error = -ENOMEM;
+		if (vma->vm_pgoff + (size >> PAGE_SHIFT) >= vma->vm_pgoff) {
+			error = acct_stack_growth(vma, size, grow);
+			if (!error) {
+				if (vma->vm_flags & VM_LOCKED)
+					mm->locked_vm += grow;
+				vm_stat_account(mm, vma->vm_flags, grow);
+				anon_vma_interval_tree_pre_update_vma(vma);
+				vma->vm_end = address;
+				/* Overwrite old entry in mtree. */
+				vma_iter_store(&vmi, vma);
+				anon_vma_interval_tree_post_update_vma(vma);
+
+				perf_event_mmap(vma);
+			}
+		}
+	}
+	anon_vma_unlock_write(vma->anon_vma);
+	vma_iter_free(&vmi);
+	validate_mm(mm);
+	return error;
+}
+#endif /* CONFIG_STACK_GROWSUP */
+
+/*
+ * vma is the first one with address < vma->vm_start.  Have to extend vma.
+ * mmap_lock held for writing.
+ */
+int expand_downwards(struct vm_area_struct *vma, unsigned long address)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct vm_area_struct *prev;
+	int error = 0;
+	VMA_ITERATOR(vmi, mm, vma->vm_start);
+
+	if (!(vma->vm_flags & VM_GROWSDOWN))
+		return -EFAULT;
+
+	mmap_assert_write_locked(mm);
+
+	address &= PAGE_MASK;
+	if (address < mmap_min_addr || address < FIRST_USER_ADDRESS)
+		return -EPERM;
+
+	/* Enforce stack_guard_gap */
+	prev = vma_prev(&vmi);
+	/* Check that both stack segments have the same anon_vma? */
+	if (prev) {
+		if (!(prev->vm_flags & VM_GROWSDOWN) &&
+		    vma_is_accessible(prev) &&
+		    (address - prev->vm_end < stack_guard_gap))
+			return -ENOMEM;
+	}
+
+	if (prev)
+		vma_iter_next_range_limit(&vmi, vma->vm_start);
+
+	vma_iter_config(&vmi, address, vma->vm_end);
+	if (vma_iter_prealloc(&vmi, vma))
+		return -ENOMEM;
+
+	/* We must make sure the anon_vma is allocated. */
+	if (unlikely(anon_vma_prepare(vma))) {
+		vma_iter_free(&vmi);
+		return -ENOMEM;
+	}
+
+	/* Lock the VMA before expanding to prevent concurrent page faults */
+	vma_start_write(vma);
+	/* We update the anon VMA tree. */
+	anon_vma_lock_write(vma->anon_vma);
+
+	/* Somebody else might have raced and expanded it already */
+	if (address < vma->vm_start) {
+		unsigned long size, grow;
+
+		size = vma->vm_end - address;
+		grow = (vma->vm_start - address) >> PAGE_SHIFT;
+
+		error = -ENOMEM;
+		if (grow <= vma->vm_pgoff) {
+			error = acct_stack_growth(vma, size, grow);
+			if (!error) {
+				if (vma->vm_flags & VM_LOCKED)
+					mm->locked_vm += grow;
+				vm_stat_account(mm, vma->vm_flags, grow);
+				anon_vma_interval_tree_pre_update_vma(vma);
+				vma->vm_start = address;
+				vma->vm_pgoff -= grow;
+				/* Overwrite old entry in mtree. */
+				vma_iter_store(&vmi, vma);
+				anon_vma_interval_tree_post_update_vma(vma);
+
+				perf_event_mmap(vma);
+			}
+		}
+	}
+	anon_vma_unlock_write(vma->anon_vma);
+	vma_iter_free(&vmi);
+	validate_mm(mm);
+	return error;
+}
--- a/mm/vma.h~mm-vma-move-stack-expansion-logic-to-mm-vmac
+++ a/mm/vma.h
@@ -139,12 +139,6 @@ void validate_mm(struct mm_struct *mm);
 #define validate_mm(mm) do { } while (0)
 #endif
 
-/* Required for expand_downwards(). */
-void anon_vma_interval_tree_pre_update_vma(struct vm_area_struct *vma);
-
-/* Required for expand_downwards(). */
-void anon_vma_interval_tree_post_update_vma(struct vm_area_struct *vma);
-
 int vma_expand(struct vma_merge_struct *vmg);
 int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	       unsigned long start, unsigned long end, pgoff_t pgoff);
@@ -478,4 +472,10 @@ static inline bool can_modify_vma_madv(s
 
 #endif
 
+#if defined(CONFIG_STACK_GROWSUP)
+int expand_upwards(struct vm_area_struct *vma, unsigned long address);
+#endif
+
+int expand_downwards(struct vm_area_struct *vma, unsigned long address);
+
 #endif	/* __MM_VMA_H */
--- a/tools/testing/vma/vma.c~mm-vma-move-stack-expansion-logic-to-mm-vmac
+++ a/tools/testing/vma/vma.c
@@ -53,6 +53,11 @@ struct task_struct *get_current(void)
 	return &__current;
 }
 
+unsigned long rlimit(unsigned int limit)
+{
+	return (unsigned long)-1;
+}
+
 /* Helper function to simply allocate a VMA. */
 static struct vm_area_struct *alloc_vma(struct mm_struct *mm,
 					unsigned long start,
--- a/tools/testing/vma/vma_internal.h~mm-vma-move-stack-expansion-logic-to-mm-vmac
+++ a/tools/testing/vma/vma_internal.h
@@ -79,6 +79,11 @@ extern unsigned long dac_mmap_min_addr;
 
 #define VM_STARTGAP_FLAGS (VM_GROWSDOWN | VM_SHADOW_STACK)
 
+#define RLIMIT_STACK		3	/* max stack size */
+#define RLIMIT_MEMLOCK		8	/* max locked-in-memory address space */
+
+#define CAP_IPC_LOCK         14
+
 #ifdef CONFIG_64BIT
 /* VM is sealed, in vm_flags */
 #define VM_SEALED	_BITUL(63)
@@ -478,6 +483,8 @@ static inline void vma_mark_detached(str
 
 extern const struct vm_operations_struct vma_dummy_vm_ops;
 
+extern unsigned long rlimit(unsigned int limit);
+
 static inline void vma_init(struct vm_area_struct *vma, struct mm_struct *mm)
 {
 	memset(vma, 0, sizeof(*vma));
@@ -1114,4 +1121,59 @@ static inline unsigned long vm_end_gap(s
 	return vm_end;
 }
 
+static inline int is_hugepage_only_range(struct mm_struct *mm,
+					unsigned long addr, unsigned long len)
+{
+	return 0;
+}
+
+static inline bool vma_is_accessible(struct vm_area_struct *vma)
+{
+	return vma->vm_flags & VM_ACCESS_FLAGS;
+}
+
+static inline bool capable(int cap)
+{
+	return true;
+}
+
+static inline bool mlock_future_ok(struct mm_struct *mm, unsigned long flags,
+			unsigned long bytes)
+{
+	unsigned long locked_pages, limit_pages;
+
+	if (!(flags & VM_LOCKED) || capable(CAP_IPC_LOCK))
+		return true;
+
+	locked_pages = bytes >> PAGE_SHIFT;
+	locked_pages += mm->locked_vm;
+
+	limit_pages = rlimit(RLIMIT_MEMLOCK);
+	limit_pages >>= PAGE_SHIFT;
+
+	return locked_pages <= limit_pages;
+}
+
+static inline int __anon_vma_prepare(struct vm_area_struct *vma)
+{
+	struct anon_vma *anon_vma = calloc(1, sizeof(struct anon_vma));
+
+	if (!anon_vma)
+		return -ENOMEM;
+
+	anon_vma->root = anon_vma;
+	vma->anon_vma = anon_vma;
+
+	return 0;
+}
+
+static inline int anon_vma_prepare(struct vm_area_struct *vma)
+{
+	if (likely(vma->anon_vma))
+		return 0;
+
+	return __anon_vma_prepare(vma);
+}
+
+
 #endif	/* __MM_VMA_INTERNAL_H */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
mm-correct-typo-in-mmap_state-macro.patch
docs-mm-add-vma-locks-documentation.patch
mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch

