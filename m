From: akpm@linux-foundation.org
Subject: [merged] thp-get-deferred_split_scan-work-again.patch removed
 from -mm tree
Date: Wed, 10 Feb 2016 11:36:01 -0800
Message-ID: <56bb9121.fw22ChOicAyTl4GR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42585 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbcBJTgC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 14:36:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: make deferred_split_scan() work again
has been removed from the -mm tree.  Its filename was
     thp-get-deferred_split_scan-work-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: make deferred_split_scan() work again

We need to iterate over split_queue, not local empty list to get anything
split from the shrinker.

Fixes: e3ae19535c66 ("thp: limit number of object to scan on deferred_split_scan()")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-get-deferred_split_scan-work-again mm/huge_memory.c
--- a/mm/huge_memory.c~thp-get-deferred_split_scan-work-again
+++ a/mm/huge_memory.c
@@ -3482,7 +3482,7 @@ static unsigned long deferred_split_scan
 
 	spin_lock_irqsave(&pgdata->split_queue_lock, flags);
 	/* Take pin on all head pages to avoid freeing them under us */
-	list_for_each_safe(pos, next, &list) {
+	list_for_each_safe(pos, next, &pgdata->split_queue) {
 		page = list_entry((void *)pos, struct page, mapping);
 		page = compound_head(page);
 		if (get_page_unless_zero(page)) {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-dax-check-for-pmd_none-after-split_huge_pmd.patch
ipc-shm-handle-removed-segments-gracefully-in-shm_mmap.patch
thp-cleanup-split_huge_page.patch
thp-vmstats-count-deferred-split-events.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

