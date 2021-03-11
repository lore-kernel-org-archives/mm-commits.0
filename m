Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39059C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 21:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCD7B64F9A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 21:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhCKVW2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 16:22:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:41944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhCKVV6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 16:21:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DB6764F84;
        Thu, 11 Mar 2021 21:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615497718;
        bh=CLluJBg2diH1ZlI/2paHHu0bCOW5GeF0zrO1fAm0UkI=;
        h=Date:From:To:Subject:From;
        b=XFka7KX357mBho0qmGLiEnZtVdMGUWLL7ciyapIKCGSGlhJ+SQLZ0BfEuPaeF4ni3
         N7/NpzS9nQgBd0EviaqYgF5Rewt6o0tINUYhsHJa7u0syp7KieEPcIOuWmA/p0zcBa
         TcdsR02c0BoFV7VCmEBJ6eKli/ywYR2R2+Sv/68E=
Date:   Thu, 11 Mar 2021 13:21:57 -0800
From:   akpm@linux-foundation.org
To:     loberman@redhat.com, mhocko@suse.com, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org, pmladek@suse.com,
        tglx@linutronix.de, vincent.whitchurch@axis.com
Subject:  +
 watchdog-explicitly-update-timestamp-when-reporting-softlockup.patch added
 to -mm tree
Message-ID: <20210311212157.w3rI8EYsE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: explicitly update timestamp when reporting softlockup
has been added to the -mm tree.  Its filename is
     watchdog-explicitly-update-timestamp-when-reporting-softlockup.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/watchdog-explicitly-update-timestamp-when-reporting-softlockup.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/watchdog-explicitly-update-timestamp-when-reporting-softlockup.patch

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
@@ -409,6 +409,9 @@ static enum hrtimer_restart watchdog_tim
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

watchdog-rename-__touch_watchdog-to-a-better-descriptive-name.patch
watchdog-explicitly-update-timestamp-when-reporting-softlockup.patch
watchdog-softlockup-report-the-overall-time-of-softlockups.patch
watchdog-softlockup-remove-logic-that-tried-to-prevent-repeated-reports.patch
watchdog-fix-barriers-when-printing-backtraces-from-all-cpus.patch
watchdog-cleanup-handling-of-false-positives.patch

