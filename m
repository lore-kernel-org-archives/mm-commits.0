From: akpm@linux-foundation.org
Subject: [merged]
 thp-change-deferred_split_count-to-return-number-of-thp-in-queue.patch
 removed from -mm tree
Date: Wed, 03 Feb 2016 13:52:53 -0800
Message-ID: <56b276b5.IHqe0KF5HspqSOLp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130AbcBCVwy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 16:52:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: change deferred_split_count() to return number of THP in queue
has been removed from the -mm tree.  Its filename was
     thp-change-deferred_split_count-to-return-number-of-thp-in-queue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: change deferred_split_count() to return number of THP in queue

I've got meaning of shrinker::count_objects() wrong: it should return
number of potentially freeable objects, which is not necessary correlate
with freeable memory.

Returning 256 per THP in queue is not reasonable:
shrinker::scan_objects() never called with nr_to_scan > 128 in my setup.

Let's return 1 per THP and correct scan_object accordingly.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN mm/huge_memory.c~thp-change-deferred_split_count-to-return-number-of-thp-in-queue mm/huge_memory.c
--- a/mm/huge_memory.c~thp-change-deferred_split_count-to-return-number-of-thp-in-queue
+++ a/mm/huge_memory.c
@@ -3465,12 +3465,7 @@ static unsigned long deferred_split_coun
 		struct shrink_control *sc)
 {
 	struct pglist_data *pgdata = NODE_DATA(sc->nid);
-	/*
-	 * Split a page from split_queue will free up at least one page,
-	 * at most HPAGE_PMD_NR - 1. We don't track exact number.
-	 * Let's use HPAGE_PMD_NR / 2 as ballpark.
-	 */
-	return ACCESS_ONCE(pgdata->split_queue_len) * HPAGE_PMD_NR / 2;
+	return ACCESS_ONCE(pgdata->split_queue_len);
 }
 
 static unsigned long deferred_split_scan(struct shrinker *shrink,
@@ -3511,7 +3506,13 @@ static unsigned long deferred_split_scan
 	list_splice_tail(&list, &pgdata->split_queue);
 	spin_unlock_irqrestore(&pgdata->split_queue_lock, flags);
 
-	return split * HPAGE_PMD_NR / 2;
+	/*
+	 * Stop shrinker if we didn't split any page, but the queue is empty.
+	 * This can happen if pages were freed under us.
+	 */
+	if (!split && list_empty(&pgdata->split_queue))
+		return SHRINK_STOP;
+	return split;
 }
 
 static struct shrinker deferred_split_shrinker = {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mempolicy-do-not-try-to-queue-pages-from-vma_migratable.patch
mm-downgrade-vm_bug-in-isolate_lru_page-to-warning.patch
ipc-shm-handle-removed-segments-gracefully-in-shm_mmap.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

