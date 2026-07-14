Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9FB35957;
	Tue, 14 Jul 2026 01:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783993544; cv=none; b=sOSENJWxW9T8soT0msVSQ2smnCPLdhzn642AOxMtaysQfs3R8IyZV/Yj/pzF0K78KoL26RVa1FLbGV+D3MbDvZCfsDRszVwJdu5J0/HjVvkFeoK3ON5EUD+spmKLFiIdGL88T/yknF2faNnhtSLpwB13GzUEebIEcT2aI6Vpark=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783993544; c=relaxed/simple;
	bh=89ToJidhQqZjuflEA2T1SQ/2WpSSuB0z+/677A2nbSo=;
	h=Date:To:From:Subject:Message-Id; b=tNXyQj3VKASepDinnKSwFUkVMyzYhjQVPbxSL9YOXGdE6AZrhnBMOAggdqu+kcc+LogjPkNkYYW1pUGT2VY+rwhzrmYa3NLiA8Hx/tGYfcVaSXVgaufZhBSBhgHTC83jDE+T10IGUVvcZAgDpiDukQFU7I4sGuhHxQ6kE0RIcpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bn+dBiy3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bn+dBiy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D88D1F000E9;
	Tue, 14 Jul 2026 01:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783993542;
	bh=KgbekPrHs1oeqEgo+qitQh8fLuQem0j6LAYsd85ok+I=;
	h=Date:To:From:Subject;
	b=bn+dBiy3ba1+6kVtI4H/Hh9SAWtwJGCWjqpA2JIESWE4HHO/UqCPTfl7xgAjTbUTh
	 Kaq91hZobCmrrr2yHTUMI4Un80fbIYNpwk3VN0Ub+BcAZQxZS4+rf6lBJVY0UmEu2S
	 GwiIox5owjb5cMk9vBlWLxfKi/tn//n5tqsxTWWY=
Date: Mon, 13 Jul 2026 18:45:42 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,toshi.kani@hpe.com,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,liam@infradead.org,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch removed from -mm tree
Message-Id: <20260714014542.9D88D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ptdump: always stabilise against page table freeing using init_mm
has been removed from the -mm tree.  Its filename was
     mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/ptdump: always stabilise against page table freeing using init_mm
Date: Fri, 10 Jul 2026 14:29:21 +0100

x86 and arm64 invoke ptdump_walk_pgd() with non-init_mm mm whilst still
walking kernel page table ranges.

For x86 this is done in ptdump_curknl_show() and ptdump_efi_show(), the
first passing current->mm, and the second passing efi_mm (we reach kernel
mappings that init_mm protects for current->mm due to x86 cloning shared
kernel page tables for arbitrary mm's).

arm64 does so via ptdump_debugfs_register(), configured by efi_ptdump_info
for efi ranges against efi_mm.

The init_mm mmap lock is used to stabilise page table freeing against
ptdump, so take a nested lock on init_mm to ensure that we are correctly
stabilised.

We take this after mmap write locking the non-init_mm mm.  Nothing
acquires the init_mm lock first before locking an arbitrary mm, so no
deadlock is possible.

Other fixes have been sent which update the two cases which can cause
races with ptdump in init_mm ranges to acquire the init_mm mmap write lock
- vmap and x86 CPA huge page promotion.

For arm64, commit fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump")
already provides exclusion against init_mm for the vmap case, which this
patch also pairs with.

The first point at which ptdump can race kernel page table freeing is
commit b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page
table"), so we target this in the Fixes tag.

Link: https://lore.kernel.org/20260710-b4-fix-non-init_mm-ptdump-v1-1-2d40982c98ec@kernel.org
Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ptdump.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/ptdump.c~mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm
+++ a/mm/ptdump.c
@@ -178,11 +178,18 @@ void ptdump_walk_pgd(struct ptdump_state
 
 	get_online_mems();
 	mmap_write_lock(mm);
+	/* To stabilise page tables we must hold the init_mm lock too. */
+	if (mm != &init_mm)
+		mmap_write_lock_nested(&init_mm, SINGLE_DEPTH_NESTING);
+
 	while (range->start != range->end) {
 		walk_page_range_debug(mm, range->start, range->end,
 				      &ptdump_ops, pgd, st);
 		range++;
 	}
+
+	if (mm != &init_mm)
+		mmap_write_unlock(&init_mm);
 	mmap_write_unlock(mm);
 	put_online_mems();
 
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-move-alloc-tag-to-mm.patch
mm-vmalloc-acquire-init_mm-read-lock-on-huge-vmap-promotion.patch
revert-arm64-enable-vmalloc-huge-with-ptdump.patch
mm-move-vma_start_pgoff-into-mmh-and-clean-up.patch
mm-add-kdoc-comments-for-vma_start-last_pgoff.patch
tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch
mm-introduce-and-use-vma_end_pgoff.patch
mm-rmap-update-mm-interval_treec-comments.patch
mm-rmap-parameterise-vma_interval_tree_-by-address_space.patch
mm-rmap-elide-unnecessary-static-inlines-in-interval_treec.patch
mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_.patch
mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma.patch
mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t.patch
mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch
maintainers-move-mm-interval_treec-to-rmap-section.patch
mm-vma-introduce-and-use-vmg_pages-vmg__pgoff.patch
mm-vma-clean-up-anon_vma_compatible.patch
mm-vma-refactor-vmg_adjust_set_range-for-clarity.patch
mm-vma-minor-cleanup-of-expand_.patch
mm-introduce-and-use-linear_page_delta.patch
mm-vma-use-vma_start_pgoff-linear_page_index-in-mm-code.patch
mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel.patch
mm-vma-remove-duplicative-vma_pgoff_offset-helper.patch
mm-use-linear_page_-consistently.patch
mm-vma-introduce-vma_assert_can_modify.patch
mm-vma-add-and-use-vma__pgoff.patch
mm-vma-move-__install_special_mapping-to-vmac.patch
mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch
mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters.patch
mm-vma-update-vmg_adjust_set_range-to-offset-pgoff-instead.patch
mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch
mm-vma-introduce-and-use-vma_set_pgoff.patch
mm-vma-correct-incorrect-vmah-inclusion.patch
mm-vma-use-guard-clauses-in-can_vma_merge_.patch
tools-testing-vma-default-vma-mm-flag-bits-to-64-bit.patch
tools-testing-vma-output-compared-expression-on-assert_.patch
mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.patch
x86-mm-pat-acquire-mmap-lock-on-page-table-free-to-avoid-ptdump-uaf.patch
arm64-remove-redundant-concurrent-ptdump-uaf-mitigation.patch

