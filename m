Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C8657C9F
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 03:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759979904; cv=none; b=s/piVBJL/1H66pZRj9Jjcrz/csxbo8+kuqoP0hONOAltpHd4iJhcmx5D36nleQkasFacisxeqcMvXIih1v0bGNfd/W57PSgU+Vkhd/JgctD3G0+KqHI7vbp7CNdsNnmquS96MynqsX+Rcq+AfFkbuxUp3IfaeSq4mjCl6HWG6z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759979904; c=relaxed/simple;
	bh=0xMMIB2N5Op4KYrMpoVvyzt2xEd6ynm7JwqucxfPakI=;
	h=Date:To:From:Subject:Message-Id; b=bFyGtukAu+TxRl+YfqqHH+nDE/nIUO0GcQoR4nfP9GVA8eMghWVMXNvSB/eaeKenGSnk0LX39UZz/eY2KfxpHm0NX/8VjOlClySFAp5+Yubg9hz40BwrsSRVqtw1FKMvSO03BtPzy+nDkFbzUs440eDpTHYD5wT/Nz/990ibwgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qxM5OWre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qxM5OWre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C30C4CEE7;
	Thu,  9 Oct 2025 03:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759979904;
	bh=0xMMIB2N5Op4KYrMpoVvyzt2xEd6ynm7JwqucxfPakI=;
	h=Date:To:From:Subject:From;
	b=qxM5OWre+R62kOnEuS0fdQGPbJMbF8GzpB/6AK734P8QYX7yb9CSxX4ruh/16Us2b
	 3Nkrzin+rXFDZqQ67gafq7mpD/OGuZ+yozpUdE6WuXir6yiKqbqti7pPOaTkd+JVqX
	 sz3bosBb6FMhlNitNaIjMqh3achDMNFmVg47tXV8=
Date: Wed, 08 Oct 2025 20:18:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,simona@ffwll.ch,ryan.roberts@arm.com,rcampbell@nvidia.com,rakie.kim@sk.com,osalvador@suse.de,npache@redhat.com,mpenttil@redhat.com,matthew.brost@intel.com,lyude@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joshua.hahnjy@gmail.com,gourry@gourry.net,francois.dugast@intel.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,airlied@gmail.com,balbirs@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-device-private-thp-support-to-pmd-operations.patch added to mm-new branch
Message-Id: <20251009031824.43C30C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: add device-private THP support to PMD operations
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-add-device-private-thp-support-to-pmd-operations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-add-device-private-thp-support-to-pmd-operations.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Balbir Singh <balbirs@nvidia.com>
Subject: mm/huge_memory: add device-private THP support to PMD operations
Date: Wed, 1 Oct 2025 16:56:54 +1000

Extend core huge page management functions to handle device-private THP
entries.  This enables proper handling of large device-private folios in
fundamental MM operations.

The following functions have been updated:

- copy_huge_pmd(): Handle device-private entries during fork/clone
- zap_huge_pmd(): Properly free device-private THP during munmap
- change_huge_pmd(): Support protection changes on device-private THP
- __pte_offset_map(): Add device-private entry awareness

Link: https://lkml.kernel.org/r/20251001065707.920170-4-balbirs@nvidia.com
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Francois Dugast <francois.dugast@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |   32 +++++++++++++++++++++
 mm/huge_memory.c        |   56 +++++++++++++++++++++++++++++++-------
 mm/pgtable-generic.c    |    2 -
 3 files changed, 80 insertions(+), 10 deletions(-)

--- a/include/linux/swapops.h~mm-huge_memory-add-device-private-thp-support-to-pmd-operations
+++ a/include/linux/swapops.h
@@ -594,10 +594,42 @@ static inline int is_pmd_migration_entry
 }
 #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
+#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_ENABLE_THP_MIGRATION)
+
+/**
+ * is_pmd_device_private_entry() - Check if PMD contains a device private swap entry
+ * @pmd: The PMD to check
+ *
+ * Returns true if the PMD contains a swap entry that represents a device private
+ * page mapping. This is used for zone device private pages that have been
+ * swapped out but still need special handling during various memory management
+ * operations.
+ *
+ * Return: 1 if PMD contains device private entry, 0 otherwise
+ */
+static inline int is_pmd_device_private_entry(pmd_t pmd)
+{
+	return is_swap_pmd(pmd) && is_device_private_entry(pmd_to_swp_entry(pmd));
+}
+
+#else /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
+
+static inline int is_pmd_device_private_entry(pmd_t pmd)
+{
+	return 0;
+}
+
+#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
+
 static inline int non_swap_entry(swp_entry_t entry)
 {
 	return swp_type(entry) >= MAX_SWAPFILES;
 }
 
+static inline int is_pmd_non_present_folio_entry(pmd_t pmd)
+{
+	return is_pmd_migration_entry(pmd) || is_pmd_device_private_entry(pmd);
+}
+
 #endif /* CONFIG_MMU */
 #endif /* _LINUX_SWAPOPS_H */
