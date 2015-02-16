From: akpm@linux-foundation.org
Subject: [merged] rtc-imx-dryice-add-more-known-register-bits.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:19:07 -0800
Message-ID: <54e250bb.8NcOdERLx3vveWQX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbbBPUTn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:19:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbe@pengutronix.de, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-imxdi.c: add more known register bits
has been removed from the -mm tree.  Its filename was
     rtc-imx-dryice-add-more-known-register-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Juergen Borleis <jbe@pengutronix.de>
Subject: drivers/rtc/rtc-imxdi.c: add more known register bits

Intended for monitoring and controlling the security features.  These bits
are required to bring this unit back to live after a security violation
event was detected.  The code to bring it back to live will follow after a
vendor clearance.

Signed-off-by: Juergen Borleis <jbe@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-imxdi.c |   44 ++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-imxdi.c~rtc-imx-dryice-add-more-known-register-bits drivers/rtc/rtc-imxdi.c
--- a/drivers/rtc/rtc-imxdi.c~rtc-imx-dryice-add-more-known-register-bits
+++ a/drivers/rtc/rtc-imxdi.c
@@ -50,22 +50,58 @@
 #define DCAMR_UNSET  0xFFFFFFFF  /* doomsday - 1 sec */
 
 #define DCR       0x10           /* Control Reg */
+#define DCR_TDCHL (1 << 30)      /* Tamper-detect configuration hard lock */
+#define DCR_TDCSL (1 << 29)      /* Tamper-detect configuration soft lock */
+#define DCR_KSSL  (1 << 27)      /* Key-select soft lock */
+#define DCR_MCHL  (1 << 20)      /* Monotonic-counter hard lock */
+#define DCR_MCSL  (1 << 19)      /* Monotonic-counter soft lock */
+#define DCR_TCHL  (1 << 18)      /* Timer-counter hard lock */
+#define DCR_TCSL  (1 << 17)      /* Timer-counter soft lock */
+#define DCR_FSHL  (1 << 16)      /* Failure state hard lock */
 #define DCR_TCE   (1 << 3)       /* Time Counter Enable */
+#define DCR_MCE   (1 << 2)       /* Monotonic Counter Enable */
 
 #define DSR       0x14           /* Status Reg */
-#define DSR_WBF   (1 << 10)      /* Write Busy Flag */
-#define DSR_WNF   (1 << 9)       /* Write Next Flag */
-#define DSR_WCF   (1 << 8)       /* Write Complete Flag */
+#define DSR_WTD   (1 << 23)      /* Wire-mesh tamper detected */
+#define DSR_ETBD  (1 << 22)      /* External tamper B detected */
+#define DSR_ETAD  (1 << 21)      /* External tamper A detected */
+#define DSR_EBD   (1 << 20)      /* External boot detected */
+#define DSR_SAD   (1 << 19)      /* SCC alarm detected */
+#define DSR_TTD   (1 << 18)      /* Temperatur tamper detected */
+#define DSR_CTD   (1 << 17)      /* Clock tamper detected */
+#define DSR_VTD   (1 << 16)      /* Voltage tamper detected */
+#define DSR_WBF   (1 << 10)      /* Write Busy Flag (synchronous) */
+#define DSR_WNF   (1 << 9)       /* Write Next Flag (synchronous) */
+#define DSR_WCF   (1 << 8)       /* Write Complete Flag (synchronous)*/
 #define DSR_WEF   (1 << 7)       /* Write Error Flag */
 #define DSR_CAF   (1 << 4)       /* Clock Alarm Flag */
+#define DSR_MCO   (1 << 3)       /* monotonic counter overflow */
+#define DSR_TCO   (1 << 2)       /* time counter overflow */
 #define DSR_NVF   (1 << 1)       /* Non-Valid Flag */
 #define DSR_SVF   (1 << 0)       /* Security Violation Flag */
 
-#define DIER      0x18           /* Interrupt Enable Reg */
+#define DIER      0x18           /* Interrupt Enable Reg (synchronous) */
 #define DIER_WNIE (1 << 9)       /* Write Next Interrupt Enable */
 #define DIER_WCIE (1 << 8)       /* Write Complete Interrupt Enable */
 #define DIER_WEIE (1 << 7)       /* Write Error Interrupt Enable */
 #define DIER_CAIE (1 << 4)       /* Clock Alarm Interrupt Enable */
+#define DIER_SVIE (1 << 0)       /* Security-violation Interrupt Enable */
+
+#define DMCR      0x1c           /* DryIce Monotonic Counter Reg */
+
+#define DTCR      0x28           /* DryIce Tamper Configuration Reg */
+#define DTCR_MOE  (1 << 9)       /* monotonic overflow enabled */
+#define DTCR_TOE  (1 << 8)       /* time overflow enabled */
+#define DTCR_WTE  (1 << 7)       /* wire-mesh tamper enabled */
+#define DTCR_ETBE (1 << 6)       /* external B tamper enabled */
+#define DTCR_ETAE (1 << 5)       /* external A tamper enabled */
+#define DTCR_EBE  (1 << 4)       /* external boot tamper enabled */
+#define DTCR_SAIE (1 << 3)       /* SCC enabled */
+#define DTCR_TTE  (1 << 2)       /* temperature tamper enabled */
+#define DTCR_CTE  (1 << 1)       /* clock tamper enabled */
+#define DTCR_VTE  (1 << 0)       /* voltage tamper enabled */
+
+#define DGPR      0x3c           /* DryIce General Purpose Reg */
 
 /**
  * struct imxdi_dev - private imxdi rtc data
_

Patches currently in -mm which might be from jbe@pengutronix.de are

origin.patch

