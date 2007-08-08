From: akpm@linux-foundation.org
Subject: - net-smc91x-build-fixes-for-general-sh-boards.patch removed from -mm tree
Date: Wed, 08 Aug 2007 12:07:50 -0700
Message-ID: <200708081907.l78J7oxQ025798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41942 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763903AbXHHTIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 15:08:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     net: smc91x: Build fixes for general sh boards.
has been removed from the -mm tree.  Its filename was
     net-smc91x-build-fixes-for-general-sh-boards.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: net: smc91x: Build fixes for general sh boards.
From: Paul Mundt <lethal@linux-sh.org>

SH boards in general only wire this up in 8 or 16-bit mode, and as we never
had the wrappers for 32-bit mode defined, SMC_CAN_USE_32BIT caused build
failure for the non-Solution Engine boards.  This gets it building again.

Also kill off the straggling set_irq_type() definition, this is left over
cruft that was missed when the rest of it switched to IRQ flags.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smc91x.h |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/net/smc91x.h~net-smc91x-build-fixes-for-general-sh-boards drivers/net/smc91x.h
--- a/drivers/net/smc91x.h~net-smc91x-build-fixes-for-general-sh-boards
+++ a/drivers/net/smc91x.h
@@ -299,7 +299,7 @@ SMC_outw(u16 val, void __iomem *ioaddr, 
 
 #define SMC_CAN_USE_8BIT       1
 #define SMC_CAN_USE_16BIT      1
-#define SMC_CAN_USE_32BIT      1
+#define SMC_CAN_USE_32BIT      0
 
 #define SMC_inb(a, r)          inb((a) + (r))
 #define SMC_inw(a, r)          inw((a) + (r))
@@ -310,8 +310,6 @@ SMC_outw(u16 val, void __iomem *ioaddr, 
 
 #endif  /* BOARDS */
 
-#define set_irq_type(irq, type) do {} while (0)
-
 #elif   defined(CONFIG_M32R)
 
 #define SMC_CAN_USE_8BIT	0
_

Patches currently in -mm which might be from lethal@linux-sh.org are

pvr2fb-consolidated-cleanup-of-pvr2fbc.patch
apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
git-netdev-all.patch
git-sh.patch
sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch
usb-enable-hcd-support-on-sh-unconditionally.patch
usb-r8a66597-hcd-clean-up-error-path.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
clean-up-duplicate-includes-in-mm.patch
printk-add-interfaces-for-external-access-to-the-log-buffer.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix-2.patch
