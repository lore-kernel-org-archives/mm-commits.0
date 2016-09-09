From: akpm@linux-foundation.org
Subject: [merged]
 relay-use-per-cpu-constructs-for-the-relay-channel-buffer-pointers.patch
 removed from -mm tree
Date: Fri, 09 Sep 2016 11:32:14 -0700
Message-ID: <57d3002e.YUN/NdfRdiQsb3dq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47100 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752015AbcIIScQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2016 14:32:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akash.goel@intel.com, chris@chris-wilson.co.uk, tvrtko.ursulin@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: relay: Use per CPU constructs for the relay channel buffer pointers
has been removed from the -mm tree.  Its filename was
     relay-use-per-cpu-constructs-for-the-relay-channel-buffer-pointers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akash Goel <akash.goel@intel.com>
Subject: relay: Use per CPU constructs for the relay channel buffer pointers

relay essentially needs to maintain the per CPU array of channel buffer
pointers but it manually creates that array.  Instead its better to avail
the per CPU constructs, provided by the kernel, to allocate & access the
array of pointer to channel buffers.

Link: http://lkml.kernel.org/r/1470909140-25919-1-git-send-email-akash.goel@intel.com
Signed-off-by: Akash Goel <akash.goel@intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/relay.h |   17 +++++----
 kernel/relay.c        |   74 ++++++++++++++++++++++------------------
 2 files changed, 52 insertions(+), 39 deletions(-)

diff -puN include/linux/relay.h~relay-use-per-cpu-constructs-for-the-relay-channel-buffer-pointers include/linux/relay.h
--- a/include/linux/relay.h~relay-use-per-cpu-constructs-for-the-relay-channel-buffer-pointers
+++ a/include/linux/relay.h
@@ -20,6 +20,7 @@
 #include <linux/poll.h>
 #include <linux/kref.h>
 #include <linux/irq_work.h>
+#include <linux/percpu.h>
 
 /*
  * Tracks changes to rchan/rchan_buf structs
@@ -64,7 +65,7 @@ struct rchan
 	struct kref kref;		/* channel refcount */
 	void *private_data;		/* for user-defined data */
 	size_t last_toobig;		/* tried to log event > subbuf size */
-	struct rchan_buf *buf[NR_CPUS]; /* per-cpu channel buffers */
+	struct rchan_buf ** __percpu buf; /* per-cpu channel buffers */
 	int is_global;			/* One global buffer ? */
 	struct list_head list;		/* for channel list */
 	struct dentry *parent;		/* parent dentry passed to open */
