Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D7C20E023
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744801; cv=none; b=LejnMtXrPu/QsSM8cMcK2YGp/VK2e0uLHmlC72CPKY7R6sVwdFONNM9IzAaynL2nNePweSfKOpHYtcQl1jHlOmDR8BbVgrLV/uizUbU6dIMfh/XEL9O2MJtBSZLvLv9Jvoi5tqk0XdFI6BnEWAmf7A6p99wbWADxkYarihMK22o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744801; c=relaxed/simple;
	bh=uBfYKUtIeSWzf/FurJqrN3D/JaA9JssHveEpNAuz0i0=;
	h=Date:To:From:Subject:Message-Id; b=aQLi8Bfwkmr4kMiDyV4fplXQv6h/2FAMJ8dPM5KloAiA/CRqIXUWbt7gDsvm+7yQ/T7SIP5YN4tfhr+QNmFlMIgYoWauSUh70hokEwrBP1xG571gc5YgpzBapwH3+WjDkqroCjYDaD9+SSITvGqGVHRVIp8UxrhQJw5FCx1Fm5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hu88mBxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hu88mBxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0F7C4CEF7;
	Sun, 29 Mar 2026 00:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744801;
	bh=uBfYKUtIeSWzf/FurJqrN3D/JaA9JssHveEpNAuz0i0=;
	h=Date:To:From:Subject:From;
	b=hu88mBxB79ZiOZ5k6Pn69OC5eEivLcp+OqSEE87fy61Su4nqaoCkFLpFBm0ThpJIQ
	 SsDTgfP57nsatsRCT4CjFHoWbd0X6anUlbFOveuGD1ir+FkwqfZwxvLmI4iP4YqyWz
	 Cllq0K+RXdihx3IeAaKcicciKyxXb53CJIhOZzXo=
Date: Sat, 28 Mar 2026 17:40:00 -0700
To: mm-commits@vger.kernel.org,zbestahu@gmail.com,xiang@kernel.org,willy@infradead.org,vishal.l.verma@intel.com,vbabka@kernel.org,tony.luck@intel.com,surenb@google.com,rppt@kernel.org,reinette.chatre@intel.com,pfalcato@suse.de,osalvador@suse.de,naohiro.aota@wdc.com,muchun.song@linux.dev,mhocko@suse.com,lihongbo22@huawei.com,liam.howlett@oracle.com,jth@kernel.org,jgg@ziepe.ca,jefflexu@linux.alibaba.com,jannh@google.com,james.morse@arm.com,jack@suse.cz,hughd@google.com,guochunhai@vivo.com,gregkh@linuxfoundation.org,dlemoal@kernel.org,dhavale@google.com,david@kernel.org,dave.martin@arm.com,dave.jiang@intel.com,dan.j.williams@intel.com,chao@kernel.org,baolin.wang@linux.alibaba.com,babu.moger@amd.com,arnd@arndb.de,almaz.alexandrovich@paragon-software.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-always-inline-__mk_vma_flags-and-invoked-functions.patch removed from -mm tree
Message-Id: <20260329004001.5A0F7C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: always inline __mk_vma_flags() and invoked functions
has been removed from the -mm tree.  Its filename was
     mm-always-inline-__mk_vma_flags-and-invoked-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm: always inline __mk_vma_flags() and invoked functions
Date: Thu, 5 Mar 2026 10:50:16 +0000

Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
macro) always being inline, as we rely on the compiler to evaluate the
loop in this function and determine that it can replace the code with the
an equivalent constant value, e.g. that:

__mk_vma_flags(2, (const vma_flag_t []){ VMA_WRITE_BIT, VMA_EXEC_BIT });

Can be replaced with:

(1UL << VMA_WRITE_BIT) | (1UL << VMA_EXEC_BIT)

= (1UL << 1) | (1UL << 2) = 6

Most likely an 'inline' will suffice for this, but be explicit as we can
be.

Also update all of the functions __mk_vma_flags() ultimately invokes to be
always inline too.

Note that test_bitmap_const_eval() asserts that the relevant bitmap
functions result in build time constant values.

Additionally, vma_flag_set() operates on a vma_flags_t type, so it is
inconsistently named versus other VMA flags functions.

