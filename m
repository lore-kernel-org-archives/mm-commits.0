Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E3BC07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A22061CA2
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhGFTYD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:24:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230003AbhGFTYC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:24:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9206061C9E;
        Tue,  6 Jul 2021 19:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599283;
        bh=pGVuzF35KrIObResiRXvPwuWRZJzYUIiIXqh2vsnwd0=;
        h=Date:From:To:Subject:From;
        b=rDrvQp921+mFMTONQJ00wfWOm2hV3bBAHuV4jgRWWTuXDhf1RdHv25FY0qQ20SnNp
         LoVmRfSepZSc2dQrwh3lwyOc83kQnTnvK5zgYNHvDmhedmHHOiI4Ysl5YCveadN+HB
         l7uDZIouE1h8E3pNJqXi6y3nBfkUqhG5A/m3O+DI=
Date:   Tue, 06 Jul 2021 12:21:23 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, bskeggs@redhat.com, hch@lst.de,
        hughd@google.com, jgg@nvidia.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, shakeelb@google.com, willy@infradead.org
Subject:  [merged] mm-remove-special-swap-entry-functions.patch
 removed from -mm tree
Message-ID: <20210706192123.w6MMz_eWu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove special swap entry functions
has been removed from the -mm tree.  Its filename was
     mm-remove-special-swap-entry-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm: remove special swap entry functions

Patch series "Add support for SVM atomics in Nouveau", v11.

Introduction
============

Some devices have features such as atomic PTE bits that can be used to
implement atomic access to system memory.  To support atomic operations to
a shared virtual memory page such a device needs access to that page which
is exclusive of the CPU.  This series introduces a mechanism to
temporarily unmap pages granting exclusive access to a device.

These changes are required to support OpenCL atomic operations in Nouveau
to shared virtual memory (SVM) regions allocated with the
CL_MEM_SVM_ATOMICS clSVMAlloc flag.  A more complete description of the
OpenCL SVM feature is available at
https://www.khronos.org/registry/OpenCL/specs/3.0-unified/html/
OpenCL_API.html#_shared_virtual_memory .

Implementation
==============

Exclusive device access is implemented by adding a new swap entry type
(SWAP_DEVICE_EXCLUSIVE) which is similar to a migration entry.  The main
difference is that on fault the original entry is immediately restored by
the fault handler instead of waiting.

Restoring the entry triggers calls to MMU notifers which allows a device
driver to revoke the atomic access permission from the GPU prior to the
CPU finalising the entry.

Patches
=======

Patches 1 & 2 refactor existing migration and device private entry
functions.

Patches 3 & 4 rework try_to_unmap_one() by splitting out unrelated
functionality into separate functions - try_to_migrate_one() and
try_to_munlock_one().

Patch 5 renames some existing code but does not introduce functionality.

Patch 6 is a small clean-up to swap entry handling in copy_pte_range().

Patch 7 contains the bulk of the implementation for device exclusive
memory.

Patch 8 contains some additions to the HMM selftests to ensure everything
works as expected.

Patch 9 is a cleanup for the Nouveau SVM implementation.

Patch 10 contains the implementation of atomic access for the Nouveau
driver.

Testing
=======

This has been tested with upstream Mesa 21.1.0 and a simple OpenCL program
which checks that GPU atomic accesses to system memory are atomic. 
Without this series the test fails as there is no way of write-protecting
the page mapping which results in the device clobbering CPU writes.  For
reference the test is available at
https://ozlabs.org/~apopple/opencl_svm_atomics/

Further testing has been performed by adding support for testing exclusive
access to the hmm-tests kselftests.


This patch (of 10):

Remove multiple similar inline functions for dealing with different types
of special swap entries.

Both migration and device private swap entries use the swap offset to
store a pfn.  Instead of multiple inline functions to obtain a struct page
for each swap entry type use a common function pfn_swap_entry_to_page(). 
Also open-code the various entry_to_pfn() functions as this results is
shorter code that is easier to understand.

