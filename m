From: akpm@linux-foundation.org
Subject: - fix-i2c-pxa-build.patch removed from -mm tree
Date: Fri, 11 May 2007 22:15:19 -0700
Message-ID: <200705120515.l4C5FJc3001743@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756359AbXELFPt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:15:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmk@arm.linux.org.uk, khali@linux-fr.org, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arm: fix i2c-pxa build
has been removed from the -mm tree.  Its filename was
     fix-i2c-pxa-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arm: fix i2c-pxa build
From: Russell King <rmk@arm.linux.org.uk>

From commit 7d054817b780e664bed6701b2aa637718e1905b7:
> According to the PXA27x developer's manual, we shall do so.

We shall also at least compile test our changes.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-pxa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/i2c/busses/i2c-pxa.c~fix-i2c-pxa-build drivers/i2c/busses/i2c-pxa.c
--- a/drivers/i2c/busses/i2c-pxa.c~fix-i2c-pxa-build
+++ a/drivers/i2c/busses/i2c-pxa.c
@@ -548,7 +548,7 @@ static inline void i2c_pxa_stop_message(
 	 */
 	icr = readl(_ICR(i2c));
 	icr &= ~(ICR_STOP | ICR_ACKNAK);
-	writel(icr, _IRC(i2c));
+	writel(icr, _ICR(i2c));
 }
 
 /*
_

Patches currently in -mm which might be from rmk@arm.linux.org.uk are

origin.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
iop13xx-msi-support-rev6.patch
arm-remove-useless-config-option-generic_bust_spinlock.patch
arm-spinlock-initializer-cleanup.patch
arm-stacktrace-fix.patch
update-documentation-driver-model-platformtxt.patch
power-management-remove-some-useless-code-from-arm.patch
git-md-accel.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
serial-use-resource_size_t-for-port-io-addresses.patch
ucb1x00-do-not-access-input_dev-private-directly.patch
