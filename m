From: akpm@linux-foundation.org
Subject: [merged] arm-fix-for-atmel-at91-powersaving.patch removed from -mm tree
Date: Tue, 24 Feb 2009 11:32:34 -0800
Message-ID: <200902241932.n1OJWYAv004433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754058AbZBXTde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 14:33:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrei.birjukov@artecdesign.ee, linux@maxim.org.za, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arm: fix for Atmel AT91 powersaving
has been removed from the -mm tree.  Its filename was
     arm-fix-for-atmel-at91-powersaving.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: fix for Atmel AT91 powersaving
From: Andrei Birjukov <andrei.birjukov@artecdesign.ee>

We've discovered that our AT91SAM9260 board consumed too much power when
returning from a slowclock low-power mode.  RAM self-refresh is enabled in
a bootloader in our case, this is how we saw a difference.  Estimated ca. 
30mA more on 4V battery than the same state before powersaving.

After a small research we found that there seems to be a bogus
sdram_selfrefresh_disable() call at the end of at91_pm_enter() call, which
overwrites the LPR register with uninitialized value.  Please find the
suggested patch attached.

This patch fixes correct restoring of LPR register of the Atmel AT91 SDRAM
controller when returning from a power saving mode.

Signed-off-by: Andrei Birjukov <andrei.birjukov@artecdesign.ee>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Andrew Victor <linux@maxim.org.za>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/pm.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/arm/mach-at91/pm.c~arm-fix-for-atmel-at91-powersaving arch/arm/mach-at91/pm.c
--- a/arch/arm/mach-at91/pm.c~arm-fix-for-atmel-at91-powersaving
+++ a/arch/arm/mach-at91/pm.c
@@ -332,7 +332,6 @@ static int at91_pm_enter(suspend_state_t
 			at91_sys_read(AT91_AIC_IPR) & at91_sys_read(AT91_AIC_IMR));
 
 error:
-	sdram_selfrefresh_disable();
 	target_state = PM_SUSPEND_ON;
 	at91_irq_resume();
 	at91_gpio_resume();
_

Patches currently in -mm which might be from andrei.birjukov@artecdesign.ee are

linux-next.patch

