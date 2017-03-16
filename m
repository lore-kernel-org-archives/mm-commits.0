From: akpm@linux-foundation.org
Subject: +
 mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v4.patch
 added to -mm tree
Date: Thu, 16 Mar 2017 13:51:50 -0700
Message-ID: <58cafae6.YDiUpL9L6BzkPDAT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52824 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752249AbdCPVDs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 17:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, SCheung@nvidia.com, arbab@linux.vnet.ibm.com, ebaskakov@nvidia.com, jhubbard@nvidia.com, mhairgrove@nvidia.com, sgutti@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: new memory migration helper for use with device memory
has been added to the -mm tree.  Its filename is
     mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v4.patch

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
Subject: mm/migrate: new memory migration helper for use with device memory

This patch add new memory migration helpers, which migrate memory backing
a range of virtual address of a process to different memory (which can be
allocated through special allocator).  It differs from numa migration by
working on a range of virtual address and thus by doing migration in chunk
that can be large enough to use DMA engine or special copy offloading
engine.

Expected users are any one with heterogeneous memory where different
memory have different characteristics (latency, bandwidth, ...).  As an
example IBM platform with CAPI bus can make use of this feature to migrate
between regular memory and CAPI device memory.  New CPU architecture with
a pool of high performance memory not manage as cache but presented as
regular memory (while being faster and with lower latency than DDR) will
also be prime user of this patch.

Migration to private device memory will be usefull for device that have
large pool of such like GPU, NVidia plans to use HMM for that.

Link: http://lkml.kernel.org/r/1489680335-6594-8-git-send-email-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Evgeny Baskakov <ebaskakov@nvidia.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Mark Hairgrove <mhairgrove@nvidia.com>
Signed-off-by: Sherry Cheung <SCheung@nvidia.com>
Signed-off-by: Subhash Gutti <sgutti@nvidia.com>
Reviewed-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Tested-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |   73 ++++++
 mm/migrate.c            |  460 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 533 insertions(+)

diff -puN include/linux/migrate.h~mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v4 include/linux/migrate.h
--- a/include/linux/migrate.h~mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v4
+++ a/include/linux/migrate.h
@@ -124,4 +124,77 @@ static inline int migrate_misplaced_tran
 }
 #endif /* CONFIG_NUMA_BALANCING && CONFIG_TRANSPARENT_HUGEPAGE*/
 
+
+#define MIGRATE_PFN_VALID	(1UL << (BITS_PER_LONG_LONG - 1))
+#define MIGRATE_PFN_MIGRATE	(1UL << (BITS_PER_LONG_LONG - 2))
+#define MIGRATE_PFN_HUGE	(1UL << (BITS_PER_LONG_LONG - 3))
+#define MIGRATE_PFN_LOCKED	(1UL << (BITS_PER_LONG_LONG - 4))
+#define MIGRATE_PFN_WRITE	(1UL << (BITS_PER_LONG_LONG - 5))
+#define MIGRATE_PFN_MASK	((1UL << (BITS_PER_LONG_LONG - PAGE_SHIFT)) - 1)
+
+static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
+{
+	if (!(mpfn & MIGRATE_PFN_VALID))
+		return NULL;
+	return pfn_to_page(mpfn & MIGRATE_PFN_MASK);
+}
+
+static inline unsigned long migrate_pfn_size(unsigned long mpfn)
+{
+	return mpfn & MIGRATE_PFN_HUGE ? PMD_SIZE : PAGE_SIZE;
+}
+
+/*
+ * struct migrate_vma_ops - migrate operation callback
+ *
+ * @alloc_and_copy: alloc destination memoiry and copy source to it
+ * @finalize_and_map: allow caller to inspect successfull migrated page
+ *
+ * migrate_vma() allow memory migration to use DMA  engine to perform copy from
+ * source to destination memory it also allow caller to use its own memory
+ * allocator for destination memory.
+ *
+ * Note that in alloc_and_copy device driver can decide not to migrate some of
+ * the entry by simply setting corresponding dst entry 0.
+ *
+ * Destination page must locked and MIGRATE_PFN_LOCKED set in the corresponding
+ * entry of dstarray. It is expected that page allocated will have an elevated
+ * refcount and that a put_page() will free the page.
+ *
+ * Device driver might want to allocate with an extra-refcount if they want to
+ * control deallocation of failed migration inside finalize_and_map() callback.
+ *
+ * The finalize_and_map() callback must use the MIGRATE_PFN_MIGRATE flag to
+ * determine which page have been successfully migrated (it is set in the src
+ * array for each entry that have been successfully migrated).
+ *
+ * For migration from device memory to system memory device driver must set any
+ * dst entry to MIGRATE_PFN_ERROR for any entry it can not migrate back due to
+ * hardware fatal failure that can not be recovered. Such failure will trigger
+ * a SIGBUS for the process trying to access such memory.
+ */
+struct migrate_vma_ops {
+	void (*alloc_and_copy)(struct vm_area_struct *vma,
+			       const unsigned long *src,
+			       unsigned long *dst,
+			       unsigned long start,
+			       unsigned long end,
+			       void *private);
+	void (*finalize_and_map)(struct vm_area_struct *vma,
+				 const unsigned long *src,
+				 const unsigned long *dst,
+				 unsigned long start,
+				 unsigned long end,
+				 void *private);
+};
+
+int migrate_vma(const struct migrate_vma_ops *ops,
+		struct vm_area_struct *vma,
+		unsigned long mentries,
+		unsigned long start,
+		unsigned long end,
+		unsigned long *src,
+		unsigned long *dst,
+		void *private);
+
 #endif /* _LINUX_MIGRATE_H */
