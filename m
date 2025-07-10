Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322F422154B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126306; cv=none; b=cyRBk0w5na43xwFHYBfPGA+He3QEIHwgX3+zghM6u7T1q8G3+QEigiSOyWW8eDtvaklJPHRTvpo66gPVoePxh34tjTpFq3OofYnMtP375LX9Xlwh8/576E1hfRIQ9JEwSZuVVFa/6hY+/hQ4TO0yvQYzdqulhk3eqexdvE08g9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126306; c=relaxed/simple;
	bh=UaPCvr5R3pNB2gQkykIX5nNpZHEFlQe/3BAv8jgI28g=;
	h=Date:To:From:Subject:Message-Id; b=CdlFPIH7vdbY3Eh/a0rYt1tcqUT0b63NOgxV0SJDcviqRKgJP6gFFpc9v462jkmoSDUcAcyUUf/7D+PrY1P5oc/Tgp858BCSWtGFWBLBi3G4XHGym04qaj9IVZ9O1/PPEoygs2BEfIRKJLMO8WvBC9aN13U4+ZBF3ChVUGv8zRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kXpmFjdv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kXpmFjdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EB7C4CEE3;
	Thu, 10 Jul 2025 05:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126306;
	bh=UaPCvr5R3pNB2gQkykIX5nNpZHEFlQe/3BAv8jgI28g=;
	h=Date:To:From:Subject:From;
	b=kXpmFjdvJQG72561nKJEbMWSiJPnJIVXiaayWr7V5IoiRzcPsXXIFYX2C4nQ25XWJ
	 4uXqVo7U2f4gKg6sJqycKVTHissBI/CM0kxq9SAV6OV1zNlDVvACnOSu0rMxKSjgex
	 qwDu16yZLMN1mSv4Py4/ptZ8p4MspLmX3KMwiFSc=
Date: Wed, 09 Jul 2025 22:45:05 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,liam.howlett@oracle.com,kees@kernel.org,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch removed from -mm tree
Message-Id: <20250710054505.F2EB7C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: use vmg->target to specify target VMA for new VMA merge
has been removed from the -mm tree.  Its filename was
     mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: use vmg->target to specify target VMA for new VMA merge
Date: Fri, 13 Jun 2025 19:48:07 +0100

In commit 3a75ccba047b ("mm: simplify vma merge structure and expand
comments") we introduced the vmg->target field to make the merging of
existing VMAs simpler - clarifying precisely which VMA would eventually
become the merged VMA once the merge operation was complete.

New VMA merging did not get quite the same treatment, retaining the rather
confusing convention of storing the target VMA in vmg->middle.

This patch corrects this state of affairs, utilising vmg->target for this
purpose for both vma_merge_new_range() and also for vma_expand().

We retain the WARN_ON for vmg->middle being specified in
vma_merge_new_range() as doing so would make no sense, but add an
additional debug assert for setting vmg->target.

This patch additionally updates VMA userland testing to account for this
change.

[lorenzo.stoakes@oracle.com: make comment consistent in vma_expand()]
  Link: https://lkml.kernel.org/r/c54f45e3-a6ac-4749-93c0-cc9e3080ee37@lucifer.local
Link: https://lkml.kernel.org/r/20250613184807.108089-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c                |   36 +++++++++++++++++++-----------------
 mm/vma_exec.c           |    2 +-
 tools/testing/vma/vma.c |    6 +++---
 3 files changed, 23 insertions(+), 21 deletions(-)

--- a/mm/vma.c~mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge
+++ a/mm/vma.c
@@ -1048,6 +1048,7 @@ struct vm_area_struct *vma_merge_new_ran
 
 	mmap_assert_write_locked(vmg->mm);
 	VM_WARN_ON_VMG(vmg->middle, vmg);
+	VM_WARN_ON_VMG(vmg->target, vmg);
 	/* vmi must point at or before the gap. */
 	VM_WARN_ON_VMG(vma_iter_addr(vmg->vmi) > end, vmg);
 
@@ -1063,13 +1064,13 @@ struct vm_area_struct *vma_merge_new_ran
 	/* If we can merge with the next VMA, adjust vmg accordingly. */
 	if (can_merge_right) {
 		vmg->end = next->vm_end;
-		vmg->middle = next;
+		vmg->target = next;
 	}
 
 	/* If we can merge with the previous VMA, adjust vmg accordingly. */
 	if (can_merge_left) {
 		vmg->start = prev->vm_start;
-		vmg->middle = prev;
+		vmg->target = prev;
 		vmg->pgoff = prev->vm_pgoff;
 
 		/*
@@ -1091,10 +1092,10 @@ struct vm_area_struct *vma_merge_new_ran
 	 * Now try to expand adjacent VMA(s). This takes care of removing the
 	 * following VMA if we have VMAs on both sides.
 	 */
-	if (vmg->middle && !vma_expand(vmg)) {
-		khugepaged_enter_vma(vmg->middle, vmg->flags);
+	if (vmg->target && !vma_expand(vmg)) {
+		khugepaged_enter_vma(vmg->target, vmg->flags);
 		vmg->state = VMA_MERGE_SUCCESS;
-		return vmg->middle;
+		return vmg->target;
 	}
 
 	return NULL;
@@ -1106,27 +1107,29 @@ struct vm_area_struct *vma_merge_new_ran
  * @vmg: Describes a VMA expansion operation.
  *
  * Expand @vma to vmg->start and vmg->end.  Can expand off the start and end.
- * Will expand over vmg->next if it's different from vmg->middle and vmg->end ==
- * vmg->next->vm_end.  Checking if the vmg->middle can expand and merge with
+ * Will expand over vmg->next if it's different from vmg->target and vmg->end ==
+ * vmg->next->vm_end.  Checking if the vmg->target can expand and merge with
  * vmg->next needs to be handled by the caller.
  *
  * Returns: 0 on success.
  *
  * ASSUMPTIONS:
- * - The caller must hold a WRITE lock on vmg->middle->mm->mmap_lock.
- * - The caller must have set @vmg->middle and @vmg->next.
+ * - The caller must hold a WRITE lock on the mm_struct->mmap_lock.
+ * - The caller must have set @vmg->target and @vmg->next.
  */
 int vma_expand(struct vma_merge_struct *vmg)
 {
 	struct vm_area_struct *anon_dup = NULL;
 	bool remove_next = false;
-	struct vm_area_struct *middle = vmg->middle;
+	struct vm_area_struct *target = vmg->target;
 	struct vm_area_struct *next = vmg->next;
 
+	VM_WARN_ON_VMG(!target, vmg);
+
 	mmap_assert_write_locked(vmg->mm);
 
-	vma_start_write(middle);
-	if (next && (middle != next) && (vmg->end == next->vm_end)) {
+	vma_start_write(target);
+	if (next && (target != next) && (vmg->end == next->vm_end)) {
 		int ret;
 
 		remove_next = true;
@@ -1137,19 +1140,18 @@ int vma_expand(struct vma_merge_struct *
 		 * In this case we don't report OOM, so vmg->give_up_on_mm is
 		 * safe.
 		 */
-		ret = dup_anon_vma(middle, next, &anon_dup);
+		ret = dup_anon_vma(target, next, &anon_dup);
 		if (ret)
 			return ret;
 	}
 
 	/* Not merging but overwriting any part of next is not handled. */
 	VM_WARN_ON_VMG(next && !remove_next &&
-		       next != middle && vmg->end > next->vm_start, vmg);
+		       next != target && vmg->end > next->vm_start, vmg);
 	/* Only handles expanding */
-	VM_WARN_ON_VMG(middle->vm_start < vmg->start ||
-		       middle->vm_end > vmg->end, vmg);
+	VM_WARN_ON_VMG(target->vm_start < vmg->start ||
+		       target->vm_end > vmg->end, vmg);
 
-	vmg->target = middle;
 	if (remove_next)
 		vmg->__remove_next = true;
 
--- a/mm/vma_exec.c~mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge
+++ a/mm/vma_exec.c
@@ -54,7 +54,7 @@ int relocate_vma_down(struct vm_area_str
 	/*
 	 * cover the whole range: [new_start, old_end)
 	 */
-	vmg.middle = vma;
+	vmg.target = vma;
 	if (vma_expand(&vmg))
 		return -ENOMEM;
 
--- a/tools/testing/vma/vma.c~mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge
+++ a/tools/testing/vma/vma.c
@@ -400,7 +400,7 @@ static bool test_simple_expand(void)
 	VMA_ITERATOR(vmi, &mm, 0);
 	struct vma_merge_struct vmg = {
 		.vmi = &vmi,
-		.middle = vma,
+		.target = vma,
 		.start = 0,
 		.end = 0x3000,
 		.pgoff = 0,
@@ -1318,7 +1318,7 @@ static bool test_dup_anon_vma(void)
 	vma_next->anon_vma = &dummy_anon_vma;
 
 	vmg_set_range(&vmg, 0, 0x5000, 0, flags);
-	vmg.middle = vma_prev;
+	vmg.target = vma_prev;
 	vmg.next = vma_next;
 
 	ASSERT_EQ(expand_existing(&vmg), 0);
@@ -1501,7 +1501,7 @@ static bool test_vmi_prealloc_fail(void)
 	vma->anon_vma = &dummy_anon_vma;
 
 	vmg_set_range(&vmg, 0, 0x5000, 3, flags);
-	vmg.middle = vma_prev;
+	vmg.target = vma_prev;
 	vmg.next = vma;
 
 	fail_prealloc = true;
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

