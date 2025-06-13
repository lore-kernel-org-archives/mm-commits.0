Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C3B2472B0
	for <mm-commits@vger.kernel.org>; Fri, 13 Jun 2025 03:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749784025; cv=none; b=Ii1IXbHHuljauUydgJFlQtv1msOcOEUwYsKKsG6Rmtdypn3PcNvh1ExGN+21imqOqcpwHPw085u8uFFQO/An6bW47w7/JnJC3K/PoSBsHK1uIAX/i1/inYKodlhKGt/IB6pcybm468j+7OhWq5hJiG3Y5HHZwVvdXdQKVshtni4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749784025; c=relaxed/simple;
	bh=65tqqRgxhKip7BU6kgy6B0KmQ7GVB1IJQ7A4GrcBEPI=;
	h=Date:To:From:Subject:Message-Id; b=BM092C5oEgHVLCIZEklA5fcXwkS4KjTNmcaIqQ4MKXyrvfiWRKuauuvUDb2jN/TpDEdEjc2RJ57ZtwvtYdRdD9000VwYe/5SeW5YKy703zK1q3JIJTv4OcfbXosyOPLw4NauE0qQTLksrnqd5IBSmV+2KqAcRuhLKjORmBeSHSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=elbKzlYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="elbKzlYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE3BC4CEEA;
	Fri, 13 Jun 2025 03:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749784024;
	bh=65tqqRgxhKip7BU6kgy6B0KmQ7GVB1IJQ7A4GrcBEPI=;
	h=Date:To:From:Subject:From;
	b=elbKzlYJTTlXimZyYfECfqtuMMGtNuBdHxQtsrzJ3mguSXG4fjAJrchBqJZNZLrz+
	 Q3E38RHKEma/qL7rX3wdMlN4izQDV6/OWFQkYkDpPNZ0EkSxYYgfXhCPF/19bJgyIs
	 Yy5QV86HMSHjqm16xNHYocbyJpppzAAxOW6Rsg9Q=
Date: Thu, 12 Jun 2025 20:07:04 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,katrinzhou@tencent.com,axboe@kernel.dk,kernelxing@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + relayfs-support-a-counter-tracking-if-data-is-too-big-to-write.patch added to mm-nonmm-unstable branch
Message-Id: <20250613030704.9DE3BC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: relayfs: support a counter tracking if data is too big to write
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     relayfs-support-a-counter-tracking-if-data-is-too-big-to-write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/relayfs-support-a-counter-tracking-if-data-is-too-big-to-write.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

relayfs-abolish-prev_padding.patch
relayfs-support-a-counter-tracking-if-per-cpu-buffers-is-full.patch
relayfs-introduce-getting-relayfs-statistics-function.patch
blktrace-use-rbuf-statsfull-as-a-drop-indicator-in-relayfs.patch
relayfs-support-a-counter-tracking-if-data-is-too-big-to-write.patch

