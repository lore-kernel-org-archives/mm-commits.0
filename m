Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF861DF258
	for <mm-commits@vger.kernel.org>; Fri, 13 Jun 2025 23:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749857815; cv=none; b=kL+k4hCAeRshQmdSOBTYK++2jd3lkc3o2ExstNoJ6NLlDXPq0J4pSAA/4DgwXwMnML3lv3mY60j6a2CDZTl1VQqwOiNai+tJgT6bzeeQarOJUMp0H6jUzDag0+1EE5TbQBfhV16gJng/PzrLdmIvipjKzrg0nI3fDAnNqra5JB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749857815; c=relaxed/simple;
	bh=2cmsFQOTKD3XD3s2X/rxIBG7A/JJwb/IaF0o2wXAU5M=;
	h=Date:To:From:Subject:Message-Id; b=Wxl0jyFHqE3Ah6wgIilGCzA/zERN3XOuSjBu41mbwit7v+msv//xWU14dMJiHxUcvJ5M19215b3BFYtGme7D3/TMcmbR5RcLliw0kll4Vy0ZcldOR9gSVyzSV4Zgj5Gbx35VPZd04ShUY+c5uAyLpf3CItCpnffLjuOQTlu3osk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cqnbe+rj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cqnbe+rj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE49C4CEE3;
	Fri, 13 Jun 2025 23:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749857815;
	bh=2cmsFQOTKD3XD3s2X/rxIBG7A/JJwb/IaF0o2wXAU5M=;
	h=Date:To:From:Subject:From;
	b=cqnbe+rjaY/+wAHqYV680eIMFVebORQv78NsnHacg3zw3Op5ZSr2s9Tho+1Ng2Ai7
	 ZCnL+6aZgm3+yN2hRPBj39squqFCnuZiZS8R2cxd+VGofKpAkFdzhuqLj5h2K8d3MC
	 YVFV1+zWzIxxlpwYWDOrIGHQXDYswSei/XxstG4k=
Date: Fri, 13 Jun 2025 16:36:54 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,liam.howlett@oracle.com,kees@kernel.org,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch added to mm-new branch
Message-Id: <20250613233655.2AE49C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: use vmg->target to specify target VMA for new VMA merge
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch

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

Link: https://lkml.kernel.org/r/20250613184807.108089-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c                |   36 +++++++++++++++++++-----------------
 mm/vma_exec.c           |    2 +-
 tools/testing/vma/vma.c |    6 +++---
 3 files changed, 23 insertions(+), 21 deletions(-)

--- a/mm/vma.c~mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge
+++ a/mm/vma.c
@@ -1028,6 +1028,7 @@ struct vm_area_struct *vma_merge_new_ran
 
 	mmap_assert_write_locked(vmg->mm);
 	VM_WARN_ON_VMG(vmg->middle, vmg);
+	VM_WARN_ON_VMG(vmg->target, vmg);
 	/* vmi must point at or before the gap. */
 	VM_WARN_ON_VMG(vma_iter_addr(vmg->vmi) > end, vmg);
 
@@ -1043,13 +1044,13 @@ struct vm_area_struct *vma_merge_new_ran
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
@@ -1071,10 +1072,10 @@ struct vm_area_struct *vma_merge_new_ran
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
@@ -1086,27 +1087,29 @@ struct vm_area_struct *vma_merge_new_ran
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
+ * - The caller must hold a WRITE lock on vmg->target->mm->mmap_lock.
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
@@ -1117,19 +1120,18 @@ int vma_expand(struct vma_merge_struct *
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

docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-add-mremap_must_relocate_anon.patch
mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch
tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch
tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch
tools-testing-selftests-add-mremap-cases-that-merge-normally.patch
tools-testing-selftests-add-mremap_relocate_anon-merge-test-cases.patch
tools-testing-selftests-expand-mremap-tests-for-mremap_relocate_anon.patch
tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch
tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch
tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch

