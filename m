Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD65828643B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127157; cv=none; b=SGkZL3C97HSYfe/ua5zxT2eoOq2sTQB5TKLeKj1U5uHO9gOh9WdTl28IDo2HiX5YAqdsfoCX7czNUdOFxEkPNTJeIFqVQVTlwyQ+EaM26KrSui/6Nte+dYdgWms0hAuMpcpM0l6PxcugWXpwDg54DEIYLrm5XqDQw4xxeBfO2rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127157; c=relaxed/simple;
	bh=fvCWXrRF+ic+/90uxaYOgsmSlW1XNEkUNxR4JhHI/V4=;
	h=Date:To:From:Subject:Message-Id; b=JnJSpJ5kx+CRFUT4+vJkr4K2S+Cpn4XuWU7tS58SkSftruRQNVuN4aK8wdZ346MvEwSnoOlOJHuqIq/D6PEfZJXrK66ZVZq3zF+dGS7hWO+iI5Zhrf0W1wurR8sn7gX3dqzsNNCyz1UfAPZO/iOb8XpbI5RjAwSW9JQ8Lw+DN9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pCNJEC5Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pCNJEC5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799BCC4CEE3;
	Thu, 10 Jul 2025 05:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127157;
	bh=fvCWXrRF+ic+/90uxaYOgsmSlW1XNEkUNxR4JhHI/V4=;
	h=Date:To:From:Subject:From;
	b=pCNJEC5QNsyypm6OrKNduQzXbdjHILiekel7dIHqTG4uO/lzmeJ6FgKkxpM3oUf/F
	 N1mQQAtcbNc7gycbHrNqntL5AhilAo6r4RLoCFZowP+UVLR5VujT2vaC6yOXOFP4JM
	 a8GGfyf2V4HzopcPXb4OH++yqCUKG0vXM7SlR3kE=
Date: Wed, 09 Jul 2025 22:59:16 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,katrinzhou@tencent.com,axboe@kernel.dk,kernelxing@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] blktrace-use-rbuf-statsfull-as-a-drop-indicator-in-relayfs.patch removed from -mm tree
Message-Id: <20250710055917.799BCC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: blktrace: use rbuf->stats.full as a drop indicator in relayfs
has been removed from the -mm tree.  Its filename was
     blktrace-use-rbuf-statsfull-as-a-drop-indicator-in-relayfs.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jason Xing <kernelxing@tencent.com>
Subject: blktrace: use rbuf->stats.full as a drop indicator in relayfs
Date: Thu, 12 Jun 2025 14:12:00 +0800

Replace internal subbuf_start in blktrace with the default policy in
relayfs.

Remove dropped field from struct blktrace.  Correspondingly, call the
common helper in relay.  By incrementing full_count to keep track of how
many times we encountered a full buffer issue, user space will know how
many events were lost.

Link: https://lkml.kernel.org/r/20250612061201.34272-5-kerneljasonxing@gmail.com
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Yushan Zhou <katrinzhou@tencent.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/blktrace.c |   22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

--- a/kernel/trace/blktrace.c~blktrace-use-rbuf-statsfull-as-a-drop-indicator-in-relayfs
+++ a/kernel/trace/blktrace.c
@@ -415,9 +415,10 @@ static ssize_t blk_dropped_read(struct f
 				size_t count, loff_t *ppos)
 {
 	struct blk_trace *bt = filp->private_data;
+	size_t dropped = relay_stats(bt->rchan, RELAY_STATS_BUF_FULL);
 	char buf[16];
 
-	snprintf(buf, sizeof(buf), "%u\n", atomic_read(&bt->dropped));
+	snprintf(buf, sizeof(buf), "%zu\n", dropped);
 
 	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
 }
@@ -456,23 +457,6 @@ static const struct file_operations blk_
 	.llseek =	noop_llseek,
 };
 
-/*
- * Keep track of how many times we encountered a full subbuffer, to aid
- * the user space app in telling how many lost events there were.
- */
-static int blk_subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
-				     void *prev_subbuf)
-{
-	struct blk_trace *bt;
-
-	if (!relay_buf_full(buf))
-		return 1;
-
-	bt = buf->chan->private_data;
-	atomic_inc(&bt->dropped);
-	return 0;
-}
-
 static int blk_remove_buf_file_callback(struct dentry *dentry)
 {
 	debugfs_remove(dentry);
@@ -491,7 +475,6 @@ static struct dentry *blk_create_buf_fil
 }
 
 static const struct rchan_callbacks blk_relay_callbacks = {
-	.subbuf_start		= blk_subbuf_start_callback,
 	.create_buf_file	= blk_create_buf_file_callback,
 	.remove_buf_file	= blk_remove_buf_file_callback,
 };
@@ -580,7 +563,6 @@ static int do_blk_trace_setup(struct req
 	}
 
 	bt->dev = dev;
-	atomic_set(&bt->dropped, 0);
 	INIT_LIST_HEAD(&bt->running_list);
 
 	ret = -EIO;
_

Patches currently in -mm which might be from kernelxing@tencent.com are


