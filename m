From: akpm@linux-foundation.org
Subject: + forcedeth-fix-checksum-flag.patch added to -mm tree
Date: Mon, 18 Aug 2008 14:54:49 -0700
Message-ID: <200808182154.m7ILsn2W014843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757930AbYHRVzq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 17:55:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aabdulla@nvidia.com, jgarzik@pobox.com, manfred@colorfullife.com


The patch titled
     forcedeth: fix checksum flag
has been added to the -mm tree.  Its filename is
     forcedeth-fix-checksum-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: forcedeth: fix checksum flag
From: Ayaz Abdulla <aabdulla@nvidia.com>

Fix the checksum feature advertised in device flags.  The hardware support
TCP/UDP over IPv4 and TCP/UDP over IPv6 (without IPv6 extension headers). 
However, the kernel feature flags do not distinguish IPv6 with/without
extension headers.

Therefore, the driver needs to use NETIF_F_IP_CSUM instead of
NETIF_F_HW_CSUM since the latter includes all IPv6 packets.

A future patch can be created to check for extension headers and perform
software checksum calculation.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Manfred Spraul <manfred@colorfullife.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/forcedeth.c~forcedeth-fix-checksum-flag drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-fix-checksum-flag
+++ a/drivers/net/forcedeth.c
@@ -5530,7 +5530,7 @@ static int __devinit nv_probe(struct pci
 	if (id->driver_data & DEV_HAS_CHECKSUM) {
 		np->rx_csum = 1;
 		np->txrxctl_bits |= NVREG_TXRXCTL_RXCHECK;
-		dev->features |= NETIF_F_HW_CSUM | NETIF_F_SG;
+		dev->features |= NETIF_F_IP_CSUM | NETIF_F_SG;
 		dev->features |= NETIF_F_TSO;
 	}
 
@@ -5843,7 +5843,7 @@ static int __devinit nv_probe(struct pci
 
 	dev_printk(KERN_INFO, &pci_dev->dev, "%s%s%s%s%s%s%s%s%s%sdesc-v%u\n",
 		   dev->features & NETIF_F_HIGHDMA ? "highdma " : "",
-		   dev->features & (NETIF_F_HW_CSUM | NETIF_F_SG) ?
+		   dev->features & (NETIF_F_IP_CSUM | NETIF_F_SG) ?
 		   	"csum " : "",
 		   dev->features & (NETIF_F_HW_VLAN_RX | NETIF_F_HW_VLAN_TX) ?
 		   	"vlan " : "",
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
forcedeth-add-pci_enable_device-to-nv_resume.patch
forcedeth-fix-checksum-flag.patch

