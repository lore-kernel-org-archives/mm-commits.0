Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9872538DC66
	for <mm-commits@vger.kernel.org>; Wed, 30 Sep 2026 18:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791653; cv=none; b=N38EGQrR+Oi45DWbkLXJHeG7Ol9n3DCbaoDU7N73CtAvqZ7JU+W4rlINrpPEQkR777FqAJZdjzvMVZJd3e8oIPlGnBoKEaVyaj9w6GIty0RxkXEOqMaBs7mhG2gKsUNq3uGKxYJ4Embxg1tTdaCCxt+Ul9bfr6qbE/Eq0QGLtwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791653; c=relaxed/simple;
	bh=v2QF4+kHZV4c3inDImfF8ZSN0bEv8LDeHnBZHgvbQxg=;
	h=Date:To:From:Subject:Message-Id; b=SKvdUxRoimsSbqdr5YEAbjgUeiRGyfRo3/mAMGpJKqpXPkByEbb3D50Mh/X3rKA8M3Zce7PfNKZTBw+0QE8r4kLHSWGF+yh5nYQgFcnMGwQwsWTsTEu03zHHzsJh98CmO7tIv04Tb/ttQJtkL4T9UB0URnj41zZ5OiT4BwlVMa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=egy5XbdZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="egy5XbdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4793B1F000FF;
	Wed, 30 Sep 2026 18:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790791651;
	bh=xBg/+IktCyWWV9z2a9ua62oz/vQUVp/aOF9mksHpv1s=;
	h=Date:To:From:Subject;
	b=egy5XbdZycQpWmpvrG2hgYLKu/uCE2rKbQ/lcPwNJtk8eF0usKInFrYJiqrQU2Tx6
	 DujRGJFWoEjDPW538UV7kENHpDgZBP6eXl+16q32TKnuaeXnvvxDItVs7zecx4xvat
	 txXZByxpS7bQkd6nfBgeR8M4hbiC2VZDzbnTwY4w=
Date: Wed, 30 Sep 2026 11:07:30 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,pan.deng@intel.com,mhocko@suse.com,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,harry@kernel.org,david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged.patch added to mm-unstable branch
Message-Id: <20260930180731.4793B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: don't remove VMA from rmap if pgoff unchanged
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: don't remove VMA from rmap if pgoff unchanged
Date: Wed, 30 Sep 2026 18:53:36 +0100

When updating a VMA, vma_prepare() unconditionally removes it from its
rmap interval trees under the rmap lock, and vma_complete() reinserts it
before releasing the lock.

This is wholly unnecessary if its page offset (file rmap) or anonymous
page offset (anon rmap) is unchanged.

So, track whether they will change in the newly introduced
vp->file_pgoff_unchanged and vp->anon_pgoff_unchanged fields, and use them
to determine whether to remove the VMA or not.

The rmap lock keeps things safe as no rmap walks can concurrently occur
during the operation.

Additionally, some architectures (arm, parisc, nios2, csky) have dcache
flush rmap walkers which take only flush_dcache_mmap_lock(), which is
likewise held across the operation.

If the VMA remains in the tree, it's necessary to keep the augmented
rb_subtree_last field updated to reflect its changed range.

Provide mapping_rmap_tree_[pre, post]_update() and anon_rmap_tree_[pre,
post]_update_vma() (replacing the existing logic in the anonymous case) to
handle both the changed and unchanged cases.

For the anon rmap case, with CONFIG_DEBUG_VM_RB set, avc->cached_vma_last
is also updated when propagating in place.

When performing a VMA shrink or a split where the VMA is the lower one,
the page offset cannot change, so set the flags unconditionally in these
cases.

When merging VMAs the page offset is unchanged only in some cases, so
update init_multi_vma_prep() to set the flags only if the page offsets
remain the same.

Finally, while we're here, also update expand_upwards() similarly.

These changes ultimately result in less rmap lock contention.

Pan Deng reported results using the UnixBench/excel benchmark on a
2-socket 192 core, 384 thread x86-64 system for v7.3-rc4 with/without the
patch applied:

Execl Throughput, index score:

                    avg    %stdev      min        max
  v7.3-rc4        3511.5     0.44%    3494.5    3543.4
  + patch         4069.0     0.48%    4047.4    4109.5 (+15.9%)

Average wait on file rmap lock in ms, 5 runs per kernel:

               avg      %stdev     min       max
  v7.3-rc4    9.470     2.91%     9.070     9.820
  + patch     8.420     3.34%     8.100     8.770 (-11.1%)

Profiling data obtained during the operation highlighted the file rmap lock
as the primary source of contention.

