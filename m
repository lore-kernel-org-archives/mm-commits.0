From: akpm@linux-foundation.org
Subject: + backlight-use-dev_get_platdata.patch added to -mm tree
Date: Wed, 18 Sep 2013 15:41:29 -0700
Message-ID: <523a2c19.0X21l8BuVukZaOXi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab3IRWla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 18:41:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + backlight-use-dev_get_platdata.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 15:41:29 -0700


The patch titled
     Subject: backlight: use dev_get_platdata()
has been added to the -mm tree.  Its filename is
     backlight-use-dev_get_platdata.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-use-dev_get_platdata.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-use-dev_get_platdata.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: use dev_get_platdata()

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/88pm860x_bl.c        |    2 +-
 drivers/video/backlight/aat2870_bl.c         |    2 +-
 drivers/video/backlight/adp5520_bl.c         |    2 +-
 drivers/video/backlight/adp8860_bl.c         |    6 +++---
 drivers/video/backlight/adp8870_bl.c         |    6 +++---
 drivers/video/backlight/ams369fg06.c         |    2 +-
 drivers/video/backlight/atmel-pwm-bl.c       |    2 +-
 drivers/video/backlight/bd6107.c             |    2 +-
 drivers/video/backlight/corgi_lcd.c          |    2 +-
 drivers/video/backlight/da903x_bl.c          |    2 +-
 drivers/video/backlight/generic_bl.c         |    2 +-
 drivers/video/backlight/gpio_backlight.c     |    3 ++-
 drivers/video/backlight/ili9320.c            |    2 +-
 drivers/video/backlight/kb3886_bl.c          |    2 +-
 drivers/video/backlight/l4f00242t03.c        |    6 +++---
 drivers/video/backlight/ld9040.c             |    2 +-
 drivers/video/backlight/lm3533_bl.c          |    2 +-
 drivers/video/backlight/lm3630a_bl.c         |    2 +-
 drivers/video/backlight/lm3639_bl.c          |    2 +-
 drivers/video/backlight/lms283gf05.c         |    4 ++--
 drivers/video/backlight/lms501kf03.c         |    2 +-
 drivers/video/backlight/lp855x_bl.c          |    4 ++--
 drivers/video/backlight/lv5207lp.c           |    2 +-
 drivers/video/backlight/omap1_bl.c           |    2 +-
 drivers/video/backlight/pcf50633-backlight.c |    2 +-
 drivers/video/backlight/platform_lcd.c       |    2 +-
 drivers/video/backlight/pwm_bl.c             |    2 +-
 drivers/video/backlight/s6e63m0.c            |    2 +-
 drivers/video/backlight/tdo24m.c             |    2 +-
 drivers/video/backlight/tosa_bl.c            |    2 +-
 drivers/video/backlight/tps65217_bl.c        |    5 ++---
 drivers/video/backlight/wm831x_bl.c          |    8 +++-----
 32 files changed, 44 insertions(+), 46 deletions(-)

