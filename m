From: akpm@linux-foundation.org
Subject: - atmel_lcdfb-adjust-fifo-size-for-at91sam9rl.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:44 -0700
Message-ID: <200804282158.m3SLwi6p018513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965445AbYD1V7Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@atmel.com, adaplas@pol.net, andrew@sanpeople.com, nicolas.ferre@rfo.atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_lcdfb: adjust fifo size for at91sam9rl
has been removed from the -mm tree.  Its filename was
     atmel_lcdfb-adjust-fifo-size-for-at91sam9rl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_lcdfb: adjust fifo size for at91sam9rl
From: Nicolas Ferre <nicolas.ferre@atmel.com>

AT91SAM9RL soc has a 2048 bytes deep FIFO, like AT91SAM9263.

[bn@niasdigital.com: fix build breakage in atmel_lcdfb]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Nicolas FERRE <nicolas.ferre@rfo.atmel.com>
Cc: Andrew Victor <andrew@sanpeople.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-adjust-fifo-size-for-at91sam9rl drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-adjust-fifo-size-for-at91sam9rl
+++ a/drivers/video/atmel_lcdfb.c
@@ -31,7 +31,8 @@
 #define ATMEL_LCDC_CVAL_DEFAULT		0xc8
 #define ATMEL_LCDC_DMA_BURST_LEN	8
 
-#if defined(CONFIG_ARCH_AT91SAM9263) || defined(CONFIG_ARCH_AT91CAP9)
+#if defined(CONFIG_ARCH_AT91SAM9263) || defined(CONFIG_ARCH_AT91CAP9) || \
+	defined(CONFIG_ARCH_AT91SAM9RL)
 #define ATMEL_LCDC_FIFO_SIZE		2048
 #else
 #define ATMEL_LCDC_FIFO_SIZE		512
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

origin.patch

