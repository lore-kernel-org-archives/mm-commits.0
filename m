From: akpm@linux-foundation.org
Subject: +
 mm-alloc_contig_range-demote-pages-busy-message-from-warn-to-info.patch
 added to -mm tree
Date: Tue, 04 Nov 2014 14:09:01 -0800
Message-ID: <54594e7d.PNbe1LnrzS0pswhO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaKDWJA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 17:09:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mina86@mina86.com, laurent.pinchart@ideasonboard.com, minchan@kernel.org, peter@hurleysoftware.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: alloc_contig_range: demote pages busy message from warn to info
has been added to the -mm tree.  Its filename is
     mm-alloc_contig_range-demote-pages-busy-message-from-warn-to-info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-alloc_contig_range-demote-pages-busy-message-from-warn-to-info.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-alloc_contig_range-demote-pages-busy-message-from-warn-to-info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Nazarewicz <mina86@mina86.com>
Subject: mm: alloc_contig_range: demote pages busy message from warn to info

Having test_pages_isolated failure message as a warning confuses users
into thinking that it is more serious than it really is.  In reality, if
called via CMA, allocation will be retried so a single test_pages_isolated
failure does not prevent allocation from succeeding.

Demote the warning message to an info message and reformat it such that
the text "failed" does not appear and instead a less worrying "PFNS busy"
is used.

This message is trivially reproducible on a 10GB x86 machine on 3.16.y
kernels configured with CONFIG_DMA_CMA.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-alloc_contig_range-demote-pages-busy-message-from-warn-to-info mm/page_alloc.c
--- a/mm/page_alloc.c~mm-alloc_contig_range-demote-pages-busy-message-from-warn-to-info
+++ a/mm/page_alloc.c
@@ -6397,13 +6397,12 @@ int alloc_contig_range(unsigned long sta
 
 	/* Make sure the range is really isolated. */
 	if (test_pages_isolated(outer_start, end, false)) {
-		pr_warn("alloc_contig_range test_pages_isolated(%lx, %lx) failed\n",
-		       outer_start, end);
+		pr_info("%s: [%lx, %lx) PFNs busy\n",
+			__func__, outer_start, end);
 		ret = -EBUSY;
 		goto done;
 	}
 
-
 	/* Grab isolated pages from freelists. */
 	outer_end = isolate_freepages_range(&cc, outer_start, end);
 	if (!outer_end) {
_

Patches currently in -mm which might be from mina86@mina86.com are

origin.patch
mm-compaction-skip-the-range-until-proper-target-pageblock-is-met.patch
mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype.patch
mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch
mm-page_alloc-move-freepage-counting-logic-to-__free_one_page.patch
mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock.patch
mm-alloc_contig_range-demote-pages-busy-message-from-warn-to-info.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
linux-next.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch
debugging-keep-track-of-page-owners.patch

