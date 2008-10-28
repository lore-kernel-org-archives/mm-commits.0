From: akpm@linux-foundation.org
Subject: + ep93xx-fix-ohci-dma-mask.patch added to -mm tree
Date: Tue, 28 Oct 2008 13:17:46 -0700
Message-ID: <200810282017.m9SKHkbn015415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752652AbYJ1USU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 16:18:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias@kaehlcke.net


The patch titled
     ep93xx: fix OHCI DMA mask
has been added to the -mm tree.  Its filename is
     ep93xx-fix-ohci-dma-mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ep93xx: fix OHCI DMA mask
From: Matthias Kaehlcke <matthias@kaehlcke.net>

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-ep93xx/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/arm/mach-ep93xx/core.c~ep93xx-fix-ohci-dma-mask arch/arm/mach-ep93xx/core.c
--- a/arch/arm/mach-ep93xx/core.c~ep93xx-fix-ohci-dma-mask
+++ a/arch/arm/mach-ep93xx/core.c
@@ -26,6 +26,7 @@
 #include <linux/serial_core.h>
 #include <linux/device.h>
 #include <linux/mm.h>
+#include <linux/dma-mapping.h>
 #include <linux/time.h>
 #include <linux/timex.h>
 #include <linux/delay.h>
@@ -449,12 +450,13 @@ static struct resource ep93xx_ohci_resou
 	},
 };
 
+
 static struct platform_device ep93xx_ohci_device = {
 	.name		= "ep93xx-ohci",
 	.id		= -1,
 	.dev		= {
-		.dma_mask		= (void *)0xffffffff,
-		.coherent_dma_mask	= 0xffffffff,
+		.dma_mask		= &ep93xx_ohci_device.dev.coherent_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 	.num_resources	= ARRAY_SIZE(ep93xx_ohci_resources),
 	.resource	= ep93xx_ohci_resources,
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

ep93xx-fix-ohci-dma-mask.patch

