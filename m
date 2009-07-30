From: akpm@linux-foundation.org
Subject: [folded] add-a-driver-for-the-winbond-wpcd376i-ir-functionality-update.patch removed from -mm tree
Date: Thu, 30 Jul 2009 15:52:34 -0700
Message-ID: <200907302252.n6UMqYJN004298@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752004AbZG3Wxs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 18:53:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@hardeman.nu, bjorn.helgaas@hp.com, jbarnes@virtuousgeek.org, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     add-a-driver-for-the-winbond-wpcd376i-ir-functionality-update
has been removed from the -mm tree.  Its filename was
     add-a-driver-for-the-winbond-wpcd376i-ir-functionality-update.patc=
h

This patch was dropped because it was folded into add-a-driver-for-the-=
winbond-wpcd376i-ir-functionality.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: add-a-driver-for-the-winbond-wpcd376i-ir-functionality-update
=46rom: David H=E4rdeman <david@hardeman.nu>

Changes since the second post to the list (AKPM's remarks):
o Various comments added
o Removed some casts
o use bitrev8
o convert data->irdata to unsigned longs, use __set_bit and test_bit

Signed-off-by: David H=E4rdeman <david@hardeman.nu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                      |    2=20
 drivers/input/misc/Kconfig       |   30 +++++-----
 drivers/input/misc/Makefile      |    2=20
 drivers/input/misc/winbond-cir.c |   81 ++++++++++++++---------------
 4 files changed, 58 insertions(+), 57 deletions(-)

diff -puN MAINTAINERS~add-a-driver-for-the-winbond-wpcd376i-ir-function=
ality-update MAINTAINERS
--- a/MAINTAINERS~add-a-driver-for-the-winbond-wpcd376i-ir-functionalit=
y-update
+++ a/MAINTAINERS
@@ -5550,7 +5550,7 @@ S:	Maintained
 F:	drivers/scsi/wd7000.c
=20
 WINBOND CIR DRIVER
-P:	David H=C3=A4rdeman
+P:	David H=E4rdeman
 M:	david@hardeman.nu
 S:	Maintained
 F:	drivers/input/misc/winbond-cir.c
diff -puN drivers/input/misc/Kconfig~add-a-driver-for-the-winbond-wpcd3=
76i-ir-functionality-update drivers/input/misc/Kconfig
--- a/drivers/input/misc/Kconfig~add-a-driver-for-the-winbond-wpcd376i-=
ir-functionality-update
+++ a/drivers/input/misc/Kconfig
@@ -222,6 +222,21 @@ config INPUT_SGI_BTNS
 	  To compile this driver as a module, choose M here: the
 	  module will be called sgi_btns.
=20
+config INPUT_WINBOND_CIR
+	tristate "Winbond IR remote control"
+	depends on X86 && ACPI
+	select LEDS_CLASS
+	help
+	  Say Y here if you want to use the IR remote functionality found
+	  in some Winbond SuperI/O chips. Currently only the WPCD376I
+	  chip is supported (included in some Intel Media series motherboards=
).
+
+	  IR Receive and wake-on-IR from suspend and power-off is currently
+	  supported.
+
+	  To compile this driver as a module, choose M here: the module will =
be
+	  called winbond_cir.
+
 config HP_SDC_RTC
 	tristate "HP SDC Real Time Clock"
 	depends on (GSC || HP300) && SERIO
@@ -248,21 +263,6 @@ config INPUT_GPIO_ROTARY_ENCODER
 	  To compile this driver as a module, choose M here: the
 	  module will be called rotary_encoder.
=20
-config INPUT_WINBOND_CIR
-	tristate "Winbond IR remote control"
-	depends on X86 && ACPI
-	select LEDS_CLASS
-	help
-	  Say Y here if you want to use the IR remote functionality found
-	  in some Winbond SuperI/O chips. Currently only the WPCD376I
-	  chip is supported (included in some Intel Media series motherboards=
).
-
-	  IR Receive and wake-on-IR from suspend and power-off is currently
-	  supported.
-
-	  To compile this driver as a module, choose M here: the module will =
be
-	  called winbond_cir.
-
 config INPUT_RB532_BUTTON
 	tristate "Mikrotik Routerboard 532 button interface"
 	depends on MIKROTIK_RB532
diff -puN drivers/input/misc/Makefile~add-a-driver-for-the-winbond-wpcd=
376i-ir-functionality-update drivers/input/misc/Makefile
--- a/drivers/input/misc/Makefile~add-a-driver-for-the-winbond-wpcd376i=
-ir-functionality-update
+++ a/drivers/input/misc/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_INPUT_PCF50633_PMU)	+=3D pcf5
 obj-$(CONFIG_INPUT_PCSPKR)		+=3D pcspkr.o
 obj-$(CONFIG_INPUT_POWERMATE)		+=3D powermate.o
 obj-$(CONFIG_INPUT_RB532_BUTTON)	+=3D rb532_button.o
