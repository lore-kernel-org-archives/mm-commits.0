Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82F23C1089
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896761; cv=none; b=dA1N0Hi32JuFjV0pWSWbq2VGBIc08qcdYgkBMeQ5bBV2Kxu1MMMaPYcukLg5WVcs+4yLaV/86jzwBjCmyIm0LvrASTICpFu0LjLfnDbD1rr9hvOMe3A7Vlvr7G4OBGyjB8N5pD6nbWpVrumDKksqz5wz/+LpTZELlyglk18ana8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896761; c=relaxed/simple;
	bh=MLy8BDh6DvRxxN1+jqAnu9DLgVrWS/gWTqa7reZvvCY=;
	h=Date:To:From:Subject:Message-Id; b=TyNIQA2J2RYg9KR4P5TakdeL1zbq4/sK3JuC2Kvp+vig7JQg1Fg0ZHaYPUZ7Ru9L5qdM0KtfI9MEnBuSQ208U1bEw+eOhfcfAaLloRcFn6S7zruiX8TSrVgli1g9A//7e52JW1513noJ3udGoA2qkkRIt8KNoLrGuOaA/3M+NBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BWJldNuu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BWJldNuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F11A1F000E9;
	Wed,  5 Aug 2026 02:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896759;
	bh=Y3Jbm7Ho+7Dkm/1L5r6d3ou1m0qZg3wWAfpAuh6J9l8=;
	h=Date:To:From:Subject;
	b=BWJldNuu70tdW/f+PBPdirYyOiA7o3QF9ncmmBjHnopbzQ0Gi2VyYqThevMUsL/gx
	 4Osqa1vyCI+88WlRrZ6hRmJOfZmbfAlXz+ZVMAijMQC3uUMl28hVQt1qaFRV9UieJn
	 /HwN8i/eTzIok37f1x7LJijt+PhB94WYi8xmUpDw=
Date: Tue, 04 Aug 2026 19:25:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,sj@kernel.org,pfalcato@suse.de,m.szyprowski@samsung.com,liam@infradead.org,kai.huang@intel.com,gourry@gourry.net,david@kernel.org,ackerleytng@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma.patch removed from -mm tree
Message-Id: <20260805022559.7F11A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: parameterise anon_vma_interval_tree_*() by anon_vma
has been removed from the -mm tree.  Its filename was
     mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/rmap: parameterise anon_vma_interval_tree_*() by anon_vma
Date: Fri, 10 Jul 2026 21:16:50 +0100

Similar to what we did with mapping_rmap_tree*(), let's declare
anon_vma_interval_tree*() in terms of anon_vma rather than rb_root_cached.

In each case the rb tree referenced is &anon_vma->rb_root, so just pass
anon_vma and the functions can figure this out themselves.

Also update the VMA userland tests to reflect the change.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-9-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h                |   11 ++++++-----
 mm/interval_tree.c                |   13 +++++++------
 mm/ksm.c                          |    6 ++----
 mm/memory-failure.c               |    3 +--
 mm/rmap.c                         |   11 +++++------
 mm/vma.c                          |    4 ++--
 tools/testing/vma/include/stubs.h |    4 ++--
 7 files changed, 25 insertions(+), 27 deletions(-)

--- a/include/linux/mm.h~mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma
+++ a/include/linux/mm.h
@@ -4115,14 +4115,15 @@ mapping_rmap_tree_iter_next(struct vm_ar
 						    pgoff_last))
 
 void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
