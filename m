From: akpm@linux-foundation.org
Subject: - blackfin-on-chip-rtc-controller-driver-fix-rtc_update_irq-augument.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:14:58 -0700
Message-ID: <200704301914.l3UJExtN012570@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946677AbXD3TPD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:15:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     Blackfin: rtc fix rtc_update_irq augument
has been removed from the -mm tree.  Its filename was
     blackfin-on-chip-rtc-controller-driver-fix-rtc_update_irq-augument.patch

This patch was dropped because it was folded into blackfin-on-chip-rtc-controller-driver.patch

------------------------------------------------------
Subject: Blackfin: rtc fix rtc_update_irq augument
From: "Wu, Bryan" <bryan.wu@analog.com>

Replacing class_dev to directly using rtc_dev.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-bfin.c~blackfin-on-chip-rtc-controller-driver-fix-rtc_update_irq-augument drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~blackfin-on-chip-rtc-controller-driver-fix-rtc_update_irq-augument
+++ a/drivers/rtc/rtc-bfin.c
@@ -166,7 +166,7 @@ static irqreturn_t bfin_rtc_interrupt(in
 		events |= RTC_UF | RTC_IRQF;
 	}
 
-	rtc_update_irq(&rtc->rtc_dev->class_dev, 1, events);
+	rtc_update_irq(rtc->rtc_dev, 1, events);
 
 	spin_unlock_irq(&rtc->lock);
 
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
blackfin-arch.patch
driver_bfin_serial_core.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-on-chip-rtc-controller-driver-fix-rtc_update_irq-augument.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver-cleanup-and-coding-style-fixing.patch
blackfin-blackfin-on-chip-spi-controller-driver-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-spi-controller-driver-update-according-to-david-brownells-review.patch
blackfin-serial-core-driver-uart1-should-depend-on-bf534-bf536-bf537-remove-experimental-marking-from-on-chip-serial-core-driver-and-make-options-less-wordy.patch
move-die-notifier-handling-to-common-code-fix.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
