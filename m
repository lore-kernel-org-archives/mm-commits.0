Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C12F234994
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744803; cv=none; b=SgAOrjfa2AzJKO+3kQeSiXVWV2wNJrL/0IzTTdLpYTp/jWpQA1ZsmP8NFKpSVtnCAJ7R/DrRF2LOfHsbdshFfZFc/9FIJEpYCiH8z7txbrOed5UyrzEAMCLQJWr62/vmHPL8M/u/nPDv59gC/DF2H5T1n6sE7pcCQF7wiFTZ3eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744803; c=relaxed/simple;
	bh=DpYkB2k1cyO7K+W0ASdqJFkg/foPOKvMHQyX+0W0u2I=;
	h=Date:To:From:Subject:Message-Id; b=S548mD/VQi0OelNbvC46yuaQPaZwln4rRsz8K3P9yAm1bNn6wSHaBuUmBas5vE5rGmzAMo5jNyX32l8aG3cR0dmWsMSkMnVSXC3a/mwLt3tPC8vUZDyxvem7uAF4OkgHZO6jzteLrhkRiVDagEMgox9+w0FPMTTnEWANaHZLYDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XHQ+ASzm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XHQ+ASzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F143DC4CEF7;
	Sun, 29 Mar 2026 00:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744803;
	bh=DpYkB2k1cyO7K+W0ASdqJFkg/foPOKvMHQyX+0W0u2I=;
	h=Date:To:From:Subject:From;
	b=XHQ+ASzmv5iOBojiLCtkiNddTh5joiNgtSByS760tMK06arKVZhToH491xbJ3bH+W
	 xJneYR7YhHU0ejWbocg7TDW8KesFmBBMMy6A3KHsp0OJpE8zv/TMtRtYPnga0BTBJB
	 Zb/5frMvqhufglHAhdws02ulkKYmi4ISF6E0+4xE=
Date: Sat, 28 Mar 2026 17:40:02 -0700
To: mm-commits@vger.kernel.org,zbestahu@gmail.com,xiang@kernel.org,willy@infradead.org,vishal.l.verma@intel.com,vbabka@kernel.org,tony.luck@intel.com,surenb@google.com,rppt@kernel.org,reinette.chatre@intel.com,pfalcato@suse.de,osalvador@suse.de,naohiro.aota@wdc.com,muchun.song@linux.dev,mhocko@suse.com,lihongbo22@huawei.com,liam.howlett@oracle.com,jth@kernel.org,jgg@ziepe.ca,jefflexu@linux.alibaba.com,jannh@google.com,james.morse@arm.com,jack@suse.cz,hughd@google.com,guochunhai@vivo.com,gregkh@linuxfoundation.org,dlemoal@kernel.org,dhavale@google.com,david@kernel.org,dave.martin@arm.com,dave.jiang@intel.com,dan.j.williams@intel.com,chao@kernel.org,baolin.wang@linux.alibaba.com,babu.moger@amd.com,arnd@arndb.de,almaz.alexandrovich@paragon-software.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-reintroduce-vma_flags_test-as-a-singular-flag-test.patch removed from -mm tree
Message-Id: <20260329004002.F143DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: reintroduce vma_flags_test() as a singular flag test
has been removed from the -mm tree.  Its filename was
     mm-reintroduce-vma_flags_test-as-a-singular-flag-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm: reintroduce vma_flags_test() as a singular flag test
Date: Thu, 5 Mar 2026 10:50:17 +0000

Since we've now renamed vma_flags_test() to vma_flags_test_any() to be
very clear as to what we are in fact testing, we now have the opportunity
to bring vma_flags_test() back, but for explicitly testing a single VMA
flag.

This is useful, as often flag tests are against a single flag, and
vma_flags_test_any(flags, VMA_READ_BIT) reads oddly and potentially causes
confusion.

We use sparse to enforce that users won't accidentally pass vm_flags_t to
this function without it being flagged so this should make it harder to
get this wrong.

Of course, passing vma_flags_t to the function is impossible, as it is a
struct.

Also update the VMA tests to reflect this change.

