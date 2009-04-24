From: akpm@linux-foundation.org
Subject: [merged] mn10300-update-the-asb2303-defconfig.patch removed from -mm tree
Date: Fri, 24 Apr 2009 12:27:59 -0700
Message-ID: <200904241927.n3OJRxvY015996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752487AbZDXT3Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Apr 2009 15:29:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: update the ASB2303 defconfig
has been removed from the -mm tree.  Its filename was
     mn10300-update-the-asb2303-defconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: update the ASB2303 defconfig
From: David Howells <dhowells@redhat.com>

Update the defconfig for the ASB2303 evaluation board.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/configs/asb2303_defconfig |  160 +++++++++++++----------
 1 file changed, 94 insertions(+), 66 deletions(-)

diff -puN arch/mn10300/configs/asb2303_defconfig~mn10300-update-the-asb2303-defconfig arch/mn10300/configs/asb2303_defconfig
--- a/arch/mn10300/configs/asb2303_defconfig~mn10300-update-the-asb2303-defconfig
+++ a/arch/mn10300/configs/asb2303_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.25-rc2
-# Tue Feb 19 18:52:24 2008
+# Linux kernel version: 2.6.30-rc2
+# Sat Apr 18 11:13:22 2009
 #
 CONFIG_MN10300=y
 CONFIG_AM33=y
@@ -18,7 +18,6 @@ CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_BUG=y
 CONFIG_QUICKLIST=y
 CONFIG_ARCH_HAS_ILOG2_U32=y
-# CONFIG_ARCH_SUPPORTS_AOUT is not set
 CONFIG_GENERIC_HARDIRQS=y
 # CONFIG_HOTPLUG_CPU is not set
 CONFIG_HZ=1000
@@ -40,52 +39,58 @@ CONFIG_BSD_PROCESS_ACCT=y
 # CONFIG_BSD_PROCESS_ACCT_V3 is not set
 # CONFIG_TASKSTATS is not set
 # CONFIG_AUDIT is not set
+
+#
+# RCU Subsystem
+#
+CONFIG_CLASSIC_RCU=y
+# CONFIG_TREE_RCU is not set
+# CONFIG_PREEMPT_RCU is not set
+# CONFIG_TREE_RCU_TRACE is not set
+# CONFIG_PREEMPT_RCU_TRACE is not set
 # CONFIG_IKCONFIG is not set
 CONFIG_LOG_BUF_SHIFT=14
-# CONFIG_CGROUPS is not set
 # CONFIG_GROUP_SCHED is not set
-# CONFIG_USER_SCHED is not set
-# CONFIG_CGROUP_SCHED is not set
-# CONFIG_SYSFS_DEPRECATED is not set
+# CONFIG_CGROUPS is not set
+# CONFIG_SYSFS_DEPRECATED_V2 is not set
 # CONFIG_RELAY is not set
 # CONFIG_NAMESPACES is not set
 # CONFIG_BLK_DEV_INITRD is not set
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SYSCTL=y
+CONFIG_ANON_INODES=y
 CONFIG_EMBEDDED=y
 CONFIG_SYSCTL_SYSCALL=y
 # CONFIG_KALLSYMS is not set
+CONFIG_STRIP_ASM_SYMS=y
 # CONFIG_HOTPLUG is not set
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
-CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
 CONFIG_SHMEM=y
+CONFIG_AIO=y
 # CONFIG_VM_EVENT_COUNTERS is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
 # CONFIG_SLOB is not set
 CONFIG_PROFILING=y
 # CONFIG_MARKERS is not set
-CONFIG_OPROFILE=y
-# CONFIG_HAVE_OPROFILE is not set
-# CONFIG_HAVE_KPROBES is not set
-# CONFIG_PROC_PAGE_MONITOR is not set
+CONFIG_HAVE_OPROFILE=y
+# CONFIG_SLOW_WORK is not set
+# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
 CONFIG_SLABINFO=y
 CONFIG_RT_MUTEXES=y
-# CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=0
 # CONFIG_MODULES is not set
 # CONFIG_BLOCK is not set
-CONFIG_CLASSIC_RCU=y
-# CONFIG_PREEMPT_RCU is not set
+# CONFIG_FREEZER is not set
 
 #
 # Matsushita MN10300 system setup
