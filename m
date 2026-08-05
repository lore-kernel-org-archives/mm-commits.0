Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CC93C062C
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896764; cv=none; b=Lj0WtGCv4OB3fduo+CczhTdLST+H8HPDSBzBjoZQGhr6JTkfOkPtwW3MJNSxopW1fM6dIfMvZjyV7XNUQVaiUqhXjbIOen7C4slvFF/SD1QxGJymXiHwN3u/FyQPJ61vRUf1r82dYAPBqyE70pCMXXilY70mGRZoFna0Idq8ies=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896764; c=relaxed/simple;
	bh=1vwltsT3X3mbV1A6QvrXXxVKtwqo3Iuws8z5ZwAK2Dk=;
	h=Date:To:From:Subject:Message-Id; b=sOlM6wzM/lyK6dkGS2JNc4ucNLAt0lgdg/rDAP8dnSzDXpgazPFROTVkYbCOXId1dI8N/w3Gei4QtjpeHepomvdAGbMIWlLFe6FTMLSVLHigya5sUIkcHb2ebk5XrwYifjjhNzpaXv5n/or0FlBoy5hpx5oMwowj6xebbXtApLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JsFJSTsV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JsFJSTsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2561F000E9;
	Wed,  5 Aug 2026 02:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896762;
	bh=44GpvipHLz3+8a0IkBTFPoIUD6LkhQaAb3/ydXnij7w=;
	h=Date:To:From:Subject;
	b=JsFJSTsVrRlU+cdmjnmDYRiOjYQODBICi5PBmodOQnOWIR927ZtHvmeZ4Jsj+tW6S
	 2O8JLRPttB/dHA9yY1RuI5/x2/8b+53W1GHWVP0KMdXqSTQJ6I1p7p8TYJENe/BOuT
	 waiF+gOX75yVRgZMDK299uFs+A5HAqLzQoM9zfpY=
Date: Tue, 04 Aug 2026 19:26:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,sj@kernel.org,pfalcato@suse.de,m.szyprowski@samsung.com,liam@infradead.org,kai.huang@intel.com,gourry@gourry.net,david@kernel.org,ackerleytng@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch removed from -mm tree
Message-Id: <20260805022602.6B2561F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: rename anon_vma_interval_tree_*() to anon_rmap_tree_*()
has been removed from the -mm tree.  Its filename was
     mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
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

