From: akpm@linux-foundation.org
Subject: + mm-page_alloc-simplify-drain_zone_pages-by-using-min.patch
 added to -mm tree
Date: Mon, 16 Jun 2014 16:12:49 -0700
Message-ID: <539f79f1.y3bd+rz+uWd0cGWb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbaFPXMu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 19:12:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mina86@mina86.com


The patch titled
     Subject: mm: page_alloc: simplify drain_zone_pages by using min()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-simplify-drain_zone_pages-by-using-min.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-simplify-drain_zone_pages-by-using-min.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-simplify-drain_zone_pages-by-using-min.patch

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
Subject: mm: page_alloc: simplify drain_zone_pages by using min()

Instead of open-coding getting minimal value of two, just use min macro. 
That is why it is there for.  While changing the function also change type
of batch local variable to match type of per_cpu_pages::batch (which is
int).

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-simplify-drain_zone_pages-by-using-min mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-simplify-drain_zone_pages-by-using-min
+++ a/mm/page_alloc.c
@@ -1245,15 +1245,11 @@ static int rmqueue_bulk(struct zone *zon
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

mm-page_alloc-simplify-drain_zone_pages-by-using-min.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
debugging-keep-track-of-page-owners.patch

