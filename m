Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE62C61DF4
	for <mm-commits@archiver.kernel.org>; Fri, 24 Nov 2023 19:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345971AbjKXTji (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Nov 2023 14:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345941AbjKXTjh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Nov 2023 14:39:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671D812B
        for <mm-commits@vger.kernel.org>; Fri, 24 Nov 2023 11:39:44 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05458C433C7;
        Fri, 24 Nov 2023 19:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700854784;
        bh=obyoLMHljbu8ZMk+zgpqlJffOe5w59WrJxCf2pHeQ7c=;
        h=Date:To:From:Subject:From;
        b=0RljBkqGScIRuQfGwJVItEKbjFg8R+w31VmKiyUXwa6mXtNIas89CdGVNob9S61BL
         CMt1lu7d5UxHJc4E3Oe8JKbJnuX7XfB8xoTyA03HmGiS9RztFH9PD9jrXvTwER3UcC
         moLyb/2ABTpCLj+SK2AQRfrbd5oE5GTCArnzQYk8=
Date:   Fri, 24 Nov 2023 11:39:43 -0800
To:     mm-commits@vger.kernel.org, pmladek@suse.com,
        lizefan.x@bytedance.com, lecopzer.chen@mediatek.com,
        kernelfans@gmail.com, dianders@chromium.org,
        lizhe.67@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + softlockup-serialized-softlockups-log.patch added to mm-nonmm-unstable branch
Message-Id: <20231124193944.05458C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: softlockup: serialized softlockup's log
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     softlockup-serialized-softlockups-log.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/softlockup-serialized-softlockups-log.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Li Zhe <lizhe.67@bytedance.com>
Subject: softlockup: serialized softlockup's log
Date: Thu, 23 Nov 2023 16:40:22 +0800

If multiple CPUs trigger softlockup at the same time with
'softlockup_all_cpu_backtrace=0', the softlockup's logs will appear
staggeredly in dmesg, which will affect the viewing of the logs for
developer.  Since the code path for outputting softlockup logs is not a
kernel hotspot and the performance requirements for the code are not
strict, locks are used to serialize the softlockup log output to improve
the readability of the logs.

Link: https://lkml.kernel.org/r/20231123084022.10302-1-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/watchdog.c~softlockup-serialized-softlockups-log
+++ a/kernel/watchdog.c
@@ -448,6 +448,7 @@ static enum hrtimer_restart watchdog_tim
 	struct pt_regs *regs = get_irq_regs();
 	int duration;
 	int softlockup_all_cpu_backtrace = sysctl_softlockup_all_cpu_backtrace;
+	static DEFINE_SPINLOCK(watchdog_output_lock);
 
 	if (!watchdog_enabled)
 		return HRTIMER_NORESTART;
@@ -514,6 +515,7 @@ static enum hrtimer_restart watchdog_tim
 		/* Start period for the next softlockup warning. */
 		update_report_ts();
 
+		spin_lock(&watchdog_output_lock);
 		pr_emerg("BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
 			smp_processor_id(), duration,
 			current->comm, task_pid_nr(current));
@@ -523,6 +525,7 @@ static enum hrtimer_restart watchdog_tim
 			show_regs(regs);
 		else
 			dump_stack();
+		spin_unlock(&watchdog_output_lock);
 
 		if (softlockup_all_cpu_backtrace) {
 			trigger_allbutcpu_cpu_backtrace(smp_processor_id());
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

softlockup-serialized-softlockups-log.patch

