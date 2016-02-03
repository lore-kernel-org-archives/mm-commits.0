From: akpm@linux-foundation.org
Subject: [folded-merged]
 thp-change-deferred_split_count-to-return-number-of-thp-in-queue-fix.patch
 removed from -mm tree
Date: Tue, 02 Feb 2016 16:54:53 -0800
Message-ID: <56b14fdd.wJXBLwNjcvzR66I9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbcBCAyy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 19:54:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: deferred_split_scan(): stop shrinker if the queue is empty
has been removed from the -mm tree.  Its filename was
     thp-change-deferred_split_count-to-return-number-of-thp-in-queue-fix.patch

This patch was dropped because it was folded into thp-change-deferred_split_count-to-return-number-of-thp-in-queue.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: deferred_split_scan(): stop shrinker if the queue is empty

If pages on queue were freed under us, deferred_split_scan() would
return zero. It makes caller keep calling deferred_split_scan() without
any result.

Let's return SHRINK_STOP in this situation.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
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

 mm/huge_memory.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/huge_memory.c~thp-change-deferred_split_count-to-return-number-of-thp-in-queue-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-change-deferred_split_count-to-return-number-of-thp-in-queue-fix
+++ a/mm/huge_memory.c
@@ -3506,6 +3506,12 @@ static unsigned long deferred_split_scan
 	list_splice_tail(&list, &pgdata->split_queue);
 	spin_unlock_irqrestore(&pgdata->split_queue_lock, flags);
 
+	/*
+	 * Stop shrinker if we didn't split any page, but the queue is empty.
+	 * This can happen if pages were freed under us.
+	 */
+	if (!split && list_empty(&pgdata->split_queue))
+		return SHRINK_STOP;
 	return split;
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-make-split_queue-per-node.patch
thp-change-deferred_split_count-to-return-number-of-thp-in-queue.patch
thp-limit-number-of-object-to-scan-on-deferred_split_scan.patch
drivers-scsi-sgc-mark-vma-as-vm_io-to-prevent-migration.patch
mempolicy-do-not-try-to-queue-pages-from-vma_migratable.patch
mm-downgrade-vm_bug-in-isolate_lru_page-to-warning.patch
ipc-shm-handle-removed-segments-gracefully-in-shm_mmap.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

