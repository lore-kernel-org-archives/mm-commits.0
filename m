Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693ED404BD2
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723636; cv=none; b=Avol0YomHTYVaAaH5swOWPzKw4kumXWzj/b8DVvpk1+XzA0U1ReauHB8SZfwsL1G5FhrGgJS6zybYO9IK6mbeTeGtZWwSU6gviekqXPKDm9iaZ7sUg5tALiohUuqhSUU8y4/MmCn44lNpCAFlA+fRZZnuyy4k4JLCJD04LNFJoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723636; c=relaxed/simple;
	bh=EpwOc/VyCMBrhAIYgjjTkHQHK+3VIaJWZuRmMbehMhg=;
	h=Date:To:From:Subject:Message-Id; b=bl6H2K7FWlpfc4iJRfRWSlOyIQTbe00kGhx1pn+HyHaVUT69cMDtCcUbwMm/HVKojI2TfsMGHYy3U9IeU3YTJIiwD//UEi5ofuW5XESX0Py5CwJiKogeM/JhHno+AEczpo/5iDELBuUq9H+zF5v/MgxQo8vbtJqQddW2NkRpQfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r7qjXZHe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r7qjXZHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BB11F000E9;
	Fri, 10 Jul 2026 22:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723635;
	bh=+X7T8+VA+o0AHoSXz1nhrv7koaamDaM6z02O5m5FlHA=;
	h=Date:To:From:Subject;
	b=r7qjXZHeu9DeI/fLZpK32V31irx/pT92cjh8Sdmx/+NbYfZUMsHNDtgw1XPl7U4tv
	 m45UHK+RHJ6jlv40k/mnhakKCetZ9s4sXs6me8GJBxp0i1/IqvK02YfQXq6pF5aNX3
	 xaghxBYIDPSgIHFKdTRuSvO0sKKgELDRsAnuAS0Q=
Date: Fri, 10 Jul 2026 15:47:14 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch added to mm-new branch
Message-Id: <20260710224715.04BB11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: make vma_set_range() static, drop insert_vm_struct() decl
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch

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
Subject: mm/vma: make vma_set_range() static, drop insert_vm_struct() decl
Date: Fri, 10 Jul 2026 21:17:06 +0100

With __install_special_mapping() moved to vma.c, vma_set_range() can be
made into a static function there and is now completely isolated from the
rest of mm.

While we're here, we can also remove the insert_vm_struct() declaration
from mm.h - the function is implemented in vma.c and already declared in
vma.h, and has no users outside of mm.

Also update the VMA userland tests to reflect this change.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-25-2a5aa403d977@kernel.org
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

 include/linux/mm.h         |    1 -
 mm/internal.h              |    9 ---------
 mm/vma.c                   |    8 ++++++++
 tools/testing/vma/shared.c |    9 ---------
 tools/testing/vma/shared.h |    5 -----
 5 files changed, 8 insertions(+), 24 deletions(-)

--- a/include/linux/mm.h~mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl
+++ a/include/linux/mm.h
@@ -4134,7 +4134,6 @@ void anon_rmap_tree_verify(struct anon_v
 
 /* mmap.c */
 extern int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin);
-extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void exit_mmap(struct mm_struct *);
 bool mmap_read_lock_maybe_expand(struct mm_struct *mm, struct vm_area_struct *vma,
 				 unsigned long addr, bool write);
--- a/mm/internal.h~mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl
+++ a/mm/internal.h
@@ -1360,15 +1360,6 @@ static inline bool gup_must_unshare(stru
 }
 
 
-static __always_inline void vma_set_range(struct vm_area_struct *vma,
-					  unsigned long start, unsigned long end,
-					  pgoff_t pgoff)
-{
-	vma->vm_start = start;
-	vma->vm_end = end;
-	vma->vm_pgoff = pgoff;
-}
-
 static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
 {
 	/*
--- a/mm/vma.c~mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl
+++ a/mm/vma.c
@@ -70,6 +70,14 @@ struct mmap_state {
 		.state = VMA_MERGE_START,				\
 	}
 
+static void vma_set_range(struct vm_area_struct *vma, unsigned long start,
+			  unsigned long end, pgoff_t pgoff)
+{
+	vma->vm_start = start;
+	vma->vm_end = end;
+	vma->vm_pgoff = pgoff;
+}
+
 /* Was this VMA ever forked from a parent, i.e. maybe contains CoW mappings? */
 static bool vma_is_fork_child(struct vm_area_struct *vma)
 {
--- a/tools/testing/vma/shared.c~mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl
+++ a/tools/testing/vma/shared.c
@@ -120,12 +120,3 @@ unsigned long rlimit(unsigned int limit)
 {
 	return (unsigned long)-1;
 }
-
-void vma_set_range(struct vm_area_struct *vma,
-		   unsigned long start, unsigned long end,
-		   pgoff_t pgoff)
-{
-	vma->vm_start = start;
-	vma->vm_end = end;
-	vma->vm_pgoff = pgoff;
-}
--- a/tools/testing/vma/shared.h~mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl
+++ a/tools/testing/vma/shared.h
@@ -125,8 +125,3 @@ void __vma_set_dummy_anon_vma(struct vm_
 /* Provide a simple dummy VMA/anon_vma dummy setup for testing. */
 void vma_set_dummy_anon_vma(struct vm_area_struct *vma,
 			    struct anon_vma_chain *avc);
-
-/* Helper function to specify a VMA's range. */
-void vma_set_range(struct vm_area_struct *vma,
-		   unsigned long start, unsigned long end,
-		   pgoff_t pgoff);
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

