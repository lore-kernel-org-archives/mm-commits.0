From: akpm@linux-foundation.org
Subject: - input-fix-platform-driver-hotplug-coldplug.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:40:43 -0700
Message-ID: <200804261640.m3QGehgY031057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756353AbYDZQl7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:41:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay.sievers@vrfy.org, dbrownell@users.sourceforge.net, dtor@mail.ru, jikos@jikos.cz, mm-commits@vger.kernel.org


The patch titled
     input: fix platform driver hotplug/coldplug
has been removed from the -mm tree.  Its filename was
     input-fix-platform-driver-hotplug-coldplug.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: input: fix platform driver hotplug/coldplug
=46rom: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias i=
s
prefixed with "platform:".  Add MODULE_ALIAS() to the hotpluggable "inp=
ut"
platform drivers, to re-enable auto loading.

[dbrownell@users.sourceforge.net: more drivers, registration fixes]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jikos@jikos.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/aaed2000_kbd.c     |    4 ++++
 drivers/input/keyboard/bf54x-keys.c       |    2 ++
 drivers/input/keyboard/corgikbd.c         |    2 ++
 drivers/input/keyboard/gpio_keys.c        |    2 ++
 drivers/input/keyboard/jornada680_kbd.c   |    2 ++
 drivers/input/keyboard/jornada720_kbd.c   |    4 ++++
 drivers/input/keyboard/omap-keypad.c      |    2 ++
 drivers/input/keyboard/pxa27x_keypad.c    |    4 ++++
 drivers/input/keyboard/spitzkbd.c         |    1 +
 drivers/input/keyboard/tosakbd.c          |    2 ++
 drivers/input/misc/cobalt_btns.c          |    3 +++
 drivers/input/mouse/gpio_mouse.c          |    4 ++++
 drivers/input/serio/rpckbd.c              |    2 ++
 drivers/input/touchscreen/corgi_ts.c      |    2 ++
 drivers/input/touchscreen/jornada720_ts.c |    4 ++++
 15 files changed, 40 insertions(+)

diff -puN drivers/input/keyboard/aaed2000_kbd.c~input-fix-platform-driv=
er-hotplug-coldplug drivers/input/keyboard/aaed2000_kbd.c
--- a/drivers/input/keyboard/aaed2000_kbd.c~input-fix-platform-driver-h=
otplug-coldplug
+++ a/drivers/input/keyboard/aaed2000_kbd.c
@@ -156,11 +156,15 @@ static int __devexit aaedkbd_remove(stru
 	return 0;
 }
