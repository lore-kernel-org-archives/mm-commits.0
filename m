From: akpm@linux-foundation.org
Subject: + mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch
 added to -mm tree
Date: Fri, 01 Aug 2014 14:54:16 -0700
Message-ID: <53dc0c88.Psp1vlO6i4A6MdBG%akpm__7445.38291260159$1406930071$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:59280 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177AbaHAVyS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Aug 2014 17:54:18 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so515859qap.0
        for <mm-commits@vger.kernel.org>; Fri, 01 Aug 2014 14:54:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, cl@linux.com, hughd@google.com, mel@csn.ul.ie, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: use get_page_unless_zero() in hugetlb_fault()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/hugetlb: use get_page_unless_zero() in hugetlb_fault()

After fixing locking in follow_page(FOLL_GET) for hugepages, I start to
observe the BUG of "get_page() on refcount 0 page" in hugetlb_fault() in
the same test.

I'm not exactly sure about how this race is triggered, but hugetlb_fault()
calls pte_page() and get_page() outside page table lock, so it's not safe.
 This patch checks the refcount of the gotten page, and aborts the page
fault if the refcount is 0, expecting to retry.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault
+++ a/mm/hugetlb.c
@@ -3192,7 +3192,8 @@ int hugetlb_fault(struct mm_struct *mm,
 	 * so no worry about deadlock.
 	 */
 	page = pte_page(entry);
-	get_page(page);
+	if (!get_page_unless_zero(page))
+		goto out_put_pagecache;
 	if (page != pagecache_page)
 		lock_page(page);
 
@@ -3218,15 +3219,14 @@ int hugetlb_fault(struct mm_struct *mm,
 
 out_ptl:
 	spin_unlock(ptl);
-
+	if (page != pagecache_page)
+		unlock_page(page);
+	put_page(page);
+out_put_pagecache:
 	if (pagecache_page) {
 		unlock_page(pagecache_page);
 		put_page(pagecache_page);
 	}
-	if (page != pagecache_page)
-		unlock_page(page);
-	put_page(page);
-
 out_mutex:
 	mutex_unlock(&htlb_fault_mutex_table[hash]);
 	return ret;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-memcontrol-rewrite-charge-api-fix-hugetlb-charging.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
mm-update-the-description-for-madvise_remove.patch
mm-hwpoison-injectc-remove-unnecessary-null-test-before-debugfs_remove_recursive.patch
hwpoison-fix-race-with-changing-page-during-offlining-v2.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages.patch
mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages-fix.patch
mm-softdirty-respect-vm_softdirty-in-pte-holes.patch
mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch
mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

