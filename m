From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory-failurec-fix-memory-leak-in-successful-soft-offlining.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:25:48 -0700
Message-ID: <51db123c.Co6R94Ey6lda2R1d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50495 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab3GHTZt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mel@csn.ul.ie, andi@firstfloor.org, n-horiguchi@ah.jp.nec.com

Subject: [merged] mm-memory-failurec-fix-memory-leak-in-successful-soft-offlining.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,andi@firstfloor.org,mel@csn.ul.ie,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:48 -0700


The patch titled
     Subject: mm/memory-failure.c: fix memory leak in successful soft offlining
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-fix-memory-leak-in-successful-soft-offlining.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/memory-failure.c: fix memory leak in successful soft offlining

After a successful page migration by soft offlining, the source page is
not properly freed and it's never reusable even if we unpoison it
afterward.

This is caused by the race between freeing page and setting PG_hwpoison. 
In successful soft offlining, the source page is put (and the refcount
becomes 0) by putback_lru_page() in unmap_and_move(), where it's linked to
pagevec and actual freeing back to buddy is delayed.  So if PG_hwpoison is
set for the page before freeing, the freeing does not functions as
expected (in such case freeing aborts in free_pages_prepare() check.)

This patch tries to make sure to free the source page before setting
PG_hwpoison on it.  To avoid reallocating, the page keeps MIGRATE_ISOLATE
until after setting PG_hwpoison.

This patch also removes obsolete comments about "keeping elevated
refcount" because what they say is not true.  Unlike memory_failure(),
soft_offline_page() uses no special page isolation code, and the
soft-offlined pages have no elevated.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failurec-fix-memory-leak-in-successful-soft-offlining mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-fix-memory-leak-in-successful-soft-offlining
+++ a/mm/memory-failure.c
@@ -1410,7 +1410,8 @@ static int __get_any_page(struct page *p
 
 	/*
 	 * Isolate the page, so that it doesn't get reallocated if it
-	 * was free.
+	 * was free. This flag should be kept set until the source page
+	 * is freed and PG_hwpoison on it is set.
 	 */
 	set_migratetype_isolate(p, true);
 	/*
@@ -1433,7 +1434,6 @@ static int __get_any_page(struct page *p
 		/* Not a free page */
 		ret = 1;
 	}
-	unset_migratetype_isolate(p, MIGRATE_MOVABLE);
 	unlock_memory_hotplug();
 	return ret;
 }
@@ -1494,7 +1494,6 @@ static int soft_offline_huge_page(struct
 		atomic_long_add(1 << compound_trans_order(hpage),
 				&num_poisoned_pages);
 	}
-	/* keep elevated page count for bad page */
 	return ret;
 }
 
@@ -1559,7 +1558,7 @@ int soft_offline_page(struct page *page,
 			atomic_long_inc(&num_poisoned_pages);
 		}
 	}
-	/* keep elevated page count for bad page */
+	unset_migratetype_isolate(page, MIGRATE_MOVABLE);
 	return ret;
 }
 
@@ -1625,7 +1624,22 @@ static int __soft_offline_page(struct pa
 			if (ret > 0)
 				ret = -EIO;
 		} else {
+			/*
+			 * After page migration succeeds, the source page can
+			 * be trapped in pagevec and actual freeing is delayed.
+			 * Freeing code works differently based on PG_hwpoison,
+			 * so there's a race. We need to make sure that the
+			 * source page should be freed back to buddy before
+			 * setting PG_hwpoison.
+			 */
+			if (!is_free_buddy_page(page))
+				lru_add_drain_all();
+			if (!is_free_buddy_page(page))
+				drain_all_pages();
 			SetPageHWPoison(page);
+			if (!is_free_buddy_page(page))
+				pr_info("soft offline: %#lx: page leaked\n",
+					pfn);
 			atomic_long_inc(&num_poisoned_pages);
 		}
 	} else {
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch

