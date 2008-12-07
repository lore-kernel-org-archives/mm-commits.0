From: akpm@linux-foundation.org
Subject: - mtd-oops-accessing-flash-operations-over-stm-flash-on-pxa.patch removed from -mm tree
Date: Sat, 06 Dec 2008 16:05:52 -0800
Message-ID: <200812070005.mB705q7J021641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753580AbYLGAGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 19:06:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@parallels.com, den@openvz.org, dwmw2@infradead.org, ymiao3@marvell.com, mm-commits@vger.kernel.org


The patch titled
     mtd: fix OOPS accessing flash operations over STM flash on PXA
has been removed from the -mm tree.  Its filename was
     mtd-oops-accessing-flash-operations-over-stm-flash-on-pxa.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

