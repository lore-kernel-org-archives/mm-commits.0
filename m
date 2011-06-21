From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-dmapool-fix-possible-use-after-free-in-dmam_pool_destroy.patch removed from -mm tree
Date: Tue, 21 Jun 2011 15:10:50 -0700
Message-ID: <201106212210.p5LMAos1027542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755101Ab1FUWLF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jun 2011 18:11:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxin.john@gmail.com, eike-kernel@sf-tec.de, mm-commits@vger.kernel.org


The patch titled
     mm/dmapool.c: fix possible use after free in dmam_pool_destroy()
has been removed from the -mm tree.  Its filename was
     mm-dmapool-fix-possible-use-after-free-in-dmam_pool_destroy.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/dmapool.c: fix possible use after free in dmam_pool_destroy()
From: Maxin B John <maxin.john@gmail.com>

"dma_pool_destroy(pool)" calls "kfree(pool)".  The freed pointer "pool" is
again passed as an argument to the function "devres_destroy()".  This
patch fixes the possible use after free.

It's notabug at this time, but the code is dangerous.

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/dmapool.c~mm-dmapool-fix-possible-use-after-free-in-dmam_pool_destroy mm/dmapool.c
--- a/mm/dmapool.c~mm-dmapool-fix-possible-use-after-free-in-dmam_pool_destroy
+++ a/mm/dmapool.c
@@ -500,7 +500,7 @@ void dmam_pool_destroy(struct dma_pool *
 {
 	struct device *dev = pool->dev;
 
-	dma_pool_destroy(pool);
 	WARN_ON(devres_destroy(dev, dmam_pool_release, dmam_pool_match, pool));
+	dma_pool_destroy(pool);
 }
 EXPORT_SYMBOL(dmam_pool_destroy);
_

Patches currently in -mm which might be from maxin.john@gmail.com are

linux-next.patch
devres-fix-possible-use-after-free.patch

