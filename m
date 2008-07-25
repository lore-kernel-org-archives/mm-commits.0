From: akpm@linux-foundation.org
Subject: - remove-apparently-unused-fd1772h-header-file.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:54:17 -0700
Message-ID: <200807252254.m6PMsHOI002800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752308AbYGYWyc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:54:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, akpm@linux-foundation.org, bunk@stusta.de, spyro@f2s.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Remove apparently unused fd1772.h header file.
has been removed from the -mm tree.  Its filename was
     remove-apparently-unused-fd1772h-header-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove apparently unused fd1772.h header file.
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

This header file has been unused for quite some time, and the
corresponding source files appear to have been removed back in commit
99eb8a550d.

commit 99eb8a550dbccc0e1f6c7e866fe421810e0585f6
Author: Adrian Bunk <bunk@stusta.de>
Date:   Tue Jul 31 00:38:19 2007 -0700

    Remove the arm26 port

    The arm26 port has been in a state where it was far from even compiling
    for quite some time.

    Ian Molton agreed with the removal.

    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Cc: Ian Molton <spyro@f2s.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Ian Molton <spyro@f2s.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fd1772.h |   80 ---------------------------------------
 1 file changed, 80 deletions(-)

diff -puN include/linux/fd1772.h~remove-apparently-unused-fd1772h-header-file /dev/null
--- a/include/linux/fd1772.h
+++ /dev/null
@@ -1,80 +0,0 @@
-#ifndef _LINUX_FD1772REG_H
-#define _LINUX_FD1772REG_H
-
-/*
-** WD1772 stuff - originally from the M68K Linux
- * Modified for Archimedes by Dave Gilbert (gilbertd@cs.man.ac.uk)
- */
-
-/* register codes */
-
-#define FDC1772SELREG_STP   (0x80)   /* command/status register */
-#define FDC1772SELREG_TRA   (0x82)   /* track register */
-#define FDC1772SELREG_SEC   (0x84)   /* sector register */
-#define FDC1772SELREG_DTA   (0x86)   /* data register */
-
-/* register names for FDC1772_READ/WRITE macros */
-
-#define FDC1772REG_CMD         0
-#define FDC1772REG_STATUS      0
-#define FDC1772REG_TRACK       2
-#define FDC1772REG_SECTOR      4
-#define FDC1772REG_DATA                6
-
-/* command opcodes */
-
-#define FDC1772CMD_RESTORE  (0x00)   /*  -                   */
-#define FDC1772CMD_SEEK     (0x10)   /*   |                  */
-#define FDC1772CMD_STEP     (0x20)   /*   |  TYP 1 Commands  */
-#define FDC1772CMD_STIN     (0x40)   /*   |                  */
-#define FDC1772CMD_STOT     (0x60)   /*  -                   */
-#define FDC1772CMD_RDSEC    (0x80)   /*  -   TYP 2 Commands  */
-#define FDC1772CMD_WRSEC    (0xa0)   /*  -          "        */
-#define FDC1772CMD_RDADR    (0xc0)   /*  -                   */
-#define FDC1772CMD_RDTRA    (0xe0)   /*   |  TYP 3 Commands  */
-#define FDC1772CMD_WRTRA    (0xf0)   /*  -                   */
-#define FDC1772CMD_FORCI    (0xd0)   /*  -   TYP 4 Command   */
-
-/* command modifier bits */
-
-#define FDC1772CMDADD_SR6   (0x00)   /* step rate settings */
-#define FDC1772CMDADD_SR12  (0x01)
-#define FDC1772CMDADD_SR2   (0x02)
-#define FDC1772CMDADD_SR3   (0x03)
-#define FDC1772CMDADD_V     (0x04)   /* verify */
-#define FDC1772CMDADD_H     (0x08)   /* wait for spin-up */
-#define FDC1772CMDADD_U     (0x10)   /* update track register */
-#define FDC1772CMDADD_M     (0x10)   /* multiple sector access */
-#define FDC1772CMDADD_E     (0x04)   /* head settling flag */
-#define FDC1772CMDADD_P     (0x02)   /* precompensation */
-#define FDC1772CMDADD_A0    (0x01)   /* DAM flag */
-
-/* status register bits */
-
-#define        FDC1772STAT_MOTORON     (0x80)   /* motor on */
-#define        FDC1772STAT_WPROT       (0x40)   /* write protected (FDC1772CMD_WR*) */
-#define        FDC1772STAT_SPINUP      (0x20)   /* motor speed stable (Type I) */
-#define        FDC1772STAT_DELDAM      (0x20)   /* sector has deleted DAM (Type II+III) */
-#define        FDC1772STAT_RECNF       (0x10)   /* record not found */
-#define        FDC1772STAT_CRC         (0x08)   /* CRC error */
-#define        FDC1772STAT_TR00        (0x04)   /* Track 00 flag (Type I) */
-#define        FDC1772STAT_LOST        (0x04)   /* Lost Data (Type II+III) */
-#define        FDC1772STAT_IDX         (0x02)   /* Index status (Type I) */
-#define        FDC1772STAT_DRQ         (0x02)   /* DRQ status (Type II+III) */
-#define        FDC1772STAT_BUSY        (0x01)   /* FDC1772 is busy */
-
-
-/* PSG Port A Bit Nr 0 .. Side Sel .. 0 -> Side 1  1 -> Side 2 */
-#define DSKSIDE     (0x01)
-        
-#define DSKDRVNONE  (0x06)
-#define DSKDRV0     (0x02)
-#define DSKDRV1     (0x04)
-
-/* step rates */
-#define        FDC1772STEP_6   0x00
-#define        FDC1772STEP_12  0x01
-#define        FDC1772STEP_2   0x02
-#define        FDC1772STEP_3   0x03
