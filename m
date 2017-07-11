From: akpm@linux-foundation.org
Subject: [merged]
 mm-soft-offline-dissolve-free-hugepage-if-soft-offlined.patch removed from
 -mm tree
Date: Tue, 11 Jul 2017 12:23:07 -0700
Message-ID: <20170711192307.7OR38kwLi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47558 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933570AbdGKTXI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:23:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: mm: soft-offline: dissolve free hugepage if soft-offlined
has been removed from the -mm tree.  Its filename was
     mm-soft-offline-dissolve-free-hugepage-if-soft-offlined.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: soft-offline: dissolve free hugepage if soft-offlined

Now we have code to rescue most of healthy pages from a hwpoisoned
hugepage.  So let's apply it to soft_offline_free_page too.

Link: http://lkml.kernel.org/r/1496305019-5493-6-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-soft-offline-dissolve-free-hugepage-if-soft-offlined mm/memory-failure.c
--- a/mm/memory-failure.c~mm-soft-offline-dissolve-free-hugepage-if-soft-offlined
+++ a/mm/memory-failure.c
@@ -1697,7 +1697,7 @@ static void soft_offline_free_page(struc
 	if (!TestSetPageHWPoison(head)) {
 		num_poisoned_pages_inc();
 		if (PageHuge(head))
-			dequeue_hwpoisoned_huge_page(head);
+			dissolve_free_huge_page(page);
 	}
 }
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are


