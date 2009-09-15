From: akpm@linux-foundation.org
Subject: + mm-zero_page-without-pte_special.patch added to -mm tree
Date: Tue, 15 Sep 2009 14:41:44 -0700
Message-ID: <200909152141.n8FLfjik006172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371AbZIOVmw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Sep 2009 17:42:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com


The patch titled
     mm: ZERO_PAGE without PTE_SPECIAL
has been added to the -mm tree.  Its filename is
     mm-zero_page-without-pte_special.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/pgtable.h |   14 +++++++++++
 mm/memory.c                     |   36 ++++++++++++++++++++----------
 2 files changed, 39 insertions(+), 11 deletions(-)

diff -puN arch/mips/include/asm/pgtable.h~mm-zero_page-without-pte_special arch/mips/include/asm/pgtable.h
--- a/arch/mips/include/asm/pgtable.h~mm-zero_page-without-pte_special
+++ a/arch/mips/include/asm/pgtable.h
@@ -76,6 +76,20 @@ extern unsigned long zero_page_mask;
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
+#define my_zero_pfn my_zero_pfn
+static inline unsigned long my_zero_pfn(unsigned long addr)
+{
+	return page_to_pfn(ZERO_PAGE(addr));
+}
+
 extern void paging_init(void);
 
 /*
diff -puN mm/memory.c~mm-zero_page-without-pte_special mm/memory.c
--- a/mm/memory.c~mm-zero_page-without-pte_special
+++ a/mm/memory.c
@@ -107,7 +107,7 @@ static int __init disable_randmaps(char 
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
@@ -1444,10 +1460,6 @@ struct page *get_dump_page(unsigned long
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
@@ -1630,7 +1642,8 @@ int vm_insert_mixed(struct vm_area_struc
 	 * If we don't have pte special, then we have to use the pfn_valid()
 	 * based VM_MIXEDMAP scheme (see vm_normal_page), and thus we *must*
 	 * refcount the page if pfn_valid is true (hence insert_page rather
-	 * than insert_pfn).
+	 * than insert_pfn).  If a zero_pfn were inserted into a VM_MIXEDMAP
+	 * without pte special, it would there be refcounted as a normal page.
 	 */
 	if (!HAVE_PTE_SPECIAL && pfn_valid(pfn)) {
 		struct page *page;
@@ -2098,7 +2111,7 @@ gotten:
 	if (unlikely(anon_vma_prepare(vma)))
 		goto oom;
 
-	if (pte_pfn(orig_pte) == zero_pfn) {
+	if (is_zero_pfn(pte_pfn(orig_pte))) {
 		new_page = alloc_zeroed_user_highpage_movable(vma, address);
 		if (!new_page)
 			goto oom;
@@ -2613,8 +2626,9 @@ static int do_anonymous_page(struct mm_s
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
vfs-optimize-touch_time-too-fix.patch
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
vfs-seq_file-add-helpers-for-data-filling.patch
vfs-revert-proc-mounts-to-old-behavior-for-unreachable-mountpoints.patch
vfs-no-unreachable-prefix-for-sysvipc-maps-in-proc-pid-maps.patch
hwpoison-fix-uninitialized-warning.patch
mm-oom-analysis-add-shmem-vmstat.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
ksm-rename-kernel_pages_allocated.patch
ksm-move-pages_sharing-updates.patch
ksm-pages_unshared-and-pages_volatile.patch
ksm-break-cow-once-unshared.patch
ksm-keep-quiet-while-list-empty.patch
ksm-five-little-cleanups.patch
ksm-fix-endless-loop-on-oom.patch
ksm-distribute-remove_mm_from_lists.patch
ksm-fix-oom-deadlock.patch
ksm-fix-deadlock-with-munlock-in-exit_mmap.patch
ksm-sysfs-and-defaults.patch
ksm-add-some-documentation.patch
ksm-remove-vm_mergeable_flags.patch
ksm-clean-up-obsolete-references.patch
ksm-unmerge-is-an-origin-of-ooms.patch
ksm-mremap-use-err-from-ksm_madvise.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
mm-includecheck-fix-for-mm-shmemc.patch
mm-introduce-page_lru_base_type-fix.patch
mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-example.patch
mm-munlock-use-follow_page.patch
mm-remove-unused-gup-flags.patch
mm-add-get_dump_page.patch
mm-foll_dump-replace-foll_anon.patch
mm-follow_hugetlb_page-flags.patch
mm-fix-anonymous-dirtying.patch
mm-reinstate-zero_page.patch
mm-foll-flags-for-gup-flags.patch
mm-munlock-avoid-zero_page.patch
mm-hugetlbfs_pagecache_present.patch
mm-zero_page-without-pte_special.patch
mm-move-highest_memmap_pfn.patch
mmap-remove-unnecessary-code.patch
tmpfs-depend-on-shmem.patch
mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust.patch
mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust-tweak.patch
mmap-save-some-cycles-for-the-shared-anonymous-mapping.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