@@ -107,7 +112,6 @@ CONFIG_INTERRUPT_VECTOR_BASE=0x90000000
 CONFIG_KERNEL_TEXT_ADDRESS=0x90001000
 CONFIG_KERNEL_ZIMAGE_BASE_ADDRESS=0x90700000
 CONFIG_PREEMPT=y
-CONFIG_PREEMPT_BKL=y
 CONFIG_MN10300_CURRENT_IN_E2=y
 CONFIG_MN10300_USING_JTAG=y
 CONFIG_MN10300_RTC=y
@@ -135,13 +139,15 @@ CONFIG_FLATMEM_MANUAL=y
 # CONFIG_SPARSEMEM_MANUAL is not set
 CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
-# CONFIG_SPARSEMEM_STATIC is not set
-# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
+CONFIG_PAGEFLAGS_EXTENDED=y
 CONFIG_SPLIT_PTLOCK_CPUS=4
-# CONFIG_RESOURCES_64BIT is not set
+# CONFIG_PHYS_ADDR_T_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=0
 CONFIG_NR_QUICK=1
 CONFIG_VIRT_TO_BUS=y
+CONFIG_UNEVICTABLE_LRU=y
+CONFIG_HAVE_MLOCK=y
+CONFIG_HAVE_MLOCKED_PAGE_BIT=y
 
 #
 # Power management options
@@ -152,11 +158,9 @@ CONFIG_VIRT_TO_BUS=y
 # Executable formats
 #
 CONFIG_BINFMT_ELF=y
+# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
+# CONFIG_HAVE_AOUT is not set
 # CONFIG_BINFMT_MISC is not set
-
-#
-# Networking
-#
 CONFIG_NET=y
 
 #
@@ -194,8 +198,6 @@ CONFIG_TCP_CONG_CUBIC=y
 CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_TCP_MD5SIG is not set
 # CONFIG_IPV6 is not set
-# CONFIG_INET6_XFRM_TUNNEL is not set
-# CONFIG_INET6_TUNNEL is not set
 # CONFIG_NETWORK_SECMARK is not set
 # CONFIG_NETFILTER is not set
 # CONFIG_IP_DCCP is not set
@@ -203,6 +205,7 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_TIPC is not set
 # CONFIG_ATM is not set
 # CONFIG_BRIDGE is not set
+# CONFIG_NET_DSA is not set
 # CONFIG_VLAN_8021Q is not set
 # CONFIG_DECNET is not set
 # CONFIG_LLC2 is not set
@@ -212,7 +215,9 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_LAPB is not set
 # CONFIG_ECONET is not set
 # CONFIG_WAN_ROUTER is not set
+# CONFIG_PHONET is not set
 # CONFIG_NET_SCHED is not set
+# CONFIG_DCB is not set
 
 #
 # Network testing
@@ -223,14 +228,8 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_IRDA is not set
 # CONFIG_BT is not set
 # CONFIG_AF_RXRPC is not set
-
-#
-# Wireless
-#
-# CONFIG_CFG80211 is not set
-# CONFIG_WIRELESS_EXT is not set
-# CONFIG_MAC80211 is not set
-# CONFIG_IEEE80211 is not set
+# CONFIG_WIRELESS is not set
+# CONFIG_WIMAX is not set
 # CONFIG_RFKILL is not set
 # CONFIG_NET_9P is not set
 
@@ -255,6 +254,7 @@ CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
 CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
 # CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
 # CONFIG_MTD_CMDLINE_PARTS is not set
+# CONFIG_MTD_AR7_PARTS is not set
 
 #
 # User Modules And Translation Layers
@@ -297,9 +297,7 @@ CONFIG_MTD_CFI_UTIL=y
 #
 # CONFIG_MTD_COMPLEX_MAPPINGS is not set
 CONFIG_MTD_PHYSMAP=y
-CONFIG_MTD_PHYSMAP_START=0x8000000
-CONFIG_MTD_PHYSMAP_LEN=0x0
-CONFIG_MTD_PHYSMAP_BANKWIDTH=2
+# CONFIG_MTD_PHYSMAP_COMPAT is not set
 # CONFIG_MTD_PLATRAM is not set
 
 #
