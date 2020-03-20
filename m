From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-dmapoolc-micro-optimisation-remove-unnecessary-branch.patch added to -mm
 tree
Date: Fri, 20 Mar 2020 16:36:59 -0700
Message-ID: <20200320233659.sQB9a31nb%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727365AbgCTXhA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Mar 2020 19:37:00 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mateusznosek0@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool.c: micro-optimisation remove unnecessary branch
has been added to the -mm tree.  Its filename is
     mm-dmapoolc-micro-optimisation-remove-unnecessary-branch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dmapoolc-micro-optimisation-remove-unnecessary-branch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dmapoolc-micro-optimisation-remove-unnecessary-branch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
