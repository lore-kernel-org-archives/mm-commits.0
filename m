From: akpm@linux-foundation.org
Subject: + rtc-fix-platform-driver-hotplug-coldplug.patch added to -mm tree
Date: Wed, 09 Apr 2008 15:57:44 -0700
Message-ID: <200804092257.m39MvjlL001540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753155AbYDIW6F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2008 18:58:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay.sievers@vrfy.org, a.zummo@towertech.it, dbrownell@users.sourceforge.net, greg@kroah.com


The patch titled
     rtc: fix platform driver hotplug/coldplug
has been added to the -mm tree.  Its filename is
     rtc-fix-platform-driver-hotplug-coldplug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: fix platform driver hotplug/coldplug
From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias is
prefixed with "platform:".  Add MODULE_ALIAS() to the hotpluggable RTC
platform drivers, to re-enable module auto loading.

[dbrownell@users.sourceforge.net: more drivers, minor fix]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at32ap700x.c |    2 +-
 drivers/rtc/rtc-at91rm9200.c |    1 +
 drivers/rtc/rtc-bfin.c       |    1 +
 drivers/rtc/rtc-cmos.c       |    3 +++
 drivers/rtc/rtc-ds1216.c     |    1 +
 drivers/rtc/rtc-ds1511.c     |    3 +++
 drivers/rtc/rtc-ds1553.c     |    3 +++
 drivers/rtc/rtc-ds1742.c     |    1 +
 drivers/rtc/rtc-ep93xx.c     |    3 +++
 drivers/rtc/rtc-m48t59.c     |    3 +++
 drivers/rtc/rtc-m48t86.c     |    1 +
 drivers/rtc/rtc-omap.c       |    2 +-
 drivers/rtc/rtc-rs5c313.c    |    1 +
 drivers/rtc/rtc-s3c.c        |    1 +
 drivers/rtc/rtc-sa1100.c     |    1 +
 drivers/rtc/rtc-sh.c         |    1 +
 drivers/rtc/rtc-stk17ta8.c   |    3 +++
 drivers/rtc/rtc-v3020.c      |    1 +
 drivers/rtc/rtc-vr41xx.c     |    3 +++
 19 files changed, 33 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-at32ap700x.c~rtc-fix-platform-driver-hotplug-coldplug drivers/rtc/rtc-at32ap700x.c
--- a/drivers/rtc/rtc-at32ap700x.c~rtc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/rtc/rtc-at32ap700x.c
@@ -290,7 +290,7 @@ static int __exit at32_rtc_remove(struct
 	return 0;
 }
 
