From: akpm@linux-foundation.org
Subject: - ssb-chipcommon-add-function-to-get-processor-clock.patch removed from -mm tree
Date: Wed, 08 Aug 2007 16:54:21 -0700
Message-ID: <200708082359.l78NxCSm005067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47788 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761471AbXHIAAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 20:00:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aurelien@aurel32.net, mb@bu3sch.de, nbd@openwrt.org, mm-commits@vger.kernel.org


The patch titled
     ssb-chipcommon: Add function to get processor clock
has been removed from the -mm tree.  Its filename was
     ssb-chipcommon-add-function-to-get-processor-clock.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: ssb-chipcommon: Add function to get processor clock
From: Aurelien Jarno <aurelien@aurel32.net>

Add a new function to get the processor clock.  It originally comes from
the OpenWrt patches.

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ssb/driver_chipcommon.c           |   24 ++++++++++++++++++++
 include/linux/ssb/ssb_driver_chipcommon.h |    2 +
 2 files changed, 26 insertions(+)

diff -puN drivers/ssb/driver_chipcommon.c~ssb-chipcommon-add-function-to-get-processor-clock drivers/ssb/driver_chipcommon.c
--- a/drivers/ssb/driver_chipcommon.c~ssb-chipcommon-add-function-to-get-processor-clock
+++ a/drivers/ssb/driver_chipcommon.c
@@ -256,6 +256,30 @@ void ssb_chipco_resume(struct ssb_chipco
 	ssb_chipco_set_clockmode(cc, SSB_CLKMODE_FAST);
 }
 
+/* Get the processor clock */
+void ssb_chipco_get_clockcpu(struct ssb_chipcommon *cc,
+                             u32 *plltype, u32 *n, u32 *m)
+{
+	*n = chipco_read32(cc, SSB_CHIPCO_CLOCK_N);
+	*plltype = (cc->capabilities & SSB_CHIPCO_CAP_PLLT);
+	switch (*plltype) {
+		case SSB_PLLTYPE_2:
+		case SSB_PLLTYPE_4:
+		case SSB_PLLTYPE_6:
+		case SSB_PLLTYPE_7:
+			*m = chipco_read32(cc, SSB_CHIPCO_CLOCK_MIPS);
+			break;
+		case SSB_PLLTYPE_3:
+			/* 5350 uses m2 to control mips */
+			*m = chipco_read32(cc, SSB_CHIPCO_CLOCK_M2);
+			break;
+		default:
+			*m = chipco_read32(cc, SSB_CHIPCO_CLOCK_SB);
+			break;
+	}
+}
+
+/* Get the bus clock */
 void ssb_chipco_get_clockcontrol(struct ssb_chipcommon *cc,
 				 u32 *plltype, u32 *n, u32 *m)
 {
diff -puN include/linux/ssb/ssb_driver_chipcommon.h~ssb-chipcommon-add-function-to-get-processor-clock include/linux/ssb/ssb_driver_chipcommon.h
--- a/include/linux/ssb/ssb_driver_chipcommon.h~ssb-chipcommon-add-function-to-get-processor-clock
+++ a/include/linux/ssb/ssb_driver_chipcommon.h
@@ -363,6 +363,8 @@ extern void ssb_chipcommon_init(struct s
 extern void ssb_chipco_suspend(struct ssb_chipcommon *cc, pm_message_t state);
 extern void ssb_chipco_resume(struct ssb_chipcommon *cc);
 
+extern void ssb_chipco_get_clockcpu(struct ssb_chipcommon *cc,
+                                    u32 *plltype, u32 *n, u32 *m);
 extern void ssb_chipco_get_clockcontrol(struct ssb_chipcommon *cc,
 					u32 *plltype, u32 *n, u32 *m);
 extern void ssb_chipco_timing_init(struct ssb_chipcommon *cc,
_

Patches currently in -mm which might be from aurelien@aurel32.net are

git-kvm.patch
git-wireless.patch
ssb-chipcommon-add-function-to-get-processor-clock.patch
ssb-chipcommon-add-function-to-get-processor-clock-fix.patch
use-ssb-extif-in-ssb-mips-core-driver.patch
add-buswidth-to-ssb-mips-core-flash-driver.patch
