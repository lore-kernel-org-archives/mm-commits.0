From: akpm@linux-foundation.org
Subject: + hwmon-applesmc-restore-accelerometer-and-keyboard-backlight-on-resume.patch added to -mm tree
Date: Tue, 25 Aug 2009 12:17:44 -0700
Message-ID: <200908251917.n7PJHiU7006750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755920AbZHYTS0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Aug 2009 15:18:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rydberg@euromail.se, nicolas@boichat.ch


The patch titled
     hwmon: applesmc: restore accelerometer and keyboard backlight on resume
has been added to the -mm tree.  Its filename is
     hwmon-applesmc-restore-accelerometer-and-keyboard-backlight-on-resume.patch

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
Subject: hwmon: applesmc: restore accelerometer and keyboard backlight on resume
From: Henrik Rydberg <rydberg@euromail.se>

On resume from suspend, the driver currently resets the logical state as
if it was brought up from halt.  This patch uses the
dev_pm_ops.resume/restore methods to synchronize the hardware with the
memorized logical state, in effect bringing back the accelerometer and
backlight to the state prior to suspend.  Works for both suspend to ram
and hibernation.  The patch has zero effect on the running state.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |   38 +++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-restore-accelerometer-and-keyboard-backlight-on-resume drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-restore-accelerometer-and-keyboard-backlight-on-resume
+++ a/drivers/hwmon/applesmc.c
@@ -178,6 +178,8 @@ static const int debug;
 static struct platform_device *pdev;
 static s16 rest_x;
 static s16 rest_y;
+static u8 backlight_state[2];
+
 static struct device *hwmon_dev;
 static struct input_polled_dev *applesmc_idev;
 
@@ -497,17 +499,36 @@ static int applesmc_probe(struct platfor
 	return 0;
 }
 
-static int applesmc_resume(struct platform_device *dev)
+/* Synchronize device with memorized backlight state */
+static int applesmc_pm_resume(struct device *dev)
 {
-	return applesmc_device_init();
+	mutex_lock(&applesmc_lock);
+	if (applesmc_light)
+		applesmc_write_key(BACKLIGHT_KEY, backlight_state, 2);
+	mutex_unlock(&applesmc_lock);
+	return 0;
 }
 
+/* Reinitialize device on resume from hibernation */
+static int applesmc_pm_restore(struct device *dev)
+{
+	int ret = applesmc_device_init();
+	if (ret)
+		return ret;
+	return applesmc_pm_resume(dev);
+}
+
+static struct dev_pm_ops applesmc_pm_ops = {
+	.resume = applesmc_pm_resume,
+	.restore = applesmc_pm_restore,
+};
+
 static struct platform_driver applesmc_driver = {
 	.probe = applesmc_probe,
-	.resume = applesmc_resume,
 	.driver	= {
 		.name = "applesmc",
 		.owner = THIS_MODULE,
+		.pm = &applesmc_pm_ops,
 	},
 };
 
@@ -804,17 +825,10 @@ static ssize_t applesmc_calibrate_store(
 	return count;
 }
 
-/* Store the next backlight value to be written by the work */
-static unsigned int backlight_value;
-
 static void applesmc_backlight_set(struct work_struct *work)
 {
-	u8 buffer[2];
