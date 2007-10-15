From: akpm@linux-foundation.org
Subject: + forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch added to -mm tree
Date: Mon, 15 Oct 2007 14:23:54 -0700
Message-ID: <200710152123.l9FLNsNQ025740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51245 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757895AbXJOVYx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 17:24:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.pyne@kdemail.net, aabdulla@nvidia.com, jeff@garzik.org, stable@kernel.org


The patch titled
     forcedeth: fix MAC address detection on network card (regression in 2.6.23)
has been added to the -mm tree.  Its filename is
     forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: forcedeth: fix MAC address detection on network card (regression in 2.6.23)
From: Michael Pyne <michael.pyne@kdemail.net>

Partially revert a change to mac address detection introduced to the forcedeth
driver.  The change was intended to correct mac address detection for newer
nVidia chipsets where the mac address was stored in reverse order.  One of
those chipsets appears to still have the mac address in reverse order (or at
least, it does on my system).

The change that broke mac address detection for my card was commit
ef756b3e56c68a4d76d9d7b9a73fa8f4f739180f "forcedeth: mac address correct"

My network card is an nVidia built-in Ethernet card, output from lspci as
follows (with text and numeric ids):
$ lspci | grep Ethernet
00:07.0 Bridge: nVidia Corporation MCP61 Ethernet (rev a2)
$ lspci -n | grep 07.0
00:07.0 0680: 10de:03ef (rev a2)

The vendor id is, of course, nVidia.  The device id corresponds to the
NVIDIA_NVENET_19 entry.

The included patch fixes the MAC address detection on my system.
Interestingly, the MAC address appears to be in the range reserved for my
motherboard manufacturer (Gigabyte) and not nVidia.

Signed-off-by: Michael J. Pyne <michael.pyne@kdemail.net>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/forcedeth.c~forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623 drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623
+++ a/drivers/net/forcedeth.c
@@ -5521,7 +5521,7 @@ static struct pci_device_id pci_tbl[] = 
 	},
 	{	/* MCP61 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_19),
-		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR,
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
 	},
 	{	/* MCP65 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_20),
_

Patches currently in -mm which might be from michael.pyne@kdemail.net are

forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
