Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D90C286893
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127154; cv=none; b=PYPsXqWzFaEQEz0Z2vBDQlTImn/S4JDPblZ+fM/KxzZxyjvqKKfSIp7aXGfe96Lj60SYGSLgCBvLp4T36KWpvFq0APprjSipUse2y/s/Z7xe0uEbPDC3yd7xHsBYYvtkI6P57e6qHEh3lXDxzYyjgtRwpMyQ3Av/BD4T2iLWPds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127154; c=relaxed/simple;
	bh=9s+n/pR0TAPgPkHp/PAOe18mh/2Wfn+ovMbjc4jRKdo=;
	h=Date:To:From:Subject:Message-Id; b=tq9f304Bc6ZWuNsQNWwG6EPrLx9OrPUdft3Vjt4me+7yIjAFTa8YFeSQWNCTce6tdJRjj1ZubZPvTeL6gmRwGN49+HnSka9hzl5ca3qpFN/WQNzdkcGwEPxRbkTW066EQk4hVTpMR6CE8N4T038Ypu0pgGTfVnhB7LkjFooEpEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V1UrZq8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V1UrZq8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65D4C4CEE3;
	Thu, 10 Jul 2025 05:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127153;
	bh=9s+n/pR0TAPgPkHp/PAOe18mh/2Wfn+ovMbjc4jRKdo=;
	h=Date:To:From:Subject:From;
	b=V1UrZq8jx1D6wmhR6rKaxatJvmk/JnNAshCPpux/YbrSE+Oj/bvBzutgjydqUQp5Q
	 9l7jTujFG64egApdC7P0ATs5kuj0CUQithm275ZiDkG9EW2d9iO7+xoCislVVfYARE
	 MYFds1ewXcRlmB99MSLN3Za1codsQTS+lWOb3frM=
Date: Wed, 09 Jul 2025 22:59:13 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,katrinzhou@tencent.com,axboe@kernel.dk,kernelxing@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] relayfs-abolish-prev_padding.patch removed from -mm tree
Message-Id: <20250710055913.C65D4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: relayfs: abolish prev_padding
has been removed from the -mm tree.  Its filename was
     relayfs-abolish-prev_padding.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jason Xing <kernelxing@tencent.com>
Subject: relayfs: abolish prev_padding
Date: Thu, 12 Jun 2025 14:11:57 +0800

Patch series "relayfs: misc changes", v5.

The series mostly focuses on the error counters which helps every user
debug their own kernel module.


This patch (of 5):

prev_padding represents the unused space of certain subbuffer.  If the
content of a call of relay_write() exceeds the limit of the remainder of
this subbuffer, it will skip storing in the rest space and record the
start point as buf->prev_padding in relay_switch_subbuf().  Since the buf
is a per-cpu big buffer, the point of prev_padding as a global value for
the whole buffer instead of a single subbuffer (whose padding info is
stored in buf->padding[]) seems meaningless from the real use cases, so we
don't bother to record it any more.

Link: https://lkml.kernel.org/r/20250612061201.34272-1-kerneljasonxing@gmail.com
Link: https://lkml.kernel.org/r/20250612061201.34272-2-kerneljasonxing@gmail.com
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Yushan Zhou <katrinzhou@tencent.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gt/uc/intel_guc_log.c |    3 +--
 drivers/net/wwan/iosm/iosm_ipc_trace.c     |    3 +--
 drivers/net/wwan/t7xx/t7xx_port_trace.c    |    2 +-
 include/linux/relay.h                      |    5 +----
 kernel/relay.c                             |   14 ++++++++------
 kernel/trace/blktrace.c                    |    2 +-
 6 files changed, 13 insertions(+), 16 deletions(-)

