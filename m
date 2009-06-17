From: akpm@linux-foundation.org
Subject: [merged] lis3-use-input_polled_device.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:38:55 -0700
Message-ID: <200906171838.n5HIct2J004960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760914AbZFQSjr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:39:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.piel@tremplin-utc.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     lis3: use input_polled_device
has been removed from the -mm tree.  Its filename was
     lis3-use-input_polled_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lis3: use input_polled_device
From: Eric Piel <eric.piel@tremplin-utc.net>

Now that there is no need to hookup on the open/close of the joystick,
it's possible to use the simplified interface input_polled_device, instead
of creating our own kthread.

[randy.dunlap@oracle.com: fix Kconfig]
[randy.dunlap@oracle.com: fix Kconfig some more]
Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/Kconfig     |    2 
 drivers/hwmon/hp_accel.c  |    3 -
 drivers/hwmon/lis3lv02d.c |   76 +++++++++++-------------------------
 drivers/hwmon/lis3lv02d.h |    5 +-
 4 files changed, 30 insertions(+), 56 deletions(-)

diff -puN drivers/hwmon/Kconfig~lis3-use-input_polled_device drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~lis3-use-input_polled_device
+++ a/drivers/hwmon/Kconfig
@@ -950,6 +950,7 @@ config SENSORS_HDAPS
 config SENSORS_LIS3LV02D
 	tristate "STMicroeletronics LIS3LV02Dx three-axis digital accelerometer"
 	depends on ACPI && INPUT
+	select INPUT_POLLDEV
 	select NEW_LEDS
 	select LEDS_CLASS
 	default n
@@ -977,6 +978,7 @@ config SENSORS_LIS3LV02D
 config SENSORS_LIS3_SPI
 	tristate "STMicroeletronics LIS3LV02Dx three-axis digital accelerometer (SPI)"
 	depends on !ACPI && SPI_MASTER && INPUT
+	select INPUT_POLLDEV
 	default n
 	help
 	  This driver provides support for the LIS3LV02Dx accelerometer connected
diff -puN drivers/hwmon/hp_accel.c~lis3-use-input_polled_device drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~lis3-use-input_polled_device
+++ a/drivers/hwmon/hp_accel.c
@@ -27,9 +27,6 @@
 #include <linux/types.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
-#include <linux/input.h>
-#include <linux/kthread.h>
-#include <linux/semaphore.h>
 #include <linux/delay.h>
 #include <linux/wait.h>
 #include <linux/poll.h>
diff -puN drivers/hwmon/lis3lv02d.c~lis3-use-input_polled_device drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-use-input_polled_device
+++ a/drivers/hwmon/lis3lv02d.c
@@ -27,9 +27,7 @@
 #include <linux/types.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
-#include <linux/input.h>
-#include <linux/kthread.h>
-#include <linux/semaphore.h>
+#include <linux/input-polldev.h>
 #include <linux/delay.h>
 #include <linux/wait.h>
 #include <linux/poll.h>
@@ -270,43 +268,16 @@ static struct miscdevice lis3lv02d_misc_
 	.fops    = &lis3lv02d_misc_fops,
 };
 
-/**
- * lis3lv02d_joystick_kthread - Kthread polling function
- * @data: unused - here to conform to threadfn prototype
- */
-static int lis3lv02d_joystick_kthread(void *data)
+static void lis3lv02d_joystick_poll(struct input_polled_dev *pidev)
 {
 	int x, y, z;
 
-	while (!kthread_should_stop()) {
-		lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
-		input_report_abs(lis3_dev.idev, ABS_X, x - lis3_dev.xcalib);
-		input_report_abs(lis3_dev.idev, ABS_Y, y - lis3_dev.ycalib);
-		input_report_abs(lis3_dev.idev, ABS_Z, z - lis3_dev.zcalib);
-
-		input_sync(lis3_dev.idev);
-
-		try_to_freeze();
-		msleep_interruptible(MDPS_POLL_INTERVAL);
-	}
-
-	return 0;
-}
-
-static int lis3lv02d_joystick_open(struct input_dev *input)
-{
-	lis3_dev.kthread = kthread_run(lis3lv02d_joystick_kthread, NULL, "klis3lv02d");
-	if (IS_ERR(lis3_dev.kthread)) {
-		return PTR_ERR(lis3_dev.kthread);
-	}
-
-	return 0;
+	lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
+	input_report_abs(pidev->input, ABS_X, x - lis3_dev.xcalib);
+	input_report_abs(pidev->input, ABS_Y, y - lis3_dev.ycalib);
+	input_report_abs(pidev->input, ABS_Z, z - lis3_dev.zcalib);
 }
 
