From: akpm@linux-foundation.org
Subject: [merged] mm-dmapoolc-reuse-devres_release-to-free-resources.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:52:11 -0700
Message-ID: <5390ca6b.K5CVjV3uZdGFx3rJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbaFETwL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com

Subject: [merged] mm-dmapoolc-reuse-devres_release-to-free-resources.patch removed from -mm tree
To: andriy.shevchenko@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:11 -0700


The patch titled
     Subject: mm/dmapool.c: reuse devres_release() to free resources
has been removed from the -mm tree.  Its filename was
     mm-dmapoolc-reuse-devres_release-to-free-resources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

