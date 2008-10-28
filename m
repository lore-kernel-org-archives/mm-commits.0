From: akpm@linux-foundation.org
Subject: - rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements.patch removed from -mm tree
Date: Tue, 28 Oct 2008 16:28:28 -0700
Message-ID: <200810282343.m9SNhIxP022168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753653AbYJ1Xn2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 19:43:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prasad@linux.vnet.ibm.com, dwilder@us.ibm.com, hunt@redhat.com, zanussi@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Rename lib/trace.[ch] files to kernel/relay_debugfs.[ch] and enhancements
has been removed from the -mm tree.  Its filename was
     rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements.patch

This patch was dropped because it breaks each time Sam changes something

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Rename lib/trace.[ch] files to kernel/relay_debugfs.[ch] and enhancements
From: "K.Prasad" <prasad@linux.vnet.ibm.com>

This patch renames the lib/trace.[ch] files to kernel/relay_debugfs.[ch]. 
Also present are the changes to rename the "trace_*" functions to
"relay_*".

Two new functions which provide an easy-to-use interface for relay
called relay_printk() and relay_dump() are also introduced (earlier
called as trace_printk() and trace_dump()).

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Tom Zanussi <zanussi@us.ibm.com>
Cc: Martin Hunt <hunt@redhat.com>
Cc: David Wilder <dwilder@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/relay.txt |   22 
 include/linux/relay_debugfs.h       |  155 +++++
 include/linux/trace.h               |   99 ---
 init/Kconfig                        |    9 
 kernel/Makefile                     |    1 
 kernel/relay_debugfs.c              |  760 ++++++++++++++++++++++++++
 lib/Kconfig                         |    9 
 lib/Makefile                        |    2 
 lib/trace.c                         |  563 -------------------
 samples/Kconfig                     |    8 
 samples/Makefile                    |    2 
 samples/relay/Makefile              |    4 
 samples/relay/fork_trace.c          |  132 ++++
 samples/trace/Makefile              |    4 
 samples/trace/fork_new_trace.c      |   99 +++
 samples/trace/fork_trace.c          |  132 ----
 16 files changed, 1187 insertions(+), 814 deletions(-)

diff -puN Documentation/filesystems/relay.txt~rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements Documentation/filesystems/relay.txt
--- a/Documentation/filesystems/relay.txt~rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements
+++ a/Documentation/filesystems/relay.txt
@@ -637,6 +637,28 @@ are:
 5) Destroy the 'relay debugfs' channel and underlying relay channel -
    relay_cleanup().
 
+Alternatively the user may choose to make use of two new interfaces --
+relay_printk() and relay_dump() -- to setup trace interface and
+relay_cleanup_all() to tear-down the same.
+
+Steps to use:
+1) Create and populate an instance of relay_printk_data structure. The fields
+   parent_dir and dir are mandatory. The fields buf_size, sub_buf_size and flags
+   are optional and will take default values if not populated. The field
+   'exists' and ti are for the trace infrastructure to use. The pointer to the
+   'struct relay_info' i.e. ti may be used to perform fine granular operations
+   such as determine the state of the 'trace', stop individual traces, etc.
+2) Default values for buf_size and sub_buf_size are 4096, 40 respectively.
+3) Use relay_dump() to output binary data which may be acted upon by a
+   high-level program (say dumping a structure). relay_printk() can be used
+   for string output. Pass a pointer to the instance of relay_printk_data
+   structure to these functions along with other parameters. The output from
+   these functions can be found at
+   <debugfs_mount>/<parent_dir>/<dir>/trace<0..n>.
+4) relay_cleanup_all() for a given parent directory will cleanup and remove all
+   trace directories created under the specified directory.
+5) Sample code for the same can be found in samples/trace/fork_new_trace.c
+
 Kernel Configuration
 --------------------
 To use 'relay debugfs', configure your kernel with CONFIG_TRACE=y.
diff -puN /dev/null include/linux/relay_debugfs.h
--- /dev/null
+++ a/include/linux/relay_debugfs.h
@@ -0,0 +1,155 @@
+/*
+ * RELAY DEBUGFS defines and function prototypes
+ *
+ * Copyright (C) 2007 IBM Inc.
+ *
+ *	Tom Zanussi <zanussi@us.ibm.com>
+ *	Martin Hunt <hunt@redhat.com>
+ *	David Wilder <dwilder@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ */
+#ifndef _LINUX_RELAY_DEBUGFS_H
+#define _LINUX_RELAY_DEBUGFS_H
+
+#include <linux/relay.h>
+
+/*
+ * RELAY DEBUGFS channel flags
+ */
+#define RELAY_GLOBAL_CHANNEL	0x01
+#define RELAY_FLIGHT_CHANNEL	0x02
+#define RELAY_DISABLE_STATE	0x04
+
+enum relay_state {
+	RELAY_SETUP,
+	RELAY_RUNNING,
+	RELAY_STOPPED,
+};
+
+enum relay_dir_state {
+	RELAY_PARENT_DIR_ABSENT,
+	RELAY_PARENT_DIR_EXISTS,
+	RELAY_DIR_EXISTS
+};
+
+#define RELAY_ROOT_NAME_SIZE	64	/* Max root dir identifier */
+#define RELAY_NAME_SIZE		64	/* Max relay identifier */
+
+/*
+ * Buffers for use by relay_printk
+ */
+#define DEFAULT_RELAY_BUF_SIZE 4096
+#define DEFAULT_RELAY_SUB_BUF_NR 40
+/*
+ * Global root user information
+ */
+struct relay_root {
+	struct list_head list;
+	char name[RELAY_ROOT_NAME_SIZE];
+	struct dentry *root;
+	unsigned int users;
+};
+
+/*
+ * Client information
+ */
+struct relay_info {
+	struct mutex state_mutex; /* Used to protect state changes */
+	enum relay_state state;
+	struct dentry *state_file;
+	struct rchan *rchan;
+	struct dentry *dir;
+	struct dentry *dropped_file;
+	struct dentry *reset_consumed_file;
+	struct dentry *nr_sub_file;
+	struct dentry *sub_size_file;
+	atomic_t dropped;
+	struct relay_root *root;
+	void *private_data;
+	unsigned int flags;
+	unsigned int buf_size;
+	unsigned int buf_nr;
+	spinlock_t relay_lock;
+};
+
+struct relay_printk_data {
+	char *parent_dir;
+	char *dir;
+	int exists;
+	int buf_size;
+	int sub_buf_size;
+	unsigned long flags;
+	struct relay_info *ti;
+};
+
+/*
+ * Information about every 'relay debugfs' directory
+ */
+struct relay_dir {
+	struct list_head relay_dir_list;
+	char relay_dir_name[RELAY_NAME_SIZE];
+	struct dentry *relay_root;
+	struct dentry *relay_dir;
+	struct relay_info *ti;
+};
+
+#ifdef CONFIG_RELAY_DEBUGFS
+static inline int relay_running(struct relay_info *relay)
+{
+	return relay->state == RELAY_RUNNING;
+}
+struct relay_info *relay_setup(const char *root, const char *name,
+			       u32 buf_size, u32 buf_nr, u32 flags);
+int relay_start(struct relay_info *relay);
+int relay_stop(struct relay_info *relay);
+void relay_cleanup(struct relay_info *relay);
+int relay_exists(const char *parent_dir, const char *dir,
+					struct relay_info **ti);
+void relay_cleanup_all(const char *parent_dir);
+int relay_printk(struct relay_printk_data *dpk, char *format, ...);
+int relay_dump(struct relay_printk_data *dpk, const void *output,
+							const int output_len);
+#else
+static inline struct relay_info *relay_setup(const char *root,
+					     const char *name, u32 buf_size,
+					     u32 buf_nr, u32 flags)
+{
+	return NULL;
+}
+static inline int relay_start(struct relay_info *relay) { return -EINVAL; }
+static inline int relay_stop(struct relay_info *relay) { return -EINVAL; }
+static inline int relay_running(struct relay_info *relay) { return 0; }
+static inline void relay_cleanup(struct relay_info *relay) {}
+static inline int relay_exists(const char *parent_dir, const char *dir,
+				struct relay_info **ti)
+{
+	return -EINVAL;
+}
+static inline void relay_cleanup_all(const char *parent_dir) {}
+static inline int relay_printk(struct relay_printk_data *dpk, char *format,
+				...)
+{
+	return -EINVAL;
+}
+int relay_dump(struct relay_printk_data *dpk, const void *output,
+							const int output_len)
+{
+	return -EINVAL;
+}
+
+#endif
+
+#endif /* ifdef CONFIG_RELAY_DEBUGFS */
diff -puN include/linux/trace.h~rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements /dev/null
--- a/include/linux/trace.h
+++ /dev/null
@@ -1,99 +0,0 @@
-/*
- * TRACE defines and function prototypes
- *
- * Copyright (C) 2007 IBM Inc.
- *
- *	Tom Zanussi <zanussi@us.ibm.com>
- *	Martin Hunt <hunt@redhat.com>
- *	David Wilder <dwilder@us.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
- */
-#ifndef _LINUX_TRACE_H
-#define _LINUX_TRACE_H
-
-#include <linux/relay.h>
-
-/*
- * TRACE channel flags
- */
-#define TRACE_GLOBAL_CHANNEL	0x01
-#define TRACE_FLIGHT_CHANNEL	0x02
-#define TRACE_DISABLE_STATE	0x04
-
-enum trace_state {
-	TRACE_SETUP,
-	TRACE_RUNNING,
-	TRACE_STOPPED,
-};
-
-#define TRACE_ROOT_NAME_SIZE	64	/* Max root dir identifier */
-#define TRACE_NAME_SIZE		64	/* Max trace identifier */
-
-/*
- * Global root user information
- */
-struct trace_root {
-	struct list_head list;
-	char name[TRACE_ROOT_NAME_SIZE];
-	struct dentry *root;
-	unsigned int users;
-};
-
-/*
- * Client information
- */
-struct trace_info {
-	struct mutex state_mutex; /* Used to protect state changes */
-	enum trace_state state;
-	struct dentry *state_file;
-	struct rchan *rchan;
-	struct dentry *dir;
-	struct dentry *dropped_file;
-	struct dentry *reset_consumed_file;
-	struct dentry *nr_sub_file;
-	struct dentry *sub_size_file;
-	atomic_t dropped;
-	struct trace_root *root;
-	void *private_data;
-	unsigned int flags;
-	unsigned int buf_size;
-	unsigned int buf_nr;
-};
-
-#ifdef CONFIG_TRACE
-static inline int trace_running(struct trace_info *trace)
-{
-	return trace->state == TRACE_RUNNING;
-}
-struct trace_info *trace_setup(const char *root, const char *name,
-			       u32 buf_size, u32 buf_nr, u32 flags);
-int trace_start(struct trace_info *trace);
-int trace_stop(struct trace_info *trace);
-void trace_cleanup(struct trace_info *trace);
-#else
-static inline struct trace_info *trace_setup(const char *root,
-					     const char *name, u32 buf_size,
-					     u32 buf_nr, u32 flags)
-{
-	return NULL;
-}
-static inline int trace_start(struct trace_info *trace) { return -EINVAL; }
-static inline int trace_stop(struct trace_info *trace) { return -EINVAL; }
-static inline int trace_running(struct trace_info *trace) { return 0; }
-static inline void trace_cleanup(struct trace_info *trace) {}
-#endif
-
-#endif
diff -puN init/Kconfig~rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements init/Kconfig
--- a/init/Kconfig~rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements
+++ a/init/Kconfig
@@ -467,6 +467,15 @@ config RELAY
 
 	  If unsure, say N.
 
+config RELAY_DEBUGFS
+	bool "Relay debugfs setup and control"
+	depends on RELAY && DEBUG_FS
+	help
+	  This option provides support for the setup, teardown and control
+	  of relay channels from kernel code which are mounted on debugfs.
+	  It also provides information and control to userspace via a set of
+	  debugfs control files.  If unsure, say N.
+
 config NAMESPACES
 	bool "Namespaces support" if EMBEDDED
 	default !EMBEDDED
diff -puN kernel/Makefile~rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements kernel/Makefile
--- a/kernel/Makefile~rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements
+++ a/kernel/Makefile
@@ -77,6 +77,7 @@ ifeq ($(CONFIG_PREEMPT_RCU),y)
 obj-$(CONFIG_RCU_TRACE) += rcupreempt_trace.o
 endif
 obj-$(CONFIG_RELAY) += relay.o
+obj-$(CONFIG_RELAY_DEBUGFS) += relay_debugfs.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
diff -puN /dev/null kernel/relay_debugfs.c
--- /dev/null
+++ a/kernel/relay_debugfs.c
@@ -0,0 +1,760 @@
+/*
+ * Based on blktrace code, Copyright (C) 2006 Jens Axboe <axboe@kernel.dk>
+ * Moved to utt.c by Tom Zanussi <zanussi@us.ibm.com>, 2006
+ * Additional contributions by:
+ * Martin Hunt <hunt@redhat.com>, 2007
+ * David Wilder <dwilder@us.ibm.com>, 2007
+ * Renamed to trace <dwilder.ibm.com>, 2007
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/mutex.h>
+#include <linux/debugfs.h>
+#include <linux/relay_debugfs.h>
+
+static LIST_HEAD(relay_roots);
+static LIST_HEAD(relay_dirs);
+static DEFINE_MUTEX(relay_mutex);
+
+static int state_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+	return 0;
+}
+
+static ssize_t state_read(struct file *filp, char __user *buffer,
+			  size_t count, loff_t *ppos)
+{
+	struct relay_info *relay = filp->private_data;
+	char *buf = "relay not started\n";
+
+	if (relay->state == RELAY_STOPPED)
+		buf = "stopped\n";
+	else if (relay->state == RELAY_RUNNING)
+		buf = "running\n";
+	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+}
+
+static ssize_t state_write(struct file *filp, const char __user *buffer,
+			   size_t count, loff_t *ppos)
+{
+	struct relay_info *relay = filp->private_data;
+	char buf[16];
+	int ret;
+
+	if (relay->flags & RELAY_DISABLE_STATE)
+		return -EINVAL;
+
+	if (count > sizeof(buf) - 1)
+		return -EINVAL;
+
+	if (copy_from_user(buf, buffer, count))
+		return -EFAULT;
+
+	buf[count-1] = '\0';
+
+	if (strcmp(buf, "start") == 0) {
+		ret = relay_start(relay);
+		if (ret)
+			return ret;
+	} else if (strcmp(buf, "stop") == 0)
+		relay_stop(relay);
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+static struct file_operations state_fops = {
+	.owner	= THIS_MODULE,
+	.open	= state_open,
+	.read	= state_read,
+	.write	= state_write,
+};
+
+static void remove_root(struct relay_info *relay)
+{
+	if (relay->root->root && simple_empty(relay->root->root)) {
+		debugfs_remove(relay->root->root);
+		list_del(&relay->root->list);
+		kfree(relay->root);
+		relay->root = NULL;
+	}
+}
+
+static void remove_tree(struct relay_info *relay)
+{
+	struct list_head *pos, *temp;
+	struct relay_dir *dr = NULL;
+
+	mutex_lock(&relay_mutex);
+	debugfs_remove(relay->dir);
+
+	list_for_each_safe(pos, temp, &relay_dirs) {
+		dr = list_entry(pos, struct relay_dir, relay_dir_list);
+		if (dr->ti == relay) {
+			list_del(pos);
+			kfree(dr);
+		}
+	}
+
+	if (relay->root) {
+		if (--relay->root->users == 0)
+			remove_root(relay);
+	}
+
+	mutex_unlock(&relay_mutex);
+}
+
+/*
+ * Creates the relay_root if it's not found.
+ */
+static struct relay_root *lookup_root(const char *root)
+{
+	struct list_head *pos;
+	struct relay_root *r;
+
+	list_for_each(pos, &relay_roots) {
+		r = list_entry(pos, struct relay_root, list);
+		if (!strcmp(r->name, root))
+			return r;
+	}
+
+	r = kzalloc(sizeof(struct relay_root), GFP_KERNEL);
+	if (!r)
+		return ERR_PTR(-ENOMEM);
+
+	strlcpy(r->name, root, sizeof(r->name));
+
+	r->root = debugfs_create_dir(root, NULL);
+	if (IS_ERR(r->root))
+		r->root = NULL;
+	else
+		list_add(&r->list, &relay_roots);
+
+	return r;
+}
+
+static struct dentry *create_tree(struct relay_info *relay, const char *root,
+				  const char *name)
+{
+	struct relay_dir *temp;
+
+	if (root == NULL || name == NULL)
+		return ERR_PTR(-EINVAL);
+
+	temp = kzalloc(sizeof(struct relay_dir), GFP_KERNEL);
+	if ((temp == NULL) || (strlen(name) > RELAY_NAME_SIZE))
+		return ERR_PTR(-ENOMEM);
+
+	strlcpy(temp->relay_dir_name, name, sizeof(temp->relay_dir_name));
+
+	mutex_lock(&relay_mutex);
+
+	relay->root = lookup_root(root);
+	if (IS_ERR(relay->root)) {
+		relay->root = NULL;
+		goto err;
+	}
+
+	temp->relay_root = relay->root->root;
+	temp->relay_dir = debugfs_create_dir(name, relay->root->root);
+
+	if (IS_ERR(temp->relay_dir))
+		remove_root(relay);
+	else {
+		relay->root->users++;
+		temp->ti = relay;
+		list_add_tail(&temp->relay_dir_list, &relay_dirs);
+	}
+
+err:
+	mutex_unlock(&relay_mutex);
+	return temp->relay_dir;
+}
+
+int relay_exists(const char *parent_dir, const char *dir,
+					struct relay_info **ti)
+{
+	struct list_head *pos;
+	struct relay_root *r;
+	struct relay_dir *temp;
+
+	list_for_each(pos, &relay_roots) {
+		r = list_entry(pos, struct relay_root, list);
+		if (!strcmp(parent_dir, r->name))
+			goto search_dir;
+	}
+	return RELAY_PARENT_DIR_ABSENT;
+
+ search_dir:
+	list_for_each(pos, &relay_dirs) {
+		temp = list_entry(pos, struct relay_dir, relay_dir_list);
+
+		if (!strcmp(dir, temp->relay_dir_name)) {
+			*ti = temp->ti;
+			return RELAY_DIR_EXISTS;
+		}
+	}
+	return RELAY_PARENT_DIR_EXISTS;
+}
+EXPORT_SYMBOL_GPL(relay_exists);
+
+static int dropped_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+
+	return 0;
+}
+
+static ssize_t dropped_read(struct file *filp, char __user *buffer,
+			    size_t count, loff_t *ppos)
+{
+	struct relay_info *relay = filp->private_data;
+	char buf[16];
+
+	snprintf(buf, sizeof(buf), "%u\n", atomic_read(&relay->dropped));
+
+	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+}
+
+static struct file_operations dropped_fops = {
+	.owner	= THIS_MODULE,
+	.open	= dropped_open,
+	.read	= dropped_read,
+};
+
+static int reset_consumed_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+
+	return 0;
+}
+
+static ssize_t reset_consumed_write(struct file *filp,
+				    const char __user *buffer,
+				    size_t count, loff_t *ppos)
+{
+	int ret = count;
+	struct relay_info *relay = filp->private_data;
+
+	mutex_lock(&relay->state_mutex);
+	switch (relay->state) {
+	case RELAY_RUNNING:
+		relay->state = RELAY_STOPPED;
+		synchronize_rcu();
+		relay_flush(relay->rchan);
+		relay_reset_consumed(relay->rchan);
+		relay->state = RELAY_RUNNING;
+		break;
+	case RELAY_STOPPED:
+		relay_reset_consumed(relay->rchan);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	mutex_unlock(&relay->state_mutex);
+	return ret;
+}
+
+static struct file_operations reset_consumed_fops = {
+	.owner	= THIS_MODULE,
+	.open	= reset_consumed_open,
+	.write	= reset_consumed_write
+};
+
+static int sub_size_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+
+	return 0;
+}
+
+static ssize_t sub_size_read(struct file *filp, char __user *buffer,
+			     size_t count, loff_t *ppos)
+{
+	struct relay_info *relay = filp->private_data;
+	char buf[32];
+
+	snprintf(buf, sizeof(buf), "%zu\n", relay->rchan->subbuf_size);
+
+	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+}
+
+static struct file_operations sub_size_fops = {
+	.owner	= THIS_MODULE,
+	.open	= sub_size_open,
+	.read	= sub_size_read,
+};
+
+static int nr_sub_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+	return 0;
+}
+
+static ssize_t nr_sub_read(struct file *filp, char __user *buffer,
+			   size_t count, loff_t *ppos)
+{
+	struct relay_info *relay = filp->private_data;
+	char buf[32];
+
+	snprintf(buf, sizeof(buf), "%zu\n", relay->rchan->n_subbufs);
+
+	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+}
+
+static struct file_operations nr_sub_fops = {
+	.owner	= THIS_MODULE,
+	.open	= nr_sub_open,
+	.read	= nr_sub_read,
+};
+
+/*
+ * Keep track of how many times we encountered a full subbuffer, to aid
+ * the user space app in telling how many lost events there were.
+ */
+static int subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
+				 void *prev_subbuf, size_t prev_padding)
+{
+	struct relay_info *relay = buf->chan->private_data;
+
+	if (relay->flags & RELAY_FLIGHT_CHANNEL)
+		return 1;
+
+	if (!relay_buf_full(buf))
+		return 1;
+
+	atomic_inc(&relay->dropped);
+
+	return 0;
+}
+
+static int remove_buf_file_callback(struct dentry *dentry)
+{
+	debugfs_remove(dentry);
+
+	return 0;
+}
+
+static struct dentry *create_buf_file_callback(const char *filename,
+					       struct dentry *parent, int mode,
+					       struct rchan_buf *buf,
+					       int *is_global)
+{
+	return debugfs_create_file(filename, mode, parent, buf,
+				   &relay_file_operations);
+}
+
+static struct dentry *create_global_buf_file_callback(const char *filename,
+						      struct dentry *parent,
+						      int mode,
+						      struct rchan_buf *buf,
+						      int *is_global)
+{
+	*is_global = 1;
+
+	return debugfs_create_file(filename, mode, parent, buf,
+				   &relay_file_operations);
+}
+
+static struct rchan_callbacks relay_callbacks = {
+	.subbuf_start		= subbuf_start_callback,
+	.create_buf_file	= create_buf_file_callback,
+	.remove_buf_file	= remove_buf_file_callback,
+};
+static struct rchan_callbacks relay_callbacks_global = {
+	.subbuf_start		= subbuf_start_callback,
+	.create_buf_file	= create_global_buf_file_callback,
+	.remove_buf_file	= remove_buf_file_callback,
+};
+
+static void remove_controls(struct relay_info *relay)
+{
+	debugfs_remove(relay->state_file);
+	debugfs_remove(relay->dropped_file);
+	debugfs_remove(relay->reset_consumed_file);
+	debugfs_remove(relay->nr_sub_file);
+	debugfs_remove(relay->sub_size_file);
+	remove_tree(relay);
+}
+
+/*
+ * Setup controls for tracing.
+ */
+static struct relay_info *setup_controls(const char *root,
+					 const char *name, u32 flags)
+{
+	struct relay_info *relay;
+	long ret;
+
+	relay = kzalloc(sizeof(*relay), GFP_KERNEL);
+	if (!relay) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	relay->dir = create_tree(relay, root, name);
+	if (IS_ERR(relay->dir)) {
+		ret = PTR_ERR(relay->dir);
+		relay->dir = NULL;
+		goto err;
+	}
+
+	relay->state_file = debugfs_create_file("state", 0444, relay->dir,
+						 relay, &state_fops);
+	if (IS_ERR(relay->state_file)) {
+		ret = PTR_ERR(relay->state_file);
+		relay->state_file = NULL;
+		goto err;
+	}
+
+	if (!(flags & RELAY_FLIGHT_CHANNEL)) {
+		relay->dropped_file = debugfs_create_file("dropped", 0444,
+							  relay->dir, relay,
+							  &dropped_fops);
+		if (IS_ERR(relay->dropped_file)) {
+			ret = PTR_ERR(relay->dropped_file);
+			relay->dropped_file = NULL;
+			goto err;
+		}
+	}
+
+	if (flags & RELAY_FLIGHT_CHANNEL) {
+		relay->reset_consumed_file = debugfs_create_file("rewind", 0444,
+							relay->dir, relay,
+							&reset_consumed_fops);
+		if (IS_ERR(relay->reset_consumed_file)) {
+			ret = PTR_ERR(relay->reset_consumed_file);
+			relay->reset_consumed_file = NULL;
+			goto err;
+		}
+	}
+
+	relay->nr_sub_file = debugfs_create_file("nr_sub", 0444,
+						 relay->dir, relay,
+						 &nr_sub_fops);
+	if (IS_ERR(relay->nr_sub_file)) {
+		ret = PTR_ERR(relay->nr_sub_file);
+		relay->nr_sub_file = NULL;
+		goto err;
+	}
+
+	relay->sub_size_file = debugfs_create_file("sub_size", 0444,
+						   relay->dir, relay,
+						   &sub_size_fops);
+	if (IS_ERR(relay->sub_size_file)) {
+		ret = PTR_ERR(relay->sub_size_file);
+		relay->sub_size_file = NULL;
+		goto err;
+	}
+
+	return relay;
+err:
+	if (relay) {
+		remove_controls(relay);
+		kfree(relay);
+	}
+
+	return ERR_PTR(ret);
+}
+
+static int relay_setup_channel(struct relay_info *relay, u32 buf_size,
+				u32 buf_nr, u32 flags)
+{
+	if (!buf_size || !buf_nr)
+		return -EINVAL;
+
+	if (flags & RELAY_GLOBAL_CHANNEL)
+		relay->rchan = relay_open("trace", relay->dir, buf_size,
+					  buf_nr, &relay_callbacks_global,
+					  relay);
+	else
+		relay->rchan = relay_open("trace", relay->dir, buf_size,
+					  buf_nr, &relay_callbacks, relay);
+
+	if (!relay->rchan)
+		return -ENOMEM;
+
+	relay->flags = flags;
+	relay->state = RELAY_SETUP;
+
+	return 0;
+}
+
+/**
+ *	relay_setup - create a new relay relay handle
+ *	@root: The root directory name to place relay directories.
+ *	@name: Relay debugfs directory name, created in @root
+ *	@buf_size: size of the relay sub-buffers
+ *	@buf_nr: number of relay sub-buffers
+ *	@flags: Option selection (see relay channel flags definitions)
+ *
+ *	returns a relay_info handle or NULL, if setup failed.
+ *
+ *	The @root is created (if needed) in the root of the debugfs.
+ *	The default values when flags=0 are: use per-CPU buffering,
+ *	use non-overwrite mode. See Documentation/filesystems/relay.txt for
+ *	details.
+ */
+struct relay_info *relay_setup(const char *root, const char *name,
+			       u32 buf_size, u32 buf_nr, u32 flags)
+{
+	struct relay_info *relay;
+
+	relay = setup_controls(root, name, flags);
+	if (IS_ERR(relay))
+		return relay;
+
+	relay->buf_size = buf_size;
+	relay->buf_nr = buf_nr;
+	relay->flags = flags;
+	mutex_init(&relay->state_mutex);
+	relay->state = RELAY_SETUP;
+
+	return relay;
+}
+EXPORT_SYMBOL_GPL(relay_setup);
+
+/**
+ *	relay_start - start tracing
+ *	@relay: relay handle to start.
+ *
+ *	returns 0 if successful.
+ */
+int relay_start(struct relay_info *relay)
+{
+	/*
+	 * For starting a relay, we can transition from a setup or stopped
+	 * relay.
+	 */
+	if (relay->state == RELAY_RUNNING)
+		return -EINVAL;
+
+	mutex_lock(&relay->state_mutex);
+	if (relay->state == RELAY_SETUP) {
+		int ret;
+
+		ret = relay_setup_channel(relay, relay->buf_size,
+					  relay->buf_nr, relay->flags);
+		if (ret) {
+			mutex_unlock(&relay->state_mutex);
+			return ret;
+		}
+	}
+
+	relay->state = RELAY_RUNNING;
+	mutex_unlock(&relay->state_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(relay_start);
+
+/**
+ *	relay_stop - stop tracing
+ *	@relay: relay handle to stop.
+ *
+ */
+int relay_stop(struct relay_info *relay)
+{
+	int ret = -EINVAL;
+
+	/*
+	 * For stopping a relay, the state must be running
+	 */
+	mutex_lock(&relay->state_mutex);
+	if (relay->state == RELAY_RUNNING) {
+		relay->state = RELAY_STOPPED;
+		/*
+		 * wait for all cpus to see the change in
+		 * state before continuing
+		 */
+		synchronize_sched();
+		relay_flush(relay->rchan);
+		ret = 0;
+	}
+	mutex_unlock(&relay->state_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(relay_stop);
+
+static void relay_cleanup_channel(struct relay_info *relay)
+{
+	relay_stop(relay);
+	relay_close(relay->rchan);
+	relay->rchan = NULL;
+}
+
+/**
+ *	relay_cleanup - destroys the relay channel, control files and dir
+ *	@relay: relay handle to cleanup
+ */
+void relay_cleanup(struct relay_info *relay)
+{
+	relay_cleanup_channel(relay);
+	remove_controls(relay);
+	kfree(relay);
+}
+EXPORT_SYMBOL_GPL(relay_cleanup);
+
+/**
+ *	relay_cleanup_all - Removes all relay debugfs directories in parent_dir
+ *	@parent_dir: Name of the parent directory
+ */
+void relay_cleanup_all(const char *parent_dir)
+{
+	struct list_head *pos, *pos_temp;
+	struct relay_dir *temp;
+
+	list_for_each_safe(pos, pos_temp, &relay_dirs) {
+		temp = list_entry(pos, struct relay_dir, relay_dir_list);
+		if (!strncmp(parent_dir, temp->relay_root->d_iname, \
+							strlen(parent_dir)))
+			relay_cleanup(temp->ti);
+	}
+}
+EXPORT_SYMBOL_GPL(relay_cleanup_all);
+
+/*
+ * Send formatted data to relay debugfs channel.
+ */
+static int relay_printf(struct relay_info *trace, const char *format,
+								va_list ap)
+{
+	va_list aq;
+	char *record;
+	int len, ret = 0;
+
+	if (relay_running(trace)) {
+		va_copy(aq, ap);
+		len = vsnprintf(NULL, 0, format, aq);
+		va_end(aq);
+		record = relay_reserve(trace->rchan, ++len);
+		if (record)
+			ret = vsnprintf(record, len, format, ap);
+	}
+	return ret;
+}
+
+static inline int init_relay_interface(struct relay_printk_data *tpk)
+{
+	int ret = 0;
+	tpk->exists = relay_exists(tpk->parent_dir, tpk->dir, &tpk->ti);
+
+	switch (tpk->exists) {
+
+	case RELAY_PARENT_DIR_EXISTS:
+	case RELAY_PARENT_DIR_ABSENT:
+		if (!tpk->buf_size)
+			tpk->buf_size = DEFAULT_RELAY_BUF_SIZE;
+		if (!tpk->sub_buf_size)
+			tpk->sub_buf_size = DEFAULT_RELAY_SUB_BUF_NR;
+		tpk->ti = relay_setup(tpk->parent_dir, tpk->dir,
+				tpk->buf_size, tpk->sub_buf_size, tpk->flags);
+		printk(KERN_INFO "Trace interface %s setup\n",
+							tpk->ti->dir->d_iname);
+		if (IS_ERR(tpk->ti)) {
+			printk(KERN_ERR "Error initialising %s interface\n",
+							tpk->ti->dir->d_iname);
+			return -EPERM;
+		}
+	/* Fall through */
+	case RELAY_DIR_EXISTS:
+		if (tpk->ti->state == RELAY_SETUP)
+			ret = relay_start(tpk->ti);
+		else
+			ret = -EPERM;
+	}
+
+	return 0;
+}
+
+/**
+ * relay_printk - Output a string to debugfs mount 'directly' using 'trace'
+ * @tpk: Structure containing info such as parent_dir and directory
+ * @format: String containing format string specifiers
+ * @ap: List of arguments
+ */
+int relay_printk(struct relay_printk_data *tpk, char *format, ...)
+{
+	int ret = 0;
+	va_list(ap);
+	unsigned long flags = 0;
+
+	va_start(ap, format);
+
+	ret = init_relay_interface(tpk);
+	if (unlikely(ret))
+		return ret;
+
+	/* Now do the actual printing */
+	/* Take an RCU Lock over the relay_info state */
+	rcu_read_lock();
+	/* Take a spinlock for the global buffer used by relay */
+	if (tpk->flags & RELAY_GLOBAL_CHANNEL)
+		spin_lock_irqsave(&tpk->ti->relay_lock, flags);
+	ret = relay_printf(tpk->ti, format, ap);
+	if (tpk->flags & RELAY_GLOBAL_CHANNEL)
+		spin_unlock_irqrestore(&tpk->ti->relay_lock, flags);
+	rcu_read_unlock();
+
+	va_end(ap);
+	return ret;
+}
+EXPORT_SYMBOL(relay_printk);
+
+/**
+ * relay_dump - Output binary into debugfs mount 'directly' using 'trace'
+ * @tpk: Structure containing info such as parent_dir and directory
+ * @output: Data that needs to be output
+ * @output_len: Length of the output data
+ */
+int relay_dump(struct relay_printk_data *tpk, const void *output,
+							const int output_len)
+{
+	char *record;
+	unsigned long flags = 0;
+	int ret = 0;
+
+	ret = init_relay_interface(tpk);
+	if (unlikely(ret))
+		return ret;
+
+	/* Now do the actual printing */
+	rcu_read_lock();
+	/* Take a spinlock for the global buffer used by relay */
+	if (tpk->flags & RELAY_GLOBAL_CHANNEL)
+		spin_lock_irqsave(&tpk->ti->relay_lock, flags);
+	record = relay_reserve(tpk->ti->rchan, output_len);
+
+	if (record && relay_running(tpk->ti))
+		memcpy(record, output, output_len);
+	else {
+		if (record)
+			ret = -EPERM;
+		else
+			ret = -ENOMEM;
+	}
+	if (tpk->flags & RELAY_GLOBAL_CHANNEL)
+		spin_unlock_irqrestore(&tpk->ti->relay_lock, flags);
+	rcu_read_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL(relay_dump);
diff -puN lib/Kconfig~rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements lib/Kconfig
--- a/lib/Kconfig~rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements
+++ a/lib/Kconfig
@@ -157,13 +157,4 @@ config CHECK_SIGNATURE
 config HAVE_LMB
 	boolean
 
-config TRACE
-	bool "Trace setup and control"
-	depends on RELAY && DEBUG_FS
-	help
-	  This option provides support for the setup, teardown and control
-	  of tracing channels from kernel code.  It also provides trace
-	  information and control to userspace via a set of debugfs control
-	  files.  If unsure, say N.
-
 endmenu
diff -puN lib/Makefile~rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements lib/Makefile
--- a/lib/Makefile~rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements
+++ a/lib/Makefile
@@ -82,8 +82,6 @@ obj-$(CONFIG_HAVE_ARCH_TRACEHOOK) += sys
 
 obj-$(CONFIG_DYNAMIC_PRINTK_DEBUG) += dynamic_printk.o
 
-obj-$(CONFIG_TRACE) += trace.o
-
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff -puN lib/trace.c~rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements /dev/null
--- a/lib/trace.c
+++ /dev/null
@@ -1,563 +0,0 @@
-/*
- * Based on blktrace code, Copyright (C) 2006 Jens Axboe <axboe@kernel.dk>
- * Moved to utt.c by Tom Zanussi <zanussi@us.ibm.com>, 2006
- * Additional contributions by:
- * Martin Hunt <hunt@redhat.com>, 2007
- * David Wilder <dwilder@us.ibm.com>, 2007
- * Renamed to trace <dwilder.ibm.com>, 2007
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/mutex.h>
-#include <linux/debugfs.h>
-#include <linux/trace.h>
-
-static LIST_HEAD(trace_roots);
-static DEFINE_MUTEX(trace_mutex);
-
-static int state_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-	return 0;
-}
-
-static ssize_t state_read(struct file *filp, char __user *buffer,
-			  size_t count, loff_t *ppos)
-{
-	struct trace_info *trace = filp->private_data;
-	char *buf = "trace not started\n";
-
-	if (trace->state == TRACE_STOPPED)
-		buf = "stopped\n";
-	else if (trace->state == TRACE_RUNNING)
-		buf = "running\n";
-	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
-}
-
-static ssize_t state_write(struct file *filp, const char __user *buffer,
-			   size_t count, loff_t *ppos)
-{
-	struct trace_info *trace = filp->private_data;
-	char buf[16];
-	int ret;
-
-	if (trace->flags & TRACE_DISABLE_STATE)
-		return -EINVAL;
-
-	if (count > sizeof(buf) - 1)
-		return -EINVAL;
-
-	if (copy_from_user(buf, buffer, count))
-		return -EFAULT;
-
-	buf[count-1] = '\0';
-
-	if (strcmp(buf, "start") == 0) {
-		ret = trace_start(trace);
-		if (ret)
-			return ret;
-	} else if (strcmp(buf, "stop") == 0)
-		trace_stop(trace);
-	else
-		return -EINVAL;
-
-	return count;
-}
-
-static struct file_operations state_fops = {
-	.owner	= THIS_MODULE,
-	.open	= state_open,
-	.read	= state_read,
-	.write	= state_write,
-};
-
-static void remove_root(struct trace_info *trace)
-{
-	if (trace->root->root && simple_empty(trace->root->root)) {
-		debugfs_remove(trace->root->root);
-		list_del(&trace->root->list);
-		kfree(trace->root);
-		trace->root = NULL;
-	}
-}
-
-static void remove_tree(struct trace_info *trace)
-{
-	mutex_lock(&trace_mutex);
-	debugfs_remove(trace->dir);
-
-	if (trace->root) {
-		if (--trace->root->users == 0)
-			remove_root(trace);
-	}
-
-	mutex_unlock(&trace_mutex);
-}
-
-/*
- * Creates the trace_root if it's not found.
- */
-static struct trace_root *lookup_root(const char *root)
-{
-	struct list_head *pos;
-	struct trace_root *r;
-
-	list_for_each(pos, &trace_roots) {
-		r = list_entry(pos, struct trace_root, list);
-		if (!strcmp(r->name, root))
-			return r;
-	}
-
-	r = kzalloc(sizeof(struct trace_root), GFP_KERNEL);
-	if (!r)
-		return ERR_PTR(-ENOMEM);
-
-	strlcpy(r->name, root, sizeof(r->name));
-
-	r->root = debugfs_create_dir(root, NULL);
-	if (IS_ERR(r->root))
-		r->root = NULL;
-	else
-		list_add(&r->list, &trace_roots);
-
-	return r;
-}
-
-static struct dentry *create_tree(struct trace_info *trace, const char *root,
-				  const char *name)
-{
-	struct dentry *dir = NULL;
-
-	if (root == NULL || name == NULL)
-		return ERR_PTR(-EINVAL);
-
-	mutex_lock(&trace_mutex);
-
-	trace->root = lookup_root(root);
-	if (IS_ERR(trace->root)) {
-		trace->root = NULL;
-		goto err;
-	}
-
-	dir = debugfs_create_dir(name, trace->root->root);
-	if (IS_ERR(dir))
-		remove_root(trace);
-	else
-		trace->root->users++;
-
-err:
-	mutex_unlock(&trace_mutex);
-	return dir;
-}
-
-static int dropped_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-
-	return 0;
-}
-
-static ssize_t dropped_read(struct file *filp, char __user *buffer,
-			    size_t count, loff_t *ppos)
-{
-	struct trace_info *trace = filp->private_data;
-	char buf[16];
-
-	snprintf(buf, sizeof(buf), "%u\n", atomic_read(&trace->dropped));
-
-	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
-}
-
-static struct file_operations dropped_fops = {
-	.owner	= THIS_MODULE,
-	.open	= dropped_open,
-	.read	= dropped_read,
-};
-
-static int reset_consumed_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-
-	return 0;
-}
-
-static ssize_t reset_consumed_write(struct file *filp,
-				    const char __user *buffer,
-				    size_t count, loff_t *ppos)
-{
-	int ret = count;
-	struct trace_info *trace = filp->private_data;
-
-	mutex_lock(&trace->state_mutex);
-	switch (trace->state) {
-	case TRACE_RUNNING:
-		trace->state = TRACE_STOPPED;
-		synchronize_rcu();
-		relay_flush(trace->rchan);
-		relay_reset_consumed(trace->rchan);
-		trace->state = TRACE_RUNNING;
-		break;
-	case TRACE_STOPPED:
-		relay_reset_consumed(trace->rchan);
-		break;
-	default:
-		ret = -EINVAL;
-	}
-	mutex_unlock(&trace->state_mutex);
-	return ret;
-}
-
-static struct file_operations reset_consumed_fops = {
-	.owner	= THIS_MODULE,
-	.open	= reset_consumed_open,
-	.write	= reset_consumed_write
-};
-
-static int sub_size_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-
-	return 0;
-}
-
-static ssize_t sub_size_read(struct file *filp, char __user *buffer,
-			     size_t count, loff_t *ppos)
-{
-	struct trace_info *trace = filp->private_data;
-	char buf[32];
-
-	snprintf(buf, sizeof(buf), "%zu\n", trace->rchan->subbuf_size);
-
-	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
-}
-
-static struct file_operations sub_size_fops = {
-	.owner	= THIS_MODULE,
-	.open	= sub_size_open,
-	.read	= sub_size_read,
-};
-
-static int nr_sub_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-	return 0;
-}
-
-static ssize_t nr_sub_read(struct file *filp, char __user *buffer,
-			   size_t count, loff_t *ppos)
-{
-	struct trace_info *trace = filp->private_data;
-	char buf[32];
-
-	snprintf(buf, sizeof(buf), "%zu\n", trace->rchan->n_subbufs);
-
-	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
-}
-
-static struct file_operations nr_sub_fops = {
-	.owner	= THIS_MODULE,
-	.open	= nr_sub_open,
-	.read	= nr_sub_read,
-};
-
-/*
- * Keep track of how many times we encountered a full subbuffer, to aid
- * the user space app in telling how many lost events there were.
- */
-static int subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
-				 void *prev_subbuf, size_t prev_padding)
-{
-	struct trace_info *trace = buf->chan->private_data;
-
-	if (trace->flags & TRACE_FLIGHT_CHANNEL)
-		return 1;
-
-	if (!relay_buf_full(buf))
-		return 1;
-
-	atomic_inc(&trace->dropped);
-
-	return 0;
-}
-
-static int remove_buf_file_callback(struct dentry *dentry)
-{
-	debugfs_remove(dentry);
-
-	return 0;
-}
-
-static struct dentry *create_buf_file_callback(const char *filename,
-					       struct dentry *parent, int mode,
-					       struct rchan_buf *buf,
-					       int *is_global)
-{
-	return debugfs_create_file(filename, mode, parent, buf,
-				   &relay_file_operations);
-}
-
-static struct dentry *create_global_buf_file_callback(const char *filename,
-						      struct dentry *parent,
-						      int mode,
-						      struct rchan_buf *buf,
-						      int *is_global)
-{
-	*is_global = 1;
-
-	return debugfs_create_file(filename, mode, parent, buf,
-				   &relay_file_operations);
-}
-
-static struct rchan_callbacks relay_callbacks = {
-	.subbuf_start		= subbuf_start_callback,
-	.create_buf_file	= create_buf_file_callback,
-	.remove_buf_file	= remove_buf_file_callback,
-};
-static struct rchan_callbacks relay_callbacks_global = {
-	.subbuf_start		= subbuf_start_callback,
-	.create_buf_file	= create_global_buf_file_callback,
-	.remove_buf_file	= remove_buf_file_callback,
-};
-
-static void remove_controls(struct trace_info *trace)
-{
-	debugfs_remove(trace->state_file);
-	debugfs_remove(trace->dropped_file);
-	debugfs_remove(trace->reset_consumed_file);
-	debugfs_remove(trace->nr_sub_file);
-	debugfs_remove(trace->sub_size_file);
-	remove_tree(trace);
-}
-
-/*
- * Setup controls for tracing.
- */
-static struct trace_info *setup_controls(const char *root,
-					 const char *name, u32 flags)
-{
-	struct trace_info *trace;
-	long ret;
-
-	trace = kzalloc(sizeof(*trace), GFP_KERNEL);
-	if (!trace) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	trace->dir = create_tree(trace, root, name);
-	if (IS_ERR(trace->dir)) {
-		ret = PTR_ERR(trace->dir);
-		trace->dir = NULL;
-		goto err;
-	}
-
-	trace->state_file = debugfs_create_file("state", 0444, trace->dir,
-						 trace, &state_fops);
-	if (IS_ERR(trace->state_file)) {
-		ret = PTR_ERR(trace->state_file);
-		trace->state_file = NULL;
-		goto err;
-	}
-
-	if (!(flags & TRACE_FLIGHT_CHANNEL)) {
-		trace->dropped_file = debugfs_create_file("dropped", 0444,
-							  trace->dir, trace,
-							  &dropped_fops);
-		if (IS_ERR(trace->dropped_file)) {
-			ret = PTR_ERR(trace->dropped_file);
-			trace->dropped_file = NULL;
-			goto err;
-		}
-	}
-
-	if (flags & TRACE_FLIGHT_CHANNEL) {
-		trace->reset_consumed_file = debugfs_create_file("rewind", 0444,
-							trace->dir, trace,
-							&reset_consumed_fops);
-		if (IS_ERR(trace->reset_consumed_file)) {
-			ret = PTR_ERR(trace->reset_consumed_file);
-			trace->reset_consumed_file = NULL;
-			goto err;
-		}
-	}
-
-	trace->nr_sub_file = debugfs_create_file("nr_sub", 0444,
-						 trace->dir, trace,
-						 &nr_sub_fops);
-	if (IS_ERR(trace->nr_sub_file)) {
-		ret = PTR_ERR(trace->nr_sub_file);
-		trace->nr_sub_file = NULL;
-		goto err;
-	}
-
-	trace->sub_size_file = debugfs_create_file("sub_size", 0444,
-						   trace->dir, trace,
-						   &sub_size_fops);
-	if (IS_ERR(trace->sub_size_file)) {
-		ret = PTR_ERR(trace->sub_size_file);
-		trace->sub_size_file = NULL;
-		goto err;
-	}
-
-	return trace;
-err:
-	if (trace) {
-		remove_controls(trace);
-		kfree(trace);
-	}
-
-	return ERR_PTR(ret);
-}
-
-static int trace_setup_channel(struct trace_info *trace, u32 buf_size,
-				u32 buf_nr, u32 flags)
-{
-	if (!buf_size || !buf_nr)
-		return -EINVAL;
-
-	if (flags & TRACE_GLOBAL_CHANNEL)
-		trace->rchan = relay_open("trace", trace->dir, buf_size,
-					  buf_nr, &relay_callbacks_global,
-					  trace);
-	else
-		trace->rchan = relay_open("trace", trace->dir, buf_size,
-					  buf_nr, &relay_callbacks, trace);
-
-	if (!trace->rchan)
-		return -ENOMEM;
-
-	trace->flags = flags;
-	trace->state = TRACE_SETUP;
-
-	return 0;
-}
-
-/**
- *	trace_setup - create a new trace trace handle
- *	@root: The root directory name to place trace directories.
- *	@name: Trace directory name, created in @root
- *	@buf_size: size of the relay sub-buffers
- *	@buf_nr: number of relay sub-buffers
- *	@flags: Option selection (see trace channel flags definitions)
- *
- *	returns a trace_info handle or NULL, if setup failed.
- *
- *	The @root is created (if needed) in the root of the debugfs.
- *	The default values when flags=0 are: use per-CPU buffering,
- *	use non-overwrite mode. See Documentation/trace.txt for details.
- */
-struct trace_info *trace_setup(const char *root, const char *name,
-			       u32 buf_size, u32 buf_nr, u32 flags)
-{
-	struct trace_info *trace;
-
-	trace = setup_controls(root, name, flags);
-	if (IS_ERR(trace))
-		return trace;
-
-	trace->buf_size = buf_size;
-	trace->buf_nr = buf_nr;
-	trace->flags = flags;
-	mutex_init(&trace->state_mutex);
-	trace->state = TRACE_SETUP;
-
-	return trace;
-}
-EXPORT_SYMBOL_GPL(trace_setup);
-
-/**
- *	trace_start - start tracing
- *	@trace: trace handle to start.
- *
- *	returns 0 if successful.
- */
-int trace_start(struct trace_info *trace)
-{
-	/*
-	 * For starting a trace, we can transition from a setup or stopped
-	 * trace.
-	 */
-	if (trace->state == TRACE_RUNNING)
-		return -EINVAL;
-
-	mutex_lock(&trace->state_mutex);
-	if (trace->state == TRACE_SETUP) {
-		int ret;
-
-		ret = trace_setup_channel(trace, trace->buf_size,
-					  trace->buf_nr, trace->flags);
-		if (ret) {
-			mutex_unlock(&trace->state_mutex);
-			return ret;
-		}
-	}
-
-	trace->state = TRACE_RUNNING;
-	mutex_unlock(&trace->state_mutex);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(trace_start);
-
-/**
- *	trace_stop - stop tracing
- *	@trace: trace handle to stop.
- *
- */
-int trace_stop(struct trace_info *trace)
-{
-	int ret = -EINVAL;
-
-	/*
-	 * For stopping a trace, the state must be running
-	 */
-	mutex_lock(&trace->state_mutex);
-	if (trace->state == TRACE_RUNNING) {
-		trace->state = TRACE_STOPPED;
-		/*
-		 * wait for all cpus to see the change in
-		 * state before continuing
-		 */
-		synchronize_sched();
-		relay_flush(trace->rchan);
-		ret = 0;
-	}
-	mutex_unlock(&trace->state_mutex);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(trace_stop);
-
-static void trace_cleanup_channel(struct trace_info *trace)
-{
-	trace_stop(trace);
-	relay_close(trace->rchan);
-	trace->rchan = NULL;
-}
-
-/**
- *	trace_cleanup - destroys the trace channel, control files and dir
- *	@trace: trace handle to cleanup
- */
-void trace_cleanup(struct trace_info *trace)
-{
-	trace_cleanup_channel(trace);
-	remove_controls(trace);
-	kfree(trace);
-}
-EXPORT_SYMBOL_GPL(trace_cleanup);
diff -puN samples/Kconfig~rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements samples/Kconfig
--- a/samples/Kconfig~rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements
+++ a/samples/Kconfig
@@ -39,11 +39,11 @@ config SAMPLE_KRETPROBES
 	default m
 	depends on SAMPLE_KPROBES && KRETPROBES
 
-config SAMPLE_TRACE
-	tristate "Build trace example -- loadable modules only"
-	depends on TRACE && KPROBES && m
+config SAMPLE_RELAY
+	tristate "Build relay debugfs example -- loadable modules only"
+	depends on RELAY && KPROBES && m
 	help
-	  This builds a trace example module.
+	  This builds a relay debugfs example module.
 
 endif # SAMPLES
 
diff -puN samples/Makefile~rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements samples/Makefile
--- a/samples/Makefile~rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements
+++ a/samples/Makefile
@@ -1,3 +1,3 @@
 # Makefile for Linux samples code
 
-obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ tracepoints/ trace/
+obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ tracepoints/ trace/ relay/
diff -puN /dev/null samples/relay/Makefile
--- /dev/null
+++ a/samples/relay/Makefile
@@ -0,0 +1,4 @@
+# builds the trace example kernel modules;
+# then to use (as root):  insmod <fork_trace.ko>
+
+obj-$(CONFIG_SAMPLE_RELAY) := fork_trace.o fork_new_trace.o
diff -puN /dev/null samples/relay/fork_trace.c
--- /dev/null
+++ a/samples/relay/fork_trace.c
@@ -0,0 +1,132 @@
+/*
+ * An example of using 'relay debugfs' in a kprobes module
+ *
+ * Copyright (C) 2007 IBM Inc.
+ *
+ * David Wilder <dwilder@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * -------
+ * This module creates a 'relay debugfs' channel and places a kprobe
+ * on the function do_fork(). The value of current->pid is written to
+ * the 'relay debugfs' channel each time the kprobe is hit..
+ *
+ * How to run the example:
+ * $ mount -t debugfs /debug
+ * $ insmod fork_trace.ko
+ *
+ * To view the data produced by the module:
+ * $ cat /debug/relay_debugfs_example/do_fork/trace0
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/kprobes.h>
+#include <linux/relay_debugfs.h>
+
+#define USE_GLOBAL_BUFFERS 1
+#define USE_FLIGHT 1
+
+#define PROBE_POINT "do_fork"
+
+static struct kprobe kp;
+static struct relay_info *kprobes_relay;
+
+#ifdef USE_GLOBAL_BUFFERS
+static DEFINE_SPINLOCK(relay_debugfs_lock);
+#endif
+
+/*
+ * Send formatted trace data to 'relay debugfs' channel.
+ * @note Preemption must be disabled to use this.
+ */
+static void relay_debugfs_printf(struct relay_info *relay, const char *format, ...)
+{
+	va_list ap, aq;
+	char *record;
+	unsigned long flags;
+	int len;
+
+	if (!relay)
+		return;
+
+#ifdef USE_GLOBAL_BUFFERS
+	spin_lock_irqsave(&relay_debugfs_lock, flags);
+#endif
+	if (relay_running(relay)) {
+		va_start(ap, format);
+		va_copy(aq, ap);
+		len = vsnprintf(NULL, 0, format, aq);
+		va_end(aq);
+		record = relay_reserve(relay->rchan, ++len);
+		if (record)
+			vsnprintf(record, len, format, ap);
+		va_end(ap);
+	}
+#ifdef USE_GLOBAL_BUFFERS
+	spin_unlock_irqrestore(&relay_debugfs_lock, flags);
+#endif
+}
+
+static int handler_pre(struct kprobe *p, struct pt_regs *regs)
+{
+	rcu_read_lock();
+	relay_debugfs_printf(kprobes_relay, "%d\n", current->pid);
+	rcu_read_unlock();
+	return 0;
+}
+
+int init_module(void)
+{
+	int ret;
+	u32 flags = 0;
+
+#ifdef USE_GLOBAL_BUFFERS
+	flags |= RELAY_GLOBAL_CHANNEL;
+#endif
+
+#ifdef USE_FLIGHT
+	flags |= RELAY_FLIGHT_CHANNEL;
+#endif
+
+	/* setup the relay */
+	kprobes_relay = relay_setup("relay_example", PROBE_POINT,
+				     1024, 8, flags);
+	if (IS_ERR(kprobes_relay))
+		return PTR_ERR(kprobes_relay);
+
+	relay_start(kprobes_relay);
+
+	/* setup the kprobe */
+	kp.pre_handler = handler_pre;
+	kp.post_handler = NULL;
+	kp.fault_handler = NULL;
+	kp.symbol_name = PROBE_POINT;
+	ret = register_kprobe(&kp);
+	if (ret) {
+		printk(KERN_ERR "fork_trace: register_kprobe failed\n");
+		return ret;
+	}
+	return 0;
+}
+
+void cleanup_module(void)
+{
+	unregister_kprobe(&kp);
+	relay_stop(kprobes_relay);
+	relay_cleanup(kprobes_relay);
+}
+MODULE_LICENSE("GPL");
diff -puN samples/trace/Makefile~rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements /dev/null
--- a/samples/trace/Makefile
+++ /dev/null
@@ -1,4 +0,0 @@
-# builds the trace example kernel modules;
-# then to use (as root):  insmod <fork_trace.ko>
-
-obj-$(CONFIG_SAMPLE_TRACE) := fork_trace.o
diff -puN /dev/null samples/trace/fork_new_trace.c
--- /dev/null
+++ a/samples/trace/fork_new_trace.c
@@ -0,0 +1,99 @@
+/*
+ * An example of using trace in a kprobes module
+ *
+ * Copyright (C) 2008 IBM Inc.
+ *
+ * K.Prasad <prasad@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * -------
+ * This module creates a trace channel and places a kprobe
+ * on the function do_fork(). The value of current->pid is written to
+ * the trace channel each time the kprobe is hit..
+ *
+ * How to run the example:
+ * $ mount -t debugfs /debug
+ * $ insmod fork_new_trace.ko
+ *
+ * To view the data produced by the module:
+ * $ cat /debug/relay_example/do_fork/trace0
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/kprobes.h>
+#include <linux/relay_debugfs.h>
+
+#define SAMPLE_PARENT_DIR "relay_new_example"
+#define PROBE_POINT "do_fork"
+
+static struct kprobe kp;
+static struct relay_printk_data *tpk;
+
+static int handler_pre(struct kprobe *p, struct pt_regs *regs)
+{
+	relay_printk(tpk, "%d\n", current->pid);
+	return 0;
+}
+
+int init_module(void)
+{
+	int ret = 0;
+	int len_parent_dir, len_dir;
+
+	/* setup the kprobe */
+	kp.pre_handler = handler_pre;
+	kp.post_handler = NULL;
+	kp.fault_handler = NULL;
+	kp.symbol_name = PROBE_POINT;
+	ret = register_kprobe(&kp);
+	if (ret) {
+		printk(KERN_ERR "fork_trace: register_kprobe failed\n");
+		return ret;
+	}
+
+	len_parent_dir = strlen(SAMPLE_PARENT_DIR) + 1;
+	/* Initialising len_dir to the larger of the two dir names */
+	len_dir = strlen("kprobe_struct") + 1;
+
+	tpk = kzalloc(sizeof(*tpk), GFP_KERNEL);
+	if (!tpk)
+		ret = 1;
+
+	tpk->parent_dir = SAMPLE_PARENT_DIR;
+
+	/* Let's do a binary dump of struct kprobe using relay_dump */
+	tpk->dir = "kprobes_struct";
+	tpk->flags = TRACE_GLOBAL_CHANNEL;
+	relay_dump(tpk, &kp, sizeof(kp));
+
+	/* Now change the directory to collect fork pid data */
+	tpk->dir = PROBE_POINT;
+
+	if (ret)
+		printk(KERN_ERR "Unable to find required free memory. "
+				"Trace new sample module loading aborted");
+	return ret;
+}
+
+void cleanup_module(void)
+{
+	unregister_kprobe(&kp);
+
+	/* Just a single cleanup call passing the parent dir string */
+	relay_cleanup_all(SAMPLE_PARENT_DIR);
+}
+MODULE_LICENSE("GPL");
diff -puN samples/trace/fork_trace.c~rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements /dev/null
--- a/samples/trace/fork_trace.c
+++ /dev/null
@@ -1,132 +0,0 @@
-/*
- * An example of using trace in a kprobes module
- *
- * Copyright (C) 2007 IBM Inc.
- *
- * David Wilder <dwilder@us.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
- * -------
- * This module creates a trace channel and places a kprobe
- * on the function do_fork(). The value of current->pid is written to
- * the trace channel each time the kprobe is hit..
- *
- * How to run the example:
- * $ mount -t debugfs /debug
- * $ insmod fork_trace.ko
- *
- * To view the data produced by the module:
- * $ cat /debug/trace_example/do_fork/trace0
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/kprobes.h>
-#include <linux/trace.h>
-
-#define USE_GLOBAL_BUFFERS 1
-#define USE_FLIGHT 1
-
-#define PROBE_POINT "do_fork"
-
-static struct kprobe kp;
-static struct trace_info *kprobes_trace;
-
-#ifdef USE_GLOBAL_BUFFERS
-static DEFINE_SPINLOCK(trace_lock);
-#endif
-
-/*
- * Send formatted trace data to trace channel.
- * @note Preemption must be disabled to use this.
- */
-static void trace_printf(struct trace_info *trace, const char *format, ...)
-{
-	va_list ap, aq;
-	char *record;
-	unsigned long flags;
-	int len;
-
-	if (!trace)
-		return;
-
-#ifdef USE_GLOBAL_BUFFERS
-	spin_lock_irqsave(&trace_lock, flags);
-#endif
-	if (trace_running(trace)) {
-		va_start(ap, format);
-		va_copy(aq, ap);
-		len = vsnprintf(NULL, 0, format, aq);
-		va_end(aq);
-		record = relay_reserve(trace->rchan, ++len);
-		if (record)
-			vsnprintf(record, len, format, ap);
-		va_end(ap);
-	}
-#ifdef USE_GLOBAL_BUFFERS
-	spin_unlock_irqrestore(&trace_lock, flags);
-#endif
-}
-
-static int handler_pre(struct kprobe *p, struct pt_regs *regs)
-{
-	rcu_read_lock();
-	trace_printf(kprobes_trace, "%d\n", current->pid);
-	rcu_read_unlock();
-	return 0;
-}
-
-int init_module(void)
-{
-	int ret;
-	u32 flags = 0;
-
-#ifdef USE_GLOBAL_BUFFERS
-	flags |= TRACE_GLOBAL_CHANNEL;
-#endif
-
-#ifdef USE_FLIGHT
-	flags |= TRACE_FLIGHT_CHANNEL;
-#endif
-
-	/* setup the trace */
-	kprobes_trace = trace_setup("trace_example", PROBE_POINT,
-				     1024, 8, flags);
-	if (IS_ERR(kprobes_trace))
-		return PTR_ERR(kprobes_trace);
-
-	trace_start(kprobes_trace);
-
-	/* setup the kprobe */
-	kp.pre_handler = handler_pre;
-	kp.post_handler = NULL;
-	kp.fault_handler = NULL;
-	kp.symbol_name = PROBE_POINT;
-	ret = register_kprobe(&kp);
-	if (ret) {
-		printk(KERN_ERR "fork_trace: register_kprobe failed\n");
-		return ret;
-	}
-	return 0;
-}
