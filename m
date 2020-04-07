From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 091/166] mm/dmapool.c: micro-optimisation remove
 unnecessary branch
Date: Mon, 06 Apr 2020 20:08:49 -0700
Message-ID: <20200407030849.9Yx9nrR8r%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbgDGDIu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:08:50 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mateusznosek0@gmail.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
