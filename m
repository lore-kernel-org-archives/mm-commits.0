Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A27FEB64DD
	for <mm-commits@archiver.kernel.org>; Thu,  3 Aug 2023 18:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjHCSTE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Aug 2023 14:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjHCSSe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Aug 2023 14:18:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E97110
        for <mm-commits@vger.kernel.org>; Thu,  3 Aug 2023 11:18:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E95DD61E69
        for <mm-commits@vger.kernel.org>; Thu,  3 Aug 2023 18:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A8BC433C8;
        Thu,  3 Aug 2023 18:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691086711;
        bh=IDDnOF7kCQuej0XQ+yxzASFDkVfAK/+GJBar3aOiwDM=;
        h=Date:To:From:Subject:From;
        b=VXOUq5NLKlvD74HaKhB/hvLnX/I3Ih/xfdHgHS0fR/N6tYcHAoaNOVDDLABMGgdX2
         QLoy+ckdifKKYUnv+sDQ7o19EXtsKHHbBVcvfZhRlnhu/HoyYGJIkxfbk9YugkrkC1
         aFsrlvYdWkg2FRN+n+vSlhEWvA8tzL57pZe1/se4=
Date:   Thu, 03 Aug 2023 11:18:30 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, mhocko@suse.com,
        lkp@intel.com, lecopzer.chen@mediatek.com, kernelfans@gmail.com,
        dianders@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-hardlockup-avoid-large-stack-frames-in-watchdog_hardlockup_check.patch added to mm-hotfixes-unstable branch
Message-Id: <20230803181831.46A8BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog/hardlockup: avoid large stack frames in watchdog_hardlockup_check()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     watchdog-hardlockup-avoid-large-stack-frames-in-watchdog_hardlockup_check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-hardlockup-avoid-large-stack-frames-in-watchdog_hardlockup_check.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: watchdog/hardlockup: avoid large stack frames in watchdog_hardlockup_check()
Date: Wed, 2 Aug 2023 12:26:00 -0700

After commit 77c12fc95980 ("watchdog/hardlockup: add a "cpu" param to
watchdog_hardlockup_check()") we started storing a `struct cpumask` on the
stack in watchdog_hardlockup_check().  On systems with CONFIG_NR_CPUS set
to 8192 this takes up 1K on the stack.  That triggers warnings with
`CONFIG_FRAME_WARN` set to 1024.

Instead of putting this `struct cpumask` on the stack, we'll allocate it
on the heap whenever userspace tells us that they want to backtrace all
CPUs upon a hardlockup.

NOTE: the reason that this mask is even needed is to make sure that we can
print the hung CPU first, which makes the logs much easier to understand.

Link: https://lkml.kernel.org/r/20230802122555.v2.1.I501ab68cb926ee33a7c87e063d207abf09b9943c@changeid
Fixes: 77c12fc95980 ("watchdog/hardlockup: add a "cpu" param to watchdog_hardlockup_check()")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202307310955.pLZDhpnl-lkp@intel.com
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   44 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

--- a/kernel/watchdog.c~watchdog-hardlockup-avoid-large-stack-frames-in-watchdog_hardlockup_check
+++ a/kernel/watchdog.c
@@ -93,6 +93,8 @@ static DEFINE_PER_CPU(bool, watchdog_har
 static DEFINE_PER_CPU(bool, watchdog_hardlockup_touched);
 static unsigned long watchdog_hardlockup_all_cpu_dumped;
 
+static struct cpumask *hardlockup_backtrace_mask;
+
 notrace void arch_touch_nmi_watchdog(void)
 {
 	/*
@@ -106,6 +108,29 @@ notrace void arch_touch_nmi_watchdog(voi
 }
 EXPORT_SYMBOL(arch_touch_nmi_watchdog);
 
+static int hardlockup_all_cpu_backtrace_proc_handler(struct ctl_table *table, int write,
+		  void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+
+	/*
+	 * Only allocate memory for the backtrace mask if userspace actually
+	 * wants to trace all CPUs since this can take up 1K of space on a
+	 * system with CONFIG_NR_CPUS=8192.
+	 */
+	if (sysctl_hardlockup_all_cpu_backtrace && !hardlockup_backtrace_mask) {
+		hardlockup_backtrace_mask =
+			   kzalloc(sizeof(*hardlockup_backtrace_mask), GFP_KERNEL);
+	} else if (!sysctl_hardlockup_all_cpu_backtrace && hardlockup_backtrace_mask) {
+		kfree(hardlockup_backtrace_mask);
+		hardlockup_backtrace_mask = NULL;
+	}
+
+	return ret;
+}
+
 void watchdog_hardlockup_touch_cpu(unsigned int cpu)
 {
 	per_cpu(watchdog_hardlockup_touched, cpu) = true;
@@ -151,9 +176,6 @@ void watchdog_hardlockup_check(unsigned
 	 */
 	if (is_hardlockup(cpu)) {
 		unsigned int this_cpu = smp_processor_id();
-		struct cpumask backtrace_mask;
-
-		cpumask_copy(&backtrace_mask, cpu_online_mask);
 
 		/* Only print hardlockups once. */
 		if (per_cpu(watchdog_hardlockup_warned, cpu))
@@ -167,19 +189,20 @@ void watchdog_hardlockup_check(unsigned
 				show_regs(regs);
 			else
 				dump_stack();
-			cpumask_clear_cpu(cpu, &backtrace_mask);
 		} else {
-			if (trigger_single_cpu_backtrace(cpu))
-				cpumask_clear_cpu(cpu, &backtrace_mask);
+			trigger_single_cpu_backtrace(cpu);
 		}
 
 		/*
 		 * Perform multi-CPU dump only once to avoid multiple
 		 * hardlockups generating interleaving traces
 		 */
-		if (sysctl_hardlockup_all_cpu_backtrace &&
-		    !test_and_set_bit(0, &watchdog_hardlockup_all_cpu_dumped))
-			trigger_cpumask_backtrace(&backtrace_mask);
+		if (hardlockup_backtrace_mask &&
+		    !test_and_set_bit(0, &watchdog_hardlockup_all_cpu_dumped)) {
+			cpumask_copy(hardlockup_backtrace_mask, cpu_online_mask);
+			cpumask_clear_cpu(cpu, hardlockup_backtrace_mask);
+			trigger_cpumask_backtrace(hardlockup_backtrace_mask);
+		}
 
 		if (hardlockup_panic)
 			nmi_panic(regs, "Hard LOCKUP");
@@ -192,6 +215,7 @@ void watchdog_hardlockup_check(unsigned
 
 #else /* CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER */
 
+#define hardlockup_all_cpu_backtrace_proc_handler proc_dointvec_minmax
 static inline void watchdog_hardlockup_kick(void) { }
 
 #endif /* !CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER */
@@ -916,7 +940,7 @@ static struct ctl_table watchdog_sysctls
 		.data		= &sysctl_hardlockup_all_cpu_backtrace,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= hardlockup_all_cpu_backtrace_proc_handler,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
_

Patches currently in -mm which might be from dianders@chromium.org are

watchdog-hardlockup-avoid-large-stack-frames-in-watchdog_hardlockup_check.patch

