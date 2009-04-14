From: akpm@linux-foundation.org
Subject: + leds-add-the-sysfs-interface-into-the-leds-bd2802-driver-for-changing-wave-pattern-and-led-current.patch added to -mm tree
Date: Tue, 14 Apr 2009 15:59:33 -0700
Message-ID: <200904142259.n3EMxXrp011509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033AbZDNXCX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 19:02:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chammoru@gmail.com, q1.kim@samsung.com, rpurdie@rpsys.net


The patch titled
     leds: add the sysfs interface into the leds-bd2802 driver  for changing wave pattern and led current.
has been added to the -mm tree.  Its filename is
     leds-add-the-sysfs-interface-into-the-leds-bd2802-driver-for-changing-wave-pattern-and-led-current.patch

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
Subject: leds: add the sysfs interface into the leds-bd2802 driver  for changing wave pattern and led current.
From: Kim Kyuwon <chammoru@gmail.com>

Allow the user application to change the wave pattern and led current by
'wave_pattern' and 'rgb_current' sysfs files.

Signed-off-by: Kim Kyuwon <q1.kim@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-bd2802.c |   86 +++++++++++++++++++++++++++++------
 1 file changed, 73 insertions(+), 13 deletions(-)

diff -puN drivers/leds/leds-bd2802.c~leds-add-the-sysfs-interface-into-the-leds-bd2802-driver-for-changing-wave-pattern-and-led-current drivers/leds/leds-bd2802.c
--- a/drivers/leds/leds-bd2802.c~leds-add-the-sysfs-interface-into-the-leds-bd2802-driver-for-changing-wave-pattern-and-led-current
+++ a/drivers/leds/leds-bd2802.c
@@ -97,6 +97,10 @@ struct bd2802_led {
 	enum led_ids			led_id;
 	enum led_colors			color;
 	enum led_bits			state;
+
+	/* General attributes of RGB LEDs */
+	int				wave_pattern;
+	int				rgb_current;
 };
 
 