+obj-$(CONFIG_INPUT_WINBOND_CIR)		+=3D winbond-cir.o
 obj-$(CONFIG_INPUT_GPIO_ROTARY_ENCODER)	+=3D rotary_encoder.o
 obj-$(CONFIG_INPUT_SGI_BTNS)		+=3D sgi_btns.o
 obj-$(CONFIG_INPUT_SPARCSPKR)		+=3D sparcspkr.o
@@ -26,4 +27,3 @@ obj-$(CONFIG_INPUT_TWL4030_PWRBUTTON)	+=3D
 obj-$(CONFIG_INPUT_UINPUT)		+=3D uinput.o
 obj-$(CONFIG_INPUT_WISTRON_BTNS)	+=3D wistron_btns.o
 obj-$(CONFIG_INPUT_YEALINK)		+=3D yealink.o
-obj-$(CONFIG_INPUT_WINBOND_CIR)		+=3D winbond-cir.o
diff -puN drivers/input/misc/winbond-cir.c~add-a-driver-for-the-winbond=
-wpcd376i-ir-functionality-update drivers/input/misc/winbond-cir.c
--- a/drivers/input/misc/winbond-cir.c~add-a-driver-for-the-winbond-wpc=
d376i-ir-functionality-update
+++ a/drivers/input/misc/winbond-cir.c
@@ -6,8 +6,8 @@
  *  could probably support others (Winbond WEC102X, NatSemi, etc)
  *  with minor modifications.
  *
- *  Original Author: David H=C3=A4rdeman <david@hardeman.nu>
- *     Copyright (C) 2009 David H=C3=A4rdeman <david@hardeman.nu>
+ *  Original Author: David H=E4rdeman <david@hardeman.nu>
+ *     Copyright (C) 2009 David H=E4rdeman <david@hardeman.nu>
  *
  *  Dedicated to Matilda, my newborn daughter, without whose loving at=
tention
  *  this driver would have been finished in half the time and with a f=
raction
@@ -54,6 +54,8 @@
 #include <linux/spinlock.h>
 #include <linux/pci_ids.h>
 #include <linux/io.h>
+#include <linux/bitrev.h>
+#include <linux/bitops.h>
=20
 #define DRVNAME "winbond-cir"
=20
@@ -114,7 +116,7 @@
 #define WBCIR_REG_SP3_IRCFG4	0x07 /* Infrared Config 4		*/
=20
 /*
- * Magic values follows
+ * Magic values follow
  */
=20
 /* No interrupts for WBCIR_REG_SP3_IER and WBCIR_REG_SP3_EIR */
@@ -235,6 +237,7 @@ static struct wbcir_key rc6_def_keymap[]
 	{ 0x800F0417, KEY_RECORD		},
 };
