From: akpm@linux-foundation.org
Subject: + mm-soft-offline-dissolve-free-hugepage-if-soft-offlined.patch
 added to -mm tree
Date: Thu, 01 Jun 2017 15:38:05 -0700
Message-ID: <5930974d.8+wYDIVoS/5N6Ro7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41670 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751134AbdFAWiG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2017 18:38:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: soft-offline: dissolve free hugepage if soft-offlined
has been added to the -mm tree.  Its filename is
     mm-soft-offline-dissolve-free-hugepage-if-soft-offlined.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-soft-offline-dissolve-free-hugepage-if-soft-offlined.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-soft-offline-dissolve-free-hugepage-if-soft-offlined.patch

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
@@ -1694,7 +1694,7 @@ static void soft_offline_free_page(struc
 	if (!TestSetPageHWPoison(head)) {
 		num_poisoned_pages_inc();
 		if (PageHuge(head))
-			dequeue_hwpoisoned_huge_page(head);
+			dissolve_free_huge_page(page);
 	}
 }
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-drop-null-return-check-of-pte_offset_map_lock.patch
mm-hugetlb-prevent-reuse-of-hwpoisoned-free-hugepages.patch
mm-hugetlb-return-immediately-for-hugetlb-page-in-__delete_from_page_cache.patch
mm-hwpoison-change-pagehwpoison-behavior-on-hugetlb-pages.patch
mm-soft-offline-dissolve-free-hugepage-if-soft-offlined.patch
mm-hwpoison-introduce-memory_failure_hugetlb.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error.patch
mm-hugetlb-delete-dequeue_hwpoisoned_huge_page.patch
mm-hwpoison-introduce-idenfity_page_state.patch

