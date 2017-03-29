From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-thp-swap-support-to-split-thp-in-swap-cache.patch removed from -mm tree
Date: Wed, 29 Mar 2017 13:59:40 -0700
Message-ID: <58dc203c.md2Xbj+jUTLBCaGE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56526 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932738AbdC2U7m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2017 16:59:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, ebru.akagunduz@gmail.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tj@kernel.org, vdavydov@tarantool.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, THP, swap: support to split THP in swap cache
has been removed from the -mm tree.  Its filename was
     mm-thp-swap-support-to-split-thp-in-swap-cache.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, THP, swap: support to split THP in swap cache

This patch enhances split_huge_page_to_list() to work properly for the THP
(Transparent Huge Page) in the swap cache during swapping out.

This is used for delaying splitting the THP during swapping out.  Where
for a THP to be swapped out, we will allocate a swap cluster, add the THP
into the swap cache, then split the THP.  The page lock will be held
during this process.  So in the code path other than swapping out, if the
THP need to be split, the PageSwapCache(THP) will be always false.

Link: http://lkml.kernel.org/r/20170328053209.25876-9-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@tarantool.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-swap-support-to-split-thp-in-swap-cache mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-swap-support-to-split-thp-in-swap-cache
+++ a/mm/huge_memory.c
@@ -2185,7 +2185,7 @@ static void __split_huge_page_tail(struc
 	 * atomic_set() here would be safe on all archs (and not only on x86),
 	 * it's safer to use atomic_inc()/atomic_add().
 	 */
-	if (PageAnon(head)) {
+	if (PageAnon(head) && !PageSwapCache(head)) {
 		page_ref_inc(page_tail);
 	} else {
 		/* Additional pin to radix tree */
@@ -2196,6 +2196,7 @@ static void __split_huge_page_tail(struc
 	page_tail->flags |= (head->flags &
 			((1L << PG_referenced) |
 			 (1L << PG_swapbacked) |
+			 (1L << PG_swapcache) |
 			 (1L << PG_mlocked) |
 			 (1L << PG_uptodate) |
 			 (1L << PG_active) |
@@ -2258,7 +2259,11 @@ static void __split_huge_page(struct pag
 	ClearPageCompound(head);
 	/* See comment in __split_huge_page_tail() */
 	if (PageAnon(head)) {
-		page_ref_inc(head);
+		/* Additional pin to radix tree of swap cache */
+		if (PageSwapCache(head))
+			page_ref_add(head, 2);
+		else
+			page_ref_inc(head);
 	} else {
 		/* Additional pin to radix tree */
 		page_ref_add(head, 2);
@@ -2370,10 +2375,12 @@ int page_trans_huge_mapcount(struct page
 /* Racy check whether the huge page can be split */
 bool can_split_huge_page(struct page *page, int *pextra_pins)
 {
-	int extra_pins = 0;
+	int extra_pins;
 
 	/* Additional pins from radix tree */
-	if (!PageAnon(page))
+	if (PageAnon(page))
+		extra_pins = PageSwapCache(page) ? HPAGE_PMD_NR : 0;
+	else
 		extra_pins = HPAGE_PMD_NR;
 	if (pextra_pins)
 		*pextra_pins = extra_pins;
@@ -2427,7 +2434,6 @@ int split_huge_page_to_list(struct page
 			ret = -EBUSY;
 			goto out;
 		}
-		extra_pins = 0;
 		mapping = NULL;
 		anon_vma_lock_write(anon_vma);
 	} else {
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-fix-a-race-in-free_swap_and_cache.patch
mm-swap-fix-comment-in-__read_swap_cache_async.patch
mm-swap-improve-readability-via-make-spin_lock-unlock-balanced.patch
mm-swap-avoid-lock-swap_avail_lock-when-held-cluster-lock.patch
mm-thp-swap-delay-splitting-thp-during-swap-out.patch

