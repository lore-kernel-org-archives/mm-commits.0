From: akpm@linux-foundation.org
Subject: + flashpoint-use-bit-instead-of-bitw.patch added to -mm tree
Date: Mon, 20 Aug 2007 13:42:43 -0700
Message-ID: <200708202042.l7KKghta022253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41942 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761626AbXHTUn1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 16:43:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, James.Bottomley@steeleye.com


The patch titled
     FlashPoint, use BIT instead of BITW
has been added to the -mm tree.  Its filename is
     flashpoint-use-bit-instead-of-bitw.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: FlashPoint, use BIT instead of BITW
From: Jiri Slaby <jirislaby@gmail.com>

FlashPoint, use BIT instead of BITW

BITW was an ushort variant of BIT, use BIT instead

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/FlashPoint.c |   82 +++++++++++++++++-------------------
 1 files changed, 40 insertions(+), 42 deletions(-)

diff -puN drivers/scsi/FlashPoint.c~flashpoint-use-bit-instead-of-bitw drivers/scsi/FlashPoint.c
--- a/drivers/scsi/FlashPoint.c~flashpoint-use-bit-instead-of-bitw
+++ a/drivers/scsi/FlashPoint.c
@@ -25,8 +25,6 @@
 
 #define FAILURE         0xFFFFFFFFL
 
-#define BITW(x)          ((unsigned short)(1<<(x)))	/* single-bit mask in bit position x */
-
 struct sccb;
 typedef void (*CALL_BK_FN) (struct sccb *);
 
@@ -373,9 +371,9 @@ typedef struct SCCBscam_info {
 #define  SCAM_ENABLED   BIT(2)
 #define  SCAM_LEVEL2    BIT(3)
 
-#define	RENEGO_ENA		BITW(10)
-#define	CONNIO_ENA		BITW(11)
-#define  GREEN_PC_ENA   BITW(12)
+#define	RENEGO_ENA		BIT(10)
+#define	CONNIO_ENA		BIT(11)
+#define  GREEN_PC_ENA   BIT(12)
 
 #define  AUTO_RATE_00   00
 #define  AUTO_RATE_05   01
@@ -510,23 +508,23 @@ typedef struct SCCBscam_info {
 
 #define  hp_intena		 0x40
 
-#define  RESET		 BITW(7)
-#define  PROG_HLT		 BITW(6)
-#define  PARITY		 BITW(5)
-#define  FIFO		 BITW(4)
-#define  SEL		 BITW(3)
-#define  SCAM_SEL		 BITW(2)
-#define  RSEL		 BITW(1)
-#define  TIMEOUT		 BITW(0)
-#define  BUS_FREE		 BITW(15)
-#define  XFER_CNT_0	 BITW(14)
-#define  PHASE		 BITW(13)
-#define  IUNKWN		 BITW(12)
-#define  ICMD_COMP	 BITW(11)
-#define  ITICKLE		 BITW(10)
-#define  IDO_STRT		 BITW(9)
-#define  ITAR_DISC	 BITW(8)
-#define  AUTO_INT		 (BITW(12)+BITW(11)+BITW(10)+BITW(9)+BITW(8))
+#define  RESET		 BIT(7)
+#define  PROG_HLT		 BIT(6)
+#define  PARITY		 BIT(5)
+#define  FIFO		 BIT(4)
+#define  SEL		 BIT(3)
+#define  SCAM_SEL		 BIT(2)
+#define  RSEL		 BIT(1)
+#define  TIMEOUT		 BIT(0)
+#define  BUS_FREE		 BIT(15)
+#define  XFER_CNT_0	 BIT(14)
+#define  PHASE		 BIT(13)
+#define  IUNKWN		 BIT(12)
+#define  ICMD_COMP	 BIT(11)
+#define  ITICKLE		 BIT(10)
+#define  IDO_STRT		 BIT(9)
+#define  ITAR_DISC	 BIT(8)
+#define  AUTO_INT		 (BIT(12)+BIT(11)+BIT(10)+BIT(9)+BIT(8))
 #define  CLR_ALL_INT	 0xFFFF
 #define  CLR_ALL_INT_1	 0xFF00
 
@@ -673,37 +671,37 @@ typedef struct SCCBscam_info {
 #define  BIOS_DATA_OFFSET     0x60
 #define  BIOS_RELATIVE_CARD   0x64
 
-#define  AR3      (BITW(9) + BITW(8))
-#define  SDATA    BITW(10)
+#define  AR3      (BIT(9) + BIT(8))
+#define  SDATA    BIT(10)
 
-#define  CRD_OP   BITW(11)	/* Cmp Reg. w/ Data */
+#define  CRD_OP   BIT(11)	/* Cmp Reg. w/ Data */
 
-#define  CRR_OP   BITW(12)	/* Cmp Reg. w. Reg. */
+#define  CRR_OP   BIT(12)	/* Cmp Reg. w. Reg. */
 
-#define  CPE_OP   (BITW(14)+BITW(11))	/* Cmp SCSI phs & Branch EQ */
+#define  CPE_OP   (BIT(14)+BIT(11))	/* Cmp SCSI phs & Branch EQ */
 
-#define  CPN_OP   (BITW(14)+BITW(12))	/* Cmp SCSI phs & Branch NOT EQ */
+#define  CPN_OP   (BIT(14)+BIT(12))	/* Cmp SCSI phs & Branch NOT EQ */
 
 #define  ADATA_OUT   0x00
-#define  ADATA_IN    BITW(8)
-#define  ACOMMAND    BITW(10)
-#define  ASTATUS     (BITW(10)+BITW(8))
-#define  AMSG_OUT    (BITW(10)+BITW(9))
-#define  AMSG_IN     (BITW(10)+BITW(9)+BITW(8))
+#define  ADATA_IN    BIT(8)
+#define  ACOMMAND    BIT(10)
+#define  ASTATUS     (BIT(10)+BIT(8))
+#define  AMSG_OUT    (BIT(10)+BIT(9))
+#define  AMSG_IN     (BIT(10)+BIT(9)+BIT(8))
 
-#define  BRH_OP   BITW(13)	/* Branch */
+#define  BRH_OP   BIT(13)	/* Branch */
 
 #define  ALWAYS   0x00
-#define  EQUAL    BITW(8)
-#define  NOT_EQ   BITW(9)
+#define  EQUAL    BIT(8)
+#define  NOT_EQ   BIT(9)
 
-#define  TCB_OP   (BITW(13)+BITW(11))	/* Test condition & branch */
+#define  TCB_OP   (BIT(13)+BIT(11))	/* Test condition & branch */
 
-#define  FIFO_0      BITW(10)
+#define  FIFO_0      BIT(10)
 
-#define  MPM_OP   BITW(15)	/* Match phase and move data */
+#define  MPM_OP   BIT(15)	/* Match phase and move data */
 
-#define  MRR_OP   BITW(14)	/* Move DReg. to Reg. */
+#define  MRR_OP   BIT(14)	/* Move DReg. to Reg. */
 
 #define  S_IDREG  (BIT(2)+BIT(1)+BIT(0))
 
@@ -711,9 +709,9 @@ typedef struct SCCBscam_info {
 #define  D_AR1    BIT(0)
 #define  D_BUCKET (BIT(2) + BIT(1) + BIT(0))
 
-#define  RAT_OP      (BITW(14)+BITW(13)+BITW(11))
+#define  RAT_OP      (BIT(14)+BIT(13)+BIT(11))
 
-#define  SSI_OP      (BITW(15)+BITW(11))
+#define  SSI_OP      (BIT(15)+BIT(11))
 
 #define  SSI_ITAR_DISC	(ITAR_DISC >> 8)
 #define  SSI_IDO_STRT	(IDO_STRT >> 8)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

net-add-ath5k-wireless-driver.patch
net-add-ath5k-wireless-driver-fix.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-mxser_new-upgrade-to-110.patch
char-mxser_new-move-to-pci_vdevice.patch
char-mxser_new-remove-useless-comments-in-mxser_cards.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
fs-select-remove-unused-macros.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
shrink_slab-handle-bad-shrinkers.patch
