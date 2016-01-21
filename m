From: akpm@linux-foundation.org
Subject: + thp-limit-number-of-object-to-scan-on-deferred_split_scan.patch added to -mm tree
Date: Thu, 21 Jan 2016 13:21:00 -0800
Message-ID: <56a14bbc.S8tK8MigoQ6aP1Sp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbcAUVVB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 16:21:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: limit number of object to scan on deferred_split_scan()
has been added to the -mm tree.  Its filename is
     thp-limit-number-of-object-to-scan-on-deferred_split_scan.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-limit-number-of-object-to-scan-on-deferred_split_scan.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-limit-number-of-object-to-scan-on-deferred_split_scan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: limit number of object to scan on deferred_split_scan()

If we have a lot of pages in queue to be split, deferred_split_scan()
can spend unreasonable amount of time under spinlock with disabled
interrupts.

Let's cap number of pages to split on scan by sc->nr_to_scan.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Andrea Arcangeli <aarcange@redhat.com>
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

mm-softirq-safe-softirq-unsafe-lock-order-detected-in-split_huge_page_to_list.patch
mm-proc-add-workaround-for-old-compilers.patch
thp-change-pmd_trans_huge_lock-interface-to-return-ptl.patch
mlocked-pages-statistics-shows-bogus-value.patch
thp-make-split_queue-per-node.patch
thp-change-deferred_split_count-to-return-number-of-thp-in-queue.patch
thp-limit-number-of-object-to-scan-on-deferred_split_scan.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

