From: akpm@osdl.org
Subject: + fix-leds-s3c24xx-hardwareh-reference.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:38:47 -0800
Message-ID: <200701022138.l02LclHS030582@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34802 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970AbXABVjr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:39:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpurdie@rpsys.net, arnaud.patard@rtp-net.org, ben-linux@fluff.org


The patch titled
     Fix leds-s3c24xx hardware.h reference
has been added to the -mm tree.  Its filename is
     fix-leds-s3c24xx-hardwareh-reference.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix leds-s3c24xx hardware.h reference
From: Richard Purdie <rpurdie@rpsys.net>

Russell King recently reminded us that one shouldn't use
asm/arch/hardware.h but one should use asm/hardware.h
(http://lkml.org/lkml/2006/12/23/26).  Unfortunately, the leds-s3c24xx
driver is using the wrong header.  This patch is fixing that.

Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: Richard Purdie <rpurdie@rpsys.net>
Acked-by: Ben Dooks <ben-linux@fluff.org> 
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/leds/leds-s3c24xx.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-s3c24xx.c~fix-leds-s3c24xx-hardwareh-reference drivers/leds/leds-s3c24xx.c
--- a/drivers/leds/leds-s3c24xx.c~fix-leds-s3c24xx-hardwareh-reference
+++ a/drivers/leds/leds-s3c24xx.c
@@ -16,7 +16,7 @@
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 
-#include <asm/arch/hardware.h>
+#include <asm/hardware.h>
 #include <asm/arch/regs-gpio.h>
 #include <asm/arch/leds-gpio.h>
 
_

Patches currently in -mm which might be from rpurdie@rpsys.net are

fix-leds-s3c24xx-hardwareh-reference.patch
git-acpi.patch
acpi-add-backlight-support-to-the-sony_acpi.patch
git-alsa.patch
