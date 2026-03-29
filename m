Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D53E231A41
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744806; cv=none; b=nqorDlqSlFF5d2BRfhZv218hO41CWIixyeL1ywmcRbUW6k+vqI9VHkll0PMrHW5fHjhK6fqlmk7OVqu/AkDbNA8tulXAIINIX1dQnVhEeTDiDbHJ5FWRcPbT2gJjjFEwCV3bIwV4ZH9sE74N3rPibgNn8+ragBP1SYMvuNwIdeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744806; c=relaxed/simple;
	bh=4os0xt2zwUq+Y61TRSYnl+mpm+Xi+8C3x7jkFJq5BZE=;
	h=Date:To:From:Subject:Message-Id; b=J3ymyuc78Fh/kqXQF0IURfvpnSRdFzaxUNrygJMPnFNzrjfV7+6MnvwO2fA1HkmvcN5FE31G4Ra1oNkObVRkdF6skCsYGYwisgT5jF66nGzYw1k195FIM4vZtagDxgBwjpFJb+x6V6n47Pz/V3HUtUETJ2JbkCXbXtPvYoDPIl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zA9y8gcx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zA9y8gcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87585C4CEF7;
	Sun, 29 Mar 2026 00:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744805;
	bh=4os0xt2zwUq+Y61TRSYnl+mpm+Xi+8C3x7jkFJq5BZE=;
	h=Date:To:From:Subject:From;
	b=zA9y8gcxOvtAiFO6sCziJqwoZIGQrKU4ABHE8irhCBNPg6D5RWlSu/Fe8JBuzLejf
	 fgOQhS2fwfaUccIB5TMDA0cnvzYYc/VV7yoKzpeAM4dRYzcjUGITpgGX4st7oRlJyD
	 iMUU8FdiRrYup/pWLxTEbZZEK8B+Nbk8z2FB296k=
Date: Sat, 28 Mar 2026 17:40:05 -0700
To: mm-commits@vger.kernel.org,zbestahu@gmail.com,xiang@kernel.org,willy@infradead.org,vishal.l.verma@intel.com,vbabka@kernel.org,tony.luck@intel.com,surenb@google.com,rppt@kernel.org,reinette.chatre@intel.com,pfalcato@suse.de,osalvador@suse.de,naohiro.aota@wdc.com,muchun.song@linux.dev,mhocko@suse.com,lihongbo22@huawei.com,liam.howlett@oracle.com,jth@kernel.org,jgg@ziepe.ca,jefflexu@linux.alibaba.com,jannh@google.com,james.morse@arm.com,jack@suse.cz,hughd@google.com,guochunhai@vivo.com,gregkh@linuxfoundation.org,dlemoal@kernel.org,dhavale@google.com,david@kernel.org,dave.martin@arm.com,dave.jiang@intel.com,dan.j.williams@intel.com,chao@kernel.org,baolin.wang@linux.alibaba.com,babu.moger@amd.com,arnd@arndb.de,almaz.alexandrovich@paragon-software.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-reintroduce-vma_desc_test-as-a-singular-flag-test.patch removed from -mm tree
Message-Id: <20260329004005.87585C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: reintroduce vma_desc_test() as a singular flag test
has been removed from the -mm tree.  Its filename was
     mm-reintroduce-vma_desc_test-as-a-singular-flag-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm: reintroduce vma_desc_test() as a singular flag test
Date: Thu, 5 Mar 2026 10:50:18 +0000

Similar to vma_flags_test(), we have previously renamed vma_desc_test() to
vma_desc_test_any().  Now that is in place, we can reintroduce
vma_desc_test() to explicitly check for a single VMA flag.

As with vma_flags_test(), this is useful as often flag tests are against a
single flag, and vma_desc_test_any(flags, VMA_READ_BIT) reads oddly and
potentially causes confusion.

As with vma_flags_test() a combination of sparse and vma_flags_t being a
struct means that users cannot misuse this function without it getting
flagged.

Also update the VMA tests to reflect this change.

