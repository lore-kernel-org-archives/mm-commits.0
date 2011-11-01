From: akpm@linux-foundation.org
Subject: [merged] lis3-change-naming-to-consistent.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:13:37 -0700
Message-ID: <201111012113.pA1LDb1w006293@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16250 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVN5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:13:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.piel@tremplin-utc.net, cascardo@holoscopio.com, chunkeey@googlemail.com, ilkka.koskinen@nokia.com, lyall.pearce@hp.com, m-starostik@versanet.de, mjg@redhat.com, witold.pilat@gmai


The patch titled
     Subject: lis3: use consistent naming of variables
has been removed from the -mm tree.  Its filename was
     lis3-change-naming-to-consistent.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
=46rom: =C9ric Piel <eric.piel@tremplin-utc.net>
Subject: lis3: use consistent naming of variables

Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Signed-off-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Witold Pilat <witold.pilat@gmail.com>
Cc: Lyall Pearce <lyall.pearce@hp.com>
Cc: Malte Starostik <m-starostik@versanet.de>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lis3lv02d/lis3lv02d.c |  120 +++++++++++++--------------
 1 file changed, 60 insertions(+), 60 deletions(-)

diff -puN drivers/misc/lis3lv02d/lis3lv02d.c~lis3-change-naming-to-cons=
istent drivers/misc/lis3lv02d/lis3lv02d.c
--- a/drivers/misc/lis3lv02d/lis3lv02d.c~lis3-change-naming-to-consiste=
nt
+++ a/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -833,23 +833,23 @@ int lis3lv02d_remove_fs(struct lis3lv02d
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
=20
-static void lis3lv02d_8b_configure(struct lis3lv02d *dev,
+static void lis3lv02d_8b_configure(struct lis3lv02d *lis3,
 				struct lis3lv02d_platform_data *p)
 {
 	int err;
 	int ctrl2 =3D p->hipass_ctrl;
=20
 	if (p->click_flags) {
-		dev->write(dev, CLICK_CFG, p->click_flags);
-		dev->write(dev, CLICK_TIMELIMIT, p->click_time_limit);
-		dev->write(dev, CLICK_LATENCY, p->click_latency);
-		dev->write(dev, CLICK_WINDOW, p->click_window);
-		dev->write(dev, CLICK_THSZ, p->click_thresh_z & 0xf);
-		dev->write(dev, CLICK_THSY_X,
+		lis3->write(lis3, CLICK_CFG, p->click_flags);
+		lis3->write(lis3, CLICK_TIMELIMIT, p->click_time_limit);
+		lis3->write(lis3, CLICK_LATENCY, p->click_latency);
+		lis3->write(lis3, CLICK_WINDOW, p->click_window);
+		lis3->write(lis3, CLICK_THSZ, p->click_thresh_z & 0xf);
+		lis3->write(lis3, CLICK_THSY_X,
 			(p->click_thresh_x & 0xf) |
 			(p->click_thresh_y << 4));
=20
-		if (dev->idev) {
+		if (lis3->idev) {
 			struct input_dev *input_dev =3D lis3_dev.idev->input;
 			input_set_capability(input_dev, EV_KEY, BTN_X);
 			input_set_capability(input_dev, EV_KEY, BTN_Y);
@@ -858,22 +858,22 @@ static void lis3lv02d_8b_configure(struc
 	}
=20
 	if (p->wakeup_flags) {
-		dev->write(dev, FF_WU_CFG_1, p->wakeup_flags);
-		dev->write(dev, FF_WU_THS_1, p->wakeup_thresh & 0x7f);
+		lis3->write(lis3, FF_WU_CFG_1, p->wakeup_flags);
+		lis3->write(lis3, FF_WU_THS_1, p->wakeup_thresh & 0x7f);
 		/* pdata value + 1 to keep this backward compatible*/
-		dev->write(dev, FF_WU_DURATION_1, p->duration1 + 1);
+		lis3->write(lis3, FF_WU_DURATION_1, p->duration1 + 1);
 		ctrl2 ^=3D HP_FF_WU1; /* Xor to keep compatible with old pdata*/
 	}
=20
 	if (p->wakeup_flags2) {
-		dev->write(dev, FF_WU_CFG_2, p->wakeup_flags2);
-		dev->write(dev, FF_WU_THS_2, p->wakeup_thresh2 & 0x7f);
+		lis3->write(lis3, FF_WU_CFG_2, p->wakeup_flags2);
+		lis3->write(lis3, FF_WU_THS_2, p->wakeup_thresh2 & 0x7f);
 		/* pdata value + 1 to keep this backward compatible*/
-		dev->write(dev, FF_WU_DURATION_2, p->duration2 + 1);
+		lis3->write(lis3, FF_WU_DURATION_2, p->duration2 + 1);
 		ctrl2 ^=3D HP_FF_WU2; /* Xor to keep compatible with old pdata*/
 	}
 	/* Configure hipass filters */
-	dev->write(dev, CTRL_REG2, ctrl2);
+	lis3->write(lis3, CTRL_REG2, ctrl2);
=20
 	if (p->irq2) {
 		err =3D request_threaded_irq(p->irq2,
@@ -891,72 +891,72 @@ static void lis3lv02d_8b_configure(struc
  * Initialise the accelerometer and the various subsystems.
  * Should be rather independent of the bus system.
  */
-int lis3lv02d_init_device(struct lis3lv02d *dev)
+int lis3lv02d_init_device(struct lis3lv02d *lis3)
 {
 	int err;
 	irq_handler_t thread_fn;
 	int irq_flags =3D 0;
=20
-	dev->whoami =3D lis3lv02d_read_8(dev, WHO_AM_I);
+	lis3->whoami =3D lis3lv02d_read_8(lis3, WHO_AM_I);
=20
-	switch (dev->whoami) {
+	switch (lis3->whoami) {
 	case WAI_12B:
 		pr_info("12 bits sensor found\n");
-		dev->read_data =3D lis3lv02d_read_12;
-		dev->mdps_max_val =3D 2048;
-		dev->pwron_delay =3D LIS3_PWRON_DELAY_WAI_12B;
-		dev->odrs =3D lis3_12_rates;
-		dev->odr_mask =3D CTRL1_DF0 | CTRL1_DF1;
-		dev->scale =3D LIS3_SENSITIVITY_12B;
-		dev->regs =3D lis3_wai12_regs;
-		dev->regs_size =3D ARRAY_SIZE(lis3_wai12_regs);
+		lis3->read_data =3D lis3lv02d_read_12;
+		lis3->mdps_max_val =3D 2048;
+		lis3->pwron_delay =3D LIS3_PWRON_DELAY_WAI_12B;
+		lis3->odrs =3D lis3_12_rates;
+		lis3->odr_mask =3D CTRL1_DF0 | CTRL1_DF1;
+		lis3->scale =3D LIS3_SENSITIVITY_12B;
+		lis3->regs =3D lis3_wai12_regs;
+		lis3->regs_size =3D ARRAY_SIZE(lis3_wai12_regs);
 		break;
 	case WAI_8B:
 		pr_info("8 bits sensor found\n");
-		dev->read_data =3D lis3lv02d_read_8;
-		dev->mdps_max_val =3D 128;
-		dev->pwron_delay =3D LIS3_PWRON_DELAY_WAI_8B;
-		dev->odrs =3D lis3_8_rates;
-		dev->odr_mask =3D CTRL1_DR;
-		dev->scale =3D LIS3_SENSITIVITY_8B;
-		dev->regs =3D lis3_wai8_regs;
-		dev->regs_size =3D ARRAY_SIZE(lis3_wai8_regs);
+		lis3->read_data =3D lis3lv02d_read_8;
+		lis3->mdps_max_val =3D 128;
+		lis3->pwron_delay =3D LIS3_PWRON_DELAY_WAI_8B;
+		lis3->odrs =3D lis3_8_rates;
+		lis3->odr_mask =3D CTRL1_DR;
+		lis3->scale =3D LIS3_SENSITIVITY_8B;
+		lis3->regs =3D lis3_wai8_regs;
+		lis3->regs_size =3D ARRAY_SIZE(lis3_wai8_regs);
 		break;
 	case WAI_3DC:
 		pr_info("8 bits 3DC sensor found\n");
-		dev->read_data =3D lis3lv02d_read_8;
-		dev->mdps_max_val =3D 128;
-		dev->pwron_delay =3D LIS3_PWRON_DELAY_WAI_8B;
-		dev->odrs =3D lis3_3dc_rates;
-		dev->odr_mask =3D CTRL1_ODR0|CTRL1_ODR1|CTRL1_ODR2|CTRL1_ODR3;
-		dev->scale =3D LIS3_SENSITIVITY_8B;
+		lis3->read_data =3D lis3lv02d_read_8;
+		lis3->mdps_max_val =3D 128;
+		lis3->pwron_delay =3D LIS3_PWRON_DELAY_WAI_8B;
+		lis3->odrs =3D lis3_3dc_rates;
+		lis3->odr_mask =3D CTRL1_ODR0|CTRL1_ODR1|CTRL1_ODR2|CTRL1_ODR3;
+		lis3->scale =3D LIS3_SENSITIVITY_8B;
 		break;
 	default:
-		pr_err("unknown sensor type 0x%X\n", dev->whoami);
+		pr_err("unknown sensor type 0x%X\n", lis3->whoami);
 		return -EINVAL;
 	}
=20
-	dev->reg_cache =3D kzalloc(max(sizeof(lis3_wai8_regs),
+	lis3->reg_cache =3D kzalloc(max(sizeof(lis3_wai8_regs),
 				     sizeof(lis3_wai12_regs)), GFP_KERNEL);
=20
-	if (dev->reg_cache =3D=3D NULL) {
+	if (lis3->reg_cache =3D=3D NULL) {
 		printk(KERN_ERR DRIVER_NAME "out of memory\n");
 		return -ENOMEM;
 	}
=20
-	mutex_init(&dev->mutex);
-	atomic_set(&dev->wake_thread, 0);
+	mutex_init(&lis3->mutex);
+	atomic_set(&lis3->wake_thread, 0);
=20
-	lis3lv02d_add_fs(dev);
-	err =3D lis3lv02d_poweron(dev);
+	lis3lv02d_add_fs(lis3);
+	err =3D lis3lv02d_poweron(lis3);
 	if (err) {
-		lis3lv02d_remove_fs(dev);
+		lis3lv02d_remove_fs(lis3);
 		return err;
 	}
=20
-	if (dev->pm_dev) {
-		pm_runtime_set_active(dev->pm_dev);
-		pm_runtime_enable(dev->pm_dev);
+	if (lis3->pm_dev) {
+		pm_runtime_set_active(lis3->pm_dev);
+		pm_runtime_enable(lis3->pm_dev);
 	}
=20
 	if (lis3lv02d_joystick_enable())
@@ -964,24 +964,24 @@ int lis3lv02d_init_device(struct lis3lv0
=20
 	/* passing in platform specific data is purely optional and only
 	 * used by the SPI transport layer at the moment */
-	if (dev->pdata) {
-		struct lis3lv02d_platform_data *p =3D dev->pdata;
+	if (lis3->pdata) {
+		struct lis3lv02d_platform_data *p =3D lis3->pdata;
=20
-		if (dev->whoami =3D=3D WAI_8B)
-			lis3lv02d_8b_configure(dev, p);
+		if (lis3->whoami =3D=3D WAI_8B)
+			lis3lv02d_8b_configure(lis3, p);
=20
 		irq_flags =3D p->irq_flags1 & IRQF_TRIGGER_MASK;
=20
-		dev->irq_cfg =3D p->irq_cfg;
+		lis3->irq_cfg =3D p->irq_cfg;
 		if (p->irq_cfg)
-			dev->write(dev, CTRL_REG3, p->irq_cfg);
+			lis3->write(lis3, CTRL_REG3, p->irq_cfg);
=20
 		if (p->default_rate)
 			lis3lv02d_set_odr(p->default_rate);
 	}
=20
 	/* bail if we did not get an IRQ from the bus layer */
-	if (!dev->irq) {
+	if (!lis3->irq) {
 		pr_debug("No IRQ. Disabling /dev/freefall\n");
 		goto out;
 	}
@@ -997,12 +997,12 @@ int lis3lv02d_init_device(struct lis3lv0
 	 * io-apic is not configurable (and generates a warning) but I keep i=
t
 	 * in case of support for other hardware.
 	 */
-	if (dev->pdata && dev->whoami =3D=3D WAI_8B)
+	if (lis3->pdata && lis3->whoami =3D=3D WAI_8B)
 		thread_fn =3D lis302dl_interrupt_thread1_8b;
 	else
 		thread_fn =3D NULL;
=20
-	err =3D request_threaded_irq(dev->irq, lis302dl_interrupt,
+	err =3D request_threaded_irq(lis3->irq, lis302dl_interrupt,
 				thread_fn,
 				IRQF_TRIGGER_RISING | IRQF_ONESHOT |
 				irq_flags,
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net=
 are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
