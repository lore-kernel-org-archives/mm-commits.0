From: akpm@linux-foundation.org
Subject: + mm-munlock-avoid-zero_page.patch added to -mm tree
Date: Tue, 15 Sep 2009 14:41:39 -0700
Message-ID: <200909152141.n8FLfdat005957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758684AbZIOVmy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Sep 2009 17:42:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com


The patch titled
     mm: m(un)lock avoid ZERO_PAGE
has been added to the -mm tree.  Its filename is
     mm-munlock-avoid-zero_page.patch

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
Subject: mm: m(un)lock avoid ZERO_PAGE
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

I'm still reluctant to clutter __get_user_pages() with another flag, just
to avoid touching ZERO_PAGE count in mlock(); though we can add that later
if it shows up as an issue in practice.

But when mlocking, we can test page->mapping slightly earlier, to avoid
the potentially bouncy rescheduling of lock_page on ZERO_PAGE - mlock
didn't lock_page in olden ZERO_PAGE days, so we might have regressed.

And when munlocking, it turns out that FOLL_DUMP coincidentally does
what's needed to avoid all updates to ZERO_PAGE, so use that here also. 
Plus add comment suggested by KAMEZAWA Hiroyuki.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   49 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 13 deletions(-)

diff -puN mm/mlock.c~mm-munlock-avoid-zero_page mm/mlock.c
--- a/mm/mlock.c~mm-munlock-avoid-zero_page
+++ a/mm/mlock.c
@@ -198,17 +198,26 @@ static long __mlock_vma_pages_range(stru
 		for (i = 0; i < ret; i++) {
 			struct page *page = pages[i];
 
-			lock_page(page);
-			/*
-			 * Because we lock page here and migration is blocked
-			 * by the elevated reference, we need only check for
-			 * file-cache page truncation.  This page->mapping
-			 * check also neatly skips over the ZERO_PAGE(),
-			 * though if that's common we'd prefer not to lock it.
-			 */
-			if (page->mapping)
-				mlock_vma_page(page);
-			unlock_page(page);
+			if (page->mapping) {
+				/*
+				 * That preliminary check is mainly to avoid
+				 * the pointless overhead of lock_page on the
+				 * ZERO_PAGE: which might bounce very badly if
+				 * there is contention.  However, we're still
+				 * dirtying its cacheline with get/put_page:
+				 * we'll add another __get_user_pages flag to
+				 * avoid it if that case turns out to matter.
+				 */
+				lock_page(page);
+				/*
+				 * Because we lock page here and migration is
+				 * blocked by the elevated reference, we need
+				 * only check for file-cache page truncation.
+				 */
+				if (page->mapping)
+					mlock_vma_page(page);
+				unlock_page(page);
+			}
 			put_page(page);	/* ref from get_user_pages() */
 		}
 
@@ -309,9 +318,23 @@ void munlock_vma_pages_range(struct vm_a
 	vma->vm_flags &= ~VM_LOCKED;
 
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
-		struct page *page = follow_page(vma, addr, FOLL_GET);
-		if (page) {
+		struct page *page;
+		/*
+		 * Although FOLL_DUMP is intended for get_dump_page(),
+		 * it just so happens that its special treatment of the
+		 * ZERO_PAGE (returning an error instead of doing get_page)
+		 * suits munlock very well (and if somehow an abnormal page
+		 * has sneaked into the range, we won't oops here: great).
+		 */
+		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
+		if (page && !IS_ERR(page)) {
 			lock_page(page);
+			/*
+			 * Like in __mlock_vma_pages_range(),
+			 * because we lock page here and migration is
+			 * blocked by the elevated reference, we need
+			 * only check for file-cache page truncation.
+			 */
 			if (page->mapping)
 				munlock_vma_page(page);
 			unlock_page(page);
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

