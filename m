From: akpm@linux-foundation.org
Subject: [folded] mm-zero_page-without-pte_special-mips-fix.patch removed from -mm tree
Date: Mon, 21 Sep 2009 14:29:48 -0700
Message-ID: <200909212129.n8LLTmhY020509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753900AbZIUVai (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Sep 2009 17:30:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@suse.de, ralf@linu


The patch titled
     mm-zero_page-without-pte_special mips fix
has been removed from the -mm tree.  Its filename was
     mm-zero_page-without-pte_special-mips-fix.patch

This patch was dropped because it was folded into mm-zero_page-without-pte_special.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-zero_page-without-pte_special mips fix
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Use macro instead of inline to fix mips allmodconfig error:

/usr/src/devel/arch/mips/include/asm/pgtable.h: In function `my_zero_pfn':
/usr/src/devel/arch/mips/include/asm/pgtable.h:90: error: `mem_map' undeclared (first use in this function)
/usr/src/devel/arch/mips/include/asm/pgtable.h:90: error: (Each undeclared identifier is reported only once
/usr/src/devel/arch/mips/include/asm/pgtable.h:90: error: for each function it appears in.)

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/pgtable.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/mips/include/asm/pgtable.h~mm-zero_page-without-pte_special-mips-fix arch/mips/include/asm/pgtable.h
--- a/arch/mips/include/asm/pgtable.h~mm-zero_page-without-pte_special-mips-fix
+++ a/arch/mips/include/asm/pgtable.h
@@ -84,11 +84,7 @@ static inline int is_zero_pfn(unsigned l
 	return offset_from_zero_pfn <= (zero_page_mask >> PAGE_SHIFT);
 }
 
-#define my_zero_pfn my_zero_pfn
-static inline unsigned long my_zero_pfn(unsigned long addr)
-{
-	return page_to_pfn(ZERO_PAGE(addr));
-}
+#define my_zero_pfn(addr)	page_to_pfn(ZERO_PAGE(addr))
 
 extern void paging_init(void);
 
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-vmstat-add-isolate-pages.patch
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
mm-introduce-page_lru_base_type.patch
mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch
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
mm-zero_page-without-pte_special-mips-fix.patch
mm-move-highest_memmap_pfn.patch
mmap-remove-unnecessary-code.patch
tmpfs-depend-on-shmem.patch
mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust.patch
mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust-tweak.patch
mmap-save-some-cycles-for-the-shared-anonymous-mapping.patch
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions-fix.patch
hugetlb-add-map_hugetlb-example.patch
shmem-initialize-struct-shmem_sb_info-to-zero.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

