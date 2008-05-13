From: akpm@linux-foundation.org
Subject: - atmel_lcdfb-fix-pixclok-divider-calculation.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:57 -0700
Message-ID: <200805132133.m4DLXvmt000869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760122AbYEMVei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@atmel.com, 12o3l@tiscali.nl, hskinnemoen@atmel.com, jw022609@uni-greifswald.de, linux@maxim.org.za, per.hedblom@abem.se, mm-commits@vger.kernel.org


The patch titled
     atmel_lcdfb: fix pixclock divider calculation
has been removed from the -mm tree.  Its filename was
     atmel_lcdfb-fix-pixclok-divider-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_lcdfb: fix pixclock divider calculation
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Fix divider calculation and allow CLKVAL = 0 (divisor 2)

It was not possible to get the clock value 0 (divisor 2) because
the test "<=0" force the BYPASS bit to be activated instead.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Per Hedblom <per.hedblom@abem.se>
Cc: Roel Kluin <12o3l@tiscali.nl>
Cc: Jan Weber <jw022609@uni-greifswald.de>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-fix-pixclok-divider-calculation drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-fix-pixclok-divider-calculation
+++ a/drivers/video/atmel_lcdfb.c
@@ -441,14 +441,15 @@ static int atmel_lcdfb_set_par(struct fb
 
 	value = DIV_ROUND_UP(clk_value_khz, PICOS2KHZ(info->var.pixclock));
 
-	value = (value / 2) - 1;
-	dev_dbg(info->device, "  * programming CLKVAL = 0x%08lx\n", value);
