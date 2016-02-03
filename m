From: akpm@linux-foundation.org
Subject: [merged]
 thp-limit-number-of-object-to-scan-on-deferred_split_scan.patch removed
 from -mm tree
Date: Wed, 03 Feb 2016 13:52:56 -0800
Message-ID: <56b276b8.cL3PjX+d8i5bdPng%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130AbcBCVw5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 16:52:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: limit number of object to scan on deferred_split_scan()
has been removed from the -mm tree.  Its filename was
     thp-limit-number-of-object-to-scan-on-deferred_split_scan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: limit number of object to scan on deferred_split_scan()

If we have a lot of pages in queue to be split, deferred_split_scan()
can spend unreasonable amount of time under spinlock with disabled
interrupts.

Let's cap number of pages to split on scan by sc->nr_to_scan.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Andrea Arcangeli <aarcange@redhat.com>
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

 mm/huge_memory.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/huge_memory.c~thp-limit-number-of-object-to-scan-on-deferred_split_scan mm/huge_memory.c
--- a/mm/huge_memory.c~thp-limit-number-of-object-to-scan-on-deferred_split_scan
+++ a/mm/huge_memory.c
@@ -3478,17 +3478,19 @@ static unsigned long deferred_split_scan
 	int split = 0;
 
 	spin_lock_irqsave(&pgdata->split_queue_lock, flags);
-	list_splice_init(&pgdata->split_queue, &list);
-
 	/* Take pin on all head pages to avoid freeing them under us */
 	list_for_each_safe(pos, next, &list) {
 		page = list_entry((void *)pos, struct page, mapping);
 		page = compound_head(page);
-		/* race with put_compound_page() */
-		if (!get_page_unless_zero(page)) {
+		if (get_page_unless_zero(page)) {
+			list_move(page_deferred_list(page), &list);
+		} else {
+			/* We lost race with put_compound_page() */
 			list_del_init(page_deferred_list(page));
 			pgdata->split_queue_len--;
 		}
+		if (!--sc->nr_to_scan)
+			break;
 	}
 	spin_unlock_irqrestore(&pgdata->split_queue_lock, flags);
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mempolicy-do-not-try-to-queue-pages-from-vma_migratable.patch
mm-downgrade-vm_bug-in-isolate_lru_page-to-warning.patch
ipc-shm-handle-removed-segments-gracefully-in-shm_mmap.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

