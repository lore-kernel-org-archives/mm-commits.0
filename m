From: akpm@linux-foundation.org
Subject: + net_sb1250_mac-update-kconfig-entry.patch added to -mm tree
Date: Fri, 14 Sep 2007 19:09:59 -0700
Message-ID: <200709150209.l8F29xRL002472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57498 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756565AbXIOCKS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 22:10:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, jeff@garzik.org, ralf@linux-mips.org


The patch titled
     NET_SB1250_MAC: Update Kconfig entry
has been added to the -mm tree.  Its filename is
     net_sb1250_mac-update-kconfig-entry.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -466,10 +466,6 @@ config MIPS_AU1X00_ENET
 	  If you have an Alchemy Semi AU1X00 based system
 	  say Y.  Otherwise, say N.
 
-config NET_SB1250_MAC
-	tristate "SB1250 Ethernet support"
-	depends on SIBYTE_SB1xxx_SOC
-
 config SGI_IOC3_ETH
 	bool "SGI IOC3 Ethernet"
 	depends on PCI && SGI_IP27
@@ -2157,6 +2153,18 @@ config R8169_VLAN
 	  
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
sb1250-macc-de-typedef-de-volatile-de-etc.patch
sb1250-macc-de-typedef-de-volatile-de-etc-update.patch
net_sb1250_mac-update-kconfig-entry.patch
net_sb1250_mac-rename-to-sb1250_mac.patch
include-linux-typesh-in-if_fddih.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
