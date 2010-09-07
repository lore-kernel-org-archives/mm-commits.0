From: akpm@linux-foundation.org
Subject: + gpio-sx150x-correct-and-refine-reset-on-probe-behavior.patch added to -mm tree
Date: Tue, 07 Sep 2010 15:07:51 -0700
Message-ID: <201009072207.o87M7p0p009189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755652Ab0IGWIk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 18:08:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gbean@codeaurora.org, khali@linux-fr.org


The patch titled
     gpio: sx150x: correct and refine reset-on-probe behavior
has been added to the -mm tree.  Its filename is
     gpio-sx150x-correct-and-refine-reset-on-probe-behavior.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: sx150x: correct and refine reset-on-probe behavior
From: Gregory Bean <gbean@codeaurora.org>

Replace the arbitrary software-reset call from the device-probe
method, because:

- It is defective.  To work correctly, it should be two byte writes,
  not a single word write.  As it stands, it does nothing.

- Some devices with sx150x expanders installed have their NRESET pins
  ganged on the same line, so resetting one causes the others to reset -
  not a nice thing to do arbitrarily!

- The probe, usually taking place at boot, implies a recent hard-reset,
  so a software reset at this point is just a waste of energy anyway.

Therefore, make it optional, defaulting to off, as this will match the
common case of probing at powerup and also matches the current broken
no-op behavior.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
Reviewed-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/sx150x.c      |   26 +++++++++++++++++++++-----
 include/linux/i2c/sx150x.h |    4 ++++
 2 files changed, 25 insertions(+), 5 deletions(-)

diff -puN drivers/gpio/sx150x.c~gpio-sx150x-correct-and-refine-reset-on-probe-behavior drivers/gpio/sx150x.c
--- a/drivers/gpio/sx150x.c~gpio-sx150x-correct-and-refine-reset-on-probe-behavior
+++ a/drivers/gpio/sx150x.c
@@ -459,17 +459,33 @@ static int sx150x_init_io(struct sx150x_
 	return err;
 }
 
-static int sx150x_init_hw(struct sx150x_chip *chip,
-			struct sx150x_platform_data *pdata)
+static int sx150x_reset(struct sx150x_chip *chip)
 {
-	int err = 0;
+	int err;
 
-	err = i2c_smbus_write_word_data(chip->client,
+	err = i2c_smbus_write_byte_data(chip->client,
 					chip->dev_cfg->reg_reset,
-					0x3412);
+					0x12);
 	if (err < 0)
 		return err;
 
+	err = i2c_smbus_write_byte_data(chip->client,
+					chip->dev_cfg->reg_reset,
+					0x34);
+	return err;
+}
+
+static int sx150x_init_hw(struct sx150x_chip *chip,
+			struct sx150x_platform_data *pdata)
+{
+	int err = 0;
+
+	if (pdata->reset_during_probe) {
+		err = sx150x_reset(chip);
+		if (err < 0)
+			return err;
+	}
+
 	err = sx150x_i2c_write(chip->client,
 			chip->dev_cfg->reg_misc,
 			0x01);
diff -puN include/linux/i2c/sx150x.h~gpio-sx150x-correct-and-refine-reset-on-probe-behavior include/linux/i2c/sx150x.h
--- a/include/linux/i2c/sx150x.h~gpio-sx150x-correct-and-refine-reset-on-probe-behavior
+++ a/include/linux/i2c/sx150x.h
@@ -63,6 +63,9 @@
  *            IRQ lines will appear.  Similarly to gpio_base, the expander
  *            will create a block of irqs beginning at this number.
  *            This value is ignored if irq_summary is < 0.
+ * @reset_during_probe: If set to true, the driver will trigger a full
+ *                      reset of the chip at the beginning of the probe
+ *                      in order to place it in a known state.
  */
 struct sx150x_platform_data {
 	unsigned gpio_base;
@@ -73,6 +76,7 @@ struct sx150x_platform_data {
 	u16      io_polarity;
 	int      irq_summary;
 	unsigned irq_base;
+	bool     reset_during_probe;
 };
 
 #endif /* __LINUX_I2C_SX150X_H */
_

Patches currently in -mm which might be from gbean@codeaurora.org are

gpio-sx150x-correct-and-refine-reset-on-probe-behavior.patch

