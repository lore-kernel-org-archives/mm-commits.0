From: akpm@linux-foundation.org
Subject: + dmaengine-fix-memory-leak-in-dma_async_device_unregister.patch added to -mm tree
Date: Fri, 29 Jan 2010 14:18:23 -0800
Message-ID: <201001292218.o0TMINvf012833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754004Ab0A2WTE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jan 2010 17:19:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agust@denx.de, dan.j.williams@intel.com, maciej.sosnowski@intel.com


The patch titled
     dmaengine: fix memory leak in dma_async_device_unregister()
has been added to the -mm tree.  Its filename is
     dmaengine-fix-memory-leak-in-dma_async_device_unregister.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
dmaengine-fix-memory-leak-in-dma_async_device_unregister.patch

