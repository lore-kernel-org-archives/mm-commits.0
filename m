From: akpm@linux-foundation.org
Subject: +
 mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3.patch added to -mm tree
Date: Thu, 16 Mar 2017 13:51:40 -0700
Message-ID: <58cafadc.BYkJMRpSAD40IxS/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52820 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751954AbdCPVDs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 17:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, dan.j.williams@intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ZONE_DEVICE/unaddressable: add support for un-addressable device memory
has been added to the -mm tree.  Its filename is
     mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3.patch

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
Subject: mm/ZONE_DEVICE/unaddressable: add support for un-addressable device memory

This adds support for un-addressable device memory.  Such memory is
hotpluged only so we can have struct page but we should never map them as
such memory can not be accessed by CPU.  For that reason it uses a special
swap entry for CPU page table entry.

This patch implements all the logic from special swap type to handling CPU
page fault through a callback specified in the ZONE_DEVICE pgmap struct.

Architecture that wish to support un-addressable device memory should make
sure to never populate the kernel linar mapping for the physical range.

This feature potentially breaks memory hotplug unless every driver using
it magically predicts the future addresses of where memory will be
hotplugged.

Link: http://lkml.kernel.org/r/1489680335-6594-5-git-send-email-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c             |    7 +++
 include/linux/ioport.h         |    1 
 include/linux/memory_hotplug.h |    7 +++
 include/linux/memremap.h       |   18 ++++++++
 include/linux/swap.h           |   18 ++++++--
 include/linux/swapops.h        |   67 +++++++++++++++++++++++++++++++
 kernel/memremap.c              |   22 +++++++++-
 mm/Kconfig                     |   12 +++++
 mm/memory.c                    |   66 ++++++++++++++++++++++++++++++
 mm/memory_hotplug.c            |   10 +++-
 mm/mprotect.c                  |   12 +++++
 11 files changed, 232 insertions(+), 8 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3
+++ a/fs/proc/task_mmu.c
@@ -542,6 +542,8 @@ static void smaps_pte_entry(pte_t *pte,
 			}
 		} else if (is_migration_entry(swpent))
 			page = migration_entry_to_page(swpent);
