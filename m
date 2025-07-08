Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902C81F9EC0
	for <mm-commits@vger.kernel.org>; Tue,  8 Jul 2025 01:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751939910; cv=none; b=tZK2TGGydyKGgce8IxCJlMrSvRZfg3dzb7cPg0WN/SfCd3LE21R7h7rzg+9AA4ABpS1odNAoOxQoNRyLbZM6He1HprPrYYRppHcldRmEvJ3nshhu4lBue3nqhYf6UKEfSovi8K3kNE6MK92ixlpNTlQlMafmVGDIFj88M2AARIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751939910; c=relaxed/simple;
	bh=TO6hK2E7r2be/IZPktPkWHEuKq2j6S61iOQtam0tlCk=;
	h=Date:To:From:Subject:Message-Id; b=DLE0UcydYFbux2d2VA7pOL+A/7R6ISvWfEYS+nWmROg7DSa6aykVCM9D95cv63wI4r2biNII/H91p6dtbsEDOM6kE7znX4cNGmY39fM+Hxpe7mRJ03CEIH5QXXHGTz+41uy4GO1g71lOAjWu5j646ZCIarz6TRwFLZoes3gUb54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BcEpNGf7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BcEpNGf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB5AC4CEE3;
	Tue,  8 Jul 2025 01:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751939910;
	bh=TO6hK2E7r2be/IZPktPkWHEuKq2j6S61iOQtam0tlCk=;
	h=Date:To:From:Subject:From;
	b=BcEpNGf74zQO2us8c/dWG//8JelIns+Z197hShNar992QnqEaWiNkas+E3fJyY3mT
	 vV0SwlMQJ6FUzur9xReoSOxGi68oHXtAd70cVBwMUar3/v8hOYfIOe4pyBIf9yZGko
	 yrqsuY3h/OY8HHHshEkdwMjwAwc5elJf7OosQGls=
Date: Mon, 07 Jul 2025 18:58:29 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,lkp@intel.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch added to mm-new branch
Message-Id: <20250708015830.0BB5AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: use an explicit uffd failure path for mremap
has been added to the -mm mm-new branch.  Its filename is
     mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch

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
Subject: mm/mremap: use an explicit uffd failure path for mremap
Date: Mon, 7 Jul 2025 06:27:48 +0100

Right now it appears that the code is relying upon the returned destination
address having bits outside PAGE_MASK to indicate whether an error value is
specified, and decrementing the increased refcount on the uffd ctx if so.

This is not a safe means of determining an error value, so instead, be
specific. It makes far more sense to do so in a dedicated error path, so
add mremap_userfaultfd_fail() for this purpose and use this when an error
arises.

A vm_userfaultfd_ctx is not established until we are at the point where
mremap_userfaultfd_prep() is invoked in copy_vma_and_data(), so this is a
no-op until this happens.

That is - uffd remap notification only occurs if the VMA is actually moved
- at which point a UFFD_EVENT_REMAP event is raised.

No errors can occur after this point currently, though it's certainly not
guaranteed this will always remain the case, and we mustn't rely on this.

However, the reason for needing to handle this case is that, when an error
arises on a VMA move at the point of adjusting page tables, we revert this
operation, and propagate the error.

At this point, it is not correct to raise a uffd remap event, and we must
handle it.

This refactoring makes it abundantly clear what we are doing.

We assume vrm->new_addr is always valid, which a prior change made the case
even for mremap() invocations which don't move the VMA, however given no
uffd context would be set up in this case it's immaterial to this change
anyway.

No functional change intended.

Link: https://lkml.kernel.org/r/be3e068c77107d385d89eae634317cb59e04e5ba.1751865330.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c              |   15 ++++++++++-----
 include/linux/userfaultfd_k.h |    1 +
 mm/mremap.c                   |   16 ++++++++++++----
 3 files changed, 23 insertions(+), 9 deletions(-)

