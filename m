From: akpm@linux-foundation.org
Subject: + matrox-maven-convert-to-a-new-style-i2c-driver.patch added to -mm tree
Date: Fri, 08 Aug 2008 14:05:20 -0700
Message-ID: <200808082105.m78L5KXb028499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753917AbYHHVF7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 17:05:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, VANDROVE@vc.cvut.cz, krzysztof.h1@wp.pl


The patch titled
     matrox maven: convert to a new-style i2c driver
has been added to the -mm tree.  Its filename is
     matrox-maven-convert-to-a-new-style-i2c-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: matrox maven: convert to a new-style i2c driver
From: Jean Delvare <khali@linux-fr.org>

The legacy i2c model is going away soon, so switch to the new model.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Petr Vandrovec <VANDROVE@vc.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/matrox/i2c-matroxfb.c   |   12 ++-
 drivers/video/matrox/matroxfb_maven.c |   95 +++++++++---------------
 include/linux/i2c-id.h                |    2 
 3 files changed, 50 insertions(+), 59 deletions(-)

diff -puN drivers/video/matrox/i2c-matroxfb.c~matrox-maven-convert-to-a-new-style-i2c-driver drivers/video/matrox/i2c-matroxfb.c
--- a/drivers/video/matrox/i2c-matroxfb.c~matrox-maven-convert-to-a-new-style-i2c-driver
+++ a/drivers/video/matrox/i2c-matroxfb.c
@@ -107,7 +107,6 @@ static int i2c_bus_reg(struct i2c_bit_ad
 	b->mask.data = data;
 	b->mask.clock = clock;
 	b->adapter.owner = THIS_MODULE;
-	b->adapter.id = I2C_HW_B_G400;
 	snprintf(b->adapter.name, sizeof(b->adapter.name), name,
 		minfo->fbcon.node);
 	i2c_set_adapdata(&b->adapter, b);
@@ -182,6 +181,17 @@ static void* i2c_matroxfb_probe(struct m
 				  MAT_DATA, MAT_CLK, "MAVEN:fb%u", 0);
 		if (err)
 			printk(KERN_INFO "i2c-matroxfb: Could not register Maven i2c bus. Continuing anyway.\n");
+		else {
+			struct i2c_board_info maven_info = {
+				I2C_BOARD_INFO("maven", 0x1b),
+			};
+			unsigned short const addr_list[2] = {
+				0x1b, I2C_CLIENT_END
+			};
+
+			i2c_new_probed_device(&m2info->maven.adapter,
+					      &maven_info, addr_list);
+		}
 	}
 	return m2info;
 fail_ddc1:;
diff -puN drivers/video/matrox/matroxfb_maven.c~matrox-maven-convert-to-a-new-style-i2c-driver drivers/video/matrox/matroxfb_maven.c
--- a/drivers/video/matrox/matroxfb_maven.c~matrox-maven-convert-to-a-new-style-i2c-driver
+++ a/drivers/video/matrox/matroxfb_maven.c
@@ -19,8 +19,6 @@
 #include <linux/matroxfb.h>
 #include <asm/div64.h>
 
-#define MAVEN_I2CID	(0x1B)
-
 #define MGATVO_B	1
 #define MGATVO_C	2
 
