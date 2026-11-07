Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794023387;
	b=wHPy/WzvynQGp3F6em8Z8voQAny2TyuKF8NT3Vnt4YPZPJNunCccpMUgf6O0PdIZn3Ac
	 gvhcE1Bypmdvl4WLLRMu/1sCHErwHR+02t9w5L7as9cENbM9vFumBbb5k/jaznRr+OONj
	 dlQYWsCn/GyopnXt6HvXiZPTIDx1cSIbPaeG1LeXCYBBw9Ifd33FXEsV6UoHIkdh50tPs
	 15NZ/hsb7A74XGctlQ5eMYM8PJYdQl20X8WzI4LiK3C7QgF/w+kSIUv9LI7UatuC1b8Nv
	 upQLvim5b55G3hIaOqZFzYYm4t0BWRLSAK9RMOa15Z8Df98HWsScHCaKiTHcJFpw3Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794023387;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=df0UMb/NOZQel0f8wEowPZ3CcWGoHkUVC3jrdQZ7rDc=;
	b=oiPAoRpUo5eGGYSO6sD7uMGAwm7NW2Jmjb2dH5CSvgeNIGcJXf367fXGaC/DH2LZtwYq
	 HskOpte/Xi6+NY4FBVw/Bupur4YwDrKA2BlTW3Ku9Z6Byi7Uog2sMSUCzpywTVcDQFRv/
	 Mt+nT+r2VZUP6qBJhMVpvKVCu5CtwXe5bKqwK2o22BNMm0j1dA5cQHJsjJ3x9hsBn1AnL
	 q7OFvXJTdYUMG89iex8ZYodWZSrBLbxTEbYs8h94WEv9q/r3vlZOdJ42RpvJKvIjsEikY
	 4k3giX3tLKpRXet9fZ1ARtB2XKSU8fTVdlr1Iae111Q/dWXfaIzeFHl97odpP67I2ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bDwn5TAQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA24606A32F
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 03:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bDwn5TAQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD8E1F008A1;
	Sat,  7 Nov 2026 03:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794023387;
	bh=df0UMb/NOZQel0f8wEowPZ3CcWGoHkUVC3jrdQZ7rDc=;
	h=Date:To:From:Subject;
	b=bDwn5TAQJpK/iET6mCk80QkkEnm/KM9XlpzqwDL/61doIGYiq3XdJO4KnXKb3k51O
	 daHvSjykSGnvoJj8Lk3Kyt6GPQK10uy8GtwMMZc19SaUbDhOHimdrG1g9yA8cketFE
	 L54Uk3+TE00BhgbQFq1dAd5OwuOMF//b6AWoDZfs=
Date: Fri, 06 Nov 2026 19:49:46 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb_vmemmap-unify-vmemmap_splitremap_no_tlb_flush.patch removed from -mm tree
Message-Id: <20261107034946.DCD8E1F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: unify VMEMMAP_{SPLIT,REMAP}_NO_TLB_FLUSH
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-unify-vmemmap_splitremap_no_tlb_flush.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: hugetlb_vmemmap: unify VMEMMAP_{SPLIT,REMAP}_NO_TLB_FLUSH
Date: Wed, 04 Nov 2026 10:35:00 +0800

VMEMMAP_SPLIT_NO_TLB_FLUSH and VMEMMAP_REMAP_NO_TLB_FLUSH do not describe
fully independent choices.  A split-only walk can defer the PMD-split
flush to a later global flush, and a remap-only walk can defer the final
remap flush.  However, when a PMD split is followed by PTE remapping, the
split flush must happen before the PTEs are changed, because stale
large-page translations must not overlap with new small-page translations
that map different physical pages.

Replace the two flags with a single VMEMMAP_DEFER_TLB_FLUSH flag.  The new
name reflects that only safely batchable flushes are deferred.  Keep
split-only walks able to defer the flush, but force the split flush
whenever a remap_pte callback is present.  Callers that batch HVO work can
still defer the final remap flush and issue their own global flush.

Current callers keep the same flushing behavior.

