From: akpm@linux-foundation.org
Subject: - at91-atmel_pwm-only-available-for-certain-at91-processors.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:12:10 -0700
Message-ID: <200810182312.m9INCAS7027939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287AbYJRXM2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:12:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avictor.za@gmail.com, hskinnemoen@atmel.com, linux@maxim.org.za, mm-commits@vger.kernel.org


The patch titled
     AT91: atmel_pwm only available for certain AT91 processors
has been removed from the -mm tree.  Its filename was
     at91-atmel_pwm-only-available-for-certain-at91-processors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: AT91: atmel_pwm only available for certain AT91 processors
From: "Andrew Victor" <avictor.za@gmail.com>

Only three of Atmel's AT91 processors (SAM9263, SAM9RL and CAP9) include a
PWM controller.

It should therefore only be possible to enable the misc/atmel_pwm.c driver
on those processors (and not all AT91 processors).

Signed-off-by: Andrew Victor <linux@maxim.org.za>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/Kconfig~at91-atmel_pwm-only-available-for-certain-at91-processors drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~at91-atmel_pwm-only-available-for-certain-at91-processors
+++ a/drivers/misc/Kconfig
@@ -15,7 +15,7 @@ if MISC_DEVICES
 
 config ATMEL_PWM
 	tristate "Atmel AT32/AT91 PWM support"
-	depends on AVR32 || ARCH_AT91
+	depends on AVR32 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91CAP9
 	help
 	  This option enables device driver support for the PWM channels
 	  on certain Atmel prcoessors.  Pulse Width Modulation is used for
_

Patches currently in -mm which might be from avictor.za@gmail.com are

origin.patch

