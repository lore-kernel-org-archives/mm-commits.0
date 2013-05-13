From: akpm@linux-foundation.org
Subject: + mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high.patch added to -mm tree
Date: Mon, 13 May 2013 14:11:47 -0700
Message-ID: <20130513211147.DECC35A40E5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:42787 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3EMVLt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 17:11:49 -0400
Received: by mail-qc0-f202.google.com with SMTP id d1so655004qcz.1
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 14:11:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cody@linux.vnet.ibm.com, gilad@benyossef.com, kosaki.motohiro@gmail.com, mgorman@suse.de, penberg@kernel.org


The patch titled
     Subject: mm/page_alloc: insert memory barriers to allow async update of pcp batch and high
has been added to the -mm tree.  Its filename is
     mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high.patch

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
Subject: mm/page_alloc: insert memory barriers to allow async update of pcp batch and high

Introduce pageset_update() to perform a safe transision from one set of
pcp->{batch,high} to a new set using memory barriers.

This ensures that batch is always set to a safe value (1) prior to
updating high, and ensure that high is fully updated before setting the
real value of batch.  It avoids ->batch ever rising above ->high.

Suggested by Gilad Ben-Yossef in these threads:

	https://lkml.org/lkml/2013/4/9/23
	https://lkml.org/lkml/2013/4/10/49

Also reproduces his proposed comment.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Reviewed-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high
+++ a/mm/page_alloc.c
@@ -4035,12 +4035,37 @@ static int __meminit zone_batchsize(stru
 #endif
 }
 
+/*
+ * pcp->high and pcp->batch values are related and dependent on one another:
+ * ->batch must never be higher then ->high.
+ * The following function updates them in a safe manner without read side
+ * locking.
+ *
+ * Any new users of pcp->batch and pcp->high should ensure they can cope with
+ * those fields changing asynchronously (acording the the above rule).
+ *
+ * mutex_is_locked(&pcp_batch_high_lock) required when calling this function
+ * outside of boot time (or some other assurance that no concurrent updaters
+ * exist).
+ */
+static void pageset_update(struct per_cpu_pages *pcp, unsigned long high,
+		unsigned long batch)
+{
+       /* start with a fail safe value for batch */
+	pcp->batch = 1;
+	smp_wmb();
+
+       /* Update high, then batch, in order */
+	pcp->high = high;
+	smp_wmb();
+
+	pcp->batch = batch;
+}
+
 /* a companion to setup_pagelist_highmark() */
 static void pageset_set_batch(struct per_cpu_pageset *p, unsigned long batch)
 {
-	struct per_cpu_pages *pcp = &p->pcp;
-	pcp->high = 6 * batch;
-	pcp->batch = max(1UL, 1 * batch);
+	pageset_update(&p->pcp, 6 * batch, max(1UL, 1 * batch));
 }
 
 static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
@@ -4064,13 +4089,11 @@ static void setup_pageset(struct per_cpu
 static void setup_pagelist_highmark(struct per_cpu_pageset *p,
 				unsigned long high)
 {
-	struct per_cpu_pages *pcp;
+	unsigned long batch = max(1UL, high / 4);
+	if ((high / 4) > (PAGE_SHIFT * 8))
+		batch = PAGE_SHIFT * 8;
 
-	pcp = &p->pcp;
-	pcp->high = high;
-	pcp->batch = max(1UL, high/4);
-	if ((high/4) > (PAGE_SHIFT * 8))
-		pcp->batch = PAGE_SHIFT * 8;
+	pageset_update(&p->pcp, high, batch);
 }
 
 static void __meminit setup_zone_pageset(struct zone *zone)
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

