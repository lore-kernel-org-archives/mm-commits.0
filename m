From: akpm@linux-foundation.org
Subject: +
 mm-swapc-clear-pageactive-before-adding-pages-onto-unevictable-list.patch
 added to -mm tree
Date: Wed, 17 Jul 2013 14:02:26 -0700
Message-ID: <51e70662.Ohv+KcYmfa1NJy/G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51816 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab3GQVC1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Jul 2013 17:02:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, kosaki.motohiro@jp.fujitsu.com, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: + mm-swapc-clear-pageactive-before-adding-pages-onto-unevictable-list.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,kirill.shutemov@linux.intel.com,kosaki.motohiro@jp.fujitsu.com,mgorman@suse.de
From: akpm@linux-foundation.org
Date: Wed, 17 Jul 2013 14:02:26 -0700


The patch titled
     Subject: mm/swap.c: clear PageActive before adding pages onto unevictable list
has been added to the -mm tree.  Its filename is
     mm-swapc-clear-pageactive-before-adding-pages-onto-unevictable-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapc-clear-pageactive-before-adding-pages-onto-unevictable-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapc-clear-pageactive-before-adding-pages-onto-unevictable-list.patch

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
Subject: mm/swap.c: clear PageActive before adding pages onto unevictable list

As a result of v3.10-3600-g13f7f78 ("mm: pagevec: defer deciding which LRU
to add a page to until pagevec drain time"), pages on unevictable lists
can have both of PageActive and PageUnevictable set.  This is not only
confusing, but also corrupts page migration and shrink_[in]active_list.

This patch fixes the problem by adding ClearPageActive before adding pages
into unevictable list.  It also cleans up VM_BUG_ONs.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN mm/swap.c~mm-swapc-clear-pageactive-before-adding-pages-onto-unevictable-list mm/swap.c
--- a/mm/swap.c~mm-swapc-clear-pageactive-before-adding-pages-onto-unevictable-list
+++ a/mm/swap.c
@@ -512,12 +512,7 @@ EXPORT_SYMBOL(__lru_cache_add);
  */
 void lru_cache_add(struct page *page)
 {
-	if (PageActive(page)) {
-		VM_BUG_ON(PageUnevictable(page));
-	} else if (PageUnevictable(page)) {
-		VM_BUG_ON(PageActive(page));
-	}
-
+	VM_BUG_ON(PageActive(page) && PageUnevictable(page));
 	VM_BUG_ON(PageLRU(page));
 	__lru_cache_add(page);
 }
@@ -539,6 +534,7 @@ void add_page_to_unevictable_list(struct
 
 	spin_lock_irq(&zone->lru_lock);
 	lruvec = mem_cgroup_page_lruvec(page, zone);
+	ClearPageActive(page);
 	SetPageUnevictable(page);
 	SetPageLRU(page);
 	add_page_to_lru_list(page, lruvec, LRU_UNEVICTABLE);
@@ -833,7 +829,6 @@ static void __pagevec_lru_add_fn(struct
 	int active = PageActive(page);
 	enum lru_list lru = page_lru(page);
 
-	VM_BUG_ON(PageUnevictable(page));
 	VM_BUG_ON(PageLRU(page));
 
 	SetPageLRU(page);
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-swapc-clear-pageactive-before-adding-pages-onto-unevictable-list.patch