Link: https://lkml.kernel.org/r/3a65ca23defb05060333f0586428fe279a484564.1772704455.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Babu Moger <babu.moger@amd.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Chatre, Reinette <reinette.chatre@intel.com>
Cc: Chunhai Guo <guochunhai@vivo.com>
Cc: Damien Le Maol <dlemoal@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Martin <dave.martin@arm.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hongbo Li <lihongbo22@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Johannes Thumshirn <jth@kernel.org>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naohiro Aota <naohiro.aota@wdc.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sandeep Dhavale <dhavale@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c              |    2 +-
 fs/hugetlbfs/inode.c            |    2 +-
 fs/ntfs3/file.c                 |    2 +-
 fs/resctrl/pseudo_lock.c        |    2 +-
 include/linux/dax.h             |    4 ++--
 include/linux/mm.h              |   11 +++++++++++
 mm/hugetlb.c                    |   12 ++++++------
 tools/testing/vma/include/dup.h |    6 ++++++
 8 files changed, 29 insertions(+), 12 deletions(-)

--- a/drivers/char/mem.c~mm-reintroduce-vma_desc_test-as-a-singular-flag-test
+++ a/drivers/char/mem.c
@@ -520,7 +520,7 @@ static int mmap_zero_prepare(struct vm_a
 #ifndef CONFIG_MMU
 	return -ENOSYS;
 #endif
-	if (vma_desc_test_any(desc, VMA_SHARED_BIT))
+	if (vma_desc_test(desc, VMA_SHARED_BIT))
 		return shmem_zero_setup_desc(desc);
 
 	desc->action.success_hook = mmap_zero_private_success;
--- a/fs/hugetlbfs/inode.c~mm-reintroduce-vma_desc_test-as-a-singular-flag-test
+++ a/fs/hugetlbfs/inode.c
@@ -164,7 +164,7 @@ static int hugetlbfs_file_mmap_prepare(s
 		goto out;
 
 	ret = 0;
-	if (vma_desc_test_any(desc, VMA_WRITE_BIT) && inode->i_size < len)
+	if (vma_desc_test(desc, VMA_WRITE_BIT) && inode->i_size < len)
 		i_size_write(inode, len);
 out:
 	inode_unlock(inode);
--- a/fs/ntfs3/file.c~mm-reintroduce-vma_desc_test-as-a-singular-flag-test
+++ a/fs/ntfs3/file.c
@@ -276,7 +276,7 @@ static int ntfs_file_mmap_prepare(struct
 	struct file *file = desc->file;
 	struct inode *inode = file_inode(file);
 	struct ntfs_inode *ni = ntfs_i(inode);
-	const bool rw = vma_desc_test_any(desc, VMA_WRITE_BIT);
+	const bool rw = vma_desc_test(desc, VMA_WRITE_BIT);
 	int err;
 
 	/* Avoid any operation if inode is bad. */
--- a/fs/resctrl/pseudo_lock.c~mm-reintroduce-vma_desc_test-as-a-singular-flag-test
+++ a/fs/resctrl/pseudo_lock.c
@@ -1044,7 +1044,7 @@ static int pseudo_lock_dev_mmap_prepare(
 	 * Ensure changes are carried directly to the memory being mapped,
 	 * do not allow copy-on-write mapping.
 	 */
-	if (!vma_desc_test_any(desc, VMA_SHARED_BIT)) {
+	if (!vma_desc_test(desc, VMA_SHARED_BIT)) {
 		mutex_unlock(&rdtgroup_mutex);
 		return -EINVAL;
 	}
--- a/include/linux/dax.h~mm-reintroduce-vma_desc_test-as-a-singular-flag-test
+++ a/include/linux/dax.h
@@ -69,7 +69,7 @@ static inline bool daxdev_mapping_suppor
 					    const struct inode *inode,
 					    struct dax_device *dax_dev)
 {
-	if (!vma_desc_test_any(desc, VMA_SYNC_BIT))
+	if (!vma_desc_test(desc, VMA_SYNC_BIT))
 		return true;
 	if (!IS_DAX(inode))
 		return false;
@@ -115,7 +115,7 @@ static inline bool daxdev_mapping_suppor
 					    const struct inode *inode,
 					    struct dax_device *dax_dev)
 {
-	return !vma_desc_test_any(desc, VMA_SYNC_BIT);
+	return !vma_desc_test(desc, VMA_SYNC_BIT);
 }
 static inline size_t dax_recovery_write(struct dax_device *dax_dev,
 		pgoff_t pgoff, void *addr, size_t bytes, struct iov_iter *i)
--- a/include/linux/mm.h~mm-reintroduce-vma_desc_test-as-a-singular-flag-test
+++ a/include/linux/mm.h
@@ -1192,6 +1192,17 @@ static inline void vma_set_flags_mask(st
 #define vma_set_flags(vma, ...) \
 	vma_set_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
 
+/*
+ * Test whether a specific VMA flag is set in a VMA descriptor, e.g.:
+ *
+ * if (vma_desc_test(desc, VMA_READ_BIT)) { ... }
+ */
+static __always_inline bool vma_desc_test(const struct vm_area_desc *desc,
+		vma_flag_t bit)
+{
+	return vma_flags_test(&desc->vma_flags, bit);
+}
+
 /* Helper to test any VMA flags in a VMA descriptor. */
 static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
 		vma_flags_t flags)
--- a/mm/hugetlb.c~mm-reintroduce-vma_desc_test-as-a-singular-flag-test
+++ a/mm/hugetlb.c
@@ -1194,7 +1194,7 @@ static void set_vma_resv_flags(struct vm
 static void set_vma_desc_resv_map(struct vm_area_desc *desc, struct resv_map *map)
 {
 	VM_WARN_ON_ONCE(!is_vma_hugetlb_flags(&desc->vma_flags));
-	VM_WARN_ON_ONCE(vma_desc_test_any(desc, VMA_MAYSHARE_BIT));
+	VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_MAYSHARE_BIT));
 
 	desc->private_data = map;
 }
@@ -1202,7 +1202,7 @@ static void set_vma_desc_resv_map(struct
 static void set_vma_desc_resv_flags(struct vm_area_desc *desc, unsigned long flags)
 {
 	VM_WARN_ON_ONCE(!is_vma_hugetlb_flags(&desc->vma_flags));
-	VM_WARN_ON_ONCE(vma_desc_test_any(desc, VMA_MAYSHARE_BIT));
+	VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_MAYSHARE_BIT));
 
 	desc->private_data = (void *)((unsigned long)desc->private_data | flags);
 }
@@ -6602,7 +6602,7 @@ long hugetlb_reserve_pages(struct inode
 	 * to reserve the full area even if read-only as mprotect() may be
 	 * called to make the mapping read-write. Assume !desc is a shm mapping
 	 */
-	if (!desc || vma_desc_test_any(desc, VMA_MAYSHARE_BIT)) {
+	if (!desc || vma_desc_test(desc, VMA_MAYSHARE_BIT)) {
 		/*
 		 * resv_map can not be NULL as hugetlb_reserve_pages is only
 		 * called for inodes for which resv_maps were created (see
@@ -6636,7 +6636,7 @@ long hugetlb_reserve_pages(struct inode
 	if (err < 0)
 		goto out_err;
 
-	if (desc && !vma_desc_test_any(desc, VMA_MAYSHARE_BIT) && h_cg) {
+	if (desc && !vma_desc_test(desc, VMA_MAYSHARE_BIT) && h_cg) {
 		/* For private mappings, the hugetlb_cgroup uncharge info hangs
 		 * of the resv_map.
 		 */
@@ -6673,7 +6673,7 @@ long hugetlb_reserve_pages(struct inode
 	 * consumed reservations are stored in the map. Hence, nothing
 	 * else has to be done for private mappings here
 	 */
-	if (!desc || vma_desc_test_any(desc, VMA_MAYSHARE_BIT)) {
+	if (!desc || vma_desc_test(desc, VMA_MAYSHARE_BIT)) {
 		add = region_add(resv_map, from, to, regions_needed, h, h_cg);
 
 		if (unlikely(add < 0)) {
@@ -6737,7 +6737,7 @@ out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
 					    chg * pages_per_huge_page(h), h_cg);
 out_err:
-	if (!desc || vma_desc_test_any(desc, VMA_MAYSHARE_BIT))
+	if (!desc || vma_desc_test(desc, VMA_MAYSHARE_BIT))
 		/* Only call region_abort if the region_chg succeeded but the
 		 * region_add failed or didn't run.
 		 */
--- a/tools/testing/vma/include/dup.h~mm-reintroduce-vma_desc_test-as-a-singular-flag-test
+++ a/tools/testing/vma/include/dup.h
@@ -922,6 +922,12 @@ static inline void vma_set_flags_mask(st
 #define vma_set_flags(vma, ...) \
 	vma_set_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
 
+static __always_inline bool vma_desc_test(const struct vm_area_desc *desc,
+		vma_flag_t bit)
+{
+	return vma_flags_test(&desc->vma_flags, bit);
+}
+
 static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
 					    vma_flags_t flags)
 {
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-add-vma_flags_empty-vma_flags_and-vma_flags_diff_pair.patch
tools-testing-vma-add-unit-tests-flag-empty-diff_pair-and.patch
mm-vma-add-further-vma_flags_t-unions.patch
tools-testing-vma-convert-bulk-of-test-code-to-vma_flags_t.patch
mm-vma-use-new-vma-flags-for-sticky-flags-logic.patch
tools-testing-vma-fix-vma-flag-tests.patch
mm-vma-add-append_vma_flags-helper.patch
tools-testing-vma-add-simple-test-for-append_vma_flags.patch
mm-unexport-vm_brk_flags-and-eliminate-vm_flags-parameter.patch
mm-vma-introduce-vma_flags_same.patch
mm-vma-introduce-_to_-helpers.patch
tools-testing-vma-test-that-legacy-flag-helpers-work-correctly.patch
mm-vma-introduce-vma_test-and-make-inlining-consistent.patch
tools-testing-vma-update-vma-flag-tests-to-test-vma_test.patch
mm-introduce-vma_flags_count-and-vma_test_single_mask.patch
tools-testing-vma-test-vma_flags_countvma_test_single_mask.patch
mm-convert-do_brk_flags-to-use-vma_flags_t.patch
mm-update-vma_supports_mlock-to-use-new-vma-flags.patch
mm-vma-introduce-vma_clear_flags.patch
tools-testing-vma-update-vma-tests-to-test-vma_clear_flags.patch
mm-vma-convert-as-much-as-we-can-in-mm-vmac-to-vma_flags_t.patch
tools-bitmap-add-missing-bitmap_copy-implementation.patch
mm-vma-convert-vma_modify_flags-to-use-vma_flags_t.patch
mm-vma-convert-__mmap_region-to-use-vma_flags_t.patch
mm-simplify-vma-flag-tests-of-excluded-flags.patch
mm-various-small-mmap_prepare-cleanups.patch
mm-add-documentation-for-the-mmap_prepare-file-operation-callback.patch
mm-document-vm_operations_struct-open-the-same-as-close.patch
mm-avoid-deadlock-when-holding-rmap-on-mmap_prepare-error.patch
mm-switch-the-rmap-lock-held-option-off-in-compat-layer.patch
mm-vma-remove-superfluous-map-hold_file_rmap_lock.patch
mm-have-mmap_action_complete-handle-the-rmap-lock-and-unmap.patch
mm-add-vm_ops-mapped-hook.patch
fs-afs-revert-mmap_prepare-change.patch
fs-afs-restore-mmap_prepare-implementation.patch
mm-add-mmap_action_simple_ioremap.patch
misc-open-dice-replace-deprecated-mmap-hook-with-mmap_prepare.patch
hpet-replace-deprecated-mmap-hook-with-mmap_prepare.patch
mtdchar-replace-deprecated-mmap-hook-with-mmap_prepare-clean-up.patch
stm-replace-deprecated-mmap-hook-with-mmap_prepare.patch
staging-vme_user-replace-deprecated-mmap-hook-with-mmap_prepare.patch
mm-allow-handling-of-stacked-mmap_prepare-hooks-in-more-drivers.patch
drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare.patch
uio-replace-deprecated-mmap-hook-with-mmap_prepare-in-uio_info.patch
mm-add-mmap_action_map_kernel_pages.patch
mm-on-remap-assert-that-input-range-within-the-proposed-vma.patch
mm-huge_memory-simplify-vma_is_specal_huge.patch
mm-huge-avoid-big-else-branch-in-zap_huge_pmd.patch
mm-huge_memory-have-zap_huge_pmd-return-a-boolean-add-kdoc.patch
mm-huge_memory-handle-buggy-pmd-entry-in-zap_huge_pmd.patch
mm-huge_memory-add-a-common-exit-path-to-zap_huge_pmd.patch
mm-huge_memory-remove-unnecessary-vm_bug_on_page.patch
mm-huge_memory-deduplicate-zap-deposited-table-call.patch
mm-huge_memory-remove-unnecessary-sanity-checks.patch
mm-huge_memory-use-mm-instead-of-tlb-mm.patch
mm-huge_memory-separate-out-the-folio-part-of-zap_huge_pmd.patch
mm-add-softleaf_is_valid_pmd_entry-pmd_to_softleaf_folio.patch
mm-huge_memory-add-and-use-normal_or_softleaf_folio_pmd.patch
mm-huge_memory-add-and-use-has_deposited_pgtable.patch
maintainers-update-mglru-entry-to-reflect-current-status.patch