diff -puN drivers/video/backlight/88pm860x_bl.c~backlight-use-dev_get_platdata drivers/video/backlight/88pm860x_bl.c
--- a/drivers/video/backlight/88pm860x_bl.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/88pm860x_bl.c
@@ -196,7 +196,7 @@ static int pm860x_backlight_dt_init(stru
 static int pm860x_backlight_probe(struct platform_device *pdev)
 {
 	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
-	struct pm860x_backlight_pdata *pdata = pdev->dev.platform_data;
+	struct pm860x_backlight_pdata *pdata = dev_get_platdata(&pdev->dev);
 	struct pm860x_backlight_data *data;
 	struct backlight_device *bl;
 	struct resource *res;
diff -puN drivers/video/backlight/aat2870_bl.c~backlight-use-dev_get_platdata drivers/video/backlight/aat2870_bl.c
--- a/drivers/video/backlight/aat2870_bl.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/aat2870_bl.c
@@ -127,7 +127,7 @@ static const struct backlight_ops aat287
 
 static int aat2870_bl_probe(struct platform_device *pdev)
 {
-	struct aat2870_bl_platform_data *pdata = pdev->dev.platform_data;
+	struct aat2870_bl_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct aat2870_bl_driver_data *aat2870_bl;
 	struct backlight_device *bd;
 	struct backlight_properties props;
diff -puN drivers/video/backlight/adp5520_bl.c~backlight-use-dev_get_platdata drivers/video/backlight/adp5520_bl.c
--- a/drivers/video/backlight/adp5520_bl.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/adp5520_bl.c
@@ -297,7 +297,7 @@ static int adp5520_bl_probe(struct platf
 		return -ENOMEM;
 
 	data->master = pdev->dev.parent;
-	data->pdata = pdev->dev.platform_data;
+	data->pdata = dev_get_platdata(&pdev->dev);
 
 	if (data->pdata  == NULL) {
 		dev_err(&pdev->dev, "missing platform data\n");
diff -puN drivers/video/backlight/adp8860_bl.c~backlight-use-dev_get_platdata drivers/video/backlight/adp8860_bl.c
--- a/drivers/video/backlight/adp8860_bl.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/adp8860_bl.c
@@ -216,7 +216,7 @@ static int adp8860_led_setup(struct adp8
 static int adp8860_led_probe(struct i2c_client *client)
 {
 	struct adp8860_backlight_platform_data *pdata =
-		client->dev.platform_data;
+		dev_get_platdata(&client->dev);
 	struct adp8860_bl *data = i2c_get_clientdata(client);
 	struct adp8860_led *led, *led_dat;
 	struct led_info *cur_led;
@@ -300,7 +300,7 @@ static int adp8860_led_probe(struct i2c_
 static int adp8860_led_remove(struct i2c_client *client)
 {
 	struct adp8860_backlight_platform_data *pdata =
-		client->dev.platform_data;
+		dev_get_platdata(&client->dev);
 	struct adp8860_bl *data = i2c_get_clientdata(client);
 	int i;
 
@@ -658,7 +658,7 @@ static int adp8860_probe(struct i2c_clie
 	struct backlight_device *bl;
 	struct adp8860_bl *data;
 	struct adp8860_backlight_platform_data *pdata =
-		client->dev.platform_data;
+		dev_get_platdata(&client->dev);
 	struct backlight_properties props;
 	uint8_t reg_val;
 	int ret;
diff -puN drivers/video/backlight/adp8870_bl.c~backlight-use-dev_get_platdata drivers/video/backlight/adp8870_bl.c
--- a/drivers/video/backlight/adp8870_bl.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/adp8870_bl.c
@@ -238,7 +238,7 @@ static int adp8870_led_setup(struct adp8
 static int adp8870_led_probe(struct i2c_client *client)
 {
 	struct adp8870_backlight_platform_data *pdata =
-		client->dev.platform_data;
+		dev_get_platdata(&client->dev);
 	struct adp8870_bl *data = i2c_get_clientdata(client);
 	struct adp8870_led *led, *led_dat;
 	struct led_info *cur_led;
@@ -325,7 +325,7 @@ static int adp8870_led_probe(struct i2c_
 static int adp8870_led_remove(struct i2c_client *client)
 {
 	struct adp8870_backlight_platform_data *pdata =
-		client->dev.platform_data;
+		dev_get_platdata(&client->dev);
 	struct adp8870_bl *data = i2c_get_clientdata(client);
 	int i;
 
@@ -848,7 +848,7 @@ static int adp8870_probe(struct i2c_clie
 	struct backlight_device *bl;
 	struct adp8870_bl *data;
 	struct adp8870_backlight_platform_data *pdata =
-		client->dev.platform_data;
+		dev_get_platdata(&client->dev);
 	uint8_t reg_val;
 	int ret;
 
diff -puN drivers/video/backlight/ams369fg06.c~backlight-use-dev_get_platdata drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/ams369fg06.c
@@ -471,7 +471,7 @@ static int ams369fg06_probe(struct spi_d
 	lcd->spi = spi;
 	lcd->dev = &spi->dev;
 
-	lcd->lcd_pd = spi->dev.platform_data;
+	lcd->lcd_pd = dev_get_platdata(&spi->dev);
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL\n");
 		return -EINVAL;
diff -puN drivers/video/backlight/atmel-pwm-bl.c~backlight-use-dev_get_platdata drivers/video/backlight/atmel-pwm-bl.c
--- a/drivers/video/backlight/atmel-pwm-bl.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/atmel-pwm-bl.c
@@ -133,7 +133,7 @@ static int __init atmel_pwm_bl_probe(str
 
 	pwmbl->pdev = pdev;
 
-	pdata = pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
 	if (!pdata) {
 		retval = -ENODEV;
 		goto err_free_mem;
diff -puN drivers/video/backlight/bd6107.c~backlight-use-dev_get_platdata drivers/video/backlight/bd6107.c
--- a/drivers/video/backlight/bd6107.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/bd6107.c
@@ -128,7 +128,7 @@ static const struct backlight_ops bd6107
 static int bd6107_probe(struct i2c_client *client,
 			  const struct i2c_device_id *id)
 {
-	struct bd6107_platform_data *pdata = client->dev.platform_data;
+	struct bd6107_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct backlight_device *backlight;
 	struct backlight_properties props;
 	struct bd6107 *bd;
diff -puN drivers/video/backlight/corgi_lcd.c~backlight-use-dev_get_platdata drivers/video/backlight/corgi_lcd.c
--- a/drivers/video/backlight/corgi_lcd.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/corgi_lcd.c
@@ -533,7 +533,7 @@ static int setup_gpio_backlight(struct c
 static int corgi_lcd_probe(struct spi_device *spi)
 {
 	struct backlight_properties props;
-	struct corgi_lcd_platform_data *pdata = spi->dev.platform_data;
+	struct corgi_lcd_platform_data *pdata = dev_get_platdata(&spi->dev);
 	struct corgi_lcd *lcd;
 	int ret = 0;
 
diff -puN drivers/video/backlight/da903x_bl.c~backlight-use-dev_get_platdata drivers/video/backlight/da903x_bl.c
--- a/drivers/video/backlight/da903x_bl.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/da903x_bl.c
@@ -109,7 +109,7 @@ static const struct backlight_ops da903x
 
 static int da903x_backlight_probe(struct platform_device *pdev)
 {
-	struct da9034_backlight_pdata *pdata = pdev->dev.platform_data;
+	struct da9034_backlight_pdata *pdata = dev_get_platdata(&pdev->dev);
 	struct da903x_backlight_data *data;
 	struct backlight_device *bl;
 	struct backlight_properties props;
diff -puN drivers/video/backlight/generic_bl.c~backlight-use-dev_get_platdata drivers/video/backlight/generic_bl.c
--- a/drivers/video/backlight/generic_bl.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/generic_bl.c
@@ -79,7 +79,7 @@ static const struct backlight_ops generi
 static int genericbl_probe(struct platform_device *pdev)
 {
 	struct backlight_properties props;
-	struct generic_bl_info *machinfo = pdev->dev.platform_data;
+	struct generic_bl_info *machinfo = dev_get_platdata(&pdev->dev);
 	const char *name = "generic-bl";
 	struct backlight_device *bd;
 
diff -puN drivers/video/backlight/gpio_backlight.c~backlight-use-dev_get_platdata drivers/video/backlight/gpio_backlight.c
--- a/drivers/video/backlight/gpio_backlight.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/gpio_backlight.c
@@ -62,7 +62,8 @@ static const struct backlight_ops gpio_b
 
 static int gpio_backlight_probe(struct platform_device *pdev)
 {
-	struct gpio_backlight_platform_data *pdata = pdev->dev.platform_data;
+	struct gpio_backlight_platform_data *pdata =
+		dev_get_platdata(&pdev->dev);
 	struct backlight_properties props;
 	struct backlight_device *bl;
 	struct gpio_backlight *gbl;
diff -puN drivers/video/backlight/ili9320.c~backlight-use-dev_get_platdata drivers/video/backlight/ili9320.c
--- a/drivers/video/backlight/ili9320.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/ili9320.c
@@ -198,7 +198,7 @@ static void ili9320_setup_spi(struct ili
 int ili9320_probe_spi(struct spi_device *spi,
 				struct ili9320_client *client)
 {
-	struct ili9320_platdata *cfg = spi->dev.platform_data;
+	struct ili9320_platdata *cfg = dev_get_platdata(&spi->dev);
 	struct device *dev = &spi->dev;
 	struct ili9320 *ili;
 	struct lcd_device *lcd;
diff -puN drivers/video/backlight/kb3886_bl.c~backlight-use-dev_get_platdata drivers/video/backlight/kb3886_bl.c
--- a/drivers/video/backlight/kb3886_bl.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/kb3886_bl.c
@@ -141,7 +141,7 @@ static const struct backlight_ops kb3886
 static int kb3886bl_probe(struct platform_device *pdev)
 {
 	struct backlight_properties props;
-	struct kb3886bl_machinfo *machinfo = pdev->dev.platform_data;
+	struct kb3886bl_machinfo *machinfo = dev_get_platdata(&pdev->dev);
 
 	bl_machinfo = machinfo;
 	if (!machinfo->limit_mask)
diff -puN drivers/video/backlight/l4f00242t03.c~backlight-use-dev_get_platdata drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -48,7 +48,7 @@ static void l4f00242t03_reset(unsigned i
 
 static void l4f00242t03_lcd_init(struct spi_device *spi)
 {
-	struct l4f00242t03_pdata *pdata = spi->dev.platform_data;
+	struct l4f00242t03_pdata *pdata = dev_get_platdata(&spi->dev);
 	struct l4f00242t03_priv *priv = spi_get_drvdata(spi);
 	const u16 cmd[] = { 0x36, param(0), 0x3A, param(0x60) };
 	int ret;
@@ -88,7 +88,7 @@ static void l4f00242t03_lcd_init(struct
 
 static void l4f00242t03_lcd_powerdown(struct spi_device *spi)
 {
-	struct l4f00242t03_pdata *pdata = spi->dev.platform_data;
+	struct l4f00242t03_pdata *pdata = dev_get_platdata(&spi->dev);
 	struct l4f00242t03_priv *priv = spi_get_drvdata(spi);
 
 	dev_dbg(&spi->dev, "Powering down LCD\n");
@@ -171,7 +171,7 @@ static struct lcd_ops l4f_ops = {
 static int l4f00242t03_probe(struct spi_device *spi)
 {
 	struct l4f00242t03_priv *priv;
-	struct l4f00242t03_pdata *pdata = spi->dev.platform_data;
+	struct l4f00242t03_pdata *pdata = dev_get_platdata(&spi->dev);
 	int ret;
 
 	if (pdata == NULL) {
diff -puN drivers/video/backlight/ld9040.c~backlight-use-dev_get_platdata drivers/video/backlight/ld9040.c
--- a/drivers/video/backlight/ld9040.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/ld9040.c
@@ -702,7 +702,7 @@ static int ld9040_probe(struct spi_devic
 	lcd->spi = spi;
 	lcd->dev = &spi->dev;
 
-	lcd->lcd_pd = spi->dev.platform_data;
+	lcd->lcd_pd = dev_get_platdata(&spi->dev);
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL.\n");
 		return -EINVAL;
diff -puN drivers/video/backlight/lm3533_bl.c~backlight-use-dev_get_platdata drivers/video/backlight/lm3533_bl.c
--- a/drivers/video/backlight/lm3533_bl.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/lm3533_bl.c
@@ -284,7 +284,7 @@ static int lm3533_bl_probe(struct platfo
 	if (!lm3533)
 		return -EINVAL;
 
-	pdata = pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
 	if (!pdata) {
 		dev_err(&pdev->dev, "no platform data\n");
 		return -EINVAL;
diff -puN drivers/video/backlight/lm3630a_bl.c~backlight-use-dev_get_platdata drivers/video/backlight/lm3630a_bl.c
--- a/drivers/video/backlight/lm3630a_bl.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/lm3630a_bl.c
@@ -365,7 +365,7 @@ static const struct regmap_config lm3630
 static int lm3630a_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
-	struct lm3630a_platform_data *pdata = client->dev.platform_data;
+	struct lm3630a_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct lm3630a_chip *pchip;
 	int rval;
 
diff -puN drivers/video/backlight/lm3639_bl.c~backlight-use-dev_get_platdata drivers/video/backlight/lm3639_bl.c
--- a/drivers/video/backlight/lm3639_bl.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/lm3639_bl.c
@@ -307,7 +307,7 @@ static int lm3639_probe(struct i2c_clien
 {
 	int ret;
 	struct lm3639_chip_data *pchip;
-	struct lm3639_platform_data *pdata = client->dev.platform_data;
+	struct lm3639_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct backlight_properties props;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
diff -puN drivers/video/backlight/lms283gf05.c~backlight-use-dev_get_platdata drivers/video/backlight/lms283gf05.c
--- a/drivers/video/backlight/lms283gf05.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/lms283gf05.c
@@ -128,7 +128,7 @@ static int lms283gf05_power_set(struct l
 {
 	struct lms283gf05_state *st = lcd_get_data(ld);
 	struct spi_device *spi = st->spi;
-	struct lms283gf05_pdata *pdata = spi->dev.platform_data;
+	struct lms283gf05_pdata *pdata = dev_get_platdata(&spi->dev);
 
 	if (power <= FB_BLANK_NORMAL) {
 		if (pdata)
@@ -153,7 +153,7 @@ static struct lcd_ops lms_ops = {
 static int lms283gf05_probe(struct spi_device *spi)
 {
 	struct lms283gf05_state *st;
-	struct lms283gf05_pdata *pdata = spi->dev.platform_data;
+	struct lms283gf05_pdata *pdata = dev_get_platdata(&spi->dev);
 	struct lcd_device *ld;
 	int ret = 0;
 
diff -puN drivers/video/backlight/lms501kf03.c~backlight-use-dev_get_platdata drivers/video/backlight/lms501kf03.c
--- a/drivers/video/backlight/lms501kf03.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/lms501kf03.c
@@ -344,7 +344,7 @@ static int lms501kf03_probe(struct spi_d
 	lcd->spi = spi;
 	lcd->dev = &spi->dev;
 
-	lcd->lcd_pd = spi->dev.platform_data;
+	lcd->lcd_pd = dev_get_platdata(&spi->dev);
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL\n");
 		return -EINVAL;
diff -puN drivers/video/backlight/lp855x_bl.c~backlight-use-dev_get_platdata drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -405,7 +405,7 @@ static int lp855x_parse_dt(struct device
 static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 {
 	struct lp855x *lp;
-	struct lp855x_platform_data *pdata = cl->dev.platform_data;
+	struct lp855x_platform_data *pdata = dev_get_platdata(&cl->dev);
 	struct device_node *node = cl->dev.of_node;
 	int ret;
 
@@ -414,7 +414,7 @@ static int lp855x_probe(struct i2c_clien
 		if (ret < 0)
 			return ret;
 
-		pdata = cl->dev.platform_data;
+		pdata = dev_get_platdata(&cl->dev);
 	}
 
 	if (!i2c_check_functionality(cl->adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
diff -puN drivers/video/backlight/lv5207lp.c~backlight-use-dev_get_platdata drivers/video/backlight/lv5207lp.c
--- a/drivers/video/backlight/lv5207lp.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/lv5207lp.c
@@ -93,7 +93,7 @@ static const struct backlight_ops lv5207
 static int lv5207lp_probe(struct i2c_client *client,
 			  const struct i2c_device_id *id)
 {
-	struct lv5207lp_platform_data *pdata = client->dev.platform_data;
+	struct lv5207lp_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct backlight_device *backlight;
 	struct backlight_properties props;
 	struct lv5207lp *lv;
diff -puN drivers/video/backlight/omap1_bl.c~backlight-use-dev_get_platdata drivers/video/backlight/omap1_bl.c
--- a/drivers/video/backlight/omap1_bl.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/omap1_bl.c
@@ -133,7 +133,7 @@ static int omapbl_probe(struct platform_
 	struct backlight_properties props;
 	struct backlight_device *dev;
 	struct omap_backlight *bl;
-	struct omap_backlight_config *pdata = pdev->dev.platform_data;
+	struct omap_backlight_config *pdata = dev_get_platdata(&pdev->dev);
 
 	if (!pdata)
 		return -ENXIO;
diff -puN drivers/video/backlight/pcf50633-backlight.c~backlight-use-dev_get_platdata drivers/video/backlight/pcf50633-backlight.c
--- a/drivers/video/backlight/pcf50633-backlight.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/pcf50633-backlight.c
@@ -103,7 +103,7 @@ static int pcf50633_bl_probe(struct plat
 {
 	struct pcf50633_bl *pcf_bl;
 	struct device *parent = pdev->dev.parent;
-	struct pcf50633_platform_data *pcf50633_data = parent->platform_data;
+	struct pcf50633_platform_data *pcf50633_data = dev_get_platdata(parent);
 	struct pcf50633_bl_platform_data *pdata = pcf50633_data->backlight_data;
 	struct backlight_properties bl_props;
 
diff -puN drivers/video/backlight/platform_lcd.c~backlight-use-dev_get_platdata drivers/video/backlight/platform_lcd.c
--- a/drivers/video/backlight/platform_lcd.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/platform_lcd.c
@@ -80,7 +80,7 @@ static int platform_lcd_probe(struct pla
 	struct device *dev = &pdev->dev;
 	int err;
 
-	pdata = pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
 	if (!pdata) {
 		dev_err(dev, "no platform data supplied\n");
 		return -EINVAL;
diff -puN drivers/video/backlight/pwm_bl.c~backlight-use-dev_get_platdata drivers/video/backlight/pwm_bl.c
--- a/drivers/video/backlight/pwm_bl.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/pwm_bl.c
@@ -163,7 +163,7 @@ static int pwm_backlight_parse_dt(struct
 
 static int pwm_backlight_probe(struct platform_device *pdev)
 {
-	struct platform_pwm_backlight_data *data = pdev->dev.platform_data;
+	struct platform_pwm_backlight_data *data = dev_get_platdata(&pdev->dev);
 	struct platform_pwm_backlight_data defdata;
 	struct backlight_properties props;
 	struct backlight_device *bl;
diff -puN drivers/video/backlight/s6e63m0.c~backlight-use-dev_get_platdata drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/s6e63m0.c
@@ -735,7 +735,7 @@ static int s6e63m0_probe(struct spi_devi
 	lcd->spi = spi;
 	lcd->dev = &spi->dev;
 
-	lcd->lcd_pd = spi->dev.platform_data;
+	lcd->lcd_pd = dev_get_platdata(&spi->dev);
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL.\n");
 		return -EINVAL;
diff -puN drivers/video/backlight/tdo24m.c~backlight-use-dev_get_platdata drivers/video/backlight/tdo24m.c
--- a/drivers/video/backlight/tdo24m.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/tdo24m.c
@@ -338,7 +338,7 @@ static int tdo24m_probe(struct spi_devic
 	enum tdo24m_model model;
 	int err;
 
-	pdata = spi->dev.platform_data;
+	pdata = dev_get_platdata(&spi->dev);
 	if (pdata)
 		model = pdata->model;
 	else
diff -puN drivers/video/backlight/tosa_bl.c~backlight-use-dev_get_platdata drivers/video/backlight/tosa_bl.c
--- a/drivers/video/backlight/tosa_bl.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/tosa_bl.c
@@ -38,7 +38,7 @@ struct tosa_bl_data {
 
 static void tosa_bl_set_backlight(struct tosa_bl_data *data, int brightness)
 {
-	struct spi_device *spi = data->i2c->dev.platform_data;
+	struct spi_device *spi = dev_get_platdata(&data->i2c->dev);
 
 	i2c_smbus_write_byte_data(data->i2c, DAC_CH1, data->comadj);
 
diff -puN drivers/video/backlight/tps65217_bl.c~backlight-use-dev_get_platdata drivers/video/backlight/tps65217_bl.c
--- a/drivers/video/backlight/tps65217_bl.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/tps65217_bl.c
@@ -287,12 +287,11 @@ static int tps65217_bl_probe(struct plat
 		if (IS_ERR(pdata))
 			return PTR_ERR(pdata);
 	} else {
-		if (!pdev->dev.platform_data) {
+		pdata = dev_get_platdata(&pdev->dev);
+		if (!pdata) {
 			dev_err(&pdev->dev, "no platform data provided\n");
 			return -EINVAL;
 		}
-
-		pdata = pdev->dev.platform_data;
 	}
 
 	tps65217_bl = devm_kzalloc(&pdev->dev, sizeof(*tps65217_bl),
diff -puN drivers/video/backlight/wm831x_bl.c~backlight-use-dev_get_platdata drivers/video/backlight/wm831x_bl.c
--- a/drivers/video/backlight/wm831x_bl.c~backlight-use-dev_get_platdata
+++ a/drivers/video/backlight/wm831x_bl.c
@@ -123,7 +123,7 @@ static const struct backlight_ops wm831x
 static int wm831x_backlight_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
-	struct wm831x_pdata *wm831x_pdata;
+	struct wm831x_pdata *wm831x_pdata = dev_get_platdata(pdev->dev.parent);
 	struct wm831x_backlight_pdata *pdata;
 	struct wm831x_backlight_data *data;
 	struct backlight_device *bl;
@@ -131,12 +131,10 @@ static int wm831x_backlight_probe(struct
 	int ret, i, max_isel, isink_reg, dcdc_cfg;
 
 	/* We need platform data */
-	if (pdev->dev.parent->platform_data) {
-		wm831x_pdata = pdev->dev.parent->platform_data;
+	if (wm831x_pdata)
 		pdata = wm831x_pdata->backlight;
-	} else {
+	else
 		pdata = NULL;
-	}
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "No platform data supplied\n");
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
backlight-lp855x_bl-support-new-lp8555-device.patch
backlight-lm3630-apply-chip-revision.patch
backlight-ld9040-staticize-local-variable-gamma_table.patch
backlight-lm3639-dont-mix-different-enum-types.patch
backlight-lp8788-staticize-default_bl_config.patch
backlight-use-dev_get_platdata.patch
w1-w1-gpio-use-dev_get_platdata.patch
w1-ds1wm-use-dev_get_platdata.patch

