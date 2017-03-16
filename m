From: akpm@linux-foundation.org
Subject: +
 mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration.patch
 added to -mm tree
Date: Thu, 16 Mar 2017 13:52:07 -0700
Message-ID: <58cafaf7.Ut8OCKoNO5qJHRM8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54976 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753830AbdCPVRc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 17:17:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm/migrate: support un-addressable ZONE_DEVICE page in migration
has been added to the -mm tree.  Its filename is
     mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration.patch

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
Subject: mm/hmm/migrate: support un-addressable ZONE_DEVICE page in migration

Allow to unmap and restore special swap entry of un-addressable
ZONE_DEVICE memory.

Link: http://lkml.kernel.org/r/1489680335-6594-14-git-send-email-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    2 
 mm/migrate.c            |  141 +++++++++++++++++++++++++++++---------
 mm/page_vma_mapped.c    |   10 ++
 mm/rmap.c               |   25 ++++++
 4 files changed, 147 insertions(+), 31 deletions(-)

diff -puN include/linux/migrate.h~mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration include/linux/migrate.h
--- a/include/linux/migrate.h~mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration
+++ a/include/linux/migrate.h
@@ -130,6 +130,8 @@ static inline int migrate_misplaced_tran
 #define MIGRATE_PFN_HUGE	(1UL << (BITS_PER_LONG_LONG - 3))
 #define MIGRATE_PFN_LOCKED	(1UL << (BITS_PER_LONG_LONG - 4))
 #define MIGRATE_PFN_WRITE	(1UL << (BITS_PER_LONG_LONG - 5))
+#define MIGRATE_PFN_DEVICE	(1UL << (BITS_PER_LONG_LONG - 6))
+#define MIGRATE_PFN_ERROR	(1UL << (BITS_PER_LONG_LONG - 7))
 #define MIGRATE_PFN_MASK	((1UL << (BITS_PER_LONG_LONG - PAGE_SHIFT)) - 1)
 
 static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
diff -puN mm/migrate.c~mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration mm/migrate.c
--- a/mm/migrate.c~mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration
+++ a/mm/migrate.c
@@ -41,6 +41,7 @@
 #include <linux/page_idle.h>
 #include <linux/page_owner.h>
 #include <linux/sched/mm.h>
+#include <linux/memremap.h>
 
 #include <asm/tlbflush.h>
 
@@ -230,7 +231,15 @@ static bool remove_migration_pte(struct
 			pte = arch_make_huge_pte(pte, vma, new, 0);
 		}
 #endif
