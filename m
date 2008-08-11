From: akpm@linux-foundation.org
Subject: + igb-remove-82576-quad-adapter.patch added to -mm tree
Date: Mon, 11 Aug 2008 16:38:12 -0700
Message-ID: <200808112338.m7BNcCNa027997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753588AbYHKXiO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 19:38:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexander.h.duyck@intel.com, jeffrey.t.kirsher@intel.com


The patch titled
     igb: remove 82576 quad adapter
has been added to the -mm tree.  Its filename is
     igb-remove-82576-quad-adapter.patch

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
Subject: igb: remove 82576 quad adapter
From: Alexander Duyck <alexander.h.duyck@intel.com>

Disable support for device 8086:10E8.  Currently the result of loading the
driver with the device present causes system instability.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/igb/e1000_82575.c |    1 -
 drivers/net/igb/e1000_hw.h    |    1 -
 drivers/net/igb/igb_ethtool.c |    9 ---------
 drivers/net/igb/igb_main.c    |   11 -----------
 4 files changed, 22 deletions(-)

diff -puN drivers/net/igb/e1000_82575.c~igb-remove-82576-quad-adapter drivers/net/igb/e1000_82575.c
--- a/drivers/net/igb/e1000_82575.c~igb-remove-82576-quad-adapter
+++ a/drivers/net/igb/e1000_82575.c
@@ -87,7 +87,6 @@ static s32 igb_get_invariants_82575(stru
 	case E1000_DEV_ID_82576:
 	case E1000_DEV_ID_82576_FIBER:
 	case E1000_DEV_ID_82576_SERDES:
-	case E1000_DEV_ID_82576_QUAD_COPPER:
 		mac->type = e1000_82576;
 		break;
 	default:
diff -puN drivers/net/igb/e1000_hw.h~igb-remove-82576-quad-adapter drivers/net/igb/e1000_hw.h
--- a/drivers/net/igb/e1000_hw.h~igb-remove-82576-quad-adapter
+++ a/drivers/net/igb/e1000_hw.h
@@ -41,7 +41,6 @@ struct e1000_hw;
 #define E1000_DEV_ID_82576                    0x10C9
 #define E1000_DEV_ID_82576_FIBER              0x10E6
 #define E1000_DEV_ID_82576_SERDES             0x10E7
-#define E1000_DEV_ID_82576_QUAD_COPPER        0x10E8
 #define E1000_DEV_ID_82575EB_COPPER           0x10A7
 #define E1000_DEV_ID_82575EB_FIBER_SERDES     0x10A9
 #define E1000_DEV_ID_82575GB_QUAD_COPPER      0x10D6
diff -puN drivers/net/igb/igb_ethtool.c~igb-remove-82576-quad-adapter drivers/net/igb/igb_ethtool.c
--- a/drivers/net/igb/igb_ethtool.c~igb-remove-82576-quad-adapter
+++ a/drivers/net/igb/igb_ethtool.c
@@ -1746,15 +1746,6 @@ static int igb_wol_exclusion(struct igb_
 		/* return success for non excluded adapter ports */
 		retval = 0;
 		break;
-	case E1000_DEV_ID_82576_QUAD_COPPER:
-		/* quad port adapters only support WoL on port A */
-		if (!(adapter->flags & IGB_FLAG_QUAD_PORT_A)) {
-			wol->supported = 0;
-			break;
-		}
-		/* return success for non excluded adapter ports */
-		retval = 0;
-		break;
 	default:
 		/* dual port cards only support WoL on port A from now on
 		 * unless it was enabled in the eeprom for port B
diff -puN drivers/net/igb/igb_main.c~igb-remove-82576-quad-adapter drivers/net/igb/igb_main.c
--- a/drivers/net/igb/igb_main.c~igb-remove-82576-quad-adapter
+++ a/drivers/net/igb/igb_main.c
@@ -61,7 +61,6 @@ static struct pci_device_id igb_pci_tbl[
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82576), board_82575 },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82576_FIBER), board_82575 },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82576_SERDES), board_82575 },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82576_QUAD_COPPER), board_82575 },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82575EB_COPPER), board_82575 },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82575EB_FIBER_SERDES), board_82575 },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82575GB_QUAD_COPPER), board_82575 },
@@ -1217,16 +1216,6 @@ static int __devinit igb_probe(struct pc
 		if (rd32(E1000_STATUS) & E1000_STATUS_FUNC_1)
 			adapter->eeprom_wol = 0;
 		break;
-	case E1000_DEV_ID_82576_QUAD_COPPER:
-		/* if quad port adapter, disable WoL on all but port A */
-		if (global_quad_port_a != 0)
-			adapter->eeprom_wol = 0;
-		else
-			adapter->flags |= IGB_FLAG_QUAD_PORT_A;
-		/* Reset for multiple quad port adapters */
-		if (++global_quad_port_a == 4)
-			global_quad_port_a = 0;
-		break;
 	}
 
 	/* initialize the wol settings based on the eeprom settings */
_

Patches currently in -mm which might be from alexander.h.duyck@intel.com are

origin.patch
igb-remove-82576-quad-adapter.patch

