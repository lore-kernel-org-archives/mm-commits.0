From: akpm@linux-foundation.org
Subject: - atmel_serial-fix-interrupt-handler-return-value.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:44:36 -0800
Message-ID: <200802250044.m1P0iaXG006123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753048AbYBYAo4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:44:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, trimarchi@gandalf.sssup.it, mm-commits@vger.kernel.org


The patch titled
     atmel_serial: fix interrupt handler return value
has been removed from the -mm tree.  Its filename was
     atmel_serial-fix-interrupt-handler-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_serial: fix interrupt handler return value
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

We should only return IRQ_HANDLED when we actually found something to
handle. This is important since the USART interrupt handler may be
shared with the timer interrupt on some chips.

Pointed-out-by: michael <trimarchi@gandalf.sssup.it>
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-fix-interrupt-handler-return-value drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-fix-interrupt-handler-return-value
+++ a/drivers/serial/atmel_serial.c
@@ -549,7 +549,7 @@ static irqreturn_t atmel_interrupt(int i
 		atmel_handle_transmit(port, pending);
 	} while (pass_counter++ < ATMEL_ISR_PASS_LIMIT);
 
-	return IRQ_HANDLED;
+	return pass_counter ? IRQ_HANDLED : IRQ_NONE;
 }
 
 /*
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

git-avr32.patch
macb-fix-speed-setting.patch
taint-kernel-after-warn_oncondition.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