--- a/mm/huge_memory.c~mm-huge_memory-add-device-private-thp-support-to-pmd-operations
+++ a/mm/huge_memory.c
@@ -1788,17 +1788,45 @@ int copy_huge_pmd(struct mm_struct *dst_
 	if (unlikely(is_swap_pmd(pmd))) {
 		swp_entry_t entry = pmd_to_swp_entry(pmd);
 
-		VM_BUG_ON(!is_pmd_migration_entry(pmd));
-		if (!is_readable_migration_entry(entry)) {
-			entry = make_readable_migration_entry(
-							swp_offset(entry));
+		VM_WARN_ON(!is_pmd_non_present_folio_entry(pmd));
+
+		if (is_writable_migration_entry(entry) ||
+		    is_readable_exclusive_migration_entry(entry)) {
+			entry = make_readable_migration_entry(swp_offset(entry));
 			pmd = swp_entry_to_pmd(entry);
 			if (pmd_swp_soft_dirty(*src_pmd))
 				pmd = pmd_swp_mksoft_dirty(pmd);
 			if (pmd_swp_uffd_wp(*src_pmd))
 				pmd = pmd_swp_mkuffd_wp(pmd);
 			set_pmd_at(src_mm, addr, src_pmd, pmd);
+		} else if (is_device_private_entry(entry)) {
+			/*
+			 * For device private entries, since there are no
+			 * read exclusive entries, writable = !readable
+			 */
+			if (is_writable_device_private_entry(entry)) {
+				entry = make_readable_device_private_entry(swp_offset(entry));
+				pmd = swp_entry_to_pmd(entry);
+
+				if (pmd_swp_soft_dirty(*src_pmd))
+					pmd = pmd_swp_mksoft_dirty(pmd);
+				if (pmd_swp_uffd_wp(*src_pmd))
+					pmd = pmd_swp_mkuffd_wp(pmd);
+				set_pmd_at(src_mm, addr, src_pmd, pmd);
+			}
+
+			src_folio = pfn_swap_entry_folio(entry);
+			VM_WARN_ON(!folio_test_large(src_folio));
+
+			folio_get(src_folio);
+			/*
+			 * folio_try_dup_anon_rmap_pmd does not fail for
+			 * device private entries.
+			 */
+			folio_try_dup_anon_rmap_pmd(src_folio, &src_folio->page,
+							dst_vma, src_vma);
 		}
+
 		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		mm_inc_nr_ptes(dst_mm);
 		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
@@ -2296,15 +2324,16 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 			folio_remove_rmap_pmd(folio, page, vma);
 			WARN_ON_ONCE(folio_mapcount(folio) < 0);
 			VM_BUG_ON_PAGE(!PageHead(page), page);
-		} else if (thp_migration_supported()) {
+		} else if (is_pmd_non_present_folio_entry(orig_pmd)) {
 			swp_entry_t entry;
 
-			VM_BUG_ON(!is_pmd_migration_entry(orig_pmd));
 			entry = pmd_to_swp_entry(orig_pmd);
 			folio = pfn_swap_entry_folio(entry);
 			flush_needed = 0;
-		} else
-			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+
+			if (!thp_migration_supported())
+				WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+		}
 
 		if (folio_test_anon(folio)) {
 			zap_deposited_table(tlb->mm, pmd);
@@ -2324,6 +2353,12 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 				folio_mark_accessed(folio);
 		}
 
+		if (folio_is_device_private(folio)) {
+			folio_remove_rmap_pmd(folio, &folio->page, vma);
+			WARN_ON_ONCE(folio_mapcount(folio) < 0);
+			folio_put(folio);
+		}
+
 		spin_unlock(ptl);
 		if (flush_needed)
 			tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
@@ -2452,7 +2487,7 @@ int change_huge_pmd(struct mmu_gather *t
 		struct folio *folio = pfn_swap_entry_folio(entry);
 		pmd_t newpmd;
 
-		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
+		VM_WARN_ON(!is_pmd_non_present_folio_entry(*pmd));
 		if (is_writable_migration_entry(entry)) {
 			/*
 			 * A protection check is difficult so
@@ -2465,6 +2500,9 @@ int change_huge_pmd(struct mmu_gather *t
 			newpmd = swp_entry_to_pmd(entry);
 			if (pmd_swp_soft_dirty(*pmd))
 				newpmd = pmd_swp_mksoft_dirty(newpmd);
+		} else if (is_writable_device_private_entry(entry)) {
+			entry = make_readable_device_private_entry(swp_offset(entry));
+			newpmd = swp_entry_to_pmd(entry);
 		} else {
 			newpmd = *pmd;
 		}
--- a/mm/pgtable-generic.c~mm-huge_memory-add-device-private-thp-support-to-pmd-operations
+++ a/mm/pgtable-generic.c
@@ -290,7 +290,7 @@ pte_t *___pte_offset_map(pmd_t *pmd, uns
 
 	if (pmdvalp)
 		*pmdvalp = pmdval;
-	if (unlikely(pmd_none(pmdval) || is_pmd_migration_entry(pmdval)))
+	if (unlikely(pmd_none(pmdval) || !pmd_present(pmdval)))
 		goto nomap;
 	if (unlikely(pmd_trans_huge(pmdval)))
 		goto nomap;
_

Patches currently in -mm which might be from balbirs@nvidia.com are

mm-zone_device-support-large-zone-device-private-folios.patch
mm-zone_device-rename-page_free-callback-to-folio_free.patch
mm-huge_memory-add-device-private-thp-support-to-pmd-operations.patch
mm-rmap-extend-rmap-and-migration-support-device-private-entries.patch
mm-huge_memory-implement-device-private-thp-splitting.patch
mm-migrate_device-handle-partially-mapped-folios-during-collection.patch
mm-migrate_device-implement-thp-migration-of-zone-device-pages.patch
mm-memory-fault-add-thp-fault-handling-for-zone-device-private-pages.patch
lib-test_hmm-add-zone-device-private-thp-test-infrastructure.patch
mm-memremap-add-driver-callback-support-for-folio-splitting.patch
mm-migrate_device-add-thp-splitting-during-migration.patch
lib-test_hmm-add-large-page-allocation-failure-testing.patch
selftests-mm-hmm-tests-new-tests-for-zone-device-thp-migration.patch
selftests-mm-hmm-tests-new-throughput-tests-including-thp.patch
gpu-drm-nouveau-enable-thp-support-for-gpu-memory-migration.patch

