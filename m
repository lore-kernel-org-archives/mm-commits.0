From: akpm@linux-foundation.org
Subject: [merged] cma-decrease-ccnr_migratepages-after-reclaiming-pagelist.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:14:38 -0700
Message-ID: <20121009181438.BCDFD100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:44009 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab2JISOj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:14:39 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so661213ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:14:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, b.zolnierkie@samsung.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cma: decrease cc.nr_migratepages after reclaiming pagelist
has been removed from the -mm tree.  Its filename was
     cma-decrease-ccnr_migratepages-after-reclaiming-pagelist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: cma: decrease cc.nr_migratepages after reclaiming pagelist

reclaim_clean_pages_from_list() reclaims clean pages before migration so
cc.nr_migratepages should be updated.  Currently, there is no problem but
it can be wrong if we try to use the value in future.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~cma-decrease-ccnr_migratepages-after-reclaiming-pagelist mm/page_alloc.c
--- a/mm/page_alloc.c~cma-decrease-ccnr_migratepages-after-reclaiming-pagelist
+++ a/mm/page_alloc.c
@@ -5674,7 +5674,7 @@ static int __alloc_contig_migrate_range(
 					unsigned long start, unsigned long end)
 {
 	/* This function is based on compact_zone() from compaction.c. */
