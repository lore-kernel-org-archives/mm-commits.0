Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07EB3C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E381761C72
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbhGFTKv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231803AbhGFTKs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:10:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A544A61C6D;
        Tue,  6 Jul 2021 19:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598489;
        bh=yJ0ULh2eZsV92yIBXJ7og2cba3CbLHEjyH15SCCL/6Q=;
        h=Date:From:To:Subject:From;
        b=cq72LEAcf9nOmjlUoFxJL8XQ+3h+ge7XoM0N+pLDq713OH2lC1WtvNe/d9RZGnZD8
         fUxPzztXdOLjLLIp9GWFj6HbC20KJt4p9Wd2z1Hs7BCBUTk7bsFrzkc1E4PHUyVn4Z
         iXWuIdgoK2yDlnBtSa+456HkjVrBi4kXl1nz++UE=
Date:   Tue, 06 Jul 2021 12:08:09 -0700
From:   akpm@linux-foundation.org
To:     jenhaochen@google.com, liumartin@google.com, minchan@google.com,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, oleg@redhat.com, pmladek@suse.com,
        tj@kernel.org
Subject:  [merged]
 =?US-ASCII?Q?kthread=5Fworker-fix-return-value-when-kthread=5Fmod=5Fde?=
 =?US-ASCII?Q?layed=5Fwork-races-with-kthread=5Fcancel=5Fdelayed=5Fwor?=
 =?US-ASCII?Q?k=5Fsync.patch?= removed from -mm tree
Message-ID: <20210706190809.InyrhGk0i%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kthread_worker: fix return value when kthread_mod_delayed_work() races with kthread_cancel_delayed_work_sync()
has been removed from the -mm tree.  Its filename was
     kthread_worker-fix-return-value-when-kthread_mod_delayed_work-races-with-kthread_cancel_delayed_work_sync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: kthread_worker: fix return value when kthread_mod_delayed_work() races with kthread_cancel_delayed_work_sync()

kthread_mod_delayed_work() might race with
kthread_cancel_delayed_work_sync() or another kthread_mod_delayed_work()
call.  The function lets the other operation win when it sees
work->canceling counter set.  And it returns @false.

But it should return @true as it is done by the related workqueue API, see
mod_delayed_work_on().

The reason is that the return value might be used for reference counting. 
It has to distinguish the case when the number of queued works has changed
or stayed the same.

The change is safe.  kthread_mod_delayed_work() return value is not
checked anywhere at the moment.

Link: https://lore.kernel.org/r/20210521163526.GA17916@redhat.com
Link: https://lkml.kernel.org/r/20210610133051.15337-4-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Minchan Kim <minchan@google.com>
Cc: <jenhaochen@google.com>
Cc: Martin Liu <liumartin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/kernel/kthread.c~kthread_worker-fix-return-value-when-kthread_mod_delayed_work-races-with-kthread_cancel_delayed_work_sync
+++ a/kernel/kthread.c
@@ -1156,14 +1156,14 @@ static bool __kthread_cancel_work(struct
  * modify @dwork's timer so that it expires after @delay. If @delay is zero,
  * @work is guaranteed to be queued immediately.
  *
- * Return: %true if @dwork was pending and its timer was modified,
- * %false otherwise.
+ * Return: %false if @dwork was idle and queued, %true otherwise.
  *
  * A special case is when the work is being canceled in parallel.
  * It might be caused either by the real kthread_cancel_delayed_work_sync()
  * or yet another kthread_mod_delayed_work() call. We let the other command
- * win and return %false here. The caller is supposed to synchronize these
- * operations a reasonable way.
+ * win and return %true here. The return value can be used for reference
+ * counting and the number of queued works stays the same. Anyway, the caller
+ * is supposed to synchronize these operations a reasonable way.
  *
  * This function is safe to call from any context including IRQ handler.
  * See __kthread_cancel_work() and kthread_delayed_work_timer_fn()
@@ -1175,13 +1175,15 @@ bool kthread_mod_delayed_work(struct kth
 {
 	struct kthread_work *work = &dwork->work;
 	unsigned long flags;
-	int ret = false;
+	int ret;
 
 	raw_spin_lock_irqsave(&worker->lock, flags);
 
 	/* Do not bother with canceling when never queued. */
-	if (!work->worker)
+	if (!work->worker) {
+		ret = false;
 		goto fast_queue;
+	}
 
 	/* Work must not be used with >1 worker, see kthread_queue_work() */
 	WARN_ON_ONCE(work->worker != worker);
@@ -1199,8 +1201,11 @@ bool kthread_mod_delayed_work(struct kth
 	 * be used for reference counting.
 	 */
 	kthread_cancel_delayed_work_timer(work, &flags);
-	if (work->canceling)
+	if (work->canceling) {
+		/* The number of works in the queue does not change. */
+		ret = true;
 		goto out;
+	}
 	ret = __kthread_cancel_work(work);
 
 fast_queue:
_

Patches currently in -mm which might be from pmladek@suse.com are


