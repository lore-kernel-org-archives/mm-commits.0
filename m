From: akpm@linux-foundation.org
Subject: + hrtimer-fix-abs-clock-realtimepatch.patch added to -mm tree
Date: Wed, 13 Feb 2008 16:31:33 -0800
Message-ID: <200802140031.m1E0VXMd022368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44094 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765630AbYBNAha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 19:37:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, elendil@planet.nl, johnstul@us.ibm.com, mingo@elte.hu


The patch titled
     hrtimer: fix abs clock realtime
has been added to the -mm tree.  Its filename is
     hrtimer-fix-abs-clock-realtimepatch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hrtimer: fix abs clock realtime
From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Frans Pop <elendil@planet.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN kernel/hrtimer.c~hrtimer-fix-abs-clock-realtimepatch kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimer-fix-abs-clock-realtimepatch
+++ a/kernel/hrtimer.c
@@ -425,6 +425,8 @@ static int hrtimer_reprogram(struct hrti
 	ktime_t expires = ktime_sub(timer->expires, base->offset);
 	int res;
 
+	WARN_ON_ONCE(timer->expires.tv64 < 0);
+
 	/*
 	 * When the callback is running, we do not reprogram the clock event
 	 * device. The timer callback is either running on a different CPU or
@@ -435,6 +437,15 @@ static int hrtimer_reprogram(struct hrti
 	if (hrtimer_callback_running(timer))
 		return 0;
 
+	/*
+	 * CLOCK_REALTIME timer might be requested with an absolute
+	 * expiry time which is less than base->offset. Nothing wrong
+	 * about that, just avoid to call into the tick code, which
+	 * has now objections against negative expiry values.
+	 */
+	if (expires.tv64 < 0)
+		return -ETIME;
+
 	if (expires.tv64 >= expires_next->tv64)
 		return 0;
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
hrtimer-fix-abs-clock-realtimepatch.patch
git-kvm.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
pci-disable-decoding-during-sizing-of-bars.patch
execute-tasklets-in-the-same-order-they-were-queued.patch
git-x86.patch
git-x86-cpa-build-fix.patch
x86-amd-thermal-interrupt-support.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
x86-visws-fix-printk-format-warnings.patch
x86-minor-cleanup-of-comments-in-processorh.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
rtc-cmos-display-hpet-emulation-mode.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
xtime_lock-vs-update_process_times.patch
x86-configurable-dmi-scanning-code.patch
