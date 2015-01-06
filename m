From: akpm@linux-foundation.org
Subject: +
 mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath.patch added
 to -mm tree
Date: Tue, 06 Jan 2015 15:33:50 -0800
Message-ID: <54ac70de.WztWVL2YDeQ7lPWp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbbAFXdv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:33:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, balbi@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop support of non-linear mapping from unmap/zap codepath
has been added to the -mm tree.  Its filename is
     mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: drop support of non-linear mapping from unmap/zap codepath

We have remap_file_pages(2) emulation in -mm tree for few release cycles
and we plan to have it mainline in v3.20. This patchset removes rest of
VM_NONLINEAR infrastructure.

Patches 1-8 take care about generic code. They are pretty
straight-forward and can be applied without other of patches.

Rest patches removes pte_file()-related stuff from architecture-specific
code. It usually frees up one bit in non-present pte. I've tried to reuse
that bit for swap offset, where I was able to figure out how to do that.

For obvious reason I cannot test all that arch-specific code and would
like to see acks from maintainers.

In total, remap_file_pages(2) required about 1.4K lines of not-so-trivial
kernel code. That's too much for functionality nobody uses.

Tested-by: Felipe Balbi <balbi@ti.com>



This patch (of 38):

We don't create non-linear mappings anymore. Let's drop code which
handles them on unmap/zap.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 mm/madvise.c       |    9 ----
 mm/memory.c        |   88 +++++++++++--------------------------------
 3 files changed, 25 insertions(+), 73 deletions(-)

