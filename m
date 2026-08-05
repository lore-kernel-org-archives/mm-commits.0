Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA163C108E
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896796; cv=none; b=P5M6xa8ImxThR0YFKIs9+/ZJFU99MULgyy5k/mOp1Pe/KMfRa8Ytn+BgwQf0AdlXOfLyJzbSVktqpEdZsXCHK3ewbUBJf2HfOTFIrutk8e1STDbYZd8nFufBmaveKuBY7sICR03s6/7QPmVhI8H2+R/C1NJL8szMPuSxJVvNGFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896796; c=relaxed/simple;
	bh=xqePtyG2hURp0vgNnoDacT02cBPBpT/tXIv32u8hrkw=;
	h=Date:To:From:Subject:Message-Id; b=Fz6RIyDJGVzxXTOFgn+BWAbDzzTER8HussgJNkyZswmWY9iiLSGxbY6opIpw1edeNwJGEsn7kLJj4I10gNXebYG7wciqoAFKFFT4uoKzi6HEqe+dWCelb0rwJ59rt1Uzjq70CdVT94piGPHVFSye1nwg+LRx3b0y+MIfcW44udM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NQmREKMp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NQmREKMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D061F00A3A;
	Wed,  5 Aug 2026 02:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896795;
	bh=Xb0pLRvq8Kw9moR4sSG8X5QknHZ4cVHSc6q6XU9JkSc=;
	h=Date:To:From:Subject;
	b=NQmREKMpIKaF4uuykSdQZHXbFEFAyuMJ2eQuvXLMatkeSrPhRMFui5bwcfyPdSu7P
	 WHPyV3HWLB1OzM5ukpRmod3dhFAGh5z4WLPZ1iwMvUGxRHT1jlJuzorDvmk2FAOq/8
	 oBWHEQ7YwO4WPgMxms29H7hfKTdq6D7cFVQ02V7Y=
Date: Tue, 04 Aug 2026 19:26:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,sj@kernel.org,pfalcato@suse.de,m.szyprowski@samsung.com,liam@infradead.org,kai.huang@intel.com,gourry@gourry.net,david@kernel.org,ackerleytng@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-use-guard-clauses-in-can_vma_merge_.patch removed from -mm tree
Message-Id: <20260805022635.13D061F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: use guard clauses in can_vma_merge_[before, after]()
has been removed from the -mm tree.  Its filename was
     mm-vma-use-guard-clauses-in-can_vma_merge_.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/vma: use guard clauses in can_vma_merge_[before, after]()
Date: Fri, 10 Jul 2026 21:17:12 +0100

Rather than combining a bunch of conditionals in a single expression,
simplify by inverting the mergeability requirements into guard clauses.

that is - instead of checking what must be true for the conditions to be
met, instead check the inverse of the requirements and return false if any
are true, defaulting to true.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-31-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/mm/vma.c~mm-vma-use-guard-clauses-in-can_vma_merge_
+++ a/mm/vma.c
@@ -215,13 +215,13 @@ static void init_multi_vma_prep(struct v
  */
 static bool can_vma_merge_before(struct vma_merge_struct *vmg)
 {
-	if (is_mergeable_vma(vmg, /* merge_next = */ true) &&
-	    is_mergeable_anon_vma(vmg, /* merge_next = */ true)) {
-		if (vmg_end_pgoff(vmg) == vma_start_pgoff(vmg->next))
-			return true;
-	}
-
-	return false;
+	if (!is_mergeable_vma(vmg, /* merge_next = */ true))
+		return false;
+	if (!is_mergeable_anon_vma(vmg, /* merge_next = */ true))
+		return false;
+	if (vmg_end_pgoff(vmg) != vma_start_pgoff(vmg->next))
+		return false;
+	return true;
 }
 
 /*
@@ -235,12 +235,13 @@ static bool can_vma_merge_before(struct
  */
 static bool can_vma_merge_after(struct vma_merge_struct *vmg)
 {
-	if (is_mergeable_vma(vmg, /* merge_next = */ false) &&
-	    is_mergeable_anon_vma(vmg, /* merge_next = */ false)) {
-		if (vma_end_pgoff(vmg->prev) == vmg_start_pgoff(vmg))
-			return true;
-	}
-	return false;
+	if (!is_mergeable_vma(vmg, /* merge_next = */ false))
+		return false;
+	if (!is_mergeable_anon_vma(vmg, /* merge_next = */ false))
+		return false;
+	if (vma_end_pgoff(vmg->prev) != vmg_start_pgoff(vmg))
+		return false;
+	return true;
 }
 
 static void __vma_link_file(struct vm_area_struct *vma,
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

