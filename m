From: akpm@linux-foundation.org
Subject: + mm-follow_hugetlb_page-flags.patch added to -mm tree
Date: Wed, 09 Sep 2009 14:40:55 -0700
Message-ID: <200909092140.n89Leus6001422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039AbZIIVvN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2009 17:51:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com


The patch titled
     mm: follow_hugetlb_page flags
has been added to the -mm tree.  Its filename is
     mm-follow_hugetlb_page-flags.patch

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
Subject: mm: follow_hugetlb_page flags
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

follow_hugetlb_page() shouldn't be guessing about the coredump case
either: pass the foll_flags down to it, instead of just the write bit.

Remove that obscure huge_zeropage_ok() test.  The decision is easy,
though unlike the non-huge case - here vm_ops->fault is always set.
But we know that a fault would serve up zeroes, unless there's
already a hugetlbfs pagecache page to back the range.

(Alternatively, since hugetlb pages aren't swapped out under pressure,
you could save more dump space by arguing that a page not yet faulted
into this process cannot be relevant to the dump; but that would be
more surprising.)

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 +-
 mm/hugetlb.c            |   62 ++++++++++++++++++++++----------------
 mm/memory.c             |   14 ++++----
 3 files changed, 48 insertions(+), 32 deletions(-)

diff -puN include/linux/hugetlb.h~mm-follow_hugetlb_page-flags include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-follow_hugetlb_page-flags
+++ a/include/linux/hugetlb.h
@@ -24,7 +24,9 @@ int hugetlb_sysctl_handler(struct ctl_ta
 int hugetlb_overcommit_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
 int hugetlb_treat_movable_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, struct vm_area_struct *);
-int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *, struct page **, struct vm_area_struct **, unsigned long *, int *, int, int);
+int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *,
+			struct page **, struct vm_area_struct **,
+			unsigned long *, int *, int, unsigned int flags);
 void unmap_hugepage_range(struct vm_area_struct *,
 			unsigned long, unsigned long, struct page *);
 void __unmap_hugepage_range(struct vm_area_struct *,
diff -puN mm/hugetlb.c~mm-follow_hugetlb_page-flags mm/hugetlb.c
--- a/mm/hugetlb.c~mm-follow_hugetlb_page-flags
+++ a/mm/hugetlb.c
@@ -2016,6 +2016,23 @@ static struct page *hugetlbfs_pagecache_
 	return find_lock_page(mapping, idx);
 }
 
+/* Return whether there is a pagecache page to back given address within VMA */
+static bool hugetlbfs_backed(struct hstate *h,
+			struct vm_area_struct *vma, unsigned long address)
+{
+	struct address_space *mapping;
+	pgoff_t idx;
+	struct page *page;
+
+	mapping = vma->vm_file->f_mapping;
+	idx = vma_hugecache_offset(h, vma, address);
+
+	page = find_get_page(mapping, idx);
+	if (page)
+		put_page(page);
+	return page != NULL;
+}
+
 static int hugetlb_no_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, pte_t *ptep, unsigned int flags)
 {
@@ -2211,54 +2228,52 @@ follow_huge_pud(struct mm_struct *mm, un
 	return NULL;
 }
 
-static int huge_zeropage_ok(pte_t *ptep, int write, int shared)
-{
-	if (!ptep || write || shared)
-		return 0;
-	else
-		return huge_pte_none(huge_ptep_get(ptep));
-}
-
 int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			struct page **pages, struct vm_area_struct **vmas,
 			unsigned long *position, int *length, int i,
-			int write)
+			unsigned int flags)
 {
 	unsigned long pfn_offset;
 	unsigned long vaddr = *position;
 	int remainder = *length;
 	struct hstate *h = hstate_vma(vma);
-	int zeropage_ok = 0;
-	int shared = vma->vm_flags & VM_SHARED;
 
 	spin_lock(&mm->page_table_lock);
 	while (vaddr < vma->vm_end && remainder) {
 		pte_t *pte;
+		int absent;
 		struct page *page;
 
 		/*
 		 * Some archs (sparc64, sh*) have multiple pte_ts to
-		 * each hugepage.  We have to make * sure we get the
+		 * each hugepage.  We have to make sure we get the
 		 * first, for the page indexing below to work.
 		 */
 		pte = huge_pte_offset(mm, vaddr & huge_page_mask(h));
-		if (huge_zeropage_ok(pte, write, shared))
-			zeropage_ok = 1;
+		absent = !pte || huge_pte_none(huge_ptep_get(pte));
+
+		/*
+		 * When coredumping, it suits get_dump_page if we just return
+		 * an error if there's a hole and no huge pagecache to back it.
+		 */
+		if (absent &&
+		    ((flags & FOLL_DUMP) && !hugetlbfs_backed(h, vma, vaddr))) {
+			remainder = 0;
+			break;
+		}
 
-		if (!pte ||
-		    (huge_pte_none(huge_ptep_get(pte)) && !zeropage_ok) ||
-		    (write && !pte_write(huge_ptep_get(pte)))) {
+		if (absent ||
+		    ((flags & FOLL_WRITE) && !pte_write(huge_ptep_get(pte)))) {
 			int ret;
 
 			spin_unlock(&mm->page_table_lock);
-			ret = hugetlb_fault(mm, vma, vaddr, write);
+			ret = hugetlb_fault(mm, vma, vaddr,
+				(flags & FOLL_WRITE) ? FAULT_FLAG_WRITE : 0);
 			spin_lock(&mm->page_table_lock);
 			if (!(ret & VM_FAULT_ERROR))
 				continue;
 
 			remainder = 0;
-			if (!i)
-				i = -EFAULT;
 			break;
 		}
 
@@ -2266,10 +2281,7 @@ int follow_hugetlb_page(struct mm_struct
 		page = pte_page(huge_ptep_get(pte));
 same_page:
 		if (pages) {
-			if (zeropage_ok)
-				pages[i] = ZERO_PAGE(0);
-			else
-				pages[i] = mem_map_offset(page, pfn_offset);
+			pages[i] = mem_map_offset(page, pfn_offset);
 			get_page(pages[i]);
 		}
 
@@ -2293,7 +2305,7 @@ same_page:
 	*length = remainder;
 	*position = vaddr;
 
-	return i;
+	return i ? i : -EFAULT;
 }
 
 void hugetlb_change_protection(struct vm_area_struct *vma,
diff -puN mm/memory.c~mm-follow_hugetlb_page-flags mm/memory.c
--- a/mm/memory.c~mm-follow_hugetlb_page-flags
+++ a/mm/memory.c
@@ -1260,17 +1260,19 @@ int __get_user_pages(struct task_struct 
 		    !(vm_flags & vma->vm_flags))
 			return i ? : -EFAULT;
 
-		if (is_vm_hugetlb_page(vma)) {
-			i = follow_hugetlb_page(mm, vma, pages, vmas,
-						&start, &nr_pages, i, write);
-			continue;
-		}
-
 		foll_flags = FOLL_TOUCH;
 		if (pages)
 			foll_flags |= FOLL_GET;
 		if (flags & GUP_FLAGS_DUMP)
 			foll_flags |= FOLL_DUMP;
+		if (write)
+			foll_flags |= FOLL_WRITE;
+
+		if (is_vm_hugetlb_page(vma)) {
+			i = follow_hugetlb_page(mm, vma, pages, vmas,
+					&start, &nr_pages, i, foll_flags);
+			continue;
+		}
 
 		do {
 			struct page *page;
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

