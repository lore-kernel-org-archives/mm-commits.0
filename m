Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E54C0015E
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjHLWGX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjHLWGO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:06:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07DC1998
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:06:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57E5E620CF
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B156CC433C9;
        Sat, 12 Aug 2023 22:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877966;
        bh=Lp/jgjEkrv2TUzJcDVJ28Q9i2HXZgIzyIngY7HScEmQ=;
        h=Date:To:From:Subject:From;
        b=l2ocpkhfln8nsgFK5JDXDT1ucwkjwtpNWp2AXPaGsXfbknZdx7Mt+wI4NqXYWd+Qn
         LWdB+e833McK+V5Yz4svCodWDSmR4BV5SiM/vooOc/7C5p73zGH9/8ArO0pyR7/12+
         vBqW81lQJyfh0iKHoTo3Dg6dO2zHUucmRYz+rRz8=
Date:   Sat, 12 Aug 2023 15:06:06 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, mhocko@suse.com,
        lkp@intel.com, lecopzer.chen@mediatek.com, kernelfans@gmail.com,
        dianders@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-hardlockup-avoid-large-stack-frames-in-watchdog_hardlockup_check.patch removed from -mm tree
Message-Id: <20230812220606.B156CC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog/hardlockup: avoid large stack frames in watchdog_hardlockup_check()
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-avoid-large-stack-frames-in-watchdog_hardlockup_check.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: watchdog/hardlockup: avoid large stack frames in watchdog_hardlockup_check()
Date: Fri, 4 Aug 2023 07:00:43 -0700

After commit 77c12fc95980 ("watchdog/hardlockup: add a "cpu" param to
watchdog_hardlockup_check()") we started storing a `struct cpumask` on the
stack in watchdog_hardlockup_check().  On systems with CONFIG_NR_CPUS set
to 8192 this takes up 1K on the stack.  That triggers warnings with
`CONFIG_FRAME_WARN` set to 1024.

We'll use the new trigger_allbutcpu_cpu_backtrace() to avoid needing to
use a CPU mask at all.

Link: https://lkml.kernel.org/r/20230804065935.v4.2.I501ab68cb926ee33a7c87e063d207abf09b9943c@changeid
Fixes: 77c12fc95980 ("watchdog/hardlockup: add a "cpu" param to watchdog_hardlockup_check()")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202307310955.pLZDhpnl-lkp@intel.com
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/kernel/watchdog.c~watchdog-hardlockup-avoid-large-stack-frames-in-watchdog_hardlockup_check
+++ a/kernel/watchdog.c
@@ -151,9 +151,6 @@ void watchdog_hardlockup_check(unsigned
 	 */
 	if (is_hardlockup(cpu)) {
 		unsigned int this_cpu = smp_processor_id();
-		struct cpumask backtrace_mask;
-
-		cpumask_copy(&backtrace_mask, cpu_online_mask);
 
 		/* Only print hardlockups once. */
 		if (per_cpu(watchdog_hardlockup_warned, cpu))
@@ -167,10 +164,8 @@ void watchdog_hardlockup_check(unsigned
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
@@ -179,7 +174,7 @@ void watchdog_hardlockup_check(unsigned
 		 */
 		if (sysctl_hardlockup_all_cpu_backtrace &&
 		    !test_and_set_bit(0, &watchdog_hardlockup_all_cpu_dumped))
-			trigger_cpumask_backtrace(&backtrace_mask);
+			trigger_allbutcpu_cpu_backtrace(cpu);
 
 		if (hardlockup_panic)
 			nmi_panic(regs, "Hard LOCKUP");
_

Patches currently in -mm which might be from dianders@chromium.org are


