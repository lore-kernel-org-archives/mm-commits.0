Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC2E378D6B
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388658; cv=none; b=Q7inTxNwrMMYAu+VtUYQQWL5YAlmVVUjvZAHRc1gO0iQLwbvRfLdrx6ORhimHuGcakLaFvWpUORsAVt6FbC+tc9pd7M2y2J63imaXlgJ5GKBBMv+tpOnfvvtY3cTpYpl5+TuUgrZQdyiWrhfnot2mabyUDybl6wDXKj1DHgPTo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388658; c=relaxed/simple;
	bh=QnsujPDccThzrcz+QXwNEm9DOtyALACgwXJuS85+EyI=;
	h=Date:To:From:Subject:Message-Id; b=B1SERtmOW9KcCm7SWL6Xp06Sip28ZLcrscvjA8+4DIXriTclNBnIY0N0wfjyQi+uGoC/JUvYcyow/dLQXNbyl8tfBTuumJeZN1YpWFIGMEG9upoeBjJ6+guUXmHqAECc6Z9HEKShPnW+9rFWcrxxIIcN6U81tNRpYYD/dblaM/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y8fQOlXm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y8fQOlXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CF8C19424;
	Tue, 24 Mar 2026 21:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388658;
	bh=QnsujPDccThzrcz+QXwNEm9DOtyALACgwXJuS85+EyI=;
	h=Date:To:From:Subject:From;
	b=y8fQOlXmJwxSt31C8q8QsxP6OKM9vb/EDuCO1PNQ7JDsIv7F3Xzjyl7WTZoBlTlMJ
	 yXwCdxM+xMnp/SSbmwCOGqTilsP90x0OQ5vdVs4QxLhsCLLIeKLK9NXGdaxmyDe+nf
	 KjqOeGMBz/AmlcTFjTgeElInY9l2OabqL2Au5WEU=
Date: Tue, 24 Mar 2026 14:44:17 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pagewalk-drop-fw_migration.patch removed from -mm tree
Message-Id: <20260324214418.33CF8C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/pagewalk: drop FW_MIGRATION
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-drop-fw_migration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/pagewalk: drop FW_MIGRATION
Date: Fri, 27 Feb 2026 22:29:52 +0100

We removed the last user of FW_MIGRATION in commit 912aa825957f ("Revert
"mm/ksm: convert break_ksm() from walk_page_range_vma() to folio_walk"").

So let's remove FW_MIGRATION and assign FW_ZEROPAGE bit 0.  Including
leafops.h is no longer required.

While at it, convert "expose_page" to "zeropage", as zeropages are now the
only remaining use case for not exposing a page.

Link: https://lkml.kernel.org/r/20260227212952.190691-1-david@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagewalk.h |    8 -------
 mm/pagewalk.c            |   40 +++++++------------------------------
 2 files changed, 9 insertions(+), 39 deletions(-)

--- a/include/linux/pagewalk.h~mm-pagewalk-drop-fw_migration
+++ a/include/linux/pagewalk.h
@@ -148,14 +148,8 @@ int walk_page_mapping(struct address_spa
 
 typedef int __bitwise folio_walk_flags_t;
 
-/*
- * Walk migration entries as well. Careful: a large folio might get split
- * concurrently.
- */
-#define FW_MIGRATION			((__force folio_walk_flags_t)BIT(0))
-
 /* Walk shared zeropages (small + huge) as well. */
-#define FW_ZEROPAGE			((__force folio_walk_flags_t)BIT(1))
+#define FW_ZEROPAGE			((__force folio_walk_flags_t)BIT(0))
 
 enum folio_walk_level {
 	FW_LEVEL_PTE,
--- a/mm/pagewalk.c~mm-pagewalk-drop-fw_migration
+++ a/mm/pagewalk.c
@@ -5,7 +5,6 @@
 #include <linux/hugetlb.h>
 #include <linux/mmu_context.h>
 #include <linux/swap.h>
-#include <linux/leafops.h>
 
 #include <asm/tlbflush.h>
 
@@ -841,9 +840,6 @@ int walk_page_mapping(struct address_spa
  * VM as documented by vm_normal_page(). If requested, zeropages will be
  * returned as well.
  *
- * As default, this function only considers present page table entries.
- * If requested, it will also consider migration entries.
- *
  * If this function returns NULL it might either indicate "there is nothing" or
  * "there is nothing suitable".
  *
@@ -854,11 +850,10 @@ int walk_page_mapping(struct address_spa
  * that call.
  *
  * @fw->page will correspond to the page that is effectively referenced by
- * @addr. However, for migration entries and shared zeropages @fw->page is
- * set to NULL. Note that large folios might be mapped by multiple page table
- * entries, and this function will always only lookup a single entry as
- * specified by @addr, which might or might not cover more than a single page of
- * the returned folio.
+ * @addr. However, for shared zeropages @fw->page is set to NULL. Note that
+ * large folios might be mapped by multiple page table entries, and this
+ * function will always only lookup a single entry as specified by @addr, which
+ * might or might not cover more than a single page of the returned folio.
  *
  * This function must *not* be used as a naive replacement for
  * get_user_pages() / pin_user_pages(), especially not to perform DMA or
@@ -885,7 +880,7 @@ struct folio *folio_walk_start(struct fo
 		folio_walk_flags_t flags)
 {
 	unsigned long entry_size;
-	bool expose_page = true;
+	bool zeropage = false;
 	struct page *page;
 	pud_t *pudp, pud;
 	pmd_t *pmdp, pmd;
@@ -933,10 +928,6 @@ struct folio *folio_walk_start(struct fo
 			if (page)
 				goto found;
 		}
-		/*
-		 * TODO: FW_MIGRATION support for PUD migration entries
-		 * once there are relevant users.
-		 */
 		spin_unlock(ptl);
 		goto not_found;
 	}
@@ -970,16 +961,9 @@ pmd_table:
 			} else if ((flags & FW_ZEROPAGE) &&
 				    is_huge_zero_pmd(pmd)) {
 				page = pfn_to_page(pmd_pfn(pmd));
-				expose_page = false;
+				zeropage = true;
 				goto found;
 			}
-		} else if ((flags & FW_MIGRATION) &&
-			   pmd_is_migration_entry(pmd)) {
-			const softleaf_t entry = softleaf_from_pmd(pmd);
-
-			page = softleaf_to_page(entry);
-			expose_page = false;
-			goto found;
 		}
 		spin_unlock(ptl);
 		goto not_found;
@@ -1004,15 +988,7 @@ pte_table:
 		if ((flags & FW_ZEROPAGE) &&
 		    is_zero_pfn(pte_pfn(pte))) {
 			page = pfn_to_page(pte_pfn(pte));
-			expose_page = false;
-			goto found;
-		}
-	} else if (!pte_none(pte)) {
-		const softleaf_t entry = softleaf_from_pte(pte);
-
-		if ((flags & FW_MIGRATION) && softleaf_is_migration(entry)) {
-			page = softleaf_to_page(entry);
-			expose_page = false;
+			zeropage = true;
 			goto found;
 		}
 	}
@@ -1021,7 +997,7 @@ not_found:
 	vma_pgtable_walk_end(vma);
 	return NULL;
 found:
-	if (expose_page)
+	if (!zeropage)
 		/* Note: Offset from the mapped page, not the folio start. */
 		fw->page = page + ((addr & (entry_size - 1)) >> PAGE_SHIFT);
 	else
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

