From: akpm@linux-foundation.org
Subject: + floppy-tolerate-dma-channel-unavailability.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:43:25 -0700
Message-ID: <200708242243.l7OMhPB0018592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56008 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761423AbXHXWn4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:43:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com


The patch titled
     floppy: tolerate DMA channel unavailability
has been added to the -mm tree.  Its filename is
     floppy-tolerate-dma-channel-unavailability.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: floppy: tolerate DMA channel unavailability
From: "Jan Beulich" <jbeulich@novell.com>

The floppy driver is already written to be able to operate in virtual DMA
mode.  Thus it can easily be adjusted to tolerate failure from
fd_request_dma() as long as virtual DMA mode is not disallowed.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff -puN drivers/block/floppy.c~floppy-tolerate-dma-channel-unavailability drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-tolerate-dma-channel-unavailability
+++ a/drivers/block/floppy.c
@@ -4397,11 +4397,15 @@ static int floppy_grab_irq_and_dma(void)
 	if (fd_request_dma()) {
 		DPRINT("Unable to grab DMA%d for the floppy driver\n",
 		       FLOPPY_DMA);
-		fd_free_irq();
-		spin_lock_irqsave(&floppy_usage_lock, flags);
-		usage_count--;
-		spin_unlock_irqrestore(&floppy_usage_lock, flags);
-		return -1;
+		if (can_use_virtual_dma & 2)
+			use_virtual_dma = can_use_virtual_dma = 1;
+		if (!(can_use_virtual_dma & 1)) {
+			fd_free_irq();
+			spin_lock_irqsave(&floppy_usage_lock, flags);
+			usage_count--;
+			spin_unlock_irqrestore(&floppy_usage_lock, flags);
+			return -1;
+		}
 	}
 
 	for (fdc = 0; fdc < N_FDC; fdc++) {
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
floppy-tolerate-dma-channel-unavailability.patch
pnp-dont-fail-device-init-if-no-dma-channel.patch
