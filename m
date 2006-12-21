From: akpm@osdl.org
Subject: + relay-add-cpu-hotplug-support.patch added to -mm tree
Date: Thu, 21 Dec 2006 13:24:50 -0800
Message-ID: <200612212124.kBLLOoq6005429@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42592 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423116AbWLUV2V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 16:28:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, zanussi@us.ibm.com


The patch titled
     Relay: add CPU hotplug support
has been added to the -mm tree.  Its filename is
     relay-add-cpu-hotplug-support.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Relay: add CPU hotplug support
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Mathieu originally needed to add this for tracing Xen, but it's something
that's needed for any application that can be tracing while cpus are added.

unplug isn't supported by this patch.  The thought was that at minumum a new
buffer needs to be added when a cpu comes up, but it wasn't worth the effort
to remove buffers on cpu down since they'd be freed soon anyway when the
channel was closed.

[zanussi@us.ibm.com: avoid lock_cpu_hotplug deadlock]
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Tom Zanussi <zanussi@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/filesystems/relay.txt |    9 +
 block/blktrace.c                    |    3 
 include/linux/relay.h               |    9 +
 kernel/relay.c                      |  180 ++++++++++++++++++--------
 4 files changed, 142 insertions(+), 59 deletions(-)

diff -puN Documentation/filesystems/relay.txt~relay-add-cpu-hotplug-support Documentation/filesystems/relay.txt
--- a/Documentation/filesystems/relay.txt~relay-add-cpu-hotplug-support
+++ a/Documentation/filesystems/relay.txt
@@ -157,7 +157,7 @@ TBD(curr. line MT:/API/)
   channel management functions:
 
     relay_open(base_filename, parent, subbuf_size, n_subbufs,
-               callbacks)
+               callbacks, private_data)
     relay_close(chan)
     relay_flush(chan)
     relay_reset(chan)
@@ -251,7 +251,7 @@ static struct rchan_callbacks relay_call
 
 And an example relay_open() invocation using them:
 
-  chan = relay_open("cpu", NULL, SUBBUF_SIZE, N_SUBBUFS, &relay_callbacks);
+  chan = relay_open("cpu", NULL, SUBBUF_SIZE, N_SUBBUFS, &relay_callbacks, NULL);
 
 If the create_buf_file() callback fails, or isn't defined, channel
 creation and thus relay_open() will fail.
@@ -289,6 +289,11 @@ they use the proper locking for such a b
 writes in a spinlock, or by copying a write function from relay.h and
 creating a local version that internally does the proper locking.
 
+The private_data passed into relay_open() allows clients to associate
+user-defined data with a channel, and is immediately available
+(including in create_buf_file()) via chan->private_data or
+buf->chan->private_data.
+
 Channel 'modes'
 ---------------
 
