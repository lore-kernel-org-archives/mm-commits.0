Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2CD14010
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tPC3JlBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF402C433C9;
	Fri, 29 Dec 2023 20:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881413;
	bh=8yow6AHH63LS8RYej8QVZyyoIpw8s0QIfBcFrfk3UKA=;
	h=Date:To:From:Subject:From;
	b=tPC3JlByInPmkwu5Y7U1rFZhqqbcadmpjV2JsEEtNDraEwPxw61wdqH5MnHFW5fYi
	 A6ue65+x6agVNIkvhk6JRXgn8Te28uFGOcDSsHw55JSSabqW2j05c7WUbhKIiyP/g8
	 xjP8tqFS8J/YO+Wqm+cVWC9/3qYU+Qcsd3MUyntQ=
Date: Fri, 29 Dec 2023 12:23:32 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,lizhe.67@bytedance.com,lecopzer.chen@mediatek.com,kernelfans@gmail.com,john.ogness@linutronix.de,dianders@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-hardlockup-adopt-softlockup-logic-avoiding-double-dumps.patch removed from -mm tree
Message-Id: <20231229202332.EF402C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog/hardlockup: adopt softlockup logic avoiding double-dumps
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-adopt-softlockup-logic-avoiding-double-dumps.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: watchdog/hardlockup: adopt softlockup logic avoiding double-dumps
Date: Wed, 20 Dec 2023 13:15:34 -0800

Patch series "watchdog: Better handling of concurrent lockups".

When we get multiple lockups at roughly the same time, the output in the
kernel logs can be very confusing since the reports about the lockups end
up interleaved in the logs.  There is some code in the kernel to try to
handle this but it wasn't that complete.

Li Zhe recently made this a bit better for softlockups (specifically for
the case where `kernel.softlockup_all_cpu_backtrace` is not set) in commit
9d02330abd3e ("softlockup: serialized softlockup's log"), but that only
handled softlockup reports.  Hardlockup reports still had similar issues.

This series also has a small fix to avoid dumping all stacks a second time
in the case of a panic.  This is a bit unrelated to the interleaving fixes
but it does also improve the clarity of lockup reports.


This patch (of 4):

The hardlockup detector and softlockup detector both have the ability to
dump the stack of all CPUs (`kernel.hardlockup_all_cpu_backtrace` and
`kernel.softlockup_all_cpu_backtrace`).  Both detectors also have some
logic to attempt to avoid interleaving printouts if two CPUs were trying
to do dumps of all CPUs at the same time.  However:

- The hardlockup detector's logic still allowed interleaving some
  information. Specifically another CPU could print modules and dump
  the stack of the locked CPU at the same time we were dumping all
  CPUs.

- In the case where `kernel.hardlockup_panic` was set in addition to
  `kernel.hardlockup_all_cpu_backtrace`, when two CPUs both detected
  hardlockups at the same time the second CPU could call panic() while
  the first was still dumping stacks. This was especially bad if the
  locked up CPU wasn't responding to the request for a backtrace since
  the function nmi_trigger_cpumask_backtrace() can wait up to 10
  seconds.

Let's resolve this by adopting the softlockup logic in the hardlockup
handler.

NOTES:

- As part of this, one might think that we should make a helper
  function that both the hard and softlockup detectors call. This
  turns out not to be super trivial since it would have to be
  parameterized quite a bit since there are separate global variables
  controlling each lockup detector and they print log messages that
  are just different enough that it would be a pain. We probably don't
  want to change the messages that are printed without good reason to
  avoid throwing log parsers for a loop.

- One might also think that it would be a good idea to have the
  hardlockup and softlockup detector use the same global variable to
  prevent interleaving. This would make sure that softlockups and
  hardlockups can't interleave each other. That _almost_ works but has
  a dangerous flaw if `kernel.hardlockup_panic` is not the same as
  `kernel.softlockup_panic` because we might skip a call to panic() if
  one type of lockup was detected at the same time as another.

Link: https://lkml.kernel.org/r/20231220211640.2023645-1-dianders@chromium.org
Link: https://lkml.kernel.org/r/20231220131534.1.I4f35a69fbb124b5f0c71f75c631e11fabbe188ff@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/kernel/watchdog.c~watchdog-hardlockup-adopt-softlockup-logic-avoiding-double-dumps
+++ a/kernel/watchdog.c
@@ -91,7 +91,7 @@ static DEFINE_PER_CPU(atomic_t, hrtimer_
 static DEFINE_PER_CPU(int, hrtimer_interrupts_saved);
 static DEFINE_PER_CPU(bool, watchdog_hardlockup_warned);
 static DEFINE_PER_CPU(bool, watchdog_hardlockup_touched);
-static unsigned long watchdog_hardlockup_all_cpu_dumped;
+static unsigned long hard_lockup_nmi_warn;
 
 notrace void arch_touch_nmi_watchdog(void)
 {
@@ -156,6 +156,15 @@ void watchdog_hardlockup_check(unsigned
 		if (per_cpu(watchdog_hardlockup_warned, cpu))
 			return;
 
+		/*
+		 * Prevent multiple hard-lockup reports if one cpu is already
+		 * engaged in dumping all cpu back traces.
+		 */
+		if (sysctl_hardlockup_all_cpu_backtrace) {
+			if (test_and_set_bit_lock(0, &hard_lockup_nmi_warn))
+				return;
+		}
+
 		pr_emerg("Watchdog detected hard LOCKUP on cpu %d\n", cpu);
 		print_modules();
 		print_irqtrace_events(current);
@@ -168,13 +177,10 @@ void watchdog_hardlockup_check(unsigned
 			trigger_single_cpu_backtrace(cpu);
 		}
 
-		/*
-		 * Perform multi-CPU dump only once to avoid multiple
-		 * hardlockups generating interleaving traces
-		 */
-		if (sysctl_hardlockup_all_cpu_backtrace &&
-		    !test_and_set_bit(0, &watchdog_hardlockup_all_cpu_dumped))
+		if (sysctl_hardlockup_all_cpu_backtrace) {
 			trigger_allbutcpu_cpu_backtrace(cpu);
+			clear_bit_unlock(0, &hard_lockup_nmi_warn);
+		}
 
 		if (hardlockup_panic)
 			nmi_panic(regs, "Hard LOCKUP");
_

Patches currently in -mm which might be from dianders@chromium.org are


