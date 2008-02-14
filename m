From: akpm@linux-foundation.org
Subject: - parport-section-fixup.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:22:28 -0500
Message-ID: <200802150225.m1F2PlcD015186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33323 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755693AbYBOC0B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:26:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     parport: section fixup
has been removed from the -mm tree.  Its filename was
     parport-section-fixup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parport: section fixup
From: David Brownell <david-b@pacbell.net>

Fix section warning for parport_ECP_supported(); it's called from a routine
exported to modules, so it can't be removed with __devinit section pruning.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_pc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/parport/parport_pc.c~parport-section-fixup drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~parport-section-fixup
+++ a/drivers/parport/parport_pc.c
@@ -1768,7 +1768,7 @@ static int parport_PS2_supported(struct 
 }
 
 #ifdef CONFIG_PARPORT_PC_FIFO
-static int __devinit parport_ECP_supported(struct parport *pb)
+static int parport_ECP_supported(struct parport *pb)
 {
 	int i;
 	int config, configb;
@@ -1992,7 +1992,7 @@ static int parport_ECPEPP_supported(stru
 /* Don't bother probing for modes we know we won't use. */
 static int __devinit parport_PS2_supported(struct parport *pb) { return 0; }
 #ifdef CONFIG_PARPORT_PC_FIFO
-static int __devinit parport_ECP_supported(struct parport *pb) { return 0; }
+static int parport_ECP_supported(struct parport *pb) { return 0; }
 #endif
 static int __devinit parport_EPP_supported(struct parport *pb) { return 0; }
 static int __devinit parport_ECPEPP_supported(struct parport *pb){return 0;}
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch
git-avr32.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
usb-net-asix-does-not-really-need-10-100mbit.patch
usb-ehci-tolerates-some-buggy-devices.patch
rtc-cmos-display-hpet-emulation-mode.patch
rtc-avoid-legacy-drivers-with-generic-framework.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-x1205-new-style-conversion.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
