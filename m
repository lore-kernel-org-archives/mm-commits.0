Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8355BC43460
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CD706145E
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhD3FzM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230318AbhD3FzM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:55:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D81161458;
        Fri, 30 Apr 2021 05:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762064;
        bh=wB9PlAoNJkpYo1ZYEHmQWRRQd89Mjrz5CyST9KkT164=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rAy8+uy0+dTl2AfxQ3ikfSySUCJHXaEQyquDIGQ7flrGgvcFasdQmQRrIg4yn58kt
         1NcNfikwnr6VI7vk8Z0/iZGCpdZVQHSihqTOTCzmGjfyA5V80jqB4IncrEbeKlOI0L
         Eq8QeKPB4XJFnYFpm9bnbJZ2rVdlDw9PkG20xTAI=
Date:   Thu, 29 Apr 2021 22:54:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, loberman@redhat.com,
        mhocko@suse.com, mingo@kernel.org, mm-commits@vger.kernel.org,
        peterz@infradead.org, pmladek@suse.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vincent.whitchurch@axis.com
Subject:  [patch 023/178] watchdog: explicitly update timestamp
 when reporting softlockup
Message-ID: <20210430055423.pnd2rwY-w%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>
Subject: watchdog: explicitly update timestamp when reporting softlockup

The softlockup situation might stay for a long time or even forever.  When
it happens, the softlockup debug messages are printed in regular intervals
defined by get_softlockup_thresh().

There is a mystery.  The repeated message is printed after the full
interval that is defined by get_softlockup_thresh().  But the timer
callback is called more often as defined by sample_period.  The code looks
like the soflockup should get reported in every sample_period when it was
once behind the thresh.

It works only by chance.  The watchdog is touched when printing the stall
report, for example, in printk_stack_address().

Make the behavior clear and predictable by explicitly updating the
timestamp in watchdog_timer_fn() when the report gets printed.

Link: https://lkml.kernel.org/r/20210311122130.6788-3-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/watchdog.c~watchdog-explicitly-update-timestamp-when-reporting-softlockup
+++ a/kernel/watchdog.c
@@ -410,6 +410,9 @@ static enum hrtimer_restart watchdog_tim
 			}
 		}
 
+		/* Start period for the next softlockup warning. */
+		update_touch_ts();
+
 		pr_emerg("BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
 			smp_processor_id(), duration,
 			current->comm, task_pid_nr(current));
_
