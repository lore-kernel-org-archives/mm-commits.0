From: akpm@linux-foundation.org
Subject: + forcedeth-addition-of-new-device-id.patch added to -mm tree
Date: Wed, 03 Jun 2009 13:24:09 -0700
Message-ID: <200906032024.n53KOBqd018756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587AbZFCUYo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 16:24:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aabdulla@nvidia.com, davem@davemloft.net


The patch titled
     forcedeth: add new device id
has been added to the -mm tree.  Its filename is
     forcedeth-addition-of-new-device-id.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: forcedeth: add new device id
From: Ayaz Abdulla <aabdulla@nvidia.com>

Add support for new ethernet device in the MCP89 chipset.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/net/forcedeth.c~forcedeth-addition-of-new-device-id drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-addition-of-new-device-id
+++ a/drivers/net/forcedeth.c
@@ -6158,7 +6158,8 @@ static int nv_resume(struct pci_dev *pde
 	for (i = 0;i <= np->register_size/sizeof(u32); i++)
 		writel(np->saved_config_space[i], base+i*sizeof(u32));
 
-	pci_write_config_dword(pdev, NV_MSI_PRIV_OFFSET, NV_MSI_PRIV_VALUE);
+	if (np->device_id != PCI_DEVICE_ID_NVIDIA_NVENET_40)
+		pci_write_config_dword(pdev, NV_MSI_PRIV_OFFSET, NV_MSI_PRIV_VALUE);
 
 	/* restore phy state, including autoneg */
 	phy_init(dev);
@@ -6362,6 +6363,10 @@ static struct pci_device_id pci_tbl[] = 
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_39),
 		.driver_data = DEV_NEED_LINKTIMER|DEV_HAS_LARGEDESC|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX_V3|DEV_HAS_STATISTICS_V3|DEV_HAS_TEST_EXTENDED|DEV_HAS_CORRECT_MACADDR|DEV_HAS_COLLISION_FIX|DEV_NEED_TX_LIMIT|DEV_HAS_GEAR_MODE,
 	},
+	{	/* MCP89 Ethernet Controller */
+		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_40),
+		.driver_data = DEV_NEED_LINKTIMER|DEV_HAS_LARGEDESC|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX_V3|DEV_HAS_STATISTICS_V3|DEV_HAS_TEST_EXTENDED|DEV_HAS_CORRECT_MACADDR|DEV_HAS_COLLISION_FIX|DEV_NEED_TX_LIMIT|DEV_HAS_GEAR_MODE,
+	},
 	{0,},
 };
 
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

linux-next.patch
forcedeth-addition-of-new-device-id.patch
new-pci-device-id.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch

