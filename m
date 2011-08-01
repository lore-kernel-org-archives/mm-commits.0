From: akpm@linux-foundation.org
Subject: + lis3-change-exported-function-to-use-given.patch added to -mm tree
Date: Mon, 01 Aug 2011 13:29:51 -0700
Message-ID: <201108012029.p71KTp4g012320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753349Ab1HAUaj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2011 16:30:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.piel@tremplin-utc.net, cascardo@holoscopio.com, chunkeey@googlemail.com, ilkka.koskinen@nokia.com, lyall.pearce@hp.com, m-starostik@versanet.de, mjg@redhat.com, witold.pilat@gmail.com


The patch titled
     lis3: change exported function to use passed parameter
has been added to the -mm tree.  Its filename is
     lis3-change-exported-function-to-use-given.patch

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
Subject: lis3: change exported function to use passed parameter
=46rom: =C9ric Piel <eric.piel@tremplin-utc.net>

Change exported functions to use the device given as parameter
instead of the global one.

Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Signed-off-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Witold Pilat <witold.pilat@gmail.com>
Cc: Lyall Pearce <lyall.pearce@hp.com>
Cc: Malte Starostik <m-starostik@versanet.de>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lis3lv02d/lis3lv02d.c     |    6 +++---
 drivers/misc/lis3lv02d/lis3lv02d.h     |    4 ++--
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c |    2 +-
 drivers/misc/lis3lv02d/lis3lv02d_spi.c |    2 +-
 drivers/platform/x86/hp_accel.c        |    4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/misc/lis3lv02d/lis3lv02d.c~lis3-change-exported-funct=
ion-to-use-given drivers/misc/lis3lv02d/lis3lv02d.c
--- a/drivers/misc/lis3lv02d/lis3lv02d.c~lis3-change-exported-function-=
to-use-given
+++ a/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -629,7 +629,7 @@ static struct miscdevice lis3lv02d_misc_
 	.fops    =3D &lis3lv02d_misc_fops,
 };
=20
-int lis3lv02d_joystick_enable(void)
+int lis3lv02d_joystick_enable(struct lis3lv02d *lis3)
 {
 	struct input_dev *input_dev;
 	int err;
@@ -687,7 +687,7 @@ int lis3lv02d_joystick_enable(void)
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_joystick_enable);
=20
-void lis3lv02d_joystick_disable(void)
+void lis3lv02d_joystick_disable(struct lis3lv02d *lis3)
 {
 	if (lis3_dev.irq)
 		free_irq(lis3_dev.irq, &lis3_dev);
@@ -957,7 +957,7 @@ int lis3lv02d_init_device(struct lis3lv0
 		pm_runtime_enable(lis3->pm_dev);
 	}
=20
-	if (lis3lv02d_joystick_enable())
+	if (lis3lv02d_joystick_enable(lis3))
 		pr_err("joystick initialization failed\n");
=20
 	/* passing in platform specific data is purely optional and only
diff -puN drivers/misc/lis3lv02d/lis3lv02d.h~lis3-change-exported-funct=
ion-to-use-given drivers/misc/lis3lv02d/lis3lv02d.h
--- a/drivers/misc/lis3lv02d/lis3lv02d.h~lis3-change-exported-function-=
to-use-given
+++ a/drivers/misc/lis3lv02d/lis3lv02d.h
@@ -282,8 +282,8 @@ struct lis3lv02d {
 };
=20
 int lis3lv02d_init_device(struct lis3lv02d *lis3);
-int lis3lv02d_joystick_enable(void);
-void lis3lv02d_joystick_disable(void);
+int lis3lv02d_joystick_enable(struct lis3lv02d *lis3);
+void lis3lv02d_joystick_disable(struct lis3lv02d *lis3);
 void lis3lv02d_poweroff(struct lis3lv02d *lis3);
 int lis3lv02d_poweron(struct lis3lv02d *lis3);
 int lis3lv02d_remove_fs(struct lis3lv02d *lis3);
diff -puN drivers/misc/lis3lv02d/lis3lv02d_i2c.c~lis3-change-exported-f=
unction-to-use-given drivers/misc/lis3lv02d/lis3lv02d_i2c.c
--- a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c~lis3-change-exported-funct=
ion-to-use-given
+++ a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
@@ -182,7 +182,7 @@ static int __devexit lis3lv02d_i2c_remov
 	if (pdata && pdata->release_resources)
 		pdata->release_resources();
=20
-	lis3lv02d_joystick_disable();
+	lis3lv02d_joystick_disable(lis3);
 	lis3lv02d_remove_fs(&lis3_dev);
=20
 	if (lis3_dev.reg_ctrl)
diff -puN drivers/misc/lis3lv02d/lis3lv02d_spi.c~lis3-change-exported-f=
unction-to-use-given drivers/misc/lis3lv02d/lis3lv02d_spi.c
--- a/drivers/misc/lis3lv02d/lis3lv02d_spi.c~lis3-change-exported-funct=
ion-to-use-given
+++ a/drivers/misc/lis3lv02d/lis3lv02d_spi.c
@@ -83,7 +83,7 @@ static int __devinit lis302dl_spi_probe(
 static int __devexit lis302dl_spi_remove(struct spi_device *spi)
 {
 	struct lis3lv02d *lis3 =3D spi_get_drvdata(spi);
-	lis3lv02d_joystick_disable();
+	lis3lv02d_joystick_disable(lis3);
 	lis3lv02d_poweroff(lis3);
=20
 	return lis3lv02d_remove_fs(&lis3_dev);
diff -puN drivers/platform/x86/hp_accel.c~lis3-change-exported-function=
-to-use-given drivers/platform/x86/hp_accel.c
--- a/drivers/platform/x86/hp_accel.c~lis3-change-exported-function-to-=
use-given
+++ a/drivers/platform/x86/hp_accel.c
@@ -323,7 +323,7 @@ static int lis3lv02d_add(struct acpi_dev
 	INIT_WORK(&hpled_led.work, delayed_set_status_worker);
 	ret =3D led_classdev_register(NULL, &hpled_led.led_classdev);
 	if (ret) {
-		lis3lv02d_joystick_disable();
+		lis3lv02d_joystick_disable(&lis3_dev);
 		lis3lv02d_poweroff(&lis3_dev);
 		flush_work(&hpled_led.work);
 		return ret;
@@ -337,7 +337,7 @@ static int lis3lv02d_remove(struct acpi_
 	if (!device)
 		return -EINVAL;
=20
-	lis3lv02d_joystick_disable();
+	lis3lv02d_joystick_disable(&lis3_dev);
 	lis3lv02d_poweroff(&lis3_dev);
=20
 	led_classdev_unregister(&hpled_led.led_classdev);
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net=
 are

lis3lv02d-avoid-divide-by-zero-due-to-unchecked.patch
lis3-update-maintainer-information.patch
lis3-add-support-for-hp-elitebook-2730p.patch
lis3-add-support-for-hp-elitebook-8540w.patch
hp_accel-add-hp-probook-655x.patch
config_hp_accel-fix-help-text.patch
lis3-free-regulators-if-probe-fails.patch
lis3-change-naming-to-consistent.patch
lis3-change-exported-function-to-use-given.patch
lis3-remove-the-references-to-the-global-variable-in-core-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