diff -puN block/blktrace.c~relay-add-cpu-hotplug-support block/blktrace.c
--- a/block/blktrace.c~relay-add-cpu-hotplug-support
+++ a/block/blktrace.c
@@ -363,10 +363,9 @@ static int blk_trace_setup(request_queue
 	if (!bt->dropped_file)
 		goto err;
 
-	bt->rchan = relay_open("trace", dir, buts.buf_size, buts.buf_nr, &blk_relay_callbacks);
+	bt->rchan = relay_open("trace", dir, buts.buf_size, buts.buf_nr, &blk_relay_callbacks, bt);
 	if (!bt->rchan)
 		goto err;
-	bt->rchan->private_data = bt;
 
 	bt->act_mask = buts.act_mask;
 	if (!bt->act_mask)
diff -puN include/linux/relay.h~relay-add-cpu-hotplug-support include/linux/relay.h
--- a/include/linux/relay.h~relay-add-cpu-hotplug-support
+++ a/include/linux/relay.h
@@ -24,7 +24,7 @@
 /*
  * Tracks changes to rchan/rchan_buf structs
  */
-#define RELAYFS_CHANNEL_VERSION		6
+#define RELAYFS_CHANNEL_VERSION		7
 
 /*
  * Per-cpu relay channel buffer
@@ -64,6 +64,10 @@ struct rchan
 	void *private_data;		/* for user-defined data */
 	size_t last_toobig;		/* tried to log event > subbuf size */
 	struct rchan_buf *buf[NR_CPUS]; /* per-cpu channel buffers */
+	int is_global;			/* One global buffer ? */
+	struct list_head list;		/* for channel list */
+	struct dentry *parent;		/* parent dentry passed to open */
+	char base_filename[NAME_MAX];	/* saved base filename */
 };
 
 /*
@@ -162,7 +166,8 @@ struct rchan *relay_open(const char *bas
 			 struct dentry *parent,
 			 size_t subbuf_size,
 			 size_t n_subbufs,
-			 struct rchan_callbacks *cb);
+			 struct rchan_callbacks *cb,
+			 void *private_data);
 extern void relay_close(struct rchan *chan);
 extern void relay_flush(struct rchan *chan);
 extern void relay_subbufs_consumed(struct rchan *chan,
diff -puN kernel/relay.c~relay-add-cpu-hotplug-support kernel/relay.c
--- a/kernel/relay.c~relay-add-cpu-hotplug-support
+++ a/kernel/relay.c
@@ -7,6 +7,8 @@
  * Copyright (C) 1999-2005 - Karim Yaghmour (karim@opersys.com)
  *
  * Moved to kernel/relay.c by Paul Mundt, 2006.
+ * November 2006 - CPU hotplug support by Mathieu Desnoyers
+ * 	(mathieu.desnoyers@polymtl.ca)
  *
  * This file is released under the GPL.
  */
@@ -18,6 +20,11 @@
 #include <linux/relay.h>
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
+#include <linux/cpu.h>
+
+/* list of open channels, for cpu hotplug */
+static DEFINE_MUTEX(relay_channels_mutex);
+static LIST_HEAD(relay_channels);
 
 /*
  * close() vm_op implementation for relay file mapping.
@@ -187,6 +194,7 @@ void relay_destroy_buf(struct rchan_buf 
 			__free_page(buf->page_array[i]);
 		kfree(buf->page_array);
 	}
+	chan->buf[buf->cpu] = NULL;
 	kfree(buf->padding);
 	kfree(buf);
 	kref_put(&chan->kref, relay_destroy_channel);
@@ -362,51 +370,69 @@ static void __relay_reset(struct rchan_b
 void relay_reset(struct rchan *chan)
 {
 	unsigned int i;
-	struct rchan_buf *prev = NULL;
 
 	if (!chan)
 		return;
 
-	for (i = 0; i < NR_CPUS; i++) {
-		if (!chan->buf[i] || chan->buf[i] == prev)
-			break;
-		__relay_reset(chan->buf[i], 0);
-		prev = chan->buf[i];
+ 	if (chan->is_global && chan->buf[0]) {
+		__relay_reset(chan->buf[0], 0);
+		return;
 	}
+
+	mutex_lock(&relay_channels_mutex);
+	for_each_online_cpu(i)
+		if (chan->buf[i])
+			__relay_reset(chan->buf[i], 0);
+	mutex_unlock(&relay_channels_mutex);
 }
 EXPORT_SYMBOL_GPL(relay_reset);
 
 /*
  *	relay_open_buf - create a new relay channel buffer
  *
- *	Internal - used by relay_open().
+ *	used by relay_open() and CPU hotplug.
  */
