From: akpm@linux-foundation.org
Subject: - net_sb1250_mac-update-kconfig-entry.patch removed from -mm tree
Date: Thu, 20 Sep 2007 13:56:35 -0700
Message-ID: <200709202056.l8KKuZ0d002110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36701 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbXITU5R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 16:57:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, jeff@garzik.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     NET_SB1250_MAC: Update Kconfig entry
has been removed from the -mm tree.  Its filename was
     net_sb1250_mac-update-kconfig-entry.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: NET_SB1250_MAC: Update Kconfig entry
From: "Maciej W. Rozycki" <macro@linux-mips.org>

The SB1250 network interfaces are Gigabit Ethernet ones.  Move the Kconfig
entry to the appropriate section and add some help text.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN drivers/net/Kconfig~net_sb1250_mac-update-kconfig-entry drivers/net/Kconfig
--- a/drivers/net/Kconfig~net_sb1250_mac-update-kconfig-entry
+++ a/drivers/net/Kconfig
@@ -472,10 +472,6 @@ config MIPS_AU1X00_ENET
 	  If you have an Alchemy Semi AU1X00 based system
 	  say Y.  Otherwise, say N.
 
-config NET_SB1250_MAC
-	tristate "SB1250 Ethernet support"
-	depends on SIBYTE_SB1xxx_SOC
-
 config SGI_IOC3_ETH
 	bool "SGI IOC3 Ethernet"
 	depends on PCI && SGI_IP27
@@ -2164,6 +2160,18 @@ config R8169_VLAN
 	  
 	  If in doubt, say Y.
 
+config NET_SB1250_MAC
+	tristate "SB1250 Gigabit Ethernet support"
+	depends on SIBYTE_SB1xxx_SOC
+	---help---
+	  This driver supports Gigabit Ethernet interfaces based on the
+	  Broadcom SiByte family of System-On-a-Chip parts.  They include
+	  the BCM1120, BCM1125, BCM1125H, BCM1250, BCM1255, BCM1280, BCM1455
+	  and BCM1480 chips.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called sb1250-mac.
+
 config SIS190
 	tristate "SiS190/SiS191 gigabit ethernet support"
 	depends on PCI
_

Patches currently in -mm which might be from macro@linux-mips.org are

git-mips.patch
git-net.patch
net_sb1250_mac-update-kconfig-entry.patch
net_sb1250_mac-rename-to-sb1250_mac.patch
phylib-spinlock-fixes-for-softirqs.patch
include-linux-typesh-in-if_fddih.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
lk201-remove-obsolete-driver.patch
drivers-video-kconfig-fix-fb_pmagb_b-dependencies.patch
drivers-video-pmag-ba-fbc-improve-diagnostics.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
