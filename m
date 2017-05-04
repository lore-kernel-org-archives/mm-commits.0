From: akpm@linux-foundation.org
Subject: [merged] mm-swap-fix-a-race-in-free_swap_and_cache.patch
 removed from -mm tree
Date: Thu, 04 May 2017 12:10:00 -0700
Message-ID: <20170504191000.XiqWyI2YG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51038 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756338AbdEDTKB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:10:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@intel.com, ying.huang@intel.com


The patch titled
     Subject: mm, swap: Fix a race in free_swap_and_cache()
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-a-race-in-free_swap_and_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, swap: Fix a race in free_swap_and_cache()

Before using cluster lock in free_swap_and_cache(), the
swap_info_struct->lock will be held during freeing the swap entry and
acquiring page lock, so the page swap count will not change when testing
page information later.  But after using cluster lock, the cluster lock
(or swap_info_struct->lock) will be held only during freeing the swap
entry.  So before acquiring the page lock, the page swap count may be
changed in another thread.  If the page swap count is not 0, we should not
delete the page from the swap cache.  This is fixed via checking page swap
count again after acquiring the page lock.

I found the race when I review the code, so I didn't trigger the race
via a test program.  If the race occurs for an anonymous page shared by
multiple processes via fork, multiple pages will be allocated and
swapped in from the swap device for the previously shared one page. 
That is, the user-visible runtime effect is more memory will be used
and the access latency for the page will be higher, that is, the
performance regression.

Link: http://lkml.kernel.org/r/20170301143905.12846-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff -puN mm/swapfile.c~mm-swap-fix-a-race-in-free_swap_and_cache mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-fix-a-race-in-free_swap_and_cache
+++ a/mm/swapfile.c
@@ -1111,6 +1111,18 @@ int page_swapcount(struct page *page)
 	return count;
 }
 
+static int swap_swapcount(struct swap_info_struct *si, swp_entry_t entry)
+{
+	int count = 0;
+	pgoff_t offset = swp_offset(entry);
+	struct swap_cluster_info *ci;
+
+	ci = lock_cluster_or_swap_info(si, offset);
+	count = swap_count(si->swap_map[offset]);
+	unlock_cluster_or_swap_info(si, ci);
+	return count;
+}
+
 /*
  * How many references to @entry are currently swapped out?
  * This does not give an exact answer when swap count is continued,
@@ -1119,17 +1131,11 @@ int page_swapcount(struct page *page)
 int __swp_swapcount(swp_entry_t entry)
 {
 	int count = 0;
-	pgoff_t offset;
 	struct swap_info_struct *si;
-	struct swap_cluster_info *ci;
 
 	si = __swap_info_get(entry);
-	if (si) {
-		offset = swp_offset(entry);
-		ci = lock_cluster_or_swap_info(si, offset);
-		count = swap_count(si->swap_map[offset]);
-		unlock_cluster_or_swap_info(si, ci);
-	}
+	if (si)
+		count = swap_swapcount(si, entry);
 	return count;
 }
 
@@ -1291,7 +1297,8 @@ int free_swap_and_cache(swp_entry_t entr
 		 * Also recheck PageSwapCache now page is locked (above).
 		 */
 		if (PageSwapCache(page) && !PageWriteback(page) &&
-		    (!page_mapped(page) || mem_cgroup_swap_full(page))) {
+		    (!page_mapped(page) || mem_cgroup_swap_full(page)) &&
+		    !swap_swapcount(p, entry)) {
 			delete_from_swap_cache(page);
 			SetPageDirty(page);
 		}
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-use-kvzalloc-to-allocate-some-swap-data-structure.patch

