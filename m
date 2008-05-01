From: akpm@linux-foundation.org
Subject: - char-ip2-macros-cleanup.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:48 -0700
Message-ID: <200805010929.m419TmNr030712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462AbYEAJ3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: ip2, macros cleanup
has been removed from the -mm tree.  Its filename was
     char-ip2-macros-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: ip2, macros cleanup
From: Jiri Slaby <jirislaby@gmail.com>

- remove i2os.h -- there was only macro to macro renaming or useless
  stuff
- remove another uselless stuf (NULLFUNC, NULLPTR, YES, NO)
- use outb/inb directly
- use locking functions directly
- don't define another ROUNDUP, use roundup(x, 2) instead
- some comments and whitespace cleanup
- remove some commented crap
- prepend the rest by I2 prefix to not collide with rest of the world
  like in following output (pointed out by akpm)

In file included from drivers/char/ip2/ip2main.c:128:
drivers/char/ip2/i2ellis.h:608:1: warning: "COMPLETE" redefined
In file included from include/net/netns/ipv4.h:8,
                 from include/net/net_namespace.h:13,
                 from include/linux/seq_file.h:7,
                 from include/asm/machdep.h:12,
                 from include/asm/pci.h:17,
                 from include/linux/pci.h:951,
                 from drivers/char/ip2/ip2main.c:95:
include/net/inet_frag.h:28:1: warning: this is the location of the previous definition

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/i2ellis.c |  194 ++++++++++++++++-------------------
 drivers/char/ip2/i2ellis.h |   58 +---------
 drivers/char/ip2/i2hw.h    |    6 -
 drivers/char/ip2/i2lib.c   |  141 +++++++++++++------------
 drivers/char/ip2/i2os.h    |  127 ----------------------
 drivers/char/ip2/ip2main.c |   68 ++++++------
 6 files changed, 211 insertions(+), 383 deletions(-)

diff -puN drivers/char/ip2/i2ellis.c~char-ip2-macros-cleanup drivers/char/ip2/i2ellis.c
--- a/drivers/char/ip2/i2ellis.c~char-ip2-macros-cleanup
+++ a/drivers/char/ip2/i2ellis.c
@@ -53,7 +53,7 @@ static int ii2Safe;         // Safe I/O 
 
 static int iiDelayed;	// Set when the iiResetDelay function is
 							// called. Cleared when ANY board is reset.
-static rwlock_t Dl_spinlock;
+static DEFINE_RWLOCK(Dl_spinlock);
 
 //********
 //* Code *
@@ -82,7 +82,6 @@ static rwlock_t Dl_spinlock;
 static void
 iiEllisInit(void)
 {
-	LOCK_INIT(&Dl_spinlock);
 }
 
 //******************************************************************************
@@ -132,7 +131,7 @@ iiSetAddress( i2eBordStrPtr pB, int addr
 		|| (address & 0x7)
 		)
 	{
-		COMPLETE(pB,I2EE_BADADDR);
+		I2_COMPLETE(pB, I2EE_BADADDR);
 	}
 
 	// Initialize accelerators
@@ -152,7 +151,7 @@ iiSetAddress( i2eBordStrPtr pB, int addr
 	pB->i2eValid = I2E_MAGIC;
 	pB->i2eState = II_STATE_COLD;
 
-	COMPLETE(pB, I2EE_GOOD);
+	I2_COMPLETE(pB, I2EE_GOOD);
 }
 
 //******************************************************************************
@@ -177,12 +176,12 @@ iiReset(i2eBordStrPtr pB)
 	// Magic number should be set, else even the address is suspect
 	if (pB->i2eValid != I2E_MAGIC)
 	{
-		COMPLETE(pB, I2EE_BADMAGIC);
+		I2_COMPLETE(pB, I2EE_BADMAGIC);
 	}
 
-	OUTB(pB->i2eBase + FIFO_RESET, 0);  // Any data will do
+	outb(0, pB->i2eBase + FIFO_RESET);  /* Any data will do */
 	iiDelay(pB, 50);                    // Pause between resets
-	OUTB(pB->i2eBase + FIFO_RESET, 0);  // Second reset
+	outb(0, pB->i2eBase + FIFO_RESET);  /* Second reset */
 
 	// We must wait before even attempting to read anything from the FIFO: the
 	// board's P.O.S.T may actually attempt to read and write its end of the
@@ -203,7 +202,7 @@ iiReset(i2eBordStrPtr pB)
 	// Ensure anything which would have been of use to standard loadware is
 	// blanked out, since board has now forgotten everything!.
 
-	pB->i2eUsingIrq = IRQ_UNDEFINED; // Not set up to use an interrupt yet
+	pB->i2eUsingIrq = I2_IRQ_UNDEFINED; /* to not use an interrupt so far */
 	pB->i2eWaitingForEmptyFifo = 0;
 	pB->i2eOutMailWaiting = 0;
 	pB->i2eChannelPtr = NULL;
@@ -215,7 +214,7 @@ iiReset(i2eBordStrPtr pB)
 	pB->i2eFatalTrap = NULL;
 	pB->i2eFatal = 0;
 
-	COMPLETE(pB, I2EE_GOOD);
+	I2_COMPLETE(pB, I2EE_GOOD);
 }
 
 //******************************************************************************
@@ -235,14 +234,14 @@ static int
 iiResetDelay(i2eBordStrPtr pB)
 {
 	if (pB->i2eValid != I2E_MAGIC) {
-		COMPLETE(pB, I2EE_BADMAGIC);
+		I2_COMPLETE(pB, I2EE_BADMAGIC);
 	}
 	if (pB->i2eState != II_STATE_RESET) {
-		COMPLETE(pB, I2EE_BADSTATE);
+		I2_COMPLETE(pB, I2EE_BADSTATE);
 	}
 	iiDelay(pB,2000);       /* Now we wait for two seconds. */
 	iiDelayed = 1;          /* Delay has been called: ok to initialize */
-	COMPLETE(pB, I2EE_GOOD);
+	I2_COMPLETE(pB, I2EE_GOOD);
 }
 
 //******************************************************************************
@@ -273,12 +272,12 @@ iiInitialize(i2eBordStrPtr pB)
 
 	if (pB->i2eValid != I2E_MAGIC)
 	{
-		COMPLETE(pB, I2EE_BADMAGIC);
+		I2_COMPLETE(pB, I2EE_BADMAGIC);
 	}
 
 	if (pB->i2eState != II_STATE_RESET || !iiDelayed)
 	{
-		COMPLETE(pB, I2EE_BADSTATE);
+		I2_COMPLETE(pB, I2EE_BADSTATE);
 	}
 
 	// In case there is a failure short of our completely reading the power-up
@@ -291,13 +290,12 @@ iiInitialize(i2eBordStrPtr pB)
 	for (itemp = 0; itemp < sizeof(porStr); itemp++)
 	{
 		// We expect the entire message is ready.
-		if (HAS_NO_INPUT(pB))
-		{
+		if (!I2_HAS_INPUT(pB)) {
 			pB->i2ePomSize = itemp;
-			COMPLETE(pB, I2EE_PORM_SHORT);
+			I2_COMPLETE(pB, I2EE_PORM_SHORT);
 		}
 
-		pB->i2ePom.c[itemp] = c = BYTE_FROM(pB);
+		pB->i2ePom.c[itemp] = c = inb(pB->i2eData);
 
 		// We check the magic numbers as soon as they are supposed to be read
 		// (rather than after) to minimize effect of reading something we
@@ -306,22 +304,22 @@ iiInitialize(i2eBordStrPtr pB)
 				(itemp == POR_2_INDEX && c != POR_MAGIC_2))
 		{
 			pB->i2ePomSize = itemp+1;
-			COMPLETE(pB, I2EE_BADMAGIC);
+			I2_COMPLETE(pB, I2EE_BADMAGIC);
 		}
 	}
 
 	pB->i2ePomSize = itemp;
 
 	// Ensure that this was all the data...
-	if (HAS_INPUT(pB))
-		COMPLETE(pB, I2EE_PORM_LONG);
+	if (I2_HAS_INPUT(pB))
+		I2_COMPLETE(pB, I2EE_PORM_LONG);
 
 	// For now, we'll fail to initialize if P.O.S.T reports bad chip mapper:
 	// Implying we will not be able to download any code either:  That's ok: the
 	// condition is pretty explicit.
 	if (pB->i2ePom.e.porDiag1 & POR_BAD_MAPPER)
 	{
-		COMPLETE(pB, I2EE_POSTERR);
+		I2_COMPLETE(pB, I2EE_POSTERR);
 	}
 
 	// Determine anything which must be done differently depending on the family
@@ -332,7 +330,7 @@ iiInitialize(i2eBordStrPtr pB)
 
 		pB->i2eFifoStyle   = FIFO_II;
 		pB->i2eFifoSize    = 512;     // 512 bytes, always
-		pB->i2eDataWidth16 = NO;
+		pB->i2eDataWidth16 = false;
 
 		pB->i2eMaxIrq = 15;	// Because board cannot tell us it is in an 8-bit
 							// slot, we do allow it to be done (documentation!)
@@ -354,7 +352,7 @@ iiInitialize(i2eBordStrPtr pB)
 			// should always be consistent for IntelliPort-II.  Ditto below...
 			if (pB->i2ePom.e.porPorts1 != 4)
 			{
-				COMPLETE(pB, I2EE_INCONSIST);
+				I2_COMPLETE(pB, I2EE_INCONSIST);
 			}
 			break;
 
@@ -364,7 +362,7 @@ iiInitialize(i2eBordStrPtr pB)
 			pB->i2eChannelMap[0] = 0xff;  // Eight port
 			if (pB->i2ePom.e.porPorts1 != 8)
 			{
-				COMPLETE(pB, I2EE_INCONSIST);
+				I2_COMPLETE(pB, I2EE_INCONSIST);
 			}
 			break;
 
