From: akpm@linux-foundation.org
Subject: [merged] atmel_lcdfb-correct-fifo-size-for-some-products.patch removed from -mm tree
Date: Fri, 29 May 2009 11:43:14 -0700
Message-ID: <200905291843.n4TIhEj6011445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039AbZE2SxC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 14:53:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@atmel.com, avictor.za@gmail.com, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_lcdfb: correct fifo size for some products
has been removed from the -mm tree.  Its filename was
     atmel_lcdfb-correct-fifo-size-for-some-products.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_lcdfb: correct fifo size for some products
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Remove wrong fifo size definition for some AT91 products.

Due to a misunderstanding of some AT91 datasheets, a fifo size of 2048
(words) has been introduced by mistake.  In fact, all products (AT91/AT32)
are sharing the same fifo size of 512 words.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-correct-fifo-size-for-some-products drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-correct-fifo-size-for-some-products
+++ a/drivers/video/atmel_lcdfb.c
@@ -29,14 +29,8 @@
 
 /* configurable parameters */
 #define ATMEL_LCDC_CVAL_DEFAULT		0xc8
-#define ATMEL_LCDC_DMA_BURST_LEN	8
