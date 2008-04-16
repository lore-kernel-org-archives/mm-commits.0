From: akpm@linux-foundation.org
Subject: - leds-fix-platform-driver-hotplug-coldplug.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:54:46 -0700
Message-ID: <200804162254.m3GMskiq011051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756283AbYDPWzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 18:55:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay.sievers@vrfy.org, dbrownell@users.sourceforge.net, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: fix platform driver hotplug/coldplug
has been removed from the -mm tree.  Its filename was
     leds-fix-platform-driver-hotplug-coldplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: fix platform driver hotplug/coldplug
From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform
modalias is prefixed with "platform:". Add MODULE_ALIAS() to the
hotpluggable platform LED drivers, to re-enable auto loading.

[dbrownell@users.sourceforge.net: more drivers, registration fixes]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-ams-delta.c   |    2 ++
 drivers/leds/leds-atmel-pwm.c   |    3 +++
 drivers/leds/leds-clevo-mail.c  |    1 +
 drivers/leds/leds-cm-x270.c     |    2 ++
 drivers/leds/leds-cobalt-qube.c |    3 +++
 drivers/leds/leds-corgi.c       |    2 ++
 drivers/leds/leds-gpio.c        |    1 +
 drivers/leds/leds-h1940.c       |    2 ++
 drivers/leds/leds-hp6xx.c       |    4 ++++
 drivers/leds/leds-s3c24xx.c     |    1 +
 drivers/leds/leds-spitz.c       |    2 ++
 drivers/leds/leds-tosa.c        |    2 ++
 12 files changed, 25 insertions(+)

diff -puN drivers/leds/leds-ams-delta.c~leds-fix-platform-driver-hotplug-coldplug drivers/leds/leds-ams-delta.c
--- a/drivers/leds/leds-ams-delta.c~leds-fix-platform-driver-hotplug-coldplug
+++ a/drivers/leds/leds-ams-delta.c
@@ -140,6 +140,7 @@ static struct platform_driver ams_delta_
 	.resume		= ams_delta_led_resume,
 	.driver		= {
 		.name = "ams-delta-led",
+		.owner = THIS_MODULE,
 	},
 };
 
@@ -159,3 +160,4 @@ module_exit(ams_delta_led_exit);
 MODULE_AUTHOR("Jonathan McDowell <noodles@earth.li>");
 MODULE_DESCRIPTION("Amstrad Delta LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:ams-delta-led");
diff -puN drivers/leds/leds-atmel-pwm.c~leds-fix-platform-driver-hotplug-coldplug drivers/leds/leds-atmel-pwm.c
--- a/drivers/leds/leds-atmel-pwm.c~leds-fix-platform-driver-hotplug-coldplug
+++ a/drivers/leds/leds-atmel-pwm.c
@@ -132,6 +132,9 @@ static int __exit pwmled_remove(struct p
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:leds-atmel-pwm");
+
 static struct platform_driver pwmled_driver = {
 	.driver = {
 		.name =		"leds-atmel-pwm",
diff -puN drivers/leds/leds-clevo-mail.c~leds-fix-platform-driver-hotplug-coldplug drivers/leds/leds-clevo-mail.c
--- a/drivers/leds/leds-clevo-mail.c~leds-fix-platform-driver-hotplug-coldplug
+++ a/drivers/leds/leds-clevo-mail.c
@@ -170,6 +170,7 @@ static struct platform_driver clevo_mail
 	.resume		= clevo_mail_led_resume,
 	.driver		= {
 		.name		= KBUILD_MODNAME,
+		.owner		= THIS_MODULE,
 	},
 };
 
diff -puN drivers/leds/leds-cm-x270.c~leds-fix-platform-driver-hotplug-coldplug drivers/leds/leds-cm-x270.c
--- a/drivers/leds/leds-cm-x270.c~leds-fix-platform-driver-hotplug-coldplug
+++ a/drivers/leds/leds-cm-x270.c
@@ -101,6 +101,7 @@ static struct platform_driver cmx270led_
 #endif
 	.driver		= {
 		.name		= "cm-x270-led",
+		.owner		= THIS_MODULE,
 	},
 };
 
@@ -120,3 +121,4 @@ module_exit(cmx270led_exit);
 MODULE_AUTHOR("Mike Rapoport <mike@compulab.co.il>");
 MODULE_DESCRIPTION("CM-x270 LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:cm-x270-led");
diff -puN drivers/leds/leds-cobalt-qube.c~leds-fix-platform-driver-hotplug-coldplug drivers/leds/leds-cobalt-qube.c
--- a/drivers/leds/leds-cobalt-qube.c~leds-fix-platform-driver-hotplug-coldplug
+++ a/drivers/leds/leds-cobalt-qube.c
@@ -75,6 +75,9 @@ static int __devexit cobalt_qube_led_rem
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:cobalt-qube-leds");
+
 static struct platform_driver cobalt_qube_led_driver = {
 	.probe	= cobalt_qube_led_probe,
 	.remove	= __devexit_p(cobalt_qube_led_remove),
diff -puN drivers/leds/leds-corgi.c~leds-fix-platform-driver-hotplug-coldplug drivers/leds/leds-corgi.c
--- a/drivers/leds/leds-corgi.c~leds-fix-platform-driver-hotplug-coldplug
+++ a/drivers/leds/leds-corgi.c
@@ -99,6 +99,7 @@ static struct platform_driver corgiled_d
 #endif
 	.driver		= {
 		.name		= "corgi-led",
+		.owner		= THIS_MODULE,
 	},
 };
 
@@ -118,3 +119,4 @@ module_exit(corgiled_exit);
 MODULE_AUTHOR("Richard Purdie <rpurdie@openedhand.com>");
 MODULE_DESCRIPTION("Corgi LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:corgi-led");
diff -puN drivers/leds/leds-gpio.c~leds-fix-platform-driver-hotplug-coldplug drivers/leds/leds-gpio.c
--- a/drivers/leds/leds-gpio.c~leds-fix-platform-driver-hotplug-coldplug
+++ a/drivers/leds/leds-gpio.c
@@ -199,3 +199,4 @@ module_exit(gpio_led_exit);
 MODULE_AUTHOR("Raphael Assenat <raph@8d.com>");
 MODULE_DESCRIPTION("GPIO LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-gpio");
diff -puN drivers/leds/leds-h1940.c~leds-fix-platform-driver-hotplug-coldplug drivers/leds/leds-h1940.c
--- a/drivers/leds/leds-h1940.c~leds-fix-platform-driver-hotplug-coldplug
+++ a/drivers/leds/leds-h1940.c
@@ -139,6 +139,7 @@ static int h1940leds_remove(struct platf
 static struct platform_driver h1940leds_driver = {
 	.driver		= {
 		.name	= "h1940-leds",
+		.owner	= THIS_MODULE,
 	},
 	.probe		= h1940leds_probe,
 	.remove		= h1940leds_remove,
@@ -161,3 +162,4 @@ module_exit(h1940leds_exit);
 MODULE_AUTHOR("Arnaud Patard <arnaud.patard@rtp-net.org>");
 MODULE_DESCRIPTION("LED driver for the iPAQ H1940");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:h1940-leds");
diff -puN drivers/leds/leds-hp6xx.c~leds-fix-platform-driver-hotplug-coldplug drivers/leds/leds-hp6xx.c
--- a/drivers/leds/leds-hp6xx.c~leds-fix-platform-driver-hotplug-coldplug
+++ a/drivers/leds/leds-hp6xx.c
@@ -90,6 +90,9 @@ static int hp6xxled_remove(struct platfo
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:hp6xx-led");
+
 static struct platform_driver hp6xxled_driver = {
 	.probe		= hp6xxled_probe,
 	.remove		= hp6xxled_remove,
@@ -99,6 +102,7 @@ static struct platform_driver hp6xxled_d
 #endif
 	.driver		= {
 		.name		= "hp6xx-led",
+		.owner		= THIS_MODULE,
 	},
 };
 
diff -puN drivers/leds/leds-s3c24xx.c~leds-fix-platform-driver-hotplug-coldplug drivers/leds/leds-s3c24xx.c
--- a/drivers/leds/leds-s3c24xx.c~leds-fix-platform-driver-hotplug-coldplug
+++ a/drivers/leds/leds-s3c24xx.c
@@ -160,3 +160,4 @@ module_exit(s3c24xx_led_exit);
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
 MODULE_DESCRIPTION("S3C24XX LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:s3c24xx_led");
diff -puN drivers/leds/leds-spitz.c~leds-fix-platform-driver-hotplug-coldplug drivers/leds/leds-spitz.c
--- a/drivers/leds/leds-spitz.c~leds-fix-platform-driver-hotplug-coldplug
+++ a/drivers/leds/leds-spitz.c
@@ -105,6 +105,7 @@ static struct platform_driver spitzled_d
 #endif
 	.driver		= {
 		.name		= "spitz-led",
+		.owner		= THIS_MODULE,
 	},
 };
 
@@ -124,3 +125,4 @@ module_exit(spitzled_exit);
 MODULE_AUTHOR("Richard Purdie <rpurdie@openedhand.com>");
 MODULE_DESCRIPTION("Spitz LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:spitz-led");
diff -puN drivers/leds/leds-tosa.c~leds-fix-platform-driver-hotplug-coldplug drivers/leds/leds-tosa.c
--- a/drivers/leds/leds-tosa.c~leds-fix-platform-driver-hotplug-coldplug
+++ a/drivers/leds/leds-tosa.c
@@ -109,6 +109,7 @@ static struct platform_driver tosaled_dr
 	.resume		= tosaled_resume,
 	.driver		= {
 		.name		= "tosa-led",
+		.owner		= THIS_MODULE,
 	},
 };
 
@@ -128,3 +129,4 @@ module_exit(tosaled_exit);
 MODULE_AUTHOR("Dirk Opfer <Dirk@Opfer-Online.de>");
 MODULE_DESCRIPTION("Tosa LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:tosa-led");
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

origin.patch
git-alsa-tiwai.patch
macintosh-windfarm-fix-platform-driver-hotplug-coldplug.patch
input-fix-platform-driver-hotplug-coldplug.patch
ata-ide-fix-platform-driver-hotplug-coldplug.patch
mtd-maps-fix-platform-driver-hotplug-coldplug.patch
mtd-nand-fix-platform-driver-hotplug-coldplug.patch
net-drivers-fix-platform-driver-hotplug-coldplug.patch
scsi-fix-platform-driver-hotplug-coldplug.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch

