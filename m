Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780A9C43460
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57FCF6146D
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhD3Fz1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229648AbhD3FzV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:55:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C8E961424;
        Fri, 30 Apr 2021 05:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762073;
        bh=qfTMhIWEwW56emfGXAIdIJTYEEzRXeA872mIJ/2ddKg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hOx+13+RZsj8arvOHp7BaFOFB14RnRzY5/qX64QuAZPGPcfjpygo/wEgzmjiX51Lg
         7FzMjptd96RO4vAc/uytxxjoQm6ZdaRnK/e5fkghBTp6QYiz7A0sBIz+QgCKgEyinX
         3FwjQSNOrkkznfP157ioZ+WBVQV8SUvz/TO/b/HI=
Date:   Thu, 29 Apr 2021 22:54:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, loberman@redhat.com,
        mhocko@suse.com, mingo@kernel.org, mm-commits@vger.kernel.org,
        peterz@infradead.org, pmladek@suse.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vincent.whitchurch@axis.com
Subject:  [patch 026/178] watchdog: fix barriers when printing
 backtraces from all CPUs
Message-ID: <20210430055433.mPeQY0F3d%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>
Subject: watchdog: fix barriers when printing backtraces from all CPUs

Any parallel softlockup reports are skipped when one CPU is already
printing backtraces from all CPUs.

The exclusive rights are synchronized using one bit in
soft_lockup_nmi_warn.  There is also one memory barrier that does not make
much sense.

Use two barriers on the right location to prevent mixing two reports.

[pmladek@suse.com: use bit lock operations to prevent multiple soft-lockup reports]
  Link: https://lkml.kernel.org/r/YFSVsLGVWMXTvlbk@alley
Link: https://lkml.kernel.org/r/20210311122130.6788-6-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/kernel/watchdog.c~watchdog-fix-barriers-when-printing-backtraces-from-all-cpus
+++ a/kernel/watchdog.c
@@ -410,11 +410,12 @@ static enum hrtimer_restart watchdog_tim
 		if (kvm_check_and_clear_guest_paused())
 			return HRTIMER_RESTART;
 
+		/*
+		 * Prevent multiple soft-lockup reports if one cpu is already
+		 * engaged in dumping all cpu back traces.
+		 */
 		if (softlockup_all_cpu_backtrace) {
-			/* Prevent multiple soft-lockup reports if one cpu is already
-			 * engaged in dumping cpu back traces
-			 */
-			if (test_and_set_bit(0, &soft_lockup_nmi_warn))
+			if (test_and_set_bit_lock(0, &soft_lockup_nmi_warn))
 				return HRTIMER_RESTART;
 		}
 
@@ -432,14 +433,8 @@ static enum hrtimer_restart watchdog_tim
 			dump_stack();
 
 		if (softlockup_all_cpu_backtrace) {
-			/* Avoid generating two back traces for current
-			 * given that one is already made above
-			 */
 			trigger_allbutself_cpu_backtrace();
-
-			clear_bit(0, &soft_lockup_nmi_warn);
-			/* Barrier to sync with other cpus */
-			smp_mb__after_atomic();
+			clear_bit_unlock(0, &soft_lockup_nmi_warn);
 		}
 
 		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
_