Link: https://lkml.kernel.org/r/f33f8d7f16c3f3d286a1dc2cba12c23683073134.1772704455.git.ljs@kernel.org
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

 include/linux/mm.h              |   17 +++++++++++++++--
 mm/hugetlb.c                    |    2 +-
 mm/shmem.c                      |    4 ++--
 tools/testing/vma/include/dup.h |    8 ++++++++
 4 files changed, 26 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-reintroduce-vma_flags_test-as-a-singular-flag-test
+++ a/include/linux/mm.h
@@ -1051,6 +1051,19 @@ static __always_inline vma_flags_t __mk_
 }
 
 /*
+ * Test whether a specific VMA flag is set, e.g.:
+ *
+ * if (vma_flags_test(flags, VMA_READ_BIT)) { ... }
+ */
+static __always_inline bool vma_flags_test(const vma_flags_t *flags,
+		vma_flag_t bit)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+
+	return test_bit((__force int)bit, bitmap);
+}
+
+/*
  * Helper macro which bitwise-or combines the specified input flags into a
  * vma_flags_t bitmap value. E.g.:
  *
@@ -1956,8 +1969,8 @@ static inline bool vma_desc_is_cow_mappi
 {
 	const vma_flags_t *flags = &desc->vma_flags;
 
-	return vma_flags_test_any(flags, VMA_MAYWRITE_BIT) &&
-		!vma_flags_test_any(flags, VMA_SHARED_BIT);
+	return vma_flags_test(flags, VMA_MAYWRITE_BIT) &&
+		!vma_flags_test(flags, VMA_SHARED_BIT);
 }
 
 #ifndef CONFIG_MMU
--- a/mm/hugetlb.c~mm-reintroduce-vma_flags_test-as-a-singular-flag-test
+++ a/mm/hugetlb.c
@@ -6593,7 +6593,7 @@ long hugetlb_reserve_pages(struct inode
 	 * attempt will be made for VM_NORESERVE to allocate a page
 	 * without using reserves
 	 */
-	if (vma_flags_test_any(&vma_flags, VMA_NORESERVE_BIT))
+	if (vma_flags_test(&vma_flags, VMA_NORESERVE_BIT))
 		return 0;
 
 	/*
--- a/mm/shmem.c~mm-reintroduce-vma_flags_test-as-a-singular-flag-test
+++ a/mm/shmem.c
@@ -3086,7 +3086,7 @@ static struct inode *__shmem_get_inode(s
 	spin_lock_init(&info->lock);
 	atomic_set(&info->stop_eviction, 0);
 	info->seals = F_SEAL_SEAL;
-	info->flags = vma_flags_test_any(&flags, VMA_NORESERVE_BIT)
+	info->flags = vma_flags_test(&flags, VMA_NORESERVE_BIT)
 		? SHMEM_F_NORESERVE : 0;
 	info->i_crtime = inode_get_mtime(inode);
 	info->fsflags = (dir == NULL) ? 0 :
@@ -5827,7 +5827,7 @@ static struct file *__shmem_file_setup(s
 				       unsigned int i_flags)
 {
 	const unsigned long shmem_flags =
-		vma_flags_test_any(&flags, VMA_NORESERVE_BIT) ? SHMEM_F_NORESERVE : 0;
+		vma_flags_test(&flags, VMA_NORESERVE_BIT) ? SHMEM_F_NORESERVE : 0;
 	struct inode *inode;
 	struct file *res;
 
--- a/tools/testing/vma/include/dup.h~mm-reintroduce-vma_flags_test-as-a-singular-flag-test
+++ a/tools/testing/vma/include/dup.h
@@ -844,6 +844,14 @@ static inline vma_flags_t __mk_vma_flags
 #define mk_vma_flags(...) __mk_vma_flags(COUNT_ARGS(__VA_ARGS__), \
 					 (const vma_flag_t []){__VA_ARGS__})
 
+static __always_inline bool vma_flags_test(const vma_flags_t *flags,
+		vma_flag_t bit)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+
+	return test_bit((__force int)bit, bitmap);
+}
+
 static __always_inline bool vma_flags_test_any_mask(const vma_flags_t *flags,
 		vma_flags_t to_test)
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