@@ -128,7 +126,7 @@ static int get_ctrl_id(__u32 v4l2_id) {
 
 struct maven_data {
 	struct matrox_fb_info*		primary_head;
-	struct i2c_client		client;
+	struct i2c_client		*client;
 	int				version;
 };
 
@@ -974,7 +972,7 @@ static inline int maven_compute_timming(
 
 static int maven_program_timming(struct maven_data* md,
 		const struct mavenregs* m) {
-	struct i2c_client* c = &md->client;
+	struct i2c_client *c = md->client;
 
 	if (m->mode == MATROXFB_OUTPUT_MODE_MONITOR) {
 		LR(0x80);
@@ -1011,7 +1009,7 @@ static int maven_program_timming(struct 
 }
 
 static inline int maven_resync(struct maven_data* md) {
-	struct i2c_client* c = &md->client;
+	struct i2c_client *c = md->client;
 	maven_set_reg(c, 0x95, 0x20);	/* start whole thing */
 	return 0;
 }
@@ -1069,48 +1067,48 @@ static int maven_set_control (struct mav
 		  maven_compute_bwlevel(md, &blacklevel, &whitelevel);
 		  blacklevel = (blacklevel >> 2) | ((blacklevel & 3) << 8);
 		  whitelevel = (whitelevel >> 2) | ((whitelevel & 3) << 8);
-		  maven_set_reg_pair(&md->client, 0x0e, blacklevel);
-		  maven_set_reg_pair(&md->client, 0x1e, whitelevel);
+		  maven_set_reg_pair(md->client, 0x0e, blacklevel);
+		  maven_set_reg_pair(md->client, 0x1e, whitelevel);
 		}
 		break;
 		case V4L2_CID_SATURATION:
 		{
-		  maven_set_reg(&md->client, 0x20, p->value);
-		  maven_set_reg(&md->client, 0x22, p->value);
+		  maven_set_reg(md->client, 0x20, p->value);
+		  maven_set_reg(md->client, 0x22, p->value);
 		}
 		break;
 		case V4L2_CID_HUE:
 		{
-		  maven_set_reg(&md->client, 0x25, p->value);
+		  maven_set_reg(md->client, 0x25, p->value);
 		}
 		break;
 		case V4L2_CID_GAMMA:
 		{
 		  const struct maven_gamma* g;
 		  g = maven_compute_gamma(md);
-		  maven_set_reg(&md->client, 0x83, g->reg83);
-		  maven_set_reg(&md->client, 0x84, g->reg84);
-		  maven_set_reg(&md->client, 0x85, g->reg85);
-		  maven_set_reg(&md->client, 0x86, g->reg86);
-		  maven_set_reg(&md->client, 0x87, g->reg87);
-		  maven_set_reg(&md->client, 0x88, g->reg88);
-		  maven_set_reg(&md->client, 0x89, g->reg89);
-		  maven_set_reg(&md->client, 0x8a, g->reg8a);
-		  maven_set_reg(&md->client, 0x8b, g->reg8b);
+		  maven_set_reg(md->client, 0x83, g->reg83);
+		  maven_set_reg(md->client, 0x84, g->reg84);
+		  maven_set_reg(md->client, 0x85, g->reg85);
+		  maven_set_reg(md->client, 0x86, g->reg86);
+		  maven_set_reg(md->client, 0x87, g->reg87);
+		  maven_set_reg(md->client, 0x88, g->reg88);
+		  maven_set_reg(md->client, 0x89, g->reg89);
+		  maven_set_reg(md->client, 0x8a, g->reg8a);
+		  maven_set_reg(md->client, 0x8b, g->reg8b);
 		}
 		break;
 		case MATROXFB_CID_TESTOUT:
 		{
 			unsigned char val 
-			  = maven_get_reg(&md->client,0x8d);
+			  = maven_get_reg(md->client, 0x8d);
 			if (p->value) val |= 0x10;
 			else          val &= ~0x10;
-			maven_set_reg(&md->client, 0x8d, val);
+			maven_set_reg(md->client, 0x8d, val);
 		}
 		break;
 		case MATROXFB_CID_DEFLICKER:
 		{
-		  maven_set_reg(&md->client, 0x93, maven_compute_deflicker(md));
+		  maven_set_reg(md->client, 0x93, maven_compute_deflicker(md));
 		}
 		break;
 	}
@@ -1189,6 +1187,7 @@ static int maven_init_client(struct i2c_
 	MINFO_FROM(container_of(clnt->adapter, struct i2c_bit_adapter, adapter)->minfo);
 
 	md->primary_head = MINFO;
+	md->client = clnt;
 	down_write(&ACCESS_FBINFO(altout.lock));
 	ACCESS_FBINFO(outputs[1]).output = &maven_altout;
 	ACCESS_FBINFO(outputs[1]).src = ACCESS_FBINFO(outputs[1]).default_src;
@@ -1232,14 +1231,11 @@ static int maven_shutdown_client(struct 
 	return 0;
 }
 
-static const unsigned short normal_i2c[] = { MAVEN_I2CID, I2C_CLIENT_END };
-I2C_CLIENT_INSMOD;
-
-static struct i2c_driver maven_driver;
-
-static int maven_detect_client(struct i2c_adapter* adapter, int address, int kind) {
-	int err = 0;
-	struct i2c_client* new_client;
+static int maven_probe(struct i2c_client *client,
+		       const struct i2c_device_id *id)
+{
+	struct i2c_adapter *adapter = client->adapter;
+	int err = -ENODEV;
 	struct maven_data* data;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WRITE_WORD_DATA |
@@ -1250,50 +1246,37 @@ static int maven_detect_client(struct i2
 		err = -ENOMEM;
 		goto ERROR0;
 	}
-	new_client = &data->client;
-	i2c_set_clientdata(new_client, data);
-	new_client->addr = address;
-	new_client->adapter = adapter;
-	new_client->driver = &maven_driver;
-	new_client->flags = 0;
-	strlcpy(new_client->name, "maven", I2C_NAME_SIZE);
-	if ((err = i2c_attach_client(new_client)))
-		goto ERROR3;
-	err = maven_init_client(new_client);
+	i2c_set_clientdata(client, data);
+	err = maven_init_client(client);
 	if (err)
 		goto ERROR4;
 	return 0;
 ERROR4:;
-	i2c_detach_client(new_client);
-ERROR3:;
 	kfree(data);
 ERROR0:;
 	return err;
 }
 
-static int maven_attach_adapter(struct i2c_adapter* adapter) {
-	if (adapter->id == I2C_HW_B_G400)
-		return i2c_probe(adapter, &addr_data, &maven_detect_client);
-	return 0;
-}
-
-static int maven_detach_client(struct i2c_client* client) {
-	int err;
-
-	if ((err = i2c_detach_client(client)))
-		return err;
+static int maven_remove(struct i2c_client *client)
+{
 	maven_shutdown_client(client);
 	kfree(i2c_get_clientdata(client));
 	return 0;
 }
 
+static const struct i2c_device_id maven_id[] = {
+	{ "maven", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, maven_id);
+
 static struct i2c_driver maven_driver={
 	.driver = {
 		.name	= "maven",
 	},
-	.id		= I2C_DRIVERID_MGATVO,
-	.attach_adapter	= maven_attach_adapter,
-	.detach_client	= maven_detach_client,
+	.probe		= maven_probe,
+	.remove		= maven_remove,
+	.id_table	= maven_id,
 };
 
 static int __init matroxfb_maven_init(void)
diff -puN include/linux/i2c-id.h~matrox-maven-convert-to-a-new-style-i2c-driver include/linux/i2c-id.h
--- a/include/linux/i2c-id.h~matrox-maven-convert-to-a-new-style-i2c-driver
+++ a/include/linux/i2c-id.h
@@ -39,7 +39,6 @@
 #define I2C_DRIVERID_SAA7111A	 8	/* video input processor	*/
 #define I2C_DRIVERID_SAA7185B	13	/* video encoder		*/
 #define I2C_DRIVERID_SAA7110	22	/* video decoder		*/
-#define I2C_DRIVERID_MGATVO	23	/* Matrox TVOut			*/
 #define I2C_DRIVERID_SAA5249	24	/* SAA5249 and compatibles	*/
 #define I2C_DRIVERID_PCF8583	25	/* real time clock		*/
 #define I2C_DRIVERID_SAB3036	26	/* SAB3036 tuner		*/
@@ -95,7 +94,6 @@
 #define I2C_HW_B_BT848		0x010005 /* BT848 video boards */
 #define I2C_HW_B_VIA		0x010007 /* Via vt82c586b */
 #define I2C_HW_B_HYDRA		0x010008 /* Apple Hydra Mac I/O */
-#define I2C_HW_B_G400		0x010009 /* Matrox G400 */
 #define I2C_HW_B_I810		0x01000a /* Intel I810 */
 #define I2C_HW_B_VOO		0x01000b /* 3dfx Voodoo 3 / Banshee */
 #define I2C_HW_B_SCX200		0x01000e /* Nat'l Semi SCx200 I2C */
_

Patches currently in -mm which might be from khali@linux-fr.org are

matrox-maven-fix-a-broken-error-path.patch
matroxfb-i2c-structure-templates-clean-up.patch
matrox-maven-convert-to-a-new-style-i2c-driver.patch
linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
i2c-renesas-highlander-fpga-smbus-support.patch
i2c-renesas-highlander-fpga-smbus-support-update.patch
i2c-renesas-highlander-fpga-smbus-support-update-fix.patch
applesmc-support-for-intel-imac.patch
applesmc-add-support-for-macbook-v3.patch
hwmon-adc124s501-generic-driver.patch
hwmon-adc124s501-generic-driver-update.patch
i5k_amb-provide-labels-for-temperature-sensors.patch
abituguru3-update-maintainers.patch
radeonfb-revert-fix-radeon-ddc-regression.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

