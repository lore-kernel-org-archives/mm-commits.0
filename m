From: akpm@linux-foundation.org
Subject: + drivers-telephony-ixj-convert-to-generic-boolean.patch added to -mm tree
Date: Fri, 09 Feb 2007 02:18:36 -0800
Message-ID: <200702091018.l19AIawD010540@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41626 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946308AbXBIKSy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 05:18:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ricknu-0@student.ltu.se, randy.dunlap@oracle.com


The patch titled
     drivers/telephony/ixj: Convert to generic boolean
has been added to the -mm tree.  Its filename is
     drivers-telephony-ixj-convert-to-generic-boolean.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/telephony/ixj: Convert to generic boolean
From: Richard Knutsson <ricknu-0@student.ltu.se>

Convert:
BOOL  -> bool
FALSE -> false
TRUE  -> true

Change a variable ('mContinue') to boolean from char, since it is used
as boolean.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/telephony/ixj.c |   39 +++++++++++++++++++-------------------
 drivers/telephony/ixj.h |    4 ---
 2 files changed, 20 insertions(+), 23 deletions(-)

diff -puN drivers/telephony/ixj.c~drivers-telephony-ixj-convert-to-generic-boolean drivers/telephony/ixj.c
--- a/drivers/telephony/ixj.c~drivers-telephony-ixj-convert-to-generic-boolean
+++ a/drivers/telephony/ixj.c
@@ -648,9 +648,9 @@ static inline BYTE SLIC_GetState(IXJ *j)
 	return j->pld_slicr.bits.state;
 }
 
