From: akpm@linux-foundation.org
Subject: [to-be-updated]
 add-another-clock-for-use-with-the-soft-lockup-watchdog.patch removed from
 -mm tree
Date: Tue, 06 Jan 2015 13:02:43 -0800
Message-ID: <54ac4d73.kM0G1Pn2mOu0yfAn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbAFVCt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 16:02:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cyrilbur@gmail.com, atomlin@redhat.com, benh@kernel.crashing.org, benzh@chromium.org, chaiw.fnst@cn.fujitsu.com, drjones@redhat.com, dzickus@redhat.com, fabf@skynet.be, mingo@kernel.org, mpe@ellerman.id.au, tglx@linutronix.de, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: add another clock for use with the soft lockup watchdog.
has been removed from the -mm tree.  Its filename was
     add-another-clock-for-use-with-the-soft-lockup-watchdog.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Cyril Bur <cyrilbur@gmail.com>
Subject: kernel/watchdog.c: add another clock for use with the soft lockup watchdog.

When the hypervisor pauses a virtualised kernel the kernel will observe a
jump in timebase, this can cause spurious messages from the softlockup
detector.

Whilst these messages are harmless, they are accompanied with a stack
trace which causes undue concern and more problematically the stack trace
in the guest has nothing to do with the observed problem and can only be
misleading.

Futhermore, on POWER8 this is completely avoidable with the introduction
of the Virtual Time Base (VTB) register.


This patch (of 2):

This permits the use of arch specific clocks for which virtualised kernels
can use their notion of 'running' time, not the elpased wall time which
will include host execution time.

Signed-off-by: Cyril Bur <cyrilbur@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Jones <drjones@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: chai wen <chaiw.fnst@cn.fujitsu.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Ben Zhang <benzh@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 +
 kernel/sched/clock.c  |   14 ++++++++++++++
 kernel/watchdog.c     |    2 +-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff -puN include/linux/sched.h~add-another-clock-for-use-with-the-soft-lockup-watchdog include/linux/sched.h
--- a/include/linux/sched.h~add-another-clock-for-use-with-the-soft-lockup-watchdog
+++ a/include/linux/sched.h
@@ -2145,6 +2145,7 @@ extern unsigned long long notrace sched_
  */
 extern u64 cpu_clock(int cpu);
 extern u64 local_clock(void);
+extern u64 running_clock(void);
 extern u64 sched_clock_cpu(int cpu);
 
 
diff -puN kernel/sched/clock.c~add-another-clock-for-use-with-the-soft-lockup-watchdog kernel/sched/clock.c
--- a/kernel/sched/clock.c~add-another-clock-for-use-with-the-soft-lockup-watchdog
+++ a/kernel/sched/clock.c
@@ -74,6 +74,20 @@ unsigned long long __weak sched_clock(vo
 }
 EXPORT_SYMBOL_GPL(sched_clock);
 
+/*
+ * Running clock - returns the time that has elapsed while a guest has been
+ * running.
+ * On a guest this value should be sched_clock minus the time the
+ * guest was suspended by the hypervisor (for any reason).
+ * On bare metal this function should return the same as sched_clock.
+ * Architectures and sub-architectures can override this.
+ */
+unsigned long long __weak running_clock(void)
+{
+	return sched_clock();
+}
+EXPORT_SYMBOL_GPL(running_clock);
+
 __read_mostly int sched_clock_running;
 
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
diff -puN kernel/watchdog.c~add-another-clock-for-use-with-the-soft-lockup-watchdog kernel/watchdog.c
--- a/kernel/watchdog.c~add-another-clock-for-use-with-the-soft-lockup-watchdog
+++ a/kernel/watchdog.c
@@ -154,7 +154,7 @@ static int get_softlockup_thresh(void)
  */
 static unsigned long get_timestamp(void)
 {
-	return local_clock() >> 30LL;  /* 2^30 ~= 10^9 */
+	return running_clock() >> 30LL;  /* 2^30 ~= 10^9 */
 }
 
 static void set_sample_period(void)
_

Patches currently in -mm which might be from cyrilbur@gmail.com are

add-another-clock-for-use-with-the-soft-lockup-watchdog-fix.patch
powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings.patch

