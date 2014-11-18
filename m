From: akpm@linux-foundation.org
Subject: +
 mm-frontswap-invalidate-expired-data-on-a-dup-store-failure.patch added to
 -mm tree
Date: Tue, 18 Nov 2014 13:41:14 -0800
Message-ID: <546bbcfa.DRfRa8weU7Z4elOu%akpm__41706.9128285677$1416346894$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36747 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbaKRVlP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Nov 2014 16:41:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weijie.yang@samsung.com, bob.liu@oracle.com, ddstreet@ieee.org, konrad.wilk@oracle.com, minchan@kernel.org, sjennings@variantweb.net, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: frontswap: invalidate expired data on a dup-store failure
has been added to the -mm tree.  Its filename is
     mm-frontswap-invalidate-expired-data-on-a-dup-store-failure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-frontswap-invalidate-expired-data-on-a-dup-store-failure.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-frontswap-invalidate-expired-data-on-a-dup-store-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm: frontswap: invalidate expired data on a dup-store failure

If a frontswap dup-store failed, it should invalidate the expired page
in the backend, or it could trigger some data corruption issue.
Such as:
1. use zswap as the frontswap backend with writeback feature
2. store a swap page(version_1) to entry A, success
3. dup-store a newer page(version_2) to the same entry A, fail
4. use __swap_writepage() write version_2 page to swapfile, success
5. zswap do shrink, writeback version_1 page to swapfile
6. version_2 page is overwrited by version_1, data corrupt.

This patch fixes this issue by invalidating expired data immediately
when meet a dup-store failure.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frontswap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/frontswap.c~mm-frontswap-invalidate-expired-data-on-a-dup-store-failure mm/frontswap.c
--- a/mm/frontswap.c~mm-frontswap-invalidate-expired-data-on-a-dup-store-failure
+++ a/mm/frontswap.c
@@ -244,8 +244,10 @@ int __frontswap_store(struct page *page)
 		  the (older) page from frontswap
 		 */
 		inc_frontswap_failed_stores();
-		if (dup)
+		if (dup) {
 			__frontswap_clear(sis, offset);
+			frontswap_ops->invalidate_page(type, offset);
+		}
 	}
 	if (frontswap_writethrough_enabled)
 		/* report failure so swap also writes to swap device */
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

mm-frontswap-invalidate-expired-data-on-a-dup-store-failure.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-mincore-add-hwpoison-page-handle.patch
mm-mincore-add-hwpoison-page-handle-checkpatch-fixes.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value-fix.patch

