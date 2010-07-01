From: akpm@linux-foundation.org
Subject: + serial-avr32-fix-rs485-for-atmel_serial.patch added to -mm tree
Date: Thu, 01 Jul 2010 15:37:59 -0700
Message-ID: <201007012237.o61MbxIn002071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756404Ab0GAWjC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jul 2010 18:39:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterhuewe@gmx.de, Sebastian.Heutling@who-ing.de, br@pwrnet.de, claudio@evidence.eu.com, michael@evidence.eu.com, rick@efn.org, rmk+kernel@arm.linux.org.uk, ryan@bluewatersys.com


The patch titled
     serial: avr32: fix rs485 for atmel_serial
has been added to the -mm tree.  Its filename is
     serial-avr32-fix-rs485-for-atmel_serial.patch

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
Subject: serial: avr32: fix rs485 for atmel_serial
From: Peter Huewe <peterhuewe@gmx.de>

Fix a build failure [1-4] in the atmel_serial code introduced by
e8faff7330a3501eafc9bfe5f4f15af444be29f5 ("ARM: 6092/1: atmel_serial:
support for RS485 communications").

The build failure was caused by missing struct field and missing defines
for the avr32 board - the patch fixes this.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Cc: Sebastian Heutling <Sebastian.Heutling@who-ing.de>
Cc: Bernhard Roth <br@pwrnet.de>
Cc: Ryan Mallon <ryan@bluewatersys.com>
Cc: Claudio Scordino <claudio@evidence.eu.com>
Cc: Michael Trimarchi <michael@evidence.eu.com>
Cc: Rick Bronson <rick@efn.org>
Cc: Sebastian Heutling <Sebastian.Heutling@who-ing.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/include/asm/ioctls.h             |    3 +++
 arch/avr32/mach-at32ap/include/mach/board.h |    2 ++
 drivers/serial/atmel_serial.c               |    1 +
 3 files changed, 6 insertions(+)

diff -puN arch/avr32/include/asm/ioctls.h~serial-avr32-fix-rs485-for-atmel_serial arch/avr32/include/asm/ioctls.h
--- a/arch/avr32/include/asm/ioctls.h~serial-avr32-fix-rs485-for-atmel_serial
+++ a/arch/avr32/include/asm/ioctls.h
@@ -54,6 +54,9 @@
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 
+#define TIOCGRS485      0x542E
+#define TIOCSRS485      0x542F
+
 #define FIONCLEX	0x5450
 #define FIOCLEX		0x5451
 #define FIOASYNC	0x5452
diff -puN arch/avr32/mach-at32ap/include/mach/board.h~serial-avr32-fix-rs485-for-atmel_serial arch/avr32/mach-at32ap/include/mach/board.h
--- a/arch/avr32/mach-at32ap/include/mach/board.h~serial-avr32-fix-rs485-for-atmel_serial
+++ a/arch/avr32/mach-at32ap/include/mach/board.h
@@ -5,6 +5,7 @@
 #define __ASM_ARCH_BOARD_H
 
 #include <linux/types.h>
+#include <linux/serial.h>
 
 #define GPIO_PIN_NONE	(-1)
 
@@ -35,6 +36,7 @@ struct atmel_uart_data {
 	short		use_dma_tx;	/* use transmit DMA? */
 	short		use_dma_rx;	/* use receive DMA? */
 	void __iomem	*regs;		/* virtual base address, if any */
+	struct serial_rs485	rs485;		/* rs485 settings */
 };
 void at32_map_usart(unsigned int hw_id, unsigned int line, int flags);
 struct platform_device *at32_add_device_usart(unsigned int id);
diff -puN drivers/serial/atmel_serial.c~serial-avr32-fix-rs485-for-atmel_serial drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~serial-avr32-fix-rs485-for-atmel_serial
+++ a/drivers/serial/atmel_serial.c
@@ -41,6 +41,7 @@
 #include <linux/uaccess.h>
 
 #include <asm/io.h>
+#include <asm/ioctls.h>
 
 #include <asm/mach/serial_at91.h>
 #include <mach/board.h>
_

Patches currently in -mm which might be from peterhuewe@gmx.de are

serial-avr32-fix-rs485-for-atmel_serial.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch

