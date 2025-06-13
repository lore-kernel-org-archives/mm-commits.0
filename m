Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF7B24DD0B
	for <mm-commits@vger.kernel.org>; Fri, 13 Jun 2025 03:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749784018; cv=none; b=mAKwDLT5a9q8cYUBHFrMB8XVeRsRtnUfYz2jggV0Qj0ix+O8PzK9MPYL6bMauNFZknL1XpHQ93O5jnM45X3I19beTaW2T4vhaT2J6jeW96DAFrfQtF673RdXZ7HvqUztQPJoE4EsvjDHomNJyDUzpGBpZeTaNBarQVKN01+KIvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749784018; c=relaxed/simple;
	bh=nU2t9UodeR1XLmU6Hc3U/iMgqTNUkPckauLRnjoPxwQ=;
	h=Date:To:From:Subject:Message-Id; b=JUcXWZIkhHidW57qaON1pJ29cmMw0WiwPW/adJm88ZKsvFq763ADXTeBu0KnQtY0ktW8jL/F1VaCgk1zl9phMlNKGZ2z3WN9MDJCsJljF4oYmJ2vmDwVPErgjjDZqBxtk9s28vz0nwIZ0E90M16IPPzslWuP9HFTQW3oS45G0KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KZUee+Er; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KZUee+Er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B515BC4CEEA;
	Fri, 13 Jun 2025 03:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749784017;
	bh=nU2t9UodeR1XLmU6Hc3U/iMgqTNUkPckauLRnjoPxwQ=;
	h=Date:To:From:Subject:From;
	b=KZUee+ErTvcxHHJCXyLatrHWZlm7FuK6LJ78StYTMZB2zi5szki4NNgtSxAFokQjk
	 9blTyXuqE/lGK8vw8rkvxKg7RUXgtmCfcn9yw93RjH2FLBUh8PTKnKeKyq5fZS9nGV
	 FIWVaCLH+J6WD9zXkNi2FsjtAjhJCDNUvUg5ggGo=
Date: Thu, 12 Jun 2025 20:06:57 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,katrinzhou@tencent.com,axboe@kernel.dk,kernelxing@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + relayfs-support-a-counter-tracking-if-per-cpu-buffers-is-full.patch added to mm-nonmm-unstable branch
Message-Id: <20250613030657.B515BC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: relayfs: support a counter tracking if per-cpu buffers is full
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     relayfs-support-a-counter-tracking-if-per-cpu-buffers-is-full.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/relayfs-support-a-counter-tracking-if-per-cpu-buffers-is-full.patch

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
Subject: relayfs: support a counter tracking if per-cpu buffers is full
Date: Thu, 12 Jun 2025 14:11:58 +0800

When using relay mechanism, we often encounter the case where new data are
lost or old unconsumed data are overwritten because of slow reader.

Add 'full' field in per-cpu buffer structure to detect if the above case
is happening.  Relay has two modes: 1) non-overwrite mode, 2) overwrite
mode.  So buffer being full here respectively means: 1) relayfs doesn't
intend to accept new data and then simply drop them, or 2) relayfs is
going to start over again and overwrite old unread data with new data.

Note: this counter doesn't need any explicit lock to protect from being
modified by different threads for the better performance consideration. 
Writers calling __relay_write/relay_write should consider how to use the
lock and ensure it performs under the lock protection, thus it's not
necessary to add a new small lock here.

Link: https://lkml.kernel.org/r/20250612061201.34272-3-kerneljasonxing@gmail.com
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Yushan Zhou <katrinzhou@tencent.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/relay.h |    9 +++++++++
 kernel/relay.c        |    8 +++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/include/linux/relay.h~relayfs-support-a-counter-tracking-if-per-cpu-buffers-is-full
+++ a/include/linux/relay.h
@@ -29,6 +29,14 @@
 #define RELAYFS_CHANNEL_VERSION		7
 
 /*
+ * Relay buffer statistics
+ */
+struct rchan_buf_stats
+{
+	unsigned int full_count;	/* counter for buffer full */
+};
+
+/*
  * Per-cpu relay channel buffer
  */
 struct rchan_buf
@@ -43,6 +51,7 @@ struct rchan_buf
 	struct irq_work wakeup_work;	/* reader wakeup */
 	struct dentry *dentry;		/* channel file dentry */
 	struct kref kref;		/* channel buffer refcount */
+	struct rchan_buf_stats stats;	/* buffer stats */
 	struct page **page_array;	/* array of current buffer pages */
 	unsigned int page_count;	/* number of current buffer pages */
 	unsigned int finalized;		/* buffer has been finalized */
--- a/kernel/relay.c~relayfs-support-a-counter-tracking-if-per-cpu-buffers-is-full
+++ a/kernel/relay.c
@@ -251,8 +251,13 @@ EXPORT_SYMBOL_GPL(relay_buf_full);
 static int relay_subbuf_start(struct rchan_buf *buf, void *subbuf,
 			      void *prev_subbuf)
 {
+	int full = relay_buf_full(buf);
+
+	if (full)
+		buf->stats.full_count++;
+
 	if (!buf->chan->cb->subbuf_start)
-		return !relay_buf_full(buf);
+		return !full;
 
 	return buf->chan->cb->subbuf_start(buf, subbuf,
 					   prev_subbuf);
@@ -297,6 +302,7 @@ static void __relay_reset(struct rchan_b
 	buf->finalized = 0;
 	buf->data = buf->start;
 	buf->offset = 0;
+	buf->stats.full_count = 0;
 
 	for (i = 0; i < buf->chan->n_subbufs; i++)
 		buf->padding[i] = 0;
_

Patches currently in -mm which might be from kernelxing@tencent.com are

relayfs-abolish-prev_padding.patch
relayfs-support-a-counter-tracking-if-per-cpu-buffers-is-full.patch
relayfs-introduce-getting-relayfs-statistics-function.patch
blktrace-use-rbuf-statsfull-as-a-drop-indicator-in-relayfs.patch
relayfs-support-a-counter-tracking-if-data-is-too-big-to-write.patch