Link: https://lore.kernel.org/20261104023510.260766-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
  Link: https://lore.kernel.org/20261103224659.2865b9ff27d09994949edd78@linux-foundation.org
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
---

 mm/hugetlb_vmemmap.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-unify-vmemmap_splitremap_no_tlb_flush
+++ a/mm/hugetlb_vmemmap.c
@@ -42,10 +42,8 @@ struct vmemmap_remap_walk {
 	struct list_head	*vmemmap_pages;
 
 
-/* Skip the TLB flush when we split the PMD */
-#define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
-/* Skip the TLB flush when we remap the PTE */
-#define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(1)
+/* Defer safely batchable TLB flushes to the caller. */
+#define VMEMMAP_DEFER_TLB_FLUSH	BIT(0)
 	unsigned long		flags;
 };
 
@@ -85,7 +83,12 @@ static int vmemmap_split_pmd(pmd_t *pmd,
 		/* Make pte visible before pmd. See comment in pmd_install(). */
 		smp_wmb();
 		pmd_populate_kernel(&init_mm, pmd, pgtable);
-		if (!(walk->flags & VMEMMAP_SPLIT_NO_TLB_FLUSH))
+		/*
+		 * Modern MMUs allow overlapping TLB entries with different mapping
+		 * granularities only if they map the same physical address. So
+		 * remapping must not proceed without first flushing the TLB.
+		 */
+		if (walk->remap_pte || !(walk->flags & VMEMMAP_DEFER_TLB_FLUSH))
 			flush_tlb_kernel_range(start, start + PMD_SIZE);
 	} else {
 		pte_free_kernel(&init_mm, pgtable);
@@ -166,7 +169,7 @@ static int vmemmap_remap_range(unsigned
 	if (ret)
 		return ret;
 
-	if (walk->remap_pte && !(walk->flags & VMEMMAP_REMAP_NO_TLB_FLUSH))
+	if (walk->remap_pte && !(walk->flags & VMEMMAP_DEFER_TLB_FLUSH))
 		flush_tlb_kernel_range(start, end);
 
 	return 0;
@@ -274,7 +277,7 @@ static int vmemmap_remap_split(unsigned
 {
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= NULL,
-		.flags		= VMEMMAP_SPLIT_NO_TLB_FLUSH,
+		.flags		= VMEMMAP_DEFER_TLB_FLUSH,
 	};
 
 	return vmemmap_remap_range(start, end, &walk);
@@ -458,7 +461,7 @@ long hugetlb_vmemmap_restore_folios(cons
 	struct folio *folio, *t_folio;
 	long restored = 0;
 	long ret = 0;
-	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
+	unsigned long flags = VMEMMAP_DEFER_TLB_FLUSH;
 
 	list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
 		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
@@ -516,7 +519,7 @@ static int __hugetlb_vmemmap_optimize_fo
 
 	/*
 	 * Very Subtle
-	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
+	 * If VMEMMAP_DEFER_TLB_FLUSH is set, TLB flushing is not performed
 	 * immediately after remapping.  As a result, subsequent accesses
 	 * and modifications to struct pages associated with the hugetlb
 	 * page could be to the OLD struct pages.  Set the vmemmap optimized
@@ -595,7 +598,7 @@ void hugetlb_vmemmap_optimize_folios(str
 	struct folio *folio;
 	unsigned long nr_to_optimize = 0;
 	LIST_HEAD(vmemmap_pages);
-	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
+	unsigned long flags = VMEMMAP_DEFER_TLB_FLUSH;
 
 	if (list_empty(folio_list))
 		return;
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch
mm-generalize-kernel-pte-table-allocation.patch
mm-generalize-pmd-page-table-allocation.patch
mm-generalize-pud-page-table-allocation.patch
mm-remove-pagetable_dtor_free.patch
mm-remove-redundant-pagetable_dtor-calls.patch
mm-hugetlb_vmemmap-simplify-vmemmap-head-page-handling.patch
mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch
mm-hugetlb_vmemmap-unify-writable-vmemmap-page-preparation.patch
mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch
mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch
mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch
mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch
mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch
mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch
mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch
mm-hugetlb-fix-validation-of-unsupported-hugetlb-orders.patch

