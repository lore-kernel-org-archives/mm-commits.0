From: akpm@linux-foundation.org
Subject: [merged] vmscan-add-barrier-to-prevent-evictable-page-in-unevictable-list.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:11:52 -0700
Message-ID: <201111012111.pA1LBvUZ013842@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29484 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1KAVMf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:12:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: add barrier to prevent evictable page in unevictable list
has been removed from the -mm tree.  Its filename was
     vmscan-add-barrier-to-prevent-evictable-page-in-unevictable-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-add-free_hot_cold_page_list-helper.patch
thp-tail-page-refcounting-fix-5.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch
memcg-skip-scanning-active-lists-based-on-individual-size-fix.patch