Link: https://lore.kernel.org/20260930-speed-up-inplace-rmap-v2-1-ac1aa19708aa@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Pan Deng <pan.deng@intel.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Pedro Falcato <pfalcato@suse.de>
---

 include/linux/mm.h                |   10 ++
 mm/interval_tree.c                |  101 ++++++++++++++++++++++++++++
 mm/vma.c                          |   74 ++++++++------------
 mm/vma.h                          |    2 
 tools/testing/vma/include/stubs.h |   22 ++++++
 5 files changed, 164 insertions(+), 45 deletions(-)

--- a/include/linux/mm.h~mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged
+++ a/include/linux/mm.h
@@ -4358,6 +4358,12 @@ void mapping_rmap_tree_insert_after(stru
 				    struct address_space *mapping);
 void mapping_rmap_tree_remove(struct vm_area_struct *vma,
 			      struct address_space *mapping);
+void mapping_rmap_tree_pre_update(struct vm_area_struct *vma,
+				  struct address_space *mapping,
+				  bool pgoff_unchanged);
+void mapping_rmap_tree_post_update(struct vm_area_struct *vma,
+				   struct address_space *mapping,
+				   bool pgoff_unchanged);
 struct vm_area_struct *
 mapping_rmap_tree_iter_first(struct address_space *mapping,
 			     pgoff_t pgoff_start, pgoff_t pgoff_last);
@@ -4375,6 +4381,10 @@ void anon_rmap_tree_insert(struct anon_v
 			   struct anon_vma *anon_vma);
 void anon_rmap_tree_remove(struct anon_vma_chain *avc,
 			   struct anon_vma *anon_vma);
+void anon_rmap_tree_pre_update_vma(struct vm_area_struct *vma,
+				   bool anon_pgoff_unchanged);
+void anon_rmap_tree_post_update_vma(struct vm_area_struct *vma,
+				    bool anon_pgoff_unchanged);
 struct anon_vma_chain *
 anon_rmap_tree_iter_first(struct anon_vma *anon_vma,
 			  pgoff_t pgoff_start, pgoff_t pgoff_last);
--- a/mm/interval_tree.c~mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged
+++ a/mm/interval_tree.c
@@ -64,6 +64,51 @@ void mapping_rmap_tree_remove(struct vm_
 	__mapping_rmap_tree_remove(vma, &mapping->i_mmap);
 }
 
+static void mapping_rmap_tree_update_inplace(struct vm_area_struct *vma)
+{
+	/* Propagate all the way up the tree. */
+	__mapping_rmap_tree_augment.propagate(&vma->shared.rb, NULL);
+}
+
+/**
+ * mapping_rmap_tree_pre_update() - Prepare the file rmap tree for a change to
+ * be made to @vma.
+ * @vma: The VMA about to be updated.
+ * @mapping: The file rmap to which @vma belongs.
+ * @pgoff_unchanged: Whether @vma's page offset will remain unchanged.
+ *
+ * The file rmap lock must be held across the entire update.
+ */
+void mapping_rmap_tree_pre_update(struct vm_area_struct *vma,
+				  struct address_space *mapping,
+				  bool pgoff_unchanged)
+{
+	/* If the pgoff has changed, then remove and reinsert afterwards. */
+	if (!pgoff_unchanged)
+		mapping_rmap_tree_remove(vma, mapping);
+}
+
+/**
+ * mapping_rmap_tree_post_update() - Update the file rmap tree to reflect a
+ * change that has been made to @vma.
+ * @vma: The VMA that has been updated.
+ * @mapping: The file rmap to which @vma belongs.
+ * @pgoff_unchanged: Whether @vma's page offset remained unchanged.
+ *
+ * mapping_rmap_tree_pre_update() must have been called prior to this.
+ *
+ * The file rmap lock must be held across the entire update.
+ */
+void mapping_rmap_tree_post_update(struct vm_area_struct *vma,
+				   struct address_space *mapping,
+				   bool pgoff_unchanged)
+{
+	if (pgoff_unchanged)
+		mapping_rmap_tree_update_inplace(vma);
+	else
+		mapping_rmap_tree_insert(vma, mapping);
+}
+
 struct vm_area_struct *
 mapping_rmap_tree_iter_first(struct address_space *mapping,
 			     pgoff_t pgoff_start, pgoff_t pgoff_last)
@@ -111,6 +156,62 @@ void anon_rmap_tree_remove(struct anon_v
 	__anon_rmap_tree_remove(avc, &anon_vma->rb_root);
 }
 
