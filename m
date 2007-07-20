From: akpm@linux-foundation.org
Subject: + atmel_lcdfb-use-spare-bits-in-32bpp-mode-as-alpha-channel.patch added to -mm tree
Date: Fri, 20 Jul 2007 16:25:39 -0700
Message-ID: <200707202325.l6KNPdeD021900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56990 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756210AbXGTXZ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 19:25:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com, adaplas@pol.net, nicolas.ferre@rfo.atmel.com


The patch titled
     atmel_lcdfb: use spare bits in 32bpp mode as alpha channel
has been added to the -mm tree.  Its filename is
     atmel_lcdfb-use-spare-bits-in-32bpp-mode-as-alpha-channel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 4 insertions(+), 1 deletion(-)

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

origin.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
atmel_lcdfb-fix-stn-lcd-support.patch
atmel_lcdfb-use-spare-bits-in-32bpp-mode-as-alpha-channel.patch
