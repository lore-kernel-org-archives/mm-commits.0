Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 785DDC48BD1
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 22:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5629E61420
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 22:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhFJWSM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Jun 2021 18:18:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230426AbhFJWSL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 10 Jun 2021 18:18:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B40D661419;
        Thu, 10 Jun 2021 22:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623363375;
        bh=9G0A8ghYWWXnAb8U463QUnvO+Wh5qO+3BFzjY3e/hMI=;
        h=Date:From:To:Subject:From;
        b=fercSQ+i7vYB7WBFLxxPR1kLM1nOeYxrnRBmWK6qqgsYHGS4FXLXXkbGUHCvjDvU6
         HvYKO0gsRhJ7wiWvY5IyUcXXE+LsXGDgljkrvkK9iCF7HTBnN/P17lDUOSyVX10c7J
         GqTAL3c9LYyms3br2KipdZKTOGIRv+4M0MwXGphM=
Date:   Thu, 10 Jun 2021 15:16:14 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, bsingharora@gmail.com, bskeggs@redhat.com,
        hch@lst.de, hughd@google.com, jgg@nvidia.com, jglisse@redhat.com,
        jhubbard@nvidia.com, mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, willy@infradead.org
Subject:  [to-be-updated] mm-device-exclusive-memory-access.patch
 removed from -mm tree
Message-ID: <20210610221614.CA_vi1gw9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: device exclusive memory access
has been removed from the -mm tree.  Its filename was
     mm-device-exclusive-memory-access.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm: device exclusive memory access

Some devices require exclusive write access to shared virtual memory (SVM)
ranges to perform atomic operations on that memory.  This requires CPU
page tables to be updated to deny access whilst atomic operations are
occurring.

In order to do this introduce a new swap entry type
(SWP_DEVICE_EXCLUSIVE).  When a SVM range needs to be marked for exclusive
access by a device all page table mappings for the particular range are
replaced with device exclusive swap entries.  This causes any CPU access
to the page to result in a fault.

Faults are resovled by replacing the faulting entry with the original
mapping.  This results in MMU notifiers being called which a driver uses
to update access permissions such as revoking atomic access.  After
notifiers have been called the device will no longer have exclusive access
to the region.

Walking of the page tables to find the target pages is handled by
get_user_pages() rather than a direct page table walk.  A direct page
table walk similar to what migrate_vma_collect()/unmap() does could also
have been utilised.  However this resulted in more code similar in
functionality to what get_user_pages() provides as page faulting is
required to make the PTEs present and to break COW.

Link: https://lkml.kernel.org/r/20210524132725.12697-8-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hmm.rst     |   17 +++
 include/linux/mmu_notifier.h |    6 +
 include/linux/rmap.h         |    4 
 include/linux/swap.h         |    7 +
 include/linux/swapops.h      |   44 +++++++
 mm/hmm.c                     |    5 
 mm/memory.c                  |  128 ++++++++++++++++++++++
 mm/mprotect.c                |    8 +
 mm/page_vma_mapped.c         |    9 +
 mm/rmap.c                    |  186 +++++++++++++++++++++++++++++++++
 10 files changed, 405 insertions(+), 9 deletions(-)

--- a/Documentation/vm/hmm.rst~mm-device-exclusive-memory-access
+++ a/Documentation/vm/hmm.rst
@@ -405,6 +405,23 @@ between device driver specific code and
 
    The lock can now be released.
 
+Exclusive access memory
+=======================
+
+Some devices have features such as atomic PTE bits that can be used to implement
+atomic access to system memory. To support atomic operations to a shared virtual
+memory page such a device needs access to that page which is exclusive of any
+userspace access from the CPU. The ``make_device_exclusive_range()`` function
+can be used to make a memory range inaccessible from userspace.
+
+This replaces all mappings for pages in the given range with special swap
+entries. Any attempt to access the swap entry results in a fault which is
+resovled by replacing the entry with the original mapping. A driver gets
+notified that the mapping has been changed by MMU notifiers, after which point
+it will no longer have exclusive access to the page. Exclusive access is
+guranteed to last until the driver drops the page lock and page reference, at
+which point any CPU faults on the page may proceed as described.
+
 Memory cgroup (memcg) and rss accounting
 ========================================
 
