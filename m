From: akpm@linux-foundation.org
Subject: + hp_accel-do-not-call-acpi-from-invalid-context.patch added to -mm tree
Date: Tue, 13 Jan 2009 14:17:56 -0800
Message-ID: <200901132217.n0DMHuf4022418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755436AbZAMWSh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 17:18:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz, eric.piel@tremplin-utc.net, lenb@kernel.org


The patch titled
     hp_accel: do not call ACPI from invalid context
has been added to the -mm tree.  Its filename is
     hp_accel-do-not-call-acpi-from-invalid-context.patch

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
Subject: hp_accel: do not call ACPI from invalid context
=46rom: Pavel Machek <pavel@suse.cz>

The LED on HP notebooks is connected through ACPI.  That unfortunately
means that it needs to be delayed by using schedule_work() to avoid
calling the ACPI interpreter from an invalid context.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c |   71 +++++++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 19 deletions(-)

diff -puN drivers/hwmon/hp_accel.c~hp_accel-do-not-call-acpi-from-inval=
id-context drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~hp_accel-do-not-call-acpi-from-invalid-c=
ontext
+++ a/drivers/hwmon/hp_accel.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 2007-2008 Yan Burman
  *  Copyright (C) 2008 Eric Piel
- *  Copyright (C) 2008 Pavel Machek
+ *  Copyright (C) 2008-2009 Pavel Machek
  *
  *  This program is free software; you can redistribute it and/or modi=
fy
  *  it under the terms of the GNU General Public License as published =
by
@@ -44,6 +44,36 @@
 #define DRIVER_NAME     "lis3lv02d"
 #define ACPI_MDPS_CLASS "accelerometer"
=20
+/* Delayed LEDs infrastructure ------------------------------------ */
+
+/* Special LED class that can defer work */
+struct delayed_led_classdev {
+	struct led_classdev led_classdev;
+	struct work_struct work;
+	enum led_brightness new_brightness;
+
+	unsigned int led;		/* For driver */
+	void (*set_brightness)(struct delayed_led_classdev *data, enum led_br=
ightness value);
+};
+
+static inline void delayed_set_status_worker(struct work_struct *work)
+{
+	struct delayed_led_classdev *data =3D
+			container_of(work, struct delayed_led_classdev, work);
+
+	data->set_brightness(data, data->new_brightness);
+}
+
+static inline void delayed_sysfs_set(struct led_classdev *led_cdev,
+			      enum led_brightness brightness)
+{
+	struct delayed_led_classdev *data =3D container_of(led_cdev,
+			     struct delayed_led_classdev, led_classdev);
+	data->new_brightness =3D brightness;
+	schedule_work(&data->work);
+}
+
+/* HP-specific accelerometer driver ----------------------------------=
-- */
=20
 /* For automatic insertion of the module */
 static struct acpi_device_id lis3lv02d_device_ids[] =3D {
@@ -155,28 +185,27 @@ static struct dmi_system_id lis3lv02d_dm
  */
 };
=20
-static acpi_status hpled_acpi_write(acpi_handle handle, int reg)
+static void hpled_set(struct delayed_led_classdev *led_cdev, enum led_=
brightness value)
 {
+	acpi_handle handle =3D adev.device->handle;
 	unsigned long long ret; /* Not used when writing */
 	union acpi_object in_obj[1];
 	struct acpi_object_list args =3D { 1, in_obj };
=20
 	in_obj[0].type          =3D ACPI_TYPE_INTEGER;
-	in_obj[0].integer.value =3D reg;
+	in_obj[0].integer.value =3D !!value;
=20
-	return acpi_evaluate_integer(handle, "ALED", &args, &ret);
+	acpi_evaluate_integer(handle, "ALED", &args, &ret);
 }
=20
-static void hpled_set(struct led_classdev *led_cdev,
-			       enum led_brightness value)
-{
-	hpled_acpi_write(adev.device->handle, !!value);
-}
-
-static struct led_classdev hpled_led =3D {
-	.name			=3D "hp:red:hddprotection",
-	.default_trigger	=3D "none",
-	.brightness_set		=3D hpled_set,
+static struct delayed_led_classdev hpled_led =3D {
+	.led_classdev =3D {
+		.name			=3D "hp::hddprotect",
+		.default_trigger	=3D "none",
+		.brightness_set		=3D delayed_sysfs_set,
+		.flags                  =3D LED_CORE_SUSPENDRESUME,
+	},
+	.set_brightness =3D hpled_set,
 };
=20
 static int lis3lv02d_add(struct acpi_device *device)
@@ -208,13 +237,17 @@ static int lis3lv02d_add(struct acpi_dev
 		adev.ac =3D lis3lv02d_axis_normal;
 	}
=20
-	ret =3D led_classdev_register(NULL, &hpled_led);
+	INIT_WORK(&hpled_led.work, delayed_set_status_worker);
+	ret =3D led_classdev_register(NULL, &hpled_led.led_classdev);
 	if (ret)
 		return ret;
=20
 	ret =3D lis3lv02d_init_device(&adev);
 	if (ret) {
-		led_classdev_unregister(&hpled_led);
+		while (work_pending(&hpled_led.work))
+			schedule();
+
+		led_classdev_unregister(&hpled_led.led_classdev);
 		return ret;
 	}
=20
@@ -229,7 +262,9 @@ static int lis3lv02d_remove(struct acpi_
 	lis3lv02d_joystick_disable();
 	lis3lv02d_poweroff(device->handle);
=20
-	led_classdev_unregister(&hpled_led);
+	while (work_pending(&hpled_led.work))
+		schedule();
+	led_classdev_unregister(&hpled_led.led_classdev);
=20
 	return lis3lv02d_remove_fs();
 }
@@ -240,7 +275,6 @@ static int lis3lv02d_suspend(struct acpi
 {
 	/* make sure the device is off when we suspend */
 	lis3lv02d_poweroff(device->handle);
-	led_classdev_suspend(&hpled_led);
 	return 0;
 }
=20
@@ -253,7 +287,6 @@ static int lis3lv02d_resume(struct acpi_
 	else
 		lis3lv02d_poweroff(device->handle);
 	mutex_unlock(&adev.lock);
-	led_classdev_resume(&hpled_led);
 	return 0;
 }
 #else
_

Patches currently in -mm which might be from pavel@suse.cz are

lis3lv02d-merge-with-leds-hp-disk.patch
maintainers-add-entry-for-freezer.patch
hp_accel-do-not-call-acpi-from-invalid-context.patch
linux-next.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.p=
atch
nbd-trivial-cleanups.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
