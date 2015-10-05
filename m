From: akpm@linux-foundation.org
Subject: + mpsc-use-dma_set_mask-insted-of-dma_supported.patch added to
 -mm tree
Date: Mon, 05 Oct 2015 14:29:22 -0700
Message-ID: <5612ebb2.R8pOGsXPw4/DGwGN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbbJEV3X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 17:29:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, gregkh@linuxfoundation.org, jslaby@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mpsc: use dma_set_mask insted of dma_supported
has been added to the -mm tree.  Its filename is
     mpsc-use-dma_set_mask-insted-of-dma_supported.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mpsc-use-dma_set_mask-insted-of-dma_supported.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mpsc-use-dma_set_mask-insted-of-dma_supported.patch

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
Subject: mpsc: use dma_set_mask insted of dma_supported

This ensures the dma mask that is supported by the driver is recorded
in the device structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/serial/mpsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/tty/serial/mpsc.c~mpsc-use-dma_set_mask-insted-of-dma_supported drivers/tty/serial/mpsc.c
--- a/drivers/tty/serial/mpsc.c~mpsc-use-dma_set_mask-insted-of-dma_supported
+++ a/drivers/tty/serial/mpsc.c
@@ -755,7 +755,7 @@ static int mpsc_alloc_ring_mem(struct mp
 		pi->port.line);
 
 	if (!pi->dma_region) {
-		if (!dma_supported(pi->port.dev, 0xffffffff)) {
+		if (!dma_set_mask(pi->port.dev, 0xffffffff)) {
 			printk(KERN_ERR "MPSC: Inadequate DMA support\n");
 			rc = -ENXIO;
 		} else if ((pi->dma_region = dma_alloc_noncoherent(pi->port.dev,
_

Patches currently in -mm which might be from hch@lst.de are

pcnet32-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
tw68-core-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
saa7164-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
saa7134-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
cx88-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
cx25821-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
cx23885-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
netup_unidvb-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
mpsc-use-dma_set_mask-insted-of-dma_supported.patch
nouveau-dont-call-pci_dma_supported.patch
sfc-dont-call-dma_supported.patch
kaweth-remove-ifdefed-out-call-to-dma_supported.patch
usbnet-remove-ifdefed-out-call-to-dma_supported.patch
pci-remove-pci_dma_supported.patch
dma-remove-external-references-to-dma_supported.patch

