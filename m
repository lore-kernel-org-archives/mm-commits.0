From: akpm@linux-foundation.org
Subject: + relay-add-buffer-only-channels-useful-for-early-logging.patch added to -mm tree
Date: Mon, 23 Jun 2008 17:27:36 -0700
Message-ID: <200806240027.m5O0Ra3a024117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750752AbYFXA2W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 20:28:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eduard.munteanu@linux360.ro, tzanussi@gmail.com


The patch titled
     relay: add buffer-only channels; useful for early logging
has been added to the -mm tree.  Its filename is
     relay-add-buffer-only-channels-useful-for-early-logging.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: relay: add buffer-only channels; useful for early logging
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

Allows one to create and use a channel with no associated files.  Files
can be initialized later.  This is useful in scenarios such as logging in
early code, before VFS is up.  Therefore, such channels can be created and
used as soon as kmem_cache_init() completed.

This is needed by kmemtrace to do tracing in early kernel code.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/relay.txt |   10 +
 include/linux/relay.h               |    5 
 kernel/relay.c                      |  170 +++++++++++++++++++++-----
 3 files changed, 156 insertions(+), 29 deletions(-)

diff -puN Documentation/filesystems/relay.txt~relay-add-buffer-only-channels-useful-for-early-logging Documentation/filesystems/relay.txt
--- a/Documentation/filesystems/relay.txt~relay-add-buffer-only-channels-useful-for-early-logging
+++ a/Documentation/filesystems/relay.txt
@@ -295,6 +295,16 @@ user-defined data with a channel, and is
 (including in create_buf_file()) via chan->private_data or
 buf->chan->private_data.
 
+Buffer-only channels
+--------------------
+
+These channels have no files associated and can be created with
+relay_open(NULL, NULL, ...). Such channels are useful in scenarios such
+as when doing early tracing in the kernel, before the VFS is up. In these
+cases, one may open a buffer-only channel and then call
+relay_late_setup_files() when the kernel is ready to handle files,
+to expose the buffered data to the userspace.
+
 Channel 'modes'
 ---------------
 
diff -puN include/linux/relay.h~relay-add-buffer-only-channels-useful-for-early-logging include/linux/relay.h
--- a/include/linux/relay.h~relay-add-buffer-only-channels-useful-for-early-logging
+++ a/include/linux/relay.h
@@ -48,6 +48,7 @@ struct rchan_buf
 	size_t *padding;		/* padding counts per sub-buffer */
 	size_t prev_padding;		/* temporary variable */
 	size_t bytes_consumed;		/* bytes consumed in cur read subbuf */
+	size_t early_bytes;		/* bytes consumed before VFS inited */
 	unsigned int cpu;		/* this buf's cpu */
 } ____cacheline_aligned;
 
@@ -68,6 +69,7 @@ struct rchan
 	int is_global;			/* One global buffer ? */
 	struct list_head list;		/* for channel list */
 	struct dentry *parent;		/* parent dentry passed to open */
+	int has_base_filename;		/* has a filename associated? */
 	char base_filename[NAME_MAX];	/* saved base filename */
 };
 
@@ -169,6 +171,9 @@ struct rchan *relay_open(const char *bas
 			 size_t n_subbufs,
 			 struct rchan_callbacks *cb,
 			 void *private_data);
