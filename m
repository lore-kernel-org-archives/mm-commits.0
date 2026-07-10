Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9601F91E3
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723595; cv=none; b=Ibp4BwI78eaKj60s78VRZ3Du1MYl1vXiLfMjFqBW5DjlK2uV8J15VAmAPCxJZSQz4IIQI8fGWuzloBr7end8IA5KBvmBIB7ZrtvtPK6q54+JIoNDK/BTdang3RXueSQt1UG6e8y+X1GkG8fUZC9mWv0U93pNkl1b++BBvKUuzBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723595; c=relaxed/simple;
	bh=i9pCyP1/tThHFiKtNOD0bi4OWPvzjU86NrXmU57D5Xg=;
	h=Date:To:From:Subject:Message-Id; b=Sf7ub8ftBt4TFOLcVlDqcO/yPMRWsaRXUKKWNhNDlNoY4az6WIcVrei/CgYDBVMbtfnP+BvlY9+V9SBFg3BaKcoY07jqsxTMNJDiVb69VGMLa9ECX2XMkIiYXDgj+DR5A9vmqM65U+NzbRaE/1AhUC0p6mWwPTtQVLRGkss7f1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qfPutvFj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qfPutvFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188521F000E9;
	Fri, 10 Jul 2026 22:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723594;
	bh=M3hPNVuQRz1lunVcYhLtoMfDQ0hALGMoA7iKpZyVd44=;
	h=Date:To:From:Subject;
	b=qfPutvFjUpXAhkqFKh5U1OxGXyrlMmgeW3bxlZZQvdwMt/rskjhmBOK/oMgUaVl0E
	 +sW/uVB9EW6W+Qrr0hc8WL3gY6RxKKtMWDkb32DKmIsK4aaPldhvkVm/+0y3EEhpD+
	 DhQqMTrSeA4aJKGn3JHcSKHyUebts0i5RILJMYU0=
Date: Fri, 10 Jul 2026 15:46:33 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-minor-cleanup-of-expand_.patch added to mm-new branch
Message-Id: <20260710224634.188521F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: minor cleanup of expand_[upwards, downwards]()
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-minor-cleanup-of-expand_.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-minor-cleanup-of-expand_.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/vma: minor cleanup of expand_[upwards, downwards]()
Date: Fri, 10 Jul 2026 21:16:57 +0100

Adjust the stack expansion functions expand_upwards() and
expand_downwards() such that they are expressed in terms of named constant
values, and make use of vma_start_pgoff().

This clearly documents that we are referencing the page offset of the start
of the VMA.

Additionally this cleans up the overflow check in expand_upwards().

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-16-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/mm/vma.c~mm-vma-minor-cleanup-of-expand_
+++ a/mm/vma.c
@@ -3216,13 +3216,12 @@ int expand_upwards(struct vm_area_struct
 
 	/* Somebody else might have raced and expanded it already */
 	if (address > vma->vm_end) {
-		unsigned long size, grow;
-
-		size = address - vma->vm_start;
-		grow = (address - vma->vm_end) >> PAGE_SHIFT;
+		const unsigned long size = address - vma->vm_start;
+		const unsigned long grow = (address - vma->vm_end) >> PAGE_SHIFT;
+		const pgoff_t pgoff = vma_start_pgoff(vma);
 
 		error = -ENOMEM;
-		if (vma->vm_pgoff + (size >> PAGE_SHIFT) >= vma->vm_pgoff) {
+		if (pgoff + (size >> PAGE_SHIFT) >= pgoff) {
 			error = acct_stack_growth(vma, size, grow);
 			if (!error) {
 				if (vma_test(vma, VMA_LOCKED_BIT))
@@ -3295,13 +3294,11 @@ int expand_downwards(struct vm_area_stru
 
 	/* Somebody else might have raced and expanded it already */
 	if (address < vma->vm_start) {
-		unsigned long size, grow;
-
-		size = vma->vm_end - address;
-		grow = (vma->vm_start - address) >> PAGE_SHIFT;
+		const unsigned long size = vma->vm_end - address;
+		const unsigned long grow = (vma->vm_start - address) >> PAGE_SHIFT;
 
 		error = -ENOMEM;
-		if (grow <= vma->vm_pgoff) {
+		if (grow <= vma_start_pgoff(vma)) {
 			error = acct_stack_growth(vma, size, grow);
 			if (!error) {
 				if (vma_test(vma, VMA_LOCKED_BIT))
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-move-alloc-tag-to-mm.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
mm-vmalloc-acquire-init_mm-read-lock-on-huge-vmap-promotion.patch
revert-arm64-enable-vmalloc-huge-with-ptdump.patch
mm-move-vma_start_pgoff-into-mmh-and-clean-up.patch
mm-add-kdoc-comments-for-vma_start-last_pgoff.patch
tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch
mm-introduce-and-use-vma_end_pgoff.patch
mm-rmap-update-mm-interval_treec-comments.patch
mm-rmap-parameterise-vma_interval_tree_-by-address_space.patch
mm-rmap-elide-unnecessary-static-inlines-in-interval_treec.patch
mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_.patch
mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma.patch
mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t.patch
mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch
maintainers-move-mm-interval_treec-to-rmap-section.patch
mm-vma-introduce-and-use-vmg_pages-vmg__pgoff.patch
mm-vma-clean-up-anon_vma_compatible.patch
mm-vma-refactor-vmg_adjust_set_range-for-clarity.patch
mm-vma-minor-cleanup-of-expand_.patch
mm-introduce-and-use-linear_page_delta.patch
mm-vma-use-vma_start_pgoff-linear_page_index-in-mm-code.patch
mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel.patch
mm-vma-remove-duplicative-vma_pgoff_offset-helper.patch
mm-use-linear_page_-consistently.patch
mm-vma-introduce-vma_assert_can_modify.patch
mm-vma-add-and-use-vma__pgoff.patch
mm-vma-move-__install_special_mapping-to-vmac.patch
mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch
mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters.patch
mm-vma-update-vmg_adjust_set_range-to-offset-pgoff-instead.patch
mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch
mm-vma-introduce-and-use-vma_set_pgoff.patch
mm-vma-correct-incorrect-vmah-inclusion.patch
mm-vma-use-guard-clauses-in-can_vma_merge_.patch
tools-testing-vma-default-vma-mm-flag-bits-to-64-bit.patch
tools-testing-vma-output-compared-expression-on-assert_.patch

