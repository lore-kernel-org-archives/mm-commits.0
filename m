From: akpm@linux-foundation.org
Subject: - remove-unused-header-file-drivers-char-digih.patch removed from -mm tree
Date: Tue, 08 May 2007 19:46:26 -0700
Message-ID: <200705090246.l492kQGt008852@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755194AbXEICq3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:46:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     remove unused header file: drivers/char/digi.h
has been removed from the -mm tree.  Its filename was
     remove-unused-header-file-drivers-char-digih.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove unused header file: drivers/char/digi.h
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/digi.h |   71 ------------------------------------------
 1 file changed, 71 deletions(-)

diff -puN drivers/char/digi.h~remove-unused-header-file-drivers-char-digih /dev/null
--- a/drivers/char/digi.h
+++ /dev/null
@@ -1,71 +0,0 @@
-/*          Definitions for DigiBoard ditty(1) command.                 */
-
-#if !defined(TIOCMODG)
-#define	TIOCMODG	(('d'<<8) | 250)		/* get modem ctrl state	*/
-#define	TIOCMODS	(('d'<<8) | 251)		/* set modem ctrl state	*/
-#endif
-
-#if !defined(TIOCMSET)
-#define	TIOCMSET	(('d'<<8) | 252)		/* set modem ctrl state	*/
-#define	TIOCMGET	(('d'<<8) | 253)		/* set modem ctrl state	*/
-#endif
-
-#if !defined(TIOCMBIC)
-#define	TIOCMBIC	(('d'<<8) | 254)		/* set modem ctrl state */
-#define	TIOCMBIS	(('d'<<8) | 255)		/* set modem ctrl state */
-#endif
-
-#if !defined(TIOCSDTR)
-#define	TIOCSDTR	(('e'<<8) | 0)		/* set DTR		*/
-#define	TIOCCDTR	(('e'<<8) | 1)		/* clear DTR		*/
-#endif
-
-/************************************************************************
- * Ioctl command arguments for DIGI parameters.
- ************************************************************************/
-#define DIGI_GETA	(('e'<<8) | 94)		/* Read params		*/
-
-#define DIGI_SETA	(('e'<<8) | 95)		/* Set params		*/
-#define DIGI_SETAW	(('e'<<8) | 96)		/* Drain & set params	*/
-#define DIGI_SETAF	(('e'<<8) | 97)		/* Drain, flush & set params */
-
-#define	DIGI_GETFLOW	(('e'<<8) | 99)		/* Get startc/stopc flow */
-						/* control characters 	 */
-#define	DIGI_SETFLOW	(('e'<<8) | 100)		/* Set startc/stopc flow */
-						/* control characters	 */
-#define	DIGI_GETAFLOW	(('e'<<8) | 101)		/* Get Aux. startc/stopc */
-						/* flow control chars 	 */
-#define	DIGI_SETAFLOW	(('e'<<8) | 102)		/* Set Aux. startc/stopc */
-						/* flow control chars	 */
-
-struct	digiflow_struct {
-	unsigned char	startc;				/* flow cntl start char	*/
-	unsigned char	stopc;				/* flow cntl stop char	*/
-};
-
-typedef struct digiflow_struct digiflow_t;
-
-
-/************************************************************************
- * Values for digi_flags 
- ************************************************************************/
-#define DIGI_IXON	0x0001		/* Handle IXON in the FEP	*/
-#define DIGI_FAST	0x0002		/* Fast baud rates		*/
-#define RTSPACE		0x0004		/* RTS input flow control	*/
-#define CTSPACE		0x0008		/* CTS output flow control	*/
-#define DSRPACE		0x0010		/* DSR output flow control	*/
-#define DCDPACE		0x0020		/* DCD output flow control	*/
-#define DTRPACE		0x0040		/* DTR input flow control	*/
-#define DIGI_FORCEDCD	0x0100		/* Force carrier		*/
-#define	DIGI_ALTPIN	0x0200		/* Alternate RJ-45 pin config	*/
-#define	DIGI_AIXON	0x0400		/* Aux flow control in fep	*/
-
-
-/************************************************************************
- * Structure used with ioctl commands for DIGI parameters.
- ************************************************************************/
-struct digi_struct {
-	unsigned short	digi_flags;		/* Flags (see above)	*/
-};
-
-typedef struct digi_struct digi_t;
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
arm-remove-useless-config-option-generic_bust_spinlock.patch
git-avr32.patch
git-dvb.patch
git-ieee1394.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