@@ -254,7 +258,7 @@ static void bd2802_set_on(struct bd2802_
 		bd2802_reset_cancel(led);
 
 	reg = bd2802_get_reg_addr(id, color, BD2802_REG_CURRENT1SETUP);
-	bd2802_write_byte(led->client, reg, BD2802_CURRENT_032);
+	bd2802_write_byte(led->client, reg, led->rgb_current);
 	reg = bd2802_get_reg_addr(id, color, BD2802_REG_CURRENT2SETUP);
 	bd2802_write_byte(led->client, reg, BD2802_CURRENT_000);
 	reg = bd2802_get_reg_addr(id, color, BD2802_REG_WAVEPATTERN);
@@ -275,9 +279,9 @@ static void bd2802_set_blink(struct bd28
 	reg = bd2802_get_reg_addr(id, color, BD2802_REG_CURRENT1SETUP);
 	bd2802_write_byte(led->client, reg, BD2802_CURRENT_000);
 	reg = bd2802_get_reg_addr(id, color, BD2802_REG_CURRENT2SETUP);
-	bd2802_write_byte(led->client, reg, BD2802_CURRENT_032);
+	bd2802_write_byte(led->client, reg, led->rgb_current);
 	reg = bd2802_get_reg_addr(id, color, BD2802_REG_WAVEPATTERN);
-	bd2802_write_byte(led->client, reg, BD2802_PATTERN_HALF);
+	bd2802_write_byte(led->client, reg, led->wave_pattern);
 
 	bd2802_enable(led, id);
 	bd2802_update_state(led, id, color, BD2802_BLINK);
@@ -406,7 +410,7 @@ static void bd2802_enable_adv_conf(struc
 		ret = device_create_file(&led->client->dev,
 						bd2802_addr_attributes[i]);
 		if (ret) {
-			dev_err(&led->client->dev, "failed to sysfs file %s\n",
+			dev_err(&led->client->dev, "failed: sysfs file %s\n",
 					bd2802_addr_attributes[i]->attr.name);
 			goto failed_remove_files;
 		}
@@ -483,6 +487,52 @@ static struct device_attribute bd2802_ad
 	.store = bd2802_store_adv_conf,
 };
 
+#define BD2802_CONTROL_ATTR(attr_name, name_str)			\
+static ssize_t bd2802_show_##attr_name(struct device *dev,		\
+	struct device_attribute *attr, char *buf)			\
+{									\
+	struct bd2802_led *led = i2c_get_clientdata(to_i2c_client(dev));\
+	ssize_t ret;							\
+	down_read(&led->rwsem);						\
+	ret = sprintf(buf, "0x%02x\n", led->attr_name);			\
+	up_read(&led->rwsem);						\
+	return ret;							\
+}									\
+static ssize_t bd2802_store_##attr_name(struct device *dev,		\
+	struct device_attribute *attr, const char *buf, size_t count)	\
+{									\
+	struct bd2802_led *led = i2c_get_clientdata(to_i2c_client(dev));\
+	unsigned long val;						\
+	int ret;							\
+	if (!count)							\
+		return -EINVAL;						\
+	ret = strict_strtoul(buf, 16, &val);				\
+	if (ret)							\
+		return ret;						\
+	down_write(&led->rwsem);					\
+	led->attr_name = val;						\
+	up_write(&led->rwsem);						\
+	return count;							\
+}									\
+static struct device_attribute bd2802_##attr_name##_attr = {		\
+	.attr = {							\
+		.name = name_str,					\
+		.mode = 0644,						\
+		.owner = THIS_MODULE					\
+	},								\
+	.show = bd2802_show_##attr_name,				\
+	.store = bd2802_store_##attr_name,				\
+};
+
+BD2802_CONTROL_ATTR(wave_pattern, "wave_pattern");
+BD2802_CONTROL_ATTR(rgb_current, "rgb_current");
+
+static struct device_attribute *bd2802_attributes[] = {
+	&bd2802_adv_conf_attr,
+	&bd2802_wave_pattern_attr,
+	&bd2802_rgb_current_attr,
+};
+
 static void bd2802_led_work(struct work_struct *work)
 {
 	struct bd2802_led *led = container_of(work, struct bd2802_led, work);
@@ -635,7 +685,7 @@ static int __devinit bd2802_probe(struct
 {
 	struct bd2802_led *led;
 	struct bd2802_led_platform_data *pdata;
-	int ret;
+	int ret, i;
 
 	led = kzalloc(sizeof(struct bd2802_led), GFP_KERNEL);
 	if (!led) {
@@ -665,13 +715,20 @@ static int __devinit bd2802_probe(struct
 	/* To save the power, reset BD2802 after detecting */
 	gpio_set_value(led->pdata->reset_gpio, 0);
 
+	/* Default attributes */
+	led->wave_pattern = BD2802_PATTERN_HALF;
+	led->rgb_current = BD2802_CURRENT_032;
+
 	init_rwsem(&led->rwsem);
 
-	ret = device_create_file(&client->dev, &bd2802_adv_conf_attr);
-	if (ret) {
-		dev_err(&client->dev, "failed to create sysfs file %s\n",
-					bd2802_adv_conf_attr.attr.name);
-		goto failed_free;
+	for (i = 0; i < ARRAY_SIZE(bd2802_attributes); i++) {
+		ret = device_create_file(&led->client->dev,
+						bd2802_attributes[i]);
+		if (ret) {
+			dev_err(&led->client->dev, "failed: sysfs file %s\n",
+					bd2802_attributes[i]->attr.name);
+			goto failed_unregister_dev_file;
+		}
 	}
 
 	ret = bd2802_register_led_classdev(led);
@@ -681,7 +738,8 @@ static int __devinit bd2802_probe(struct
 	return 0;
 
 failed_unregister_dev_file:
-	device_remove_file(&client->dev, &bd2802_adv_conf_attr);
+	for (i--; i >= 0; i--)
+		device_remove_file(&led->client->dev, bd2802_attributes[i]);
 failed_free:
 	i2c_set_clientdata(client, NULL);
 	kfree(led);
@@ -692,12 +750,14 @@ failed_free:
 static int __exit bd2802_remove(struct i2c_client *client)
 {
 	struct bd2802_led *led = i2c_get_clientdata(client);
+	int i;
 
-	bd2802_unregister_led_classdev(led);
 	gpio_set_value(led->pdata->reset_gpio, 0);
+	bd2802_unregister_led_classdev(led);
 	if (led->adf_on)
 		bd2802_disable_adv_conf(led);
-	device_remove_file(&client->dev, &bd2802_adv_conf_attr);
+	for (i = 0; i < ARRAY_SIZE(bd2802_attributes); i++)
+		device_remove_file(&led->client->dev, bd2802_attributes[i]);
 	i2c_set_clientdata(client, NULL);
 	kfree(led);
 
_

Patches currently in -mm which might be from chammoru@gmail.com are

leds-fix-led-bd2802-errors-while-resuming.patch
leds-change-the-license-information.patch
leds-add-the-sysfs-interface-into-the-leds-bd2802-driver-for-changing-wave-pattern-and-led-current.patch