+static void anon_rmap_tree_update_inplace(struct anon_vma_chain *avc)
+{
+#ifdef CONFIG_DEBUG_VM_RB
+	avc->cached_vma_last = avc_last_pgoff(avc);
+#endif
+	/* Propagate all the way up the tree. */
+	__anon_rmap_tree_augment.propagate(&avc->rb, NULL);
+}
+
+/**
+ * anon_rmap_tree_pre_update_vma() - Prepare the anon rmap trees for a change
+ * to be made to @vma.
+ * @vma: The VMA about to be updated, which has an anon rmap assigned and is
+ *       already inserted on its interval trees.
+ * @anon_pgoff_unchanged: Whether @vma's anonymous page offset will remain
+ *                        unchanged.
+ *
+ * The anon rmap lock must be held across the entire update.
+ */
+void anon_rmap_tree_pre_update_vma(struct vm_area_struct *vma,
+				   bool anon_pgoff_unchanged)
+{
+	struct anon_vma_chain *avc;
+
+	if (anon_pgoff_unchanged)
+		return;
+
+	/* If the pgoff has changed, then remove and reinsert afterwards. */
+	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
+		anon_rmap_tree_remove(avc, avc->anon_vma);
+}
+
+/**
+ * anon_rmap_tree_post_update_vma() - Update the anon rmap trees to reflect a
+ * change that has been made to @vma.
+ * @vma: The VMA that has been updated.
+ * @anon_pgoff_unchanged: Whether @vma's anonymous page offset remained
+ *                        unchanged.
+ *
+ * anon_rmap_tree_pre_update_vma() must have been called prior to this.
+ *
+ * The anon rmap lock must be held across the entire update.
+ */
+void anon_rmap_tree_post_update_vma(struct vm_area_struct *vma,
+				    bool anon_pgoff_unchanged)
+{
+	struct anon_vma_chain *avc;
+
+	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma) {
+		if (anon_pgoff_unchanged)
+			anon_rmap_tree_update_inplace(avc);
+		else
+			anon_rmap_tree_insert(avc, avc->anon_vma);
+	}
+}
+
 struct anon_vma_chain *
 anon_rmap_tree_iter_first(struct anon_vma *anon_vma,
 			  pgoff_t pgoff_start, pgoff_t pgoff_last)
--- a/mm/vma.c~mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged
+++ a/mm/vma.c
@@ -201,8 +201,15 @@ static void init_multi_vma_prep(struct v
 	if (vp->file)
 		vp->mapping = vma->vm_file->f_mapping;
 
-	if (vmg && vmg->skip_vma_uprobe)
+	if (!vmg)
+		return;
+
+	if (vmg->skip_vma_uprobe)
 		vp->skip_vma_uprobe = true;
+	if (vma_start_pgoff(vma) == vmg_start_pgoff(vmg))
+		vp->file_pgoff_unchanged = true;
+	if (vma_start_anon_pgoff(vma) == vmg_start_anon_pgoff(vmg))
+		vp->anon_pgoff_unchanged = true;
 }
 
 /*
@@ -300,38 +307,6 @@ static void __remove_shared_vm_struct(st
 }
 
 /*
- * vma has an anon rmap assigned, and is already inserted on its interval
- * trees.
- *
- * Before updating the vma's vm_start / vm_end / vm_pgoff fields, the
- * vma must be removed from the anon rmap's interval trees using
- * anon_rmap_tree_pre_update_vma().
- *
- * After the update, the vma will be reinserted using
- * anon_rmap_tree_post_update_vma().
- *
- * The entire update must be protected by exclusive mmap_lock and by
- * the anon rmap root lock.
- */
-static void
-anon_rmap_tree_pre_update_vma(struct vm_area_struct *vma)
-{
-	struct anon_vma_chain *avc;
-
-	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-		anon_rmap_tree_remove(avc, avc->anon_vma);
-}
-
-static void
-anon_rmap_tree_post_update_vma(struct vm_area_struct *vma)
-{
-	struct anon_vma_chain *avc;
-
-	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-		anon_rmap_tree_insert(avc, avc->anon_vma);
-}
-
-/*
  * vma_prepare() - Helper function for handling locking VMAs prior to altering
  * @vp: The initialized vma_prepare struct
  */
