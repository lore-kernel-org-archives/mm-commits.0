Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA5D305057
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723543; cv=none; b=n+okNhoTOmi5U0VDbwDO80tFAWp5ZisozWHX8zVYKMpTep5g7fAMtqzrqmKuC9fPVX9h4Xahbx+apI7v2eqWDHTwVkRrmcmCadpvWdVtK5LJwSy0dGAWCfW8JltzHlK7lJaIOyugbuWjGial8L3TbN2ZTST+yk1eQzyG2lzl7mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723543; c=relaxed/simple;
	bh=apR3dODnkHAoo9tuKTFWCdNaTqjcNcozjpBRgNF0tIU=;
	h=Date:To:From:Subject:Message-Id; b=mY90BQ3vcSA44OfSI6RBLg0rqJT3uM+IYm1KockSwnEnHy4EbewHVYsq3qazDObPBwbmohZnwy3ozTpxLoOZ0ndIE0GFEwhFj16tjYnPDh9M9K1peg0qgRK1YfFwTxQpKY+UN8bqsolYBE+fJ71+3aOh1H9iXeaiQkigxiiupEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d2vbfUiG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d2vbfUiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CEE1F000E9;
	Fri, 10 Jul 2026 22:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723541;
	bh=1J8TogDzDmL7CxXfMonIdH3rE9ZVnatx6a5xL4awOb4=;
	h=Date:To:From:Subject;
	b=d2vbfUiG30jem07KkwCq6WEG64YXoK8vyfqaiqRFhj7QcfWWF9dG2EzSWXMTD/RaB
	 mEktSwUxjtDzq/NoCWO8PF4jgdNgO9MSwjSuPiPlD/gF1zw//rNHjAL7F4jYKJikI2
	 exegRhjNgDE/S87MqT0eFv7CcJ67DQjB5SX28Jis=
Date: Fri, 10 Jul 2026 15:45:40 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-kdoc-comments-for-vma_start-last_pgoff.patch added to mm-new branch
Message-Id: <20260710224541.46CEE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add kdoc comments for vma_start/last_pgoff()
has been added to the -mm mm-new branch.  Its filename is
     mm-add-kdoc-comments-for-vma_start-last_pgoff.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-kdoc-comments-for-vma_start-last_pgoff.patch

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
Subject: mm: add kdoc comments for vma_start/last_pgoff()
Date: Fri, 10 Jul 2026 21:16:43 +0100

Describe what vma_start_pgoff() and vma_last_pgoff() actually provide in
detail.

This is in order that we can differentiate this between functions that will
be added in a subsequent patch which provide a different page offset.

We go to lengths to describe the edge cases that can be run into here.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-2-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/include/linux/mm.h~mm-add-kdoc-comments-for-vma_start-last_pgoff
+++ a/include/linux/mm.h
@@ -4311,11 +4311,41 @@ static inline unsigned long vma_pages(co
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
 
+/**
+ * vma_start_pgoff() - Get the page offset of the start of @vma
+ * @vma: The VMA whose page offset is required.
+ *
+ * If the VMA is file-backed, this is the page offset into the file.
+ *
+ * If @vma is anonymous, this is the virtual page offset of the start of the
+ * VMA - if unfaulted, then vma->vm_start >> PAGE_SHIFT, if faulted then the
+ * virtual page offset at the time of first fault.
+ *
+ * If @vma is a MAP_PRIVATE file-backed mapping, then this returns the
+ * page offset within the file.
+ *
+ * Edge cases: nommu does not abide by these, MAP_PRIVATE-/dev/zero satisfies
+ * vma_is_anonymous() but has file-backed page offset, and MAP_PRIVATE-pfnmap
+ * regions have their page offset set to the first PFN in the range.
+ *
+ * Returns: The page offset of the start of @vma.
+ */
 static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
 {
 	return vma->vm_pgoff;
 }
 
+/**
+ * vma_last_pgoff() - Get the page offset of the last page in @vma
+ * @vma: The VMA whose last page offset is required.
+ *
+ * This returns the last page offset contained within @vma.
+ *
+ * See the description of vma_start_pgoff() for a description of VMA page
+ * offsets.
+ *
+ * Returns: The last page offset of @vma.
+ */
 static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
 {
 	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
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

