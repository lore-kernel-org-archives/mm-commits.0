Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA37A2F7F01
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723582; cv=none; b=Vzk8TJtfGhx0XkGjnX0uh2Ay+Ih/nbCkcemkMOaPD25zPEeB19IW9X8KrBNEv/ZhqTjxTlzVn1R+8bVXNMuzV7MsqrIsitwemR+i68p7ffog6WRdCiwXIeArNZ622YdDXw0KIUhnKfg0G1Af988SHT1V97nJTEWcllV1+mY97G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723582; c=relaxed/simple;
	bh=LUz4REdMToCmUvdWq6a56xuvmQuUfaBqz+7okR3atu8=;
	h=Date:To:From:Subject:Message-Id; b=bs7YP4yIOZteXEmBEpRp1pp/6wvM0ZsQLLo35pG11s6/2teNgK7kxts6aG7StpJusKDFTS5utCNrg22dJ37GwNU5LZ1urHG1KoUuqw9exinCbqrPZMAJ/CIHYSFgIBpzKkSYLdX9iq2ZX3Eyh3kyPI/GFM8jmJZa5tx4kOO17co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M7o6yJHz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M7o6yJHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5451F000E9;
	Fri, 10 Jul 2026 22:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723580;
	bh=IrforzZ6VqrGE/fcRYXcBYFHXiRWVhTKxmNgGOX3+4g=;
	h=Date:To:From:Subject;
	b=M7o6yJHzyZUyJlJ5Ig7W6YmEqwk1mFspOPtmG0Ts0Taa/XaCiU7/xzp72Vdk1IW0k
	 /51nsCq/3670Ey93u/r032XUqdwYXYpvt55kGZSoVWDRr44xvvQBHABzC6YoyDdyUm
	 WmNo/K1m5WpTIF4YjD8D2GpBBzsc3ECUH7anjQC8=
Date: Fri, 10 Jul 2026 15:46:20 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch added to mm-new branch
Message-Id: <20260710224620.9D5451F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: rename anon_vma_interval_tree_*() to anon_rmap_tree_*()
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch

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
Subject: mm/rmap: rename anon_vma_interval_tree_*() to anon_rmap_tree_*()
Date: Fri, 10 Jul 2026 21:16:52 +0100

To be consistent with the newly renamed mapping_rmap_tree_*(), rename the
anon_vma_interval_tree_*() helpers to anon_rmap_tree_*().

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-11-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h                |   27 +++++++++++--------------
 mm/interval_tree.c                |   30 ++++++++++++++--------------
 mm/ksm.c                          |    4 +--
 mm/memory-failure.c               |    2 -
 mm/rmap.c                         |   10 ++++-----
 mm/vma.c                          |   30 ++++++++++++++--------------
 tools/testing/vma/include/stubs.h |    8 +++----
 7 files changed, 54 insertions(+), 57 deletions(-)

--- a/include/linux/mm.h~mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_
+++ a/include/linux/mm.h
@@ -4114,26 +4114,23 @@ mapping_rmap_tree_iter_next(struct vm_ar
 	     vma; vma = mapping_rmap_tree_iter_next(vma, pgoff_start,	 \
 						    pgoff_last))
 
-void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
-				   struct anon_vma *anon_vma);
-void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
-				   struct anon_vma *anon_vma);
-
+void anon_rmap_tree_insert(struct anon_vma_chain *avc,
+			   struct anon_vma *anon_vma);
+void anon_rmap_tree_remove(struct anon_vma_chain *avc,
+			   struct anon_vma *anon_vma);
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_first(struct anon_vma *anon_vma,
-				  pgoff_t pgoff_start, pgoff_t pgoff_last);
+anon_rmap_tree_iter_first(struct anon_vma *anon_vma,
+			  pgoff_t pgoff_start, pgoff_t pgoff_last);
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_next(struct anon_vma_chain *avc,
-				 pgoff_t pgoff_start, pgoff_t pgoff_last);
+anon_rmap_tree_iter_next(struct anon_vma_chain *avc,
+			 pgoff_t pgoff_start, pgoff_t pgoff_last);
 #ifdef CONFIG_DEBUG_VM_RB
