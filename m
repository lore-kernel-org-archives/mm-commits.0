From: akpm@osdl.org
Subject: - add-display-output-class-support.patch removed from -mm tree
Date: Wed, 20 Dec 2006 16:36:29 -0800
Message-ID: <200612210036.kBL0aTwO011201@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53287 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161097AbWLUAgl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:36:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luming.yu@gmail.com, Luming.yu@intel.com, adaplas@pol.net, greg@kroah.com, len.brown@intel.com, mm-commits@vger.kernel.org


The patch titled
     Add display output class support
has been removed from the -mm tree.  Its filename was
     add-display-output-class-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add display output class support
From: Yu Luming <luming.yu@gmail.com>

Add generic abstract layer for display output switch control.  The output
sysfs class driver provides an abstract video output layer that can be used to
hook platform specific methods to enable/disable video output device through
common sysfs interface.

Signed-off-by: Luming Yu <Luming.yu@intel.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/output.c       |  129 +++++++++++++++++++++++++++++++++
 include/linux/video_output.h |   42 ++++++++++
 2 files changed, 171 insertions(+)

diff -puN /dev/null drivers/video/output.c
--- /dev/null
+++ a/drivers/video/output.c
@@ -0,0 +1,129 @@
+/*
+ *  output.c - Display Output Switch driver
+ *
+ *  Copyright (C) 2006 Luming Yu <luming.yu@intel.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or (at
+ *  your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#include <linux/module.h>
+#include <linux/video_output.h>
+#include <linux/err.h>
+#include <linux/ctype.h>
+
+
+MODULE_DESCRIPTION("Display Output Switcher Lowlevel Control Abstraction");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Luming Yu <luming.yu@intel.com>");
+
+static ssize_t video_output_show_state(struct class_device *dev,char *buf)
+{
+	ssize_t ret_size = 0;
+	struct output_device *od = to_output_device(dev);
+	if (od->props)
+		ret_size = sprintf(buf,"%.8x\n",od->props->get_status(od));
+	return ret_size;
+}
+
+static ssize_t video_output_store_state(struct class_device *dev,
+	const char *buf,size_t count)
+{
+	char *endp;
+	struct output_device *od = to_output_device(dev);
+	int request_state = simple_strtoul(buf,&endp,0);
+	size_t size = endp - buf;
+
+	if (*endp && isspace(*endp))
+		size++;
+	if (size != count)
+		return -EINVAL;
+
+	if (od->props) {
+		od->request_state = request_state;
+		od->props->set_state(od);
+	}
+	return count;
+}
+
+static void video_output_class_release(struct class_device *dev)
+{
+	struct output_device *od = to_output_device(dev);
+	kfree(od);
+}
+
+static struct class_device_attribute video_output_attributes[] = {
+	__ATTR(state, 0644, video_output_show_state, video_output_store_state),
+	__ATTR_NULL,
+};
+
+static struct class video_output_class = {
+	.name = "video_output",
+	.release = video_output_class_release,
+	.class_dev_attrs = video_output_attributes,
+};
+
+struct output_device *video_output_register(const char *name,
+	struct device *dev,
+	void *devdata,
+	struct output_properties *op)
+{
+	struct output_device *new_dev;
+	int ret_code = 0;
+
+	new_dev = kzalloc(sizeof(struct output_device),GFP_KERNEL);
+	if (!new_dev) {
+		ret_code = -ENOMEM;
+		goto error_return;
+	}
+	new_dev->props = op;
+	new_dev->class_dev.class = &video_output_class;
+	new_dev->class_dev.dev = dev;
+	strlcpy(new_dev->class_dev.class_id,name,KOBJ_NAME_LEN);
+	class_set_devdata(&new_dev->class_dev,devdata);
+	ret_code = class_device_register(&new_dev->class_dev);
+	if (ret_code) {
+		kfree(new_dev);
+		goto error_return;
+	}
+	return new_dev;
+
+error_return:
+	return ERR_PTR(ret_code);
+}
+EXPORT_SYMBOL(video_output_register);
+
+void video_output_unregister(struct output_device *dev)
+{
+	if (!dev)
+		return;
+	class_device_unregister(&dev->class_dev);
+}
+EXPORT_SYMBOL(video_output_unregister);
+
+static void __exit video_output_class_exit(void)
+{
+	class_unregister(&video_output_class);
+}
+
+static int __init video_output_class_init(void)
+{
+	return class_register(&video_output_class);
+}
+
+postcore_initcall(video_output_class_init);
+module_exit(video_output_class_exit);
diff -puN /dev/null include/linux/video_output.h
--- /dev/null
+++ a/include/linux/video_output.h
@@ -0,0 +1,42 @@
+/*
+ *
+ *  Copyright (C) 2006 Luming Yu <luming.yu@intel.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or (at
+ *  your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#ifndef _LINUX_VIDEO_OUTPUT_H
+#define _LINUX_VIDEO_OUTPUT_H
+#include <linux/device.h>
+struct output_device;
+struct output_properties {
+	int (*set_state)(struct output_device *);
+	int (*get_status)(struct output_device *);
+};
+struct output_device {
+	int request_state;
+	struct output_properties *props;
+	struct class_device class_dev;
+};
+#define to_output_device(obj) container_of(obj, struct output_device, class_dev)
+struct output_device *video_output_register(const char *name,
+	struct device *dev,
+	void *devdata,
+	struct output_properties *op);
+void video_output_unregister(struct output_device *dev);
+#endif
_

Patches currently in -mm which might be from luming.yu@gmail.com are

git-acpi.patch

