From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-simplify-drain_zone_pages-by-using-min.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:03:53 -0700
Message-ID: <53e3dba9.vyWdgQK+BVbXSnn0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:45678 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050AbaHGUDy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:03:54 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so836846oig.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:03:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mina86@mina86.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: simplify drain_zone_pages by using min()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-simplify-drain_zone_pages-by-using-min.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Nazarewicz <mina86@mina86.com>
Subject: mm: page_alloc: simplify drain_zone_pages by using min()

Instead of open-coding getting minimal value of two, just use min macro. 
That is why it is there for.  While changing the function also change type
of batch local variable to match type of per_cpu_pages::batch (which is
int).

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-simplify-drain_zone_pages-by-using-min mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-simplify-drain_zone_pages-by-using-min
+++ a/mm/page_alloc.c
@@ -1257,15 +1257,11 @@ static int rmqueue_bulk(struct zone *zon
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp)
 {
 	unsigned long flags;
-	int to_drain;
-	unsigned long batch;
+	int to_drain, batch;
 
 	local_irq_save(flags);
 	batch = ACCESS_ONCE(pcp->batch);
-	if (pcp->count >= batch)
-		to_drain = batch;
-	else
-		to_drain = pcp->count;
+	to_drain = min(pcp->count, batch);
 	if (to_drain > 0) {
 		free_pcppages_bulk(zone, to_drain, pcp);
 		pcp->count -= to_drain;
_

Patches currently in -mm which might be from mina86@mina86.com are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max-fix.patch
debugging-keep-track-of-page-owners.patch

