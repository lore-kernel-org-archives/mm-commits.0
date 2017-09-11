From: akpm@linux-foundation.org
Subject: [merged]
 mm-migrate-support-un-addressable-zone_device-page-in-migration-v3.patch
 removed from -mm tree
Date: Mon, 11 Sep 2017 12:39:28 -0700
Message-ID: <20170911193928.sBcmAg_y7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49076 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdIKTja (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:39:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, bsingharora@gmail.com, dan.j.williams@intel.com, dnellans@nvidia.com, ebaskakov@nvidia.com, hannes@cmpxchg.org, jglisse@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, liubo95@huawei.com, mhairgrove@nvidia.com, mhocko@kernel.org, mm-commits@vger.kernel.org, paulmck@linux.vnet.ibm.com, ross.zwisler@linux.intel.com, SCheung@nvidia.com, sgutti@nvidia.com, vdavydov.dev@gmail.com


The patch titled
     Subject: mm/migrate: support un-addressable ZONE_DEVICE page in migration
has been removed from the -mm tree.  Its filename was
     mm-migrate-support-un-addressable-zone_device-page-in-migration-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/migrate: support un-addressable ZONE_DEVICE page in migration

Allow to unmap and restore special swap entry of un-addressable
ZONE_DEVICE memory.

Link: http://lkml.kernel.org/r/20170817000548.32038-17-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Nellans <dnellans@nvidia.com>
Cc: Evgeny Baskakov <ebaskakov@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mark Hairgrove <mhairgrove@nvidia.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Sherry Cheung <SCheung@nvidia.com>
Cc: Subhash Gutti <sgutti@nvidia.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Bob Liu <liubo95@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |   10 ++
 mm/migrate.c            |  149 ++++++++++++++++++++++++++++++--------
 mm/page_vma_mapped.c    |   10 ++
 mm/rmap.c               |   26 ++++++
 4 files changed, 165 insertions(+), 30 deletions(-)

diff -puN include/linux/migrate.h~mm-migrate-support-un-addressable-zone_device-page-in-migration-v3 include/linux/migrate.h
--- a/include/linux/migrate.h~mm-migrate-support-un-addressable-zone_device-page-in-migration-v3
+++ a/include/linux/migrate.h
@@ -159,12 +159,18 @@ static inline int migrate_misplaced_tran
 
 #ifdef CONFIG_MIGRATION
 
+/*
+ * Watch out for PAE architecture, which has an unsigned long, and might not
+ * have enough bits to store all physical address and flags. So far we have
+ * enough room for all our flags.
+ */
 #define MIGRATE_PFN_VALID	(1UL << 0)
 #define MIGRATE_PFN_MIGRATE	(1UL << 1)
 #define MIGRATE_PFN_LOCKED	(1UL << 2)
 #define MIGRATE_PFN_WRITE	(1UL << 3)
-#define MIGRATE_PFN_ERROR	(1UL << 4)
-#define MIGRATE_PFN_SHIFT	5
+#define MIGRATE_PFN_DEVICE	(1UL << 4)
+#define MIGRATE_PFN_ERROR	(1UL << 5)
+#define MIGRATE_PFN_SHIFT	6
 
 static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
 {
diff -puN mm/migrate.c~mm-migrate-support-un-addressable-zone_device-page-in-migration-v3 mm/migrate.c
--- a/mm/migrate.c~mm-migrate-support-un-addressable-zone_device-page-in-migration-v3
+++ a/mm/migrate.c
@@ -36,6 +36,7 @@
 #include <linux/hugetlb.h>
 #include <linux/hugetlb_cgroup.h>
 #include <linux/gfp.h>
+#include <linux/memremap.h>
 #include <linux/balloon_compaction.h>
 #include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
@@ -237,7 +238,13 @@ static bool remove_migration_pte(struct
 		if (is_write_migration_entry(entry))
 			pte = maybe_mkwrite(pte, vma);
 
-		flush_dcache_page(new);
+		if (unlikely(is_zone_device_page(new)) &&
+		    is_device_private_page(new)) {
+			entry = make_device_private_entry(new, pte_write(pte));
+			pte = swp_entry_to_pte(entry);
+		} else
+			flush_dcache_page(new);
+
 #ifdef CONFIG_HUGETLB_PAGE
 		if (PageHuge(new)) {
 			pte = pte_mkhuge(pte);
@@ -2205,17 +2212,40 @@ again:
 		pte = *ptep;
 		pfn = pte_pfn(pte);
 
-		if (!pte_present(pte)) {
+		if (pte_none(pte)) {
 			mpfn = pfn = 0;
 			goto next;
 		}
 
+		if (!pte_present(pte)) {
+			mpfn = pfn = 0;
+
+			/*
+			 * Only care about unaddressable device page special
+			 * page table entry. Other special swap entries are not
+			 * migratable, and we ignore regular swapped page.
+			 */
+			entry = pte_to_swp_entry(pte);
+			if (!is_device_private_entry(entry))
+				goto next;
+
+			page = device_private_entry_to_page(entry);
+			mpfn = migrate_pfn(page_to_pfn(page))|
+				MIGRATE_PFN_DEVICE | MIGRATE_PFN_MIGRATE;
+			if (is_write_device_private_entry(entry))
+				mpfn |= MIGRATE_PFN_WRITE;
+		} else {
+			page = vm_normal_page(migrate->vma, addr, pte);
+			mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
+			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
+		}
+
 		/* FIXME support THP */
-		page = vm_normal_page(migrate->vma, addr, pte);
 		if (!page || !page->mapping || PageTransCompound(page)) {
 			mpfn = pfn = 0;
 			goto next;
 		}
+		pfn = page_to_pfn(page);
 
 		/*
 		 * By getting a reference on the page we pin it and that blocks
@@ -2228,8 +2258,6 @@ again:
 		 */
 		get_page(page);
 		migrate->cpages++;
-		mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
-		mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
 
 		/*
 		 * Optimize for the common case where page is only mapped once
@@ -2256,10 +2284,13 @@ again:
 			 */
 			page_remove_rmap(page, false);
 			put_page(page);
-			unmapped++;
+
+			if (pte_present(pte))
+				unmapped++;
 		}
 
 next:
+		migrate->dst[migrate->npages] = 0;
 		migrate->src[migrate->npages++] = mpfn;
 	}
 	arch_leave_lazy_mmu_mode();
@@ -2329,6 +2360,28 @@ static bool migrate_vma_check_page(struc
 	if (PageCompound(page))
 		return false;
 
+	/* Page from ZONE_DEVICE have one extra reference */
+	if (is_zone_device_page(page)) {
+		/*
+		 * Private page can never be pin as they have no valid pte and
+		 * GUP will fail for those. Yet if there is a pending migration
+		 * a thread might try to wait on the pte migration entry and
+		 * will bump the page reference count. Sadly there is no way to
+		 * differentiate a regular pin from migration wait. Hence to
+		 * avoid 2 racing thread trying to migrate back to CPU to enter
+		 * infinite loop (one stoping migration because the other is
+		 * waiting on pte migration entry). We always return true here.
+		 *
+		 * FIXME proper solution is to rework migration_entry_wait() so
+		 * it does not need to take a reference on page.
+		 */
+		if (is_device_private_page(page))
+			return true;
+
+		/* Other ZONE_DEVICE memory type are not supported */
+		return false;
+	}
+
 	if ((page_count(page) - extra) > page_mapcount(page))
 		return false;
 
@@ -2379,24 +2432,30 @@ static void migrate_vma_prepare(struct m
 			migrate->src[i] |= MIGRATE_PFN_LOCKED;
 		}
 
-		if (!PageLRU(page) && allow_drain) {
-			/* Drain CPU's pagevec */
-			lru_add_drain_all();
-			allow_drain = false;
-		}
+		/* ZONE_DEVICE pages are not on LRU */
+		if (!is_zone_device_page(page)) {
+			if (!PageLRU(page) && allow_drain) {
+				/* Drain CPU's pagevec */
+				lru_add_drain_all();
+				allow_drain = false;
+			}
 
-		if (isolate_lru_page(page)) {
-			if (remap) {
-				migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
-				migrate->cpages--;
-				restore++;
-			} else {
-				migrate->src[i] = 0;
-				unlock_page(page);
-				migrate->cpages--;
-				put_page(page);
+			if (isolate_lru_page(page)) {
+				if (remap) {
+					migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
+					migrate->cpages--;
+					restore++;
+				} else {
+					migrate->src[i] = 0;
+					unlock_page(page);
+					migrate->cpages--;
+					put_page(page);
+				}
+				continue;
 			}
-			continue;
+
+			/* Drop the reference we took in collect */
+			put_page(page);
 		}
 
 		if (!migrate_vma_check_page(page)) {
@@ -2405,14 +2464,19 @@ static void migrate_vma_prepare(struct m
 				migrate->cpages--;
 				restore++;
 
-				get_page(page);
-				putback_lru_page(page);
+				if (!is_zone_device_page(page)) {
+					get_page(page);
+					putback_lru_page(page);
+				}
 			} else {
 				migrate->src[i] = 0;
 				unlock_page(page);
 				migrate->cpages--;
 
-				putback_lru_page(page);
+				if (!is_zone_device_page(page))
+					putback_lru_page(page);
+				else
+					put_page(page);
 			}
 		}
 	}
@@ -2483,7 +2547,10 @@ restore:
 		unlock_page(page);
 		restore--;
 
-		putback_lru_page(page);
+		if (is_zone_device_page(page))
+			put_page(page);
+		else
+			putback_lru_page(page);
 	}
 }
 
@@ -2514,6 +2581,26 @@ static void migrate_vma_pages(struct mig
 
 		mapping = page_mapping(page);
 
+		if (is_zone_device_page(newpage)) {
+			if (is_device_private_page(newpage)) {
+				/*
+				 * For now only support private anonymous when
+				 * migrating to un-addressable device memory.
+				 */
+				if (mapping) {
+					migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
+					continue;
+				}
+			} else {
+				/*
+				 * Other types of ZONE_DEVICE page are not
+				 * supported.
+				 */
+				migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
+				continue;
+			}
+		}
+
 		r = migrate_page(mapping, newpage, page, MIGRATE_SYNC_NO_COPY);
 		if (r != MIGRATEPAGE_SUCCESS)
 			migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
@@ -2554,11 +2641,17 @@ static void migrate_vma_finalize(struct
 		unlock_page(page);
 		migrate->cpages--;
 
-		putback_lru_page(page);
+		if (is_zone_device_page(page))
+			put_page(page);
+		else
+			putback_lru_page(page);
 
 		if (newpage != page) {
 			unlock_page(newpage);
-			putback_lru_page(newpage);
+			if (is_zone_device_page(newpage))
+				put_page(newpage);
+			else
+				putback_lru_page(newpage);
 		}
 	}
 }
diff -puN mm/page_vma_mapped.c~mm-migrate-support-un-addressable-zone_device-page-in-migration-v3 mm/page_vma_mapped.c
--- a/mm/page_vma_mapped.c~mm-migrate-support-un-addressable-zone_device-page-in-migration-v3
+++ a/mm/page_vma_mapped.c
@@ -48,6 +48,7 @@ static bool check_pte(struct page_vma_ma
 		if (!is_swap_pte(*pvmw->pte))
 			return false;
 		entry = pte_to_swp_entry(*pvmw->pte);
+
 		if (!is_migration_entry(entry))
 			return false;
 		if (migration_entry_to_page(entry) - pvmw->page >=
@@ -60,6 +61,15 @@ static bool check_pte(struct page_vma_ma
 		WARN_ON_ONCE(1);
 #endif
 	} else {
+		if (is_swap_pte(*pvmw->pte)) {
+			swp_entry_t entry;
+
+			entry = pte_to_swp_entry(*pvmw->pte);
+			if (is_device_private_entry(entry) &&
+			    device_private_entry_to_page(entry) == pvmw->page)
+				return true;
+		}
+
 		if (!pte_present(*pvmw->pte))
 			return false;
 
diff -puN mm/rmap.c~mm-migrate-support-un-addressable-zone_device-page-in-migration-v3 mm/rmap.c
--- a/mm/rmap.c~mm-migrate-support-un-addressable-zone_device-page-in-migration-v3
+++ a/mm/rmap.c
@@ -63,6 +63,7 @@
 #include <linux/hugetlb.h>
 #include <linux/backing-dev.h>
 #include <linux/page_idle.h>
+#include <linux/memremap.h>
 
 #include <asm/tlbflush.h>
 
@@ -1346,6 +1347,10 @@ static bool try_to_unmap_one(struct page
 	if ((flags & TTU_MUNLOCK) && !(vma->vm_flags & VM_LOCKED))
 		return true;
 
+	if (IS_ENABLED(CONFIG_MIGRATION) && (flags & TTU_MIGRATION) &&
+	    is_zone_device_page(page) && !is_device_private_page(page))
+		return true;
+
 	if (flags & TTU_SPLIT_HUGE_PMD) {
 		split_huge_pmd_address(vma, address,
 				flags & TTU_SPLIT_FREEZE, page);
@@ -1403,6 +1408,27 @@ static bool try_to_unmap_one(struct page
 		address = pvmw.address;
 
 
+		if (IS_ENABLED(CONFIG_MIGRATION) &&
+		    (flags & TTU_MIGRATION) &&
+		    is_zone_device_page(page)) {
+			swp_entry_t entry;
+			pte_t swp_pte;
+
+			pteval = ptep_get_and_clear(mm, pvmw.address, pvmw.pte);
+
+			/*
+			 * Store the pfn of the page in a special migration
+			 * pte. do_swap_page() will wait until the migration
+			 * pte is removed and then restart fault handling.
+			 */
+			entry = make_migration_entry(page, 0);
+			swp_pte = swp_entry_to_pte(entry);
+			if (pte_soft_dirty(pteval))
+				swp_pte = pte_swp_mksoft_dirty(swp_pte);
+			set_pte_at(mm, pvmw.address, pvmw.pte, swp_pte);
+			goto discard;
+		}
+
 		if (!(flags & TTU_IGNORE_ACCESS)) {
 			if (ptep_clear_flush_young_notify(vma, address,
 						pvmw.pte)) {
_

Patches currently in -mm which might be from jglisse@redhat.com are


