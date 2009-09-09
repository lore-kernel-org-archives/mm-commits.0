From: akpm@linux-foundation.org
Subject: + mm-reinstate-zero_page.patch added to -mm tree
Date: Wed, 09 Sep 2009 14:41:01 -0700
Message-ID: <200909092141.n89Lf1f0001652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079AbZIIVmO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2009 17:42:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com


The patch titled
     mm: reinstate ZERO_PAGE
has been added to the -mm tree.  Its filename is
     mm-reinstate-zero_page.patch

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
@@ -107,6 +107,17 @@ static int __init disable_randmaps(char 
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
@@ -2085,10 +2103,19 @@ gotten:
 
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
@@ -2098,8 +2125,6 @@ gotten:
 		clear_page_mlock(old_page);
 		unlock_page(old_page);
 	}
-	cow_user_page(new_page, old_page, address, vma);
-	__SetPageUptodate(new_page);
 
 	if (mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))
 		goto oom_free_new;
@@ -2594,6 +2619,15 @@ static int do_anonymous_page(struct mm_s
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
 
@@ -2617,6 +2651,7 @@ static int do_anonymous_page(struct mm_s
 
 	inc_mm_counter(mm, anon_rss);
 	page_add_new_anon_rmap(page, vma, address);
+setpte:
 	set_pte_at(mm, address, page_table, entry);
 
 	/* No need to invalidate - it was non-present before */
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

linux-next.patch
acpi-fix-null-bug-for-hid-uid-string-2.patch
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
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