@@ -319,14 +317,23 @@ CONFIG_MTD_PHYSMAP_BANKWIDTH=2
 # CONFIG_MTD_ONENAND is not set
 
 #
+# LPDDR flash memory drivers
+#
+# CONFIG_MTD_LPDDR is not set
+
+#
 # UBI - Unsorted block images
 #
 # CONFIG_MTD_UBI is not set
 # CONFIG_PARPORT is not set
 CONFIG_MISC_DEVICES=y
-# CONFIG_EEPROM_93CX6 is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
-# CONFIG_HAVE_IDE is not set
+# CONFIG_C2PORT is not set
+
+#
+# EEPROM support
+#
+# CONFIG_EEPROM_93CX6 is not set
 
 #
 # SCSI device support
@@ -334,7 +341,7 @@ CONFIG_MISC_DEVICES=y
 # CONFIG_SCSI_DMA is not set
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_NETDEVICES=y
-# CONFIG_NETDEVICES_MULTIQUEUE is not set
+CONFIG_COMPAT_NET_DEV_OPS=y
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
 # CONFIG_MACVLAN is not set
@@ -345,10 +352,15 @@ CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_MII=y
 CONFIG_SMC91X=y
+# CONFIG_ETHOC is not set
+# CONFIG_DNET is not set
 # CONFIG_IBM_NEW_EMAC_ZMII is not set
 # CONFIG_IBM_NEW_EMAC_RGMII is not set
 # CONFIG_IBM_NEW_EMAC_TAH is not set
 # CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
+# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
+# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
 # CONFIG_B44 is not set
 # CONFIG_NETDEV_1000 is not set
 # CONFIG_NETDEV_10000 is not set
@@ -358,6 +370,10 @@ CONFIG_SMC91X=y
 #
 # CONFIG_WLAN_PRE80211 is not set
 # CONFIG_WLAN_80211 is not set
+
+#
+# Enable WiMAX (Networking options) to see the WiMAX drivers
+#
 # CONFIG_WAN is not set
 # CONFIG_PPP is not set
 # CONFIG_SLIP is not set
@@ -382,6 +398,7 @@ CONFIG_SMC91X=y
 # Character devices
 #
 # CONFIG_VT is not set
+CONFIG_DEVKMEM=y
 # CONFIG_SERIAL_NONSTANDARD is not set
 
 #
@@ -403,6 +420,7 @@ CONFIG_SERIAL_8250_SHARE_IRQ=y
 CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
 CONFIG_UNIX98_PTYS=y
+# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_IPMI_HANDLER is not set
@@ -411,34 +429,43 @@ CONFIG_RTC=y
 # CONFIG_R3964 is not set
 # CONFIG_TCG_TPM is not set
 # CONFIG_I2C is not set
-
-#
-# SPI support
-#
 # CONFIG_SPI is not set
-# CONFIG_SPI_MASTER is not set
 # CONFIG_W1 is not set
 # CONFIG_POWER_SUPPLY is not set
 # CONFIG_HWMON is not set
 # CONFIG_THERMAL is not set
+# CONFIG_THERMAL_HWMON is not set
 # CONFIG_WATCHDOG is not set
+CONFIG_SSB_POSSIBLE=y
 
 #
 # Sonics Silicon Backplane
 #
-CONFIG_SSB_POSSIBLE=y
 # CONFIG_SSB is not set
 
 #
 # Multifunction device drivers
 #
+# CONFIG_MFD_CORE is not set
 # CONFIG_MFD_SM501 is not set
+# CONFIG_HTC_PASIC3 is not set
+# CONFIG_MFD_TMIO is not set
+# CONFIG_REGULATOR is not set
 
 #
 # Multimedia devices
 #
+
+#
+# Multimedia core support
+#
 # CONFIG_VIDEO_DEV is not set
 # CONFIG_DVB_CORE is not set
+# CONFIG_VIDEO_MEDIA is not set
+
+#
+# Multimedia drivers
+#
 # CONFIG_DAB is not set
 
 #
@@ -453,21 +480,17 @@ CONFIG_SSB_POSSIBLE=y
 # Display device support
 #
 # CONFIG_DISPLAY_SUPPORT is not set
