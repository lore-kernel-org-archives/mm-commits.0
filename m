From: akpm@linux-foundation.org
Subject: - xen-add-xenfs-to-allow-usermode-xen-interaction.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:46:39 -0800
Message-ID: <200901082246.n08MkdTk026197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757984AbZAHWr3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:47:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.zeffertt@eu.citrix.com, jeremy.fitzhardinge@citrix.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     xen: add xenfs to allow usermode <-> Xen interaction
has been removed from the -mm tree.  Its filename was
     xen-add-xenfs-to-allow-usermode-xen-interaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xen: add xenfs to allow usermode <-> Xen interaction
From: Alex Zeffertt <alex.zeffertt@eu.citrix.com>

The xenfs filesystem exports various interfaces to usermode.  Initially
this exports a file to allow usermode to interact with xenbus/xenstore.

Traditionally this appeared in /proc/xen.  Rather than extending procfs,
this patch adds a backward-compat mountpoint on /proc/xen, and provides
a xenfs filesystem which can be mounted there.

Signed-off-by: Alex Zeffertt <alex.zeffertt@eu.citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/Kconfig               |   24 +
 drivers/xen/Makefile              |    2 
 drivers/xen/xenbus/xenbus_probe.c |   28 +
 drivers/xen/xenbus/xenbus_xs.c    |    1 
 drivers/xen/xenfs/Makefile        |    3 
 drivers/xen/xenfs/super.c         |   64 +++
 drivers/xen/xenfs/xenbus.c        |  593 ++++++++++++++++++++++++++++
 drivers/xen/xenfs/xenfs.h         |    6 
 include/linux/magic.h             |    1 
 include/xen/xenbus.h              |    2 
 10 files changed, 716 insertions(+), 8 deletions(-)

diff -puN drivers/xen/Kconfig~xen-add-xenfs-to-allow-usermode-xen-interaction drivers/xen/Kconfig
--- a/drivers/xen/Kconfig~xen-add-xenfs-to-allow-usermode-xen-interaction
+++ a/drivers/xen/Kconfig
@@ -17,3 +17,27 @@ config XEN_SCRUB_PAGES
 	  is not accidentally visible to other domains.  Is it more
 	  secure, but slightly less efficient.
 	  If in doubt, say yes.
+
+config XENFS
+	tristate "Xen filesystem"
+	depends on XEN
+	default y
+	help
+	  The xen filesystem provides a way for domains to share
+	  information with each other and with the hypervisor.
+	  For example, by reading and writing the "xenbus" file, guests
+	  may pass arbitrary information to the initial domain.
+	  If in doubt, say yes.
+
+config XEN_COMPAT_XENFS
+       bool "Create compatibility mount point /proc/xen"
+       depends on XENFS
+       default y
+       help
+         The old xenstore userspace tools expect to find "xenbus"
+         under /proc/xen, but "xenbus" is now found at the root of the
+         xenfs filesystem.  Selecting this causes the kernel to create
+         the compatibilty mount point /proc/xen if it is running on
+         a xen platform.
+         If in doubt, say yes.
+
diff -puN drivers/xen/Makefile~xen-add-xenfs-to-allow-usermode-xen-interaction drivers/xen/Makefile
--- a/drivers/xen/Makefile~xen-add-xenfs-to-allow-usermode-xen-interaction
+++ a/drivers/xen/Makefile
@@ -1,5 +1,7 @@
 obj-y	+= grant-table.o features.o events.o manage.o
 obj-y	+= xenbus/
+
 obj-$(CONFIG_HOTPLUG_CPU)	+= cpu_hotplug.o
 obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
 obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
+obj-$(CONFIG_XENFS)		+= xenfs/
\ No newline at end of file
diff -puN drivers/xen/xenbus/xenbus_probe.c~xen-add-xenfs-to-allow-usermode-xen-interaction drivers/xen/xenbus/xenbus_probe.c
--- a/drivers/xen/xenbus/xenbus_probe.c~xen-add-xenfs-to-allow-usermode-xen-interaction
+++ a/drivers/xen/xenbus/xenbus_probe.c
@@ -40,6 +40,7 @@
 #include <linux/ctype.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
+#include <linux/proc_fs.h>
 #include <linux/notifier.h>
 #include <linux/kthread.h>
 #include <linux/mutex.h>
@@ -55,7 +56,10 @@
 #include "xenbus_comms.h"
 #include "xenbus_probe.h"
 
+
 int xen_store_evtchn;
+EXPORT_SYMBOL(xen_store_evtchn);
+
 struct xenstore_domain_interface *xen_store_interface;
 static unsigned long xen_store_mfn;
 
@@ -166,6 +170,9 @@ static int read_backend_details(struct x
 	return read_otherend_details(xendev, "backend-id", "backend");
 }
 
+static struct device_attribute xenbus_dev_attrs[] = {
+	__ATTR_NULL
+};
 
 /* Bus type for frontend drivers. */
 static struct xen_bus_type xenbus_frontend = {
@@ -174,12 +181,13 @@ static struct xen_bus_type xenbus_fronte
 	.get_bus_id = frontend_bus_id,
 	.probe = xenbus_probe_frontend,
 	.bus = {
-		.name     = "xen",
-		.match    = xenbus_match,
-		.uevent   = xenbus_uevent,
-		.probe    = xenbus_dev_probe,
-		.remove   = xenbus_dev_remove,
-		.shutdown = xenbus_dev_shutdown,
+		.name      = "xen",
+		.match     = xenbus_match,
+		.uevent    = xenbus_uevent,
+		.probe     = xenbus_dev_probe,
+		.remove    = xenbus_dev_remove,
+		.shutdown  = xenbus_dev_shutdown,
+		.dev_attrs = xenbus_dev_attrs,
 	},
 };
 
