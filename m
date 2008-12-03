From: akpm@linux-foundation.org
Subject: + mtd-oops-accessing-flash-operations-over-stm-flash-on-pxa.patch added to -mm tree
Date: Tue, 02 Dec 2008 20:19:06 -0800
Message-ID: <200812030419.mB34J6vw006692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627AbYLCETO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 23:19:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@parallels.com, den@openvz.org, dwmw2@infradead.org, ymiao3@marvell.com


The patch titled
     mtd: fix OOPS accessing flash operations over STM flash on PXA
has been added to the -mm tree.  Its filename is
     mtd-oops-accessing-flash-operations-over-stm-flash-on-pxa.patch

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
Subject: mtd: fix OOPS accessing flash operations over STM flash on PXA
From: "Denis V. Lunev" <den@parallels.com>

STM 2Gb flash is a large-page NAND flash.  Set operations accordingly. 
This field is dereferrenced without a check in several places resulting in
OOPS.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Acked-by: Eric Miao <ymiao3@marvell.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/pxa3xx_nand.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mtd/nand/pxa3xx_nand.c~mtd-oops-accessing-flash-operations-over-stm-flash-on-pxa drivers/mtd/nand/pxa3xx_nand.c
--- a/drivers/mtd/nand/pxa3xx_nand.c~mtd-oops-accessing-flash-operations-over-stm-flash-on-pxa
+++ a/drivers/mtd/nand/pxa3xx_nand.c
@@ -269,6 +269,7 @@ static struct pxa3xx_nand_timing stm2GbX
 
 static struct pxa3xx_nand_flash stm2GbX16 = {
 	.timing = &stm2GbX16_timing,
+	.cmdset	= &largepage_cmdset,
 	.page_per_block = 64,
 	.page_size = 2048,
 	.flash_width = 16,
_

Patches currently in -mm which might be from den@parallels.com are

mtd-oops-accessing-flash-operations-over-stm-flash-on-pxa.patch

