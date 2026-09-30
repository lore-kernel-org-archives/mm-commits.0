Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3182F34CFDE
	for <mm-commits@vger.kernel.org>; Wed, 30 Sep 2026 18:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791616; cv=none; b=EJFSw3IF/ZTs5qeRl2UHDFWTfHwN1Qt5iZsmwc1J2trUZyk3ojn+2mTWcNLeh+odmd4lM3aUMjEZVArz+cbo3ZldinMEk/jbQtlWk+3vmcqUbyizkNK/qaLpn8vl7kh16rfXaKjQy5QnPR9bAFkcO9VkBPVMbYFb+4QFsRjnVOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791616; c=relaxed/simple;
	bh=S5Vrt0XZ6DJF/6ACtsiF94j1LBjP88LMo8uL4F8bVXU=;
	h=Date:To:From:Subject:Message-Id; b=pKQdiHYJhNUTU9+uZpZj+vuGee4slxWQH91HuU3dchwjxurlQfJBBTtDTLaB0/qI989G63IPwLYU3O3IHgMxQWjMnhllHfTe7ygkisvXgl21TCK7FfJXr1kDKke0i/6nfhx6CC/nf+koPeuAAEY33I6s/15nH5cs2PseHdg8gms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z82lSZYs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z82lSZYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90D31F00898;
	Wed, 30 Sep 2026 18:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790791614;
	bh=tEb6EfqwWOHOsT5GlYxnG6rhcBaan3w1D5Oq7NYABx4=;
	h=Date:To:From:Subject;
	b=z82lSZYsFNN17YdplregcIM44XHnfwPp1KHg5CNgiY+ubyTHhYaFgSRAnLPMkTnI7
	 nlD8M76Crt3TIhhtbxIL/tRyYssfL4/8mrQpNtyPvjJVCGFOM0bUcM+wgGZFMV8E/k
	 fBW/7Zqi6H6pM/lw40xm0lpEeaupbciH9NI+TDDY=
Date: Wed, 30 Sep 2026 11:06:53 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,pan.deng@intel.com,mhocko@suse.com,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,harry@kernel.org,david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged.patch removed from -mm tree
Message-Id: <20260930180653.D90D31F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: don't remove VMA from rmap if pgoff unchanged
has been removed from the -mm tree.  Its filename was
     mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: don't remove VMA from rmap if pgoff unchanged
Date: Fri, 25 Sep 2026 19:32:20 +0100

When updating a VMA, vma_prepare() unconditionally removes it from its
rmap interval trees under the rmap lock, and vma_complete() reinserts it
before releasing the lock.

This is wholly unnecessary if its page offset (file rmap) or anonymous
page offset (anon rmap) is unchanged.

So, track whether they will change in the newly introduced
vp->anon_pgoff_unchanged and vp->pgoff_unchanged fields, and use them to
determine whether to remove the VMA or not.

The rmap lock keeps things safe as no rmap walks can concurrently occur
during the operation.

Additionally, some architectures (arm, parisc, nios2, csky) have dcache
flush rmap walkers which take only flush_dcache_mmap_lock(), which is
likewise held across the operation.

It's also necessary to keep the rb_subtree_last field updated in the
interval tree so implement anon_rmap_tree_update_inplace() and
mapping_rmap_tree_update_inplace() to do that.

This is done in vma_complete(), after the VMA's range has been updated, so
in the interim the field may be invalid.  However, given the locks
described above, this cannot be observed until after the state is
corrected.

The anonymous rmap is keyed on anon_vma_chains not VMAs, so in those
instances anon_rmap_tree_update_vma_inplace() iterates over
vma->anon_vma_chain, invoking anon_rmap_tree_update_inplace() on each one.

For the anon rmap case, with CONFIG_DEBUG_VM_RB set, avc->cached_vma_last
is also updated in anon_rmap_tree_update_inplace().

When performing a VMA shrink or a split where the VMA is the lower one,
the page offset cannot change, so set the flags unconditionally in these
cases.

When merging VMAs the page offset is unchanged only in some cases, so
update init_multi_vma_prep() to set the flags only if the page offsets
remain the same.