-MODULE_ALIAS("at32ap700x_rtc");
+MODULE_ALIAS("platform:at32ap700x_rtc");
 
 static struct platform_driver at32_rtc_driver = {
 	.remove		= __exit_p(at32_rtc_remove),
diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-fix-platform-driver-hotplug-coldplug drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -407,3 +407,4 @@ module_exit(at91_rtc_exit);
 MODULE_AUTHOR("Rick Bronson");
 MODULE_DESCRIPTION("RTC driver for Atmel AT91RM9200");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:at91_rtc");
diff -puN drivers/rtc/rtc-bfin.c~rtc-fix-platform-driver-hotplug-coldplug drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~rtc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/rtc/rtc-bfin.c
@@ -470,3 +470,4 @@ module_exit(bfin_rtc_exit);
 MODULE_DESCRIPTION("Blackfin On-Chip Real Time Clock Driver");
 MODULE_AUTHOR("Mike Frysinger <vapier@gentoo.org>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:rtc-bfin");
diff -puN drivers/rtc/rtc-cmos.c~rtc-fix-platform-driver-hotplug-coldplug drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/rtc/rtc-cmos.c
@@ -943,6 +943,9 @@ static void cmos_platform_shutdown(struc
 	cmos_do_shutdown();
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:rtc_cmos");
+
 static struct platform_driver cmos_platform_driver = {
 	.remove		= __exit_p(cmos_platform_remove),
 	.shutdown	= cmos_platform_shutdown,
diff -puN drivers/rtc/rtc-ds1216.c~rtc-fix-platform-driver-hotplug-coldplug drivers/rtc/rtc-ds1216.c
--- a/drivers/rtc/rtc-ds1216.c~rtc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/rtc/rtc-ds1216.c
@@ -221,6 +221,7 @@ MODULE_AUTHOR("Thomas Bogendoerfer <tsbo
 MODULE_DESCRIPTION("DS1216 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("platform:rtc-ds1216");
 
 module_init(ds1216_rtc_init);
 module_exit(ds1216_rtc_exit);
diff -puN drivers/rtc/rtc-ds1511.c~rtc-fix-platform-driver-hotplug-coldplug drivers/rtc/rtc-ds1511.c
--- a/drivers/rtc/rtc-ds1511.c~rtc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/rtc/rtc-ds1511.c
@@ -626,6 +626,9 @@ ds1511_rtc_remove(struct platform_device
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:ds1511");
+
 static struct platform_driver ds1511_rtc_driver = {
 	.probe		= ds1511_rtc_probe,
 	.remove		= __devexit_p(ds1511_rtc_remove),
diff -puN drivers/rtc/rtc-ds1553.c~rtc-fix-platform-driver-hotplug-coldplug drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~rtc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/rtc/rtc-ds1553.c
@@ -391,6 +391,9 @@ static int __devexit ds1553_rtc_remove(s
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:rtc-ds1553");
+
 static struct platform_driver ds1553_rtc_driver = {
 	.probe		= ds1553_rtc_probe,
 	.remove		= __devexit_p(ds1553_rtc_remove),
diff -puN drivers/rtc/rtc-ds1742.c~rtc-fix-platform-driver-hotplug-coldplug drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~rtc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/rtc/rtc-ds1742.c
@@ -276,3 +276,4 @@ MODULE_AUTHOR("Atsushi Nemoto <anemo@mba
 MODULE_DESCRIPTION("Dallas DS1742 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("platform:rtc-ds1742");
diff -puN drivers/rtc/rtc-ep93xx.c~rtc-fix-platform-driver-hotplug-coldplug drivers/rtc/rtc-ep93xx.c
--- a/drivers/rtc/rtc-ep93xx.c~rtc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/rtc/rtc-ep93xx.c
@@ -132,6 +132,9 @@ static int __devexit ep93xx_rtc_remove(s
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:ep93xx-rtc");
+
 static struct platform_driver ep93xx_rtc_platform_driver = {
 	.driver		= {
 		.name	= "ep93xx-rtc",
diff -puN drivers/rtc/rtc-m48t59.c~rtc-fix-platform-driver-hotplug-coldplug drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~rtc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/rtc/rtc-m48t59.c
@@ -465,6 +465,9 @@ static int __devexit m48t59_rtc_remove(s
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:rtc-m48t59");
+
 static struct platform_driver m48t59_rtc_driver = {
 	.driver		= {
 		.name	= "rtc-m48t59",
diff -puN drivers/rtc/rtc-m48t86.c~rtc-fix-platform-driver-hotplug-coldplug drivers/rtc/rtc-m48t86.c
--- a/drivers/rtc/rtc-m48t86.c~rtc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/rtc/rtc-m48t86.c
@@ -199,6 +199,7 @@ MODULE_AUTHOR("Alessandro Zummo <a.zummo
 MODULE_DESCRIPTION("M48T86 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("platform:rtc-m48t86");
 
 module_init(m48t86_rtc_init);
 module_exit(m48t86_rtc_exit);
diff -puN drivers/rtc/rtc-omap.c~rtc-fix-platform-driver-hotplug-coldplug drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/rtc/rtc-omap.c
@@ -497,7 +497,7 @@ static void omap_rtc_shutdown(struct pla
 	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
 }
 
-MODULE_ALIAS("omap_rtc");
+MODULE_ALIAS("platform:omap_rtc");
 static struct platform_driver omap_rtc_driver = {
 	.probe		= omap_rtc_probe,
 	.remove		= __devexit_p(omap_rtc_remove),
diff -puN drivers/rtc/rtc-rs5c313.c~rtc-fix-platform-driver-hotplug-coldplug drivers/rtc/rtc-rs5c313.c
--- a/drivers/rtc/rtc-rs5c313.c~rtc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/rtc/rtc-rs5c313.c
@@ -421,3 +421,4 @@ MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR("kogiidena , Nobuhiro Iwamatsu <iwamatsu@nigauri.org>");
 MODULE_DESCRIPTION("Ricoh RS5C313 RTC device driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRV_NAME);
diff -puN drivers/rtc/rtc-s3c.c~rtc-fix-platform-driver-hotplug-coldplug drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/rtc/rtc-s3c.c
@@ -592,3 +592,4 @@ module_exit(s3c_rtc_exit);
 MODULE_DESCRIPTION("Samsung S3C RTC Driver");
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:s3c2410-rtc");
diff -puN drivers/rtc/rtc-sa1100.c~rtc-fix-platform-driver-hotplug-coldplug drivers/rtc/rtc-sa1100.c
--- a/drivers/rtc/rtc-sa1100.c~rtc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/rtc/rtc-sa1100.c
@@ -399,3 +399,4 @@ module_exit(sa1100_rtc_exit);
 MODULE_AUTHOR("Richard Purdie <rpurdie@rpsys.net>");
 MODULE_DESCRIPTION("SA11x0/PXA2xx Realtime Clock Driver (RTC)");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:sa1100-rtc");
diff -puN drivers/rtc/rtc-sh.c~rtc-fix-platform-driver-hotplug-coldplug drivers/rtc/rtc-sh.c
--- a/drivers/rtc/rtc-sh.c~rtc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/rtc/rtc-sh.c
@@ -664,3 +664,4 @@ MODULE_DESCRIPTION("SuperH on-chip RTC d
 MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR("Paul Mundt <lethal@linux-sh.org>, Jamie Lenehan <lenehan@twibble.org>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRV_NAME);
diff -puN drivers/rtc/rtc-stk17ta8.c~rtc-fix-platform-driver-hotplug-coldplug drivers/rtc/rtc-stk17ta8.c
--- a/drivers/rtc/rtc-stk17ta8.c~rtc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/rtc/rtc-stk17ta8.c
@@ -394,6 +394,9 @@ static int __devexit stk17ta8_rtc_remove
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:stk17ta8");
+
 static struct platform_driver stk17ta8_rtc_driver = {
 	.probe		= stk17ta8_rtc_probe,
 	.remove		= __devexit_p(stk17ta8_rtc_remove),
diff -puN drivers/rtc/rtc-v3020.c~rtc-fix-platform-driver-hotplug-coldplug drivers/rtc/rtc-v3020.c
--- a/drivers/rtc/rtc-v3020.c~rtc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/rtc/rtc-v3020.c
@@ -264,3 +264,4 @@ module_exit(v3020_exit);
 MODULE_DESCRIPTION("V3020 RTC");
 MODULE_AUTHOR("Raphael Assenat");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:v3020");
diff -puN drivers/rtc/rtc-vr41xx.c~rtc-fix-platform-driver-hotplug-coldplug drivers/rtc/rtc-vr41xx.c
--- a/drivers/rtc/rtc-vr41xx.c~rtc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/rtc/rtc-vr41xx.c
@@ -422,6 +422,9 @@ static int __devexit rtc_remove(struct p
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:RTC");
+
 static struct platform_driver rtc_platform_driver = {
 	.probe		= rtc_probe,
 	.remove		= __devexit_p(rtc_remove),
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

i2c-fix-platform-driver-hotplug-coldplug.patch
spi-fix-platform-driver-hotplug-coldplug.patch
usb-gadget-fix-platform-driver-hotplug-coldplug.patch
usb-host-fix-platform-driver-hotplug-coldplug.patch
watchdog-fix-platform-driver-hotplug-coldplug.patch
rtc-fix-platform-driver-hotplug-coldplug.patch
pm-remove-destroy_suspended_device.patch
sysfs-refill-attribute-buffer-when-reading-from-offset-0.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7-fix.patch
pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type-rev-3.patch
pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type-rev-3.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch

