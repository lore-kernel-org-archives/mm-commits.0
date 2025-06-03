Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D023FE4
	for <mm-commits@vger.kernel.org>; Tue,  3 Jun 2025 02:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748919146; cv=none; b=uvyyiuhGfZ01Hzk6mjFZiQD3+cIsb/eC7jgqLfjS4sOSxHB8ls6ghYY4TkjlaS+LOiz0ywPkQ3FOfs2rItOkLmM1imi5MkkvmHBEpe5mEBKiwl7Qp0zxmXh/jsf/6xgpH1iYsmDitIWbOv4hggk7HjG7uzyKA+QF6THWPICIHE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748919146; c=relaxed/simple;
	bh=oYbBJ9anGcZUYlN8dfROV5qR1jNDuDoP0ry0hJw2STM=;
	h=Date:To:From:Subject:Message-Id; b=hsQ/0JUBSTN9Bq2dSlnSBwE/rVbvaHEEJ+gd1Vs60b2L4IY0bN6JNdGO/TfHd9l6rlBUGYSZbXb/0xG7MPwDXLIlBrRr1y7p2MkPgnF0bYVlVTifwn9ZqyBbuimPN1OCxY+RKDx4CA+FuAm7R0OYiIS9C5eNVSrQUFgKxBAZ7P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YieLXZlS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YieLXZlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32A7C4CEEB;
	Tue,  3 Jun 2025 02:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748919146;
	bh=oYbBJ9anGcZUYlN8dfROV5qR1jNDuDoP0ry0hJw2STM=;
	h=Date:To:From:Subject:From;
	b=YieLXZlSx3cUT4+2zhC9yJTaaACe0TDuzcHOOeA1odCuzwzeDWifFbc6U7yY6tBnq
	 9yjgb1+Rn3pIRYN1WcTP4GwFIMck+csCzTMbz7zl4MkOVAUW2nOBrtBDuXXosJ35pS
	 BGyuy+3blAYTXaEKTz3j2j8ikCLnnVneDbEwD93g=
Date: Mon, 02 Jun 2025 19:52:25 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,viro@zeniv.linux.org.uk,vbabka@suse.cz,shr@devkernel.io,Liam.Howlett@oracle.com,jannh@google.com,jack@suse.cz,david@redhat.com,chengming.zhou@linux.dev,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch added to mm-new branch
Message-Id: <20250603025225.E32A7C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: prevent KSM from breaking VMA merging for new VMAs
has been added to the -mm mm-new branch.  Its filename is
     mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm: prevent KSM from breaking VMA merging for new VMAs
Date: Thu, 29 May 2025 18:15:47 +0100

If a user wishes to enable KSM mergeability for an entire process and all
fork/exec'd processes that come after it, they use the prctl()
PR_SET_MEMORY_MERGE operation.

This defaults all newly mapped VMAs to have the VM_MERGEABLE VMA flag set
(in order to indicate they are KSM mergeable), as well as setting this
flag for all existing VMAs and propagating this across fork/exec.

However it also breaks VMA merging for new VMAs, both in the process and
all forked (and fork/exec'd) child processes.

This is because when a new mapping is proposed, the flags specified will
never have VM_MERGEABLE set.  However all adjacent VMAs will already have
VM_MERGEABLE set, rendering VMAs unmergeable by default.

To work around this, we try to set the VM_MERGEABLE flag prior to
attempting a merge.  In the case of brk() this can always be done.

However on mmap() things are more complicated - while KSM is not supported
for MAP_SHARED file-backed mappings, it is supported for MAP_PRIVATE
file-backed mappings.

These mappings may have deprecated .mmap() callbacks specified which
could, in theory, adjust flags and thus KSM eligibility.

So we check to determine whether this is possible.  If not, we set
VM_MERGEABLE prior to the merge attempt on mmap(), otherwise we retain the
previous behaviour.

This fixes VMA merging for all new anonymous mappings, which covers the
majority of real-world cases, so we should see a significant improvement
in VMA mergeability.

For MAP_PRIVATE file-backed mappings, those which implement the
.mmap_prepare() hook and shmem are both known to be safe, so we allow
these, disallowing all other cases.

Also add stubs for newly introduced function invocations to VMA userland
testing.

Link: https://lkml.kernel.org/r/3ba660af716d87a18ca5b4e635f2101edeb56340.1748537921.git.lorenzo.stoakes@oracle.com
Fixes: d7597f59d1d3 ("mm: add new api to enable ksm per process") # please no backport!
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xu Xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h              |    8 +++--
 mm/ksm.c                         |   18 +++++++----
 mm/vma.c                         |   44 +++++++++++++++++++++++++++--
 tools/testing/vma/vma_internal.h |   11 +++++++
 4 files changed, 70 insertions(+), 11 deletions(-)

--- a/include/linux/ksm.h~mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas
+++ a/include/linux/ksm.h
@@ -17,8 +17,8 @@
 #ifdef CONFIG_KSM
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, int advice, unsigned long *vm_flags);
-
-void ksm_add_vma(struct vm_area_struct *vma);
+vm_flags_t ksm_vma_flags(const struct mm_struct *mm, const struct file *file,
+			 vm_flags_t vm_flags);
 int ksm_enable_merge_any(struct mm_struct *mm);
 int ksm_disable_merge_any(struct mm_struct *mm);
 int ksm_disable(struct mm_struct *mm);