These changes ultimately result in less rmap lock contention.

Link: https://lore.kernel.org/20260925-speed-up-inplace-rmap-v1-1-babc48ce7c83@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Pan Deng <pan.deng@intel.com>
Link: https://lore.kernel.org/linux-mm/20260924054301.2330822-1-pan.deng@intel.com/
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

 include/linux/mm.h                |    3 ++
 mm/interval_tree.c                |   33 +++++++++++++++++++++++
 mm/vma.c                          |   40 ++++++++++++++++++++++++----
 mm/vma.h                          |    2 +
 tools/testing/vma/include/stubs.h |    8 +++++
 5 files changed, 81 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged
+++ a/include/linux/mm.h
@@ -4358,6 +4358,8 @@ void mapping_rmap_tree_insert_after(stru
 				    struct address_space *mapping);
 void mapping_rmap_tree_remove(struct vm_area_struct *vma,
 			      struct address_space *mapping);
+void mapping_rmap_tree_update_inplace(struct vm_area_struct *vma);
+
 struct vm_area_struct *
 mapping_rmap_tree_iter_first(struct address_space *mapping,
 			     pgoff_t pgoff_start, pgoff_t pgoff_last);
@@ -4375,6 +4377,7 @@ void anon_rmap_tree_insert(struct anon_v
 			   struct anon_vma *anon_vma);
 void anon_rmap_tree_remove(struct anon_vma_chain *avc,
 			   struct anon_vma *anon_vma);
+void anon_rmap_tree_update_inplace(struct anon_vma_chain *avc);
 struct anon_vma_chain *
 anon_rmap_tree_iter_first(struct anon_vma *anon_vma,
 			  pgoff_t pgoff_start, pgoff_t pgoff_last);
--- a/mm/interval_tree.c~mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged
+++ a/mm/interval_tree.c
@@ -64,6 +64,21 @@ void mapping_rmap_tree_remove(struct vm_
 	__mapping_rmap_tree_remove(vma, &mapping->i_mmap);
 }
 
+/**
+ * mapping_rmap_tree_update_inplace() - Update file rmap tree to reflect an
+ * in-place change in a VMA's size.
+ * @vma: The VMA whose size has changed.
+ *
+ * The file rmap lock must be held.
+ *
+ * Invalid to do so if @vma->vm_pgoff has changed.
+ */
+void mapping_rmap_tree_update_inplace(struct vm_area_struct *vma)
+{
+	/* Propagate all the way up the tree. */
+	__mapping_rmap_tree_augment.propagate(&vma->shared.rb, NULL);
+}
+
 struct vm_area_struct *
 mapping_rmap_tree_iter_first(struct address_space *mapping,
 			     pgoff_t pgoff_start, pgoff_t pgoff_last)
@@ -111,6 +126,24 @@ void anon_rmap_tree_remove(struct anon_v
 	__anon_rmap_tree_remove(avc, &anon_vma->rb_root);
 }
 
