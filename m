Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BE22905
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126197; cv=none; b=fdlWXuD/6EPob/8J7CKA6SnjN1YNLmvkjkrJFZBtCf3GsoafyPlx7AuaQ9kvm45duDfunMhkq7yLTwzVi51WNSFwk+ABDrrbPdNODPxAlU4gxcRXtrM9FxQ+fFeN7rxX1LGiQSau7vXaHgp8/b7SJS6bkIheYaRFQQNnmV5f9vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126197; c=relaxed/simple;
	bh=+htCRZBEcbh0vIAkN13vIeZqivgx8/iuhtX5Zs8WWzA=;
	h=Date:To:From:Subject:Message-Id; b=hSD7LsAhMiTVd0KbjrWuC32hYGyWtkpgvpRJZ4KShnQCgLXkjLS/15svdZ9U3TCRbqJWgNyqFNXWDRZEwrmVnehS9pObu6hlRiR7GPP6X/EPtF6ad2jgWhqMh8Ly/kgbh4QuIOCrTrX7AwnCd6ebI6pFUYqwyt9oRixXoOtsBYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vu9cTMR2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vu9cTMR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D1DC4CEE3;
	Thu, 10 Jul 2025 05:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126197;
	bh=+htCRZBEcbh0vIAkN13vIeZqivgx8/iuhtX5Zs8WWzA=;
	h=Date:To:From:Subject:From;
	b=vu9cTMR2rvhJvvxcVG6yCW9GLR7zccTSthGkoPc7yklBrEJn9S8wFNEDZCLdIGOYG
	 JRpnfMRdEO29W0JWi6abVcF/4MXwRmY9kQM9JNhrx9ajFwtCaNmTMyLoVisd3mkNAb
	 4JiwUaZ/r6qooKWEIICPAkkYBsrHBNuM2sXmEbKo=
Date: Wed, 09 Jul 2025 22:43:16 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,viro@zeniv.linux.org.uk,vbabka@suse.cz,shr@devkernel.io,Liam.Howlett@oracle.com,jannh@google.com,jack@suse.cz,david@redhat.com,chengming.zhou@linux.dev,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch removed from -mm tree
Message-Id: <20250710054317.54D1DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: prevent KSM from breaking VMA merging for new VMAs
has been removed from the -mm tree.  Its filename was
     mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[lorenzo.stoakes@oracle.com: correctly invoke late KSM check after mmap hook]
  Link: https://lkml.kernel.org/r/5861f8f6-cf5a-4d82-a062-139fb3f9cddb@lucifer.local
Link: https://lkml.kernel.org/r/3ba660af716d87a18ca5b4e635f2101edeb56340.1748537921.git.lorenzo.stoakes@oracle.com
Fixes: d7597f59d1d3 ("mm: add new api to enable ksm per process") # please no backport!
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h              |    8 ++--
 mm/ksm.c                         |   18 ++++++----
 mm/vma.c                         |   51 +++++++++++++++++++++++++++--
 tools/testing/vma/vma_internal.h |   11 ++++++
 4 files changed, 77 insertions(+), 11 deletions(-)

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
@@ -32,6 +32,9 @@ struct mmap_state {
 	struct vma_munmap_struct vms;
 	struct ma_state mas_detach;
 	struct maple_tree mt_detach;
+
+	/* Determine if we can check KSM flags early in mmap() logic. */
+	bool check_ksm_early;
 };
 
 #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, flags_, file_) \
@@ -2320,6 +2323,11 @@ static void vms_abort_munmap_vmas(struct
 	vms_complete_munmap_vmas(vms, mas_detach);
 }
 
+static void update_ksm_flags(struct mmap_state *map)
+{
+	map->flags = ksm_vma_flags(map->mm, map->file, map->flags);
+}
+
 /*
  * __mmap_prepare() - Prepare to gather any overlapping VMAs that need to be
  * unmapped once the map operation is completed, check limits, account mapping
@@ -2424,6 +2432,7 @@ static int __mmap_new_file_vma(struct mm
 			!(map->flags & VM_MAYWRITE) &&
 			(vma->vm_flags & VM_MAYWRITE));
 
+	map->file = vma->vm_file;
 	map->flags = vma->vm_flags;
 
 	return 0;
@@ -2473,6 +2482,11 @@ static int __mmap_new_vma(struct mmap_st
 	if (error)
 		goto free_iter_vma;
 
+	if (!map->check_ksm_early) {
+		update_ksm_flags(map);
+		vm_flags_init(vma, map->flags);
+	}
+
 #ifdef CONFIG_SPARC64
 	/* TODO: Fix SPARC ADI! */
 	WARN_ON_ONCE(!arch_validate_flags(map->flags));
@@ -2490,7 +2504,6 @@ static int __mmap_new_vma(struct mmap_st
 	 */
 	if (!vma_is_anonymous(vma))
 		khugepaged_enter_vma(vma, map->flags);
-	ksm_add_vma(vma);
 	*vmap = vma;
 	return 0;
 
@@ -2593,6 +2606,35 @@ static void set_vma_user_defined_fields(
 	vma->vm_private_data = map->vm_private_data;
 }
 
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
@@ -2604,12 +2646,17 @@ static unsigned long __mmap_region(struc
 	VMA_ITERATOR(vmi, mm, addr);
 	MMAP_STATE(map, mm, &vmi, addr, len, pgoff, vm_flags, file);
 
+	map.check_ksm_early = can_set_ksm_flags_early(&map);
+
 	error = __mmap_prepare(&map, uf);
 	if (!error && have_mmap_prepare)
 		error = call_mmap_prepare(&map);
 	if (error)
 		goto abort_munmap;
 
+	if (map.check_ksm_early)
+		update_ksm_flags(&map);
+
 	/* Attempt to merge with adjacent VMAs... */
 	if (map.prev || map.next) {
 		VMG_MMAP_STATE(vmg, &map, /* vma = */ NULL);
@@ -2721,6 +2768,7 @@ int do_brk_flags(struct vma_iterator *vm
 	 * Note: This happens *after* clearing old mappings in some code paths.
 	 */
 	flags |= VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
+	flags = ksm_vma_flags(mm, NULL, flags);
 	if (!may_expand_vm(mm, flags, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
@@ -2764,7 +2812,6 @@ int do_brk_flags(struct vma_iterator *vm
 
 	mm->map_count++;
 	validate_mm(mm);
-	ksm_add_vma(vma);
 out:
 	perf_event_mmap(vma);
 	mm->total_vm += len >> PAGE_SHIFT;
--- a/tools/testing/vma/vma_internal.h~mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas
+++ a/tools/testing/vma/vma_internal.h
@@ -1484,4 +1484,15 @@ static inline void vma_set_file(struct v
 	fput(file);
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

mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch
tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap-fix.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch

