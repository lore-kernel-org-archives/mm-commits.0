From: akpm@linux-foundation.org
Subject: + leds-lp5523-fix-circular-locking.patch added to -mm tree
Date: Tue, 04 Jan 2011 13:45:55 -0800
Message-ID: <201101042145.p04Lju96025907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980Ab1ADVqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 16:46:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, arun.murthy@stericsson.com, ilkka.koskinen@nokia.com, rpurdie@rpsys.net


The patch titled
     leds: lp5523: fix circular locking
has been added to the -mm tree.  Its filename is
     leds-lp5523-fix-circular-locking.patch

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
Subject: leds: lp5523: fix circular locking
From: Samu Onkalo <samu.p.onkalo@nokia.com>

Driver contained possibility for circular locking.
One lock is held by sysfs-core and another one by the driver itself.
This happened when the driver created or removed sysfs entries dynamically.
There is no real need to do those operations. Now all the sysfs entries
are created at probe and removed at removal. Engine load and mux configuration
sysfs entries are now visible all the time. However, access to the entries
fails if the engine is disabled or running.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Arun Murthy <arun.murthy@stericsson.com>
Reviewed-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5523.c |   56 ++++++++++-------------------------
 1 file changed, 16 insertions(+), 40 deletions(-)

diff -puN drivers/leds/leds-lp5523.c~leds-lp5523-fix-circular-locking drivers/leds/leds-lp5523.c
--- a/drivers/leds/leds-lp5523.c~leds-lp5523-fix-circular-locking
+++ a/drivers/leds/leds-lp5523.c
@@ -105,7 +105,6 @@
 #define SHIFT_MASK(id)			(((id) - 1) * 2)
 
 struct lp5523_engine {
-	const struct attribute_group *attributes;
 	int		id;
 	u8		mode;
 	u8		prog_page;
@@ -403,14 +402,23 @@ static ssize_t store_engine_leds(struct 
 	struct i2c_client *client = to_i2c_client(dev);
 	struct lp5523_chip *chip = i2c_get_clientdata(client);
 	u16 mux = 0;
+	ssize_t ret;
 
 	if (lp5523_mux_parse(buf, &mux, len))
 		return -EINVAL;
 
+	mutex_lock(&chip->lock);
+	ret = -EINVAL;
+	if (chip->engines[nr - 1].mode != LP5523_CMD_LOAD)
+		goto leave;
+
 	if (lp5523_load_mux(&chip->engines[nr - 1], mux))
-		return -EINVAL;
+		goto leave;
 
-	return len;
+	ret = len;
+leave:
+	mutex_unlock(&chip->lock);
+	return ret;
 }
 
 #define store_leds(nr)						\
@@ -556,7 +564,11 @@ static int lp5523_do_store_load(struct l
 
 	mutex_lock(&chip->lock);
 
-	ret = lp5523_load_program(engine, pattern);
+	if (engine->mode == LP5523_CMD_LOAD)
+		ret = lp5523_load_program(engine, pattern);
+	else
+		ret = -EINVAL;
+
 	mutex_unlock(&chip->lock);
 
 	if (ret) {
@@ -737,37 +749,18 @@ static struct attribute *lp5523_attribut
 	&dev_attr_engine2_mode.attr,
 	&dev_attr_engine3_mode.attr,
 	&dev_attr_selftest.attr,
-	NULL
-};
-
-static struct attribute *lp5523_engine1_attributes[] = {
 	&dev_attr_engine1_load.attr,
 	&dev_attr_engine1_leds.attr,
-	NULL
-};
-
-static struct attribute *lp5523_engine2_attributes[] = {
 	&dev_attr_engine2_load.attr,
 	&dev_attr_engine2_leds.attr,
-	NULL
-};
-
-static struct attribute *lp5523_engine3_attributes[] = {
 	&dev_attr_engine3_load.attr,
 	&dev_attr_engine3_leds.attr,
-	NULL
 };
 
 static const struct attribute_group lp5523_group = {
 	.attrs = lp5523_attributes,
 };
 
-static const struct attribute_group lp5523_engine_group[] = {
-	{.attrs = lp5523_engine1_attributes },
-	{.attrs = lp5523_engine2_attributes },
-	{.attrs = lp5523_engine3_attributes },
-};
-
 static int lp5523_register_sysfs(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
@@ -788,10 +781,6 @@ static void lp5523_unregister_sysfs(stru
 
 	sysfs_remove_group(&dev->kobj, &lp5523_group);
 
-	for (i = 0; i < ARRAY_SIZE(chip->engines); i++)
-		if (chip->engines[i].mode == LP5523_CMD_LOAD)
-			sysfs_remove_group(&dev->kobj, &lp5523_engine_group[i]);
-
 	for (i = 0; i < chip->num_leds; i++)
 		sysfs_remove_group(&chip->leds[i].cdev.dev->kobj,
 				&lp5523_led_attribute_group);
@@ -802,10 +791,6 @@ static void lp5523_unregister_sysfs(stru
 /*--------------------------------------------------------------*/
 static int lp5523_set_mode(struct lp5523_engine *engine, u8 mode)
 {
-	/*  engine to chip */
-	struct lp5523_chip *chip = engine_to_lp5523(engine);
-	struct i2c_client *client = chip->client;
-	struct device *dev = &client->dev;
 	int ret = 0;
 
 	/* if in that mode already do nothing, except for run */
@@ -817,18 +802,10 @@ static int lp5523_set_mode(struct lp5523
 	} else if (mode == LP5523_CMD_LOAD) {
 		lp5523_set_engine_mode(engine, LP5523_CMD_DISABLED);
 		lp5523_set_engine_mode(engine, LP5523_CMD_LOAD);
-
-		ret = sysfs_create_group(&dev->kobj, engine->attributes);
-		if (ret)
-			return ret;
 	} else if (mode == LP5523_CMD_DISABLED) {
 		lp5523_set_engine_mode(engine, LP5523_CMD_DISABLED);
 	}
 
-	/* remove load attribute from sysfs if not in load mode */
-	if (engine->mode == LP5523_CMD_LOAD && mode != LP5523_CMD_LOAD)
-		sysfs_remove_group(&dev->kobj, engine->attributes);
