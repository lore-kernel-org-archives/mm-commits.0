From: akpm@linux-foundation.org
Subject: [merged] sh7724-clock-fixes.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:02:31 -0700
Message-ID: <53e3db57.ieFK9iFn1WGvw1C8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:54831 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaHGUCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:02:32 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so1172603pab.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:02:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: danieruru@gmail.com, kuninori.morimoto.gx@renesas.com, pebolle@tiscali.nl, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: SH7724 clock fixes
has been removed from the -mm tree.  Its filename was
     sh7724-clock-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Palmer <danieruru@gmail.com>
Subject: sh: SH7724 clock fixes

Fix the device name for the CMT.

Add clocks called usb0 and usb1 so that r8a66597_hcd works again on the
ecovec24 board

Signed-off-by: Daniel Palmer <danieruru@gmail.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/cpu/sh4a/clock-sh7724.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/sh/kernel/cpu/sh4a/clock-sh7724.c~sh7724-clock-fixes arch/sh/kernel/cpu/sh4a/clock-sh7724.c
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7724.c~sh7724-clock-fixes
+++ a/arch/sh/kernel/cpu/sh4a/clock-sh7724.c
@@ -307,7 +307,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_ICK_ID("fck", "sh-tmu.0", &mstp_clks[HWBLK_TMU0]),
 	CLKDEV_ICK_ID("fck", "sh-tmu.1", &mstp_clks[HWBLK_TMU1]),
 
-	CLKDEV_ICK_ID("fck", "sh-cmt-16.0", &mstp_clks[HWBLK_CMT]),
+	CLKDEV_ICK_ID("fck", "sh-cmt-32.0", &mstp_clks[HWBLK_CMT]),
 	CLKDEV_DEV_ID("sh-wdt.0", &mstp_clks[HWBLK_RWDT]),
 	CLKDEV_DEV_ID("sh-dma-engine.1", &mstp_clks[HWBLK_DMAC1]),
 
@@ -332,6 +332,8 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_CON_ID("tsif0", &mstp_clks[HWBLK_TSIF]),
 	CLKDEV_DEV_ID("renesas_usbhs.1", &mstp_clks[HWBLK_USB1]),
 	CLKDEV_DEV_ID("renesas_usbhs.0", &mstp_clks[HWBLK_USB0]),
+	CLKDEV_CON_ID("usb1", &mstp_clks[HWBLK_USB1]),
+	CLKDEV_CON_ID("usb0", &mstp_clks[HWBLK_USB0]),
 	CLKDEV_CON_ID("2dg0", &mstp_clks[HWBLK_2DG]),
 	CLKDEV_DEV_ID("sh_mobile_sdhi.0", &mstp_clks[HWBLK_SDHI0]),
 	CLKDEV_DEV_ID("sh_mobile_sdhi.1", &mstp_clks[HWBLK_SDHI1]),
_

Patches currently in -mm which might be from danieruru@gmail.com are

origin.patch