@@ -373,7 +371,7 @@ iiInitialize(i2eBordStrPtr pB)
 			pB->i2eChannelMap[0] = 0x3f;  // Six Port
 			if (pB->i2ePom.e.porPorts1 != 6)
 			{
-				COMPLETE(pB, I2EE_INCONSIST);
+				I2_COMPLETE(pB, I2EE_INCONSIST);
 			}
 			break;
 		}
@@ -402,7 +400,7 @@ iiInitialize(i2eBordStrPtr pB)
 
 		if (itemp < 8 || itemp > 15)
 		{
-			COMPLETE(pB, I2EE_INCONSIST);
+			I2_COMPLETE(pB, I2EE_INCONSIST);
 		}
 		pB->i2eFifoSize = (1 << itemp);
 
@@ -450,26 +448,26 @@ iiInitialize(i2eBordStrPtr pB)
 		switch (pB->i2ePom.e.porBus & (POR_BUS_SLOT16 | POR_BUS_DIP16) )
 		{
 		case POR_BUS_SLOT16 | POR_BUS_DIP16:
-			pB->i2eDataWidth16 = YES;
+			pB->i2eDataWidth16 = true;
 			pB->i2eMaxIrq = 15;
 			break;
 
 		case POR_BUS_SLOT16:
-			pB->i2eDataWidth16 = NO;
+			pB->i2eDataWidth16 = false;
 			pB->i2eMaxIrq = 15;
 			break;
 
 		case 0:
 		case POR_BUS_DIP16:     // In an 8-bit slot, DIP switch don't care.
 		default:
-			pB->i2eDataWidth16 = NO;
+			pB->i2eDataWidth16 = false;
 			pB->i2eMaxIrq = 7;
 			break;
 		}
 		break;   // POR_ID_FIIEX case
 
 	default:    // Unknown type of board
-		COMPLETE(pB, I2EE_BAD_FAMILY);
+		I2_COMPLETE(pB, I2EE_BAD_FAMILY);
 		break;
 	}  // End the switch based on family
 
@@ -483,17 +481,14 @@ iiInitialize(i2eBordStrPtr pB)
 	{
 	case POR_BUS_T_ISA:
 	case POR_BUS_T_UNK:  // If the type of bus is undeclared, assume ok.
-		pB->i2eChangeIrq = YES;
-		break;
 	case POR_BUS_T_MCA:
 	case POR_BUS_T_EISA:
-		pB->i2eChangeIrq = NO;
 		break;
 	default:
-		COMPLETE(pB, I2EE_BADBUS);
+		I2_COMPLETE(pB, I2EE_BADBUS);
 	}
 
-	if (pB->i2eDataWidth16 == YES)
+	if (pB->i2eDataWidth16)
 	{
 		pB->i2eWriteBuf  = iiWriteBuf16;
 		pB->i2eReadBuf   = iiReadBuf16;
@@ -529,7 +524,7 @@ iiInitialize(i2eBordStrPtr pB)
 		break;
 
 	default:
-		COMPLETE(pB, I2EE_INCONSIST);
+		I2_COMPLETE(pB, I2EE_INCONSIST);
 	}
 
 	// Initialize state information.
@@ -549,7 +544,7 @@ iiInitialize(i2eBordStrPtr pB)
 	// Everything is ok now, return with good status/
 
 	pB->i2eValid = I2E_MAGIC;
-	COMPLETE(pB, I2EE_GOOD);
+	I2_COMPLETE(pB, I2EE_GOOD);
 }
 
 //******************************************************************************
@@ -658,7 +653,7 @@ ii2DelayIO(unsigned int mseconds)
 	while(mseconds--) {
 		int i = ii2DelValue;
 		while ( i-- ) {
-			INB ( ii2Safe );
+			inb(ii2Safe);
 		}
 	}
 }
