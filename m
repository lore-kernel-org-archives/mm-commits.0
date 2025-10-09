Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2805C22E3F0
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 03:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759979908; cv=none; b=akY4S8HJT+vzfNgeYGhvf95Akszyr5k0XoWbqqr0s2eowG8St4cTqZZUmR18MdjhBJt09IwpAEaxA/+ZYm4siE1qxGwzZaDTBmWu6tUmxeFq6pakadODgE/XyjC3LgescBDCa831PBqm7Fvpcrj6RvExFSRa506tCARz46Q9HSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759979908; c=relaxed/simple;
	bh=3b1vjJytkdq3nGXf0OsIzn94+9GCZV5g9EE2GJcCqyI=;
	h=Date:To:From:Subject:Message-Id; b=TKI77zodJ+LUh1m3EzHVBCVyciIISGKzKzVG3ShrDgH4w+rL/M0GpqZEoyEfrR+P28pM1iMEL9ry6TLGLPPVSuMJ0e6je3Sr2sS6uqIWq56gHVBQQABare5ZIY9/pZREij+VMUs6eiQ0sSBUEXChwpbrw9kGxl4G6ZWXTg+Se9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sioI6WIg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sioI6WIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1ECC4CEE7;
	Thu,  9 Oct 2025 03:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759979907;
	bh=3b1vjJytkdq3nGXf0OsIzn94+9GCZV5g9EE2GJcCqyI=;
	h=Date:To:From:Subject:From;
	b=sioI6WIgOGaLvKD6cvjtlld4FIOTuTTPNs34y9Ce8WI603pQ39hZIHZJfur79cauM
	 t1GemC8CJmtlYIrJnWBdzLuYGSrdxQYGs7qk7Z6OTiFqiPgzJw+1vewB2w8aTYSfbx
	 9YEyQtCKOKY0wICX7fQyJ9NoAZVPu5SE4zZptx7I=
Date: Wed, 08 Oct 2025 20:18:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,sj@kernel.org,simona@ffwll.ch,ryan.roberts@arm.com,rcampbell@nvidia.com,rakie.kim@sk.com,osalvador@suse.de,npache@redhat.com,mpenttil@redhat.com,matthew.brost@intel.com,lyude@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joshua.hahnjy@gmail.com,gourry@gourry.net,francois.dugast@intel.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,airlied@gmail.com,balbirs@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-extend-rmap-and-migration-support-device-private-entries.patch added to mm-new branch
Message-Id: <20251009031827.7F1ECC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: extend rmap and migration support device-private entries
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-extend-rmap-and-migration-support-device-private-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-extend-rmap-and-migration-support-device-private-entries.patch

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
Subject: mm/rmap: extend rmap and migration support device-private entries
Date: Wed, 1 Oct 2025 16:56:55 +1000

Add device-private THP support to reverse mapping infrastructure, enabling
proper handling during migration and walk operations.

The key changes are:
- add_migration_pmd()/remove_migration_pmd(): Handle device-private
  entries during folio migration and splitting
- page_vma_mapped_walk(): Recognize device-private THP entries during
  VMA traversal operations

This change supports folio splitting and migration operations on
device-private entries.

Link: https://lkml.kernel.org/r/20251001065707.920170-5-balbirs@nvidia.com
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
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
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |   20 +++++++++++++++++---
 mm/huge_memory.c      |   16 +++++++++++++++-
 mm/page_idle.c        |    7 +++++--
 mm/page_vma_mapped.c  |    7 +++++++
 mm/rmap.c             |   24 ++++++++++++++++++++----
 5 files changed, 64 insertions(+), 10 deletions(-)

--- a/mm/damon/ops-common.c~mm-rmap-extend-rmap-and-migration-support-device-private-entries
+++ a/mm/damon/ops-common.c
@@ -75,12 +75,24 @@ void damon_ptep_mkold(pte_t *pte, struct
 void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	struct folio *folio = damon_get_folio(pmd_pfn(pmdp_get(pmd)));
+	pmd_t pmdval = pmdp_get(pmd);
+	struct folio *folio;
+	bool young = false;
+	unsigned long pfn;
+
+	if (likely(pmd_present(pmdval)))
+		pfn = pmd_pfn(pmdval);
+	else
+		pfn = swp_offset_pfn(pmd_to_swp_entry(pmdval));
 
+	folio = damon_get_folio(pfn);
 	if (!folio)
 		return;
 
-	if (pmdp_clear_young_notify(vma, addr, pmd))
+	if (likely(pmd_present(pmdval)))
+		young |= pmdp_clear_young_notify(vma, addr, pmd);
+	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + HPAGE_PMD_SIZE);
+	if (young)
 		folio_set_young(folio);
 
 	folio_set_idle(folio);
