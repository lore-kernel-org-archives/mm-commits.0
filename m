From: akpm@linux-foundation.org
Subject: [folded] backlight-add-ams369fg06-amoled-driver-fix.patch removed from -mm tree
Date: Mon, 25 Jul 2011 16:55:04 -0700
Message-ID: <201107252355.p6PNt4B3006137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960Ab1GYXzv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 19:55:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, anish198519851985@gmail.com, inki.dae@samsung.com, jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     backlight-add-ams369fg06-amoled-driver-fix
has been removed from the -mm tree.  Its filename was
     backlight-add-ams369fg06-amoled-driver-fix.patch

This patch was dropped because it was folded into backlight-add-ams369fg06-amoled-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight-add-ams369fg06-amoled-driver-fix
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 1 Jul 2011 15:34:22 +1000
Subject: [PATCH] backlight: make some varibales static

fixes this build error:

drivers/video/backlight/ams369fg06.o:(.bss+0x510): multiple definition of `before_power'
drivers/video/backlight/s6e63m0.o:(.bss+0x5e0): first defined here

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: anish singh <anish198519851985@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |    2 +-
 drivers/video/backlight/s6e63m0.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/ams369fg06.c~backlight-add-ams369fg06-amoled-driver-fix drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~backlight-add-ams369fg06-amoled-driver-fix
+++ a/drivers/video/backlight/ams369fg06.c
@@ -560,7 +560,7 @@ static int __devexit ams369fg06_remove(s
 }
 
 #if defined(CONFIG_PM)
-unsigned int before_power;
+static unsigned int before_power;
 
 static int ams369fg06_suspend(struct spi_device *spi, pm_message_t mesg)
 {
diff -puN drivers/video/backlight/s6e63m0.c~backlight-add-ams369fg06-amoled-driver-fix drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~backlight-add-ams369fg06-amoled-driver-fix
+++ a/drivers/video/backlight/s6e63m0.c
@@ -840,7 +840,7 @@ static int __devexit s6e63m0_remove(stru
 }
 
 #if defined(CONFIG_PM)
-unsigned int before_power;
+static unsigned int before_power;
 
 static int s6e63m0_suspend(struct spi_device *spi, pm_message_t mesg)
 {
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
backlight-add-ams369fg06-amoled-driver.patch
notifiers-sys-move-reboot-notifiers-into-rebooth-fix.patch
gma500-udelay20000-it-too-long-again.patch