@@ -359,16 +334,19 @@ static void vma_prepare(struct vma_prepa
 
 	if (vp->anon_vma) {
 		anon_vma_lock_write(vp->anon_vma);
-		anon_rmap_tree_pre_update_vma(vp->vma);
+		anon_rmap_tree_pre_update_vma(vp->vma, vp->anon_pgoff_unchanged);
+		/* The adjacent VMA's start is moved, so its page offset changes. */
 		if (vp->adj_next)
-			anon_rmap_tree_pre_update_vma(vp->adj_next);
+			anon_rmap_tree_pre_update_vma(vp->adj_next, false);
 	}
 
 	if (vp->file) {
 		flush_dcache_mmap_lock(vp->mapping);
-		mapping_rmap_tree_remove(vp->vma, vp->mapping);
+		mapping_rmap_tree_pre_update(vp->vma, vp->mapping,
+					     vp->file_pgoff_unchanged);
 		if (vp->adj_next)
-			mapping_rmap_tree_remove(vp->adj_next, vp->mapping);
+			mapping_rmap_tree_pre_update(vp->adj_next, vp->mapping,
+						     false);
 	}
 
 }
@@ -386,8 +364,10 @@ static void vma_complete(struct vma_prep
 {
 	if (vp->file) {
 		if (vp->adj_next)
-			mapping_rmap_tree_insert(vp->adj_next, vp->mapping);
-		mapping_rmap_tree_insert(vp->vma, vp->mapping);
+			mapping_rmap_tree_post_update(vp->adj_next, vp->mapping,
+						      false);
+		mapping_rmap_tree_post_update(vp->vma, vp->mapping,
+					      vp->file_pgoff_unchanged);
 		flush_dcache_mmap_unlock(vp->mapping);
 	}
 
@@ -406,9 +386,9 @@ static void vma_complete(struct vma_prep
 	}
 
 	if (vp->anon_vma) {
-		anon_rmap_tree_post_update_vma(vp->vma);
+		anon_rmap_tree_post_update_vma(vp->vma, vp->anon_pgoff_unchanged);
 		if (vp->adj_next)
-			anon_rmap_tree_post_update_vma(vp->adj_next);
+			anon_rmap_tree_post_update_vma(vp->adj_next, false);
 		anon_vma_unlock_write(vp->anon_vma);
 	}
 
@@ -593,6 +573,8 @@ __split_vma(struct vma_iterator *vmi, st
 
 	init_vma_prep(&vp, vma);
 	vp.insert = new;
+	vp.file_pgoff_unchanged = !new_below;
+	vp.anon_pgoff_unchanged = !new_below;
 	vma_prepare(&vp);
 
 	/*
@@ -1346,6 +1328,8 @@ int vma_shrink(struct vma_iterator *vmi,
 	vma_start_write(vma);
 
 	init_vma_prep(&vp, vma);
+	vp.file_pgoff_unchanged = true;
+	vp.anon_pgoff_unchanged = true;
 	vma_prepare(&vp);
 	vma_adjust_trans_huge(vma, vma->vm_start, end, NULL);
 
@@ -3453,11 +3437,11 @@ int expand_upwards(struct vm_area_struct
 				if (vma_test(vma, VMA_LOCKED_BIT))
 					mm->locked_vm += grow;
 				vm_stat_account(mm, vma->vm_flags, grow);
-				anon_rmap_tree_pre_update_vma(vma);
+				anon_rmap_tree_pre_update_vma(vma, true);
 				vma->vm_end = address;
 				/* Overwrite old entry in mtree. */
 				vma_iter_store_overwrite(&vmi, vma);
-				anon_rmap_tree_post_update_vma(vma);
+				anon_rmap_tree_post_update_vma(vma, true);
 
 				perf_event_mmap(vma);
 			}
@@ -3530,12 +3514,12 @@ int expand_downwards(struct vm_area_stru
 				if (vma_test(vma, VMA_LOCKED_BIT))
 					mm->locked_vm += grow;
 				vm_stat_account(mm, vma->vm_flags, grow);
-				anon_rmap_tree_pre_update_vma(vma);
+				anon_rmap_tree_pre_update_vma(vma, false);
 				vma->vm_start = address;
 				vma_sub_pgoff(vma, grow);
 				/* Overwrite old entry in mtree. */
 				vma_iter_store_overwrite(&vmi, vma);
-				anon_rmap_tree_post_update_vma(vma);
+				anon_rmap_tree_post_update_vma(vma, false);
 
 				perf_event_mmap(vma);
 			}
--- a/mm/vma.h~mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged
+++ a/mm/vma.h
@@ -28,6 +28,8 @@ struct vma_prepare {
 	struct vm_area_struct *remove2;
 
 	bool skip_vma_uprobe :1;
+	bool file_pgoff_unchanged :1;
+	bool anon_pgoff_unchanged :1;
 };
 
 struct unlink_vma_file_batch {
--- a/tools/testing/vma/include/stubs.h~mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged
+++ a/tools/testing/vma/include/stubs.h
@@ -267,6 +267,18 @@ static inline void mapping_rmap_tree_rem
 {
 }
 
+static inline void mapping_rmap_tree_pre_update(struct vm_area_struct *vma,
+						struct address_space *mapping,
+						bool pgoff_unchanged)
+{
+}
+
+static inline void mapping_rmap_tree_post_update(struct vm_area_struct *vma,
+						 struct address_space *mapping,
+						 bool pgoff_unchanged)
+{
+}
+
 static inline void flush_dcache_mmap_unlock(struct address_space *mapping)
 {
 }
@@ -281,6 +293,16 @@ static inline void anon_rmap_tree_remove
 {
 }
 
+static inline void anon_rmap_tree_pre_update_vma(struct vm_area_struct *vma,
+						 bool anon_pgoff_unchanged)
+{
+}
+
+static inline void anon_rmap_tree_post_update_vma(struct vm_area_struct *vma,
+						  bool anon_pgoff_unchanged)
+{
+}
+
 static inline void uprobe_mmap(struct vm_area_struct *vma)
 {
 }
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-mremap-fix-locked_vm-leak-from-mremap_dontunmap-self-merge.patch
mm-mremap-fix-locked_vm-leak-by-splitting-vma-for-mremap_dontunmap.patch
drivers-char-mem-mmap-readonly-map_shared-dev-zero-correctly.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch
mm-khugepaged-deposit-a-newly-allocated-page-table-on-collapse.patch
mm-enable-mmu_gather_rcu_table_free-for-most-2-level-architectures.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-riscv.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-arm.patch
mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc64.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-coldfire.patch
mm-enable-mmu_gather_rcu_table_free-for-sh-x2.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-motorola.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc32.patch
mm-userland-pgtable-freeing-is-rcu-safe-now-remove-leftover-bits.patch
mm-change-the-contract-for-free_pgtables-update-docs.patch
mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get.patch
mm-vma-introduce-and-use-vma_can_merge.patch
mm-consistently-validate-vma-state-after-mmap-hooks.patch
mm-vma-ensure-mmap_prepare-doesnt-set-actions-on-a-mergeable-vma.patch
mm-make-map_kernel_pages_-internal-and-unexported.patch
mm-vma-tidy-up-map-kernel-pages-enum-values.patch
mm-add-mmap-action-for-discontiguous-kernel-page-mapping.patch
docs-filesystems-update-mmap_prepare-docs-for-discontig-kernel-pgs.patch
drivers-usb-mon-update-to-use-mmap_prepare-map-kernel-pages.patch
infiniband-update-hfi1-to-use-remap_vmalloc_range.patch
selinux-reject-writable-opens-of-policy-file-drop-mmap-shared-write-check.patch
alsa-pcm-use-vm_insert_page-to-map-pcm-status-page.patch
bpf-arena-mark-arena_map_mmap-mappings-vm_mixedmap.patch
mm-vma-add-vma_is_kernel_owned-predicates.patch
mm-vma-only-allow-mmap-to-clear-vma_maywrite_bit-if-kernel-owned.patch
mm-vma-add-and-use-vma__is_fixed_mapping.patch
scsi-sg-convert-mmap-hook-to-mmap_prepare-and-rework.patch
fbdev-defio-assert-fbinfo_virtfb-drop-vm_io-add-vm_mixedmap.patch
hsi-cmt_speech-convert-mmap-hook-to-mmap_prepare-refactor.patch
mm-gup-error-out-early-on-vma_mayread_bit-vmas.patch
uprobes-remove-vm_io-set-vm_mixedmap-for-mapped-kernel-pages.patch
mm-mlock-clear-vma_locked_mask-over-mmap-callback.patch
mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify.patch
mm-vma-enforce-that-only-kernel-owned-mappings-may-set-vma_io_bit.patch
mm-remove-vma_io_bit-check-in-vma_is_kernel_owned.patch
mm-remove-hugetlb_inlineh.patch
mm-rename-is_vm_hugetlb_page-to-vma_is_hugetlb.patch
mm-drop-some-redundant-checks-around-hugetlb-vmas.patch
mm-madvise-update-is_valid_guard_vma-to-use-vma_can_merge.patch
mm-vma-introduce-vma_is_persistent.patch
mm-uffd-use-predicates-for-userfaultfd-checks.patch
mm-madvise-use-predicates-for-madvise-madv_dofork.patch
mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested.patch
mm-eliminate-vma_special_flags-check-in-lru_gen_look_around.patch
mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup.patch
mm-eliminate-vm_special-vma_special_flags.patch
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-introduce-and-use-vma_can_gup.patch
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch
mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged.patch