=20
+/* Registers and other state is protected by wbcir_lock */
 struct wbcir_data {
 	unsigned long wbase;        /* Wake-Up Baseaddr		*/
 	unsigned long ebase;        /* Enhanced Func. Baseaddr	*/
@@ -247,7 +250,6 @@ struct wbcir_data {
 	struct led_trigger *txtrigger;
 	struct led_classdev led;
=20
-	/* The rest is protected by wbcir_lock */
 	u32 last_scancode;
 	unsigned int last_keycode;
 	u8 last_toggle;
@@ -256,7 +258,7 @@ struct wbcir_data {
 	unsigned int idle_count;
=20
 	/* RX irdata and parsing state */
-	u8 irdata[30];
+	unsigned long irdata[30];
 	unsigned int irdata_count;
 	unsigned int irdata_idle;
 	unsigned int irdata_off;
@@ -292,6 +294,7 @@ MODULE_PARM_DESC(wake_rc6mode, "RC6 mode
  *
  *********************************************************************=
********/
=20
+/* Caller needs to hold wbcir_lock */
 static void
 wbcir_set_bits(unsigned long addr, u8 bits, u8 mask)
 {
@@ -302,6 +305,7 @@ wbcir_set_bits(unsigned long addr, u8 bi
 	outb(val, addr);
 }
=20
+/* Selects the register bank for the serial port */
 static inline void
 wbcir_select_bank(struct wbcir_data *data, enum wbcir_bank bank)
 {
@@ -334,14 +338,7 @@ wbcir_led_brightness_set(struct led_clas
 		       WBCIR_LED_ENABLE);
 }
=20
-static u8
-wbcir_revbyte(u8 byte)
-{
-	byte =3D ((byte >> 1) & 0x55) | ((byte << 1) & 0xAA);
-	byte =3D ((byte >> 2) & 0x33) | ((byte << 2) & 0xCC);
-	return (byte >> 4) | (byte<<4);
-}
-
+/* Manchester encodes bits to RC6 message cells (see wbcir_parse_rc6) =
*/
 static u8
 wbcir_to_rc6cells(u8 val)
 {
@@ -389,16 +386,11 @@ wbcir_do_getkeycode(struct wbcir_data *d
 }
=20
 static int
-wbcir_getkeycode(struct input_dev *dev, int sscancode, int *keycode)
+wbcir_getkeycode(struct input_dev *dev, int scancode, int *keycode)
 {
-	unsigned int scancode =3D (unsigned int)sscancode;
 	struct wbcir_data *data =3D input_get_drvdata(dev);
=20
-	if (scancode < 0 || scancode > 0xFFFFFFFF)
-		return -EINVAL;
-
 	*keycode =3D (int)wbcir_do_getkeycode(data, (u32)scancode);
-
 	return 0;
 }
=20
@@ -410,10 +402,7 @@ wbcir_setkeycode(struct input_dev *dev,=20
 	struct wbcir_keyentry *new_keyentry;
 	unsigned long flags;
 	unsigned int old_keycode =3D KEY_RESERVED;
-	unsigned int scancode =3D (unsigned int)sscancode;
-
-	if (scancode < 0 || scancode > 0xFFFFFFFF)
-		return -EINVAL;
+	u32 scancode =3D (u32)sscancode;
=20
 	if (keycode < 0 || keycode > KEY_MAX)
 		return -EINVAL;
@@ -442,8 +431,8 @@ wbcir_setkeycode(struct input_dev *dev,=20
 	set_bit(keycode, dev->keybit);
=20
 	if (old_keycode =3D=3D KEY_RESERVED) {
-		new_keyentry->key.scancode =3D (u32)scancode;
-		new_keyentry->key.keycode =3D (unsigned int)keycode;
+		new_keyentry->key.scancode =3D scancode;
+		new_keyentry->key.keycode =3D keycode;
 		list_add(&new_keyentry->list, &data->keytable);
 	} else {
 		kfree(new_keyentry);
@@ -460,6 +449,10 @@ wbcir_setkeycode(struct input_dev *dev,=20
 	return 0;
 }
=20
+/*
+ * Timer function to report keyup event some time after keydown is
+ * reported by the ISR.
+ */
 static void
 wbcir_keyup(unsigned long cookie)
 {
@@ -470,6 +463,11 @@ wbcir_keyup(unsigned long cookie)
 	 * data->keyup_jiffies is used to prevent a race condition if a
 	 * hardware interrupt occurs at this point and the keyup timer
 	 * event is moved further into the future as a result.
+	 *
+	 * The timer will then be reactivated and this function called
+	 * again in the future. We need to exit gracefully in that case
+	 * to allow the input subsystem to do its auto-repeat magic or
+	 * a keyup event might follow immediately after the keydown.
 	 */
=20
 	spin_lock_irqsave(&wbcir_lock, flags);
@@ -534,7 +532,7 @@ set_timer:
 static void
 wbcir_reset_irdata(struct wbcir_data *data)
 {
-	memset(&data->irdata, 0, sizeof(data->irdata));
+	memset(data->irdata, 0, sizeof(data->irdata));
 	data->irdata_count =3D 0;
 	data->irdata_off =3D 0;
 	data->irdata_error =3D 0;
@@ -544,9 +542,13 @@ wbcir_reset_irdata(struct wbcir_data *da
 static void
 add_irdata_bit(struct wbcir_data *data, int set)
 {
+	if (data->irdata_count >=3D sizeof(data->irdata) * 8) {
+		data->irdata_error =3D 1;
+		return;
+	}
+
 	if (set)
-		data->irdata[data->irdata_count / 8] |=3D
-			0x01 << (data->irdata_count % 8);
+		__set_bit(data->irdata_count, data->irdata);
 	data->irdata_count++;
 }
=20
@@ -563,8 +565,7 @@ get_bits(struct wbcir_data *data, int co
=20
 	while (count > 0) {
 		val <<=3D 1;
-		if (data->irdata[data->irdata_off / 8] &
-		    (0x01 << (data->irdata_off % 8)))
+		if (test_bit(data->irdata_off, data->irdata))
 			val |=3D 0x1;
 		count--;
 		data->irdata_off++;
@@ -893,10 +894,10 @@ wbcir_parse_nec(struct device *dev, stru
 		return;
 	}
=20
-	address1  =3D wbcir_revbyte(get_bits(data, 8));
-	address2  =3D wbcir_revbyte(get_bits(data, 8));
-	command1  =3D wbcir_revbyte(get_bits(data, 8));
-	command2  =3D wbcir_revbyte(get_bits(data, 8));
+	address1  =3D bitrev8(get_bits(data, 8));
+	address2  =3D bitrev8(get_bits(data, 8));
+	command1  =3D bitrev8(get_bits(data, 8));
+	command2  =3D bitrev8(get_bits(data, 8));
=20
 	/* Sanity check */
 	if (data->irdata_error) {
@@ -988,8 +989,8 @@ wbcir_irq_handler(int irqno, void *cooki
 		outb(WBCIR_RX_DISABLE, data->sbase + WBCIR_REG_SP3_ASCR);
=20
 		dev_dbg(dev, "IRDATA:\n");
-		for (i =3D 0; i < data->irdata_count; i +=3D 8)
-			dev_dbg(dev, "0x%02X\n", data->irdata[i/8]);
+		for (i =3D 0; i < data->irdata_count; i +=3D BITS_PER_LONG)
+			dev_dbg(dev, "0x%08lX\n", data->irdata[i/BITS_PER_LONG]);
=20
 		switch (protocol) {
 		case IR_PROTOCOL_RC5:
@@ -1068,12 +1069,12 @@ wbcir_shutdown(struct acpi_device *devic
=20
 		mask[0] =3D mask[1] =3D mask[2] =3D mask[3] =3D 0xFF;
=20
-		match[1] =3D wbcir_revbyte((wake_sc & 0xFF));
+		match[1] =3D bitrev8((wake_sc & 0xFF));
 		match[0] =3D ~match[1];
=20
-		match[3] =3D wbcir_revbyte((wake_sc & 0xFF00) >> 8);
+		match[3] =3D bitrev8((wake_sc & 0xFF00) >> 8);
 		if (wake_sc > 0xFFFF)
-			match[2] =3D wbcir_revbyte((wake_sc & 0xFF0000) >> 16);
+			match[2] =3D bitrev8((wake_sc & 0xFF0000) >> 16);
 		else
 			match[2] =3D ~match[3];
=20
@@ -1683,7 +1684,7 @@ wbcir_exit(void)
 	acpi_bus_unregister_driver(&wbcir_driver);
 }
=20
-MODULE_AUTHOR("David H=C3=A4rdeman <david@hardeman.nu>");
+MODULE_AUTHOR("David H=E4rdeman <david@hardeman.nu>");
 MODULE_DESCRIPTION("Winbond SuperI/O Consumer IR Driver");
 MODULE_LICENSE("GPL");
=20
_

Patches currently in -mm which might be from david@hardeman.nu are

acpi-reintroduce-acpi_device_ops-shutdown-method.patch
add-a-driver-for-the-winbond-wpcd376i-ir-functionality.patch
add-a-driver-for-the-winbond-wpcd376i-ir-functionality-update.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
