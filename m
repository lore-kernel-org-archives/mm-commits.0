From: akpm@linux-foundation.org
Subject: [merged] arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:39:23 -0800
Message-ID: <20121219203924.1E977200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f201.google.com ([209.85.215.201]:48357 "EHLO
	mail-ea0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab2LSUj0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:39:26 -0500
Received: by mail-ea0-f201.google.com with SMTP id b14so134029eaa.2
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:39:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Sebastien.Hinderer@ens-lyon.org, lenb@kernel.org, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/platform/iris/iris.c: register a platform device=
 and a platform driver
has been removed from the -mm tree.  Its filename was
     arch-x86-platform-iris-irisc-register-a-platform-device-and-a-plat=
form-driver.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Sh=E9rab <Sebastien.Hinderer@ens-lyon.org>
Subject: arch/x86/platform/iris/iris.c: register a platform device and =
a platform driver

This makes the iris driver use the platform API, so it is properly expo=
sed
in /sys.

[akpm@linux-foundation.org: remove commented-out code, add missing spac=
e to printk, clean up code layout]
Signed-off-by: Sh=E9rab <Sebastien.Hinderer@ens-lyon.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/iris/iris.c |   67 +++++++++++++++++++++++++++-----
 1 file changed, 57 insertions(+), 10 deletions(-)

diff -puN arch/x86/platform/iris/iris.c~arch-x86-platform-iris-irisc-re=
gister-a-platform-device-and-a-platform-driver arch/x86/platform/iris/i=
ris.c
--- a/arch/x86/platform/iris/iris.c~arch-x86-platform-iris-irisc-regist=
er-a-platform-device-and-a-platform-driver
+++ a/arch/x86/platform/iris/iris.c
@@ -23,6 +23,7 @@
=20
 #include <linux/moduleparam.h>
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
@@ -62,29 +63,75 @@ static void iris_power_off(void)
  * by reading its input port and seeing whether the read value is
  * meaningful.
  */
-static int iris_init(void)
+static int iris_probe(struct platform_device *pdev)
 {
-	unsigned char status;
-	if (force !=3D 1) {
-		printk(KERN_ERR "The force parameter has not been set to 1 so the Ir=
is poweroff handler will not be installed.\n");
-		return -ENODEV;
-	}
-	status =3D inb(IRIS_GIO_INPUT);
+	unsigned char status =3D inb(IRIS_GIO_INPUT);
 	if (status =3D=3D IRIS_GIO_NODEV) {
-		printk(KERN_ERR "This machine does not seem to be an Iris. Power_off=
 handler not installed.\n");
+		printk(KERN_ERR "This machine does not seem to be an Iris. "
+			"Power off handler not installed.\n");
 		return -ENODEV;
 	}
 	old_pm_power_off =3D pm_power_off;
 	pm_power_off =3D &iris_power_off;
 	printk(KERN_INFO "Iris power_off handler installed.\n");
-
 	return 0;
 }
=20
-static void iris_exit(void)
+static int iris_remove(struct platform_device *pdev)
 {
 	pm_power_off =3D old_pm_power_off;
 	printk(KERN_INFO "Iris power_off handler uninstalled.\n");
+	return 0;
+}
+
+static struct platform_driver iris_driver =3D {
+	.driver		=3D {
+		.name   =3D "iris",
+		.owner  =3D THIS_MODULE,
+	},
+	.probe          =3D iris_probe,
+	.remove         =3D iris_remove,
+};
+
+static struct resource iris_resources[] =3D {
+	{
+		.start  =3D IRIS_GIO_BASE,
+		.end    =3D IRIS_GIO_OUTPUT,
+		.flags  =3D IORESOURCE_IO,
+		.name   =3D "address"
+	}
+};
+
+static struct platform_device *iris_device;
+
+static int iris_init(void)
+{
+	int ret;
+	if (force !=3D 1) {
+		printk(KERN_ERR "The force parameter has not been set to 1."
+			" The Iris poweroff handler will not be installed.\n");
+		return -ENODEV;
+	}
+	ret =3D platform_driver_register(&iris_driver);
+	if (ret < 0) {
+		printk(KERN_ERR "Failed to register iris platform driver: %d\n",
+			ret);
+		return ret;
+	}
+	iris_device =3D platform_device_register_simple("iris", (-1),
+				iris_resources, ARRAY_SIZE(iris_resources));
+	if (IS_ERR(iris_device)) {
+		printk(KERN_ERR "Failed to register iris platform device\n");
+		platform_driver_unregister(&iris_driver);
+		return PTR_ERR(iris_device);
+	}
+	return 0;
+}
+
+static void iris_exit(void)
+{
+	platform_device_unregister(iris_device);
+	platform_driver_unregister(&iris_driver);
 }
=20
 module_init(iris_init);
_

Patches currently in -mm which might be from Sebastien.Hinderer@ens-lyo=
n.org are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
