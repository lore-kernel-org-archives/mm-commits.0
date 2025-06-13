Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CC9253350
	for <mm-commits@vger.kernel.org>; Fri, 13 Jun 2025 03:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749784023; cv=none; b=X3WOPf0G8xJ2D18C87apY4yUvTdUkIp9QjnXVvOSM3b3HKLAL+Fu/nVYh12tflVoe/poF8Vtll9GVdNfQ8quRy4UB57hisXUqvAC4KteVGe2na67VKftHyiJ+OBAyjYE0zsHP8cpkUZX7uTToH6fWogOwdiYWzVMaBffmT2b7IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749784023; c=relaxed/simple;
	bh=wQvagOK+7A+npYQQroer5Gi8MW/hOPMx6z1kmmJGjqw=;
	h=Date:To:From:Subject:Message-Id; b=SiO7amgew5xSLIBAwibMgcXU/fSf9f//kElfJHZ6d76eqwvhYyXI6QlaSX+VhM+uU8Ua/WuDwcW074/djT3ul6xP2pB4zb+RH/w4f08l56DpkF4Cn1ni6aceLwdHrNE6GxlUCjDLcpnuCrAV5lMTuCyDLSKxbf6KJQszArHiLJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oz2zl/ZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oz2zl/ZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B05DC4CEEA;
	Fri, 13 Jun 2025 03:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749784022;
	bh=wQvagOK+7A+npYQQroer5Gi8MW/hOPMx6z1kmmJGjqw=;
	h=Date:To:From:Subject:From;
	b=Oz2zl/ZV2Wi2793etV8dXc77k1QuDzMw79cRvp+16uZw9CQp9Trwzs2cHvqA0EMOe
	 lZrGRtvYnoxUibsQXNWzvX1W864iipTnnLsdLInBHWjDFNETdOfboZTl5f3gnLtvaB
	 E7UV4wUVUxo9yRaBf9WIUx6UKAAfe6fwVoqi+qwE=
Date: Thu, 12 Jun 2025 20:07:01 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,katrinzhou@tencent.com,axboe@kernel.dk,kernelxing@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + blktrace-use-rbuf-statsfull-as-a-drop-indicator-in-relayfs.patch added to mm-nonmm-unstable branch
Message-Id: <20250613030702.9B05DC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: blktrace: use rbuf->stats.full as a drop indicator in relayfs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     blktrace-use-rbuf-statsfull-as-a-drop-indicator-in-relayfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/blktrace-use-rbuf-statsfull-as-a-drop-indicator-in-relayfs.patch

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

relayfs-abolish-prev_padding.patch
relayfs-support-a-counter-tracking-if-per-cpu-buffers-is-full.patch
relayfs-introduce-getting-relayfs-statistics-function.patch
blktrace-use-rbuf-statsfull-as-a-drop-indicator-in-relayfs.patch
relayfs-support-a-counter-tracking-if-data-is-too-big-to-write.patch

