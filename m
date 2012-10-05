From: akpm@linux-foundation.org
Subject: [merged] drivers-rapidio-devices-tsi721c-fix-error-return-code.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:20:22 -0700
Message-ID: <20121005202023.2BD1E20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:63280 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUUZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:20:25 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so141181lbo.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:20:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter.senna@gmail.com, alexandre.bounine@idt.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rapidio/devices/tsi721.c: fix error return code
has been removed from the -mm tree.  Its filename was
     drivers-rapidio-devices-tsi721c-fix-error-return-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: drivers/rapidio/devices/tsi721.c: fix error return code

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rapidio/devices/tsi721.c~drivers-rapidio-devices-tsi721c-fix-error-return-code drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~drivers-rapidio-devices-tsi721c-fix-error-return-code
+++ a/drivers/rapidio/devices/tsi721.c
@@ -2316,7 +2316,8 @@ static int __devinit tsi721_probe(struct
 
 	/* Configure DMA attributes. */
 	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
-		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (err) {
 			dev_info(&pdev->dev, "Unable to set DMA mask\n");
 			goto err_unmap_bars;
 		}
_

Patches currently in -mm which might be from peter.senna@gmail.com are

origin.patch
linux-next.patch

