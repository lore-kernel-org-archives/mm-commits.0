From: akpm@linux-foundation.org
Subject: + mm-dmapoolc-reuse-devres_release-to-free-resources.patch added
 to -mm tree
Date: Mon, 12 May 2014 16:32:00 -0700
Message-ID: <537159f0.KmywskULV1rIbwey%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaELXcA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 May 2014 19:32:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com

Subject: + mm-dmapoolc-reuse-devres_release-to-free-resources.patch added to -mm tree
To: andriy.shevchenko@linux.intel.com
From: akpm@linux-foundation.org
Date: Mon, 12 May 2014 16:32:00 -0700


The patch titled
     Subject: mm/dmapool.c: reuse devres_release() to free resources
has been added to the -mm tree.  Its filename is
     mm-dmapoolc-reuse-devres_release-to-free-resources.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dmapoolc-reuse-devres_release-to-free-resources.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dmapoolc-reuse-devres_release-to-free-resources.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: mm/dmapool.c: reuse devres_release() to free resources

Instead of calling an additional routine in dmam_pool_destroy() rely on
what dmam_pool_release() is doing.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/dmapool.c~mm-dmapoolc-reuse-devres_release-to-free-resources mm/dmapool.c
--- a/mm/dmapool.c~mm-dmapoolc-reuse-devres_release-to-free-resources
+++ a/mm/dmapool.c
@@ -500,7 +500,6 @@ void dmam_pool_destroy(struct dma_pool *
 {
 	struct device *dev = pool->dev;
 
-	WARN_ON(devres_destroy(dev, dmam_pool_release, dmam_pool_match, pool));
-	dma_pool_destroy(pool);
+	WARN_ON(devres_release(dev, dmam_pool_release, dmam_pool_match, pool));
 }
 EXPORT_SYMBOL(dmam_pool_destroy);
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

mm-dmapoolc-reuse-devres_release-to-free-resources.patch
printk-fix-lockdep-instrumentation-of-console_sem.patch
linux-next.patch

