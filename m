From: akpm@linux-foundation.org
Subject: [merged]
 mm-dmapoolc-micro-optimisation-remove-unnecessary-branch.patch removed from
 -mm tree
Date: Tue, 07 Apr 2020 19:00:05 -0700
Message-ID: <20200408020005.vOVFSP7Uc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgDHCAF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:00:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mateusznosek0@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool.c: micro-optimisation remove unnecessary branch
has been removed from the -mm tree.  Its filename was
     mm-dmapoolc-micro-optimisation-remove-unnecessary-branch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/dmapool.c: micro-optimisation remove unnecessary branch

Previously there was a check if 'size' is aligned to 'align' and if not
then it was aligned.  This check was expensive as both branch and division
are expensive instructions in most architectures.  'ALIGN' function on
already aligned value will not change it, and as it is cheaper than branch
+ division it can be executed all the time and branch can be removed.

Link: http://lkml.kernel.org/r/20200320173317.26408-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/dmapool.c~mm-dmapoolc-micro-optimisation-remove-unnecessary-branch
+++ a/mm/dmapool.c
@@ -144,9 +144,7 @@ struct dma_pool *dma_pool_create(const c
 	else if (size < 4)
 		size = 4;
 
-	if ((size % align) != 0)
-		size = ALIGN(size, align);
