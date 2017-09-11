From: akpm@linux-foundation.org
Subject: [merged]
 mn10300-defconfig-cleanup-from-old-kconfig-options.patch removed from -mm
 tree
Date: Mon, 11 Sep 2017 12:44:01 -0700
Message-ID: <20170911194401.kSsqOsg9G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50854 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751045AbdIKToC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:44:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mn10300: defconfig: cleanup from old Kconfig options
has been removed from the -mm tree.  Its filename was
     mn10300-defconfig-cleanup-from-old-kconfig-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: mn10300: defconfig: cleanup from old Kconfig options

Remove old, dead Kconfig options (in order appearing in this commit):
 - EXPERIMENTAL is gone since v3.9;
 - INET_LRO: commit 7bbf3cae65b6 ("ipv4: Remove inet_lro library");
 - MTD_PARTITIONS: commit 6a8a98b22b10 ("mtd: kill
   CONFIG_MTD_PARTITIONS");
 - MTD_CHAR: commit 660685d9d1b4 ("mtd: merge mtdchar module with
   mtdcore");
 - NETDEV_1000 and NETDEV_10000: commit f860b0522f65 ("drivers/net:
   Kconfig and Makefile cleanup"); NET_ETHERNET should be replaced with
   just ETHERNET but that is separate change;
 - HID_SUPPORT: commit 1f41a6a99476 ("HID: Fix the generic Kconfig
   options");
 - RCU_CPU_STALL_DETECTOR: commit a00e0d714fbd ("rcu: Remove conditional
   compilation for RCU CPU stall warnings");

Link: http://lkml.kernel.org/r/1500526786-3789-1-git-send-email-krzk@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/configs/asb2303_defconfig |    6 ------
 arch/mn10300/configs/asb2364_defconfig |    8 --------
 2 files changed, 14 deletions(-)

diff -puN arch/mn10300/configs/asb2303_defconfig~mn10300-defconfig-cleanup-from-old-kconfig-options arch/mn10300/configs/asb2303_defconfig
--- a/arch/mn10300/configs/asb2303_defconfig~mn10300-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/mn10300/configs/asb2303_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_TINY_RCU=y
@@ -28,16 +27,13 @@ CONFIG_IP_PNP_BOOTP=y
 # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
 # CONFIG_INET_XFRM_MODE_TUNNEL is not set
 # CONFIG_INET_XFRM_MODE_BEET is not set
-# CONFIG_INET_LRO is not set
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 # CONFIG_WIRELESS is not set
 CONFIG_MTD=y
 CONFIG_MTD_DEBUG=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_JEDECPROBE=y
 CONFIG_MTD_CFI_ADV_OPTIONS=y
@@ -48,8 +44,6 @@ CONFIG_MTD_PHYSMAP=y
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMC91X=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_WLAN is not set
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
diff -puN arch/mn10300/configs/asb2364_defconfig~mn10300-defconfig-cleanup-from-old-kconfig-options arch/mn10300/configs/asb2364_defconfig
--- a/arch/mn10300/configs/asb2364_defconfig~mn10300-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/mn10300/configs/asb2364_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
@@ -40,7 +39,6 @@ CONFIG_IP_PNP_BOOTP=y
 # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
 # CONFIG_INET_XFRM_MODE_TUNNEL is not set
 # CONFIG_INET_XFRM_MODE_BEET is not set
-# CONFIG_INET_LRO is not set
 # CONFIG_INET_DIAG is not set
 CONFIG_IPV6=y
 # CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
@@ -50,10 +48,8 @@ CONFIG_IPV6=y
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
 CONFIG_MTD_DEBUG=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_JEDECPROBE=y
 CONFIG_MTD_CFI_ADV_OPTIONS=y
@@ -64,8 +60,6 @@ CONFIG_MTD_PHYSMAP=y
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMSC911X=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_KEYBOARD is not set
 # CONFIG_INPUT_MOUSE is not set
@@ -77,7 +71,6 @@ CONFIG_SERIAL_8250_EXTENDED=y
 CONFIG_SERIAL_8250_SHARE_IRQ=y
 # CONFIG_HW_RANDOM is not set
 # CONFIG_HWMON is not set
-# CONFIG_HID_SUPPORT is not set
 # CONFIG_USB_SUPPORT is not set
 CONFIG_PROC_KCORE=y
 # CONFIG_PROC_PAGE_MONITOR is not set
@@ -93,4 +86,3 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_DEBUG_INFO=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
_

Patches currently in -mm which might be from krzk@kernel.org are


