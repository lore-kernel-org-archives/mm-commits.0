From: akpm@linux-foundation.org
Subject: + hrtimer-prevent-overrun-dos-in-hrtimer_forward.patch added to -mm tree
Date: Wed, 14 Mar 2007 04:09:06 -0800
Message-ID: <200703141109.l2EB97jf023188@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59862 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161123AbXCNLKy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Mar 2007 07:10:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, stable@kernel.org


The patch titled
     hrtimer: prevent overrun DoS in hrtimer_forward()
has been added to the -mm tree.  Its filename is
     hrtimer-prevent-overrun-dos-in-hrtimer_forward.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hrtimer: prevent overrun DoS in hrtimer_forward()
From: Thomas Gleixner <tglx@linutronix.de>

hrtimer_forward() does not check for the possible overflow of
timer->expires.  This can happen on 64 bit machines with large interval
values and results currently in an endless loop in the softirq because the
expiry value becomes negative and therefor the timer is expired all the
time.

Check for this condition and set the expiry value to the max.  expiry time
in the future.  The fix should be applied to stable kernel series as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN kernel/hrtimer.c~hrtimer-prevent-overrun-dos-in-hrtimer_forward kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimer-prevent-overrun-dos-in-hrtimer_forward
+++ a/kernel/hrtimer.c
@@ -644,6 +644,12 @@ hrtimer_forward(struct hrtimer *timer, k
 		orun++;
 	}
 	timer->expires = ktime_add(timer->expires, interval);
+	/*
+	 * Make sure, that the result did not wrap with a very large
+	 * interval.
+	 */
+	if (timer->expires.tv64 < 0)
+		timer->expires = ktime_set(KTIME_SEC_MAX, 0);
 
 	return orun;
 }
_

Patches currently in -mm which might be from tglx@linutronix.de are

hrtimer-prevent-overrun-dos-in-hrtimer_forward.patch
paravirt-build-fixes.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-4.patch
git-ieee1394.patch
log-reason-why-tsc-was-marked-unstable.patch
optimize-timespec_trunc.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
