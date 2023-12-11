Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A972A7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EmRMoBB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BB2C433C9;
	Mon, 11 Dec 2023 01:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257841;
	bh=jBhDKdFcMKpnKAMPQ7SUhT7Qek0lCB8dVRQl42Y7A3Y=;
	h=Date:To:From:Subject:From;
	b=EmRMoBB1t0eZ4ezUChlfNwUit3AttY+NzFnh8tV+Ja5VF5mt96VASZCWRfNCAcU6a
	 itPvGttvLIac5+vR9Eqxn5UJ8/uuh1ujJckxlIexSPprGu+cEroTUHe4bwUzoCirVu
	 NFuEbyHWcvdg4G6lHojWdVaEc72MDoXBH2F++0E0=
Date: Sun, 10 Dec 2023 17:24:00 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,lizefan.x@bytedance.com,lecopzer.chen@mediatek.com,kernelfans@gmail.com,john.ogness@linutronix.de,dianders@chromium.org,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] softlockup-serialized-softlockups-log.patch removed from -mm tree
Message-Id: <20231211012401.75BB2C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: softlockup: serialized softlockup's log
has been removed from the -mm tree.  Its filename was
     softlockup-serialized-softlockups-log.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: John Ogness <john.ogness@linutronix.de>
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


