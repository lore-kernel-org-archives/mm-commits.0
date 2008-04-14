From: akpm@linux-foundation.org
Subject: + scsi-fix-platform-driver-hotplug-coldplug.patch added to -mm tree
Date: Sun, 13 Apr 2008 22:35:43 -0700
Message-ID: <200804140535.m3E5ZhXw023351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752343AbYDNFgX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 01:36:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay.sievers@vrfy.org, James.Bottomley@HansenPartnership.com, dbrownell@users.sourceforge.net


The patch titled
     scsi: fix platform driver hotplug/coldplug
has been added to the -mm tree.  Its filename is
     scsi-fix-platform-driver-hotplug-coldplug.patch

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
Subject: scsi: fix platform driver hotplug/coldplug
=46rom: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias
is prefixed with "platform:". Add MODULE_ALIAS() to the hotpluggable
SCSI platform drivers, to re-enable auto loading.

[dbrownell@users.sourceforge.net: more drivers, registration fixes]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/jazz_esp.c   |    4 ++++
 drivers/scsi/sgiwd93.c    |    2 ++
 drivers/scsi/sni_53c710.c |    2 ++
 drivers/scsi/sun3x_esp.c  |    2 ++
 4 files changed, 10 insertions(+)

diff -puN drivers/scsi/jazz_esp.c~scsi-fix-platform-driver-hotplug-cold=
plug drivers/scsi/jazz_esp.c
--- a/drivers/scsi/jazz_esp.c~scsi-fix-platform-driver-hotplug-coldplug
+++ a/drivers/scsi/jazz_esp.c
@@ -217,11 +217,15 @@ static int __devexit esp_jazz_remove(str
 	return 0;
 }
=20
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:jazz_esp");
+
 static struct platform_driver esp_jazz_driver =3D {
 	.probe		=3D esp_jazz_probe,
 	.remove		=3D __devexit_p(esp_jazz_remove),
 	.driver	=3D {
 		.name	=3D "jazz_esp",
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
diff -puN drivers/scsi/sgiwd93.c~scsi-fix-platform-driver-hotplug-coldp=
lug drivers/scsi/sgiwd93.c
--- a/drivers/scsi/sgiwd93.c~scsi-fix-platform-driver-hotplug-coldplug
+++ a/drivers/scsi/sgiwd93.c
@@ -314,6 +314,7 @@ static struct platform_driver sgiwd93_dr
 	.remove =3D __devexit_p(sgiwd93_remove),
 	.driver =3D {
 		.name   =3D "sgiwd93"
+		.owner	=3D THIS_MODULE,
 	}
 };
=20
@@ -333,3 +334,4 @@ module_exit(sgiwd93_module_exit);
 MODULE_DESCRIPTION("SGI WD33C93 driver");
 MODULE_AUTHOR("Ralf Baechle <ralf@linux-mips.org>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:sgiwd93");
diff -puN drivers/scsi/sni_53c710.c~scsi-fix-platform-driver-hotplug-co=
ldplug drivers/scsi/sni_53c710.c
--- a/drivers/scsi/sni_53c710.c~scsi-fix-platform-driver-hotplug-coldpl=
ug
+++ a/drivers/scsi/sni_53c710.c
@@ -53,6 +53,7 @@
 MODULE_AUTHOR("Thomas Bogend=F6rfer");
 MODULE_DESCRIPTION("SNI RM 53c710 SCSI Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:snirm_53c710");
=20
 #define SNIRM710_CLOCK	32
=20
@@ -136,6 +137,7 @@ static struct platform_driver snirm710_d
 	.remove	=3D __devexit_p(snirm710_driver_remove),
 	.driver	=3D {
 		.name	=3D "snirm_53c710",
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
diff -puN drivers/scsi/sun3x_esp.c~scsi-fix-platform-driver-hotplug-col=
dplug drivers/scsi/sun3x_esp.c
--- a/drivers/scsi/sun3x_esp.c~scsi-fix-platform-driver-hotplug-coldplu=
g
+++ a/drivers/scsi/sun3x_esp.c
@@ -294,6 +294,7 @@ static struct platform_driver esp_sun3x_
 	.remove         =3D __devexit_p(esp_sun3x_remove),
 	.driver =3D {
 		.name   =3D "sun3x_esp",
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
@@ -314,3 +315,4 @@ MODULE_VERSION(DRV_VERSION);
=20
 module_init(sun3x_esp_init);
 module_exit(sun3x_esp_exit);
+MODULE_ALIAS("platform:sun3x_esp");
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

mmc-fix-platform-driver-hotplug-coldplug.patch
leds-fix-platform-driver-hotplug-coldplug.patch
misc-fix-platform-driver-hotplug-coldplug.patch
pcmcia-fix-platform-driver-hotplug-coldplug.patch
serial-fix-platform-driver-hotplug-coldplug.patch
sound-fix-platform-driver-hotplug-coldplug.patch
macintosh-windfarm-fix-platform-driver-hotplug-coldplug.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7.patc=
h
pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7-fix.=
patch
pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type-rev-3.pa=
tch
pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type-rev-3.patch
input-fix-platform-driver-hotplug-coldplug.patch
ata-ide-fix-platform-driver-hotplug-coldplug.patch
mtd-maps-fix-platform-driver-hotplug-coldplug.patch
mtd-nand-fix-platform-driver-hotplug-coldplug.patch
scsi-fix-platform-driver-hotplug-coldplug.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
