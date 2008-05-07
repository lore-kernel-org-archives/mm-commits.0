From: akpm@linux-foundation.org
Subject: + atmel_lcdfb-fix-pixclok-divider-calculation.patch added to -mm tree
Date: Wed, 07 May 2008 15:08:35 -0700
Message-ID: <200805072208.m47M8ZCt019042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932344AbYEGWJn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 18:09:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, 12o3l@tiscali.nl, hskinnemoen@atmel.com, jw022609@uni-greifswald.de, linux@maxim.org.za, per.hedblom@abem.se


The patch titled
     atmel_lcdfb: fix pixclok divider calculation
has been added to the -mm tree.  Its filename is
     atmel_lcdfb-fix-pixclok-divider-calculation.patch

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
Subject: atmel_lcdfb: fix pixclok divider calculation
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Fix divider calculation and allow CLKVAL = 0 (divisor 2)

It was not possible to get the clock value 0 (divisor 2) because
the test "<=0" force the BYPASS bit to be activated instead.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Per Hedblom <per.hedblom@abem.se>
Cc: Roel Kluin <12o3l@tiscali.nl>
Cc: Jan Weber <jw022609@uni-greifswald.de>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-fix-pixclok-divider-calculation drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-fix-pixclok-divider-calculation
+++ a/drivers/video/atmel_lcdfb.c
@@ -441,13 +441,12 @@ static int atmel_lcdfb_set_par(struct fb
 
 	value = DIV_ROUND_UP(clk_value_khz, PICOS2KHZ(info->var.pixclock));
 
-	value = (value / 2) - 1;
-	dev_dbg(info->device, "  * programming CLKVAL = 0x%08lx\n", value);
