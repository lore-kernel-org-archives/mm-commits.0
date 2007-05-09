From: akpm@linux-foundation.org
Subject: + fix-i2c-pxa-build.patch added to -mm tree
Date: Wed, 09 May 2007 12:05:15 -0700
Message-ID: <200705091905.l49J5HlO031141@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756856AbXEITGJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 15:06:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rmk@arm.linux.org.uk, khali@linux-fr.org, rmk+kernel@arm.linux.org.uk


The patch titled
     arm: fix i2c-pxa build
has been added to the -mm tree.  Its filename is
     fix-i2c-pxa-build.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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
rename-thread_info-to-stack.patch
fix-i2c-pxa-build.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
iop13xx-msi-support-rev6.patch
arm-remove-useless-config-option-generic_bust_spinlock.patch
arm-spinlock-initializer-cleanup.patch
update-documentation-driver-model-platformtxt.patch
power-management-remove-some-useless-code-from-arm.patch
git-md-accel.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
