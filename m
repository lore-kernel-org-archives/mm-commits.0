Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6888414010
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BecIdZRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B1AC433C8;
	Fri, 29 Dec 2023 20:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881415;
	bh=GYNCrLobkWjxlKDYQQDDpndO9UKI3o/jN9Q/EWbmjSc=;
	h=Date:To:From:Subject:From;
	b=BecIdZRNFDYHPklfBAh2lyHalE6nuSgwyj1MzNYD93C5clwed4KF7o3CoanN9v1p8
	 ypD0BWoyQd+5AOJJgy5drnjyJa1UVWSgyP5gEMtTjdDG7gKwErjZJv2b6sFrk5xMnH
	 SdiOLmVGVzpPkT+/mT0v1lfSW0hTr70O26gk8zpU=
Date: Fri, 29 Dec 2023 12:23:34 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,lizhe.67@bytedance.com,lecopzer.chen@mediatek.com,kernelfans@gmail.com,john.ogness@linutronix.de,dianders@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-hardlockup-use-printk_cpu_sync_get_irqsave-to-serialize-reporting.patch removed from -mm tree
Message-Id: <20231229202335.34B1AC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog/hardlockup: use printk_cpu_sync_get_irqsave() to serialize reporting
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-use-printk_cpu_sync_get_irqsave-to-serialize-reporting.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: watchdog/hardlockup: use printk_cpu_sync_get_irqsave() to serialize reporting
Date: Wed, 20 Dec 2023 13:15:36 -0800

If two CPUs end up reporting a hardlockup at the same time then their logs
could get interleaved which is hard to read.

The interleaving problem was especially bad with the "perf" hardlockup
detector where the locked up CPU is always the same as the running CPU and
we end up in show_regs().  show_regs() has no inherent serialization so we
could mix together two crawls if two hardlockups happened at the same time
(and if we didn't have `sysctl_hardlockup_all_cpu_backtrace` set).  With
this change we'll fully serialize hardlockups when using the "perf"
hardlockup detector.

The interleaving problem was less bad with the "buddy" hardlockup
detector.  With "buddy" we always end up calling
`trigger_single_cpu_backtrace(cpu)` on some CPU other than the running
one.  trigger_single_cpu_backtrace() always at least serializes the
individual stack crawls because it eventually uses
printk_cpu_sync_get_irqsave().  Unfortunately the fact that
trigger_single_cpu_backtrace() eventually calls
printk_cpu_sync_get_irqsave() (on a different CPU) means that we have to
drop the "lock" before calling it and we can't fully serialize all
printouts associated with a given hardlockup.  However, we still do get
the advantage of serializing the output of print_modules() and
print_irqtrace_events().

Aside from serializing hardlockups from each other, this change also has
the advantage of serializing hardlockups and softlockups from each other
if they happen to happen at the same time since they are both using the
same "lock".

Even though nobody is expected to hang while holding the lock associated
with printk_cpu_sync_get_irqsave(), out of an abundance of caution, we
don't call printk_cpu_sync_get_irqsave() until after we print out about
the hardlockup.  This makes extra sure that, even if
printk_cpu_sync_get_irqsave() somehow never runs we at least print that we
saw the hardlockup.  This is different than the choice made for softlockup
because hardlockup is really our last resort.

Link: https://lkml.kernel.org/r/20231220131534.3.I6ff691b3b40f0379bc860f80c6e729a0485b5247@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/kernel/watchdog.c~watchdog-hardlockup-use-printk_cpu_sync_get_irqsave-to-serialize-reporting
+++ a/kernel/watchdog.c
@@ -151,6 +151,7 @@ void watchdog_hardlockup_check(unsigned
 	 */
 	if (is_hardlockup(cpu)) {
 		unsigned int this_cpu = smp_processor_id();
+		unsigned long flags;
 
 		/* Only print hardlockups once. */
 		if (per_cpu(watchdog_hardlockup_warned, cpu))
@@ -165,7 +166,17 @@ void watchdog_hardlockup_check(unsigned
 				return;
 		}
 
+		/*
+		 * NOTE: we call printk_cpu_sync_get_irqsave() after printing
+		 * the lockup message. While it would be nice to serialize
+		 * that printout, we really want to make sure that if some
+		 * other CPU somehow locked up while holding the lock associated
+		 * with printk_cpu_sync_get_irqsave() that we can still at least
+		 * get the message about the lockup out.
+		 */
 		pr_emerg("Watchdog detected hard LOCKUP on cpu %d\n", cpu);
+		printk_cpu_sync_get_irqsave(flags);
+
 		print_modules();
 		print_irqtrace_events(current);
 		if (cpu == this_cpu) {
@@ -173,7 +184,9 @@ void watchdog_hardlockup_check(unsigned
 				show_regs(regs);
 			else
 				dump_stack();
+			printk_cpu_sync_put_irqrestore(flags);
 		} else {
+			printk_cpu_sync_put_irqrestore(flags);
 			trigger_single_cpu_backtrace(cpu);
 		}
 
_

Patches currently in -mm which might be from dianders@chromium.org are