@@ -203,7 +215,9 @@ static bool damon_folio_young_one(struct
 				mmu_notifier_test_young(vma->vm_mm, addr);
 		} else {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-			*accessed = pmd_young(pmdp_get(pvmw.pmd)) ||
+			pmd_t pmd = pmdp_get(pvmw.pmd);
+
+			*accessed = (pmd_present(pmd) && pmd_young(pmd)) ||
 				!folio_test_idle(folio) ||
 				mmu_notifier_test_young(vma->vm_mm, addr);
 #else
--- a/mm/huge_memory.c~mm-rmap-extend-rmap-and-migration-support-device-private-entries
+++ a/mm/huge_memory.c
@@ -4724,7 +4724,10 @@ int set_pmd_migration_entry(struct page_
 		return 0;
 
 	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
-	pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
+	if (unlikely(!pmd_present(*pvmw->pmd)))
+		pmdval = pmdp_huge_get_and_clear(vma->vm_mm, address, pvmw->pmd);
+	else
+		pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
 
 	/* See folio_try_share_anon_rmap_pmd(): invalidate PMD first. */
 	anon_exclusive = folio_test_anon(folio) && PageAnonExclusive(page);
@@ -4774,6 +4777,17 @@ void remove_migration_pmd(struct page_vm
 	entry = pmd_to_swp_entry(*pvmw->pmd);
 	folio_get(folio);
 	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
+
+	if (folio_is_device_private(folio)) {
+		if (pmd_write(pmde))
+			entry = make_writable_device_private_entry(
+							page_to_pfn(new));
+		else
+			entry = make_readable_device_private_entry(
+							page_to_pfn(new));
+		pmde = swp_entry_to_pmd(entry);
+	}
+
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
 	if (is_writable_migration_entry(entry))
--- a/mm/page_idle.c~mm-rmap-extend-rmap-and-migration-support-device-private-entries
+++ a/mm/page_idle.c
@@ -71,8 +71,11 @@ static bool page_idle_clear_pte_refs_one
 				referenced |= ptep_test_and_clear_young(vma, addr, pvmw.pte);
 			referenced |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
-			if (pmdp_clear_young_notify(vma, addr, pvmw.pmd))
-				referenced = true;
+			pmd_t pmdval = pmdp_get(pvmw.pmd);
+
+			if (likely(pmd_present(pmdval)))
+				referenced |= pmdp_clear_young_notify(vma, addr, pvmw.pmd);
+			referenced |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PMD_SIZE);
 		} else {
 			/* unexpected pmd-mapped page? */
 			WARN_ON_ONCE(1);
--- a/mm/page_vma_mapped.c~mm-rmap-extend-rmap-and-migration-support-device-private-entries
+++ a/mm/page_vma_mapped.c
@@ -277,6 +277,13 @@ restart:
 			 * cannot return prematurely, while zap_huge_pmd() has
 			 * cleared *pmd but not decremented compound_mapcount().
 			 */
+			swp_entry_t entry = pmd_to_swp_entry(pmde);
+
+			if (is_device_private_entry(entry)) {
+				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
+				return true;
+			}
+
 			if ((pvmw->flags & PVMW_SYNC) &&
 			    thp_vma_suitable_order(vma, pvmw->address,
 						   PMD_ORDER) &&
--- a/mm/rmap.c~mm-rmap-extend-rmap-and-migration-support-device-private-entries
+++ a/mm/rmap.c
@@ -1046,9 +1046,16 @@ static int page_vma_mkclean_one(struct p
 		} else {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			pmd_t *pmd = pvmw->pmd;
-			pmd_t entry;
+			pmd_t entry = pmdp_get(pmd);
 
-			if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
+			/*
+			 * Please see the comment above (!pte_present).
+			 * A non present PMD is not writable from a CPU
+			 * perspective.
+			 */
+			if (!pmd_present(entry))
+				continue;
+			if (!pmd_dirty(entry) && !pmd_write(entry))
 				continue;
 
 			flush_cache_range(vma, address,
@@ -2343,6 +2350,9 @@ static bool try_to_migrate_one(struct fo
 	while (page_vma_mapped_walk(&pvmw)) {
 		/* PMD-mapped THP migration entry */
 		if (!pvmw.pte) {
+			__maybe_unused unsigned long pfn;
+			__maybe_unused pmd_t pmdval;
+
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				split_huge_pmd_locked(vma, pvmw.address,
 						      pvmw.pmd, true);
@@ -2351,8 +2361,14 @@ static bool try_to_migrate_one(struct fo
 				break;
 			}
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
-			subpage = folio_page(folio,
-				pmd_pfn(*pvmw.pmd) - folio_pfn(folio));
+			pmdval = pmdp_get(pvmw.pmd);
+			if (likely(pmd_present(pmdval)))
+				pfn = pmd_pfn(pmdval);
+			else
+				pfn = swp_offset_pfn(pmd_to_swp_entry(pmdval));
+
+			subpage = folio_page(folio, pfn - folio_pfn(folio));
+
 			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
 					!folio_test_pmd_mappable(folio), folio);
 
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

