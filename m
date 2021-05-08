Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96EF6C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74EF46141D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhEHWkw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhEHWkw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:40:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B112B6140E;
        Sat,  8 May 2021 22:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513590;
        bh=3Hg/OMZ9SN6LRzh/GBSSux/v3U2WlpULLKsoV23+L8c=;
        h=Date:From:To:Subject:From;
        b=PZx1OwnexE7DFH5eLdPmhVyrdwk1d4qPhqOvCH1rZoTa9cg4tT+aKaKrzy4qj79fp
         B5Xo10675tSK8Jc7c3oJ8SVegO6VcP2TYDH2X7dD0EPglLWnimgAYG5ldErBgDhtd8
         zeY1POt4KiGwyNFCK7t89RsisAwZeH2XBQFYl8zA=
Date:   Sat, 08 May 2021 15:39:49 -0700
From:   akpm@linux-foundation.org
To:     loberman@redhat.com, mhocko@suse.com, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org, pmladek@suse.com,
        tglx@linutronix.de, vincent.whitchurch@axis.com
Subject:  [merged]
 =?US-ASCII?Q?watchdog-softlockup-remove-logic-that-tried-to-prevent-re?=
 =?US-ASCII?Q?peated-reports.patch?= removed from -mm tree
Message-ID: <20210508223949.pZlX4vQuD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog/softlockup: remove logic that tried to prevent repeated reports
has been removed from the -mm tree.  Its filename was
     watchdog-softlockup-remove-logic-that-tried-to-prevent-repeated-reports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: watchdog/softlockup: remove logic that tried to prevent repeated reports

The softlockup detector does some gymnastic with the variable
soft_watchdog_warn.  It was added by the commit 58687acba59266735ad
("lockup_detector: Combine nmi_watchdog and softlockup detector").

The purpose is not completely clear.  There are the following clues.  They
describe the situation how it looked after the above mentioned commit:

  1. The variable was checked with a comment "only warn once".

  2. The variable was set when softlockup was reported. It was cleared
     only when the CPU was not longer in the softlockup state.

  3. watchdog_touch_ts was not explicitly updated when the softlockup
     was reported. Without this variable, the report would normally
     be printed again during every following watchdog_timer_fn()
     invocation.

The logic has got even more tangled up by the commit ed235875e2ca98
("kernel/watchdog.c: print traces for all cpus on lockup detection"). 
After this commit, soft_watchdog_warn is set only when
softlockup_all_cpu_backtrace is enabled.  But multiple reports from all
CPUs are prevented by a new variable soft_lockup_nmi_warn.

Conclusion:

The variable probably never worked as intended.  In each case, it has not
worked last many years because the softlockup was reported repeatedly
after the full period defined by watchdog_thresh.

The reason is that watchdog gets touched in many known slow paths, for
example, in printk_stack_address().  This code is called also when
printing the softlockup report.  It means that the watchdog timestamp gets
updated after each report.

Solution:

Simply remove the logic. People want the periodic report anyway.

Link: https://lkml.kernel.org/r/20210311122130.6788-5-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/kernel/watchdog.c~watchdog-softlockup-remove-logic-that-tried-to-prevent-repeated-reports
+++ a/kernel/watchdog.c
@@ -179,7 +179,6 @@ static DEFINE_PER_CPU(unsigned long, wat
 static DEFINE_PER_CPU(unsigned long, watchdog_report_ts);
 static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
 static DEFINE_PER_CPU(bool, softlockup_touch_sync);
-static DEFINE_PER_CPU(bool, soft_watchdog_warn);
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
 static unsigned long soft_lockup_nmi_warn;
@@ -411,19 +410,12 @@ static enum hrtimer_restart watchdog_tim
 		if (kvm_check_and_clear_guest_paused())
 			return HRTIMER_RESTART;
 
-		/* only warn once */
-		if (__this_cpu_read(soft_watchdog_warn) == true)
-			return HRTIMER_RESTART;
-
 		if (softlockup_all_cpu_backtrace) {
 			/* Prevent multiple soft-lockup reports if one cpu is already
 			 * engaged in dumping cpu back traces
 			 */
-			if (test_and_set_bit(0, &soft_lockup_nmi_warn)) {
-				/* Someone else will report us. Let's give up */
-				__this_cpu_write(soft_watchdog_warn, true);
+			if (test_and_set_bit(0, &soft_lockup_nmi_warn))
 				return HRTIMER_RESTART;
-			}
 		}
 
 		/* Start period for the next softlockup warning. */
@@ -453,9 +445,7 @@ static enum hrtimer_restart watchdog_tim
 		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
 		if (softlockup_panic)
 			panic("softlockup: hung tasks");
-		__this_cpu_write(soft_watchdog_warn, true);
-	} else
-		__this_cpu_write(soft_watchdog_warn, false);
+	}
 
 	return HRTIMER_RESTART;
 }
_

Patches currently in -mm which might be from pmladek@suse.com are


