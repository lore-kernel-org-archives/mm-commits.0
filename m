From: akpm@linux-foundation.org
Subject: + drivers-avoid-format-string-in-dev_set_name.patch added to -mm
 tree
Date: Tue, 11 Jun 2013 13:11:52 -0700
Message-ID: <51b78488.fgKPM8U9PUYd8GFS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab3FKULx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 16:11:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, keescook@chromium.org

Subject: + drivers-avoid-format-string-in-dev_set_name.patch added to -mm tree
To: keescook@chromium.org
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 13:11:52 -0700


The patch titled
     Subject: drivers: avoid format string in dev_set_name
has been added to the -mm tree.  Its filename is
     drivers-avoid-format-string-in-dev_set_name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: drivers: avoid format string in dev_set_name

Calling dev_set_name with a single paramter causes it to be handled as a
format string.  Many callers are passing potentially dynamic string
content, so use "%s" in those cases to avoid any potential accidents,
including wrappers like device_create*() and bdi_register().

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/attribute_container.c       |    2 +-
 drivers/devfreq/devfreq.c                |    2 +-
 drivers/extcon/extcon-class.c            |    2 +-
 drivers/hsi/hsi.c                        |    2 +-
 drivers/ide/ide-cd.c                     |    2 +-
 drivers/ide/ide-gd.c                     |    2 +-
 drivers/ide/ide-probe.c                  |    4 ++--
 drivers/ide/ide-tape.c                   |    2 +-
 drivers/infiniband/core/sysfs.c          |    2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c |    2 +-
 drivers/isdn/mISDN/dsp_pipeline.c        |    2 +-
 drivers/mtd/mtdcore.c                    |    2 +-
 drivers/platform/x86/wmi.c               |    2 +-
 drivers/scsi/sd.c                        |    2 +-
 drivers/staging/android/timed_output.c   |    2 +-
 drivers/staging/dgrp/dgrp_sysfs.c        |    2 +-
 drivers/uwb/lc-dev.c                     |    2 +-
 drivers/video/backlight/backlight.c      |    2 +-
 drivers/video/backlight/lcd.c            |    2 +-
 drivers/video/output.c                   |    2 +-
 drivers/xen/xenbus/xenbus_probe.c        |    2 +-
 mm/backing-dev.c                         |    5 ++---
 sound/sound_core.c                       |    2 +-
 23 files changed, 25 insertions(+), 26 deletions(-)

diff -puN drivers/base/attribute_container.c~drivers-avoid-format-string-in-dev_set_name drivers/base/attribute_container.c
--- a/drivers/base/attribute_container.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/base/attribute_container.c
@@ -167,7 +167,7 @@ attribute_container_add_device(struct de
 		ic->classdev.parent = get_device(dev);
 		ic->classdev.class = cont->class;
 		cont->class->dev_release = attribute_container_release;
-		dev_set_name(&ic->classdev, dev_name(dev));
+		dev_set_name(&ic->classdev, "%s", dev_name(dev));
 		if (fn)
 			fn(cont, dev, &ic->classdev);
 		else
diff -puN drivers/devfreq/devfreq.c~drivers-avoid-format-string-in-dev_set_name drivers/devfreq/devfreq.c
--- a/drivers/devfreq/devfreq.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/devfreq/devfreq.c
@@ -486,7 +486,7 @@ struct devfreq *devfreq_add_device(struc
 						GFP_KERNEL);
 	devfreq->last_stat_updated = jiffies;
 
-	dev_set_name(&devfreq->dev, dev_name(dev));
+	dev_set_name(&devfreq->dev, "%s", dev_name(dev));
 	err = device_register(&devfreq->dev);
 	if (err) {
 		put_device(&devfreq->dev);
diff -puN drivers/extcon/extcon-class.c~drivers-avoid-format-string-in-dev_set_name drivers/extcon/extcon-class.c
--- a/drivers/extcon/extcon-class.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/extcon/extcon-class.c
@@ -620,7 +620,7 @@ int extcon_dev_register(struct extcon_de
 	edev->dev->class = extcon_class;
 	edev->dev->release = extcon_dev_release;
 
-	dev_set_name(edev->dev, edev->name ? edev->name : dev_name(dev));
+	dev_set_name(edev->dev, "%s", edev->name ? edev->name : dev_name(dev));
 
 	if (edev->max_supported) {
 		char buf[10];
diff -puN drivers/hsi/hsi.c~drivers-avoid-format-string-in-dev_set_name drivers/hsi/hsi.c
--- a/drivers/hsi/hsi.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/hsi/hsi.c
@@ -75,7 +75,7 @@ static void hsi_new_client(struct hsi_po
 	cl->device.bus = &hsi_bus_type;
 	cl->device.parent = &port->device;
 	cl->device.release = hsi_client_release;
-	dev_set_name(&cl->device, info->name);
+	dev_set_name(&cl->device, "%s", info->name);
 	cl->device.platform_data = info->platform_data;
 	if (info->archdata)
 		cl->device.archdata = *info->archdata;
diff -puN drivers/ide/ide-cd.c~drivers-avoid-format-string-in-dev_set_name drivers/ide/ide-cd.c
--- a/drivers/ide/ide-cd.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/ide/ide-cd.c
@@ -1756,7 +1756,7 @@ static int ide_cd_probe(ide_drive_t *dri
 
 	info->dev.parent = &drive->gendev;
 	info->dev.release = ide_cd_release;
-	dev_set_name(&info->dev, dev_name(&drive->gendev));
+	dev_set_name(&info->dev, "%s", dev_name(&drive->gendev));
 
 	if (device_register(&info->dev))
 		goto out_free_disk;
diff -puN drivers/ide/ide-gd.c~drivers-avoid-format-string-in-dev_set_name drivers/ide/ide-gd.c
--- a/drivers/ide/ide-gd.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/ide/ide-gd.c
@@ -392,7 +392,7 @@ static int ide_gd_probe(ide_drive_t *dri
 
 	idkp->dev.parent = &drive->gendev;
 	idkp->dev.release = ide_disk_release;
-	dev_set_name(&idkp->dev, dev_name(&drive->gendev));
+	dev_set_name(&idkp->dev, "%s", dev_name(&drive->gendev));
 
 	if (device_register(&idkp->dev))
 		goto out_free_disk;
diff -puN drivers/ide/ide-probe.c~drivers-avoid-format-string-in-dev_set_name drivers/ide/ide-probe.c
--- a/drivers/ide/ide-probe.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/ide/ide-probe.c
@@ -545,7 +545,7 @@ static int ide_register_port(ide_hwif_t
 	int ret;
 
 	/* register with global device tree */
-	dev_set_name(&hwif->gendev, hwif->name);
+	dev_set_name(&hwif->gendev, "%s", hwif->name);
 	dev_set_drvdata(&hwif->gendev, hwif);
 	if (hwif->gendev.parent == NULL)
 		hwif->gendev.parent = hwif->dev;
@@ -559,7 +559,7 @@ static int ide_register_port(ide_hwif_t
 	}
 
 	hwif->portdev = device_create(ide_port_class, &hwif->gendev,
-				      MKDEV(0, 0), hwif, hwif->name);
+				      MKDEV(0, 0), hwif, "%s", hwif->name);
 	if (IS_ERR(hwif->portdev)) {
 		ret = PTR_ERR(hwif->portdev);
 		device_unregister(&hwif->gendev);
diff -puN drivers/ide/ide-tape.c~drivers-avoid-format-string-in-dev_set_name drivers/ide/ide-tape.c
--- a/drivers/ide/ide-tape.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/ide/ide-tape.c
@@ -1985,7 +1985,7 @@ static int ide_tape_probe(ide_drive_t *d
 
 	tape->dev.parent = &drive->gendev;
 	tape->dev.release = ide_tape_release;
-	dev_set_name(&tape->dev, dev_name(&drive->gendev));
+	dev_set_name(&tape->dev, "%s", dev_name(&drive->gendev));
 
 	if (device_register(&tape->dev))
 		goto out_free_disk;
diff -puN drivers/infiniband/core/sysfs.c~drivers-avoid-format-string-in-dev_set_name drivers/infiniband/core/sysfs.c
--- a/drivers/infiniband/core/sysfs.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/infiniband/core/sysfs.c
@@ -813,7 +813,7 @@ int ib_device_register_sysfs(struct ib_d
 
 	class_dev->class      = &ib_class;
 	class_dev->parent     = device->dma_device;
-	dev_set_name(class_dev, device->name);
+	dev_set_name(class_dev, "%s", device->name);
 	dev_set_drvdata(class_dev, device);
 
 	INIT_LIST_HEAD(&device->port_list);
diff -puN drivers/infiniband/hw/qib/qib_file_ops.c~drivers-avoid-format-string-in-dev_set_name drivers/infiniband/hw/qib/qib_file_ops.c
--- a/drivers/infiniband/hw/qib/qib_file_ops.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -2208,7 +2208,7 @@ int qib_cdev_init(int minor, const char
 		goto err_cdev;
 	}
 
-	device = device_create(qib_class, NULL, dev, NULL, name);
+	device = device_create(qib_class, NULL, dev, NULL, "%s", name);
 	if (!IS_ERR(device))
 		goto done;
 	ret = PTR_ERR(device);
diff -puN drivers/isdn/mISDN/dsp_pipeline.c~drivers-avoid-format-string-in-dev_set_name drivers/isdn/mISDN/dsp_pipeline.c
--- a/drivers/isdn/mISDN/dsp_pipeline.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/isdn/mISDN/dsp_pipeline.c
@@ -102,7 +102,7 @@ int mISDN_dsp_element_register(struct mI
 	entry->dev.class = elements_class;
 	entry->dev.release = mISDN_dsp_dev_release;
 	dev_set_drvdata(&entry->dev, elem);
-	dev_set_name(&entry->dev, elem->name);
+	dev_set_name(&entry->dev, "%s", elem->name);
 	ret = device_register(&entry->dev);
 	if (ret) {
 		printk(KERN_ERR "%s: failed to register %s\n",
diff -puN drivers/mtd/mtdcore.c~drivers-avoid-format-string-in-dev_set_name drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/mtd/mtdcore.c
@@ -1151,7 +1151,7 @@ static int __init mtd_bdi_init(struct ba
 
 	ret = bdi_init(bdi);
 	if (!ret)
-		ret = bdi_register(bdi, NULL, name);
+		ret = bdi_register(bdi, NULL, "%s", name);
 
 	if (ret)
 		bdi_destroy(bdi);
diff -puN drivers/platform/x86/wmi.c~drivers-avoid-format-string-in-dev_set_name drivers/platform/x86/wmi.c
--- a/drivers/platform/x86/wmi.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/platform/x86/wmi.c
@@ -743,7 +743,7 @@ static int wmi_create_device(const struc
 	wblock->dev.class = &wmi_class;
 
 	wmi_gtoa(gblock->guid, guid_string);
-	dev_set_name(&wblock->dev, guid_string);
+	dev_set_name(&wblock->dev, "%s", guid_string);
 
 	dev_set_drvdata(&wblock->dev, wblock);
 
diff -puN drivers/scsi/sd.c~drivers-avoid-format-string-in-dev_set_name drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/scsi/sd.c
@@ -2941,7 +2941,7 @@ static int sd_probe(struct device *dev)
 	device_initialize(&sdkp->dev);
 	sdkp->dev.parent = dev;
 	sdkp->dev.class = &sd_disk_class;
-	dev_set_name(&sdkp->dev, dev_name(dev));
+	dev_set_name(&sdkp->dev, "%s", dev_name(dev));
 
 	if (device_add(&sdkp->dev))
 		goto out_free_index;
diff -puN drivers/staging/android/timed_output.c~drivers-avoid-format-string-in-dev_set_name drivers/staging/android/timed_output.c
--- a/drivers/staging/android/timed_output.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/staging/android/timed_output.c
@@ -78,7 +78,7 @@ int timed_output_dev_register(struct tim
 
 	tdev->index = atomic_inc_return(&device_count);
 	tdev->dev = device_create(timed_output_class, NULL,
-		MKDEV(0, tdev->index), NULL, tdev->name);
+		MKDEV(0, tdev->index), NULL, "%s", tdev->name);
 	if (IS_ERR(tdev->dev))
 		return PTR_ERR(tdev->dev);
 
diff -puN drivers/staging/dgrp/dgrp_sysfs.c~drivers-avoid-format-string-in-dev_set_name drivers/staging/dgrp/dgrp_sysfs.c
--- a/drivers/staging/dgrp/dgrp_sysfs.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/staging/dgrp/dgrp_sysfs.c
@@ -273,7 +273,7 @@ void dgrp_create_node_class_sysfs_files(
 		sprintf(name, "node%ld", nd->nd_major);
 
 	nd->nd_class_dev = device_create(dgrp_class, dgrp_class_nodes_dev,
-		MKDEV(0, nd->nd_major), NULL, name);
+		MKDEV(0, nd->nd_major), NULL, "%s", name);
 
 	ret = sysfs_create_group(&nd->nd_class_dev->kobj,
 				 &dgrp_node_attribute_group);
diff -puN drivers/uwb/lc-dev.c~drivers-avoid-format-string-in-dev_set_name drivers/uwb/lc-dev.c
--- a/drivers/uwb/lc-dev.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/uwb/lc-dev.c
@@ -440,7 +440,7 @@ void uwbd_dev_onair(struct uwb_rc *rc, s
 	uwb_dev_init(uwb_dev);		/* This sets refcnt to one, we own it */
 	uwb_dev->mac_addr = *bce->mac_addr;
 	uwb_dev->dev_addr = bce->dev_addr;
-	dev_set_name(&uwb_dev->dev, macbuf);
+	dev_set_name(&uwb_dev->dev, "%s", macbuf);
 	result = uwb_dev_add(uwb_dev, &rc->uwb_dev.dev, rc);
 	if (result < 0) {
 		dev_err(dev, "new device %s: cannot instantiate device\n",
diff -puN drivers/video/backlight/backlight.c~drivers-avoid-format-string-in-dev_set_name drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/video/backlight/backlight.c
@@ -309,7 +309,7 @@ struct backlight_device *backlight_devic
 	new_bd->dev.class = backlight_class;
 	new_bd->dev.parent = parent;
 	new_bd->dev.release = bl_device_release;
-	dev_set_name(&new_bd->dev, name);
+	dev_set_name(&new_bd->dev, "%s", name);
 	dev_set_drvdata(&new_bd->dev, devdata);
 
 	/* Set default properties */
diff -puN drivers/video/backlight/lcd.c~drivers-avoid-format-string-in-dev_set_name drivers/video/backlight/lcd.c
--- a/drivers/video/backlight/lcd.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/video/backlight/lcd.c
@@ -219,7 +219,7 @@ struct lcd_device *lcd_device_register(c
 	new_ld->dev.class = lcd_class;
 	new_ld->dev.parent = parent;
 	new_ld->dev.release = lcd_device_release;
-	dev_set_name(&new_ld->dev, name);
+	dev_set_name(&new_ld->dev, "%s", name);
 	dev_set_drvdata(&new_ld->dev, devdata);
 
 	rc = device_register(&new_ld->dev);
diff -puN drivers/video/output.c~drivers-avoid-format-string-in-dev_set_name drivers/video/output.c
--- a/drivers/video/output.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/video/output.c
@@ -97,7 +97,7 @@ struct output_device *video_output_regis
 	new_dev->props = op;
 	new_dev->dev.class = &video_output_class;
 	new_dev->dev.parent = dev;
-	dev_set_name(&new_dev->dev, name);
+	dev_set_name(&new_dev->dev, "%s", name);
 	dev_set_drvdata(&new_dev->dev, devdata);
 	ret_code = device_register(&new_dev->dev);
 	if (ret_code) {
diff -puN drivers/xen/xenbus/xenbus_probe.c~drivers-avoid-format-string-in-dev_set_name drivers/xen/xenbus/xenbus_probe.c
--- a/drivers/xen/xenbus/xenbus_probe.c~drivers-avoid-format-string-in-dev_set_name
+++ a/drivers/xen/xenbus/xenbus_probe.c
@@ -447,7 +447,7 @@ int xenbus_probe_node(struct xen_bus_typ
 	if (err)
 		goto fail;
 
-	dev_set_name(&xendev->dev, devname);
+	dev_set_name(&xendev->dev, "%s", devname);
 
 	/* Register with generic device framework. */
 	err = device_register(&xendev->dev);
diff -puN mm/backing-dev.c~drivers-avoid-format-string-in-dev_set_name mm/backing-dev.c
--- a/mm/backing-dev.c~drivers-avoid-format-string-in-dev_set_name
+++ a/mm/backing-dev.c
@@ -515,7 +515,6 @@ EXPORT_SYMBOL(bdi_destroy);
 int bdi_setup_and_register(struct backing_dev_info *bdi, char *name,
 			   unsigned int cap)
 {
-	char tmp[32];
 	int err;
 
 	bdi->name = name;
@@ -524,8 +523,8 @@ int bdi_setup_and_register(struct backin
 	if (err)
 		return err;
 
-	sprintf(tmp, "%.28s%s", name, "-%d");
-	err = bdi_register(bdi, NULL, tmp, atomic_long_inc_return(&bdi_seq));
+	err = bdi_register(bdi, NULL, "%.28s-%ld", name,
+			   atomic_long_inc_return(&bdi_seq));
 	if (err) {
 		bdi_destroy(bdi);
 		return err;
diff -puN sound/sound_core.c~drivers-avoid-format-string-in-dev_set_name sound/sound_core.c
--- a/sound/sound_core.c~drivers-avoid-format-string-in-dev_set_name
+++ a/sound/sound_core.c
@@ -292,7 +292,7 @@ retry:
 	}
 
 	device_create(sound_class, dev, MKDEV(SOUND_MAJOR, s->unit_minor),
-		      NULL, s->name+6);
+		      NULL, "%s", s->name+6);
 	return s->unit_minor;
 
 fail:
_

Patches currently in -mm which might be from keescook@chromium.org are

linux-next.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
drivers-mtd-chips-gen_probec-refactor-call-to-request_module.patch
clean-up-scary-strncpydst-src-strlensrc-uses.patch
clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix.patch
block-do-not-pass-disk-names-as-format-strings.patch
crypto-sanitize-argument-for-format-string.patch
drivers-avoid-format-string-in-dev_set_name.patch
drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue.patch
drivers-avoid-parsing-names-as-kthread_run-format-strings.patch
isdn-clean-up-debug-format-string-usage.patch

