Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A1AC2BBCD
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 105E122D0A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgLOX7U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:59816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728187AbgLOXXa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:23:30 -0500
Date:   Tue, 15 Dec 2020 15:21:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074497;
        bh=LbKI9Mfky6eAHihAsNNN3AXjkE9SaiiDNXOJyG6+Nrw=;
        h=From:To:Subject:From;
        b=Z7d2wCPL5mRQ0NJNBcEJf1yO4ujECGLyzaSlSRC6+KcQwGNBAG65SCpbyiXK25D+l
         iN0SOahgZGpe1lWXehTBG0REoLwgI8p5z0EElJb7fX5eT+Wg/7Al1J1DlN5NlI/lEK
         ynyEZpcxhlRqCrODCGCZ/zHTQDAYAqS2mcT8d2pg=
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, vbabka@suse.cz
Subject:  [merged] mm-page_alloc-simplify-pageset_update.patch
 removed from -mm tree
Message-ID: <20201215232137.GRmFNLMhv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: simplify pageset_update()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-simplify-pageset_update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: simplify pageset_update()

pageset_update() attempts to update pcplist's high and batch values in a
way that readers don't observe batch > high.  It uses smp_wmb() to order
the updates in a way to achieve this.  However, without proper pairing
read barriers in readers this guarantee doesn't hold, and there are no
such barriers in e.g.  free_unref_page_commit().

Commit 88e8ac11d2ea ("mm, page_alloc: fix core hung in
free_pcppages_bulk()") already showed this is problematic, and solved this
by ultimately only trusing pcp->count of the current cpu with interrupts
disabled.

The update dance with unpaired write barriers thus makes no sense. 
Replace them with plain WRITE_ONCE to prevent store tearing, and document
that the values can change asynchronously and should not be trusted for
correctness.

All current readers appear to be OK after 88e8ac11d2ea.  Convert them to
READ_ONCE to prevent unnecessary read tearing, but mainly to alert anybody
making future changes to the code that special care is needed.

Link: https://lkml.kernel.org/r/20201111092812.11329-5-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-simplify-pageset_update
+++ a/mm/page_alloc.c
@@ -1344,7 +1344,7 @@ static void free_pcppages_bulk(struct zo
 {
 	int migratetype = 0;
 	int batch_free = 0;
-	int prefetch_nr = 0;
+	int prefetch_nr = READ_ONCE(pcp->batch);
 	bool isolated_pageblocks;
 	struct page *page, *tmp;
 	LIST_HEAD(head);
@@ -1395,8 +1395,10 @@ static void free_pcppages_bulk(struct zo
 			 * avoid excessive prefetching due to large count, only
 			 * prefetch buddy for the first pcp->batch nr of pages.
 			 */
-			if (prefetch_nr++ < pcp->batch)
+			if (prefetch_nr) {
 				prefetch_buddy(page);
+				prefetch_nr--;
+			}
 		} while (--count && --batch_free && !list_empty(list));
 	}
 
@@ -3197,10 +3199,8 @@ static void free_unref_page_commit(struc
 	pcp = &this_cpu_ptr(zone->pageset)->pcp;
 	list_add(&page->lru, &pcp->lists[migratetype]);
 	pcp->count++;
-	if (pcp->count >= pcp->high) {
-		unsigned long batch = READ_ONCE(pcp->batch);
-		free_pcppages_bulk(zone, batch, pcp);
-	}
+	if (pcp->count >= READ_ONCE(pcp->high))
+		free_pcppages_bulk(zone, READ_ONCE(pcp->batch), pcp);
 }
 
 /*
@@ -3385,7 +3385,7 @@ static struct page *__rmqueue_pcplist(st
 	do {
 		if (list_empty(list)) {
 			pcp->count += rmqueue_bulk(zone, 0,
-					pcp->batch, list,
+					READ_ONCE(pcp->batch), list,
 					migratetype, alloc_flags);
 			if (unlikely(list_empty(list)))
 				return NULL;
@@ -6270,13 +6270,16 @@ static int zone_batchsize(struct zone *z
 }
 
 /*
- * pcp->high and pcp->batch values are related and dependent on one another:
- * ->batch must never be higher then ->high.
- * The following function updates them in a safe manner without read side
- * locking.
- *
- * Any new users of pcp->batch and pcp->high should ensure they can cope with
- * those fields changing asynchronously (acording to the above rule).
+ * pcp->high and pcp->batch values are related and generally batch is lower
+ * than high. They are also related to pcp->count such that count is lower
+ * than high, and as soon as it reaches high, the pcplist is flushed.
+ *
+ * However, guaranteeing these relations at all times would require e.g. write
+ * barriers here but also careful usage of read barriers at the read side, and
+ * thus be prone to error and bad for performance. Thus the update only prevents
+ * store tearing. Any new users of pcp->batch and pcp->high should ensure they
+ * can cope with those fields changing asynchronously, and fully trust only the
+ * pcp->count field on the local CPU with interrupts disabled.
  *
  * mutex_is_locked(&pcp_batch_high_lock) required when calling this function
  * outside of boot time (or some other assurance that no concurrent updaters
@@ -6285,15 +6288,8 @@ static int zone_batchsize(struct zone *z
 static void pageset_update(struct per_cpu_pages *pcp, unsigned long high,
 		unsigned long batch)
 {
-       /* start with a fail safe value for batch */
-	pcp->batch = 1;
-	smp_wmb();
-
-       /* Update high, then batch, in order */
-	pcp->high = high;
-	smp_wmb();
-
-	pcp->batch = batch;
+	WRITE_ONCE(pcp->batch, batch);
+	WRITE_ONCE(pcp->high, high);
 }
 
 static void pageset_init(struct per_cpu_pageset *p)
_

Patches currently in -mm which might be from vbabka@suse.cz are