-static struct rchan_buf *relay_open_buf(struct rchan *chan,
-					const char *filename,
-					struct dentry *parent,
-					int *is_global)
+static struct rchan_buf *relay_open_buf(struct rchan *chan, unsigned int cpu)
 {
-	struct rchan_buf *buf;
+ 	struct rchan_buf *buf = NULL;
 	struct dentry *dentry;
+ 	char *tmpname;
 
-	if (*is_global)
+ 	if (chan->is_global)
 		return chan->buf[0];
 
+	tmpname = kzalloc(NAME_MAX + 1, GFP_KERNEL);
+ 	if (!tmpname)
+ 		goto end;
+ 	snprintf(tmpname, NAME_MAX, "%s%d", chan->base_filename, cpu);
+
 	buf = relay_create_buf(chan);
 	if (!buf)
-		return NULL;
+ 		goto free_name;
+
+ 	buf->cpu = cpu;
+ 	__relay_reset(buf, 1);
 
 	/* Create file in fs */
-	dentry = chan->cb->create_buf_file(filename, parent, S_IRUSR,
-					   buf, is_global);
-	if (!dentry) {
-		relay_destroy_buf(buf);
-		return NULL;
-	}
+ 	dentry = chan->cb->create_buf_file(tmpname, chan->parent, S_IRUSR,
+ 					   buf, &chan->is_global);
+ 	if (!dentry)
+ 		goto free_buf;
 
 	buf->dentry = dentry;
-	__relay_reset(buf, 1);
 
+ 	if(chan->is_global) {
+ 		chan->buf[0] = buf;
+ 		buf->cpu = 0;
+  	}
+
+ 	goto free_name;
+
+free_buf:
+ 	relay_destroy_buf(buf);
+free_name:
+ 	kfree(tmpname);
+end:
 	return buf;
 }
 