+/**
+ * anon_rmap_tree_update_inplace() - Update anon rmap tree to reflect an
+ * in-place change in the size of @avc's VMA.
+ * @avc: The anon_vma_chain whose VMA's size has changed.
+ *
+ * The anon rmap root lock must be held.
+ *
+ * Invalid to do so if the VMA's anonymous pgoff has changed.
+ */
+void anon_rmap_tree_update_inplace(struct anon_vma_chain *avc)
+{
+#ifdef CONFIG_DEBUG_VM_RB
+	avc->cached_vma_last = avc_last_pgoff(avc);
+#endif
+	/* Propagate all the way up the tree. */
+	__anon_rmap_tree_augment.propagate(&avc->rb, NULL);
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
+		vp->pgoff_unchanged = true;
+	if (vma_start_anon_pgoff(vma) == vmg_start_anon_pgoff(vmg))
+		vp->anon_pgoff_unchanged = true;
 }
 
 /*
@@ -331,6 +338,15 @@ anon_rmap_tree_post_update_vma(struct vm
 		anon_rmap_tree_insert(avc, avc->anon_vma);
 }
 
+static void
+anon_rmap_tree_update_vma_inplace(struct vm_area_struct *vma)
+{
+	struct anon_vma_chain *avc;
+
+	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
+		anon_rmap_tree_update_inplace(avc);
+}
+
 /*
  * vma_prepare() - Helper function for handling locking VMAs prior to altering
  * @vp: The initialized vma_prepare struct
@@ -359,14 +375,16 @@ static void vma_prepare(struct vma_prepa
 
 	if (vp->anon_vma) {
 		anon_vma_lock_write(vp->anon_vma);
-		anon_rmap_tree_pre_update_vma(vp->vma);
+		if (!vp->anon_pgoff_unchanged)
+			anon_rmap_tree_pre_update_vma(vp->vma);
 		if (vp->adj_next)
 			anon_rmap_tree_pre_update_vma(vp->adj_next);
 	}
 
 	if (vp->file) {
 		flush_dcache_mmap_lock(vp->mapping);
-		mapping_rmap_tree_remove(vp->vma, vp->mapping);
+		if (!vp->pgoff_unchanged)
+			mapping_rmap_tree_remove(vp->vma, vp->mapping);
 		if (vp->adj_next)
 			mapping_rmap_tree_remove(vp->adj_next, vp->mapping);
 	}
@@ -387,7 +405,11 @@ static void vma_complete(struct vma_prep
 	if (vp->file) {
 		if (vp->adj_next)
 			mapping_rmap_tree_insert(vp->adj_next, vp->mapping);
-		mapping_rmap_tree_insert(vp->vma, vp->mapping);
+		/* Need only propagate the change inplace. */
+		if (vp->pgoff_unchanged)
+			mapping_rmap_tree_update_inplace(vp->vma);
+		else
+			mapping_rmap_tree_insert(vp->vma, vp->mapping);
 		flush_dcache_mmap_unlock(vp->mapping);
 	}
 
@@ -406,7 +428,11 @@ static void vma_complete(struct vma_prep
 	}
 
 	if (vp->anon_vma) {
-		anon_rmap_tree_post_update_vma(vp->vma);
+		/* Need only propagate the change inplace. */
+		if (vp->anon_pgoff_unchanged)
+			anon_rmap_tree_update_vma_inplace(vp->vma);
+		else
+			anon_rmap_tree_post_update_vma(vp->vma);
 		if (vp->adj_next)
 			anon_rmap_tree_post_update_vma(vp->adj_next);
 		anon_vma_unlock_write(vp->anon_vma);
@@ -593,6 +619,8 @@ __split_vma(struct vma_iterator *vmi, st
 
 	init_vma_prep(&vp, vma);
 	vp.insert = new;
+	vp.pgoff_unchanged = !new_below;
+	vp.anon_pgoff_unchanged = !new_below;
 	vma_prepare(&vp);
 
 	/*
@@ -1346,6 +1374,8 @@ int vma_shrink(struct vma_iterator *vmi,
 	vma_start_write(vma);
 
 	init_vma_prep(&vp, vma);
+	vp.pgoff_unchanged = true;
+	vp.anon_pgoff_unchanged = true;
 	vma_prepare(&vp);
 	vma_adjust_trans_huge(vma, vma->vm_start, end, NULL);
 
--- a/mm/vma.h~mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged
+++ a/mm/vma.h
@@ -28,6 +28,8 @@ struct vma_prepare {
 	struct vm_area_struct *remove2;
 
 	bool skip_vma_uprobe :1;
+	bool pgoff_unchanged :1;
+	bool anon_pgoff_unchanged :1;
 };
 
 struct unlink_vma_file_batch {
--- a/tools/testing/vma/include/stubs.h~mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged
+++ a/tools/testing/vma/include/stubs.h
@@ -267,6 +267,10 @@ static inline void mapping_rmap_tree_rem
 {
 }
 
+static inline void mapping_rmap_tree_update_inplace(struct vm_area_struct *vma)
+{
+}
+
 static inline void flush_dcache_mmap_unlock(struct address_space *mapping)
 {
 }
@@ -281,6 +285,10 @@ static inline void anon_rmap_tree_remove
 {
 }
 
+static inline void anon_rmap_tree_update_inplace(struct anon_vma_chain *avc)
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

