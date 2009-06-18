From: akpm@linux-foundation.org
Subject: [merged] leds-alix-leds2-fixed-for-award-bios.patch removed from -mm tree
Date: Thu, 18 Jun 2009 11:20:41 -0700
Message-ID: <200906181820.n5IIKfeL018207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753104AbZFRSVV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 14:21:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Tobias_Mueller@twam.info, const@mimas.ru, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: alix-leds2 fixed for Award  BIOS
has been removed from the -mm tree.  Its filename was
     leds-alix-leds2-fixed-for-award-bios.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: alix-leds2 fixed for Award  BIOS
From: Tobias Mueller <Tobias_Mueller@twam.info>

Add initialisation of GPIO ports for compatibility with boards with Award
BIOS (e.g.  ALIX.3D3).

Signed-off-by: Tobias Mueller <Tobias_Mueller@twam.info>
Reviewed-by: Constantin Baranov <const@mimas.ru>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig      |    1 +
 drivers/leds/leds-alix2.c |    7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/leds/Kconfig~leds-alix-leds2-fixed-for-award-bios drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-alix-leds2-fixed-for-award-bios
+++ a/drivers/leds/Kconfig
@@ -75,6 +75,7 @@ config LEDS_ALIX2
 	depends on LEDS_CLASS && X86 && EXPERIMENTAL
 	help
 	  This option enables support for the PCEngines ALIX.2 and ALIX.3 LEDs.
+	  You have to set leds-alix2.force=1 for boards with Award BIOS.
 
 config LEDS_H1940
 	tristate "LED Support for iPAQ H1940 device"
diff -puN drivers/leds/leds-alix2.c~leds-alix-leds2-fixed-for-award-bios drivers/leds/leds-alix2.c
--- a/drivers/leds/leds-alix2.c~leds-alix-leds2-fixed-for-award-bios
+++ a/drivers/leds/leds-alix2.c
@@ -14,7 +14,7 @@
 
 static int force = 0;
 module_param(force, bool, 0444);
-MODULE_PARM_DESC(force, "Assume system has ALIX.2 style LEDs");
+MODULE_PARM_DESC(force, "Assume system has ALIX.2/ALIX.3 style LEDs");
 
 struct alix_led {
 	struct led_classdev cdev;
@@ -155,6 +155,11 @@ static int __init alix_led_init(void)
 		goto out;
 	}
 
+	/* enable output on GPIO for LED 1,2,3 */
+	outl(1 << 6, 0x6104);
+	outl(1 << 9, 0x6184);
+	outl(1 << 11, 0x6184);
+
 	pdev = platform_device_register_simple(KBUILD_MODNAME, -1, NULL, 0);
 	if (!IS_ERR(pdev)) {
 		ret = platform_driver_probe(&alix_led_driver, alix_led_probe);
_

Patches currently in -mm which might be from Tobias_Mueller@twam.info are

linux-next.patch