We only use vma_flag_set() in __mk_vma_flags() so we don't need to worry
about its new name being rather cumbersome, so rename it to
vma_flags_set_flag() to disambiguate it from vma_flags_set().

Also update the VMA test headers to reflect the changes.

Link: https://lkml.kernel.org/r/241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org
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

 include/linux/mm.h                 |    8 +++++---
 include/linux/mm_types.h           |    2 +-
 tools/testing/vma/include/custom.h |    5 +++--
 tools/testing/vma/include/dup.h    |    5 +++--
 4 files changed, 12 insertions(+), 8 deletions(-)

--- a/include/linux/mm.h~mm-always-inline-__mk_vma_flags-and-invoked-functions
+++ a/include/linux/mm.h
@@ -1030,21 +1030,23 @@ static inline bool vma_test_atomic_flag(
 }
 
 /* Set an individual VMA flag in flags, non-atomically. */
-static inline void vma_flag_set(vma_flags_t *flags, vma_flag_t bit)
+static __always_inline void vma_flags_set_flag(vma_flags_t *flags,
+		vma_flag_t bit)
 {
 	unsigned long *bitmap = flags->__vma_flags;
 
 	__set_bit((__force int)bit, bitmap);
 }
 
-static inline vma_flags_t __mk_vma_flags(size_t count, const vma_flag_t *bits)
+static __always_inline vma_flags_t __mk_vma_flags(size_t count,
+		const vma_flag_t *bits)
 {
 	vma_flags_t flags;
 	int i;
 
 	vma_flags_clear_all(&flags);
 	for (i = 0; i < count; i++)
-		vma_flag_set(&flags, bits[i]);
+		vma_flags_set_flag(&flags, bits[i]);
 	return flags;
 }
 
--- a/include/linux/mm_types.h~mm-always-inline-__mk_vma_flags-and-invoked-functions
+++ a/include/linux/mm_types.h
@@ -1056,7 +1056,7 @@ struct vm_area_struct {
 } __randomize_layout;
 
 /* Clears all bits in the VMA flags bitmap, non-atomically. */
-static inline void vma_flags_clear_all(vma_flags_t *flags)
+static __always_inline void vma_flags_clear_all(vma_flags_t *flags)
 {
 	bitmap_zero(flags->__vma_flags, NUM_VMA_FLAG_BITS);
 }
--- a/tools/testing/vma/include/custom.h~mm-always-inline-__mk_vma_flags-and-invoked-functions
+++ a/tools/testing/vma/include/custom.h
@@ -102,7 +102,8 @@ static inline void vma_lock_init(struct
 		refcount_set(&vma->vm_refcnt, 0);
 }
 
-static inline vma_flags_t __mk_vma_flags(size_t count, const vma_flag_t *bits)
+static __always_inline vma_flags_t __mk_vma_flags(size_t count,
+		const vma_flag_t *bits)
 {
 	vma_flags_t flags;
 	int i;
@@ -114,6 +115,6 @@ static inline vma_flags_t __mk_vma_flags
 	vma_flags_clear_all(&flags);
 	for (i = 0; i < count; i++)
 		if (bits[i] < NUM_VMA_FLAG_BITS)
-			vma_flag_set(&flags, bits[i]);
+			vma_flags_set_flag(&flags, bits[i]);
 	return flags;
 }
--- a/tools/testing/vma/include/dup.h~mm-always-inline-__mk_vma_flags-and-invoked-functions
+++ a/tools/testing/vma/include/dup.h
@@ -780,12 +780,13 @@ static inline void vma_flags_clear_word(
 	*bitmap &= ~value;
 }
 
-static inline void vma_flags_clear_all(vma_flags_t *flags)
+static __always_inline void vma_flags_clear_all(vma_flags_t *flags)
 {
 	bitmap_zero(ACCESS_PRIVATE(flags, __vma_flags), NUM_VMA_FLAG_BITS);
 }
 
-static inline void vma_flag_set(vma_flags_t *flags, vma_flag_t bit)
+static __always_inline void vma_flags_set_flag(vma_flags_t *flags,
+		vma_flag_t bit)
 {
 	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
 
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

