From: akpm@linux-foundation.org
Subject: + rtc-limit-frequency.patch added to -mm tree
Date: Fri, 22 Jul 2011 15:11:44 -0700
Message-ID: <201107222211.p6MMBixa018070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750956Ab1GVWME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 18:12:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, greearb@candelatech.com, john.stultz@linaro.org, mingo@elte.hu, stable@kernel.org


The patch titled
     rtc: limit frequency
has been added to the -mm tree.  Its filename is
     rtc-limit-frequency.patch

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
Subject: rtc: limit frequency
From: Thomas Gleixner <tglx@linutronix.de>

The RTC hrtimer is self rearming.  We really need to limit the frequency
to something sensible.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ben Greear <greearb@candelatech.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/interface.c~rtc-limit-frequency drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-limit-frequency
+++ a/drivers/rtc/interface.c
@@ -688,7 +688,7 @@ int rtc_irq_set_freq(struct rtc_device *
 	int err = 0;
 	unsigned long flags;
 
-	if (freq <= 0)
+	if (freq <= 0 || freq > 5000)
 		return -EINVAL;
 
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
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

