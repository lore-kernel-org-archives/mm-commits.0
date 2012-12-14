From: akpm@linux-foundation.org
Subject: [merged] mm-use-migrate_prep-instead-of-migrate_prep_local.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:27:55 -0800
Message-ID: <20121214232755.A97F482004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:50539 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab2LNX15 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:27:57 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so408838qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:27:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.szyprowski@samsung.com, kyungmin.park@samsung.com, mina86@mina86.com, sunghwan.yun@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use migrate_prep() instead of migrate_prep_local()
has been removed from the -mm tree.  Its filename was
     mm-use-migrate_prep-instead-of-migrate_prep_local.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: mm: use migrate_prep() instead of migrate_prep_local()

__alloc_contig_migrate_range() should use all possible ways to get all the
pages migrated from the given memory range, so pruning per-cpu lru lists
for all CPUs is required, regadless the cost of such operation.  Otherwise
some pages which got stuck at per-cpu lru list might get missed by
migration procedure causing the contiguous allocation to fail.

Reported-by: SeongHwan Yoon <sunghwan.yun@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-use-migrate_prep-instead-of-migrate_prep_local mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-migrate_prep-instead-of-migrate_prep_local
+++ a/mm/page_alloc.c
@@ -5727,7 +5727,7 @@ static int __alloc_contig_migrate_range(
 	unsigned int tries = 0;
 	int ret = 0;
 
-	migrate_prep_local();
+	migrate_prep();
 
 	while (pfn < end || !list_empty(&cc->migratepages)) {
 		if (fatal_signal_pending(current)) {
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

origin.patch
linux-next.patch
mm-cma-warn-if-freed-memory-is-still-in-use.patch

