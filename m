From: akpm@linux-foundation.org
Subject: [folded] leds-add-bd2802gu-led-driver-update.patch removed from -mm tree
Date: Wed, 04 Mar 2009 11:46:50 -0800
Message-ID: <200903041946.n24JkolX027091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755022AbZCDTrG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 14:47:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chammoru@gmail.com, kyungmin.park@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds-add-bd2802gu-led-driver-update
has been removed from the -mm tree.  Its filename was
     leds-add-bd2802gu-led-driver-update.patch

This patch was dropped because it was folded into leds-add-bd2802gu-led-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds-add-bd2802gu-led-driver-update
From: Kim Kyuwon <chammoru@gmail.com>

Signed-off-by: Kim Kyuwon <chammoru@gmail.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-bd2802.c  |  114 +++++++++++++++++-----------------
 include/linux/leds-bd2802.h |    6 -
 2 files changed, 60 insertions(+), 60 deletions(-)

diff -puN drivers/leds/leds-bd2802.c~leds-add-bd2802gu-led-driver-update drivers/leds/leds-bd2802.c
--- a/drivers/leds/leds-bd2802.c~leds-add-bd2802gu-led-driver-update
+++ a/drivers/leds/leds-bd2802.c
@@ -20,13 +20,13 @@
 #include <linux/leds-bd2802.h>
 
 
-#define LED_CTL(rgb2en, rgb1en) ((rgb2en) << 4 | (rgb1en << 0))
+#define LED_CTL(rgb2en, rgb1en) ((rgb2en) << 4 | ((rgb1en) << 0))
 
 #define BD2802_LED_OFFSET		0xa
 #define BD2802_COLOR_OFFSET		0x3
 
-#define BD2802_REG_CLKSETUP		0x00
-#define BD2802_REG_CONTROL		0x01
+#define BD2802_REG_CLKSETUP 		0x00
+#define BD2802_REG_CONTROL 		0x01
 #define BD2802_REG_HOURSETUP		0x02
 #define BD2802_REG_CURRENT1SETUP	0x03
 #define BD2802_REG_CURRENT2SETUP	0x04
@@ -68,40 +68,40 @@ struct led_state {
 };
 
 struct bd2802_led {
-	struct bd2802_led_platform_data *pdata;
-	struct i2c_client *client;
-	struct rw_semaphore rwsem;
-	struct work_struct work;
+	struct bd2802_led_platform_data	*pdata;
+	struct i2c_client		*client;
+	struct rw_semaphore		rwsem;
+	struct work_struct		work;
 
-	struct led_state led[2];
+	struct led_state		led[2];
 
 	/*
-	* Making led_classdev as array is not recommended, because array
-	* members prevent using 'container_of' macro. So repetitive works
-	* are needed.
-	*/
-	struct led_classdev cdev_led1r;
-	struct led_classdev cdev_led1g;
-	struct led_classdev cdev_led1b;
-	struct led_classdev cdev_led2r;
-	struct led_classdev cdev_led2g;
-	struct led_classdev cdev_led2b;
+	 * Making led_classdev as array is not recommended, because array
+	 * members prevent using 'container_of' macro. So repetitive works
+	 * are needed.
+	 */
+	struct led_classdev		cdev_led1r;
+	struct led_classdev		cdev_led1g;
+	struct led_classdev		cdev_led1b;
+	struct led_classdev		cdev_led2r;
+	struct led_classdev		cdev_led2g;
+	struct led_classdev		cdev_led2b;
 
 	/*
-	* Advanced Configuration Function(ADF) mode:
-	* In ADF mode, user can set registers of BD2802GU directly,
-	* therefore BD2802GU doesn't enter reset state.
-	*/
-	int adf_on;
-
-	enum led_ids led_id;
-	enum led_colors color;
-	enum led_bits state;
+	 * Advanced Configuration Function(ADF) mode:
+	 * In ADF mode, user can set registers of BD2802GU directly,
+	 * therefore BD2802GU doesn't enter reset state.
+	 */
+	int 				adf_on;
+
+	enum led_ids			led_id;
+	enum led_colors			color;
+	enum led_bits			state;
 };
 
 
 /*--------------------------------------------------------------*/
