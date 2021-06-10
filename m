Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F8BC48BD1
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 21:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4574F613E3
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 21:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhFJVfP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Jun 2021 17:35:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229963AbhFJVfP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 10 Jun 2021 17:35:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D4B66139A;
        Thu, 10 Jun 2021 21:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623360798;
        bh=G3Hpge7GRB5CxKlWK6Yla3eyqs1FjzWkLW35VvLGlZ8=;
        h=Date:From:To:Subject:From;
        b=vWgrtzfG2v/2H1JTPuIYS/RApgegQ6jqZwBcEQsTBUCwK5UzJ3S02E7hdghpEnHlT
         dWFR89tjBRZBmNDUQQMvb4PHsuBAk5HHzPyZHGpFF2oBNLYK0AY4bJCIAaQx2BU4aa
         Flr1vZ2t0ZB7OLmOAEt1/Sku/UbMY1TsmkKHHJKU=
Date:   Thu, 10 Jun 2021 14:33:17 -0700
From:   akpm@linux-foundation.org
To:     jenhaochen@google.com, liumartin@google.com, minchan@google.com,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, oleg@redhat.com, pmladek@suse.com,
        tj@kernel.org
Subject:  +
 kthread_worker-split-code-for-canceling-the-delayed-work-timer.patch added
 to -mm tree
Message-ID: <20210610213317.KNElxHkA5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kthread_worker: split code for canceling the delayed work timer
has been added to the -mm tree.  Its filename is
     kthread_worker-split-code-for-canceling-the-delayed-work-timer.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kthread_worker-split-code-for-canceling-the-delayed-work-timer.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kthread_worker-split-code-for-canceling-the-delayed-work-timer.patch

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
Subject: kthread_worker: split code for canceling the delayed work timer

Patch series "kthread_worker: Fix race between kthread_mod_delayed_work()
and kthread_cancel_delayed_work_sync()".

This patchset fixes the race between kthread_mod_delayed_work() and
kthread_cancel_delayed_work_sync() including proper return value handling.


This patch (of 3):

Simple code refactoring as a preparation step for fixing a race between
kthread_mod_delayed_work() and kthread_cancel_delayed_work_sync().

It does not modify the existing behavior.

Link: https://lkml.kernel.org/r/20210610133051.15337-2-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: <jenhaochen@google.com>
Cc: Martin Liu <liumartin@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   46 ++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

--- a/kernel/kthread.c~kthread_worker-split-code-for-canceling-the-delayed-work-timer
+++ a/kernel/kthread.c
@@ -1093,6 +1093,33 @@ void kthread_flush_work(struct kthread_w
 EXPORT_SYMBOL_GPL(kthread_flush_work);
 
 /*
+ * Make sure that the timer is neither set nor running and could
+ * not manipulate the work list_head any longer.
+ *
+ * The function is called under worker->lock. The lock is temporary
+ * released but the timer can't be set again in the meantime.
+ */
+static void kthread_cancel_delayed_work_timer(struct kthread_work *work,
+					      unsigned long *flags)
+{
+	struct kthread_delayed_work *dwork =
+		container_of(work, struct kthread_delayed_work, work);
+	struct kthread_worker *worker = work->worker;
+
+	/*
+	 * del_timer_sync() must be called to make sure that the timer
+	 * callback is not running. The lock must be temporary released
+	 * to avoid a deadlock with the callback. In the meantime,
+	 * any queuing is blocked by setting the canceling counter.
+	 */
+	work->canceling++;
+	raw_spin_unlock_irqrestore(&worker->lock, *flags);
+	del_timer_sync(&dwork->timer);
+	raw_spin_lock_irqsave(&worker->lock, *flags);
+	work->canceling--;
+}
+
+/*
  * This function removes the work from the worker queue. Also it makes sure
  * that it won't get queued later via the delayed work's timer.
  *
@@ -1106,23 +1133,8 @@ static bool __kthread_cancel_work(struct
 				  unsigned long *flags)
 {
 	/* Try to cancel the timer if exists. */
-	if (is_dwork) {
-		struct kthread_delayed_work *dwork =
-			container_of(work, struct kthread_delayed_work, work);
-		struct kthread_worker *worker = work->worker;
-
-		/*
-		 * del_timer_sync() must be called to make sure that the timer
-		 * callback is not running. The lock must be temporary released
-		 * to avoid a deadlock with the callback. In the meantime,
-		 * any queuing is blocked by setting the canceling counter.
-		 */
-		work->canceling++;
-		raw_spin_unlock_irqrestore(&worker->lock, *flags);
-		del_timer_sync(&dwork->timer);
-		raw_spin_lock_irqsave(&worker->lock, *flags);
-		work->canceling--;
-	}
+	if (is_dwork)
+		kthread_cancel_delayed_work_timer(work, flags);
 
 	/*
 	 * Try to remove the work from a worker list. It might either
_

Patches currently in -mm which might be from pmladek@suse.com are

kthread_worker-split-code-for-canceling-the-delayed-work-timer.patch
kthread-prevent-deadlock-when-kthread_mod_delayed_work-races-with-kthread_cancel_delayed_work_sync.patch
kthread_worker-fix-return-value-when-kthread_mod_delayed_work-races-with-kthread_cancel_delayed_work_sync.patch

