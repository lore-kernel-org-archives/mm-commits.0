From: akpm@linux-foundation.org
Subject: - input-convert-from-class-devices-to-standard-devices.patch removed from -mm tree
Date: Mon, 04 Jun 2007 13:56:36 -0700
Message-ID: <200706042056.l54KuYCY018904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42817 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757475AbXFDU4x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 16:56:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dtor@insightbb.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     Input: convert from class devices to standard devices
has been removed from the -mm tree.  Its filename was
     input-convert-from-class-devices-to-standard-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Input: convert from class devices to standard devices
From: Dmitry Torokhov <dtor@insightbb.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/evdev.c    |   84 ++++++------
 drivers/input/input.c    |  136 +++++++++++---------
 drivers/input/joydev.c   |   84 ++++++------
 drivers/input/mousedev.c |  244 ++++++++++++++++++++-----------------
 drivers/input/tsdev.c    |   88 ++++++-------
 include/linux/input.h    |   20 +--
 6 files changed, 346 insertions(+), 310 deletions(-)

diff -puN drivers/input/evdev.c~input-convert-from-class-devices-to-standard-devices drivers/input/evdev.c
--- a/drivers/input/evdev.c~input-convert-from-class-devices-to-standard-devices
+++ a/drivers/input/evdev.c
@@ -30,6 +30,7 @@ struct evdev {
 	wait_queue_head_t wait;
 	struct evdev_client *grab;
 	struct list_head client_list;
+	struct device dev;
 };
 
 struct evdev_client {
@@ -94,8 +95,10 @@ static int evdev_flush(struct file *file
 	return input_flush_device(&evdev->handle, file);
 }
 
-static void evdev_free(struct evdev *evdev)
+static void evdev_free(struct device *dev)
 {
+	struct evdev *evdev = container_of(dev, struct evdev, dev);
+
 	evdev_table[evdev->minor] = NULL;
 	kfree(evdev);
 }
@@ -114,12 +117,10 @@ static int evdev_release(struct inode *i
 	list_del(&client->node);
 	kfree(client);
 
-	if (!--evdev->open) {
-		if (evdev->exist)
-			input_close_device(&evdev->handle);
-		else
-			evdev_free(evdev);
-	}
+	if (!--evdev->open && evdev->exist)
+		input_close_device(&evdev->handle);
+
+	put_device(&evdev->dev);
 
 	return 0;
 }
@@ -139,24 +140,32 @@ static int evdev_open(struct inode *inod
 	if (!evdev || !evdev->exist)
 		return -ENODEV;
 
+	get_device(&evdev->dev);
+
 	client = kzalloc(sizeof(struct evdev_client), GFP_KERNEL);
-	if (!client)
-		return -ENOMEM;
+	if (!client) {
+		error = -ENOMEM;
+		goto err_put_evdev;
+	}
 
 	client->evdev = evdev;
 	list_add_tail(&client->node, &evdev->client_list);
 
 	if (!evdev->open++ && evdev->exist) {
 		error = input_open_device(&evdev->handle);
-		if (error) {
-			list_del(&client->node);
-			kfree(client);
-			return error;
-		}
+		if (error)
+			goto err_free_client;
 	}
 
 	file->private_data = client;
 	return 0;
+
+ err_free_client:
+	list_del(&client->node);
+	kfree(client);
+ err_put_evdev:
+	put_device(&evdev->dev);
+	return error;
 }
 
 #ifdef CONFIG_COMPAT
@@ -625,8 +634,6 @@ static int evdev_connect(struct input_ha
 			 const struct input_device_id *id)
 {
 	struct evdev *evdev;
-	struct class_device *cdev;
-	dev_t devt;
 	int minor;
 	int error;
 
@@ -649,38 +656,32 @@ static int evdev_connect(struct input_ha
 	evdev->handle.name = evdev->name;
 	evdev->handle.handler = handler;
 	evdev->handle.private = evdev;
-	sprintf(evdev->name, "event%d", minor);
-
-	evdev_table[minor] = evdev;
+	snprintf(evdev->name, sizeof(evdev->name), "event%d", minor);
 
-	devt = MKDEV(INPUT_MAJOR, EVDEV_MINOR_BASE + minor),
+	snprintf(evdev->dev.bus_id, sizeof(evdev->dev.bus_id),
+		 "event%d", minor);
+	evdev->dev.class = &input_class;
+	evdev->dev.parent = &dev->dev;
+	evdev->dev.devt = MKDEV(INPUT_MAJOR, EVDEV_MINOR_BASE + minor);
+	evdev->dev.release = evdev_free;
+	device_initialize(&evdev->dev);
 
-	cdev = class_device_create(&input_class, &dev->cdev, devt,
-				   dev->cdev.dev, evdev->name);
-	if (IS_ERR(cdev)) {
-		error = PTR_ERR(cdev);
-		goto err_free_evdev;
-	}
+	evdev_table[minor] = evdev;
 
-	/* temporary symlink to keep userspace happy */
-	error = sysfs_create_link(&input_class.subsys.kobj,
-				  &cdev->kobj, evdev->name);
+	error = device_add(&evdev->dev);
 	if (error)
-		goto err_cdev_destroy;
+		goto err_free_evdev;
 
 	error = input_register_handle(&evdev->handle);
 	if (error)
-		goto err_remove_link;
+		goto err_delete_evdev;
 
 	return 0;
 
- err_remove_link:
-	sysfs_remove_link(&input_class.subsys.kobj, evdev->name);
- err_cdev_destroy:
-	class_device_destroy(&input_class, devt);
+ err_delete_evdev:
+	device_del(&evdev->dev);
  err_free_evdev:
-	kfree(evdev);
-	evdev_table[minor] = NULL;
+	put_device(&evdev->dev);
 	return error;
 }
 
@@ -690,10 +691,8 @@ static void evdev_disconnect(struct inpu
 	struct evdev_client *client;
 
 	input_unregister_handle(handle);
+	device_del(&evdev->dev);
 
-	sysfs_remove_link(&input_class.subsys.kobj, evdev->name);
-	class_device_destroy(&input_class,
-			MKDEV(INPUT_MAJOR, EVDEV_MINOR_BASE + evdev->minor));
 	evdev->exist = 0;
 
 	if (evdev->open) {
@@ -702,8 +701,9 @@ static void evdev_disconnect(struct inpu
 		list_for_each_entry(client, &evdev->client_list, node)
 			kill_fasync(&client->fasync, SIGIO, POLL_HUP);
 		wake_up_interruptible(&evdev->wait);
-	} else
-		evdev_free(evdev);
+	}
+
+	put_device(&evdev->dev);
 }
 
 static const struct input_device_id evdev_ids[] = {
diff -puN drivers/input/input.c~input-convert-from-class-devices-to-standard-devices drivers/input/input.c
--- a/drivers/input/input.c~input-convert-from-class-devices-to-standard-devices
+++ a/drivers/input/input.c
@@ -442,7 +442,7 @@ static int input_attach_handler(struct i
 		printk(KERN_ERR
 			"input: failed to attach handler %s to device %s, "
 			"error: %d\n",
-			handler->name, kobject_name(&dev->cdev.kobj), error);
+			handler->name, kobject_name(&dev->dev.kobj), error);
 
 	return error;
 }
@@ -506,7 +506,7 @@ static void input_seq_print_bitmap(struc
 static int input_devices_seq_show(struct seq_file *seq, void *v)
 {
 	struct input_dev *dev = container_of(v, struct input_dev, node);
-	const char *path = kobject_get_path(&dev->cdev.kobj, GFP_KERNEL);
+	const char *path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
 	struct input_handle *handle;
 
 	seq_printf(seq, "I: Bus=%04x Vendor=%04x Product=%04x Version=%04x\n",
@@ -661,15 +661,17 @@ static inline int input_proc_init(void) 
 static inline void input_proc_exit(void) { }
 #endif
 
-#define INPUT_DEV_STRING_ATTR_SHOW(name)					\
-static ssize_t input_dev_show_##name(struct class_device *dev, char *buf)	\
-{										\
-	struct input_dev *input_dev = to_input_dev(dev);			\
-										\
-	return scnprintf(buf, PAGE_SIZE, "%s\n",				\
-			 input_dev->name ? input_dev->name : "");		\
-}										\
-static CLASS_DEVICE_ATTR(name, S_IRUGO, input_dev_show_##name, NULL);
+#define INPUT_DEV_STRING_ATTR_SHOW(name)				\
+static ssize_t input_dev_show_##name(struct device *dev,		\
+				     struct device_attribute *attr,	\
+				     char *buf)				\
+{									\
+	struct input_dev *input_dev = to_input_dev(dev);		\
+									\
+	return scnprintf(buf, PAGE_SIZE, "%s\n",			\
+			 input_dev->name ? input_dev->name : "");	\
+}									\
+static DEVICE_ATTR(name, S_IRUGO, input_dev_show_##name, NULL)
 
 INPUT_DEV_STRING_ATTR_SHOW(name);
 INPUT_DEV_STRING_ATTR_SHOW(phys);
@@ -723,7 +725,9 @@ static int input_print_modalias(char *bu
 	return len;
 }
 
-static ssize_t input_dev_show_modalias(struct class_device *dev, char *buf)
+static ssize_t input_dev_show_modalias(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
 {
 	struct input_dev *id = to_input_dev(dev);
 	ssize_t len;
@@ -732,13 +736,13 @@ static ssize_t input_dev_show_modalias(s
 
 	return min_t(int, len, PAGE_SIZE);
 }
-static CLASS_DEVICE_ATTR(modalias, S_IRUGO, input_dev_show_modalias, NULL);
+static DEVICE_ATTR(modalias, S_IRUGO, input_dev_show_modalias, NULL);
 
 static struct attribute *input_dev_attrs[] = {
-	&class_device_attr_name.attr,
-	&class_device_attr_phys.attr,
-	&class_device_attr_uniq.attr,
-	&class_device_attr_modalias.attr,
+	&dev_attr_name.attr,
+	&dev_attr_phys.attr,
+	&dev_attr_uniq.attr,
+	&dev_attr_modalias.attr,
 	NULL
 };
 
@@ -746,13 +750,15 @@ static struct attribute_group input_dev_
 	.attrs	= input_dev_attrs,
 };
 
-#define INPUT_DEV_ID_ATTR(name)							\
-static ssize_t input_dev_show_id_##name(struct class_device *dev, char *buf)	\
-{										\
-	struct input_dev *input_dev = to_input_dev(dev);			\
-	return scnprintf(buf, PAGE_SIZE, "%04x\n", input_dev->id.name);		\
-}										\
-static CLASS_DEVICE_ATTR(name, S_IRUGO, input_dev_show_id_##name, NULL);
+#define INPUT_DEV_ID_ATTR(name)						\
+static ssize_t input_dev_show_id_##name(struct device *dev,		\
+					struct device_attribute *attr,	\
+					char *buf)			\
+{									\
+	struct input_dev *input_dev = to_input_dev(dev);		\
+	return scnprintf(buf, PAGE_SIZE, "%04x\n", input_dev->id.name);	\
+}									\
+static DEVICE_ATTR(name, S_IRUGO, input_dev_show_id_##name, NULL)
 
 INPUT_DEV_ID_ATTR(bustype);
 INPUT_DEV_ID_ATTR(vendor);
@@ -760,10 +766,10 @@ INPUT_DEV_ID_ATTR(product);
 INPUT_DEV_ID_ATTR(version);
 
 static struct attribute *input_dev_id_attrs[] = {
-	&class_device_attr_bustype.attr,
-	&class_device_attr_vendor.attr,
-	&class_device_attr_product.attr,
-	&class_device_attr_version.attr,
+	&dev_attr_bustype.attr,
+	&dev_attr_vendor.attr,
+	&dev_attr_product.attr,
+	&dev_attr_version.attr,
 	NULL
 };
 
@@ -792,15 +798,17 @@ static int input_print_bitmap(char *buf,
 	return len;
 }
 
-#define INPUT_DEV_CAP_ATTR(ev, bm)						\
-static ssize_t input_dev_show_cap_##bm(struct class_device *dev, char *buf)	\
-{										\
-	struct input_dev *input_dev = to_input_dev(dev);			\
-	int len = input_print_bitmap(buf, PAGE_SIZE,				\
-				     input_dev->bm##bit, ev##_MAX, 1);		\
-	return min_t(int, len, PAGE_SIZE);					\
-}										\
-static CLASS_DEVICE_ATTR(bm, S_IRUGO, input_dev_show_cap_##bm, NULL);
+#define INPUT_DEV_CAP_ATTR(ev, bm)					\
+static ssize_t input_dev_show_cap_##bm(struct device *dev,		\
+				       struct device_attribute *attr,	\
+				       char *buf)			\
+{									\
+	struct input_dev *input_dev = to_input_dev(dev);		\
+	int len = input_print_bitmap(buf, PAGE_SIZE,			\
+				     input_dev->bm##bit, ev##_MAX, 1);	\
+	return min_t(int, len, PAGE_SIZE);				\
+}									\
+static DEVICE_ATTR(bm, S_IRUGO, input_dev_show_cap_##bm, NULL)
 
 INPUT_DEV_CAP_ATTR(EV, ev);
 INPUT_DEV_CAP_ATTR(KEY, key);
@@ -813,15 +821,15 @@ INPUT_DEV_CAP_ATTR(FF, ff);
 INPUT_DEV_CAP_ATTR(SW, sw);
 
 static struct attribute *input_dev_caps_attrs[] = {
-	&class_device_attr_ev.attr,
-	&class_device_attr_key.attr,
-	&class_device_attr_rel.attr,
-	&class_device_attr_abs.attr,
-	&class_device_attr_msc.attr,
-	&class_device_attr_led.attr,
-	&class_device_attr_snd.attr,
-	&class_device_attr_ff.attr,
-	&class_device_attr_sw.attr,
+	&dev_attr_ev.attr,
+	&dev_attr_key.attr,
+	&dev_attr_rel.attr,
+	&dev_attr_abs.attr,
+	&dev_attr_msc.attr,
+	&dev_attr_led.attr,
+	&dev_attr_snd.attr,
+	&dev_attr_ff.attr,
+	&dev_attr_sw.attr,
 	NULL
 };
 
@@ -837,9 +845,9 @@ static struct attribute_group *input_dev
 	NULL
 };
 
-static void input_dev_release(struct class_device *class_dev)
+static void input_dev_release(struct device *device)
 {
-	struct input_dev *dev = to_input_dev(class_dev);
+	struct input_dev *dev = to_input_dev(device);
 
 	input_ff_destroy(dev);
 	kfree(dev);
@@ -926,10 +934,10 @@ static int input_add_uevent_modalias_var
 			return err;					\
 	} while (0)
 
-static int input_dev_uevent(struct class_device *cdev, char **envp,
+static int input_dev_uevent(struct device *device, char **envp,
 			    int num_envp, char *buffer, int buffer_size)
 {
-	struct input_dev *dev = to_input_dev(cdev);
+	struct input_dev *dev = to_input_dev(device);
 	int i = 0;
 	int len = 0;
 
@@ -967,10 +975,14 @@ static int input_dev_uevent(struct class
 	return 0;
 }
 
+static struct device_type input_dev_type = {
+	.groups		= input_dev_attr_groups,
+	.release	= input_dev_release,
+	.uevent		= input_dev_uevent,
+};
+
 struct class input_class = {
-	.name			= "input",
-	.release		= input_dev_release,
-	.uevent			= input_dev_uevent,
+	.name		= "input",
 };
 EXPORT_SYMBOL_GPL(input_class);
 
@@ -989,9 +1001,9 @@ struct input_dev *input_allocate_device(
 
 	dev = kzalloc(sizeof(struct input_dev), GFP_KERNEL);
 	if (dev) {
-		dev->cdev.class = &input_class;
-		dev->cdev.groups = input_dev_attr_groups;
-		class_device_initialize(&dev->cdev);
+		dev->dev.type = &input_dev_type;
+		dev->dev.class = &input_class;
+		device_initialize(&dev->dev);
 		mutex_init(&dev->mutex);
 		INIT_LIST_HEAD(&dev->h_list);
 		INIT_LIST_HEAD(&dev->node);
@@ -1110,17 +1122,17 @@ int input_register_device(struct input_d
 
 	list_add_tail(&dev->node, &input_dev_list);
 
-	snprintf(dev->cdev.class_id, sizeof(dev->cdev.class_id),
+	snprintf(dev->dev.bus_id, sizeof(dev->dev.bus_id),
 		 "input%ld", (unsigned long) atomic_inc_return(&input_no) - 1);
 
-	if (!dev->cdev.dev)
-		dev->cdev.dev = dev->dev.parent;
+	if (dev->cdev.dev)
+		dev->dev.parent = dev->cdev.dev;
 
-	error = class_device_add(&dev->cdev);
+	error = device_add(&dev->dev);
 	if (error)
 		return error;
 
-	path = kobject_get_path(&dev->cdev.kobj, GFP_KERNEL);
+	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
 	printk(KERN_INFO "input: %s as %s\n",
 		dev->name ? dev->name : "Unspecified device", path ? path : "N/A");
 	kfree(path);
@@ -1152,7 +1164,7 @@ void input_unregister_device(struct inpu
 
 	list_del_init(&dev->node);
 
-	class_device_unregister(&dev->cdev);
+	device_unregister(&dev->dev);
 
 	input_wakeup_procfs_readers();
 }
diff -puN drivers/input/joydev.c~input-convert-from-class-devices-to-standard-devices drivers/input/joydev.c
--- a/drivers/input/joydev.c~input-convert-from-class-devices-to-standard-devices
+++ a/drivers/input/joydev.c
@@ -43,6 +43,8 @@ struct joydev {
 	struct input_handle handle;
 	wait_queue_head_t wait;
 	struct list_head client_list;
+	struct device dev;
+
 	struct js_corr corr[ABS_MAX + 1];
 	struct JS_DATA_SAVE_TYPE glue;
 	int nabs;
@@ -161,8 +163,10 @@ static int joydev_fasync(int fd, struct 
 	return retval < 0 ? retval : 0;
 }
 
-static void joydev_free(struct joydev *joydev)
+static void joydev_free(struct device *dev)
 {
+	struct joydev *joydev = container_of(dev, struct joydev, dev);
+
 	joydev_table[joydev->minor] = NULL;
 	kfree(joydev);
 }
@@ -177,12 +181,10 @@ static int joydev_release(struct inode *
 	list_del(&client->node);
 	kfree(client);
 
-	if (!--joydev->open) {
-		if (joydev->exist)
-			input_close_device(&joydev->handle);
-		else
-			joydev_free(joydev);
-	}
+	if (!--joydev->open && joydev->exist)
+		input_close_device(&joydev->handle);
+
+	put_device(&joydev->dev);
 
 	return 0;
 }
@@ -201,24 +203,32 @@ static int joydev_open(struct inode *ino
 	if (!joydev || !joydev->exist)
 		return -ENODEV;
 
+	get_device(&joydev->dev);
+
 	client = kzalloc(sizeof(struct joydev_client), GFP_KERNEL);
-	if (!client)
-		return -ENOMEM;
+	if (!client) {
+		error = -ENOMEM;
+		goto err_put_joydev;
+	}
 
 	client->joydev = joydev;
 	list_add_tail(&client->node, &joydev->client_list);
 
 	if (!joydev->open++ && joydev->exist) {
 		error = input_open_device(&joydev->handle);
-		if (error) {
-			list_del(&client->node);
-			kfree(client);
-			return error;
-		}
+		if (error)
+			goto err_free_client;
 	}
 
 	file->private_data = client;
 	return 0;
+
+ err_free_client:
+	list_del(&client->node);
+	kfree(client);
+ err_put_joydev:
+	put_device(&joydev->dev);
+	return error;
 }
 
 static ssize_t joydev_write(struct file *file, const char __user *buffer, size_t count, loff_t *ppos)
@@ -504,8 +514,6 @@ static int joydev_connect(struct input_h
 			  const struct input_device_id *id)
 {
 	struct joydev *joydev;
-	struct class_device *cdev;
-	dev_t devt;
 	int i, j, minor;
 	int error;
 
@@ -528,7 +536,7 @@ static int joydev_connect(struct input_h
 	joydev->handle.name = joydev->name;
 	joydev->handle.handler = handler;
 	joydev->handle.private = joydev;
-	sprintf(joydev->name, "js%d", minor);
+	snprintf(joydev->name, sizeof(joydev->name), "js%d", minor);
 
 	for (i = 0; i < ABS_MAX + 1; i++)
 		if (test_bit(i, dev->absbit)) {
@@ -572,36 +580,30 @@ static int joydev_connect(struct input_h
 		joydev->abs[i] = joydev_correct(dev->abs[j], joydev->corr + i);
 	}
 
-	joydev_table[minor] = joydev;
-
-	devt = MKDEV(INPUT_MAJOR, JOYDEV_MINOR_BASE + minor),
+	snprintf(joydev->dev.bus_id, sizeof(joydev->dev.bus_id),
+		 "js%d", minor);
+	joydev->dev.class = &input_class;
+	joydev->dev.parent = &dev->dev;
+	joydev->dev.devt = MKDEV(INPUT_MAJOR, JOYDEV_MINOR_BASE + minor);
+	joydev->dev.release = joydev_free;
+	device_initialize(&joydev->dev);
 
-	cdev = class_device_create(&input_class, &dev->cdev, devt,
-				   dev->cdev.dev, joydev->name);
-	if (IS_ERR(cdev)) {
-		error = PTR_ERR(cdev);
-		goto err_free_joydev;
-	}
+	joydev_table[minor] = joydev;
 
-	/* temporary symlink to keep userspace happy */
-	error = sysfs_create_link(&input_class.subsys.kobj,
-				  &cdev->kobj, joydev->name);
+	error = device_add(&joydev->dev);
 	if (error)
-		goto err_cdev_destroy;
+		goto err_free_joydev;
 
 	error = input_register_handle(&joydev->handle);
 	if (error)
-		goto err_remove_link;
+		goto err_delete_joydev;
 
 	return 0;
 
- err_remove_link:
-	sysfs_remove_link(&input_class.subsys.kobj, joydev->name);
- err_cdev_destroy:
-	class_device_destroy(&input_class, devt);
+ err_delete_joydev:
+	device_del(&joydev->dev);
  err_free_joydev:
-	joydev_table[minor] = NULL;
-	kfree(joydev);
+	put_device(&joydev->dev);
 	return error;
 }
 
@@ -612,9 +614,8 @@ static void joydev_disconnect(struct inp
 	struct joydev_client *client;
 
 	input_unregister_handle(handle);
+	device_del(&joydev->dev);
 
-	sysfs_remove_link(&input_class.subsys.kobj, joydev->name);
-	class_device_destroy(&input_class, MKDEV(INPUT_MAJOR, JOYDEV_MINOR_BASE + joydev->minor));
 	joydev->exist = 0;
 
 	if (joydev->open) {
@@ -622,8 +623,9 @@ static void joydev_disconnect(struct inp
 		list_for_each_entry(client, &joydev->client_list, node)
 			kill_fasync(&client->fasync, SIGIO, POLL_HUP);
 		wake_up_interruptible(&joydev->wait);
-	} else
-		joydev_free(joydev);
+	}
+
+	put_device(&joydev->dev);
 }
 
 static const struct input_device_id joydev_blacklist[] = {
diff -puN drivers/input/mousedev.c~input-convert-from-class-devices-to-standard-devices drivers/input/mousedev.c
--- a/drivers/input/mousedev.c~input-convert-from-class-devices-to-standard-devices
+++ a/drivers/input/mousedev.c
@@ -21,7 +21,7 @@
 #include <linux/input.h>
 #include <linux/random.h>
 #include <linux/major.h>
-#include <linux/device.h>
+ #include <linux/device.h>
 #ifdef CONFIG_INPUT_MOUSEDEV_PSAUX
 #include <linux/miscdevice.h>
 #endif
@@ -64,6 +64,7 @@ struct mousedev {
 	wait_queue_head_t wait;
 	struct list_head client_list;
 	struct input_handle handle;
+	struct device dev;
 
 	struct list_head mixdev_node;
 	int mixdev_open;
@@ -112,7 +113,7 @@ static unsigned char mousedev_imex_seq[]
 static struct input_handler mousedev_handler;
 
 static struct mousedev *mousedev_table[MOUSEDEV_MINORS];
-static struct mousedev mousedev_mix;
+static struct mousedev *mousedev_mix;
 static LIST_HEAD(mousedev_mix_list);
 
 #define fx(i)  (mousedev->old_x[(mousedev->pkt_count - (i)) & 03])
@@ -218,10 +219,10 @@ static void mousedev_key_event(struct mo
 
 	if (value) {
 		set_bit(index, &mousedev->packet.buttons);
-		set_bit(index, &mousedev_mix.packet.buttons);
+		set_bit(index, &mousedev_mix->packet.buttons);
 	} else {
 		clear_bit(index, &mousedev->packet.buttons);
-		clear_bit(index, &mousedev_mix.packet.buttons);
+		clear_bit(index, &mousedev_mix->packet.buttons);
 	}
 }
 
@@ -287,11 +288,11 @@ static void mousedev_touchpad_touch(stru
 			 * motion packet so we won't mess current position.
 			 */
 			set_bit(0, &mousedev->packet.buttons);
-			set_bit(0, &mousedev_mix.packet.buttons);
-			mousedev_notify_readers(mousedev, &mousedev_mix.packet);
-			mousedev_notify_readers(&mousedev_mix, &mousedev_mix.packet);
+			set_bit(0, &mousedev_mix->packet.buttons);
+			mousedev_notify_readers(mousedev, &mousedev_mix->packet);
+			mousedev_notify_readers(mousedev_mix, &mousedev_mix->packet);
 			clear_bit(0, &mousedev->packet.buttons);
-			clear_bit(0, &mousedev_mix.packet.buttons);
+			clear_bit(0, &mousedev_mix->packet.buttons);
 		}
 		mousedev->touch = mousedev->pkt_count = 0;
 		mousedev->frac_dx = 0;
@@ -343,7 +344,7 @@ static void mousedev_event(struct input_
 				}
 
 				mousedev_notify_readers(mousedev, &mousedev->packet);
-				mousedev_notify_readers(&mousedev_mix, &mousedev->packet);
+				mousedev_notify_readers(mousedev_mix, &mousedev->packet);
 
 				mousedev->packet.dx = mousedev->packet.dy = mousedev->packet.dz = 0;
 				mousedev->packet.abs_event = 0;
@@ -362,8 +363,10 @@ static int mousedev_fasync(int fd, struc
 	return retval < 0 ? retval : 0;
 }
 
-static void mousedev_free(struct mousedev *mousedev)
+static void mousedev_free(struct device *dev)
 {
+	struct mousedev *mousedev = container_of(dev, struct mousedev, dev);
+
 	mousedev_table[mousedev->minor] = NULL;
 	kfree(mousedev);
 }
@@ -372,15 +375,16 @@ static int mixdev_add_device(struct mous
 {
 	int error;
 
-	if (mousedev_mix.open) {
+	if (mousedev_mix->open) {
 		error = input_open_device(&mousedev->handle);
 		if (error)
 			return error;
 
 		mousedev->open++;
-		mousedev->mixdev_open++;
+		mousedev->mixdev_open = 1;
 	}
 
+	get_device(&mousedev->dev);
 	list_add_tail(&mousedev->mixdev_node, &mousedev_mix_list);
 
 	return 0;
@@ -395,36 +399,40 @@ static void mixdev_remove_device(struct 
 	}
 
 	list_del_init(&mousedev->mixdev_node);
+	put_device(&mousedev->dev);
 }
 
 static void mixdev_open_devices(void)
 {
 	struct mousedev *mousedev;
 
+	if (mousedev_mix->open++)
+		return;
+
 	list_for_each_entry(mousedev, &mousedev_mix_list, mixdev_node) {
-		if (mousedev->exist && !mousedev->open) {
-			if (input_open_device(&mousedev->handle))
-				continue;
+		if (!mousedev->mixdev_open) {
+			if (!mousedev->open && mousedev->exist)
+				if (input_open_device(&mousedev->handle))
+					continue;
 
 			mousedev->open++;
-			mousedev->mixdev_open++;
+			mousedev->mixdev_open = 1;
 		}
 	}
 }
 
 static void mixdev_close_devices(void)
 {
-	struct mousedev *mousedev, *next;
+	struct mousedev *mousedev;
 
-	list_for_each_entry_safe(mousedev, next, &mousedev_mix_list, mixdev_node) {
+	if (--mousedev_mix->open)
+		return;
+
+	list_for_each_entry(mousedev, &mousedev_mix_list, mixdev_node) {
 		if (mousedev->mixdev_open) {
 			mousedev->mixdev_open = 0;
-			if (!--mousedev->open) {
-				if (mousedev->exist)
-					input_close_device(&mousedev->handle);
-				else
-					mousedev_free(mousedev);
-			}
+			if (!--mousedev->open && mousedev->exist)
+				input_close_device(&mousedev->handle);
 		}
 	}
 }
@@ -439,14 +447,12 @@ static int mousedev_release(struct inode
 	list_del(&client->node);
 	kfree(client);
 
-	if (!--mousedev->open) {
-		if (mousedev->minor == MOUSEDEV_MIX)
-			mixdev_close_devices();
-		else if (mousedev->exist)
-			input_close_device(&mousedev->handle);
-		else
-			mousedev_free(mousedev);
-	}
+	if (mousedev->minor == MOUSEDEV_MIX)
+		mixdev_close_devices();
+	else if (!--mousedev->open && mousedev->exist)
+		input_close_device(&mousedev->handle);
+
+	put_device(&mousedev->dev);
 
 	return 0;
 }
@@ -473,9 +479,13 @@ static int mousedev_open(struct inode *i
 	if (!mousedev)
 		return -ENODEV;
 
+	get_device(&mousedev->dev);
+
 	client = kzalloc(sizeof(struct mousedev_client), GFP_KERNEL);
-	if (!client)
-		return -ENOMEM;
+	if (!client) {
+		error = -ENOMEM;
+		goto err_put_mousedev;
+	}
 
 	spin_lock_init(&client->packet_lock);
 	client->pos_x = xres / 2;
@@ -483,21 +493,23 @@ static int mousedev_open(struct inode *i
 	client->mousedev = mousedev;
 	list_add_tail(&client->node, &mousedev->client_list);
 
-	if (!mousedev->open++) {
-		if (mousedev->minor == MOUSEDEV_MIX)
-			mixdev_open_devices();
-		else if (mousedev->exist) {
-			error = input_open_device(&mousedev->handle);
-			if (error) {
-				list_del(&client->node);
-				kfree(client);
-				return error;
-			}
-		}
+	if (mousedev->minor == MOUSEDEV_MIX)
+		mixdev_open_devices();
+	else if (!mousedev->open++ && mousedev->exist) {
+		error = input_open_device(&mousedev->handle);
+		if (error)
+			goto err_free_client;
 	}
 
 	file->private_data = client;
 	return 0;
+
+ err_free_client:
+	list_del(&client->node);
+	kfree(client);
+ err_put_mousedev:
+	put_device(&mousedev->dev);
+	return error;
 }
 
 static inline int mousedev_limit_delta(int delta, int limit)
@@ -680,57 +692,96 @@ static const struct file_operations mous
 	.fasync =	mousedev_fasync,
 };
 
-static int mousedev_connect(struct input_handler *handler, struct input_dev *dev,
-			    const struct input_device_id *id)
+static struct mousedev *mousedev_create(struct input_dev *dev,
+					struct input_handler *handler,
+					int minor)
 {
 	struct mousedev *mousedev;
-	struct class_device *cdev;
-	dev_t devt;
-	int minor;
 	int error;
 
-	for (minor = 0; minor < MOUSEDEV_MINORS && mousedev_table[minor]; minor++);
-	if (minor == MOUSEDEV_MINORS) {
-		printk(KERN_ERR "mousedev: no more free mousedev devices\n");
-		return -ENFILE;
-	}
-
 	mousedev = kzalloc(sizeof(struct mousedev), GFP_KERNEL);
-	if (!mousedev)
-		return -ENOMEM;
+	if (!mousedev) {
+		error = -ENOMEM;
+		goto err_out;
+	}
 
 	INIT_LIST_HEAD(&mousedev->client_list);
 	INIT_LIST_HEAD(&mousedev->mixdev_node);
 	init_waitqueue_head(&mousedev->wait);
 
+	if (minor == MOUSEDEV_MIX)
+		strlcpy(mousedev->name, "mice", sizeof(mousedev->name));
+	else
+		snprintf(mousedev->name, sizeof(mousedev->name),
+			 "mouse%d", minor);
+
 	mousedev->minor = minor;
 	mousedev->exist = 1;
 	mousedev->handle.dev = dev;
 	mousedev->handle.name = mousedev->name;
 	mousedev->handle.handler = handler;
 	mousedev->handle.private = mousedev;
-	sprintf(mousedev->name, "mouse%d", minor);
 
-	mousedev_table[minor] = mousedev;
+	strlcpy(mousedev->dev.bus_id, mousedev->name,
+		sizeof(mousedev->dev.bus_id));
+	mousedev->dev.class = &input_class;
+	if (dev)
+		mousedev->dev.parent = &dev->dev;
+	mousedev->dev.devt = MKDEV(INPUT_MAJOR, MOUSEDEV_MINOR_BASE + minor);
+	mousedev->dev.release = mousedev_free;
+	device_initialize(&mousedev->dev);
 
-	devt = MKDEV(INPUT_MAJOR, MOUSEDEV_MINOR_BASE + minor),
+	mousedev_table[minor] = mousedev;
 
-	cdev = class_device_create(&input_class, &dev->cdev, devt,
-				   dev->cdev.dev, mousedev->name);
-	if (IS_ERR(cdev)) {
-		error = PTR_ERR(cdev);
+	error = device_add(&mousedev->dev);
+	if (error)
 		goto err_free_mousedev;
+
+	return mousedev;
+
+ err_free_mousedev:
+	put_device(&mousedev->dev);
+ err_out:
+	return ERR_PTR(error);
+}
+
+static void mousedev_destroy(struct mousedev *mousedev)
+{
+	struct mousedev_client *client;
+
+	device_del(&mousedev->dev);
+	mousedev->exist = 0;
+
+	if (mousedev->open) {
+		input_close_device(&mousedev->handle);
+		list_for_each_entry(client, &mousedev->client_list, node)
+			kill_fasync(&client->fasync, SIGIO, POLL_HUP);
+		wake_up_interruptible(&mousedev->wait);
 	}
 
-	/* temporary symlink to keep userspace happy */
-	error = sysfs_create_link(&input_class.subsys.kobj,
-				  &cdev->kobj, mousedev->name);
-	if (error)
-		goto err_cdev_destroy;
+	put_device(&mousedev->dev);
+}
+
+static int mousedev_connect(struct input_handler *handler, struct input_dev *dev,
+			    const struct input_device_id *id)
+{
+	struct mousedev *mousedev;
+	int minor;
+	int error;
+
+	for (minor = 0; minor < MOUSEDEV_MINORS && mousedev_table[minor]; minor++);
+	if (minor == MOUSEDEV_MINORS) {
+		printk(KERN_ERR "mousedev: no more free mousedev devices\n");
+		return -ENFILE;
+	}
+
+	mousedev = mousedev_create(dev, handler, minor);
+	if (IS_ERR(mousedev))
+		return PTR_ERR(mousedev);
 
 	error = input_register_handle(&mousedev->handle);
 	if (error)
-		goto err_remove_link;
+		goto err_delete_mousedev;
 
 	error = mixdev_add_device(mousedev);
 	if (error)
@@ -740,37 +791,18 @@ static int mousedev_connect(struct input
 
  err_unregister_handle:
 	input_unregister_handle(&mousedev->handle);
- err_remove_link:
-	sysfs_remove_link(&input_class.subsys.kobj, mousedev->name);
- err_cdev_destroy:
-	class_device_destroy(&input_class, devt);
- err_free_mousedev:
-	mousedev_table[minor] = NULL;
-	kfree(mousedev);
+ err_delete_mousedev:
+	device_unregister(&mousedev->dev);
 	return error;
 }
 
 static void mousedev_disconnect(struct input_handle *handle)
 {
 	struct mousedev *mousedev = handle->private;
-	struct mousedev_client *client;
-
-	input_unregister_handle(handle);
-
-	sysfs_remove_link(&input_class.subsys.kobj, mousedev->name);
-	class_device_destroy(&input_class,
-			MKDEV(INPUT_MAJOR, MOUSEDEV_MINOR_BASE + mousedev->minor));
-	mousedev->exist = 0;
 
 	mixdev_remove_device(mousedev);
-
-	if (mousedev->open) {
-		input_close_device(handle);
-		list_for_each_entry(client, &mousedev->client_list, node)
-			kill_fasync(&client->fasync, SIGIO, POLL_HUP);
-		wake_up_interruptible(&mousedev->wait);
-	} else
-		mousedev_free(mousedev);
+	input_unregister_handle(handle);
+	mousedev_destroy(mousedev);
 }
 
 static const struct input_device_id mousedev_ids[] = {
@@ -822,25 +854,16 @@ static int psaux_registered;
 
 static int __init mousedev_init(void)
 {
-	struct class_device *cdev;
 	int error;
 
+	mousedev_mix = mousedev_create(NULL, &mousedev_handler, MOUSEDEV_MIX);
+	if (IS_ERR(mousedev_mix))
+		return PTR_ERR(mousedev_mix);
+
 	error = input_register_handler(&mousedev_handler);
-	if (error)
+	if (error) {
+		mousedev_destroy(mousedev_mix);
 		return error;
-
-	memset(&mousedev_mix, 0, sizeof(struct mousedev));
-	INIT_LIST_HEAD(&mousedev_mix.client_list);
-	init_waitqueue_head(&mousedev_mix.wait);
-	mousedev_table[MOUSEDEV_MIX] = &mousedev_mix;
-	mousedev_mix.exist = 1;
-	mousedev_mix.minor = MOUSEDEV_MIX;
-
-	cdev = class_device_create(&input_class, NULL,
-			MKDEV(INPUT_MAJOR, MOUSEDEV_MINOR_BASE + MOUSEDEV_MIX), NULL, "mice");
-	if (IS_ERR(cdev)) {
-		input_unregister_handler(&mousedev_handler);
-		return PTR_ERR(cdev);
 	}
 
 #ifdef CONFIG_INPUT_MOUSEDEV_PSAUX
@@ -863,9 +886,8 @@ static void __exit mousedev_exit(void)
 	if (psaux_registered)
 		misc_deregister(&psaux_mouse);
 #endif
-	class_device_destroy(&input_class,
-			MKDEV(INPUT_MAJOR, MOUSEDEV_MINOR_BASE + MOUSEDEV_MIX));
 	input_unregister_handler(&mousedev_handler);
+	mousedev_destroy(mousedev_mix);
 }
 
 module_init(mousedev_init);
diff -puN drivers/input/tsdev.c~input-convert-from-class-devices-to-standard-devices drivers/input/tsdev.c
--- a/drivers/input/tsdev.c~input-convert-from-class-devices-to-standard-devices
+++ a/drivers/input/tsdev.c
@@ -109,9 +109,11 @@ struct tsdev {
 	int open;
 	int minor;
 	char name[8];
+	struct input_handle handle;
 	wait_queue_head_t wait;
 	struct list_head client_list;
-	struct input_handle handle;
+	struct device dev;
+
 	int x, y, pressure;
 	struct ts_calibration cal;
 };
@@ -163,9 +165,13 @@ static int tsdev_open(struct inode *inod
 	if (!tsdev || !tsdev->exist)
 		return -ENODEV;
 
+	get_device(&tsdev->dev);
+
 	client = kzalloc(sizeof(struct tsdev_client), GFP_KERNEL);
-	if (!client)
-		return -ENOMEM;
+	if (!client) {
+		error = -ENOMEM;
+		goto err_put_tsdev;
+	}
 
 	client->tsdev = tsdev;
 	client->raw = (i >= TSDEV_MINORS / 2) ? 1 : 0;
@@ -173,19 +179,25 @@ static int tsdev_open(struct inode *inod
 
 	if (!tsdev->open++ && tsdev->exist) {
 		error = input_open_device(&tsdev->handle);
-		if (error) {
-			list_del(&client->node);
-			kfree(client);
-			return error;
-		}
+		if (error)
+			goto err_free_client;
 	}
 
 	file->private_data = client;
 	return 0;
+
+ err_free_client:
+	list_del(&client->node);
+	kfree(client);
+ err_put_tsdev:
+	put_device(&tsdev->dev);
+	return error;
 }
 
-static void tsdev_free(struct tsdev *tsdev)
+static void tsdev_free(struct device *dev)
 {
+	struct tsdev *tsdev = container_of(dev, struct tsdev, dev);
+
 	tsdev_table[tsdev->minor] = NULL;
 	kfree(tsdev);
 }
@@ -200,12 +212,10 @@ static int tsdev_release(struct inode *i
 	list_del(&client->node);
 	kfree(client);
 
-	if (!--tsdev->open) {
-		if (tsdev->exist)
-			input_close_device(&tsdev->handle);
-		else
-			tsdev_free(tsdev);
-	}
+	if (!--tsdev->open && tsdev->exist)
+		input_close_device(&tsdev->handle);
+
+	put_device(&tsdev->dev);
 
 	return 0;
 }
@@ -388,8 +398,6 @@ static int tsdev_connect(struct input_ha
 			 const struct input_device_id *id)
 {
 	struct tsdev *tsdev;
-	struct class_device *cdev;
-	dev_t devt;
 	int minor, delta;
 	int error;
 
@@ -407,14 +415,13 @@ static int tsdev_connect(struct input_ha
 	INIT_LIST_HEAD(&tsdev->client_list);
 	init_waitqueue_head(&tsdev->wait);
 
-	sprintf(tsdev->name, "ts%d", minor);
-
 	tsdev->exist = 1;
 	tsdev->minor = minor;
 	tsdev->handle.dev = dev;
 	tsdev->handle.name = tsdev->name;
 	tsdev->handle.handler = handler;
 	tsdev->handle.private = tsdev;
+	snprintf(tsdev->name, sizeof(tsdev->name), "ts%d", minor);
 
 	/* Precompute the rough calibration matrix */
 	delta = dev->absmax [ABS_X] - dev->absmin [ABS_X] + 1;
@@ -429,36 +436,30 @@ static int tsdev_connect(struct input_ha
 	tsdev->cal.yscale = (yres << 8) / delta;
 	tsdev->cal.ytrans = - ((dev->absmin [ABS_Y] * tsdev->cal.yscale) >> 8);
 
-	tsdev_table[minor] = tsdev;
-
-	devt = MKDEV(INPUT_MAJOR, TSDEV_MINOR_BASE + minor),
+	snprintf(tsdev->dev.bus_id, sizeof(tsdev->dev.bus_id),
+		 "ts%d", minor);
+	tsdev->dev.class = &input_class;
+	tsdev->dev.parent = &dev->dev;
+	tsdev->dev.devt = MKDEV(INPUT_MAJOR, TSDEV_MINOR_BASE + minor);
+	tsdev->dev.release = tsdev_free;
+	device_initialize(&tsdev->dev);
 
-	cdev = class_device_create(&input_class, &dev->cdev, devt,
-				   dev->cdev.dev, tsdev->name);
-	if (IS_ERR(cdev)) {
-		error = PTR_ERR(cdev);
-		goto err_free_tsdev;
-	}
+	tsdev_table[minor] = tsdev;
 
-	/* temporary symlink to keep userspace happy */
-	error = sysfs_create_link(&input_class.subsys.kobj,
-				  &cdev->kobj, tsdev->name);
+	error = device_add(&tsdev->dev);
 	if (error)
-		goto err_cdev_destroy;
+		goto err_free_tsdev;
 
 	error = input_register_handle(&tsdev->handle);
 	if (error)
-		goto err_remove_link;
+		goto err_delete_tsdev;
 
 	return 0;
 
- err_remove_link:
-	sysfs_remove_link(&input_class.subsys.kobj, tsdev->name);
- err_cdev_destroy:
-	class_device_destroy(&input_class, devt);
+ err_delete_tsdev:
+	device_del(&tsdev->dev);
  err_free_tsdev:
-	tsdev_table[minor] = NULL;
-	kfree(tsdev);
+	put_device(&tsdev->dev);
 	return error;
 }
 
@@ -468,10 +469,8 @@ static void tsdev_disconnect(struct inpu
 	struct tsdev_client *client;
 
 	input_unregister_handle(handle);
+	device_del(&tsdev->dev);
 
-	sysfs_remove_link(&input_class.subsys.kobj, tsdev->name);
-	class_device_destroy(&input_class,
-			MKDEV(INPUT_MAJOR, TSDEV_MINOR_BASE + tsdev->minor));
 	tsdev->exist = 0;
 
 	if (tsdev->open) {
@@ -479,8 +478,9 @@ static void tsdev_disconnect(struct inpu
 		list_for_each_entry(client, &tsdev->client_list, node)
 			kill_fasync(&client->fasync, SIGIO, POLL_HUP);
 		wake_up_interruptible(&tsdev->wait);
-	} else
-		tsdev_free(tsdev);
+	}
+
+	put_device(&tsdev->dev);
 }
 
 static const struct input_device_id tsdev_ids[] = {
diff -puN include/linux/input.h~input-convert-from-class-devices-to-standard-devices include/linux/input.h
--- a/include/linux/input.h~input-convert-from-class-devices-to-standard-devices
+++ a/include/linux/input.h
@@ -972,15 +972,15 @@ struct input_dev {
 	struct mutex mutex;	/* serializes open and close operations */
 	unsigned int users;
 
-	struct class_device cdev;
+	struct device dev;
 	union {			/* temporarily so while we switching to struct device */
-		struct device *parent;
-	} dev;
+		struct device *dev;
+	} cdev;
 
 	struct list_head	h_list;
 	struct list_head	node;
 };
-#define to_input_dev(d) container_of(d, struct input_dev, cdev)
+#define to_input_dev(d) container_of(d, struct input_dev, dev)
 
 /*
  * Verify that we are in sync with input_device_id mod_devicetable.h #defines
@@ -1087,22 +1087,22 @@ struct input_handle {
 	struct list_head	h_node;
 };
 
-#define to_dev(n) container_of(n,struct input_dev,node)
-#define to_handler(n) container_of(n,struct input_handler,node)
-#define to_handle(n) container_of(n,struct input_handle,d_node)
-#define to_handle_h(n) container_of(n,struct input_handle,h_node)
+#define to_dev(n) container_of(n, struct input_dev, node)
+#define to_handler(n) container_of(n, struct input_handler, node)
+#define to_handle(n) container_of(n, struct input_handle, d_node)
+#define to_handle_h(n) container_of(n, struct input_handle, h_node)
 
 struct input_dev *input_allocate_device(void);
 void input_free_device(struct input_dev *dev);
 
 static inline struct input_dev *input_get_device(struct input_dev *dev)
 {
-	return to_input_dev(class_device_get(&dev->cdev));
+	return to_input_dev(get_device(&dev->dev));
 }
 
 static inline void input_put_device(struct input_dev *dev)
 {
-	class_device_put(&dev->cdev);
+	put_device(&dev->dev);
 }
 
 static inline void *input_get_drvdata(struct input_dev *dev)
_

Patches currently in -mm which might be from dtor@insightbb.com are

git-dvb.patch
hdaps-switch-to-using-input-polldev.patch
applesmc-switch-to-using-input-polldev.patch
ams-switch-to-using-input-polldev.patch
git-input.patch
ibmasm-whitespace-cleanup.patch
ibmasm-dont-use-extern-in-function-declarations.patch
ibmasm-miscellaneous-fixes.patch
ibmasm-must-depend-on-config_input.patch
