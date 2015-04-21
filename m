From: akpm@linux-foundation.org
Subject: +
 mm-soft-offline-fix-num_poisoned_pages-counting-on-concurrent-events.patch
 added to -mm tree
Date: Tue, 21 Apr 2015 15:23:58 -0700
Message-ID: <5536cdfe.Cr3fedX34dHahziE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643AbbDUWX7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Apr 2015 18:23:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, dnelson@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: soft-offline: fix num_poisoned_pages counting on concurrent events
has been added to the -mm tree.  Its filename is
     mm-soft-offline-fix-num_poisoned_pages-counting-on-concurrent-events.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-soft-offline-fix-num_poisoned_pages-counting-on-concurrent-events.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-soft-offline-fix-num_poisoned_pages-counting-on-concurrent-events.patch

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
Subject: mm: soft-offline: fix num_poisoned_pages counting on concurrent events

If multiple soft offline events hit one free page/hugepage concurrently,
soft_offline_page() can handle the free page/hugepage multiple times,
which makes num_poisoned_pages counter increased more than once.  This
patch fixes this wrong counting by checking TestSetPageHWPoison for normal
papes and by checking the return value of dequeue_hwpoisoned_huge_page()
for hugepages.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Dean Nelson <dnelson@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: <stable@vger.kernel.org>	[3.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memory-failure.c~mm-soft-offline-fix-num_poisoned_pages-counting-on-concurrent-events mm/memory-failure.c
--- a/mm/memory-failure.c~mm-soft-offline-fix-num_poisoned_pages-counting-on-concurrent-events
+++ a/mm/memory-failure.c
@@ -1777,12 +1777,12 @@ int soft_offline_page(struct page *page,
 	} else if (ret == 0) { /* for free pages */
 		if (PageHuge(page)) {
 			set_page_hwpoison_huge_page(hpage);
-			dequeue_hwpoisoned_huge_page(hpage);
-			atomic_long_add(1 << compound_order(hpage),
+			if (!dequeue_hwpoisoned_huge_page(hpage))
+				atomic_long_add(1 << compound_order(hpage),
 					&num_poisoned_pages);
 		} else {
-			SetPageHWPoison(page);
-			atomic_long_inc(&num_poisoned_pages);
+			if (!TestSetPageHWPoison(page))
+				atomic_long_inc(&num_poisoned_pages);
 		}
 	}
 	unset_migratetype_isolate(page, MIGRATE_MOVABLE);
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-memory-failure-call-shake_page-when-error-hits-thp-tail-page.patch
mm-soft-offline-fix-num_poisoned_pages-counting-on-concurrent-events.patch
mm-hwpoison-add-comment-describing-when-to-add-new-cases.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

