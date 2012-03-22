From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-make-compact_control-order-signed.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:50 -0700
Message-ID: <20120322201750.85200A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:33426 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab2CVUR4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:17:56 -0400
Received: by mail-gx0-f202.google.com with SMTP id d2so401419ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, aarcange@redhat.com, mel@csn.ul.ie, minchan@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: make compact_control order signed
has been removed from the -mm tree.  Its filename was
     mm-compaction-make-compact_control-order-signed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: mm: compaction: make compact_control order signed

"order" is -1 when compacting via /proc/sys/vm/compact_memory.  Making
it unsigned causes a bug in __compact_pgdat() when we test:

	if (cc->order < 0 || !compaction_deferred(zone, cc->order))
		compact_zone(zone, cc);

[akpm@linux-foundation.org: make __compact_pgdat()'s comparison match other code sites]
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan@kernel.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/compaction.c~mm-compaction-make-compact_control-order-signed mm/compaction.c
--- a/mm/compaction.c~mm-compaction-make-compact_control-order-signed
+++ a/mm/compaction.c
@@ -35,7 +35,7 @@ struct compact_control {
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
 	bool sync;			/* Synchronous migration */
 
-	unsigned int order;		/* order a direct compactor needs */
+	int order;			/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
 	struct zone *zone;
 };
@@ -692,7 +692,7 @@ static int __compact_pgdat(pg_data_t *pg
 		INIT_LIST_HEAD(&cc->freepages);
 		INIT_LIST_HEAD(&cc->migratepages);
 
-		if (cc->order < 0 || !compaction_deferred(zone, cc->order))
+		if (cc->order == -1 || !compaction_deferred(zone, cc->order))
 			compact_zone(zone, cc);
 
 		if (cc->order > 0) {
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
thermal-spear13xx-checking-for-null-instead-of-is_err.patch
backlight-lp855x_bl-silence-a-compiler-warning.patch
drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe.patch
epoll-remove-unneeded-variable-in-reverse_path_check.patch