@@ -97,8 +97,10 @@ bool ksm_process_mergeable(struct mm_str
 
 #else  /* !CONFIG_KSM */
 
-static inline void ksm_add_vma(struct vm_area_struct *vma)
+static inline vm_flags_t ksm_vma_flags(const struct mm_struct *mm,
+		const struct file *file, vm_flags_t vm_flags)
 {
+	return vm_flags;
 }
 
 static inline int ksm_disable(struct mm_struct *mm)
--- a/mm/ksm.c~mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas
+++ a/mm/ksm.c
@@ -2731,16 +2731,22 @@ static int __ksm_del_vma(struct vm_area_
 	return 0;
 }
 /**
- * ksm_add_vma - Mark vma as mergeable if compatible
+ * ksm_vma_flags - Update VMA flags to mark as mergeable if compatible
  *
- * @vma:  Pointer to vma
+ * @mm:       Proposed VMA's mm_struct
+ * @file:     Proposed VMA's file-backed mapping, if any.
+ * @vm_flags: Proposed VMA"s flags.
+ *
+ * Returns: @vm_flags possibly updated to mark mergeable.
  */
-void ksm_add_vma(struct vm_area_struct *vma)
+vm_flags_t ksm_vma_flags(const struct mm_struct *mm, const struct file *file,
+			 vm_flags_t vm_flags)
 {
-	struct mm_struct *mm = vma->vm_mm;
+	if (test_bit(MMF_VM_MERGE_ANY, &mm->flags) &&
+	    __ksm_should_add_vma(file, vm_flags))
+		vm_flags |= VM_MERGEABLE;
 
-	if (test_bit(MMF_VM_MERGE_ANY, &mm->flags))
-		__ksm_add_vma(vma);
+	return vm_flags;
 }
 
 static void ksm_add_vmas(struct mm_struct *mm)
--- a/mm/vma.c~mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas
+++ a/mm/vma.c
@@ -2504,7 +2504,6 @@ static int __mmap_new_vma(struct mmap_st
 	 */
 	if (!vma_is_anonymous(vma))
 		khugepaged_enter_vma(vma, map->flags);
-	ksm_add_vma(vma);
 	*vmap = vma;
 	return 0;
 
@@ -2607,6 +2606,40 @@ static void set_vma_user_defined_fields(
 	vma->vm_private_data = map->vm_private_data;
 }
 
+static void update_ksm_flags(struct mmap_state *map)
+{
+	map->flags = ksm_vma_flags(map->mm, map->file, map->flags);
+}
+
+/*
+ * Are we guaranteed no driver can change state such as to preclude KSM merging?
+ * If so, let's set the KSM mergeable flag early so we don't break VMA merging.
+ */
+static bool can_set_ksm_flags_early(struct mmap_state *map)
+{
+	struct file *file = map->file;
+
+	/* Anonymous mappings have no driver which can change them. */
+	if (!file)
+		return true;
+
+	/*
+	 * If .mmap_prepare() is specified, then the driver will have already
+	 * manipulated state prior to updating KSM flags. So no need to worry
+	 * about mmap callbacks modifying VMA flags after the KSM flag has been
+	 * updated here, which could otherwise affect KSM eligibility.
+	 */
+	if (file->f_op->mmap_prepare)
+		return true;
+
+	/* shmem is safe. */
+	if (shmem_file(file))
+		return true;
+
+	/* Any other .mmap callback is not safe. */
+	return false;
+}
+
 static unsigned long __mmap_region(struct file *file, unsigned long addr,
 		unsigned long len, vm_flags_t vm_flags, unsigned long pgoff,
 		struct list_head *uf)
@@ -2617,6 +2650,7 @@ static unsigned long __mmap_region(struc
 	bool have_mmap_prepare = file && file->f_op->mmap_prepare;
 	VMA_ITERATOR(vmi, mm, addr);
 	MMAP_STATE(map, mm, &vmi, addr, len, pgoff, vm_flags, file);
+	bool check_ksm_early = can_set_ksm_flags_early(&map);
 
 	error = __mmap_prepare(&map, uf);
 	if (!error && have_mmap_prepare)
@@ -2624,6 +2658,9 @@ static unsigned long __mmap_region(struc
 	if (error)
 		goto abort_munmap;
 
+	if (check_ksm_early)
+		update_ksm_flags(&map);
+
 	/* Attempt to merge with adjacent VMAs... */
 	if (map.prev || map.next) {
 		VMG_MMAP_STATE(vmg, &map, /* vma = */ NULL);
@@ -2633,6 +2670,9 @@ static unsigned long __mmap_region(struc
 
 	/* ...but if we can't, allocate a new VMA. */
 	if (!vma) {
+		if (!check_ksm_early)
+			update_ksm_flags(&map);
+
 		error = __mmap_new_vma(&map, &vma);
 		if (error)
 			goto unacct_error;
@@ -2735,6 +2775,7 @@ int do_brk_flags(struct vma_iterator *vm
 	 * Note: This happens *after* clearing old mappings in some code paths.
 	 */
 	flags |= VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
+	flags = ksm_vma_flags(mm, NULL, flags);
 	if (!may_expand_vm(mm, flags, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
@@ -2778,7 +2819,6 @@ int do_brk_flags(struct vma_iterator *vm
 
 	mm->map_count++;
 	validate_mm(mm);
-	ksm_add_vma(vma);
 out:
 	perf_event_mmap(vma);
 	mm->total_vm += len >> PAGE_SHIFT;
--- a/tools/testing/vma/vma_internal.h~mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas
+++ a/tools/testing/vma/vma_internal.h
@@ -1468,4 +1468,15 @@ static inline void fixup_hugetlb_reserva
 	(void)vma;
 }
 
+static inline bool shmem_file(struct file *)
+{
+	return false;
+}
+
+static inline vm_flags_t ksm_vma_flags(const struct mm_struct *, const struct file *,
+			 vm_flags_t vm_flags)
+{
+	return vm_flags;
+}
+
 #endif	/* __MM_VMA_INTERNAL_H */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

kvm-s390-rename-prot_none-to-prot_type_dummy.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch

