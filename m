From: akpm@linux-foundation.org
Subject: + mm-cma-add-functions-to-get-region-pages-counters-fix-3.patch
 added to -mm tree
Date: Wed, 08 Apr 2015 15:11:06 -0700
Message-ID: <5525a77a.vBeTUy47hbesfVPa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbbDHWLH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Apr 2015 18:11:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.safonov@partner.samsung.com, iamjoonsoo.kim@lge.com, m.szyprowski@samsung.com, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-add-functions-to-get-region-pages-counters-fix-3
has been added to the -mm tree.  Its filename is
     mm-cma-add-functions-to-get-region-pages-counters-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-add-functions-to-get-region-pages-counters-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-add-functions-to-get-region-pages-counters-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Safonov <d.safonov@partner.samsung.com>
Subject: mm-cma-add-functions-to-get-region-pages-counters-fix-3

Fix for the next compiler warnings:
mm/cma_debug.c:45 cma_used_get() warn: should 'used << cma->order_per_bit' be a 64 bit type?
mm/cma_debug.c:67 cma_maxchunk_get() warn: should 'maxchunk << cma->order_per_bit' be a 64 bit type?

Signed-off-by: Dmitry Safonov <d.safonov@partner.samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/cma_debug.c~mm-cma-add-functions-to-get-region-pages-counters-fix-3 mm/cma_debug.c
--- a/mm/cma_debug.c~mm-cma-add-functions-to-get-region-pages-counters-fix-3
+++ a/mm/cma_debug.c
@@ -42,7 +42,7 @@ static int cma_used_get(void *data, u64
 	/* pages counter is smaller than sizeof(int) */
 	used = bitmap_weight(cma->bitmap, (int)cma->count);
 	mutex_unlock(&cma->lock);
-	*val = used << cma->order_per_bit;
+	*val = (u64)used << cma->order_per_bit;
 
 	return 0;
 }
@@ -64,7 +64,7 @@ static int cma_maxchunk_get(void *data,
 		maxchunk = max(end - start, maxchunk);
 	}
 	mutex_unlock(&cma->lock);
-	*val = maxchunk << cma->order_per_bit;
+	*val = (u64)maxchunk << cma->order_per_bit;
 
 	return 0;
 }
_

Patches currently in -mm which might be from d.safonov@partner.samsung.com are

mm-cma-add-functions-to-get-region-pages-counters.patch
mm-cma-add-functions-to-get-region-pages-counters-fix.patch
mm-cma-add-functions-to-get-region-pages-counters-fix-2.patch
mm-cma-add-functions-to-get-region-pages-counters-fix-3.patch
mm-cma_debugc-remove-blank-lines-before-define_simple_attribute.patch

