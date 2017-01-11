From: akpm@linux-foundation.org
Subject: [patch 26/27] mm/hugetlb.c: fix reservation race when freeing
 surplus pages
Date: Tue, 10 Jan 2017 16:58:27 -0800
Message-ID: <58758333.VeJx5vSVuIzHzBXy%akpm__39276.1962874376$1484096359$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33634 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759981AbdAKA62 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2017 19:58:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mike.kravetz@oracle.com, aneesh.kumar@linux.vnet.ibm.com, cassella@cray.com, hillf.zj@alibaba-inc.com, m.mizuma@jp.fujitsu.com, mhocko@kernel.org, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb.c: fix reservation race when freeing surplus pages

return_unused_surplus_pages() decrements the global reservation count, and
frees any unused surplus pages that were backing the reservation.  Commit
7848a4bf51b3 ("mm/hugetlb.c: add cond_resched_lock() in
return_unused_surplus_pages()") added a call to cond_resched_lock in the
loop freeing the pages.  As a result, the hugetlb_lock could be dropped,
and someone else could use the pages that will be freed in subsequent
iterations of the loop.  This could result in inconsistent global hugetlb
page state, application api failures (such as mmap) failures or
application crashes.

When dropping the lock in return_unused_surplus_pages, make sure that the
global reservation count (resv_huge_pages) remains sufficiently large to
prevent someone else from claiming pages about to be freed.

Analyzed by Paul Cassella.

Fixes: 7848a4bf51b3 ("mm/hugetlb.c: add cond_resched_lock() in return_unused_surplus_pages()")
Link: http://lkml.kernel.org/r/1483991767-6879-1-git-send-email-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Paul Cassella <cassella@cray.com>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: <stable@vger.kernel.org>	[3.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-fix-reservation-race-when-freeing-surplus-pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-fix-reservation-race-when-freeing-surplus-pages
+++ a/mm/hugetlb.c
@@ -1773,23 +1773,32 @@ free:
 }
 
 /*
- * When releasing a hugetlb pool reservation, any surplus pages that were
- * allocated to satisfy the reservation must be explicitly freed if they were
- * never used.
- * Called with hugetlb_lock held.
+ * This routine has two main purposes:
+ * 1) Decrement the reservation count (resv_huge_pages) by the value passed
+ *    in unused_resv_pages.  This corresponds to the prior adjustments made
+ *    to the associated reservation map.
+ * 2) Free any unused surplus pages that may have been allocated to satisfy
+ *    the reservation.  As many as unused_resv_pages may be freed.
+ *
+ * Called with hugetlb_lock held.  However, the lock could be dropped (and
+ * reacquired) during calls to cond_resched_lock.  Whenever dropping the lock,
+ * we must make sure nobody else can claim pages we are in the process of
+ * freeing.  Do this by ensuring resv_huge_page always is greater than the
+ * number of huge pages we plan to free when dropping the lock.
  */
 static void return_unused_surplus_pages(struct hstate *h,
 					unsigned long unused_resv_pages)
 {
 	unsigned long nr_pages;
 
-	/* Uncommit the reservation */
-	h->resv_huge_pages -= unused_resv_pages;
-
 	/* Cannot return gigantic pages currently */
 	if (hstate_is_gigantic(h))
-		return;
+		goto out;
 
+	/*
+	 * Part (or even all) of the reservation could have been backed
+	 * by pre-allocated pages. Only free surplus pages.
+	 */
 	nr_pages = min(unused_resv_pages, h->surplus_huge_pages);
 
 	/*
@@ -1799,12 +1808,22 @@ static void return_unused_surplus_pages(
 	 * when the nodes with surplus pages have no free pages.
 	 * free_pool_huge_page() will balance the the freed pages across the
 	 * on-line nodes with memory and will handle the hstate accounting.
+	 *
+	 * Note that we decrement resv_huge_pages as we free the pages.  If
+	 * we drop the lock, resv_huge_pages will still be sufficiently large
+	 * to cover subsequent pages we may free.
 	 */
 	while (nr_pages--) {
+		h->resv_huge_pages--;
+		unused_resv_pages--;
 		if (!free_pool_huge_page(h, &node_states[N_MEMORY], 1))
-			break;
+			goto out;
 		cond_resched_lock(&hugetlb_lock);
 	}
+
+out:
+	/* Fully uncommit the reservation */
+	h->resv_huge_pages -= unused_resv_pages;
 }
 
 
_
