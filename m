From: akpm@linux-foundation.org
Subject: + mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v2.patch added
 to -mm tree
Date: Thu, 16 Mar 2017 13:52:01 -0700
Message-ID: <58cafaf1.qdGLNqJ5poi7H92R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52834 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752610AbdCPVDs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 17:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, SCheung@nvidia.com, ebaskakov@nvidia.com, jhubbard@nvidia.com, mhairgrove@nvidia.com, sgutti@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm/mirror: helper to snapshot CPU page table
has been added to the -mm tree.  Its filename is
     mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v2.patch

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
Subject: mm/hmm/mirror: helper to snapshot CPU page table

This does not use existing page table walker because we want to share same
code for our page fault handler.

Link: http://lkml.kernel.org/r/1489680335-6594-12-git-send-email-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Evgeny Baskakov <ebaskakov@nvidia.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Mark Hairgrove <mhairgrove@nvidia.com>
Signed-off-by: Sherry Cheung <SCheung@nvidia.com>
Signed-off-by: Subhash Gutti <sgutti@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hmm.h |   56 ++++++++-
 mm/hmm.c            |  257 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 311 insertions(+), 2 deletions(-)

diff -puN include/linux/hmm.h~mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v2 include/linux/hmm.h
--- a/include/linux/hmm.h~mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v2
+++ a/include/linux/hmm.h
@@ -86,13 +86,28 @@ struct hmm;
  *
  * Flags:
  * HMM_PFN_VALID: pfn is valid
+ * HMM_PFN_READ: read permission set
  * HMM_PFN_WRITE: CPU page table have the write permission set
+ * HMM_PFN_ERROR: corresponding CPU page table entry point to poisoned memory
+ * HMM_PFN_EMPTY: corresponding CPU page table entry is none (pte_none() true)
+ * HMM_PFN_DEVICE: this is device memory (ie a ZONE_DEVICE page)
+ * HMM_PFN_SPECIAL: corresponding CPU page table entry is special ie result of
+ *      vm_insert_pfn() or vm_insert_page() and thus should not be mirror by a
+ *      device (the entry will never have HMM_PFN_VALID set and the pfn value
+ *      is undefine)
+ * HMM_PFN_UNADDRESSABLE: unaddressable device memory (ZONE_DEVICE)
  */
 typedef unsigned long hmm_pfn_t;
 
 #define HMM_PFN_VALID (1 << 0)
-#define HMM_PFN_WRITE (1 << 1)
-#define HMM_PFN_SHIFT 2
+#define HMM_PFN_READ (1 << 1)
+#define HMM_PFN_WRITE (1 << 2)
+#define HMM_PFN_ERROR (1 << 3)
+#define HMM_PFN_EMPTY (1 << 4)
+#define HMM_PFN_DEVICE (1 << 5)
+#define HMM_PFN_SPECIAL (1 << 6)
+#define HMM_PFN_UNADDRESSABLE (1 << 7)
+#define HMM_PFN_SHIFT 8
 
 /*
  * hmm_pfn_to_page() - return struct page pointed to by a valid hmm_pfn_t
@@ -239,6 +254,43 @@ int hmm_mirror_register(struct hmm_mirro
 int hmm_mirror_register_locked(struct hmm_mirror *mirror,
 			       struct mm_struct *mm);
 void hmm_mirror_unregister(struct hmm_mirror *mirror);
+
+
+/*
+ * struct hmm_range - track invalidation lock on virtual address range
+ *
+ * @list: all range lock are on a list
+ * @start: range virtual start address (inclusive)
+ * @end: range virtual end address (exclusive)
+ * @pfns: array of pfns (big enough for the range)
+ * @valid: pfns array did not change since it has been fill by an HMM function
+ */
+struct hmm_range {
+	struct list_head	list;
+	unsigned long		start;
+	unsigned long		end;
+	hmm_pfn_t		*pfns;
+	bool			valid;
+};
+
+/*
+ * To snapshot CPU page table call hmm_vma_get_pfns() then take device driver
+ * lock that serialize device page table update and call hmm_vma_range_done()
+ * to check if snapshot is still valid. The device driver page table update
+ * lock must also be use in the HMM mirror update() callback so that CPU page
+ * table invalidation serialize on it.
+ *
+ * YOU MUST CALL hmm_vma_range_dond() ONCE AND ONLY ONCE EACH TIME YOU CALL
+ * hmm_vma_get_pfns() WITHOUT ERROR !
+ *
+ * IF YOU DO NOT FOLLOW THE ABOVE RULE THE SNAPSHOT CONTENT MIGHT BE INVALID !
+ */
+int hmm_vma_get_pfns(struct vm_area_struct *vma,
+		     struct hmm_range *range,
+		     unsigned long start,
+		     unsigned long end,
+		     hmm_pfn_t *pfns);
+bool hmm_vma_range_done(struct vm_area_struct *vma, struct hmm_range *range);
 #endif /* IS_ENABLED(CONFIG_HMM_MIRROR) */
 
 
