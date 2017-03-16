From: akpm@linux-foundation.org
Subject: +
 mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
 added to -mm tree
Date: Thu, 16 Mar 2017 13:51:53 -0700
Message-ID: <58cafae9.FfESDofRH4ld+GWH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54984 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753899AbdCPVRm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 17:17:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, SCheung@nvidia.com, ebaskakov@nvidia.com, jhubbard@nvidia.com, mhairgrove@nvidia.com, sgutti@nvidia.com, mm-commits@vger.kernel.org


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

Link: http://lkml.kernel.org/r/1489680335-6594-9-git-send-email-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Evgeny Baskakov <ebaskakov@nvidia.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Mark Hairgrove <mhairgrove@nvidia.com>
Signed-off-by: Sherry Cheung <SCheung@nvidia.com>
Signed-off-by: Subhash Gutti <sgutti@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |  111 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 95 insertions(+), 16 deletions(-)

diff -puN mm/migrate.c~mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages mm/migrate.c
--- a/mm/migrate.c~mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages
+++ a/mm/migrate.c
@@ -2123,9 +2123,10 @@ static int migrate_vma_collect_pmd(pmd_t
 {
 	struct migrate_vma *migrate = walk->private;
 	struct mm_struct *mm = walk->vma->vm_mm;
-	unsigned long addr = start;
+	unsigned long addr = start, unmapped = 0;
 	spinlock_t *ptl;
 	pte_t *ptep;
+	int ret = 0;
 
 	if (pmd_none(*pmdp) || pmd_trans_unstable(pmdp)) {
 		/* FIXME support THP */
@@ -2133,9 +2134,12 @@ static int migrate_vma_collect_pmd(pmd_t
 	}
 
 	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	arch_enter_lazy_mmu_mode();
+
 	for (; addr < end; addr += PAGE_SIZE, ptep++) {
 		unsigned long flags, pfn;
 		struct page *page;
+		swp_entry_t entry;
 		pte_t pte;
 		int ret;
 
@@ -2168,17 +2172,50 @@ static int migrate_vma_collect_pmd(pmd_t
 		flags = MIGRATE_PFN_VALID | MIGRATE_PFN_MIGRATE;
 		flags |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
 
+		/*
+		 * Optimize for the common case where page is only mapped once
+		 * in one process. If we can lock the page, then we can safely
+		 * set up a special migration page table entry now.
+		 */
+		if (trylock_page(page)) {
+			pte_t swp_pte;
+
+			flags |= MIGRATE_PFN_LOCKED;
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
 		migrate->src[migrate->npages++] = pfn | flags;
 		ret = migrate_vma_array_full(migrate);
 		if (ret) {
-			pte_unmap_unlock(ptep, ptl);
-			return ret;
+			ptep++;
+			break;
 		}
 	}
+	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(ptep - 1, ptl);
 
-	return 0;
+	/* Only flush the TLB if we actually modified any entries */
+	if (unmapped)
+		flush_tlb_range(walk->vma, start, end);
+
+	return ret;
 }
 
 /*
@@ -2202,7 +2239,13 @@ static void migrate_vma_collect(struct m
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
@@ -2249,21 +2292,27 @@ static bool migrate_vma_check_page(struc
  */
 static void migrate_vma_prepare(struct migrate_vma *migrate)
 {
-	unsigned long addr = migrate->start, i, size;
+	unsigned long addr = migrate->start, i, size, restore = 0;
 	const unsigned long npages = migrate->npages;
+	const unsigned long start = migrate->start;
 	bool allow_drain = true;
 
 	lru_add_drain();
 
-	for (i = 0; i < npages && migrate->cpages; i++, addr += size) {
+	for (addr = start, i = 0; i < npages; i++, addr += size) {
 		struct page *page = migrate_pfn_to_page(migrate->src[i]);
+		bool remap = true;
+
 		size = migrate_pfn_size(migrate->src[i]);
 
 		if (!page)
 			continue;
 
-		lock_page(page);
-		migrate->src[i] |= MIGRATE_PFN_LOCKED;
+		if (!(migrate->src[i] & MIGRATE_PFN_LOCKED)) {
+			remap = false;
+			lock_page(page);
+			migrate->src[i] |= MIGRATE_PFN_LOCKED;
+		}
 
 		if (!PageLRU(page) && allow_drain) {
 			/* Drain CPU's pagevec */
@@ -2272,10 +2321,16 @@ static void migrate_vma_prepare(struct m
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
 
@@ -2283,13 +2338,37 @@ static void migrate_vma_prepare(struct m
 		put_page(page);
 
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
+	for (i = 0, addr = start; i < npages && restore; i++, addr += size) {
+		struct page *page = migrate_pfn_to_page(migrate->src[i]);
+		size = migrate_pfn_size(migrate->src[i]);
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
_

Patches currently in -mm which might be from jglisse@redhat.com are

mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3.patch
mm-put_page-move-ref-decrement-to-put_zone_device_page.patch
mm-zone_device-free-page-callback-when-page-is-freed-v3.patch
mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3.patch
mm-zone_device-x86-add-support-for-un-addressable-device-memory.patch
mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback.patch
mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v4.patch
mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
mm-hmm-heterogeneous-memory-management-hmm-for-short.patch
mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers.patch
mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v2.patch
mm-hmm-mirror-device-page-fault-handler.patch
mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration.patch
mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry.patch
mm-hmm-devmem-device-memory-hotplug-using-zone_device.patch
mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v2.patch

