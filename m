Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A4C3C9EE0
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 23:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774394016; cv=none; b=QbT3o5i/HAvgEnQOMfn6yJ+7yCc28Xw1DWOXvrn4f/Obgne6viQhExkj7sbrwjKTsdWZX92ugIf/zuLPX291TtdNXx/HGx4BclBVXHH03ZYjhdcV1BfK7ogmTias2tnrzPQopy6bQQ8CZYcQgp1jiDsaZN9uLASHbUo0/h7aJNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774394016; c=relaxed/simple;
	bh=tCkvbpxWFpbHcPjR87g7DNu6Weh5K0QNbXxkW/cKi/U=;
	h=Date:To:From:Subject:Message-Id; b=HojItIP7XYxFmPha0AGjmRKVJiafd7KlMaiKtgHB0zrJdV9EaIvsSXNXFhB2ySXsnVcRnkn1vzHYW8afGNiBbwuCXJty5o3JTHQIkqg0nsi5P95S8PGok0R7zSUEfd1mNVkhO3Itk9Fdl0vtzbaOiBsYmyFuQVik6ODE0XZKHtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wVvA2nh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wVvA2nh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42309C2BCB2;
	Tue, 24 Mar 2026 23:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774394016;
	bh=tCkvbpxWFpbHcPjR87g7DNu6Weh5K0QNbXxkW/cKi/U=;
	h=Date:To:From:Subject:From;
	b=wVvA2nh06ZnJdN8vD7Os+RTdxMDD0cLtsV7eMp1QFH3d7gFEUBBzXCH2XacMWua05
	 S1zyXo0VAt2LcER0DxeiZzr6Fso2Bryc3ChNUJPfy1p1FcF2u8pszkH5m6xjZQDIb4
	 Sm6KK4NTB8/4grPvfUi7qmQ+/O+KdsLBzbtSbvkY=
Date: Tue, 24 Mar 2026 16:13:35 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory-inline-unmap_page_range-into-__zap_vma_range-fix.patch removed from -mm tree
Message-Id: <20260324231336.42309C2BCB2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memory-inline-unmap_page_range-into-__zap_vma_range-fix
has been removed from the -mm tree.  Its filename was
     mm-memory-inline-unmap_page_range-into-__zap_vma_range-fix.patch

This patch was dropped because it was folded into mm-memory-inline-unmap_page_range-into-__zap_vma_range.patch

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm-memory-inline-unmap_page_range-into-__zap_vma_range-fix
Date: Wed, 11 Mar 2026 10:19:00 +0100

tet's call the local variable simply "addr", per Lorenzo

Link: https://lkml.kernel.org/r/f7732d1c-0e85-4a14-948a-912c417018b5@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-memory-inline-unmap_page_range-into-__zap_vma_range-fix
+++ a/mm/memory.c
@@ -2081,17 +2081,17 @@ static void __zap_vma_range(struct mmu_g
 			return;
 		__unmap_hugepage_range(tlb, vma, start, end, NULL, zap_flags);
 	} else {
-		unsigned long next, cur = start;
+		unsigned long next, addr = start;
 		pgd_t *pgd;
 
 		tlb_start_vma(tlb, vma);
-		pgd = pgd_offset(vma->vm_mm, cur);
+		pgd = pgd_offset(vma->vm_mm, addr);
 		do {
-			next = pgd_addr_end(cur, end);
+			next = pgd_addr_end(addr, end);
 			if (pgd_none_or_clear_bad(pgd))
 				continue;
-			next = zap_p4d_range(tlb, vma, pgd, cur, next, details);
-		} while (pgd++, cur = next, cur != end);
+			next = zap_p4d_range(tlb, vma, pgd, addr, next, details);
+		} while (pgd++, addr = next, addr != end);
 		tlb_end_vma(tlb, vma);
 	}
 }
_

Patches currently in -mm which might be from david@kernel.org are

mm-memory-fix-pmd-pud-checks-in-follow_pfnmap_start.patch
mm-madvise-drop-range-checks-in-madvise_free_single_vma.patch
mm-memory-remove-zap_details-parameter-from-zap_page_range_single.patch
mm-memory-inline-unmap_mapping_range_vma-into-unmap_mapping_range_tree.patch
mm-memory-simplify-calculation-in-unmap_mapping_range_tree.patch
mm-oom_kill-use-mmu_notify_clear-in-__oom_reap_task_mm.patch
mm-oom_kill-factor-out-zapping-of-vma-into-zap_vma_for_reaping.patch
mm-memory-rename-unmap_single_vma-to-__zap_vma_range.patch
mm-memory-move-adjusting-of-address-range-to-unmap_vmas.patch
mm-memory-convert-details-even_cows-into-details-skip_cows.patch
mm-memory-use-__zap_vma_range-in-zap_vma_for_reaping.patch
mm-memory-inline-unmap_page_range-into-__zap_vma_range.patch
mm-rename-zap_vma_pages-to-zap_vma.patch
mm-rename-zap_page_range_single_batched-to-zap_vma_range_batched.patch
mm-rename-zap_page_range_single-to-zap_vma_range.patch
mm-rename-zap_vma_ptes-to-zap_special_vma_range.patch
mm-memory-support-vm_mixedmap-in-zap_special_vma_range.patch
mm-move-vma_kernel_pagesize-from-hugetlb-to-mmh.patch
mm-move-vma_mmu_pagesize-from-hugetlb-to-vmac.patch
kvm-remove-hugetlbh-inclusion.patch
kvm-ppc-remove-hugetlbh-inclusion.patch
mm-memory_hotplug-remove-for_each_valid_pfn-usage.patch
mm-sparse-remove-warn_ons-from-onlineoffline_mem_sections.patch
mm-kconfig-make-config_memory_hotplug-depend-on-config_sparsemem_vmemmap.patch
mm-memory_hotplug-simplify-check_pfn_span.patch
mm-sparse-remove-config_sparsemem_vmemmap-leftovers-for-config_memory_hotplug.patch
mm-bootmem_info-remove-handling-for-config_sparsemem_vmemmap.patch
mm-bootmem_info-avoid-using-sparse_decode_mem_map.patch
mm-sparse-remove-sparse_decode_mem_map.patch
mm-sparse-remove-config_memory_hotplug-specific-usemap-allocation-handling.patch
mm-prepare-to-move-subsection_map_init-to-mm-sparse-vmemmapc.patch
mm-sparse-drop-set_section_nid-from-sparse_add_section.patch
mm-sparse-move-sparse_init_one_section-to-internalh.patch
mm-sparse-move-sparse_init_one_section-to-internalh-fix.patch
mm-sparse-move-__section_mark_present-to-internalh.patch
mm-sparse-move-memory-hotplug-bits-to-sparse-vmemmapc.patch
mm-remove-config_arch_enable_memory_hotremove.patch
mm-introduce-config_numa_migration-and-simplify-config_migration.patch

