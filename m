From: akpm@linux-foundation.org
Subject: +
 mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-v4.patch
 added to -mm tree
Date: Thu, 17 Aug 2017 14:42:26 -0700
Message-ID: <59960dc2.wrOfvP/BCTFVRrtS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40738 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753736AbdHQVm2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Aug 2017 17:42:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, SCheung@nvidia.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, bsingharora@gmail.com, dan.j.williams@intel.com, dnellans@nvidia.com, ebaskakov@nvidia.com, hannes@cmpxchg.org, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mhairgrove@nvidia.com, mhocko@kernel.org, paulmck@linux.vnet.ibm.com, ross.zwisler@linux.intel.com, sgutti@nvidia.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: allow migrate_vma() to alloc new page on empty entry
has been added to the -mm tree.  Its filename is
     mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-v4.patch

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
Subject: mm/migrate: allow migrate_vma() to alloc new page on empty entry

This allows callers of migrate_vma() to allocate new page for empty CPU
page table entry (pte_none or back by zero page).  This is only for
anonymous memory and it won't allow new page to be instanced if the
userfaultfd is armed.

This is useful to device driver that want to migrate a range of virtual
address and would rather allocate new memory than having to fault later
on.

Link: http://lkml.kernel.org/r/20170817000548.32038-18-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Nellans <dnellans@nvidia.com>
Cc: Evgeny Baskakov <ebaskakov@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mark Hairgrove <mhairgrove@nvidia.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Sherry Cheung <SCheung@nvidia.com>
Cc: Subhash Gutti <sgutti@nvidia.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    9 +
 mm/migrate.c            |  205 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 205 insertions(+), 9 deletions(-)

diff -puN include/linux/migrate.h~mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-v4 include/linux/migrate.h
--- a/include/linux/migrate.h~mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-v4
+++ a/include/linux/migrate.h
@@ -218,6 +218,15 @@ static inline unsigned long migrate_pfn(
  * driver should avoid setting MIGRATE_PFN_ERROR unless it is really in an
  * unrecoverable state.
  *
+ * For empty entry inside CPU page table (pte_none() or pmd_none() is true) we
+ * do set MIGRATE_PFN_MIGRATE flag inside the corresponding source array thus
+ * allowing device driver to allocate device memory for those unback virtual
+ * address. For this the device driver simply have to allocate device memory
+ * and properly set the destination entry like for regular migration. Note that
+ * this can still fails and thus inside the device driver must check if the
+ * migration was successful for those entry inside the finalize_and_map()
+ * callback just like for regular migration.
+ *
  * THE alloc_and_copy() CALLBACK MUST NOT CHANGE ANY OF THE SRC ARRAY ENTRIES
  * OR BAD THINGS WILL HAPPEN !
  *
diff -puN mm/migrate.c~mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-v4 mm/migrate.c
--- a/mm/migrate.c~mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-v4
+++ a/mm/migrate.c
@@ -37,6 +37,7 @@
 #include <linux/hugetlb_cgroup.h>
 #include <linux/gfp.h>
 #include <linux/memremap.h>
+#include <linux/userfaultfd_k.h>
 #include <linux/balloon_compaction.h>
 #include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
@@ -2146,6 +2147,22 @@ static int migrate_vma_collect_hole(unsi
 	unsigned long addr;
 
 	for (addr = start & PAGE_MASK; addr < end; addr += PAGE_SIZE) {
+		migrate->src[migrate->npages++] = MIGRATE_PFN_MIGRATE;
+		migrate->dst[migrate->npages] = 0;
+		migrate->cpages++;
+	}
+
+	return 0;
+}
+
+static int migrate_vma_collect_skip(unsigned long start,
+				    unsigned long end,
+				    struct mm_walk *walk)
+{
+	struct migrate_vma *migrate = walk->private;
+	unsigned long addr;
+
+	for (addr = start & PAGE_MASK; addr < end; addr += PAGE_SIZE) {
 		migrate->dst[migrate->npages] = 0;
 		migrate->src[migrate->npages++] = 0;
 	}
@@ -2183,7 +2200,7 @@ again:
 			spin_unlock(ptl);
 			split_huge_pmd(vma, pmdp, addr);
 			if (pmd_trans_unstable(pmdp))
-				return migrate_vma_collect_hole(start, end,
+				return migrate_vma_collect_skip(start, end,
 								walk);
 		} else {
 			int ret;
@@ -2191,19 +2208,22 @@ again:
 			get_page(page);
 			spin_unlock(ptl);
 			if (unlikely(!trylock_page(page)))
-				return migrate_vma_collect_hole(start, end,
+				return migrate_vma_collect_skip(start, end,
 								walk);
 			ret = split_huge_page(page);
 			unlock_page(page);
 			put_page(page);
-			if (ret || pmd_none(*pmdp))
+			if (ret)
+				return migrate_vma_collect_skip(start, end,
+								walk);
+			if (pmd_none(*pmdp))
 				return migrate_vma_collect_hole(start, end,
 								walk);
 		}
 	}
 
 	if (unlikely(pmd_bad(*pmdp)))
-		return migrate_vma_collect_hole(start, end, walk);
+		return migrate_vma_collect_skip(start, end, walk);
 
 	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
 	arch_enter_lazy_mmu_mode();
@@ -2218,7 +2238,9 @@ again:
 		pfn = pte_pfn(pte);
 
 		if (pte_none(pte)) {
-			mpfn = pfn = 0;
+			mpfn = MIGRATE_PFN_MIGRATE;
+			migrate->cpages++;
+			pfn = 0;
 			goto next;
 		}
 
@@ -2240,6 +2262,12 @@ again:
 			if (is_write_device_private_entry(entry))
 				mpfn |= MIGRATE_PFN_WRITE;
 		} else {
+			if (is_zero_pfn(pfn)) {
+				mpfn = MIGRATE_PFN_MIGRATE;
+				migrate->cpages++;
+				pfn = 0;
+				goto next;
+			}
 			page = vm_normal_page(migrate->vma, addr, pte);
 			mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
 			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
@@ -2559,6 +2587,135 @@ restore:
 	}
 }
 
+static void migrate_vma_insert_page(struct migrate_vma *migrate,
+				    unsigned long addr,
+				    struct page *page,
+				    unsigned long *src,
+				    unsigned long *dst)
+{
+	struct vm_area_struct *vma = migrate->vma;
+	struct mm_struct *mm = vma->vm_mm;
+	struct mem_cgroup *memcg;
+	bool flush = false;
+	spinlock_t *ptl;
+	pte_t entry;
+	pgd_t *pgdp;
+	p4d_t *p4dp;
+	pud_t *pudp;
+	pmd_t *pmdp;
+	pte_t *ptep;
+
+	/* Only allow populating anonymous memory */
+	if (!vma_is_anonymous(vma))
+		goto abort;
+
+	pgdp = pgd_offset(mm, addr);
+	p4dp = p4d_alloc(mm, pgdp, addr);
+	if (!p4dp)
+		goto abort;
+	pudp = pud_alloc(mm, p4dp, addr);
+	if (!pudp)
+		goto abort;
+	pmdp = pmd_alloc(mm, pudp, addr);
+	if (!pmdp)
+		goto abort;
+
+	if (pmd_trans_huge(*pmdp) || pmd_devmap(*pmdp))
+		goto abort;
+
+	/*
+	 * Use pte_alloc() instead of pte_alloc_map().  We can't run
+	 * pte_offset_map() on pmds where a huge pmd might be created
+	 * from a different thread.
+	 *
+	 * pte_alloc_map() is safe to use under down_write(mmap_sem) or when
+	 * parallel threads are excluded by other means.
+	 *
+	 * Here we only have down_read(mmap_sem).
+	 */
+	if (pte_alloc(mm, pmdp, addr))
+		goto abort;
+
+	/* See the comment in pte_alloc_one_map() */
+	if (unlikely(pmd_trans_unstable(pmdp)))
+		goto abort;
+
+	if (unlikely(anon_vma_prepare(vma)))
+		goto abort;
+	if (mem_cgroup_try_charge(page, vma->vm_mm, GFP_KERNEL, &memcg, false))
+		goto abort;
+
+	/*
+	 * The memory barrier inside __SetPageUptodate makes sure that
+	 * preceding stores to the page contents become visible before
+	 * the set_pte_at() write.
+	 */
+	__SetPageUptodate(page);
+
+	if (is_zone_device_page(page) && is_device_private_page(page)) {
+		swp_entry_t swp_entry;
+
+		swp_entry = make_device_private_entry(page, vma->vm_flags & VM_WRITE);
+		entry = swp_entry_to_pte(swp_entry);
+	} else {
+		entry = mk_pte(page, vma->vm_page_prot);
+		if (vma->vm_flags & VM_WRITE)
+			entry = pte_mkwrite(pte_mkdirty(entry));
+	}
+
+	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+
+	if (pte_present(*ptep)) {
+		unsigned long pfn = pte_pfn(*ptep);
+
+		if (!is_zero_pfn(pfn)) {
+			pte_unmap_unlock(ptep, ptl);
+			mem_cgroup_cancel_charge(page, memcg, false);
+			goto abort;
+		}
+		flush = true;
+	} else if (!pte_none(*ptep)) {
+		pte_unmap_unlock(ptep, ptl);
+		mem_cgroup_cancel_charge(page, memcg, false);
+		goto abort;
+	}
+
+	/*
+	 * Check for usefaultfd but do not deliver the fault. Instead,
+	 * just back off.
+	 */
+	if (userfaultfd_missing(vma)) {
+		pte_unmap_unlock(ptep, ptl);
+		mem_cgroup_cancel_charge(page, memcg, false);
+		goto abort;
+	}
+
+	inc_mm_counter(mm, MM_ANONPAGES);
+	page_add_new_anon_rmap(page, vma, addr, false);
+	mem_cgroup_commit_charge(page, memcg, false, false);
+	if (!is_zone_device_page(page))
+		lru_cache_add_active_or_unevictable(page, vma);
+	get_page(page);
+
+	if (flush) {
+		flush_cache_page(vma, addr, pte_pfn(*ptep));
+		ptep_clear_flush_notify(vma, addr, ptep);
+		set_pte_at_notify(mm, addr, ptep, entry);
+		update_mmu_cache(vma, addr, ptep);
+	} else {
+		/* No need to invalidate - it was non-present before */
+		set_pte_at(mm, addr, ptep, entry);
+		update_mmu_cache(vma, addr, ptep);
+	}
+
+	pte_unmap_unlock(ptep, ptl);
+	*src = MIGRATE_PFN_MIGRATE;
+	return;
+
+abort:
+	*src &= ~MIGRATE_PFN_MIGRATE;
+}
+
 /*
  * migrate_vma_pages() - migrate meta-data from src page to dst page
  * @migrate: migrate struct containing all migration information
@@ -2571,7 +2728,10 @@ static void migrate_vma_pages(struct mig
 {
 	const unsigned long npages = migrate->npages;
 	const unsigned long start = migrate->start;
-	unsigned long addr, i;
+	struct vm_area_struct *vma = migrate->vma;
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long addr, i, mmu_start;
+	bool notified = false;
 
 	for (i = 0, addr = start; i < npages; addr += PAGE_SIZE, i++) {
 		struct page *newpage = migrate_pfn_to_page(migrate->dst[i]);
@@ -2579,10 +2739,27 @@ static void migrate_vma_pages(struct mig
 		struct address_space *mapping;
 		int r;
 
-		if (!page || !newpage)
+		if (!newpage) {
+			migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
 			continue;
-		if (!(migrate->src[i] & MIGRATE_PFN_MIGRATE))
+		}
+
+		if (!page) {
+			if (!(migrate->src[i] & MIGRATE_PFN_MIGRATE)) {
+				continue;
+			}
+			if (!notified) {
+				mmu_start = addr;
+				notified = true;
+				mmu_notifier_invalidate_range_start(mm,
+								mmu_start,
+								migrate->end);
+			}
+			migrate_vma_insert_page(migrate, addr, newpage,
+						&migrate->src[i],
+						&migrate->dst[i]);
 			continue;
+		}
 
 		mapping = page_mapping(page);
 
@@ -2610,6 +2787,10 @@ static void migrate_vma_pages(struct mig
 		if (r != MIGRATEPAGE_SUCCESS)
 			migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
 	}
+
+	if (notified)
+		mmu_notifier_invalidate_range_end(mm, mmu_start,
+						  migrate->end);
 }
 
 /*
@@ -2632,8 +2813,14 @@ static void migrate_vma_finalize(struct
 		struct page *newpage = migrate_pfn_to_page(migrate->dst[i]);
 		struct page *page = migrate_pfn_to_page(migrate->src[i]);
 
-		if (!page)
+		if (!page) {
+			if (newpage) {
+				unlock_page(newpage);
+				put_page(newpage);
+			}
 			continue;
+		}
+
 		if (!(migrate->src[i] & MIGRATE_PFN_MIGRATE) || !newpage) {
 			if (newpage) {
 				unlock_page(newpage);
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

