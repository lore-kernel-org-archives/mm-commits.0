From: akpm@linux-foundation.org
Subject: + mm-hmm-mirror-device-page-fault-handler.patch added to -mm tree
Date: Thu, 17 Aug 2017 14:41:41 -0700
Message-ID: <59960d95.S7FPALWjoCkwjr/4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40458 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753753AbdHQVln (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Aug 2017 17:41:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, SCheung@nvidia.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, bsingharora@gmail.com, dan.j.williams@intel.com, dnellans@nvidia.com, ebaskakov@nvidia.com, hannes@cmpxchg.org, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mhairgrove@nvidia.com, mhocko@kernel.org, paulmck@linux.vnet.ibm.com, ross.zwisler@linux.intel.com, sgutti@nvidia.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm/mirror: device page fault handler
has been added to the -mm tree.  Its filename is
     mm-hmm-mirror-device-page-fault-handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-mirror-device-page-fault-handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-mirror-device-page-fault-handler.patch

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
Subject: mm/hmm/mirror: device page fault handler

This handles page fault on behalf of device driver, unlike
handle_mm_fault() it does not trigger migration back to system memory for
device memory.

Link: http://lkml.kernel.org/r/20170817000548.32038-6-jglisse@redhat.com
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

 include/linux/hmm.h |   27 ++++
 mm/hmm.c            |  256 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 271 insertions(+), 12 deletions(-)

diff -puN include/linux/hmm.h~mm-hmm-mirror-device-page-fault-handler include/linux/hmm.h
--- a/include/linux/hmm.h~mm-hmm-mirror-device-page-fault-handler
+++ a/include/linux/hmm.h
@@ -292,6 +292,33 @@ int hmm_vma_get_pfns(struct vm_area_stru
 		     unsigned long end,
 		     hmm_pfn_t *pfns);
 bool hmm_vma_range_done(struct vm_area_struct *vma, struct hmm_range *range);
+
+
+/*
+ * Fault memory on behalf of device driver. Unlike handle_mm_fault(), this will
+ * not migrate any device memory back to system memory. The hmm_pfn_t array will
+ * be updated with the fault result and current snapshot of the CPU page table
+ * for the range.
+ *
+ * The mmap_sem must be taken in read mode before entering and it might be
+ * dropped by the function if the block argument is false. In that case, the
+ * function returns -EAGAIN.
+ *
+ * Return value does not reflect if the fault was successful for every single
+ * address or not. Therefore, the caller must to inspect the hmm_pfn_t array to
+ * determine fault status for each address.
+ *
+ * Trying to fault inside an invalid vma will result in -EINVAL.
+ *
+ * See the function description in mm/hmm.c for further documentation.
+ */
+int hmm_vma_fault(struct vm_area_struct *vma,
+		  struct hmm_range *range,
+		  unsigned long start,
+		  unsigned long end,
+		  hmm_pfn_t *pfns,
+		  bool write,
+		  bool block);
 #endif /* IS_ENABLED(CONFIG_HMM_MIRROR) */
 
 
diff -puN mm/hmm.c~mm-hmm-mirror-device-page-fault-handler mm/hmm.c
--- a/mm/hmm.c~mm-hmm-mirror-device-page-fault-handler
+++ a/mm/hmm.c
@@ -236,6 +236,36 @@ void hmm_mirror_unregister(struct hmm_mi
 }
 EXPORT_SYMBOL(hmm_mirror_unregister);
 
+struct hmm_vma_walk {
+	struct hmm_range	*range;
+	unsigned long		last;
+	bool			fault;
+	bool			block;
+	bool			write;
+};
+
+static int hmm_vma_do_fault(struct mm_walk *walk,
+			    unsigned long addr,
+			    hmm_pfn_t *pfn)
+{
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_REMOTE;
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct vm_area_struct *vma = walk->vma;
+	int r;
+
+	flags |= hmm_vma_walk->block ? 0 : FAULT_FLAG_ALLOW_RETRY;
+	flags |= hmm_vma_walk->write ? FAULT_FLAG_WRITE : 0;
+	r = handle_mm_fault(vma, addr, flags);
+	if (r & VM_FAULT_RETRY)
+		return -EBUSY;
+	if (r & VM_FAULT_ERROR) {
+		*pfn = HMM_PFN_ERROR;
+		return -EFAULT;
+	}
+
+	return -EAGAIN;
+}
+
 static void hmm_pfns_special(hmm_pfn_t *pfns,
 			     unsigned long addr,
 			     unsigned long end)
@@ -259,34 +289,62 @@ static int hmm_pfns_bad(unsigned long ad
 	return 0;
 }
 
+static void hmm_pfns_clear(hmm_pfn_t *pfns,
+			   unsigned long addr,
+			   unsigned long end)
+{
+	for (; addr < end; addr += PAGE_SIZE, pfns++)
+		*pfns = 0;
+}
+
 static int hmm_vma_walk_hole(unsigned long addr,
 			     unsigned long end,
 			     struct mm_walk *walk)
 {
-	struct hmm_range *range = walk->private;
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct hmm_range *range = hmm_vma_walk->range;
 	hmm_pfn_t *pfns = range->pfns;
 	unsigned long i;
 
+	hmm_vma_walk->last = addr;
 	i = (addr - range->start) >> PAGE_SHIFT;
-	for (; addr < end; addr += PAGE_SIZE, i++)
+	for (; addr < end; addr += PAGE_SIZE, i++) {
 		pfns[i] = HMM_PFN_EMPTY;
+		if (hmm_vma_walk->fault) {
+			int ret;
 
-	return 0;
+			ret = hmm_vma_do_fault(walk, addr, &pfns[i]);
+			if (ret != -EAGAIN)
+				return ret;
+		}
+	}
+
+	return hmm_vma_walk->fault ? -EAGAIN : 0;
 }
 
 static int hmm_vma_walk_clear(unsigned long addr,
 			      unsigned long end,
 			      struct mm_walk *walk)
 {
-	struct hmm_range *range = walk->private;
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct hmm_range *range = hmm_vma_walk->range;
 	hmm_pfn_t *pfns = range->pfns;
 	unsigned long i;
 
+	hmm_vma_walk->last = addr;
 	i = (addr - range->start) >> PAGE_SHIFT;
-	for (; addr < end; addr += PAGE_SIZE, i++)
+	for (; addr < end; addr += PAGE_SIZE, i++) {
 		pfns[i] = 0;
+		if (hmm_vma_walk->fault) {
+			int ret;
 
-	return 0;
+			ret = hmm_vma_do_fault(walk, addr, &pfns[i]);
+			if (ret != -EAGAIN)
+				return ret;
+		}
+	}
+
+	return hmm_vma_walk->fault ? -EAGAIN : 0;
 }
 
 static int hmm_vma_walk_pmd(pmd_t *pmdp,
@@ -294,15 +352,18 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 			    unsigned long end,
 			    struct mm_walk *walk)
 {
-	struct hmm_range *range = walk->private;
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct hmm_range *range = hmm_vma_walk->range;
 	struct vm_area_struct *vma = walk->vma;
 	hmm_pfn_t *pfns = range->pfns;
 	unsigned long addr = start, i;
+	bool write_fault;
 	hmm_pfn_t flag;
 	pte_t *ptep;
 
 	i = (addr - range->start) >> PAGE_SHIFT;
 	flag = vma->vm_flags & VM_READ ? HMM_PFN_READ : 0;
+	write_fault = hmm_vma_walk->fault & hmm_vma_walk->write;
 
 again:
 	if (pmd_none(*pmdp))
@@ -331,6 +392,9 @@ again:
 		if (pmd_protnone(pmd))
 			return hmm_vma_walk_clear(start, end, walk);
 
+		if (write_fault && !pmd_write(pmd))
+			return hmm_vma_walk_clear(start, end, walk);
+
 		pfn = pmd_pfn(pmd) + pte_index(addr);
 		flag |= pmd_write(pmd) ? HMM_PFN_WRITE : 0;
 		for (; addr < end; addr += PAGE_SIZE, i++, pfn++)
@@ -347,13 +411,55 @@ again:
 
 		pfns[i] = 0;
 
-		if (pte_none(pte) || !pte_present(pte)) {
+		if (pte_none(pte)) {
 			pfns[i] = HMM_PFN_EMPTY;
+			if (hmm_vma_walk->fault)
+				goto fault;
 			continue;
 		}
 
+		if (!pte_present(pte)) {
+			swp_entry_t entry;
+
+			if (!non_swap_entry(entry)) {
+				if (hmm_vma_walk->fault)
+					goto fault;
+				continue;
+			}
+
+			entry = pte_to_swp_entry(pte);
+
+			/*
+			 * This is a special swap entry, ignore migration, use
+			 * device and report anything else as error.
+			 */
+			if (is_migration_entry(entry)) {
+				if (hmm_vma_walk->fault) {
+					pte_unmap(ptep);
+					hmm_vma_walk->last = addr;
+					migration_entry_wait(vma->vm_mm,
+							     pmdp, addr);
+					return -EAGAIN;
+				}
+				continue;
+			} else {
+				/* Report error for everything else */
+				pfns[i] = HMM_PFN_ERROR;
+			}
+			continue;
+		}
+
+		if (write_fault && !pte_write(pte))
+			goto fault;
+
 		pfns[i] = hmm_pfn_t_from_pfn(pte_pfn(pte)) | flag;
 		pfns[i] |= pte_write(pte) ? HMM_PFN_WRITE : 0;
+		continue;
+
+fault:
+		pte_unmap(ptep);
+		/* Fault all pages in range */
+		return hmm_vma_walk_clear(start, end, walk);
 	}
 	pte_unmap(ptep - 1);
 
@@ -386,6 +492,7 @@ int hmm_vma_get_pfns(struct vm_area_stru
 		     unsigned long end,
 		     hmm_pfn_t *pfns)
 {
+	struct hmm_vma_walk hmm_vma_walk;
 	struct mm_walk mm_walk;
 	struct hmm *hmm;
 
@@ -417,9 +524,12 @@ int hmm_vma_get_pfns(struct vm_area_stru
 	list_add_rcu(&range->list, &hmm->ranges);
 	spin_unlock(&hmm->lock);
 
+	hmm_vma_walk.fault = false;
+	hmm_vma_walk.range = range;
+	mm_walk.private = &hmm_vma_walk;
+
 	mm_walk.vma = vma;
 	mm_walk.mm = vma->vm_mm;
-	mm_walk.private = range;
 	mm_walk.pte_entry = NULL;
 	mm_walk.test_walk = NULL;
 	mm_walk.hugetlb_entry = NULL;
@@ -427,7 +537,6 @@ int hmm_vma_get_pfns(struct vm_area_stru
 	mm_walk.pte_hole = hmm_vma_walk_hole;
 
 	walk_page_range(start, end, &mm_walk);
-
 	return 0;
 }
 EXPORT_SYMBOL(hmm_vma_get_pfns);
@@ -454,7 +563,7 @@ EXPORT_SYMBOL(hmm_vma_get_pfns);
  *
  * There are two ways to use this :
  * again:
- *   hmm_vma_get_pfns(vma, range, start, end, pfns);
+ *   hmm_vma_get_pfns(vma, range, start, end, pfns); or hmm_vma_fault(...);
  *   trans = device_build_page_table_update_transaction(pfns);
  *   device_page_table_lock();
  *   if (!hmm_vma_range_done(vma, range)) {
@@ -465,7 +574,7 @@ EXPORT_SYMBOL(hmm_vma_get_pfns);
  *   device_page_table_unlock();
  *
  * Or:
- *   hmm_vma_get_pfns(vma, range, start, end, pfns);
+ *   hmm_vma_get_pfns(vma, range, start, end, pfns); or hmm_vma_fault(...);
  *   device_page_table_lock();
  *   hmm_vma_range_done(vma, range);
  *   device_update_page_table(pfns);
@@ -494,4 +603,127 @@ bool hmm_vma_range_done(struct vm_area_s
 	return range->valid;
 }
 EXPORT_SYMBOL(hmm_vma_range_done);
+
+/*
+ * hmm_vma_fault() - try to fault some address in a virtual address range
+ * @vma: virtual memory area containing the virtual address range
+ * @range: use to track pfns array content validity
+ * @start: fault range virtual start address (inclusive)
+ * @end: fault range virtual end address (exclusive)
+ * @pfns: array of hmm_pfn_t, only entry with fault flag set will be faulted
+ * @write: is it a write fault
+ * @block: allow blocking on fault (if true it sleeps and do not drop mmap_sem)
+ * Returns: 0 success, error otherwise (-EAGAIN means mmap_sem have been drop)
+ *
+ * This is similar to a regular CPU page fault except that it will not trigger
+ * any memory migration if the memory being faulted is not accessible by CPUs.
+ *
+ * On error, for one virtual address in the range, the function will set the
+ * hmm_pfn_t error flag for the corresponding pfn entry.
+ *
+ * Expected use pattern:
+ * retry:
+ *   down_read(&mm->mmap_sem);
+ *   // Find vma and address device wants to fault, initialize hmm_pfn_t
+ *   // array accordingly
+ *   ret = hmm_vma_fault(vma, start, end, pfns, allow_retry);
+ *   switch (ret) {
+ *   case -EAGAIN:
+ *     hmm_vma_range_done(vma, range);
+ *     // You might want to rate limit or yield to play nicely, you may
+ *     // also commit any valid pfn in the array assuming that you are
+ *     // getting true from hmm_vma_range_monitor_end()
+ *     goto retry;
+ *   case 0:
+ *     break;
+ *   default:
+ *     // Handle error !
+ *     up_read(&mm->mmap_sem)
+ *     return;
+ *   }
+ *   // Take device driver lock that serialize device page table update
+ *   driver_lock_device_page_table_update();
+ *   hmm_vma_range_done(vma, range);
+ *   // Commit pfns we got from hmm_vma_fault()
+ *   driver_unlock_device_page_table_update();
+ *   up_read(&mm->mmap_sem)
+ *
+ * YOU MUST CALL hmm_vma_range_done() AFTER THIS FUNCTION RETURN SUCCESS (0)
+ * BEFORE FREEING THE range struct OR YOU WILL HAVE SERIOUS MEMORY CORRUPTION !
+ *
+ * YOU HAVE BEEN WARNED !
+ */
+int hmm_vma_fault(struct vm_area_struct *vma,
+		  struct hmm_range *range,
+		  unsigned long start,
+		  unsigned long end,
+		  hmm_pfn_t *pfns,
+		  bool write,
+		  bool block)
+{
+	struct hmm_vma_walk hmm_vma_walk;
+	struct mm_walk mm_walk;
+	struct hmm *hmm;
+	int ret;
+
+	/* Sanity check, this really should not happen ! */
+	if (start < vma->vm_start || start >= vma->vm_end)
+		return -EINVAL;
+	if (end < vma->vm_start || end > vma->vm_end)
+		return -EINVAL;
+
+	hmm = hmm_register(vma->vm_mm);
+	if (!hmm) {
+		hmm_pfns_clear(pfns, start, end);
+		return -ENOMEM;
+	}
+	/* Caller must have registered a mirror using hmm_mirror_register() */
+	if (!hmm->mmu_notifier.ops)
+		return -EINVAL;
+
+	/* Initialize range to track CPU page table update */
+	range->start = start;
+	range->pfns = pfns;
+	range->end = end;
+	spin_lock(&hmm->lock);
+	range->valid = true;
+	list_add_rcu(&range->list, &hmm->ranges);
+	spin_unlock(&hmm->lock);
+
+	/* FIXME support hugetlb fs */
+	if (is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_SPECIAL)) {
+		hmm_pfns_special(pfns, start, end);
+		return 0;
+	}
+
+	hmm_vma_walk.fault = true;
+	hmm_vma_walk.write = write;
+	hmm_vma_walk.block = block;
+	hmm_vma_walk.range = range;
+	mm_walk.private = &hmm_vma_walk;
+	hmm_vma_walk.last = range->start;
+
+	mm_walk.vma = vma;
+	mm_walk.mm = vma->vm_mm;
+	mm_walk.pte_entry = NULL;
+	mm_walk.test_walk = NULL;
+	mm_walk.hugetlb_entry = NULL;
+	mm_walk.pmd_entry = hmm_vma_walk_pmd;
+	mm_walk.pte_hole = hmm_vma_walk_hole;
+
+	do {
+		ret = walk_page_range(start, end, &mm_walk);
+		start = hmm_vma_walk.last;
+	} while (ret == -EAGAIN);
+
+	if (ret) {
+		unsigned long i;
+
+		i = (hmm_vma_walk.last - range->start) >> PAGE_SHIFT;
+		hmm_pfns_clear(&pfns[i], hmm_vma_walk.last, end);
+		hmm_vma_range_done(vma, range);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(hmm_vma_fault);
 #endif /* IS_ENABLED(CONFIG_HMM_MIRROR) */
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

