Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B27F2DC799;
	Thu,  1 May 2025 18:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746122620; cv=none; b=oRTh9HMbDYNb9OSa6B396U1YLLBSXwz3uZRE6hy5MTZeSxn11CPjUAD1u/jZI/Og6P282NuRba+Haf2v9lZzktq9xQnVGmK5mzfm2ng49LVi4u5O6OaseZOvlT8A0h88uqtIsw00F1ZRjMAGPu5VVWIdTBg5nrpfYHA8RfIvG+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746122620; c=relaxed/simple;
	bh=7Nslu/VuTL9px1pHd82ENo2ZmtoJ6voVF3llkTvMou0=;
	h=Date:To:From:Subject:Message-Id; b=uY9TTGpGCUu+aSrwAG+LoqmHLiGmjoxVL0cEpilJx6BtmGCaIZdcjsZqjCm7nIK7PNcqNuEktNSRZbyEmFQUoPOwaGLpjrDONZXXrOTCuf7hfBCppK3KpwROqFy+W8/KH0Tpyi0l90WOsNmimWfBXEaTDj/7uYrDyuwXsVSjySc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O7o2bzFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O7o2bzFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA43C4CEE9;
	Thu,  1 May 2025 18:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746122619;
	bh=7Nslu/VuTL9px1pHd82ENo2ZmtoJ6voVF3llkTvMou0=;
	h=Date:To:From:Subject:From;
	b=O7o2bzFIMwdv8hd/tq2nYC6QH2tfm+wh3M0YletHUX+afEh2zaGGT8scOjmAtbTtC
	 2v5djcGejerv+BotLbuFTq0WRdHK0R8xj21f8C0z2Yj7TPTj8O7Th7R32Xz25f7hxs
	 M4gU1sCNAHbuRuaqmiUvgX0Dg+N3OWIf7UhSIXbI=
Date: Thu, 01 May 2025 11:03:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,qq282012236@gmail.com,peterx@redhat.com,hannes@cmpxchg.org,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-userfaultfd-prevent-busy-looping-for-tasks-with-signals-pending.patch removed from -mm tree
Message-Id: <20250501180339.BCA43C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/userfaultfd: prevent busy looping for tasks with signals pending
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-prevent-busy-looping-for-tasks-with-signals-pending.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Jens Axboe <axboe@kernel.dk>
Subject: mm/userfaultfd: prevent busy looping for tasks with signals pending
Date: Wed, 23 Apr 2025 17:37:06 -0600

userfaultfd may use interruptible sleeps to wait on userspace filling a
page fault, which works fine if the task can be reliably put to sleeping
waiting for that.  However, if the task has a normal (ie non-fatal) signal
pending, then TASK_INTERRUPTIBLE sleep will simply cause schedule() to be
a no-op.

For a task that registers a page with userfaultfd and then proceeds to do
a write from it, if that task also has a signal pending then it'll
essentially busy loop from do_page_fault() -> handle_userfault() until
that fault has been filled.  Normally it'd be expected that the task would
sleep until that happens.  Here's a trace from an application doing just
that:

handle_userfault+0x4b8/0xa00 (P)
hugetlb_fault+0xe24/0x1060
handle_mm_fault+0x2bc/0x318
do_page_fault+0x1e8/0x6f0
do_translation_fault+0x9c/0xd0
do_mem_abort+0x44/0xa0
el1_abort+0x3c/0x68
el1h_64_sync_handler+0xd4/0x100
el1h_64_sync+0x6c/0x70
fault_in_readable+0x74/0x108 (P)
iomap_file_buffered_write+0x14c/0x438
blkdev_write_iter+0x1a8/0x340
vfs_write+0x20c/0x348
ksys_write+0x64/0x108
__arm64_sys_write+0x1c/0x38

where the task is looping with 100% CPU time in the above mentioned fault
path.

