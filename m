From: akpm@linux-foundation.org
Subject: + mm-swap-fix-a-race-in-free_swap_and_cache.patch added to -mm
 tree
Date: Fri, 03 Mar 2017 14:44:07 -0800
Message-ID: <58b9f1b7.IQQKfk4vYiZS3uQn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44066 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751989AbdCCWu6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 17:50:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, hughd@google.com, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap: Fix a race in free_swap_and_cache()
has been added to the -mm tree.  Its filename is
     mm-swap-fix-a-race-in-free_swap_and_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-fix-a-race-in-free_swap_and_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-fix-a-race-in-free_swap_and_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-swap-fix-a-race-in-free_swap_and_cache.patch

