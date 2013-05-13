From: akpm@linux-foundation.org
Subject: + mm-page_alloc-factor-out-setting-of-pcp-high-and-pcp-batch.patch added to -mm tree
Date: Mon, 13 May 2013 14:11:43 -0700
Message-ID: <20130513211143.C8B9A31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:54289 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab3EMVLp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 17:11:45 -0400
Received: by mail-qe0-f74.google.com with SMTP id 7so36248qeb.1
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 14:11:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cody@linux.vnet.ibm.com, gilad@benyossef.com, kosaki.motohiro@gmail.com, mgorman@suse.de, penberg@kernel.org


The patch titled
     Subject: mm/page_alloc: factor out setting of pcp->high and pcp->batch
has been added to the -mm tree.  Its filename is
     mm-page_alloc-factor-out-setting-of-pcp-high-and-pcp-batch.patch

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
Subject: mm/page_alloc: factor out setting of pcp->high and pcp->batch

"Problems" with the current code:

1: there is a lack of synchronization in setting ->high and ->batch in
   percpu_pagelist_fraction_sysctl_handler()

2: stop_machine() in zone_pcp_update() is unnecissary.

3: zone_pcp_update() does not consider the case where
   percpu_pagelist_fraction is non-zero

To fix:

1: add memory barriers, a safe ->batch value, an update side mutex when
   updating ->high and ->batch, and use ACCESS_ONCE() for ->batch users
   that expect a stable value.

2: avoid draining pages in zone_pcp_update(), rely upon the memory
   barriers added to fix #1

3: factor out quite a few functions, and then call the appropriate one.

Note that it results in a change to the behavior of zone_pcp_update(),
which is used by memory_hotplug.  I'm rather certain that I've diserned
(and preserved) the essential behavior (changing ->high and ->batch), and
only eliminated unneeded actions (draining the per cpu pages), but this
may not be the case.

Further note that the draining of pages that previously took place in
zone_pcp_update() occured after repeated draining when attempting to
offline a page, and after the offline has "succeeded".  It appears that
the draining was added to zone_pcp_update() to avoid refactoring
setup_pageset() into 2 funtions.


This patch:

Creates pageset_set_batch() for use in setup_pageset(). 
pageset_set_batch() imitates the functionality of
setup_pagelist_highmark(), but uses the boot time
(percpu_pagelist_fraction == 0) calculations for determining ->high based
on ->batch.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-factor-out-setting-of-pcp-high-and-pcp-batch mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-factor-out-setting-of-pcp-high-and-pcp-batch
+++ a/mm/page_alloc.c
@@ -4032,6 +4032,14 @@ static int __meminit zone_batchsize(stru
 #endif
 }
 
+/* a companion to setup_pagelist_highmark() */
+static void pageset_set_batch(struct per_cpu_pageset *p, unsigned long batch)
+{
+	struct per_cpu_pages *pcp = &p->pcp;
+	pcp->high = 6 * batch;
+	pcp->batch = max(1UL, 1 * batch);
+}
+
 static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
 {
 	struct per_cpu_pages *pcp;
@@ -4041,8 +4049,7 @@ static void setup_pageset(struct per_cpu
 
 	pcp = &p->pcp;
 	pcp->count = 0;
-	pcp->high = 6 * batch;
-	pcp->batch = max(1UL, 1 * batch);
+	pageset_set_batch(p, batch);
 	for (migratetype = 0; migratetype < MIGRATE_PCPTYPES; migratetype++)
 		INIT_LIST_HEAD(&pcp->lists[migratetype]);
 }
@@ -4051,7 +4058,6 @@ static void setup_pageset(struct per_cpu
  * setup_pagelist_highmark() sets the high water mark for hot per_cpu_pagelist
  * to the value high for the pageset p.
  */
