Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD88B20E023
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744799; cv=none; b=PrHSeV3MO/Ow+lWZHRtIMkj6pkgRcuzvnkp5mYLrxaFt+Fp1wUaUblG1J3+Mpf3PkWyd9zVdZBZOo+BEaMjTJ2k8qkxVX5O+ne7WqcOHEAFJdNjEagf+0CZ3WKI7vxtvqpx22oci4nanmnH3iLzsri0VowJiXO/AYYtdoosKfhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744799; c=relaxed/simple;
	bh=ja9Zr5JKqWktt9ywod08BBGG8XLtVVZR0zeHeU5KMn8=;
	h=Date:To:From:Subject:Message-Id; b=WzAMwDFx8G9OxokayMkYp16ojFTJQV4HYKXak4OuNAv25oE9ssgITxrMC1qVkF4r+y+uyyQYTXoJJtRUs/xM7McFB6P231nCGa9MCCh+t6ywMFQTB+UsJTTp0B+dBMTJKb2PlUa26KhQ6dfqwncgnodiB8D3erbIDjQG8IJXpKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eSU1TDvk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eSU1TDvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFADAC4CEF7;
	Sun, 29 Mar 2026 00:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744799;
	bh=ja9Zr5JKqWktt9ywod08BBGG8XLtVVZR0zeHeU5KMn8=;
	h=Date:To:From:Subject:From;
	b=eSU1TDvk22tnW29rg0Dkdq3VbTzLyy74EKpbNShVD8artSn9UukJulZ78ycMcTY4a
	 8gDonubVb1e+dW4hKgdY4YD8U6FmvO1NDXITQg2sJ0mCeWgCD0MbLrYFvsiVm9gwfr
	 u74Vg7GGkcyG5Ytv8X2jYxWp+CKsDeWcyQQkEwnI=
Date: Sat, 28 Mar 2026 17:39:59 -0700
To: mm-commits@vger.kernel.org,zbestahu@gmail.com,xiang@kernel.org,willy@infradead.org,vishal.l.verma@intel.com,vbabka@kernel.org,tony.luck@intel.com,surenb@google.com,rppt@kernel.org,reinette.chatre@intel.com,pfalcato@suse.de,osalvador@suse.de,naohiro.aota@wdc.com,muchun.song@linux.dev,mhocko@suse.com,lihongbo22@huawei.com,liam.howlett@oracle.com,jth@kernel.org,jgg@ziepe.ca,jefflexu@linux.alibaba.com,jannh@google.com,james.morse@arm.com,jack@suse.cz,hughd@google.com,guochunhai@vivo.com,gregkh@linuxfoundation.org,dlemoal@kernel.org,dhavale@google.com,david@kernel.org,dave.martin@arm.com,dave.jiang@intel.com,dan.j.williams@intel.com,chao@kernel.org,baolin.wang@linux.alibaba.com,babu.moger@amd.com,arnd@arndb.de,almaz.alexandrovich@paragon-software.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-vma_desc_test_all-and-use-it.patch removed from -mm tree
Message-Id: <20260329003959.AFADAC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add vma_desc_test_all() and use it
has been removed from the -mm tree.  Its filename was
     mm-add-vma_desc_test_all-and-use-it.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm: add vma_desc_test_all() and use it
Date: Thu, 5 Mar 2026 10:50:15 +0000

erofs and zonefs are using vma_desc_test_any() twice to check whether all
of VMA_SHARED_BIT and VMA_MAYWRITE_BIT are set, this is silly, so add
vma_desc_test_all() to test all flags and update erofs and zonefs to use
it.

While we're here, update the helper function comments to be more
consistent.

Also add the same to the VMA test headers.

Link: https://lkml.kernel.org/r/568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
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
Cc: Yue Hu <zbestahu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/erofs/data.c                 |    3 +--
 fs/zonefs/file.c                |    3 +--
 include/linux/mm.h              |   24 ++++++++++++++++++++----
 tools/testing/vma/include/dup.h |    9 +++++++++
 4 files changed, 31 insertions(+), 8 deletions(-)

