Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA7C286D56
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127159; cv=none; b=p3ct2kjNDoTsbBAjwDjgCLuxgU5HMnEXklpJTdd0xis32x1QsMJMZgxbX3aoU/9FDN1BJQspEvokEW+bpSOQwPmhUQCKjLYTHK/OEhhmhQ/ZJyKsix1OviltJ23UwmycpS3+UCXjUjvYzK4swQsuNUyQJHTUiZxuJ7iZUEDXf3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127159; c=relaxed/simple;
	bh=Mfhvuk5rNUUEXWB0/FRJJrysNtGRNU/8P3z0p5iOYMY=;
	h=Date:To:From:Subject:Message-Id; b=H1Kzcc+kLPnLudPTTnmqfePCv3zoQsdIqoh4FJFxu+4gwVqD9DEx4evo9u+WqH9UN8rZDFN/wY06S5ejf1HGoBjnIrscLeiV9qF1ccGgFtYcBkCKUDXXg9/lVpIb8K+77fqs4p8owXgbaeax03lmg+0iPeNwT4iDtarF9v1SoO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pOWrCk/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pOWrCk/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E13C4CEE3;
	Thu, 10 Jul 2025 05:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127158;
	bh=Mfhvuk5rNUUEXWB0/FRJJrysNtGRNU/8P3z0p5iOYMY=;
	h=Date:To:From:Subject:From;
	b=pOWrCk/381Ki9b+8vXzy7OcyoHvNHAcZXW/wncRkyb9XfQwRt5dlJa21k2dCu1R+r
	 hcXFP8ceuf5U2/BZ6OqJlpGF7E296wvPK6K28DY2CHJWZMZD99q0KusUBmzWERMDm3
	 RHfnffPjO1Sd9ATlwLYhKbQmQMVJiiLCWU5K8AJo=
Date: Wed, 09 Jul 2025 22:59:18 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,katrinzhou@tencent.com,axboe@kernel.dk,kernelxing@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] relayfs-support-a-counter-tracking-if-data-is-too-big-to-write.patch removed from -mm tree
Message-Id: <20250710055918.B3E13C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: relayfs: support a counter tracking if data is too big to write
has been removed from the -mm tree.  Its filename was
     relayfs-support-a-counter-tracking-if-data-is-too-big-to-write.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jason Xing <kernelxing@tencent.com>
Subject: relayfs: support a counter tracking if data is too big to write
Date: Thu, 12 Jun 2025 14:12:01 +0800

It really doesn't matter if the user/admin knows what the last too big
value is.  Record how many times this case is triggered would be helpful.

Solve the existing issue where relay_reset() doesn't restore the value.

Store the counter in the per-cpu buffer structure instead of the global
buffer structure.  It also solves the racy condition which is likely to
happen when a few of per-cpu buffers encounter the too big data case and
then access the global field last_toobig without lock protection.

Remove the printk in relay_close() since kernel module can directly call
relay_stats() as they want.

Link: https://lkml.kernel.org/r/20250612061201.34272-6-kerneljasonxing@gmail.com
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Yushan Zhou <katrinzhou@tencent.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/relay.h |    5 +++--
 kernel/relay.c        |   18 ++++++++++--------
 2 files changed, 13 insertions(+), 10 deletions(-)

--- a/include/linux/relay.h~relayfs-support-a-counter-tracking-if-data-is-too-big-to-write
+++ a/include/linux/relay.h
@@ -33,13 +33,15 @@
  */
 enum {
 	RELAY_STATS_BUF_FULL = (1 << 0),
+	RELAY_STATS_WRT_BIG = (1 << 1),
 
-	RELAY_STATS_LAST = RELAY_STATS_BUF_FULL,
+	RELAY_STATS_LAST = RELAY_STATS_WRT_BIG,
 };
 
 struct rchan_buf_stats
 {
 	unsigned int full_count;	/* counter for buffer full */
+	unsigned int big_count;		/* counter for too big to write */
 };
 
 /*
@@ -79,7 +81,6 @@ struct rchan
 	const struct rchan_callbacks *cb; /* client callbacks */
 	struct kref kref;		/* channel refcount */
 	void *private_data;		/* for user-defined data */
-	size_t last_toobig;		/* tried to log event > subbuf size */
 	struct rchan_buf * __percpu *buf; /* per-cpu channel buffers */
 	int is_global;			/* One global buffer ? */
 	struct list_head list;		/* for channel list */
--- a/kernel/relay.c~relayfs-support-a-counter-tracking-if-data-is-too-big-to-write
+++ a/kernel/relay.c
@@ -303,6 +303,7 @@ static void __relay_reset(struct rchan_b
 	buf->data = buf->start;
 	buf->offset = 0;
 	buf->stats.full_count = 0;
+	buf->stats.big_count = 0;
 
 	for (i = 0; i < buf->chan->n_subbufs; i++)
 		buf->padding[i] = 0;
@@ -602,7 +603,7 @@ size_t relay_switch_subbuf(struct rchan_
 	return length;
 
 toobig:
-	buf->chan->last_toobig = length;
+	buf->stats.big_count++;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(relay_switch_subbuf);
@@ -662,11 +663,6 @@ void relay_close(struct rchan *chan)
 			if ((buf = *per_cpu_ptr(chan->buf, i)))
 				relay_close_buf(buf);
 
-	if (chan->last_toobig)
-		printk(KERN_WARNING "relay: one or more items not logged "
-		       "[item size (%zd) > sub-buffer size (%zd)]\n",
-		       chan->last_toobig, chan->subbuf_size);
-
 	list_del(&chan->list);
 	kref_put(&chan->kref, relay_destroy_channel);
 	mutex_unlock(&relay_channels_mutex);
@@ -719,11 +715,17 @@ size_t relay_stats(struct rchan *chan, i
 		rbuf = *per_cpu_ptr(chan->buf, 0);
 		if (flags & RELAY_STATS_BUF_FULL)
 			count = rbuf->stats.full_count;
+		else if (flags & RELAY_STATS_WRT_BIG)
+			count = rbuf->stats.big_count;
 	} else {
 		for_each_online_cpu(i) {
 			rbuf = *per_cpu_ptr(chan->buf, i);
-			if (rbuf && flags & RELAY_STATS_BUF_FULL)
-				count += rbuf->stats.full_count;
+			if (rbuf) {
+				if (flags & RELAY_STATS_BUF_FULL)
+					count += rbuf->stats.full_count;
+				else if (flags & RELAY_STATS_WRT_BIG)
+					count += rbuf->stats.big_count;
+			}
 		}
 	}
 
_

Patches currently in -mm which might be from kernelxing@tencent.com are


