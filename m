From: akpm@linux-foundation.org
Subject: + arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch added to -mm tree
Date: Tue, 05 Jul 2011 13:42:50 -0700
Message-ID: <201107052042.p65KgouX022802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542Ab1GEUnL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2011 16:43:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Sebastien.Hinderer@ens-lyon.org, lenb@kernel.org, mjg@redhat.com


The patch titled
     arch/x86/platform/iris/iris.c: register a platform device and a pl=
atform driver
has been added to the -mm tree.  Its filename is
     arch-x86-platform-iris-irisc-register-a-platform-device-and-a-plat=
form-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: arch/x86/platform/iris/iris.c: register a platform device and =
a platform driver
=46rom: Sh=E9rab <Sebastien.Hinderer@ens-lyon.org>

This makes the iris driver use the platform API, so it is properly expo=
sed
in /sys.

Signed-off-by: Sh=E9rab <Sebastien.Hinderer@ens-lyon.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/iris/iris.c |   69 +++++++++++++++++++++++++++-----
 1 file changed, 59 insertions(+), 10 deletions(-)

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
@@ -62,29 +63,77 @@ static void iris_power_off(void)
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
+/*
+	unsigned char status =3D inb(IRIS_GIO_INPUT);
 	if (status =3D=3D IRIS_GIO_NODEV) {
-		printk(KERN_ERR "This machine does not seem to be an Iris. Power_off=
 handler not installed.\n");
+		printk(KERN_ERR "This machine does not seem to be an Iris. "
+			"Power off handler not installed.\n");
 		return -ENODEV;
 	}
+*/
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
+			"The Iris poweroff handler will not be installed.\n");
+		return -ENODEV;
+	}
+	ret =3D platform_driver_register(&iris_driver);
+	if (ret < 0) {
+		printk(KERN_ERR "Failed to register iris platform driver: "
+			"%d\n", ret);
+		return ret;
+	}
+	iris_device =3D platform_device_register_simple(
+		"iris", (-1), iris_resources, ARRAY_SIZE(iris_resources));
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

arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-=
driver.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-=
driver-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
