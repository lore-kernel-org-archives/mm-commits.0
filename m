Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61ACD22B5A3
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 03:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759979912; cv=none; b=Ho7/G+yLwzKV+WwFK+8/tCR41f0kHogeC2Kn0IbQRzILC5DiBNtp/vSQQpjnDzMP4Kfk3qJg2cRiZEgVrZL4PA8+SJELgsevhfcJUQmgTt2OJLYse7xpPBqEiZCcxHv+QcvIwlERcyomLiqJj0B/XgHN9Khn03H3+K5m+nUaN8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759979912; c=relaxed/simple;
	bh=rDneEVdd7Ca8oPnAj10XLcS1an0+3/hiIpRpqdPgW7E=;
	h=Date:To:From:Subject:Message-Id; b=RkGWHmWjoku0tpysxd0KYNTB6asB/z9DlODAs/Z41N7F2E5zOaT1wYDO7EQAAEelW7xw9VsWVzoUu2jvNoUerZPxto69kk5+qj4hUXVQSmoLO9KUhs0QlBwZYV4ZzMiQO4JOnXighJSj4T7j8Pj3vC8LLBpPbLozfvGEvM4g9zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eCt4buGH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eCt4buGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B602BC4CEE7;
	Thu,  9 Oct 2025 03:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759979911;
	bh=rDneEVdd7Ca8oPnAj10XLcS1an0+3/hiIpRpqdPgW7E=;
	h=Date:To:From:Subject:From;
	b=eCt4buGHEIk/ztDg3fPWqlOJi63ClP4juAOjmHwHH/KmXzMpdDliKt9RtM64u6Jj3
	 xlLt74ddFXqQdiV3XmoySssh42CC3hWu/szFKHnUGjH6m3QI/yMfN7iebztgBL3FYP
	 lyoFdToh+EgfuWyTL3LuzWUQDWZpUnWeoboL6PB0=
Date: Wed, 08 Oct 2025 20:18:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,simona@ffwll.ch,ryan.roberts@arm.com,rcampbell@nvidia.com,rakie.kim@sk.com,osalvador@suse.de,npache@redhat.com,mpenttil@redhat.com,matthew.brost@intel.com,lyude@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joshua.hahnjy@gmail.com,gourry@gourry.net,francois.dugast@intel.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,airlied@gmail.com,balbirs@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-implement-device-private-thp-splitting.patch added to mm-new branch
Message-Id: <20251009031831.B602BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: implement device-private THP splitting
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-implement-device-private-thp-splitting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-implement-device-private-thp-splitting.patch

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
Subject: mm/huge_memory: implement device-private THP splitting
Date: Wed, 1 Oct 2025 16:56:56 +1000

Add support for splitting device-private THP folios, enabling fallback
to smaller page sizes when large page allocation or migration fails.

Key changes:
- split_huge_pmd(): Handle device-private PMD entries during splitting
- Preserve RMAP_EXCLUSIVE semantics for anonymous exclusive folios
- Skip RMP_USE_SHARED_ZEROPAGE for device-private entries as they
  don't support shared zero page semantics

Link: https://lkml.kernel.org/r/20251001065707.920170-6-balbirs@nvidia.com
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
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

 mm/huge_memory.c |   87 ++++++++++++++++++++++++++++++++++++++-------
 mm/migrate.c     |    1 
 2 files changed, 76 insertions(+), 12 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-implement-device-private-thp-splitting
+++ a/mm/huge_memory.c
@@ -2957,16 +2957,18 @@ static void __split_huge_pmd_locked(stru
 	struct page *page;
 	pgtable_t pgtable;
 	pmd_t old_pmd, _pmd;
-	bool young, write, soft_dirty, pmd_migration = false, uffd_wp = false;
+	bool soft_dirty, uffd_wp = false, young = false, write = false;
 	bool anon_exclusive = false, dirty = false;
 	unsigned long addr;
 	pte_t *pte;
 	int i;
+	swp_entry_t entry;
 
 	VM_BUG_ON(haddr & ~HPAGE_PMD_MASK);
 	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
 	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PMD_SIZE, vma);
-	VM_BUG_ON(!is_pmd_migration_entry(*pmd) && !pmd_trans_huge(*pmd));
+
+	VM_WARN_ON(!is_pmd_non_present_folio_entry(*pmd) && !pmd_trans_huge(*pmd));
 
 	count_vm_event(THP_SPLIT_PMD);
 
@@ -3014,20 +3016,51 @@ static void __split_huge_pmd_locked(stru
 		return __split_huge_zero_page_pmd(vma, haddr, pmd);
 	}
 
-	pmd_migration = is_pmd_migration_entry(*pmd);
-	if (unlikely(pmd_migration)) {
-		swp_entry_t entry;
 
+	if (is_pmd_migration_entry(*pmd)) {
 		old_pmd = *pmd;
 		entry = pmd_to_swp_entry(old_pmd);
 		page = pfn_swap_entry_to_page(entry);
+		folio = page_folio(page);
+
+		soft_dirty = pmd_swp_soft_dirty(old_pmd);
+		uffd_wp = pmd_swp_uffd_wp(old_pmd);
+
 		write = is_writable_migration_entry(entry);
 		if (PageAnon(page))
 			anon_exclusive = is_readable_exclusive_migration_entry(entry);
 		young = is_migration_entry_young(entry);
 		dirty = is_migration_entry_dirty(entry);
+	} else if (is_pmd_device_private_entry(*pmd)) {
+		old_pmd = *pmd;
+		entry = pmd_to_swp_entry(old_pmd);
+		page = pfn_swap_entry_to_page(entry);
+		folio = page_folio(page);
+
 		soft_dirty = pmd_swp_soft_dirty(old_pmd);
 		uffd_wp = pmd_swp_uffd_wp(old_pmd);
+
+		write = is_writable_device_private_entry(entry);
+		anon_exclusive = PageAnonExclusive(page);
+
+		/*
+		 * Device private THP should be treated the same as regular
+		 * folios w.r.t anon exclusive handling. See the comments for
+		 * folio handling and anon_exclusive below.
+		 */
+		if (freeze && anon_exclusive &&
+		    folio_try_share_anon_rmap_pmd(folio, page))
+			freeze = false;
+		if (!freeze) {
+			rmap_t rmap_flags = RMAP_NONE;
+
+			folio_ref_add(folio, HPAGE_PMD_NR - 1);
+			if (anon_exclusive)
+				rmap_flags |= RMAP_EXCLUSIVE;
+
+			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
+						 vma, haddr, rmap_flags);
+		}
 	} else {
 		/*
 		 * Up to this point the pmd is present and huge and userland has
@@ -3111,11 +3144,11 @@ static void __split_huge_pmd_locked(stru
 	 * Note that NUMA hinting access restrictions are not transferred to
 	 * avoid any possibility of altering permissions across VMAs.
 	 */
-	if (freeze || pmd_migration) {
-		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
-			pte_t entry;
-			swp_entry_t swp_entry;
+	if (freeze || is_pmd_migration_entry(old_pmd)) {
+		pte_t entry;
+		swp_entry_t swp_entry;
 
+		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
 			if (write)
 				swp_entry = make_writable_migration_entry(
 							page_to_pfn(page + i));
@@ -3134,7 +3167,33 @@ static void __split_huge_pmd_locked(stru
 				entry = pte_swp_mksoft_dirty(entry);
 			if (uffd_wp)
 				entry = pte_swp_mkuffd_wp(entry);
+			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
+			set_pte_at(mm, addr, pte + i, entry);
+		}
+	} else if (is_pmd_device_private_entry(old_pmd)) {
+		pte_t entry;
+		swp_entry_t swp_entry;
 
+		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
+			/*
+			 * anon_exclusive was already propagated to the relevant
+			 * pages corresponding to the pte entries when freeze
+			 * is false.
+			 */
+			if (write)
+				swp_entry = make_writable_device_private_entry(
+							page_to_pfn(page + i));
+			else
+				swp_entry = make_readable_device_private_entry(
+							page_to_pfn(page + i));
+			/*
+			 * Young and dirty bits are not progated via swp_entry
+			 */
+			entry = swp_entry_to_pte(swp_entry);
+			if (soft_dirty)
+				entry = pte_swp_mksoft_dirty(entry);
+			if (uffd_wp)
+				entry = pte_swp_mkuffd_wp(entry);
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 			set_pte_at(mm, addr, pte + i, entry);
 		}
@@ -3161,7 +3220,7 @@ static void __split_huge_pmd_locked(stru
 	}
 	pte_unmap(pte);
 
-	if (!pmd_migration)
+	if (!is_pmd_migration_entry(*pmd))
 		folio_remove_rmap_pmd(folio, page, vma);
 	if (freeze)
 		put_page(page);
@@ -3174,7 +3233,7 @@ void split_huge_pmd_locked(struct vm_are
 			   pmd_t *pmd, bool freeze)
 {
 	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
-	if (pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd))
+	if (pmd_trans_huge(*pmd) || is_pmd_non_present_folio_entry(*pmd))
 		__split_huge_pmd_locked(vma, pmd, address, freeze);
 }
 
@@ -3353,6 +3412,9 @@ static void lru_add_split_folio(struct f
 	VM_BUG_ON_FOLIO(folio_test_lru(new_folio), folio);
 	lockdep_assert_held(&lruvec->lru_lock);
 
+	if (folio_is_device_private(folio))
+		return;
+
 	if (list) {
 		/* page reclaim is reclaiming a huge page */
 		VM_WARN_ON(folio_test_lru(folio));
@@ -3971,8 +4033,9 @@ fail:
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
-	if (!ret && is_anon)
+	if (!ret && is_anon && !folio_is_device_private(folio))
 		remap_flags = RMP_USE_SHARED_ZEROPAGE;
+
 	remap_page(folio, 1 << order, remap_flags);
 
 	/*
--- a/mm/migrate.c~mm-huge_memory-implement-device-private-thp-splitting
+++ a/mm/migrate.c
@@ -306,6 +306,7 @@ static bool try_to_map_unused_to_zeropag
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(pte_present(old_pte), page);
+	VM_WARN_ON_ONCE_FOLIO(folio_is_device_private(folio), folio);
 
 	if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags & VM_LOCKED) ||
 	    mm_forbids_zeropage(pvmw->vma->vm_mm))
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

