From: akpm@linux-foundation.org
Subject: + rtc-ds1307-add-trickle-charger-device-tree-binding.patch added
 to -mm tree
Date: Wed, 10 Sep 2014 16:56:55 -0700
Message-ID: <5410e547.sHQD9SDSkXCfgnc2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbaIJX44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Sep 2014 19:56:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matti.vaittinen@nsn.com, a.zummo@towertech.it, jason@lakedaemon.net, linux@roeck-us.net, mark.rutland@arm.com, pavel@denx.de, pawel.moll@arm.com, robh+dt@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: ds1307: add trickle charger device tree binding
has been added to the -mm tree.  Its filename is
     rtc-ds1307-add-trickle-charger-device-tree-binding.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-ds1307-add-trickle-charger-device-tree-binding.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-ds1307-add-trickle-charger-device-tree-binding.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matti Vaittinen <matti.vaittinen@nsn.com>
Subject: rtc: ds1307: add trickle charger device tree binding

Some DS13XX devices have "trickle chargers".  Introduce a device tree
binding for specifying the trickle charger configuration for ds1339.

Only ds1339 dt binding is supported because this is the only chip I have. 
I _assume_ the code would have worked on other allready supported chips. 
However I cannot check the resistor values for the other chips or test
them.  For other chips the driver code works as earlier Eg.  it does not
check the dt bindings at all

Signed-off-by: Matti Vaittinen <matti.vaittinen@nsn.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Pavel Machek <pavel@denx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   67 ++++++++++++++++++++++++++++++++++---
 1 file changed, 63 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-add-trickle-charger-device-tree-binding drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-add-trickle-charger-device-tree-binding
+++ a/drivers/rtc/rtc-ds1307.c
@@ -126,9 +126,14 @@ struct chip_desc {
 	u16			nvram_offset;
 	u16			nvram_size;
 	u16			trickle_charger_reg;
+	u8			trickle_charger_setup;
+	u8			(*do_trickle_setup)(struct i2c_client *, uint32_t, bool);
 };
 
-static const struct chip_desc chips[last_ds_type] = {
+static u8 do_trickle_setup_ds1339(struct i2c_client *,
+				  uint32_t ohms, bool diode);
+
+static struct chip_desc chips[last_ds_type] = {
 	[ds_1307] = {
 		.nvram_offset	= 8,
 		.nvram_size	= 56,
@@ -143,6 +148,7 @@ static const struct chip_desc chips[last
 	[ds_1339] = {
 		.alarm		= 1,
 		.trickle_charger_reg = 0x10,
+		.do_trickle_setup = &do_trickle_setup_ds1339,
 	},
 	[ds_1340] = {
 		.trickle_charger_reg = 0x08,
@@ -833,15 +839,58 @@ ds1307_nvram_write(struct file *filp, st
 	return count;
 }
 
+
 /*----------------------------------------------------------------------*/
 
+static u8 do_trickle_setup_ds1339(struct i2c_client *client,
+				  uint32_t ohms, bool diode)
+{
+	u8 setup = (diode) ? DS1307_TRICKLE_CHARGER_DIODE :
+		DS1307_TRICKLE_CHARGER_NO_DIODE;
+
+	switch (ohms) {
+	case 250:
+		setup |= DS1307_TRICKLE_CHARGER_250_OHM;
+		break;
+	case 2000:
+		setup |= DS1307_TRICKLE_CHARGER_2K_OHM;
+		break;
+	case 4000:
+		setup |= DS1307_TRICKLE_CHARGER_4K_OHM;
+		break;
+	default:
+		dev_warn(&client->dev,
+			 "Unsupported ohm value %u in dt\n", ohms);
+		return 0;
+	}
+	return setup;
+}
+
+static void ds1307_trickle_of_init(struct i2c_client *client,
+				   struct chip_desc *chip)
+{
+	uint32_t ohms = 0;
+	bool diode = true;
+
+	if (!chip->do_trickle_setup)
+		goto out;
+	if (of_property_read_u32(client->dev.of_node, "trickle-resistor-ohms" , &ohms))
+		goto out;
+	if (of_property_read_bool(client->dev.of_node, "trickle-diode-disable"))
+		diode = false;
+	chip->trickle_charger_setup = chip->do_trickle_setup(client,
+							     ohms, diode);
+out:
+	return;
+}
+
 static int ds1307_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct ds1307		*ds1307;
 	int			err = -ENODEV;
 	int			tmp;
-	const struct chip_desc	*chip = &chips[id->driver_data];
+	struct chip_desc	*chip = &chips[id->driver_data];
 	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
 	bool			want_irq = false;
 	unsigned char		*buf;
@@ -866,9 +915,19 @@ static int ds1307_probe(struct i2c_clien
 	ds1307->client	= client;
 	ds1307->type	= id->driver_data;
 
-	if (pdata && pdata->trickle_charger_setup && chip->trickle_charger_reg)
+	if (!pdata && client->dev.of_node)
+		ds1307_trickle_of_init(client, chip);
+	else if (pdata && pdata->trickle_charger_setup)
+		chip->trickle_charger_setup = pdata->trickle_charger_setup;
+
+	if (chip->trickle_charger_setup && chip->trickle_charger_reg) {
+		dev_dbg(&client->dev, "writing trickle charger info 0x%x to 0x%x\n",
+		    DS13XX_TRICKLE_CHARGER_MAGIC | chip->trickle_charger_setup,
+		    chip->trickle_charger_reg);
 		i2c_smbus_write_byte_data(client, chip->trickle_charger_reg,
-			DS13XX_TRICKLE_CHARGER_MAGIC | pdata->trickle_charger_setup);
+		    DS13XX_TRICKLE_CHARGER_MAGIC |
+		    chip->trickle_charger_setup);
+	}
 
 	buf = ds1307->regs;
 	if (i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK)) {
_

Patches currently in -mm which might be from matti.vaittinen@nsn.com are

documentation-dt-bindings-trickle-charger-dt-binding-document-for-ds1339.patch
rtc-ds1307-add-trickle-charger-device-tree-binding.patch

