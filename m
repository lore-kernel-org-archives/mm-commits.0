From: akpm@linux-foundation.org
Subject: + mm-page_alloc-factor-setup_pageset-into-pageset_init-and-pageset_set_batch.patch added to -mm tree
Date: Mon, 13 May 2013 14:11:57 -0700
Message-ID: <20130513211157.A15945A40E5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:50384 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab3EMVL6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 17:11:58 -0400
Received: by mail-gh0-f201.google.com with SMTP id r14so198145ghr.4
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 14:11:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cody@linux.vnet.ibm.com, gilad@benyossef.com, kosaki.motohiro@gmail.com, mgorman@suse.de, penberg@kernel.org


The patch titled
     Subject: mm/page_alloc: factor setup_pageset() into pageset_init() and pageset_set_batch()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-factor-setup_pageset-into-pageset_init-and-pageset_set_batch.patch

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
Subject: mm/page_alloc: factor setup_pageset() into pageset_init() and pageset_set_batch()

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-factor-setup_pageset-into-pageset_init-and-pageset_set_batch mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-factor-setup_pageset-into-pageset_init-and-pageset_set_batch
+++ a/mm/page_alloc.c
@@ -4071,7 +4071,7 @@ static void pageset_set_batch(struct per
 	pageset_update(&p->pcp, 6 * batch, max(1UL, 1 * batch));
 }
 
-static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
+static void pageset_init(struct per_cpu_pageset *p)
 {
 	struct per_cpu_pages *pcp;
 	int migratetype;
@@ -4080,11 +4080,16 @@ static void setup_pageset(struct per_cpu
 
 	pcp = &p->pcp;
 	pcp->count = 0;
-	pageset_set_batch(p, batch);
 	for (migratetype = 0; migratetype < MIGRATE_PCPTYPES; migratetype++)
 		INIT_LIST_HEAD(&pcp->lists[migratetype]);
 }
 
+static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
+{
+	pageset_init(p);
+	pageset_set_batch(p, batch);
+}
+
 /*
  * setup_pagelist_highmark() sets the high water mark for hot per_cpu_pagelist
  * to the value high for the pageset p.
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