diff -puN include/linux/mm.h~mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath include/linux/mm.h
--- a/include/linux/mm.h~mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath
+++ a/include/linux/mm.h
@@ -1119,7 +1119,6 @@ extern void user_shm_unlock(size_t, stru
  * Parameter block passed down to zap_pte_range in exceptional cases.
  */
 struct zap_details {
-	struct vm_area_struct *nonlinear_vma;	/* Check page->index if set */
 	struct address_space *check_mapping;	/* Check page->mapping if set */
 	pgoff_t	first_index;			/* Lowest page->index to unmap */
 	pgoff_t last_index;			/* Highest page->index to unmap */
diff -puN mm/madvise.c~mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath mm/madvise.c
--- a/mm/madvise.c~mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath
+++ a/mm/madvise.c
@@ -278,14 +278,7 @@ static long madvise_dontneed(struct vm_a
 	if (vma->vm_flags & (VM_LOCKED|VM_HUGETLB|VM_PFNMAP))
 		return -EINVAL;
 
-	if (unlikely(vma->vm_flags & VM_NONLINEAR)) {
-		struct zap_details details = {
-			.nonlinear_vma = vma,
-			.last_index = ULONG_MAX,
-		};
-		zap_page_range(vma, start, end - start, &details);
-	} else
-		zap_page_range(vma, start, end - start, NULL);
+	zap_page_range(vma, start, end - start, NULL);
 	return 0;
 }
 
diff -puN mm/memory.c~mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath mm/memory.c
--- a/mm/memory.c~mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath
+++ a/mm/memory.c
@@ -1082,6 +1082,7 @@ static unsigned long zap_pte_range(struc
 	spinlock_t *ptl;
 	pte_t *start_pte;
 	pte_t *pte;
+	swp_entry_t entry;
 
 again:
 	init_rss_vec(rss);
@@ -1107,28 +1108,12 @@ again:
 				if (details->check_mapping &&
 				    details->check_mapping != page->mapping)
 					continue;
-				/*
-				 * Each page->index must be checked when
-				 * invalidating or truncating nonlinear.
-				 */
-				if (details->nonlinear_vma &&
-				    (page->index < details->first_index ||
-				     page->index > details->last_index))
-					continue;
 			}
 			ptent = ptep_get_and_clear_full(mm, addr, pte,
 							tlb->fullmm);
 			tlb_remove_tlb_entry(tlb, pte, addr);
 			if (unlikely(!page))
 				continue;
-			if (unlikely(details) && details->nonlinear_vma
-			    && linear_page_index(details->nonlinear_vma,
-						addr) != page->index) {
-				pte_t ptfile = pgoff_to_pte(page->index);
-				if (pte_soft_dirty(ptent))
-					ptfile = pte_file_mksoft_dirty(ptfile);
-				set_pte_at(mm, addr, pte, ptfile);
-			}
 			if (PageAnon(page))
 				rss[MM_ANONPAGES]--;
 			else {
@@ -1151,33 +1136,25 @@ again:
 			}
 			continue;
 		}
-		/*
-		 * If details->check_mapping, we leave swap entries;
-		 * if details->nonlinear_vma, we leave file entries.
-		 */
+		/* If details->check_mapping, we leave swap entries. */
 		if (unlikely(details))
 			continue;
-		if (pte_file(ptent)) {
-			if (unlikely(!(vma->vm_flags & VM_NONLINEAR)))
-				print_bad_pte(vma, addr, ptent, NULL);
-		} else {
-			swp_entry_t entry = pte_to_swp_entry(ptent);
-
-			if (!non_swap_entry(entry))
-				rss[MM_SWAPENTS]--;
-			else if (is_migration_entry(entry)) {
-				struct page *page;
-
-				page = migration_entry_to_page(entry);
-
-				if (PageAnon(page))
-					rss[MM_ANONPAGES]--;
-				else
-					rss[MM_FILEPAGES]--;
-			}
-			if (unlikely(!free_swap_and_cache(entry)))
-				print_bad_pte(vma, addr, ptent, NULL);
+
+		entry = pte_to_swp_entry(ptent);
+		if (!non_swap_entry(entry))
+			rss[MM_SWAPENTS]--;
+		else if (is_migration_entry(entry)) {
+			struct page *page;
+
+			page = migration_entry_to_page(entry);
+
+			if (PageAnon(page))
+				rss[MM_ANONPAGES]--;
+			else
+				rss[MM_FILEPAGES]--;
 		}
+		if (unlikely(!free_swap_and_cache(entry)))
+			print_bad_pte(vma, addr, ptent, NULL);
 		pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
@@ -1277,7 +1254,7 @@ static void unmap_page_range(struct mmu_
 	pgd_t *pgd;
 	unsigned long next;
 
-	if (details && !details->check_mapping && !details->nonlinear_vma)
+	if (details && !details->check_mapping)
 		details = NULL;
 
 	BUG_ON(addr >= end);
@@ -1371,7 +1348,7 @@ void unmap_vmas(struct mmu_gather *tlb,
  * @vma: vm_area_struct holding the applicable pages
  * @start: starting address of pages to zap
  * @size: number of bytes to zap
- * @details: details of nonlinear truncation or shared cache invalidation
+ * @details: details of shared cache invalidation
  *
  * Caller must protect the VMA list
  */
@@ -1397,7 +1374,7 @@ void zap_page_range(struct vm_area_struc
  * @vma: vm_area_struct holding the applicable pages
  * @address: starting address of pages to zap
  * @size: number of bytes to zap
- * @details: details of nonlinear truncation or shared cache invalidation
+ * @details: details of shared cache invalidation
  *
  * The range must fit into one VMA.
  */
@@ -2331,25 +2308,11 @@ static inline void unmap_mapping_range_t
 	}
 }
 
-static inline void unmap_mapping_range_list(struct list_head *head,
-					    struct zap_details *details)
-{
-	struct vm_area_struct *vma;
-
-	/*
-	 * In nonlinear VMAs there is no correspondence between virtual address
-	 * offset and file offset.  So we must perform an exhaustive search
-	 * across *all* the pages in each nonlinear VMA, not just the pages
-	 * whose virtual address lies outside the file truncation point.
-	 */
-	list_for_each_entry(vma, head, shared.nonlinear) {
-		details->nonlinear_vma = vma;
-		unmap_mapping_range_vma(vma, vma->vm_start, vma->vm_end, details);
-	}
-}
-
 /**
- * unmap_mapping_range - unmap the portion of all mmaps in the specified address_space corresponding to the specified page range in the underlying file.
+ * unmap_mapping_range - unmap the portion of all mmaps in the specified
+ * address_space corresponding to the specified page range in the underlying
+ * file.
+ *
  * @mapping: the address space containing mmaps to be unmapped.
  * @holebegin: byte in first page to unmap, relative to the start of
  * the underlying file.  This will be rounded down to a PAGE_SIZE
@@ -2378,7 +2341,6 @@ void unmap_mapping_range(struct address_
 	}
 
 	details.check_mapping = even_cows? NULL: mapping;
-	details.nonlinear_vma = NULL;
 	details.first_index = hba;
 	details.last_index = hba + hlen - 1;
 	if (details.last_index < details.first_index)
@@ -2388,8 +2350,6 @@ void unmap_mapping_range(struct address_
 	i_mmap_lock_write(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
-	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
-		unmap_mapping_range_list(&mapping->i_mmap_nonlinear, &details);
 	i_mmap_unlock_write(mapping);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-protect-set_page_dirty-from-ongoing-truncation.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath.patch
mm-drop-support-of-non-linear-mapping-from-fault-codepath.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub.patch
proc-drop-handling-non-linear-mappings.patch
rmap-drop-support-of-non-linear-mappings.patch
mm-replace-vma-shareadlinear-with-vma-shared.patch
mm-remove-rest-usage-of-vm_nonlinear-and-pte_file.patch
asm-generic-drop-unused-pte_file-helpers.patch
alpha-drop-_page_file-and-pte_file-related-helpers.patch
arc-drop-_page_file-and-pte_file-related-helpers.patch
arm64-drop-pte_file-and-pte_file-related-helpers.patch
arm-drop-l_pte_file-and-pte_file-related-helpers.patch
avr32-drop-_page_file-and-pte_file-related-helpers.patch
blackfin-drop-pte_file.patch
c6x-drop-pte_file.patch
cris-drop-_page_file-and-pte_file-related-helpers.patch
frv-drop-_page_file-and-pte_file-related-helpers.patch
hexagon-drop-_page_file-and-pte_file-related-helpers.patch
ia64-drop-_page_file-and-pte_file-related-helpers.patch
m32r-drop-_page_file-and-pte_file-related-helpers.patch
m68k-drop-_page_file-and-pte_file-related-helpers.patch
metag-drop-_page_file-and-pte_file-related-helpers.patch
microblaze-drop-_page_file-and-pte_file-related-helpers.patch
mips-drop-_page_file-and-pte_file-related-helpers.patch
mn10300-drop-_page_file-and-pte_file-related-helpers.patch
nios2-drop-_page_file-and-pte_file-related-helpers.patch
openrisc-drop-_page_file-and-pte_file-related-helpers.patch
parisc-drop-_page_file-and-pte_file-related-helpers.patch
powerpc-drop-_page_file-and-pte_file-related-helpers.patch
s390-drop-pte_file-related-helpers.patch
score-drop-_page_file-and-pte_file-related-helpers.patch
sh-drop-_page_file-and-pte_file-related-helpers.patch
sparc-drop-pte_file-related-helpers.patch
tile-drop-pte_file-related-helpers.patch
um-drop-_page_file-and-pte_file-related-helpers.patch
unicore32-drop-pte_file-related-helpers.patch
x86-drop-_page_file-and-pte_file-related-helpers.patch
xtensa-drop-_page_file-and-pte_file-related-helpers.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
mm-add-vm_bug_on_page-for-page_mapcount.patch

