Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3284EC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 024E66141E
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhEHWkq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhEHWkp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:40:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97235613EA;
        Sat,  8 May 2021 22:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513583;
        bh=1BMWrDCYl9MLGKK9Y9KYN4FMcF9ZcWJdV3SuOUtAy6o=;
        h=Date:From:To:Subject:From;
        b=XCsJHX3QDUMwa7LaE5hPjO/abTHlfrqUhe+d4dTmzIzTKlfcE4n3Nag4mCvBOu1cJ
         IoQJgqRG63KFUv/HCQFi23hnAl/aQD7f6kG4KHtEY7XdE+w9fnKhf3P2Dg/pz2IUNo
         wY8664sEZcXgEwmZ6oJYGJSpM/LBtEhiQPpTnUrI=
Date:   Sat, 08 May 2021 15:39:43 -0700
From:   akpm@linux-foundation.org
To:     loberman@redhat.com, mhocko@suse.com, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org, pmladek@suse.com,
        tglx@linutronix.de, vincent.whitchurch@axis.com
Subject:  [merged]
 watchdog-explicitly-update-timestamp-when-reporting-softlockup.patch
 removed from -mm tree
Message-ID: <20210508223943.-lO8U1LOW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: explicitly update timestamp when reporting softlockup
has been removed from the -mm tree.  Its filename was
     watchdog-explicitly-update-timestamp-when-reporting-softlockup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from pmladek@suse.com are


