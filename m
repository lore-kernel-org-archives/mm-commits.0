Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94FE2C15AC
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 16:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774716327; cv=none; b=ICTJF0Gr41EsbyeM5bY+eK7HdYXdDY9seMtoF65oiNAuNvfcFNJAykt+Fi5bWDkEH+fCUz6o5yhUhfQQ1JgzDJ7NYjHgTmS69T3liRiP1u3MX0prm+FLjIZ5QIK+x0zB4mkCUoPIiwz1vXuyYg47z18jfIrKRgJRxm74cuAntl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774716327; c=relaxed/simple;
	bh=o1ClZ3JytRpU/mb4akkPs1lYTCeZkHY+rTP0MONy1Io=;
	h=Date:To:From:Subject:Message-Id; b=uM4V4aYCIxqkl+EIKbn7jrlu58OWIu1a2HJDJREVmQSMjLy8vBM0imaNxAl8x0CpG+lHzE33Mqc7kLMD5BpPXX+3GWx5nk1n8lLFvwfLFDipEDINIS3DSp0yiX7kCRoubcWit1fF7gA8BX/iZImJOuv3wah1YzNwP7tn4Lz+Wmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nfN/ENzK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nfN/ENzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6EAC4CEF7;
	Sat, 28 Mar 2026 16:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774716326;
	bh=o1ClZ3JytRpU/mb4akkPs1lYTCeZkHY+rTP0MONy1Io=;
	h=Date:To:From:Subject:From;
	b=nfN/ENzKbyER0gdSnlZuJ0XvFDJJP2Q95vUT2fcIlfP/oCeYF4xk01iPA0+CVOFgF
	 xJFYcQTWXnHaeOR81VE59DzD3jJZZ7o3U32nHQCPjEpvYL8W00QIpmS1MduLjb8w1b
	 yfcWkdT72gJ8zviA8t4AiRIdmDdhuSom6YlCv6j8=
Date: Sat, 28 Mar 2026 09:45:25 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,sidhartha.kumar@oracle.com,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-sparse-move-sparse_init_one_section-to-internalh-fix.patch removed from -mm tree
Message-Id: <20260328164526.5F6EAC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-sparse-move-sparse_init_one_section-to-internalh-fix
has been removed from the -mm tree.  Its filename was
     mm-sparse-move-sparse_init_one_section-to-internalh-fix.patch

This patch was dropped because it was folded into mm-sparse-move-sparse_init_one_section-to-internalh.patch

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm-sparse-move-sparse_init_one_section-to-internalh-fix
Date: Mon, 23 Mar 2026 09:48:21 +0100

s/VM_WARN_ON/VM_WARN_ON_ONCE/

Link: https://lkml.kernel.org/r/6b04c1a1-74e7-42e8-8523-a40802e5dacc@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/internal.h~mm-sparse-move-sparse_init_one_section-to-internalh-fix
+++ a/mm/internal.h
@@ -979,7 +979,7 @@ static inline void sparse_init_one_secti
 	 * from the page pointer to obtain the PFN.
 	 */
 	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(pnum));
-	VM_WARN_ON(coded_mem_map & ~SECTION_MAP_MASK);
+	VM_WARN_ON_ONCE(coded_mem_map & ~SECTION_MAP_MASK);
 
 	ms->section_mem_map &= ~SECTION_MAP_MASK;
 	ms->section_mem_map |= coded_mem_map;
_

Patches currently in -mm which might be from david@kernel.org are

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
mm-memory_hotplug-fix-possible-race-in-scan_movable_pages.patch
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
mm-sparse-move-__section_mark_present-to-internalh.patch
mm-sparse-move-memory-hotplug-bits-to-sparse-vmemmapc.patch
mm-remove-config_arch_enable_memory_hotremove.patch
mm-introduce-config_numa_migration-and-simplify-config_migration.patch