--- a/include/linux/mmu_notifier.h~mm-device-exclusive-memory-access
+++ a/include/linux/mmu_notifier.h
@@ -42,6 +42,11 @@ struct mmu_interval_notifier;
  * @MMU_NOTIFY_MIGRATE: used during migrate_vma_collect() invalidate to signal
  * a device driver to possibly ignore the invalidation if the
  * owner field matches the driver's device private pgmap owner.
+ *
+ * @MMU_NOTIFY_EXCLUSIVE: to signal a device driver that the device will no
+ * longer have exclusive access to the page. May ignore the invalidation that's
+ * part of make_device_exclusive_range() if the owner field
+ * matches the value passed to make_device_exclusive_range().
  */
 enum mmu_notifier_event {
 	MMU_NOTIFY_UNMAP = 0,
@@ -51,6 +56,7 @@ enum mmu_notifier_event {
 	MMU_NOTIFY_SOFT_DIRTY,
 	MMU_NOTIFY_RELEASE,
 	MMU_NOTIFY_MIGRATE,
+	MMU_NOTIFY_EXCLUSIVE,
 };
 
 #define MMU_NOTIFIER_RANGE_BLOCKABLE (1 << 0)
--- a/include/linux/rmap.h~mm-device-exclusive-memory-access
+++ a/include/linux/rmap.h
@@ -193,6 +193,10 @@ int page_referenced(struct page *, int i
 bool try_to_migrate(struct page *page, enum ttu_flags flags);
 bool try_to_unmap(struct page *, enum ttu_flags flags);
 
+int make_device_exclusive_range(struct mm_struct *mm, unsigned long start,
+				unsigned long end, struct page **pages,
+				void *arg);
+
 /* Avoid racy checks */
 #define PVMW_SYNC		(1 << 0)
 /* Look for migarion entries rather than present PTEs */
--- a/include/linux/swap.h~mm-device-exclusive-memory-access
+++ a/include/linux/swap.h
@@ -63,11 +63,16 @@ static inline int current_is_kswapd(void
  *
  * When a page is migrated from CPU to device, we set the CPU page table entry
  * to a special SWP_DEVICE_* entry.
+ *
+ * When a page is mapped by the device for exclusive access we set the CPU page
+ * table entries to special SWP_DEVICE_EXCLUSIVE_* entries.
  */
 #ifdef CONFIG_DEVICE_PRIVATE
-#define SWP_DEVICE_NUM 2
+#define SWP_DEVICE_NUM 4
 #define SWP_DEVICE_WRITE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM)
 #define SWP_DEVICE_READ (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+1)
+#define SWP_DEVICE_EXCLUSIVE_WRITE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+2)
+#define SWP_DEVICE_EXCLUSIVE_READ (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+3)
 #else
 #define SWP_DEVICE_NUM 0
 #endif
--- a/include/linux/swapops.h~mm-device-exclusive-memory-access
+++ a/include/linux/swapops.h
@@ -127,6 +127,27 @@ static inline bool is_writable_device_pr
 {
 	return unlikely(swp_type(entry) == SWP_DEVICE_WRITE);
 }
+
+static inline swp_entry_t make_readable_device_exclusive_entry(pgoff_t offset)
+{
+	return swp_entry(SWP_DEVICE_EXCLUSIVE_READ, offset);
+}
+
+static inline swp_entry_t make_writable_device_exclusive_entry(pgoff_t offset)
+{
+	return swp_entry(SWP_DEVICE_EXCLUSIVE_WRITE, offset);
+}
+
+static inline bool is_device_exclusive_entry(swp_entry_t entry)
+{
+	return swp_type(entry) == SWP_DEVICE_EXCLUSIVE_READ ||
+		swp_type(entry) == SWP_DEVICE_EXCLUSIVE_WRITE;
+}
+
+static inline bool is_writable_device_exclusive_entry(swp_entry_t entry)
+{
+	return unlikely(swp_type(entry) == SWP_DEVICE_EXCLUSIVE_WRITE);
+}
 #else /* CONFIG_DEVICE_PRIVATE */
 static inline swp_entry_t make_readable_device_private_entry(pgoff_t offset)
 {
@@ -147,6 +168,26 @@ static inline bool is_writable_device_pr
 {
 	return false;
 }
+
+static inline swp_entry_t make_readable_device_exclusive_entry(pgoff_t offset)
+{
+	return swp_entry(0, 0);
+}
+
+static inline swp_entry_t make_writable_device_exclusive_entry(pgoff_t offset)
+{
+	return swp_entry(0, 0);
+}
+
+static inline bool is_device_exclusive_entry(swp_entry_t entry)
+{
+	return false;
+}
+
+static inline bool is_writable_device_exclusive_entry(swp_entry_t entry)
+{
+	return false;
+}
 #endif /* CONFIG_DEVICE_PRIVATE */
 
 #ifdef CONFIG_MIGRATION
@@ -226,7 +267,8 @@ static inline struct page *pfn_swap_entr
  */
 static inline bool is_pfn_swap_entry(swp_entry_t entry)
 {
-	return is_migration_entry(entry) || is_device_private_entry(entry);
+	return is_migration_entry(entry) || is_device_private_entry(entry) ||
+	       is_device_exclusive_entry(entry);
 }
 
 struct page_vma_mapped_walk;
--- a/mm/hmm.c~mm-device-exclusive-memory-access
+++ a/mm/hmm.c
@@ -26,6 +26,8 @@
 #include <linux/mmu_notifier.h>
 #include <linux/memory_hotplug.h>
 
+#include "internal.h"
+
 struct hmm_vma_walk {
 	struct hmm_range	*range;
 	unsigned long		last;
@@ -271,6 +273,9 @@ static int hmm_vma_handle_pte(struct mm_
 		if (!non_swap_entry(entry))
 			goto fault;
 
+		if (is_device_exclusive_entry(entry))
+			goto fault;
+
 		if (is_migration_entry(entry)) {
 			pte_unmap(ptep);
 			hmm_vma_walk->last = addr;
--- a/mm/memory.c~mm-device-exclusive-memory-access
+++ a/mm/memory.c
@@ -700,6 +700,68 @@ out:
 }
 #endif
 
+static void restore_exclusive_pte(struct vm_area_struct *vma,
+				  struct page *page, unsigned long address,
+				  pte_t *ptep)
+{
+	pte_t pte;
+	swp_entry_t entry;
+
+	pte = pte_mkold(mk_pte(page, READ_ONCE(vma->vm_page_prot)));
+	if (pte_swp_soft_dirty(*ptep))
+		pte = pte_mksoft_dirty(pte);
+
+	entry = pte_to_swp_entry(*ptep);
+	if (pte_swp_uffd_wp(*ptep))
+		pte = pte_mkuffd_wp(pte);
+	else if (is_writable_device_exclusive_entry(entry))
+		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
+
+	set_pte_at(vma->vm_mm, address, ptep, pte);
+
+	/*
+	 * No need to take a page reference as one was already
+	 * created when the swap entry was made.
+	 */
+	if (PageAnon(page))
+		page_add_anon_rmap(page, vma, address, false);
+	else
+		/*
+		 * Currently device exclusive access only supports anonymous
+		 * memory so the entry shouldn't point to a filebacked page.
+		 */
+		WARN_ON_ONCE(!PageAnon(page));
+
+	if (vma->vm_flags & VM_LOCKED)
+		mlock_vma_page(page);
+
+	/*
+	 * No need to invalidate - it was non-present before. However
+	 * secondary CPUs may have mappings that need invalidating.
+	 */
+	update_mmu_cache(vma, address, ptep);
+}
+
+/*
+ * Tries to restore an exclusive pte if the page lock can be acquired without
+ * sleeping.
+ */
+static unsigned long
+try_restore_exclusive_pte(struct mm_struct *src_mm, pte_t *src_pte,
+			  struct vm_area_struct *vma, unsigned long addr)
+{
+	swp_entry_t entry = pte_to_swp_entry(*src_pte);
+	struct page *page = pfn_swap_entry_to_page(entry);
+
+	if (trylock_page(page)) {
+		restore_exclusive_pte(vma, page, addr, src_pte);
+		unlock_page(page);
+		return 0;
+	}
+
+	return -EBUSY;
+}
+
 /*
  * copy one vm_area from one task to the other. Assumes the page tables
  * already present in the new task to be cleared in the whole range
@@ -781,6 +843,17 @@ copy_nonpresent_pte(struct mm_struct *ds
 				pte = pte_swp_mkuffd_wp(pte);
 			set_pte_at(src_mm, addr, src_pte, pte);
 		}
+	} else if (is_device_exclusive_entry(entry)) {
+		/*
+		 * Make device exclusive entries present by restoring the
+		 * original entry then copying as for a present pte. Device
+		 * exclusive entries currently only support private writable
+		 * (ie. COW) mappings.
+		 */
+		VM_BUG_ON(!is_cow_mapping(vma->vm_flags));
+		if (try_restore_exclusive_pte(src_mm, src_pte, vma, addr))
+			return -EBUSY;
+		return -ENOENT;
 	}
 	set_pte_at(dst_mm, addr, dst_pte, pte);
 	return 0;
@@ -980,9 +1053,18 @@ again:
 			if (ret == -EAGAIN) {
 				entry = pte_to_swp_entry(*src_pte);
 				break;
+			} else if (ret == -EBUSY) {
+				break;
+			} else if (!ret) {
+				progress += 8;
+				continue;
 			}
-			progress += 8;
-			continue;
+
+			/*
+			 * Device exclusive entry restored, continue by copying
+			 * the now present pte.
+			 */
+			WARN_ON_ONCE(ret != -ENOENT);
 		}
 		/* copy_present_pte() will clear `*prealloc' if consumed */
 		ret = copy_present_pte(dst_vma, src_vma, dst_pte, src_pte,
@@ -1019,6 +1101,8 @@ again:
 			goto out;
 		}
 		entry.val = 0;
+	} else if (ret == -EBUSY) {
+		return -EBUSY;
 	} else if (ret) {
 		WARN_ON_ONCE(ret != -EAGAIN);
 		prealloc = page_copy_prealloc(src_mm, src_vma, addr);
@@ -1283,7 +1367,8 @@ again:
 		}
 
 		entry = pte_to_swp_entry(ptent);
-		if (is_device_private_entry(entry)) {
+		if (is_device_private_entry(entry) ||
+		    is_device_exclusive_entry(entry)) {
 			struct page *page = pfn_swap_entry_to_page(entry);
 
 			if (unlikely(details && details->check_mapping)) {
@@ -1299,7 +1384,10 @@ again:
 
 			pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 			rss[mm_counter(page)]--;
-			page_remove_rmap(page, false);
+
+			if (is_device_private_entry(entry))
+				page_remove_rmap(page, false);
+
 			put_page(page);
 			continue;
 		}
@@ -3307,6 +3395,35 @@ void unmap_mapping_range(struct address_
 EXPORT_SYMBOL(unmap_mapping_range);
 
 /*
+ * Restore a potential device exclusive pte to a working pte entry
+ */
+static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
+{
+	struct page *page = vmf->page;
+	struct vm_area_struct *vma = vmf->vma;
+	vm_fault_t ret = 0;
+	struct mmu_notifier_range range;
+
+	if (!lock_page_or_retry(page, vma->vm_mm, vmf->flags))
+		return VM_FAULT_RETRY;
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
+				vmf->address & PAGE_MASK,
+				(vmf->address & PAGE_MASK) + PAGE_SIZE);
+	mmu_notifier_invalidate_range_start(&range);
+
+	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
+				&vmf->ptl);
+	if (likely(pte_same(*vmf->pte, vmf->orig_pte)))
+		restore_exclusive_pte(vma, page, vmf->address, vmf->pte);
+
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	unlock_page(page);
+
+	mmu_notifier_invalidate_range_end(&range);
+	return ret;
+}
+
+/*
  * We enter with non-exclusive mmap_lock (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
  * We return with pte unmapped and unlocked.
@@ -3334,6 +3451,9 @@ vm_fault_t do_swap_page(struct vm_fault
 		if (is_migration_entry(entry)) {
 			migration_entry_wait(vma->vm_mm, vmf->pmd,
 					     vmf->address);
+		} else if (is_device_exclusive_entry(entry)) {
+			vmf->page = pfn_swap_entry_to_page(entry);
+			ret = remove_device_exclusive_entry(vmf);
 		} else if (is_device_private_entry(entry)) {
 			vmf->page = pfn_swap_entry_to_page(entry);
 			ret = vmf->page->pgmap->ops->migrate_to_ram(vmf);
--- a/mm/mprotect.c~mm-device-exclusive-memory-access
+++ a/mm/mprotect.c
@@ -165,6 +165,14 @@ static unsigned long change_pte_range(st
 				newpte = swp_entry_to_pte(entry);
 				if (pte_swp_uffd_wp(oldpte))
 					newpte = pte_swp_mkuffd_wp(newpte);
+			} else if (is_writable_device_exclusive_entry(entry)) {
+				entry = make_readable_device_exclusive_entry(
+							swp_offset(entry));
+				newpte = swp_entry_to_pte(entry);
+				if (pte_swp_soft_dirty(oldpte))
+					newpte = pte_swp_mksoft_dirty(newpte);
+				if (pte_swp_uffd_wp(oldpte))
+					newpte = pte_swp_mkuffd_wp(newpte);
 			} else {
 				newpte = oldpte;
 			}
--- a/mm/page_vma_mapped.c~mm-device-exclusive-memory-access
+++ a/mm/page_vma_mapped.c
@@ -41,7 +41,8 @@ static bool map_pte(struct page_vma_mapp
 
 				/* Handle un-addressable ZONE_DEVICE memory */
 				entry = pte_to_swp_entry(*pvmw->pte);
-				if (!is_device_private_entry(entry))
+				if (!is_device_private_entry(entry) &&
+				    !is_device_exclusive_entry(entry))
 					return false;
 			} else if (!pte_present(*pvmw->pte))
 				return false;
@@ -93,7 +94,8 @@ static bool check_pte(struct page_vma_ma
 			return false;
 		entry = pte_to_swp_entry(*pvmw->pte);
 
-		if (!is_migration_entry(entry))
+		if (!is_migration_entry(entry) &&
+		    !is_device_exclusive_entry(entry))
 			return false;
 
 		pfn = swp_offset(entry);
@@ -102,7 +104,8 @@ static bool check_pte(struct page_vma_ma
 
 		/* Handle un-addressable ZONE_DEVICE memory */
 		entry = pte_to_swp_entry(*pvmw->pte);
-		if (!is_device_private_entry(entry))
+		if (!is_device_private_entry(entry) &&
+		    !is_device_exclusive_entry(entry))
 			return false;
 
 		pfn = swp_offset(entry);
--- a/mm/rmap.c~mm-device-exclusive-memory-access
+++ a/mm/rmap.c
@@ -2008,6 +2008,192 @@ void page_mlock(struct page *page)
 	rmap_walk(page, &rwc);
 }
 
+struct make_exclusive_args {
+	struct mm_struct *mm;
+	unsigned long address;
+	void *owner;
+	bool valid;
+};
+
+static bool page_make_device_exclusive_one(struct page *page,
+		struct vm_area_struct *vma, unsigned long address, void *priv)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct page_vma_mapped_walk pvmw = {
+		.page = page,
+		.vma = vma,
+		.address = address,
+	};
+	struct make_exclusive_args *args = priv;
+	pte_t pteval;
+	struct page *subpage;
+	bool ret = true;
+	struct mmu_notifier_range range;
+	swp_entry_t entry;
+	pte_t swp_pte;
+
+	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0, vma,
+				      vma->vm_mm, address, min(vma->vm_end,
+				      address + page_size(page)), args->owner);
+	mmu_notifier_invalidate_range_start(&range);
+
+	while (page_vma_mapped_walk(&pvmw)) {
+		/* Unexpected PMD-mapped THP? */
+		VM_BUG_ON_PAGE(!pvmw.pte, page);
+
+		if (!pte_present(*pvmw.pte)) {
+			ret = false;
+			page_vma_mapped_walk_done(&pvmw);
+			break;
+		}
+
+		subpage = page - page_to_pfn(page) + pte_pfn(*pvmw.pte);
+		address = pvmw.address;
+
+		/* Nuke the page table entry. */
+		flush_cache_page(vma, address, pte_pfn(*pvmw.pte));
+		pteval = ptep_clear_flush(vma, address, pvmw.pte);
+
+		/* Move the dirty bit to the page. Now the pte is gone. */
+		if (pte_dirty(pteval))
+			set_page_dirty(page);
+
+		if (arch_unmap_one(mm, vma, address, pteval) < 0) {
+			set_pte_at(mm, address, pvmw.pte, pteval);
+			ret = false;
+			page_vma_mapped_walk_done(&pvmw);
+			break;
+		}
+
+		/*
+		 * Check that our target page is still mapped at the expected
+		 * address.
+		 */
+		if (args->mm == mm && args->address == address &&
+		    pte_write(pteval))
+			args->valid = true;
+
+		/*
+		 * Store the pfn of the page in a special migration
+		 * pte. do_swap_page() will wait until the migration
+		 * pte is removed and then restart fault handling.
+		 */
+		if (pte_write(pteval))
+			entry = make_writable_device_exclusive_entry(
+							page_to_pfn(subpage));
+		else
+			entry = make_readable_device_exclusive_entry(
+							page_to_pfn(subpage));
+		swp_pte = swp_entry_to_pte(entry);
+		if (pte_soft_dirty(pteval))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		if (pte_uffd_wp(pteval))
+			swp_pte = pte_swp_mkuffd_wp(swp_pte);
+
+		/* Take a reference for the swap entry */
+		get_page(page);
+		set_pte_at(mm, address, pvmw.pte, swp_pte);
+
+		page_remove_rmap(subpage, PageHuge(page));
+		put_page(page);
+	}
+
+	mmu_notifier_invalidate_range_end(&range);
+
+	return ret;
+}
+
+/**
+ * page_make_device_exclusive - replace page table mappings with swap entries
+ * @page: the page to replace page table entries for
+ * @mm: the mm_struct where the page is expected to be mapped
+ * @address: address where the page is expected to be mapped
+ * @owner: passed to MMU_NOTIFY_EXCLUSIVE range notifier callbacks
+ *
+ * Tries to remove all the page table entries which are mapping this page and
+ * replace them with special device exclusive swap entries to grant a device
+ * exclusive access to the page. Caller must hold the page lock.
+ *
+ * Returns false if the page is still mapped, or if it could not be unmapped
+ * from the expected address. Otherwise returns true (success).
+ */
+static bool page_make_device_exclusive(struct page *page, struct mm_struct *mm,
+				unsigned long address, void *owner)
+{
+	struct make_exclusive_args args = {
+		.mm = mm,
+		.address = address,
+		.owner = owner,
+		.valid = false,
+	};
+	struct rmap_walk_control rwc = {
+		.rmap_one = page_make_device_exclusive_one,
+		.done = page_not_mapped,
+		.anon_lock = page_lock_anon_vma_read,
+		.arg = &args,
+	};
+
+	/*
+	 * Restrict to anonymous pages for now to avoid potential writeback
+	 * issues.
+	 */
+	if (!PageAnon(page))
+		return false;
+
+	rmap_walk(page, &rwc);
+
+	return args.valid && !page_mapcount(page);
+}
+
+/**
+ * make_device_exclusive_range() - Mark a range for exclusive use by a device
+ * @mm: mm_struct of assoicated target process
+ * @start: start of the region to mark for exclusive device access
+ * @end: end address of region
+ * @pages: returns the pages which were successfully marked for exclusive access
+ * @owner: passed to MMU_NOTIFY_EXCLUSIVE range notifier to allow filtering
+ *
+ * Returns: number of pages found in the range by GUP. A page is marked for
+ * exclusive access only if the page pointer is non-NULL.
+ *
+ * This function finds ptes mapping page(s) to the given address range, locks
+ * them and replaces mappings with special swap entries preventing userspace CPU
+ * access. On fault these entries are replaced with the original mapping after
+ * calling MMU notifiers.
+ *
+ * A driver using this to program access from a device must use a mmu notifier
+ * critical section to hold a device specific lock during programming. Once
+ * programming is complete it should drop the page lock and reference after
+ * which point CPU access to the page will revoke the exclusive access.
+ */
+int make_device_exclusive_range(struct mm_struct *mm, unsigned long start,
+				unsigned long end, struct page **pages,
+				void *owner)
+{
+	unsigned long npages = (end - start) >> PAGE_SHIFT;
+	unsigned long i;
+
+	npages = get_user_pages_remote(mm, start, npages,
+				       FOLL_GET | FOLL_WRITE | FOLL_SPLIT_PMD,
+				       pages, NULL, NULL);
+	for (i = 0; i < npages; i++, start += PAGE_SIZE) {
+		if (!trylock_page(pages[i])) {
+			put_page(pages[i]);
+			pages[i] = NULL;
+			continue;
+		}
+
+		if (!page_make_device_exclusive(pages[i], mm, start, owner)) {
+			unlock_page(pages[i]);
+			put_page(pages[i]);
+			pages[i] = NULL;
+		}
+	}
+
+	return npages;
+}
+EXPORT_SYMBOL_GPL(make_device_exclusive_range);
+
 void __put_anon_vma(struct anon_vma *anon_vma)
 {
 	struct anon_vma *root = anon_vma->root;
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-selftests-for-exclusive-device-memory.patch
nouveau-svm-refactor-nouveau_range_fault.patch
nouveau-svm-implement-atomic-svm-access.patch

