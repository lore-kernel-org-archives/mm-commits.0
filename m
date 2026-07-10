Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EA72F7F01
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723540; cv=none; b=CZYMB+y+ZBCtXiNhBZ5scOzc2d6IkpBa9dGPx7AdrKsfVy39ke6ikLEx5pFRDWlbfkgcz7aWadnC6ybJpUd7iUO+jJh5HdE7GqB6ZIWhCWmpKD3k/1eRh5UYkMWYUCi2nsH5OZIjPAPltNlIynDblFou38N8YNI5XZkgZFKbuVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723540; c=relaxed/simple;
	bh=EHTz4pKFGZwe7AoQ6xEWBpzqiLuKcP4CTiF2Zf1XK7U=;
	h=Date:To:From:Subject:Message-Id; b=ZGrAEnbwpcLPdrJzqczRZ6UU3d2cpU7kK06UWR86xdX9Ao47dDyK4o7zOhsmUe26rZR+HvXfk4OAyxdPdfgaryoLM0uFKNqnEHeVS4v+5ImMxs4ChUmcZzv3ZCRGkJpGPjjtZVyHv04oK6OQkRsu2EQfspMcKJqTGfi4SE/qOA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fTaI+DTm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fTaI+DTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6B91F000E9;
	Fri, 10 Jul 2026 22:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723538;
	bh=J7QUcxh4vcyloYtJnd6B9/Jc2wxR32eUTeZ+Me7TXgc=;
	h=Date:To:From:Subject;
	b=fTaI+DTmypyEKQR4IhS/bTPiiWwwZEdNq6TII7OS8CWFjTHQDwwXPh+sJKN4FeqVg
	 oaLEtfyHVSuOGDCp8uF5I/KuKPIRziKOaEcVr1VdihJvDuCWkebdBexpO7NKmbGyVk
	 Ge7fUj6arFcqtHvUmKWgtylPIqZQ2fa3aiFRtIb8=
Date: Fri, 10 Jul 2026 15:45:37 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-vma_start_pgoff-into-mmh-and-clean-up.patch added to mm-new branch
Message-Id: <20260710224538.5A6B91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move vma_start_pgoff() into mm.h and clean up
has been added to the -mm mm-new branch.  Its filename is
     mm-move-vma_start_pgoff-into-mmh-and-clean-up.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-vma_start_pgoff-into-mmh-and-clean-up.patch

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
Subject: mm: move vma_start_pgoff() into mm.h and clean up
Date: Fri, 10 Jul 2026 21:16:42 +0100

Patch series "mm: make VMA page offset handling more consistent", v2.

This series performs a series of cleanups and improvements around how the
vma->vm_pgoff field is used.

Folios belonging to file-backed mappings are simply indexed by the page
offset within the file they map (excepting pfnmap and driver mappings
which sometimes do things different).

However, anonymous folios belonging to pure anonymous mappings are indexed
by their "virtual" page offset, which is equal to addr >> PAGE_SHIFT at
the time at which the VMA was first faulted in.

The page offset of a VMA is stored in vma->vm_pgoff and indicates the page
offset of the start of the VMA range, whether it be file-backed or
anonymous.

The work here both cleans up how we reference this field, as well as
laying the foundations for a future series which addresses the
inconsistency of CoW'd folios in MAP_PRIVATE-file backed mappings, which
are indexed as if they were file-backed but behave as if they were
anonymous.

This future series will make it such that all anonymous folios are indexed
by virtual page offset whether belonging to VMAs who satisfy
vma_is_anonymous() or MAP_PRIVATE-mapped file-backed mappings.

This series:

* Exposes vma_start_pgoff() and updates the kernel to use it consistently.
* Adds and uses the useful vma_end_pgoff() helper.
* Parameterises the file-backed mapping helpers vma_interval_tree_*()
  by address_space rather than rb_root_cached.
* Renames: the misleadingly-named vma_interval_tree_*() helpers to
  mapping_rmap_tree_*() to be consistent with the renamed
  anon_rmap_tree_*().
* Parameterises anon_rmap_tree_*() by anon_vma.
* Moves mm/interval_tree.c to the rmap section.
* Adds vmg_*() helpers for page offset.
* Clarifies the confusing vmg_adjust_set_range() function.
* Introduces linear_page_delta() to provide relative pgoff within a VMA.
* Replaces open-coded versions of linear_page_delta() and
  linear_page_index() with invocations of these functions.
* Introduces and uses vma_assert_can_modify() to account for whether a VMA
  can be modified (detached or write locked).
* Adds and uses vma_[add,sub]_pgoff() to adjust VMA page offset.
* Moves __install_special_mapping() to vma.c.
* Makes vma_set_range() static and internal to vma.c.
* Introduces and makes use of vma_set_pgoff().
* Fixes incorrect vma.h header inclusion.
* Defaults VMA userland tests to 64-bit vma flags size.
* Updates VMA userland tests to give better output on failure.
* Various smaller cleanups.
* Updated the vma_set_pgoff() assert to account for MAP_PRIVATE /dev/zero
  correctly.


This patch (of 33):

vma_last_pgoff() already lives there, so it's a bit odd to keep
vma_start_pgoff() in mm/interval_tree.c. Move them together.

These each return unsigned long, which pgoff_t is typedef'd to. Make this
consistent and have these functions return pgoff_t instead.

Additionally, express vma_last_pgoff() in terms of vma_start_pgoff(), since
we wrap the vma->vm_pgoff access, we may as well use it here.

Also while we're here, const-ify the VMA and cleanup a bit.

Also update the VMA userland tests to reflect the change.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org
Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-1-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h              |    9 +++++++--
 mm/interval_tree.c              |    5 -----
 tools/testing/vma/include/dup.h |    5 +++++
 3 files changed, 12 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h~mm-move-vma_start_pgoff-into-mmh-and-clean-up
+++ a/include/linux/mm.h
@@ -4311,9 +4311,14 @@ static inline unsigned long vma_pages(co
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
 
-static inline unsigned long vma_last_pgoff(struct vm_area_struct *vma)
+static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
 {
-	return vma->vm_pgoff + vma_pages(vma) - 1;
+	return vma->vm_pgoff;
+}
+
+static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
 }
 
 static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
--- a/mm/interval_tree.c~mm-move-vma_start_pgoff-into-mmh-and-clean-up
+++ a/mm/interval_tree.c
@@ -10,11 +10,6 @@
 #include <linux/rmap.h>
 #include <linux/interval_tree_generic.h>
 
-static inline unsigned long vma_start_pgoff(struct vm_area_struct *v)
-{
-	return v->vm_pgoff;
-}
-
 INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
 		     unsigned long, shared.rb_subtree_last,
 		     vma_start_pgoff, vma_last_pgoff, /* empty */, vma_interval_tree)
--- a/tools/testing/vma/include/dup.h~mm-move-vma_start_pgoff-into-mmh-and-clean-up
+++ a/tools/testing/vma/include/dup.h
@@ -1301,6 +1301,11 @@ static inline unsigned long vma_pages(co
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
 
+static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
+{
+	return vma->vm_pgoff;
+}
+
 static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 {
 	return file->f_op->mmap_prepare(desc);
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

