Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1568EEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjFSX2X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjFSX2E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:28:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F621BEF
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:26:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2914B610A6
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F9DC433C8;
        Mon, 19 Jun 2023 23:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217173;
        bh=OycIyQkJBFgnpY2b15Ahq9X3P6aZ1h0y8FSq5zmzL1I=;
        h=Date:To:From:Subject:From;
        b=PBR+qM3lEpfs9gxuhM106TcA/YpJYBeqcJSsM4PX/H8F98E69P6GVLd50HiTIwArb
         7k8A1SW82wNWfbfWqItglzHvEkknU6zFcVK+mN+XPBL7JMPfdpu9d/VXQ2zweAbBbZ
         QsjZCU/fpubgsbIjfpYZL4okTAzQE09iptKhwypM=
Date:   Mon, 19 Jun 2023 16:26:12 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, npiggin@gmail.com,
        mpe@ellerman.id.au, davem@davemloft.net,
        christophe.leroy@csgroup.eu, dianders@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-buddy-cleanup-how-watchdog_buddy_check_hardlockup-is-called.patch removed from -mm tree
Message-Id: <20230619232613.81F9DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog/buddy: cleanup how watchdog_buddy_check_hardlockup() is called
has been removed from the -mm tree.  Its filename was
     watchdog-buddy-cleanup-how-watchdog_buddy_check_hardlockup-is-called.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: watchdog/buddy: cleanup how watchdog_buddy_check_hardlockup() is called
Date: Fri, 26 May 2023 18:41:36 -0700

In the patch ("watchdog/hardlockup: detect hard lockups using secondary
(buddy) CPUs"), we added a call from the common watchdog.c file into the
buddy.  That call could be done more cleanly.  Specifically:

1. If we move the call into watchdog_hardlockup_kick() then it keeps
   watchdog_timer_fn() simpler.
2. We don't need to pass an "unsigned long" to the buddy for the timer
   count. In the patch ("watchdog/hardlockup: add a "cpu" param to
   watchdog_hardlockup_check()") the count was changed to "atomic_t"
   which is backed by an int, so we should match types.

Link: https://lkml.kernel.org/r/20230526184139.6.I006c7d958a1ea5c4e1e4dc44a25596d9bb5fd3ba@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Suggested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h     |    4 ++--
 kernel/watchdog.c       |   15 +++++++--------
 kernel/watchdog_buddy.c |    2 +-
 3 files changed, 10 insertions(+), 11 deletions(-)

--- a/include/linux/nmi.h~watchdog-buddy-cleanup-how-watchdog_buddy_check_hardlockup-is-called
+++ a/include/linux/nmi.h
@@ -114,9 +114,9 @@ void watchdog_hardlockup_disable(unsigne
 void lockup_detector_reconfigure(void);
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR_BUDDY
-void watchdog_buddy_check_hardlockup(unsigned long hrtimer_interrupts);
+void watchdog_buddy_check_hardlockup(int hrtimer_interrupts);
 #else
-static inline void watchdog_buddy_check_hardlockup(unsigned long hrtimer_interrupts) {}
+static inline void watchdog_buddy_check_hardlockup(int hrtimer_interrupts) {}
 #endif
 
 /**
--- a/kernel/watchdog_buddy.c~watchdog-buddy-cleanup-how-watchdog_buddy_check_hardlockup-is-called
+++ a/kernel/watchdog_buddy.c
@@ -72,7 +72,7 @@ void watchdog_hardlockup_disable(unsigne
 	cpumask_clear_cpu(cpu, &watchdog_cpus);
 }
 
-void watchdog_buddy_check_hardlockup(unsigned long hrtimer_interrupts)
+void watchdog_buddy_check_hardlockup(int hrtimer_interrupts)
 {
 	unsigned int next_cpu;
 
--- a/kernel/watchdog.c~watchdog-buddy-cleanup-how-watchdog_buddy_check_hardlockup-is-called
+++ a/kernel/watchdog.c
@@ -131,9 +131,12 @@ static bool is_hardlockup(unsigned int c
 	return false;
 }
 
-static unsigned long watchdog_hardlockup_kick(void)
+static void watchdog_hardlockup_kick(void)
 {
-	return atomic_inc_return(this_cpu_ptr(&hrtimer_interrupts));
+	int new_interrupts;
+
+	new_interrupts = atomic_inc_return(this_cpu_ptr(&hrtimer_interrupts));
+	watchdog_buddy_check_hardlockup(new_interrupts);
 }
 
 void watchdog_hardlockup_check(unsigned int cpu, struct pt_regs *regs)
@@ -195,7 +198,7 @@ void watchdog_hardlockup_check(unsigned
 
 #else /* CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER */
 
-static inline unsigned long watchdog_hardlockup_kick(void) { return 0; }
+static inline void watchdog_hardlockup_kick(void) { }
 
 #endif /* !CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER */
 
@@ -449,15 +452,11 @@ static enum hrtimer_restart watchdog_tim
 	struct pt_regs *regs = get_irq_regs();
 	int duration;
 	int softlockup_all_cpu_backtrace = sysctl_softlockup_all_cpu_backtrace;
-	unsigned long hrtimer_interrupts;
 
 	if (!watchdog_enabled)
 		return HRTIMER_NORESTART;
 
-	hrtimer_interrupts = watchdog_hardlockup_kick();
-
-	/* test for hardlockups */
-	watchdog_buddy_check_hardlockup(hrtimer_interrupts);
+	watchdog_hardlockup_kick();
 
 	/* kick the softlockup detector */
 	if (completion_done(this_cpu_ptr(&softlockup_completion))) {
_

Patches currently in -mm which might be from dianders@chromium.org are


