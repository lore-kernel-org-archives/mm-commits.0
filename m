From: akpm@linux-foundation.org
Subject: + wol-bugfix-for-3c59xc.patch added to -mm tree
Date: Thu, 09 Aug 2007 14:24:51 -0700
Message-ID: <200708092124.l79LOplD020300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60559 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757113AbXHIVZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 17:25:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: klassert@mathematik.tu-chemnitz.de, hcoin@n4comm.com


The patch titled
     WOL bugfix for 3c59x.c
has been added to the -mm tree.  Its filename is
     wol-bugfix-for-3c59xc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: WOL bugfix for 3c59x.c
From: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>

Some NICs (3c905B) can not generate PME in power state PCI_D0, while others
like 3c905C can, so I guess you have one of those NICs that can not.

Cc: Harry Coin <hcoin@n4comm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c59x.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/net/3c59x.c~wol-bugfix-for-3c59xc drivers/net/3c59x.c
--- a/drivers/net/3c59x.c~wol-bugfix-for-3c59xc
+++ a/drivers/net/3c59x.c
@@ -3107,7 +3107,13 @@ static void acpi_set_WOL(struct net_devi
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

3c59x-check-return-of-pci_enable_device.patch
3c59x-fix-duplex-configuration.patch
wol-bugfix-for-3c59xc.patch
