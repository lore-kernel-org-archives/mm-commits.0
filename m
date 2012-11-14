From: akpm@linux-foundation.org
Subject: + mm-use-migrate_prep-instead-of-migrate_prep_local.patch added to -mm tree
Date: Wed, 14 Nov 2012 14:49:46 -0800
Message-ID: <20121114224946.B8854100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:55179 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997Ab2KNWts (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Nov 2012 17:49:48 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so106091vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Nov 2012 14:49:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, mina86@mina86.com, sunghwan.yun@samsung.com


The patch titled
     Subject: mm: use migrate_prep() instead of migrate_prep_local()
has been added to the -mm tree.  Its filename is
     mm-use-migrate_prep-instead-of-migrate_prep_local.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5764,7 +5764,7 @@ static int __alloc_contig_migrate_range(
 	unsigned int tries = 0;
 	int ret = 0;
 
-	migrate_prep_local();
+	migrate_prep();
 
 	while (pfn < end || !list_empty(&cc->migratepages)) {
 		if (fatal_signal_pending(current)) {
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

linux-next.patch
mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page.patch
mm-cma-remove-watermark-hacks.patch
mm-cma-remove-watermark-hacks-fix.patch
mm-cma-warn-if-freed-memory-is-still-in-use.patch
mm-use-migrate_prep-instead-of-migrate_prep_local.patch

