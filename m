Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B8D28643B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127156; cv=none; b=BGKmN7gs4aHRj+cVFSmQF00HIgRLOzL9XtwZdMZyyrhFyYCZCQ4W7jqa4rhPb80xocLkv2g7L0lXcnvQktfkUWUie7sF5tZZz6tbfL3mJXIzFwPTFjYro8V9QAA8XIVTR091+bByhUiDyobrCY5DmAIP3FvF4MRmLBhcKZwCdOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127156; c=relaxed/simple;
	bh=vziVTPLE5MKVyH/ld36OvocbrZBWmW2kwyh9OlOByGY=;
	h=Date:To:From:Subject:Message-Id; b=BBaUBuQpERfxTCJ+Rxz+owU2yVaIe9wdFBCuqqmopqmC/1HNj7PAmPogOwwBvP01MjPoYNBK+yW+yni2s8olG6oe+Fnt1aZQXDjFb9UXXsKDPjkQbVpd6LshZaNjxQEVdRJVxFfi1Bh28xNwXkaSQu91aA2nPWNqvxE8R5qrBzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gCKBNjHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gCKBNjHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4765AC4CEE3;
	Thu, 10 Jul 2025 05:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127156;
	bh=vziVTPLE5MKVyH/ld36OvocbrZBWmW2kwyh9OlOByGY=;
	h=Date:To:From:Subject:From;
	b=gCKBNjHa96Ri7L4frNpu0Ohw/sqWIQsjaobKm5CopDVOAVduAldGBFo2JZKzhxijt
	 oKuv91AhB3JfrdRKtwqxHLBfF16UY47LAo78noaXhs6GQ5dHsyFitySJMARRO2KMpR
	 3jRnLg3f3QdLKwfNy0xHBmre0fBQO0dePRlwYBR8=
Date: Wed, 09 Jul 2025 22:59:15 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,katrinzhou@tencent.com,axboe@kernel.dk,kernelxing@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] relayfs-introduce-getting-relayfs-statistics-function.patch removed from -mm tree
Message-Id: <20250710055916.4765AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: relayfs: introduce getting relayfs statistics function
has been removed from the -mm tree.  Its filename was
     relayfs-introduce-getting-relayfs-statistics-function.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jason Xing <kernelxing@tencent.com>
Subject: relayfs: introduce getting relayfs statistics function
Date: Thu, 12 Jun 2025 14:11:59 +0800

In this version, only support getting the counter for buffer full and
implement the framework of how it works.

Users can pass certain flag to fetch what field/statistics they expect to
know.  Each time it only returns one result.  So do not pass multiple
flags.

Link: https://lkml.kernel.org/r/20250612061201.34272-4-kerneljasonxing@gmail.com
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Yushan Zhou <katrinzhou@tencent.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/relay.h |    7 +++++++
 kernel/relay.c        |   30 ++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

--- a/include/linux/relay.h~relayfs-introduce-getting-relayfs-statistics-function
+++ a/include/linux/relay.h
@@ -31,6 +31,12 @@
 /*
  * Relay buffer statistics
  */
+enum {
+	RELAY_STATS_BUF_FULL = (1 << 0),
+
+	RELAY_STATS_LAST = RELAY_STATS_BUF_FULL,
+};
+
 struct rchan_buf_stats
 {
 	unsigned int full_count;	/* counter for buffer full */
@@ -167,6 +173,7 @@ struct rchan *relay_open(const char *bas
 			 void *private_data);
 extern void relay_close(struct rchan *chan);
 extern void relay_flush(struct rchan *chan);
+size_t relay_stats(struct rchan *chan, int flags);
 extern void relay_subbufs_consumed(struct rchan *chan,
 				   unsigned int cpu,
 				   size_t consumed);
--- a/kernel/relay.c~relayfs-introduce-getting-relayfs-statistics-function
+++ a/kernel/relay.c
@@ -701,6 +701,36 @@ void relay_flush(struct rchan *chan)
 EXPORT_SYMBOL_GPL(relay_flush);
 
 /**
+ *	relay_stats - get channel buffer statistics
+ *	@chan: the channel
+ *	@flags: select particular information to get
+ *
+ *	Returns the count of certain field that caller specifies.
+ */
+size_t relay_stats(struct rchan *chan, int flags)
+{
+	unsigned int i, count = 0;
+	struct rchan_buf *rbuf;
+
+	if (!chan || flags > RELAY_STATS_LAST)
+		return 0;
+
+	if (chan->is_global) {
+		rbuf = *per_cpu_ptr(chan->buf, 0);
+		if (flags & RELAY_STATS_BUF_FULL)
+			count = rbuf->stats.full_count;
+	} else {
+		for_each_online_cpu(i) {
+			rbuf = *per_cpu_ptr(chan->buf, i);
+			if (rbuf && flags & RELAY_STATS_BUF_FULL)
+				count += rbuf->stats.full_count;
+		}
+	}
+
+	return count;
+}
+
+/**
  *	relay_file_open - open file op for relay files
  *	@inode: the inode
  *	@filp: the file
_

Patches currently in -mm which might be from kernelxing@tencent.com are


