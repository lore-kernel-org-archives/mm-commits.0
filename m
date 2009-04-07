From: akpm@linux-foundation.org
Subject: - trace-code-and-documentation.patch removed from -mm tree
Date: Tue, 07 Apr 2009 16:52:38 -0700
Message-ID: <200904072352.n37Nqc9j004359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752211AbZDGXzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 19:55:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwilder@us.ibm.com, hunt@redhat.com, zanussi@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Trace code and documentation
has been removed from the -mm tree.  Its filename was
     trace-code-and-documentation.patch

This patch was dropped because I guess I won't be merging these in their present form

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Trace code and documentation
From: "David J. Wilder" <dwilder@us.ibm.com>

Provides tracing primitives

Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
Signed-off-by: Martin Hunt <hunt@redhat.com>
Signed-off-by: David Wilder <dwilder@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace.txt |  210 ++++++++++++++
 include/linux/trace.h   |   99 ++++++
 lib/Kconfig             |    9 
 lib/Makefile            |    2 
 lib/trace.c             |  563 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 883 insertions(+)

diff -puN /dev/null Documentation/trace.txt
--- /dev/null
+++ a/Documentation/trace.txt
@@ -0,0 +1,210 @@
+Trace Setup and Control
+=======================
+In the kernel, the trace interface provides a simple mechanism for
+starting and managing data channels (traces) to user space.  The
+trace interface builds on the relay interface.  For a complete
+description of the relay interface, please see:
+Documentation/filesystems/relay.txt.
+
+The trace interface provides a single layer in a complete tracing
+application.  Trace provides a kernel API that can be used for the setup
+and control of tracing channels.  User of trace must provide a data layer
+responsible for formatting and writing data into the trace channels.
+
+A layered approach to tracing
+=============================
+A complete kernel tracing application consists of a data provider and
+a data consumer.  Both provider and consumer contain three layers; each
+layer works in tandem with the corresponding layer in the opposite side.
+The layers are represented in the following diagram.
+
+Provider Data layer
+	Formats raw trace data and provides data-related service.
+	For example, adding timestamps used by consumer to sort data.
+
+Provider Control layer
+	Provided by the trace interface, this layer creates trace channels
+	and informs the data layer and consumer of the current state
+	of the trace channels.
+
+Provider Buffering layer
+	Provided by relay. This layer buffers data in the
+	kernel for consumption by the consumer's buffer
+	layer.
+
+Provider (in-kernel facility)
+-----------------------------------------------------------------------------
+Consumer (user application)
+
+
+Consumer Buffer layer
+	Reads/consumes data from the provider's data buffers.
+
+Consumer Control layer
+	Communicates to the provider's control layer to control the state
+	of the trace channels.
+
+Consumer Data layer
+	Sorts and formats data as provided by the provider's data layer.
+
+The provider is coded as a kernel facility.  The consumer is coded as
+a user application.
+
+
+Trace - Features
+================
+Trace exploits services and features provided by relay.  These features
+are:
+- The creation and destruction of relay channels.
+- Buffer management.  Overwrite or non-overwrite modes can be selected
+  as well as global or per-CPU buffering.
+
+Overwrite mode can be called "flight recorder mode".  Flight recorder
+mode is selected by setting the TRACE_FLIGHT_CHANNEL flag when
+creating trace channels.  In flight mode when a tracing buffer is
+full, the oldest records in the buffer will be discarded to make room
+as new records arrive. In the default non-overwrite mode, new records
+may be written only if the buffer has room.  In either case, to
+prevent data loss, a user space reader must keep the buffers
+drained. Trace provides a means to detect the number of records that
+have been dropped due to a buffer-full condition (non-overwrite mode
+only).
+
+When per-CPU buffers are used, relay creates one debugfs file for each
+running CPU.  The user-space consumer of the data is responsible for
+reading the per-CPU buffers and collating the records presumably using
+a time stamp or sequence number included in the trace records.  The
+use of global buffers eliminates this extra work of sequencing
+records; however the provider's data layer must hold a lock when
+writing records.  The lock prevents writers running on different CPUs
+from overwriting each other's data.  However, buffering may be slower
+because writes to the buffer are serialized. Global buffering is
+selected by setting the TRACE_GLOBAL_CHANNEL flag when creating trace
+channels.
+
+Trace User Interface
+===================
+When a trace channel is created and started, the following
+directories and files are created in the root of the mounted debugfs.
+
+/debug (root of the debugfs)
+	/<trace-root-dir>
+		/<trace-name>
+			trace[0...N-1]     Per-CPU trace data, one
+					   file per CPU.
+
+			state		   Start or stop tracing by
+					   by writing the strings
+					   "start" or "stop" to this
+					   file. Read the file to get the
+					   current state.
+
+			dropped		   The number of records dropped
+					   due to a full-buffer condition,
+					   for non-TRACE_FLIGHT_CHANNELs
+					   only.
+
+			rewind		   Trigger a rewind by writing
+					   to this file.  i.e. start
+					   next read at the beginning
+					   again. Only available for
+					   TRACE_FLIGHT_CHANNELS.
+
+
+			nr_sub		   Number of sub-buffers
+					   in the channel.
+
+			sub_size	   Size of sub-buffers in
+					   the channel.
+
+Trace data is gathered from the trace[0...N-1] files using one of the
+available interfaces provided by relay.
+
+When using the read(2) interface, as data is read it is marked as
+consumed by the relay subsystem.  Therefore, subsequent reads will
+only return unconsumed data.
+
+Trace Kernel API
+===============
+An overview of the trace Kernel API is now given. More details of the
+API can be found in linux/trace.h.
+
+The steps a kernel data provider takes to utilize the trace interface are:
+1) Set up a trace channel - trace_setup()
+2) Start the trace channel - trace_start()
+3) Write one or more trace records into the channel (using the relay API).
+
+   Important: When writing a trace record the provider must insure that
+   preemption is disabled and that trace state is  set to "running". A
+   typical function used to write records into a trace channel should
+   follow the following semantics:
+
+	rcu_read_lock();	    // disables preemption
+	if (trace_running(trace)){
+		relay_write(....); // use any available relay data
+				   // function
+	}
+	rcu_read_unlock();	   // enables preemption
+
+4) Stop and start tracing as desired - trace_start()/trace_stop()
+5) Destroy the trace channel and underlying relay channel -
+   trace_cleanup().
+
+Kernel Configuration
+--------------------
+To use trace, configure your kernel with CONFIG_TRACE=y. Trace depends on
+both CONFIG_RELAY and CONFIG_DEBUG_FS, these will be automatically configured
+when CONFIG_TRACE is selected (if not already configured).
+
+Using the User Interface
+------------------------
+Reading trace data and controlling the trace can be done using commands such
+as cat, echo and sort.  However, If you are logging binary trace data a
+custom application may be required to read and process the trace data.
+This section shows several examples of reading trace data and controling
+the trace.  All examples assume that the "trace" directory is your current
+working directory.
+
+Viewing the current trace state:
+$cat state
+
+Turning the trace on and off:
+$echo start > state
+$echo stop > state
+
+Reading data when using global buffers (USE_GLOBAL_BUFFERS):
+$echo stop > state
+$cat  trace0
+$echo start > state
+
+Reading data when using per-cpu buffers:
+When using per-cpu buffers the tracer should add a time stamp or sequence
+number to each trace records.  This is used by the consumer to sort the trace
+records into chronological order.  In the following example the tracer has
+placed a time stamp at the front of each the record.  The format of a record
+is now shown.
+
+:<time stamp>:<field 1>:<field 2>:..........
+
+Collect the data from the per-cpu trace buffers, sorting chronologically:
+$sort --field-separator=: --key=2.1 trace*
+
+Verify that no data was lost by examining the dropped file:
+$ cat  dropped
+
+To collect a larger amount of data the trace buffers can be read
+continuously using something like:
+
+while [ 1 ] ; do
+	sort --field-separator=: --key=2.1   trace*
+done
+
+
+Credits
+=======
+Trace is adapted from blktrace authored by Jens Axboe (axboe@kernel.dk).
+
+Major contributions were made by:
+Tom Zanussi <zanussi@us.ibm.com>
+Martin Hunt <hunt@redhat.com>
+David Wilder <dwilder@us.ibm.com>
diff -puN /dev/null include/linux/trace.h
--- /dev/null
+++ a/include/linux/trace.h
@@ -0,0 +1,99 @@
+/*
+ * TRACE defines and function prototypes
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
+#ifndef _LINUX_TRACE_H
+#define _LINUX_TRACE_H
+
+#include <linux/relay.h>
+
+/*
+ * TRACE channel flags
+ */
+#define TRACE_GLOBAL_CHANNEL	0x01
+#define TRACE_FLIGHT_CHANNEL	0x02
+#define TRACE_DISABLE_STATE	0x04
+
+enum trace_state {
+	TRACE_SETUP,
+	TRACE_RUNNING,
+	TRACE_STOPPED,
+};
+
+#define TRACE_ROOT_NAME_SIZE	64	/* Max root dir identifier */
+#define TRACE_NAME_SIZE		64	/* Max trace identifier */
+
+/*
+ * Global root user information
+ */
+struct trace_root {
+	struct list_head list;
+	char name[TRACE_ROOT_NAME_SIZE];
+	struct dentry *root;
+	unsigned int users;
+};
+
+/*
+ * Client information
+ */
+struct trace_info {
+	struct mutex state_mutex; /* Used to protect state changes */
+	enum trace_state state;
+	struct dentry *state_file;
+	struct rchan *rchan;
+	struct dentry *dir;
+	struct dentry *dropped_file;
+	struct dentry *reset_consumed_file;
+	struct dentry *nr_sub_file;
+	struct dentry *sub_size_file;
+	atomic_t dropped;
+	struct trace_root *root;
+	void *private_data;
+	unsigned int flags;
+	unsigned int buf_size;
+	unsigned int buf_nr;
+};
+
+#ifdef CONFIG_TRACE
+static inline int trace_running(struct trace_info *trace)
+{
+	return trace->state == TRACE_RUNNING;
+}
+struct trace_info *trace_setup(const char *root, const char *name,
+			       u32 buf_size, u32 buf_nr, u32 flags);
+int trace_start(struct trace_info *trace);
+int trace_stop(struct trace_info *trace);
+void trace_cleanup(struct trace_info *trace);
+#else
+static inline struct trace_info *trace_setup(const char *root,
+					     const char *name, u32 buf_size,
+					     u32 buf_nr, u32 flags)
+{
+	return NULL;
+}
+static inline int trace_start(struct trace_info *trace) { return -EINVAL; }
+static inline int trace_stop(struct trace_info *trace) { return -EINVAL; }
+static inline int trace_running(struct trace_info *trace) { return 0; }
+static inline void trace_cleanup(struct trace_info *trace) {}
+#endif
+
+#endif
diff -puN lib/Kconfig~trace-code-and-documentation lib/Kconfig
--- a/lib/Kconfig~trace-code-and-documentation
+++ a/lib/Kconfig
@@ -191,4 +191,13 @@ config DISABLE_OBSOLETE_CPUMASK_FUNCTION
 config NLATTR
 	bool
 
+config TRACE
+	bool "Trace setup and control"
+	depends on RELAY && DEBUG_FS
+	help
+	  This option provides support for the setup, teardown and control
+	  of tracing channels from kernel code.  It also provides trace
+	  information and control to userspace via a set of debugfs control
+	  files.  If unsure, say N.
+
 endmenu
diff -puN lib/Makefile~trace-code-and-documentation lib/Makefile
--- a/lib/Makefile~trace-code-and-documentation
+++ a/lib/Makefile
@@ -92,6 +92,8 @@ obj-$(CONFIG_NLATTR) += nlattr.o
 
 obj-$(CONFIG_DMA_API_DEBUG) += dma-debug.o
 
+obj-$(CONFIG_TRACE) += trace.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff -puN /dev/null lib/trace.c
--- /dev/null
+++ a/lib/trace.c
@@ -0,0 +1,563 @@
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
+#include <linux/trace.h>
+
+static LIST_HEAD(trace_roots);
+static DEFINE_MUTEX(trace_mutex);
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
+	struct trace_info *trace = filp->private_data;
+	char *buf = "trace not started\n";
+
+	if (trace->state == TRACE_STOPPED)
+		buf = "stopped\n";
+	else if (trace->state == TRACE_RUNNING)
+		buf = "running\n";
+	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+}
+
+static ssize_t state_write(struct file *filp, const char __user *buffer,
+			   size_t count, loff_t *ppos)
+{
+	struct trace_info *trace = filp->private_data;
+	char buf[16];
+	int ret;
+
+	if (trace->flags & TRACE_DISABLE_STATE)
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
+		ret = trace_start(trace);
+		if (ret)
+			return ret;
+	} else if (strcmp(buf, "stop") == 0)
+		trace_stop(trace);
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
+static void remove_root(struct trace_info *trace)
+{
+	if (trace->root->root && simple_empty(trace->root->root)) {
+		debugfs_remove(trace->root->root);
+		list_del(&trace->root->list);
+		kfree(trace->root);
+		trace->root = NULL;
+	}
+}
+
+static void remove_tree(struct trace_info *trace)
+{
+	mutex_lock(&trace_mutex);
+	debugfs_remove(trace->dir);
+
+	if (trace->root) {
+		if (--trace->root->users == 0)
+			remove_root(trace);
+	}
+
+	mutex_unlock(&trace_mutex);
+}
+
+/*
+ * Creates the trace_root if it's not found.
+ */
+static struct trace_root *lookup_root(const char *root)
+{
+	struct list_head *pos;
+	struct trace_root *r;
+
+	list_for_each(pos, &trace_roots) {
+		r = list_entry(pos, struct trace_root, list);
+		if (!strcmp(r->name, root))
+			return r;
+	}
+
+	r = kzalloc(sizeof(struct trace_root), GFP_KERNEL);
+	if (!r)
+		return ERR_PTR(-ENOMEM);
+
+	strlcpy(r->name, root, sizeof(r->name));
+
+	r->root = debugfs_create_dir(root, NULL);
+	if (IS_ERR(r->root))
+		r->root = NULL;
+	else
+		list_add(&r->list, &trace_roots);
+
+	return r;
+}
+
+static struct dentry *create_tree(struct trace_info *trace, const char *root,
+				  const char *name)
+{
+	struct dentry *dir = NULL;
+
+	if (root == NULL || name == NULL)
+		return ERR_PTR(-EINVAL);
+
+	mutex_lock(&trace_mutex);
+
+	trace->root = lookup_root(root);
+	if (IS_ERR(trace->root)) {
+		trace->root = NULL;
+		goto err;
+	}
+
+	dir = debugfs_create_dir(name, trace->root->root);
+	if (IS_ERR(dir))
+		remove_root(trace);
+	else
+		trace->root->users++;
+
+err:
+	mutex_unlock(&trace_mutex);
+	return dir;
+}
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
+	struct trace_info *trace = filp->private_data;
+	char buf[16];
+
+	snprintf(buf, sizeof(buf), "%u\n", atomic_read(&trace->dropped));
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
+	struct trace_info *trace = filp->private_data;
+
+	mutex_lock(&trace->state_mutex);
+	switch (trace->state) {
+	case TRACE_RUNNING:
+		trace->state = TRACE_STOPPED;
+		synchronize_rcu();
+		relay_flush(trace->rchan);
+		relay_reset_consumed(trace->rchan);
+		trace->state = TRACE_RUNNING;
+		break;
+	case TRACE_STOPPED:
+		relay_reset_consumed(trace->rchan);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	mutex_unlock(&trace->state_mutex);
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
+	struct trace_info *trace = filp->private_data;
+	char buf[32];
+
+	snprintf(buf, sizeof(buf), "%zu\n", trace->rchan->subbuf_size);
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
+	struct trace_info *trace = filp->private_data;
+	char buf[32];
+
+	snprintf(buf, sizeof(buf), "%zu\n", trace->rchan->n_subbufs);
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
+	struct trace_info *trace = buf->chan->private_data;
+
+	if (trace->flags & TRACE_FLIGHT_CHANNEL)
+		return 1;
+
+	if (!relay_buf_full(buf))
+		return 1;
+
+	atomic_inc(&trace->dropped);
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
+static void remove_controls(struct trace_info *trace)
+{
+	debugfs_remove(trace->state_file);
+	debugfs_remove(trace->dropped_file);
+	debugfs_remove(trace->reset_consumed_file);
+	debugfs_remove(trace->nr_sub_file);
+	debugfs_remove(trace->sub_size_file);
+	remove_tree(trace);
+}
+
+/*
+ * Setup controls for tracing.
+ */
+static struct trace_info *setup_controls(const char *root,
+					 const char *name, u32 flags)
+{
+	struct trace_info *trace;
+	long ret;
+
+	trace = kzalloc(sizeof(*trace), GFP_KERNEL);
+	if (!trace) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	trace->dir = create_tree(trace, root, name);
+	if (IS_ERR(trace->dir)) {
+		ret = PTR_ERR(trace->dir);
+		trace->dir = NULL;
+		goto err;
+	}
+
+	trace->state_file = debugfs_create_file("state", 0444, trace->dir,
+						 trace, &state_fops);
+	if (IS_ERR(trace->state_file)) {
+		ret = PTR_ERR(trace->state_file);
+		trace->state_file = NULL;
+		goto err;
+	}
+
+	if (!(flags & TRACE_FLIGHT_CHANNEL)) {
+		trace->dropped_file = debugfs_create_file("dropped", 0444,
+							  trace->dir, trace,
+							  &dropped_fops);
+		if (IS_ERR(trace->dropped_file)) {
+			ret = PTR_ERR(trace->dropped_file);
+			trace->dropped_file = NULL;
+			goto err;
+		}
+	}
+
+	if (flags & TRACE_FLIGHT_CHANNEL) {
+		trace->reset_consumed_file = debugfs_create_file("rewind", 0444,
+							trace->dir, trace,
+							&reset_consumed_fops);
+		if (IS_ERR(trace->reset_consumed_file)) {
+			ret = PTR_ERR(trace->reset_consumed_file);
+			trace->reset_consumed_file = NULL;
+			goto err;
+		}
+	}
+
+	trace->nr_sub_file = debugfs_create_file("nr_sub", 0444,
+						 trace->dir, trace,
+						 &nr_sub_fops);
+	if (IS_ERR(trace->nr_sub_file)) {
+		ret = PTR_ERR(trace->nr_sub_file);
+		trace->nr_sub_file = NULL;
+		goto err;
+	}
+
+	trace->sub_size_file = debugfs_create_file("sub_size", 0444,
+						   trace->dir, trace,
+						   &sub_size_fops);
+	if (IS_ERR(trace->sub_size_file)) {
+		ret = PTR_ERR(trace->sub_size_file);
+		trace->sub_size_file = NULL;
+		goto err;
+	}
+
+	return trace;
+err:
+	if (trace) {
+		remove_controls(trace);
+		kfree(trace);
+	}
+
+	return ERR_PTR(ret);
+}
+
+static int trace_setup_channel(struct trace_info *trace, u32 buf_size,
+				u32 buf_nr, u32 flags)
+{
+	if (!buf_size || !buf_nr)
+		return -EINVAL;
+
+	if (flags & TRACE_GLOBAL_CHANNEL)
+		trace->rchan = relay_open("trace", trace->dir, buf_size,
+					  buf_nr, &relay_callbacks_global,
+					  trace);
+	else
+		trace->rchan = relay_open("trace", trace->dir, buf_size,
+					  buf_nr, &relay_callbacks, trace);
+
+	if (!trace->rchan)
+		return -ENOMEM;
+
+	trace->flags = flags;
+	trace->state = TRACE_SETUP;
+
+	return 0;
+}
+
+/**
+ *	trace_setup - create a new trace trace handle
+ *	@root: The root directory name to place trace directories.
+ *	@name: Trace directory name, created in @root
+ *	@buf_size: size of the relay sub-buffers
+ *	@buf_nr: number of relay sub-buffers
+ *	@flags: Option selection (see trace channel flags definitions)
+ *
+ *	returns a trace_info handle or NULL, if setup failed.
+ *
+ *	The @root is created (if needed) in the root of the debugfs.
+ *	The default values when flags=0 are: use per-CPU buffering,
+ *	use non-overwrite mode. See Documentation/trace.txt for details.
+ */
+struct trace_info *trace_setup(const char *root, const char *name,
+			       u32 buf_size, u32 buf_nr, u32 flags)
+{
+	struct trace_info *trace;
+
+	trace = setup_controls(root, name, flags);
+	if (IS_ERR(trace))
+		return trace;
+
+	trace->buf_size = buf_size;
+	trace->buf_nr = buf_nr;
+	trace->flags = flags;
+	mutex_init(&trace->state_mutex);
+	trace->state = TRACE_SETUP;
+
+	return trace;
+}
+EXPORT_SYMBOL_GPL(trace_setup);
+
+/**
+ *	trace_start - start tracing
+ *	@trace: trace handle to start.
+ *
+ *	returns 0 if successful.
+ */
+int trace_start(struct trace_info *trace)
+{
+	/*
+	 * For starting a trace, we can transition from a setup or stopped
+	 * trace.
+	 */
+	if (trace->state == TRACE_RUNNING)
+		return -EINVAL;
+
+	mutex_lock(&trace->state_mutex);
+	if (trace->state == TRACE_SETUP) {
+		int ret;
+
+		ret = trace_setup_channel(trace, trace->buf_size,
+					  trace->buf_nr, trace->flags);
+		if (ret) {
+			mutex_unlock(&trace->state_mutex);
+			return ret;
+		}
+	}
+
+	trace->state = TRACE_RUNNING;
+	mutex_unlock(&trace->state_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(trace_start);
+
+/**
+ *	trace_stop - stop tracing
+ *	@trace: trace handle to stop.
+ *
+ */
+int trace_stop(struct trace_info *trace)
+{
+	int ret = -EINVAL;
+
+	/*
+	 * For stopping a trace, the state must be running
+	 */
+	mutex_lock(&trace->state_mutex);
+	if (trace->state == TRACE_RUNNING) {
+		trace->state = TRACE_STOPPED;
+		/*
+		 * wait for all cpus to see the change in
+		 * state before continuing
+		 */
+		synchronize_sched();
+		relay_flush(trace->rchan);
+		ret = 0;
+	}
+	mutex_unlock(&trace->state_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(trace_stop);
+
+static void trace_cleanup_channel(struct trace_info *trace)
+{
+	trace_stop(trace);
+	relay_close(trace->rchan);
+	trace->rchan = NULL;
+}
+
+/**
+ *	trace_cleanup - destroys the trace channel, control files and dir
+ *	@trace: trace handle to cleanup
+ */
+void trace_cleanup(struct trace_info *trace)
+{
+	trace_cleanup_channel(trace);
+	remove_controls(trace);
+	kfree(trace);
+}
+EXPORT_SYMBOL_GPL(trace_cleanup);
_

Patches currently in -mm which might be from dwilder@us.ibm.com are

trace-code-and-documentation.patch
trace-code-and-documentation-merging-documentation-tracetxt-with-documentation-filesystems-relaytxt.patch
trace-sample.patch

