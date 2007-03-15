From: akpm@linux-foundation.org
Subject: - ibmtr-drain-rich-supply-of-modpost-warnings.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:58:57 -0800
Message-ID: <200703152158.l2FLwvO0027773@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42715 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbXCOWCP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 18:02:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     ibmtr: drain rich supply of modpost warnings
has been removed from the -mm tree.  Its filename was
     ibmtr-drain-rich-supply-of-modpost-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ibmtr: drain rich supply of modpost warnings
From: Ralf Baechle <ralf@linux-mips.org>

Building ibmtr as a module produces a spectacular pile of modpost warnings:

WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.text:ibmtr_probe1 from .text between 'ibmtr_probe_card' (at offset 0x450) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.text:ibmtr_probe1 from .text between 'ibmtr_probe_card' (at offset 0x454) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.text:ibmtr_probe1 from .text between 'ibmtr_probe_card' (at offset 0x458) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.text:ibmtr_probe1 from .text between 'ibmtr_probe_card' (at offset 0x45c) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.data:ibmtr_portlist from .text between 'ibmtr_probe_card' (at offset 0x4e8) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.data:ibmtr_portlist from .text between 'ibmtr_probe_card' (at offset 0x4ec) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.data:ibmtr_portlist from .text between 'ibmtr_probe_card' (at offset 0x4f0) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.data:ibmtr_portlist from .text between 'ibmtr_probe_card' (at offset 0x4f4) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.text:find_turbo_adapters from .text between 'ibmtr_probe_card' (at offset 0x500) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.text:find_turbo_adapters from .text between 'ibmtr_probe_card' (at offset 0x504) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.text:find_turbo_adapters from .text between 'ibmtr_probe_card' (at offset 0x508) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.text:find_turbo_adapters from .text between 'ibmtr_probe_card' (at offset 0x50c) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.data:ibmtr_portlist from .text between 'ibmtr_probe_card' (at offset 0x520) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.data:ibmtr_portlist from .text between 'ibmtr_probe_card' (at offset 0x524) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.data:ibmtr_portlist from .text between 'ibmtr_probe_card' (at offset 0x528) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.data:ibmtr_portlist from .text between 'ibmtr_probe_card' (at offset 0x534) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.data: from .text between 'ibmtr_probe_card' (at offset 0x540) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.data: from .text between 'ibmtr_probe_card' (at offset 0x544) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.data: from .text between 'ibmtr_probe_card' (at offset 0x548) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.data: from .text between 'ibmtr_probe_card' (at offset 0x54c) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.text:ibmtr_probe1 from .text between 'ibmtr_probe_card' (at offset 0x558) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.text:ibmtr_probe1 from .text between 'ibmtr_probe_card' (at offset 0x55c) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.text:ibmtr_probe1 from .text between 'ibmtr_probe_card' (at offset 0x560) and 'ibmtr_reset_timer'
WARNING: drivers/net/tokenring/ibmtr.o - Section mismatch: reference to .init.text:ibmtr_probe1 from .text between 'ibmtr_probe_card' (at offset 0x564) and 'ibmtr_reset_timer'

Fix by making ibmtr_probe an __init function.

While at it, move move ibmtr_probe_card below ibmtr_probe so the protoype
for ibmtr_probe can be deleted.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tokenring/ibmtr.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff -puN drivers/net/tokenring/ibmtr.c~ibmtr-drain-rich-supply-of-modpost-warnings drivers/net/tokenring/ibmtr.c
--- a/drivers/net/tokenring/ibmtr.c~ibmtr-drain-rich-supply-of-modpost-warnings
+++ a/drivers/net/tokenring/ibmtr.c
@@ -186,7 +186,6 @@ static char __devinit *adapter_def(char 
 #define TRC_INITV 0x02		/*  verbose init trace points     */
 static unsigned char ibmtr_debug_trace = 0;
 
-static int 	ibmtr_probe(struct net_device *dev);
 static int	ibmtr_probe1(struct net_device *dev, int ioaddr);
 static unsigned char get_sram_size(struct tok_info *adapt_info);
 static int 	trdev_init(struct net_device *dev);
@@ -335,17 +334,6 @@ static void ibmtr_cleanup_card(struct ne
 #endif		
 }
 
-int ibmtr_probe_card(struct net_device *dev)
-{
-	int err = ibmtr_probe(dev);
-	if (!err) {
-		err = register_netdev(dev);
-		if (err)
-			ibmtr_cleanup_card(dev);
-	}
-	return err;
-}
-
 /****************************************************************************
  *	ibmtr_probe():  Routine specified in the network device structure
  *	to probe for an IBM Token Ring Adapter.  Routine outline:
@@ -358,7 +346,7 @@ int ibmtr_probe_card(struct net_device *
  *	which references it.
  ****************************************************************************/
 
-static int ibmtr_probe(struct net_device *dev)
+static int __init ibmtr_probe(struct net_device *dev)
 {
 	int i;
 	int base_addr = dev->base_addr;
@@ -378,6 +366,17 @@ static int ibmtr_probe(struct net_device
 	return -ENODEV;
 }
 
+int __init ibmtr_probe_card(struct net_device *dev)
+{
+	int err = ibmtr_probe(dev);
+	if (!err) {
+		err = register_netdev(dev);
+		if (err)
+			ibmtr_cleanup_card(dev);
+	}
+	return err;
+}
+
 /*****************************************************************************/
 
 static int __devinit ibmtr_probe1(struct net_device *dev, int PIOaddr)
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
git-alsa.patch
git-netdev-all.patch
div64_64-common-code.patch
serial-driver-pmc-msp71xx.patch
rm9000-serial-driver.patch
rm9000-serial-driver-tidy.patch
x86_64-fix-ia32_binfmtc-build-error.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
simplify-the-stacktrace-code.patch
serial-allocate-minor-device-numbers-for.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
local_t-mips-extension.patch
tgafb-turbochannel-support.patch
