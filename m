From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-lp5521c-adjust-delays-and-add-comments-to-them.patch removed from -mm tree
Date: Mon, 29 Nov 2010 11:51:05 -0800
Message-ID: <201011291951.oATJpYl4007298@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921Ab0K2Tvr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Nov 2010 14:51:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samu.p.onkalo@nokia.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/leds/leds-lp5521.c: adjust delays and add comments to them
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lp5521c-adjust-delays-and-add-comments-to-them.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/leds/leds-lp5521.c: adjust delays and add comments to them
From: Samu Onkalo <samu.p.onkalo@nokia.com>

Delays were little bit too long.  Adjust delay times and add some comments
to them.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5521.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff -puN drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-adjust-delays-and-add-comments-to-them drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-adjust-delays-and-add-comments-to-them
+++ a/drivers/leds/leds-lp5521.c
@@ -196,14 +196,17 @@ static int lp5521_load_program(struct lp
 
 	/* move current engine to direct mode and remember the state */
 	ret = lp5521_set_engine_mode(eng, LP5521_CMD_DIRECT);
-	usleep_range(1000, 10000);
+	/* Mode change requires min 500 us delay. 1 - 2 ms  with margin */
+	usleep_range(1000, 2000);
 	ret |= lp5521_read(client, LP5521_REG_OP_MODE, &mode);
 
 	/* For loading, all the engines to load mode */
 	lp5521_write(client, LP5521_REG_OP_MODE, LP5521_CMD_DIRECT);
-	usleep_range(1000, 10000);
+	/* Mode change requires min 500 us delay. 1 - 2 ms  with margin */
+	usleep_range(1000, 2000);
 	lp5521_write(client, LP5521_REG_OP_MODE, LP5521_CMD_LOAD);
-	usleep_range(1000, 10000);
+	/* Mode change requires min 500 us delay. 1 - 2 ms  with margin */
+	usleep_range(1000, 2000);
 
 	addr = LP5521_PROG_MEM_BASE + eng->prog_page * LP5521_PROG_MEM_SIZE;
 	i2c_smbus_write_i2c_block_data(client,
@@ -244,7 +247,10 @@ static int lp5521_configure(struct i2c_c
 
 	lp5521_write(client, LP5521_REG_RESET, 0xff);
 
-	usleep_range(10000, 20000);
+	usleep_range(10000, 20000); /*
+				     * Exact value is not available. 10 - 20ms
+				     * appears to be enough for reset.
+				     */
 
 	/* Set all PWMs to direct control mode */
 	ret = lp5521_write(client, LP5521_REG_OP_MODE, 0x3F);
@@ -262,8 +268,8 @@ static int lp5521_configure(struct i2c_c
 	ret |= lp5521_write(client, LP5521_REG_ENABLE,
 			LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM |
 			LP5521_EXEC_RUN);
-	/* enable takes 500us */
-	usleep_range(500, 20000);
+	/* enable takes 500us. 1 - 2 ms leaves some margin */
+	usleep_range(1000, 2000);
 
 	return ret;
 }
@@ -316,7 +322,8 @@ static int lp5521_detect(struct i2c_clie
 			LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM);
 	if (ret)
 		return ret;
-	usleep_range(1000, 10000);
+	/* enable takes 500us. 1 - 2 ms leaves some margin */
+	usleep_range(1000, 2000);
 	ret = lp5521_read(client, LP5521_REG_ENABLE, &buf);
 	if (ret)
 		return ret;
@@ -704,9 +711,9 @@ static int lp5521_probe(struct i2c_clien
 
 	if (pdata->enable) {
 		pdata->enable(0);
-		usleep_range(1000, 10000);
+		usleep_range(1000, 2000); /* Keep enable down at least 1ms */
 		pdata->enable(1);
-		usleep_range(1000, 10000); /* Spec says min 500us */
+		usleep_range(1000, 2000); /* 500us abs min. */
 	}
 
 	ret = lp5521_detect(client);
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com are

origin.patch