Link: https://lkml.kernel.org/r/20210616105937.23201-1-apopple@nvidia.com
Link: https://lkml.kernel.org/r/20210616105937.23201-2-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/pgtable.c  |    2 -
 fs/proc/task_mmu.c      |   23 ++++--------
 include/linux/swap.h    |    4 +-
 include/linux/swapops.h |   69 ++++++++++++--------------------------
 mm/hmm.c                |    5 +-
 mm/huge_memory.c        |    6 +--
 mm/memcontrol.c         |    2 -
 mm/memory.c             |   10 ++---
 mm/migrate.c            |    6 +--
 mm/page_vma_mapped.c    |    6 +--
 10 files changed, 51 insertions(+), 82 deletions(-)

--- a/arch/s390/mm/pgtable.c~mm-remove-special-swap-entry-functions
+++ a/arch/s390/mm/pgtable.c
@@ -691,7 +691,7 @@ static void ptep_zap_swap_entry(struct m
 	if (!non_swap_entry(entry))
 		dec_mm_counter(mm, MM_SWAPENTS);
 	else if (is_migration_entry(entry)) {
-		struct page *page = migration_entry_to_page(entry);
+		struct page *page = pfn_swap_entry_to_page(entry);
 
 		dec_mm_counter(mm, mm_counter(page));
 	}
--- a/fs/proc/task_mmu.c~mm-remove-special-swap-entry-functions
+++ a/fs/proc/task_mmu.c
@@ -514,10 +514,8 @@ static void smaps_pte_entry(pte_t *pte,
 			} else {
 				mss->swap_pss += (u64)PAGE_SIZE << PSS_SHIFT;
 			}
-		} else if (is_migration_entry(swpent))
-			page = migration_entry_to_page(swpent);
-		else if (is_device_private_entry(swpent))
-			page = device_private_entry_to_page(swpent);
+		} else if (is_pfn_swap_entry(swpent))
+			page = pfn_swap_entry_to_page(swpent);
 	} else if (unlikely(IS_ENABLED(CONFIG_SHMEM) && mss->check_shmem_swap
 							&& pte_none(*pte))) {
 		page = xa_load(&vma->vm_file->f_mapping->i_pages,
@@ -549,7 +547,7 @@ static void smaps_pmd_entry(pmd_t *pmd,
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
 
 		if (is_migration_entry(entry))
-			page = migration_entry_to_page(entry);
+			page = pfn_swap_entry_to_page(entry);
 	}
 	if (IS_ERR_OR_NULL(page))
 		return;
@@ -694,10 +692,8 @@ static int smaps_hugetlb_range(pte_t *pt
 	} else if (is_swap_pte(*pte)) {
 		swp_entry_t swpent = pte_to_swp_entry(*pte);
 
-		if (is_migration_entry(swpent))
-			page = migration_entry_to_page(swpent);
-		else if (is_device_private_entry(swpent))
-			page = device_private_entry_to_page(swpent);
+		if (is_pfn_swap_entry(swpent))
+			page = pfn_swap_entry_to_page(swpent);
 	}
 	if (page) {
 		int mapcount = page_mapcount(page);
@@ -1389,11 +1385,8 @@ static pagemap_entry_t pte_to_pagemap_en
 			frame = swp_type(entry) |
 				(swp_offset(entry) << MAX_SWAPFILES_SHIFT);
 		flags |= PM_SWAP;
-		if (is_migration_entry(entry))
-			page = migration_entry_to_page(entry);
-
-		if (is_device_private_entry(entry))
-			page = device_private_entry_to_page(entry);
+		if (is_pfn_swap_entry(entry))
+			page = pfn_swap_entry_to_page(entry);
 	}
 
 	if (page && !PageAnon(page))
@@ -1454,7 +1447,7 @@ static int pagemap_pmd_range(pmd_t *pmdp
 			if (pmd_swp_uffd_wp(pmd))
 				flags |= PM_UFFD_WP;
 			VM_BUG_ON(!is_pmd_migration_entry(pmd));
-			page = migration_entry_to_page(entry);
+			page = pfn_swap_entry_to_page(entry);
 		}
 #endif
 
--- a/include/linux/swap.h~mm-remove-special-swap-entry-functions
+++ a/include/linux/swap.h
@@ -564,8 +564,8 @@ static inline void show_swap_cache_info(
 {
 }
 
-#define free_swap_and_cache(e) ({(is_migration_entry(e) || is_device_private_entry(e));})
-#define swapcache_prepare(e) ({(is_migration_entry(e) || is_device_private_entry(e));})
+/* used to sanity check ptes in zap_pte_range when CONFIG_SWAP=0 */
+#define free_swap_and_cache(e) is_pfn_swap_entry(e)
 
 static inline int add_swap_count_continuation(swp_entry_t swp, gfp_t gfp_mask)
 {
--- a/include/linux/swapops.h~mm-remove-special-swap-entry-functions
+++ a/include/linux/swapops.h
@@ -128,16 +128,6 @@ static inline bool is_write_device_priva
 {
 	return unlikely(swp_type(entry) == SWP_DEVICE_WRITE);
 }
-
-static inline unsigned long device_private_entry_to_pfn(swp_entry_t entry)
-{
-	return swp_offset(entry);
-}
-
-static inline struct page *device_private_entry_to_page(swp_entry_t entry)
-{
-	return pfn_to_page(swp_offset(entry));
-}
 #else /* CONFIG_DEVICE_PRIVATE */
 static inline swp_entry_t make_device_private_entry(struct page *page, bool write)
 {
@@ -157,16 +147,6 @@ static inline bool is_write_device_priva
 {
 	return false;
 }
-
-static inline unsigned long device_private_entry_to_pfn(swp_entry_t entry)
-{
-	return 0;
-}
-
-static inline struct page *device_private_entry_to_page(swp_entry_t entry)
-{
-	return NULL;
-}
 #endif /* CONFIG_DEVICE_PRIVATE */
 
 #ifdef CONFIG_MIGRATION
@@ -189,22 +169,6 @@ static inline int is_write_migration_ent
 	return unlikely(swp_type(entry) == SWP_MIGRATION_WRITE);
 }
 
-static inline unsigned long migration_entry_to_pfn(swp_entry_t entry)
-{
-	return swp_offset(entry);
-}
-
-static inline struct page *migration_entry_to_page(swp_entry_t entry)
-{
-	struct page *p = pfn_to_page(swp_offset(entry));
-	/*
-	 * Any use of migration entries may only occur while the
-	 * corresponding page is locked
-	 */
-	BUG_ON(!PageLocked(compound_head(p)));
-	return p;
-}
-
 static inline void make_migration_entry_read(swp_entry_t *entry)
 {
 	*entry = swp_entry(SWP_MIGRATION_READ, swp_offset(*entry));
@@ -224,16 +188,6 @@ static inline int is_migration_entry(swp
 	return 0;
 }
 
-static inline unsigned long migration_entry_to_pfn(swp_entry_t entry)
-{
-	return 0;
-}
-
-static inline struct page *migration_entry_to_page(swp_entry_t entry)
-{
-	return NULL;
-}
-
 static inline void make_migration_entry_read(swp_entry_t *entryp) { }
 static inline void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
 					spinlock_t *ptl) { }
@@ -248,6 +202,29 @@ static inline int is_write_migration_ent
 
 #endif
 
+static inline struct page *pfn_swap_entry_to_page(swp_entry_t entry)
+{
+	struct page *p = pfn_to_page(swp_offset(entry));
+
+	/*
+	 * Any use of migration entries may only occur while the
+	 * corresponding page is locked
+	 */
+	BUG_ON(is_migration_entry(entry) && !PageLocked(p));
+
+	return p;
+}
+
+/*
+ * A pfn swap entry is a special type of swap entry that always has a pfn stored
+ * in the swap offset. They are used to represent unaddressable device memory
+ * and to restrict access to a page undergoing migration.
+ */
+static inline bool is_pfn_swap_entry(swp_entry_t entry)
+{
+	return is_migration_entry(entry) || is_device_private_entry(entry);
+}
+
 struct page_vma_mapped_walk;
 
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
--- a/mm/hmm.c~mm-remove-special-swap-entry-functions
+++ a/mm/hmm.c
@@ -214,7 +214,7 @@ static inline bool hmm_is_device_private
 		swp_entry_t entry)
 {
 	return is_device_private_entry(entry) &&
-		device_private_entry_to_page(entry)->pgmap->owner ==
+		pfn_swap_entry_to_page(entry)->pgmap->owner ==
 		range->dev_private_owner;
 }
 
@@ -257,8 +257,7 @@ static int hmm_vma_handle_pte(struct mm_
 			cpu_flags = HMM_PFN_VALID;
 			if (is_write_device_private_entry(entry))
 				cpu_flags |= HMM_PFN_WRITE;
-			*hmm_pfn = device_private_entry_to_pfn(entry) |
-					cpu_flags;
+			*hmm_pfn = swp_offset(entry) | cpu_flags;
 			return 0;
 		}
 
--- a/mm/huge_memory.c~mm-remove-special-swap-entry-functions
+++ a/mm/huge_memory.c
@@ -1643,7 +1643,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 
 			VM_BUG_ON(!is_pmd_migration_entry(orig_pmd));
 			entry = pmd_to_swp_entry(orig_pmd);
-			page = migration_entry_to_page(entry);
+			page = pfn_swap_entry_to_page(entry);
 			flush_needed = 0;
 		} else
 			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
@@ -2012,7 +2012,7 @@ static void __split_huge_pmd_locked(stru
 			swp_entry_t entry;
 
 			entry = pmd_to_swp_entry(old_pmd);
-			page = migration_entry_to_page(entry);
+			page = pfn_swap_entry_to_page(entry);
 		} else {
 			page = pmd_page(old_pmd);
 			if (!PageDirty(page) && pmd_dirty(old_pmd))
@@ -2066,7 +2066,7 @@ static void __split_huge_pmd_locked(stru
 		swp_entry_t entry;
 
 		entry = pmd_to_swp_entry(old_pmd);
-		page = migration_entry_to_page(entry);
+		page = pfn_swap_entry_to_page(entry);
 		write = is_write_migration_entry(entry);
 		young = false;
 		soft_dirty = pmd_swp_soft_dirty(old_pmd);
--- a/mm/memcontrol.c~mm-remove-special-swap-entry-functions
+++ a/mm/memcontrol.c
@@ -5532,7 +5532,7 @@ static struct page *mc_handle_swap_pte(s
 	 * as special swap entry in the CPU page table.
 	 */
 	if (is_device_private_entry(ent)) {
-		page = device_private_entry_to_page(ent);
+		page = pfn_swap_entry_to_page(ent);
 		/*
 		 * MEMORY_DEVICE_PRIVATE means ZONE_DEVICE page and which have
 		 * a refcount of 1 when free (unlike normal page)
--- a/mm/memory.c~mm-remove-special-swap-entry-functions
+++ a/mm/memory.c
@@ -729,7 +729,7 @@ copy_nonpresent_pte(struct mm_struct *ds
 		}
 		rss[MM_SWAPENTS]++;
 	} else if (is_migration_entry(entry)) {
-		page = migration_entry_to_page(entry);
+		page = pfn_swap_entry_to_page(entry);
 
 		rss[mm_counter(page)]++;
 
@@ -748,7 +748,7 @@ copy_nonpresent_pte(struct mm_struct *ds
 			set_pte_at(src_mm, addr, src_pte, pte);
 		}
 	} else if (is_device_private_entry(entry)) {
-		page = device_private_entry_to_page(entry);
+		page = pfn_swap_entry_to_page(entry);
 
 		/*
 		 * Update rss count even for unaddressable pages, as
@@ -1280,7 +1280,7 @@ again:
 
 		entry = pte_to_swp_entry(ptent);
 		if (is_device_private_entry(entry)) {
-			struct page *page = device_private_entry_to_page(entry);
+			struct page *page = pfn_swap_entry_to_page(entry);
 
 			if (unlikely(details && details->check_mapping)) {
 				/*
@@ -1309,7 +1309,7 @@ again:
 		else if (is_migration_entry(entry)) {
 			struct page *page;
 
-			page = migration_entry_to_page(entry);
+			page = pfn_swap_entry_to_page(entry);
 			rss[mm_counter(page)]--;
 		}
 		if (unlikely(!free_swap_and_cache(entry)))
@@ -3372,7 +3372,7 @@ vm_fault_t do_swap_page(struct vm_fault
 			migration_entry_wait(vma->vm_mm, vmf->pmd,
 					     vmf->address);
 		} else if (is_device_private_entry(entry)) {
-			vmf->page = device_private_entry_to_page(entry);
+			vmf->page = pfn_swap_entry_to_page(entry);
 			ret = vmf->page->pgmap->ops->migrate_to_ram(vmf);
 		} else if (is_hwpoison_entry(entry)) {
 			ret = VM_FAULT_HWPOISON;
--- a/mm/migrate.c~mm-remove-special-swap-entry-functions
+++ a/mm/migrate.c
@@ -296,7 +296,7 @@ void __migration_entry_wait(struct mm_st
 	if (!is_migration_entry(entry))
 		goto out;
 
-	page = migration_entry_to_page(entry);
+	page = pfn_swap_entry_to_page(entry);
 	page = compound_head(page);
 
 	/*
@@ -337,7 +337,7 @@ void pmd_migration_entry_wait(struct mm_
 	ptl = pmd_lock(mm, pmd);
 	if (!is_pmd_migration_entry(*pmd))
 		goto unlock;
-	page = migration_entry_to_page(pmd_to_swp_entry(*pmd));
+	page = pfn_swap_entry_to_page(pmd_to_swp_entry(*pmd));
 	if (!get_page_unless_zero(page))
 		goto unlock;
 	spin_unlock(ptl);
@@ -2289,7 +2289,7 @@ again:
 			if (!is_device_private_entry(entry))
 				goto next;
 
-			page = device_private_entry_to_page(entry);
+			page = pfn_swap_entry_to_page(entry);
 			if (!(migrate->flags &
 				MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
 			    page->pgmap->owner != migrate->pgmap_owner)
--- a/mm/page_vma_mapped.c~mm-remove-special-swap-entry-functions
+++ a/mm/page_vma_mapped.c
@@ -96,7 +96,7 @@ static bool check_pte(struct page_vma_ma
 		if (!is_migration_entry(entry))
 			return false;
 
-		pfn = migration_entry_to_pfn(entry);
+		pfn = swp_offset(entry);
 	} else if (is_swap_pte(*pvmw->pte)) {
 		swp_entry_t entry;
 
@@ -105,7 +105,7 @@ static bool check_pte(struct page_vma_ma
 		if (!is_device_private_entry(entry))
 			return false;
 
-		pfn = device_private_entry_to_pfn(entry);
+		pfn = swp_offset(entry);
 	} else {
 		if (!pte_present(*pvmw->pte))
 			return false;
@@ -233,7 +233,7 @@ restart:
 					return not_found(pvmw);
 				entry = pmd_to_swp_entry(pmde);
 				if (!is_migration_entry(entry) ||
-				    migration_entry_to_page(entry) != page)
+				    pfn_swap_entry_to_page(entry) != page)
 					return not_found(pvmw);
 				return true;
 			}
_

Patches currently in -mm which might be from apopple@nvidia.com are


