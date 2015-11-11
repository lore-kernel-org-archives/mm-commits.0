From: akpm@linux-foundation.org
Subject: [merged] kaweth-remove-ifdefed-out-call-to-dma_supported.patch
 removed from -mm tree
Date: Wed, 11 Nov 2015 11:48:35 -0800
Message-ID: <56439b93.QEnNEBeoedeKL2f5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbbKKTsf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 14:48:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, davem@davemloft.net, khoroshilov@ispras.ru, oliver@neukum.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kaweth: remove ifdefed out call to dma_supported
has been removed from the -mm tree.  Its filename was
     kaweth-remove-ifdefed-out-call-to-dma_supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
