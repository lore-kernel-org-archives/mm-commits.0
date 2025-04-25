Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B178BE5;
	Fri, 25 Apr 2025 00:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745542734; cv=none; b=HXaCN3C/3M2npvc/JCh1lA9WZN0jCOszbX7ctcWbbcAALLvTnH5xFYIdkaL6C6Qa3yic3eiKoUOgTcknTdRfxXOQugAoG908VKIAd8s8af1yJ/JqmlAnIex0WEt9XeHmQaDVSXjqljAsioB674aIgtjfzOxgRAIzRqgcuKQD9zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745542734; c=relaxed/simple;
	bh=JqDE5OV8P6WOTWsr+h/b5Gh5Hzv1wAao/sjJhgjV8j4=;
	h=Date:To:From:Subject:Message-Id; b=JYc4zZUePSfQNDUQtqypGnok8sFfGjD8UouZvcAcuX4xnWGOUAkOyTeqxuUezTfYOHKBaciUImGim0v5wGsDBwlpWMywaenuiwZ0Spf0Jn4BnyWdSWiLCC57IaVmS9aGWMvtRlcCrU1UvHnLz0yNyeCP5mHLz1ppLMDXIsOcv3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jqw5UnY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jqw5UnY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA516C4CEE3;
	Fri, 25 Apr 2025 00:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745542733;
	bh=JqDE5OV8P6WOTWsr+h/b5Gh5Hzv1wAao/sjJhgjV8j4=;
	h=Date:To:From:Subject:From;
	b=Jqw5UnY/kWo0pfpmA4ZbpVBzimd4iyBu2JMp1By6bbkeK/apsEllrr25b/le99Yl0
	 lsmWII2lJP0oUFSPgjEiQ3RG5axd5jj5pjDggUJV09cySJOQkaEQ65981p2r2b1zgc
	 Wfr1oYX7DvLGSwhiuPzD3kCgjqh5MVoqBk/dy6Hg=
Date: Thu, 24 Apr 2025 17:58:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,qq282012236@gmail.com,peterx@redhat.com,hannes@cmpxchg.org,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-prevent-busy-looping-for-tasks-with-signals-pending.patch added to mm-hotfixes-unstable branch
Message-Id: <20250425005853.CA516C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/userfaultfd: prevent busy looping for tasks with signals pending
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-userfaultfd-prevent-busy-looping-for-tasks-with-signals-pending.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-prevent-busy-looping-for-tasks-with-signals-pending.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-userfaultfd-prevent-busy-looping-for-tasks-with-signals-pending.patch

