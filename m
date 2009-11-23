From: akpm@linux-foundation.org
Subject: + serial-add-configuration-c-flag-for-9-bit-mode.patch added to -mm tree
Date: Mon, 23 Nov 2009 13:34:38 -0800
Message-ID: <200911232134.nANLYc7V009862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755098AbZKWVes (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 16:34:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jpinkasfeld@aldebaran-robotics.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com


The patch titled
     serial: add configuration c-flag for 9-bit mode
has been added to the -mm tree.  Its filename is
     serial-add-configuration-c-flag-for-9-bit-mode.patch

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
Subject: serial: add configuration c-flag for 9-bit mode
From: Joseph Pinkasfeld <jpinkasfeld@aldebaran-robotics.com>

Add 9-bit bit mode configuration registers for 16C950.  Tested on OXPCIe954.

Signed-off-by: pinkasfeld joseph <jpinkasfeld@aldebaran-robotics.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/termbits.h     |    1 +
 arch/avr32/include/asm/termbits.h   |    1 +
 arch/cris/include/asm/termbits.h    |    1 +
 arch/frv/include/asm/termbits.h     |    1 +
 arch/h8300/include/asm/termbits.h   |    1 +
 arch/ia64/include/asm/termbits.h    |    1 +
 arch/m32r/include/asm/termbits.h    |    1 +
 arch/m68k/include/asm/termbits.h    |    1 +
 arch/mips/include/asm/termbits.h    |    1 +
 arch/mn10300/include/asm/termbits.h |    1 +
 arch/parisc/include/asm/termbits.h  |    1 +
 arch/powerpc/include/asm/termbits.h |    1 +
 arch/sparc/include/asm/termbits.h   |    1 +
 arch/xtensa/include/asm/termbits.h  |    1 +
 drivers/serial/serial_core.c        |    2 ++
 include/asm-generic/termbits.h      |    1 +
 include/linux/serial_reg.h          |    9 ++++++++-
 17 files changed, 25 insertions(+), 1 deletion(-)

diff -puN arch/arm/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode arch/arm/include/asm/termbits.h
--- a/arch/arm/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode
+++ a/arch/arm/include/asm/termbits.h
@@ -155,6 +155,7 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
+#define CNBENB    001000000000 /* 9 bit enable */
 #define CIBAUD	  002003600000		/* input baud rate */
 #define CMSPAR    010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
diff -puN arch/avr32/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode arch/avr32/include/asm/termbits.h
--- a/arch/avr32/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode
+++ a/arch/avr32/include/asm/termbits.h
@@ -155,6 +155,7 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
+#define CNBENB    001000000000 /* 9 bit enable */
 #define CIBAUD	  002003600000	/* input baud rate (not used) */
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
diff -puN arch/cris/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode arch/cris/include/asm/termbits.h
--- a/arch/cris/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode
+++ a/arch/cris/include/asm/termbits.h
@@ -195,6 +195,7 @@ struct ktermios {
  * shifted left IBSHIFT bits.
  */
 #define IBSHIFT   16
+#define CNBENB    001000000000 /* 9 bit enable */
 #define CMSPAR    010000000000 /* mark or space (stick) parity - PARODD=space*/
 #define CRTSCTS	  020000000000		/* flow control */
 
diff -puN arch/frv/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode arch/frv/include/asm/termbits.h
--- a/arch/frv/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode
+++ a/arch/frv/include/asm/termbits.h
@@ -157,6 +157,7 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
+#define CNBENB    001000000000 /* 9 bit enable */
 #define CIBAUD	  002003600000		/* Input baud rate */
 #define CTVB	  004000000000		/* VisioBraille Terminal flow control */
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
diff -puN arch/h8300/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode arch/h8300/include/asm/termbits.h
--- a/arch/h8300/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode
+++ a/arch/h8300/include/asm/termbits.h
@@ -157,6 +157,7 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
+#define CNBENB    001000000000 /* 9 bit enable */
 #define CIBAUD	  002003600000		/* input baud rate */
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
diff -puN arch/ia64/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode arch/ia64/include/asm/termbits.h
--- a/arch/ia64/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode
+++ a/arch/ia64/include/asm/termbits.h
@@ -165,6 +165,7 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
+#define CNBENB    001000000000 /* 9 bit enable */
 #define CIBAUD	  002003600000		/* input baud rate */
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
diff -puN arch/m32r/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode arch/m32r/include/asm/termbits.h
--- a/arch/m32r/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode
+++ a/arch/m32r/include/asm/termbits.h
@@ -156,6 +156,7 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
+#define CNBENB    001000000000 /* 9 bit enable */
 #define CIBAUD	  002003600000		/** input baud rate */
 #define CTVB	  004000000000		/* VisioBraille Terminal flow control */
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
diff -puN arch/m68k/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode arch/m68k/include/asm/termbits.h
--- a/arch/m68k/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode
+++ a/arch/m68k/include/asm/termbits.h
@@ -157,6 +157,7 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
+#define CNBENB    001000000000 /* 9 bit enable */
 #define CIBAUD	  002003600000		/* input baud rate */
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
diff -puN arch/mips/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode arch/mips/include/asm/termbits.h
--- a/arch/mips/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode
+++ a/arch/mips/include/asm/termbits.h
@@ -180,6 +180,7 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
+#define CNBENB    001000000000 /* 9 bit enable */
 #define CIBAUD	  002003600000	/* input baud rate */
 #define CMSPAR    010000000000	/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000	/* flow control */
diff -puN arch/mn10300/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode arch/mn10300/include/asm/termbits.h
--- a/arch/mn10300/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode
+++ a/arch/mn10300/include/asm/termbits.h
@@ -157,6 +157,7 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
+#define CNBENB    001000000000 /* 9 bit enable */
 #define CIBAUD	  002003600000	/* input baud rate (not used) */
 #define CTVB	  004000000000		/* VisioBraille Terminal flow control */
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
diff -puN arch/parisc/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode arch/parisc/include/asm/termbits.h
--- a/arch/parisc/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode
+++ a/arch/parisc/include/asm/termbits.h
@@ -157,6 +157,7 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
+#define CNBENB    001000000000 /* 9 bit enable */
 #define CIBAUD    002003600000		/* input baud rate */
 #define CMSPAR    010000000000          /* mark or space (stick) parity */
 #define CRTSCTS   020000000000          /* flow control */
diff -puN arch/powerpc/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode arch/powerpc/include/asm/termbits.h
--- a/arch/powerpc/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode
+++ a/arch/powerpc/include/asm/termbits.h
@@ -170,6 +170,7 @@ struct ktermios {
 #define HUPCL	00040000
 
 #define CLOCAL	00100000
+#define CNBENB    001000000000 /* 9 bit enable */
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
 
diff -puN arch/s390/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode arch/s390/include/asm/termbits.h
diff -puN arch/sparc/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode arch/sparc/include/asm/termbits.h
--- a/arch/sparc/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode
+++ a/arch/sparc/include/asm/termbits.h
@@ -202,6 +202,7 @@ struct ktermios {
 #define B3000000  0x00001011
 #define B3500000  0x00001012
 #define B4000000  0x00001013  */
+#define CNBENB    0x8000000 /* 9 bit enable */
 #define CIBAUD	  0x100f0000  /* input baud rate (not used) */
 #define CMSPAR	  0x40000000  /* mark or space (stick) parity */
 #define CRTSCTS	  0x80000000  /* flow control */
diff -puN arch/xtensa/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode arch/xtensa/include/asm/termbits.h
--- a/arch/xtensa/include/asm/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode
+++ a/arch/xtensa/include/asm/termbits.h
@@ -173,6 +173,7 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
+#define CNBENB    001000000000 /* 9 bit enable */
 #define CIBAUD	  002003600000		/* input baud rate */
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
diff -puN drivers/serial/serial_core.c~serial-add-configuration-c-flag-for-9-bit-mode drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-add-configuration-c-flag-for-9-bit-mode
+++ a/drivers/serial/serial_core.c
@@ -294,6 +294,8 @@ uart_update_timeout(struct uart_port *po
 		break; /* CS8 */
 	}
 
+	if (cflag & CNBENB)
+		bits = 11;
 	if (cflag & CSTOPB)
 		bits++;
 	if (cflag & PARENB)
diff -puN include/asm-generic/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode include/asm-generic/termbits.h
--- a/include/asm-generic/termbits.h~serial-add-configuration-c-flag-for-9-bit-mode
+++ a/include/asm-generic/termbits.h
@@ -156,6 +156,7 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
+#define CNBENB    001000000000 /* 9 bit enable */
 #define CIBAUD	  002003600000	/* input baud rate */
 #define CMSPAR	  010000000000	/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000	/* flow control */
diff -puN include/linux/serial_reg.h~serial-add-configuration-c-flag-for-9-bit-mode include/linux/serial_reg.h
--- a/include/linux/serial_reg.h~serial-add-configuration-c-flag-for-9-bit-mode
+++ a/include/linux/serial_reg.h
@@ -116,9 +116,11 @@
 #define UART_LSR_BI		0x10 /* Break interrupt indicator */
 #define UART_LSR_FE		0x08 /* Frame error indicator */
 #define UART_LSR_PE		0x04 /* Parity error indicator */
+#define UART_LSR_9TH_BIT		0x04 /* 9th bit received in 9bit mode */
 #define UART_LSR_OE		0x02 /* Overrun error indicator */
 #define UART_LSR_DR		0x01 /* Receiver data ready */
 #define UART_LSR_BRK_ERROR_BITS	0x1E /* BI, FE, PE, OE bits */
+#define UART_LSR_NBM_BRK_ERROR_BITS	0x1A /* BI,FE,OE bits in 9bit mode */
 
 #define UART_MSR	6	/* In:  Modem Status Register */
 #define UART_MSR_DCD		0x80 /* Data Carrier Detect */
@@ -259,7 +261,12 @@
 #define UART_ACR_ICRRD	0x40	/* ICR Read enable */
 #define UART_ACR_ASREN	0x80	/* Additional status enable */
 