--- a/fs/erofs/data.c~mm-add-vma_desc_test_all-and-use-it
+++ a/fs/erofs/data.c
@@ -473,8 +473,7 @@ static int erofs_file_mmap_prepare(struc
 	if (!IS_DAX(file_inode(desc->file)))
 		return generic_file_readonly_mmap_prepare(desc);
 
-	if (vma_desc_test_any(desc, VMA_SHARED_BIT) &&
-	    vma_desc_test_any(desc, VMA_MAYWRITE_BIT))
+	if (vma_desc_test_all(desc, VMA_SHARED_BIT, VMA_MAYWRITE_BIT))
 		return -EINVAL;
 
 	desc->vm_ops = &erofs_dax_vm_ops;
--- a/fs/zonefs/file.c~mm-add-vma_desc_test_all-and-use-it
+++ a/fs/zonefs/file.c
@@ -333,8 +333,7 @@ static int zonefs_file_mmap_prepare(stru
 	 * ordering between msync() and page cache writeback.
 	 */
 	if (zonefs_inode_is_seq(file_inode(file)) &&
-	    vma_desc_test_any(desc, VMA_SHARED_BIT) &&
-	    vma_desc_test_any(desc, VMA_MAYWRITE_BIT))
+	    vma_desc_test_all(desc, VMA_SHARED_BIT, VMA_MAYWRITE_BIT))
 		return -EINVAL;
 
 	file_accessed(file);
--- a/include/linux/mm.h~mm-add-vma_desc_test_all-and-use-it
+++ a/include/linux/mm.h
@@ -1177,7 +1177,7 @@ static inline void vma_set_flags_mask(st
 #define vma_set_flags(vma, ...) \
 	vma_set_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
 
-/* Helper to test all VMA flags in a VMA descriptor. */
+/* Helper to test any VMA flags in a VMA descriptor. */
 static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
 		vma_flags_t flags)
 {
@@ -1185,8 +1185,8 @@ static inline bool vma_desc_test_any_mas
 }
 
 /*
- * Helper macro for testing VMA flags for an input pointer to a struct
- * vm_area_desc object describing a proposed VMA, e.g.:
+ * Helper macro for testing whether any VMA flags are set in a VMA descriptor,
+ * e.g.:
  *
  * if (vma_desc_test_any(desc, VMA_IO_BIT, VMA_PFNMAP_BIT,
  *		VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)) { ... }
@@ -1194,6 +1194,22 @@ static inline bool vma_desc_test_any_mas
 #define vma_desc_test_any(desc, ...) \
 	vma_desc_test_any_mask(desc, mk_vma_flags(__VA_ARGS__))
 
+/* Helper to test all VMA flags in a VMA descriptor. */
+static inline bool vma_desc_test_all_mask(const struct vm_area_desc *desc,
+		vma_flags_t flags)
+{
+	return vma_flags_test_all_mask(&desc->vma_flags, flags);
+}
+
+/*
+ * Helper macro for testing whether ALL VMA flags are set in a VMA descriptor,
+ * e.g.:
+ *
+ * if (vma_desc_test_all(desc, VMA_READ_BIT, VMA_MAYREAD_BIT)) { ... }
+ */
+#define vma_desc_test_all(desc, ...) \
+	vma_desc_test_all_mask(desc, mk_vma_flags(__VA_ARGS__))
+
 /* Helper to set all VMA flags in a VMA descriptor. */
 static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
 		vma_flags_t flags)
@@ -1206,7 +1222,7 @@ static inline void vma_desc_set_flags_ma
  * vm_area_desc object describing a proposed VMA, e.g.:
  *
  * vma_desc_set_flags(desc, VMA_IO_BIT, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT,
- * 		VMA_DONTDUMP_BIT);
+ *		VMA_DONTDUMP_BIT);
  */
 #define vma_desc_set_flags(desc, ...) \
 	vma_desc_set_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
--- a/tools/testing/vma/include/dup.h~mm-add-vma_desc_test_all-and-use-it
+++ a/tools/testing/vma/include/dup.h
@@ -922,6 +922,15 @@ static inline bool vma_desc_test_any_mas
 #define vma_desc_test_any(desc, ...) \
 	vma_desc_test_any_mask(desc, mk_vma_flags(__VA_ARGS__))
 
+static inline bool vma_desc_test_all_mask(const struct vm_area_desc *desc,
+		vma_flags_t flags)
+{
+	return vma_flags_test_all_mask(&desc->vma_flags, flags);
+}
+
+#define vma_desc_test_all(desc, ...) \
+	vma_desc_test_all_mask(desc, mk_vma_flags(__VA_ARGS__))
+
 static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
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

