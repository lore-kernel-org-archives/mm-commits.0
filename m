From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp.patch removed from -mm tree
Date: Fri, 01 Feb 2013 14:14:00 -0800
Message-ID: <20130201221401.6C1A15A4219@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:52100 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab3BAWOD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2013 17:14:03 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so429472qeb.0
        for <mm-commits@vger.kernel.org>; Fri, 01 Feb 2013 14:14:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, fengguang.wu@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: fix wrong num_poisoned_pages in handling memory error on thp
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/memory-failure.c: fix wrong num_poisoned_pages in handling memory error on thp

num_poisoned_pages counts up the number of pages isolated by memory
errors.  But for thp, only one subpage is isolated because memory error
handler splits it, so it's wrong to add (1 << compound_trans_order).

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp
+++ a/mm/memory-failure.c
@@ -1039,7 +1039,14 @@ int memory_failure(unsigned long pfn, in
 		return 0;
 	}
 
-	nr_pages = 1 << compound_trans_order(hpage);
+	/*
+	 * If a thp is hit by a memory failure, it's supposed to be split.
+	 * So we should add only one to num_poisoned_pages for that case.
+	 */
+	if (PageHuge(p))
+		nr_pages = 1 << compound_trans_order(hpage);
+	else /* normal page or thp */
+		nr_pages = 1;
 	atomic_long_add(nr_pages, &num_poisoned_pages);
 
 	/*
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

memory-failure-fix-an-error-of-mce_bad_pages-statistics.patch
mm-memory-failurec-clean-up-soft_offline_page.patch

