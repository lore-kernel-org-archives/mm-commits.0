From: akpm@linux-foundation.org
Subject: [merged] mm-reinstate-zero_page.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:42:58 -0700
Message-ID: <200909222042.n8MKgwHN010684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753055AbZIVUnQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:43:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: reinstate ZERO_PAGE
has been removed from the -mm tree.  Its filename was
     mm-reinstate-zero_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: reinstate ZERO_PAGE
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

KAMEZAWA Hiroyuki has observed customers of earlier kernels taking
advantage of the ZERO_PAGE: which we stopped do_anonymous_page() from
using in 2.6.24.  And there were a couple of regression reports on LKML.

Following suggestions from Linus, reinstate do_anonymous_page() use of
the ZERO_PAGE; but this time avoid dirtying its struct page cacheline
with (map)count updates - let vm_normal_page() regard it as abnormal.

Use it only on arches which __HAVE_ARCH_PTE_SPECIAL (x86, s390, sh32,
most powerpc): that's not essential, but minimizes additional branches
(keeping them in the unlikely pte_special case); and incidentally
excludes mips (some models of which needed eight colours of ZERO_PAGE
to avoid costly exceptions).

Don't be fanatical about avoiding ZERO_PAGE updates: get_user_pages()
callers won't want to make exceptions for it, so increment its count
there.  Changes to mlock and migration? happily seems not needed.

In most places it's quicker to check pfn than struct page address:
prepare a __read_mostly zero_pfn for that.  Does get_dump_page()
still need its ZERO_PAGE check? probably not, but keep it anyway.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   53 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 44 insertions(+), 9 deletions(-)

diff -puN mm/memory.c~mm-reinstate-zero_page mm/memory.c
--- a/mm/memory.c~mm-reinstate-zero_page
+++ a/mm/memory.c
@@ -108,6 +108,17 @@ static int __init disable_randmaps(char 
 }
 __setup("norandmaps", disable_randmaps);
 
+static unsigned long zero_pfn __read_mostly;
+
+/*
+ * CONFIG_MMU architectures set up ZERO_PAGE in their paging_init()
+ */
+static int __init init_zero_pfn(void)
+{
+	zero_pfn = page_to_pfn(ZERO_PAGE(0));
+	return 0;
+}
+core_initcall(init_zero_pfn);
 
 /*
  * If a p?d_bad entry is found while walking page tables, report
@@ -499,7 +510,9 @@ struct page *vm_normal_page(struct vm_ar
 	if (HAVE_PTE_SPECIAL) {
 		if (likely(!pte_special(pte)))
 			goto check_pfn;
-		if (!(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)))
+		if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
+			return NULL;
+		if (pfn != zero_pfn)
 			print_bad_pte(vma, addr, pte, NULL);
 		return NULL;
 	}
@@ -1144,9 +1157,14 @@ struct page *follow_page(struct vm_area_
 		goto no_page;
 	if ((flags & FOLL_WRITE) && !pte_write(pte))
 		goto unlock;
+
 	page = vm_normal_page(vma, address, pte);
-	if (unlikely(!page))
-		goto bad_page;
+	if (unlikely(!page)) {
+		if ((flags & FOLL_DUMP) ||
+		    pte_pfn(pte) != zero_pfn)
+			goto bad_page;
+		page = pte_page(pte);
+	}
 
 	if (flags & FOLL_GET)
 		get_page(page);
@@ -2084,10 +2102,19 @@ gotten:
 
 	if (unlikely(anon_vma_prepare(vma)))
 		goto oom;
-	VM_BUG_ON(old_page == ZERO_PAGE(0));
-	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
-	if (!new_page)
-		goto oom;
+
+	if (pte_pfn(orig_pte) == zero_pfn) {
+		new_page = alloc_zeroed_user_highpage_movable(vma, address);
+		if (!new_page)
+			goto oom;
+	} else {
+		new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
+		if (!new_page)
+			goto oom;
+		cow_user_page(new_page, old_page, address, vma);
+	}
+	__SetPageUptodate(new_page);
+
 	/*
 	 * Don't let another task, with possibly unlocked vma,
 	 * keep the mlocked page.
@@ -2097,8 +2124,6 @@ gotten:
 		clear_page_mlock(old_page);
 		unlock_page(old_page);
 	}
-	cow_user_page(new_page, old_page, address, vma);
-	__SetPageUptodate(new_page);
 
 	if (mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))
 		goto oom_free_new;
@@ -2639,6 +2664,15 @@ static int do_anonymous_page(struct mm_s
 	spinlock_t *ptl;
 	pte_t entry;
 
+	if (HAVE_PTE_SPECIAL && !(flags & FAULT_FLAG_WRITE)) {
+		entry = pte_mkspecial(pfn_pte(zero_pfn, vma->vm_page_prot));
+		ptl = pte_lockptr(mm, pmd);
+		spin_lock(ptl);
+		if (!pte_none(*page_table))
+			goto unlock;
+		goto setpte;
+	}
+
 	/* Allocate our own private page. */
 	pte_unmap(page_table);
 
@@ -2662,6 +2696,7 @@ static int do_anonymous_page(struct mm_s
 
 	inc_mm_counter(mm, anon_rss);
 	page_add_new_anon_rmap(page, vma, address);
+setpte:
 	set_pte_at(mm, address, page_table, entry);
 
 	/* No need to invalidate - it was non-present before */
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

