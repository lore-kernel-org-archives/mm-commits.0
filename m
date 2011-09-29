From: akpm@google.com
Subject: + vmscan-add-barrier-to-prevent-evictable-page-in-unevictable-list.patch added to -mm tree
Date: Thu, 29 Sep 2011 15:15:48 -0700
Message-ID: <201109292215.p8TMFmoa009761@hpaq6.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:35314 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab1I2WQp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2011 18:16:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, riel@redhat.com


The patch titled
     Subject: vmscan: add barrier to prevent evictable page in unevictable list
has been added to the -mm tree.  Its filename is
     vmscan-add-barrier-to-prevent-evictable-page-in-unevictable-list.patch

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
From: Minchan Kim <minchan.kim@gmail.com>
Subject: vmscan: add barrier to prevent evictable page in unevictable list

When a race between putback_lru_page() and shmem_lock with lock=0 happens,
progrom execution order is as follows, but clear_bit in processor #1 could
be reordered right before spin_unlock of processor #1.  Then, the page
would be stranded on the unevictable list.

spin_lock
SetPageLRU
spin_unlock
                                clear_bit(AS_UNEVICTABLE)
                                spin_lock
                                if PageLRU()
                                        if !test_bit(AS_UNEVICTABLE)
                                        	move evictable list
smp_mb
if !test_bit(AS_UNEVICTABLE)
        move evictable list
                                spin_unlock

But, pagevec_lookup() in scan_mapping_unevictable_pages() has
rcu_read_[un]lock() so it could protect reordering before reaching
test_bit(AS_UNEVICTABLE) on processor #1 so this problem never happens. 
But it's a unexpected side effect and we should solve this problem
properly.

This patch adds a barrier after mapping_clear_unevictable.

I didn't meet this problem but just found during review.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 mm/shmem.c  |    6 ++++++
 mm/vmscan.c |   11 ++++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff -puN mm/shmem.c~vmscan-add-barrier-to-prevent-evictable-page-in-unevictable-list mm/shmem.c
--- a/mm/shmem.c~vmscan-add-barrier-to-prevent-evictable-page-in-unevictable-list
+++ a/mm/shmem.c
@@ -1068,6 +1068,12 @@ int shmem_lock(struct file *file, int lo
 		user_shm_unlock(inode->i_size, user);
 		info->flags &= ~VM_LOCKED;
 		mapping_clear_unevictable(file->f_mapping);
+		/*
+		 * Ensure that a racing putback_lru_page() can see
+		 * the pages of this mapping are evictable when we
+		 * skip them due to !PageLRU during the scan.
+		 */
+		smp_mb__after_clear_bit();
 		scan_mapping_unevictable_pages(file->f_mapping);
 	}
 	retval = 0;
diff -puN mm/vmscan.c~vmscan-add-barrier-to-prevent-evictable-page-in-unevictable-list mm/vmscan.c
--- a/mm/vmscan.c~vmscan-add-barrier-to-prevent-evictable-page-in-unevictable-list
+++ a/mm/vmscan.c
@@ -633,13 +633,14 @@ redo:
 		lru = LRU_UNEVICTABLE;
 		add_page_to_unevictable_list(page);
 		/*
-		 * When racing with an mlock clearing (page is
-		 * unlocked), make sure that if the other thread does
-		 * not observe our setting of PG_lru and fails
-		 * isolation, we see PG_mlocked cleared below and move
+		 * When racing with an mlock or AS_UNEVICTABLE clearing
+		 * (page is unlocked) make sure that if the other thread
+		 * does not observe our setting of PG_lru and fails
+		 * isolation/check_move_unevictable_page,
+		 * we see PG_mlocked/AS_UNEVICTABLE cleared below and move
 		 * the page back to the evictable list.
 		 *
-		 * The other side is TestClearPageMlocked().
+		 * The other side is TestClearPageMlocked() or shmem_lock().
 		 */
 		smp_mb();
 	}
_
Subject: Subject: vmscan: add barrier to prevent evictable page in unevictable list

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-change-isolate-mode-from-define-to-bitwise-type-fix.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-compaction-make-isolate_lru_page-filter-aware-fix.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware-fix.patch
mm-migration-clean-up-unmap_and_move.patch
vmscan-add-block-plug-for-page-reclaim.patch
mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
vmscan-count-pages-into-balanced-for-zone-with-good-watermark.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-add-free_hot_cold_page_list-helper.patch
mm-compaction-compact-unevictable-pages.patch
mm-compaction-compact-unevictable-pages-checkpatch-fixes.patch
mm-compaction-accounting-fix.patch
kswapd-assign-new_order-and-new_classzone_idx-after-wakeup-in-sleeping.patch
thp-tail-page-refcounting-fix-5.patch
thp-tail-page-refcounting-fix-6.patch
mm-compaction-make-compact_zone_order-static.patch
mm-disable-user-interface-to-manually-rescue-unevictable-pages.patch
vmscan-add-barrier-to-prevent-evictable-page-in-unevictable-list.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch
memcg-skip-scanning-active-lists-based-on-individual-size-fix.patch

