From: akpm@linux-foundation.org
Subject: - rtc-fix-reported-irq-rate-for-when-hpet-is-enabled.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:50:36 -0700
Message-ID: <200807112350.m6BNoa6K010971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754576AbYGKXvO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:51:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.gortmaker@windriver.com, david-b@pacbell.net, mingo@elte.hu, stable@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     rtc: fix reported IRQ rate for when HPET is enabled
has been removed from the -mm tree.  Its filename was
     rtc-fix-reported-irq-rate-for-when-hpet-is-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: fix reported IRQ rate for when HPET is enabled
From: Paul Gortmaker <paul.gortmaker@windriver.com>

The IRQ rate reported back by the RTC is incorrect when HPET is enabled.

Newer hardware that has HPET to emulate the legacy RTC device gets this value
wrong since after it sets the rate, it returns before setting the variable
used to report the IRQ rate back to users of the device -- so the set rate and
the reported rate get out of sync.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Brownell <david-b@pacbell.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/rtc.c~rtc-fix-reported-irq-rate-for-when-hpet-is-enabled drivers/char/rtc.c
--- a/drivers/char/rtc.c~rtc-fix-reported-irq-rate-for-when-hpet-is-enabled
+++ a/drivers/char/rtc.c
@@ -678,12 +678,13 @@ static int rtc_do_ioctl(unsigned int cmd
 		if (arg != (1<<tmp))
 			return -EINVAL;
 
+		rtc_freq = arg;
+
 		spin_lock_irqsave(&rtc_lock, flags);
 		if (hpet_set_periodic_freq(arg)) {
 			spin_unlock_irqrestore(&rtc_lock, flags);
 			return 0;
 		}
-		rtc_freq = arg;
 
 		val = CMOS_READ(RTC_FREQ_SELECT) & 0xf0;
 		val |= (16 - tmp);
_

Patches currently in -mm which might be from paul.gortmaker@windriver.com are

origin.patch

