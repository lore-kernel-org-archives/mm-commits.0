From: akpm@linux-foundation.org
Subject: + kaweth-remove-ifdefed-out-call-to-dma_supported.patch added to
 -mm tree
Date: Mon, 05 Oct 2015 14:29:28 -0700
Message-ID: <5612ebb8.HyPWZjZ++7re4XCU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbbJEV33 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 17:29:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, davem@davemloft.net, khoroshilov@ispras.ru, oliver@neukum.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kaweth: remove ifdefed out call to dma_supported
has been added to the -mm tree.  Its filename is
     kaweth-remove-ifdefed-out-call-to-dma_supported.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kaweth-remove-ifdefed-out-call-to-dma_supported.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kaweth-remove-ifdefed-out-call-to-dma_supported.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: kaweth: remove ifdefed out call to dma_supported

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Oliver Neukum <oliver@neukum.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/kaweth.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/net/usb/kaweth.c~kaweth-remove-ifdefed-out-call-to-dma_supported drivers/net/usb/kaweth.c
--- a/drivers/net/usb/kaweth.c~kaweth-remove-ifdefed-out-call-to-dma_supported
+++ a/drivers/net/usb/kaweth.c
@@ -1177,12 +1177,6 @@ err_fw:
 	INIT_DELAYED_WORK(&kaweth->lowmem_work, kaweth_resubmit_tl);
 	usb_set_intfdata(intf, kaweth);
 
-#if 0
-// dma_supported() is deeply broken on almost all architectures
-	if (dma_supported (dev, 0xffffffffffffffffULL))
-		kaweth->net->features |= NETIF_F_HIGHDMA;
-#endif