@@ -205,7 +206,7 @@ static inline void relay_write(struct rc
 	struct rchan_buf *buf;
 
 	local_irq_save(flags);
-	buf = chan->buf[smp_processor_id()];
+	buf = *this_cpu_ptr(chan->buf);
 	if (unlikely(buf->offset + length > chan->subbuf_size))
 		length = relay_switch_subbuf(buf, length);
 	memcpy(buf->data + buf->offset, data, length);
@@ -231,12 +232,12 @@ static inline void __relay_write(struct
 {
 	struct rchan_buf *buf;
 
-	buf = chan->buf[get_cpu()];
+	buf = *get_cpu_ptr(chan->buf);
 	if (unlikely(buf->offset + length > buf->chan->subbuf_size))
 		length = relay_switch_subbuf(buf, length);
 	memcpy(buf->data + buf->offset, data, length);
 	buf->offset += length;
-	put_cpu();
+	put_cpu_ptr(chan->buf);
 }
 
 /**
@@ -252,17 +253,19 @@ static inline void __relay_write(struct
  */
 static inline void *relay_reserve(struct rchan *chan, size_t length)
 {
-	void *reserved;
-	struct rchan_buf *buf = chan->buf[smp_processor_id()];
+	void *reserved = NULL;
+	struct rchan_buf *buf = *get_cpu_ptr(chan->buf);
 
 	if (unlikely(buf->offset + length > buf->chan->subbuf_size)) {
 		length = relay_switch_subbuf(buf, length);
 		if (!length)
-			return NULL;
+			goto end;
 	}
 	reserved = buf->data + buf->offset;
 	buf->offset += length;
 
+end:
+	put_cpu_ptr(chan->buf);
 	return reserved;
 }
 
diff -puN kernel/relay.c~relay-use-per-cpu-constructs-for-the-relay-channel-buffer-pointers kernel/relay.c
--- a/kernel/relay.c~relay-use-per-cpu-constructs-for-the-relay-channel-buffer-pointers
+++ a/kernel/relay.c
@@ -214,7 +214,7 @@ static void relay_destroy_buf(struct rch
 			__free_page(buf->page_array[i]);
 		relay_free_page_array(buf->page_array);
 	}
-	chan->buf[buf->cpu] = NULL;
+	*per_cpu_ptr(chan->buf, buf->cpu) = NULL;
 	kfree(buf->padding);
 	kfree(buf);
 	kref_put(&chan->kref, relay_destroy_channel);
@@ -385,20 +385,21 @@ static void __relay_reset(struct rchan_b
  */
 void relay_reset(struct rchan *chan)
 {
+	struct rchan_buf *buf;
 	unsigned int i;
 
 	if (!chan)
 		return;
 
-	if (chan->is_global && chan->buf[0]) {
-		__relay_reset(chan->buf[0], 0);
+	if (chan->is_global && (buf = *per_cpu_ptr(chan->buf, 0))) {
+		__relay_reset(buf, 0);
 		return;
 	}
 
 	mutex_lock(&relay_channels_mutex);
 	for_each_possible_cpu(i)
-		if (chan->buf[i])
-			__relay_reset(chan->buf[i], 0);
+		if ((buf = *per_cpu_ptr(chan->buf, i)))
+			__relay_reset(buf, 0);
 	mutex_unlock(&relay_channels_mutex);
 }
 EXPORT_SYMBOL_GPL(relay_reset);
@@ -443,7 +444,7 @@ static struct rchan_buf *relay_open_buf(
 	struct dentry *dentry;
 
  	if (chan->is_global)
-		return chan->buf[0];
+		return *per_cpu_ptr(chan->buf, 0);
 
 	buf = relay_create_buf(chan);
 	if (!buf)
@@ -467,7 +468,7 @@ static struct rchan_buf *relay_open_buf(
  	__relay_reset(buf, 1);
 
  	if(chan->is_global) {
- 		chan->buf[0] = buf;
+		*per_cpu_ptr(chan->buf, 0) = buf;
  		buf->cpu = 0;
   	}
 
@@ -529,22 +530,24 @@ static int relay_hotcpu_callback(struct
 {
 	unsigned int hotcpu = (unsigned long)hcpu;
 	struct rchan *chan;
+	struct rchan_buf *buf;
 
 	switch(action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
 		mutex_lock(&relay_channels_mutex);
 		list_for_each_entry(chan, &relay_channels, list) {
-			if (chan->buf[hotcpu])
+			if ((buf = *per_cpu_ptr(chan->buf, hotcpu)))
 				continue;
-			chan->buf[hotcpu] = relay_open_buf(chan, hotcpu);
-			if(!chan->buf[hotcpu]) {
+			buf = relay_open_buf(chan, hotcpu);
+			if (!buf) {
 				printk(KERN_ERR
 					"relay_hotcpu_callback: cpu %d buffer "
 					"creation failed\n", hotcpu);
 				mutex_unlock(&relay_channels_mutex);
 				return notifier_from_errno(-ENOMEM);
 			}
+			*per_cpu_ptr(chan->buf, hotcpu) = buf;
 		}
 		mutex_unlock(&relay_channels_mutex);
 		break;
@@ -586,6 +589,7 @@ struct rchan *relay_open(const char *bas
 {
 	unsigned int i;
 	struct rchan *chan;
+	struct rchan_buf *buf;
 
 	if (!(subbuf_size && n_subbufs))
 		return NULL;
@@ -596,6 +600,7 @@ struct rchan *relay_open(const char *bas
 	if (!chan)
 		return NULL;
 
+	chan->buf = alloc_percpu(struct rchan_buf *);
 	chan->version = RELAYFS_CHANNEL_VERSION;
 	chan->n_subbufs = n_subbufs;
 	chan->subbuf_size = subbuf_size;
@@ -611,9 +616,10 @@ struct rchan *relay_open(const char *bas
 
 	mutex_lock(&relay_channels_mutex);
 	for_each_online_cpu(i) {
-		chan->buf[i] = relay_open_buf(chan, i);
-		if (!chan->buf[i])
+		buf = relay_open_buf(chan, i);
+		if (!buf)
 			goto free_bufs;
+		*per_cpu_ptr(chan->buf, i) = buf;
 	}
 	list_add(&chan->list, &relay_channels);
 	mutex_unlock(&relay_channels_mutex);
@@ -622,8 +628,8 @@ struct rchan *relay_open(const char *bas
 
 free_bufs:
 	for_each_possible_cpu(i) {
-		if (chan->buf[i])
-			relay_close_buf(chan->buf[i]);
+		if ((buf = *per_cpu_ptr(chan->buf, i)))
+			relay_close_buf(buf);
 	}
 
 	kref_put(&chan->kref, relay_destroy_channel);
@@ -669,6 +675,7 @@ int relay_late_setup_files(struct rchan
 	unsigned int i, curr_cpu;
 	unsigned long flags;
 	struct dentry *dentry;
+	struct rchan_buf *buf;
 	struct rchan_percpu_buf_dispatcher disp;
 
 	if (!chan || !base_filename)
@@ -687,10 +694,11 @@ int relay_late_setup_files(struct rchan
 
 	if (chan->is_global) {
 		err = -EINVAL;
-		if (!WARN_ON_ONCE(!chan->buf[0])) {
-			dentry = relay_create_buf_file(chan, chan->buf[0], 0);
+		buf = *per_cpu_ptr(chan->buf, 0);
+		if (!WARN_ON_ONCE(!buf)) {
+			dentry = relay_create_buf_file(chan, buf, 0);
 			if (dentry && !WARN_ON_ONCE(!chan->is_global)) {
-				relay_set_buf_dentry(chan->buf[0], dentry);
+				relay_set_buf_dentry(buf, dentry);
 				err = 0;
 			}
 		}
@@ -705,13 +713,14 @@ int relay_late_setup_files(struct rchan
 	 * on all currently online CPUs.
 	 */
 	for_each_online_cpu(i) {
-		if (unlikely(!chan->buf[i])) {
+		buf = *per_cpu_ptr(chan->buf, i);
+		if (unlikely(!buf)) {
 			WARN_ONCE(1, KERN_ERR "CPU has no buffer!\n");
 			err = -EINVAL;
 			break;
 		}
 
-		dentry = relay_create_buf_file(chan, chan->buf[i], i);
+		dentry = relay_create_buf_file(chan, buf, i);
 		if (unlikely(!dentry)) {
 			err = -EINVAL;
 			break;
@@ -719,10 +728,10 @@ int relay_late_setup_files(struct rchan
 
 		if (curr_cpu == i) {
 			local_irq_save(flags);
-			relay_set_buf_dentry(chan->buf[i], dentry);
+			relay_set_buf_dentry(buf, dentry);
 			local_irq_restore(flags);
 		} else {
-			disp.buf = chan->buf[i];
+			disp.buf = buf;
 			disp.dentry = dentry;
 			smp_mb();
 			/* relay_channels_mutex must be held, so wait. */
@@ -826,11 +835,10 @@ void relay_subbufs_consumed(struct rchan
 	if (!chan)
 		return;
 
-	if (cpu >= NR_CPUS || !chan->buf[cpu] ||
-					subbufs_consumed > chan->n_subbufs)
+	buf = *per_cpu_ptr(chan->buf, cpu);
+	if (cpu >= NR_CPUS || !buf || subbufs_consumed > chan->n_subbufs)
 		return;
 
-	buf = chan->buf[cpu];
 	if (subbufs_consumed > buf->subbufs_produced - buf->subbufs_consumed)
 		buf->subbufs_consumed = buf->subbufs_produced;
 	else
@@ -846,18 +854,19 @@ EXPORT_SYMBOL_GPL(relay_subbufs_consumed
  */
 void relay_close(struct rchan *chan)
 {
+	struct rchan_buf *buf;
 	unsigned int i;
 
 	if (!chan)
 		return;
 
 	mutex_lock(&relay_channels_mutex);
-	if (chan->is_global && chan->buf[0])
-		relay_close_buf(chan->buf[0]);
+	if (chan->is_global && (buf = *per_cpu_ptr(chan->buf, 0)))
+		relay_close_buf(buf);
 	else
 		for_each_possible_cpu(i)
-			if (chan->buf[i])
-				relay_close_buf(chan->buf[i]);
+			if ((buf = *per_cpu_ptr(chan->buf, i)))
+				relay_close_buf(buf);
 
 	if (chan->last_toobig)
 		printk(KERN_WARNING "relay: one or more items not logged "
@@ -878,20 +887,21 @@ EXPORT_SYMBOL_GPL(relay_close);
  */
 void relay_flush(struct rchan *chan)
 {
+	struct rchan_buf *buf;
 	unsigned int i;
 
 	if (!chan)
 		return;
 
-	if (chan->is_global && chan->buf[0]) {
-		relay_switch_subbuf(chan->buf[0], 0);
+	if (chan->is_global && (buf = *per_cpu_ptr(chan->buf, 0))) {
+		relay_switch_subbuf(buf, 0);
 		return;
 	}
 
 	mutex_lock(&relay_channels_mutex);
 	for_each_possible_cpu(i)
-		if (chan->buf[i])
-			relay_switch_subbuf(chan->buf[i], 0);
+		if ((buf = *per_cpu_ptr(chan->buf, i)))
+			relay_switch_subbuf(buf, 0);
 	mutex_unlock(&relay_channels_mutex);
 }
 EXPORT_SYMBOL_GPL(relay_flush);
_

Patches currently in -mm which might be from akash.goel@intel.com are


