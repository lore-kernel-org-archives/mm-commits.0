From: akpm@linux-foundation.org
Subject: + mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp.patch added to -mm tree
Date: Fri, 01 Feb 2013 14:15:38 -0800
Message-ID: <20130201221538.A33C631C1BF@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:44139 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757883Ab3BAWPk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2013 17:15:40 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so127929qaj.3
        for <mm-commits@vger.kernel.org>; Fri, 01 Feb 2013 14:15:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, fengguang.wu@intel.com, tony.luck@intel.com


The patch titled
     Subject: mm/memory-failure.c: fix wrong num_poisoned_pages in handling memory error on thp
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp.patch

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
+	 * Currently errors on hugetlbfs pages are contained in hugepage
+	 * unit, so nr_pages should be 1 << compound_order. OTOH when
+	 * errors are on transparent hugepages, they are supposed to be
+	 * split and error containment is done in normal page unit.
+	 * So nr_pages should be one in this case.
+	 */
+	if (PageHuge(p))
+		nr_pages = 1 << compound_order(hpage);
+	else /* normal page or thp */
+		nr_pages = 1;
 	atomic_long_add(nr_pages, &num_poisoned_pages);
 
 	/*
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

memory-failure-fix-an-error-of-mce_bad_pages-statistics.patch
mm-memory-failurec-clean-up-soft_offline_page.patch
mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp.patch

