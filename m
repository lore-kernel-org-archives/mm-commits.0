Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE83364053
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388592; cv=none; b=cRHxnrm3kkfj31NEPu3n3t5Y5ryWxJTUZFCc6YN/bdb+bwM2MFsT6FlkFDSRa8hqtPhMTonWgmxtzeF+Dp2FTtjl0SxFpTMNkIxJxYm9l1w1X5oiA1PPOa5NIVVJnQJ+gMbQorDczknSeYNnBij45nEBj7q0MxNi/QO1AdRX0Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388592; c=relaxed/simple;
	bh=gxUWCb635vDA1uX2gqi1exQ/XBp8cGRIMFAGa31ltb0=;
	h=Date:To:From:Subject:Message-Id; b=ZHT4cSZg7xN8h/HM7rq6el4SNs3VUYlAWNADP3uV+iXGMnKYj2l6ngNeYYVgl+5zsdHbbnm1bz03cUuxN/1B5djIArAXgwGfOK5eXZ+uD7iYWZvVQ9NP0uZiU7pFFFFSIuL26SIrqthRYLIeFpoCIsICeJMoh3JzYYV1OECwgF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PcjEziNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PcjEziNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A67EC19424;
	Tue, 24 Mar 2026 21:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388592;
	bh=gxUWCb635vDA1uX2gqi1exQ/XBp8cGRIMFAGa31ltb0=;
	h=Date:To:From:Subject:From;
	b=PcjEziNXb/hvAlpbbh83uSsvoIgGSOKdTAlUJBBgsK1Jf1pVbzCWrggq/A1DHtzKq
	 V9XadWrDfZQL48crzjtJH5tk/ZnjA3w8px+SsyBJHAwIvl/jMiaEYfAfCcqYbKMxb4
	 NJ+WEaUu9/Y/F8bE4YPpqZt08I/Ji1IW+v2MOBaI=
Date: Tue, 24 Mar 2026 14:43:11 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap.patch removed from -mm tree
Message-Id: <20260324214312.7A67EC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: centralize+fix comments about compound_mapcount() in new sync_with_folio_pmd_zap()
has been removed from the -mm tree.  Its filename was
     mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: centralize+fix comments about compound_mapcount() in new sync_with_folio_pmd_zap()
Date: Mon, 23 Feb 2026 17:39:20 +0100

We still mention compound_mapcount() in two comments.

Instead of simply referring to the folio mapcount in both places, let's
factor out the odd-looking PTL sync into sync_with_folio_pmd_zap(), and
add centralized documentation why this is required.

[akpm@linux-foundation.org: update comment per Matthew and David]
Link: https://lkml.kernel.org/r/20260223163920.287720-1-david@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h        |   19 +++++++++++++++++++
 mm/memory.c          |    8 +-------
 mm/page_vma_mapped.c |   11 ++---------
 3 files changed, 22 insertions(+), 16 deletions(-)

--- a/mm/internal.h~mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap
+++ a/mm/internal.h
@@ -516,6 +516,25 @@ void free_pgtables(struct mmu_gather *tl
 
 void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
 
+/**
+ * sync_with_folio_pmd_zap - sync with concurrent zapping of a folio PMD
+ * @mm: The mm_struct.
+ * @pmdp: Pointer to the pmd that was found to be pmd_none().
+ *
+ * When we find a pmd_none() while unmapping a folio without holding the PTL,
+ * zap_huge_pmd() may have cleared the PMD but not yet modified the folio to
+ * indicate that it's unmapped. Skipping the PMD without synchronization could
+ * make folio unmapping code assume that unmapping failed.
+ *
+ * Wait for concurrent zapping to complete by grabbing the PTL.
+ */
+static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp)
+{
+	spinlock_t *ptl = pmd_lock(mm, pmdp);
+
+	spin_unlock(ptl);
+}
+
 struct zap_details;
 void unmap_page_range(struct mmu_gather *tlb,
 			     struct vm_area_struct *vma,
--- a/mm/memory.c~mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap
+++ a/mm/memory.c
@@ -1993,13 +1993,7 @@ static inline unsigned long zap_pmd_rang
 		} else if (details && details->single_folio &&
 			   folio_test_pmd_mappable(details->single_folio) &&
 			   next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
-			spinlock_t *ptl = pmd_lock(tlb->mm, pmd);
-			/*
-			 * Take and drop THP pmd lock so that we cannot return
-			 * prematurely, while zap_huge_pmd() has cleared *pmd,
-			 * but not yet decremented compound_mapcount().
-			 */
-			spin_unlock(ptl);
+			sync_with_folio_pmd_zap(tlb->mm, pmd);
 		}
 		if (pmd_none(*pmd)) {
 			addr = next;
--- a/mm/page_vma_mapped.c~mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap
+++ a/mm/page_vma_mapped.c
@@ -269,11 +269,6 @@ restart:
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
 		} else if (!pmd_present(pmde)) {
-			/*
-			 * If PVMW_SYNC, take and drop THP pmd lock so that we
-			 * cannot return prematurely, while zap_huge_pmd() has
-			 * cleared *pmd but not decremented compound_mapcount().
-			 */
 			const softleaf_t entry = softleaf_from_pmd(pmde);
 
 			if (softleaf_is_device_private(entry)) {
@@ -284,11 +279,9 @@ restart:
 			if ((pvmw->flags & PVMW_SYNC) &&
 			    thp_vma_suitable_order(vma, pvmw->address,
 						   PMD_ORDER) &&
-			    (pvmw->nr_pages >= HPAGE_PMD_NR)) {
-				spinlock_t *ptl = pmd_lock(mm, pvmw->pmd);
+			    (pvmw->nr_pages >= HPAGE_PMD_NR))
+				sync_with_folio_pmd_zap(mm, pvmw->pmd);
 
-				spin_unlock(ptl);
-			}
 			step_forward(pvmw, PMD_SIZE);
 			continue;
 		}
_

Patches currently in -mm which might be from david@kernel.org are

mm-memory-fix-pmd-pud-checks-in-follow_pfnmap_start.patch
mm-madvise-drop-range-checks-in-madvise_free_single_vma.patch
mm-memory-remove-zap_details-parameter-from-zap_page_range_single.patch
mm-memory-remove-zap_details-parameter-from-zap_page_range_single-fix.patch
mm-memory-inline-unmap_mapping_range_vma-into-unmap_mapping_range_tree.patch
mm-memory-simplify-calculation-in-unmap_mapping_range_tree.patch
mm-oom_kill-use-mmu_notify_clear-in-__oom_reap_task_mm.patch
mm-oom_kill-factor-out-zapping-of-vma-into-zap_vma_for_reaping.patch
mm-memory-rename-unmap_single_vma-to-__zap_vma_range.patch
mm-memory-move-adjusting-of-address-range-to-unmap_vmas.patch
mm-memory-convert-details-even_cows-into-details-skip_cows.patch
mm-memory-use-__zap_vma_range-in-zap_vma_for_reaping.patch
mm-memory-inline-unmap_page_range-into-__zap_vma_range.patch
mm-memory-inline-unmap_page_range-into-__zap_vma_range-fix.patch
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