+		else if (is_device_entry(swpent))
+			page = device_entry_to_page(swpent);
 	} else if (unlikely(IS_ENABLED(CONFIG_SHMEM) && mss->check_shmem_swap
 							&& pte_none(*pte))) {
 		page = find_get_entry(vma->vm_file->f_mapping,
@@ -704,6 +706,8 @@ static int smaps_hugetlb_range(pte_t *pt
 
 		if (is_migration_entry(swpent))
 			page = migration_entry_to_page(swpent);
+		else if (is_device_entry(swpent))
+			page = device_entry_to_page(swpent);
 	}
 	if (page) {
 		int mapcount = page_mapcount(page);
@@ -1196,6 +1200,9 @@ static pagemap_entry_t pte_to_pagemap_en
 		flags |= PM_SWAP;
 		if (is_migration_entry(entry))
 			page = migration_entry_to_page(entry);
+
+		if (is_device_entry(entry))
+			page = device_entry_to_page(entry);
 	}
 
 	if (page && !PageAnon(page))
diff -puN include/linux/ioport.h~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3 include/linux/ioport.h
--- a/include/linux/ioport.h~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3
+++ a/include/linux/ioport.h
@@ -130,6 +130,7 @@ enum {
 	IORES_DESC_ACPI_NV_STORAGE		= 3,
 	IORES_DESC_PERSISTENT_MEMORY		= 4,
 	IORES_DESC_PERSISTENT_MEMORY_LEGACY	= 5,
+	IORES_DESC_UNADDRESSABLE_MEMORY		= 6,
 };
 
 /* helpers to define resources */
diff -puN include/linux/memory_hotplug.h~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3 include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3
+++ a/include/linux/memory_hotplug.h
@@ -286,15 +286,22 @@ extern int zone_for_memory(int nid, u64
  * never relied on struct page migration so far and new user of might also
  * prefer avoiding struct page migration.
  *
+ * For device memory (which use ZONE_DEVICE) we want differentiate between CPU
+ * accessible memory (persitent memory, device memory on an architecture with a
+ * system bus that allow transparent access to device memory) and unaddressable
+ * memory (device memory that can not be accessed by CPU directly).
+ *
  * New non device memory specific flags can be added if ever needed.
  *
  * MEMORY_REGULAR: regular system memory
  * DEVICE_MEMORY: device memory create a ZONE_DEVICE zone for it
  * DEVICE_MEMORY_ALLOW_MIGRATE: page in that device memory ca be migrated
+ * MEMORY_DEVICE_UNADDRESSABLE: un-addressable memory (CPU can not access it)
  */
 #define MEMORY_NORMAL 0
 #define MEMORY_DEVICE (1 << 0)
 #define MEMORY_DEVICE_ALLOW_MIGRATE (1 << 1)
+#define MEMORY_DEVICE_UNADDRESSABLE (1 << 2)
 
 extern int arch_add_memory(int nid, u64 start, u64 size, int flags);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
diff -puN include/linux/memremap.h~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3 include/linux/memremap.h
--- a/include/linux/memremap.h~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3
+++ a/include/linux/memremap.h
@@ -35,10 +35,16 @@ static inline struct vmem_altmap *to_vme
 }
 #endif
 
+typedef int (*dev_page_fault_t)(struct vm_area_struct *vma,
+				unsigned long addr,
+				struct page *page,
+				unsigned flags,
+				pmd_t *pmdp);
 typedef void (*dev_page_free_t)(struct page *page, void *data);
 
 /**
  * struct dev_pagemap - metadata for ZONE_DEVICE mappings
+ * @page_fault: callback when CPU fault on an un-addressable device page
  * @page_free: free page callback when page refcount reach 1
  * @altmap: pre-allocated/reserved memory for vmemmap allocations
  * @res: physical address range covered by @ref
@@ -48,6 +54,7 @@ typedef void (*dev_page_free_t)(struct p
  * @flags: memory flags see MEMORY_* in memory_hotplug.h
  */
 struct dev_pagemap {
+	dev_page_fault_t page_fault;
 	dev_page_free_t page_free;
 	struct vmem_altmap *altmap;
 	const struct resource *res;
@@ -67,6 +74,12 @@ static inline bool dev_page_allow_migrat
 	return ((page_zonenum(page) == ZONE_DEVICE) &&
 		(page->pgmap->flags & MEMORY_DEVICE_ALLOW_MIGRATE));
 }
+
+static inline bool is_addressable_page(const struct page *page)
+{
+	return ((page_zonenum(page) != ZONE_DEVICE) ||
+		!(page->pgmap->flags & MEMORY_DEVICE_UNADDRESSABLE));
+}
 #else
 static inline void *devm_memremap_pages(struct device *dev,
 		struct resource *res, struct percpu_ref *ref,
@@ -90,6 +103,11 @@ static inline bool dev_page_allow_migrat
 {
 	return false;
 }
+
+static inline bool is_addressable_page(const struct page *page)
+{
+	return true;
+}
 #endif
 
 /**
diff -puN include/linux/swap.h~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3 include/linux/swap.h
--- a/include/linux/swap.h~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3
+++ a/include/linux/swap.h
@@ -51,6 +51,17 @@ static inline int current_is_kswapd(void
  */
 
 /*
+ * Un-addressable device memory support
+ */
+#ifdef CONFIG_DEVICE_UNADDRESSABLE
+#define SWP_DEVICE_NUM 2
+#define SWP_DEVICE_WRITE (MAX_SWAPFILES + SWP_HWPOISON_NUM + SWP_MIGRATION_NUM)
+#define SWP_DEVICE (MAX_SWAPFILES + SWP_HWPOISON_NUM + SWP_MIGRATION_NUM + 1)
+#else
+#define SWP_DEVICE_NUM 0
+#endif
+
+/*
  * NUMA node memory migration support
  */
 #ifdef CONFIG_MIGRATION
@@ -72,7 +83,8 @@ static inline int current_is_kswapd(void
 #endif
 
 #define MAX_SWAPFILES \
-	((1 << MAX_SWAPFILES_SHIFT) - SWP_MIGRATION_NUM - SWP_HWPOISON_NUM)
+	((1 << MAX_SWAPFILES_SHIFT) - SWP_DEVICE_NUM - \
+	SWP_MIGRATION_NUM - SWP_HWPOISON_NUM)
 
 /*
  * Magic header for a swap area. The first part of the union is
@@ -435,8 +447,8 @@ static inline void show_swap_cache_info(
 {
 }
 
-#define free_swap_and_cache(swp)	is_migration_entry(swp)
-#define swapcache_prepare(swp)		is_migration_entry(swp)
+#define free_swap_and_cache(e) (is_migration_entry(e) || is_device_entry(e))
+#define swapcache_prepare(e) (is_migration_entry(e) || is_device_entry(e))
 
 static inline int add_swap_count_continuation(swp_entry_t swp, gfp_t gfp_mask)
 {
diff -puN include/linux/swapops.h~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3 include/linux/swapops.h
--- a/include/linux/swapops.h~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3
+++ a/include/linux/swapops.h
@@ -100,6 +100,73 @@ static inline void *swp_to_radix_entry(s
 	return (void *)(value | RADIX_TREE_EXCEPTIONAL_ENTRY);
 }
 
+#if IS_ENABLED(CONFIG_DEVICE_UNADDRESSABLE)
+static inline swp_entry_t make_device_entry(struct page *page, bool write)
+{
+	return swp_entry(write?SWP_DEVICE_WRITE:SWP_DEVICE, page_to_pfn(page));
+}
+
+static inline bool is_device_entry(swp_entry_t entry)
+{
+	int type = swp_type(entry);
+	return type == SWP_DEVICE || type == SWP_DEVICE_WRITE;
+}
+
+static inline void make_device_entry_read(swp_entry_t *entry)
+{
+	*entry = swp_entry(SWP_DEVICE, swp_offset(*entry));
+}
+
+static inline bool is_write_device_entry(swp_entry_t entry)
+{
+	return unlikely(swp_type(entry) == SWP_DEVICE_WRITE);
+}
+
+static inline struct page *device_entry_to_page(swp_entry_t entry)
+{
+	return pfn_to_page(swp_offset(entry));
+}
+
+int device_entry_fault(struct vm_area_struct *vma,
+		       unsigned long addr,
+		       swp_entry_t entry,
+		       unsigned flags,
+		       pmd_t *pmdp);
+#else /* CONFIG_DEVICE_UNADDRESSABLE */
+static inline swp_entry_t make_device_entry(struct page *page, bool write)
+{
+	return swp_entry(0, 0);
+}
+
+static inline void make_device_entry_read(swp_entry_t *entry)
+{
+}
+
+static inline bool is_device_entry(swp_entry_t entry)
+{
+	return false;
+}
+
+static inline bool is_write_device_entry(swp_entry_t entry)
+{
+	return false;
+}
+
+static inline struct page *device_entry_to_page(swp_entry_t entry)
+{
+	return NULL;
+}
+
+static inline int device_entry_fault(struct vm_area_struct *vma,
+				     unsigned long addr,
+				     swp_entry_t entry,
+				     unsigned flags,
+				     pmd_t *pmdp)
+{
+	return VM_FAULT_SIGBUS;
+}
+#endif /* CONFIG_DEVICE_UNADDRESSABLE */
+
 #ifdef CONFIG_MIGRATION
 static inline swp_entry_t make_migration_entry(struct page *page, int write)
 {
diff -puN kernel/memremap.c~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3 kernel/memremap.c
--- a/kernel/memremap.c~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3
+++ a/kernel/memremap.c
@@ -18,6 +18,8 @@
 #include <linux/io.h>
 #include <linux/mm.h>
 #include <linux/memory_hotplug.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
 
 #ifndef ioremap_cache
 /* temporary while we convert existing ioremap_cache users to memremap */
@@ -203,6 +205,21 @@ void put_zone_device_page(struct page *p
 }
 EXPORT_SYMBOL(put_zone_device_page);
 
+#if IS_ENABLED(CONFIG_DEVICE_UNADDRESSABLE)
+int device_entry_fault(struct vm_area_struct *vma,
+		       unsigned long addr,
+		       swp_entry_t entry,
+		       unsigned flags,
+		       pmd_t *pmdp)
+{
+	struct page *page = device_entry_to_page(entry);
+
+	BUG_ON(!page->pgmap->page_fault);
+	return page->pgmap->page_fault(vma, addr, page, flags, pmdp);
+}
+EXPORT_SYMBOL(device_entry_fault);
+#endif /* CONFIG_DEVICE_UNADDRESSABLE */
+
 static void pgmap_radix_release(struct resource *res)
 {
 	resource_size_t key, align_start, align_size, align_end;
@@ -257,7 +274,7 @@ static void devm_memremap_pages_release(
 	align_size = ALIGN(resource_size(res), SECTION_SIZE);
 
 	mem_hotplug_begin();
-	arch_remove_memory(align_start, align_size, MEMORY_DEVICE);
+	arch_remove_memory(align_start, align_size, pgmap->flags);
 	mem_hotplug_done();
 
 	untrack_pfn(NULL, PHYS_PFN(align_start), align_size);
@@ -336,6 +353,7 @@ void *devm_memremap_pages(struct device
 	pgmap->ref = ref;
 	pgmap->res = &page_map->res;
 	pgmap->flags = MEMORY_DEVICE;
+	pgmap->page_fault = NULL;
 	pgmap->page_free = NULL;
 	pgmap->data = NULL;
 
@@ -375,7 +393,7 @@ void *devm_memremap_pages(struct device
 		goto err_pfn_remap;
 
 	mem_hotplug_begin();
-	error = arch_add_memory(nid, align_start, align_size, MEMORY_DEVICE);
+	error = arch_add_memory(nid, align_start, align_size, pgmap->flags);
 	mem_hotplug_done();
 	if (error)
 		goto err_add_memory;
diff -puN mm/Kconfig~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3 mm/Kconfig
--- a/mm/Kconfig~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3
+++ a/mm/Kconfig
@@ -700,6 +700,18 @@ config ZONE_DEVICE
 
 	  If FS_DAX is enabled, then say Y.
 
+config DEVICE_UNADDRESSABLE
+	bool "Un-addressable device memory (GPU memory, ...)"
+	depends on ZONE_DEVICE
+
+	help
+	  Allow to create struct page for un-addressable device memory
+	  ie memory that is only accessible by the device (or group of
+	  devices).
+
+	  Having struct page is necessary for process memory migration
+	  to device memory.
+
 config FRAME_VECTOR
 	bool
 
diff -puN mm/memory.c~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3 mm/memory.c
--- a/mm/memory.c~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3
+++ a/mm/memory.c
@@ -49,6 +49,7 @@
 #include <linux/swap.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
+#include <linux/memremap.h>
 #include <linux/ksm.h>
 #include <linux/rmap.h>
 #include <linux/export.h>
@@ -927,6 +928,25 @@ copy_one_pte(struct mm_struct *dst_mm, s
 					pte = pte_swp_mksoft_dirty(pte);
 				set_pte_at(src_mm, addr, src_pte, pte);
 			}
+		} else if (is_device_entry(entry)) {
+			page = device_entry_to_page(entry);
+
+			/*
+			 * Update rss count even for un-addressable page as
+			 * they should be consider just like any other page.
+			 */
+			get_page(page);
+			rss[mm_counter(page)]++;
+			page_dup_rmap(page, false);
+
+			if (is_write_device_entry(entry) &&
+			    is_cow_mapping(vm_flags)) {
+				make_device_entry_read(&entry);
+				pte = swp_entry_to_pte(entry);
+				if (pte_swp_soft_dirty(*src_pte))
+					pte = pte_swp_mksoft_dirty(pte);
+				set_pte_at(src_mm, addr, src_pte, pte);
+			}
 		}
 		goto out_set_pte;
 	}
@@ -1243,6 +1263,34 @@ again:
 			}
 			continue;
 		}
+
+		/*
+		 * Un-addressable page must always be check that are not like
+		 * other swap entries and thus should be check no matter what
+		 * details->check_swap_entries value is.
+		 */
+		entry = pte_to_swp_entry(ptent);
+		if (non_swap_entry(entry) && is_device_entry(entry)) {
+			struct page *page = device_entry_to_page(entry);
+
+			if (unlikely(details && details->check_mapping)) {
+				/*
+				 * unmap_shared_mapping_pages() wants to
+				 * invalidate cache without truncating:
+				 * unmap shared but keep private pages.
+				 */
+				if (details->check_mapping !=
+				    page_rmapping(page))
+					continue;
+			}
+
+			pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
+			rss[mm_counter(page)]--;
+			page_remove_rmap(page, false);
+			put_page(page);
+			continue;
+		}
+
 		/* If details->check_mapping, we leave swap entries. */
 		if (unlikely(details))
 			continue;
@@ -2690,6 +2738,14 @@ int do_swap_page(struct vm_fault *vmf)
 		if (is_migration_entry(entry)) {
 			migration_entry_wait(vma->vm_mm, vmf->pmd,
 					     vmf->address);
+		} else if (is_device_entry(entry)) {
+			/*
+			 * For un-addressable device memory we call the pgmap
+			 * fault handler callback. The callback must migrate
+			 * the page back to some CPU accessible page.
+			 */
+			ret = device_entry_fault(vma, vmf->address, entry,
+						 vmf->flags, vmf->pmd);
 		} else if (is_hwpoison_entry(entry)) {
 			ret = VM_FAULT_HWPOISON;
 		} else {
@@ -3679,6 +3735,7 @@ static int wp_huge_pud(struct vm_fault *
 static int handle_pte_fault(struct vm_fault *vmf)
 {
 	pte_t entry;
+	struct page *page;
 
 	if (unlikely(pmd_none(*vmf->pmd))) {
 		/*
@@ -3729,9 +3786,16 @@ static int handle_pte_fault(struct vm_fa
 	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma))
 		return do_numa_page(vmf);
 
+	/* Catch mapping of un-addressable memory this should never happen */
+	entry = vmf->orig_pte;
+	page = pfn_to_page(pte_pfn(entry));
+	if (!is_addressable_page(page)) {
+		print_bad_pte(vmf->vma, vmf->address, entry, page);
+		return VM_FAULT_SIGBUS;
+	}
+
 	vmf->ptl = pte_lockptr(vmf->vma->vm_mm, vmf->pmd);
 	spin_lock(vmf->ptl);
-	entry = vmf->orig_pte;
 	if (unlikely(!pte_same(*vmf->pte, entry)))
 		goto unlock;
 	if (vmf->flags & FAULT_FLAG_WRITE) {
diff -puN mm/memory_hotplug.c~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3 mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3
+++ a/mm/memory_hotplug.c
@@ -156,7 +156,7 @@ void mem_hotplug_done(void)
 /* add this memory to iomem resource */
 static struct resource *register_memory_resource(u64 start, u64 size)
 {
-	struct resource *res;
+	struct resource *res, *conflict;
 	res = kzalloc(sizeof(struct resource), GFP_KERNEL);
 	if (!res)
 		return ERR_PTR(-ENOMEM);
@@ -165,7 +165,13 @@ static struct resource *register_memory_
 	res->start = start;
 	res->end = start + size - 1;
 	res->flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
-	if (request_resource(&iomem_resource, res) < 0) {
+	conflict =  request_resource_conflict(&iomem_resource, res);
+	if (conflict) {
+		if (conflict->desc == IORES_DESC_UNADDRESSABLE_MEMORY) {
+			pr_debug("Device un-addressable memory block "
+				 "memory hotplug at %#010llx !\n",
+				 (unsigned long long)start);
+		}
 		pr_debug("System RAM resource %pR cannot be added\n", res);
 		kfree(res);
 		return ERR_PTR(-EEXIST);
diff -puN mm/mprotect.c~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3 mm/mprotect.c
--- a/mm/mprotect.c~mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3
+++ a/mm/mprotect.c
@@ -126,6 +126,18 @@ static unsigned long change_pte_range(st
 
 				pages++;
 			}
+
+			if (is_write_device_entry(entry)) {
+				pte_t newpte;
+
+				make_device_entry_read(&entry);
+				newpte = swp_entry_to_pte(entry);
+				if (pte_swp_soft_dirty(oldpte))
+					newpte = pte_swp_mksoft_dirty(newpte);
+				set_pte_at(mm, addr, pte, newpte);
+
+				pages++;
+			}
 		}
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	arch_leave_lazy_mmu_mode();
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