=20
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:aaed2000-keyboard");
+
 static struct platform_driver aaedkbd_driver =3D {
 	.probe		=3D aaedkbd_probe,
 	.remove		=3D __devexit_p(aaedkbd_remove),
 	.driver		=3D {
 		.name	=3D "aaed2000-keyboard",
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
diff -puN drivers/input/keyboard/bf54x-keys.c~input-fix-platform-driver=
-hotplug-coldplug drivers/input/keyboard/bf54x-keys.c
--- a/drivers/input/keyboard/bf54x-keys.c~input-fix-platform-driver-hot=
plug-coldplug
+++ a/drivers/input/keyboard/bf54x-keys.c
@@ -359,6 +359,7 @@ struct platform_driver bfin_kpad_device_
 	.remove		=3D __devexit_p(bfin_kpad_remove),
 	.driver		=3D {
 		.name	=3D DRV_NAME,
+		.owner	=3D THIS_MODULE,
 	}
 };
=20
@@ -378,3 +379,4 @@ module_exit(bfin_kpad_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("Keypad driver for BF54x Processors");
+MODULE_ALIAS("platform:bf54x-keys");
diff -puN drivers/input/keyboard/corgikbd.c~input-fix-platform-driver-h=
otplug-coldplug drivers/input/keyboard/corgikbd.c
--- a/drivers/input/keyboard/corgikbd.c~input-fix-platform-driver-hotpl=
ug-coldplug
+++ a/drivers/input/keyboard/corgikbd.c
@@ -393,6 +393,7 @@ static struct platform_driver corgikbd_d
 	.resume		=3D corgikbd_resume,
 	.driver		=3D {
 		.name	=3D "corgi-keyboard",
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
@@ -412,3 +413,4 @@ module_exit(corgikbd_exit);
 MODULE_AUTHOR("Richard Purdie <rpurdie@rpsys.net>");
 MODULE_DESCRIPTION("Corgi Keyboard Driver");
 MODULE_LICENSE("GPLv2");
+MODULE_ALIAS("platform:corgi-keyboard");
diff -puN drivers/input/keyboard/gpio_keys.c~input-fix-platform-driver-=
hotplug-coldplug drivers/input/keyboard/gpio_keys.c
--- a/drivers/input/keyboard/gpio_keys.c~input-fix-platform-driver-hotp=
lug-coldplug
+++ a/drivers/input/keyboard/gpio_keys.c
@@ -214,6 +214,7 @@ struct platform_driver gpio_keys_device_
 	.resume		=3D gpio_keys_resume,
 	.driver		=3D {
 		.name	=3D "gpio-keys",
+		.owner	=3D THIS_MODULE,
 	}
 };
=20
@@ -233,3 +234,4 @@ module_exit(gpio_keys_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Phil Blundell <pb@handhelds.org>");
 MODULE_DESCRIPTION("Keyboard driver for CPU GPIOs");
+MODULE_ALIAS("platform:gpio-keys");
diff -puN drivers/input/keyboard/jornada680_kbd.c~input-fix-platform-dr=
iver-hotplug-coldplug drivers/input/keyboard/jornada680_kbd.c
--- a/drivers/input/keyboard/jornada680_kbd.c~input-fix-platform-driver=
-hotplug-coldplug
+++ a/drivers/input/keyboard/jornada680_kbd.c
@@ -254,6 +254,7 @@ static int __devexit jornada680kbd_remov
 static struct platform_driver jornada680kbd_driver =3D {
 	.driver	=3D {
 		.name	=3D "jornada680_kbd",
+		.owner	=3D THIS_MODULE,
 	},
 	.probe	=3D jornada680kbd_probe,
 	.remove	=3D __devexit_p(jornada680kbd_remove),
@@ -275,3 +276,4 @@ module_exit(jornada680kbd_exit);
 MODULE_AUTHOR("Kristoffer Ericson <kristoffer.ericson@gmail.com>");
 MODULE_DESCRIPTION("HP Jornada 620/660/680/690 Keyboard Driver");
 MODULE_LICENSE("GPLv2");
+MODULE_ALIAS("platform:jornada680_kbd");
diff -puN drivers/input/keyboard/jornada720_kbd.c~input-fix-platform-dr=
iver-hotplug-coldplug drivers/input/keyboard/jornada720_kbd.c
--- a/drivers/input/keyboard/jornada720_kbd.c~input-fix-platform-driver=
-hotplug-coldplug
+++ a/drivers/input/keyboard/jornada720_kbd.c
@@ -162,9 +162,13 @@ static int __devexit jornada720_kbd_remo
 	return 0;
 }
=20
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:jornada720_kbd");
+
 static struct platform_driver jornada720_kbd_driver =3D {
 	.driver  =3D {
 		.name    =3D "jornada720_kbd",
+		.owner	=3D THIS_MODULE,
 	 },
 	.probe   =3D jornada720_kbd_probe,
 	.remove  =3D __devexit_p(jornada720_kbd_remove),
diff -puN drivers/input/keyboard/omap-keypad.c~input-fix-platform-drive=
r-hotplug-coldplug drivers/input/keyboard/omap-keypad.c
--- a/drivers/input/keyboard/omap-keypad.c~input-fix-platform-driver-ho=
tplug-coldplug
+++ a/drivers/input/keyboard/omap-keypad.c
@@ -467,6 +467,7 @@ static struct platform_driver omap_kp_dr
 	.resume		=3D omap_kp_resume,
 	.driver		=3D {
 		.name	=3D "omap-keypad",
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
@@ -487,3 +488,4 @@ module_exit(omap_kp_exit);
 MODULE_AUTHOR("Timo Ter=C3=A4s");
 MODULE_DESCRIPTION("OMAP Keypad Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:omap-keypad");
diff -puN drivers/input/keyboard/pxa27x_keypad.c~input-fix-platform-dri=
ver-hotplug-coldplug drivers/input/keyboard/pxa27x_keypad.c
--- a/drivers/input/keyboard/pxa27x_keypad.c~input-fix-platform-driver-=
hotplug-coldplug
+++ a/drivers/input/keyboard/pxa27x_keypad.c
@@ -545,6 +545,9 @@ static int __devexit pxa27x_keypad_remov
 	return 0;
 }
=20
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:pxa27x-keypad");
+
 static struct platform_driver pxa27x_keypad_driver =3D {
 	.probe		=3D pxa27x_keypad_probe,
 	.remove		=3D __devexit_p(pxa27x_keypad_remove),
@@ -552,6 +555,7 @@ static struct platform_driver pxa27x_key
 	.resume		=3D pxa27x_keypad_resume,
 	.driver		=3D {
 		.name	=3D "pxa27x-keypad",
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
diff -puN drivers/input/keyboard/spitzkbd.c~input-fix-platform-driver-h=
otplug-coldplug drivers/input/keyboard/spitzkbd.c
--- a/drivers/input/keyboard/spitzkbd.c~input-fix-platform-driver-hotpl=
ug-coldplug
+++ a/drivers/input/keyboard/spitzkbd.c
@@ -495,3 +495,4 @@ module_exit(spitzkbd_exit);
 MODULE_AUTHOR("Richard Purdie <rpurdie@rpsys.net>");
 MODULE_DESCRIPTION("Spitz Keyboard Driver");
 MODULE_LICENSE("GPLv2");
+MODULE_ALIAS("platform:spitz-keyboard");
diff -puN drivers/input/keyboard/tosakbd.c~input-fix-platform-driver-ho=
tplug-coldplug drivers/input/keyboard/tosakbd.c
--- a/drivers/input/keyboard/tosakbd.c~input-fix-platform-driver-hotplu=
g-coldplug
+++ a/drivers/input/keyboard/tosakbd.c
@@ -409,6 +409,7 @@ static struct platform_driver tosakbd_dr
 	.resume		=3D tosakbd_resume,
 	.driver		=3D {
 		.name	=3D "tosa-keyboard",
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
@@ -428,3 +429,4 @@ module_exit(tosakbd_exit);
 MODULE_AUTHOR("Dirk Opfer <Dirk@Opfer-Online.de>");
 MODULE_DESCRIPTION("Tosa Keyboard Driver");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:tosa-keyboard");
diff -puN drivers/input/misc/cobalt_btns.c~input-fix-platform-driver-ho=
tplug-coldplug drivers/input/misc/cobalt_btns.c
--- a/drivers/input/misc/cobalt_btns.c~input-fix-platform-driver-hotplu=
g-coldplug
+++ a/drivers/input/misc/cobalt_btns.c
@@ -148,6 +148,9 @@ static int __devexit cobalt_buttons_remo
 	return 0;
 }
=20
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:Cobalt buttons");
+
 static struct platform_driver cobalt_buttons_driver =3D {
 	.probe	=3D cobalt_buttons_probe,
 	.remove	=3D __devexit_p(cobalt_buttons_remove),
diff -puN drivers/input/mouse/gpio_mouse.c~input-fix-platform-driver-ho=
tplug-coldplug drivers/input/mouse/gpio_mouse.c
--- a/drivers/input/mouse/gpio_mouse.c~input-fix-platform-driver-hotplu=
g-coldplug
+++ a/drivers/input/mouse/gpio_mouse.c
@@ -171,10 +171,14 @@ static int __devexit gpio_mouse_remove(s
 	return 0;
 }
=20
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:gpio_mouse");
+
 struct platform_driver gpio_mouse_device_driver =3D {
 	.remove		=3D __devexit_p(gpio_mouse_remove),
 	.driver		=3D {
 		.name	=3D "gpio_mouse",
+		.owner	=3D THIS_MODULE,
 	}
 };
=20
diff -puN drivers/input/serio/rpckbd.c~input-fix-platform-driver-hotplu=
g-coldplug drivers/input/serio/rpckbd.c
--- a/drivers/input/serio/rpckbd.c~input-fix-platform-driver-hotplug-co=
ldplug
+++ a/drivers/input/serio/rpckbd.c
@@ -45,6 +45,7 @@
 MODULE_AUTHOR("Vojtech Pavlik, Russell King");
 MODULE_DESCRIPTION("Acorn RiscPC PS/2 keyboard controller driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:kart");
=20
 static int rpckbd_write(struct serio *port, unsigned char val)
 {
@@ -140,6 +141,7 @@ static struct platform_driver rpckbd_dri
 	.remove		=3D __devexit_p(rpckbd_remove),
 	.driver		=3D {
 		.name	=3D "kart",
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
diff -puN drivers/input/touchscreen/corgi_ts.c~input-fix-platform-drive=
r-hotplug-coldplug drivers/input/touchscreen/corgi_ts.c
--- a/drivers/input/touchscreen/corgi_ts.c~input-fix-platform-driver-ho=
tplug-coldplug
+++ a/drivers/input/touchscreen/corgi_ts.c
@@ -362,6 +362,7 @@ static struct platform_driver corgits_dr
 	.resume		=3D corgits_resume,
 	.driver		=3D {
 		.name	=3D "corgi-ts",
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
@@ -381,3 +382,4 @@ module_exit(corgits_exit);
 MODULE_AUTHOR("Richard Purdie <rpurdie@rpsys.net>");
 MODULE_DESCRIPTION("Corgi TouchScreen Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:corgi-ts");
diff -puN drivers/input/touchscreen/jornada720_ts.c~input-fix-platform-=
driver-hotplug-coldplug drivers/input/touchscreen/jornada720_ts.c
--- a/drivers/input/touchscreen/jornada720_ts.c~input-fix-platform-driv=
er-hotplug-coldplug
+++ a/drivers/input/touchscreen/jornada720_ts.c
@@ -160,11 +160,15 @@ static int __devexit jornada720_ts_remov
 	return 0;
 }
=20
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:jornada_ts");
+
 static struct platform_driver jornada720_ts_driver =3D {
 	.probe		=3D jornada720_ts_probe,
 	.remove		=3D __devexit_p(jornada720_ts_remove),
 	.driver		=3D {
 		.name	=3D "jornada_ts",
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

origin.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=3Dy.p=
atch
git-scsi-misc.patch
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