Since it's impossible to handle signals, or other conditions like
TIF_NOTIFY_SIGNAL that also prevents interruptible sleeping, from the
fault path, use TASK_UNINTERRUPTIBLE with a short timeout even for vmf
modes that would normally ask for INTERRUPTIBLE or KILLABLE sleep.  Fatal
signals will still be handled by the caller, and the timeout is short
enough to hopefully not cause any issues.  If this is the first invocation
of this fault, eg FAULT_FLAG_TRIED isn't set, then the normal sleep mode
is used.

Link: https://lkml.kernel.org/r/27c3a7f5-aad8-4f2a-a66e-ff5ae98f31eb@kernel.dk
Fixes: 4064b9827063 ("mm: allow VM_FAULT_RETRY for multiple times")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Reported-by: Zhiwei Jiang <qq282012236@gmail.com>
Closes: https://lore.kernel.org/io-uring/20250422162913.1242057-1-qq282012236@gmail.com/
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

--- a/fs/userfaultfd.c~mm-userfaultfd-prevent-busy-looping-for-tasks-with-signals-pending
+++ a/fs/userfaultfd.c
@@ -334,15 +334,29 @@ out:
 	return ret;
 }
 
-static inline unsigned int userfaultfd_get_blocking_state(unsigned int flags)
+struct userfault_wait {
+	unsigned int task_state;
+	bool timeout;
+};
+
+static struct userfault_wait userfaultfd_get_blocking_state(unsigned int flags)
 {
+	/*
+	 * If the fault has already been tried AND there's a signal pending
+	 * for this task, use TASK_UNINTERRUPTIBLE with a small timeout.
+	 * This prevents busy looping where schedule() otherwise does nothing
+	 * for TASK_INTERRUPTIBLE when the task has a signal pending.
+	 */
+	if ((flags & FAULT_FLAG_TRIED) && signal_pending(current))
+		return (struct userfault_wait) { TASK_UNINTERRUPTIBLE, true };
+
 	if (flags & FAULT_FLAG_INTERRUPTIBLE)
-		return TASK_INTERRUPTIBLE;
+		return (struct userfault_wait) { TASK_INTERRUPTIBLE, false };
 
 	if (flags & FAULT_FLAG_KILLABLE)
-		return TASK_KILLABLE;
+		return (struct userfault_wait) { TASK_KILLABLE, false };
 
-	return TASK_UNINTERRUPTIBLE;
+	return (struct userfault_wait) { TASK_UNINTERRUPTIBLE, false };
 }
 
 /*
@@ -368,7 +382,7 @@ vm_fault_t handle_userfault(struct vm_fa
 	struct userfaultfd_wait_queue uwq;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 	bool must_wait;
-	unsigned int blocking_state;
+	struct userfault_wait wait_mode;
 
 	/*
 	 * We don't do userfault handling for the final child pid update
@@ -466,7 +480,7 @@ vm_fault_t handle_userfault(struct vm_fa
 	uwq.ctx = ctx;
 	uwq.waken = false;
 
-	blocking_state = userfaultfd_get_blocking_state(vmf->flags);
+	wait_mode = userfaultfd_get_blocking_state(vmf->flags);
 
         /*
          * Take the vma lock now, in order to safely call
@@ -488,7 +502,7 @@ vm_fault_t handle_userfault(struct vm_fa
 	 * following the spin_unlock to happen before the list_add in
 	 * __add_wait_queue.
 	 */
-	set_current_state(blocking_state);
+	set_current_state(wait_mode.task_state);
 	spin_unlock_irq(&ctx->fault_pending_wqh.lock);
 
 	if (!is_vm_hugetlb_page(vma))
@@ -501,7 +515,11 @@ vm_fault_t handle_userfault(struct vm_fa
 
 	if (likely(must_wait && !READ_ONCE(ctx->released))) {
 		wake_up_poll(&ctx->fd_wqh, EPOLLIN);
-		schedule();
+		/* See comment in userfaultfd_get_blocking_state() */
+		if (!wait_mode.timeout)
+			schedule();
+		else
+			schedule_timeout(HZ / 10);
 	}
 
 	__set_current_state(TASK_RUNNING);
_

Patches currently in -mm which might be from axboe@kernel.dk are


