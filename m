From: akpm@linux-foundation.org
Subject: - watchdog-support-3.patch removed from -mm tree
Date: Wed, 08 Aug 2007 16:54:19 -0700
Message-ID: <200708082359.l78NxAih005060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59633 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762808AbXHIAAG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 20:00:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aurelien@aurel32.net, mb@bu3sch.de, nbd@openwrt.org, mm-commits@vger.kernel.org


The patch titled
     SSB: watchdog support
has been removed from the -mm tree.  Its filename was
     watchdog-support-3.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: SSB: watchdog support
From: Aurelien Jarno <aurelien@aurel32.net>

Add a new function to control the watchdog.  It originally comes from the
OpenWrt patches.

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ssb/driver_chipcommon.c           |    7 +++++++
 include/linux/ssb/ssb_driver_chipcommon.h |    3 +++
 2 files changed, 10 insertions(+)

diff -puN drivers/ssb/driver_chipcommon.c~watchdog-support-3 drivers/ssb/driver_chipcommon.c
--- a/drivers/ssb/driver_chipcommon.c~watchdog-support-3
+++ a/drivers/ssb/driver_chipcommon.c
@@ -312,6 +312,13 @@ void ssb_chipco_timing_init(struct ssb_c
 	}
 }
 
+/* Set chip watchdog reset timer to fire in 'ticks' backplane cycles */
+void
+ssb_chipco_watchdog_timer_set(struct ssb_chipcommon *cc, u32 ticks)
+{
+	/* instant NMI */
+	chipco_write32(cc, SSB_CHIPCO_WATCHDOG, ticks);
+}
 
 #ifdef CONFIG_SSB_SERIAL
 int ssb_chipco_serial_init(struct ssb_chipcommon *cc,
diff -puN include/linux/ssb/ssb_driver_chipcommon.h~watchdog-support-3 include/linux/ssb/ssb_driver_chipcommon.h
--- a/include/linux/ssb/ssb_driver_chipcommon.h~watchdog-support-3
+++ a/include/linux/ssb/ssb_driver_chipcommon.h
@@ -377,6 +377,9 @@ enum ssb_clkmode {
 extern void ssb_chipco_set_clockmode(struct ssb_chipcommon *cc,
 				     enum ssb_clkmode mode);
 
+extern void ssb_chipco_watchdog_timer_set(struct ssb_chipcommon *cc,
+					  u32 ticks);
+
 #ifdef CONFIG_SSB_SERIAL
 extern int ssb_chipco_serial_init(struct ssb_chipcommon *cc,
 				  struct ssb_serial_port *ports);
_

Patches currently in -mm which might be from aurelien@aurel32.net are

git-kvm.patch
git-wireless.patch
watchdog-support-3.patch
ssb-chipcommon-add-function-to-get-processor-clock.patch
ssb-chipcommon-add-function-to-get-processor-clock-fix.patch
use-ssb-extif-in-ssb-mips-core-driver.patch
add-buswidth-to-ssb-mips-core-flash-driver.patch
