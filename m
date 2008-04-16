From: akpm@linux-foundation.org
Subject: - pcmcia-fix-platform-driver-hotplug-coldplug.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:54:53 -0700
Message-ID: <200804162254.m3GMsrF8011063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756369AbYDPWzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 18:55:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay.sievers@vrfy.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     pcmcia: fix platform driver hotplug/coldplug
has been removed from the -mm tree.  Its filename was
     pcmcia-fix-platform-driver-hotplug-coldplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia: fix platform driver hotplug/coldplug
From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias is
prefixed with "platform:".  Add MODULE_ALIAS() to the hotpluggable PCMCIA
platform drivers, to re-enable auto loading.

[dbrownell@users.sourceforge.net: registration fixes]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/at91_cf.c     |    1 +
 drivers/pcmcia/omap_cf.c     |    2 ++
 drivers/pcmcia/pxa2xx_base.c |    2 ++
 3 files changed, 5 insertions(+)

diff -puN drivers/pcmcia/at91_cf.c~pcmcia-fix-platform-driver-hotplug-coldplug drivers/pcmcia/at91_cf.c
--- a/drivers/pcmcia/at91_cf.c~pcmcia-fix-platform-driver-hotplug-coldplug
+++ a/drivers/pcmcia/at91_cf.c
@@ -419,3 +419,4 @@ module_exit(at91_cf_exit);
 MODULE_DESCRIPTION("AT91 Compact Flash Driver");
 MODULE_AUTHOR("David Brownell");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:at91_cf");
diff -puN drivers/pcmcia/omap_cf.c~pcmcia-fix-platform-driver-hotplug-coldplug drivers/pcmcia/omap_cf.c
--- a/drivers/pcmcia/omap_cf.c~pcmcia-fix-platform-driver-hotplug-coldplug
+++ a/drivers/pcmcia/omap_cf.c
@@ -344,6 +344,7 @@ static int omap_cf_resume(struct platfor
 static struct platform_driver omap_cf_driver = {
 	.driver = {
 		.name	= (char *) driver_name,
+		.owner	= THIS_MODULE,
 	},
 	.remove		= __exit_p(omap_cf_remove),
 	.suspend	= omap_cf_suspend,
@@ -368,3 +369,4 @@ module_exit(omap_cf_exit);
 
 MODULE_DESCRIPTION("OMAP CF Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:omap_cf");
diff -puN drivers/pcmcia/pxa2xx_base.c~pcmcia-fix-platform-driver-hotplug-coldplug drivers/pcmcia/pxa2xx_base.c
--- a/drivers/pcmcia/pxa2xx_base.c~pcmcia-fix-platform-driver-hotplug-coldplug
+++ a/drivers/pcmcia/pxa2xx_base.c
@@ -239,6 +239,7 @@ static struct platform_driver pxa2xx_pcm
 	.resume 	= pxa2xx_drv_pcmcia_resume,
 	.driver		= {
 		.name	= "pxa2xx-pcmcia",
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -258,3 +259,4 @@ module_exit(pxa2xx_pcmcia_exit);
 MODULE_AUTHOR("Stefan Eletzhofer <stefan.eletzhofer@inquant.de> and Ian Molton <spyro@f2s.com>");
 MODULE_DESCRIPTION("Linux PCMCIA Card Services: PXA2xx core socket driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pxa2xx-pcmcia");
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