--- a/fs/userfaultfd.c~mm-mremap-use-an-explicit-uffd-failure-path-for-mremap
+++ a/fs/userfaultfd.c
@@ -750,11 +750,6 @@ void mremap_userfaultfd_complete(struct
 	if (!ctx)
 		return;
 
-	if (to & ~PAGE_MASK) {
-		userfaultfd_ctx_put(ctx);
-		return;
-	}
-
 	msg_init(&ewq.msg);
 
 	ewq.msg.event = UFFD_EVENT_REMAP;
@@ -765,6 +760,16 @@ void mremap_userfaultfd_complete(struct
 	userfaultfd_event_wait_completion(ctx, &ewq);
 }
 
+void mremap_userfaultfd_fail(struct vm_userfaultfd_ctx *vm_ctx)
+{
+	struct userfaultfd_ctx *ctx = vm_ctx->ctx;
+
+	if (!ctx)
+		return;
+
+	userfaultfd_ctx_put(ctx);
+}
+
 bool userfaultfd_remove(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end)
 {
--- a/include/linux/userfaultfd_k.h~mm-mremap-use-an-explicit-uffd-failure-path-for-mremap
+++ a/include/linux/userfaultfd_k.h
@@ -259,6 +259,7 @@ extern void mremap_userfaultfd_prep(stru
 extern void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx *,
 					unsigned long from, unsigned long to,
 					unsigned long len);
+void mremap_userfaultfd_fail(struct vm_userfaultfd_ctx *);
 
 extern bool userfaultfd_remove(struct vm_area_struct *vma,
 			       unsigned long start,
--- a/mm/mremap.c~mm-mremap-use-an-explicit-uffd-failure-path-for-mremap
+++ a/mm/mremap.c
@@ -1729,12 +1729,17 @@ static int check_prep_vma(struct vma_rem
 	return 0;
 }
 
-static void notify_uffd(struct vma_remap_struct *vrm, unsigned long ret)
+static void notify_uffd(struct vma_remap_struct *vrm, bool failed)
 {
 	struct mm_struct *mm = current->mm;
 
+	/* Regardless of success/failure, we always notify of any unmaps. */
 	userfaultfd_unmap_complete(mm, vrm->uf_unmap_early);
-	mremap_userfaultfd_complete(vrm->uf, vrm->addr, ret, vrm->old_len);
+	if (failed)
+		mremap_userfaultfd_fail(vrm->uf);
+	else
+		mremap_userfaultfd_complete(vrm->uf, vrm->addr,
+			vrm->new_addr, vrm->old_len);
 	userfaultfd_unmap_complete(mm, vrm->uf_unmap);
 }
 
@@ -1742,6 +1747,7 @@ static unsigned long do_mremap(struct vm
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long res;
+	bool failed;
 
 	vrm->old_len = PAGE_ALIGN(vrm->old_len);
 	vrm->new_len = PAGE_ALIGN(vrm->new_len);
@@ -1763,13 +1769,15 @@ static unsigned long do_mremap(struct vm
 	res = vrm_implies_new_addr(vrm) ? mremap_to(vrm) : mremap_at(vrm);
 
 out:
+	failed = IS_ERR_VALUE(res);
+
 	if (vrm->mmap_locked)
 		mmap_write_unlock(mm);
 
-	if (!IS_ERR_VALUE(res) && vrm->mlocked && vrm->new_len > vrm->old_len)
+	if (!failed && vrm->mlocked && vrm->new_len > vrm->old_len)
 		mm_populate(vrm->new_addr + vrm->old_len, vrm->delta);
 
-	notify_uffd(vrm, res);
+	notify_uffd(vrm, failed);
 	return res;
 }
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas-fix.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-use-per_vma-lock-for-madv_dontneed-fix.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
secretmem-remove-uses-of-struct-page-fix.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge-fix.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix.patch
mm-update-core-kernel-code-to-use-vm_flags_t-consistently.patch
mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch
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

