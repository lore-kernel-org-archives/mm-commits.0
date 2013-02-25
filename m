From: akpm@linux-foundation.org
Subject: [merged] mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:52:01 -0800
Message-ID: <20130225205201.B11C331C26E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:61305 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759681Ab3BYUwD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:52:03 -0500
Received: by mail-qe0-f73.google.com with SMTP id 3so70389qea.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:52:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, fengguang.wu@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: fix wrong num_poisoned_pages in handling memory error on thp
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/memory-failure.c: fix wrong num_poisoned_pages in handling memory error on thp

num_poisoned_pages counts up the number of pages isolated by memory
errors.  But for thp, only one subpage is isolated because memory error
handler splits it, so it's wrong to add (1 << compound_trans_order).

[akpm@linux-foundation.org: tweak comment]
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp
+++ a/mm/memory-failure.c
@@ -1039,7 +1039,17 @@ int memory_failure(unsigned long pfn, in
 		return 0;
 	}
 
-	nr_pages = 1 << compound_trans_order(hpage);
+	/*
+	 * Currently errors on hugetlbfs pages are measured in hugepage units,
+	 * so nr_pages should be 1 << compound_order.  OTOH when errors are on
+	 * transparent hugepages, they are supposed to be split and error
+	 * measurement is done in normal page units.  So nr_pages should be one
+	 * in this case.
+	 */
+	if (PageHuge(p))
+		nr_pages = 1 << compound_order(hpage);
+	else /* normal page or thp */
+		nr_pages = 1;
 	atomic_long_add(nr_pages, &num_poisoned_pages);
 
 	/*
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch

