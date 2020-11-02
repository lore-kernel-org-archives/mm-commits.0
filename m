Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A62C4741F
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:07:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BECC22272
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604279275;
	bh=Niqq3HHDaK9hED/6KWIFNkPVh25jJQDmz3J5SXB7FEo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=y5lftRZEXWQeeUUBedtCj2PfTbJu3/fqO/cvmVoQQFNLujfEKko0iW5+0iWLdfzKG
	 qVsrgZNtK3cFYqCniEG0gqTtnBOu4CQOcDkb3Qn+Zo9bUHf+xEKUqFR967PiJRsrjQ
	 mH7HxdeMM9x3Q0hKywClOgz1yWq//Wqj2WDzFkVo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbgKBBHy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Nov 2020 20:07:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgKBBHy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Nov 2020 20:07:54 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 185C622268;
        Mon,  2 Nov 2020 01:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604279274;
        bh=Niqq3HHDaK9hED/6KWIFNkPVh25jJQDmz3J5SXB7FEo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kEPjnqHb6CSGc4mnOA92vk95X5/ZHb/ViGi8ZoU8ae+EmxI0kuEkNMo9efUJlsiTO
         yEPeJXbJl9BAAuseR05wqkEjdGQgdyY9ShwdyDucNj11jaVGLkF5oJtQvSL4NuUyVd
         dc/3GLITTstvmJkXNnyGyTcVxjoBYrFym/yFTfUk=
Date:   Sun, 01 Nov 2020 17:07:53 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pmladek@suse.com,
        qiang.zhang@windriver.com, stable@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 10/15] kthread_worker: prevent queuing delayed
 work from timer_fn when it is being canceled
Message-ID: <20201102010753.nF453nOWt%akpm@linux-foundation.org>
In-Reply-To: <20201101170656.48abbd5e88375219f868af5e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zqiang <qiang.zhang@windriver.com>
Subject: kthread_worker: prevent queuing delayed work from timer_fn when it is being canceled

There is a small race window when a delayed work is being canceled and the
work still might be queued from the timer_fn:

	CPU0						CPU1
kthread_cancel_delayed_work_sync()
   __kthread_cancel_work_sync()
     __kthread_cancel_work()
        work->canceling++;
					      kthread_delayed_work_timer_fn()
						   kthread_insert_work();

BUG: kthread_insert_work() should not get called when work->canceling is
set.

Link: https://lkml.kernel.org/r/20201014083030.16895-1-qiang.zhang@windriver.com
Signed-off-by: Zqiang <qiang.zhang@windriver.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/kthread.c~kthread_worker-prevent-queuing-delayed-work-from-timer_fn-when-it-is-being-canceled
+++ a/kernel/kthread.c
@@ -897,7 +897,8 @@ void kthread_delayed_work_timer_fn(struc
 	/* Move the work from worker->delayed_work_list. */
 	WARN_ON_ONCE(list_empty(&work->node));
 	list_del_init(&work->node);
-	kthread_insert_work(worker, work, &worker->work_list);
+	if (!work->canceling)
+		kthread_insert_work(worker, work, &worker->work_list);
 
 	raw_spin_unlock_irqrestore(&worker->lock, flags);
 }
_
