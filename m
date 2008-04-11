From: akpm@linux-foundation.org
Subject: + mmc-fix-platform-driver-hotplug-coldplug.patch added to -mm tree
Date: Thu, 10 Apr 2008 21:49:25 -0700
Message-ID: <200804110449.m3B4nPD8001141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755096AbYDKEtk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Apr 2008 00:49:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay.sievers@vrfy.org, dbrownell@users.sourceforge.net, drzeus@drzeus.cx


The patch titled
     mmc: fix platform driver hotplug/coldplug
has been added to the -mm tree.  Its filename is
     mmc-fix-platform-driver-hotplug-coldplug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mmc: fix platform driver hotplug/coldplug
=46rom: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias i=
s
prefixed with "platform:".  Add MODULE_ALIAS() to the hotpluggable MMC =
host
platform drivers, to re-enable auto loading.

Also, add missing owner declarations in driver init.

[dbrownell@users.sourceforge.net: registration fixes]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/at91_mci.c |    1 +
 drivers/mmc/host/au1xmmc.c  |    2 ++
 drivers/mmc/host/imxmmc.c   |    2 ++
 drivers/mmc/host/omap.c     |    3 ++-
 drivers/mmc/host/pxamci.c   |    2 ++
 drivers/mmc/host/wbsd.c     |    1 +
 6 files changed, 10 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/at91_mci.c~mmc-fix-platform-driver-hotplug-c=
oldplug drivers/mmc/host/at91_mci.c
--- a/drivers/mmc/host/at91_mci.c~mmc-fix-platform-driver-hotplug-coldp=
lug
+++ a/drivers/mmc/host/at91_mci.c
@@ -1075,3 +1075,4 @@ module_exit(at91_mci_exit);
 MODULE_DESCRIPTION("AT91 Multimedia Card Interface driver");
 MODULE_AUTHOR("Nick Randell");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:at91_mci");
diff -puN drivers/mmc/host/au1xmmc.c~mmc-fix-platform-driver-hotplug-co=
ldplug drivers/mmc/host/au1xmmc.c
--- a/drivers/mmc/host/au1xmmc.c~mmc-fix-platform-driver-hotplug-coldpl=
ug
+++ a/drivers/mmc/host/au1xmmc.c
@@ -998,6 +998,7 @@ static struct platform_driver au1xmmc_dr
 	.resume        =3D NULL,
 	.driver        =3D {
 		.name  =3D DRIVER_NAME,
+		.owner =3D THIS_MODULE,
 	},
 };
=20
@@ -1018,5 +1019,6 @@ module_exit(au1xmmc_exit);
 MODULE_AUTHOR("Advanced Micro Devices, Inc");
 MODULE_DESCRIPTION("MMC/SD driver for the Alchemy Au1XXX");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:au1xxx-mmc");
 #endif
=20
diff -puN drivers/mmc/host/imxmmc.c~mmc-fix-platform-driver-hotplug-col=
dplug drivers/mmc/host/imxmmc.c
--- a/drivers/mmc/host/imxmmc.c~mmc-fix-platform-driver-hotplug-coldplu=
g
+++ a/drivers/mmc/host/imxmmc.c
@@ -1128,6 +1128,7 @@ static struct platform_driver imxmci_dri
 	.resume		=3D imxmci_resume,
 	.driver		=3D {
 		.name		=3D DRIVER_NAME,
+		.owner		=3D THIS_MODULE,
 	}
 };
=20
@@ -1147,3 +1148,4 @@ module_exit(imxmci_exit);
 MODULE_DESCRIPTION("i.MX Multimedia Card Interface Driver");
 MODULE_AUTHOR("Sascha Hauer, Pengutronix");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:imx-mmc");
diff -puN drivers/mmc/host/omap.c~mmc-fix-platform-driver-hotplug-coldp=
lug drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/mmc/host/omap.c
@@ -1255,6 +1255,7 @@ static struct platform_driver mmc_omap_d
 	.resume		=3D mmc_omap_resume,
 	.driver		=3D {
 		.name	=3D DRIVER_NAME,
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
@@ -1273,5 +1274,5 @@ module_exit(mmc_omap_exit);
=20
 MODULE_DESCRIPTION("OMAP Multimedia Card driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS(DRIVER_NAME);
+MODULE_ALIAS("platform:" DRIVER_NAME);
 MODULE_AUTHOR("Juha Yrj=F6l=E4");
diff -puN drivers/mmc/host/pxamci.c~mmc-fix-platform-driver-hotplug-col=
dplug drivers/mmc/host/pxamci.c
--- a/drivers/mmc/host/pxamci.c~mmc-fix-platform-driver-hotplug-coldplu=
g
+++ a/drivers/mmc/host/pxamci.c
@@ -693,6 +693,7 @@ static struct platform_driver pxamci_dri
 	.resume		=3D pxamci_resume,
 	.driver		=3D {
 		.name	=3D DRIVER_NAME,
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
@@ -711,3 +712,4 @@ module_exit(pxamci_exit);
=20
 MODULE_DESCRIPTION("PXA Multimedia Card Interface Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pxa2xx-mci");
diff -puN drivers/mmc/host/wbsd.c~mmc-fix-platform-driver-hotplug-coldp=
lug drivers/mmc/host/wbsd.c
--- a/drivers/mmc/host/wbsd.c~mmc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/mmc/host/wbsd.c
@@ -1948,6 +1948,7 @@ static struct platform_driver wbsd_drive
 	.resume		=3D wbsd_platform_resume,
 	.driver		=3D {
 		.name	=3D DRIVER_NAME,
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

spi-fix-platform-driver-hotplug-coldplug.patch
usb-gadget-fix-platform-driver-hotplug-coldplug.patch
usb-host-fix-platform-driver-hotplug-coldplug.patch
watchdog-fix-platform-driver-hotplug-coldplug.patch
rtc-fix-platform-driver-hotplug-coldplug.patch
pm-remove-destroy_suspended_device.patch
sysfs-refill-attribute-buffer-when-reading-from-offset-0.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7.patc=
h
pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7-fix.=
patch
pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type-rev-3.pa=
tch
pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type-rev-3.patch
i2c-fix-platform-driver-hotplug-coldplug.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch
mmc-fix-platform-driver-hotplug-coldplug.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