+extern int relay_late_setup_files(struct rchan *chan,
+				  const char *base_filename,
+				  struct dentry *parent);
 extern void relay_close(struct rchan *chan);
 extern void relay_flush(struct rchan *chan);
 extern void relay_subbufs_consumed(struct rchan *chan,
diff -puN kernel/relay.c~relay-add-buffer-only-channels-useful-for-early-logging kernel/relay.c
--- a/kernel/relay.c~relay-add-buffer-only-channels-useful-for-early-logging
+++ a/kernel/relay.c
@@ -458,6 +458,35 @@ void relay_reset_consumed(struct rchan *
 }
 EXPORT_SYMBOL_GPL(relay_reset_consumed);
 
+static inline void relay_set_buf_dentry(struct rchan_buf *buf,
+					struct dentry *dentry)
+{
+	buf->dentry = dentry;
+	buf->dentry->d_inode->i_size = buf->early_bytes;
+}
+
+static struct dentry *relay_create_buf_file(struct rchan *chan,
+					    struct rchan_buf *buf,
+					    unsigned int cpu)
+{
+	struct dentry *dentry;
+	char *tmpname;
+
+	tmpname = kzalloc(NAME_MAX + 1, GFP_KERNEL);
+	if (!tmpname)
+		return NULL;
+	snprintf(tmpname, NAME_MAX, "%s%d", chan->base_filename, cpu);
+
+	/* Create file in fs */
+	dentry = chan->cb->create_buf_file(tmpname, chan->parent,
+					   S_IRUSR, buf,
+					   &chan->is_global);
+
+	kfree(tmpname);
+
+	return dentry;
+}
+
 /*
  *	relay_open_buf - create a new relay channel buffer
  *
@@ -467,45 +496,34 @@ static struct rchan_buf *relay_open_buf(
 {
  	struct rchan_buf *buf = NULL;
 	struct dentry *dentry;
- 	char *tmpname;
 
  	if (chan->is_global)
 		return chan->buf[0];
 
-	tmpname = kzalloc(NAME_MAX + 1, GFP_KERNEL);
- 	if (!tmpname)
- 		goto end;
- 	snprintf(tmpname, NAME_MAX, "%s%d", chan->base_filename, cpu);
-
 	buf = relay_create_buf(chan);
 	if (!buf)
- 		goto free_name;
+		return NULL;
+
+	if (chan->has_base_filename) {
+		dentry = relay_create_buf_file(chan, buf, cpu);
+		if (!dentry)
+			goto free_buf;
+		relay_set_buf_dentry(buf, dentry);
+	}
 
  	buf->cpu = cpu;
  	__relay_reset(buf, 1);
 
-	/* Create file in fs */
- 	dentry = chan->cb->create_buf_file(tmpname, chan->parent, S_IRUSR,
- 					   buf, &chan->is_global);
- 	if (!dentry)
- 		goto free_buf;
-
-	buf->dentry = dentry;
-
  	if(chan->is_global) {
  		chan->buf[0] = buf;
  		buf->cpu = 0;
   	}
 
- 	goto free_name;
+	return buf;
 
 free_buf:
  	relay_destroy_buf(buf);
- 	buf = NULL;
-free_name:
- 	kfree(tmpname);
-end:
-	return buf;
+	return NULL;
 }
 
 /**
@@ -588,8 +606,8 @@ static int __cpuinit relay_hotcpu_callba
 
 /**
  *	relay_open - create a new relay channel
- *	@base_filename: base name of files to create
- *	@parent: dentry of parent directory, %NULL for root directory
+ *	@base_filename: base name of files to create, %NULL for buffering only
+ *	@parent: dentry of parent directory, %NULL for root directory or buffer
  *	@subbuf_size: size of sub-buffers
  *	@n_subbufs: number of sub-buffers
  *	@cb: client callback functions
@@ -611,8 +629,6 @@ struct rchan *relay_open(const char *bas
 {
 	unsigned int i;
 	struct rchan *chan;
-	if (!base_filename)
-		return NULL;
 
 	if (!(subbuf_size && n_subbufs))
 		return NULL;
@@ -627,7 +643,10 @@ struct rchan *relay_open(const char *bas
 	chan->alloc_size = FIX_SIZE(subbuf_size * n_subbufs);
 	chan->parent = parent;
 	chan->private_data = private_data;
-	strlcpy(chan->base_filename, base_filename, NAME_MAX);
+	if (base_filename) {
+		chan->has_base_filename = 1;
+		strlcpy(chan->base_filename, base_filename, NAME_MAX);
+	}
 	setup_callbacks(chan, cb);
 	kref_init(&chan->kref);
 
@@ -655,6 +674,94 @@ free_bufs:
 }
 EXPORT_SYMBOL_GPL(relay_open);
 
+struct rchan_percpu_buf_dispatcher {
+	struct rchan_buf *buf;
+	struct dentry *dentry;
+};
+
+/* Called in atomic context. */
+static void __relay_set_buf_dentry(void *info)
+{
+	struct rchan_percpu_buf_dispatcher *p = info;
+
+	relay_set_buf_dentry(p->buf, p->dentry);
+}
+
+/**
+ *	relay_late_setup_files - triggers file creation
+ *	@chan: channel to operate on
+ *	@base_filename: base name of files to create
+ *	@parent: dentry of parent directory, %NULL for root directory
+ *
+ *	Returns 0 if successful, non-zero otherwise.
+ *
+ *	Use to setup files for a previously buffer-only channel.
+ *	Useful to do early tracing in kernel, before VFS is up, for example.
+ */
+int relay_late_setup_files(struct rchan *chan,
+			   const char *base_filename,
+			   struct dentry *parent)
+{
+	int err = 0;
+	unsigned int i, curr_cpu;
+	unsigned long flags;
+	struct dentry *dentry;
+	struct rchan_percpu_buf_dispatcher disp;
+
+	if (!chan || !base_filename)
+		return -EINVAL;
+
+	strlcpy(chan->base_filename, base_filename, NAME_MAX);
+
+	mutex_lock(&relay_channels_mutex);
+	/* Is chan already set up? */
+	if (unlikely(chan->has_base_filename))
+		return -EEXIST;
+	chan->has_base_filename = 1;
+	chan->parent = parent;
+	curr_cpu = get_cpu();
+	/*
+	 * The CPU hotplug notifier ran before us and created buffers with
+	 * no files associated. So it's safe to call relay_setup_buf_file()
+	 * on all currently online CPUs.
+	 */
+	for_each_online_cpu(i) {
+		if (unlikely(!chan->buf[i])) {
+			printk(KERN_ERR "relay_late_setup_files: CPU %u "
+					"has no buffer, it must have!\n", i);
+			BUG();
+			err = -EINVAL;
+			break;
+		}
+
+		dentry = relay_create_buf_file(chan, chan->buf[i], i);
+		if (unlikely(!dentry)) {
+			err = -EINVAL;
+			break;
+		}
+
+		if (curr_cpu == i) {
+			local_irq_save(flags);
+			relay_set_buf_dentry(chan->buf[i], dentry);
+			local_irq_restore(flags);
+		} else {
+			disp.buf = chan->buf[i];
+			disp.dentry = dentry;
+			smp_mb();
+			/* relay_channels_mutex must be held, so wait. */
+			err = smp_call_function_single(i,
+						       __relay_set_buf_dentry,
+						       &disp, 0, 1);
+		}
+		if (unlikely(err))
+			break;
+	}
+	put_cpu();
+	mutex_unlock(&relay_channels_mutex);
+
+	return err;
+}
+
 /**
  *	relay_switch_subbuf - switch to a new sub-buffer
  *	@buf: channel buffer
@@ -678,8 +785,13 @@ size_t relay_switch_subbuf(struct rchan_
 		old_subbuf = buf->subbufs_produced % buf->chan->n_subbufs;
 		buf->padding[old_subbuf] = buf->prev_padding;
 		buf->subbufs_produced++;
-		buf->dentry->d_inode->i_size += buf->chan->subbuf_size -
-			buf->padding[old_subbuf];
+		if (buf->dentry)
+			buf->dentry->d_inode->i_size +=
+				buf->chan->subbuf_size -
+				buf->padding[old_subbuf];
+		else
+			buf->early_bytes += buf->chan->subbuf_size -
+					    buf->padding[old_subbuf];
 		smp_mb();
 		if (waitqueue_active(&buf->read_wait))
 			/*
@@ -1285,4 +1397,4 @@ static __init int relay_init(void)
 	return 0;
 }
 
-module_init(relay_init);
+early_initcall(relay_init);
_

Patches currently in -mm which might be from eduard.munteanu@linux360.ro are

better-interface-for-hooking-early-initcalls.patch
full-conversion-to-early_initcall-interface-remove-old-interface.patch
relay-add-buffer-only-channels-useful-for-early-logging.patch

