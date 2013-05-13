From: akpm@linux-foundation.org
Subject: + mm-page_alloc-protect-pcp-batch-accesses-with-access_once.patch added to -mm tree
Date: Mon, 13 May 2013 14:11:49 -0700
Message-ID: <20130513211149.DCD305A40E5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:50763 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab3EMVLv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 17:11:51 -0400
Received: by mail-gg0-f201.google.com with SMTP id k25so654172ggl.4
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 14:11:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cody@linux.vnet.ibm.com, gilad@benyossef.com, kosaki.motohiro@gmail.com, mgorman@suse.de, penberg@kernel.org


The patch titled
     Subject: mm/page_alloc: protect pcp->batch accesses with ACCESS_ONCE
has been added to the -mm tree.  Its filename is
     mm-page_alloc-protect-pcp-batch-accesses-with-access_once.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm/page_alloc: protect pcp->batch accesses with ACCESS_ONCE

pcp->batch could change at any point, avoid relying on it being a stable
value.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-protect-pcp-batch-accesses-with-access_once mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-protect-pcp-batch-accesses-with-access_once
+++ a/mm/page_alloc.c
@@ -1182,10 +1182,12 @@ void drain_zone_pages(struct zone *zone,
 {
 	unsigned long flags;
 	int to_drain;
+	unsigned long batch;
 
 	local_irq_save(flags);
-	if (pcp->count >= pcp->batch)
-		to_drain = pcp->batch;
+	batch = ACCESS_ONCE(pcp->batch);
+	if (pcp->count >= batch)
+		to_drain = batch;
 	else
 		to_drain = pcp->count;
 	if (to_drain > 0) {
@@ -1353,8 +1355,9 @@ void free_hot_cold_page(struct page *pag
 		list_add(&page->lru, &pcp->lists[migratetype]);
 	pcp->count++;
 	if (pcp->count >= pcp->high) {
-		free_pcppages_bulk(zone, pcp->batch, pcp);
-		pcp->count -= pcp->batch;
+		unsigned long batch = ACCESS_ONCE(pcp->batch);
+		free_pcppages_bulk(zone, batch, pcp);
+		pcp->count -= batch;
 	}
 
 out:
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

mm-page_alloc-factor-out-setting-of-pcp-high-and-pcp-batch.patch
mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high.patch
mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high.patch
mm-page_alloc-protect-pcp-batch-accesses-with-access_once.patch
mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine.patch
mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high.patch
mm-page_alloc-factor-setup_pageset-into-pageset_init-and-pageset_set_batch.patch
mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to.patch
mm-page_alloc-factor-zone_pageset_init-out-of-setup_zone_pageset.patch
mm-page_alloc-in-zone_pcp_update-uze-zone_pageset_init.patch
mm-page_alloc-rename-setup_pagelist_highmark-to-match-naming-of-pageset_set_batch.patch

