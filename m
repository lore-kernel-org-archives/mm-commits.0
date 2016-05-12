From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults-fix.patch removed from -mm tree
Date: Thu, 12 May 2016 15:18:37 -0700
Message-ID: <5735013d.nz6iyUnX8SZl8jGc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbcELWSi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2016 18:18:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: fix build of reuse_swap_page with CONFIG_SWAP=n
has been removed from the -mm tree.  Its filename was
     mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults-fix.patch

This patch was dropped because it was folded into mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults.patch

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: thp: fix build of reuse_swap_page with CONFIG_SWAP=n

page_trans_huge_compound is inline defined in mm.h. reuse_swap_page is
calling page_trans_huge_compound in swap.h which included early on by
mm.h before page_trans_huge_compound is defined.

This is why reuse_swap_page was a preprocessor macro, so make it a
preprocessor macro again.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN include/linux/swap.h~mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults-fix include/linux/swap.h
--- a/include/linux/swap.h~mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults-fix
+++ a/include/linux/swap.h
@@ -513,10 +513,8 @@ static inline int swp_swapcount(swp_entr
 	return 0;
 }
 
-static inline bool reuse_swap_page(struct page *page, int *total_mapcount)
-{
-	return page_trans_huge_mapcount(page, total_mapcount) == 1;
-}
+#define reuse_swap_page(page, total_mapcount) \
+	(page_trans_huge_mapcount(page, total_mapcount) == 1)
 
 static inline int try_to_free_swap(struct page *page)
 {
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults.patch
mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults-fix-2.patch
mm-thp-microoptimize-compound_mapcount.patch
mm-thp-split_huge_pmd_address-comment-improvement.patch