-static BOOL SLIC_SetState(BYTE byState, IXJ *j)
+static bool SLIC_SetState(BYTE byState, IXJ *j)
 {
-	BOOL fRetVal = FALSE;
+	bool fRetVal = false;
 
 	if (j->cardtype == QTI_PHONECARD) {
 		if (j->flags.pcmciasct) {
@@ -659,14 +659,14 @@ static BOOL SLIC_SetState(BYTE byState, 
 			case PLD_SLIC_STATE_OC:
 				j->pslic.bits.powerdown = 1;
 				j->pslic.bits.ring0 = j->pslic.bits.ring1 = 0;
-				fRetVal = TRUE;
+				fRetVal = true;
 				break;
 			case PLD_SLIC_STATE_RINGING:
 				if (j->readers || j->writers) {
 					j->pslic.bits.powerdown = 0;
 					j->pslic.bits.ring0 = 1;
 					j->pslic.bits.ring1 = 0;
-					fRetVal = TRUE;
+					fRetVal = true;
 				}
 				break;
 			case PLD_SLIC_STATE_OHT:	/* On-hook transmit */
@@ -679,14 +679,14 @@ static BOOL SLIC_SetState(BYTE byState, 
 					j->pslic.bits.powerdown = 1;
 				}
 				j->pslic.bits.ring0 = j->pslic.bits.ring1 = 0;
-				fRetVal = TRUE;
+				fRetVal = true;
 				break;
 			case PLD_SLIC_STATE_APR:	/* Active polarity reversal */
 
 			case PLD_SLIC_STATE_OHTPR:	/* OHT polarity reversal */
 
 			default:
-				fRetVal = FALSE;
+				fRetVal = false;
 				break;
 			}
 			j->psccr.bits.dev = 3;
@@ -703,7 +703,7 @@ static BOOL SLIC_SetState(BYTE byState, 
 			j->pld_slicw.bits.c3 = 0;
 			j->pld_slicw.bits.b2en = 0;
 			outb_p(j->pld_slicw.byte, j->XILINXbase + 0x01);
-			fRetVal = TRUE;
+			fRetVal = true;
 			break;
 		case PLD_SLIC_STATE_RINGING:
 			j->pld_slicw.bits.c1 = 1;
@@ -711,7 +711,7 @@ static BOOL SLIC_SetState(BYTE byState, 
 			j->pld_slicw.bits.c3 = 0;
 			j->pld_slicw.bits.b2en = 1;
 			outb_p(j->pld_slicw.byte, j->XILINXbase + 0x01);
-			fRetVal = TRUE;
+			fRetVal = true;
 			break;
 		case PLD_SLIC_STATE_ACTIVE:
 			j->pld_slicw.bits.c1 = 0;
@@ -719,7 +719,7 @@ static BOOL SLIC_SetState(BYTE byState, 
 			j->pld_slicw.bits.c3 = 0;
 			j->pld_slicw.bits.b2en = 0;
 			outb_p(j->pld_slicw.byte, j->XILINXbase + 0x01);
-			fRetVal = TRUE;
+			fRetVal = true;
 			break;
 		case PLD_SLIC_STATE_OHT:	/* On-hook transmit */
 
@@ -728,7 +728,7 @@ static BOOL SLIC_SetState(BYTE byState, 
 			j->pld_slicw.bits.c3 = 0;
 			j->pld_slicw.bits.b2en = 0;
 			outb_p(j->pld_slicw.byte, j->XILINXbase + 0x01);
-			fRetVal = TRUE;
+			fRetVal = true;
 			break;
 		case PLD_SLIC_STATE_TIPOPEN:
 			j->pld_slicw.bits.c1 = 0;
@@ -736,7 +736,7 @@ static BOOL SLIC_SetState(BYTE byState, 
 			j->pld_slicw.bits.c3 = 1;
 			j->pld_slicw.bits.b2en = 0;
 			outb_p(j->pld_slicw.byte, j->XILINXbase + 0x01);
-			fRetVal = TRUE;
+			fRetVal = true;
 			break;
 		case PLD_SLIC_STATE_STANDBY:
 			j->pld_slicw.bits.c1 = 1;
@@ -744,7 +744,7 @@ static BOOL SLIC_SetState(BYTE byState, 
 			j->pld_slicw.bits.c3 = 1;
 			j->pld_slicw.bits.b2en = 1;
 			outb_p(j->pld_slicw.byte, j->XILINXbase + 0x01);
-			fRetVal = TRUE;
+			fRetVal = true;
 			break;
 		case PLD_SLIC_STATE_APR:	/* Active polarity reversal */
 
@@ -753,7 +753,7 @@ static BOOL SLIC_SetState(BYTE byState, 
 			j->pld_slicw.bits.c3 = 1;
 			j->pld_slicw.bits.b2en = 0;
 			outb_p(j->pld_slicw.byte, j->XILINXbase + 0x01);
-			fRetVal = TRUE;
+			fRetVal = true;
 			break;
 		case PLD_SLIC_STATE_OHTPR:	/* OHT polarity reversal */
 
@@ -762,10 +762,10 @@ static BOOL SLIC_SetState(BYTE byState, 
 			j->pld_slicw.bits.c3 = 1;
 			j->pld_slicw.bits.b2en = 0;
 			outb_p(j->pld_slicw.byte, j->XILINXbase + 0x01);
-			fRetVal = TRUE;
+			fRetVal = true;
 			break;
 		default:
-			fRetVal = FALSE;
+			fRetVal = false;
 			break;
 		}
 	}
@@ -4969,7 +4969,8 @@ static int ixj_daa_cid_read(IXJ *j)
 {
 	int i;
 	BYTES bytes;
-	char CID[ALISDAA_CALLERID_SIZE], mContinue;
+	char CID[ALISDAA_CALLERID_SIZE];
+	bool mContinue;
 	char *pIn, *pOut;
 
 	if (!SCI_Prepare(j))
@@ -5013,7 +5014,7 @@ static int ixj_daa_cid_read(IXJ *j)
 
 	pIn = CID;
 	pOut = j->m_DAAShadowRegs.CAO_REGS.CAO.CallerID;
-	mContinue = 1;
+	mContinue = true;
 	while (mContinue) {
 		if ((pIn[1] & 0x03) == 0x01) {
 			pOut[0] = pIn[0];
@@ -5027,7 +5028,7 @@ static int ixj_daa_cid_read(IXJ *j)
 		if ((pIn[4] & 0xc0) == 0x40) {
 			pOut[3] = ((pIn[4] & 0x3f) << 2) | ((pIn[3] & 0xc0) >> 6);
 		} else {
-			mContinue = FALSE;
+			mContinue = false;
 		}
 		pIn += 5, pOut += 4;
 	}
@@ -7498,7 +7499,7 @@ static BYTE PCIEE_ReadBit(WORD wEEPROMAd
 	return ((inb(wEEPROMAddress) >> 3) & 1);
 }
 
-static BOOL PCIEE_ReadWord(WORD wAddress, WORD wLoc, WORD * pwResult)
+static bool PCIEE_ReadWord(WORD wAddress, WORD wLoc, WORD * pwResult)
 {
 	BYTE lastLCC;
 	WORD wEEPROMAddress = wAddress + 3;
diff -puN drivers/telephony/ixj.h~drivers-telephony-ixj-convert-to-generic-boolean drivers/telephony/ixj.h
--- a/drivers/telephony/ixj.h~drivers-telephony-ixj-convert-to-generic-boolean
+++ a/drivers/telephony/ixj.h
@@ -48,15 +48,11 @@
 typedef __u16 WORD;
 typedef __u32 DWORD;
 typedef __u8 BYTE;
-typedef __u8 BOOL;
 
 #ifndef IXJMAX
 #define IXJMAX 16
 #endif
 
-#define TRUE 1
-#define FALSE 0
-
 /******************************************************************************
 *
 *  This structure when unioned with the structures below makes simple byte
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

origin.patch
git-dvb.patch
git-net.patch
git-scsi-misc.patch
drivers-block-dac960-converted-boolean-to-bool.patch
include-linux-kernelh-remove-labs.patch
drivers-telephony-ixj-convert-to-generic-boolean.patch
drivers-isdn-hardware-eicon-convert-to-generic-boolean-values.patch
drivers-isdn-hisax-convert-to-generic-boolean-values.patch
drivers-video-sis-convert-to-generic-boolean.patch
