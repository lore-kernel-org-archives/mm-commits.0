From: akpm@linux-foundation.org
Subject: [merged] mm-zero_page-without-pte_special.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:43:10 -0700
Message-ID: <200909222043.n8MKhAt3011066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753109AbZIVUng (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:43:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@suse.de, ralf@linux-mips.org, riel@redhat.com


The patch titled
     mm: ZERO_PAGE without PTE_SPECIAL
has been removed from the -mm tree.  Its filename was
     mm-zero_page-without-pte_special.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: ZERO_PAGE without PTE_SPECIAL
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Reinstate anonymous use of ZERO_PAGE to all architectures, not just to
those which __HAVE_ARCH_PTE_SPECIAL: as suggested by Nick Piggin.

Contrary to how I'd imagined it, there's nothing ugly about this, just a
zero_pfn test built into one or another block of vm_normal_page().

But the MIPS ZERO_PAGE-of-many-colours case demands is_zero_pfn() and
my_zero_pfn() inlines.  Reinstate its mremap move_pte() shuffling of
ZERO_PAGEs we did from 2.6.17 to 2.6.19?  Not unless someone shouts for
that: it would have to take vm_flags to weed out some cases.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/pgtable.h |   10 ++++++++
 mm/memory.c                     |   36 ++++++++++++++++++++----------
 2 files changed, 35 insertions(+), 11 deletions(-)

diff -puN arch/mips/include/asm/pgtable.h~mm-zero_page-without-pte_special arch/mips/include/asm/pgtable.h
--- a/arch/mips/include/asm/pgtable.h~mm-zero_page-without-pte_special
+++ a/arch/mips/include/asm/pgtable.h
@@ -76,6 +76,16 @@ extern unsigned long zero_page_mask;
 #define ZERO_PAGE(vaddr) \
 	(virt_to_page((void *)(empty_zero_page + (((unsigned long)(vaddr)) & zero_page_mask))))
 
+#define is_zero_pfn is_zero_pfn
+static inline int is_zero_pfn(unsigned long pfn)
+{
+	extern unsigned long zero_pfn;
+	unsigned long offset_from_zero_pfn = pfn - zero_pfn;
+	return offset_from_zero_pfn <= (zero_page_mask >> PAGE_SHIFT);
+}
+
+#define my_zero_pfn(addr)	page_to_pfn(ZERO_PAGE(addr))
+
 extern void paging_init(void);
 
 /*
diff -puN mm/memory.c~mm-zero_page-without-pte_special mm/memory.c
--- a/mm/memory.c~mm-zero_page-without-pte_special
+++ a/mm/memory.c
@@ -108,7 +108,7 @@ static int __init disable_randmaps(char 
 }
 __setup("norandmaps", disable_randmaps);
 
-static unsigned long zero_pfn __read_mostly;
+unsigned long zero_pfn __read_mostly;
 
 /*
  * CONFIG_MMU architectures set up ZERO_PAGE in their paging_init()
@@ -455,6 +455,20 @@ static inline int is_cow_mapping(unsigne
 	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 }
 
+#ifndef is_zero_pfn
+static inline int is_zero_pfn(unsigned long pfn)
+{
+	return pfn == zero_pfn;
+}
+#endif
+
+#ifndef my_zero_pfn
+static inline unsigned long my_zero_pfn(unsigned long addr)
+{
+	return zero_pfn;
+}
+#endif
+
 /*
  * vm_normal_page -- This function gets the "struct page" associated with a pte.
  *
@@ -512,7 +526,7 @@ struct page *vm_normal_page(struct vm_ar
 			goto check_pfn;
 		if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
 			return NULL;
-		if (pfn != zero_pfn)
+		if (!is_zero_pfn(pfn))
 			print_bad_pte(vma, addr, pte, NULL);
 		return NULL;
 	}
@@ -534,6 +548,8 @@ struct page *vm_normal_page(struct vm_ar
 		}
 	}
 
+	if (is_zero_pfn(pfn))
+		return NULL;
 check_pfn:
 	if (unlikely(pfn > highest_memmap_pfn)) {
 		print_bad_pte(vma, addr, pte, NULL);
@@ -1161,7 +1177,7 @@ struct page *follow_page(struct vm_area_
 	page = vm_normal_page(vma, address, pte);
 	if (unlikely(!page)) {
 		if ((flags & FOLL_DUMP) ||
-		    pte_pfn(pte) != zero_pfn)
+		    !is_zero_pfn(pte_pfn(pte)))
 			goto bad_page;
 		page = pte_page(pte);
 	}
@@ -1443,10 +1459,6 @@ struct page *get_dump_page(unsigned long
 	if (__get_user_pages(current, current->mm, addr, 1,
 			FOLL_FORCE | FOLL_DUMP | FOLL_GET, &page, &vma) < 1)
 		return NULL;
-	if (page == ZERO_PAGE(0)) {
-		page_cache_release(page);
-		return NULL;
-	}
 	flush_cache_page(vma, addr, page_to_pfn(page));
 	return page;
 }
@@ -1629,7 +1641,8 @@ int vm_insert_mixed(struct vm_area_struc
 	 * If we don't have pte special, then we have to use the pfn_valid()
 	 * based VM_MIXEDMAP scheme (see vm_normal_page), and thus we *must*
 	 * refcount the page if pfn_valid is true (hence insert_page rather
-	 * than insert_pfn).
+	 * than insert_pfn).  If a zero_pfn were inserted into a VM_MIXEDMAP
+	 * without pte special, it would there be refcounted as a normal page.
 	 */
 	if (!HAVE_PTE_SPECIAL && pfn_valid(pfn)) {
 		struct page *page;
@@ -2097,7 +2110,7 @@ gotten:
 	if (unlikely(anon_vma_prepare(vma)))
 		goto oom;
 
-	if (pte_pfn(orig_pte) == zero_pfn) {
+	if (is_zero_pfn(pte_pfn(orig_pte))) {
 		new_page = alloc_zeroed_user_highpage_movable(vma, address);
 		if (!new_page)
 			goto oom;
@@ -2658,8 +2671,9 @@ static int do_anonymous_page(struct mm_s
 	spinlock_t *ptl;
 	pte_t entry;
 
-	if (HAVE_PTE_SPECIAL && !(flags & FAULT_FLAG_WRITE)) {
-		entry = pte_mkspecial(pfn_pte(zero_pfn, vma->vm_page_prot));
+	if (!(flags & FAULT_FLAG_WRITE)) {
+		entry = pte_mkspecial(pfn_pte(my_zero_pfn(address),
+						vma->vm_page_prot));
 		ptl = pte_lockptr(mm, pmd);
 		spin_lock(ptl);
 		if (!pte_none(*page_table))
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-optimize-touch_time-too.patch
vfs-seq_file-add-helpers-for-data-filling.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
getrusage-fill-ru_maxrss-value.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

