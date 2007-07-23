From: akpm@linux-foundation.org
Subject: - atmel_lcdfb-use-spare-bits-in-32bpp-mode-as-alpha-channel.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:35:15 -0700
Message-ID: <200707230935.l6N9ZFoi016469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50602 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755701AbXGWJtY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:49:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, adaplas@pol.net, nicolas.ferre@rfo.atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_lcdfb: use spare bits in 32bpp mode as alpha channel
has been removed from the -mm tree.  Its filename was
     atmel_lcdfb-use-spare-bits-in-32bpp-mode-as-alpha-channel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atmel_lcdfb: use spare bits in 32bpp mode as alpha channel
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Set var->transp.offset and var->transp.length in 32bpp mode to indicate
that the 8 otherwise unused bits can be used for transparency.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-use-spare-bits-in-32bpp-mode-as-alpha-channel drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-use-spare-bits-in-32bpp-mode-as-alpha-channel
+++ a/drivers/video/atmel_lcdfb.c
@@ -219,8 +219,11 @@ static int atmel_lcdfb_check_var(struct 
 		var->blue.offset = 10;
 		var->red.length = var->green.length = var->blue.length = 5;
 		break;
-	case 24:
 	case 32:
+		var->transp.offset = 24;
+		var->transp.length = 8;
+		/* fall through */
+	case 24:
 		var->red.offset = 0;
 		var->green.offset = 8;
 		var->blue.offset = 16;
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
