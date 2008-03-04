From: akpm@linux-foundation.org
Subject: + m68knommu-update-defconfig.patch added to -mm tree
Date: Tue, 04 Mar 2008 01:33:37 -0800
Message-ID: <200803040933.m249Xb4G001524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431AbYCDJen (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 04:34:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org


The patch titled
     m68knommu: update defconfig
has been added to the -mm tree.  Its filename is
     m68knommu-update-defconfig.patch

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
Subject: m68knommu: update defconfig
From: Greg Ungerer <gerg@snapgear.com>

Update the m68knommu defconfig.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/defconfig |  112 ++++++++++++++++++-------------------
 1 file changed, 56 insertions(+), 56 deletions(-)

diff -puN arch/m68knommu/defconfig~m68knommu-update-defconfig arch/m68knommu/defconfig
--- a/arch/m68knommu/defconfig~m68knommu-update-defconfig
+++ a/arch/m68knommu/defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.23
-# Thu Oct 18 13:17:38 2007
+# Linux kernel version: 2.6.25-rc3
+# Mon Feb 25 15:03:00 2008
 #
 CONFIG_M68K=y
 # CONFIG_MMU is not set
@@ -15,8 +15,10 @@ CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_GENERIC_TIME=y
 CONFIG_TIME_LOW_RES=y
 CONFIG_NO_IOPORT=y
+CONFIG_ARCH_SUPPORTS_AOUT=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
@@ -31,12 +33,14 @@ CONFIG_LOCALVERSION_AUTO=y
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
-# CONFIG_USER_NS is not set
 # CONFIG_AUDIT is not set
 # CONFIG_IKCONFIG is not set
 CONFIG_LOG_BUF_SHIFT=14
+# CONFIG_CGROUPS is not set
+# CONFIG_GROUP_SCHED is not set
 # CONFIG_SYSFS_DEPRECATED is not set
 # CONFIG_RELAY is not set
+# CONFIG_NAMESPACES is not set
 # CONFIG_BLK_DEV_INITRD is not set
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SYSCTL=y
@@ -48,15 +52,22 @@ CONFIG_SYSCTL_SYSCALL=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
 # CONFIG_SIGNALFD is not set
+# CONFIG_TIMERFD is not set
 # CONFIG_EVENTFD is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
 # CONFIG_SLOB is not set
+# CONFIG_PROFILING is not set
+# CONFIG_MARKERS is not set
+# CONFIG_HAVE_OPROFILE is not set
+# CONFIG_HAVE_KPROBES is not set
+CONFIG_SLABINFO=y
 CONFIG_TINY_SHMEM=y
 CONFIG_BASE_SMALL=0
 CONFIG_MODULES=y
@@ -83,6 +94,8 @@ CONFIG_IOSCHED_NOOP=y
 # CONFIG_DEFAULT_CFQ is not set
 CONFIG_DEFAULT_NOOP=y
 CONFIG_DEFAULT_IOSCHED="noop"
+CONFIG_CLASSIC_RCU=y
+# CONFIG_PREEMPT_RCU is not set
 
 #
 # Processor type and features
@@ -121,6 +134,7 @@ CONFIG_M5272C3=y
 # CONFIG_MOD5272 is not set
 CONFIG_FREESCALE=y
 CONFIG_4KSTACKS=y
+CONFIG_HZ=100
 
 #
 # RAM configuration
@@ -147,6 +161,7 @@ CONFIG_FLATMEM_MANUAL=y
 CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
 # CONFIG_SPARSEMEM_STATIC is not set
+# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
@@ -159,10 +174,6 @@ CONFIG_VIRT_TO_BUS=y
 # CONFIG_ARCH_SUPPORTS_MSI is not set
 
 #
-# PCCARD (PCMCIA/CardBus) support
-#
-
-#
 # Executable file formats
 #
 CONFIG_BINFMT_FLAT=y
@@ -205,6 +216,7 @@ CONFIG_IP_FIB_HASH=y
 # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
 # CONFIG_INET_XFRM_MODE_TUNNEL is not set
 # CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_LRO is not set
 # CONFIG_INET_DIAG is not set
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
@@ -229,10 +241,6 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_LAPB is not set
 # CONFIG_ECONET is not set
 # CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
 # CONFIG_NET_SCHED is not set
 
 #
@@ -240,6 +248,7 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 #
 # CONFIG_NET_PKTGEN is not set
 # CONFIG_HAMRADIO is not set
+# CONFIG_CAN is not set
 # CONFIG_IRDA is not set
 # CONFIG_BT is not set
 # CONFIG_AF_RXRPC is not set
@@ -283,6 +292,7 @@ CONFIG_MTD_BLOCK=y
 # CONFIG_INFTL is not set
 # CONFIG_RFD_FTL is not set
 # CONFIG_SSFDC is not set
+# CONFIG_MTD_OOPS is not set
 
 #
 # RAM/ROM/Flash chip drivers
@@ -339,10 +349,11 @@ CONFIG_BLK_DEV=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
-CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
+# CONFIG_BLK_DEV_XIP is not set
 # CONFIG_CDROM_PKTCDVD is not set
 # CONFIG_ATA_OVER_ETH is not set
 # CONFIG_MISC_DEVICES is not set
+CONFIG_HAVE_IDE=y
 # CONFIG_IDE is not set
 
 #
@@ -360,9 +371,15 @@ CONFIG_NETDEVICES=y
 # CONFIG_MACVLAN is not set
 # CONFIG_EQUALIZER is not set
 # CONFIG_TUN is not set
+# CONFIG_VETH is not set
 # CONFIG_PHYLIB is not set
 CONFIG_NET_ETHERNET=y
 # CONFIG_MII is not set
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_B44 is not set
 CONFIG_FEC=y
 # CONFIG_FEC2 is not set
 # CONFIG_NETDEV_1000 is not set
@@ -377,7 +394,7 @@ CONFIG_FEC=y
 CONFIG_PPP=y
 # CONFIG_PPP_MULTILINK is not set
 # CONFIG_PPP_FILTER is not set
-# CONFIG_PPP_ASYNC is not set
+CONFIG_PPP_ASYNC=y
 # CONFIG_PPP_SYNC_TTY is not set
 # CONFIG_PPP_DEFLATE is not set
 # CONFIG_PPP_BSDCOMP is not set
@@ -386,7 +403,6 @@ CONFIG_PPP=y
 # CONFIG_PPPOL2TP is not set
 # CONFIG_SLIP is not set
 CONFIG_SLHC=y
-# CONFIG_SHAPER is not set
 # CONFIG_NETCONSOLE is not set
 # CONFIG_NETPOLL is not set
 # CONFIG_NET_POLL_CONTROLLER is not set
@@ -418,12 +434,16 @@ CONFIG_SLHC=y
 #
 # Non-8250 serial port support
 #
-CONFIG_SERIAL_COLDFIRE=y
+CONFIG_SERIAL_CORE=y
+CONFIG_SERIAL_CORE_CONSOLE=y
+# CONFIG_SERIAL_COLDFIRE is not set
+CONFIG_SERIAL_MCF=y
+CONFIG_SERIAL_MCF_BAUDRATE=19200
+CONFIG_SERIAL_MCF_CONSOLE=y
 # CONFIG_UNIX98_PTYS is not set
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_IPMI_HANDLER is not set
-# CONFIG_WATCHDOG is not set
 # CONFIG_HW_RANDOM is not set
 # CONFIG_GEN_RTC is not set
 # CONFIG_R3964 is not set
@@ -439,6 +459,14 @@ CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_W1 is not set
 # CONFIG_POWER_SUPPLY is not set
 # CONFIG_HWMON is not set
+# CONFIG_THERMAL is not set
+# CONFIG_WATCHDOG is not set
+
+#
+# Sonics Silicon Backplane
+#
+CONFIG_SSB_POSSIBLE=y
+# CONFIG_SSB is not set
 
 #
 # Multifunction device drivers
@@ -450,20 +478,20 @@ CONFIG_LEGACY_PTY_COUNT=256
 #
 # CONFIG_VIDEO_DEV is not set
 # CONFIG_DVB_CORE is not set
-CONFIG_DAB=y
+# CONFIG_DAB is not set
 
 #
 # Graphics support
 #
+# CONFIG_VGASTATE is not set
+# CONFIG_VIDEO_OUTPUT_CONTROL is not set
+# CONFIG_FB is not set
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
 # Display device support
 #
 # CONFIG_DISPLAY_SUPPORT is not set
-# CONFIG_VGASTATE is not set
-CONFIG_VIDEO_OUTPUT_CONTROL=y
-# CONFIG_FB is not set
 
 #
 # Sound
@@ -471,23 +499,11 @@ CONFIG_VIDEO_OUTPUT_CONTROL=y
 # CONFIG_SOUND is not set
 # CONFIG_USB_SUPPORT is not set
 # CONFIG_MMC is not set
+# CONFIG_MEMSTICK is not set
 # CONFIG_NEW_LEDS is not set
 # CONFIG_RTC_CLASS is not set
 
 #
-# DMA Engine support
-#
-# CONFIG_DMA_ENGINE is not set
-
-#
-# DMA Clients
-#
-
-#
-# DMA Devices
-#
-
-#
 # Userspace I/O
 #
 # CONFIG_UIO is not set
@@ -505,11 +521,9 @@ CONFIG_EXT2_FS=y
 # CONFIG_XFS_FS is not set
 # CONFIG_GFS2_FS is not set
 # CONFIG_OCFS2_FS is not set
-# CONFIG_MINIX_FS is not set
-CONFIG_ROMFS_FS=y
+# CONFIG_DNOTIFY is not set
 # CONFIG_INOTIFY is not set
 # CONFIG_QUOTA is not set
-# CONFIG_DNOTIFY is not set
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
 # CONFIG_FUSE_FS is not set
@@ -535,7 +549,6 @@ CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
 # CONFIG_TMPFS is not set
 # CONFIG_HUGETLB_PAGE is not set
-CONFIG_RAMFS=y
 # CONFIG_CONFIGFS_FS is not set
 
 #
@@ -551,42 +564,27 @@ CONFIG_RAMFS=y
 # CONFIG_JFFS2_FS is not set
 # CONFIG_CRAMFS is not set
 # CONFIG_VXFS_FS is not set
+# CONFIG_MINIX_FS is not set
 # CONFIG_HPFS_FS is not set
 # CONFIG_QNX4FS_FS is not set
+CONFIG_ROMFS_FS=y
 # CONFIG_SYSV_FS is not set
 # CONFIG_UFS_FS is not set
-
-#
-# Network File Systems
-#
-# CONFIG_NFS_FS is not set
-# CONFIG_NFSD is not set
-# CONFIG_SMB_FS is not set
-# CONFIG_CIFS is not set
-# CONFIG_NCP_FS is not set
-# CONFIG_CODA_FS is not set
-# CONFIG_AFS_FS is not set
+# CONFIG_NETWORK_FILESYSTEMS is not set
 
 #
 # Partition Types
 #
 # CONFIG_PARTITION_ADVANCED is not set
 CONFIG_MSDOS_PARTITION=y
-
-#
-# Native Language Support
-#
 # CONFIG_NLS is not set
-
-#
-# Distributed Lock Manager
-#
 # CONFIG_DLM is not set
 
 #
 # Kernel hacking
 #
 # CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_WARN_DEPRECATED=y
 # CONFIG_ENABLE_MUST_CHECK is not set
 # CONFIG_MAGIC_SYSRQ is not set
 # CONFIG_UNUSED_SYMBOLS is not set
@@ -594,6 +592,7 @@ CONFIG_MSDOS_PARTITION=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_SAMPLES is not set
 # CONFIG_FULLDEBUG is not set
 # CONFIG_HIGHPROFILE is not set
 # CONFIG_BOOTPARAM is not set
@@ -605,6 +604,7 @@ CONFIG_MSDOS_PARTITION=y
 #
 # CONFIG_KEYS is not set
 # CONFIG_SECURITY is not set
+# CONFIG_SECURITY_FILE_CAPABILITIES is not set
 # CONFIG_CRYPTO is not set
 
 #
_

Patches currently in -mm which might be from gerg@snapgear.com are

m68knommu-update-defconfig.patch
m68knommu-remove-duplicate-hw_tick-code.patch
m68knommu-declare-do_irq.patch
m68knommu-fix-fec-driver-interrupt-races.patch

