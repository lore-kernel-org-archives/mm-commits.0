Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1775F404BFD
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723591; cv=none; b=OVsrwFHGyyHgC/1b/40jfUkCrJm1ej8OqsXhBa8v0HOBRgMCC1i1+VknVGnnkAjWAAEwbRXeaoxMqv50hRzbgBfVT3R2bs+O1VUn8AKSetGT3D0LIFpJGjbTpaL6hWdQQuYkKJOJvhS4Ut05wRtwUekY+T9DSmsawEC+2JVDoOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723591; c=relaxed/simple;
	bh=57k9N1pQOMSgoYfvi45CMjUjCOI+9lQOUKq93mSUUDc=;
	h=Date:To:From:Subject:Message-Id; b=NF73JsdEmHJEbQm/+yxs+U+XAqJI4eASQeOAOPckYema8sQpmMcDqyQD3bBY1s80aZaJLQbTE8tOkb6QiHW4rp1/QDr3v+JnKi6VCgxPFSiHz+uIT+GfqTukTrYHL68LFCKfmF/4TLgbr1B817jU5luiGhr7bx74EEi/bgzRaQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wOTYvNwT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wOTYvNwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72D71F000E9;
	Fri, 10 Jul 2026 22:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723590;
	bh=TXhLH6n6sxenlkeQuNt9EN8wFXIbp+sVcMzHENES1/M=;
	h=Date:To:From:Subject;
	b=wOTYvNwTh/oHd4g7igfj5NQSqc5oamSKjvLUTyeBR5mWorp/vr0TD3QXBhbAyOk8K
	 rB/SN9L1RchnObFneEbVwXLkQn+jej7Fe4b8EULOVjlMDkAIt2DbzLprj8lDeoFbXh
	 PbgMfLfrShM4Dyh5LR75C5A+kYnq0rR8WAcWykxA=
Date: Fri, 10 Jul 2026 15:46:29 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-clean-up-anon_vma_compatible.patch added to mm-new branch
Message-Id: <20260710224629.D72D71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: clean up anon_vma_compatible()
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-clean-up-anon_vma_compatible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-clean-up-anon_vma_compatible.patch

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
Subject: mm/vma: clean up anon_vma_compatible()
Date: Fri, 10 Jul 2026 21:16:55 +0100

Break up the existing very large conditional, add comments and use
vma_[start/end]_pgoff() to make clearer what we're doing here.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-14-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/mm/vma.c~mm-vma-clean-up-anon_vma_compatible
+++ a/mm/vma.c
@@ -1967,14 +1967,25 @@ static int anon_vma_compatible(struct vm
 {
 	vma_flags_t diff = vma_flags_diff_pair(&a->flags, &b->flags);
 
+	/* Ignore flags that mprotect() can change. */
 	vma_flags_clear_mask(&diff, VMA_ACCESS_FLAGS);
+	/* Ignore flags that do not impact merging. */
 	vma_flags_clear_mask(&diff, VMA_IGNORE_MERGE_FLAGS);
 
-	return a->vm_end == b->vm_start &&
-		mpol_equal(vma_policy(a), vma_policy(b)) &&
-		a->vm_file == b->vm_file &&
-		vma_flags_empty(&diff) &&
-		b->vm_pgoff == a->vm_pgoff + ((b->vm_start - a->vm_start) >> PAGE_SHIFT);
+	/* Must be adjacent. */
+	if (a->vm_end != b->vm_start)
+		return false;
+	/* Must have matching policy. */
+	if (!mpol_equal(vma_policy(a), vma_policy(b)))
+		return false;
+	/* Must both be anon or map the same file (MAP_PRIVATE case). */
+	if (a->vm_file != b->vm_file)
+		return false;
+	/* Flags must be equivalent modulo mprotect(). */
+	if (!vma_flags_empty(&diff))
+		return false;
+	/* Page offset must align. */
+	return vma_end_pgoff(a) == vma_start_pgoff(b);
 }
 
 /*
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

