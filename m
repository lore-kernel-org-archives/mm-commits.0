From: akpm@linux-foundation.org
Subject: [merged]
 mm-soft-offline-fix-num_poisoned_pages-counting-on-concurrent-events.patch
 removed from -mm tree
Date: Wed, 06 May 2015 11:58:22 -0700
Message-ID: <554a644e.g8DUFm9ektru7XnD%akpm__17833.8700360202$1430938716$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbbEFS6X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2015 14:58:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, dnelson@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: soft-offline: fix num_poisoned_pages counting on concurrent events
has been removed from the -mm tree.  Its filename was
     mm-soft-offline-fix-num_poisoned_pages-counting-on-concurrent-events.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Dean Nelson <dnelson@redhat.com>
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
mm-hwpoison-add-comment-describing-when-to-add-new-cases.patch
mm-hwpoison-remove-obsolete-notebook-todo-list.patch
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

