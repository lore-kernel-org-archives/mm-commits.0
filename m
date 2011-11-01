From: akpm@linux-foundation.org
Subject: [merged] lis3-remove-the-references-to-the-global-variable-in-core-driver.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:13:48 -0700
Message-ID: <201111012113.pA1LDmYY006339@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29776 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVOL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:14:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.piel@tremplin-utc.net, cascardo@holoscopio.com, chunkeey@googlemail.com, ilkka.koskinen@nokia.com, lyall.pearce@hp.com, m-starostik@versanet.de, mjg@redhat.com, witold.pilat@gmai


The patch titled
     Subject: lis3: remove the references to the global variable in cor=
e driver
has been removed from the -mm tree.  Its filename was
     lis3-remove-the-references-to-the-global-variable-in-core-driver.p=
atch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
=46rom: =C9ric Piel <eric.piel@tremplin-utc.net>
Subject: lis3: remove the references to the global variable in core dri=
ver

[ilkka.koskinen@nokia.com: fix arg to lis3->read()]
Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Signed-off-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Witold Pilat <witold.pilat@gmail.com>
Cc: Lyall Pearce <lyall.pearce@hp.com>
Cc: Malte Starostik <m-starostik@versanet.de>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>
Subject: lis3-remove-the-references-to-the-global-variable-in-core-driv=
er-fix
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lis3lv02d/lis3lv02d.c |  233 +++++++++++++++------------
 drivers/misc/lis3lv02d/lis3lv02d.h |    3=20
 2 files changed, 133 insertions(+), 103 deletions(-)

diff -puN drivers/misc/lis3lv02d/lis3lv02d.c~lis3-remove-the-references=
-to-the-global-variable-in-core-driver drivers/misc/lis3lv02d/lis3lv02d=
=2Ec
--- a/drivers/misc/lis3lv02d/lis3lv02d.c~lis3-remove-the-references-to-=
the-global-variable-in-core-driver
+++ a/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -163,7 +163,7 @@ static void lis3lv02d_get_xyz(struct lis
 	int i;
=20
 	if (lis3->blkread) {
-		if (lis3_dev.whoami =3D=3D WAI_12B) {
+		if (lis3->whoami =3D=3D WAI_12B) {
 			u16 data[3];
 			lis3->blkread(lis3, OUTX_L, 6, (u8 *)data);
 			for (i =3D 0; i < 3; i++)
@@ -195,20 +195,20 @@ static int lis3_8_rates[2] =3D {100, 400};
 static int lis3_3dc_rates[16] =3D {0, 1, 10, 25, 50, 100, 200, 400, 16=
00, 5000};
=20
 /* ODR is Output Data Rate */
-static int lis3lv02d_get_odr(void)
+static int lis3lv02d_get_odr(struct lis3lv02d *lis3)
 {
 	u8 ctrl;
 	int shift;
=20
-	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
-	ctrl &=3D lis3_dev.odr_mask;
-	shift =3D ffs(lis3_dev.odr_mask) - 1;
-	return lis3_dev.odrs[(ctrl >> shift)];
+	lis3->read(lis3, CTRL_REG1, &ctrl);
+	ctrl &=3D lis3->odr_mask;
+	shift =3D ffs(lis3->odr_mask) - 1;
+	return lis3->odrs[(ctrl >> shift)];
 }
=20
 static int lis3lv02d_get_pwron_wait(struct lis3lv02d *lis3)
 {
-	int div =3D lis3lv02d_get_odr();
+	int div =3D lis3lv02d_get_odr(lis3);
=20
 	if (WARN_ONCE(div =3D=3D 0, "device returned spurious data"))
 		return -ENXIO;
@@ -218,7 +218,7 @@ static int lis3lv02d_get_pwron_wait(stru
 	return 0;
 }
=20
-static int lis3lv02d_set_odr(int rate)
+static int lis3lv02d_set_odr(struct lis3lv02d *lis3, int rate)
 {
 	u8 ctrl;
 	int i, len, shift;
@@ -226,14 +226,14 @@ static int lis3lv02d_set_odr(int rate)
 	if (!rate)
 		return -EINVAL;
=20
-	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
-	ctrl &=3D ~lis3_dev.odr_mask;
-	len =3D 1 << hweight_long(lis3_dev.odr_mask); /* # of possible values=
 */
-	shift =3D ffs(lis3_dev.odr_mask) - 1;
+	lis3->read(lis3, CTRL_REG1, &ctrl);
+	ctrl &=3D ~lis3->odr_mask;
+	len =3D 1 << hweight_long(lis3->odr_mask); /* # of possible values */
+	shift =3D ffs(lis3->odr_mask) - 1;
=20
 	for (i =3D 0; i < len; i++)
-		if (lis3_dev.odrs[i] =3D=3D rate) {
-			lis3_dev.write(&lis3_dev, CTRL_REG1,
+		if (lis3->odrs[i] =3D=3D rate) {
+			lis3->write(lis3, CTRL_REG1,
 					ctrl | (i << shift));
 			return 0;
 		}
@@ -252,12 +252,12 @@ static int lis3lv02d_selftest(struct lis
 	mutex_lock(&lis3->mutex);
=20
 	irq_cfg =3D lis3->irq_cfg;
-	if (lis3_dev.whoami =3D=3D WAI_8B) {
+	if (lis3->whoami =3D=3D WAI_8B) {
 		lis3->data_ready_count[IRQ_LINE0] =3D 0;
 		lis3->data_ready_count[IRQ_LINE1] =3D 0;
=20
 		/* Change interrupt cfg to data ready for selftest */
-		atomic_inc(&lis3_dev.wake_thread);
+		atomic_inc(&lis3->wake_thread);
 		lis3->irq_cfg =3D LIS3_IRQ1_DATA_READY | LIS3_IRQ2_DATA_READY;
 		lis3->read(lis3, CTRL_REG3, &ctrl_reg_data);
 		lis3->write(lis3, CTRL_REG3, (ctrl_reg_data &
@@ -265,12 +265,12 @@ static int lis3lv02d_selftest(struct lis
 				(LIS3_IRQ1_DATA_READY | LIS3_IRQ2_DATA_READY));
 	}
=20
-	if (lis3_dev.whoami =3D=3D WAI_3DC) {
+	if (lis3->whoami =3D=3D WAI_3DC) {
 		ctlreg =3D CTRL_REG4;
 		selftest =3D CTRL4_ST0;
 	} else {
 		ctlreg =3D CTRL_REG1;
-		if (lis3_dev.whoami =3D=3D WAI_12B)
+		if (lis3->whoami =3D=3D WAI_12B)
 			selftest =3D CTRL1_ST;
 		else
 			selftest =3D CTRL1_STP;
@@ -299,9 +299,9 @@ static int lis3lv02d_selftest(struct lis
=20
 	ret =3D 0;
=20
-	if (lis3_dev.whoami =3D=3D WAI_8B) {
+	if (lis3->whoami =3D=3D WAI_8B) {
 		/* Restore original interrupt configuration */
-		atomic_dec(&lis3_dev.wake_thread);
+		atomic_dec(&lis3->wake_thread);
 		lis3->write(lis3, CTRL_REG3, ctrl_reg_data);
 		lis3->irq_cfg =3D irq_cfg;
=20
@@ -415,24 +415,27 @@ EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
=20
 static void lis3lv02d_joystick_poll(struct input_polled_dev *pidev)
 {
+	struct lis3lv02d *lis3 =3D pidev->private;
 	int x, y, z;
=20
-	mutex_lock(&lis3_dev.mutex);
-	lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
+	mutex_lock(&lis3->mutex);
+	lis3lv02d_get_xyz(lis3, &x, &y, &z);
 	input_report_abs(pidev->input, ABS_X, x);
 	input_report_abs(pidev->input, ABS_Y, y);
 	input_report_abs(pidev->input, ABS_Z, z);
 	input_sync(pidev->input);
-	mutex_unlock(&lis3_dev.mutex);
+	mutex_unlock(&lis3->mutex);
 }
=20
 static void lis3lv02d_joystick_open(struct input_polled_dev *pidev)
 {
-	if (lis3_dev.pm_dev)
-		pm_runtime_get_sync(lis3_dev.pm_dev);
+	struct lis3lv02d *lis3 =3D pidev->private;
=20
-	if (lis3_dev.pdata && lis3_dev.whoami =3D=3D WAI_8B && lis3_dev.idev)
-		atomic_set(&lis3_dev.wake_thread, 1);
+	if (lis3->pm_dev)
+		pm_runtime_get_sync(lis3->pm_dev);
+
+	if (lis3->pdata && lis3->whoami =3D=3D WAI_8B && lis3->idev)
+		atomic_set(&lis3->wake_thread, 1);
 	/*
 	 * Update coordinates for the case where poll interval is 0 and
 	 * the chip in running purely under interrupt control
@@ -442,14 +445,18 @@ static void lis3lv02d_joystick_open(stru
=20
 static void lis3lv02d_joystick_close(struct input_polled_dev *pidev)
 {
-	atomic_set(&lis3_dev.wake_thread, 0);
-	if (lis3_dev.pm_dev)
-		pm_runtime_put(lis3_dev.pm_dev);
+	struct lis3lv02d *lis3 =3D pidev->private;
+
+	atomic_set(&lis3->wake_thread, 0);
+	if (lis3->pm_dev)
+		pm_runtime_put(lis3->pm_dev);
 }
=20
-static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
+static irqreturn_t lis302dl_interrupt(int irq, void *data)
 {
-	if (!test_bit(0, &lis3_dev.misc_opened))
+	struct lis3lv02d *lis3 =3D data;
+
+	if (!test_bit(0, &lis3->misc_opened))
 		goto out;
=20
 	/*
@@ -457,12 +464,12 @@ static irqreturn_t lis302dl_interrupt(in
 	 * the lid is closed. This leads to interrupts as soon as a little mo=
ve
 	 * is done.
 	 */
-	atomic_inc(&lis3_dev.count);
+	atomic_inc(&lis3->count);
=20
-	wake_up_interruptible(&lis3_dev.misc_wait);
-	kill_fasync(&lis3_dev.async_queue, SIGIO, POLL_IN);
+	wake_up_interruptible(&lis3->misc_wait);
+	kill_fasync(&lis3->async_queue, SIGIO, POLL_IN);
 out:
-	if (atomic_read(&lis3_dev.wake_thread))
+	if (atomic_read(&lis3->wake_thread))
 		return IRQ_WAKE_THREAD;
 	return IRQ_HANDLED;
 }
@@ -534,28 +541,37 @@ static irqreturn_t lis302dl_interrupt_th
=20
 static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, &lis3_dev.misc_opened))
+	struct lis3lv02d *lis3 =3D container_of(file->private_data,
+					      struct lis3lv02d, miscdev);
+
+	if (test_and_set_bit(0, &lis3->misc_opened))
 		return -EBUSY; /* already open */
=20
-	if (lis3_dev.pm_dev)
-		pm_runtime_get_sync(lis3_dev.pm_dev);
+	if (lis3->pm_dev)
+		pm_runtime_get_sync(lis3->pm_dev);
=20
-	atomic_set(&lis3_dev.count, 0);
+	atomic_set(&lis3->count, 0);
 	return 0;
 }
=20
 static int lis3lv02d_misc_release(struct inode *inode, struct file *fi=
le)
 {
-	fasync_helper(-1, file, 0, &lis3_dev.async_queue);
-	clear_bit(0, &lis3_dev.misc_opened); /* release the device */
-	if (lis3_dev.pm_dev)
-		pm_runtime_put(lis3_dev.pm_dev);
+	struct lis3lv02d *lis3 =3D container_of(file->private_data,
+					      struct lis3lv02d, miscdev);
+
+	fasync_helper(-1, file, 0, &lis3->async_queue);
+	clear_bit(0, &lis3->misc_opened); /* release the device */
+	if (lis3->pm_dev)
+		pm_runtime_put(lis3->pm_dev);
 	return 0;
 }
=20
 static ssize_t lis3lv02d_misc_read(struct file *file, char __user *buf=
,
 				size_t count, loff_t *pos)
 {
+	struct lis3lv02d *lis3 =3D container_of(file->private_data,
+					      struct lis3lv02d, miscdev);
+
 	DECLARE_WAITQUEUE(wait, current);
 	u32 data;
 	unsigned char byte_data;
@@ -564,10 +580,10 @@ static ssize_t lis3lv02d_misc_read(struc
 	if (count < 1)
 		return -EINVAL;
=20
-	add_wait_queue(&lis3_dev.misc_wait, &wait);
+	add_wait_queue(&lis3->misc_wait, &wait);
 	while (true) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		data =3D atomic_xchg(&lis3_dev.count, 0);
+		data =3D atomic_xchg(&lis3->count, 0);
 		if (data)
 			break;
=20
@@ -597,22 +613,28 @@ static ssize_t lis3lv02d_misc_read(struc
=20
 out:
 	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&lis3_dev.misc_wait, &wait);
+	remove_wait_queue(&lis3->misc_wait, &wait);
=20
 	return retval;
 }
=20
 static unsigned int lis3lv02d_misc_poll(struct file *file, poll_table =
*wait)
 {
-	poll_wait(file, &lis3_dev.misc_wait, wait);
-	if (atomic_read(&lis3_dev.count))
+	struct lis3lv02d *lis3 =3D container_of(file->private_data,
+					      struct lis3lv02d, miscdev);
+
+	poll_wait(file, &lis3->misc_wait, wait);
+	if (atomic_read(&lis3->count))
 		return POLLIN | POLLRDNORM;
 	return 0;
 }
=20
 static int lis3lv02d_misc_fasync(int fd, struct file *file, int on)
 {
-	return fasync_helper(fd, file, on, &lis3_dev.async_queue);
+	struct lis3lv02d *lis3 =3D container_of(file->private_data,
+					      struct lis3lv02d, miscdev);
+
+	return fasync_helper(fd, file, on, &lis3->async_queue);
 }
=20
 static const struct file_operations lis3lv02d_misc_fops =3D {
@@ -625,12 +647,6 @@ static const struct file_operations lis3
 	.fasync  =3D lis3lv02d_misc_fasync,
 };
=20
-static struct miscdevice lis3lv02d_misc_device =3D {
-	.minor   =3D MISC_DYNAMIC_MINOR,
-	.name    =3D "freefall",
-	.fops    =3D &lis3lv02d_misc_fops,
-};
-
 int lis3lv02d_joystick_enable(struct lis3lv02d *lis3)
 {
 	struct input_dev *input_dev;
@@ -638,51 +654,52 @@ int lis3lv02d_joystick_enable(struct lis
 	int max_val, fuzz, flat;
 	int btns[] =3D {BTN_X, BTN_Y, BTN_Z};
=20
-	if (lis3_dev.idev)
+	if (lis3->idev)
 		return -EINVAL;
=20
-	lis3_dev.idev =3D input_allocate_polled_device();
-	if (!lis3_dev.idev)
+	lis3->idev =3D input_allocate_polled_device();
+	if (!lis3->idev)
 		return -ENOMEM;
=20
-	lis3_dev.idev->poll =3D lis3lv02d_joystick_poll;
-	lis3_dev.idev->open =3D lis3lv02d_joystick_open;
-	lis3_dev.idev->close =3D lis3lv02d_joystick_close;
-	lis3_dev.idev->poll_interval =3D MDPS_POLL_INTERVAL;
-	lis3_dev.idev->poll_interval_min =3D MDPS_POLL_MIN;
-	lis3_dev.idev->poll_interval_max =3D MDPS_POLL_MAX;
-	input_dev =3D lis3_dev.idev->input;
+	lis3->idev->poll =3D lis3lv02d_joystick_poll;
+	lis3->idev->open =3D lis3lv02d_joystick_open;
+	lis3->idev->close =3D lis3lv02d_joystick_close;
+	lis3->idev->poll_interval =3D MDPS_POLL_INTERVAL;
+	lis3->idev->poll_interval_min =3D MDPS_POLL_MIN;
+	lis3->idev->poll_interval_max =3D MDPS_POLL_MAX;
+	lis3->idev->private =3D lis3;
+	input_dev =3D lis3->idev->input;
=20
 	input_dev->name       =3D "ST LIS3LV02DL Accelerometer";
 	input_dev->phys       =3D DRIVER_NAME "/input0";
 	input_dev->id.bustype =3D BUS_HOST;
 	input_dev->id.vendor  =3D 0;
-	input_dev->dev.parent =3D &lis3_dev.pdev->dev;
+	input_dev->dev.parent =3D &lis3->pdev->dev;
=20
 	set_bit(EV_ABS, input_dev->evbit);
-	max_val =3D (lis3_dev.mdps_max_val * lis3_dev.scale) / LIS3_ACCURACY;
-	if (lis3_dev.whoami =3D=3D WAI_12B) {
+	max_val =3D (lis3->mdps_max_val * lis3->scale) / LIS3_ACCURACY;
+	if (lis3->whoami =3D=3D WAI_12B) {
 		fuzz =3D LIS3_DEFAULT_FUZZ_12B;
 		flat =3D LIS3_DEFAULT_FLAT_12B;
 	} else {
 		fuzz =3D LIS3_DEFAULT_FUZZ_8B;
 		flat =3D LIS3_DEFAULT_FLAT_8B;
 	}
-	fuzz =3D (fuzz * lis3_dev.scale) / LIS3_ACCURACY;
-	flat =3D (flat * lis3_dev.scale) / LIS3_ACCURACY;
+	fuzz =3D (fuzz * lis3->scale) / LIS3_ACCURACY;
+	flat =3D (flat * lis3->scale) / LIS3_ACCURACY;
=20
 	input_set_abs_params(input_dev, ABS_X, -max_val, max_val, fuzz, flat)=
;
 	input_set_abs_params(input_dev, ABS_Y, -max_val, max_val, fuzz, flat)=
;
 	input_set_abs_params(input_dev, ABS_Z, -max_val, max_val, fuzz, flat)=
;
=20
-	lis3_dev.mapped_btns[0] =3D lis3lv02d_get_axis(abs(lis3_dev.ac.x), bt=
ns);
-	lis3_dev.mapped_btns[1] =3D lis3lv02d_get_axis(abs(lis3_dev.ac.y), bt=
ns);
-	lis3_dev.mapped_btns[2] =3D lis3lv02d_get_axis(abs(lis3_dev.ac.z), bt=
ns);
+	lis3->mapped_btns[0] =3D lis3lv02d_get_axis(abs(lis3->ac.x), btns);
+	lis3->mapped_btns[1] =3D lis3lv02d_get_axis(abs(lis3->ac.y), btns);
+	lis3->mapped_btns[2] =3D lis3lv02d_get_axis(abs(lis3->ac.z), btns);
=20
-	err =3D input_register_polled_device(lis3_dev.idev);
+	err =3D input_register_polled_device(lis3->idev);
 	if (err) {
-		input_free_polled_device(lis3_dev.idev);
-		lis3_dev.idev =3D NULL;
+		input_free_polled_device(lis3->idev);
+		lis3->idev =3D NULL;
 	}
=20
 	return err;
@@ -691,19 +708,19 @@ EXPORT_SYMBOL_GPL(lis3lv02d_joystick_ena
=20
 void lis3lv02d_joystick_disable(struct lis3lv02d *lis3)
 {
-	if (lis3_dev.irq)
-		free_irq(lis3_dev.irq, &lis3_dev);
-	if (lis3_dev.pdata && lis3_dev.pdata->irq2)
-		free_irq(lis3_dev.pdata->irq2, &lis3_dev);
+	if (lis3->irq)
+		free_irq(lis3->irq, lis3);
+	if (lis3->pdata && lis3->pdata->irq2)
+		free_irq(lis3->pdata->irq2, lis3);
=20
-	if (!lis3_dev.idev)
+	if (!lis3->idev)
 		return;
=20
-	if (lis3_dev.irq)
-		misc_deregister(&lis3lv02d_misc_device);
-	input_unregister_polled_device(lis3_dev.idev);
-	input_free_polled_device(lis3_dev.idev);
-	lis3_dev.idev =3D NULL;
+	if (lis3->irq)
+		misc_deregister(&lis3->miscdev);
+	input_unregister_polled_device(lis3->idev);
+	input_free_polled_device(lis3->idev);
+	lis3->idev =3D NULL;
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_joystick_disable);
=20
@@ -728,6 +745,7 @@ static void lis3lv02d_sysfs_poweron(stru
 static ssize_t lis3lv02d_selftest_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
+	struct lis3lv02d *lis3 =3D dev_get_drvdata(dev);
 	s16 values[3];
=20
 	static const char ok[] =3D "OK";
@@ -735,8 +753,8 @@ static ssize_t lis3lv02d_selftest_show(s
 	static const char irq[] =3D "FAIL_IRQ";
 	const char *res;
=20
-	lis3lv02d_sysfs_poweron(&lis3_dev);
-	switch (lis3lv02d_selftest(&lis3_dev, values)) {
+	lis3lv02d_sysfs_poweron(lis3);
+	switch (lis3lv02d_selftest(lis3, values)) {
 	case SELFTEST_FAIL:
 		res =3D fail;
 		break;
@@ -755,33 +773,37 @@ static ssize_t lis3lv02d_selftest_show(s
 static ssize_t lis3lv02d_position_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
+	struct lis3lv02d *lis3 =3D dev_get_drvdata(dev);
 	int x, y, z;
=20
-	lis3lv02d_sysfs_poweron(&lis3_dev);
-	mutex_lock(&lis3_dev.mutex);
-	lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
-	mutex_unlock(&lis3_dev.mutex);
+	lis3lv02d_sysfs_poweron(lis3);
+	mutex_lock(&lis3->mutex);
+	lis3lv02d_get_xyz(lis3, &x, &y, &z);
+	mutex_unlock(&lis3->mutex);
 	return sprintf(buf, "(%d,%d,%d)\n", x, y, z);
 }
=20
 static ssize_t lis3lv02d_rate_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	lis3lv02d_sysfs_poweron(&lis3_dev);
-	return sprintf(buf, "%d\n", lis3lv02d_get_odr());
+	struct lis3lv02d *lis3 =3D dev_get_drvdata(dev);
+
+	lis3lv02d_sysfs_poweron(lis3);
+	return sprintf(buf, "%d\n", lis3lv02d_get_odr(lis3));
 }
=20
 static ssize_t lis3lv02d_rate_set(struct device *dev,
 				struct device_attribute *attr, const char *buf,
 				size_t count)
 {
+	struct lis3lv02d *lis3 =3D dev_get_drvdata(dev);
 	unsigned long rate;
=20
 	if (strict_strtoul(buf, 0, &rate))
 		return -EINVAL;
=20
-	lis3lv02d_sysfs_poweron(&lis3_dev);
-	if (lis3lv02d_set_odr(rate))
+	lis3lv02d_sysfs_poweron(lis3);
+	if (lis3lv02d_set_odr(lis3, rate))
 		return -EINVAL;
=20
 	return count;
@@ -810,6 +832,7 @@ static int lis3lv02d_add_fs(struct lis3l
 	if (IS_ERR(lis3->pdev))
 		return PTR_ERR(lis3->pdev);
=20
+	platform_set_drvdata(lis3->pdev, lis3);
 	return sysfs_create_group(&lis3->pdev->dev.kobj, &lis3lv02d_attribute=
_group);
 }
=20
@@ -823,7 +846,7 @@ int lis3lv02d_remove_fs(struct lis3lv02d
=20
 		/* SYSFS may have left chip running. Turn off if necessary */
 		if (!pm_runtime_suspended(lis3->pm_dev))
-			lis3lv02d_poweroff(&lis3_dev);
+			lis3lv02d_poweroff(lis3);
=20
 		pm_runtime_disable(lis3->pm_dev);
 		pm_runtime_set_suspended(lis3->pm_dev);
@@ -850,7 +873,7 @@ static void lis3lv02d_8b_configure(struc
 			(p->click_thresh_y << 4));
=20
 		if (lis3->idev) {
-			struct input_dev *input_dev =3D lis3_dev.idev->input;
+			struct input_dev *input_dev =3D lis3->idev->input;
 			input_set_capability(input_dev, EV_KEY, BTN_X);
 			input_set_capability(input_dev, EV_KEY, BTN_Y);
 			input_set_capability(input_dev, EV_KEY, BTN_Z);
@@ -881,7 +904,7 @@ static void lis3lv02d_8b_configure(struc
 					lis302dl_interrupt_thread2_8b,
 					IRQF_TRIGGER_RISING | IRQF_ONESHOT |
 					(p->irq_flags2 & IRQF_TRIGGER_MASK),
-					DRIVER_NAME, &lis3_dev);
+					DRIVER_NAME, lis3);
 		if (err < 0)
 			pr_err("No second IRQ. Limited functionality\n");
 	}
@@ -977,7 +1000,7 @@ int lis3lv02d_init_device(struct lis3lv0
 			lis3->write(lis3, CTRL_REG3, p->irq_cfg);
=20
 		if (p->default_rate)
-			lis3lv02d_set_odr(p->default_rate);
+			lis3lv02d_set_odr(lis3, p->default_rate);
 	}
=20
 	/* bail if we did not get an IRQ from the bus layer */
@@ -1006,14 +1029,18 @@ int lis3lv02d_init_device(struct lis3lv0
 				thread_fn,
 				IRQF_TRIGGER_RISING | IRQF_ONESHOT |
 				irq_flags,
-				DRIVER_NAME, &lis3_dev);
+				DRIVER_NAME, lis3);
=20
 	if (err < 0) {
 		pr_err("Cannot get IRQ\n");
 		goto out;
 	}
=20
-	if (misc_register(&lis3lv02d_misc_device))
+	lis3->miscdev.minor	=3D MISC_DYNAMIC_MINOR;
+	lis3->miscdev.name	=3D "freefall";
+	lis3->miscdev.fops	=3D &lis3lv02d_misc_fops;
+
+	if (misc_register(&lis3->miscdev))
 		pr_err("misc_register failed\n");
 out:
 	return 0;
diff -puN drivers/misc/lis3lv02d/lis3lv02d.h~lis3-remove-the-references=
-to-the-global-variable-in-core-driver drivers/misc/lis3lv02d/lis3lv02d=
=2Eh
--- a/drivers/misc/lis3lv02d/lis3lv02d.h~lis3-remove-the-references-to-=
the-global-variable-in-core-driver
+++ a/drivers/misc/lis3lv02d/lis3lv02d.h
@@ -21,6 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/input-polldev.h>
 #include <linux/regulator/consumer.h>
+#include <linux/miscdevice.h>
=20
 /*
  * This driver tries to support the "digital" accelerometer chips from
@@ -273,6 +274,8 @@ struct lis3lv02d {
 	struct fasync_struct	*async_queue; /* queue for the misc device */
 	wait_queue_head_t	misc_wait; /* Wait queue for the misc device */
 	unsigned long		misc_opened; /* bit0: whether the device is open */
+	struct miscdevice	miscdev;
+
 	int                     data_ready_count[2];
 	atomic_t		wake_thread;
 	unsigned char           irq_cfg;
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net=
 are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
