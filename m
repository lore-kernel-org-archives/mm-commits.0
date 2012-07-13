From: akpm@linux-foundation.org
Subject: + dma-dmaengine-lower-the-priority-of-failed-to-get-dma-channel-message.patch added to -mm tree
Date: Fri, 13 Jul 2012 15:57:00 -0700
Message-ID: <20120713225701.2D79620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:61655 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab2GMW5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 18:57:04 -0400
Received: by wibhr14 with SMTP id hr14so57370wib.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 15:57:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fabio.estevam@freescale.com, dan.j.williams@intel.com, vinod.koul@intel.com


The patch titled
     Subject: drivers/dma/dmaengine.c: lower the priority of 'failed to get' dma channel message
has been added to the -mm tree.  Its filename is
     dma-dmaengine-lower-the-priority-of-failed-to-get-dma-channel-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmaengine.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/dma/dmaengine.c~dma-dmaengine-lower-the-priority-of-failed-to-get-dma-channel-message drivers/dma/dmaengine.c
--- a/drivers/dma/dmaengine.c~dma-dmaengine-lower-the-priority-of-failed-to-get-dma-channel-message
+++ a/drivers/dma/dmaengine.c
@@ -578,7 +578,7 @@ void dmaengine_get(void)
 				list_del_rcu(&device->global_node);
 				break;
 			} else if (err)
-				pr_err("%s: failed to get %s: (%d)\n",
+				pr_debug("%s: failed to get %s: (%d)\n",
 					__func__, dma_chan_name(chan), err);
 		}
 	}
_
Subject: Subject: drivers/dma/dmaengine.c: lower the priority of 'failed to get' dma channel message

Patches currently in -mm which might be from fabio.estevam@freescale.com are

origin.patch
linux-next.patch
dma-dmaengine-lower-the-priority-of-failed-to-get-dma-channel-message.patch

