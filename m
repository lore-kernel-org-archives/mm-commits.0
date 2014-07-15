From: akpm@linux-foundation.org
Subject: + sh7724-clock-fixes.patch added to -mm tree
Date: Tue, 15 Jul 2014 14:55:48 -0700
Message-ID: <53c5a364.VPGMgUvmXL5mqG1R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:33569 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933246AbaGOVzt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jul 2014 17:55:49 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so11814pab.3
        for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2014 14:55:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: danieruru@gmail.com, pebolle@tiscali.nl, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: SH7724 clock fixes
has been added to the -mm tree.  Its filename is
     sh7724-clock-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh7724-clock-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh7724-clock-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Palmer <danieruru@gmail.com>
Subject: sh: SH7724 clock fixes

Fix the device name for the CMT.

Add clocks called usb0 and usb1 so that r8a66597_hcd works again on the
ecovec24 board

Signed-off-by: Daniel Palmer <danieruru@gmail.com>
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

sh7724-clock-fixes.patch