-static void lis3lv02d_joystick_close(struct input_dev *input)
-{
-	kthread_stop(lis3_dev.kthread);
-}
 
 static inline void lis3lv02d_calibrate_joystick(void)
 {
@@ -316,33 +287,36 @@ static inline void lis3lv02d_calibrate_j
 
 int lis3lv02d_joystick_enable(void)
 {
+	struct input_dev *input_dev;
 	int err;
 
 	if (lis3_dev.idev)
 		return -EINVAL;
 
-	lis3_dev.idev = input_allocate_device();
+	lis3_dev.idev = input_allocate_polled_device();
 	if (!lis3_dev.idev)
 		return -ENOMEM;
 
+	lis3_dev.idev->poll = lis3lv02d_joystick_poll;
+	lis3_dev.idev->poll_interval = MDPS_POLL_INTERVAL;
+	input_dev = lis3_dev.idev->input;
+
 	lis3lv02d_calibrate_joystick();
 
-	lis3_dev.idev->name       = "ST LIS3LV02DL Accelerometer";
-	lis3_dev.idev->phys       = DRIVER_NAME "/input0";
-	lis3_dev.idev->id.bustype = BUS_HOST;
-	lis3_dev.idev->id.vendor  = 0;
-	lis3_dev.idev->dev.parent = &lis3_dev.pdev->dev;
-	lis3_dev.idev->open       = lis3lv02d_joystick_open;
-	lis3_dev.idev->close      = lis3lv02d_joystick_close;
-
-	set_bit(EV_ABS, lis3_dev.idev->evbit);
-	input_set_abs_params(lis3_dev.idev, ABS_X, -lis3_dev.mdps_max_val, lis3_dev.mdps_max_val, 3, 3);
-	input_set_abs_params(lis3_dev.idev, ABS_Y, -lis3_dev.mdps_max_val, lis3_dev.mdps_max_val, 3, 3);
-	input_set_abs_params(lis3_dev.idev, ABS_Z, -lis3_dev.mdps_max_val, lis3_dev.mdps_max_val, 3, 3);
+	input_dev->name       = "ST LIS3LV02DL Accelerometer";
+	input_dev->phys       = DRIVER_NAME "/input0";
+	input_dev->id.bustype = BUS_HOST;
+	input_dev->id.vendor  = 0;
+	input_dev->dev.parent = &lis3_dev.pdev->dev;
+
+	set_bit(EV_ABS, input_dev->evbit);
+	input_set_abs_params(input_dev, ABS_X, -lis3_dev.mdps_max_val, lis3_dev.mdps_max_val, 3, 3);
+	input_set_abs_params(input_dev, ABS_Y, -lis3_dev.mdps_max_val, lis3_dev.mdps_max_val, 3, 3);
+	input_set_abs_params(input_dev, ABS_Z, -lis3_dev.mdps_max_val, lis3_dev.mdps_max_val, 3, 3);
 
-	err = input_register_device(lis3_dev.idev);
+	err = input_register_polled_device(lis3_dev.idev);
 	if (err) {
-		input_free_device(lis3_dev.idev);
+		input_free_polled_device(lis3_dev.idev);
 		lis3_dev.idev = NULL;
 	}
 
@@ -357,7 +331,7 @@ void lis3lv02d_joystick_disable(void)
 
 	if (lis3_dev.irq)
 		misc_deregister(&lis3lv02d_misc_device);
-	input_unregister_device(lis3_dev.idev);
+	input_unregister_polled_device(lis3_dev.idev);
 	lis3_dev.idev = NULL;
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_joystick_disable);
diff -puN drivers/hwmon/lis3lv02d.h~lis3-use-input_polled_device drivers/hwmon/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~lis3-use-input_polled_device
+++ a/drivers/hwmon/lis3lv02d.h
@@ -18,6 +18,8 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
+#include <linux/platform_device.h>
+#include <linux/input-polldev.h>
 
 /*
  * The actual chip is STMicroelectronics LIS3LV02DL or LIS3LV02DQ that seems to
@@ -169,8 +171,7 @@ struct lis3lv02d {
 	s16 (*read_data) (struct lis3lv02d *lis3, int reg);
 	int			mdps_max_val;
 
-	struct input_dev	*idev;     /* input device */
-	struct task_struct	*kthread;  /* kthread for input */
+	struct input_polled_dev	*idev;     /* input device */
 	struct platform_device	*pdev;     /* platform device */
 	atomic_t		count;     /* interrupt count after last read */
 	int			xcalib;    /* calibrated null value for x */
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net are

origin.patch

