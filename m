From: akpm@linux-foundation.org
Subject: - forcedeth-boot-delay-fix.patch removed from -mm tree
Date: Tue, 20 Nov 2007 01:01:58 -0800
Message-ID: <200711200909.lAK996Iv028989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53330 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753381AbXKTJJM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 04:09:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aabdulla@nvidia.com, astinus@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     forcedeth boot delay fix
has been removed from the -mm tree.  Its filename was
     forcedeth-boot-delay-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: forcedeth boot delay fix
From: Ayaz Abdulla <aabdulla@nvidia.com>

Fix a long boot delay in the forcedeth driver.  During initialization, the
timeout for the handshake between mgmt unit and driver can be very long. 
The patch reduces the timeout by eliminating a extra loop around the
timeout logic.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=9308

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: Alex Howells <astinus@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN drivers/net/forcedeth.c~forcedeth-boot-delay-fix drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-boot-delay-fix
+++ a/drivers/net/forcedeth.c
@@ -5294,20 +5294,17 @@ static int __devinit nv_probe(struct pci
 		if (readl(base + NvRegTransmitterControl) & NVREG_XMITCTL_SYNC_PHY_INIT) {
 			np->mac_in_use = readl(base + NvRegTransmitterControl) & NVREG_XMITCTL_MGMT_ST;
 			dprintk(KERN_INFO "%s: mgmt unit is running. mac in use %x.\n", pci_name(pci_dev), np->mac_in_use);
-			for (i = 0; i < 5000; i++) {
-				msleep(1);
-				if (nv_mgmt_acquire_sema(dev)) {
-					/* management unit setup the phy already? */
-					if ((readl(base + NvRegTransmitterControl) & NVREG_XMITCTL_SYNC_MASK) ==
-					    NVREG_XMITCTL_SYNC_PHY_INIT) {
-						/* phy is inited by mgmt unit */
-						phyinitialized = 1;
-						dprintk(KERN_INFO "%s: Phy already initialized by mgmt unit.\n", pci_name(pci_dev));
-					} else {
-						/* we need to init the phy */
-					}
-					break;
+			if (nv_mgmt_acquire_sema(dev)) {
+				/* management unit setup the phy already? */
+				if ((readl(base + NvRegTransmitterControl) & NVREG_XMITCTL_SYNC_MASK) ==
+				    NVREG_XMITCTL_SYNC_PHY_INIT) {
+					/* phy is inited by mgmt unit */
+					phyinitialized = 1;
+					dprintk(KERN_INFO "%s: Phy already initialized by mgmt unit.\n", pci_name(pci_dev));
+				} else {
+					/* we need to init the phy */
 				}
+				break;
 			}
 		}
 	}
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
forcedeth-new-mcp79-device-ids.patch
forcedeth-boot-delay-fix.patch
