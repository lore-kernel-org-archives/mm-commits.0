Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0763C48BDF
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 21:33:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7E93613E3
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 21:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhFJVfa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Jun 2021 17:35:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230334AbhFJVf3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 10 Jun 2021 17:35:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23A22613E3;
        Thu, 10 Jun 2021 21:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623360801;
        bh=qxBe7vBg3mlgJFU8DvHsO1W/tRBQ8EbjOo7GSHnniiw=;
        h=Date:From:To:Subject:From;
        b=UsbbZc5oHxlvuBhaQEbZq3chQIqIEXY9XpG0q6ayZ15LosFykXFKJkkMSlWi8V/9G
         OBamyydYZPb0RuiOypRRwiQEQRsTDiKY9yWlUX55VMtNVQkSv3NyGwIoOqkrlr94qB
         1xEB16rvQTotn+3Iutz73ixl2xLcbn8CI5iqAXS0=
Date:   Thu, 10 Jun 2021 14:33:20 -0700
From:   akpm@linux-foundation.org
To:     jenhaochen@google.com, liumartin@google.com, minchan@google.com,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, oleg@redhat.com, pmladek@suse.com,
        tj@kernel.org
Subject:  +
 =?US-ASCII?Q?kthread-prevent-deadlock-when-kthread=5Fmod=5Fdelayed=5Fwo?=
 =?US-ASCII?Q?rk-races-with-kthread=5Fcancel=5Fdelayed=5Fwork=5Fsync.p?=
 =?US-ASCII?Q?atch?= added to -mm tree
Message-ID: <20210610213320.50qQNZhnf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: prevent deadlock when kthread_mod_delayed_work() races with kthread_cancel_delayed_work_sync()
has been added to the -mm tree.  Its filename is
     kthread-prevent-deadlock-when-kthread_mod_delayed_work-races-with-kthread_cancel_delayed_work_sync.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kthread-prevent-deadlock-when-kthread_mod_delayed_work-races-with-kthread_cancel_delayed_work_sync.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kthread-prevent-deadlock-when-kthread_mod_delayed_work-races-with-kthread_cancel_delayed_work_sync.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: kthread: prevent deadlock when kthread_mod_delayed_work() races with kthread_cancel_delayed_work_sync()

The system might hang with the following backtrace:

	schedule+0x80/0x100
	schedule_timeout+0x48/0x138
	wait_for_common+0xa4/0x134
	wait_for_completion+0x1c/0x2c
	kthread_flush_work+0x114/0x1cc
	kthread_cancel_work_sync.llvm.16514401384283632983+0xe8/0x144
	kthread_cancel_delayed_work_sync+0x18/0x2c
	xxxx_pm_notify+0xb0/0xd8
	blocking_notifier_call_chain_robust+0x80/0x194
	pm_notifier_call_chain_robust+0x28/0x4c
	suspend_prepare+0x40/0x260
	enter_state+0x80/0x3f4
	pm_suspend+0x60/0xdc
	state_store+0x108/0x144
	kobj_attr_store+0x38/0x88
	sysfs_kf_write+0x64/0xc0
	kernfs_fop_write_iter+0x108/0x1d0
	vfs_write+0x2f4/0x368
	ksys_write+0x7c/0xec

It is caused by the following race between kthread_mod_delayed_work() and
kthread_cancel_delayed_work_sync():

CPU0				CPU1

Context: Thread A		Context: Thread B

kthread_mod_delayed_work()
  spin_lock()
  __kthread_cancel_work()
     spin_unlock()
     del_timer_sync()
				kthread_cancel_delayed_work_sync()
				  spin_lock()
				  __kthread_cancel_work()
				    spin_unlock()
				    del_timer_sync()
				    spin_lock()

				  work->canceling++
				  spin_unlock
     spin_lock()
   queue_delayed_work()
     // dwork is put into the worker->delayed_work_list

   spin_unlock()

				  kthread_flush_work()
     // flush_work is put at the tail of the dwork

				    wait_for_completion()

Context: IRQ

  kthread_delayed_work_timer_fn()
    spin_lock()
    list_del_init(&work->node);
    spin_unlock()

BANG: flush_work is not longer linked and will never get proceed.

The problem is that kthread_mod_delayed_work() checks work->canceling flag
before canceling the timer.