@@ -852,6 +860,14 @@ static int __init xenbus_probe_init(void
 	if (!xen_initial_domain())
 		xenbus_probe(NULL);
 
+#ifdef CONFIG_XEN_COMPAT_XENFS
+	/*
+	 * Create xenfs mountpoint in /proc for compatibility with
+	 * utilities that expect to find "xenbus" under "/proc/xen".
+	 */
+	proc_mkdir("xen", NULL);
+#endif
+
 	return 0;
 
   out_unreg_back:
diff -puN drivers/xen/xenbus/xenbus_xs.c~xen-add-xenfs-to-allow-usermode-xen-interaction drivers/xen/xenbus/xenbus_xs.c
--- a/drivers/xen/xenbus/xenbus_xs.c~xen-add-xenfs-to-allow-usermode-xen-interaction
+++ a/drivers/xen/xenbus/xenbus_xs.c
@@ -184,6 +184,7 @@ void *xenbus_dev_request_and_reply(struc
 
 	return ret;
 }
+EXPORT_SYMBOL(xenbus_dev_request_and_reply);
 
 /* Send message to xs, get kmalloc'ed reply.  ERR_PTR() on error. */
 static void *xs_talkv(struct xenbus_transaction t,
diff -puN /dev/null drivers/xen/xenfs/Makefile
--- /dev/null
+++ a/drivers/xen/xenfs/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_XENFS) += xenfs.o
+
+xenfs-objs = super.o xenbus.o
\ No newline at end of file
diff -puN /dev/null drivers/xen/xenfs/super.c
--- /dev/null
+++ a/drivers/xen/xenfs/super.c
@@ -0,0 +1,64 @@
+/*
+ *  xenfs.c - a filesystem for passing info between the a domain and
+ *  the hypervisor.
+ *
+ * 2008-10-07  Alex Zeffertt    Replaced /proc/xen/xenbus with xenfs filesystem
+ *                              and /proc/xen compatibility mount point.
+ *                              Turned xenfs into a loadable module.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/magic.h>
+
+#include "xenfs.h"
+
+#include <asm/xen/hypervisor.h>
+
+MODULE_DESCRIPTION("Xen filesystem");
+MODULE_LICENSE("GPL");
+
+static int xenfs_fill_super(struct super_block *sb, void *data, int silent)
+{
+	static struct tree_descr xenfs_files[] = {
+		[2] = {"xenbus", &xenbus_file_ops, S_IRUSR|S_IWUSR},
+		{""},
+	};
+
+	return simple_fill_super(sb, XENFS_SUPER_MAGIC, xenfs_files);
+}
+
+static int xenfs_get_sb(struct file_system_type *fs_type,
+			int flags, const char *dev_name,
+			void *data, struct vfsmount *mnt)
+{
+	return get_sb_single(fs_type, flags, data, xenfs_fill_super, mnt);
+}
+
+static struct file_system_type xenfs_type = {
+	.owner =	THIS_MODULE,
+	.name =		"xenfs",
+	.get_sb =	xenfs_get_sb,
+	.kill_sb =	kill_litter_super,
+};
+
+static int __init xenfs_init(void)
+{
+	if (xen_pv_domain())
+		return register_filesystem(&xenfs_type);
+
+	printk(KERN_INFO "XENFS: not registering filesystem on non-xen platform\n");
+	return 0;
+}
+
+static void __exit xenfs_exit(void)
+{
+	if (xen_pv_domain())
+		unregister_filesystem(&xenfs_type);
+}
+
+module_init(xenfs_init);
+module_exit(xenfs_exit);
+
diff -puN /dev/null drivers/xen/xenfs/xenbus.c
--- /dev/null
+++ a/drivers/xen/xenfs/xenbus.c
@@ -0,0 +1,593 @@
+/*
+ * Driver giving user-space access to the kernel's xenbus connection
+ * to xenstore.
+ *
+ * Copyright (c) 2005, Christian Limpach
+ * Copyright (c) 2005, Rusty Russell, IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ *
+ * Changes:
+ * 2008-10-07  Alex Zeffertt    Replaced /proc/xen/xenbus with xenfs filesystem
+ *                              and /proc/xen compatibility mount point.
+ *                              Turned xenfs into a loadable module.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/uio.h>
+#include <linux/notifier.h>
+#include <linux/wait.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/mount.h>
+#include <linux/pagemap.h>
+#include <linux/uaccess.h>
+#include <linux/init.h>
+#include <linux/namei.h>
+#include <linux/string.h>
+
+#include "xenfs.h"
+#include "../xenbus/xenbus_comms.h"
+
+#include <xen/xenbus.h>
+#include <asm/xen/hypervisor.h>
+
+/*
+ * An element of a list of outstanding transactions, for which we're
+ * still waiting a reply.
+ */
+struct xenbus_transaction_holder {
+	struct list_head list;
+	struct xenbus_transaction handle;
+};
+
+/*
+ * A buffer of data on the queue.
+ */
+struct read_buffer {
+	struct list_head list;
+	unsigned int cons;
+	unsigned int len;
+	char msg[];
+};
+
+struct xenbus_file_priv {
+	/*
+	 * msgbuffer_mutex is held while partial requests are built up
+	 * and complete requests are acted on.  It therefore protects
+	 * the "transactions" and "watches" lists, and the partial
+	 * request length and buffer.
+	 *
+	 * reply_mutex protects the reply being built up to return to
+	 * usermode.  It nests inside msgbuffer_mutex but may be held
+	 * alone during a watch callback.
+	 */
+	struct mutex msgbuffer_mutex;
+
+	/* In-progress transactions */
+	struct list_head transactions;
+
+	/* Active watches. */
+	struct list_head watches;
+
+	/* Partial request. */
+	unsigned int len;
+	union {
+		struct xsd_sockmsg msg;
+		char buffer[PAGE_SIZE];
+	} u;
+
+	/* Response queue. */
+	struct mutex reply_mutex;
+	struct list_head read_buffers;
+	wait_queue_head_t read_waitq;
+
+};
+
+/* Read out any raw xenbus messages queued up. */
+static ssize_t xenbus_file_read(struct file *filp,
+			       char __user *ubuf,
+			       size_t len, loff_t *ppos)
+{
+	struct xenbus_file_priv *u = filp->private_data;
+	struct read_buffer *rb;
+	unsigned i;
+	int ret;
+
+	mutex_lock(&u->reply_mutex);
+	while (list_empty(&u->read_buffers)) {
+		mutex_unlock(&u->reply_mutex);
+		ret = wait_event_interruptible(u->read_waitq,
+					       !list_empty(&u->read_buffers));
+		if (ret)
+			return ret;
+		mutex_lock(&u->reply_mutex);
+	}
+
+	rb = list_entry(u->read_buffers.next, struct read_buffer, list);
+	i = 0;
+	while (i < len) {
+		unsigned sz = min((unsigned)len - i, rb->len - rb->cons);
+
+		ret = copy_to_user(ubuf + i, &rb->msg[rb->cons], sz);
+
+		i += sz - ret;
+		rb->cons += sz - ret;
+
+		if (ret != sz) {
+			if (i == 0)
+				i = -EFAULT;
+			goto out;
+		}
+
+		/* Clear out buffer if it has been consumed */
+		if (rb->cons == rb->len) {
+			list_del(&rb->list);
+			kfree(rb);
+			if (list_empty(&u->read_buffers))
+				break;
+			rb = list_entry(u->read_buffers.next,
+					struct read_buffer, list);
+		}
+	}
+
+out:
+	mutex_unlock(&u->reply_mutex);
+	return i;
+}
+
+/*
+ * Add a buffer to the queue.  Caller must hold the appropriate lock
+ * if the queue is not local.  (Commonly the caller will build up
+ * multiple queued buffers on a temporary local list, and then add it
+ * to the appropriate list under lock once all the buffers have een
+ * successfully allocated.)
+ */
+static int queue_reply(struct list_head *queue, const void *data, size_t len)
+{
+	struct read_buffer *rb;
+
+	if (len == 0)
+		return 0;
+
+	rb = kmalloc(sizeof(*rb) + len, GFP_KERNEL);
+	if (rb == NULL)
+		return -ENOMEM;
+
+	rb->cons = 0;
+	rb->len = len;
+
+	memcpy(rb->msg, data, len);
+
+	list_add_tail(&rb->list, queue);
+	return 0;
+}
+
+/*
+ * Free all the read_buffer s on a list.
+ * Caller must have sole reference to list.
+ */
+static void queue_cleanup(struct list_head *list)
+{
+	struct read_buffer *rb;
+
+	while (!list_empty(list)) {
+		rb = list_entry(list->next, struct read_buffer, list);
+		list_del(list->next);
+		kfree(rb);
+	}
+}
+
+struct watch_adapter {
+	struct list_head list;
+	struct xenbus_watch watch;
+	struct xenbus_file_priv *dev_data;
+	char *token;
+};
+
+static void free_watch_adapter(struct watch_adapter *watch)
+{
+	kfree(watch->watch.node);
+	kfree(watch->token);
+	kfree(watch);
+}
+
+static struct watch_adapter *alloc_watch_adapter(const char *path,
+						 const char *token)
+{
+	struct watch_adapter *watch;
+
+	watch = kzalloc(sizeof(*watch), GFP_KERNEL);
+	if (watch == NULL)
+		goto out_fail;
+
+	watch->watch.node = kstrdup(path, GFP_KERNEL);
+	if (watch->watch.node == NULL)
+		goto out_free;
+
+	watch->token = kstrdup(token, GFP_KERNEL);
+	if (watch->token == NULL)
+		goto out_free;
+
+	return watch;
+
+out_free:
+	free_watch_adapter(watch);
+
+out_fail:
+	return NULL;
+}
+
+static void watch_fired(struct xenbus_watch *watch,
+			const char **vec,
+			unsigned int len)
+{
+	struct watch_adapter *adap;
+	struct xsd_sockmsg hdr;
+	const char *path, *token;
+	int path_len, tok_len, body_len, data_len = 0;
+	int ret;
+	LIST_HEAD(staging_q);
+
+	adap = container_of(watch, struct watch_adapter, watch);
+
+	path = vec[XS_WATCH_PATH];
+	token = adap->token;
+
+	path_len = strlen(path) + 1;
+	tok_len = strlen(token) + 1;
+	if (len > 2)
+		data_len = vec[len] - vec[2] + 1;
+	body_len = path_len + tok_len + data_len;
+
+	hdr.type = XS_WATCH_EVENT;
+	hdr.len = body_len;
+
+	mutex_lock(&adap->dev_data->reply_mutex);
+
+	ret = queue_reply(&staging_q, &hdr, sizeof(hdr));
+	if (!ret)
+		ret = queue_reply(&staging_q, path, path_len);
+	if (!ret)
+		ret = queue_reply(&staging_q, token, tok_len);
+	if (!ret && len > 2)
+		ret = queue_reply(&staging_q, vec[2], data_len);
+
+	if (!ret) {
+		/* success: pass reply list onto watcher */
+		list_splice_tail(&staging_q, &adap->dev_data->read_buffers);
+		wake_up(&adap->dev_data->read_waitq);
+	} else
+		queue_cleanup(&staging_q);
+
+	mutex_unlock(&adap->dev_data->reply_mutex);
+}
+
+static int xenbus_write_transaction(unsigned msg_type,
+				    struct xenbus_file_priv *u)
+{
+	int rc, ret;
+	void *reply;
+	struct xenbus_transaction_holder *trans = NULL;
+	LIST_HEAD(staging_q);
+
+	if (msg_type == XS_TRANSACTION_START) {
+		trans = kmalloc(sizeof(*trans), GFP_KERNEL);
+		if (!trans) {
+			rc = -ENOMEM;
+			goto out;
+		}
+	}
+
+	reply = xenbus_dev_request_and_reply(&u->u.msg);
+	if (IS_ERR(reply)) {
+		kfree(trans);
+		rc = PTR_ERR(reply);
+		goto out;
+	}
+
+	if (msg_type == XS_TRANSACTION_START) {
+		trans->handle.id = simple_strtoul(reply, NULL, 0);
+
+		list_add(&trans->list, &u->transactions);
+	} else if (msg_type == XS_TRANSACTION_END) {
+		list_for_each_entry(trans, &u->transactions, list)
+			if (trans->handle.id == u->u.msg.tx_id)
+				break;
+		BUG_ON(&trans->list == &u->transactions);
+		list_del(&trans->list);
+
+		kfree(trans);
+	}
+
+	mutex_lock(&u->reply_mutex);
+	ret = queue_reply(&staging_q, &u->u.msg, sizeof(u->u.msg));
+	if (!ret)
+		ret = queue_reply(&staging_q, reply, u->u.msg.len);
+	if (!ret) {
+		list_splice_tail(&staging_q, &u->read_buffers);
+		wake_up(&u->read_waitq);
+	} else {
+		queue_cleanup(&staging_q);
+		rc = ret;
+	}
+	mutex_unlock(&u->reply_mutex);
+
+	kfree(reply);
+
+out:
+	return rc;
+}
+
+static int xenbus_write_watch(unsigned msg_type, struct xenbus_file_priv *u)
+{
+	struct watch_adapter *watch, *tmp_watch;
+	char *path, *token;
+	int err, rc;
+	LIST_HEAD(staging_q);
+
+	path = u->u.buffer + sizeof(u->u.msg);
+	token = memchr(path, 0, u->u.msg.len);
+	if (token == NULL) {
+		rc = -EILSEQ;
+		goto out;
+	}
+	token++;
+
+	if (msg_type == XS_WATCH) {
+		watch = alloc_watch_adapter(path, token);
+		if (watch == NULL) {
+			rc = -ENOMEM;
+			goto out;
+		}
+
+		watch->watch.callback = watch_fired;
+		watch->dev_data = u;
+
+		err = register_xenbus_watch(&watch->watch);
+		if (err) {
+			free_watch_adapter(watch);
+			rc = err;
+			goto out;
+		}
+		list_add(&watch->list, &u->watches);
+	} else {
+		list_for_each_entry_safe(watch, tmp_watch, &u->watches, list) {
+			if (!strcmp(watch->token, token) &&
+			    !strcmp(watch->watch.node, path)) {
+				unregister_xenbus_watch(&watch->watch);
+				list_del(&watch->list);
+				free_watch_adapter(watch);
+				break;
+			}
+		}
+	}
+
+	/* Success.  Synthesize a reply to say all is OK. */
+	{
+		struct {
+			struct xsd_sockmsg hdr;
+			char body[3];
+		} __packed reply = {
+			{
+				.type = msg_type,
+				.len = sizeof(reply.body)
+			},
+			"OK"
+		};
+
+		mutex_lock(&u->reply_mutex);
+		rc = queue_reply(&u->read_buffers, &reply, sizeof(reply));
+		mutex_unlock(&u->reply_mutex);
+	}
+
+out:
+	return rc;
+}
+
+static ssize_t xenbus_file_write(struct file *filp,
+				const char __user *ubuf,
+				size_t len, loff_t *ppos)
+{
+	struct xenbus_file_priv *u = filp->private_data;
+	uint32_t msg_type;
+	int rc = len;
+	int ret;
+	LIST_HEAD(staging_q);
+
+	/*
+	 * We're expecting usermode to be writing properly formed
+	 * xenbus messages.  If they write an incomplete message we
+	 * buffer it up.  Once it is complete, we act on it.
+	 */
+
+	/*
+	 * Make sure concurrent writers can't stomp all over each
+	 * other's messages and make a mess of our partial message
+	 * buffer.  We don't make any attemppt to stop multiple
+	 * writers from making a mess of each other's incomplete
+	 * messages; we're just trying to guarantee our own internal
+	 * consistency and make sure that single writes are handled
+	 * atomically.
+	 */
+	mutex_lock(&u->msgbuffer_mutex);
+
+	/* Get this out of the way early to avoid confusion */
+	if (len == 0)
+		goto out;
+
+	/* Can't write a xenbus message larger we can buffer */
+	if ((len + u->len) > sizeof(u->u.buffer)) {
+		/* On error, dump existing buffer */
+		u->len = 0;
+		rc = -EINVAL;
+		goto out;
+	}
+
+	ret = copy_from_user(u->u.buffer + u->len, ubuf, len);
+
+	if (ret == len) {
+		rc = -EFAULT;
+		goto out;
+	}
+
+	/* Deal with a partial copy. */
+	len -= ret;
+	rc = len;
+
+	u->len += len;
+
+	/* Return if we haven't got a full message yet */
+	if (u->len < sizeof(u->u.msg))
+		goto out;	/* not even the header yet */
+
+	/* If we're expecting a message that's larger than we can
+	   possibly send, dump what we have and return an error. */
+	if ((sizeof(u->u.msg) + u->u.msg.len) > sizeof(u->u.buffer)) {
+		rc = -E2BIG;
+		u->len = 0;
+		goto out;
+	}
+
+	if (u->len < (sizeof(u->u.msg) + u->u.msg.len))
+		goto out;	/* incomplete data portion */
+
+	/*
+	 * OK, now we have a complete message.  Do something with it.
+	 */
+
+	msg_type = u->u.msg.type;
+
+	switch (msg_type) {
+	case XS_TRANSACTION_START:
+	case XS_TRANSACTION_END:
+	case XS_DIRECTORY:
+	case XS_READ:
+	case XS_GET_PERMS:
+	case XS_RELEASE:
+	case XS_GET_DOMAIN_PATH:
+	case XS_WRITE:
+	case XS_MKDIR:
+	case XS_RM:
+	case XS_SET_PERMS:
+		/* Send out a transaction */
+		ret = xenbus_write_transaction(msg_type, u);
+		break;
+
+	case XS_WATCH:
+	case XS_UNWATCH:
+		/* (Un)Ask for some path to be watched for changes */
+		ret = xenbus_write_watch(msg_type, u);
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	if (ret != 0)
+		rc = ret;
+
+	/* Buffered message consumed */
+	u->len = 0;
+
+ out:
+	mutex_unlock(&u->msgbuffer_mutex);
+	return rc;
+}
+
+static int xenbus_file_open(struct inode *inode, struct file *filp)
+{
+	struct xenbus_file_priv *u;
+
+	if (xen_store_evtchn == 0)
+		return -ENOENT;
+
+	nonseekable_open(inode, filp);
+
+	u = kzalloc(sizeof(*u), GFP_KERNEL);
+	if (u == NULL)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&u->transactions);
+	INIT_LIST_HEAD(&u->watches);
+	INIT_LIST_HEAD(&u->read_buffers);
+	init_waitqueue_head(&u->read_waitq);
+
+	mutex_init(&u->reply_mutex);
+	mutex_init(&u->msgbuffer_mutex);
+
+	filp->private_data = u;
+
+	return 0;
+}
+
+static int xenbus_file_release(struct inode *inode, struct file *filp)
+{
+	struct xenbus_file_priv *u = filp->private_data;
+	struct xenbus_transaction_holder *trans, *tmp;
+	struct watch_adapter *watch, *tmp_watch;
+
+	/*
+	 * No need for locking here because there are no other users,
+	 * by definition.
+	 */
+
+	list_for_each_entry_safe(trans, tmp, &u->transactions, list) {
+		xenbus_transaction_end(trans->handle, 1);
+		list_del(&trans->list);
+		kfree(trans);
+	}
+
+	list_for_each_entry_safe(watch, tmp_watch, &u->watches, list) {
+		unregister_xenbus_watch(&watch->watch);
+		list_del(&watch->list);
+		free_watch_adapter(watch);
+	}
+
+	kfree(u);
+
+	return 0;
+}
+
+static unsigned int xenbus_file_poll(struct file *file, poll_table *wait)
+{
+	struct xenbus_file_priv *u = file->private_data;
+
+	poll_wait(file, &u->read_waitq, wait);
+	if (!list_empty(&u->read_buffers))
+		return POLLIN | POLLRDNORM;
+	return 0;
+}
+
+const struct file_operations xenbus_file_ops = {
+	.read = xenbus_file_read,
+	.write = xenbus_file_write,
+	.open = xenbus_file_open,
+	.release = xenbus_file_release,
+	.poll = xenbus_file_poll,
+};
diff -puN /dev/null drivers/xen/xenfs/xenfs.h
--- /dev/null
+++ a/drivers/xen/xenfs/xenfs.h
@@ -0,0 +1,6 @@
+#ifndef _XENFS_XENBUS_H
+#define _XENFS_XENBUS_H
+
+extern const struct file_operations xenbus_file_ops;
+
+#endif	/* _XENFS_XENBUS_H */
diff -puN include/linux/magic.h~xen-add-xenfs-to-allow-usermode-xen-interaction include/linux/magic.h
--- a/include/linux/magic.h~xen-add-xenfs-to-allow-usermode-xen-interaction
+++ a/include/linux/magic.h
@@ -13,6 +13,7 @@
 #define EFS_SUPER_MAGIC		0x414A53
 #define EXT2_SUPER_MAGIC	0xEF53
 #define EXT3_SUPER_MAGIC	0xEF53
+#define XENFS_SUPER_MAGIC	0xabba1974
 #define EXT4_SUPER_MAGIC	0xEF53
 #define HPFS_SUPER_MAGIC	0xf995e849
 #define ISOFS_SUPER_MAGIC	0x9660
diff -puN include/xen/xenbus.h~xen-add-xenfs-to-allow-usermode-xen-interaction include/xen/xenbus.h
--- a/include/xen/xenbus.h~xen-add-xenfs-to-allow-usermode-xen-interaction
+++ a/include/xen/xenbus.h
@@ -136,8 +136,6 @@ struct xenbus_transaction
 /* Nil transaction ID. */
 #define XBT_NIL ((struct xenbus_transaction) { 0 })
 
-int __init xenbus_dev_init(void);
