From: akpm@linux-foundation.org
Subject: +
 mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
 added to -mm tree
Date: Thu, 17 Aug 2017 14:42:19 -0700
Message-ID: <59960dbb.iNmWJxL7wbrX2rly%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40696 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753736AbdHQVmV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Aug 2017 17:42:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, SCheung@nvidia.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, bsingharora@gmail.com, dan.j.williams@intel.com, dnellans@nvidia.com, ebaskakov@nvidia.com, hannes@cmpxchg.org, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mhairgrove@nvidia.com, mhocko@kernel.org, paulmck@linux.vnet.ibm.com, ross.zwisler@linux.intel.com, sgutti@nvidia.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: migrate_vma() unmap page from vma while collecting pages
has been added to the -mm tree.  Its filename is
     mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/migrate: migrate_vma() unmap page from vma while collecting pages

Common case for migration of virtual address range is page are map only
once inside the vma in which migration is taking place.  Because we
already walk the CPU page table for that range we can directly do the
unmap there and setup special migration swap entry.

Link: http://lkml.kernel.org/r/20170817000548.32038-16-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Evgeny Baskakov <ebaskakov@nvidia.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Mark Hairgrove <mhairgrove@nvidia.com>
Signed-off-by: Sherry Cheung <SCheung@nvidia.com>
Signed-off-by: Subhash Gutti <sgutti@nvidia.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Nellans <dnellans@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |  141 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 112 insertions(+), 29 deletions(-)

diff -puN mm/migrate.c~mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages mm/migrate.c
--- a/mm/migrate.c~mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages
+++ a/mm/migrate.c
@@ -2154,7 +2154,7 @@ static int migrate_vma_collect_pmd(pmd_t
 	struct migrate_vma *migrate = walk->private;
 	struct vm_area_struct *vma = walk->vma;
 	struct mm_struct *mm = vma->vm_mm;
-	unsigned long addr = start;
+	unsigned long addr = start, unmapped = 0;
 	spinlock_t *ptl;
 	pte_t *ptep;
 
@@ -2199,9 +2199,12 @@ again:
 		return migrate_vma_collect_hole(start, end, walk);
 
 	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	arch_enter_lazy_mmu_mode();
+
 	for (; addr < end; addr += PAGE_SIZE, ptep++) {
 		unsigned long mpfn, pfn;
 		struct page *page;
+		swp_entry_t entry;
 		pte_t pte;
 
 		pte = *ptep;
@@ -2233,11 +2236,44 @@ again:
 		mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
 		mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
 
+		/*
+		 * Optimize for the common case where page is only mapped once
+		 * in one process. If we can lock the page, then we can safely
+		 * set up a special migration page table entry now.
+		 */
+		if (trylock_page(page)) {
+			pte_t swp_pte;
+
+			mpfn |= MIGRATE_PFN_LOCKED;
+			ptep_get_and_clear(mm, addr, ptep);
+
+			/* Setup special migration page table entry */
+			entry = make_migration_entry(page, pte_write(pte));
+			swp_pte = swp_entry_to_pte(entry);
+			if (pte_soft_dirty(pte))
+				swp_pte = pte_swp_mksoft_dirty(swp_pte);
+			set_pte_at(mm, addr, ptep, swp_pte);
+
+			/*
+			 * This is like regular unmap: we remove the rmap and
+			 * drop page refcount. Page won't be freed, as we took
+			 * a reference just above.
+			 */
+			page_remove_rmap(page, false);
+			put_page(page);
+			unmapped++;
+		}
+
 next:
 		migrate->src[migrate->npages++] = mpfn;
 	}
+	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(ptep - 1, ptl);
 
+	/* Only flush the TLB if we actually modified any entries */
+	if (unmapped)
+		flush_tlb_range(walk->vma, start, end);
+
 	return 0;
 }
 
@@ -2262,7 +2298,13 @@ static void migrate_vma_collect(struct m
 	mm_walk.mm = migrate->vma->vm_mm;
 	mm_walk.private = migrate;
 
+	mmu_notifier_invalidate_range_start(mm_walk.mm,
+					    migrate->start,
+					    migrate->end);
 	walk_page_range(migrate->start, migrate->end, &mm_walk);
+	mmu_notifier_invalidate_range_end(mm_walk.mm,
+					  migrate->start,
+					  migrate->end);
 
 	migrate->end = migrate->start + (migrate->npages << PAGE_SHIFT);
 }