-void anon_vma_interval_tree_verify(struct anon_vma_chain *avc);
+void anon_rmap_tree_verify(struct anon_vma_chain *avc);
 #endif
 
-#define anon_vma_interval_tree_foreach(avc, anon_vma, pgoff_start, pgoff_last) \
-	for (avc = anon_vma_interval_tree_iter_first(anon_vma, pgoff_start,    \
-						     pgoff_last);	       \
-	     avc; avc = anon_vma_interval_tree_iter_next(avc, pgoff_start,     \
-							 pgoff_last))
+#define anon_rmap_tree_foreach(avc, anon_vma, pgoff_start, pgoff_last)		 \
+	for (avc = anon_rmap_tree_iter_first(anon_vma, pgoff_start, pgoff_last); \
+	     avc; avc = anon_rmap_tree_iter_next(avc, pgoff_start, pgoff_last))
 
 /* mmap.c */
 extern int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin);
--- a/mm/interval_tree.c~mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_
+++ a/mm/interval_tree.c
@@ -93,41 +93,41 @@ static pgoff_t avc_last_pgoff(struct ano
 
 INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, pgoff_t, rb_subtree_last,
 		     avc_start_pgoff, avc_last_pgoff,
-		     static, __anon_vma_interval_tree)
+		     static, __anon_rmap_tree)
 
-void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
-				   struct anon_vma *anon_vma)
+void anon_rmap_tree_insert(struct anon_vma_chain *avc,
+			   struct anon_vma *anon_vma)
 {
 #ifdef CONFIG_DEBUG_VM_RB
 	avc->cached_vma_start = avc_start_pgoff(avc);
 	avc->cached_vma_last = avc_last_pgoff(avc);
 #endif
-	__anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
+	__anon_rmap_tree_insert(avc, &anon_vma->rb_root);
 }
 
-void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
-				   struct anon_vma *anon_vma)
+void anon_rmap_tree_remove(struct anon_vma_chain *avc,
+			   struct anon_vma *anon_vma)
 {
-	__anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
+	__anon_rmap_tree_remove(avc, &anon_vma->rb_root);
 }
 
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_first(struct anon_vma *anon_vma,
-				  pgoff_t pgoff_start, pgoff_t pgoff_last)
+anon_rmap_tree_iter_first(struct anon_vma *anon_vma,
+			  pgoff_t pgoff_start, pgoff_t pgoff_last)
 {
-	return __anon_vma_interval_tree_iter_first(&anon_vma->rb_root,
-						   pgoff_start, pgoff_last);
+	return __anon_rmap_tree_iter_first(&anon_vma->rb_root,
+					   pgoff_start, pgoff_last);
 }
 
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_next(struct anon_vma_chain *avc,
-				  pgoff_t pgoff_start, pgoff_t pgoff_last)
+anon_rmap_tree_iter_next(struct anon_vma_chain *avc,
+			 pgoff_t pgoff_start, pgoff_t pgoff_last)
 {
-	return __anon_vma_interval_tree_iter_next(avc, pgoff_start, pgoff_last);
+	return __anon_rmap_tree_iter_next(avc, pgoff_start, pgoff_last);
 }
 
 #ifdef CONFIG_DEBUG_VM_RB
-void anon_vma_interval_tree_verify(struct anon_vma_chain *avc)
+void anon_rmap_tree_verify(struct anon_vma_chain *avc)
 {
 	WARN_ON_ONCE(avc->cached_vma_start != avc_start_pgoff(avc));
 	WARN_ON_ONCE(avc->cached_vma_last != avc_last_pgoff(avc));
--- a/mm/ksm.c~mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_
+++ a/mm/ksm.c
@@ -3232,7 +3232,7 @@ again:
 		 * we wouldn't have the KSM folio mapped in these processes
 		 * anymore.
 		 */
-		anon_vma_interval_tree_foreach(vmac, anon_vma, index, index) {
+		anon_rmap_tree_foreach(vmac, anon_vma, index, index) {
 
 			cond_resched();
 			vma = vmac->vma;
@@ -3294,7 +3294,7 @@ void collect_procs_ksm(const struct foli
 				task_early_kill(tsk, force_early);
 			if (!t)
 				continue;
-			anon_vma_interval_tree_foreach(vmac, av, index, index)
+			anon_rmap_tree_foreach(vmac, av, index, index)
 			{
 				vma = vmac->vma;
 				if (vma->vm_mm == t->mm) {
--- a/mm/memory-failure.c~mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_
+++ a/mm/memory-failure.c
@@ -564,7 +564,7 @@ static void collect_procs_anon(const str
 
 		if (!t)
 			continue;
-		anon_vma_interval_tree_foreach(vmac, av, pgoff, pgoff) {
+		anon_rmap_tree_foreach(vmac, av, pgoff, pgoff) {
 			vma = vmac->vma;
 			if (vma->vm_mm != t->mm)
 				continue;
--- a/mm/rmap.c~mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_
+++ a/mm/rmap.c
@@ -211,7 +211,7 @@ int __anon_vma_prepare(struct vm_area_st
 	if (likely(!vma->anon_vma)) {
 		vma->anon_vma = anon_vma;
 		anon_vma_chain_assign(vma, avc, anon_vma);
-		anon_vma_interval_tree_insert(avc, anon_vma);
+		anon_rmap_tree_insert(avc, anon_vma);
 		anon_vma->num_active_vmas++;
 		allocated = NULL;
 		avc = NULL;
@@ -354,7 +354,7 @@ int anon_vma_clone(struct vm_area_struct
 	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		anon_vma_interval_tree_insert(avc, anon_vma);
+		anon_rmap_tree_insert(avc, anon_vma);
 		if (operation == VMA_OP_FORK)
 			maybe_reuse_anon_vma(dst, anon_vma);
 	}
@@ -434,7 +434,7 @@ int anon_vma_fork(struct vm_area_struct
 	anon_vma_chain_assign(vma, avc, anon_vma);
 	/* Now let rmap see it. */
 	anon_vma_lock_write(anon_vma);
-	anon_vma_interval_tree_insert(avc, anon_vma);
+	anon_rmap_tree_insert(avc, anon_vma);
 	anon_vma->parent->num_children++;
 	anon_vma_unlock_write(anon_vma);
 
@@ -499,7 +499,7 @@ void unlink_anon_vmas(struct vm_area_str
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		anon_vma_interval_tree_remove(avc, anon_vma);
+		anon_rmap_tree_remove(avc, anon_vma);
 
 		/*
 		 * Leave empty anon_vmas on the list - we'll need
@@ -2988,7 +2988,7 @@ static void rmap_walk_anon(struct folio
 
 	pgoff_start = folio_pgoff(folio);
 	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
-	anon_vma_interval_tree_foreach(avc, anon_vma, pgoff_start, pgoff_end) {
+	anon_rmap_tree_foreach(avc, anon_vma, pgoff_start, pgoff_end) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(vma, pgoff_start,
 				folio_nr_pages(folio));
--- a/mm/vma.c~mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_
+++ a/mm/vma.c
@@ -258,30 +258,30 @@ static void __remove_shared_vm_struct(st
  *
  * Before updating the vma's vm_start / vm_end / vm_pgoff fields, the
  * vma must be removed from the anon_vma's interval trees using
- * anon_vma_interval_tree_pre_update_vma().
+ * anon_rmap_tree_pre_update_vma().
  *
  * After the update, the vma will be reinserted using
- * anon_vma_interval_tree_post_update_vma().
+ * anon_rmap_tree_post_update_vma().
  *
  * The entire update must be protected by exclusive mmap_lock and by
  * the root anon_vma's mutex.
  */
 static void
-anon_vma_interval_tree_pre_update_vma(struct vm_area_struct *vma)
+anon_rmap_tree_pre_update_vma(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc;
 
 	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-		anon_vma_interval_tree_remove(avc, avc->anon_vma);
+		anon_rmap_tree_remove(avc, avc->anon_vma);
 }
 
 static void
-anon_vma_interval_tree_post_update_vma(struct vm_area_struct *vma)
+anon_rmap_tree_post_update_vma(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc;
 
 	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-		anon_vma_interval_tree_insert(avc, avc->anon_vma);
+		anon_rmap_tree_insert(avc, avc->anon_vma);
 }
 
 /*
@@ -312,9 +312,9 @@ static void vma_prepare(struct vma_prepa
 
 	if (vp->anon_vma) {
 		anon_vma_lock_write(vp->anon_vma);
-		anon_vma_interval_tree_pre_update_vma(vp->vma);
+		anon_rmap_tree_pre_update_vma(vp->vma);
 		if (vp->adj_next)
-			anon_vma_interval_tree_pre_update_vma(vp->adj_next);
+			anon_rmap_tree_pre_update_vma(vp->adj_next);
 	}
 
 	if (vp->file) {
@@ -359,9 +359,9 @@ static void vma_complete(struct vma_prep
 	}
 
 	if (vp->anon_vma) {
-		anon_vma_interval_tree_post_update_vma(vp->vma);
+		anon_rmap_tree_post_update_vma(vp->vma);
 		if (vp->adj_next)
-			anon_vma_interval_tree_post_update_vma(vp->adj_next);
+			anon_rmap_tree_post_update_vma(vp->adj_next);
 		anon_vma_unlock_write(vp->anon_vma);
 	}
 
@@ -677,7 +677,7 @@ void validate_mm(struct mm_struct *mm)
 		if (anon_vma) {
 			anon_vma_lock_read(anon_vma);
 			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-				anon_vma_interval_tree_verify(avc);
+				anon_rmap_tree_verify(avc);
 			anon_vma_unlock_read(anon_vma);
 		}
 #endif
@@ -3177,11 +3177,11 @@ int expand_upwards(struct vm_area_struct
 				if (vma_test(vma, VMA_LOCKED_BIT))
 					mm->locked_vm += grow;
 				vm_stat_account(mm, vma->vm_flags, grow);
-				anon_vma_interval_tree_pre_update_vma(vma);
+				anon_rmap_tree_pre_update_vma(vma);
 				vma->vm_end = address;
 				/* Overwrite old entry in mtree. */
 				vma_iter_store_overwrite(&vmi, vma);
-				anon_vma_interval_tree_post_update_vma(vma);
+				anon_rmap_tree_post_update_vma(vma);
 
 				perf_event_mmap(vma);
 			}
@@ -3256,12 +3256,12 @@ int expand_downwards(struct vm_area_stru
 				if (vma_test(vma, VMA_LOCKED_BIT))
 					mm->locked_vm += grow;
 				vm_stat_account(mm, vma->vm_flags, grow);
-				anon_vma_interval_tree_pre_update_vma(vma);
+				anon_rmap_tree_pre_update_vma(vma);
 				vma->vm_start = address;
 				vma->vm_pgoff -= grow;
 				/* Overwrite old entry in mtree. */
 				vma_iter_store_overwrite(&vmi, vma);
-				anon_vma_interval_tree_post_update_vma(vma);
+				anon_rmap_tree_post_update_vma(vma);
 
 				perf_event_mmap(vma);
 			}
--- a/tools/testing/vma/include/stubs.h~mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_
+++ a/tools/testing/vma/include/stubs.h
@@ -271,13 +271,13 @@ static inline void flush_dcache_mmap_unl
 {
 }
 
-static inline void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
-						 struct anon_vma *anon_vma)
+static inline void anon_rmap_tree_insert(struct anon_vma_chain *avc,
+					 struct anon_vma *anon_vma)
 {
 }
 
-static inline void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
-						 struct anon_vma *anon_vma)
+static inline void anon_rmap_tree_remove(struct anon_vma_chain *avc,
+					 struct anon_vma *anon_vma)
 {
 }
 
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

