From: akpm@linux-foundation.org
Subject: [merged] dma-dmaengine-lower-the-priority-of-failed-to-get-dma-channel-message.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:11:56 -0700
Message-ID: <20121005201156.D17AB1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:38013 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab2JEUL6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:11:58 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so93506qae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:11:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabio.estevam@freescale.com, dan.j.williams@intel.com, stable@vger.kernel.org, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/dma/dmaengine.c: lower the priority of 'failed to get' dma channel message
has been removed from the -mm tree.  Its filename was
     dma-dmaengine-lower-the-priority-of-failed-to-get-dma-channel-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabio Estevam <fabio.estevam@freescale.com>
Subject: drivers/dma/dmaengine.c: lower the priority of 'failed to get' dma channel message

Do the same as commit a03a202e9 ("dmaengine: failure to get a specific DMA
channel is not critical") to get rid of the following messages during
kernel boot:

dmaengine_get: failed to get dma1chan0: (-22)
dmaengine_get: failed to get dma1chan1: (-22)
dmaengine_get: failed to get dma1chan2: (-22)
dmaengine_get: failed to get dma1chan3: (-22)
dmaengine_get: failed to get dma1chan4: (-22)
dmaengine_get: failed to get dma1chan5: (-22)
dmaengine_get: failed to get dma1chan6: (-22)
dmaengine_get: failed to get dma1chan7: (-22)
dmaengine_get: failed to get dma1chan8: (-22)
dmaengine_get: failed to get dma1chan9: (-22)
dmaengine_get: failed to get dma1chan10: (-22)
dmaengine_get: failed to get dma1chan11: (-22)
dmaengine_get: failed to get dma1chan12: (-22)
dmaengine_get: failed to get dma1chan13: (-22)
dmaengine_get: failed to get dma1chan14: (-22)
dmaengine_get: failed to get dma1chan15: (-22)
dmaengine_get: failed to get dma1chan16: (-22)
dmaengine_get: failed to get dma1chan17: (-22)
dmaengine_get: failed to get dma1chan18: (-22)
dmaengine_get: failed to get dma1chan19: (-22)
dmaengine_get: failed to get dma1chan20: (-22)
dmaengine_get: failed to get dma1chan21: (-22)
dmaengine_get: failed to get dma1chan22: (-22)
dmaengine_get: failed to get dma1chan23: (-22)
dmaengine_get: failed to get dma1chan24: (-22)
dmaengine_get: failed to get dma1chan25: (-22)
dmaengine_get: failed to get dma1chan26: (-22)
dmaengine_get: failed to get dma1chan27: (-22)
dmaengine_get: failed to get dma1chan28: (-22)
dmaengine_get: failed to get dma1chan29: (-22)

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmaengine.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/dma/dmaengine.c~dma-dmaengine-lower-the-priority-of-failed-to-get-dma-channel-message drivers/dma/dmaengine.c
--- a/drivers/dma/dmaengine.c~dma-dmaengine-lower-the-priority-of-failed-to-get-dma-channel-message
+++ a/drivers/dma/dmaengine.c
@@ -582,7 +582,7 @@ void dmaengine_get(void)
 				list_del_rcu(&device->global_node);
 				break;
 			} else if (err)
-				pr_err("%s: failed to get %s: (%d)\n",
+				pr_debug("%s: failed to get %s: (%d)\n",
 				       __func__, dma_chan_name(chan), err);
 		}
 	}
_

Patches currently in -mm which might be from fabio.estevam@freescale.com are

origin.patch
linux-next.patch

