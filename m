From: akpm@linux-foundation.org
Subject: - scsi-fix-platform-driver-hotplug-coldplug.patch removed from -mm tree
Date: Mon, 28 Apr 2008 02:55:19 -0700
Message-ID: <200804280955.m3S9tJGH020820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765310AbYD1J4R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 05:56:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay.sievers@vrfy.org, James.Bottomley@HansenPartnership.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     scsi: fix platform driver hotplug/coldplug
has been removed from the -mm tree.  Its filename was
     scsi-fix-platform-driver-hotplug-coldplug.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: scsi: fix platform driver hotplug/coldplug
=46rom: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias
is prefixed with "platform:". Add MODULE_ALIAS() to the hotpluggable
SCSI platform drivers, to re-enable auto loading.

[dbrownell@users.sourceforge.net: more drivers, registration fixes]
[akpm@linux-foundation.org: fix sgiwd93.c]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/jazz_esp.c   |    4 ++++
 drivers/scsi/sgiwd93.c    |    4 +++-
 drivers/scsi/sni_53c710.c |    2 ++
 drivers/scsi/sun3x_esp.c  |    2 ++
 4 files changed, 11 insertions(+), 1 deletion(-)

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
@@ -313,7 +313,8 @@ static struct platform_driver sgiwd93_dr
 	.probe  =3D sgiwd93_probe,
 	.remove =3D __devexit_p(sgiwd93_remove),
 	.driver =3D {
-		.name   =3D "sgiwd93"
+		.name   =3D "sgiwd93",
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

origin.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=3Dy.p=
atch
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