@@ -448,12 +474,54 @@ static void setup_callbacks(struct rchan
 }
 
 /**
+ *
+ * 	relay_hotcpu_callback - CPU hotplug callback
+ * 	@nb: notifier block
+ * 	@action: hotplug action to take
+ * 	@hcpu: CPU number
+ *
+ * 	Returns the success/failure of the operation. (NOTIFY_OK, NOTIFY_BAD)
+ */
+static int __cpuinit relay_hotcpu_callback(struct notifier_block *nb,
+				unsigned long action,
+				void *hcpu)
+{
+	unsigned int hotcpu = (unsigned long)hcpu;
+	struct rchan *chan;
+
+	switch(action) {
+	case CPU_UP_PREPARE:
+		mutex_lock(&relay_channels_mutex);
+		list_for_each_entry(chan, &relay_channels, list) {
+			if (chan->buf[hotcpu])
+				continue;
+			chan->buf[hotcpu] = relay_open_buf(chan, hotcpu);
+			if(!chan->buf[hotcpu]) {
+				printk(KERN_ERR
+					"relay_hotcpu_callback: cpu %d buffer "
+					"creation failed\n", hotcpu);
+				mutex_unlock(&relay_channels_mutex);
+				return NOTIFY_BAD;
+			}
+		}
+		mutex_unlock(&relay_channels_mutex);
+		break;
+	case CPU_DEAD:
+		/* No need to flush the cpu : will be flushed upon
+		 * final relay_flush() call. */
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+/**
  *	relay_open - create a new relay channel
  *	@base_filename: base name of files to create
  *	@parent: dentry of parent directory, %NULL for root directory
  *	@subbuf_size: size of sub-buffers
  *	@n_subbufs: number of sub-buffers
  *	@cb: client callback functions
+ *	@private_data: user-defined data
  *
  *	Returns channel pointer if successful, %NULL otherwise.
  *
@@ -466,13 +534,11 @@ struct rchan *relay_open(const char *bas
 			 struct dentry *parent,
 			 size_t subbuf_size,
 			 size_t n_subbufs,
-			 struct rchan_callbacks *cb)
+			 struct rchan_callbacks *cb,
+			 void *private_data)
 {
 	unsigned int i;
 	struct rchan *chan;
-	char *tmpname;
-	int is_global = 0;
-
 	if (!base_filename)
 		return NULL;
 
@@ -487,38 +553,32 @@ struct rchan *relay_open(const char *bas
 	chan->n_subbufs = n_subbufs;
 	chan->subbuf_size = subbuf_size;
 	chan->alloc_size = FIX_SIZE(subbuf_size * n_subbufs);
+	chan->parent = parent;
+	chan->private_data = private_data;
+	strlcpy(chan->base_filename, base_filename, NAME_MAX);
 	setup_callbacks(chan, cb);
 	kref_init(&chan->kref);
 
-	tmpname = kmalloc(NAME_MAX + 1, GFP_KERNEL);
-	if (!tmpname)
-		goto free_chan;
-
+	mutex_lock(&relay_channels_mutex);
 	for_each_online_cpu(i) {
-		sprintf(tmpname, "%s%d", base_filename, i);
-		chan->buf[i] = relay_open_buf(chan, tmpname, parent,
-					      &is_global);
+		chan->buf[i] = relay_open_buf(chan, i);
 		if (!chan->buf[i])
 			goto free_bufs;
-
-		chan->buf[i]->cpu = i;
 	}
+	list_add(&chan->list, &relay_channels);
+	mutex_unlock(&relay_channels_mutex);
 
-	kfree(tmpname);
 	return chan;
 
 free_bufs:
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_online_cpu(i) {
 		if (!chan->buf[i])
 			break;
 		relay_close_buf(chan->buf[i]);
-		if (is_global)
-			break;
 	}
-	kfree(tmpname);
 
-free_chan:
 	kref_put(&chan->kref, relay_destroy_channel);
+	mutex_unlock(&relay_channels_mutex);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(relay_open);
@@ -619,24 +679,26 @@ EXPORT_SYMBOL_GPL(relay_subbufs_consumed
 void relay_close(struct rchan *chan)
 {
 	unsigned int i;
-	struct rchan_buf *prev = NULL;
 
 	if (!chan)
 		return;
 
-	for (i = 0; i < NR_CPUS; i++) {
-		if (!chan->buf[i] || chan->buf[i] == prev)
-			break;
-		relay_close_buf(chan->buf[i]);
-		prev = chan->buf[i];
-	}
+	mutex_lock(&relay_channels_mutex);
+	if (chan->is_global && chan->buf[0])
+		relay_close_buf(chan->buf[0]);
+	else
+		for_each_possible_cpu(i)
+			if (chan->buf[i])
+				relay_close_buf(chan->buf[i]);
 
 	if (chan->last_toobig)
 		printk(KERN_WARNING "relay: one or more items not logged "
 		       "[item size (%Zd) > sub-buffer size (%Zd)]\n",
 		       chan->last_toobig, chan->subbuf_size);
 
+	list_del(&chan->list);
 	kref_put(&chan->kref, relay_destroy_channel);
+	mutex_unlock(&relay_channels_mutex);
 }
 EXPORT_SYMBOL_GPL(relay_close);
 
@@ -649,17 +711,20 @@ EXPORT_SYMBOL_GPL(relay_close);
 void relay_flush(struct rchan *chan)
 {
 	unsigned int i;
-	struct rchan_buf *prev = NULL;
 
 	if (!chan)
 		return;
 
-	for (i = 0; i < NR_CPUS; i++) {
-		if (!chan->buf[i] || chan->buf[i] == prev)
-			break;
-		relay_switch_subbuf(chan->buf[i], 0);
-		prev = chan->buf[i];
+	if (chan->is_global && chan->buf[0]) {
+		relay_switch_subbuf(chan->buf[0], 0);
+		return;
 	}
+
+	mutex_lock(&relay_channels_mutex);
+	for_each_possible_cpu(i)
+		if (chan->buf[i])
+			relay_switch_subbuf(chan->buf[i], 0);
+	mutex_unlock(&relay_channels_mutex);
 }
 EXPORT_SYMBOL_GPL(relay_flush);
 
@@ -1022,3 +1087,12 @@ const struct file_operations relay_file_
 	.sendfile       = relay_file_sendfile,
 };
 EXPORT_SYMBOL_GPL(relay_file_operations);
+
+static __init int relay_init(void)
+{
+
+	hotcpu_notifier(relay_hotcpu_callback, 0);
+	return 0;
+}
+
+module_init(relay_init);
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

relay-remove-inlining.patch
relay-add-cpu-hotplug-support.patch

