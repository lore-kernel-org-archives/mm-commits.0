From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:24:13 -0700
Message-ID: <51db11dd.jly4evHzW6pKO0v2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3GHTYO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mgorman@suse.de, kosaki.motohiro@gmail.com, gilad@benyossef.com, cody@linux.vnet.ibm.com

Subject: [merged] mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high.patch removed from -mm tree
To: cody@linux.vnet.ibm.com,gilad@benyossef.com,kosaki.motohiro@gmail.com,mgorman@suse.de,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:13 -0700


The patch titled
     Subject: mm/page_alloc: insert memory barriers to allow async update of pcp batch and high
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch

