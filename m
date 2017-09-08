From: akpm@linux-foundation.org
Subject: [patch 119/126] sh: defconfig: cleanup from old Kconfig
 options
Date: Fri, 08 Sep 2017 16:17:31 -0700
Message-ID: <20170908231731.F_VyDs8P2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53792 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932660AbdIHXRd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:17:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, krzk@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: sh: defconfig: cleanup from old Kconfig options

Remove old, dead Kconfig options (in order appearing in this commit):
 - EXPERIMENTAL is gone since v3.9;
 - INET_LRO: commit 7bbf3cae65b6 ("ipv4: Remove inet_lro library");
 - MTD_CONCAT: commit f53fdebcc3e1 ("mtd: drop MTD_CONCAT from Kconfig
   entirely");
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
 - SYSCTL_SYSCALL_CHECK: commit 7c60c48f58a7 ("sysctl: Improve the
   sysctl sanity checks");
 - VIDEO_OUTPUT_CONTROL: commit f167a64e9d67 ("video / output: Drop
   display output class support");
 - MISC_DEVICES: commit 7c5763b8453a ("drivers: misc: Remove
   MISC_DEVICES config option");
 - AUTOFS_FS: commit 561c5cf9236a ("staging: Remove autofs3");
 - IP_NF_QUEUE: commit 3dd6664fac7e ("netfilter: remove unused "config
   IP_NF_QUEUE"");
 - USB_DEVICE_CLASS: commit 007bab91324e ("USB: remove
   CONFIG_USB_DEVICE_CLASS");
 - USB_LIBUSUAL: commit f61870ee6f8c ("usb: remove libusual");
 - DISPLAY_SUPPORT: commit 5a6b5e02d673 ("fbdev: remove display
   subsystem");
 - IP_NF_TARGET_ULOG: commit d4da843e6fad ("netfilter: kill remnants of
   ulog targets");
 - IP6_NF_QUEUE: commit d16cf20e2f2f ("netfilter: remove ip_queue
   support");
 - IP6_NF_TARGET_LOG: commit 6939c33a757b ("netfilter: merge ipt_LOG and
   ip6_LOG into xt_LOG");

Link: http://lkml.kernel.org/r/1500526846-4072-1-git-send-email-krzk@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/configs/ap325rxa_defconfig          |   10 ----------
 arch/sh/configs/apsh4a3a_defconfig          |    9 ---------
 arch/sh/configs/apsh4ad0a_defconfig         |    6 ------
 arch/sh/configs/cayman_defconfig            |    4 ----
 arch/sh/configs/dreamcast_defconfig         |    6 ------
 arch/sh/configs/ecovec24-romimage_defconfig |    7 -------
 arch/sh/configs/ecovec24_defconfig          |    9 ---------
 arch/sh/configs/edosk7705_defconfig         |    2 --
 arch/sh/configs/edosk7760_defconfig         |   11 -----------
 arch/sh/configs/espt_defconfig              |   10 ----------
 arch/sh/configs/hp6xx_defconfig             |    4 ----
 arch/sh/configs/kfr2r09-romimage_defconfig  |    5 -----
 arch/sh/configs/kfr2r09_defconfig           |    7 -------
 arch/sh/configs/landisk_defconfig           |    4 ----
 arch/sh/configs/lboxre2_defconfig           |    3 ---
 arch/sh/configs/magicpanelr2_defconfig      |    9 ---------
 arch/sh/configs/microdev_defconfig          |    3 ---
 arch/sh/configs/migor_defconfig             |    8 --------
 arch/sh/configs/polaris_defconfig           |    9 ---------
 arch/sh/configs/r7780mp_defconfig           |    4 ----
 arch/sh/configs/r7785rp_defconfig           |    3 ---
 arch/sh/configs/rsk7201_defconfig           |    8 --------
 arch/sh/configs/rsk7203_defconfig           |   10 ----------
 arch/sh/configs/rsk7264_defconfig           |    3 ---
 arch/sh/configs/rsk7269_defconfig           |    4 ----
 arch/sh/configs/rts7751r2d1_defconfig       |    5 -----
 arch/sh/configs/rts7751r2dplus_defconfig    |    8 --------
 arch/sh/configs/sdk7780_defconfig           |    9 ---------
 arch/sh/configs/sdk7786_defconfig           |    9 ---------
 arch/sh/configs/se7206_defconfig            |    8 --------
 arch/sh/configs/se7343_defconfig            |    9 ---------
 arch/sh/configs/se7619_defconfig            |    5 -----
 arch/sh/configs/se7705_defconfig            |    5 -----
 arch/sh/configs/se7712_defconfig            |    7 -------
 arch/sh/configs/se7721_defconfig            |    6 ------
 arch/sh/configs/se7722_defconfig            |    3 ---
 arch/sh/configs/se7724_defconfig            |    9 ---------
 arch/sh/configs/se7750_defconfig            |    5 -----
 arch/sh/configs/se7751_defconfig            |    5 -----
 arch/sh/configs/se7780_defconfig            |    7 -------
 arch/sh/configs/secureedge5410_defconfig    |    9 ---------
 arch/sh/configs/sh03_defconfig              |    4 ----
 arch/sh/configs/sh2007_defconfig            |    8 --------
 arch/sh/configs/sh7710voipgw_defconfig      |    5 -----
 arch/sh/configs/sh7724_generic_defconfig    |    3 ---
 arch/sh/configs/sh7757lcr_defconfig         |    4 ----
 arch/sh/configs/sh7763rdp_defconfig         |    9 ---------
 arch/sh/configs/sh7770_generic_defconfig    |    3 ---
 arch/sh/configs/sh7785lcr_32bit_defconfig   |   10 ----------
 arch/sh/configs/sh7785lcr_defconfig         |    9 ---------
 arch/sh/configs/shmin_defconfig             |    4 ----
 arch/sh/configs/shx3_defconfig              |    6 ------
 arch/sh/configs/titan_defconfig             |    8 --------
 arch/sh/configs/ul2_defconfig               |    9 ---------
 arch/sh/configs/urquell_defconfig           |    9 ---------
 55 files changed, 358 deletions(-)

diff -puN arch/sh/configs/ap325rxa_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/ap325rxa_defconfig
--- a/arch/sh/configs/ap325rxa_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/ap325rxa_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
@@ -28,14 +27,10 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
 # CONFIG_INET_XFRM_MODE_TUNNEL is not set
 # CONFIG_INET_XFRM_MODE_BEET is not set
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
@@ -51,8 +46,6 @@ CONFIG_NETDEVICES=y
 CONFIG_SMSC_PHY=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMSC911X=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_KEYBOARD is not set
 # CONFIG_INPUT_MOUSE is not set
@@ -82,7 +75,6 @@ CONFIG_FB=y
 CONFIG_FB_SH_MOBILE_LCDC=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_LOGO=y
-# CONFIG_HID_SUPPORT is not set
 # CONFIG_USB_SUPPORT is not set
 CONFIG_MMC=y
 CONFIG_MMC_SPI=y
@@ -110,8 +102,6 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_932=y
 CONFIG_NLS_ISO8859_1=y
 # CONFIG_ENABLE_MUST_CHECK is not set
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
-CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_CRYPTO=y
 CONFIG_CRYPTO_CBC=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/sh/configs/apsh4a3a_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/apsh4a3a_defconfig
--- a/arch/sh/configs/apsh4a3a_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/apsh4a3a_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
@@ -28,15 +27,11 @@ CONFIG_INET=y
 CONFIG_IP_ADVANCED_ROUTER=y
 CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 # CONFIG_WIRELESS is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
@@ -46,8 +41,6 @@ CONFIG_BLK_DEV_RAM_SIZE=16384
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMSC911X=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_WLAN is not set
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_KEYBOARD is not set
@@ -66,7 +59,6 @@ CONFIG_FONTS=y
 CONFIG_FONT_8x8=y
 CONFIG_FONT_8x16=y
 CONFIG_LOGO=y
-# CONFIG_HID_SUPPORT is not set
 # CONFIG_USB_SUPPORT is not set
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
@@ -96,7 +88,6 @@ CONFIG_DEBUG_KERNEL=y
 # CONFIG_DEBUG_PREEMPT is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_DEBUG_INFO=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_FTRACE is not set
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
diff -puN arch/sh/configs/apsh4ad0a_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/apsh4ad0a_defconfig
--- a/arch/sh/configs/apsh4ad0a_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/apsh4ad0a_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
@@ -53,7 +52,6 @@ CONFIG_PACKET=y
 CONFIG_UNIX=y
 CONFIG_NET_KEY=y
 CONFIG_INET=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 # CONFIG_WIRELESS is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
@@ -70,8 +68,6 @@ CONFIG_NETDEVICES=y
 CONFIG_MDIO_BITBANG=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMSC911X=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_WLAN is not set
 CONFIG_INPUT_EVDEV=y
 # CONFIG_INPUT_KEYBOARD is not set
@@ -83,7 +79,6 @@ CONFIG_SERIAL_SH_SCI_CONSOLE=y
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_HW_RANDOM is not set
 # CONFIG_HWMON is not set
-CONFIG_VIDEO_OUTPUT_CONTROL=y
 CONFIG_FB=y
 CONFIG_FB_SH7785FB=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
@@ -124,6 +119,5 @@ CONFIG_DEBUG_SHIRQ=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_VM=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_DWARF_UNWINDER=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/sh/configs/cayman_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/cayman_defconfig
--- a/arch/sh/configs/cayman_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/cayman_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
@@ -19,7 +18,6 @@ CONFIG_PACKET=y
 CONFIG_UNIX=y
 CONFIG_INET=y
 CONFIG_IP_PNP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
@@ -38,7 +36,6 @@ CONFIG_NET_ETHERNET=y
 CONFIG_HW_RANDOM=y
 CONFIG_I2C=m
 CONFIG_WATCHDOG=y
-CONFIG_VIDEO_OUTPUT_CONTROL=y
 CONFIG_FB=y
 CONFIG_FIRMWARE_EDID=y
 CONFIG_FB_MODE_HELPERS=y
@@ -67,5 +64,4 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_SCHEDSTATS=y
 CONFIG_FRAME_POINTER=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/sh/configs/dreamcast_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/dreamcast_defconfig
--- a/arch/sh/configs/dreamcast_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/dreamcast_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
@@ -32,7 +31,6 @@ CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
 CONFIG_INET=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_STANDALONE is not set
@@ -43,8 +41,6 @@ CONFIG_NET_ETHERNET=y
 CONFIG_NET_PCI=y
 CONFIG_8139TOO=y
 # CONFIG_8139TOO_PIO is not set
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_KEYBOARD_ATKBD is not set
 CONFIG_KEYBOARD_MAPLE=y
 # CONFIG_MOUSE_PS2 is not set
@@ -56,7 +52,6 @@ CONFIG_HW_RANDOM=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
 CONFIG_SH_WDT=y
-CONFIG_VIDEO_OUTPUT_CONTROL=m
 CONFIG_FB=y
 CONFIG_FIRMWARE_EDID=y
 CONFIG_FB_PVR2=y
@@ -74,5 +69,4 @@ CONFIG_LOGO=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_HUGETLBFS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/sh/configs/ecovec24-romimage_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/ecovec24-romimage_defconfig
--- a/arch/sh/configs/ecovec24-romimage_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/ecovec24-romimage_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
@@ -26,19 +25,15 @@ CONFIG_INET=y
 # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
 # CONFIG_INET_XFRM_MODE_TUNNEL is not set
 # CONFIG_INET_XFRM_MODE_BEET is not set
-# CONFIG_INET_LRO is not set
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 # CONFIG_SCSI_LOWLEVEL is not set
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SH_ETH=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_KEYBOARD is not set
 # CONFIG_INPUT_MOUSE is not set
@@ -51,7 +46,6 @@ CONFIG_I2C=y
 CONFIG_I2C_SH_MOBILE=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
-# CONFIG_HID_SUPPORT is not set
 CONFIG_USB=y
 CONFIG_USB_R8A66597_HCD=y
 CONFIG_USB_STORAGE=y
@@ -64,4 +58,3 @@ CONFIG_TMPFS=y
 # CONFIG_NETWORK_FILESYSTEMS is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_DEBUG_FS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
diff -puN arch/sh/configs/ecovec24_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/ecovec24_defconfig
--- a/arch/sh/configs/ecovec24_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/ecovec24_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
@@ -29,16 +28,12 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
 # CONFIG_INET_XFRM_MODE_TUNNEL is not set
 # CONFIG_INET_XFRM_MODE_BEET is not set
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_IRDA=y
 CONFIG_SH_SIR=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
@@ -53,8 +48,6 @@ CONFIG_NETDEVICES=y
 CONFIG_SMSC_PHY=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SH_ETH=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_INPUT_MOUSEDEV is not set
 CONFIG_INPUT_EVDEV=y
 # CONFIG_KEYBOARD_ATKBD is not set
@@ -140,8 +133,6 @@ CONFIG_NLS_CODEPAGE_932=y
 CONFIG_NLS_ISO8859_1=y
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_DEBUG_FS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
-CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_CRYPTO=y
 CONFIG_CRYPTO_CBC=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/sh/configs/edosk7705_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/edosk7705_defconfig
--- a/arch/sh/configs/edosk7705_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/edosk7705_defconfig
@@ -20,7 +20,6 @@ CONFIG_CPU_SUBTYPE_SH7705=y
 CONFIG_SH_EDOSK7705=y
 CONFIG_SH_PCLK_FREQ=31250000
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
-# CONFIG_MISC_DEVICES is not set
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
@@ -35,5 +34,4 @@ CONFIG_SH_PCLK_FREQ=31250000
 # CONFIG_SYSFS is not set
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_CRC32 is not set
diff -puN arch/sh/configs/edosk7760_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/edosk7760_defconfig
--- a/arch/sh/configs/edosk7760_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/edosk7760_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="_edosk7760"
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
@@ -31,7 +30,6 @@ CONFIG_IP_PNP_BOOTP=y
 # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
 # CONFIG_INET_XFRM_MODE_TUNNEL is not set
 # CONFIG_INET_XFRM_MODE_BEET is not set
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
@@ -39,10 +37,7 @@ CONFIG_DEBUG_DRIVER=y
 CONFIG_DEBUG_DEVRES=y
 CONFIG_MTD=y
 CONFIG_MTD_DEBUG=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_JEDECPROBE=y
@@ -62,12 +57,9 @@ CONFIG_MTD_ABSENT=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=26000
-# CONFIG_MISC_DEVICES is not set
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMC91X=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_KEYBOARD is not set
 # CONFIG_INPUT_MOUSE is not set
@@ -92,7 +84,6 @@ CONFIG_SND=y
 # CONFIG_SND_VERBOSE_PROCFS is not set
 CONFIG_SND_VERBOSE_PRINTK=y
 CONFIG_SND_SOC=y
-# CONFIG_HID_SUPPORT is not set
 # CONFIG_USB_SUPPORT is not set
 CONFIG_EXT2_FS=y
 CONFIG_EXT2_FS_XATTR=y
@@ -119,8 +110,6 @@ CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_SCHED_DEBUG is not set
 CONFIG_TIMER_STATS=y
 CONFIG_DEBUG_INFO=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
-CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_CRYPTO=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_DES=y
diff -puN arch/sh/configs/espt_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/espt_defconfig
--- a/arch/sh/configs/espt_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/espt_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
@@ -26,13 +25,10 @@ CONFIG_INET=y
 CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
 CONFIG_IP_PNP_BOOTP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_JEDECPROBE=y
@@ -43,14 +39,11 @@ CONFIG_MTD_CFI_GEOMETRY=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_COMPLEX_MAPPINGS=y
 CONFIG_MTD_PHYSMAP=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SH_ETH=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_KEYBOARD is not set
 # CONFIG_INPUT_MOUSE is not set
@@ -65,7 +58,6 @@ CONFIG_FB_FOREIGN_ENDIAN=y
 CONFIG_FB_SH7760=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_LOGO=y
-# CONFIG_HID_SUPPORT is not set
 CONFIG_USB=y
 CONFIG_USB_MON=y
 CONFIG_USB_OHCI_HCD=y
@@ -73,7 +65,6 @@ CONFIG_USB_STORAGE=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
-CONFIG_AUTOFS_FS=y
 CONFIG_AUTOFS4_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
@@ -123,6 +114,5 @@ CONFIG_NLS_UTF8=y
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_DEBUG_FS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRC_T10DIF=y
diff -puN arch/sh/configs/hp6xx_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/hp6xx_defconfig
--- a/arch/sh/configs/hp6xx_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/hp6xx_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
@@ -37,7 +36,6 @@ CONFIG_SERIAL_SH_SCI_NR_UARTS=3
 CONFIG_SERIAL_SH_SCI_CONSOLE=y
 CONFIG_LEGACY_PTY_COUNT=64
 # CONFIG_HWMON is not set
-CONFIG_VIDEO_OUTPUT_CONTROL=y
 CONFIG_FB=y
 CONFIG_FIRMWARE_EDID=y
 CONFIG_FB_HIT=y
@@ -46,7 +44,6 @@ CONFIG_BACKLIGHT_LCD_SUPPORT=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_FONTS=y
 CONFIG_FONT_PEARL_8x8=y
-# CONFIG_HID_SUPPORT is not set
 # CONFIG_USB_SUPPORT is not set
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_SH=y
@@ -55,7 +52,6 @@ CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_NLS_CODEPAGE_850=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_CRYPTO=y
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_ECB=y
diff -puN arch/sh/configs/kfr2r09-romimage_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/kfr2r09-romimage_defconfig
--- a/arch/sh/configs/kfr2r09-romimage_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/kfr2r09-romimage_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
@@ -26,12 +25,10 @@ CONFIG_INET=y
 # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
 # CONFIG_INET_XFRM_MODE_TUNNEL is not set
 # CONFIG_INET_XFRM_MODE_BEET is not set
-# CONFIG_INET_LRO is not set
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 # CONFIG_WIRELESS is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
-# CONFIG_MISC_DEVICES is not set
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_KEYBOARD is not set
 # CONFIG_INPUT_MOUSE is not set
@@ -44,7 +41,6 @@ CONFIG_I2C=y
 CONFIG_I2C_SH_MOBILE=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
-# CONFIG_HID_SUPPORT is not set
 CONFIG_USB_GADGET=y
 CONFIG_USB_CDC_COMPOSITE=y
 # CONFIG_DNOTIFY is not set
@@ -55,5 +51,4 @@ CONFIG_TMPFS=y
 # CONFIG_NETWORK_FILESYSTEMS is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_DEBUG_FS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_CRC32 is not set
diff -puN arch/sh/configs/kfr2r09_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/kfr2r09_defconfig
--- a/arch/sh/configs/kfr2r09_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/kfr2r09_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
@@ -33,15 +32,12 @@ CONFIG_INET=y
 # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
 # CONFIG_INET_XFRM_MODE_TUNNEL is not set
 # CONFIG_INET_XFRM_MODE_BEET is not set
-# CONFIG_INET_LRO is not set
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 # CONFIG_WIRELESS is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
 CONFIG_MTD_CMDLINE_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_INTELEXT=y
@@ -49,7 +45,6 @@ CONFIG_MTD_PHYSMAP=y
 CONFIG_MTD_ONENAND=y
 CONFIG_MTD_ONENAND_GENERIC=y
 CONFIG_MTD_UBI=y
-# CONFIG_MISC_DEVICES is not set
 # CONFIG_INPUT_MOUSEDEV is not set
 CONFIG_INPUT_EVDEV=y
 # CONFIG_KEYBOARD_ATKBD is not set
@@ -77,7 +72,6 @@ CONFIG_LOGO=y
 # CONFIG_LOGO_LINUX_CLUT224 is not set
 # CONFIG_LOGO_SUPERH_MONO is not set
 # CONFIG_LOGO_SUPERH_CLUT224 is not set
-# CONFIG_HID_SUPPORT is not set
 CONFIG_USB_GADGET=y
 CONFIG_USB_CDC_COMPOSITE=m
 CONFIG_MMC=y
@@ -91,4 +85,3 @@ CONFIG_TMPFS=y
 # CONFIG_NETWORK_FILESYSTEMS is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_DEBUG_FS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
diff -puN arch/sh/configs/landisk_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/landisk_defconfig
--- a/arch/sh/configs/landisk_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/landisk_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_SYSCTL_SYSCALL is not set
@@ -24,10 +23,8 @@ CONFIG_UNIX=y
 CONFIG_INET=y
 CONFIG_IP_ADVANCED_ROUTER=y
 CONFIG_IP_PNP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_NETFILTER=y
-CONFIG_IP_NF_QUEUE=m
 CONFIG_ATALK=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_BLK_DEV_LOOP=y
@@ -118,7 +115,6 @@ CONFIG_NFSD_V3=y
 CONFIG_SMB_FS=m
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_932=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_SH_STANDARD_BIOS=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRC_T10DIF=y
diff -puN arch/sh/configs/lboxre2_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/lboxre2_defconfig
--- a/arch/sh/configs/lboxre2_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/lboxre2_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_SYSCTL_SYSCALL is not set
@@ -28,7 +27,6 @@ CONFIG_UNIX=y
 CONFIG_INET=y
 CONFIG_IP_ADVANCED_ROUTER=y
 CONFIG_IP_PNP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_NETFILTER=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
@@ -61,7 +59,6 @@ CONFIG_VFAT_FS=y
 CONFIG_TMPFS=y
 CONFIG_ROMFS_FS=y
 CONFIG_NLS_CODEPAGE_437=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_SH_STANDARD_BIOS=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRC_T10DIF=y
diff -puN arch/sh/configs/magicpanelr2_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/magicpanelr2_defconfig
--- a/arch/sh/configs/magicpanelr2_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/magicpanelr2_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
@@ -35,16 +34,13 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
 # CONFIG_INET_XFRM_MODE_TUNNEL is not set
 # CONFIG_INET_XFRM_MODE_BEET is not set
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_STANDALONE is not set
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CMDLINE_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
@@ -55,8 +51,6 @@ CONFIG_NETDEVICES=y
 CONFIG_SMSC_PHY=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMSC911X=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 CONFIG_INPUT_EVDEV=y
 # CONFIG_MOUSE_PS2 is not set
 CONFIG_SERIAL_8250=y
@@ -68,7 +62,6 @@ CONFIG_SERIAL_SH_SCI=y
 CONFIG_SERIAL_SH_SCI_CONSOLE=y
 # CONFIG_HW_RANDOM is not set
 # CONFIG_HWMON is not set
-# CONFIG_HID_SUPPORT is not set
 # CONFIG_USB_SUPPORT is not set
 CONFIG_RTC_CLASS=y
 # CONFIG_RTC_HCTOSYS is not set
@@ -96,7 +89,5 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_KOBJECT=y
 CONFIG_DEBUG_INFO=y
 CONFIG_FRAME_POINTER=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
-CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_CRC_CCITT=m
 CONFIG_CRC16=m
diff -puN arch/sh/configs/microdev_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/microdev_defconfig
--- a/arch/sh/configs/microdev_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/microdev_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
@@ -19,7 +18,6 @@ CONFIG_SUPERHYWAY=y
 CONFIG_NET=y
 CONFIG_INET=y
 CONFIG_IP_PNP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
@@ -45,6 +43,5 @@ CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_CRYPTO_ECB=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/sh/configs/migor_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/migor_defconfig
--- a/arch/sh/configs/migor_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/migor_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
@@ -26,15 +25,11 @@ CONFIG_UNIX=y
 CONFIG_INET=y
 CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_FW_LOADER=m
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
@@ -47,8 +42,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMC91X=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_INPUT_MOUSEDEV is not set
 CONFIG_INPUT_EVDEV=y
 # CONFIG_KEYBOARD_ATKBD is not set
@@ -101,7 +94,6 @@ CONFIG_TMPFS=y
 CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
 CONFIG_DEBUG_FS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_CRYPTO_MANAGER=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
diff -puN arch/sh/configs/polaris_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/polaris_defconfig
--- a/arch/sh/configs/polaris_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/polaris_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
@@ -37,14 +36,11 @@ CONFIG_IP_MULTICAST=y
 # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
 # CONFIG_INET_XFRM_MODE_TUNNEL is not set
 # CONFIG_INET_XFRM_MODE_BEET is not set
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_ADV_OPTIONS=y
@@ -57,8 +53,6 @@ CONFIG_NETDEVICES=y
 CONFIG_SMSC_PHY=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMSC911X=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_KEYBOARD is not set
 # CONFIG_INPUT_MOUSE is not set
@@ -71,7 +65,6 @@ CONFIG_SERIAL_SH_SCI_CONSOLE=y
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_HW_RANDOM is not set
 # CONFIG_HWMON is not set
-# CONFIG_HID_SUPPORT is not set
 # CONFIG_USB_SUPPORT is not set
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_SH=y
@@ -91,5 +84,3 @@ CONFIG_DEBUG_LOCK_ALLOC=y
 CONFIG_DEBUG_SPINLOCK_SLEEP=y
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_SG=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
-CONFIG_SYSCTL_SYSCALL_CHECK=y
diff -puN arch/sh/configs/r7780mp_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/r7780mp_defconfig
--- a/arch/sh/configs/r7780mp_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/r7780mp_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
@@ -35,13 +34,11 @@ CONFIG_INET=y
 CONFIG_IP_ADVANCED_ROUTER=y
 CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_BRIDGE=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_FW_LOADER=m
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_COMPLEX_MAPPINGS=y
@@ -110,7 +107,6 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_DEBUG_PREEMPT is not set
 CONFIG_DEBUG_INFO=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_CRYPTO_ECB=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
diff -puN arch/sh/configs/r7785rp_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/r7785rp_defconfig
--- a/arch/sh/configs/r7785rp_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/r7785rp_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
@@ -42,7 +41,6 @@ CONFIG_INET=y
 CONFIG_IP_ADVANCED_ROUTER=y
 CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_BRIDGE=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
@@ -104,7 +102,6 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_LOCK_ALLOC=y
 CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
 CONFIG_DEBUG_INFO=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_SH_STANDARD_BIOS=y
 CONFIG_DEBUG_STACK_USAGE=y
 CONFIG_4KSTACKS=y
diff -puN arch/sh/configs/rsk7201_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/rsk7201_defconfig
--- a/arch/sh/configs/rsk7201_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/rsk7201_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
@@ -37,10 +36,7 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
@@ -58,8 +54,6 @@ CONFIG_SERIAL_SH_SCI_CONSOLE=y
 # CONFIG_HW_RANDOM is not set
 # CONFIG_HWMON is not set
 CONFIG_THERMAL=y
-CONFIG_VIDEO_OUTPUT_CONTROL=y
-# CONFIG_HID_SUPPORT is not set
 # CONFIG_USB_SUPPORT is not set
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_SH=y
@@ -71,5 +65,3 @@ CONFIG_ROMFS_FS=y
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
-CONFIG_SYSCTL_SYSCALL_CHECK=y
diff -puN arch/sh/configs/rsk7203_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/rsk7203_defconfig
--- a/arch/sh/configs/rsk7203_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/rsk7203_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
@@ -44,7 +43,6 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
 # CONFIG_INET_XFRM_MODE_TUNNEL is not set
 # CONFIG_INET_XFRM_MODE_BEET is not set
-# CONFIG_INET_LRO is not set
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
@@ -52,10 +50,7 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
@@ -64,8 +59,6 @@ CONFIG_NETDEVICES=y
 CONFIG_SMSC_PHY=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMSC911X=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 CONFIG_INPUT_FF_MEMLESS=m
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_KEYBOARD is not set
@@ -81,7 +74,6 @@ CONFIG_SERIAL_SH_SCI_CONSOLE=y
 # CONFIG_HWMON is not set
 CONFIG_THERMAL=y
 CONFIG_REGULATOR=y
-CONFIG_VIDEO_OUTPUT_CONTROL=y
 CONFIG_HID_A4TECH=y
 CONFIG_HID_APPLE=y
 CONFIG_HID_BELKIN=y
@@ -130,6 +122,4 @@ CONFIG_DEBUG_VM=y
 CONFIG_DEBUG_LIST=y
 CONFIG_DEBUG_SG=y
 CONFIG_FRAME_POINTER=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
-CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_DEBUG_STACK_USAGE=y
diff -puN arch/sh/configs/rsk7264_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/rsk7264_defconfig
--- a/arch/sh/configs/rsk7264_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/rsk7264_defconfig
@@ -35,7 +35,6 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
 # CONFIG_INET_XFRM_MODE_TUNNEL is not set
 # CONFIG_INET_XFRM_MODE_BEET is not set
-# CONFIG_INET_LRO is not set
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
@@ -61,11 +60,9 @@ CONFIG_SERIAL_SH_SCI_CONSOLE=y
 # CONFIG_HWMON is not set
 CONFIG_USB=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
-# CONFIG_USB_DEVICE_CLASS is not set
 CONFIG_USB_R8A66597_HCD=y
 CONFIG_USB_STORAGE=y
 CONFIG_USB_STORAGE_DEBUG=y
-CONFIG_USB_LIBUSUAL=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
diff -puN arch/sh/configs/rsk7269_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/rsk7269_defconfig
--- a/arch/sh/configs/rsk7269_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/rsk7269_defconfig
@@ -24,7 +24,6 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
 # CONFIG_INET_XFRM_MODE_TUNNEL is not set
 # CONFIG_INET_XFRM_MODE_BEET is not set
-# CONFIG_INET_LRO is not set
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
@@ -44,11 +43,9 @@ CONFIG_SERIAL_SH_SCI_CONSOLE=y
 # CONFIG_HWMON is not set
 CONFIG_USB=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
-# CONFIG_USB_DEVICE_CLASS is not set
 CONFIG_USB_R8A66597_HCD=y
 CONFIG_USB_STORAGE=y
 CONFIG_USB_STORAGE_DEBUG=y
-CONFIG_USB_LIBUSUAL=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
@@ -60,5 +57,4 @@ CONFIG_PARTITION_ADVANCED=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 # CONFIG_ENABLE_MUST_CHECK is not set
-CONFIG_SYSCTL_SYSCALL_CHECK=y
 # CONFIG_FTRACE is not set
diff -puN arch/sh/configs/rts7751r2d1_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/rts7751r2d1_defconfig
--- a/arch/sh/configs/rts7751r2d1_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/rts7751r2d1_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
@@ -22,7 +21,6 @@ CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
 CONFIG_INET=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_FW_LOADER=m
@@ -48,7 +46,6 @@ CONFIG_HW_RANDOM=y
 CONFIG_SPI=y
 CONFIG_SPI_SH_SCI=y
 CONFIG_MFD_SM501=y
-CONFIG_VIDEO_OUTPUT_CONTROL=m
 CONFIG_FB=y
 CONFIG_FB_SH_MOBILE_LCDC=m
 CONFIG_FB_SM501=y
@@ -83,7 +80,6 @@ CONFIG_USB=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
 CONFIG_USB_OHCI_HCD=y
 CONFIG_USB_STORAGE=y
-CONFIG_USB_LIBUSUAL=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_R9701=y
 CONFIG_EXT2_FS=y
@@ -94,6 +90,5 @@ CONFIG_TMPFS=y
 CONFIG_MINIX_FS=y
 CONFIG_NLS_CODEPAGE_932=y
 CONFIG_DEBUG_FS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRC_T10DIF=y
diff -puN arch/sh/configs/rts7751r2dplus_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/rts7751r2dplus_defconfig
--- a/arch/sh/configs/rts7751r2dplus_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/rts7751r2dplus_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
@@ -22,15 +21,11 @@ CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
 CONFIG_INET=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_FW_LOADER=m
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP=y
@@ -56,7 +51,6 @@ CONFIG_HW_RANDOM=y
 CONFIG_SPI=y
 CONFIG_SPI_SH_SCI=y
 CONFIG_MFD_SM501=y
-CONFIG_VIDEO_OUTPUT_CONTROL=m
 CONFIG_FB=y
 CONFIG_FB_SH_MOBILE_LCDC=m
 CONFIG_FB_SM501=y
@@ -91,7 +85,6 @@ CONFIG_USB=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
 CONFIG_USB_OHCI_HCD=y
 CONFIG_USB_STORAGE=y
-CONFIG_USB_LIBUSUAL=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_R9701=y
 CONFIG_EXT2_FS=y
@@ -102,6 +95,5 @@ CONFIG_TMPFS=y
 CONFIG_MINIX_FS=y
 CONFIG_NLS_CODEPAGE_932=y
 CONFIG_DEBUG_FS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRC_T10DIF=y
diff -puN arch/sh/configs/sdk7780_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/sdk7780_defconfig
--- a/arch/sh/configs/sdk7780_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/sdk7780_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="_SDK7780"
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
@@ -39,7 +38,6 @@ CONFIG_IP_ADVANCED_ROUTER=y
 CONFIG_IP_PNP=y
 CONFIG_IP_PNP_BOOTP=y
 # CONFIG_INET_XFRM_MODE_BEET is not set
-# CONFIG_INET_LRO is not set
 CONFIG_IPV6=y
 # CONFIG_INET6_XFRM_MODE_BEET is not set
 CONFIG_NET_SCHED=y
@@ -47,7 +45,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug
 CONFIG_PARPORT=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_IDE=y
 CONFIG_BLK_DEV_IDECD=y
 CONFIG_BLK_DEV_PLATFORM=y
@@ -63,8 +60,6 @@ CONFIG_BLK_DEV_DM=y
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMC91X=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 CONFIG_NETCONSOLE=y
 CONFIG_INPUT_FF_MEMLESS=m
 CONFIG_INPUT_EVDEV=y
@@ -78,7 +73,6 @@ CONFIG_SSB=y
 CONFIG_SSB_DRIVER_PCICORE=y
 CONFIG_FB=y
 CONFIG_FB_SH_MOBILE_LCDC=m
-CONFIG_DISPLAY_SUPPORT=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
 CONFIG_LOGO=y
@@ -101,7 +95,6 @@ CONFIG_HID_SAMSUNG=y
 CONFIG_HID_SONY=y
 CONFIG_HID_SUNPLUS=y
 CONFIG_USB=y
-# CONFIG_USB_DEVICE_CLASS is not set
 CONFIG_USB_MON=y
 CONFIG_USB_EHCI_HCD=y
 # CONFIG_USB_EHCI_TT_NEWSCHED is not set
@@ -144,8 +137,6 @@ CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_SCHED_DEBUG is not set
 CONFIG_TIMER_STATS=y
 CONFIG_DEBUG_INFO=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
-CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_SH_STANDARD_BIOS=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_DES=y
diff -puN arch/sh/configs/sdk7786_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/sdk7786_defconfig
--- a/arch/sh/configs/sdk7786_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/sdk7786_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZO=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
@@ -90,13 +89,11 @@ CONFIG_NET_KEY=y
 CONFIG_INET=y
 CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 # CONFIG_WIRELESS is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_BLOCK=y
 CONFIG_FTL=y
@@ -119,7 +116,6 @@ CONFIG_MTD_UBI_GLUEBI=m
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_CRYPTOLOOP=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_IDE=y
 CONFIG_BLK_DEV_IDECD=y
 CONFIG_BLK_DEV_PLATFORM=y
@@ -140,8 +136,6 @@ CONFIG_MDIO_BITBANG=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMC91X=y
 CONFIG_SMSC911X=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_WLAN is not set
 CONFIG_VT_HW_CONSOLE_BINDING=y
 CONFIG_SERIAL_SH_SCI=y
@@ -157,7 +151,6 @@ CONFIG_SPI=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
 CONFIG_SH_WDT=y
-CONFIG_VIDEO_OUTPUT_CONTROL=m
 CONFIG_USB=y
 CONFIG_USB_MON=y
 CONFIG_USB_OHCI_HCD=y
@@ -223,9 +216,7 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_TIMER_STATS=y
 CONFIG_DEBUG_MEMORY_INIT=y
-# CONFIG_RCU_CPU_STALL_VERBOSE is not set
 CONFIG_LATENCYTOP=y
-CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_FUNCTION_TRACER=y
 # CONFIG_FUNCTION_GRAPH_TRACER is not set
 CONFIG_DMA_API_DEBUG=y
diff -puN arch/sh/configs/se7206_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/se7206_defconfig
--- a/arch/sh/configs/se7206_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/se7206_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
@@ -57,7 +56,6 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
 # CONFIG_INET_XFRM_MODE_TUNNEL is not set
 # CONFIG_INET_XFRM_MODE_BEET is not set
-# CONFIG_INET_LRO is not set
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
@@ -65,9 +63,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
@@ -78,8 +73,6 @@ CONFIG_EEPROM_93CX6=y
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMC91X=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
@@ -109,7 +102,6 @@ CONFIG_DEBUG_SPINLOCK_SLEEP=y
 CONFIG_DEBUG_VM=y
 CONFIG_DEBUG_LIST=y
 CONFIG_FRAME_POINTER=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_DEBUG_STACK_USAGE=y
 CONFIG_CRYPTO_DEFLATE=y
 CONFIG_CRYPTO_LZO=y
diff -puN arch/sh/configs/se7343_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/se7343_defconfig
--- a/arch/sh/configs/se7343_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/se7343_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
@@ -27,26 +26,19 @@ CONFIG_PACKET=y
 CONFIG_UNIX=y
 CONFIG_INET=y
 CONFIG_SYN_COOKIES=y
-# CONFIG_INET_LRO is not set
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_RAM=y
 CONFIG_MTD_PHYSMAP=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 CONFIG_SCSI_MULTI_LUN=y
 # CONFIG_SCSI_LOWLEVEL is not set
 CONFIG_NETDEVICES=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 CONFIG_USB_USBNET=y
 # CONFIG_USB_NET_AX8817X is not set
 CONFIG_USB_NET_DM9601=y
@@ -104,5 +96,4 @@ CONFIG_CRAMFS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
 CONFIG_NFSD=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/sh/configs/se7619_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/se7619_defconfig
--- a/arch/sh/configs/se7619_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/se7619_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_UID16 is not set
@@ -24,10 +23,7 @@ CONFIG_BINFMT_ZFLAT=y
 # CONFIG_STANDALONE is not set
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
@@ -48,4 +44,3 @@ CONFIG_SERIAL_SH_SCI_CONSOLE=y
 # CONFIG_SYSFS is not set
 CONFIG_ROMFS_FS=y
 # CONFIG_ENABLE_MUST_CHECK is not set
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
diff -puN arch/sh/configs/se7705_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/se7705_defconfig
--- a/arch/sh/configs/se7705_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/se7705_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
@@ -27,11 +26,8 @@ CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
 CONFIG_IP_PNP_BOOTP=y
 CONFIG_IP_PNP_RARP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
@@ -58,5 +54,4 @@ CONFIG_PROC_KCORE=y
 CONFIG_JFFS2_FS=y
 CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/sh/configs/se7712_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/se7712_defconfig
--- a/arch/sh/configs/se7712_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/se7712_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
@@ -47,7 +46,6 @@ CONFIG_SYN_COOKIES=y
 CONFIG_INET_AH=y
 CONFIG_INET_ESP=y
 CONFIG_INET_IPCOMP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_NET_SCHED=y
@@ -68,9 +66,6 @@ CONFIG_NET_CLS_FW=y
 CONFIG_NET_CLS_IND=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
@@ -104,8 +99,6 @@ CONFIG_ROOT_NFS=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_INFO=y
 CONFIG_FRAME_POINTER=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
-CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_CRYPTO_ECB=m
 CONFIG_CRYPTO_PCBC=m
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/sh/configs/se7721_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/se7721_defconfig
--- a/arch/sh/configs/se7721_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/se7721_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
@@ -46,7 +45,6 @@ CONFIG_SYN_COOKIES=y
 CONFIG_INET_AH=y
 CONFIG_INET_ESP=y
 CONFIG_INET_IPCOMP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_NET_SCHED=y
@@ -67,9 +65,6 @@ CONFIG_NET_CLS_FW=y
 CONFIG_NET_CLS_IND=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
@@ -132,6 +127,5 @@ CONFIG_NLS_ISO8859_1=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_INFO=y
 CONFIG_FRAME_POINTER=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRC_CCITT=y
diff -puN arch/sh/configs/se7722_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/se7722_defconfig
--- a/arch/sh/configs/se7722_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/se7722_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
@@ -26,7 +25,6 @@ CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
 CONFIG_INET=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
@@ -57,6 +55,5 @@ CONFIG_PRINTK_TIME=y
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_SH_STANDARD_BIOS=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/sh/configs/se7724_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/se7724_defconfig
--- a/arch/sh/configs/se7724_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/se7724_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
@@ -30,14 +29,10 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
 # CONFIG_INET_XFRM_MODE_TUNNEL is not set
 # CONFIG_INET_XFRM_MODE_BEET is not set
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
@@ -53,8 +48,6 @@ CONFIG_SMSC_PHY=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SH_ETH=y
 CONFIG_SMC91X=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_INPUT_MOUSEDEV is not set
 CONFIG_INPUT_EVDEV=y
 # CONFIG_KEYBOARD_ATKBD is not set
@@ -137,8 +130,6 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_932=y
 CONFIG_NLS_ISO8859_1=y
 # CONFIG_ENABLE_MUST_CHECK is not set
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
-CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_CRYPTO=y
 CONFIG_CRYPTO_CBC=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/sh/configs/se7750_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/se7750_defconfig
--- a/arch/sh/configs/se7750_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/se7750_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
@@ -25,11 +24,8 @@ CONFIG_INET=y
 CONFIG_IP_MULTICAST=y
 CONFIG_IP_PNP=y
 CONFIG_IP_PNP_BOOTP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
@@ -58,5 +54,4 @@ CONFIG_ROOT_NFS=y
 CONFIG_PARTITION_ADVANCED=y
 # CONFIG_MSDOS_PARTITION is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/sh/configs/se7751_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/se7751_defconfig
--- a/arch/sh/configs/se7751_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/se7751_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
@@ -25,12 +24,9 @@ CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
 CONFIG_IP_PNP_BOOTP=y
 CONFIG_IP_PNP_RARP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_NETFILTER=y
-CONFIG_IP_NF_QUEUE=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
@@ -48,5 +44,4 @@ CONFIG_EXT2_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_JFFS2_FS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/sh/configs/se7780_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/se7780_defconfig
--- a/arch/sh/configs/se7780_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/se7780_defconfig
@@ -24,7 +24,6 @@ CONFIG_UNIX=y
 CONFIG_INET=y
 CONFIG_IP_MULTICAST=y
 CONFIG_IP_PNP=y
-# CONFIG_INET_LRO is not set
 CONFIG_IPV6=y
 # CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
 # CONFIG_INET6_XFRM_MODE_TUNNEL is not set
@@ -32,8 +31,6 @@ CONFIG_IPV6=y
 # CONFIG_IPV6_SIT is not set
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_ADV_OPTIONS=y
@@ -54,8 +51,6 @@ CONFIG_SMSC_PHY=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMC91X=y
 CONFIG_NET_PCI=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 CONFIG_INPUT_FF_MEMLESS=m
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
 # CONFIG_INPUT_KEYBOARD is not set
@@ -94,7 +89,6 @@ CONFIG_HID_SAMSUNG=y
 CONFIG_HID_SONY=y
 CONFIG_HID_SUNPLUS=y
 CONFIG_USB=y
-# CONFIG_USB_DEVICE_CLASS is not set
 CONFIG_USB_MON=y
 CONFIG_USB_EHCI_HCD=y
 CONFIG_USB_OHCI_HCD=y
@@ -110,5 +104,4 @@ CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
 CONFIG_ROOT_NFS=y
 CONFIG_DEBUG_FS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/sh/configs/secureedge5410_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/secureedge5410_defconfig
--- a/arch/sh/configs/secureedge5410_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/secureedge5410_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
@@ -18,12 +17,9 @@ CONFIG_INET=y
 # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
 # CONFIG_INET_XFRM_MODE_TUNNEL is not set
 # CONFIG_INET_XFRM_MODE_BEET is not set
-# CONFIG_INET_LRO is not set
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK_RO=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_ADV_OPTIONS=y
@@ -34,14 +30,11 @@ CONFIG_MTD_CFI_GEOMETRY=y
 CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_PLATRAM=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_NET_PCI=y
 CONFIG_8139CP=y
 CONFIG_8139TOO=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_KEYBOARD is not set
 # CONFIG_INPUT_MOUSE is not set
@@ -51,7 +44,6 @@ CONFIG_SERIAL_SH_SCI=y
 CONFIG_SERIAL_SH_SCI_CONSOLE=y
 # CONFIG_HW_RANDOM is not set
 # CONFIG_HWMON is not set
-# CONFIG_HID_SUPPORT is not set
 # CONFIG_USB_SUPPORT is not set
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_DS1302=y
@@ -60,4 +52,3 @@ CONFIG_EXT2_FS=y
 CONFIG_TMPFS=y
 CONFIG_CRAMFS=y
 CONFIG_ROMFS_FS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
diff -puN arch/sh/configs/sh03_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/sh03_defconfig
--- a/arch/sh/configs/sh03_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/sh03_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
@@ -34,7 +33,6 @@ CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
 CONFIG_IP_PNP_BOOTP=y
 CONFIG_IP_PNP_RARP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_STANDALONE is not set
@@ -70,7 +68,6 @@ CONFIG_EXT2_FS_XATTR=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
 CONFIG_EXT3_FS_POSIX_ACL=y
-CONFIG_AUTOFS_FS=y
 CONFIG_AUTOFS4_FS=y
 CONFIG_ISO9660_FS=m
 CONFIG_JOLIET=y
@@ -126,7 +123,6 @@ CONFIG_NLS_KOI8_R=m
 CONFIG_NLS_KOI8_U=m
 CONFIG_NLS_UTF8=m
 CONFIG_DEBUG_FS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_SH_STANDARD_BIOS=y
 CONFIG_CRYPTO_ECB=m
 CONFIG_CRYPTO_HMAC=y
diff -puN arch/sh/configs/sh2007_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/sh2007_defconfig
--- a/arch/sh/configs/sh2007_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/sh2007_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
@@ -42,7 +41,6 @@ CONFIG_NET_IPIP=y
 # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
 # CONFIG_INET_XFRM_MODE_TUNNEL is not set
 # CONFIG_INET_XFRM_MODE_BEET is not set
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_NETWORK_SECMARK=y
 CONFIG_NET_PKTGEN=y
@@ -50,7 +48,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_CDROM_PKTCDVD=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_RAID_ATTRS=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
@@ -72,8 +69,6 @@ CONFIG_TUN=y
 CONFIG_VETH=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMSC911X=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_WLAN is not set
 CONFIG_INPUT_FF_MEMLESS=y
 # CONFIG_INPUT_MOUSEDEV is not set
@@ -95,9 +90,7 @@ CONFIG_BACKLIGHT_LCD_SUPPORT=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
 CONFIG_LOGO=y
-# CONFIG_HID_SUPPORT is not set
 CONFIG_USB=y
-# CONFIG_USB_DEVICE_CLASS is not set
 CONFIG_USB_MON=y
 CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
@@ -172,7 +165,6 @@ CONFIG_DEBUG_KERNEL=y
 # CONFIG_SCHED_DEBUG is not set
 CONFIG_DEBUG_INFO=y
 CONFIG_FRAME_POINTER=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_SH_STANDARD_BIOS=y
 CONFIG_CRYPTO_NULL=y
 CONFIG_CRYPTO_AUTHENC=y
diff -puN arch/sh/configs/sh7710voipgw_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/sh7710voipgw_defconfig
--- a/arch/sh/configs/sh7710voipgw_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/sh7710voipgw_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
@@ -24,7 +23,6 @@ CONFIG_PACKET=y
 CONFIG_UNIX=y
 CONFIG_INET=y
 CONFIG_SYN_COOKIES=y
-# CONFIG_INET_LRO is not set
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_NETFILTER=y
@@ -36,8 +34,6 @@ CONFIG_NET_CLS_ROUTE4=y
 CONFIG_NET_CLS_U32=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
@@ -59,5 +55,4 @@ CONFIG_THERMAL=y
 # CONFIG_DNOTIFY is not set
 CONFIG_JFFS2_FS=y
 CONFIG_DEBUG_FS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/sh/configs/sh7724_generic_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/sh7724_generic_defconfig
--- a/arch/sh/configs/sh7724_generic_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/sh7724_generic_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_CGROUPS=y
@@ -18,7 +17,6 @@ CONFIG_HIBERNATION=y
 CONFIG_CPU_IDLE=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
-# CONFIG_MISC_DEVICES is not set
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
@@ -44,5 +42,4 @@ CONFIG_UIO_PDRV_GENIRQ=y
 # CONFIG_MISC_FILESYSTEMS is not set
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_CRC32 is not set
diff -puN arch/sh/configs/sh7757lcr_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/sh7757lcr_defconfig
--- a/arch/sh/configs/sh7757lcr_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/sh7757lcr_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
@@ -32,13 +31,11 @@ CONFIG_INET=y
 CONFIG_IP_MULTICAST=y
 CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
-# CONFIG_INET_LRO is not set
 CONFIG_IPV6=y
 # CONFIG_WIRELESS is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_M25P80=y
 CONFIG_BLK_DEV_RAM=y
@@ -48,7 +45,6 @@ CONFIG_NETDEVICES=y
 CONFIG_VITESSE_PHY=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SH_ETH=y
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_WLAN is not set
 # CONFIG_KEYBOARD_ATKBD is not set
 # CONFIG_MOUSE_PS2 is not set
diff -puN arch/sh/configs/sh7763rdp_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/sh7763rdp_defconfig
--- a/arch/sh/configs/sh7763rdp_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/sh7763rdp_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
@@ -26,11 +25,9 @@ CONFIG_INET=y
 CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
 CONFIG_IP_PNP_BOOTP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_BLKDEVS=y
 CONFIG_MTD_CFI=y
@@ -43,14 +40,11 @@ CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_CFI_STAA=y
 CONFIG_MTD_COMPLEX_MAPPINGS=y
 CONFIG_MTD_PHYSMAP=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SH_ETH=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_KEYBOARD is not set
 # CONFIG_INPUT_MOUSE is not set
@@ -65,7 +59,6 @@ CONFIG_FB_FOREIGN_ENDIAN=y
 CONFIG_FB_SH7760=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_LOGO=y
-# CONFIG_HID_SUPPORT is not set
 CONFIG_USB=y
 CONFIG_USB_MON=y
 CONFIG_USB_OHCI_HCD=y
@@ -74,7 +67,6 @@ CONFIG_MMC=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
-CONFIG_AUTOFS_FS=y
 CONFIG_AUTOFS4_FS=y
 CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
@@ -124,6 +116,5 @@ CONFIG_NLS_UTF8=y
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_DEBUG_FS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRC_T10DIF=y
diff -puN arch/sh/configs/sh7770_generic_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/sh7770_generic_defconfig
--- a/arch/sh/configs/sh7770_generic_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/sh7770_generic_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_CGROUPS=y
@@ -20,7 +19,6 @@ CONFIG_HIBERNATION=y
 CONFIG_CPU_IDLE=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
-# CONFIG_MISC_DEVICES is not set
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
@@ -46,5 +44,4 @@ CONFIG_UIO_PDRV_GENIRQ=y
 # CONFIG_MISC_FILESYSTEMS is not set
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_CRC32 is not set
diff -puN arch/sh/configs/sh7785lcr_32bit_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/sh7785lcr_32bit_defconfig
--- a/arch/sh/configs/sh7785lcr_32bit_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/sh7785lcr_32bit_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
@@ -44,13 +43,9 @@ CONFIG_INET=y
 CONFIG_IP_ADVANCED_ROUTER=y
 CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
@@ -58,7 +53,6 @@ CONFIG_MTD_PHYSMAP=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=y
 # CONFIG_SCSI_LOWLEVEL is not set
@@ -69,7 +63,6 @@ CONFIG_NET_ETHERNET=y
 CONFIG_NET_VENDOR_3COM=y
 CONFIG_VORTEX=y
 CONFIG_R8169=y
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_WLAN is not set
 CONFIG_INPUT_FF_MEMLESS=m
 CONFIG_INPUT_EVDEV=y
@@ -113,7 +106,6 @@ CONFIG_SND_CMIPCI=y
 CONFIG_SND_EMU10K1=y
 # CONFIG_SND_SUPERH is not set
 CONFIG_USB=y
-# CONFIG_USB_DEVICE_CLASS is not set
 CONFIG_USB_R8A66597_HCD=y
 CONFIG_USB_STORAGE=y
 CONFIG_MMC=y
@@ -154,9 +146,7 @@ CONFIG_DEBUG_SPINLOCK=y
 CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_SPINLOCK_SLEEP=y
 CONFIG_DEBUG_INFO=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_LATENCYTOP=y
-CONFIG_SYSCTL_SYSCALL_CHECK=y
 # CONFIG_FTRACE is not set
 CONFIG_CRYPTO_HMAC=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/sh/configs/sh7785lcr_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/sh7785lcr_defconfig
--- a/arch/sh/configs/sh7785lcr_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/sh7785lcr_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
@@ -26,27 +25,21 @@ CONFIG_INET=y
 CONFIG_IP_ADVANCED_ROUTER=y
 CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_BLK_DEV_SD=y
 # CONFIG_SCSI_LOWLEVEL is not set
 CONFIG_ATA=y
 CONFIG_SATA_SIL=y
 CONFIG_NETDEVICES=y
 CONFIG_R8169=y
-# CONFIG_NETDEV_10000 is not set
 CONFIG_INPUT_FF_MEMLESS=m
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
 # CONFIG_KEYBOARD_ATKBD is not set
@@ -121,8 +114,6 @@ CONFIG_NLS_ISO8859_1=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
-CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_CRYPTO_HMAC=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
diff -puN arch/sh/configs/shmin_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/shmin_defconfig
--- a/arch/sh/configs/shmin_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/shmin_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_UID16 is not set
@@ -28,10 +27,8 @@ CONFIG_NET=y
 CONFIG_UNIX=y
 CONFIG_INET=y
 CONFIG_IP_PNP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
@@ -53,6 +50,5 @@ CONFIG_CRAMFS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
 CONFIG_ROOT_NFS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_SH_STANDARD_BIOS=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/sh/configs/shx3_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/shx3_defconfig
--- a/arch/sh/configs/shx3_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/shx3_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
@@ -56,7 +55,6 @@ CONFIG_NET=y
 CONFIG_INET=y
 CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
-# CONFIG_INET_LRO is not set
 CONFIG_CAN=m
 CONFIG_CAN_RAW=m
 CONFIG_CAN_BCM=m
@@ -70,8 +68,6 @@ CONFIG_PATA_PLATFORM=y
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMC91X=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
@@ -82,7 +78,6 @@ CONFIG_I2C=m
 CONFIG_SPI=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
-CONFIG_VIDEO_OUTPUT_CONTROL=m
 CONFIG_USB=y
 CONFIG_USB_MON=y
 CONFIG_USB_R8A66597_HCD=m
@@ -104,7 +99,6 @@ CONFIG_DEBUG_SHIRQ=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_DEBUG_VM=y
 CONFIG_FRAME_POINTER=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_SH_STANDARD_BIOS=y
 CONFIG_DEBUG_STACK_USAGE=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/sh/configs/titan_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/titan_defconfig
--- a/arch/sh/configs/titan_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/titan_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
@@ -49,7 +48,6 @@ CONFIG_SYN_COOKIES=y
 CONFIG_INET_AH=y
 CONFIG_INET_ESP=y
 CONFIG_INET_IPCOMP=y
-# CONFIG_INET_LRO is not set
 CONFIG_INET_DIAG=m
 CONFIG_IPV6=y
 CONFIG_IPV6_PRIVACY=y
@@ -79,7 +77,6 @@ CONFIG_NETFILTER_XT_MATCH_REALM=m
 CONFIG_NETFILTER_XT_MATCH_SCTP=m
 CONFIG_NETFILTER_XT_MATCH_STRING=m
 CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
-CONFIG_IP_NF_QUEUE=m
 CONFIG_IP_NF_IPTABLES=m
 CONFIG_IP_NF_MATCH_ADDRTYPE=m
 CONFIG_IP_NF_MATCH_AH=m
@@ -88,7 +85,6 @@ CONFIG_IP_NF_MATCH_TTL=m
 CONFIG_IP_NF_FILTER=m
 CONFIG_IP_NF_TARGET_REJECT=m
 CONFIG_IP_NF_TARGET_LOG=m
-CONFIG_IP_NF_TARGET_ULOG=m
 CONFIG_IP_NF_MANGLE=m
 CONFIG_IP_NF_TARGET_ECN=m
 CONFIG_IP_NF_TARGET_TTL=m
@@ -96,7 +92,6 @@ CONFIG_IP_NF_RAW=m
 CONFIG_IP_NF_ARPTABLES=m
 CONFIG_IP_NF_ARPFILTER=m
 CONFIG_IP_NF_ARP_MANGLE=m
-CONFIG_IP6_NF_QUEUE=m
 CONFIG_IP6_NF_IPTABLES=m
 CONFIG_IP6_NF_MATCH_AH=m
 CONFIG_IP6_NF_MATCH_EUI64=m
@@ -106,7 +101,6 @@ CONFIG_IP6_NF_MATCH_HL=m
 CONFIG_IP6_NF_MATCH_IPV6HEADER=m
 CONFIG_IP6_NF_MATCH_RT=m
 CONFIG_IP6_NF_TARGET_HL=m
-CONFIG_IP6_NF_TARGET_LOG=m
 CONFIG_IP6_NF_FILTER=m
 CONFIG_IP6_NF_TARGET_REJECT=m
 CONFIG_IP6_NF_MANGLE=m
@@ -154,7 +148,6 @@ CONFIG_FW_LOADER=m
 CONFIG_CONNECTOR=m
 CONFIG_MTD=m
 CONFIG_MTD_DEBUG=y
-CONFIG_MTD_CHAR=m
 CONFIG_MTD_BLOCK=m
 CONFIG_FTL=m
 CONFIG_NFTL=m
@@ -261,7 +254,6 @@ CONFIG_NLS_UTF8=m
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_CRYPTO_NULL=m
 CONFIG_CRYPTO_ECB=y
 CONFIG_CRYPTO_MD4=m
diff -puN arch/sh/configs/ul2_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/ul2_defconfig
--- a/arch/sh/configs/ul2_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/ul2_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
@@ -29,7 +28,6 @@ CONFIG_UNIX=y
 CONFIG_INET=y
 CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_CFG80211=y
 CONFIG_MAC80211=y
@@ -37,9 +35,6 @@ CONFIG_MAC80211_RC_PID=y
 # CONFIG_MAC80211_RC_MINSTREL is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
@@ -50,8 +45,6 @@ CONFIG_ATA=y
 CONFIG_PATA_PLATFORM=y
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
 CONFIG_LIBERTAS=m
 CONFIG_LIBERTAS_SDIO=m
 CONFIG_LIBERTAS_DEBUG=y
@@ -70,7 +63,6 @@ CONFIG_SERIAL_SH_SCI_CONSOLE=y
 # CONFIG_UNIX98_PTYS is not set
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_HW_RANDOM is not set
-# CONFIG_HID_SUPPORT is not set
 CONFIG_USB=y
 CONFIG_USB_MON=y
 CONFIG_USB_R8A66597_HCD=y
@@ -92,6 +84,5 @@ CONFIG_NLS_CODEPAGE_932=y
 CONFIG_NLS_ISO8859_1=y
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_CRYPTO_MICHAEL_MIC=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff -puN arch/sh/configs/urquell_defconfig~sh-defconfig-cleanup-from-old-kconfig-options arch/sh/configs/urquell_defconfig
--- a/arch/sh/configs/urquell_defconfig~sh-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/sh/configs/urquell_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
@@ -46,20 +45,15 @@ CONFIG_INET=y
 CONFIG_IP_ADVANCED_ROUTER=y
 CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
-# CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_BLK_DEV_SD=y
 # CONFIG_SCSI_LOWLEVEL is not set
 CONFIG_ATA=y
@@ -73,7 +67,6 @@ CONFIG_NET_PCI=y
 CONFIG_8139CP=y
 CONFIG_SKY2=y
 CONFIG_SKY2_DEBUG=y
-# CONFIG_NETDEV_10000 is not set
 CONFIG_INPUT_FF_MEMLESS=m
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
 # CONFIG_KEYBOARD_ATKBD is not set
@@ -150,8 +143,6 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_DEBUG_INFO=y
 CONFIG_FRAME_POINTER=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
-CONFIG_SYSCTL_SYSCALL_CHECK=y
 # CONFIG_FTRACE is not set
 # CONFIG_DUMP_CODE is not set
 CONFIG_CRYPTO_HMAC=y
_
