From: akpm@linux-foundation.org
Subject: - e1000-fix-firmware-handover-bits.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:58:51 -0800
Message-ID: <200703152158.l2FLwpGI027764@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42509 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbXCOV6x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:58:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bruce.w.allan@intel.com, auke-jan.h.kok@intel.com, mm-commits@vger.kernel.org


The patch titled
     e1000: FIX: firmware handover bits
has been removed from the -mm tree.  Its filename was
     e1000-fix-firmware-handover-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: e1000: FIX: firmware handover bits
From: Bruce Allan <bruce.w.allan@intel.com>

Upon code inspection it was spotted that the firmware handover bit get/set
mismatched, which may have resulted in management issues on PCI-E adapters. 
Setting them correctly may fix some management issues such as arp routing etc.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000_main.c |   33 +++++++++++--------------------
 1 files changed, 12 insertions(+), 21 deletions(-)

diff -puN drivers/net/e1000/e1000_main.c~e1000-fix-firmware-handover-bits drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~e1000-fix-firmware-handover-bits
+++ a/drivers/net/e1000/e1000_main.c
@@ -409,25 +409,21 @@ e1000_release_hw_control(struct e1000_ad
 {
 	uint32_t ctrl_ext;
 	uint32_t swsm;
-	uint32_t extcnf;
 
 	/* Let firmware taken over control of h/w */
 	switch (adapter->hw.mac_type) {
-	case e1000_82571:
-	case e1000_82572:
-	case e1000_80003es2lan:
-		ctrl_ext = E1000_READ_REG(&adapter->hw, CTRL_EXT);
-		E1000_WRITE_REG(&adapter->hw, CTRL_EXT,
-				ctrl_ext & ~E1000_CTRL_EXT_DRV_LOAD);
-		break;
 	case e1000_82573:
 		swsm = E1000_READ_REG(&adapter->hw, SWSM);
 		E1000_WRITE_REG(&adapter->hw, SWSM,
 				swsm & ~E1000_SWSM_DRV_LOAD);
+		break;
+	case e1000_82571:
+	case e1000_82572:
+	case e1000_80003es2lan:
 	case e1000_ich8lan:
-		extcnf = E1000_READ_REG(&adapter->hw, CTRL_EXT);
+		ctrl_ext = E1000_READ_REG(&adapter->hw, CTRL_EXT);
 		E1000_WRITE_REG(&adapter->hw, CTRL_EXT,
-				extcnf & ~E1000_CTRL_EXT_DRV_LOAD);
+				ctrl_ext & ~E1000_CTRL_EXT_DRV_LOAD);
 		break;
 	default:
 		break;
@@ -450,26 +446,21 @@ e1000_get_hw_control(struct e1000_adapte
 {
 	uint32_t ctrl_ext;
 	uint32_t swsm;
-	uint32_t extcnf;
 
 	/* Let firmware know the driver has taken over */
 	switch (adapter->hw.mac_type) {
-	case e1000_82571:
-	case e1000_82572:
-	case e1000_80003es2lan:
-		ctrl_ext = E1000_READ_REG(&adapter->hw, CTRL_EXT);
-		E1000_WRITE_REG(&adapter->hw, CTRL_EXT,
-				ctrl_ext | E1000_CTRL_EXT_DRV_LOAD);
-		break;
 	case e1000_82573:
 		swsm = E1000_READ_REG(&adapter->hw, SWSM);
 		E1000_WRITE_REG(&adapter->hw, SWSM,
 				swsm | E1000_SWSM_DRV_LOAD);
 		break;
+	case e1000_82571:
+	case e1000_82572:
+	case e1000_80003es2lan:
 	case e1000_ich8lan:
-		extcnf = E1000_READ_REG(&adapter->hw, EXTCNF_CTRL);
-		E1000_WRITE_REG(&adapter->hw, EXTCNF_CTRL,
-				extcnf | E1000_EXTCNF_CTRL_SWFLAG);
+		ctrl_ext = E1000_READ_REG(&adapter->hw, CTRL_EXT);
+		E1000_WRITE_REG(&adapter->hw, CTRL_EXT,
+				ctrl_ext | E1000_CTRL_EXT_DRV_LOAD);
 		break;
 	default:
 		break;
_

Patches currently in -mm which might be from bruce.w.allan@intel.com are

git-netdev-all.patch
