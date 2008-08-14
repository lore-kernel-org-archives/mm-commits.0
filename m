From: akpm@linux-foundation.org
Subject: - ixgbe-add-cx4-device-id.patch removed from -mm tree
Date: Thu, 14 Aug 2008 16:54:24 -0700
Message-ID: <200808142354.m7ENsOdH003935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973AbYHNXy0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 19:54:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesse.brandeburg@intel.com, jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     ixgbe: add cx4 device ID
has been removed from the -mm tree.  Its filename was
     ixgbe-add-cx4-device-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ixgbe: add cx4 device ID
From: Jesse Brandeburg <jesse.brandeburg@intel.com>

This is a simple device ID add for adapters that support CX4 (copper
infiniband style cable) connectors for 10GbE.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ixgbe/ixgbe_82598.c |    1 +
 drivers/net/ixgbe/ixgbe_main.c  |    4 +++-
 drivers/net/ixgbe/ixgbe_type.h  |    1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/net/ixgbe/ixgbe_82598.c~ixgbe-add-cx4-device-id drivers/net/ixgbe/ixgbe_82598.c
--- a/drivers/net/ixgbe/ixgbe_82598.c~ixgbe-add-cx4-device-id
+++ a/drivers/net/ixgbe/ixgbe_82598.c
@@ -190,6 +190,7 @@ static enum ixgbe_media_type ixgbe_get_m
 	case IXGBE_DEV_ID_82598AF_DUAL_PORT:
 	case IXGBE_DEV_ID_82598AF_SINGLE_PORT:
 	case IXGBE_DEV_ID_82598EB_CX4:
+	case IXGBE_DEV_ID_82598_CX4_DUAL_PORT:
 		media_type = ixgbe_media_type_fiber;
 		break;
 	case IXGBE_DEV_ID_82598AT_DUAL_PORT:
diff -puN drivers/net/ixgbe/ixgbe_main.c~ixgbe-add-cx4-device-id drivers/net/ixgbe/ixgbe_main.c
--- a/drivers/net/ixgbe/ixgbe_main.c~ixgbe-add-cx4-device-id
+++ a/drivers/net/ixgbe/ixgbe_main.c
@@ -48,7 +48,7 @@ char ixgbe_driver_name[] = "ixgbe";
 static const char ixgbe_driver_string[] =
 	"Intel(R) 10 Gigabit PCI Express Network Driver";
 
-#define DRV_VERSION "1.3.18-k2"
+#define DRV_VERSION "1.3.18-k4"
 const char ixgbe_driver_version[] = DRV_VERSION;
 static const char ixgbe_copyright[] =
 	 "Copyright (c) 1999-2007 Intel Corporation.";
@@ -72,6 +72,8 @@ static struct pci_device_id ixgbe_pci_tb
 	 board_82598 },
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82598EB_CX4),
 	 board_82598 },
+	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82598_CX4_DUAL_PORT),
+	 board_82598 },
 
 	/* required last entry */
 	{0, }
diff -puN drivers/net/ixgbe/ixgbe_type.h~ixgbe-add-cx4-device-id drivers/net/ixgbe/ixgbe_type.h
--- a/drivers/net/ixgbe/ixgbe_type.h~ixgbe-add-cx4-device-id
+++ a/drivers/net/ixgbe/ixgbe_type.h
@@ -39,6 +39,7 @@
 #define IXGBE_DEV_ID_82598AF_SINGLE_PORT 0x10C7
 #define IXGBE_DEV_ID_82598AT_DUAL_PORT   0x10C8
 #define IXGBE_DEV_ID_82598EB_CX4         0x10DD
+#define IXGBE_DEV_ID_82598_CX4_DUAL_PORT 0x10EC
 
 /* General Registers */
 #define IXGBE_CTRL      0x00000
_

Patches currently in -mm which might be from jesse.brandeburg@intel.com are

git-net.patch