-
-#
-# Sound
-#
 # CONFIG_SOUND is not set
 # CONFIG_USB_SUPPORT is not set
 # CONFIG_MMC is not set
 # CONFIG_MEMSTICK is not set
 # CONFIG_NEW_LEDS is not set
+# CONFIG_ACCESSIBILITY is not set
 # CONFIG_RTC_CLASS is not set
-
-#
-# Userspace I/O
-#
+# CONFIG_DMADEVICES is not set
+# CONFIG_AUXDISPLAY is not set
 # CONFIG_UIO is not set
+# CONFIG_STAGING is not set
 
 #
 # File systems
@@ -481,20 +504,23 @@ CONFIG_INOTIFY_USER=y
 # CONFIG_FUSE_FS is not set
 
 #
+# Caches
+#
+# CONFIG_FSCACHE is not set
+
+#
 # Pseudo filesystems
 #
 CONFIG_PROC_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_PROC_SYSCTL=y
+# CONFIG_PROC_PAGE_MONITOR is not set
 CONFIG_SYSFS=y
 CONFIG_TMPFS=y
 # CONFIG_TMPFS_POSIX_ACL is not set
 # CONFIG_HUGETLB_PAGE is not set
 # CONFIG_CONFIGFS_FS is not set
-
-#
-# Miscellaneous filesystems
-#
+CONFIG_MISC_FILESYSTEMS=y
 CONFIG_JFFS2_FS=y
 CONFIG_JFFS2_FS_DEBUG=0
 CONFIG_JFFS2_FS_WRITEBUFFER=y
@@ -506,19 +532,17 @@ CONFIG_JFFS2_ZLIB=y
 # CONFIG_JFFS2_LZO is not set
 CONFIG_JFFS2_RTIME=y
 # CONFIG_JFFS2_RUBIN is not set
+# CONFIG_ROMFS_FS is not set
 CONFIG_NETWORK_FILESYSTEMS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
 # CONFIG_NFS_V3_ACL is not set
 # CONFIG_NFS_V4 is not set
-# CONFIG_NFS_DIRECTIO is not set
-# CONFIG_NFSD is not set
 CONFIG_ROOT_NFS=y
 CONFIG_LOCKD=y
 CONFIG_LOCKD_V4=y
 CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
-# CONFIG_SUNRPC_BIND34 is not set
 # CONFIG_RPCSEC_GSS_KRB5 is not set
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
 # CONFIG_SMB_FS is not set
@@ -535,12 +559,16 @@ CONFIG_SUNRPC=y
 # CONFIG_PRINTK_TIME is not set
 CONFIG_ENABLE_WARN_DEPRECATED=y
 CONFIG_ENABLE_MUST_CHECK=y
+CONFIG_FRAME_WARN=1024
 CONFIG_MAGIC_SYSRQ=y
 # CONFIG_UNUSED_SYMBOLS is not set
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_DEBUG_MEMORY_INIT is not set
+# CONFIG_RCU_CPU_STALL_DETECTOR is not set
+# CONFIG_SYSCTL_SYSCALL_CHECK is not set
 # CONFIG_SAMPLES is not set
 
 #
@@ -548,26 +576,26 @@ CONFIG_MAGIC_SYSRQ=y
 #
 # CONFIG_KEYS is not set
 # CONFIG_SECURITY is not set
+# CONFIG_SECURITYFS is not set
 # CONFIG_SECURITY_FILE_CAPABILITIES is not set
 # CONFIG_CRYPTO is not set
+# CONFIG_BINARY_PRINTF is not set
 
 #
 # Library routines
 #
 CONFIG_BITREVERSE=y
+CONFIG_GENERIC_FIND_LAST_BIT=y
 # CONFIG_CRC_CCITT is not set
 # CONFIG_CRC16 is not set
+# CONFIG_CRC_T10DIF is not set
 # CONFIG_CRC_ITU_T is not set
 CONFIG_CRC32=y
 # CONFIG_CRC7 is not set
 # CONFIG_LIBCRC32C is not set
 CONFIG_ZLIB_INFLATE=y
 CONFIG_ZLIB_DEFLATE=y
-CONFIG_PLIST=y
 CONFIG_HAS_IOMEM=y
 CONFIG_HAS_IOPORT=y
 CONFIG_HAS_DMA=y
