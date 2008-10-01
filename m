From: akpm@linux-foundation.org
Subject: - forcedeth-fix-take-phy-out-of-reset-during-power-up.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:52:50 -0700
Message-ID: <200810012152.m91LqoNw006084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754053AbYJAVxd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:53:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aabdulla@nvidia.com, jgarzik@pobox.com, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     forcedeth fix: take phy out of reset during power up
has been removed from the -mm tree.  Its filename was
     forcedeth-fix-take-phy-out-of-reset-during-power-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: forcedeth fix: take phy out of reset during power up
From: Ayaz Abdulla <aabdulla@nvidia.com>

Add the phy reset bit into the power up mask which is used during power
up.  Certain BIOSes will place the phy in reset and therefore the driver
must take the phy out of reset when it loads.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/forcedeth.c~forcedeth-fix-take-phy-out-of-reset-during-power-up drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-fix-take-phy-out-of-reset-during-power-up
+++ a/drivers/net/forcedeth.c
@@ -337,7 +337,7 @@ enum {
 	NvRegMSIXIrqStatus = 0x3f0,
 
 	NvRegPowerState2 = 0x600,
-#define NVREG_POWERSTATE2_POWERUP_MASK		0x0F11
+#define NVREG_POWERSTATE2_POWERUP_MASK		0x0F15
 #define NVREG_POWERSTATE2_POWERUP_REV_A3	0x0001
 #define NVREG_POWERSTATE2_PHY_RESET		0x0004
 };
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

git-net.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
forcedeth-add-pci_enable_device-to-nv_resume.patch
forcdeth-increase-max_interrupt_work.patch