@@ -709,11 +704,11 @@ iiWriteBuf16(i2eBordStrPtr pB, unsigned 
 {
 	// Rudimentary sanity checking here.
 	if (pB->i2eValid != I2E_MAGIC)
-		COMPLETE(pB, I2EE_INVALID);
+		I2_COMPLETE(pB, I2EE_INVALID);
 
-	OUTSW ( pB->i2eData, address, count);
+	I2_OUTSW(pB->i2eData, address, count);
 
-	COMPLETE(pB, I2EE_GOOD);
+	I2_COMPLETE(pB, I2EE_GOOD);
 }
 
 //******************************************************************************
@@ -738,11 +733,11 @@ iiWriteBuf8(i2eBordStrPtr pB, unsigned c
 {
 	/* Rudimentary sanity checking here */
 	if (pB->i2eValid != I2E_MAGIC)
-		COMPLETE(pB, I2EE_INVALID);
+		I2_COMPLETE(pB, I2EE_INVALID);
 
-	OUTSB ( pB->i2eData, address, count );
+	I2_OUTSB(pB->i2eData, address, count);
 
-	COMPLETE(pB, I2EE_GOOD);
+	I2_COMPLETE(pB, I2EE_GOOD);
 }
 
 //******************************************************************************
@@ -767,11 +762,11 @@ iiReadBuf16(i2eBordStrPtr pB, unsigned c
 {
 	// Rudimentary sanity checking here.
 	if (pB->i2eValid != I2E_MAGIC)
-		COMPLETE(pB, I2EE_INVALID);
+		I2_COMPLETE(pB, I2EE_INVALID);
 
-	INSW ( pB->i2eData, address, count);
+	I2_INSW(pB->i2eData, address, count);
 
-	COMPLETE(pB, I2EE_GOOD);
+	I2_COMPLETE(pB, I2EE_GOOD);
 }
 
 //******************************************************************************
@@ -796,11 +791,11 @@ iiReadBuf8(i2eBordStrPtr pB, unsigned ch
 {
 	// Rudimentary sanity checking here.
 	if (pB->i2eValid != I2E_MAGIC)
-		COMPLETE(pB, I2EE_INVALID);
+		I2_COMPLETE(pB, I2EE_INVALID);
 
-	INSB ( pB->i2eData, address, count);
+	I2_INSB(pB->i2eData, address, count);
 
-	COMPLETE(pB, I2EE_GOOD);
+	I2_COMPLETE(pB, I2EE_GOOD);
 }
 
 //******************************************************************************
@@ -820,7 +815,7 @@ iiReadBuf8(i2eBordStrPtr pB, unsigned ch
 static unsigned short
 iiReadWord16(i2eBordStrPtr pB)
 {
-	return (unsigned short)( INW(pB->i2eData) );
+	return inw(pB->i2eData);
 }
 
 //******************************************************************************
@@ -842,9 +837,9 @@ iiReadWord8(i2eBordStrPtr pB)
 {
 	unsigned short urs;
 
-	urs = INB ( pB->i2eData );
+	urs = inb(pB->i2eData);
 
-	return ( ( INB ( pB->i2eData ) << 8 ) | urs );
+	return (inb(pB->i2eData) << 8) | urs;
 }
 
 //******************************************************************************
@@ -865,7 +860,7 @@ iiReadWord8(i2eBordStrPtr pB)
 static void
 iiWriteWord16(i2eBordStrPtr pB, unsigned short value)
 {
-	WORD_TO(pB, (int)value);
+	outw((int)value, pB->i2eData);
 }
 
 //******************************************************************************
@@ -886,8 +881,8 @@ iiWriteWord16(i2eBordStrPtr pB, unsigned
 static void
 iiWriteWord8(i2eBordStrPtr pB, unsigned short value)
 {
-	BYTE_TO(pB, (char)value);
-	BYTE_TO(pB, (char)(value >> 8) );
+	outb((char)value, pB->i2eData);
+	outb((char)(value >> 8), pB->i2eData);
 }
 
 //******************************************************************************
@@ -939,30 +934,30 @@ iiWaitForTxEmptyII(i2eBordStrPtr pB, int
 		// interrupts of any kind.
 
 
-		WRITE_LOCK_IRQSAVE(&Dl_spinlock,flags)
-		OUTB(pB->i2ePointer, SEL_COMMAND);
-		OUTB(pB->i2ePointer, SEL_CMD_SH);
+		write_lock_irqsave(&Dl_spinlock, flags);
+		outb(SEL_COMMAND, pB->i2ePointer);
+		outb(SEL_CMD_SH, pB->i2ePointer);
 
-		itemp = INB(pB->i2eStatus);
+		itemp = inb(pB->i2eStatus);
 
-		OUTB(pB->i2ePointer, SEL_COMMAND);
-		OUTB(pB->i2ePointer, SEL_CMD_UNSH);
+		outb(SEL_COMMAND, pB->i2ePointer);
+		outb(SEL_CMD_UNSH, pB->i2ePointer);
 
 		if (itemp & ST_IN_EMPTY)
 		{
-			UPDATE_FIFO_ROOM(pB);
-			WRITE_UNLOCK_IRQRESTORE(&Dl_spinlock,flags)
-			COMPLETE(pB, I2EE_GOOD);
+			I2_UPDATE_FIFO_ROOM(pB);
+			write_unlock_irqrestore(&Dl_spinlock, flags);
+			I2_COMPLETE(pB, I2EE_GOOD);
 		}
 
-		WRITE_UNLOCK_IRQRESTORE(&Dl_spinlock,flags)
+		write_unlock_irqrestore(&Dl_spinlock, flags);
 
 		if (mSdelay-- == 0)
 			break;
 
 		iiDelay(pB, 1);      /* 1 mS granularity on checking condition */
 	}
-	COMPLETE(pB, I2EE_TXE_TIME);
+	I2_COMPLETE(pB, I2EE_TXE_TIME);
 }
 
 //******************************************************************************
@@ -1002,21 +997,21 @@ iiWaitForTxEmptyIIEX(i2eBordStrPtr pB, i
 		// you will generally not want to service interrupts or in any way
 		// disrupt the assumptions implicit in the larger context.
 
-		WRITE_LOCK_IRQSAVE(&Dl_spinlock,flags)
+		write_lock_irqsave(&Dl_spinlock, flags);
 
-		if (INB(pB->i2eStatus) & STE_OUT_MT) {
-			UPDATE_FIFO_ROOM(pB);
-			WRITE_UNLOCK_IRQRESTORE(&Dl_spinlock,flags)
-			COMPLETE(pB, I2EE_GOOD);
+		if (inb(pB->i2eStatus) & STE_OUT_MT) {
+			I2_UPDATE_FIFO_ROOM(pB);
+			write_unlock_irqrestore(&Dl_spinlock, flags);
+			I2_COMPLETE(pB, I2EE_GOOD);
 		}
-		WRITE_UNLOCK_IRQRESTORE(&Dl_spinlock,flags)
+		write_unlock_irqrestore(&Dl_spinlock, flags);
 
 		if (mSdelay-- == 0)
 			break;
 
 		iiDelay(pB, 1);      // 1 mS granularity on checking condition
 	}
-	COMPLETE(pB, I2EE_TXE_TIME);
+	I2_COMPLETE(pB, I2EE_TXE_TIME);
 }
 
 //******************************************************************************
@@ -1038,8 +1033,8 @@ static int
 iiTxMailEmptyII(i2eBordStrPtr pB)
 {
 	int port = pB->i2ePointer;
-	OUTB ( port, SEL_OUTMAIL );
-	return ( INB(port) == 0 );
+	outb(SEL_OUTMAIL, port);
+	return inb(port) == 0;
 }
 
 //******************************************************************************
@@ -1060,7 +1055,7 @@ iiTxMailEmptyII(i2eBordStrPtr pB)
 static int
 iiTxMailEmptyIIEX(i2eBordStrPtr pB)
 {
-	return !(INB(pB->i2eStatus) & STE_OUT_MAIL);
+	return !(inb(pB->i2eStatus) & STE_OUT_MAIL);
 }
 
 //******************************************************************************
@@ -1084,10 +1079,10 @@ iiTrySendMailII(i2eBordStrPtr pB, unsign
 {
 	int port = pB->i2ePointer;
 
-	OUTB(port, SEL_OUTMAIL);
-	if (INB(port) == 0) {
-		OUTB(port, SEL_OUTMAIL);
-		OUTB(port, mail);
+	outb(SEL_OUTMAIL, port);
+	if (inb(port) == 0) {
+		outb(SEL_OUTMAIL, port);
+		outb(mail, port);
 		return 1;
 	}
 	return 0;
@@ -1112,10 +1107,9 @@ iiTrySendMailII(i2eBordStrPtr pB, unsign
 static int
 iiTrySendMailIIEX(i2eBordStrPtr pB, unsigned char mail)
 {
-	if(INB(pB->i2eStatus) & STE_OUT_MAIL) {
+	if (inb(pB->i2eStatus) & STE_OUT_MAIL)
 		return 0;
-	}
-	OUTB(pB->i2eXMail, mail);
+	outb(mail, pB->i2eXMail);
 	return 1;
 }
 
@@ -1136,9 +1130,9 @@ iiTrySendMailIIEX(i2eBordStrPtr pB, unsi
 static unsigned short
 iiGetMailII(i2eBordStrPtr pB)
 {
-	if (HAS_MAIL(pB)) {
-		OUTB(pB->i2ePointer, SEL_INMAIL);
-		return INB(pB->i2ePointer);
+	if (I2_HAS_MAIL(pB)) {
+		outb(SEL_INMAIL, pB->i2ePointer);
+		return inb(pB->i2ePointer);
 	} else {
 		return NO_MAIL_HERE;
 	}
@@ -1161,11 +1155,10 @@ iiGetMailII(i2eBordStrPtr pB)
 static unsigned short
 iiGetMailIIEX(i2eBordStrPtr pB)
 {
-	if (HAS_MAIL(pB)) {
-		return INB(pB->i2eXMail);
-	} else {
+	if (I2_HAS_MAIL(pB))
+		return inb(pB->i2eXMail);
+	else
 		return NO_MAIL_HERE;
-	}
 }
 
 //******************************************************************************
@@ -1184,8 +1177,8 @@ iiGetMailIIEX(i2eBordStrPtr pB)
 static void
 iiEnableMailIrqII(i2eBordStrPtr pB)
 {
-	OUTB(pB->i2ePointer, SEL_MASK);
-	OUTB(pB->i2ePointer, ST_IN_MAIL);
+	outb(SEL_MASK, pB->i2ePointer);
+	outb(ST_IN_MAIL, pB->i2ePointer);
 }
 
 //******************************************************************************
@@ -1204,7 +1197,7 @@ iiEnableMailIrqII(i2eBordStrPtr pB)
 static void
 iiEnableMailIrqIIEX(i2eBordStrPtr pB)
 {
-	OUTB(pB->i2eXMask, MX_IN_MAIL);
+	outb(MX_IN_MAIL, pB->i2eXMask);
 }
 
 //******************************************************************************
@@ -1223,8 +1216,8 @@ iiEnableMailIrqIIEX(i2eBordStrPtr pB)
 static void
 iiWriteMaskII(i2eBordStrPtr pB, unsigned char value)
 {
-	OUTB(pB->i2ePointer, SEL_MASK);
-	OUTB(pB->i2ePointer, value);
+	outb(SEL_MASK, pB->i2ePointer);
+	outb(value, pB->i2ePointer);
 }
 
 //******************************************************************************
@@ -1243,7 +1236,7 @@ iiWriteMaskII(i2eBordStrPtr pB, unsigned
 static void
 iiWriteMaskIIEX(i2eBordStrPtr pB, unsigned char value)
 {
-	OUTB(pB->i2eXMask, value);
+	outb(value, pB->i2eXMask);
 }
 
 //******************************************************************************
@@ -1354,9 +1347,8 @@ iiDownloadBlock ( i2eBordStrPtr pB, load
 	// immediately and be harmless, though not strictly necessary.
 	itemp = MAX_DLOAD_ACK_TIME/10;
 	while (--itemp) {
-		if (HAS_INPUT(pB)) {
-			switch(BYTE_FROM(pB))
-			{
+		if (I2_HAS_INPUT(pB)) {
+			switch (inb(pB->i2eData)) {
 			case LOADWARE_OK:
 				pB->i2eState =
 					isStandard ? II_STATE_STDLOADED :II_STATE_LOADED;
diff -puN drivers/char/ip2/i2ellis.h~char-ip2-macros-cleanup drivers/char/ip2/i2ellis.h
--- a/drivers/char/ip2/i2ellis.h~char-ip2-macros-cleanup
+++ a/drivers/char/ip2/i2ellis.h
@@ -185,10 +185,6 @@ typedef struct _i2eBordStr
 						// The highest allowable IRQ, based on the
 						// slot size.
 
-	unsigned char  i2eChangeIrq;
-						// Whether tis valid to change IRQ's
-						// ISA = ok, EISA, MicroChannel, no
-
 	// Accelerators for various addresses on the board
 	int            i2eBase;        // I/O Address of the Board
 	int            i2eData;        // From here data transfers happen
@@ -431,12 +427,6 @@ typedef struct _i2eBordStr
 // Manifests for i2eBordStr:
 //-------------------------------------------
 
-#define YES 1
-#define NO  0
-
-#define NULLFUNC (void (*)(void))0
-#define NULLPTR (void *)0
-
 typedef void (*delayFunc_t)(unsigned int);
 
 // i2eValid
@@ -494,8 +484,8 @@ typedef void (*delayFunc_t)(unsigned int
 
 // i2eUsingIrq
 //
-#define IRQ_UNDEFINED   0x1352  // No valid irq (or polling = 0) can ever
-								// promote to this!
+#define I2_IRQ_UNDEFINED	0x1352  /* No valid irq (or polling = 0) can
+					 * ever promote to this! */
 //------------------------------------------
 // Handy Macros for i2ellis.c and others
 // Note these are common to -II and -IIEX
@@ -504,41 +494,14 @@ typedef void (*delayFunc_t)(unsigned int
 // Given a pointer to the board structure, does the input FIFO have any data or
 // not?
 //
-#define HAS_INPUT(pB)      !(INB(pB->i2eStatus) & ST_IN_EMPTY)
-#define HAS_NO_INPUT(pB)   (INB(pB->i2eStatus) & ST_IN_EMPTY)
-
-// Given a pointer to board structure, read a byte or word from the fifo
-//
-#define BYTE_FROM(pB)      (unsigned char)INB(pB->i2eData)
-#define WORD_FROM(pB)      (unsigned short)INW(pB->i2eData)
-
-// Given a pointer to board structure, is there room for any data to be written
-// to the data fifo?
-//
-#define HAS_OUTROOM(pB)    !(INB(pB->i2eStatus) & ST_OUT_FULL)
-#define HAS_NO_OUTROOM(pB) (INB(pB->i2eStatus) & ST_OUT_FULL)
-
-// Given a pointer to board structure, write a single byte to the fifo
-// structure. Note that for 16-bit interfaces, the high order byte is undefined
-// and unknown.
-//
-#define BYTE_TO(pB, c)     OUTB(pB->i2eData,(c))
-
-// Write a word to the fifo structure. For 8-bit interfaces, this may have
-// unknown results.
-//
-#define WORD_TO(pB, c)     OUTW(pB->i2eData,(c))
+#define I2_HAS_INPUT(pB)	!(inb(pB->i2eStatus) & ST_IN_EMPTY)
 
 // Given a pointer to the board structure, is there anything in the incoming
 // mailbox?
 //
-#define HAS_MAIL(pB)       (INB(pB->i2eStatus) & ST_IN_MAIL)
+#define I2_HAS_MAIL(pB)		(inb(pB->i2eStatus) & ST_IN_MAIL)
 
-#define UPDATE_FIFO_ROOM(pB)  (pB)->i2eFifoRemains=(pB)->i2eFifoSize
-
-// Handy macro to round up a number (like the buffer write and read routines do)
-// 
-#define ROUNDUP(number)    (((number)+1) & (~1))
+#define I2_UPDATE_FIFO_ROOM(pB)	((pB)->i2eFifoRemains = (pB)->i2eFifoSize)
 
 //------------------------------------------
 // Function Declarations for i2ellis.c
@@ -593,20 +556,11 @@ static int iiDownloadBlock(i2eBordStrPtr
 //
 static int iiDownloadAll(i2eBordStrPtr, loadHdrStrPtr, int, int);
 
-// Called indirectly always.  Needed externally so the routine might be
-// SPECIFIED as an argument to iiReset()
-//
-//static void ii2DelayIO(unsigned int);		// N-millisecond delay using
-											//hardware spin
-//static void ii2DelayTimer(unsigned int);	// N-millisecond delay using Linux
-											//timer
-
 // Many functions defined here return True if good, False otherwise, with an
 // error code in i2eError field. Here is a handy macro for setting the error
 // code and returning.
 //
-#define COMPLETE(pB,code) \
-	do { \
+#define I2_COMPLETE(pB,code) do { \
 		 pB->i2eError = code; \
 		 return (code == I2EE_GOOD);\
 	} while (0)
diff -puN drivers/char/ip2/i2hw.h~char-ip2-macros-cleanup drivers/char/ip2/i2hw.h
--- a/drivers/char/ip2/i2hw.h~char-ip2-macros-cleanup
+++ a/drivers/char/ip2/i2hw.h
@@ -129,7 +129,6 @@ registers, use byte operations only.
 //------------------------------------------------
 //
 #include "ip2types.h"
-#include "i2os.h"    /* For any o.s., compiler, or host-related issues */
 
 //-------------------------------------------------------------------------
 // Manifests for the I/O map:
@@ -644,5 +643,10 @@ typedef union _loadHdrStr
 #define ABS_BIGGEST_BOX 16    // Absolute the most ports per box
 #define ABS_MOST_PORTS  (ABS_MAX_BOXES * ABS_BIGGEST_BOX)
 
+#define I2_OUTSW(port, addr, count)	outsw((port), (addr), (((count)+1)/2))
+#define I2_OUTSB(port, addr, count)	outsb((port), (addr), (((count)+1))&-2)
+#define I2_INSW(port, addr, count)	insw((port), (addr), (((count)+1)/2))
+#define I2_INSB(port, addr, count)	insb((port), (addr), (((count)+1))&-2)
+
 #endif   // I2HW_H
 
diff -puN drivers/char/ip2/i2lib.c~char-ip2-macros-cleanup drivers/char/ip2/i2lib.c
--- a/drivers/char/ip2/i2lib.c~char-ip2-macros-cleanup
+++ a/drivers/char/ip2/i2lib.c
@@ -227,17 +227,17 @@ i2InitChannels ( i2eBordStrPtr pB, int n
 	i2ChanStrPtr *ppCh;
 	
 	if (pB->i2eValid != I2E_MAGIC) {
-		COMPLETE(pB, I2EE_BADMAGIC);
+		I2_COMPLETE(pB, I2EE_BADMAGIC);
 	}
 	if (pB->i2eState != II_STATE_STDLOADED) {
-		COMPLETE(pB, I2EE_BADSTATE);
+		I2_COMPLETE(pB, I2EE_BADSTATE);
 	}
 
-	LOCK_INIT(&pB->read_fifo_spinlock);
-	LOCK_INIT(&pB->write_fifo_spinlock);
-	LOCK_INIT(&pB->Dbuf_spinlock);
-	LOCK_INIT(&pB->Bbuf_spinlock);
-	LOCK_INIT(&pB->Fbuf_spinlock);
+	rwlock_init(&pB->read_fifo_spinlock);
+	rwlock_init(&pB->write_fifo_spinlock);
+	rwlock_init(&pB->Dbuf_spinlock);
+	rwlock_init(&pB->Bbuf_spinlock);
+	rwlock_init(&pB->Fbuf_spinlock);
 	
 	// NO LOCK needed yet - this is init
 
@@ -259,10 +259,10 @@ i2InitChannels ( i2eBordStrPtr pB, int n
 		if ( !(pB->i2eChannelMap[index >> 4] & (1 << (index & 0xf)) ) ) {
 			continue;
 		}
-		LOCK_INIT(&pCh->Ibuf_spinlock);
-		LOCK_INIT(&pCh->Obuf_spinlock);
-		LOCK_INIT(&pCh->Cbuf_spinlock);
-		LOCK_INIT(&pCh->Pbuf_spinlock);
+		rwlock_init(&pCh->Ibuf_spinlock);
+		rwlock_init(&pCh->Obuf_spinlock);
+		rwlock_init(&pCh->Cbuf_spinlock);
+		rwlock_init(&pCh->Pbuf_spinlock);
 		// NO LOCK needed yet - this is init
 		// Set up validity flag according to support level
 		if (pB->i2eGoodMap[index >> 4] & (1 << (index & 0xf)) ) {
@@ -347,7 +347,7 @@ i2InitChannels ( i2eBordStrPtr pB, int n
 	}
 	// No need to check for wrap here; this is initialization.
 	pB->i2Fbuf_stuff = stuffIndex;
-	COMPLETE(pB, I2EE_GOOD);
+	I2_COMPLETE(pB, I2EE_GOOD);
 
 }
 
@@ -374,7 +374,7 @@ i2DeQueueNeeds(i2eBordStrPtr pB, int typ
 
 	case  NEED_INLINE:
 
-		WRITE_LOCK_IRQSAVE(&pB->Dbuf_spinlock,flags);
+		write_lock_irqsave(&pB->Dbuf_spinlock, flags);
 		if ( pB->i2Dbuf_stuff != pB->i2Dbuf_strip)
 		{
 			queueIndex = pB->i2Dbuf_strip;
@@ -386,12 +386,12 @@ i2DeQueueNeeds(i2eBordStrPtr pB, int typ
 			pB->i2Dbuf_strip = queueIndex;
 			pCh->channelNeeds &= ~NEED_INLINE;
 		}
-		WRITE_UNLOCK_IRQRESTORE(&pB->Dbuf_spinlock,flags); 
+		write_unlock_irqrestore(&pB->Dbuf_spinlock, flags);
 		break;
 
 	case NEED_BYPASS:
 
-		WRITE_LOCK_IRQSAVE(&pB->Bbuf_spinlock,flags);
+		write_lock_irqsave(&pB->Bbuf_spinlock, flags);
 		if (pB->i2Bbuf_stuff != pB->i2Bbuf_strip)
 		{
 			queueIndex = pB->i2Bbuf_strip;
@@ -403,12 +403,12 @@ i2DeQueueNeeds(i2eBordStrPtr pB, int typ
 			pB->i2Bbuf_strip = queueIndex;
 			pCh->channelNeeds &= ~NEED_BYPASS;
 		}
-		WRITE_UNLOCK_IRQRESTORE(&pB->Bbuf_spinlock,flags); 
+		write_unlock_irqrestore(&pB->Bbuf_spinlock, flags);
 		break;
 	
 	case NEED_FLOW:
 
-		WRITE_LOCK_IRQSAVE(&pB->Fbuf_spinlock,flags);
+		write_lock_irqsave(&pB->Fbuf_spinlock, flags);
 		if (pB->i2Fbuf_stuff != pB->i2Fbuf_strip)
 		{
 			queueIndex = pB->i2Fbuf_strip;
@@ -420,7 +420,7 @@ i2DeQueueNeeds(i2eBordStrPtr pB, int typ
 			pB->i2Fbuf_strip = queueIndex;
 			pCh->channelNeeds &= ~NEED_FLOW;
 		}
-		WRITE_UNLOCK_IRQRESTORE(&pB->Fbuf_spinlock,flags); 
+		write_unlock_irqrestore(&pB->Fbuf_spinlock, flags);
 		break;
 	default:
 		printk(KERN_ERR "i2DeQueueNeeds called with bad type:%x\n",type);
@@ -453,7 +453,7 @@ i2QueueNeeds(i2eBordStrPtr pB, i2ChanStr
 
 	case NEED_INLINE:
 
-		WRITE_LOCK_IRQSAVE(&pB->Dbuf_spinlock,flags);
+		write_lock_irqsave(&pB->Dbuf_spinlock, flags);
 		if ( !(pCh->channelNeeds & NEED_INLINE) )
 		{
 			pCh->channelNeeds |= NEED_INLINE;
@@ -463,12 +463,12 @@ i2QueueNeeds(i2eBordStrPtr pB, i2ChanStr
 				queueIndex = 0;
 			pB->i2Dbuf_stuff = queueIndex;
 		}
-		WRITE_UNLOCK_IRQRESTORE(&pB->Dbuf_spinlock,flags); 
+		write_unlock_irqrestore(&pB->Dbuf_spinlock, flags);
 		break;
 
 	case NEED_BYPASS:
 
-		WRITE_LOCK_IRQSAVE(&pB->Bbuf_spinlock,flags);
+		write_lock_irqsave(&pB->Bbuf_spinlock, flags);
 		if ((type & NEED_BYPASS) && !(pCh->channelNeeds & NEED_BYPASS))
 		{
 			pCh->channelNeeds |= NEED_BYPASS;
@@ -478,12 +478,12 @@ i2QueueNeeds(i2eBordStrPtr pB, i2ChanStr
 				queueIndex = 0;
 			pB->i2Bbuf_stuff = queueIndex;
 		} 
-		WRITE_UNLOCK_IRQRESTORE(&pB->Bbuf_spinlock,flags); 
+		write_unlock_irqrestore(&pB->Bbuf_spinlock, flags);
 		break;
 
 	case NEED_FLOW:
 
-		WRITE_LOCK_IRQSAVE(&pB->Fbuf_spinlock,flags);
+		write_lock_irqsave(&pB->Fbuf_spinlock, flags);
 		if ((type & NEED_FLOW) && !(pCh->channelNeeds & NEED_FLOW))
 		{
 			pCh->channelNeeds |= NEED_FLOW;
@@ -493,7 +493,7 @@ i2QueueNeeds(i2eBordStrPtr pB, i2ChanStr
 				queueIndex = 0;
 			pB->i2Fbuf_stuff = queueIndex;
 		}
-		WRITE_UNLOCK_IRQRESTORE(&pB->Fbuf_spinlock,flags); 
+		write_unlock_irqrestore(&pB->Fbuf_spinlock, flags);
 		break;
 
 	case NEED_CREDIT:
@@ -562,9 +562,8 @@ i2QueueCommands(int type, i2ChanStrPtr p
 	pB = pCh->pMyBord;
 
 	// Board must also exist, and THE INTERRUPT COMMAND ALREADY SENT
-	if (pB->i2eValid != I2E_MAGIC || pB->i2eUsingIrq == IRQ_UNDEFINED) {
+	if (pB->i2eValid != I2E_MAGIC || pB->i2eUsingIrq == I2_IRQ_UNDEFINED)
 		return -2;
-	}
 	// If the board has gone fatal, return bad, and also hit the trap routine if
 	// it exists.
 	if (pB->i2eFatal) {
@@ -620,13 +619,13 @@ i2QueueCommands(int type, i2ChanStrPtr p
 			switch(type) {
 			case PTYPE_INLINE:
 				lock_var_p = &pCh->Obuf_spinlock;
-				WRITE_LOCK_IRQSAVE(lock_var_p,flags);
+				write_lock_irqsave(lock_var_p, flags);
 				stuffIndex = pCh->Obuf_stuff;
 				bufroom = pCh->Obuf_strip - stuffIndex;
 				break;
 			case PTYPE_BYPASS:
 				lock_var_p = &pCh->Cbuf_spinlock;
-				WRITE_LOCK_IRQSAVE(lock_var_p,flags);
+				write_lock_irqsave(lock_var_p, flags);
 				stuffIndex = pCh->Cbuf_stuff;
 				bufroom = pCh->Cbuf_strip - stuffIndex;
 				break;
@@ -645,7 +644,7 @@ i2QueueCommands(int type, i2ChanStrPtr p
 				break; /* from for()- Enough room: goto proceed */
 			}
 			ip2trace(CHANN, ITRC_QUEUE, 3, 1, totalsize);
-			WRITE_UNLOCK_IRQRESTORE(lock_var_p, flags);
+			write_unlock_irqrestore(lock_var_p, flags);
 		} else
 			ip2trace(CHANN, ITRC_QUEUE, 3, 1, totalsize);
 
@@ -747,7 +746,7 @@ i2QueueCommands(int type, i2ChanStrPtr p
 	{
 	case PTYPE_INLINE:
 		pCh->Obuf_stuff = stuffIndex;  // Store buffer pointer
-		WRITE_UNLOCK_IRQRESTORE(&pCh->Obuf_spinlock,flags); 
+		write_unlock_irqrestore(&pCh->Obuf_spinlock, flags);
 
 		pB->debugInlineQueued++;
 		// Add the channel pointer to list of channels needing service (first
@@ -757,7 +756,7 @@ i2QueueCommands(int type, i2ChanStrPtr p
 
 	case PTYPE_BYPASS:
 		pCh->Cbuf_stuff = stuffIndex;  // Store buffer pointer
-		WRITE_UNLOCK_IRQRESTORE(&pCh->Cbuf_spinlock,flags); 
+		write_unlock_irqrestore(&pCh->Cbuf_spinlock, flags);
 
 		pB->debugBypassQueued++;
 		// Add the channel pointer to list of channels needing service (first
@@ -840,7 +839,7 @@ i2Input(i2ChanStrPtr pCh)
 		count = -1;
 		goto i2Input_exit;
 	}
-	WRITE_LOCK_IRQSAVE(&pCh->Ibuf_spinlock,flags);
+	write_lock_irqsave(&pCh->Ibuf_spinlock, flags);
 
 	// initialize some accelerators and private copies
 	stripIndex = pCh->Ibuf_strip;
@@ -850,7 +849,7 @@ i2Input(i2ChanStrPtr pCh)
 	// If buffer is empty or requested data count was 0, (trivial case) return
 	// without any further thought.
 	if ( count == 0 ) {
-		WRITE_UNLOCK_IRQRESTORE(&pCh->Ibuf_spinlock,flags);
+		write_unlock_irqrestore(&pCh->Ibuf_spinlock, flags);
 		goto i2Input_exit;
 	}
 	// Adjust for buffer wrap
@@ -891,10 +890,10 @@ i2Input(i2ChanStrPtr pCh)
 
 	if ((pCh->sinceLastFlow += count) >= pCh->whenSendFlow) {
 		pCh->sinceLastFlow -= pCh->whenSendFlow;
-		WRITE_UNLOCK_IRQRESTORE(&pCh->Ibuf_spinlock,flags);
+		write_unlock_irqrestore(&pCh->Ibuf_spinlock, flags);
 		i2QueueNeeds(pCh->pMyBord, pCh, NEED_FLOW);
 	} else {
-		WRITE_UNLOCK_IRQRESTORE(&pCh->Ibuf_spinlock,flags);
+		write_unlock_irqrestore(&pCh->Ibuf_spinlock, flags);
 	}
 
 i2Input_exit:
@@ -926,7 +925,7 @@ i2InputFlush(i2ChanStrPtr pCh)
 
 	ip2trace (CHANN, ITRC_INPUT, 10, 0);
 
-	WRITE_LOCK_IRQSAVE(&pCh->Ibuf_spinlock,flags);
+	write_lock_irqsave(&pCh->Ibuf_spinlock, flags);
 	count = pCh->Ibuf_stuff - pCh->Ibuf_strip;
 
 	// Adjust for buffer wrap
@@ -947,10 +946,10 @@ i2InputFlush(i2ChanStrPtr pCh)
 	if ( (pCh->sinceLastFlow += count) >= pCh->whenSendFlow )
 	{
 		pCh->sinceLastFlow -= pCh->whenSendFlow;
-		WRITE_UNLOCK_IRQRESTORE(&pCh->Ibuf_spinlock,flags);
+		write_unlock_irqrestore(&pCh->Ibuf_spinlock, flags);
 		i2QueueNeeds(pCh->pMyBord, pCh, NEED_FLOW);
 	} else {
-		WRITE_UNLOCK_IRQRESTORE(&pCh->Ibuf_spinlock,flags);
+		write_unlock_irqrestore(&pCh->Ibuf_spinlock, flags);
 	}
 
 	ip2trace (CHANN, ITRC_INPUT, 19, 1, count);
@@ -979,9 +978,9 @@ i2InputAvailable(i2ChanStrPtr pCh)
 
 
 	// initialize some accelerators and private copies
-	READ_LOCK_IRQSAVE(&pCh->Ibuf_spinlock,flags);
+	read_lock_irqsave(&pCh->Ibuf_spinlock, flags);
 	count = pCh->Ibuf_stuff - pCh->Ibuf_strip;
-	READ_UNLOCK_IRQRESTORE(&pCh->Ibuf_spinlock,flags);
+	read_unlock_irqrestore(&pCh->Ibuf_spinlock, flags);
 
 	// Adjust for buffer wrap
 	if (count < 0)
@@ -1045,9 +1044,9 @@ i2Output(i2ChanStrPtr pCh, const char *p
 	while ( count > 0 ) {
 
 		// How much room in output buffer is there?
-		READ_LOCK_IRQSAVE(&pCh->Obuf_spinlock,flags);
+		read_lock_irqsave(&pCh->Obuf_spinlock, flags);
 		amountToMove = pCh->Obuf_strip - pCh->Obuf_stuff - 1;
-		READ_UNLOCK_IRQRESTORE(&pCh->Obuf_spinlock,flags);
+		read_unlock_irqrestore(&pCh->Obuf_spinlock, flags);
 		if (amountToMove < 0) {
 			amountToMove += OBUF_SIZE;
 		}
@@ -1075,7 +1074,7 @@ i2Output(i2ChanStrPtr pCh, const char *p
 		if ( !(pCh->flush_flags && i2RetryFlushOutput(pCh) ) 
 				&& amountToMove > 0 )
 		{
-			WRITE_LOCK_IRQSAVE(&pCh->Obuf_spinlock,flags);
+			write_lock_irqsave(&pCh->Obuf_spinlock, flags);
 			stuffIndex = pCh->Obuf_stuff;
       
 			// Had room to move some data: don't know whether the block size,
@@ -1102,7 +1101,7 @@ i2Output(i2ChanStrPtr pCh, const char *p
 			}
 			pCh->Obuf_stuff = stuffIndex;
 
-			WRITE_UNLOCK_IRQRESTORE(&pCh->Obuf_spinlock,flags);
+			write_unlock_irqrestore(&pCh->Obuf_spinlock, flags);
 
 			ip2trace (CHANN, ITRC_OUTPUT, 13, 1, stuffIndex );
 
@@ -1352,9 +1351,9 @@ i2OutputFree(i2ChanStrPtr pCh)
 	if ( !i2Validate ( pCh ) ) {
 		return -1;
 	}
-	READ_LOCK_IRQSAVE(&pCh->Obuf_spinlock,flags);
+	read_lock_irqsave(&pCh->Obuf_spinlock, flags);
 	amountToMove = pCh->Obuf_strip - pCh->Obuf_stuff - 1;
-	READ_UNLOCK_IRQRESTORE(&pCh->Obuf_spinlock,flags);
+	read_unlock_irqrestore(&pCh->Obuf_spinlock, flags);
 
 	if (amountToMove < 0) {
 		amountToMove += OBUF_SIZE;
@@ -1464,11 +1463,11 @@ i2StripFifo(i2eBordStrPtr pB)
 
 //	ip2trace (ITRC_NO_PORT, ITRC_SFIFO, ITRC_ENTER, 0 );
 
-	while (HAS_INPUT(pB)) {
+	while (I2_HAS_INPUT(pB)) {
 //		ip2trace (ITRC_NO_PORT, ITRC_SFIFO, 2, 0 );
 
 		// Process packet from fifo a one atomic unit
-		WRITE_LOCK_IRQSAVE(&pB->read_fifo_spinlock,bflags);
+		write_lock_irqsave(&pB->read_fifo_spinlock, bflags);
    
 		// The first word (or two bytes) will have channel number and type of
 		// packet, possibly other information
@@ -1490,7 +1489,8 @@ i2StripFifo(i2eBordStrPtr pB)
 // sick!
 			if ( ((unsigned int)count) > IBUF_SIZE ) {
 				pB->i2eFatal = 2;
-				WRITE_UNLOCK_IRQRESTORE(&pB->read_fifo_spinlock,bflags);
+				write_unlock_irqrestore(&pB->read_fifo_spinlock,
+						bflags);
 				return;     /* Bail out ASAP */
 			}
 			// Channel is illegally big ?
@@ -1498,7 +1498,8 @@ i2StripFifo(i2eBordStrPtr pB)
 				(NULL==(pCh = ((i2ChanStrPtr*)pB->i2eChannelPtr)[channel])))
 			{
 				iiReadBuf(pB, junkBuffer, count);
-				WRITE_UNLOCK_IRQRESTORE(&pB->read_fifo_spinlock,bflags);
+				write_unlock_irqrestore(&pB->read_fifo_spinlock,
+						bflags);
 				break;         /* From switch: ready for next packet */
 			}
 
@@ -1512,14 +1513,15 @@ i2StripFifo(i2eBordStrPtr pB)
 			if(ID_OF(pB->i2eLeadoffWord) == ID_HOT_KEY)
 			{
 				pCh->hotKeyIn = iiReadWord(pB) & 0xff;
-				WRITE_UNLOCK_IRQRESTORE(&pB->read_fifo_spinlock,bflags);
+				write_unlock_irqrestore(&pB->read_fifo_spinlock,
+						bflags);
 				i2QueueCommands(PTYPE_BYPASS, pCh, 0, 1, CMD_HOTACK);
 				break;   /* From the switch: ready for next packet */
 			}
 
 			// Normal data! We crudely assume there is room for the data in our
 			// buffer because the board wouldn't have exceeded his credit limit.
-			WRITE_LOCK_IRQSAVE(&pCh->Ibuf_spinlock,cflags);
+			write_lock_irqsave(&pCh->Ibuf_spinlock, cflags);
 													// We have 2 locks now
 			stuffIndex = pCh->Ibuf_stuff;
 			amountToRead = IBUF_SIZE - stuffIndex;
@@ -1562,8 +1564,9 @@ i2StripFifo(i2eBordStrPtr pB)
 
 			// Update stuff index
 			pCh->Ibuf_stuff = stuffIndex;
-			WRITE_UNLOCK_IRQRESTORE(&pCh->Ibuf_spinlock,cflags);
-			WRITE_UNLOCK_IRQRESTORE(&pB->read_fifo_spinlock,bflags);
+			write_unlock_irqrestore(&pCh->Ibuf_spinlock, cflags);
+			write_unlock_irqrestore(&pB->read_fifo_spinlock,
+					bflags);
 
 #ifdef USE_IQ
 			schedule_work(&pCh->tqueue_input);
@@ -1585,7 +1588,8 @@ i2StripFifo(i2eBordStrPtr pB)
 
 			iiReadBuf(pB, cmdBuffer, count);
 			// We can release early with buffer grab
-			WRITE_UNLOCK_IRQRESTORE(&pB->read_fifo_spinlock,bflags);
+			write_unlock_irqrestore(&pB->read_fifo_spinlock,
+					bflags);
 
 			pc = cmdBuffer;
 			pcLimit = &(cmdBuffer[count]);
@@ -1830,12 +1834,12 @@ i2StripFifo(i2eBordStrPtr pB)
 		default: // Neither packet? should be impossible
 			ip2trace (ITRC_NO_PORT, ITRC_SFIFO, 5, 1,
 				PTYPE_OF(pB->i2eLeadoffWord) );
-			WRITE_UNLOCK_IRQRESTORE(&pB->read_fifo_spinlock,
+			write_unlock_irqrestore(&pB->read_fifo_spinlock,
 					bflags);
 
 			break;
 		}  // End of switch on type of packets
-	}	//while(board HAS_INPUT)
+	}	/*while(board I2_HAS_INPUT)*/
 
 	ip2trace (ITRC_NO_PORT, ITRC_SFIFO, ITRC_RETURN, 0 );
 
@@ -1858,7 +1862,7 @@ i2Write2Fifo(i2eBordStrPtr pB, unsigned 
 {
 	int rc = 0;
 	unsigned long flags;
-	WRITE_LOCK_IRQSAVE(&pB->write_fifo_spinlock,flags);
+	write_lock_irqsave(&pB->write_fifo_spinlock, flags);
 	if (!pB->i2eWaitingForEmptyFifo) {
 		if (pB->i2eFifoRemains > (count+reserve)) {
 			pB->i2eFifoRemains -= count;
@@ -1867,7 +1871,7 @@ i2Write2Fifo(i2eBordStrPtr pB, unsigned 
 			rc =  count;
 		}
 	}
-	WRITE_UNLOCK_IRQRESTORE(&pB->write_fifo_spinlock,flags);
+	write_unlock_irqrestore(&pB->write_fifo_spinlock, flags);
 	return rc;
 }
 //******************************************************************************
@@ -1898,7 +1902,7 @@ i2StuffFifoBypass(i2eBordStrPtr pB)
 	while ( --bailout && notClogged && 
 			(NULL != (pCh = i2DeQueueNeeds(pB,NEED_BYPASS))))
 	{
-		WRITE_LOCK_IRQSAVE(&pCh->Cbuf_spinlock,flags);
+		write_lock_irqsave(&pCh->Cbuf_spinlock, flags);
 		stripIndex = pCh->Cbuf_strip;
 
 		// as long as there are packets for this channel...
@@ -1906,7 +1910,7 @@ i2StuffFifoBypass(i2eBordStrPtr pB)
 		while (stripIndex != pCh->Cbuf_stuff) {
 			pRemove = &(pCh->Cbuf[stripIndex]);
 			packetSize = CMD_COUNT_OF(pRemove) + sizeof(i2CmdHeader);
-			paddedSize = ROUNDUP(packetSize);
+			paddedSize = roundup(packetSize, 2);
 
 			if (paddedSize > 0) {
 				if ( 0 == i2Write2Fifo(pB, pRemove, paddedSize,0)) {
@@ -1930,7 +1934,7 @@ WriteDBGBuf("BYPS", pRemove, paddedSize)
 		// Done with this channel. Move to next, removing this one from 
 		// the queue of channels if we cleaned it out (i.e., didn't get clogged.
 		pCh->Cbuf_strip = stripIndex;
-		WRITE_UNLOCK_IRQRESTORE(&pCh->Cbuf_spinlock,flags);
+		write_unlock_irqrestore(&pCh->Cbuf_spinlock, flags);
 	}  // Either clogged or finished all the work
 
 #ifdef IP2DEBUG_TRACE
@@ -1954,7 +1958,7 @@ static inline void
 i2StuffFifoFlow(i2eBordStrPtr pB)
 {
 	i2ChanStrPtr pCh;
-	unsigned short paddedSize		= ROUNDUP(sizeof(flowIn));
+	unsigned short paddedSize = roundup(sizeof(flowIn), 2);
 
 	ip2trace (ITRC_NO_PORT, ITRC_SFLOW, ITRC_ENTER, 2,
 		pB->i2eFifoRemains, paddedSize );
@@ -2010,7 +2014,7 @@ i2StuffFifoInline(i2eBordStrPtr pB)
 	while ( --bailout && notClogged && 
 			(NULL != (pCh = i2DeQueueNeeds(pB,NEED_INLINE))) )
 	{
-		WRITE_LOCK_IRQSAVE(&pCh->Obuf_spinlock,flags);
+		write_lock_irqsave(&pCh->Obuf_spinlock, flags);
 		stripIndex = pCh->Obuf_strip;
 
 		ip2trace (CHANN, ITRC_SICMD, 3, 2, stripIndex, pCh->Obuf_stuff );
@@ -2031,7 +2035,7 @@ i2StuffFifoInline(i2eBordStrPtr pB)
 				packetSize = flowsize + sizeof(i2CmdHeader);
 			}
 			flowsize = CREDIT_USAGE(flowsize);
-			paddedSize = ROUNDUP(packetSize);
+			paddedSize = roundup(packetSize, 2);
 
 			ip2trace (CHANN, ITRC_SICMD, 4, 2, pB->i2eFifoRemains, paddedSize );
 
@@ -2086,7 +2090,7 @@ WriteDBGBuf("DATA", pRemove, paddedSize)
 		// Done with this channel. Move to next, removing this one from the
 		// queue of channels if we cleaned it out (i.e., didn't get clogged.
 		pCh->Obuf_strip = stripIndex;
-		WRITE_UNLOCK_IRQRESTORE(&pCh->Obuf_spinlock,flags);
+		write_unlock_irqrestore(&pCh->Obuf_spinlock, flags);
 		if ( notClogged )
 		{
 
@@ -2190,10 +2194,11 @@ i2ServiceBoard ( i2eBordStrPtr pB )
 
 		if (inmail & MB_OUT_STRIPPED) {
 			pB->i2eFifoOutInts++;
-			WRITE_LOCK_IRQSAVE(&pB->write_fifo_spinlock,flags);
+			write_lock_irqsave(&pB->write_fifo_spinlock, flags);
 			pB->i2eFifoRemains = pB->i2eFifoSize;
 			pB->i2eWaitingForEmptyFifo = 0;
-			WRITE_UNLOCK_IRQRESTORE(&pB->write_fifo_spinlock,flags);
+			write_unlock_irqrestore(&pB->write_fifo_spinlock,
+					flags);
 
 			ip2trace (ITRC_NO_PORT, ITRC_INTR, 30, 1, pB->i2eFifoRemains );
 
diff -puN drivers/char/ip2/i2os.h~char-ip2-macros-cleanup /dev/null
--- a/drivers/char/ip2/i2os.h
+++ /dev/null
@@ -1,127 +0,0 @@
-/*******************************************************************************
-*
-*   (c) 1999 by Computone Corporation
-*
-********************************************************************************
-*
-*
-*   PACKAGE:     Linux tty Device Driver for IntelliPort II family of multiport
-*                serial I/O controllers.
-*
-*   DESCRIPTION: Defines, definitions and includes which are heavily dependent
-*                on O/S, host, compiler, etc. This file is tailored for:
-*                 Linux v2.0.0 and later
-*                 Gnu gcc c2.7.2
-*                 80x86 architecture
-*
-*******************************************************************************/
-
-#ifndef I2OS_H    /* To prevent multiple includes */
-#define I2OS_H 1
-
-//-------------------------------------------------
-// Required Includes
-//-------------------------------------------------
-
-#include "ip2types.h"
-#include <asm/io.h>  /* For inb, etc */
-
-//------------------------------------
-// Defines for I/O instructions:
-//------------------------------------
-
-#define INB(port)                inb(port)
-#define OUTB(port,value)         outb((value),(port))
-#define INW(port)                inw(port)
-#define OUTW(port,value)         outw((value),(port))
-#define OUTSW(port,addr,count)   outsw((port),(addr),(((count)+1)/2))
-#define OUTSB(port,addr,count)   outsb((port),(addr),(((count)+1))&-2)
-#define INSW(port,addr,count)    insw((port),(addr),(((count)+1)/2))
-#define INSB(port,addr,count)    insb((port),(addr),(((count)+1))&-2)
-
-//--------------------------------------------
-// Interrupt control
-//--------------------------------------------
-
-#define LOCK_INIT(a)	rwlock_init(a)
-
-#define SAVE_AND_DISABLE_INTS(a,b) { \
-	/* printk("get_lock: 0x%x,%4d,%s\n",(int)a,__LINE__,__FILE__);*/ \
-	spin_lock_irqsave(a,b); \
-}
-
-#define RESTORE_INTS(a,b) { \
-	/* printk("rel_lock: 0x%x,%4d,%s\n",(int)a,__LINE__,__FILE__);*/ \
-	spin_unlock_irqrestore(a,b); \
-}
-
-#define READ_LOCK_IRQSAVE(a,b) { \
-	/* printk("get_read_lock: 0x%x,%4d,%s\n",(int)a,__LINE__,__FILE__);*/ \
-	read_lock_irqsave(a,b); \
-}
-
-#define READ_UNLOCK_IRQRESTORE(a,b) { \
-	/* printk("rel_read_lock: 0x%x,%4d,%s\n",(int)a,__LINE__,__FILE__);*/ \
-	read_unlock_irqrestore(a,b); \
-}
-
-#define WRITE_LOCK_IRQSAVE(a,b) { \
-	/* printk("get_write_lock: 0x%x,%4d,%s\n",(int)a,__LINE__,__FILE__);*/ \
-	write_lock_irqsave(a,b); \
-}
-
-#define WRITE_UNLOCK_IRQRESTORE(a,b) { \
-	/* printk("rel_write_lock: 0x%x,%4d,%s\n",(int)a,__LINE__,__FILE__);*/ \
-	write_unlock_irqrestore(a,b); \
-}
-
-
-//------------------------------------------------------------------------------
-// Hardware-delay loop
-//
-// Probably used in only one place (see i2ellis.c) but this helps keep things
-// together. Note we have unwound the IN instructions. On machines with a
-// reasonable cache, the eight instructions (1 byte each) should fit in cache
-// nicely, and on un-cached machines, the code-fetch would tend not to dominate.
-// Note that cx is shifted so that "count" still reflects the total number of
-// iterations assuming no unwinding.
-//------------------------------------------------------------------------------
-
-//#define  DELAY1MS(port,count,label)
-
-//------------------------------------------------------------------------------
-// Macros to switch to a new stack, saving stack pointers, and to restore the
-// old stack (Used, for example, in i2lib.c) "heap" is the address of some
-// buffer which will become the new stack (working down from highest address).
-// The two words at the two lowest addresses in this stack are for storing the
-// SS and SP.
-//------------------------------------------------------------------------------
-
-//#define  TO_NEW_STACK(heap,size)
-//#define  TO_OLD_STACK(heap)
-
-//------------------------------------------------------------------------------
-// Macros to save the original IRQ vectors and masks, and to patch in new ones.
-//------------------------------------------------------------------------------
-
-//#define  SAVE_IRQ_MASKS(dest)
-//#define  WRITE_IRQ_MASKS(src)
-//#define  SAVE_IRQ_VECTOR(value,dest)
-//#define  WRITE_IRQ_VECTOR(value,src)
-
-//------------------------------------------------------------------------------
-// Macro to copy data from one far pointer to another.
-//------------------------------------------------------------------------------
-
-#define  I2_MOVE_DATA(fpSource,fpDest,count) memmove(fpDest,fpSource,count);
-
-//------------------------------------------------------------------------------
-// Macros to issue eoi's to host interrupt control (IBM AT 8259-style).
-//------------------------------------------------------------------------------
-
-//#define MASTER_EOI
-//#define SLAVE_EOI
-
-#endif   /* I2OS_H */
-
-
diff -puN drivers/char/ip2/ip2main.c~char-ip2-macros-cleanup drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~char-ip2-macros-cleanup
+++ a/drivers/char/ip2/ip2main.c
@@ -1052,9 +1052,9 @@ set_irq( int boardnum, int boardIrq )
 	 * Write to FIFO; don't bother to adjust fifo capacity for this, since
 	 * board will respond almost immediately after SendMail hit.
 	 */
-	WRITE_LOCK_IRQSAVE(&pB->write_fifo_spinlock,flags);
+	write_lock_irqsave(&pB->write_fifo_spinlock, flags);
 	iiWriteBuf(pB, tempCommand, 4);
-	WRITE_UNLOCK_IRQRESTORE(&pB->write_fifo_spinlock,flags);
+	write_unlock_irqrestore(&pB->write_fifo_spinlock, flags);
 	pB->i2eUsingIrq = boardIrq;
 	pB->i2eOutMailWaiting |= MB_OUT_STUFFED;
 
@@ -1072,9 +1072,9 @@ set_irq( int boardnum, int boardIrq )
 	(CMD_OF(tempCommand))[4] = 64;	// chars
 
 	(CMD_OF(tempCommand))[5] = 87;	// HW_TEST
-	WRITE_LOCK_IRQSAVE(&pB->write_fifo_spinlock,flags);
+	write_lock_irqsave(&pB->write_fifo_spinlock, flags);
 	iiWriteBuf(pB, tempCommand, 8);
-	WRITE_UNLOCK_IRQRESTORE(&pB->write_fifo_spinlock,flags);
+	write_unlock_irqrestore(&pB->write_fifo_spinlock, flags);
 
 	CHANNEL_OF(tempCommand) = 0;
 	PTYPE_OF(tempCommand) = PTYPE_BYPASS;
@@ -1089,9 +1089,9 @@ set_irq( int boardnum, int boardIrq )
 	CMD_COUNT_OF(tempCommand) = 2;
 	(CMD_OF(tempCommand))[0] = 44;	/* get ping */
 	(CMD_OF(tempCommand))[1] = 200;	/* 200 ms */
-	WRITE_LOCK_IRQSAVE(&pB->write_fifo_spinlock,flags);
+	write_lock_irqsave(&pB->write_fifo_spinlock, flags);
 	iiWriteBuf(pB, tempCommand, 4);
-	WRITE_UNLOCK_IRQRESTORE(&pB->write_fifo_spinlock,flags);
+	write_unlock_irqrestore(&pB->write_fifo_spinlock, flags);
 #endif
 
 	iiEnableMailIrq(pB);
@@ -1270,12 +1270,12 @@ static void do_input(struct work_struct 
 
 	// Data input
 	if ( pCh->pTTY != NULL ) {
-		READ_LOCK_IRQSAVE(&pCh->Ibuf_spinlock,flags)
+		read_lock_irqsave(&pCh->Ibuf_spinlock, flags);
 		if (!pCh->throttled && (pCh->Ibuf_stuff != pCh->Ibuf_strip)) {
-			READ_UNLOCK_IRQRESTORE(&pCh->Ibuf_spinlock,flags)
+			read_unlock_irqrestore(&pCh->Ibuf_spinlock, flags);
 			i2Input( pCh );
 		} else
-			READ_UNLOCK_IRQRESTORE(&pCh->Ibuf_spinlock,flags)
+			read_unlock_irqrestore(&pCh->Ibuf_spinlock, flags);
 	} else {
 		ip2trace(CHANN, ITRC_INPUT, 22, 0 );
 
@@ -1719,9 +1719,9 @@ ip2_write( PTTY tty, const unsigned char
 	ip2_flush_chars( tty );
 
 	/* This is the actual move bit. Make sure it does what we need!!!!! */
-	WRITE_LOCK_IRQSAVE(&pCh->Pbuf_spinlock,flags);
+	write_lock_irqsave(&pCh->Pbuf_spinlock, flags);
 	bytesSent = i2Output( pCh, pData, count);
-	WRITE_UNLOCK_IRQRESTORE(&pCh->Pbuf_spinlock,flags);
+	write_unlock_irqrestore(&pCh->Pbuf_spinlock, flags);
 
 	ip2trace (CHANN, ITRC_WRITE, ITRC_RETURN, 1, bytesSent );
 
@@ -1746,13 +1746,13 @@ ip2_putchar( PTTY tty, unsigned char ch 
 
 //	ip2trace (CHANN, ITRC_PUTC, ITRC_ENTER, 1, ch );
 
-	WRITE_LOCK_IRQSAVE(&pCh->Pbuf_spinlock,flags);
+	write_lock_irqsave(&pCh->Pbuf_spinlock, flags);
 	pCh->Pbuf[pCh->Pbuf_stuff++] = ch;
 	if ( pCh->Pbuf_stuff == sizeof pCh->Pbuf ) {
-		WRITE_UNLOCK_IRQRESTORE(&pCh->Pbuf_spinlock,flags);
+		write_unlock_irqrestore(&pCh->Pbuf_spinlock, flags);
 		ip2_flush_chars( tty );
 	} else
-		WRITE_UNLOCK_IRQRESTORE(&pCh->Pbuf_spinlock,flags);
+		write_unlock_irqrestore(&pCh->Pbuf_spinlock, flags);
 
 //	ip2trace (CHANN, ITRC_PUTC, ITRC_RETURN, 1, ch );
 }
@@ -1772,7 +1772,7 @@ ip2_flush_chars( PTTY tty )
 	i2ChanStrPtr  pCh = tty->driver_data;
 	unsigned long flags;
 
-	WRITE_LOCK_IRQSAVE(&pCh->Pbuf_spinlock,flags);
+	write_lock_irqsave(&pCh->Pbuf_spinlock, flags);
 	if ( pCh->Pbuf_stuff ) {
 
 //		ip2trace (CHANN, ITRC_PUTC, 10, 1, strip );
@@ -1786,7 +1786,7 @@ ip2_flush_chars( PTTY tty )
 		}
 		pCh->Pbuf_stuff -= strip;
 	}
-	WRITE_UNLOCK_IRQRESTORE(&pCh->Pbuf_spinlock,flags);
+	write_unlock_irqrestore(&pCh->Pbuf_spinlock, flags);
 }
 
 /******************************************************************************/
@@ -1804,9 +1804,9 @@ ip2_write_room ( PTTY tty )
 	i2ChanStrPtr  pCh = tty->driver_data;
 	unsigned long flags;
 
-	READ_LOCK_IRQSAVE(&pCh->Pbuf_spinlock,flags);
+	read_lock_irqsave(&pCh->Pbuf_spinlock, flags);
 	bytesFree = i2OutputFree( pCh ) - pCh->Pbuf_stuff;
-	READ_UNLOCK_IRQRESTORE(&pCh->Pbuf_spinlock,flags);
+	read_unlock_irqrestore(&pCh->Pbuf_spinlock, flags);
 
 	ip2trace (CHANN, ITRC_WRITE, 11, 1, bytesFree );
 
@@ -1836,12 +1836,12 @@ ip2_chars_in_buf ( PTTY tty )
 				 pCh->Obuf_char_count + pCh->Pbuf_stuff,
 				 pCh->Obuf_char_count, pCh->Pbuf_stuff );
 #endif
-	READ_LOCK_IRQSAVE(&pCh->Obuf_spinlock,flags);
+	read_lock_irqsave(&pCh->Obuf_spinlock, flags);
 	rc =  pCh->Obuf_char_count;
-	READ_UNLOCK_IRQRESTORE(&pCh->Obuf_spinlock,flags);
-	READ_LOCK_IRQSAVE(&pCh->Pbuf_spinlock,flags);
+	read_unlock_irqrestore(&pCh->Obuf_spinlock, flags);
+	read_lock_irqsave(&pCh->Pbuf_spinlock, flags);
 	rc +=  pCh->Pbuf_stuff;
-	READ_UNLOCK_IRQRESTORE(&pCh->Pbuf_spinlock,flags);
+	read_unlock_irqrestore(&pCh->Pbuf_spinlock, flags);
 	return rc;
 }
 
@@ -1865,9 +1865,9 @@ ip2_flush_buffer( PTTY tty )
 #ifdef IP2DEBUG_WRITE
 	printk (KERN_DEBUG "IP2: flush buffer\n" );
 #endif
-	WRITE_LOCK_IRQSAVE(&pCh->Pbuf_spinlock,flags);
+	write_lock_irqsave(&pCh->Pbuf_spinlock, flags);
 	pCh->Pbuf_stuff = 0;
-	WRITE_UNLOCK_IRQRESTORE(&pCh->Pbuf_spinlock,flags);
+	write_unlock_irqrestore(&pCh->Pbuf_spinlock, flags);
 	i2FlushOutput( pCh );
 	ip2_owake(tty);
 
@@ -1953,15 +1953,15 @@ ip2_unthrottle ( PTTY tty )
 	pCh->throttled = 0;
  	i2QueueCommands(PTYPE_BYPASS, pCh, 0, 1, CMD_RESUME);
 	serviceOutgoingFifo( pCh->pMyBord );
-	READ_LOCK_IRQSAVE(&pCh->Ibuf_spinlock,flags)
+	read_lock_irqsave(&pCh->Ibuf_spinlock, flags);
 	if ( pCh->Ibuf_stuff != pCh->Ibuf_strip ) {
-		READ_UNLOCK_IRQRESTORE(&pCh->Ibuf_spinlock,flags)
+		read_unlock_irqrestore(&pCh->Ibuf_spinlock, flags);
 #ifdef IP2DEBUG_READ
 		printk (KERN_DEBUG "i2Input called from unthrottle\n" );
 #endif
 		i2Input( pCh );
 	} else
-		READ_UNLOCK_IRQRESTORE(&pCh->Ibuf_spinlock,flags)
+		read_unlock_irqrestore(&pCh->Ibuf_spinlock, flags);
 }
 
 static void
@@ -2204,9 +2204,9 @@ ip2_ioctl ( PTTY tty, struct file *pFile
 	 * for masking). Caller should use TIOCGICOUNT to see which one it was
 	 */
 	case TIOCMIWAIT:
-		WRITE_LOCK_IRQSAVE(&pB->read_fifo_spinlock, flags);
+		write_lock_irqsave(&pB->read_fifo_spinlock, flags);
 		cprev = pCh->icount;	 /* note the counters on entry */
-		WRITE_UNLOCK_IRQRESTORE(&pB->read_fifo_spinlock, flags);
+		write_unlock_irqrestore(&pB->read_fifo_spinlock, flags);
 		i2QueueCommands(PTYPE_BYPASS, pCh, 100, 4, 
 						CMD_DCD_REP, CMD_CTS_REP, CMD_DSR_REP, CMD_RI_REP);
 		init_waitqueue_entry(&wait, current);
@@ -2226,9 +2226,9 @@ ip2_ioctl ( PTTY tty, struct file *pFile
 				rc = -ERESTARTSYS;
 				break;
 			}
-			WRITE_LOCK_IRQSAVE(&pB->read_fifo_spinlock, flags);
+			write_lock_irqsave(&pB->read_fifo_spinlock, flags);
 			cnow = pCh->icount; /* atomic copy */
-			WRITE_UNLOCK_IRQRESTORE(&pB->read_fifo_spinlock, flags);
+			write_unlock_irqrestore(&pB->read_fifo_spinlock, flags);
 			if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
 				cnow.dcd == cprev.dcd && cnow.cts == cprev.cts) {
 				rc =  -EIO; /* no change => rc */
@@ -2266,9 +2266,9 @@ ip2_ioctl ( PTTY tty, struct file *pFile
 	case TIOCGICOUNT:
 		ip2trace (CHANN, ITRC_IOCTL, 11, 1, rc );
 
-		WRITE_LOCK_IRQSAVE(&pB->read_fifo_spinlock, flags);
+		write_lock_irqsave(&pB->read_fifo_spinlock, flags);
 		cnow = pCh->icount;
-		WRITE_UNLOCK_IRQRESTORE(&pB->read_fifo_spinlock, flags);
+		write_unlock_irqrestore(&pB->read_fifo_spinlock, flags);
 		p_cuser = argp;
 		rc = put_user(cnow.cts, &p_cuser->cts);
 		rc = put_user(cnow.dsr, &p_cuser->dsr);
@@ -2874,7 +2874,7 @@ ip2_ipl_ioctl ( struct inode *pInode, st
 		case 65:	/* Board  - ip2stat */
 			if ( pB ) {
 				rc = copy_to_user(argp, pB, sizeof(i2eBordStr));
-				rc = put_user(INB(pB->i2eStatus),
+				rc = put_user(inb(pB->i2eStatus),
 					(ULONG __user *)(arg + (ULONG)(&pB->i2eStatus) - (ULONG)pB ) );
 			} else {
 				rc = -ENODEV;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

