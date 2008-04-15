From: akpm@linux-foundation.org
Subject: - sound-fix-platform-driver-hotplug-coldplug.patch removed from -mm tree
Date: Tue, 15 Apr 2008 02:10:31 -0700
Message-ID: <200804150910.m3F9AV7x020636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756043AbYDOJLU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 05:11:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay.sievers@vrfy.org, dbrownell@users.sourceforge.net, perex@perex.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     sound: fix platform driver hotplug/coldplug
has been removed from the -mm tree.  Its filename was
     sound-fix-platform-driver-hotplug-coldplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sound: fix platform driver hotplug/coldplug
From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias is
prefixed with "platform:".  Add MODULE_ALIAS() to the hotpluggable sound
platform drivers, to re-enable auto loading.

[dbrownell@users.sourceforge.net: more drivers, registration fixes]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/arm/pxa2xx-ac97.c      |    2 ++
 sound/drivers/ml403-ac97cr.c |    4 ++++
 sound/soc/soc-core.c         |    2 ++
 3 files changed, 8 insertions(+)

diff -puN sound/arm/pxa2xx-ac97.c~sound-fix-platform-driver-hotplug-coldplug sound/arm/pxa2xx-ac97.c
--- a/sound/arm/pxa2xx-ac97.c~sound-fix-platform-driver-hotplug-coldplug
+++ a/sound/arm/pxa2xx-ac97.c
@@ -391,6 +391,7 @@ static struct platform_driver pxa2xx_ac9
 	.resume		= pxa2xx_ac97_resume,
 	.driver		= {
 		.name	= "pxa2xx-ac97",
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -410,3 +411,4 @@ module_exit(pxa2xx_ac97_exit);
 MODULE_AUTHOR("Nicolas Pitre");
 MODULE_DESCRIPTION("AC97 driver for the Intel PXA2xx chip");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pxa2xx-ac97");
diff -puN sound/drivers/ml403-ac97cr.c~sound-fix-platform-driver-hotplug-coldplug sound/drivers/ml403-ac97cr.c
--- a/sound/drivers/ml403-ac97cr.c~sound-fix-platform-driver-hotplug-coldplug
+++ a/sound/drivers/ml403-ac97cr.c
@@ -1328,11 +1328,15 @@ static int snd_ml403_ac97cr_remove(struc
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:" SND_ML403_AC97CR_DRIVER);
+
 static struct platform_driver snd_ml403_ac97cr_driver = {
 	.probe = snd_ml403_ac97cr_probe,
 	.remove = snd_ml403_ac97cr_remove,
 	.driver = {
 		.name = SND_ML403_AC97CR_DRIVER,
+		.owner = THIS_MODULE,
 	},
 };
 
diff -puN sound/soc/soc-core.c~sound-fix-platform-driver-hotplug-coldplug sound/soc/soc-core.c
--- a/sound/soc/soc-core.c~sound-fix-platform-driver-hotplug-coldplug
+++ a/sound/soc/soc-core.c
@@ -839,6 +839,7 @@ static int soc_remove(struct platform_de
 static struct platform_driver soc_driver = {
 	.driver		= {
 		.name		= "soc-audio",
+		.owner		= THIS_MODULE,
 	},
 	.probe		= soc_probe,
 	.remove		= soc_remove,
@@ -1601,3 +1602,4 @@ module_exit(snd_soc_exit);
 MODULE_AUTHOR("Liam Girdwood, liam.girdwood@wolfsonmicro.com, www.wolfsonmicro.com");
 MODULE_DESCRIPTION("ALSA SoC Core");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:soc-audio");
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

mmc-fix-platform-driver-hotplug-coldplug.patch
leds-fix-platform-driver-hotplug-coldplug.patch
misc-fix-platform-driver-hotplug-coldplug.patch
pcmcia-fix-platform-driver-hotplug-coldplug.patch
serial-fix-platform-driver-hotplug-coldplug.patch
git-alsa-tiwai.patch
macintosh-windfarm-fix-platform-driver-hotplug-coldplug.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks.patch
pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type.patch
pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type.patch
sysfs-add-sys-dev-charblock-to-lookup-sysfs-path-by-major-minor.patch
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

