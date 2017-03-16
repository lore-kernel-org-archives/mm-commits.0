From: akpm@linux-foundation.org
Subject: +
 mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry.patch added
 to -mm tree
Date: Thu, 16 Mar 2017 13:52:10 -0700
Message-ID: <58cafafa.48ZMh/b+JJ3uaQrq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54986 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753840AbdCPVRc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 17:17:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: allow migrate_vma() to alloc new page on empty entry
has been added to the -mm tree.  Its filename is
     mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry.patch

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

This allow caller of migrate_vma() to allocate new page for empty CPU page
table entry.  It only support anoymous memory and it won't allow new page
to be instance if userfaultfd is armed.

This is usefull to device driver that want to migrate a range of virtual
address and would rather allocate new memory than having to fault later
on.

Link: http://lkml.kernel.org/r/1489680335-6594-15-git-send-email-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    6 +
 mm/migrate.c            |  156 ++++++++++++++++++++++++++++++++------
 2 files changed, 138 insertions(+), 24 deletions(-)

diff -puN include/linux/migrate.h~mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry include/linux/migrate.h
--- a/include/linux/migrate.h~mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry
+++ a/include/linux/migrate.h
@@ -157,7 +157,11 @@ static inline unsigned long migrate_pfn_
  * allocator for destination memory.
  *
  * Note that in alloc_and_copy device driver can decide not to migrate some of
- * the entry by simply setting corresponding dst entry 0.
+ * the entry by simply setting corresponding dst entry 0. Driver can also try
+ * to allocate memory for empty source entry by setting valid dst entry. If
+ * CPU page table is not populated while alloc_and_copy() callback is taking
+ * place then CPU page table will be updated to point to the newly allocated
+ * memory.
  *
  * Destination page must locked and MIGRATE_PFN_LOCKED set in the corresponding
  * entry of dstarray. It is expected that page allocated will have an elevated
diff -puN mm/migrate.c~mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry mm/migrate.c
--- a/mm/migrate.c~mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry
+++ a/mm/migrate.c
@@ -42,6 +42,7 @@
 #include <linux/page_owner.h>
 #include <linux/sched/mm.h>
 #include <linux/memremap.h>
+#include <linux/userfaultfd_k.h>
 
 #include <asm/tlbflush.h>
 
@@ -2101,29 +2102,17 @@ static int migrate_vma_collect_hole(unsi
 				    struct mm_walk *walk)
 {
 	struct migrate_vma *migrate = walk->private;
-	unsigned long addr, next;
+	unsigned long addr;
 
-	for (addr = start & PAGE_MASK; addr < end; addr = next) {
-		unsigned long npages, i;
+	for (addr = start & PAGE_MASK; addr < end; addr += PAGE_SIZE) {
 		int ret;
 
-		next = pmd_addr_end(addr, end);
-		npages = (next - addr) >> PAGE_SHIFT;
-		if (npages == (PMD_SIZE >> PAGE_SHIFT)) {
-			migrate->dst[migrate->npages] = 0;
-			migrate->src[migrate->npages++] = MIGRATE_PFN_HUGE;
-			ret = migrate_vma_array_full(migrate);
-			if (ret)
-				return ret;
-		} else {
-			for (i = 0; i < npages; ++i) {
-				migrate->dst[migrate->npages] = 0;
-				migrate->src[migrate->npages++] = 0;
-				ret = migrate_vma_array_full(migrate);
-				if (ret)
-					return ret;
-			}
-		}
+		migrate->cpages++;
+		migrate->dst[migrate->npages] = 0;
+		migrate->src[migrate->npages++] = 0;
+		ret = migrate_vma_array_full(migrate);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
@@ -2160,6 +2149,7 @@ static int migrate_vma_collect_pmd(pmd_t
 		pfn = pte_pfn(pte);
 
 		if (pte_none(pte)) {
+			migrate->cpages++;
 			flags = pfn = 0;
 			goto next;
 		}
@@ -2478,6 +2468,114 @@ static void migrate_vma_unmap(struct mig
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
+	spinlock_t *ptl;
+	pgd_t *pgdp;
+	pud_t *pudp;
+	pmd_t *pmdp;
+	pte_t *ptep;
+	pte_t entry;
+
+	if ((*dst & MIGRATE_PFN_HUGE) || (*src & MIGRATE_PFN_HUGE))
+		goto abort;
+
+	/* Only allow to populate anonymous memory */
+	if (!vma_is_anonymous(vma))
+		goto abort;
+
+	pgdp = pgd_offset(mm, addr);
+	pudp = pud_alloc(mm, pgdp, addr);
+	if (!pudp)
+		goto abort;
+	pmdp = pmd_alloc(mm, pudp, addr);
+	if (!pmdp)
+		goto abort;
+
+	if (pmd_trans_unstable(pmdp) || pmd_devmap(*pmdp))
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
+	 * preceeding stores to the page contents become visible before
+	 * the set_pte_at() write.
+	 */
+	__SetPageUptodate(page);
+
+	if (is_zone_device_page(page) && !is_addressable_page(page)) {
+		swp_entry_t swp_entry;
+
+		swp_entry = make_device_entry(page, vma->vm_flags & VM_WRITE);
+		entry = swp_entry_to_pte(swp_entry);
+	} else {
+		entry = mk_pte(page, vma->vm_page_prot);
+		if (vma->vm_flags & VM_WRITE)
+			entry = pte_mkwrite(pte_mkdirty(entry));
+	}
+
+	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	if (!pte_none(*ptep)) {
+		pte_unmap_unlock(ptep, ptl);
+		mem_cgroup_cancel_charge(page, memcg, false);
+		goto abort;
+	}
+
+	/* Check for usefaultfd but do not deliver fault just back of */
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
+	set_pte_at(mm, addr, ptep, entry);
+
+	/* Take a reference on the page */
+	get_page(page);
+
+	/* No need to invalidate - it was non-present before */
+	update_mmu_cache(vma, addr, ptep);
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
@@ -2499,10 +2597,16 @@ static void migrate_vma_pages(struct mig
 
 		size = migrate_pfn_size(migrate->src[i]);
 
-		if (!page || !newpage)
+		if (!newpage) {
+			migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
 			continue;
-		if (!(migrate->src[i] & MIGRATE_PFN_MIGRATE))
+		} else if (!(migrate->src[i] & MIGRATE_PFN_MIGRATE)) {
+			if (!page)
+				migrate_vma_insert_page(migrate, addr, newpage,
+							&migrate->src[i],
+							&migrate->dst[i]);
 			continue;
+		}
 
 		mapping = page_mapping(page);
 
@@ -2549,8 +2653,14 @@ static void migrate_vma_finalize(struct
 		struct page *page = migrate_pfn_to_page(migrate->src[i]);
 		size = migrate_pfn_size(migrate->src[i]);
 
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

