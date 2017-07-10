From: akpm@linux-foundation.org
Subject: [patch 012/115] mm: soft-offline: dissolve free hugepage
 if soft-offlined
Date: Mon, 10 Jul 2017 15:47:44 -0700
Message-ID: <20170710224744.Sgy6KNq_8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42106 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754930AbdGJWrp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:47:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org

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
