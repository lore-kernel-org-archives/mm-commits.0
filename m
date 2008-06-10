From: akpm@linux-foundation.org
Subject: + dma-mapping-add-the-device-argument-to-dma_mapping_error-b34-fix.patch added to -mm tree
Date: Tue, 10 Jun 2008 10:43:32 -0700
Message-ID: <200806101743.m5AHhWkk021540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709AbYFJRns (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jun 2008 13:43:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, fujita.tomonori@lab.ntt.co.jp, miles.lane@gmail.com, vegard.nossum@gmail.com


The patch titled
     dma-mapping-add-the-device-argument-to-dma_mapping_error: b43 fix
has been added to the -mm tree.  Its filename is
     dma-mapping-add-the-device-argument-to-dma_mapping_error-b34-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping-add-the-device-argument-to-dma_mapping_error: b43 fix
From: Michael Buesch <mb@bu3sch.de>

Also make sure to check b43legacy. I _guess_ you might have added
the same bug there.

Cc: "Vegard Nossum" <vegard.nossum@gmail.com>
Reported-by: "Miles Lane" <miles.lane@gmail.com>
Cc: "Michael Buesch" <mb@bu3sch.de>
Cc: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/b43/dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/b43/dma.c~dma-mapping-add-the-device-argument-to-dma_mapping_error-b34-fix drivers/net/wireless/b43/dma.c
--- a/drivers/net/wireless/b43/dma.c~dma-mapping-add-the-device-argument-to-dma_mapping_error-b34-fix
+++ a/drivers/net/wireless/b43/dma.c
@@ -802,6 +802,7 @@ struct b43_dmaring *b43_setup_dmaring(st
 	if (!ring)
 		goto out;
 	ring->type = type;
+	ring->dev = dev;
 
 	nr_slots = B43_RXRING_SLOTS;
 	if (for_tx)
@@ -853,7 +854,6 @@ struct b43_dmaring *b43_setup_dmaring(st
 				 DMA_TO_DEVICE);
 	}
 
-	ring->dev = dev;
 	ring->nr_slots = nr_slots;
 	ring->mmio_base = b43_dmacontroller_base(type, controller_index);
 	ring->index = controller_index;
_

Patches currently in -mm which might be from mb@bu3sch.de are

linux-next.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-b34-fix.patch

