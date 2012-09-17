From: akpm@linux-foundation.org
Subject: + drivers-rapidio-devices-tsi721c-fix-error-return-code.patch added to -mm tree
Date: Mon, 17 Sep 2012 15:29:21 -0700
Message-ID: <20120917222922.103675C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:63806 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338Ab2IQW3Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Sep 2012 18:29:24 -0400
Received: by eekd4 with SMTP id d4so424141eek.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Sep 2012 15:29:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter.senna@gmail.com, alexandre.bounine@idt.com


The patch titled
     Subject: drivers/rapidio/devices/tsi721.c: fix error return code
has been added to the -mm tree.  Its filename is
     drivers-rapidio-devices-tsi721c-fix-error-return-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
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

linux-next.patch
drivers-rapidio-devices-tsi721c-fix-error-return-code.patch