@@ -2310,32 +2352,37 @@ static bool migrate_vma_check_page(struc
 static void migrate_vma_prepare(struct migrate_vma *migrate)
 {
 	const unsigned long npages = migrate->npages;
+	const unsigned long start = migrate->start;
+	unsigned long addr, i, restore = 0;
 	bool allow_drain = true;
-	unsigned long i;
 
 	lru_add_drain();
 
 	for (i = 0; (i < npages) && migrate->cpages; i++) {
 		struct page *page = migrate_pfn_to_page(migrate->src[i]);
+		bool remap = true;
 
 		if (!page)
 			continue;
 
-		/*
-		 * Because we are migrating several pages there can be
-		 * a deadlock between 2 concurrent migration where each
-		 * are waiting on each other page lock.
-		 *
-		 * Make migrate_vma() a best effort thing and backoff
-		 * for any page we can not lock right away.
-		 */
-		if (!trylock_page(page)) {
-			migrate->src[i] = 0;
-			migrate->cpages--;
-			put_page(page);
-			continue;
+		if (!(migrate->src[i] & MIGRATE_PFN_LOCKED)) {
+			/*
+			 * Because we are migrating several pages there can be
+			 * a deadlock between 2 concurrent migration where each
+			 * are waiting on each other page lock.
+			 *
+			 * Make migrate_vma() a best effort thing and backoff
+			 * for any page we can not lock right away.
+			 */
+			if (!trylock_page(page)) {
+				migrate->src[i] = 0;
+				migrate->cpages--;
+				put_page(page);
+				continue;
+			}
+			remap = false;
+			migrate->src[i] |= MIGRATE_PFN_LOCKED;
 		}
-		migrate->src[i] |= MIGRATE_PFN_LOCKED;
 
 		if (!PageLRU(page) && allow_drain) {
 			/* Drain CPU's pagevec */
@@ -2344,21 +2391,50 @@ static void migrate_vma_prepare(struct m
 		}
 
 		if (isolate_lru_page(page)) {
-			migrate->src[i] = 0;
-			unlock_page(page);
-			migrate->cpages--;
-			put_page(page);
+			if (remap) {
+				migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
+				migrate->cpages--;
+				restore++;
+			} else {
+				migrate->src[i] = 0;
+				unlock_page(page);
+				migrate->cpages--;
+				put_page(page);
+			}
 			continue;
 		}
 
 		if (!migrate_vma_check_page(page)) {
-			migrate->src[i] = 0;
-			unlock_page(page);
-			migrate->cpages--;
+			if (remap) {
+				migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
+				migrate->cpages--;
+				restore++;
+
+				get_page(page);
+				putback_lru_page(page);
+			} else {
+				migrate->src[i] = 0;
+				unlock_page(page);
+				migrate->cpages--;
 
-			putback_lru_page(page);
+				putback_lru_page(page);
+			}
 		}
 	}
+
+	for (i = 0, addr = start; i < npages && restore; i++, addr += PAGE_SIZE) {
+		struct page *page = migrate_pfn_to_page(migrate->src[i]);
+
+		if (!page || (migrate->src[i] & MIGRATE_PFN_MIGRATE))
+			continue;
+
+		remove_migration_pte(page, migrate->vma, addr, page);
+
+		migrate->src[i] = 0;
+		unlock_page(page);
+		put_page(page);
+		restore--;
+	}
 }
 
 /*
@@ -2385,12 +2461,19 @@ static void migrate_vma_unmap(struct mig
 		if (!page || !(migrate->src[i] & MIGRATE_PFN_MIGRATE))
 			continue;
 
-		try_to_unmap(page, flags);
-		if (page_mapped(page) || !migrate_vma_check_page(page)) {
-			migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
-			migrate->cpages--;
-			restore++;
+		if (page_mapped(page)) {
+			try_to_unmap(page, flags);
+			if (page_mapped(page))
+				goto restore;
 		}
+
+		if (migrate_vma_check_page(page))
+			continue;
+
+restore:
+		migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
+		migrate->cpages--;
+		restore++;
 	}
 
 	for (addr = start, i = 0; i < npages && restore; addr += PAGE_SIZE, i++) {
_

Patches currently in -mm which might be from jglisse@redhat.com are

hmm-heterogeneous-memory-management-documentation-v3.patch
mm-hmm-heterogeneous-memory-management-hmm-for-short-v5.patch
mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers-v3.patch
mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v4.patch
mm-hmm-mirror-device-page-fault-handler.patch
mm-zone_device-new-type-of-zone_device-for-unaddressable-memory-v5.patch
mm-zone_device-special-case-put_page-for-device-private-pages-v4.patch
mm-memcontrol-allow-to-uncharge-page-without-using-page-lru-field.patch
mm-memcontrol-support-memory_device_private-v4.patch
mm-hmm-devmem-device-memory-hotplug-using-zone_device-v7.patch
mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v3.patch
mm-migrate-new-migrate-mode-migrate_sync_no_copy.patch
mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v5.patch
mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
mm-migrate-support-un-addressable-zone_device-page-in-migration-v3.patch
mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-v4.patch
mm-device-public-memory-device-memory-cache-coherent-with-cpu-v5.patch
mm-hmm-add-new-helper-to-hotplug-cdm-memory-region-v3.patch
lib-interval_tree-fast-overlap-detection-fix.patch