A simple solution is to (re)check work->canceling after
__kthread_cancel_work().  But then it is not clear what should be returned
when __kthread_cancel_work() removed the work from the queue (list) and it
can't queue it again with the new @delay.

The return value might be used for reference counting.  The caller has to
know whether a new work has been queued or an existing one was replaced.

The proper solution is that kthread_mod_delayed_work() will remove the
work from the queue (list) _only_ when work->canceling is not set.  The
flag must be checked after the timer is stopped and the remaining
operations can be done under worker->lock.

Note that kthread_mod_delayed_work() could remove the timer and then bail
out.  It is fine.  The other canceling caller needs to cancel the timer as
well.  The important thing is that the queue (list) manipulation is done
atomically under worker->lock.

Link: https://lkml.kernel.org/r/20210610133051.15337-3-pmladek@suse.com
Fixes: 9a6b06c8d9a220860468a ("kthread: allow to modify delayed kthread work")
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reported-by: Martin Liu <liumartin@google.com>
Cc: <jenhaochen@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

--- a/kernel/kthread.c~kthread-prevent-deadlock-when-kthread_mod_delayed_work-races-with-kthread_cancel_delayed_work_sync
+++ a/kernel/kthread.c
@@ -1120,8 +1120,11 @@ static void kthread_cancel_delayed_work_
 }
 
 /*
- * This function removes the work from the worker queue. Also it makes sure
- * that it won't get queued later via the delayed work's timer.
+ * This function removes the work from the worker queue.
+ *
+ * It is called under worker->lock. The caller must make sure that
+ * the timer used by delayed work is not running, e.g. by calling
+ * kthread_cancel_delayed_work_timer().
  *
  * The work might still be in use when this function finishes. See the
  * current_work proceed by the worker.
@@ -1129,13 +1132,8 @@ static void kthread_cancel_delayed_work_
  * Return: %true if @work was pending and successfully canceled,
  *	%false if @work was not pending
  */
-static bool __kthread_cancel_work(struct kthread_work *work, bool is_dwork,
-				  unsigned long *flags)
+static bool __kthread_cancel_work(struct kthread_work *work)
 {
-	/* Try to cancel the timer if exists. */
-	if (is_dwork)
-		kthread_cancel_delayed_work_timer(work, flags);
-
 	/*
 	 * Try to remove the work from a worker list. It might either
 	 * be from worker->work_list or from worker->delayed_work_list.
@@ -1188,11 +1186,23 @@ bool kthread_mod_delayed_work(struct kth
 	/* Work must not be used with >1 worker, see kthread_queue_work() */
 	WARN_ON_ONCE(work->worker != worker);
 
-	/* Do not fight with another command that is canceling this work. */
+	/*
+	 * Temporary cancel the work but do not fight with another command
+	 * that is canceling the work as well.
+	 *
+	 * It is a bit tricky because of possible races with another
+	 * mod_delayed_work() and cancel_delayed_work() callers.
+	 *
+	 * The timer must be canceled first because worker->lock is released
+	 * when doing so. But the work can be removed from the queue (list)
+	 * only when it can be queued again so that the return value can
+	 * be used for reference counting.
+	 */
+	kthread_cancel_delayed_work_timer(work, &flags);
 	if (work->canceling)
 		goto out;
+	ret = __kthread_cancel_work(work);
 
-	ret = __kthread_cancel_work(work, true, &flags);
 fast_queue:
 	__kthread_queue_delayed_work(worker, dwork, delay);
 out:
@@ -1214,7 +1224,10 @@ static bool __kthread_cancel_work_sync(s
 	/* Work must not be used with >1 worker, see kthread_queue_work(). */
 	WARN_ON_ONCE(work->worker != worker);
 
-	ret = __kthread_cancel_work(work, is_dwork, &flags);
+	if (is_dwork)
+		kthread_cancel_delayed_work_timer(work, &flags);
+
+	ret = __kthread_cancel_work(work);
 
 	if (worker->current_work != work)
 		goto out_fast;
_

Patches currently in -mm which might be from pmladek@suse.com are

kthread_worker-split-code-for-canceling-the-delayed-work-timer.patch
kthread-prevent-deadlock-when-kthread_mod_delayed_work-races-with-kthread_cancel_delayed_work_sync.patch
kthread_worker-fix-return-value-when-kthread_mod_delayed_work-races-with-kthread_cancel_delayed_work_sync.patch

