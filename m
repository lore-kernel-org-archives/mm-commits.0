Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710E911719
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 22:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SKgaKrQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4550C433C9;
	Thu, 21 Dec 2023 22:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703198149;
	bh=ZeIqwSSwoulvkDcUFKITqFbriGraYgZwcNW31joyIeQ=;
	h=Date:To:From:Subject:From;
	b=SKgaKrQfbnzqQtB7HPvKDG3GEcpwY9CtxVHfJ2s0ZMpIrimpIySrUA6DctCWxwZsW
	 coUNFcuiYKllJgVa8WzlaiCYQNGbgPfFdVtOr+pbBdYXgtF0gKynPUJfwuKl78xO6z
	 9GQbZpqs4LEjqxFOXnq4hUfy6SILGKi4en486i6c=
Date: Thu, 21 Dec 2023 14:35:49 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,lizhe.67@bytedance.com,lecopzer.chen@mediatek.com,kernelfans@gmail.com,john.ogness@linutronix.de,dianders@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-softlockup-use-printk_cpu_sync_get_irqsave-to-serialize-reporting.patch added to mm-nonmm-unstable branch
Message-Id: <20231221223549.C4550C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog/softlockup: use printk_cpu_sync_get_irqsave() to serialize reporting
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-softlockup-use-printk_cpu_sync_get_irqsave-to-serialize-reporting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-softlockup-use-printk_cpu_sync_get_irqsave-to-serialize-reporting.patch

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
From: Douglas Anderson <dianders@chromium.org>
Subject: watchdog/softlockup: use printk_cpu_sync_get_irqsave() to serialize reporting
Date: Wed, 20 Dec 2023 13:15:35 -0800

Instead of introducing a spinlock, use printk_cpu_sync_get_irqsave() and
printk_cpu_sync_put_irqrestore() to serialize softlockup reporting.  Alone
this doesn't have any real advantage over the spinlock, but this will
allow us to use the same function in a future change to also serialize
hardlockup crawls.

NOTE: for the most part this serialization is important because we often
end up in the show_regs() path and that has no built-in serialization if
there are multiple callers at once.  However, even in the case where we
end up in the dump_stack() path this still has some advantages because the
stack will be guaranteed to be together in the logs with the lockup
message with no interleaving.

NOTE: the fact that printk_cpu_sync_get_irqsave() is allowed to be called
multiple times on the same CPU is important here.  Specifically we hold
the "lock" while calling dump_stack() which also gets the same "lock". 
This is explicitly documented to be OK and means we don't need to
introduce a variant of dump_stack() that doesn't grab the lock.

Link: https://lkml.kernel.org/r/20231220131534.2.Ia5906525d440d8e8383cde31b7c61c2aadc8f907@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/watchdog.c~watchdog-softlockup-use-printk_cpu_sync_get_irqsave-to-serialize-reporting
+++ a/kernel/watchdog.c
@@ -454,7 +454,7 @@ static enum hrtimer_restart watchdog_tim
 	struct pt_regs *regs = get_irq_regs();
 	int duration;
 	int softlockup_all_cpu_backtrace = sysctl_softlockup_all_cpu_backtrace;
-	static DEFINE_SPINLOCK(watchdog_output_lock);
+	unsigned long flags;
 
 	if (!watchdog_enabled)
 		return HRTIMER_NORESTART;
@@ -521,7 +521,7 @@ static enum hrtimer_restart watchdog_tim
 		/* Start period for the next softlockup warning. */
 		update_report_ts();
 
-		spin_lock(&watchdog_output_lock);
+		printk_cpu_sync_get_irqsave(flags);
 		pr_emerg("BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
 			smp_processor_id(), duration,
 			current->comm, task_pid_nr(current));
@@ -531,7 +531,7 @@ static enum hrtimer_restart watchdog_tim
 			show_regs(regs);
 		else
 			dump_stack();
-		spin_unlock(&watchdog_output_lock);
+		printk_cpu_sync_put_irqrestore(flags);
 
 		if (softlockup_all_cpu_backtrace) {
 			trigger_allbutcpu_cpu_backtrace(smp_processor_id());
_

Patches currently in -mm which might be from dianders@chromium.org are

watchdog-hardlockup-adopt-softlockup-logic-avoiding-double-dumps.patch
watchdog-softlockup-use-printk_cpu_sync_get_irqsave-to-serialize-reporting.patch
watchdog-hardlockup-use-printk_cpu_sync_get_irqsave-to-serialize-reporting.patch
watchdog-if-panicking-and-we-dumped-everything-dont-re-enable-dumping.patch

