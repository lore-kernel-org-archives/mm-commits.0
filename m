Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C50405C48
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723640; cv=none; b=spnWeLS7Gsj8vv8Loq6KJBr11lwlTNj8JRTh+9ysys/yMcAIHFGXh5KMOKdt29CQSjmYBUl94s14xTTs0IiwCt4gltZJWq5HqaAqg3CV2wX+NjwPIXlW6QeJ87QGyiMVQLyxDr21TMIBnipNo+J6MC2+pn1rfmDlHl41tQED4sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723640; c=relaxed/simple;
	bh=K/faW64LW2BK7m8vAOZDWTCb+dAiKDMsr30AobD85E4=;
	h=Date:To:From:Subject:Message-Id; b=JmZNjRlaSUEX697zy/t+zNai+lPlmm4BJAYuYg8qD/76FRKK5R4MGrlusZ+tntZJeW4C+RMqUCsDVJsPQWE70nDUzSqgVBri3yqtwqH6eMfUgXbJkbmTiSimYeTbexLsZCYl2vmAsETFkunwBy6QZ9/Js8eMQ93x5u8M5YVAJGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Th0HDEdQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Th0HDEdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B191F000E9;
	Fri, 10 Jul 2026 22:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723638;
	bh=zp64SZ7wQshlySMrPODzEpk0WWfqFs8/BwjckSKMihc=;
	h=Date:To:From:Subject;
	b=Th0HDEdQjE8NB/VUgW8Exfqy69B5vciUwQKfwt7pEbIY/QLgACmZApiKMi9vcE7WV
	 TWg3YjbhdlCjsfsIbTETHWJJozjSe7zILprZdPOr4eFWFMTFCGydOfPQ96J7rOHejX
	 XxNME8ROoJ9l1roW4x1kszBSabb4gkNh7xMd1Vu4=
Date: Fri, 10 Jul 2026 15:47:18 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters.patch added to mm-new branch
Message-Id: <20260710224718.D5B191F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: update vma_shrink() to not pass start, pgoff parameters
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters.patch

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
Subject: mm/vma: update vma_shrink() to not pass start, pgoff parameters
Date: Fri, 10 Jul 2026 21:17:07 +0100

vma_shrink() is only used by relocate_vma_down() to shrink the tail of a
VMA. Therefore neither the start nor the pgoff parameters make any sense.

It seemed we were passing the pgoff parameter solely to satisfy
vma_set_range()'s requirement for pgoff being specified.

Since vma_set_range() is now isolated to vma.c, we can simply introduce
__vma_set_range() which sets only vma->vm_[start, end], and invoke this
instead, removing start and pgoff from vma_shrink() altogether.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-26-2a5aa403d977@kernel.org
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

 mm/vma.c                        |   31 ++++++++++++++++--------------
 mm/vma.h                        |    3 --
 mm/vma_exec.c                   |    2 -
 tools/testing/vma/tests/merge.c |    2 -
 4 files changed, 20 insertions(+), 18 deletions(-)

--- a/mm/vma.c~mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters
+++ a/mm/vma.c
@@ -70,11 +70,17 @@ struct mmap_state {
 		.state = VMA_MERGE_START,				\
 	}
 
-static void vma_set_range(struct vm_area_struct *vma, unsigned long start,
-			  unsigned long end, pgoff_t pgoff)
+static void __vma_set_range(struct vm_area_struct *vma, unsigned long start,
+			    unsigned long end)
 {
 	vma->vm_start = start;
 	vma->vm_end = end;
+}
+
+static void vma_set_range(struct vm_area_struct *vma, unsigned long start,
+			  unsigned long end, pgoff_t pgoff)
+{
+	__vma_set_range(vma, start, end);
 	vma->vm_pgoff = pgoff;
 }
 
@@ -1279,27 +1285,24 @@ nomem:
 	return -ENOMEM;
 }
 
-/*
- * vma_shrink() - Reduce an existing VMAs memory area
+/**
+ * vma_shrink() - Shrink the end of a VMA
  * @vmi: The vma iterator
  * @vma: The VMA to modify
- * @start: The new start
  * @end: The new end
  *
+ * Note that the caller may only shrink the end of the VMA.
+ *
  * Returns: 0 on success, -ENOMEM otherwise
  */
 int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
-	       unsigned long start, unsigned long end, pgoff_t pgoff)
+	       unsigned long end)
 {
 	struct vma_prepare vp;
 
-	WARN_ON((vma->vm_start != start) && (vma->vm_end != end));
-
-	if (vma->vm_start < start)
-		vma_iter_config(vmi, vma->vm_start, start);
-	else
-		vma_iter_config(vmi, end, vma->vm_end);
+	VM_WARN_ON_ONCE(end > vma->vm_end);
 
+	vma_iter_config(vmi, end, vma->vm_end);
 	if (vma_iter_prealloc(vmi, NULL))
 		return -ENOMEM;
 
@@ -1307,10 +1310,10 @@ int vma_shrink(struct vma_iterator *vmi,
 
 	init_vma_prep(&vp, vma);
 	vma_prepare(&vp);
-	vma_adjust_trans_huge(vma, start, end, NULL);
+	vma_adjust_trans_huge(vma, vma->vm_start, end, NULL);
 
 	vma_iter_clear(vmi);
-	vma_set_range(vma, start, end, pgoff);
+	__vma_set_range(vma, vma->vm_start, end);
 	vma_complete(&vp, vmi, vma->vm_mm);
 	validate_mm(vma->vm_mm);
 	return 0;
--- a/mm/vma_exec.c~mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters
+++ a/mm/vma_exec.c
@@ -89,7 +89,7 @@ int relocate_vma_down(struct vm_area_str
 
 	vma_prev(&vmi);
 	/* Shrink the vma to just the new range */
-	return vma_shrink(&vmi, vma, new_start, new_end, vma_start_pgoff(vma));
+	return vma_shrink(&vmi, vma, new_end);
 }
 
 /*
--- a/mm/vma.h~mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters
+++ a/mm/vma.h
@@ -297,8 +297,7 @@ void validate_mm(struct mm_struct *mm);
 
 __must_check int vma_expand(struct vma_merge_struct *vmg);
 __must_check int vma_shrink(struct vma_iterator *vmi,
-		struct vm_area_struct *vma,
-		unsigned long start, unsigned long end, pgoff_t pgoff);
+		struct vm_area_struct *vma, unsigned long end);
 
 static inline int vma_iter_store_gfp(struct vma_iterator *vmi,
 			struct vm_area_struct *vma, gfp_t gfp)
--- a/tools/testing/vma/tests/merge.c~mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters
+++ a/tools/testing/vma/tests/merge.c
@@ -227,7 +227,7 @@ static bool test_simple_shrink(void)
 
 	ASSERT_FALSE(attach_vma(&mm, vma));
 
-	ASSERT_FALSE(vma_shrink(&vmi, vma, 0, 0x1000, 0));
+	ASSERT_FALSE(vma_shrink(&vmi, vma, 0x1000));
 
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);
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