-				   struct rb_root_cached *root);
+				   struct anon_vma *anon_vma);
 void anon_vma_interval_tree_remove(struct anon_vma_chain *node,
-				   struct rb_root_cached *root);
+				   struct anon_vma *anon_vma);
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_first(struct rb_root_cached *root,
+anon_vma_interval_tree_iter_first(struct anon_vma *anon_vma,
 				  unsigned long start, unsigned long last);
-struct anon_vma_chain *anon_vma_interval_tree_iter_next(
-	struct anon_vma_chain *node, unsigned long start, unsigned long last);
+struct anon_vma_chain *
+anon_vma_interval_tree_iter_next(struct anon_vma_chain *avc,
+				 unsigned long start, unsigned long last);
 #ifdef CONFIG_DEBUG_VM_RB
 void anon_vma_interval_tree_verify(struct anon_vma_chain *node);
 #endif
--- a/mm/interval_tree.c~mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma
+++ a/mm/interval_tree.c
@@ -96,26 +96,27 @@ INTERVAL_TREE_DEFINE(struct anon_vma_cha
 		     static, __anon_vma_interval_tree)
 
 void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
-				   struct rb_root_cached *root)
+				   struct anon_vma *anon_vma)
 {
 #ifdef CONFIG_DEBUG_VM_RB
 	node->cached_vma_start = avc_start_pgoff(node);
 	node->cached_vma_last = avc_last_pgoff(node);
 #endif
-	__anon_vma_interval_tree_insert(node, root);
+	__anon_vma_interval_tree_insert(node, &anon_vma->rb_root);
 }
 
 void anon_vma_interval_tree_remove(struct anon_vma_chain *node,
-				   struct rb_root_cached *root)
+				   struct anon_vma *anon_vma)
 {
-	__anon_vma_interval_tree_remove(node, root);
+	__anon_vma_interval_tree_remove(node, &anon_vma->rb_root);
 }
 
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_first(struct rb_root_cached *root,
+anon_vma_interval_tree_iter_first(struct anon_vma *anon_vma,
 				  unsigned long first, unsigned long last)
 {
-	return __anon_vma_interval_tree_iter_first(root, first, last);
+	return __anon_vma_interval_tree_iter_first(&anon_vma->rb_root,
+						   first, last);
 }
 
 struct anon_vma_chain *
--- a/mm/ksm.c~mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma
+++ a/mm/ksm.c
@@ -3232,8 +3232,7 @@ again:
 		 * we wouldn't have the KSM folio mapped in these processes
 		 * anymore.
 		 */
-		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
-					       index, index) {
+		anon_vma_interval_tree_foreach(vmac, anon_vma, index, index) {
 
 			cond_resched();
 			vma = vmac->vma;
@@ -3295,8 +3294,7 @@ void collect_procs_ksm(const struct foli
 				task_early_kill(tsk, force_early);
 			if (!t)
 				continue;
-			anon_vma_interval_tree_foreach(vmac, &av->rb_root, index,
-						       index)
+			anon_vma_interval_tree_foreach(vmac, av, index, index)
 			{
 				vma = vmac->vma;
 				if (vma->vm_mm == t->mm) {
--- a/mm/memory-failure.c~mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma
+++ a/mm/memory-failure.c
@@ -564,8 +564,7 @@ static void collect_procs_anon(const str
 
 		if (!t)
 			continue;
-		anon_vma_interval_tree_foreach(vmac, &av->rb_root,
-					       pgoff, pgoff) {
+		anon_vma_interval_tree_foreach(vmac, av, pgoff, pgoff) {
 			vma = vmac->vma;
 			if (vma->vm_mm != t->mm)
 				continue;
--- a/mm/rmap.c~mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma
+++ a/mm/rmap.c
@@ -211,7 +211,7 @@ int __anon_vma_prepare(struct vm_area_st
 	if (likely(!vma->anon_vma)) {
 		vma->anon_vma = anon_vma;
 		anon_vma_chain_assign(vma, avc, anon_vma);
-		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
+		anon_vma_interval_tree_insert(avc, anon_vma);
 		anon_vma->num_active_vmas++;
 		allocated = NULL;
 		avc = NULL;
@@ -354,7 +354,7 @@ int anon_vma_clone(struct vm_area_struct
 	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
+		anon_vma_interval_tree_insert(avc, anon_vma);
 		if (operation == VMA_OP_FORK)
 			maybe_reuse_anon_vma(dst, anon_vma);
 	}
@@ -434,7 +434,7 @@ int anon_vma_fork(struct vm_area_struct
 	anon_vma_chain_assign(vma, avc, anon_vma);
 	/* Now let rmap see it. */
 	anon_vma_lock_write(anon_vma);
-	anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
+	anon_vma_interval_tree_insert(avc, anon_vma);
 	anon_vma->parent->num_children++;
 	anon_vma_unlock_write(anon_vma);
 
@@ -499,7 +499,7 @@ void unlink_anon_vmas(struct vm_area_str
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
+		anon_vma_interval_tree_remove(avc, anon_vma);
 
 		/*
 		 * Leave empty anon_vmas on the list - we'll need
@@ -2988,8 +2988,7 @@ static void rmap_walk_anon(struct folio
 
 	pgoff_start = folio_pgoff(folio);
 	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
-	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
-			pgoff_start, pgoff_end) {
+	anon_vma_interval_tree_foreach(avc, anon_vma, pgoff_start, pgoff_end) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(vma, pgoff_start,
 				folio_nr_pages(folio));
--- a/mm/vma.c~mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma
+++ a/mm/vma.c
@@ -272,7 +272,7 @@ anon_vma_interval_tree_pre_update_vma(st
 	struct anon_vma_chain *avc;
 
 	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-		anon_vma_interval_tree_remove(avc, &avc->anon_vma->rb_root);
+		anon_vma_interval_tree_remove(avc, avc->anon_vma);
 }
 
 static void
@@ -281,7 +281,7 @@ anon_vma_interval_tree_post_update_vma(s
 	struct anon_vma_chain *avc;
 
 	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-		anon_vma_interval_tree_insert(avc, &avc->anon_vma->rb_root);
+		anon_vma_interval_tree_insert(avc, avc->anon_vma);
 }
 
 /*
--- a/tools/testing/vma/include/stubs.h~mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma
+++ a/tools/testing/vma/include/stubs.h
@@ -272,12 +272,12 @@ static inline void flush_dcache_mmap_unl
 }
 
 static inline void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
-						 struct rb_root_cached *rb)
+						 struct anon_vma *anon_vma)
 {
 }
 
 static inline void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
-						 struct rb_root_cached *rb)
+						 struct anon_vma *anon_vma)
 {
 }
 
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
arm64-remove-redundant-concurrent-ptdump-uaf-mitigation.patch
mm-huge_memory-fix-huge_zero_pfn-race.patch
mm-huge_memory-separate-out-config_persistent_huge_zero_folio-logic.patch
x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch
mm-vma-update-do_mmap-to-use-vma_flags_t.patch
mm-convert-__get_unmapped_area-to-use-vma_flags_t.patch
mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch
mm-prefer-mm-def_vma_flags-in-mm-logic.patch
mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch
mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch
mm-introduce-vma_get_page_prot-and-use-it.patch
mm-vma-update-create_init_stack_vma-to-use-vma_flags_t.patch
mm-vma-convert-miscellaneous-uses-of-vma-flags-in-core-mm.patch
mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch
mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch
mm-mremap-convert-mremap-code-to-use-vma_flags_t.patch
mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch
mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch
mm-mseal-remove-further-superfluous-comments-do_mseal.patch
mm-vma-introduce-vma-virtual-page-offset-field-and-add-helpers.patch
mm-introduce-linear_virt_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-virtual-page-index.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-walk-is-anonymous.patch
mm-introduce-and-use-linear_folio_page_index.patch
mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-virt-pgoff.patch
tools-testing-selftests-mm-test-virtual-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch

