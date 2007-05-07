From: akpm@linux-foundation.org
Subject: - input-evdev-implement-proper-locking.patch removed from -mm tree
Date: Sun, 06 May 2007 23:22:56 -0700
Message-ID: <200705070622.l476Mv60019385@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754038AbXEGGXF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 02:23:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dtor@insightbb.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: evdev - implement proper locking
has been removed from the -mm tree.  Its filename was
     input-evdev-implement-proper-locking.patch

This patch was dropped because the struct subsystem removal patch got applied

------------------------------------------------------
Subject: input: evdev - implement proper locking
From: Dmitry Torokhov <dtor@insightbb.com>

Input: evdev - implement proper locking

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/evdev.c |  353 ++++++++++++++++++++++++++++------------
 1 file changed, 255 insertions(+), 98 deletions(-)

diff -puN drivers/input/evdev.c~input-evdev-implement-proper-locking drivers/input/evdev.c
--- a/drivers/input/evdev.c~input-evdev-implement-proper-locking
+++ a/drivers/input/evdev.c
@@ -31,6 +31,8 @@ struct evdev {
 	wait_queue_head_t wait;
 	struct evdev_client *grab;
 	struct list_head client_list;
+	spinlock_t client_lock;
+	struct mutex mutex;
 	struct device dev;
 };
 
@@ -38,39 +40,48 @@ struct evdev_client {
 	struct input_event buffer[EVDEV_BUFFER_SIZE];
 	int head;
 	int tail;
+	spinlock_t buffer_lock;
 	struct fasync_struct *fasync;
 	struct evdev *evdev;
 	struct list_head node;
 };
 
 static struct evdev *evdev_table[EVDEV_MINORS];
+static DEFINE_MUTEX(evdev_table_mutex);
+
+static void evdev_pass_event(struct evdev_client *client, struct input_event *event)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&client->buffer_lock, flags);
+	client->buffer[client->head++] = *event;
+	client->head &= EVDEV_BUFFER_SIZE - 1;
+	spin_unlock_irqrestore(&client->buffer_lock, flags);
+
+	kill_fasync(&client->fasync, SIGIO, POLL_IN);
+}
 
 static void evdev_event(struct input_handle *handle, unsigned int type, unsigned int code, int value)
 {
 	struct evdev *evdev = handle->private;
 	struct evdev_client *client;
+	struct input_event event;
 
-	if (evdev->grab) {
-		client = evdev->grab;
-
-		do_gettimeofday(&client->buffer[client->head].time);
-		client->buffer[client->head].type = type;
-		client->buffer[client->head].code = code;
-		client->buffer[client->head].value = value;
-		client->head = (client->head + 1) & (EVDEV_BUFFER_SIZE - 1);
-
-		kill_fasync(&client->fasync, SIGIO, POLL_IN);
-	} else
-		list_for_each_entry(client, &evdev->client_list, node) {
-
-			do_gettimeofday(&client->buffer[client->head].time);
-			client->buffer[client->head].type = type;
-			client->buffer[client->head].code = code;
-			client->buffer[client->head].value = value;
-			client->head = (client->head + 1) & (EVDEV_BUFFER_SIZE - 1);
+	do_gettimeofday(&event.time);
+	event.type = type;
+	event.code = code;
+	event.value = value;
+
+	rcu_read_lock();
+
+	client = rcu_dereference(evdev->grab);
+	if (client)
+		evdev_pass_event(client, &event);
+	else
+		list_for_each_entry_rcu(client, &evdev->client_list, node)
+			evdev_pass_event(client, &event);
 
-			kill_fasync(&client->fasync, SIGIO, POLL_IN);
-		}
+	rcu_read_unlock();
 
 	wake_up_interruptible(&evdev->wait);
 }
@@ -89,33 +100,98 @@ static int evdev_flush(struct file *file
 {
 	struct evdev_client *client = file->private_data;
 	struct evdev *evdev = client->evdev;
+	int retval;
+
+
+	retval = mutex_lock_interruptible(&evdev->mutex);
+	if (retval)
+		return retval;
 
 	if (!evdev->exist)
-		return -ENODEV;
+		retval = -ENODEV;
+	else
+		retval = input_flush_device(&evdev->handle, file);
 
-	return input_flush_device(&evdev->handle, file);
+	mutex_unlock(&evdev->mutex);
+	return retval;
 }
 
 static void evdev_free(struct device *dev)
 {
 	struct evdev *evdev = container_of(dev, struct evdev, dev);
 
-	evdev_table[evdev->minor] = NULL;
 	kfree(evdev);
 }
 
+static int evdev_grab(struct evdev *evdev, struct evdev_client *client)
+{
+	int error;
+
+	if (evdev->grab)
+		return -EBUSY;
+
+	error = input_grab_device(&evdev->handle);
+	if (error)
+		return error;
+
+	rcu_assign_pointer(evdev->grab, client);
+	synchronize_rcu();
+
+	return 0;
+}
+
+static int evdev_ungrab(struct evdev *evdev, struct evdev_client *client)
+{
+	if (evdev->grab != client)
+		return  -EINVAL;
+
+	rcu_assign_pointer(evdev->grab, NULL);
+	synchronize_rcu();
+	input_release_device(&evdev->handle);
+
+	return 0;
+}
+
+static void evdev_attach_client(struct evdev *evdev, struct evdev_client *client)
+{
+	spin_lock(&evdev->client_lock);
+	list_add_tail_rcu(&client->node, &evdev->client_list);
+	spin_unlock(&evdev->client_lock);
+	synchronize_rcu();
+}
+
+static void evdev_detach_client(struct evdev *evdev, struct evdev_client *client)
+{
+	spin_lock(&evdev->client_lock);
+	list_del_rcu(&client->node);
+	spin_unlock(&evdev->client_lock);
+	synchronize_rcu();
+}
+
+static void evdev_hangup(struct evdev *evdev)
+{
+	struct evdev_client *client;
+
+	wake_up_interruptible(&evdev->wait);
+
+	spin_lock(&evdev->client_lock);
+	list_for_each_entry(client, &evdev->client_list, node)
+		kill_fasync(&client->fasync, SIGIO, POLL_HUP);
+	spin_unlock(&evdev->client_lock);
+}
+
 static int evdev_release(struct inode *inode, struct file *file)
 {
 	struct evdev_client *client = file->private_data;
 	struct evdev *evdev = client->evdev;
 
-	if (evdev->grab == client) {
-		input_release_device(&evdev->handle);
-		evdev->grab = NULL;
-	}
+	mutex_lock(&evdev->mutex);
+	if (evdev->grab == client)
+		evdev_ungrab(evdev, client);
+	mutex_unlock(&evdev->mutex);
 
 	evdev_fasync(-1, file, 0);
-	list_del(&client->node);
+	evdev_detach_client(evdev, client);
 	kfree(client);
 
 	if (!--evdev->open && evdev->exist)
@@ -126,47 +202,53 @@ static int evdev_release(struct inode *i
 	return 0;
 }
 
-static int evdev_open(struct inode *inode, struct file *file)
+static int evdev_new_client(struct evdev *evdev, struct file *file)
 {
 	struct evdev_client *client;
-	struct evdev *evdev;
-	int i = iminor(inode) - EVDEV_MINOR_BASE;
 	int error;
 
-	if (i >= EVDEV_MINORS)
-		return -ENODEV;
-
-	evdev = evdev_table[i];
-
-	if (!evdev || !evdev->exist)
+	if (!evdev)
 		return -ENODEV;
 
-	get_device(&evdev->dev);
-
 	client = kzalloc(sizeof(struct evdev_client), GFP_KERNEL);
-	if (!client) {
-		error = -ENOMEM;
-		goto err_put_evdev;
-	}
+	if (!client)
+		return -ENOMEM;
 
+	spin_lock_init(&client->buffer_lock);
 	client->evdev = evdev;
-	list_add_tail(&client->node, &evdev->client_list);
+	evdev_attach_client(evdev, client);
 
 	if (!evdev->open++ && evdev->exist) {
 		error = input_open_device(&evdev->handle);
-		if (error)
-			goto err_free_client;
+		if (error) {
+			evdev_detach_client(evdev, client);
+			kfree(client);
+			return error;
+		}
 	}
 
+	get_device(&evdev->dev);
 	file->private_data = client;
 	return 0;
+}
 
- err_free_client:
-	list_del(&client->node);
-	kfree(client);
- err_put_evdev:
-	put_device(&evdev->dev);
-	return error;
+static int evdev_open(struct inode *inode, struct file *file)
+{
+	int i = iminor(inode) - EVDEV_MINOR_BASE;
+	int retval;
+
+	if (i >= EVDEV_MINORS)
+		return -ENODEV;
+
+	retval = mutex_lock_interruptible(&evdev_table_mutex);
+	if (retval)
+		return retval;
+
+	retval = evdev_new_client(evdev_table[i], file);
+
+	mutex_unlock(&evdev_table_mutex);
+
+	return retval;
 }
 
 #ifdef CONFIG_COMPAT
@@ -272,26 +354,56 @@ static ssize_t evdev_write(struct file *
 	struct evdev_client *client = file->private_data;
 	struct evdev *evdev = client->evdev;
 	struct input_event event;
-	int retval = 0;
+	int retval;
 
-	if (!evdev->exist)
-		return -ENODEV;
+	retval = mutex_lock_interruptible(&evdev->mutex);
+	if (retval)
+		return retval;
+
+	if (!evdev->exist) {
+		retval = -ENODEV;
+		goto out;
+	}
 
 	while (retval < count) {
 
-		if (evdev_event_from_user(buffer + retval, &event))
-			return -EFAULT;
+		if (evdev_event_from_user(buffer + retval, &event)) {
+			retval = -EFAULT;
+			goto out;
+		}
+
 		input_inject_event(&evdev->handle, event.type, event.code, event.value);
 		retval += evdev_event_size();
 	}
 
+ out:
+	mutex_unlock(&evdev->mutex);
 	return retval;
 }
 
+static int evdev_fetch_next_event(struct evdev_client *client,
+				  struct input_event *event)
+{
+	int have_event;
+
+	spin_lock_irq(&client->buffer_lock);
+
+	have_event = client->head != client->tail;
+	if (have_event) {
+		*event = client->buffer[client->tail++];
+		client->tail &= EVDEV_BUFFER_SIZE - 1;
+	}
+
+	spin_unlock_irq(&client->buffer_lock);
+
+	return have_event;
+}
+
 static ssize_t evdev_read(struct file *file, char __user *buffer, size_t count, loff_t *ppos)
 {
 	struct evdev_client *client = file->private_data;
 	struct evdev *evdev = client->evdev;
+	struct input_event event;
 	int retval;
 
 	if (count < evdev_event_size())
@@ -308,14 +420,12 @@ static ssize_t evdev_read(struct file *f
 	if (!evdev->exist)
 		return -ENODEV;
 
-	while (client->head != client->tail && retval + evdev_event_size() <= count) {
-
-		struct input_event *event = (struct input_event *) client->buffer + client->tail;
+	while (retval + evdev_event_size() <= count &&
+	       evdev_fetch_next_event(client, &event)) {
 
-		if (evdev_event_to_user(buffer + retval, event))
+		if (evdev_event_to_user(buffer + retval, &event))
 			return -EFAULT;
 
-		client->tail = (client->tail + 1) & (EVDEV_BUFFER_SIZE - 1);
 		retval += evdev_event_size();
 	}
 
@@ -410,8 +520,8 @@ static int str_to_user(const char *str, 
 	return copy_to_user(p, str, len) ? -EFAULT : len;
 }
 
-static long evdev_ioctl_handler(struct file *file, unsigned int cmd,
-				void __user *p, int compat_mode)
+static long evdev_do_ioctl(struct file *file, unsigned int cmd,
+			   void __user *p, int compat_mode)
 {
 	struct evdev_client *client = file->private_data;
 	struct evdev *evdev = client->evdev;
@@ -422,9 +532,6 @@ static long evdev_ioctl_handler(struct f
 	int i, t, u, v;
 	int error;
 
-	if (!evdev->exist)
-		return -ENODEV;
-
 	switch (cmd) {
 
 		case EVIOCGVERSION:
@@ -497,20 +604,10 @@ static long evdev_ioctl_handler(struct f
 			return 0;
 
 		case EVIOCGRAB:
-			if (p) {
-				if (evdev->grab)
-					return -EBUSY;
-				if (input_grab_device(&evdev->handle))
-					return -EBUSY;
-				evdev->grab = client;
-				return 0;
-			} else {
-				if (evdev->grab != client)
-					return -EINVAL;
-				input_release_device(&evdev->handle);
-				evdev->grab = NULL;
-				return 0;
-			}
+			if (p)
+				return evdev_grab(evdev, client);
+			else
+				return evdev_ungrab(evdev, client);
 
 		default:
 
@@ -604,6 +701,29 @@ static long evdev_ioctl_handler(struct f
 	return -EINVAL;
 }
 
+static long evdev_ioctl_handler(struct file *file, unsigned int cmd,
+				void __user *p, int compat_mode)
+{
+	struct evdev_client *client = file->private_data;
+	struct evdev *evdev = client->evdev;
+	int retval;
+
+	retval = mutex_lock_interruptible(&evdev->mutex);
+	if (retval)
+		return retval;
+
+	if (!evdev->exist) {
+		retval = -ENODEV;
+		goto out;
+	}
+
+	retval = evdev_do_ioctl(file, cmd, p, compat_mode);
+
+ out:
+	mutex_unlock(&evdev->mutex);
+	return retval;
+}
+
 static long evdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	return evdev_ioctl_handler(file, cmd, (void __user *)arg, 0);
@@ -631,47 +751,81 @@ static const struct file_operations evde
 	.flush =	evdev_flush
 };
 
-static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
-			 const struct input_device_id *id)
+static int evdev_install_chrdev(struct evdev *evdev)
 {
-	struct evdev *evdev;
 	int minor;
-	int error;
+	int retval;
+
+	retval = mutex_lock_interruptible(&evdev_table_mutex);
+	if (retval)
+		return retval;
 
 	for (minor = 0; minor < EVDEV_MINORS && evdev_table[minor]; minor++);
 	if (minor == EVDEV_MINORS) {
 		printk(KERN_ERR "evdev: no more free evdev devices\n");
-		return -ENFILE;
+		retval = -ENFILE;
+		goto out;
 	}
 
+	snprintf(evdev->name, sizeof(evdev->name), "event%d", minor);
+	evdev->minor = minor;
+	strlcpy(evdev->dev.bus_id, evdev->name, sizeof(evdev->dev.bus_id));
+	evdev->dev.devt = MKDEV(INPUT_MAJOR, EVDEV_MINOR_BASE + minor);
+
+	evdev_table[minor] = evdev;
+
+ out:
+	mutex_unlock(&evdev_table_mutex);
+	return retval;
+}
+
+static void evdev_remove_chrdev(struct evdev *evdev)
+{
+	mutex_lock(&evdev_table_mutex);
+	evdev_table[evdev->minor] = NULL;
+	mutex_unlock(&evdev_table_mutex);
+}
+
+static void evdev_mark_dead(struct evdev *evdev)
+{
+	mutex_lock(&evdev->mutex);
+	evdev->exist = 0;
+	mutex_unlock(&evdev->mutex);
+}
+
+static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
+			 const struct input_device_id *id)
+{
+	struct evdev *evdev;
+	int error;
+
 	evdev = kzalloc(sizeof(struct evdev), GFP_KERNEL);
 	if (!evdev)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&evdev->client_list);
+	spin_lock_init(&evdev->client_lock);
+	mutex_init(&evdev->mutex);
 	init_waitqueue_head(&evdev->wait);
 
 	evdev->exist = 1;
-	evdev->minor = minor;
 	evdev->handle.dev = dev;
 	evdev->handle.name = evdev->name;
 	evdev->handle.handler = handler;
 	evdev->handle.private = evdev;
-	snprintf(evdev->name, sizeof(evdev->name), "event%d", minor);
 
-	snprintf(evdev->dev.bus_id, sizeof(evdev->dev.bus_id),
-		 "event%d", minor);
 	evdev->dev.class = &input_class;
 	evdev->dev.parent = &dev->dev;
-	evdev->dev.devt = MKDEV(INPUT_MAJOR, EVDEV_MINOR_BASE + minor);
 	evdev->dev.release = evdev_free;
 	device_initialize(&evdev->dev);
 
-	evdev_table[minor] = evdev;
+	error = evdev_install_chrdev(evdev);
+	if (error)
+		goto err_free_evdev;
 
 	error = device_add(&evdev->dev);
 	if (error)
-		goto err_free_evdev;
+		goto err_remove_chrdev;
 
 	error = input_register_handle(&evdev->handle);
 	if (error)
@@ -681,6 +835,10 @@ static int evdev_connect(struct input_ha
 
  err_delete_evdev:
 	device_del(&evdev->dev);
+ err_remove_chrdev:
+	evdev_remove_chrdev(evdev);
+	evdev_mark_dead(evdev);
+	evdev_hangup(evdev);
  err_free_evdev:
 	put_device(&evdev->dev);
 	return error;
@@ -689,19 +847,18 @@ static int evdev_connect(struct input_ha
 static void evdev_disconnect(struct input_handle *handle)
 {
 	struct evdev *evdev = handle->private;
-	struct evdev_client *client;
+
+	evdev_remove_chrdev(evdev);
 
 	input_unregister_handle(handle);
 	device_del(&evdev->dev);
 
-	evdev->exist = 0;
+	evdev_mark_dead(evdev);
+	evdev_hangup(evdev);
 
 	if (evdev->open) {
 		input_flush_device(handle, NULL);
 		input_close_device(handle);
-		wake_up_interruptible(&evdev->wait);
-		list_for_each_entry(client, &evdev->client_list, node)
-			kill_fasync(&client->fasync, SIGIO, POLL_HUP);
 	}
 
 	put_device(&evdev->dev);
_

Patches currently in -mm which might be from dtor@insightbb.com are

origin.patch
git-input.patch
input-evdev-implement-proper-locking.patch
mousedev-fix.patch
mousedev-fix-2.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio.patch
