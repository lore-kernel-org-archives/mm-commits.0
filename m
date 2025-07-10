Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4574F28643B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127155; cv=none; b=GeZHVtckgeCU0oAjyc2DCcPghGJ7GzdoKiub5gebL+Kav79t62Ocih25yD4qVVixEhdVfwdY/RJ7SuxzTtxjCQaukd+bvUXDis0oE/COp+7nRRgmOx2hDVOVIttNUb1wEqC5HSjHmB42b/uwDWWLAMU/3G4FyGBEmg2S5eft3Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127155; c=relaxed/simple;
	bh=qM2Hvyf2W7BCwxS+gAoBb2TqnrxxefTek8mTyGb16VA=;
	h=Date:To:From:Subject:Message-Id; b=JgNhFoSLNQBWU8UKs8PZyi3WZ7pFcBhfLTouNkaHb2nsLfoMwy3wsPuetMOxhFuoy/4r5XOauV/ggT+4w5rb9FslLePtYzhkdkqvc+V+l0XeFuxyot0bKnbc/tc3IBDOmyy+QY8Ysk/WORPt9QUxG0K+STdpaKGnEuo3hmNbDTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iFilwr3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iFilwr3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A81C4CEE3;
	Thu, 10 Jul 2025 05:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127155;
	bh=qM2Hvyf2W7BCwxS+gAoBb2TqnrxxefTek8mTyGb16VA=;
	h=Date:To:From:Subject:From;
	b=iFilwr3LYn9yD7CQcwxld42AS3zhVGABzp6RyBFF4EwHk6xMrPnm8ucZAjZWdSTJD
	 com6cHBMnlGVXsQ9bytl+FSd7iaYLAjT4/LFx1axfaqgr9OQq9n9CRh7uPPhH0Tcfl
	 ChkFsNGbHIl5iaiu+EKuvH1ftLzrjjj5LYlXmags=
Date: Wed, 09 Jul 2025 22:59:14 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,katrinzhou@tencent.com,axboe@kernel.dk,kernelxing@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] relayfs-support-a-counter-tracking-if-per-cpu-buffers-is-full.patch removed from -mm tree
Message-Id: <20250710055915.17A81C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: relayfs: support a counter tracking if per-cpu buffers is full
has been removed from the -mm tree.  Its filename was
     relayfs-support-a-counter-tracking-if-per-cpu-buffers-is-full.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


