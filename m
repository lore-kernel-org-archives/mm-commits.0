From: akpm@linux-foundation.org
Subject: [merged] thp-mm-split_huge_page-caller-need-to-lock-page.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:02:47 -0800
Message-ID: <569e9667.mw2yboJgfc10yiJz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203AbcASUCs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:02:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp, mm: split_huge_page(): caller need to lock page
has been removed from the -mm tree.  Its filename was
     thp-mm-split_huge_page-caller-need-to-lock-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp, mm: split_huge_page(): caller need to lock page

We're going to use migration entries instead of compound_lock() to
stabilize page refcounts. Setup and remove migration entries require
page to be locked.

Some of split_huge_page() callers already have the page locked. Let's
require everybody to lock the page before calling split_huge_page().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    8 +++++++-
 mm/migrate.c        |    8 ++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff -puN mm/memory-failure.c~thp-mm-split_huge_page-caller-need-to-lock-page mm/memory-failure.c
--- a/mm/memory-failure.c~thp-mm-split_huge_page-caller-need-to-lock-page
+++ a/mm/memory-failure.c
@@ -1149,7 +1149,9 @@ int memory_failure(unsigned long pfn, in
 	}
 
 	if (!PageHuge(p) && PageTransHuge(hpage)) {
+		lock_page(hpage);
 		if (!PageAnon(hpage) || unlikely(split_huge_page(hpage))) {
+			unlock_page(hpage);
 			if (!PageAnon(hpage))
 				pr_err("MCE: %#lx: non anonymous thp\n", pfn);
 			else
@@ -1159,6 +1161,7 @@ int memory_failure(unsigned long pfn, in
 			put_hwpoison_page(p);
 			return -EBUSY;
 		}
+		unlock_page(hpage);
 		VM_BUG_ON_PAGE(!page_count(p), p);
 		hpage = compound_head(p);
 	}
@@ -1751,7 +1754,10 @@ int soft_offline_page(struct page *page,
 		return -EBUSY;
 	}
 	if (!PageHuge(page) && PageTransHuge(hpage)) {
-		if (PageAnon(hpage) && unlikely(split_huge_page(hpage))) {
+		lock_page(page);
+		ret = split_huge_page(hpage);
+		unlock_page(page);
+		if (unlikely(ret)) {
 			pr_info("soft offline: %#lx: failed to split THP\n",
 				pfn);
 			if (flags & MF_COUNT_INCREASED)
diff -puN mm/migrate.c~thp-mm-split_huge_page-caller-need-to-lock-page mm/migrate.c
--- a/mm/migrate.c~thp-mm-split_huge_page-caller-need-to-lock-page
+++ a/mm/migrate.c
@@ -943,9 +943,13 @@ static ICE_noinline int unmap_and_move(n
 		goto out;
 	}
 
-	if (unlikely(PageTransHuge(page)))
-		if (unlikely(split_huge_page(page)))
+	if (unlikely(PageTransHuge(page))) {
+		lock_page(page);
+		rc = split_huge_page(page);
+		unlock_page(page);
+		if (rc)
 			goto out;
+	}
 
 	rc = __unmap_and_move(page, newpage, force, mode);
 	if (rc == MIGRATEPAGE_SUCCESS)
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
thp-fix-split_huge_page-after-mremap-of-thp.patch
memblock-fix-section-mismatch.patch
mm-fix-locking-order-in-mm_take_all_locks.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

