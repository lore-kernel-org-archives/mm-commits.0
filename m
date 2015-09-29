From: akpm@linux-foundation.org
Subject: + dmapool-fix-overflow-condition-in-pool_find_page.patch added to -mm tree
Date: Tue, 29 Sep 2015 14:40:54 -0700
Message-ID: <560b0566.7Ll4XGqNu9JD/8TB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbbI2Vkz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 17:40:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robin.murphy@arm.com, arnd@arndb.de, m.szyprowski@samsung.com, rmk+kernel@arm.linux.org.uk, sakari.ailus@iki.fi, sumit.semwal@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: dmapool: fix overflow condition in pool_find_page()
has been added to the -mm tree.  Its filename is
     dmapool-fix-overflow-condition-in-pool_find_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dmapool-fix-overflow-condition-in-pool_find_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dmapool-fix-overflow-condition-in-pool_find_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Robin Murphy <robin.murphy@arm.com>
Subject: dmapool: fix overflow condition in pool_find_page()

If a DMA pool lies at the very top of the dma_addr_t range (as may happen
with an IOMMU involved), the calculated end address of the pool wraps
around to zero, and page lookup always fails.  Tweak the relevant
calculation to be overflow-proof.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/dmapool.c~dmapool-fix-overflow-condition-in-pool_find_page mm/dmapool.c
--- a/mm/dmapool.c~dmapool-fix-overflow-condition-in-pool_find_page
+++ a/mm/dmapool.c
@@ -394,7 +394,7 @@ static struct dma_page *pool_find_page(s
 	list_for_each_entry(page, &pool->page_list, page_list) {
 		if (dma < page->dma)
 			continue;
-		if (dma < (page->dma + pool->allocation))
+		if ((dma - page->dma) < pool->allocation)
 			return page;
 	}
 	return NULL;
_

Patches currently in -mm which might be from robin.murphy@arm.com are

dmapool-fix-overflow-condition-in-pool_find_page.patch
dma-mapping-tidy-up-dma_parms-default-handling.patch
dma-debug-check-nents-in-dma_sync_sg.patch
dma-debug-allow-poisoning-nonzero-allocations.patch

