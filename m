From: akpm@linux-foundation.org
Subject: + bcm1480-serial-build-fix.patch added to -mm tree
Date: Fri, 31 Aug 2007 12:18:06 -0700
Message-ID: <200708311918.l7VJILEW022565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47496 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932850AbXHaTTC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 15:19:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ths@networkno.de, ralf@linux-mips.org


The patch titled
     BCM1480 serial build fix
has been added to the -mm tree.  Its filename is
     bcm1480-serial-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: BCM1480 serial build fix
From: Thiemo Seufer <ths@networkno.de>

Restores serial functionality for the BCM1480.

Signed-off-by: Thiemo Seufer <ths@networkno.de>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/sb1250-duart.c          |    6 ++++++
 include/asm-mips/sibyte/bcm1480_regs.h |    5 +++++
 2 files changed, 11 insertions(+)

diff -puN drivers/serial/sb1250-duart.c~bcm1480-serial-build-fix drivers/serial/sb1250-duart.c
--- a/drivers/serial/sb1250-duart.c~bcm1480-serial-build-fix
+++ a/drivers/serial/sb1250-duart.c
@@ -58,6 +58,12 @@
 #define SBD_CTRLREGS(line)	A_BCM1480_DUART_CTRLREG((line), 0)
 #define SBD_INT(line)		(K_BCM1480_INT_UART_0 + (line))
 
+#define DUART_CHANREG_SPACING	BCM1480_DUART_CHANREG_SPACING
+
+#define R_DUART_IMRREG(line)	R_BCM1480_DUART_IMRREG(line)
+#define R_DUART_INCHREG(line)	R_BCM1480_DUART_INCHREG(line)
+#define R_DUART_ISRREG(line)	R_BCM1480_DUART_ISRREG(line)
+
 #elif defined(CONFIG_SIBYTE_SB1250) || defined(CONFIG_SIBYTE_BCM112X)
 #include <asm/sibyte/sb1250_regs.h>
 #include <asm/sibyte/sb1250_int.h>
diff -puN include/asm-mips/sibyte/bcm1480_regs.h~bcm1480-serial-build-fix include/asm-mips/sibyte/bcm1480_regs.h
--- a/include/asm-mips/sibyte/bcm1480_regs.h~bcm1480-serial-build-fix
+++ a/include/asm-mips/sibyte/bcm1480_regs.h
@@ -227,10 +227,15 @@
 	(A_BCM1480_DUART(chan) +					\
 	 BCM1480_DUART_CHANREG_SPACING * 3 + (reg))
 
+#define DUART_IMRISR_SPACING	    0x20
+#define DUART_INCHNG_SPACING	    0x10
+
 #define R_BCM1480_DUART_IMRREG(chan)					\
 	(R_DUART_IMR_A + ((chan) & 1) * DUART_IMRISR_SPACING)
 #define R_BCM1480_DUART_ISRREG(chan)					\
 	(R_DUART_ISR_A + ((chan) & 1) * DUART_IMRISR_SPACING)
+#define R_BCM1480_DUART_INCHREG(chan)					\
+	(R_DUART_IN_CHNG_A + ((chan) & 1) * DUART_INCHNG_SPACING)
 
 #define A_BCM1480_DUART_IMRREG(chan)					\
 	(A_BCM1480_DUART_CTRLREG((chan), R_BCM1480_DUART_IMRREG(chan)))
_

Patches currently in -mm which might be from ths@networkno.de are

bcm1480-serial-build-fix.patch
