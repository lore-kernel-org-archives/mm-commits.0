From: akpm@osdl.org
Subject: + avr32-fix-build-breakage.patch added to -mm tree
Date: Tue, 23 Jan 2007 12:18:00 -0800
Message-ID: <200701232018.l0NKI0vo030123@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53086 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933108AbXAWUSS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 15:18:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben.nizette@iinet.net.au, hskinnemoen@atmel.com


The patch titled
     AVR32: fix build breakage
has been added to the -mm tree.  Its filename is
     avr32-fix-build-breakage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: AVR32: fix build breakage
From: Ben Nizette <ben.nizette@iinet.net.au>

Remove an unwanted remnant of the recent revert of AVR32/AT91 SPI
patches in -mm.  Without this patch, the AVR32 build of
2.6.20-rc[34]-mm1 breaks.

Signed-off-by: Ben Nizette <ben.nizette@iinet.net.au>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/avr32/mach-at32ap/at32ap7000.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/avr32/mach-at32ap/at32ap7000.c~avr32-fix-build-breakage arch/avr32/mach-at32ap/at32ap7000.c
--- a/arch/avr32/mach-at32ap/at32ap7000.c~avr32-fix-build-breakage
+++ a/arch/avr32/mach-at32ap/at32ap7000.c
@@ -895,7 +895,7 @@ struct clk *at32_clock_list[] = {
 	&macb0_pclk,
 	&macb1_hclk,
 	&macb1_pclk,
-	&atmel_spi0_mck,
+	&atmel_spi0_pclk,
 	&atmel_spi1_pclk,
 	&lcdc0_hclk,
 	&lcdc0_pixclk,
_

Patches currently in -mm which might be from ben.nizette@iinet.net.au are

avr32-fix-build-breakage.patch