-		flush_dcache_page(new);
+
+		if (unlikely(is_zone_device_page(new)) &&
+		    !is_addressable_page(new)) {
+			entry = make_device_entry(new, pte_write(pte));
+			pte = swp_entry_to_pte(entry);
+			if (pte_swp_soft_dirty(*pvmw.pte))
+				pte = pte_mksoft_dirty(pte);
+		} else
+			flush_dcache_page(new);
 		set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
 
 		if (PageHuge(new)) {
@@ -302,6 +311,8 @@ void __migration_entry_wait(struct mm_st
 	 */
 	if (!get_page_unless_zero(page))
 		goto out;
+	if (is_zone_device_page(page))
+		get_zone_device_page(page);
 	pte_unmap_unlock(ptep, ptl);
 	wait_on_page_locked(page);
 	put_page(page);
@@ -2099,12 +2110,14 @@ static int migrate_vma_collect_hole(unsi
 		next = pmd_addr_end(addr, end);
 		npages = (next - addr) >> PAGE_SHIFT;
 		if (npages == (PMD_SIZE >> PAGE_SHIFT)) {
+			migrate->dst[migrate->npages] = 0;
 			migrate->src[migrate->npages++] = MIGRATE_PFN_HUGE;
 			ret = migrate_vma_array_full(migrate);
 			if (ret)
 				return ret;
 		} else {
 			for (i = 0; i < npages; ++i) {
+				migrate->dst[migrate->npages] = 0;
 				migrate->src[migrate->npages++] = 0;
 				ret = migrate_vma_array_full(migrate);
 				if (ret)
@@ -2146,17 +2159,44 @@ static int migrate_vma_collect_pmd(pmd_t
 		pte = *ptep;
 		pfn = pte_pfn(pte);
 
-		if (!pte_present(pte)) {
+		if (pte_none(pte)) {
 			flags = pfn = 0;
 			goto next;
 		}
 
+		if (!pte_present(pte)) {
+			flags = pfn = 0;
+
+			/*
+			 * Only care about unaddressable device page special
+			 * page table entry. Other special swap entry are not
+			 * migratable and we ignore regular swapped page.
+			 */
+			entry = pte_to_swp_entry(pte);
+			if (!is_device_entry(entry))
+				goto next;
+
+			page = device_entry_to_page(entry);
+			if (!dev_page_allow_migrate(page))
+				goto next;
+
+			flags = MIGRATE_PFN_VALID |
+				MIGRATE_PFN_DEVICE |
+				MIGRATE_PFN_MIGRATE;
+			if (is_write_device_entry(entry))
+				flags |= MIGRATE_PFN_WRITE;
+		} else {
+			page = vm_normal_page(migrate->vma, addr, pte);
+			flags = MIGRATE_PFN_VALID | MIGRATE_PFN_MIGRATE;
+			flags |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
+		}
+
 		/* FIXME support THP */
-		page = vm_normal_page(migrate->vma, addr, pte);
 		if (!page || !page->mapping || PageTransCompound(page)) {
 			flags = pfn = 0;
 			goto next;
 		}
+		pfn = page_to_pfn(page);
 
 		/*
 		 * By getting a reference on the page we pin it and that blocks
@@ -2169,8 +2209,6 @@ static int migrate_vma_collect_pmd(pmd_t
 		 */
 		get_page(page);
 		migrate->cpages++;
-		flags = MIGRATE_PFN_VALID | MIGRATE_PFN_MIGRATE;
-		flags |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
 
 		/*
 		 * Optimize for the common case where page is only mapped once
@@ -2201,6 +2239,7 @@ static int migrate_vma_collect_pmd(pmd_t
 		}
 
 next:
+		migrate->dst[migrate->npages] = 0;
 		migrate->src[migrate->npages++] = pfn | flags;
 		ret = migrate_vma_array_full(migrate);
 		if (ret) {
@@ -2275,6 +2314,13 @@ static bool migrate_vma_check_page(struc
 	if (PageCompound(page))
 		return false;
 
+	/* Page from ZONE_DEVICE have one extra reference */
+	if (is_zone_device_page(page)) {
+		if (!dev_page_allow_migrate(page))
+			return false;
+		extra++;
+	}
+
 	if ((page_count(page) - extra) > page_mapcount(page))
 		return false;
 
@@ -2314,28 +2360,31 @@ static void migrate_vma_prepare(struct m
 			migrate->src[i] |= MIGRATE_PFN_LOCKED;
 		}
 
-		if (!PageLRU(page) && allow_drain) {
-			/* Drain CPU's pagevec */
-			lru_add_drain_all();
-			allow_drain = false;
-		}
+		/* ZONE_DEVICE page are not on LRU */
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
-		}
 
-		/* Drop the reference we took in collect */
-		put_page(page);
+			/* Drop the reference we took in collect */
+			put_page(page);
+		}
 
 		if (!migrate_vma_check_page(page)) {
 			if (remap) {
@@ -2343,14 +2392,19 @@ static void migrate_vma_prepare(struct m
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
@@ -2389,7 +2443,7 @@ static void migrate_vma_unmap(struct mig
 	const unsigned long npages = migrate->npages;
 	const unsigned long start = migrate->start;
 
-	for (i = 0; i < npages && migrate->cpages; addr += size, i++) {
+	for (addr = start, i = 0; i < npages; addr += size, i++) {
 		struct page *page = migrate_pfn_to_page(migrate->src[i]);
 		size = migrate_pfn_size(migrate->src[i]);
 
@@ -2417,7 +2471,10 @@ static void migrate_vma_unmap(struct mig
 		unlock_page(page);
 		restore--;
 
-		putback_lru_page(page);
+		if (is_zone_device_page(page))
+			put_page(page);
+		else
+			putback_lru_page(page);
 	}
 }
 
@@ -2449,6 +2506,22 @@ static void migrate_vma_pages(struct mig
 
 		mapping = page_mapping(page);
 
+		if (is_zone_device_page(newpage)) {
+			if (!dev_page_allow_migrate(newpage)) {
+				migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
+				continue;
+			}
+
+			/*
+			 * For now only support private anonymous when migrating
+			 * to un-addressable device memory.
+			 */
+			if (mapping && !is_addressable_page(newpage)) {
+				migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
+				continue;
+			}
+		}
+
 		r = migrate_page(mapping, newpage, page, MIGRATE_SYNC, false);
 		if (r != MIGRATEPAGE_SUCCESS)
 			migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
@@ -2490,11 +2563,17 @@ static void migrate_vma_finalize(struct
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
diff -puN mm/page_vma_mapped.c~mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration mm/page_vma_mapped.c
--- a/mm/page_vma_mapped.c~mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration
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
+			if (is_device_entry(entry) &&
+			    device_entry_to_page(entry) == pvmw->page)
+				return true;
+		}
+
 		if (!pte_present(*pvmw->pte))
 			return false;
 
diff -puN mm/rmap.c~mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration mm/rmap.c
--- a/mm/rmap.c~mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration
+++ a/mm/rmap.c
@@ -63,6 +63,7 @@
 #include <linux/hugetlb.h>
 #include <linux/backing-dev.h>
 #include <linux/page_idle.h>
+#include <linux/memremap.h>
 
 #include <asm/tlbflush.h>
 
@@ -1308,6 +1309,10 @@ static bool try_to_unmap_one(struct page
 	if ((flags & TTU_MUNLOCK) && !(vma->vm_flags & VM_LOCKED))
 		return true;
 
+	if (IS_ENABLED(CONFIG_MIGRATION) && (flags & TTU_MIGRATION) &&
+	    is_zone_device_page(page) && !dev_page_allow_migrate(page))
+		return SWAP_AGAIN;
+
 	if (flags & TTU_SPLIT_HUGE_PMD) {
 		split_huge_pmd_address(vma, address,
 				flags & TTU_MIGRATION, page);
@@ -1343,6 +1348,26 @@ static bool try_to_unmap_one(struct page
 		subpage = page - page_to_pfn(page) + pte_pfn(*pvmw.pte);
 		address = pvmw.address;
 
+		if (IS_ENABLED(CONFIG_MIGRATION) &&
+		    (flags & TTU_MIGRATION) &&
+		    is_zone_device_page(page)) {
+			swp_entry_t entry;
+			pte_t swp_pte;
+
+			pteval = ptep_get_and_clear(mm, address, pvmw.pte);
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
+			set_pte_at(mm, address, pvmw.pte, swp_pte);
+			goto discard;
+		}
 
 		if (!(flags & TTU_IGNORE_ACCESS)) {
 			if (ptep_clear_flush_young_notify(vma, address,
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

