From: akpm@linux-foundation.org
Subject: - hrtimer-fix-abs-clock-realtimepatch.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:23:30 -0500
Message-ID: <200802150226.m1F2Qn7J015256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42628 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762037AbYBOC2h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:28:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, elendil@planet.nl, johnstul@us.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     hrtimer: fix abs clock realtime
has been removed from the -mm tree.  Its filename was
     hrtimer-fix-abs-clock-realtimepatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-hrt.patch
git-kvm.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
pci-disable-decoding-during-sizing-of-bars.patch
execute-tasklets-in-the-same-order-they-were-queued.patch
x86-amd-thermal-interrupt-support.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
x86-visws-fix-printk-format-warnings.patch
x86-minor-cleanup-of-comments-in-processorh.patch
documentation-i386-io-apictxt-fix-description.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
rtc-cmos-display-hpet-emulation-mode.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
dmi-prevent-linked-list-corruption-resent.patch
x86-fix-clearcopy_user_page-declarations-in-pageh.patch
futex-fix-init-order.patch
futex-runtime-enable-pi-and-robust-functionality.patch
x86-configurable-dmi-scanning-code.patch
asm-futexh-should-include-linux-uaccessh.patch