--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c~relayfs-abolish-prev_padding
+++ a/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c
@@ -220,8 +220,7 @@ static int guc_action_control_log(struct
  */
 static int subbuf_start_callback(struct rchan_buf *buf,
 				 void *subbuf,
-				 void *prev_subbuf,
-				 size_t prev_padding)
+				 void *prev_subbuf)
 {
 	/*
 	 * Use no-overwrite mode by default, where relay will stop accepting
--- a/drivers/net/wwan/iosm/iosm_ipc_trace.c~relayfs-abolish-prev_padding
+++ a/drivers/net/wwan/iosm/iosm_ipc_trace.c
@@ -51,8 +51,7 @@ static int ipc_trace_remove_buf_file_han
 }
 
 static int ipc_trace_subbuf_start_handler(struct rchan_buf *buf, void *subbuf,
-					  void *prev_subbuf,
-					  size_t prev_padding)
+					  void *prev_subbuf)
 {
 	if (relay_buf_full(buf)) {
 		pr_err_ratelimited("Relay_buf full dropping traces");
--- a/drivers/net/wwan/t7xx/t7xx_port_trace.c~relayfs-abolish-prev_padding
+++ a/drivers/net/wwan/t7xx/t7xx_port_trace.c
@@ -33,7 +33,7 @@ static int t7xx_trace_remove_buf_file_ha
 }
 
 static int t7xx_trace_subbuf_start_handler(struct rchan_buf *buf, void *subbuf,
-					   void *prev_subbuf, size_t prev_padding)
+					   void *prev_subbuf)
 {
 	if (relay_buf_full(buf)) {
 		pr_err_ratelimited("Relay_buf full dropping traces");
--- a/include/linux/relay.h~relayfs-abolish-prev_padding
+++ a/include/linux/relay.h
@@ -47,7 +47,6 @@ struct rchan_buf
 	unsigned int page_count;	/* number of current buffer pages */
 	unsigned int finalized;		/* buffer has been finalized */
 	size_t *padding;		/* padding counts per sub-buffer */
-	size_t prev_padding;		/* temporary variable */
 	size_t bytes_consumed;		/* bytes consumed in cur read subbuf */
 	size_t early_bytes;		/* bytes consumed before VFS inited */
 	unsigned int cpu;		/* this buf's cpu */
@@ -84,7 +83,6 @@ struct rchan_callbacks
 	 * @buf: the channel buffer containing the new sub-buffer
 	 * @subbuf: the start of the new sub-buffer
 	 * @prev_subbuf: the start of the previous sub-buffer
-	 * @prev_padding: unused space at the end of previous sub-buffer
 	 *
 	 * The client should return 1 to continue logging, 0 to stop
 	 * logging.
@@ -100,8 +98,7 @@ struct rchan_callbacks
 	 */
 	int (*subbuf_start) (struct rchan_buf *buf,
 			     void *subbuf,
-			     void *prev_subbuf,
-			     size_t prev_padding);
+			     void *prev_subbuf);
 
 	/*
 	 * create_buf_file - create file to represent a relay channel buffer
--- a/kernel/relay.c~relayfs-abolish-prev_padding
+++ a/kernel/relay.c
@@ -249,13 +249,13 @@ EXPORT_SYMBOL_GPL(relay_buf_full);
  */
 
 static int relay_subbuf_start(struct rchan_buf *buf, void *subbuf,
-			      void *prev_subbuf, size_t prev_padding)
+			      void *prev_subbuf)
 {
 	if (!buf->chan->cb->subbuf_start)
 		return !relay_buf_full(buf);
 
 	return buf->chan->cb->subbuf_start(buf, subbuf,
-					   prev_subbuf, prev_padding);
+					   prev_subbuf);
 }
 
 /**
@@ -301,7 +301,7 @@ static void __relay_reset(struct rchan_b
 	for (i = 0; i < buf->chan->n_subbufs; i++)
 		buf->padding[i] = 0;
 
-	relay_subbuf_start(buf, buf->data, NULL, 0);
+	relay_subbuf_start(buf, buf->data, NULL);
 }
 
 /**
@@ -554,9 +554,11 @@ size_t relay_switch_subbuf(struct rchan_
 		goto toobig;
 
 	if (buf->offset != buf->chan->subbuf_size + 1) {
-		buf->prev_padding = buf->chan->subbuf_size - buf->offset;
+		size_t prev_padding;
+
+		prev_padding = buf->chan->subbuf_size - buf->offset;
 		old_subbuf = buf->subbufs_produced % buf->chan->n_subbufs;
-		buf->padding[old_subbuf] = buf->prev_padding;
+		buf->padding[old_subbuf] = prev_padding;
 		buf->subbufs_produced++;
 		if (buf->dentry)
 			d_inode(buf->dentry)->i_size +=
@@ -581,7 +583,7 @@ size_t relay_switch_subbuf(struct rchan_
 	new_subbuf = buf->subbufs_produced % buf->chan->n_subbufs;
 	new = buf->start + new_subbuf * buf->chan->subbuf_size;
 	buf->offset = 0;
-	if (!relay_subbuf_start(buf, new, old, buf->prev_padding)) {
+	if (!relay_subbuf_start(buf, new, old)) {
 		buf->offset = buf->chan->subbuf_size + 1;
 		return 0;
 	}
--- a/kernel/trace/blktrace.c~relayfs-abolish-prev_padding
+++ a/kernel/trace/blktrace.c
@@ -461,7 +461,7 @@ static const struct file_operations blk_
  * the user space app in telling how many lost events there were.
  */
 static int blk_subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
-				     void *prev_subbuf, size_t prev_padding)
+				     void *prev_subbuf)
 {
 	struct blk_trace *bt;
 
_

Patches currently in -mm which might be from kernelxing@tencent.com are


