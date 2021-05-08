Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4C1C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8718613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhEHWko (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhEHWkn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:40:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A231E6140E;
        Sat,  8 May 2021 22:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513580;
        bh=MwaUXsl2NTwVnq3PgBmUQK40RP6DTqjzq8U7D9XpzgY=;
        h=Date:From:To:Subject:From;
        b=w+yjxbKhBhlsgTc9zLZ0W7bFdE75eWQqeIhguloRp8qFKb749srIEO8BI6T2gWc1M
         oHeHscDwb/lp3FSxh5PoywDwmWmv1O/Sl6B5napuvtu80lgmOpN9tRyGI1IkmdbPsj
         gWx+5ccHZlMUNAuCgjfGd7c3RcxRmHpQUN+nhJgM=
Date:   Sat, 08 May 2021 15:39:40 -0700
From:   akpm@linux-foundation.org
To:     loberman@redhat.com, mhocko@suse.com, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org, pmladek@suse.com,
        tglx@linutronix.de, vincent.whitchurch@axis.com
Subject:  [merged]
 watchdog-rename-__touch_watchdog-to-a-better-descriptive-name.patch removed
 from -mm tree
Message-ID: <20210508223940.nFYIuFlZp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: rename __touch_watchdog() to a better descriptive name
has been removed from the -mm tree.  Its filename was
     watchdog-rename-__touch_watchdog-to-a-better-descriptive-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: watchdog: rename __touch_watchdog() to a better descriptive name

Patch series "watchdog/softlockup: Report overall time and some cleanup", v2.

I dug deep into the softlockup watchdog history when time permitted this
year.  And reworked the patchset that fixed timestamps and cleaned up the
code[2].

I split it into very small steps and did even more code clean up.  The
result looks quite strightforward and I am pretty confident with the
changes.

[1] v2: https://lore.kernel.org/r/20201210160038.31441-1-pmladek@suse.com
[2] v1: https://lore.kernel.org/r/20191024114928.15377-1-pmladek@suse.com


This patch (of 6):

There are many touch_*watchdog() functions.  They are called in situations
where the watchdog could report false positives or create unnecessary
noise.  For example, when CPU is entering idle mode, a virtual machine is
stopped, or a lot of messages are printed in the atomic context.

These functions set SOFTLOCKUP_RESET instead of a real timestamp.  It
allows to call them even in a context where jiffies might be outdated. 
For example, in an atomic context.

The real timestamp is set by __touch_watchdog() that is called from the
watchdog timer callback.

Rename this callback to update_touch_ts().  It better describes the effect
and clearly distinguish is from the other touch_*watchdog() functions.

Another motivation is that two timestamps are going to be used.  One will
be used for the total softlockup time.  The other will be used to measure
time since the last report.  The new function name will help to
distinguish which timestamp is being updated.

Link: https://lkml.kernel.org/r/20210311122130.6788-1-pmladek@suse.com
Link: https://lkml.kernel.org/r/20210311122130.6788-2-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/watchdog.c~watchdog-rename-__touch_watchdog-to-a-better-descriptive-name
+++ a/kernel/watchdog.c
@@ -236,7 +236,7 @@ static void set_sample_period(void)
 }
 
 /* Commands for resetting the watchdog */
-static void __touch_watchdog(void)
+static void update_touch_ts(void)
 {
 	__this_cpu_write(watchdog_touch_ts, get_timestamp());
 }
@@ -332,7 +332,7 @@ static DEFINE_PER_CPU(struct cpu_stop_wo
  */
 static int softlockup_fn(void *data)
 {
-	__touch_watchdog();
+	update_touch_ts();
 	complete(this_cpu_ptr(&softlockup_completion));
 
 	return 0;
@@ -375,7 +375,7 @@ static enum hrtimer_restart watchdog_tim
 
 		/* Clear the guest paused flag on watchdog reset */
 		kvm_check_and_clear_guest_paused();
-		__touch_watchdog();
+		update_touch_ts();
 		return HRTIMER_RESTART;
 	}
 
@@ -461,7 +461,7 @@ static void watchdog_enable(unsigned int
 		      HRTIMER_MODE_REL_PINNED_HARD);
 
 	/* Initialize timestamp */
-	__touch_watchdog();
+	update_touch_ts();
 	/* Enable the perf event */
 	if (watchdog_enabled & NMI_WATCHDOG_ENABLED)
 		watchdog_nmi_enable(cpu);
_

Patches currently in -mm which might be from pmladek@suse.com are


