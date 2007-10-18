From: akpm@linux-foundation.org
Subject: - wol-bugfix-for-3c59xc.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:05:34 -0700
Message-ID: <200710180705.l9I75YBN031658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35863 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760329AbXJRHPV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: klassert@mathematik.tu-chemnitz.de, hcoin@n4comm.com, mm-commits@vger.kernel.org


The patch titled
     WOL bugfix for 3c59x.c
has been removed from the -mm tree.  Its filename was
     wol-bugfix-for-3c59xc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: WOL bugfix for 3c59x.c
From: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>

Some NICs (3c905B) can not generate PME in power state PCI_D0, while others
like 3c905C can.  Call pci_enable_wake() with PCI_D3hot should give proper
WOL for 3c905B.

Signed-off-by: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
Tested-by: Harry Coin <hcoin@n4comm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c59x.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/net/3c59x.c~wol-bugfix-for-3c59xc drivers/net/3c59x.c
--- a/drivers/net/3c59x.c~wol-bugfix-for-3c59xc
+++ a/drivers/net/3c59x.c
@@ -3118,7 +3118,13 @@ static void acpi_set_WOL(struct net_devi
 		iowrite16(SetRxFilter|RxStation|RxMulticast|RxBroadcast, ioaddr + EL3_CMD);
 		iowrite16(RxEnable, ioaddr + EL3_CMD);
 
-		pci_enable_wake(VORTEX_PCI(vp), 0, 1);
+		if (pci_enable_wake(VORTEX_PCI(vp), PCI_D3hot, 1)) {
+			printk(KERN_INFO "%s: WOL not supported.\n",
+					pci_name(VORTEX_PCI(vp)));
+
+			vp->enable_wol = 0;
+			return;
+		}
 
 		/* Change the power state to D3; RxEnable doesn't take effect. */
 		pci_set_power_state(VORTEX_PCI(vp), PCI_D3hot);
_

Patches currently in -mm which might be from klassert@mathematik.tu-chemnitz.de are

origin.patch
