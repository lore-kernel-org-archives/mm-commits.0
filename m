From: akpm@linux-foundation.org
Subject: [merged] hwmon-applesmc-restore-accelerometer-and-keyboard-backlight-on-resume.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:46:32 -0700
Message-ID: <200909222046.n8MKkWHR017910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753234AbZIVUrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:47:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, nicolas@boichat.ch, mm-commits@vger.kernel.org


The patch titled
     hwmon: applesmc: restore accelerometer and keyboard backlight on resume
has been removed from the -mm tree.  Its filename was
     hwmon-applesmc-restore-accelerometer-and-keyboard-backlight-on-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