diff -puN mm/hmm.c~mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v2 mm/hmm.c
--- a/mm/hmm.c~mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v2
+++ a/mm/hmm.c
@@ -19,10 +19,15 @@
  */
 #include <linux/mm.h>
 #include <linux/hmm.h>
+#include <linux/rmap.h>
+#include <linux/swap.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/swapops.h>
+#include <linux/hugetlb.h>
 #include <linux/mmu_notifier.h>
 
+
 /*
  * struct hmm - HMM per mm struct
  *
@@ -37,6 +42,7 @@
 struct hmm {
 	struct mm_struct	*mm;
 	spinlock_t		lock;
+	struct list_head	ranges;
 	struct list_head	mirrors;
 	atomic_t		sequence;
 	wait_queue_head_t	wait_queue;
@@ -65,6 +71,7 @@ static struct hmm *hmm_register(struct m
 		INIT_LIST_HEAD(&hmm->mirrors);
 		atomic_set(&hmm->sequence, 0);
 		hmm->mmu_notifier.ops = NULL;
+		INIT_LIST_HEAD(&hmm->ranges);
 		spin_lock_init(&hmm->lock);
 		hmm->mm = mm;
 
@@ -107,6 +114,22 @@ static void hmm_invalidate_range(struct
 				 unsigned long end)
 {
 	struct hmm_mirror *mirror;
+	struct hmm_range *range;
+
+	spin_lock(&hmm->lock);
+	list_for_each_entry(range, &hmm->ranges, list) {
+		unsigned long addr, idx, npages;
+
+		if (end < range->start || start >= range->end)
+			continue;
+
+		range->valid = false;
+		addr = max(start, range->start);
+		idx = (addr - range->start) >> PAGE_SHIFT;
+		npages = (min(range->end, end) - addr) >> PAGE_SHIFT;
+		memset(&range->pfns[idx], 0, sizeof(*range->pfns) * npages);
+	}
+	spin_unlock(&hmm->lock);
 
 	/*
 	 * Mirror being added or removed is a rare event so list traversal isn't
@@ -264,4 +287,238 @@ void hmm_mirror_unregister(struct hmm_mi
 	wait_event(hmm->wait_queue, !atomic_read(&hmm->notifier_count));
 }
 EXPORT_SYMBOL(hmm_mirror_unregister);
+
+static void hmm_pfns_empty(hmm_pfn_t *pfns,
+			   unsigned long addr,
+			   unsigned long end)
+{
+	for (; addr < end; addr += PAGE_SIZE, pfns++)
+		*pfns = HMM_PFN_EMPTY;
+}
+
+static void hmm_pfns_special(hmm_pfn_t *pfns,
+			     unsigned long addr,
+			     unsigned long end)
+{
+	for (; addr < end; addr += PAGE_SIZE, pfns++)
+		*pfns = HMM_PFN_SPECIAL;
+}
+
+static void hmm_vma_walk(struct vm_area_struct *vma,
+			 unsigned long start,
+			 unsigned long end,
+			 hmm_pfn_t *pfns)
+{
+	unsigned long addr, next;
+	hmm_pfn_t flag;
+
+	flag = vma->vm_flags & VM_READ ? HMM_PFN_READ : 0;
+
+	for (addr = start; addr < end; addr = next) {
+		unsigned long i = (addr - start) >> PAGE_SHIFT;
+		pgd_t *pgdp;
+		pud_t *pudp;
+		pmd_t *pmdp;
+		pte_t *ptep;
+		pmd_t pmd;
+
+		/*
+		 * We are accessing/faulting for a device from an unknown
+		 * thread that might be foreign to the mm we are faulting
+		 * against so do not call arch_vma_access_permitted() !
+		 */
+
+		next = pgd_addr_end(addr, end);
+		pgdp = pgd_offset(vma->vm_mm, addr);
+		if (pgd_none(*pgdp) || pgd_bad(*pgdp)) {
+			hmm_pfns_empty(&pfns[i], addr, next);
+			continue;
+		}
+
+		next = pud_addr_end(addr, end);
+		pudp = pud_offset(pgdp, addr);
+		if (pud_none(*pudp) || pud_bad(*pudp)) {
+			hmm_pfns_empty(&pfns[i], addr, next);
+			continue;
+		}
+
+		next = pmd_addr_end(addr, end);
+		pmdp = pmd_offset(pudp, addr);
+		pmd = pmd_read_atomic(pmdp);
+		barrier();
+		if (pmd_none(pmd) || pmd_bad(pmd)) {
+			hmm_pfns_empty(&pfns[i], addr, next);
+			continue;
+		}
+		if (pmd_trans_huge(pmd) || pmd_devmap(pmd)) {
+			unsigned long pfn = pmd_pfn(pmd) + pte_index(addr);
+			hmm_pfn_t flags = flag;
+
+			if (pmd_protnone(pmd)) {
+				hmm_pfns_clear(&pfns[i], addr, next);
+				continue;
+			}
+			flags |= pmd_write(*pmdp) ? HMM_PFN_WRITE : 0;
+			flags |= pmd_devmap(pmd) ? HMM_PFN_DEVICE : 0;
+			for (; addr < next; addr += PAGE_SIZE, i++, pfn++)
+				pfns[i] = hmm_pfn_from_pfn(pfn) | flags;
+			continue;
+		}
+
+		ptep = pte_offset_map(pmdp, addr);
+		for (; addr < next; addr += PAGE_SIZE, i++, ptep++) {
+			swp_entry_t entry;
+			pte_t pte = *ptep;
+
+			pfns[i] = 0;
+
+			if (pte_none(pte)) {
+				pfns[i] = HMM_PFN_EMPTY;
+				continue;
+			}
+
+			entry = pte_to_swp_entry(pte);
+			if (!pte_present(pte) && !non_swap_entry(entry)) {
+				continue;
+			}
+
+			if (pte_present(pte)) {
+				pfns[i] = hmm_pfn_from_pfn(pte_pfn(pte))|flag;
+				pfns[i] |= pte_write(pte) ? HMM_PFN_WRITE : 0;
+				continue;
+			}
+
+			/*
+			 * This is a special swap entry, ignore migration, use
+			 * device and report anything else as error.
+			*/
+			if (is_device_entry(entry)) {
+				pfns[i] = hmm_pfn_from_pfn(swp_offset(entry));
+				if (is_write_device_entry(entry))
+					pfns[i] |= HMM_PFN_WRITE;
+				pfns[i] |= HMM_PFN_DEVICE;
+				pfns[i] |= HMM_PFN_UNADDRESSABLE;
+				pfns[i] |= flag;
+			} else if (!is_migration_entry(entry)) {
+				pfns[i] = HMM_PFN_ERROR;
+			}
+		}
+		pte_unmap(ptep - 1);
+	}
+}
+
+/*
+ * hmm_vma_get_pfns() - snapshot CPU page table for a range of virtual address
+ * @vma: virtual memory area containing the virtual address range
+ * @range: use to track snapshot validity
+ * @start: range virtual start address (inclusive)
+ * @end: range virtual end address (exclusive)
+ * @entries: array of hmm_pfn_t provided by caller fill by function
+ * Returns: -EINVAL if invalid argument, -ENOMEM out of memory, 0 success
+ *
+ * This snapshot the CPU page table for a range of virtual address, snapshot
+ * validity is track by the range struct see hmm_vma_range_done() for further
+ * informations.
+ *
+ * The range struct is initialized and track CPU page table only if function
+ * returns success (0) then you must call hmm_vma_range_done() to stop range
+ * CPU page table update tracking.
+ *
+ * NOT CALLING hmm_vma_range_done() IF FUNCTION RETURNS 0 WILL LEAD TO SERIOUS
+ * MEMORY CORRUPTION ! YOU HAVE BEEN WARN !
+ */
+int hmm_vma_get_pfns(struct vm_area_struct *vma,
+		     struct hmm_range *range,
+		     unsigned long start,
+		     unsigned long end,
+		     hmm_pfn_t *pfns)
+{
+	struct hmm *hmm;
+
+	/* FIXME support hugetlb fs */
+	if (is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_SPECIAL)) {
+		hmm_pfns_special(pfns, start, end);
+		return -EINVAL;
+	}
+
+	/* Sanity check, this really should not happen ! */
+	if (start < vma->vm_start || start >= vma->vm_end)
+		return -EINVAL;
+	if (end < vma->vm_start || end > vma->vm_end)
+		return -EINVAL;
+
+	hmm = hmm_register(vma->vm_mm);
+	if (!hmm)
+		return -ENOMEM;
+	/* Caller must have register a mirror (with hmm_mirror_register()) ! */
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
+	hmm_vma_walk(vma, start, end, pfns);
+	return 0;
+}
+EXPORT_SYMBOL(hmm_vma_get_pfns);
+
+/*
+ * hmm_vma_range_done() - stop tracking change to CPU page table over a range
+ * @vma: virtual memory area containing the virtual address range
+ * @range: range being track
+ * Returns: false if range data have been invalidated, true otherwise
+ *
+ * Range struct is use to track update to CPU page table after call to
+ * hmm_vma_get_pfns(). Once device driver is done using or want to lock update
+ * to data it gots from this function it calls hmm_vma_range_done() which stop
+ * the tracking.
+ *
+ * There is 2 way to use this :
+ * again:
+ *   hmm_vma_get_pfns(vma, range, start, end, pfns);
+ *   trans = device_build_page_table_update_transaction(pfns);
+ *   device_page_table_lock();
+ *   if (!hmm_vma_range_done(vma, range)) {
+ *     device_page_table_unlock();
+ *     goto again;
+ *   }
+ *   device_commit_transaction(trans);
+ *   device_page_table_unlock();
+ *
+ * Or:
+ *   hmm_vma_get_pfns(vma, range, start, end, pfns);
+ *   device_page_table_lock();
+ *   hmm_vma_range_done(vma, range);
+ *   device_update_page_table(pfns);
+ *   device_page_table_unlock();
+ */
+bool hmm_vma_range_done(struct vm_area_struct *vma, struct hmm_range *range)
+{
+	unsigned long npages = (range->end - range->start) >> PAGE_SHIFT;
+	struct hmm *hmm;
+
+	if (range->end <= range->start) {
+		BUG();
+		return false;
+	}
+
+	hmm = hmm_register(vma->vm_mm);
+	if (!hmm) {
+		memset(range->pfns, 0, sizeof(*range->pfns) * npages);
+		return false;
+	}
+
+	spin_lock(&hmm->lock);
+	list_del_rcu(&range->list);
+	spin_unlock(&hmm->lock);
+
+	return range->valid;
+}
+EXPORT_SYMBOL(hmm_vma_range_done);
 #endif /* IS_ENABLED(CONFIG_HMM_MIRROR) */
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

