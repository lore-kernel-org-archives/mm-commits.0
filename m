From: akpm@linux-foundation.org
Subject: + leds-lp5521-fix-circular-locking.patch added to -mm tree
Date: Tue, 04 Jan 2011 13:45:57 -0800
Message-ID: <201101042145.p04LjvK6025910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014Ab1ADVrJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 16:47:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, arun.murthy@stericsson.com, ilkka.koskinen@nokia.com, rpurdie@rpsys.net


The patch titled
     leds: lp5521: fix circular locking
has been added to the -mm tree.  Its filename is
     leds-lp5521-fix-circular-locking.patch

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
Subject: leds: lp5521: fix circular locking
From: Samu Onkalo <samu.p.onkalo@nokia.com>

Driver contained possibility for circular locking.
One lock is held by sysfs-core and another one by the driver itself.
This happened when the driver created or removed sysfs entries dynamically.
There is no real need to do those operations. Now all the sysfs entries
are created at probe and removed at removal. Engine load sysfs entries are
now visible all the time. However, access to the entries fails if
the engine is disabled or running.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Arun Murthy <arun.murthy@stericsson.com>
Reviewed-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5521.c |   52 +++++------------------------------
 1 file changed, 8 insertions(+), 44 deletions(-)

diff -puN drivers/leds/leds-lp5521.c~leds-lp5521-fix-circular-locking drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~leds-lp5521-fix-circular-locking
+++ a/drivers/leds/leds-lp5521.c
@@ -98,7 +98,6 @@
 #define LP5521_EXT_CLK_USED		0x08
 
 struct lp5521_engine {
-	const struct attribute_group *attributes;
 	int		id;
 	u8		mode;
 	u8		prog_page;
@@ -225,25 +224,22 @@ static int lp5521_set_led_current(struct
 		    curr);
 }
 
-static void lp5521_init_engine(struct lp5521_chip *chip,
-			const struct attribute_group *attr_group)
+static void lp5521_init_engine(struct lp5521_chip *chip)
 {
 	int i;
 	for (i = 0; i < ARRAY_SIZE(chip->engines); i++) {
 		chip->engines[i].id = i + 1;
 		chip->engines[i].engine_mask = LP5521_ENG_MASK_BASE >> (i * 2);
 		chip->engines[i].prog_page = i;
-		chip->engines[i].attributes = &attr_group[i];
 	}
 }
 
-static int lp5521_configure(struct i2c_client *client,
-			const struct attribute_group *attr_group)
+static int lp5521_configure(struct i2c_client *client)
 {
 	struct lp5521_chip *chip = i2c_get_clientdata(client);
 	int ret;
 
-	lp5521_init_engine(chip, attr_group);
+	lp5521_init_engine(chip);
 
 	/* Set all PWMs to direct control mode */
 	ret = lp5521_write(client, LP5521_REG_OP_MODE, 0x3F);
@@ -329,9 +325,6 @@ static int lp5521_detect(struct i2c_clie
 /* Set engine mode and create appropriate sysfs attributes, if required. */
 static int lp5521_set_mode(struct lp5521_engine *engine, u8 mode)
 {
-	struct lp5521_chip *chip = engine_to_lp5521(engine);
-	struct i2c_client *client = chip->client;
-	struct device *dev = &client->dev;
 	int ret = 0;
 
 	/* if in that mode already do nothing, except for run */
@@ -343,18 +336,10 @@ static int lp5521_set_mode(struct lp5521
 	} else if (mode == LP5521_CMD_LOAD) {
 		lp5521_set_engine_mode(engine, LP5521_CMD_DISABLED);
 		lp5521_set_engine_mode(engine, LP5521_CMD_LOAD);
-
-		ret = sysfs_create_group(&dev->kobj, engine->attributes);
-		if (ret)
-			return ret;
 	} else if (mode == LP5521_CMD_DISABLED) {
 		lp5521_set_engine_mode(engine, LP5521_CMD_DISABLED);
 	}
 
-	/* remove load attribute from sysfs if not in load mode */
-	if (engine->mode == LP5521_CMD_LOAD && mode != LP5521_CMD_LOAD)
-		sysfs_remove_group(&dev->kobj, engine->attributes);
-
 	engine->mode = mode;
 
 	return ret;
@@ -389,7 +374,10 @@ static int lp5521_do_store_load(struct l
 		goto fail;
 
 	mutex_lock(&chip->lock);
-	ret = lp5521_load_program(engine, pattern);
+	if (engine->mode == LP5521_CMD_LOAD)
+		ret = lp5521_load_program(engine, pattern);
+	else
+		ret = -EINVAL;
 	mutex_unlock(&chip->lock);
 
 	if (ret) {
@@ -576,20 +564,8 @@ static struct attribute *lp5521_attribut
 	&dev_attr_engine2_mode.attr,
 	&dev_attr_engine3_mode.attr,
 	&dev_attr_selftest.attr,
-	NULL
-};
-
-static struct attribute *lp5521_engine1_attributes[] = {
 	&dev_attr_engine1_load.attr,
-	NULL
-};
-
-static struct attribute *lp5521_engine2_attributes[] = {
 	&dev_attr_engine2_load.attr,
-	NULL
-};
-
-static struct attribute *lp5521_engine3_attributes[] = {
 	&dev_attr_engine3_load.attr,
 	NULL
 };
@@ -598,12 +574,6 @@ static const struct attribute_group lp55
 	.attrs = lp5521_attributes,
 };
 
-static const struct attribute_group lp5521_engine_group[] = {
-	{.attrs = lp5521_engine1_attributes },
-	{.attrs = lp5521_engine2_attributes },
-	{.attrs = lp5521_engine3_attributes },
-};
-
 static int lp5521_register_sysfs(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
@@ -618,12 +588,6 @@ static void lp5521_unregister_sysfs(stru
 
 	sysfs_remove_group(&dev->kobj, &lp5521_group);
 
-	for (i = 0; i <  ARRAY_SIZE(chip->engines); i++) {
-		if (chip->engines[i].mode == LP5521_CMD_LOAD)
-			sysfs_remove_group(&dev->kobj,
-					chip->engines[i].attributes);
-	}
