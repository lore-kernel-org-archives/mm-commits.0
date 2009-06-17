From: akpm@linux-foundation.org
Subject: [merged] atmel-lcdc-fix-pixclock-upper-bound-detection.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:39:18 -0700
Message-ID: <200906171839.n5HIdIdL005305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754480AbZFQSvI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:51:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bn@niasdigital.com, dg@emlix.com, haavard.skinnemoen@atmel.com, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel-lcdc: fix pixclock upper bound detection
has been removed from the -mm tree.  Its filename was
     atmel-lcdc-fix-pixclock-upper-bound-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel-lcdc: fix pixclock upper bound detection
From: Ben Nizette <bn@niasdigital.com>

AFAICT the code which checks that the requested pixclock value is within
bounds is incorrect.  It ensures that the lcdc core clock is at least
(bytes per pixel) times higher than the pixel clock rather than just
greater than or equal to.

There are tighter restrictions on the pixclock value as a function of bus
width for STN panels but even then it isn't a simple relationship as
currently checked for.  IMO either something like the below patch should
be applied or else more detailed checking logic should be implemented
which takes in to account the panel type as well.

Signed-off-by: Ben Nizette <bn@niasdigital.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Daniel Glockner <dg@emlix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/atmel_lcdfb.c~atmel-lcdc-fix-pixclock-upper-bound-detection drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel-lcdc-fix-pixclock-upper-bound-detection
+++ a/drivers/video/atmel_lcdfb.c
@@ -345,7 +345,7 @@ static int atmel_lcdfb_check_var(struct 
 	dev_dbg(dev, "  bpp:        %u\n", var->bits_per_pixel);
 	dev_dbg(dev, "  clk:        %lu KHz\n", clk_value_khz);
 
-	if ((PICOS2KHZ(var->pixclock) * var->bits_per_pixel / 8) > clk_value_khz) {
+	if (PICOS2KHZ(var->pixclock) > clk_value_khz) {
 		dev_err(dev, "%lu KHz pixel clock is too fast\n", PICOS2KHZ(var->pixclock));
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from bn@niasdigital.com are

origin.patch

