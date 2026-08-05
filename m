Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837623C09E4
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896756; cv=none; b=Cdw0xzt0QM/Yt2bxxWbbrojz65Yg2+aRcYDcVQB7u8R3lmAFLB0gJzYsO/4DIsX9Di6m+0RmgEeXQj4H05XiFtuY9gY9V/SsHBgJsiOMSSTrg1tOQx14M6R2JYmtKDlPj8vghAd+SutuCoq30JfMc7xJyVW2e9UCLvqpZlNZpFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896756; c=relaxed/simple;
	bh=Y52LHglouUkLcs8UjWRaUnqNtA0TAhlMxH9aaSlxdR0=;
	h=Date:To:From:Subject:Message-Id; b=eFPTDuph9IVTfHvR3SYUQLt8gCvAO0vDZj/AW+aGxenaTalWdwGrFk2jyBk5FpbzopUWpM7yOmorVCUPN5RqT/g5oBDBLko/A2D3pNcV8ectHxAgPCe8HVsrChjDk9abxDHWHKWSfq8iUIt3i9i8ULrJfkSrbqaqorRxA4R26I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0GRQQJ7W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0GRQQJ7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA511F000E9;
	Wed,  5 Aug 2026 02:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896755;
	bh=n65lOhQVxeMJ0MNycsoR3LsYLRu4U9AVkSeh+2CcF7w=;
	h=Date:To:From:Subject;
	b=0GRQQJ7Wwz9bR7wIQ1jbl7dg4BaD+PqooAaoyUiyFe17Sw9GPfV6YFUnOw3R+EmgW
	 SS7yrZ1z6AgnJpLevK1O/BsNsR79k1Sdlv9cUqYWfyVNSWrozG8ZxMTrXgOpxGbiwk
	 oIr9ZRXD+ZyeuVuxmNXEZGrnVmPegYgjbMtP+B1U=
Date: Tue, 04 Aug 2026 19:25:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,sj@kernel.org,pfalcato@suse.de,m.szyprowski@samsung.com,liam@infradead.org,kai.huang@intel.com,gourry@gourry.net,david@kernel.org,ackerleytng@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-elide-unnecessary-static-inlines-in-interval_treec.patch removed from -mm tree
Message-Id: <20260805022555.4CA511F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: elide unnecessary static inline's in interval_tree.c
has been removed from the -mm tree.  Its filename was
     mm-rmap-elide-unnecessary-static-inlines-in-interval_treec.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/rmap: elide unnecessary static inline's in interval_tree.c
Date: Fri, 10 Jul 2026 21:16:48 +0100

It's not necessary to declare these functions static inline as they are
contained within a single compilation unit.

This makes the anonymous interval tree code consistent with the newly
updated file-backed interval tree code.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-7-2a5aa403d977@kernel.org
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

 mm/interval_tree.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/interval_tree.c~mm-rmap-elide-unnecessary-static-inlines-in-interval_treec
+++ a/mm/interval_tree.c
@@ -81,19 +81,19 @@ vma_interval_tree_iter_next(struct vm_ar
 
 /* Anonymous interval tree (anon_vma->rb_root) */
 
-static inline unsigned long avc_start_pgoff(struct anon_vma_chain *avc)
+static unsigned long avc_start_pgoff(struct anon_vma_chain *avc)
 {
 	return vma_start_pgoff(avc->vma);
 }
 
-static inline unsigned long avc_last_pgoff(struct anon_vma_chain *avc)
+static unsigned long avc_last_pgoff(struct anon_vma_chain *avc)
 {
 	return vma_last_pgoff(avc->vma);
 }
 
 INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, unsigned long, rb_subtree_last,
 		     avc_start_pgoff, avc_last_pgoff,
-		     static inline, __anon_vma_interval_tree)
+		     static, __anon_vma_interval_tree)
 
 void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
 				   struct rb_root_cached *root)
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

