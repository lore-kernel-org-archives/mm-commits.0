From: akpm@linux-foundation.org
Subject: [merged] dmaengine-fix-memory-leak-in-dma_async_device_unregister.patch removed from -mm tree
Date: Thu, 04 Feb 2010 09:49:10 -0800
Message-ID: <201002041749.o14HnAQc012000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755463Ab0BDRti (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 12:49:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agust@denx.de, dan.j.williams@intel.com, maciej.sosnowski@intel.com, mm-commits@vger.kernel.org


The patch titled
     dmaengine: fix memory leak in dma_async_device_unregister()
has been removed from the -mm tree.  Its filename was
     dmaengine-fix-memory-leak-in-dma_async_device_unregister.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dmaengine: fix memory leak in dma_async_device_unregister()
From: Anatolij Gustschin <agust@denx.de>

While debugging a dma driver I noticed a memleak after unloading the
driver module.

Caught by kmemleak.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmaengine.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/dma/dmaengine.c~dmaengine-fix-memory-leak-in-dma_async_device_unregister drivers/dma/dmaengine.c
--- a/drivers/dma/dmaengine.c~dmaengine-fix-memory-leak-in-dma_async_device_unregister
+++ a/drivers/dma/dmaengine.c
@@ -826,6 +826,7 @@ void dma_async_device_unregister(struct 
 		chan->dev->chan = NULL;
 		mutex_unlock(&dma_list_mutex);
 		device_unregister(&chan->dev->device);
+		free_percpu(chan->local);
 	}
 }
 EXPORT_SYMBOL(dma_async_device_unregister);
_

Patches currently in -mm which might be from agust@denx.de are

linux-next.patch

