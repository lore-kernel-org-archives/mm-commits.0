From: akpm@linux-foundation.org
Subject: +
 mm-thp-swap-enable-thp-swap-optimization-only-if-has-compound-map.patch
 added to -mm tree
Date: Mon, 15 May 2017 13:18:19 -0700
Message-ID: <591a0d0b.hsMz5RsEtMJKVMVT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39688 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965496AbdEOUSU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 16:18:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, ebru.akagunduz@gmail.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, THP, swap: enable THP swap optimization only if has compound map
has been added to the -mm tree.  Its filename is
     mm-thp-swap-enable-thp-swap-optimization-only-if-has-compound-map.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-swap-enable-thp-swap-optimization-only-if-has-compound-map.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-swap-enable-thp-swap-optimization-only-if-has-compound-map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, THP, swap: enable THP swap optimization only if has compound map

If there is no compound map for a THP (Transparent Huge Page), it is
possible that the map count of some sub-pages of the THP is 0.  So it is
better to split the THP before swapping out.  In this way, the sub-pages
not mapped will be freed, and we can avoid the unnecessary swap out
operations for these sub-pages.

Link: http://lkml.kernel.org/r/20170515112522.32457-6-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~mm-thp-swap-enable-thp-swap-optimization-only-if-has-compound-map mm/vmscan.c
--- a/mm/vmscan.c~mm-thp-swap-enable-thp-swap-optimization-only-if-has-compound-map
+++ a/mm/vmscan.c
@@ -1125,10 +1125,19 @@ static unsigned long shrink_page_list(st
 		    !PageSwapCache(page)) {
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
-			/* cannot split THP, skip it */
-			if (PageTransHuge(page) &&
-			    !can_split_huge_page(page, NULL))
-				goto activate_locked;
+			if (PageTransHuge(page)) {
+				/* cannot split THP, skip it */
+				if (!can_split_huge_page(page, NULL))
+					goto activate_locked;
+				/*
+				 * Split pages without a PMD map right
+				 * away. Chances are some or all of the
+				 * tail pages can be freed without IO.
+				 */
+				if (!compound_mapcount(page) &&
+				    split_huge_page_to_list(page, page_list))
+					goto activate_locked;
+			}
 			if (!add_to_swap(page)) {
 				if (!PageTransHuge(page))
 					goto activate_locked;
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-thp-swap-delay-splitting-thp-during-swap-out.patch
mm-thp-swap-check-whether-thp-can-be-split-firstly.patch
mm-thp-swap-enable-thp-swap-optimization-only-if-has-compound-map.patch

