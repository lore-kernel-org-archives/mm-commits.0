From: akpm@linux-foundation.org
Subject: + rtc-handle-errors-correctly-in-rtc_irq_set_state.patch added to -mm tree
Date: Fri, 22 Jul 2011 15:11:42 -0700
Message-ID: <201107222211.p6MMBgFJ018066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916Ab1GVWMB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 18:12:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, greearb@candelatech.com, john.stultz@linaro.org, mingo@elte.hu, stable@kernel.org


The patch titled
     rtc: handle errors correctly in rtc_irq_set_state()
has been added to the -mm tree.  Its filename is
     rtc-handle-errors-correctly-in-rtc_irq_set_state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: handle errors correctly in rtc_irq_set_state()
From: Thomas Gleixner <tglx@linutronix.de>

The code checks the correctness of the parameters, but unconditionally
arms/disarms the hrtimer.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ben Greear <greearb@candelatech.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/rtc/interface.c~rtc-handle-errors-correctly-in-rtc_irq_set_state drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-handle-errors-correctly-in-rtc_irq_set_state
+++ a/drivers/rtc/interface.c
@@ -656,6 +656,8 @@ int rtc_irq_set_state(struct rtc_device 
 		err = -EBUSY;
 	if (rtc->irq_task != task)
 		err = -EACCES;
+	if (err)
+		goto out;
 
 	if (enabled) {
 		ktime_t period = ktime_set(0, NSEC_PER_SEC/rtc->irq_freq);
@@ -664,6 +666,7 @@ int rtc_irq_set_state(struct rtc_device 
 		hrtimer_cancel(&rtc->pie_timer);
 	}
 	rtc->pie_enabled = enabled;
+out:
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
 
 	return err;
_

Patches currently in -mm which might be from tglx@linutronix.de are

linux-next.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long-fix.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
x86-fix-mmap-random-address-range.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface.patch
arch-x86-kernel-e820c-eliminate-bubble-sort-from-sanitize_e820_map.patch
x86-olpc-add-missing-elements-to-device-tree.patch
x86-olpc-move-cs5536-related-constants-to-cs5535h.patch
x86-olpc-rename-olpc-xo1-to-olpc-xo1-pm.patch
x86-olpc-add-xo-1-suspend-resume-support.patch
x86-olpc-add-xo-1-sci-driver-and-power-button-control.patch
x86-olpc-ec-sci-wakeup-mask-functionality.patch
x86-olpc-xo1-sci-add-gpe-handler-and-ebook-switch-functionality.patch
x86-olpc-xo1-sci-add-lid-switch-functionality.patch
x86-olpc-xo1-sci-propagate-power-supply-battery-events.patch
x86-olpc-add-xo-1-rtc-driver.patch
x86-olpc-add-xo-15-sci-driver.patch
genirq-fix-missing-parenthesises-in-generic-chip.patch
pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const.patch
cross-memory-attach-v3.patch
hpet-factor-timer-allocate-from-open.patch
maintainers-update-high-resolution-timers-patterns.patch
rtc-handle-errors-correctly-in-rtc_irq_set_state.patch
rtc-limit-frequency.patch
rtc-fix-hrtimer-deadlock.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