-/*     BD2802GU helper functions					*/
+/*	BD2802GU helper functions					*/
 /*--------------------------------------------------------------*/
 
 static inline int bd2802_is_rgb_off(struct bd2802_led *led, enum led_ids id,
@@ -152,7 +152,7 @@ static inline u8 bd2802_get_reg_addr(enu
 
 
 /*--------------------------------------------------------------*/
-/*     BD2802GU core functions				 */
+/*	BD2802GU core functions					*/
 /*--------------------------------------------------------------*/
 
 static int bd2802_write_byte(struct i2c_client *client, u8 reg, u8 val)
@@ -205,9 +205,9 @@ static void bd2802_update_state(struct b
 	}
 
 	/*
-	* In this case, other led is turned on, and current led is turned
-	* off. So set RGB LED Control register to stop the current RGB LED
-	*/
+	 * In this case, other led is turned on, and current led is turned
+	 * off. So set RGB LED Control register to stop the current RGB LED
+	 */
 	value = (id == LED1) ? LED_CTL(1, 0) : LED_CTL(0, 1);
 	bd2802_write_byte(led->client, BD2802_REG_CONTROL, value);
 }
@@ -283,7 +283,7 @@ static void bd2802_set_blink(struct bd28
 	bd2802_update_state(led, id, color, BD2802_BLINK);
 }
 
-static inline void bd2802_turn_on(struct bd2802_led *led, enum led_ids id,
+static void bd2802_turn_on(struct bd2802_led *led, enum led_ids id,
 				enum led_colors color, enum led_bits led_bit)
 {
 	if (led_bit == BD2802_OFF) {
@@ -328,26 +328,26 @@ static void bd2802_restore_state(struct 
 	}
 }
 
-#define BD2802_SET_REGISTER(reg_addr, reg_name)			\
-static ssize_t bd2802_store_reg##reg_addr(struct device *dev,	  \
-	struct device_attribute *attr, const char *buf, size_t count)   \
-{								      \
+#define BD2802_SET_REGISTER(reg_addr, reg_name)				\
+static ssize_t bd2802_store_reg##reg_addr(struct device *dev,		\
+	struct device_attribute *attr, const char *buf, size_t count)	\
+{									\
 	struct bd2802_led *led = i2c_get_clientdata(to_i2c_client(dev));\
-	unsigned long val;					      \
+	unsigned long val;						\
 	int ret;							\
-	if (!count)						     \
-		return -EINVAL;					 \
-	ret = strict_strtoul(buf, 16, &val);			    \
+	if (!count)							\
+		return -EINVAL;						\
+	ret = strict_strtoul(buf, 16, &val);				\
 	if (ret)							\
-		return ret;					     \
+		return ret;						\
 	down_write(&led->rwsem);					\
-	bd2802_write_byte(led->client, reg_addr, (u8) val);	     \
-	up_write(&led->rwsem);					  \
-	return count;						   \
-}								      \
-static struct device_attribute bd2802_reg##reg_addr##_attr = {	 \
-	.attr = {.name = reg_name, .mode = 0644, .owner = THIS_MODULE}, \
-	.store = bd2802_store_reg##reg_addr,			    \
+	bd2802_write_byte(led->client, reg_addr, (u8) val);		\
+	up_write(&led->rwsem);						\
+	return count;							\
+}									\
+static struct device_attribute bd2802_reg##reg_addr##_attr = {		\
+	.attr = {.name = reg_name, .mode = 0644, .owner = THIS_MODULE},	\
+	.store = bd2802_store_reg##reg_addr,				\
 };
 
 BD2802_SET_REGISTER(0x00, "0x00");
@@ -497,12 +497,12 @@ static void bd2802_led_work(struct work_
 static void bd2802_set_##name##_brightness(struct led_classdev *led_cdev,\
 					enum led_brightness value)	\
 {									\
-	struct bd2802_led *led =						\
+	struct bd2802_led *led =					\
 		container_of(led_cdev, struct bd2802_led, cdev_##name);	\
 	led->led_id = id;						\
 	led->color = clr;						\
 	if (value == LED_OFF)						\
-		led->state = BD2802_OFF;					\
+		led->state = BD2802_OFF;				\
 	else								\
 		led->state = BD2802_ON;					\
 	schedule_work(&led->work);					\
@@ -510,7 +510,7 @@ static void bd2802_set_##name##_brightne
 static int bd2802_set_##name##_blink(struct led_classdev *led_cdev,	\
 		unsigned long *delay_on, unsigned long *delay_off)	\
 {									\
-	struct bd2802_led *led =						\
+	struct bd2802_led *led =					\
 		container_of(led_cdev, struct bd2802_led, cdev_##name);	\
 	if (*delay_on == 0 || *delay_off == 0)				\
 		return -EINVAL;						\
@@ -738,13 +738,13 @@ static const struct i2c_device_id bd2802
 MODULE_DEVICE_TABLE(i2c, bd2802_id);
 
 static struct i2c_driver bd2802_i2c_driver = {
-	.driver = {
-		.name   = "BD2802",
+	.driver	= {
+		.name	= "BD2802",
 	},
-	.probe	  = bd2802_probe,
-	.remove	 = __exit_p(bd2802_remove),
+	.probe		= bd2802_probe,
+	.remove		= __exit_p(bd2802_remove),
 	.suspend	= bd2802_suspend,
-	.resume	 = bd2802_resume,
+	.resume		= bd2802_resume,
 	.id_table	= bd2802_id,
 };
 
diff -puN include/linux/leds-bd2802.h~leds-add-bd2802gu-led-driver-update include/linux/leds-bd2802.h
--- a/include/linux/leds-bd2802.h~leds-add-bd2802gu-led-driver-update
+++ a/include/linux/leds-bd2802.h
@@ -15,12 +15,12 @@
 #define _LEDS_BD2802_H_
 
 struct bd2802_led_platform_data{
-       int     reset_gpio;
-       u8      rgb_time;
+	int	reset_gpio;
+	u8	rgb_time;
 };
 
 #define RGB_TIME(slopedown, slopeup, waveform) \
-       ((slopedown) << 6 | ((slopeup) << 4) | (waveform))
+	((slopedown) << 6 | (slopeup) << 4 | (waveform))
 
 #endif /* _LEDS_BD2802_H_ */
 
_

Patches currently in -mm which might be from chammoru@gmail.com are

leds-add-bd2802gu-led-driver.patch
leds-add-bd2802gu-led-driver-update.patch

