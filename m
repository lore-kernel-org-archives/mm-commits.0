From: akpm@linux-foundation.org
Subject: + memstick-r592-avoid-gcc-6-warning.patch added to -mm tree
Date: Wed, 23 Mar 2016 13:35:08 -0700
Message-ID: <56f2fdfc.V110D3atoiSW/yHN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbcCWUfJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 16:35:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, lambert.quentin@gmail.com, maximlevitsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/memstick/host/r592.c: avoid gcc-6 warning
has been added to the -mm tree.  Its filename is
     memstick-r592-avoid-gcc-6-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memstick-r592-avoid-gcc-6-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memstick-r592-avoid-gcc-6-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: drivers/memstick/host/r592.c: avoid gcc-6 warning

The r592 driver relies on behavior of the DMA mapping API that is normally
observed but not guaranteed by the API.  Instead it uses a runtime check
to fail transfers if the API ever behaves

When CONFIG_NEED_SG_DMA_LENGTH is not set, one of the checks turns into a
comparison of a variable with itself, which gcc-6.0 now warns about:

drivers/memstick/host/r592.c: In function 'r592_transfer_fifo_dma':
drivers/memstick/host/r592.c:302:31: error: self-comparison always evaluates to false [-Werror=tautological-compare]
    (sg_dma_len(&dev->req->sg) < dev->req->sg.length)) {
                               ^

The check itself is not a problem, so this patch just rephrases the
condition in a way that gcc does not consider an indication of a mistake. 
We already know that dev->req->sg.length was initially R592_LFIFO_SIZE, so
we can compare it to that constant again.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Quentin Lambert <lambert.quentin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/r592.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/memstick/host/r592.c~memstick-r592-avoid-gcc-6-warning drivers/memstick/host/r592.c
--- a/drivers/memstick/host/r592.c~memstick-r592-avoid-gcc-6-warning
+++ a/drivers/memstick/host/r592.c
@@ -298,8 +298,7 @@ static int r592_transfer_fifo_dma(struct
 	sg_count = dma_map_sg(&dev->pci_dev->dev, &dev->req->sg, 1, is_write ?
 		PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
 
-	if (sg_count != 1 ||
-			(sg_dma_len(&dev->req->sg) < dev->req->sg.length)) {
+	if (sg_count != 1 || sg_dma_len(&dev->req->sg) < R592_LFIFO_SIZE) {
 		message("problem in dma_map_sg");
 		return -EIO;
 	}
_

Patches currently in -mm which might be from arnd@arndb.de are

memstick-r592-avoid-gcc-6-warning.patch
staging-goldfish-use-6-arg-get_user_pages.patch

