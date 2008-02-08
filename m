From: akpm@linux-foundation.org
Subject: + mxser-convert-large-macros-to-functions.patch added to -mm tree
Date: Fri, 08 Feb 2008 13:41:26 -0800
Message-ID: <200802082141.m18LfQAj014748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45057 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758102AbYBHVmc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:42:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, jirislaby@gmail.com


The patch titled
     mxser: convert large macros to functions
has been added to the -mm tree.  Its filename is
     mxser-convert-large-macros-to-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mxser: convert large macros to functions
From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |  229 ++++++++++++++++++++++++++++++++++++++---
 drivers/char/mxser.h |  137 ------------------------
 2 files changed, 214 insertions(+), 152 deletions(-)

diff -puN drivers/char/mxser.c~mxser-convert-large-macros-to-functions drivers/char/mxser.c
--- a/drivers/char/mxser.c~mxser-convert-large-macros-to-functions
+++ a/drivers/char/mxser.c
@@ -307,6 +307,200 @@ static unsigned char mxser_msr[MXSER_POR
 static struct mxser_mon_ext mon_data_ext;
 static int mxser_set_baud_method[MXSER_PORTS + 1];
 
+static void mxser_enable_must_enchance_mode(unsigned long baseio)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr |= MOXA_MUST_EFR_EFRB_ENABLE;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
+static void mxser_disable_must_enchance_mode(unsigned long baseio)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_EFRB_ENABLE;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
+static void mxser_set_must_xon1_value(unsigned long baseio, u8 value)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_BANK_MASK;
+	efr |= MOXA_MUST_EFR_BANK0;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	outb(value, baseio + MOXA_MUST_XON1_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
+static void mxser_set_must_xoff1_value(unsigned long baseio, u8 value)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_BANK_MASK;
+	efr |= MOXA_MUST_EFR_BANK0;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	outb(value, baseio + MOXA_MUST_XOFF1_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
+static void mxser_set_must_fifo_value(struct mxser_port *info)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(info->ioaddr + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, info->ioaddr + UART_LCR);
+
+	efr = inb(info->ioaddr + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_BANK_MASK;
+	efr |= MOXA_MUST_EFR_BANK1;
+
+	outb(efr, info->ioaddr + MOXA_MUST_EFR_REGISTER);
+	outb((u8)info->rx_high_water, info->ioaddr + MOXA_MUST_RBRTH_REGISTER);
+	outb((u8)info->rx_trigger, info->ioaddr + MOXA_MUST_RBRTI_REGISTER);
+	outb((u8)info->rx_low_water, info->ioaddr + MOXA_MUST_RBRTL_REGISTER);
+	outb(oldlcr, info->ioaddr + UART_LCR);
+}
+
+static void mxser_set_must_enum_value(unsigned long baseio, u8 value)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_BANK_MASK;
+	efr |= MOXA_MUST_EFR_BANK2;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	outb(value, baseio + MOXA_MUST_ENUM_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
+static void mxser_get_must_hardware_id(unsigned long baseio, u8 *pId)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_BANK_MASK;
+	efr |= MOXA_MUST_EFR_BANK2;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	*pId = inb(baseio + MOXA_MUST_HWID_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
+static void SET_MOXA_MUST_NO_SOFTWARE_FLOW_CONTROL(unsigned long baseio)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_SF_MASK;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
+static void mxser_enable_must_tx_software_flow_control(unsigned long baseio)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_SF_TX_MASK;
+	efr |= MOXA_MUST_EFR_SF_TX1;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
+static void mxser_disable_must_tx_software_flow_control(unsigned long baseio)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_SF_TX_MASK;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
+static void mxser_enable_must_rx_software_flow_control(unsigned long baseio)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_SF_RX_MASK;
+	efr |= MOXA_MUST_EFR_SF_RX1;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
+static void mxser_disable_must_rx_software_flow_control(unsigned long baseio)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_SF_RX_MASK;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
 #ifdef CONFIG_PCI
 static int __devinit CheckIsMoxaMust(unsigned long io)
 {
@@ -314,16 +508,16 @@ static int __devinit CheckIsMoxaMust(uns
 	int i;
 
 	outb(0, io + UART_LCR);
-	DISABLE_MOXA_MUST_ENCHANCE_MODE(io);
+	mxser_disable_must_enchance_mode(io);
 	oldmcr = inb(io + UART_MCR);
 	outb(0, io + UART_MCR);
-	SET_MOXA_MUST_XON1_VALUE(io, 0x11);
+	mxser_set_must_xon1_value(io, 0x11);
 	if ((hwid = inb(io + UART_MCR)) != 0) {
 		outb(oldmcr, io + UART_MCR);
 		return MOXA_OTHER_UART;
 	}
 
-	GET_MOXA_MUST_HARDWARE_ID(io, &hwid);
+	mxser_get_must_hardware_id(io, &hwid);
 	for (i = 1; i < UART_INFO_NUM; i++) { /* 0 = OTHER_UART */
 		if (hwid == Gpci_uart_info[i].type)
 			return (int)hwid;
@@ -494,10 +688,10 @@ static int mxser_set_baud(struct mxser_p
 		} else
 			quot /= newspd;
 
-		SET_MOXA_MUST_ENUM_VALUE(info->ioaddr, quot);
+		mxser_set_must_enum_value(info->ioaddr, quot);
 	} else
 #endif
-		SET_MOXA_MUST_ENUM_VALUE(info->ioaddr, 0);
+		mxser_set_must_enum_value(info->ioaddr, 0);
 
 	return 0;
 }
@@ -553,14 +747,14 @@ static int mxser_change_speed(struct mxs
 		if (info->board->chip_flag) {
 			fcr = UART_FCR_ENABLE_FIFO;
 			fcr |= MOXA_MUST_FCR_GDA_MODE_ENABLE;
-			SET_MOXA_MUST_FIFO_VALUE(info);
+			mxser_set_must_fifo_value(info);
 		} else
 			fcr = 0;
 	} else {
 		fcr = UART_FCR_ENABLE_FIFO;
 		if (info->board->chip_flag) {
 			fcr |= MOXA_MUST_FCR_GDA_MODE_ENABLE;
-			SET_MOXA_MUST_FIFO_VALUE(info);
+			mxser_set_must_fifo_value(info);
 		} else {
 			switch (info->rx_trigger) {
 			case 1:
@@ -657,17 +851,21 @@ static int mxser_change_speed(struct mxs
 		}
 	}
 	if (info->board->chip_flag) {
-		SET_MOXA_MUST_XON1_VALUE(info->ioaddr, START_CHAR(info->tty));
-		SET_MOXA_MUST_XOFF1_VALUE(info->ioaddr, STOP_CHAR(info->tty));
+		mxser_set_must_xon1_value(info->ioaddr, START_CHAR(info->tty));
+		mxser_set_must_xoff1_value(info->ioaddr, STOP_CHAR(info->tty));
 		if (I_IXON(info->tty)) {
-			ENABLE_MOXA_MUST_RX_SOFTWARE_FLOW_CONTROL(info->ioaddr);
+			mxser_enable_must_rx_software_flow_control(
+					info->ioaddr);
 		} else {
-			DISABLE_MOXA_MUST_RX_SOFTWARE_FLOW_CONTROL(info->ioaddr);
+			mxser_disable_must_rx_software_flow_control(
+					info->ioaddr);
 		}
 		if (I_IXOFF(info->tty)) {
-			ENABLE_MOXA_MUST_TX_SOFTWARE_FLOW_CONTROL(info->ioaddr);
+			mxser_enable_must_tx_software_flow_control(
+					info->ioaddr);
 		} else {
-			DISABLE_MOXA_MUST_TX_SOFTWARE_FLOW_CONTROL(info->ioaddr);
+			mxser_disable_must_tx_software_flow_control(
+					info->ioaddr);
 		}
 	}
 
@@ -1925,7 +2123,8 @@ static void mxser_set_termios(struct tty
 
 		if (info->board->chip_flag) {
 			spin_lock_irqsave(&info->slock, flags);
-			DISABLE_MOXA_MUST_RX_SOFTWARE_FLOW_CONTROL(info->ioaddr);
+			mxser_disable_must_rx_software_flow_control(
+					info->ioaddr);
 			spin_unlock_irqrestore(&info->slock, flags);
 		}
 
@@ -2342,7 +2541,7 @@ static int __devinit mxser_initbrd(struc
 
 		/* Enhance mode enabled here */
 		if (brd->chip_flag != MOXA_OTHER_UART)
-			ENABLE_MOXA_MUST_ENCHANCE_MODE(info->ioaddr);
+			mxser_enable_must_enchance_mode(info->ioaddr);
 
 		info->flags = ASYNC_SHARE_IRQ;
 		info->type = brd->uart_type;
diff -puN drivers/char/mxser.h~mxser-convert-large-macros-to-functions drivers/char/mxser.h
--- a/drivers/char/mxser.h~mxser-convert-large-macros-to-functions
+++ a/drivers/char/mxser.h
@@ -147,141 +147,4 @@
 /* Rx software flow control mask */
 #define MOXA_MUST_EFR_SF_RX_MASK	0x03
 
-#define ENABLE_MOXA_MUST_ENCHANCE_MODE(baseio) do { 		\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr |= MOXA_MUST_EFR_EFRB_ENABLE;			\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
-#define DISABLE_MOXA_MUST_ENCHANCE_MODE(baseio) do {		\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr &= ~MOXA_MUST_EFR_EFRB_ENABLE;			\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
-#define SET_MOXA_MUST_XON1_VALUE(baseio, Value) do {		\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr &= ~MOXA_MUST_EFR_BANK_MASK;			\
-	__efr |= MOXA_MUST_EFR_BANK0;				\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	outb((u8)(Value), (baseio)+MOXA_MUST_XON1_REGISTER);	\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
-#define SET_MOXA_MUST_XOFF1_VALUE(baseio, Value) do {		\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr &= ~MOXA_MUST_EFR_BANK_MASK;			\
-	__efr |= MOXA_MUST_EFR_BANK0;				\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	outb((u8)(Value), (baseio)+MOXA_MUST_XOFF1_REGISTER);	\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
-#define SET_MOXA_MUST_FIFO_VALUE(info) do {			\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((info)->ioaddr+UART_LCR);		\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (info)->ioaddr+UART_LCR);\
-	__efr = inb((info)->ioaddr+MOXA_MUST_EFR_REGISTER);	\
-	__efr &= ~MOXA_MUST_EFR_BANK_MASK;			\
-	__efr |= MOXA_MUST_EFR_BANK1;				\
-	outb(__efr, (info)->ioaddr+MOXA_MUST_EFR_REGISTER);	\
-	outb((u8)((info)->rx_high_water), (info)->ioaddr+	\
-			MOXA_MUST_RBRTH_REGISTER);		\
-	outb((u8)((info)->rx_trigger), (info)->ioaddr+		\
-			MOXA_MUST_RBRTI_REGISTER);		\
-	outb((u8)((info)->rx_low_water), (info)->ioaddr+	\
-			MOXA_MUST_RBRTL_REGISTER);		\
-	outb(__oldlcr, (info)->ioaddr+UART_LCR);		\
-} while (0)
-
-#define SET_MOXA_MUST_ENUM_VALUE(baseio, Value) do {		\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr &= ~MOXA_MUST_EFR_BANK_MASK;			\
-	__efr |= MOXA_MUST_EFR_BANK2;				\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	outb((u8)(Value), (baseio)+MOXA_MUST_ENUM_REGISTER);	\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
-#define GET_MOXA_MUST_HARDWARE_ID(baseio, pId) do {		\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr &= ~MOXA_MUST_EFR_BANK_MASK;			\
-	__efr |= MOXA_MUST_EFR_BANK2;				\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	*pId = inb((baseio)+MOXA_MUST_HWID_REGISTER);		\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
-#define SET_MOXA_MUST_NO_SOFTWARE_FLOW_CONTROL(baseio) do {	\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr &= ~MOXA_MUST_EFR_SF_MASK;			\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
-#define ENABLE_MOXA_MUST_TX_SOFTWARE_FLOW_CONTROL(baseio) do {	\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr &= ~MOXA_MUST_EFR_SF_TX_MASK;			\
-	__efr |= MOXA_MUST_EFR_SF_TX1;				\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
-#define DISABLE_MOXA_MUST_TX_SOFTWARE_FLOW_CONTROL(baseio) do {	\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr &= ~MOXA_MUST_EFR_SF_TX_MASK;			\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
-#define ENABLE_MOXA_MUST_RX_SOFTWARE_FLOW_CONTROL(baseio) do {	\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr &= ~MOXA_MUST_EFR_SF_RX_MASK;			\
-	__efr |= MOXA_MUST_EFR_SF_RX1;				\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
-#define DISABLE_MOXA_MUST_RX_SOFTWARE_FLOW_CONTROL(baseio) do {	\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr &= ~MOXA_MUST_EFR_SF_RX_MASK;			\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
 #endif
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
git-unionfs.patch
git-xfs.patch
uml-update-defconfig.patch
reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
rename-open_namei-to-open_pathname.patch
rename-open_namei-to-open_pathname-vs-git-acpi.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
introduce-path_get-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
introduce-path_put-unionfs.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
mxser-convert-large-macros-to-functions.patch
vfs-create-proc-pid-mountinfo.patch
reiserfs-use-open_bdev_excl.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