diff -puN mm/migrate.c~mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v4 mm/migrate.c
--- a/mm/migrate.c~mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v4
+++ a/mm/migrate.c
@@ -393,6 +393,14 @@ int migrate_page_move_mapping(struct add
 	int expected_count = 1 + extra_count;
 	void **pslot;
 
+	/*
+	 * ZONE_DEVICE pages have 1 refcount always held by their device
+	 *
+	 * Note that DAX memory will never reach that point as it does not have
+	 * the MEMORY_DEVICE_ALLOW_MIGRATE flag set (see memory_hotplug.h).
+	 */
+	expected_count += is_zone_device_page(page);
+
 	if (!mapping) {
 		/* Anonymous page without mapping */
 		if (page_count(page) != expected_count)
@@ -2059,3 +2067,455 @@ out_unlock:
 #endif /* CONFIG_NUMA_BALANCING */
 
 #endif /* CONFIG_NUMA */
+
+
+struct migrate_vma {
+	struct vm_area_struct	*vma;
+	unsigned long		*dst;
+	unsigned long		*src;
+	unsigned long		cpages;
+	unsigned long		npages;
+	unsigned long		mpages;
+	unsigned long		start;
+	unsigned long		end;
+};
+
+static inline int migrate_vma_array_full(struct migrate_vma *migrate)
+{
+	return migrate->npages >= migrate->mpages ? -ENOSPC : 0;
+}
+
+static int migrate_vma_collect_hole(unsigned long start,
+				    unsigned long end,
+				    struct mm_walk *walk)
+{
+	struct migrate_vma *migrate = walk->private;
+	unsigned long addr, next;
+
+	for (addr = start & PAGE_MASK; addr < end; addr = next) {
+		unsigned long npages, i;
+		int ret;
+
+		next = pmd_addr_end(addr, end);
+		npages = (next - addr) >> PAGE_SHIFT;
+		if (npages == (PMD_SIZE >> PAGE_SHIFT)) {
+			migrate->src[migrate->npages++] = MIGRATE_PFN_HUGE;
+			ret = migrate_vma_array_full(migrate);
+			if (ret)
+				return ret;
+		} else {
+			for (i = 0; i < npages; ++i) {
+				migrate->src[migrate->npages++] = 0;
+				ret = migrate_vma_array_full(migrate);
+				if (ret)
+					return ret;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int migrate_vma_collect_pmd(pmd_t *pmdp,
+				   unsigned long start,
+				   unsigned long end,
+				   struct mm_walk *walk)
+{
+	struct migrate_vma *migrate = walk->private;
+	struct mm_struct *mm = walk->vma->vm_mm;
+	unsigned long addr = start;
+	spinlock_t *ptl;
+	pte_t *ptep;
+
+	if (pmd_none(*pmdp) || pmd_trans_unstable(pmdp)) {
+		/* FIXME support THP */
+		return migrate_vma_collect_hole(start, end, walk);
+	}
+
+	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	for (; addr < end; addr += PAGE_SIZE, ptep++) {
+		unsigned long flags, pfn;
+		struct page *page;
+		pte_t pte;
+		int ret;
+
+		pte = *ptep;
+		pfn = pte_pfn(pte);
+
+		if (!pte_present(pte)) {
+			flags = pfn = 0;
+			goto next;
+		}
+
+		/* FIXME support THP */
+		page = vm_normal_page(migrate->vma, addr, pte);
+		if (!page || !page->mapping || PageTransCompound(page)) {
+			flags = pfn = 0;
+			goto next;
+		}
+
+		/*
+		 * By getting a reference on the page we pin it and that blocks
+		 * any kind of migration. Side effect is that it "freezes" the
+		 * pte.
+		 *
+		 * We drop this reference after isolating the page from the lru
+		 * for non device page (device page are not on the lru and thus
+		 * can't be dropped from it).
+		 */
+		get_page(page);
+		migrate->cpages++;
+		flags = MIGRATE_PFN_VALID | MIGRATE_PFN_MIGRATE;
+		flags |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
+
+next:
+		migrate->src[migrate->npages++] = pfn | flags;
+		ret = migrate_vma_array_full(migrate);
+		if (ret) {
+			pte_unmap_unlock(ptep, ptl);
+			return ret;
+		}
+	}
+	pte_unmap_unlock(ptep - 1, ptl);
+
+	return 0;
+}
+
+/*
+ * migrate_vma_collect() - collect page over range of virtual addresses
+ * @migrate: migrate struct containing all migration information
+ *
+ * This will walk the CPU page table. For each virtual address backed by a
+ * valid page, it updates the src array and takes a reference on the page, in
+ * order to pin the page until we lock it and unmap it.
+ */
+static void migrate_vma_collect(struct migrate_vma *migrate)
+{
+	struct mm_walk mm_walk;
+
+	mm_walk.pmd_entry = migrate_vma_collect_pmd;
+	mm_walk.pte_entry = NULL;
+	mm_walk.pte_hole = migrate_vma_collect_hole;
+	mm_walk.hugetlb_entry = NULL;
+	mm_walk.test_walk = NULL;
+	mm_walk.vma = migrate->vma;
+	mm_walk.mm = migrate->vma->vm_mm;
+	mm_walk.private = migrate;
+
+	walk_page_range(migrate->start, migrate->end, &mm_walk);
+
+	migrate->end = migrate->start + (migrate->npages << PAGE_SHIFT);
+}
+
+/*
+ * migrate_vma_check_page() - check if page is pinned or not
+ * @page: struct page to check
+ *
+ * Pinned pages cannot be migrated. This is the same test as in
+ * migrate_page_move_mapping(), except that here we allow migration of a
+ * ZONE_DEVICE page.
+ */
+static bool migrate_vma_check_page(struct page *page)
+{
+	/*
+	 * One extra ref because caller holds an extra reference, either from
+	 * isolate_lru_page() for a regular page, or migrate_vma_collect() for
+	 * a device page.
+	 */
+	int extra = 1;
+
+	/*
+	 * FIXME support THP (transparent huge page), it is bit more complex to
+	 * check them than regular pages, because they can be mapped with a pmd
+	 * or with a pte (split pte mapping).
+	 */
+	if (PageCompound(page))
+		return false;
+
+	if ((page_count(page) - extra) > page_mapcount(page))
+		return false;
+
+	return true;
+}
+
+/*
+ * migrate_vma_prepare() - lock pages and isolate them from the lru
+ * @migrate: migrate struct containing all migration informations
+ *
+ * This locks pages that have been collected by migrate_vma_collect(). Once each
+ * page is locked it is isolated from the lru (for non-device pages). Finally,
+ * the ref taken by migrate_vma_collect() is dropped, as locked pages cannot be
+ * migrated by concurrent kernel threads.
+ */
+static void migrate_vma_prepare(struct migrate_vma *migrate)
+{
+	unsigned long addr = migrate->start, i, size;
+	const unsigned long npages = migrate->npages;
+	bool allow_drain = true;
+
+	lru_add_drain();
+
+	for (i = 0; i < npages && migrate->cpages; i++, addr += size) {
+		struct page *page = migrate_pfn_to_page(migrate->src[i]);
+		size = migrate_pfn_size(migrate->src[i]);
+
+		if (!page)
+			continue;
+
+		lock_page(page);
+		migrate->src[i] |= MIGRATE_PFN_LOCKED;
+
+		if (!PageLRU(page) && allow_drain) {
+			/* Drain CPU's pagevec */
+			lru_add_drain_all();
+			allow_drain = false;
+		}
+
+		if (isolate_lru_page(page)) {
+			migrate->src[i] = 0;
+			unlock_page(page);
+			migrate->cpages--;
+			put_page(page);
+			continue;
+		}
+
+		/* Drop the reference we took in collect */
+		put_page(page);
+
+		if (!migrate_vma_check_page(page)) {
+			migrate->src[i] = 0;
+			unlock_page(page);
+			migrate->cpages--;
+
+			putback_lru_page(page);
+		}
+	}
+}
+
+/*
+ * migrate_vma_unmap() - replace page mapping with special migration pte entry
+ * @migrate: migrate struct containing all migration information
+ *
+ * Replace page mapping (CPU page table pte) with special migration pte entry
+ * and check again if it has been pinned. Pinned pages are restored because we
+ * cannot migrate them.
+ *
+ * This is the last step before we call the device driver callback to allocate
+ * destination memory and copy contents of original page over to new page.
+ */
+static void migrate_vma_unmap(struct migrate_vma *migrate)
+{
+	int flags = TTU_MIGRATION | TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
+	unsigned long addr = migrate->start, i, restore = 0, size;
+	const unsigned long npages = migrate->npages;
+	const unsigned long start = migrate->start;
+
+	for (i = 0; i < npages && migrate->cpages; addr += size, i++) {
+		struct page *page = migrate_pfn_to_page(migrate->src[i]);
+		size = migrate_pfn_size(migrate->src[i]);
+
+		if (!page || !(migrate->src[i] & MIGRATE_PFN_MIGRATE))
+			continue;
+
+		try_to_unmap(page, flags);
+		if (page_mapped(page) || !migrate_vma_check_page(page)) {
+			migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
+			migrate->cpages--;
+			restore++;
+		}
+	}
+
+	for (addr = start, i = 0; i < npages && restore; addr += size, i++) {
+		struct page *page = migrate_pfn_to_page(migrate->src[i]);
+		size = migrate_pfn_size(migrate->src[i]);
+
+		if (!page || (migrate->src[i] & MIGRATE_PFN_MIGRATE))
+			continue;
+
+		remove_migration_ptes(page, page, false);
+
+		migrate->src[i] = 0;
+		unlock_page(page);
+		restore--;
+
+		putback_lru_page(page);
+	}
+}
+
+/*
+ * migrate_vma_pages() - migrate meta-data from src page to dst page
+ * @migrate: migrate struct containing all migration information
+ *
+ * This migrate struct page meta-data from source struct page to destination
+ * struct page. This effectively finishes the migration from source page to the
+ * destination page.
+ */
+static void migrate_vma_pages(struct migrate_vma *migrate)
+{
+	const unsigned long npages = migrate->npages;
+	unsigned long addr, i, size;
+
+	for (i = 0, addr = migrate->start; i < npages; addr += size, i++) {
+		struct page *newpage = migrate_pfn_to_page(migrate->dst[i]);
+		struct page *page = migrate_pfn_to_page(migrate->src[i]);
+		struct address_space *mapping;
+		int r;
+
+		size = migrate_pfn_size(migrate->src[i]);
+
+		if (!page || !newpage)
+			continue;
+		if (!(migrate->src[i] & MIGRATE_PFN_MIGRATE))
+			continue;
+
+		mapping = page_mapping(page);
+
+		r = migrate_page(mapping, newpage, page, MIGRATE_SYNC, false);
+		if (r != MIGRATEPAGE_SUCCESS)
+			migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
+	}
+}
+
+/*
+ * migrate_vma_finalize() - restore CPU page table entry
+ * @migrate: migrate struct containing all migration information
+ *
+ * This replaces the special migration pte entry with either a mapping to the
+ * new page if migration was successful for that page, or to the original page
+ * otherwise.
+ *
+ * This also unlocks the pages and puts them back on the lru, or drops the extra
+ * refcount, for device pages.
+ */
+static void migrate_vma_finalize(struct migrate_vma *migrate)
+{
+	const unsigned long npages = migrate->npages;
+	unsigned long addr, i, size;
+
+	for (i = 0, addr = migrate->start; i < npages; addr += size, i++) {
+		struct page *newpage = migrate_pfn_to_page(migrate->dst[i]);
+		struct page *page = migrate_pfn_to_page(migrate->src[i]);
+		size = migrate_pfn_size(migrate->src[i]);
+
+		if (!page)
+			continue;
+		if (!(migrate->src[i] & MIGRATE_PFN_MIGRATE) || !newpage) {
+			if (newpage) {
+				unlock_page(newpage);
+				put_page(newpage);
+			}
+			newpage = page;
+		}
+
+		remove_migration_ptes(page, newpage, false);
+		unlock_page(page);
+		migrate->cpages--;
+
+		putback_lru_page(page);
+
+		if (newpage != page) {
+			unlock_page(newpage);
+			putback_lru_page(newpage);
+		}
+	}
+}
+
+/*
+ * migrate_vma() - migrate a range of memory inside vma using accelerated copy
+ *
+ * @ops: migration callback for allocating destination memory and copying
+ * @vma: virtual memory area containing the range to be migrated
+ * @mentries: maximum number of entry in src or dst pfns array
+ * @start: start address of the range to migrate (inclusive)
+ * @end: end address of the range to migrate (exclusive)
+ * @src: array of hmm_pfn_t containing source pfns
+ * @dst: array of hmm_pfn_t containing destination pfns
+ * @private: pointer passed back to each of the callback
+ * Returns: 0 on success, error code otherwise
+ *
+ * This will try to migrate a range of memory using callback to allocate and
+ * copy memory from source to destination. This function will first collect,
+ * lock and unmap pages in the range and then call alloc_and_copy() callback
+ * for device driver to allocate destination memory and copy from source.
+ *
+ * Then it will proceed and try to effectively migrate the page (struct page
+ * metadata), a step that can fail for various reasons. Before updating CPU page
+ * table it will call finalize_and_map() callback so that the device driver can
+ * inspect what has been successfully migrated and update its own page tables
+ * (this latter aspect is not mandatory and only make senses for some users of
+ * this API).
+ *
+ * Finally the function update CPU page table and unlock the pages before
+ * returning 0.
+ *
+ * It will return an error code only if one of the arguments is invalid.
+ */
+int migrate_vma(const struct migrate_vma_ops *ops,
+		struct vm_area_struct *vma,
+		unsigned long mentries,
+		unsigned long start,
+		unsigned long end,
+		unsigned long *src,
+		unsigned long *dst,
+		void *private)
+{
+	struct migrate_vma migrate;
+
+	/* Sanity check the arguments */
+	start &= PAGE_MASK;
+	end &= PAGE_MASK;
+	if (is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_SPECIAL))
+		return -EINVAL;
+	if (!vma || !ops || !src || !dst || start >= end)
+		return -EINVAL;
+	if (start < vma->vm_start || start >= vma->vm_end)
+		return -EINVAL;
+	if (end <= vma->vm_start || end > vma->vm_end)
+		return -EINVAL;
+
+	memset(src, 0, sizeof(*src) * ((end - start) >> PAGE_SHIFT));
+	migrate.src = src;
+	migrate.dst = dst;
+	migrate.start = start;
+	migrate.npages = 0;
+	migrate.cpages = 0;
+	migrate.mpages = mentries;
+	migrate.end = end;
+	migrate.vma = vma;
+
+	/* Collect, and try to unmap source pages */
+	migrate_vma_collect(&migrate);
+	if (!migrate.cpages)
+		return 0;
+
+	/* Lock and isolate page */
+	migrate_vma_prepare(&migrate);
+	if (!migrate.cpages)
+		return 0;
+
+	/* Unmap pages */
+	migrate_vma_unmap(&migrate);
+	if (!migrate.cpages)
+		return 0;
+
+	/*
+	 * At this point pages are locked and unmapped, and thus they have
+	 * stable content and can safely be copied to destination memory that
+	 * is allocated by the callback.
+	 *
+	 * Note that migration can fail in migrate_vma_struct_page() for each
+	 * individual page.
+	 */
+	ops->alloc_and_copy(vma, src, dst, start, end, private);
+
+	/* This does the real migration of struct page */
+	migrate_vma_pages(&migrate);
+
+	ops->finalize_and_map(vma, src, dst, start, end, private);
+
+	/* Unlock and remap pages */
+	migrate_vma_finalize(&migrate);
+
+	return 0;
+}
+EXPORT_SYMBOL(migrate_vma);
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

