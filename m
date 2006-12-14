From: akpm@osdl.org
Subject: + m32r-update-defconfig-files-for-v2619.patch added to -mm tree
Date: Thu, 14 Dec 2006 13:11:43 -0800
Message-ID: <200612142111.kBELBheF026063@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58794 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932916AbWLNVMV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 16:12:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: takata@linux-m32r.org


The patch titled
     m32r: update defconfig files for v2.6.19
has been added to the -mm tree.  Its filename is
     m32r-update-defconfig-files-for-v2619.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m32r: update defconfig files for v2.6.19
From: Hirokazu Takata <takata@linux-m32r.org>

This patch upgrades defconfig files for all m32r platforms.

Signed-off-by: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/m32r/defconfig                       |  525 ++++++++---
 arch/m32r/m32104ut/defconfig.m32104ut     |  756 ++++++++++++++---
 arch/m32r/m32700ut/defconfig.m32700ut.smp |  519 ++++++++---
 arch/m32r/m32700ut/defconfig.m32700ut.up  |  516 ++++++++---
 arch/m32r/mappi/defconfig.nommu           |  366 +++++---
 arch/m32r/mappi/defconfig.smp             |  382 ++++++--
 arch/m32r/mappi/defconfig.up              |  380 ++++++--
 arch/m32r/mappi2/defconfig.opsp           |  883 ++++++++++++++++++++
 arch/m32r/mappi2/defconfig.vdec2          |  388 ++++++--
 arch/m32r/mappi3/defconfig.smp            |  373 +++++---
 arch/m32r/oaks32r/defconfig.nommu         |  348 +++++--
 arch/m32r/opsput/defconfig.opsput         |  383 ++++++--
 12 files changed, 4435 insertions(+), 1384 deletions(-)

diff -puN arch/m32r/defconfig~m32r-update-defconfig-files-for-v2619 arch/m32r/defconfig
--- a/arch/m32r/defconfig~m32r-update-defconfig-files-for-v2619
+++ a/arch/m32r/defconfig
@@ -1,20 +1,18 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.12-rc5
-# Fri Jun  3 16:20:11 2005
+# Linux kernel version: 2.6.19
+# Tue Dec 12 17:52:38 2006
 #
 CONFIG_M32R=y
-# CONFIG_UID16 is not set
 CONFIG_GENERIC_ISA_DMA=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
 # Code maturity level options
 #
 CONFIG_EXPERIMENTAL=y
-CONFIG_CLEAN_COMPILE=y
-CONFIG_BROKEN_ON_SMP=y
 CONFIG_LOCK_KERNEL=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
 
@@ -22,32 +20,40 @@ CONFIG_INIT_ENV_ARG_LIMIT=32
 # General setup
 #
 CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SWAP=y
 CONFIG_SYSVIPC=y
+# CONFIG_IPC_NS is not set
 # CONFIG_POSIX_MQUEUE is not set
 CONFIG_BSD_PROCESS_ACCT=y
 # CONFIG_BSD_PROCESS_ACCT_V3 is not set
-CONFIG_SYSCTL=y
+# CONFIG_TASKSTATS is not set
+# CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
-CONFIG_HOTPLUG=y
-CONFIG_KOBJECT_UEVENT=y
 CONFIG_IKCONFIG=y
-# CONFIG_IKCONFIG_PROC is not set
+CONFIG_IKCONFIG_PROC=y
+# CONFIG_CPUSETS is not set
+CONFIG_SYSFS_DEPRECATED=y
+# CONFIG_RELAY is not set
+CONFIG_INITRAMFS_SOURCE=""
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
 CONFIG_EMBEDDED=y
+CONFIG_SYSCTL_SYSCALL=y
 # CONFIG_KALLSYMS is not set
+CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
+CONFIG_ELF_CORE=y
 CONFIG_BASE_FULL=y
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SHMEM=y
-CONFIG_CC_ALIGN_FUNCTIONS=0
-CONFIG_CC_ALIGN_LABELS=0
-CONFIG_CC_ALIGN_LOOPS=0
-CONFIG_CC_ALIGN_JUMPS=0
+CONFIG_SLAB=y
+CONFIG_VM_EVENT_COUNTERS=y
 # CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=0
+# CONFIG_SLOB is not set
 
 #
 # Loadable module support
@@ -55,10 +61,29 @@ CONFIG_BASE_SMALL=0
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
-CONFIG_OBSOLETE_MODPARM=y
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_KMOD=y
+CONFIG_STOP_MACHINE=y
+
+#
+# Block layer
+#
+CONFIG_BLOCK=y
+# CONFIG_BLK_DEV_IO_TRACE is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+# CONFIG_IOSCHED_AS is not set
+CONFIG_IOSCHED_DEADLINE=y
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_AS is not set
+# CONFIG_DEFAULT_DEADLINE is not set
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
 
 #
 # Processor type and features
@@ -70,8 +95,10 @@ CONFIG_PLAT_M32700UT=y
 # CONFIG_PLAT_OAKS32R is not set
 # CONFIG_PLAT_MAPPI2 is not set
 # CONFIG_PLAT_MAPPI3 is not set
+# CONFIG_PLAT_M32104UT is not set
 CONFIG_CHIP_M32700=y
 # CONFIG_CHIP_M32102 is not set
+# CONFIG_CHIP_M32104 is not set
 # CONFIG_CHIP_VDEC2 is not set
 # CONFIG_CHIP_OPSP is not set
 CONFIG_MMU=y
@@ -85,34 +112,39 @@ CONFIG_TIMER_DIVIDE=128
 CONFIG_MEMORY_START=0x08000000
 CONFIG_MEMORY_SIZE=0x01000000
 CONFIG_NOHIGHMEM=y
-# CONFIG_DISCONTIGMEM is not set
+CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
+CONFIG_SELECT_MEMORY_MODEL=y
+# CONFIG_FLATMEM_MANUAL is not set
+CONFIG_DISCONTIGMEM_MANUAL=y
+# CONFIG_SPARSEMEM_MANUAL is not set
+CONFIG_DISCONTIGMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+CONFIG_NEED_MULTIPLE_NODES=y
+# CONFIG_SPARSEMEM_STATIC is not set
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
+CONFIG_IRAM_START=0x00f00000
+CONFIG_IRAM_SIZE=0x00080000
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_PREEMPT=y
-# CONFIG_HAVE_DEC_LOCK is not set
-# CONFIG_SMP is not set
+CONFIG_SMP=y
+# CONFIG_CHIP_M32700_TS1 is not set
+CONFIG_NR_CPUS=2
+CONFIG_NODES_SHIFT=1
 
 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
 #
-# CONFIG_PCI is not set
 # CONFIG_ISA is not set
 
 #
 # PCCARD (PCMCIA/CardBus) support
 #
-CONFIG_PCCARD=y
-# CONFIG_PCMCIA_DEBUG is not set
-CONFIG_PCMCIA=y
-
-#
-# PC-card bridges
-#
-# CONFIG_TCIC is not set
-# CONFIG_M32R_PCC is not set
-CONFIG_M32R_CFC=y
-CONFIG_M32R_CFC_NUM=1
+# CONFIG_PCCARD is not set
 
 #
 # PCI Hotplug Support
@@ -125,6 +157,94 @@ CONFIG_BINFMT_ELF=y
 # CONFIG_BINFMT_MISC is not set
 
 #
+# Networking
+#
+CONFIG_NET=y
+
+#
+# Networking options
+#
+# CONFIG_NETDEBUG is not set
+CONFIG_PACKET=y
+# CONFIG_PACKET_MMAP is not set
+CONFIG_UNIX=y
+CONFIG_XFRM=y
+# CONFIG_XFRM_USER is not set
+# CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+# CONFIG_IP_MULTICAST is not set
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+# CONFIG_IP_PNP_BOOTP is not set
+# CONFIG_IP_PNP_RARP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_ARPD is not set
+# CONFIG_SYN_COOKIES is not set
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+CONFIG_INET_XFRM_MODE_TRANSPORT=y
+CONFIG_INET_XFRM_MODE_TUNNEL=y
+CONFIG_INET_XFRM_MODE_BEET=y
+CONFIG_INET_DIAG=y
+CONFIG_INET_TCP_DIAG=y
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_INET6_XFRM_TUNNEL is not set
+# CONFIG_INET6_TUNNEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+
+#
+# DCCP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_DCCP is not set
+
+#
+# SCTP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_SCTP is not set
+
+#
+# TIPC Configuration (EXPERIMENTAL)
+#
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+
+#
+# QoS and/or fair queueing
+#
+# CONFIG_NET_SCHED is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_IEEE80211 is not set
+
+#
 # Device Drivers
 #
 
@@ -133,12 +253,100 @@ CONFIG_BINFMT_ELF=y
 #
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
-# CONFIG_FW_LOADER is not set
+CONFIG_FW_LOADER=y
+# CONFIG_SYS_HYPERVISOR is not set
+
+#
+# Connector - unified userspace <-> kernelspace linker
+#
+# CONFIG_CONNECTOR is not set
 
 #
 # Memory Technology Devices (MTD)
 #
-# CONFIG_MTD is not set
+CONFIG_MTD=y
+# CONFIG_MTD_DEBUG is not set
+# CONFIG_MTD_CONCAT is not set
+CONFIG_MTD_PARTITIONS=y
+CONFIG_MTD_REDBOOT_PARTS=y
+CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
+# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
+# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
+# CONFIG_MTD_CMDLINE_PARTS is not set
+
+#
+# User Modules And Translation Layers
+#
+# CONFIG_MTD_CHAR is not set
+CONFIG_MTD_BLOCK=y
+# CONFIG_FTL is not set
+# CONFIG_NFTL is not set
+# CONFIG_INFTL is not set
+# CONFIG_RFD_FTL is not set
+# CONFIG_SSFDC is not set
+
+#
+# RAM/ROM/Flash chip drivers
+#
+CONFIG_MTD_CFI=m
+CONFIG_MTD_JEDECPROBE=m
+CONFIG_MTD_GEN_PROBE=m
+CONFIG_MTD_CFI_ADV_OPTIONS=y
+# CONFIG_MTD_CFI_NOSWAP is not set
+CONFIG_MTD_CFI_BE_BYTE_SWAP=y
+# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
+CONFIG_MTD_CFI_GEOMETRY=y
+CONFIG_MTD_MAP_BANK_WIDTH_1=y
+CONFIG_MTD_MAP_BANK_WIDTH_2=y
+CONFIG_MTD_MAP_BANK_WIDTH_4=y
+# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
+CONFIG_MTD_CFI_I1=y
+# CONFIG_MTD_CFI_I2 is not set
+# CONFIG_MTD_CFI_I4 is not set
+# CONFIG_MTD_CFI_I8 is not set
+# CONFIG_MTD_OTP is not set
+# CONFIG_MTD_CFI_INTELEXT is not set
+CONFIG_MTD_CFI_AMDSTD=m
+# CONFIG_MTD_CFI_STAA is not set
+CONFIG_MTD_CFI_UTIL=m
+# CONFIG_MTD_RAM is not set
+# CONFIG_MTD_ROM is not set
+# CONFIG_MTD_ABSENT is not set
+# CONFIG_MTD_OBSOLETE_CHIPS is not set
+
+#
+# Mapping drivers for chip access
+#
+# CONFIG_MTD_COMPLEX_MAPPINGS is not set
+# CONFIG_MTD_PHYSMAP is not set
+# CONFIG_MTD_PLATRAM is not set
+
+#
+# Self-contained MTD device drivers
+#
+# CONFIG_MTD_SLRAM is not set
+# CONFIG_MTD_PHRAM is not set
+# CONFIG_MTD_MTDRAM is not set
+# CONFIG_MTD_BLOCK2MTD is not set
+
+#
+# Disk-On-Chip Device Drivers
+#
+# CONFIG_MTD_DOC2000 is not set
+# CONFIG_MTD_DOC2001 is not set
+# CONFIG_MTD_DOC2001PLUS is not set
+
+#
+# NAND Flash Device Drivers
+#
+# CONFIG_MTD_NAND is not set
+
+#
+# OneNAND Flash Device Drivers
+#
+# CONFIG_MTD_ONENAND is not set
 
 #
 # Parallel port support
@@ -152,7 +360,6 @@ CONFIG_PREVENT_FIRMWARE_BUILD=y
 #
 # Block devices
 #
-# CONFIG_BLK_DEV_FD is not set
 # CONFIG_BLK_DEV_COW_COMMON is not set
 CONFIG_BLK_DEV_LOOP=y
 # CONFIG_BLK_DEV_CRYPTOLOOP is not set
@@ -160,23 +367,21 @@ CONFIG_BLK_DEV_NBD=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 # CONFIG_BLK_DEV_INITRD is not set
-CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CDROM_PKTCDVD is not set
+CONFIG_ATA_OVER_ETH=m
 
 #
-# IO Schedulers
+# Misc devices
 #
-CONFIG_IOSCHED_NOOP=y
-# CONFIG_IOSCHED_AS is not set
-CONFIG_IOSCHED_DEADLINE=y
-CONFIG_IOSCHED_CFQ=y
-# CONFIG_ATA_OVER_ETH is not set
+# CONFIG_TIFM_CORE is not set
 
 #
 # ATA/ATAPI/MFM/RLL support
 #
 CONFIG_IDE=y
+CONFIG_IDE_MAX_HWIFS=4
 CONFIG_BLK_DEV_IDE=y
 
 #
@@ -185,7 +390,6 @@ CONFIG_BLK_DEV_IDE=y
 # CONFIG_BLK_DEV_IDE_SATA is not set
 CONFIG_BLK_DEV_IDEDISK=y
 # CONFIG_IDEDISK_MULTI_MODE is not set
-CONFIG_BLK_DEV_IDECS=y
 CONFIG_BLK_DEV_IDECD=m
 # CONFIG_BLK_DEV_IDETAPE is not set
 # CONFIG_BLK_DEV_IDEFLOPPY is not set
@@ -204,7 +408,9 @@ CONFIG_IDE_GENERIC=y
 #
 # SCSI device support
 #
+# CONFIG_RAID_ATTRS is not set
 CONFIG_SCSI=m
+# CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
 #
@@ -216,6 +422,7 @@ CONFIG_BLK_DEV_SD=m
 CONFIG_BLK_DEV_SR=m
 # CONFIG_BLK_DEV_SR_VENDOR is not set
 CONFIG_CHR_DEV_SG=m
+# CONFIG_CHR_DEV_SCH is not set
 
 #
 # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
@@ -225,26 +432,23 @@ CONFIG_SCSI_MULTI_LUN=y
 # CONFIG_SCSI_LOGGING is not set
 
 #
-# SCSI Transport Attributes
+# SCSI Transports
 #
 # CONFIG_SCSI_SPI_ATTRS is not set
 # CONFIG_SCSI_FC_ATTRS is not set
 # CONFIG_SCSI_ISCSI_ATTRS is not set
+# CONFIG_SCSI_SAS_ATTRS is not set
+# CONFIG_SCSI_SAS_LIBSAS is not set
 
 #
 # SCSI low-level drivers
 #
-# CONFIG_SCSI_SATA is not set
+# CONFIG_ISCSI_TCP is not set
 # CONFIG_SCSI_DEBUG is not set
 
 #
-# PCMCIA SCSI adapter support
+# Serial ATA (prod) and Parallel ATA (experimental) drivers
 #
-# CONFIG_PCMCIA_AHA152X is not set
-# CONFIG_PCMCIA_FDOMAIN is not set
-# CONFIG_PCMCIA_NINJA_SCSI is not set
-# CONFIG_PCMCIA_QLOGIC is not set
-# CONFIG_PCMCIA_SYM53C500 is not set
 
 #
 # Multi-device support (RAID and LVM)
@@ -254,6 +458,7 @@ CONFIG_SCSI_MULTI_LUN=y
 #
 # Fusion MPT device support
 #
+# CONFIG_FUSION is not set
 
 #
 # IEEE 1394 (FireWire) support
@@ -264,69 +469,8 @@ CONFIG_SCSI_MULTI_LUN=y
 #
 
 #
-# Networking support
-#
-CONFIG_NET=y
-
-#
-# Networking options
-#
-CONFIG_PACKET=y
-# CONFIG_PACKET_MMAP is not set
-CONFIG_UNIX=y
-# CONFIG_NET_KEY is not set
-CONFIG_INET=y
-# CONFIG_IP_MULTICAST is not set
-# CONFIG_IP_ADVANCED_ROUTER is not set
-CONFIG_IP_PNP=y
-CONFIG_IP_PNP_DHCP=y
-# CONFIG_IP_PNP_BOOTP is not set
-# CONFIG_IP_PNP_RARP is not set
-# CONFIG_NET_IPIP is not set
-# CONFIG_NET_IPGRE is not set
-# CONFIG_ARPD is not set
-# CONFIG_SYN_COOKIES is not set
-# CONFIG_INET_AH is not set
-# CONFIG_INET_ESP is not set
-# CONFIG_INET_IPCOMP is not set
-# CONFIG_INET_TUNNEL is not set
-CONFIG_IP_TCPDIAG=y
-# CONFIG_IP_TCPDIAG_IPV6 is not set
-# CONFIG_IPV6 is not set
-# CONFIG_NETFILTER is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
-#
-# CONFIG_IP_SCTP is not set
-# CONFIG_ATM is not set
-# CONFIG_BRIDGE is not set
-# CONFIG_VLAN_8021Q is not set
-# CONFIG_DECNET is not set
-# CONFIG_LLC2 is not set
-# CONFIG_IPX is not set
-# CONFIG_ATALK is not set
-# CONFIG_X25 is not set
-# CONFIG_LAPB is not set
-# CONFIG_NET_DIVERT is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
-# CONFIG_NET_SCHED is not set
-# CONFIG_NET_CLS_ROUTE is not set
-
-#
-# Network testing
+# Network device support
 #
-# CONFIG_NET_PKTGEN is not set
-# CONFIG_NETPOLL is not set
-# CONFIG_NET_POLL_CONTROLLER is not set
-# CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
-# CONFIG_BT is not set
 CONFIG_NETDEVICES=y
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
@@ -334,6 +478,11 @@ CONFIG_NETDEVICES=y
 # CONFIG_TUN is not set
 
 #
+# PHY device support
+#
+# CONFIG_PHYLIB is not set
+
+#
 # Ethernet (10 or 100Mbit)
 #
 CONFIG_NET_ETHERNET=y
@@ -359,11 +508,6 @@ CONFIG_SMC91X=y
 # CONFIG_NET_RADIO is not set
 
 #
-# PCMCIA network device support
-#
-# CONFIG_NET_PCMCIA is not set
-
-#
 # Wan interfaces
 #
 # CONFIG_WAN is not set
@@ -371,6 +515,8 @@ CONFIG_SMC91X=y
 # CONFIG_SLIP is not set
 # CONFIG_SHAPER is not set
 # CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
 
 #
 # ISDN subsystem
@@ -386,6 +532,7 @@ CONFIG_SMC91X=y
 # Input device support
 #
 CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set
 
 #
 # Userland interfaces
@@ -414,7 +561,6 @@ CONFIG_SERIO_SERPORT=y
 # CONFIG_SERIO_LIBPS2 is not set
 # CONFIG_SERIO_RAW is not set
 # CONFIG_GAMEPORT is not set
-CONFIG_SOUND_GAMEPORT=y
 
 #
 # Character devices
@@ -422,6 +568,7 @@ CONFIG_SOUND_GAMEPORT=y
 CONFIG_VT=y
 CONFIG_VT_CONSOLE=y
 CONFIG_HW_CONSOLE=y
+# CONFIG_VT_HW_CONSOLE_BINDING is not set
 # CONFIG_SERIAL_NONSTANDARD is not set
 
 #
@@ -450,8 +597,8 @@ CONFIG_LEGACY_PTY_COUNT=256
 # Watchdog Cards
 #
 # CONFIG_WATCHDOG is not set
+CONFIG_HW_RANDOM=y
 # CONFIG_RTC is not set
-# CONFIG_GEN_RTC is not set
 CONFIG_DS1302=y
 # CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
@@ -459,17 +606,12 @@ CONFIG_DS1302=y
 #
 # Ftape, the floppy tape device driver
 #
-# CONFIG_DRM is not set
-
-#
-# PCMCIA character devices
-#
-# CONFIG_SYNCLINK_CS is not set
 # CONFIG_RAW_DRIVER is not set
 
 #
 # TPM devices
 #
+# CONFIG_TCG_TPM is not set
 
 #
 # I2C support
@@ -477,34 +619,51 @@ CONFIG_DS1302=y
 # CONFIG_I2C is not set
 
 #
+# SPI support
+#
+# CONFIG_SPI is not set
+# CONFIG_SPI_MASTER is not set
+
+#
 # Dallas's 1-wire bus
 #
 # CONFIG_W1 is not set
 
 #
-# Misc devices
+# Hardware Monitoring support
 #
+CONFIG_HWMON=y
+# CONFIG_HWMON_VID is not set
+# CONFIG_SENSORS_ABITUGURU is not set
+# CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_VT1211 is not set
+# CONFIG_HWMON_DEBUG_CHIP is not set
 
 #
 # Multimedia devices
 #
-CONFIG_VIDEO_DEV=y
+CONFIG_VIDEO_DEV=m
+CONFIG_VIDEO_V4L1=y
+CONFIG_VIDEO_V4L1_COMPAT=y
+CONFIG_VIDEO_V4L2=y
 
 #
-# Video For Linux
+# Video Capture Adapters
 #
 
 #
-# Video Adapters
+# Video Capture Adapters
 #
+# CONFIG_VIDEO_ADV_DEBUG is not set
+CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
+# CONFIG_VIDEO_VIVI is not set
 # CONFIG_VIDEO_CPIA is not set
-CONFIG_VIDEO_M32R_AR=y
-CONFIG_VIDEO_M32R_AR_M64278=y
+CONFIG_VIDEO_M32R_AR=m
+CONFIG_VIDEO_M32R_AR_M64278=m
 
 #
 # Radio Adapters
 #
-# CONFIG_RADIO_MAESTRO is not set
 
 #
 # Digital Video Broadcasting Devices
@@ -514,15 +673,16 @@ CONFIG_VIDEO_M32R_AR_M64278=y
 #
 # Graphics support
 #
+CONFIG_FIRMWARE_EDID=y
 CONFIG_FB=y
-# CONFIG_FB_CFB_FILLRECT is not set
-# CONFIG_FB_CFB_COPYAREA is not set
-# CONFIG_FB_CFB_IMAGEBLIT is not set
-# CONFIG_FB_SOFT_CURSOR is not set
+CONFIG_FB_CFB_FILLRECT=y
+CONFIG_FB_CFB_COPYAREA=y
+CONFIG_FB_CFB_IMAGEBLIT=y
 # CONFIG_FB_MACMODES is not set
+# CONFIG_FB_BACKLIGHT is not set
 # CONFIG_FB_MODE_HELPERS is not set
 # CONFIG_FB_TILEBLITTING is not set
-# CONFIG_FB_S1D13XXX is not set
+CONFIG_FB_S1D13XXX=y
 # CONFIG_FB_VIRTUAL is not set
 
 #
@@ -531,6 +691,7 @@ CONFIG_FB=y
 # CONFIG_VGA_CONSOLE is not set
 CONFIG_DUMMY_CONSOLE=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
+# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
 # CONFIG_FONTS is not set
 CONFIG_FONT_8x8=y
 CONFIG_FONT_8x16=y
@@ -542,6 +703,7 @@ CONFIG_LOGO=y
 CONFIG_LOGO_LINUX_MONO=y
 CONFIG_LOGO_LINUX_VGA16=y
 CONFIG_LOGO_LINUX_CLUT224=y
+CONFIG_LOGO_M32R_CLUT224=y
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
@@ -554,6 +716,11 @@ CONFIG_LOGO_LINUX_CLUT224=y
 #
 # CONFIG_USB_ARCH_HAS_HCD is not set
 # CONFIG_USB_ARCH_HAS_OHCI is not set
+# CONFIG_USB_ARCH_HAS_EHCI is not set
+
+#
+# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+#
 
 #
 # USB Gadget Support
@@ -563,23 +730,62 @@ CONFIG_LOGO_LINUX_CLUT224=y
 #
 # MMC/SD Card support
 #
-# CONFIG_MMC is not set
+CONFIG_MMC=y
+CONFIG_MMC_DEBUG=y
+CONFIG_MMC_BLOCK=y
+# CONFIG_MMC_TIFM_SD is not set
+
+#
+# LED devices
+#
+# CONFIG_NEW_LEDS is not set
+
+#
+# LED drivers
+#
+
+#
+# LED Triggers
+#
 
 #
 # InfiniBand support
 #
-# CONFIG_INFINIBAND is not set
+
+#
+# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
+#
+
+#
+# Real Time Clock
+#
+# CONFIG_RTC_CLASS is not set
+
+#
+# DMA Engine support
+#
+# CONFIG_DMA_ENGINE is not set
+
+#
+# DMA Clients
+#
+
+#
+# DMA Devices
+#
 
 #
 # File systems
 #
 CONFIG_EXT2_FS=y
 # CONFIG_EXT2_FS_XATTR is not set
-CONFIG_EXT3_FS=m
+# CONFIG_EXT2_FS_XIP is not set
+CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_XATTR=y
 # CONFIG_EXT3_FS_POSIX_ACL is not set
 # CONFIG_EXT3_FS_SECURITY is not set
-CONFIG_JBD=m
+# CONFIG_EXT4DEV_FS is not set
+CONFIG_JBD=y
 CONFIG_JBD_DEBUG=y
 CONFIG_FS_MBCACHE=y
 CONFIG_REISERFS_FS=m
@@ -587,17 +793,19 @@ CONFIG_REISERFS_FS=m
 # CONFIG_REISERFS_PROC_INFO is not set
 # CONFIG_REISERFS_FS_XATTR is not set
 # CONFIG_JFS_FS is not set
-
-#
-# XFS support
-#
+# CONFIG_FS_POSIX_ACL is not set
 # CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
 # CONFIG_MINIX_FS is not set
 # CONFIG_ROMFS_FS is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
 CONFIG_DNOTIFY=y
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
 
 #
 # CD-ROM/DVD Filesystems
@@ -623,15 +831,13 @@ CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
 #
 CONFIG_PROC_FS=y
 CONFIG_PROC_KCORE=y
+CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
-CONFIG_DEVFS_FS=y
-CONFIG_DEVFS_MOUNT=y
-# CONFIG_DEVFS_DEBUG is not set
-# CONFIG_DEVPTS_FS_XATTR is not set
 CONFIG_TMPFS=y
-# CONFIG_TMPFS_XATTR is not set
+# CONFIG_TMPFS_POSIX_ACL is not set
 # CONFIG_HUGETLB_PAGE is not set
 CONFIG_RAMFS=y
+# CONFIG_CONFIGFS_FS is not set
 
 #
 # Miscellaneous filesystems
@@ -643,6 +849,8 @@ CONFIG_RAMFS=y
 # CONFIG_BEFS_FS is not set
 # CONFIG_BFS_FS is not set
 # CONFIG_EFS_FS is not set
+# CONFIG_JFFS_FS is not set
+# CONFIG_JFFS2_FS is not set
 # CONFIG_CRAMFS is not set
 # CONFIG_VXFS_FS is not set
 # CONFIG_HPFS_FS is not set
@@ -655,12 +863,14 @@ CONFIG_RAMFS=y
 #
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
 # CONFIG_NFS_V4 is not set
 # CONFIG_NFS_DIRECTIO is not set
 # CONFIG_NFSD is not set
 CONFIG_ROOT_NFS=y
 CONFIG_LOCKD=y
 CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
 # CONFIG_RPCSEC_GSS_KRB5 is not set
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
@@ -669,6 +879,7 @@ CONFIG_SUNRPC=y
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
+# CONFIG_9P_FS is not set
 
 #
 # Partition Types
@@ -723,16 +934,23 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 #
 # Profiling support
 #
-# CONFIG_PROFILING is not set
+CONFIG_PROFILING=y
+CONFIG_OPROFILE=y
 
 #
 # Kernel hacking
 #
 # CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_MUST_CHECK=y
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
 # CONFIG_DEBUG_KERNEL is not set
-CONFIG_LOG_BUF_SHIFT=14
+CONFIG_LOG_BUF_SHIFT=15
 # CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_DEBUG_FS is not set
 # CONFIG_FRAME_POINTER is not set
+# CONFIG_UNWIND_INFO is not set
+# CONFIG_HEADERS_CHECK is not set
 
 #
 # Security options
@@ -746,12 +964,9 @@ CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CRYPTO is not set
 
 #
-# Hardware crypto devices
-#
-
-#
 # Library routines
 #
 # CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
 CONFIG_CRC32=y
 # CONFIG_LIBCRC32C is not set
diff -puN arch/m32r/m32104ut/defconfig.m32104ut~m32r-update-defconfig-files-for-v2619 arch/m32r/m32104ut/defconfig.m32104ut
--- a/arch/m32r/m32104ut/defconfig.m32104ut~m32r-update-defconfig-files-for-v2619
+++ a/arch/m32r/m32104ut/defconfig.m32104ut
@@ -1,20 +1,20 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.14
-# Wed Nov  9 16:04:51 2005
+# Linux kernel version: 2.6.19
+# Wed Dec 13 17:22:20 2006
 #
 CONFIG_M32R=y
-# CONFIG_UID16 is not set
 CONFIG_GENERIC_ISA_DMA=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
 # Code maturity level options
 #
 CONFIG_EXPERIMENTAL=y
-CONFIG_CLEAN_COMPILE=y
 CONFIG_BROKEN_ON_SMP=y
+CONFIG_LOCK_KERNEL=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
 
 #
@@ -22,33 +22,66 @@ CONFIG_INIT_ENV_ARG_LIMIT=32
 #
 CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
+CONFIG_SYSVIPC=y
+# CONFIG_IPC_NS is not set
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
-CONFIG_SYSCTL=y
+# CONFIG_TASKSTATS is not set
+# CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
-CONFIG_HOTPLUG=y
-# CONFIG_KOBJECT_UEVENT is not set
-# CONFIG_IKCONFIG is not set
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_SYSFS_DEPRECATED=y
+# CONFIG_RELAY is not set
 CONFIG_INITRAMFS_SOURCE=""
-CONFIG_EMBEDDED=y
-# CONFIG_KALLSYMS is not set
+CONFIG_CC_OPTIMIZE_FOR_SIZE=y
+CONFIG_SYSCTL=y
+# CONFIG_EMBEDDED is not set
+CONFIG_SYSCTL_SYSCALL=y
+CONFIG_KALLSYMS=y
+# CONFIG_KALLSYMS_EXTRA_PASS is not set
+CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
+CONFIG_ELF_CORE=y
 CONFIG_BASE_FULL=y
-# CONFIG_FUTEX is not set
-# CONFIG_EPOLL is not set
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_CC_ALIGN_FUNCTIONS=0
-CONFIG_CC_ALIGN_LABELS=0
-CONFIG_CC_ALIGN_LOOPS=0
-CONFIG_CC_ALIGN_JUMPS=0
+CONFIG_FUTEX=y
+CONFIG_EPOLL=y
+CONFIG_SLAB=y
+CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_RT_MUTEXES=y
 CONFIG_TINY_SHMEM=y
 CONFIG_BASE_SMALL=0
+# CONFIG_SLOB is not set
 
 #
 # Loadable module support
 #
-# CONFIG_MODULES is not set
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+CONFIG_MODULE_FORCE_UNLOAD=y
+# CONFIG_MODVERSIONS is not set
+# CONFIG_MODULE_SRCVERSION_ALL is not set
+CONFIG_KMOD=y
+
+#
+# Block layer
+#
+CONFIG_BLOCK=y
+# CONFIG_BLK_DEV_IO_TRACE is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+CONFIG_IOSCHED_AS=y
+CONFIG_IOSCHED_DEADLINE=y
+CONFIG_IOSCHED_CFQ=y
+CONFIG_DEFAULT_AS=y
+# CONFIG_DEFAULT_DEADLINE is not set
+# CONFIG_DEFAULT_CFQ is not set
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="anticipatory"
 
 #
 # Processor type and features
@@ -70,40 +103,40 @@ CONFIG_ISA_M32R=y
 CONFIG_BUS_CLOCK=54000000
 CONFIG_TIMER_DIVIDE=128
 # CONFIG_CPU_LITTLE_ENDIAN is not set
-CONFIG_MEMORY_START=04000000
-CONFIG_MEMORY_SIZE=01000000
+CONFIG_MEMORY_START=0x04000000
+CONFIG_MEMORY_SIZE=0x01000000
 CONFIG_NOHIGHMEM=y
-# CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
+CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
 CONFIG_SELECT_MEMORY_MODEL=y
-CONFIG_FLATMEM_MANUAL=y
-# CONFIG_DISCONTIGMEM_MANUAL is not set
+# CONFIG_FLATMEM_MANUAL is not set
+CONFIG_DISCONTIGMEM_MANUAL=y
 # CONFIG_SPARSEMEM_MANUAL is not set
-CONFIG_FLATMEM=y
+CONFIG_DISCONTIGMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
+CONFIG_NEED_MULTIPLE_NODES=y
 # CONFIG_SPARSEMEM_STATIC is not set
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
+CONFIG_IRAM_START=0x00700000
+CONFIG_IRAM_SIZE=0x00010000
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
-# CONFIG_PREEMPT is not set
+CONFIG_PREEMPT=y
 # CONFIG_SMP is not set
+CONFIG_NODES_SHIFT=1
 
 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
 #
-# CONFIG_ISA is not set
+CONFIG_ISA=y
 
 #
 # PCCARD (PCMCIA/CardBus) support
 #
-CONFIG_PCCARD=y
-# CONFIG_PCMCIA_DEBUG is not set
-CONFIG_PCMCIA=y
-CONFIG_PCMCIA_LOAD_CIS=y
-CONFIG_PCMCIA_IOCTL=y
-
-#
-# PC-card bridges
-#
+# CONFIG_PCCARD is not set
 
 #
 # PCI Hotplug Support
@@ -112,10 +145,8 @@ CONFIG_PCMCIA_IOCTL=y
 #
 # Executable file formats
 #
-CONFIG_BINFMT_FLAT=y
-# CONFIG_BINFMT_ZFLAT is not set
-# CONFIG_BINFMT_SHARED_FLAT is not set
-# CONFIG_BINFMT_MISC is not set
+# CONFIG_BINFMT_FLAT is not set
+CONFIG_BINFMT_MISC=y
 
 #
 # Networking
@@ -125,17 +156,19 @@ CONFIG_NET=y
 #
 # Networking options
 #
-# CONFIG_PACKET is not set
+# CONFIG_NETDEBUG is not set
+CONFIG_PACKET=y
+# CONFIG_PACKET_MMAP is not set
 CONFIG_UNIX=y
+CONFIG_XFRM=y
+# CONFIG_XFRM_USER is not set
+# CONFIG_XFRM_SUB_POLICY is not set
 # CONFIG_NET_KEY is not set
 CONFIG_INET=y
 # CONFIG_IP_MULTICAST is not set
 # CONFIG_IP_ADVANCED_ROUTER is not set
 CONFIG_IP_FIB_HASH=y
-CONFIG_IP_PNP=y
-CONFIG_IP_PNP_DHCP=y
-# CONFIG_IP_PNP_BOOTP is not set
-# CONFIG_IP_PNP_RARP is not set
+# CONFIG_IP_PNP is not set
 # CONFIG_NET_IPIP is not set
 # CONFIG_NET_IPGRE is not set
 # CONFIG_ARPD is not set
@@ -143,13 +176,87 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_INET_AH is not set
 # CONFIG_INET_ESP is not set
 # CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
 # CONFIG_INET_TUNNEL is not set
+CONFIG_INET_XFRM_MODE_TRANSPORT=y
+CONFIG_INET_XFRM_MODE_TUNNEL=y
+CONFIG_INET_XFRM_MODE_BEET=y
 CONFIG_INET_DIAG=y
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
-CONFIG_TCP_CONG_BIC=y
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+
+#
+# IP: Virtual Server Configuration
+#
+# CONFIG_IP_VS is not set
 # CONFIG_IPV6 is not set
-# CONFIG_NETFILTER is not set
+# CONFIG_INET6_XFRM_TUNNEL is not set
+# CONFIG_INET6_TUNNEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+CONFIG_NETFILTER=y
+# CONFIG_NETFILTER_DEBUG is not set
+
+#
+# Core Netfilter Configuration
+#
+CONFIG_NETFILTER_NETLINK=m
+CONFIG_NETFILTER_NETLINK_QUEUE=m
+CONFIG_NETFILTER_NETLINK_LOG=m
+# CONFIG_NF_CONNTRACK_ENABLED is not set
+CONFIG_NETFILTER_XTABLES=m
+CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
+# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
+CONFIG_NETFILTER_XT_TARGET_MARK=m
+CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
+# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
+CONFIG_NETFILTER_XT_MATCH_COMMENT=m
+CONFIG_NETFILTER_XT_MATCH_DCCP=m
+# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
+# CONFIG_NETFILTER_XT_MATCH_ESP is not set
+CONFIG_NETFILTER_XT_MATCH_LENGTH=m
+CONFIG_NETFILTER_XT_MATCH_LIMIT=m
+CONFIG_NETFILTER_XT_MATCH_MAC=m
+CONFIG_NETFILTER_XT_MATCH_MARK=m
+# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
+# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
+CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
+# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
+CONFIG_NETFILTER_XT_MATCH_REALM=m
+CONFIG_NETFILTER_XT_MATCH_SCTP=m
+# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
+CONFIG_NETFILTER_XT_MATCH_STRING=m
+CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
+# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
+
+#
+# IP: Netfilter Configuration
+#
+CONFIG_IP_NF_QUEUE=m
+CONFIG_IP_NF_IPTABLES=m
+CONFIG_IP_NF_MATCH_IPRANGE=m
+CONFIG_IP_NF_MATCH_TOS=m
+CONFIG_IP_NF_MATCH_RECENT=m
+CONFIG_IP_NF_MATCH_ECN=m
+# CONFIG_IP_NF_MATCH_AH is not set
+CONFIG_IP_NF_MATCH_TTL=m
+CONFIG_IP_NF_MATCH_OWNER=m
+CONFIG_IP_NF_MATCH_ADDRTYPE=m
+CONFIG_IP_NF_FILTER=m
+CONFIG_IP_NF_TARGET_REJECT=m
+CONFIG_IP_NF_TARGET_LOG=m
+CONFIG_IP_NF_TARGET_ULOG=m
+CONFIG_IP_NF_TARGET_TCPMSS=m
+CONFIG_IP_NF_MANGLE=m
+CONFIG_IP_NF_TARGET_TOS=m
+CONFIG_IP_NF_TARGET_ECN=m
+CONFIG_IP_NF_TARGET_TTL=m
+CONFIG_IP_NF_RAW=m
+CONFIG_IP_NF_ARPTABLES=m
+CONFIG_IP_NF_ARPFILTER=m
+CONFIG_IP_NF_ARP_MANGLE=m
 
 #
 # DCCP Configuration (EXPERIMENTAL)
@@ -160,6 +267,11 @@ CONFIG_TCP_CONG_BIC=y
 # SCTP Configuration (EXPERIMENTAL)
 #
 # CONFIG_IP_SCTP is not set
+
+#
+# TIPC Configuration (EXPERIMENTAL)
+#
+# CONFIG_TIPC is not set
 # CONFIG_ATM is not set
 # CONFIG_BRIDGE is not set
 # CONFIG_VLAN_8021Q is not set
@@ -169,11 +281,14 @@ CONFIG_TCP_CONG_BIC=y
 # CONFIG_ATALK is not set
 # CONFIG_X25 is not set
 # CONFIG_LAPB is not set
-# CONFIG_NET_DIVERT is not set
 # CONFIG_ECONET is not set
 # CONFIG_WAN_ROUTER is not set
+
+#
+# QoS and/or fair queueing
+#
 # CONFIG_NET_SCHED is not set
-# CONFIG_NET_CLS_ROUTE is not set
+CONFIG_NET_CLS_ROUTE=y
 
 #
 # Network testing
@@ -193,8 +308,8 @@ CONFIG_TCP_CONG_BIC=y
 #
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
-CONFIG_FW_LOADER=y
-# CONFIG_DEBUG_DRIVER is not set
+# CONFIG_FW_LOADER is not set
+# CONFIG_SYS_HYPERVISOR is not set
 
 #
 # Connector - unified userspace <-> kernelspace linker
@@ -209,11 +324,21 @@ CONFIG_FW_LOADER=y
 #
 # Parallel port support
 #
-# CONFIG_PARPORT is not set
+CONFIG_PARPORT=m
+# CONFIG_PARPORT_GSC is not set
+# CONFIG_PARPORT_AX88796 is not set
+CONFIG_PARPORT_1284=y
 
 #
 # Plug and Play support
 #
+CONFIG_PNP=y
+# CONFIG_PNP_DEBUG is not set
+
+#
+# Protocols
+#
+CONFIG_ISAPNP=y
 
 #
 # Block devices
@@ -221,37 +346,130 @@ CONFIG_FW_LOADER=y
 # CONFIG_BLK_DEV_COW_COMMON is not set
 CONFIG_BLK_DEV_LOOP=y
 # CONFIG_BLK_DEV_CRYPTOLOOP is not set
-CONFIG_BLK_DEV_NBD=y
-CONFIG_BLK_DEV_RAM=y
-CONFIG_BLK_DEV_RAM_COUNT=16
-CONFIG_BLK_DEV_RAM_SIZE=4096
-CONFIG_BLK_DEV_INITRD=y
-# CONFIG_CDROM_PKTCDVD is not set
+CONFIG_BLK_DEV_NBD=m
+# CONFIG_BLK_DEV_RAM is not set
+# CONFIG_BLK_DEV_INITRD is not set
+CONFIG_CDROM_PKTCDVD=m
+CONFIG_CDROM_PKTCDVD_BUFFERS=8
+CONFIG_CDROM_PKTCDVD_WCACHE=y
+# CONFIG_ATA_OVER_ETH is not set
 
 #
-# IO Schedulers
+# Misc devices
 #
-CONFIG_IOSCHED_NOOP=y
-# CONFIG_IOSCHED_AS is not set
-# CONFIG_IOSCHED_DEADLINE is not set
-# CONFIG_IOSCHED_CFQ is not set
-# CONFIG_ATA_OVER_ETH is not set
+# CONFIG_TIFM_CORE is not set
 
 #
 # ATA/ATAPI/MFM/RLL support
 #
-# CONFIG_IDE is not set
+CONFIG_IDE=y
+CONFIG_BLK_DEV_IDE=y
+
+#
+# Please see Documentation/ide.txt for help/info on IDE drives
+#
+# CONFIG_BLK_DEV_IDE_SATA is not set
+CONFIG_BLK_DEV_IDEDISK=y
+# CONFIG_IDEDISK_MULTI_MODE is not set
+CONFIG_BLK_DEV_IDECD=y
+# CONFIG_BLK_DEV_IDETAPE is not set
+# CONFIG_BLK_DEV_IDEFLOPPY is not set
+# CONFIG_BLK_DEV_IDESCSI is not set
+# CONFIG_IDE_TASK_IOCTL is not set
+
+#
+# IDE chipset support/bugfixes
+#
+CONFIG_IDE_GENERIC=y
+# CONFIG_BLK_DEV_IDEPNP is not set
+# CONFIG_IDE_ARM is not set
+# CONFIG_IDE_CHIPSETS is not set
+# CONFIG_BLK_DEV_IDEDMA is not set
+# CONFIG_IDEDMA_AUTO is not set
+# CONFIG_BLK_DEV_HD is not set
 
 #
 # SCSI device support
 #
 # CONFIG_RAID_ATTRS is not set
-# CONFIG_SCSI is not set
+CONFIG_SCSI=y
+# CONFIG_SCSI_NETLINK is not set
+CONFIG_SCSI_PROC_FS=y
+
+#
+# SCSI support type (disk, tape, CD-ROM)
+#
+CONFIG_BLK_DEV_SD=y
+CONFIG_CHR_DEV_ST=m
+# CONFIG_CHR_DEV_OSST is not set
+CONFIG_BLK_DEV_SR=m
+# CONFIG_BLK_DEV_SR_VENDOR is not set
+CONFIG_CHR_DEV_SG=m
+# CONFIG_CHR_DEV_SCH is not set
+
+#
+# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
+#
+CONFIG_SCSI_MULTI_LUN=y
+CONFIG_SCSI_CONSTANTS=y
+# CONFIG_SCSI_LOGGING is not set
+
+#
+# SCSI Transports
+#
+CONFIG_SCSI_SPI_ATTRS=y
+# CONFIG_SCSI_FC_ATTRS is not set
+# CONFIG_SCSI_ISCSI_ATTRS is not set
+# CONFIG_SCSI_SAS_ATTRS is not set
+# CONFIG_SCSI_SAS_LIBSAS is not set
+
+#
+# SCSI low-level drivers
+#
+# CONFIG_ISCSI_TCP is not set
+# CONFIG_SCSI_AHA152X is not set
+# CONFIG_SCSI_AIC7XXX_OLD is not set
+# CONFIG_SCSI_IN2000 is not set
+# CONFIG_SCSI_DTC3280 is not set
+# CONFIG_SCSI_FUTURE_DOMAIN is not set
+# CONFIG_SCSI_GENERIC_NCR5380 is not set
+# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
+# CONFIG_SCSI_NCR53C406A is not set
+# CONFIG_SCSI_PAS16 is not set
+# CONFIG_SCSI_PSI240I is not set
+# CONFIG_SCSI_QLOGIC_FAS is not set
+# CONFIG_SCSI_SYM53C416 is not set
+# CONFIG_SCSI_T128 is not set
+# CONFIG_SCSI_DEBUG is not set
+
+#
+# Serial ATA (prod) and Parallel ATA (experimental) drivers
+#
+
+#
+# Old CD-ROM drivers (not SCSI, not IDE)
+#
+# CONFIG_CD_NO_IDESCSI is not set
 
 #
 # Multi-device support (RAID and LVM)
 #
-# CONFIG_MD is not set
+CONFIG_MD=y
+CONFIG_BLK_DEV_MD=y
+# CONFIG_MD_LINEAR is not set
+# CONFIG_MD_RAID0 is not set
+CONFIG_MD_RAID1=y
+# CONFIG_MD_RAID10 is not set
+# CONFIG_MD_RAID456 is not set
+# CONFIG_MD_MULTIPATH is not set
+# CONFIG_MD_FAULTY is not set
+CONFIG_BLK_DEV_DM=m
+# CONFIG_DM_DEBUG is not set
+CONFIG_DM_CRYPT=m
+CONFIG_DM_SNAPSHOT=m
+# CONFIG_DM_MIRROR is not set
+# CONFIG_DM_ZERO is not set
+# CONFIG_DM_MULTIPATH is not set
 
 #
 # Fusion MPT device support
@@ -270,10 +488,16 @@ CONFIG_IOSCHED_NOOP=y
 # Network device support
 #
 CONFIG_NETDEVICES=y
-CONFIG_DUMMY=y
+CONFIG_DUMMY=m
 # CONFIG_BONDING is not set
 # CONFIG_EQUALIZER is not set
 # CONFIG_TUN is not set
+# CONFIG_NET_SB1000 is not set
+
+#
+# ARCnet devices
+#
+# CONFIG_ARCNET is not set
 
 #
 # PHY device support
@@ -285,8 +509,33 @@ CONFIG_DUMMY=y
 #
 CONFIG_NET_ETHERNET=y
 CONFIG_MII=y
-CONFIG_SMC91X=y
-# CONFIG_NE2000 is not set
+CONFIG_NET_VENDOR_3COM=y
+# CONFIG_EL1 is not set
+# CONFIG_EL2 is not set
+# CONFIG_EL16 is not set
+# CONFIG_EL3 is not set
+# CONFIG_NET_VENDOR_SMC is not set
+# CONFIG_SMC91X is not set
+# CONFIG_NET_VENDOR_RACAL is not set
+# CONFIG_AT1700 is not set
+# CONFIG_DEPCA is not set
+# CONFIG_HP100 is not set
+CONFIG_NET_ISA=y
+# CONFIG_E2100 is not set
+# CONFIG_EWRK3 is not set
+# CONFIG_EEXPRESS is not set
+# CONFIG_EEXPRESS_PRO is not set
+# CONFIG_HPLAN_PLUS is not set
+# CONFIG_HPLAN is not set
+# CONFIG_LP486E is not set
+# CONFIG_ETH16I is not set
+CONFIG_NE2000=m
+# CONFIG_SEEQ8005 is not set
+CONFIG_NET_PCI=y
+# CONFIG_AC3200 is not set
+# CONFIG_APRICOT is not set
+# CONFIG_CS89x0 is not set
+# CONFIG_NET_POCKET is not set
 
 #
 # Ethernet (1000 Mbit)
@@ -299,6 +548,7 @@ CONFIG_SMC91X=y
 #
 # Token Ring devices
 #
+# CONFIG_TR is not set
 
 #
 # Wireless LAN (non-hamradio)
@@ -306,14 +556,10 @@ CONFIG_SMC91X=y
 # CONFIG_NET_RADIO is not set
 
 #
-# PCMCIA network device support
-#
-# CONFIG_NET_PCMCIA is not set
-
-#
 # Wan interfaces
 #
 # CONFIG_WAN is not set
+# CONFIG_PLIP is not set
 # CONFIG_PPP is not set
 # CONFIG_SLIP is not set
 # CONFIG_SHAPER is not set
@@ -334,35 +580,83 @@ CONFIG_SMC91X=y
 #
 # Input device support
 #
-# CONFIG_INPUT is not set
+CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set
+
+#
+# Userland interfaces
+#
+CONFIG_INPUT_MOUSEDEV=y
+CONFIG_INPUT_MOUSEDEV_PSAUX=y
+CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
+CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
+# CONFIG_INPUT_JOYDEV is not set
+# CONFIG_INPUT_TSDEV is not set
+# CONFIG_INPUT_EVDEV is not set
+# CONFIG_INPUT_EVBUG is not set
+
+#
+# Input Device Drivers
+#
+CONFIG_INPUT_KEYBOARD=y
+CONFIG_KEYBOARD_ATKBD=y
+# CONFIG_KEYBOARD_SUNKBD is not set
+# CONFIG_KEYBOARD_LKKBD is not set
+# CONFIG_KEYBOARD_XTKBD is not set
+# CONFIG_KEYBOARD_NEWTON is not set
+# CONFIG_KEYBOARD_STOWAWAY is not set
+CONFIG_INPUT_MOUSE=y
+CONFIG_MOUSE_PS2=y
+# CONFIG_MOUSE_SERIAL is not set
+# CONFIG_MOUSE_INPORT is not set
+# CONFIG_MOUSE_LOGIBM is not set
+# CONFIG_MOUSE_PC110PAD is not set
+# CONFIG_MOUSE_VSXXXAA is not set
+# CONFIG_INPUT_JOYSTICK is not set
+# CONFIG_INPUT_TOUCHSCREEN is not set
+# CONFIG_INPUT_MISC is not set
 
 #
 # Hardware I/O ports
 #
-# CONFIG_SERIO is not set
+CONFIG_SERIO=y
+CONFIG_SERIO_I8042=y
+CONFIG_SERIO_SERPORT=y
+# CONFIG_SERIO_PARKBD is not set
+CONFIG_SERIO_LIBPS2=y
+# CONFIG_SERIO_RAW is not set
 # CONFIG_GAMEPORT is not set
 
 #
 # Character devices
 #
-# CONFIG_VT is not set
+CONFIG_VT=y
+CONFIG_VT_CONSOLE=y
+CONFIG_HW_CONSOLE=y
+# CONFIG_VT_HW_CONSOLE_BINDING is not set
 # CONFIG_SERIAL_NONSTANDARD is not set
 
 #
 # Serial drivers
 #
-# CONFIG_SERIAL_8250 is not set
+CONFIG_SERIAL_8250=m
+CONFIG_SERIAL_8250_PNP=m
+CONFIG_SERIAL_8250_NR_UARTS=4
+CONFIG_SERIAL_8250_RUNTIME_UARTS=4
+# CONFIG_SERIAL_8250_EXTENDED is not set
 
 #
 # Non-8250 serial port support
 #
 CONFIG_SERIAL_CORE=y
-CONFIG_SERIAL_CORE_CONSOLE=y
 CONFIG_SERIAL_M32R_SIO=y
-CONFIG_SERIAL_M32R_SIO_CONSOLE=y
+# CONFIG_SERIAL_M32R_SIO_CONSOLE is not set
 CONFIG_UNIX98_PTYS=y
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
+# CONFIG_PRINTER is not set
+# CONFIG_PPDEV is not set
+# CONFIG_TIPAR is not set
 
 #
 # IPMI
@@ -372,13 +666,8 @@ CONFIG_LEGACY_PTY_COUNT=256
 #
 # Watchdog Cards
 #
-CONFIG_WATCHDOG=y
-# CONFIG_WATCHDOG_NOWAYOUT is not set
-
-#
-# Watchdog Device Drivers
-#
-CONFIG_SOFT_WATCHDOG=y
+# CONFIG_WATCHDOG is not set
+# CONFIG_HW_RANDOM is not set
 # CONFIG_RTC is not set
 # CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
@@ -386,45 +675,149 @@ CONFIG_SOFT_WATCHDOG=y
 #
 # Ftape, the floppy tape device driver
 #
-
-#
-# PCMCIA character devices
-#
-# CONFIG_SYNCLINK_CS is not set
 # CONFIG_RAW_DRIVER is not set
 
 #
 # TPM devices
 #
+# CONFIG_TCG_TPM is not set
 
 #
 # I2C support
 #
-# CONFIG_I2C is not set
+CONFIG_I2C=m
+CONFIG_I2C_CHARDEV=m
 
 #
-# Dallas's 1-wire bus
+# I2C Algorithms
 #
-# CONFIG_W1 is not set
+CONFIG_I2C_ALGOBIT=m
+CONFIG_I2C_ALGOPCF=m
+# CONFIG_I2C_ALGOPCA is not set
 
 #
-# Hardware Monitoring support
+# I2C Hardware Bus support
 #
-# CONFIG_HWMON is not set
-# CONFIG_HWMON_VID is not set
+CONFIG_I2C_ELEKTOR=m
+CONFIG_I2C_ISA=m
+# CONFIG_I2C_OCORES is not set
+# CONFIG_I2C_PARPORT is not set
+# CONFIG_I2C_PARPORT_LIGHT is not set
+# CONFIG_I2C_STUB is not set
+# CONFIG_I2C_PCA_ISA is not set
 
 #
-# Misc devices
+# Miscellaneous I2C Chip support
+#
+# CONFIG_SENSORS_DS1337 is not set
+# CONFIG_SENSORS_DS1374 is not set
+# CONFIG_SENSORS_EEPROM is not set
+# CONFIG_SENSORS_PCF8574 is not set
+# CONFIG_SENSORS_PCA9539 is not set
+# CONFIG_SENSORS_PCF8591 is not set
+# CONFIG_SENSORS_MAX6875 is not set
+# CONFIG_I2C_DEBUG_CORE is not set
+# CONFIG_I2C_DEBUG_ALGO is not set
+# CONFIG_I2C_DEBUG_BUS is not set
+# CONFIG_I2C_DEBUG_CHIP is not set
+
+#
+# SPI support
+#
+# CONFIG_SPI is not set
+# CONFIG_SPI_MASTER is not set
+
 #
+# Dallas's 1-wire bus
+#
+# CONFIG_W1 is not set
 
 #
-# Multimedia Capabilities Port drivers
+# Hardware Monitoring support
 #
+CONFIG_HWMON=y
+CONFIG_HWMON_VID=m
+# CONFIG_SENSORS_ABITUGURU is not set
+CONFIG_SENSORS_ADM1021=m
+CONFIG_SENSORS_ADM1025=m
+# CONFIG_SENSORS_ADM1026 is not set
+CONFIG_SENSORS_ADM1031=m
+# CONFIG_SENSORS_ADM9240 is not set
+CONFIG_SENSORS_ASB100=m
+# CONFIG_SENSORS_ATXP1 is not set
+CONFIG_SENSORS_DS1621=m
+# CONFIG_SENSORS_F71805F is not set
+CONFIG_SENSORS_FSCHER=m
+# CONFIG_SENSORS_FSCPOS is not set
+CONFIG_SENSORS_GL518SM=m
+# CONFIG_SENSORS_GL520SM is not set
+CONFIG_SENSORS_IT87=m
+# CONFIG_SENSORS_LM63 is not set
+CONFIG_SENSORS_LM75=m
+CONFIG_SENSORS_LM77=m
+CONFIG_SENSORS_LM78=m
+CONFIG_SENSORS_LM80=m
+CONFIG_SENSORS_LM83=m
+CONFIG_SENSORS_LM85=m
+# CONFIG_SENSORS_LM87 is not set
+CONFIG_SENSORS_LM90=m
+# CONFIG_SENSORS_LM92 is not set
+CONFIG_SENSORS_MAX1619=m
+# CONFIG_SENSORS_PC87360 is not set
+CONFIG_SENSORS_SMSC47M1=m
+# CONFIG_SENSORS_SMSC47M192 is not set
+# CONFIG_SENSORS_SMSC47B397 is not set
+# CONFIG_SENSORS_VT1211 is not set
+CONFIG_SENSORS_W83781D=m
+# CONFIG_SENSORS_W83791D is not set
+# CONFIG_SENSORS_W83792D is not set
+CONFIG_SENSORS_W83L785TS=m
+CONFIG_SENSORS_W83627HF=m
+# CONFIG_SENSORS_W83627EHF is not set
+# CONFIG_HWMON_DEBUG_CHIP is not set
 
 #
 # Multimedia devices
 #
-# CONFIG_VIDEO_DEV is not set
+CONFIG_VIDEO_DEV=m
+CONFIG_VIDEO_V4L1=y
+CONFIG_VIDEO_V4L1_COMPAT=y
+CONFIG_VIDEO_V4L2=y
+
+#
+# Video Capture Adapters
+#
+
+#
+# Video Capture Adapters
+#
+# CONFIG_VIDEO_ADV_DEBUG is not set
+CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
+# CONFIG_VIDEO_VIVI is not set
+# CONFIG_VIDEO_PMS is not set
+CONFIG_VIDEO_BWQCAM=m
+CONFIG_VIDEO_CQCAM=m
+# CONFIG_VIDEO_W9966 is not set
+# CONFIG_VIDEO_CPIA is not set
+# CONFIG_VIDEO_SAA5246A is not set
+# CONFIG_VIDEO_SAA5249 is not set
+# CONFIG_TUNER_3036 is not set
+# CONFIG_VIDEO_M32R_AR is not set
+
+#
+# Radio Adapters
+#
+# CONFIG_RADIO_CADET is not set
+# CONFIG_RADIO_RTRACK is not set
+# CONFIG_RADIO_RTRACK2 is not set
+# CONFIG_RADIO_AZTECH is not set
+# CONFIG_RADIO_GEMTEK is not set
+# CONFIG_RADIO_SF16FMI is not set
+# CONFIG_RADIO_SF16FMR2 is not set
+# CONFIG_RADIO_TERRATEC is not set
+# CONFIG_RADIO_TRUST is not set
+# CONFIG_RADIO_TYPHOON is not set
+# CONFIG_RADIO_ZOLTRIX is not set
 
 #
 # Digital Video Broadcasting Devices
@@ -434,9 +827,19 @@ CONFIG_SOFT_WATCHDOG=y
 #
 # Graphics support
 #
+CONFIG_FIRMWARE_EDID=y
 # CONFIG_FB is not set
 
 #
+# Console display driver support
+#
+CONFIG_VGA_CONSOLE=y
+# CONFIG_VGACON_SOFT_SCROLLBACK is not set
+# CONFIG_MDA_CONSOLE is not set
+CONFIG_DUMMY_CONSOLE=y
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+
+#
 # Sound
 #
 # CONFIG_SOUND is not set
@@ -446,6 +849,11 @@ CONFIG_SOFT_WATCHDOG=y
 #
 # CONFIG_USB_ARCH_HAS_HCD is not set
 # CONFIG_USB_ARCH_HAS_OHCI is not set
+# CONFIG_USB_ARCH_HAS_EHCI is not set
+
+#
+# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+#
 
 #
 # USB Gadget Support
@@ -458,33 +866,69 @@ CONFIG_SOFT_WATCHDOG=y
 # CONFIG_MMC is not set
 
 #
+# LED devices
+#
+# CONFIG_NEW_LEDS is not set
+
+#
+# LED drivers
+#
+
+#
+# LED Triggers
+#
+
+#
 # InfiniBand support
 #
 
 #
-# SN Devices
+# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
+#
+
+#
+# Real Time Clock
+#
+# CONFIG_RTC_CLASS is not set
+
+#
+# DMA Engine support
+#
+# CONFIG_DMA_ENGINE is not set
+
+#
+# DMA Clients
+#
+
+#
+# DMA Devices
 #
 
 #
 # File systems
 #
 CONFIG_EXT2_FS=y
-# CONFIG_EXT2_FS_XATTR is not set
-# CONFIG_EXT2_FS_XIP is not set
+CONFIG_EXT2_FS_XATTR=y
+CONFIG_EXT2_FS_POSIX_ACL=y
+CONFIG_EXT2_FS_SECURITY=y
 CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_XATTR=y
 CONFIG_EXT3_FS_POSIX_ACL=y
-# CONFIG_EXT3_FS_SECURITY is not set
+CONFIG_EXT3_FS_SECURITY=y
+# CONFIG_EXT4DEV_FS is not set
 CONFIG_JBD=y
-# CONFIG_JBD_DEBUG is not set
+CONFIG_JBD_DEBUG=y
 CONFIG_FS_MBCACHE=y
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
 CONFIG_FS_POSIX_ACL=y
 # CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
 # CONFIG_MINIX_FS is not set
-# CONFIG_ROMFS_FS is not set
-# CONFIG_INOTIFY is not set
+CONFIG_ROMFS_FS=y
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
 CONFIG_DNOTIFY=y
 # CONFIG_AUTOFS_FS is not set
@@ -494,8 +938,11 @@ CONFIG_DNOTIFY=y
 #
 # CD-ROM/DVD Filesystems
 #
-# CONFIG_ISO9660_FS is not set
-# CONFIG_UDF_FS is not set
+CONFIG_ISO9660_FS=y
+CONFIG_JOLIET=y
+# CONFIG_ZISOFS is not set
+CONFIG_UDF_FS=m
+CONFIG_UDF_NLS=y
 
 #
 # DOS/FAT/NT Filesystems
@@ -503,7 +950,7 @@ CONFIG_DNOTIFY=y
 CONFIG_FAT_FS=y
 CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
-CONFIG_FAT_DEFAULT_CODEPAGE=932
+CONFIG_FAT_DEFAULT_CODEPAGE=437
 CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
 # CONFIG_NTFS_FS is not set
 
@@ -511,11 +958,13 @@ CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
 # Pseudo filesystems
 #
 CONFIG_PROC_FS=y
+CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
 CONFIG_TMPFS=y
+# CONFIG_TMPFS_POSIX_ACL is not set
 # CONFIG_HUGETLB_PAGE is not set
 CONFIG_RAMFS=y
-# CONFIG_RELAYFS_FS is not set
+CONFIG_CONFIGFS_FS=m
 
 #
 # Miscellaneous filesystems
@@ -527,7 +976,7 @@ CONFIG_RAMFS=y
 # CONFIG_BEFS_FS is not set
 # CONFIG_BFS_FS is not set
 # CONFIG_EFS_FS is not set
-CONFIG_CRAMFS=y
+# CONFIG_CRAMFS is not set
 # CONFIG_VXFS_FS is not set
 # CONFIG_HPFS_FS is not set
 # CONFIG_QNX4FS_FS is not set
@@ -542,10 +991,14 @@ CONFIG_NFS_V3=y
 # CONFIG_NFS_V3_ACL is not set
 # CONFIG_NFS_V4 is not set
 # CONFIG_NFS_DIRECTIO is not set
-# CONFIG_NFSD is not set
-CONFIG_ROOT_NFS=y
+CONFIG_NFSD=m
+CONFIG_NFSD_V3=y
+# CONFIG_NFSD_V3_ACL is not set
+# CONFIG_NFSD_V4 is not set
+# CONFIG_NFSD_TCP is not set
 CONFIG_LOCKD=y
 CONFIG_LOCKD_V4=y
+CONFIG_EXPORTFS=m
 CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
 # CONFIG_RPCSEC_GSS_KRB5 is not set
@@ -567,7 +1020,7 @@ CONFIG_MSDOS_PARTITION=y
 # Native Language Support
 #
 CONFIG_NLS=y
-CONFIG_NLS_DEFAULT="iso8859-1"
+CONFIG_NLS_DEFAULT="cp437"
 CONFIG_NLS_CODEPAGE_437=y
 # CONFIG_NLS_CODEPAGE_737 is not set
 # CONFIG_NLS_CODEPAGE_775 is not set
@@ -592,7 +1045,7 @@ CONFIG_NLS_CODEPAGE_932=y
 # CONFIG_NLS_CODEPAGE_1250 is not set
 # CONFIG_NLS_CODEPAGE_1251 is not set
 # CONFIG_NLS_ASCII is not set
-# CONFIG_NLS_ISO8859_1 is not set
+CONFIG_NLS_ISO8859_1=y
 # CONFIG_NLS_ISO8859_2 is not set
 # CONFIG_NLS_ISO8859_3 is not set
 # CONFIG_NLS_ISO8859_4 is not set
@@ -605,32 +1058,28 @@ CONFIG_NLS_CODEPAGE_932=y
 # CONFIG_NLS_ISO8859_15 is not set
 # CONFIG_NLS_KOI8_R is not set
 # CONFIG_NLS_KOI8_U is not set
-CONFIG_NLS_UTF8=y
+# CONFIG_NLS_UTF8 is not set
 
 #
 # Profiling support
 #
-# CONFIG_PROFILING is not set
+CONFIG_PROFILING=y
+CONFIG_OPROFILE=m
 
 #
 # Kernel hacking
 #
 # CONFIG_PRINTK_TIME is not set
-CONFIG_DEBUG_KERNEL=y
-CONFIG_MAGIC_SYSRQ=y
+CONFIG_ENABLE_MUST_CHECK=y
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
+# CONFIG_DEBUG_KERNEL is not set
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_DETECT_SOFTLOCKUP=y
-# CONFIG_SCHEDSTATS is not set
-# CONFIG_DEBUG_SLAB is not set
-# CONFIG_DEBUG_SPINLOCK is not set
-# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
-# CONFIG_DEBUG_KOBJECT is not set
-# CONFIG_DEBUG_BUGVERBOSE is not set
-CONFIG_DEBUG_INFO=y
+CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_FRAME_POINTER is not set
-# CONFIG_DEBUG_STACKOVERFLOW is not set
-# CONFIG_DEBUG_STACK_USAGE is not set
+# CONFIG_UNWIND_INFO is not set
+# CONFIG_HEADERS_CHECK is not set
 
 #
 # Security options
@@ -641,7 +1090,38 @@ CONFIG_DEBUG_INFO=y
 #
 # Cryptographic options
 #
-# CONFIG_CRYPTO is not set
+CONFIG_CRYPTO=y
+CONFIG_CRYPTO_ALGAPI=y
+CONFIG_CRYPTO_BLKCIPHER=m
+CONFIG_CRYPTO_HASH=y
+CONFIG_CRYPTO_MANAGER=y
+CONFIG_CRYPTO_HMAC=y
+CONFIG_CRYPTO_NULL=m
+CONFIG_CRYPTO_MD4=m
+CONFIG_CRYPTO_MD5=m
+CONFIG_CRYPTO_SHA1=m
+CONFIG_CRYPTO_SHA256=m
+CONFIG_CRYPTO_SHA512=m
+CONFIG_CRYPTO_WP512=m
+# CONFIG_CRYPTO_TGR192 is not set
+CONFIG_CRYPTO_ECB=m
+CONFIG_CRYPTO_CBC=m
+CONFIG_CRYPTO_DES=m
+CONFIG_CRYPTO_BLOWFISH=m
+CONFIG_CRYPTO_TWOFISH=m
+CONFIG_CRYPTO_TWOFISH_COMMON=m
+CONFIG_CRYPTO_SERPENT=m
+CONFIG_CRYPTO_AES=m
+# CONFIG_CRYPTO_CAST5 is not set
+# CONFIG_CRYPTO_CAST6 is not set
+# CONFIG_CRYPTO_TEA is not set
+# CONFIG_CRYPTO_ARC4 is not set
+# CONFIG_CRYPTO_KHAZAD is not set
+# CONFIG_CRYPTO_ANUBIS is not set
+# CONFIG_CRYPTO_DEFLATE is not set
+# CONFIG_CRYPTO_MICHAEL_MIC is not set
+CONFIG_CRYPTO_CRC32C=m
+# CONFIG_CRYPTO_TEST is not set
 
 #
 # Hardware crypto devices
@@ -650,8 +1130,12 @@ CONFIG_DEBUG_INFO=y
 #
 # Library routines
 #
-# CONFIG_CRC_CCITT is not set
-# CONFIG_CRC16 is not set
+CONFIG_CRC_CCITT=m
+CONFIG_CRC16=m
 CONFIG_CRC32=y
-CONFIG_LIBCRC32C=y
-CONFIG_ZLIB_INFLATE=y
+CONFIG_LIBCRC32C=m
+CONFIG_TEXTSEARCH=y
+CONFIG_TEXTSEARCH_KMP=m
+CONFIG_TEXTSEARCH_BM=m
+CONFIG_TEXTSEARCH_FSM=m
+CONFIG_PLIST=y
diff -puN arch/m32r/m32700ut/defconfig.m32700ut.smp~m32r-update-defconfig-files-for-v2619 arch/m32r/m32700ut/defconfig.m32700ut.smp
--- a/arch/m32r/m32700ut/defconfig.m32700ut.smp~m32r-update-defconfig-files-for-v2619
+++ a/arch/m32r/m32700ut/defconfig.m32700ut.smp
@@ -1,19 +1,18 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.12-rc5
-# Fri Jun  3 16:20:58 2005
+# Linux kernel version: 2.6.19
+# Tue Dec 12 17:52:38 2006
 #
 CONFIG_M32R=y
-# CONFIG_UID16 is not set
 CONFIG_GENERIC_ISA_DMA=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
 # Code maturity level options
 #
 CONFIG_EXPERIMENTAL=y
-CONFIG_CLEAN_COMPILE=y
 CONFIG_LOCK_KERNEL=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
 
@@ -21,33 +20,40 @@ CONFIG_INIT_ENV_ARG_LIMIT=32
 # General setup
 #
 CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SWAP=y
 CONFIG_SYSVIPC=y
+# CONFIG_IPC_NS is not set
 # CONFIG_POSIX_MQUEUE is not set
 CONFIG_BSD_PROCESS_ACCT=y
 # CONFIG_BSD_PROCESS_ACCT_V3 is not set
-CONFIG_SYSCTL=y
+# CONFIG_TASKSTATS is not set
+# CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
-CONFIG_HOTPLUG=y
-CONFIG_KOBJECT_UEVENT=y
 CONFIG_IKCONFIG=y
-# CONFIG_IKCONFIG_PROC is not set
+CONFIG_IKCONFIG_PROC=y
 # CONFIG_CPUSETS is not set
+CONFIG_SYSFS_DEPRECATED=y
+# CONFIG_RELAY is not set
+CONFIG_INITRAMFS_SOURCE=""
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
 CONFIG_EMBEDDED=y
+CONFIG_SYSCTL_SYSCALL=y
 # CONFIG_KALLSYMS is not set
+CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
+CONFIG_ELF_CORE=y
 CONFIG_BASE_FULL=y
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SHMEM=y
-CONFIG_CC_ALIGN_FUNCTIONS=0
-CONFIG_CC_ALIGN_LABELS=0
-CONFIG_CC_ALIGN_LOOPS=0
-CONFIG_CC_ALIGN_JUMPS=0
+CONFIG_SLAB=y
+CONFIG_VM_EVENT_COUNTERS=y
 # CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=0
+# CONFIG_SLOB is not set
 
 #
 # Loadable module support
@@ -55,13 +61,31 @@ CONFIG_BASE_SMALL=0
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
-CONFIG_OBSOLETE_MODPARM=y
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_KMOD=y
 CONFIG_STOP_MACHINE=y
 
 #
+# Block layer
+#
+CONFIG_BLOCK=y
+# CONFIG_BLK_DEV_IO_TRACE is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+# CONFIG_IOSCHED_AS is not set
+CONFIG_IOSCHED_DEADLINE=y
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_AS is not set
+# CONFIG_DEFAULT_DEADLINE is not set
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
+
+#
 # Processor type and features
 #
 # CONFIG_PLAT_MAPPI is not set
@@ -71,8 +95,10 @@ CONFIG_PLAT_M32700UT=y
 # CONFIG_PLAT_OAKS32R is not set
 # CONFIG_PLAT_MAPPI2 is not set
 # CONFIG_PLAT_MAPPI3 is not set
+# CONFIG_PLAT_M32104UT is not set
 CONFIG_CHIP_M32700=y
 # CONFIG_CHIP_M32102 is not set
+# CONFIG_CHIP_M32104 is not set
 # CONFIG_CHIP_VDEC2 is not set
 # CONFIG_CHIP_OPSP is not set
 CONFIG_MMU=y
@@ -86,37 +112,39 @@ CONFIG_TIMER_DIVIDE=128
 CONFIG_MEMORY_START=0x08000000
 CONFIG_MEMORY_SIZE=0x01000000
 CONFIG_NOHIGHMEM=y
-# CONFIG_DISCONTIGMEM is not set
+CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
+CONFIG_SELECT_MEMORY_MODEL=y
+# CONFIG_FLATMEM_MANUAL is not set
+CONFIG_DISCONTIGMEM_MANUAL=y
+# CONFIG_SPARSEMEM_MANUAL is not set
+CONFIG_DISCONTIGMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+CONFIG_NEED_MULTIPLE_NODES=y
+# CONFIG_SPARSEMEM_STATIC is not set
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
+CONFIG_IRAM_START=0x00f00000
+CONFIG_IRAM_SIZE=0x00080000
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_PREEMPT=y
-# CONFIG_HAVE_DEC_LOCK is not set
 CONFIG_SMP=y
-CONFIG_CHIP_M32700_TS1=y
+# CONFIG_CHIP_M32700_TS1 is not set
 CONFIG_NR_CPUS=2
-# CONFIG_NUMA is not set
+CONFIG_NODES_SHIFT=1
 
 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
 #
-# CONFIG_PCI is not set
 # CONFIG_ISA is not set
 
 #
 # PCCARD (PCMCIA/CardBus) support
 #
-CONFIG_PCCARD=y
-# CONFIG_PCMCIA_DEBUG is not set
-CONFIG_PCMCIA=y
-
-#
-# PC-card bridges
-#
-# CONFIG_TCIC is not set
-# CONFIG_M32R_PCC is not set
-CONFIG_M32R_CFC=y
-CONFIG_M32R_CFC_NUM=1
+# CONFIG_PCCARD is not set
 
 #
 # PCI Hotplug Support
@@ -129,6 +157,94 @@ CONFIG_BINFMT_ELF=y
 # CONFIG_BINFMT_MISC is not set
 
 #
+# Networking
+#
+CONFIG_NET=y
+
+#
+# Networking options
+#
+# CONFIG_NETDEBUG is not set
+CONFIG_PACKET=y
+# CONFIG_PACKET_MMAP is not set
+CONFIG_UNIX=y
+CONFIG_XFRM=y
+# CONFIG_XFRM_USER is not set
+# CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+# CONFIG_IP_MULTICAST is not set
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+# CONFIG_IP_PNP_BOOTP is not set
+# CONFIG_IP_PNP_RARP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_ARPD is not set
+# CONFIG_SYN_COOKIES is not set
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+CONFIG_INET_XFRM_MODE_TRANSPORT=y
+CONFIG_INET_XFRM_MODE_TUNNEL=y
+CONFIG_INET_XFRM_MODE_BEET=y
+CONFIG_INET_DIAG=y
+CONFIG_INET_TCP_DIAG=y
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_INET6_XFRM_TUNNEL is not set
+# CONFIG_INET6_TUNNEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+
+#
+# DCCP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_DCCP is not set
+
+#
+# SCTP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_SCTP is not set
+
+#
+# TIPC Configuration (EXPERIMENTAL)
+#
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+
+#
+# QoS and/or fair queueing
+#
+# CONFIG_NET_SCHED is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_IEEE80211 is not set
+
+#
 # Device Drivers
 #
 
@@ -137,12 +253,100 @@ CONFIG_BINFMT_ELF=y
 #
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
-# CONFIG_FW_LOADER is not set
+CONFIG_FW_LOADER=y
+# CONFIG_SYS_HYPERVISOR is not set
+
+#
+# Connector - unified userspace <-> kernelspace linker
+#
+# CONFIG_CONNECTOR is not set
 
 #
 # Memory Technology Devices (MTD)
 #
-# CONFIG_MTD is not set
+CONFIG_MTD=y
+# CONFIG_MTD_DEBUG is not set
+# CONFIG_MTD_CONCAT is not set
+CONFIG_MTD_PARTITIONS=y
+CONFIG_MTD_REDBOOT_PARTS=y
+CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
+# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
+# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
+# CONFIG_MTD_CMDLINE_PARTS is not set
+
+#
+# User Modules And Translation Layers
+#
+# CONFIG_MTD_CHAR is not set
+CONFIG_MTD_BLOCK=y
+# CONFIG_FTL is not set
+# CONFIG_NFTL is not set
+# CONFIG_INFTL is not set
+# CONFIG_RFD_FTL is not set
+# CONFIG_SSFDC is not set
+
+#
+# RAM/ROM/Flash chip drivers
+#
+CONFIG_MTD_CFI=m
+CONFIG_MTD_JEDECPROBE=m
+CONFIG_MTD_GEN_PROBE=m
+CONFIG_MTD_CFI_ADV_OPTIONS=y
+# CONFIG_MTD_CFI_NOSWAP is not set
+CONFIG_MTD_CFI_BE_BYTE_SWAP=y
+# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
+CONFIG_MTD_CFI_GEOMETRY=y
+CONFIG_MTD_MAP_BANK_WIDTH_1=y
+CONFIG_MTD_MAP_BANK_WIDTH_2=y
+CONFIG_MTD_MAP_BANK_WIDTH_4=y
+# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
+CONFIG_MTD_CFI_I1=y
+# CONFIG_MTD_CFI_I2 is not set
+# CONFIG_MTD_CFI_I4 is not set
+# CONFIG_MTD_CFI_I8 is not set
+# CONFIG_MTD_OTP is not set
+# CONFIG_MTD_CFI_INTELEXT is not set
+CONFIG_MTD_CFI_AMDSTD=m
+# CONFIG_MTD_CFI_STAA is not set
+CONFIG_MTD_CFI_UTIL=m
+# CONFIG_MTD_RAM is not set
+# CONFIG_MTD_ROM is not set
+# CONFIG_MTD_ABSENT is not set
+# CONFIG_MTD_OBSOLETE_CHIPS is not set
+
+#
+# Mapping drivers for chip access
+#
+# CONFIG_MTD_COMPLEX_MAPPINGS is not set
+# CONFIG_MTD_PHYSMAP is not set
+# CONFIG_MTD_PLATRAM is not set
+
+#
+# Self-contained MTD device drivers
+#
+# CONFIG_MTD_SLRAM is not set
+# CONFIG_MTD_PHRAM is not set
+# CONFIG_MTD_MTDRAM is not set
+# CONFIG_MTD_BLOCK2MTD is not set
+
+#
+# Disk-On-Chip Device Drivers
+#
+# CONFIG_MTD_DOC2000 is not set
+# CONFIG_MTD_DOC2001 is not set
+# CONFIG_MTD_DOC2001PLUS is not set
+
+#
+# NAND Flash Device Drivers
+#
+# CONFIG_MTD_NAND is not set
+
+#
+# OneNAND Flash Device Drivers
+#
+# CONFIG_MTD_ONENAND is not set
 
 #
 # Parallel port support
@@ -156,7 +360,6 @@ CONFIG_PREVENT_FIRMWARE_BUILD=y
 #
 # Block devices
 #
-# CONFIG_BLK_DEV_FD is not set
 # CONFIG_BLK_DEV_COW_COMMON is not set
 CONFIG_BLK_DEV_LOOP=y
 # CONFIG_BLK_DEV_CRYPTOLOOP is not set
@@ -164,23 +367,21 @@ CONFIG_BLK_DEV_NBD=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 # CONFIG_BLK_DEV_INITRD is not set
-CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CDROM_PKTCDVD is not set
+CONFIG_ATA_OVER_ETH=m
 
 #
-# IO Schedulers
+# Misc devices
 #
-CONFIG_IOSCHED_NOOP=y
-# CONFIG_IOSCHED_AS is not set
-CONFIG_IOSCHED_DEADLINE=y
-CONFIG_IOSCHED_CFQ=y
-# CONFIG_ATA_OVER_ETH is not set
+# CONFIG_TIFM_CORE is not set
 
 #
 # ATA/ATAPI/MFM/RLL support
 #
 CONFIG_IDE=y
+CONFIG_IDE_MAX_HWIFS=4
 CONFIG_BLK_DEV_IDE=y
 
 #
@@ -189,7 +390,6 @@ CONFIG_BLK_DEV_IDE=y
 # CONFIG_BLK_DEV_IDE_SATA is not set
 CONFIG_BLK_DEV_IDEDISK=y
 # CONFIG_IDEDISK_MULTI_MODE is not set
-CONFIG_BLK_DEV_IDECS=y
 CONFIG_BLK_DEV_IDECD=m
 # CONFIG_BLK_DEV_IDETAPE is not set
 # CONFIG_BLK_DEV_IDEFLOPPY is not set
@@ -208,7 +408,9 @@ CONFIG_IDE_GENERIC=y
 #
 # SCSI device support
 #
+# CONFIG_RAID_ATTRS is not set
 CONFIG_SCSI=m
+# CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
 #
@@ -220,6 +422,7 @@ CONFIG_BLK_DEV_SD=m
 CONFIG_BLK_DEV_SR=m
 # CONFIG_BLK_DEV_SR_VENDOR is not set
 CONFIG_CHR_DEV_SG=m
+# CONFIG_CHR_DEV_SCH is not set
 
 #
 # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
@@ -229,26 +432,23 @@ CONFIG_SCSI_MULTI_LUN=y
 # CONFIG_SCSI_LOGGING is not set
 
 #
-# SCSI Transport Attributes
+# SCSI Transports
 #
 # CONFIG_SCSI_SPI_ATTRS is not set
 # CONFIG_SCSI_FC_ATTRS is not set
 # CONFIG_SCSI_ISCSI_ATTRS is not set
+# CONFIG_SCSI_SAS_ATTRS is not set
+# CONFIG_SCSI_SAS_LIBSAS is not set
 
 #
 # SCSI low-level drivers
 #
-# CONFIG_SCSI_SATA is not set
+# CONFIG_ISCSI_TCP is not set
 # CONFIG_SCSI_DEBUG is not set
 
 #
-# PCMCIA SCSI adapter support
+# Serial ATA (prod) and Parallel ATA (experimental) drivers
 #
-# CONFIG_PCMCIA_AHA152X is not set
-# CONFIG_PCMCIA_FDOMAIN is not set
-# CONFIG_PCMCIA_NINJA_SCSI is not set
-# CONFIG_PCMCIA_QLOGIC is not set
-# CONFIG_PCMCIA_SYM53C500 is not set
 
 #
 # Multi-device support (RAID and LVM)
@@ -258,6 +458,7 @@ CONFIG_SCSI_MULTI_LUN=y
 #
 # Fusion MPT device support
 #
+# CONFIG_FUSION is not set
 
 #
 # IEEE 1394 (FireWire) support
@@ -268,69 +469,8 @@ CONFIG_SCSI_MULTI_LUN=y
 #
 
 #
-# Networking support
-#
-CONFIG_NET=y
-
-#
-# Networking options
-#
-CONFIG_PACKET=y
-# CONFIG_PACKET_MMAP is not set
-CONFIG_UNIX=y
-# CONFIG_NET_KEY is not set
-CONFIG_INET=y
-# CONFIG_IP_MULTICAST is not set
-# CONFIG_IP_ADVANCED_ROUTER is not set
-CONFIG_IP_PNP=y
-CONFIG_IP_PNP_DHCP=y
-# CONFIG_IP_PNP_BOOTP is not set
-# CONFIG_IP_PNP_RARP is not set
-# CONFIG_NET_IPIP is not set
-# CONFIG_NET_IPGRE is not set
-# CONFIG_ARPD is not set
-# CONFIG_SYN_COOKIES is not set
-# CONFIG_INET_AH is not set
-# CONFIG_INET_ESP is not set
-# CONFIG_INET_IPCOMP is not set
-# CONFIG_INET_TUNNEL is not set
-CONFIG_IP_TCPDIAG=y
-# CONFIG_IP_TCPDIAG_IPV6 is not set
-# CONFIG_IPV6 is not set
-# CONFIG_NETFILTER is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
-#
-# CONFIG_IP_SCTP is not set
-# CONFIG_ATM is not set
-# CONFIG_BRIDGE is not set
-# CONFIG_VLAN_8021Q is not set
-# CONFIG_DECNET is not set
-# CONFIG_LLC2 is not set
-# CONFIG_IPX is not set
-# CONFIG_ATALK is not set
-# CONFIG_X25 is not set
-# CONFIG_LAPB is not set
-# CONFIG_NET_DIVERT is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
-# CONFIG_NET_SCHED is not set
-# CONFIG_NET_CLS_ROUTE is not set
-
-#
-# Network testing
+# Network device support
 #
-# CONFIG_NET_PKTGEN is not set
-# CONFIG_NETPOLL is not set
-# CONFIG_NET_POLL_CONTROLLER is not set
-# CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
-# CONFIG_BT is not set
 CONFIG_NETDEVICES=y
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
@@ -338,6 +478,11 @@ CONFIG_NETDEVICES=y
 # CONFIG_TUN is not set
 
 #
+# PHY device support
+#
+# CONFIG_PHYLIB is not set
+
+#
 # Ethernet (10 or 100Mbit)
 #
 CONFIG_NET_ETHERNET=y
@@ -363,11 +508,6 @@ CONFIG_SMC91X=y
 # CONFIG_NET_RADIO is not set
 
 #
-# PCMCIA network device support
-#
-# CONFIG_NET_PCMCIA is not set
-
-#
 # Wan interfaces
 #
 # CONFIG_WAN is not set
@@ -375,6 +515,8 @@ CONFIG_SMC91X=y
 # CONFIG_SLIP is not set
 # CONFIG_SHAPER is not set
 # CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
 
 #
 # ISDN subsystem
@@ -390,6 +532,7 @@ CONFIG_SMC91X=y
 # Input device support
 #
 CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set
 
 #
 # Userland interfaces
@@ -418,7 +561,6 @@ CONFIG_SERIO_SERPORT=y
 # CONFIG_SERIO_LIBPS2 is not set
 # CONFIG_SERIO_RAW is not set
 # CONFIG_GAMEPORT is not set
-CONFIG_SOUND_GAMEPORT=y
 
 #
 # Character devices
@@ -426,6 +568,7 @@ CONFIG_SOUND_GAMEPORT=y
 CONFIG_VT=y
 CONFIG_VT_CONSOLE=y
 CONFIG_HW_CONSOLE=y
+# CONFIG_VT_HW_CONSOLE_BINDING is not set
 # CONFIG_SERIAL_NONSTANDARD is not set
 
 #
@@ -454,8 +597,8 @@ CONFIG_LEGACY_PTY_COUNT=256
 # Watchdog Cards
 #
 # CONFIG_WATCHDOG is not set
+CONFIG_HW_RANDOM=y
 # CONFIG_RTC is not set
-# CONFIG_GEN_RTC is not set
 CONFIG_DS1302=y
 # CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
@@ -463,17 +606,12 @@ CONFIG_DS1302=y
 #
 # Ftape, the floppy tape device driver
 #
-# CONFIG_DRM is not set
-
-#
-# PCMCIA character devices
-#
-# CONFIG_SYNCLINK_CS is not set
 # CONFIG_RAW_DRIVER is not set
 
 #
 # TPM devices
 #
+# CONFIG_TCG_TPM is not set
 
 #
 # I2C support
@@ -481,34 +619,51 @@ CONFIG_DS1302=y
 # CONFIG_I2C is not set
 
 #
+# SPI support
+#
+# CONFIG_SPI is not set
+# CONFIG_SPI_MASTER is not set
+
+#
 # Dallas's 1-wire bus
 #
 # CONFIG_W1 is not set
 
 #
-# Misc devices
+# Hardware Monitoring support
 #
+CONFIG_HWMON=y
+# CONFIG_HWMON_VID is not set
+# CONFIG_SENSORS_ABITUGURU is not set
+# CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_VT1211 is not set
+# CONFIG_HWMON_DEBUG_CHIP is not set
 
 #
 # Multimedia devices
 #
-CONFIG_VIDEO_DEV=y
+CONFIG_VIDEO_DEV=m
+CONFIG_VIDEO_V4L1=y
+CONFIG_VIDEO_V4L1_COMPAT=y
+CONFIG_VIDEO_V4L2=y
 
 #
-# Video For Linux
+# Video Capture Adapters
 #
 
 #
-# Video Adapters
+# Video Capture Adapters
 #
+# CONFIG_VIDEO_ADV_DEBUG is not set
+CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
+# CONFIG_VIDEO_VIVI is not set
 # CONFIG_VIDEO_CPIA is not set
-CONFIG_VIDEO_M32R_AR=y
-CONFIG_VIDEO_M32R_AR_M64278=y
+CONFIG_VIDEO_M32R_AR=m
+CONFIG_VIDEO_M32R_AR_M64278=m
 
 #
 # Radio Adapters
 #
-# CONFIG_RADIO_MAESTRO is not set
 
 #
 # Digital Video Broadcasting Devices
@@ -518,15 +673,16 @@ CONFIG_VIDEO_M32R_AR_M64278=y
 #
 # Graphics support
 #
+CONFIG_FIRMWARE_EDID=y
 CONFIG_FB=y
-# CONFIG_FB_CFB_FILLRECT is not set
-# CONFIG_FB_CFB_COPYAREA is not set
-# CONFIG_FB_CFB_IMAGEBLIT is not set
-# CONFIG_FB_SOFT_CURSOR is not set
+CONFIG_FB_CFB_FILLRECT=y
+CONFIG_FB_CFB_COPYAREA=y
+CONFIG_FB_CFB_IMAGEBLIT=y
 # CONFIG_FB_MACMODES is not set
+# CONFIG_FB_BACKLIGHT is not set
 # CONFIG_FB_MODE_HELPERS is not set
 # CONFIG_FB_TILEBLITTING is not set
-# CONFIG_FB_S1D13XXX is not set
+CONFIG_FB_S1D13XXX=y
 # CONFIG_FB_VIRTUAL is not set
 
 #
@@ -535,6 +691,7 @@ CONFIG_FB=y
 # CONFIG_VGA_CONSOLE is not set
 CONFIG_DUMMY_CONSOLE=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
+# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
 # CONFIG_FONTS is not set
 CONFIG_FONT_8x8=y
 CONFIG_FONT_8x16=y
@@ -546,6 +703,7 @@ CONFIG_LOGO=y
 CONFIG_LOGO_LINUX_MONO=y
 CONFIG_LOGO_LINUX_VGA16=y
 CONFIG_LOGO_LINUX_CLUT224=y
+CONFIG_LOGO_M32R_CLUT224=y
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
@@ -558,6 +716,11 @@ CONFIG_LOGO_LINUX_CLUT224=y
 #
 # CONFIG_USB_ARCH_HAS_HCD is not set
 # CONFIG_USB_ARCH_HAS_OHCI is not set
+# CONFIG_USB_ARCH_HAS_EHCI is not set
+
+#
+# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+#
 
 #
 # USB Gadget Support
@@ -567,23 +730,62 @@ CONFIG_LOGO_LINUX_CLUT224=y
 #
 # MMC/SD Card support
 #
-# CONFIG_MMC is not set
+CONFIG_MMC=y
+CONFIG_MMC_DEBUG=y
+CONFIG_MMC_BLOCK=y
+# CONFIG_MMC_TIFM_SD is not set
+
+#
+# LED devices
+#
+# CONFIG_NEW_LEDS is not set
+
+#
+# LED drivers
+#
+
+#
+# LED Triggers
+#
 
 #
 # InfiniBand support
 #
-# CONFIG_INFINIBAND is not set
+
+#
+# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
+#
+
+#
+# Real Time Clock
+#
+# CONFIG_RTC_CLASS is not set
+
+#
+# DMA Engine support
+#
+# CONFIG_DMA_ENGINE is not set
+
+#
+# DMA Clients
+#
+
+#
+# DMA Devices
+#
 
 #
 # File systems
 #
 CONFIG_EXT2_FS=y
 # CONFIG_EXT2_FS_XATTR is not set
-CONFIG_EXT3_FS=m
+# CONFIG_EXT2_FS_XIP is not set
+CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_XATTR=y
 # CONFIG_EXT3_FS_POSIX_ACL is not set
 # CONFIG_EXT3_FS_SECURITY is not set
-CONFIG_JBD=m
+# CONFIG_EXT4DEV_FS is not set
+CONFIG_JBD=y
 CONFIG_JBD_DEBUG=y
 CONFIG_FS_MBCACHE=y
 CONFIG_REISERFS_FS=m
@@ -591,17 +793,19 @@ CONFIG_REISERFS_FS=m
 # CONFIG_REISERFS_PROC_INFO is not set
 # CONFIG_REISERFS_FS_XATTR is not set
 # CONFIG_JFS_FS is not set
-
-#
-# XFS support
-#
+# CONFIG_FS_POSIX_ACL is not set
 # CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
 # CONFIG_MINIX_FS is not set
 # CONFIG_ROMFS_FS is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
 CONFIG_DNOTIFY=y
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
 
 #
 # CD-ROM/DVD Filesystems
@@ -627,15 +831,13 @@ CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
 #
 CONFIG_PROC_FS=y
 CONFIG_PROC_KCORE=y
+CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
-CONFIG_DEVFS_FS=y
-CONFIG_DEVFS_MOUNT=y
-# CONFIG_DEVFS_DEBUG is not set
-# CONFIG_DEVPTS_FS_XATTR is not set
 CONFIG_TMPFS=y
-# CONFIG_TMPFS_XATTR is not set
+# CONFIG_TMPFS_POSIX_ACL is not set
 # CONFIG_HUGETLB_PAGE is not set
 CONFIG_RAMFS=y
+# CONFIG_CONFIGFS_FS is not set
 
 #
 # Miscellaneous filesystems
@@ -647,6 +849,8 @@ CONFIG_RAMFS=y
 # CONFIG_BEFS_FS is not set
 # CONFIG_BFS_FS is not set
 # CONFIG_EFS_FS is not set
+# CONFIG_JFFS_FS is not set
+# CONFIG_JFFS2_FS is not set
 # CONFIG_CRAMFS is not set
 # CONFIG_VXFS_FS is not set
 # CONFIG_HPFS_FS is not set
@@ -659,12 +863,14 @@ CONFIG_RAMFS=y
 #
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
 # CONFIG_NFS_V4 is not set
 # CONFIG_NFS_DIRECTIO is not set
 # CONFIG_NFSD is not set
 CONFIG_ROOT_NFS=y
 CONFIG_LOCKD=y
 CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
 # CONFIG_RPCSEC_GSS_KRB5 is not set
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
@@ -673,6 +879,7 @@ CONFIG_SUNRPC=y
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
+# CONFIG_9P_FS is not set
 
 #
 # Partition Types
@@ -727,16 +934,23 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 #
 # Profiling support
 #
-# CONFIG_PROFILING is not set
+CONFIG_PROFILING=y
+CONFIG_OPROFILE=y
 
 #
 # Kernel hacking
 #
 # CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_MUST_CHECK=y
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
 # CONFIG_DEBUG_KERNEL is not set
 CONFIG_LOG_BUF_SHIFT=15
 # CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_DEBUG_FS is not set
 # CONFIG_FRAME_POINTER is not set
+# CONFIG_UNWIND_INFO is not set
+# CONFIG_HEADERS_CHECK is not set
 
 #
 # Security options
@@ -750,12 +964,9 @@ CONFIG_LOG_BUF_SHIFT=15
 # CONFIG_CRYPTO is not set
 
 #
-# Hardware crypto devices
-#
-
-#
 # Library routines
 #
 # CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
 CONFIG_CRC32=y
 # CONFIG_LIBCRC32C is not set
diff -puN arch/m32r/m32700ut/defconfig.m32700ut.up~m32r-update-defconfig-files-for-v2619 arch/m32r/m32700ut/defconfig.m32700ut.up
--- a/arch/m32r/m32700ut/defconfig.m32700ut.up~m32r-update-defconfig-files-for-v2619
+++ a/arch/m32r/m32700ut/defconfig.m32700ut.up
@@ -1,19 +1,18 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.12-rc5
-# Fri Jun  3 16:21:34 2005
+# Linux kernel version: 2.6.19
+# Tue Dec 12 12:07:08 2006
 #
 CONFIG_M32R=y
-# CONFIG_UID16 is not set
 CONFIG_GENERIC_ISA_DMA=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
 # Code maturity level options
 #
 CONFIG_EXPERIMENTAL=y
-CONFIG_CLEAN_COMPILE=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_LOCK_KERNEL=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
@@ -22,32 +21,39 @@ CONFIG_INIT_ENV_ARG_LIMIT=32
 # General setup
 #
 CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SWAP=y
 CONFIG_SYSVIPC=y
+# CONFIG_IPC_NS is not set
 # CONFIG_POSIX_MQUEUE is not set
 CONFIG_BSD_PROCESS_ACCT=y
 # CONFIG_BSD_PROCESS_ACCT_V3 is not set
-CONFIG_SYSCTL=y
+# CONFIG_TASKSTATS is not set
+# CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
-CONFIG_HOTPLUG=y
-CONFIG_KOBJECT_UEVENT=y
 CONFIG_IKCONFIG=y
-# CONFIG_IKCONFIG_PROC is not set
+CONFIG_IKCONFIG_PROC=y
+CONFIG_SYSFS_DEPRECATED=y
+# CONFIG_RELAY is not set
+CONFIG_INITRAMFS_SOURCE=""
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
 CONFIG_EMBEDDED=y
+CONFIG_SYSCTL_SYSCALL=y
 # CONFIG_KALLSYMS is not set
+CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
+CONFIG_ELF_CORE=y
 CONFIG_BASE_FULL=y
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SHMEM=y
-CONFIG_CC_ALIGN_FUNCTIONS=0
-CONFIG_CC_ALIGN_LABELS=0
-CONFIG_CC_ALIGN_LOOPS=0
-CONFIG_CC_ALIGN_JUMPS=0
+CONFIG_SLAB=y
+CONFIG_VM_EVENT_COUNTERS=y
 # CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=0
+# CONFIG_SLOB is not set
 
 #
 # Loadable module support
@@ -55,12 +61,30 @@ CONFIG_BASE_SMALL=0
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
-CONFIG_OBSOLETE_MODPARM=y
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_KMOD=y
 
 #
+# Block layer
+#
+CONFIG_BLOCK=y
+# CONFIG_BLK_DEV_IO_TRACE is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+# CONFIG_IOSCHED_AS is not set
+CONFIG_IOSCHED_DEADLINE=y
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_AS is not set
+# CONFIG_DEFAULT_DEADLINE is not set
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
+
+#
 # Processor type and features
 #
 # CONFIG_PLAT_MAPPI is not set
@@ -70,8 +94,10 @@ CONFIG_PLAT_M32700UT=y
 # CONFIG_PLAT_OAKS32R is not set
 # CONFIG_PLAT_MAPPI2 is not set
 # CONFIG_PLAT_MAPPI3 is not set
+# CONFIG_PLAT_M32104UT is not set
 CONFIG_CHIP_M32700=y
 # CONFIG_CHIP_M32102 is not set
+# CONFIG_CHIP_M32104 is not set
 # CONFIG_CHIP_VDEC2 is not set
 # CONFIG_CHIP_OPSP is not set
 CONFIG_MMU=y
@@ -85,34 +111,37 @@ CONFIG_TIMER_DIVIDE=128
 CONFIG_MEMORY_START=0x08000000
 CONFIG_MEMORY_SIZE=0x01000000
 CONFIG_NOHIGHMEM=y
-# CONFIG_DISCONTIGMEM is not set
+CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
+CONFIG_SELECT_MEMORY_MODEL=y
+# CONFIG_FLATMEM_MANUAL is not set
+CONFIG_DISCONTIGMEM_MANUAL=y
+# CONFIG_SPARSEMEM_MANUAL is not set
+CONFIG_DISCONTIGMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+CONFIG_NEED_MULTIPLE_NODES=y
+# CONFIG_SPARSEMEM_STATIC is not set
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
+CONFIG_IRAM_START=0x00f00000
+CONFIG_IRAM_SIZE=0x00080000
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_PREEMPT=y
-# CONFIG_HAVE_DEC_LOCK is not set
 # CONFIG_SMP is not set
+CONFIG_NODES_SHIFT=1
 
 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
 #
-# CONFIG_PCI is not set
 # CONFIG_ISA is not set
 
 #
 # PCCARD (PCMCIA/CardBus) support
 #
-CONFIG_PCCARD=y
-# CONFIG_PCMCIA_DEBUG is not set
-CONFIG_PCMCIA=y
-
-#
-# PC-card bridges
-#
-# CONFIG_TCIC is not set
-# CONFIG_M32R_PCC is not set
-CONFIG_M32R_CFC=y
-CONFIG_M32R_CFC_NUM=1
+# CONFIG_PCCARD is not set
 
 #
 # PCI Hotplug Support
@@ -125,6 +154,94 @@ CONFIG_BINFMT_ELF=y
 # CONFIG_BINFMT_MISC is not set
 
 #
+# Networking
+#
+CONFIG_NET=y
+
+#
+# Networking options
+#
+# CONFIG_NETDEBUG is not set
+CONFIG_PACKET=y
+# CONFIG_PACKET_MMAP is not set
+CONFIG_UNIX=y
+CONFIG_XFRM=y
+# CONFIG_XFRM_USER is not set
+# CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+# CONFIG_IP_MULTICAST is not set
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+# CONFIG_IP_PNP_BOOTP is not set
+# CONFIG_IP_PNP_RARP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_ARPD is not set
+# CONFIG_SYN_COOKIES is not set
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+CONFIG_INET_XFRM_MODE_TRANSPORT=y
+CONFIG_INET_XFRM_MODE_TUNNEL=y
+CONFIG_INET_XFRM_MODE_BEET=y
+CONFIG_INET_DIAG=y
+CONFIG_INET_TCP_DIAG=y
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_INET6_XFRM_TUNNEL is not set
+# CONFIG_INET6_TUNNEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+
+#
+# DCCP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_DCCP is not set
+
+#
+# SCTP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_SCTP is not set
+
+#
+# TIPC Configuration (EXPERIMENTAL)
+#
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+
+#
+# QoS and/or fair queueing
+#
+# CONFIG_NET_SCHED is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_IEEE80211 is not set
+
+#
 # Device Drivers
 #
 
@@ -133,12 +250,100 @@ CONFIG_BINFMT_ELF=y
 #
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
-# CONFIG_FW_LOADER is not set
+CONFIG_FW_LOADER=y
+# CONFIG_SYS_HYPERVISOR is not set
+
+#
+# Connector - unified userspace <-> kernelspace linker
+#
+# CONFIG_CONNECTOR is not set
 
 #
 # Memory Technology Devices (MTD)
 #
-# CONFIG_MTD is not set
+CONFIG_MTD=y
+# CONFIG_MTD_DEBUG is not set
+# CONFIG_MTD_CONCAT is not set
+CONFIG_MTD_PARTITIONS=y
+CONFIG_MTD_REDBOOT_PARTS=y
+CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
+# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
+# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
+# CONFIG_MTD_CMDLINE_PARTS is not set
+
+#
+# User Modules And Translation Layers
+#
+# CONFIG_MTD_CHAR is not set
+CONFIG_MTD_BLOCK=y
+# CONFIG_FTL is not set
+# CONFIG_NFTL is not set
+# CONFIG_INFTL is not set
+# CONFIG_RFD_FTL is not set
+# CONFIG_SSFDC is not set
+
+#
+# RAM/ROM/Flash chip drivers
+#
+CONFIG_MTD_CFI=m
+CONFIG_MTD_JEDECPROBE=m
+CONFIG_MTD_GEN_PROBE=m
+CONFIG_MTD_CFI_ADV_OPTIONS=y
+# CONFIG_MTD_CFI_NOSWAP is not set
+CONFIG_MTD_CFI_BE_BYTE_SWAP=y
+# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
+CONFIG_MTD_CFI_GEOMETRY=y
+CONFIG_MTD_MAP_BANK_WIDTH_1=y
+CONFIG_MTD_MAP_BANK_WIDTH_2=y
+CONFIG_MTD_MAP_BANK_WIDTH_4=y
+# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
+CONFIG_MTD_CFI_I1=y
+# CONFIG_MTD_CFI_I2 is not set
+# CONFIG_MTD_CFI_I4 is not set
+# CONFIG_MTD_CFI_I8 is not set
+# CONFIG_MTD_OTP is not set
+# CONFIG_MTD_CFI_INTELEXT is not set
+CONFIG_MTD_CFI_AMDSTD=m
+# CONFIG_MTD_CFI_STAA is not set
+CONFIG_MTD_CFI_UTIL=m
+# CONFIG_MTD_RAM is not set
+# CONFIG_MTD_ROM is not set
+# CONFIG_MTD_ABSENT is not set
+# CONFIG_MTD_OBSOLETE_CHIPS is not set
+
+#
+# Mapping drivers for chip access
+#
+# CONFIG_MTD_COMPLEX_MAPPINGS is not set
+# CONFIG_MTD_PHYSMAP is not set
+# CONFIG_MTD_PLATRAM is not set
+
+#
+# Self-contained MTD device drivers
+#
+# CONFIG_MTD_SLRAM is not set
+# CONFIG_MTD_PHRAM is not set
+# CONFIG_MTD_MTDRAM is not set
+# CONFIG_MTD_BLOCK2MTD is not set
+
+#
+# Disk-On-Chip Device Drivers
+#
+# CONFIG_MTD_DOC2000 is not set
+# CONFIG_MTD_DOC2001 is not set
+# CONFIG_MTD_DOC2001PLUS is not set
+
+#
+# NAND Flash Device Drivers
+#
+# CONFIG_MTD_NAND is not set
+
+#
+# OneNAND Flash Device Drivers
+#
+# CONFIG_MTD_ONENAND is not set
 
 #
 # Parallel port support
@@ -152,7 +357,6 @@ CONFIG_PREVENT_FIRMWARE_BUILD=y
 #
 # Block devices
 #
-# CONFIG_BLK_DEV_FD is not set
 # CONFIG_BLK_DEV_COW_COMMON is not set
 CONFIG_BLK_DEV_LOOP=y
 # CONFIG_BLK_DEV_CRYPTOLOOP is not set
@@ -160,23 +364,21 @@ CONFIG_BLK_DEV_NBD=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 # CONFIG_BLK_DEV_INITRD is not set
-CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CDROM_PKTCDVD is not set
+CONFIG_ATA_OVER_ETH=m
 
 #
-# IO Schedulers
+# Misc devices
 #
-CONFIG_IOSCHED_NOOP=y
-# CONFIG_IOSCHED_AS is not set
-CONFIG_IOSCHED_DEADLINE=y
-CONFIG_IOSCHED_CFQ=y
-# CONFIG_ATA_OVER_ETH is not set
+# CONFIG_TIFM_CORE is not set
 
 #
 # ATA/ATAPI/MFM/RLL support
 #
 CONFIG_IDE=y
+CONFIG_IDE_MAX_HWIFS=4
 CONFIG_BLK_DEV_IDE=y
 
 #
@@ -185,7 +387,6 @@ CONFIG_BLK_DEV_IDE=y
 # CONFIG_BLK_DEV_IDE_SATA is not set
 CONFIG_BLK_DEV_IDEDISK=y
 # CONFIG_IDEDISK_MULTI_MODE is not set
-CONFIG_BLK_DEV_IDECS=y
 CONFIG_BLK_DEV_IDECD=m
 # CONFIG_BLK_DEV_IDETAPE is not set
 # CONFIG_BLK_DEV_IDEFLOPPY is not set
@@ -204,7 +405,9 @@ CONFIG_IDE_GENERIC=y
 #
 # SCSI device support
 #
+# CONFIG_RAID_ATTRS is not set
 CONFIG_SCSI=m
+# CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
 #
@@ -216,6 +419,7 @@ CONFIG_BLK_DEV_SD=m
 CONFIG_BLK_DEV_SR=m
 # CONFIG_BLK_DEV_SR_VENDOR is not set
 CONFIG_CHR_DEV_SG=m
+# CONFIG_CHR_DEV_SCH is not set
 
 #
 # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
@@ -225,26 +429,23 @@ CONFIG_SCSI_MULTI_LUN=y
 # CONFIG_SCSI_LOGGING is not set
 
 #
-# SCSI Transport Attributes
+# SCSI Transports
 #
 # CONFIG_SCSI_SPI_ATTRS is not set
 # CONFIG_SCSI_FC_ATTRS is not set
 # CONFIG_SCSI_ISCSI_ATTRS is not set
+# CONFIG_SCSI_SAS_ATTRS is not set
+# CONFIG_SCSI_SAS_LIBSAS is not set
 
 #
 # SCSI low-level drivers
 #
-# CONFIG_SCSI_SATA is not set
+# CONFIG_ISCSI_TCP is not set
 # CONFIG_SCSI_DEBUG is not set
 
 #
-# PCMCIA SCSI adapter support
+# Serial ATA (prod) and Parallel ATA (experimental) drivers
 #
-# CONFIG_PCMCIA_AHA152X is not set
-# CONFIG_PCMCIA_FDOMAIN is not set
-# CONFIG_PCMCIA_NINJA_SCSI is not set
-# CONFIG_PCMCIA_QLOGIC is not set
-# CONFIG_PCMCIA_SYM53C500 is not set
 
 #
 # Multi-device support (RAID and LVM)
@@ -254,6 +455,7 @@ CONFIG_SCSI_MULTI_LUN=y
 #
 # Fusion MPT device support
 #
+# CONFIG_FUSION is not set
 
 #
 # IEEE 1394 (FireWire) support
@@ -264,69 +466,8 @@ CONFIG_SCSI_MULTI_LUN=y
 #
 
 #
-# Networking support
-#
-CONFIG_NET=y
-
-#
-# Networking options
-#
-CONFIG_PACKET=y
-# CONFIG_PACKET_MMAP is not set
-CONFIG_UNIX=y
-# CONFIG_NET_KEY is not set
-CONFIG_INET=y
-# CONFIG_IP_MULTICAST is not set
-# CONFIG_IP_ADVANCED_ROUTER is not set
-CONFIG_IP_PNP=y
-CONFIG_IP_PNP_DHCP=y
-# CONFIG_IP_PNP_BOOTP is not set
-# CONFIG_IP_PNP_RARP is not set
-# CONFIG_NET_IPIP is not set
-# CONFIG_NET_IPGRE is not set
-# CONFIG_ARPD is not set
-# CONFIG_SYN_COOKIES is not set
-# CONFIG_INET_AH is not set
-# CONFIG_INET_ESP is not set
-# CONFIG_INET_IPCOMP is not set
-# CONFIG_INET_TUNNEL is not set
-CONFIG_IP_TCPDIAG=y
-# CONFIG_IP_TCPDIAG_IPV6 is not set
-# CONFIG_IPV6 is not set
-# CONFIG_NETFILTER is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
-#
-# CONFIG_IP_SCTP is not set
-# CONFIG_ATM is not set
-# CONFIG_BRIDGE is not set
-# CONFIG_VLAN_8021Q is not set
-# CONFIG_DECNET is not set
-# CONFIG_LLC2 is not set
-# CONFIG_IPX is not set
-# CONFIG_ATALK is not set
-# CONFIG_X25 is not set
-# CONFIG_LAPB is not set
-# CONFIG_NET_DIVERT is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
-# CONFIG_NET_SCHED is not set
-# CONFIG_NET_CLS_ROUTE is not set
-
-#
-# Network testing
+# Network device support
 #
-# CONFIG_NET_PKTGEN is not set
-# CONFIG_NETPOLL is not set
-# CONFIG_NET_POLL_CONTROLLER is not set
-# CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
-# CONFIG_BT is not set
 CONFIG_NETDEVICES=y
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
@@ -334,6 +475,11 @@ CONFIG_NETDEVICES=y
 # CONFIG_TUN is not set
 
 #
+# PHY device support
+#
+# CONFIG_PHYLIB is not set
+
+#
 # Ethernet (10 or 100Mbit)
 #
 CONFIG_NET_ETHERNET=y
@@ -359,11 +505,6 @@ CONFIG_SMC91X=y
 # CONFIG_NET_RADIO is not set
 
 #
-# PCMCIA network device support
-#
-# CONFIG_NET_PCMCIA is not set
-
-#
 # Wan interfaces
 #
 # CONFIG_WAN is not set
@@ -371,6 +512,8 @@ CONFIG_SMC91X=y
 # CONFIG_SLIP is not set
 # CONFIG_SHAPER is not set
 # CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
 
 #
 # ISDN subsystem
@@ -386,6 +529,7 @@ CONFIG_SMC91X=y
 # Input device support
 #
 CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set
 
 #
 # Userland interfaces
@@ -414,7 +558,6 @@ CONFIG_SERIO_SERPORT=y
 # CONFIG_SERIO_LIBPS2 is not set
 # CONFIG_SERIO_RAW is not set
 # CONFIG_GAMEPORT is not set
-CONFIG_SOUND_GAMEPORT=y
 
 #
 # Character devices
@@ -422,6 +565,7 @@ CONFIG_SOUND_GAMEPORT=y
 CONFIG_VT=y
 CONFIG_VT_CONSOLE=y
 CONFIG_HW_CONSOLE=y
+# CONFIG_VT_HW_CONSOLE_BINDING is not set
 # CONFIG_SERIAL_NONSTANDARD is not set
 
 #
@@ -450,8 +594,8 @@ CONFIG_LEGACY_PTY_COUNT=256
 # Watchdog Cards
 #
 # CONFIG_WATCHDOG is not set
+CONFIG_HW_RANDOM=y
 # CONFIG_RTC is not set
-# CONFIG_GEN_RTC is not set
 CONFIG_DS1302=y
 # CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
@@ -459,17 +603,12 @@ CONFIG_DS1302=y
 #
 # Ftape, the floppy tape device driver
 #
-# CONFIG_DRM is not set
-
-#
-# PCMCIA character devices
-#
-# CONFIG_SYNCLINK_CS is not set
 # CONFIG_RAW_DRIVER is not set
 
 #
 # TPM devices
 #
+# CONFIG_TCG_TPM is not set
 
 #
 # I2C support
@@ -477,34 +616,51 @@ CONFIG_DS1302=y
 # CONFIG_I2C is not set
 
 #
+# SPI support
+#
+# CONFIG_SPI is not set
+# CONFIG_SPI_MASTER is not set
+
+#
 # Dallas's 1-wire bus
 #
 # CONFIG_W1 is not set
 
 #
-# Misc devices
+# Hardware Monitoring support
 #
+CONFIG_HWMON=y
+# CONFIG_HWMON_VID is not set
+# CONFIG_SENSORS_ABITUGURU is not set
+# CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_VT1211 is not set
+# CONFIG_HWMON_DEBUG_CHIP is not set
 
 #
 # Multimedia devices
 #
-CONFIG_VIDEO_DEV=y
+CONFIG_VIDEO_DEV=m
+CONFIG_VIDEO_V4L1=y
+CONFIG_VIDEO_V4L1_COMPAT=y
+CONFIG_VIDEO_V4L2=y
 
 #
-# Video For Linux
+# Video Capture Adapters
 #
 
 #
-# Video Adapters
+# Video Capture Adapters
 #
+# CONFIG_VIDEO_ADV_DEBUG is not set
+CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
+# CONFIG_VIDEO_VIVI is not set
 # CONFIG_VIDEO_CPIA is not set
-CONFIG_VIDEO_M32R_AR=y
-CONFIG_VIDEO_M32R_AR_M64278=y
+CONFIG_VIDEO_M32R_AR=m
+CONFIG_VIDEO_M32R_AR_M64278=m
 
 #
 # Radio Adapters
 #
-# CONFIG_RADIO_MAESTRO is not set
 
 #
 # Digital Video Broadcasting Devices
@@ -514,15 +670,16 @@ CONFIG_VIDEO_M32R_AR_M64278=y
 #
 # Graphics support
 #
+CONFIG_FIRMWARE_EDID=y
 CONFIG_FB=y
-# CONFIG_FB_CFB_FILLRECT is not set
-# CONFIG_FB_CFB_COPYAREA is not set
-# CONFIG_FB_CFB_IMAGEBLIT is not set
-# CONFIG_FB_SOFT_CURSOR is not set
+CONFIG_FB_CFB_FILLRECT=y
+CONFIG_FB_CFB_COPYAREA=y
+CONFIG_FB_CFB_IMAGEBLIT=y
 # CONFIG_FB_MACMODES is not set
+# CONFIG_FB_BACKLIGHT is not set
 # CONFIG_FB_MODE_HELPERS is not set
 # CONFIG_FB_TILEBLITTING is not set
-# CONFIG_FB_S1D13XXX is not set
+CONFIG_FB_S1D13XXX=y
 # CONFIG_FB_VIRTUAL is not set
 
 #
@@ -531,6 +688,7 @@ CONFIG_FB=y
 # CONFIG_VGA_CONSOLE is not set
 CONFIG_DUMMY_CONSOLE=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
+# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
 # CONFIG_FONTS is not set
 CONFIG_FONT_8x8=y
 CONFIG_FONT_8x16=y
@@ -542,6 +700,7 @@ CONFIG_LOGO=y
 CONFIG_LOGO_LINUX_MONO=y
 CONFIG_LOGO_LINUX_VGA16=y
 CONFIG_LOGO_LINUX_CLUT224=y
+CONFIG_LOGO_M32R_CLUT224=y
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
@@ -554,6 +713,11 @@ CONFIG_LOGO_LINUX_CLUT224=y
 #
 # CONFIG_USB_ARCH_HAS_HCD is not set
 # CONFIG_USB_ARCH_HAS_OHCI is not set
+# CONFIG_USB_ARCH_HAS_EHCI is not set
+
+#
+# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+#
 
 #
 # USB Gadget Support
@@ -563,23 +727,62 @@ CONFIG_LOGO_LINUX_CLUT224=y
 #
 # MMC/SD Card support
 #
-# CONFIG_MMC is not set
+CONFIG_MMC=y
+CONFIG_MMC_DEBUG=y
+CONFIG_MMC_BLOCK=y
+# CONFIG_MMC_TIFM_SD is not set
+
+#
+# LED devices
+#
+# CONFIG_NEW_LEDS is not set
+
+#
+# LED drivers
+#
+
+#
+# LED Triggers
+#
 
 #
 # InfiniBand support
 #
-# CONFIG_INFINIBAND is not set
+
+#
+# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
+#
+
+#
+# Real Time Clock
+#
+# CONFIG_RTC_CLASS is not set
+
+#
+# DMA Engine support
+#
+# CONFIG_DMA_ENGINE is not set
+
+#
+# DMA Clients
+#
+
+#
+# DMA Devices
+#
 
 #
 # File systems
 #
 CONFIG_EXT2_FS=y
 # CONFIG_EXT2_FS_XATTR is not set
-CONFIG_EXT3_FS=m
+# CONFIG_EXT2_FS_XIP is not set
+CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_XATTR=y
 # CONFIG_EXT3_FS_POSIX_ACL is not set
 # CONFIG_EXT3_FS_SECURITY is not set
-CONFIG_JBD=m
+# CONFIG_EXT4DEV_FS is not set
+CONFIG_JBD=y
 CONFIG_JBD_DEBUG=y
 CONFIG_FS_MBCACHE=y
 CONFIG_REISERFS_FS=m
@@ -587,17 +790,19 @@ CONFIG_REISERFS_FS=m
 # CONFIG_REISERFS_PROC_INFO is not set
 # CONFIG_REISERFS_FS_XATTR is not set
 # CONFIG_JFS_FS is not set
-
-#
-# XFS support
-#
+# CONFIG_FS_POSIX_ACL is not set
 # CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
 # CONFIG_MINIX_FS is not set
 # CONFIG_ROMFS_FS is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
 CONFIG_DNOTIFY=y
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
 
 #
 # CD-ROM/DVD Filesystems
@@ -623,15 +828,13 @@ CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
 #
 CONFIG_PROC_FS=y
 CONFIG_PROC_KCORE=y
+CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
-CONFIG_DEVFS_FS=y
-CONFIG_DEVFS_MOUNT=y
-# CONFIG_DEVFS_DEBUG is not set
-# CONFIG_DEVPTS_FS_XATTR is not set
 CONFIG_TMPFS=y
-# CONFIG_TMPFS_XATTR is not set
+# CONFIG_TMPFS_POSIX_ACL is not set
 # CONFIG_HUGETLB_PAGE is not set
 CONFIG_RAMFS=y
+# CONFIG_CONFIGFS_FS is not set
 
 #
 # Miscellaneous filesystems
@@ -643,6 +846,8 @@ CONFIG_RAMFS=y
 # CONFIG_BEFS_FS is not set
 # CONFIG_BFS_FS is not set
 # CONFIG_EFS_FS is not set
+# CONFIG_JFFS_FS is not set
+# CONFIG_JFFS2_FS is not set
 # CONFIG_CRAMFS is not set
 # CONFIG_VXFS_FS is not set
 # CONFIG_HPFS_FS is not set
@@ -655,12 +860,14 @@ CONFIG_RAMFS=y
 #
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
 # CONFIG_NFS_V4 is not set
 # CONFIG_NFS_DIRECTIO is not set
 # CONFIG_NFSD is not set
 CONFIG_ROOT_NFS=y
 CONFIG_LOCKD=y
 CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
 # CONFIG_RPCSEC_GSS_KRB5 is not set
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
@@ -669,6 +876,7 @@ CONFIG_SUNRPC=y
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
+# CONFIG_9P_FS is not set
 
 #
 # Partition Types
@@ -723,16 +931,23 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 #
 # Profiling support
 #
-# CONFIG_PROFILING is not set
+CONFIG_PROFILING=y
+CONFIG_OPROFILE=y
 
 #
 # Kernel hacking
 #
 # CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_MUST_CHECK=y
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
 # CONFIG_DEBUG_KERNEL is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_DEBUG_FS is not set
 # CONFIG_FRAME_POINTER is not set
+# CONFIG_UNWIND_INFO is not set
+# CONFIG_HEADERS_CHECK is not set
 
 #
 # Security options
@@ -746,12 +961,9 @@ CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CRYPTO is not set
 
 #
-# Hardware crypto devices
-#
-
-#
 # Library routines
 #
 # CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
 CONFIG_CRC32=y
 # CONFIG_LIBCRC32C is not set
diff -puN arch/m32r/mappi/defconfig.nommu~m32r-update-defconfig-files-for-v2619 arch/m32r/mappi/defconfig.nommu
--- a/arch/m32r/mappi/defconfig.nommu~m32r-update-defconfig-files-for-v2619
+++ a/arch/m32r/mappi/defconfig.nommu
@@ -1,19 +1,18 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.12-rc5
-# Fri Jun  3 16:21:46 2005
+# Linux kernel version: 2.6.19
+# Wed Dec 13 17:57:45 2006
 #
 CONFIG_M32R=y
-# CONFIG_UID16 is not set
 CONFIG_GENERIC_ISA_DMA=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
 # Code maturity level options
 #
 CONFIG_EXPERIMENTAL=y
-CONFIG_CLEAN_COMPILE=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_LOCK_KERNEL=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
@@ -22,29 +21,36 @@ CONFIG_INIT_ENV_ARG_LIMIT=32
 # General setup
 #
 CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
+# CONFIG_SYSVIPC is not set
 # CONFIG_POSIX_MQUEUE is not set
 CONFIG_BSD_PROCESS_ACCT=y
 # CONFIG_BSD_PROCESS_ACCT_V3 is not set
-CONFIG_SYSCTL=y
+# CONFIG_TASKSTATS is not set
+# CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
-CONFIG_HOTPLUG=y
-CONFIG_KOBJECT_UEVENT=y
 CONFIG_IKCONFIG=y
 # CONFIG_IKCONFIG_PROC is not set
+CONFIG_SYSFS_DEPRECATED=y
+# CONFIG_RELAY is not set
+CONFIG_INITRAMFS_SOURCE=""
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
 CONFIG_EMBEDDED=y
+CONFIG_SYSCTL_SYSCALL=y
 # CONFIG_KALLSYMS is not set
+CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
+CONFIG_ELF_CORE=y
 CONFIG_BASE_FULL=y
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_CC_ALIGN_FUNCTIONS=0
-CONFIG_CC_ALIGN_LABELS=0
-CONFIG_CC_ALIGN_LOOPS=0
-CONFIG_CC_ALIGN_JUMPS=0
+CONFIG_SLAB=y
+CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_TINY_SHMEM=y
 CONFIG_BASE_SMALL=0
+# CONFIG_SLOB is not set
 
 #
 # Loadable module support
@@ -52,12 +58,30 @@ CONFIG_BASE_SMALL=0
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
-CONFIG_OBSOLETE_MODPARM=y
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_KMOD=y
 
 #
+# Block layer
+#
+CONFIG_BLOCK=y
+# CONFIG_BLK_DEV_IO_TRACE is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+# CONFIG_IOSCHED_AS is not set
+CONFIG_IOSCHED_DEADLINE=y
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_AS is not set
+# CONFIG_DEFAULT_DEADLINE is not set
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
+
+#
 # Processor type and features
 #
 CONFIG_PLAT_MAPPI=y
@@ -67,8 +91,10 @@ CONFIG_PLAT_MAPPI=y
 # CONFIG_PLAT_OAKS32R is not set
 # CONFIG_PLAT_MAPPI2 is not set
 # CONFIG_PLAT_MAPPI3 is not set
+# CONFIG_PLAT_M32104UT is not set
 CONFIG_CHIP_M32700=y
 # CONFIG_CHIP_M32102 is not set
+# CONFIG_CHIP_M32104 is not set
 # CONFIG_CHIP_VDEC2 is not set
 # CONFIG_CHIP_OPSP is not set
 # CONFIG_MMU is not set
@@ -82,18 +108,31 @@ CONFIG_TIMER_DIVIDE=128
 CONFIG_MEMORY_START=0x00000000
 CONFIG_MEMORY_SIZE=0x00E00000
 CONFIG_NOHIGHMEM=y
-# CONFIG_DISCONTIGMEM is not set
+CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
+CONFIG_SELECT_MEMORY_MODEL=y
+# CONFIG_FLATMEM_MANUAL is not set
+CONFIG_DISCONTIGMEM_MANUAL=y
+# CONFIG_SPARSEMEM_MANUAL is not set
+CONFIG_DISCONTIGMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+CONFIG_NEED_MULTIPLE_NODES=y
+# CONFIG_SPARSEMEM_STATIC is not set
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
+CONFIG_IRAM_START=0x00f00000
+CONFIG_IRAM_SIZE=0x00080000
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_PREEMPT=y
-# CONFIG_HAVE_DEC_LOCK is not set
 # CONFIG_SMP is not set
+CONFIG_NODES_SHIFT=1
 
 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
 #
-# CONFIG_PCI is not set
 # CONFIG_ISA is not set
 
 #
@@ -102,12 +141,14 @@ CONFIG_PREEMPT=y
 CONFIG_PCCARD=y
 # CONFIG_PCMCIA_DEBUG is not set
 CONFIG_PCMCIA=y
+CONFIG_PCMCIA_LOAD_CIS=y
+CONFIG_PCMCIA_IOCTL=y
 
 #
 # PC-card bridges
 #
-# CONFIG_TCIC is not set
 CONFIG_M32R_PCC=y
+CONFIG_PCCARD_NONSTATIC=y
 
 #
 # PCI Hotplug Support
@@ -122,6 +163,94 @@ CONFIG_BINFMT_FLAT=y
 # CONFIG_BINFMT_MISC is not set
 
 #
+# Networking
+#
+CONFIG_NET=y
+
+#
+# Networking options
+#
+# CONFIG_NETDEBUG is not set
+CONFIG_PACKET=y
+# CONFIG_PACKET_MMAP is not set
+CONFIG_UNIX=y
+CONFIG_XFRM=y
+# CONFIG_XFRM_USER is not set
+# CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+# CONFIG_IP_MULTICAST is not set
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+# CONFIG_IP_PNP_BOOTP is not set
+# CONFIG_IP_PNP_RARP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_ARPD is not set
+# CONFIG_SYN_COOKIES is not set
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+CONFIG_INET_XFRM_MODE_TRANSPORT=y
+CONFIG_INET_XFRM_MODE_TUNNEL=y
+CONFIG_INET_XFRM_MODE_BEET=y
+CONFIG_INET_DIAG=y
+CONFIG_INET_TCP_DIAG=y
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_INET6_XFRM_TUNNEL is not set
+# CONFIG_INET6_TUNNEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+
+#
+# DCCP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_DCCP is not set
+
+#
+# SCTP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_SCTP is not set
+
+#
+# TIPC Configuration (EXPERIMENTAL)
+#
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+
+#
+# QoS and/or fair queueing
+#
+# CONFIG_NET_SCHED is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_IEEE80211 is not set
+
+#
 # Device Drivers
 #
 
@@ -130,7 +259,13 @@ CONFIG_BINFMT_FLAT=y
 #
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
-# CONFIG_FW_LOADER is not set
+CONFIG_FW_LOADER=y
+# CONFIG_SYS_HYPERVISOR is not set
+
+#
+# Connector - unified userspace <-> kernelspace linker
+#
+# CONFIG_CONNECTOR is not set
 
 #
 # Memory Technology Devices (MTD)
@@ -149,7 +284,6 @@ CONFIG_PREVENT_FIRMWARE_BUILD=y
 #
 # Block devices
 #
-# CONFIG_BLK_DEV_FD is not set
 # CONFIG_BLK_DEV_COW_COMMON is not set
 CONFIG_BLK_DEV_LOOP=y
 # CONFIG_BLK_DEV_CRYPTOLOOP is not set
@@ -157,18 +291,15 @@ CONFIG_BLK_DEV_NBD=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 # CONFIG_BLK_DEV_INITRD is not set
-CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
 
 #
-# IO Schedulers
+# Misc devices
 #
-CONFIG_IOSCHED_NOOP=y
-# CONFIG_IOSCHED_AS is not set
-CONFIG_IOSCHED_DEADLINE=y
-CONFIG_IOSCHED_CFQ=y
-# CONFIG_ATA_OVER_ETH is not set
+# CONFIG_TIFM_CORE is not set
 
 #
 # ATA/ATAPI/MFM/RLL support
@@ -178,7 +309,13 @@ CONFIG_IOSCHED_CFQ=y
 #
 # SCSI device support
 #
+# CONFIG_RAID_ATTRS is not set
 # CONFIG_SCSI is not set
+# CONFIG_SCSI_NETLINK is not set
+
+#
+# Serial ATA (prod) and Parallel ATA (experimental) drivers
+#
 
 #
 # Multi-device support (RAID and LVM)
@@ -188,6 +325,7 @@ CONFIG_IOSCHED_CFQ=y
 #
 # Fusion MPT device support
 #
+# CONFIG_FUSION is not set
 
 #
 # IEEE 1394 (FireWire) support
@@ -198,69 +336,8 @@ CONFIG_IOSCHED_CFQ=y
 #
 
 #
-# Networking support
-#
-CONFIG_NET=y
-
-#
-# Networking options
-#
-CONFIG_PACKET=y
-# CONFIG_PACKET_MMAP is not set
-CONFIG_UNIX=y
-# CONFIG_NET_KEY is not set
-CONFIG_INET=y
-# CONFIG_IP_MULTICAST is not set
-# CONFIG_IP_ADVANCED_ROUTER is not set
-CONFIG_IP_PNP=y
-CONFIG_IP_PNP_DHCP=y
-# CONFIG_IP_PNP_BOOTP is not set
-# CONFIG_IP_PNP_RARP is not set
-# CONFIG_NET_IPIP is not set
-# CONFIG_NET_IPGRE is not set
-# CONFIG_ARPD is not set
-# CONFIG_SYN_COOKIES is not set
-# CONFIG_INET_AH is not set
-# CONFIG_INET_ESP is not set
-# CONFIG_INET_IPCOMP is not set
-# CONFIG_INET_TUNNEL is not set
-CONFIG_IP_TCPDIAG=y
-# CONFIG_IP_TCPDIAG_IPV6 is not set
-# CONFIG_IPV6 is not set
-# CONFIG_NETFILTER is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
-#
-# CONFIG_IP_SCTP is not set
-# CONFIG_ATM is not set
-# CONFIG_BRIDGE is not set
-# CONFIG_VLAN_8021Q is not set
-# CONFIG_DECNET is not set
-# CONFIG_LLC2 is not set
-# CONFIG_IPX is not set
-# CONFIG_ATALK is not set
-# CONFIG_X25 is not set
-# CONFIG_LAPB is not set
-# CONFIG_NET_DIVERT is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
-# CONFIG_NET_SCHED is not set
-# CONFIG_NET_CLS_ROUTE is not set
-
-#
-# Network testing
+# Network device support
 #
-# CONFIG_NET_PKTGEN is not set
-# CONFIG_NETPOLL is not set
-# CONFIG_NET_POLL_CONTROLLER is not set
-# CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
-# CONFIG_BT is not set
 CONFIG_NETDEVICES=y
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
@@ -268,6 +345,10 @@ CONFIG_NETDEVICES=y
 # CONFIG_TUN is not set
 
 #
+# PHY device support
+#
+
+#
 # Ethernet (10 or 100Mbit)
 #
 # CONFIG_NET_ETHERNET is not set
@@ -303,6 +384,8 @@ CONFIG_NE2000=y
 # CONFIG_SLIP is not set
 # CONFIG_SHAPER is not set
 # CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
 
 #
 # ISDN subsystem
@@ -318,6 +401,7 @@ CONFIG_NE2000=y
 # Input device support
 #
 CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set
 
 #
 # Userland interfaces
@@ -346,7 +430,6 @@ CONFIG_SERIO_SERPORT=y
 # CONFIG_SERIO_LIBPS2 is not set
 # CONFIG_SERIO_RAW is not set
 # CONFIG_GAMEPORT is not set
-CONFIG_SOUND_GAMEPORT=y
 
 #
 # Character devices
@@ -366,7 +449,6 @@ CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
 CONFIG_SERIAL_M32R_SIO=y
 CONFIG_SERIAL_M32R_SIO_CONSOLE=y
-# CONFIG_SERIAL_M32R_PLDSIO is not set
 CONFIG_UNIX98_PTYS=y
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
@@ -380,25 +462,27 @@ CONFIG_LEGACY_PTY_COUNT=256
 # Watchdog Cards
 #
 # CONFIG_WATCHDOG is not set
+CONFIG_HW_RANDOM=y
 # CONFIG_RTC is not set
-# CONFIG_GEN_RTC is not set
 # CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
 
 #
 # Ftape, the floppy tape device driver
 #
-# CONFIG_DRM is not set
 
 #
 # PCMCIA character devices
 #
 # CONFIG_SYNCLINK_CS is not set
+# CONFIG_CARDMAN_4000 is not set
+# CONFIG_CARDMAN_4040 is not set
 # CONFIG_RAW_DRIVER is not set
 
 #
 # TPM devices
 #
+# CONFIG_TCG_TPM is not set
 
 #
 # I2C support
@@ -406,13 +490,25 @@ CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_I2C is not set
 
 #
+# SPI support
+#
+# CONFIG_SPI is not set
+# CONFIG_SPI_MASTER is not set
+
+#
 # Dallas's 1-wire bus
 #
 # CONFIG_W1 is not set
 
 #
-# Misc devices
+# Hardware Monitoring support
 #
+CONFIG_HWMON=y
+# CONFIG_HWMON_VID is not set
+# CONFIG_SENSORS_ABITUGURU is not set
+# CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_VT1211 is not set
+# CONFIG_HWMON_DEBUG_CHIP is not set
 
 #
 # Multimedia devices
@@ -427,7 +523,9 @@ CONFIG_LEGACY_PTY_COUNT=256
 #
 # Graphics support
 #
+CONFIG_FIRMWARE_EDID=y
 # CONFIG_FB is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
 # Sound
@@ -439,6 +537,11 @@ CONFIG_LEGACY_PTY_COUNT=256
 #
 # CONFIG_USB_ARCH_HAS_HCD is not set
 # CONFIG_USB_ARCH_HAS_OHCI is not set
+# CONFIG_USB_ARCH_HAS_EHCI is not set
+
+#
+# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+#
 
 #
 # USB Gadget Support
@@ -451,30 +554,72 @@ CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_MMC is not set
 
 #
+# LED devices
+#
+# CONFIG_NEW_LEDS is not set
+
+#
+# LED drivers
+#
+
+#
+# LED Triggers
+#
+
+#
 # InfiniBand support
 #
-# CONFIG_INFINIBAND is not set
+
+#
+# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
+#
+
+#
+# Real Time Clock
+#
+# CONFIG_RTC_CLASS is not set
+
+#
+# DMA Engine support
+#
+# CONFIG_DMA_ENGINE is not set
+
+#
+# DMA Clients
+#
+
+#
+# DMA Devices
+#
 
 #
 # File systems
 #
 CONFIG_EXT2_FS=y
 # CONFIG_EXT2_FS_XATTR is not set
-# CONFIG_EXT3_FS is not set
-# CONFIG_JBD is not set
+CONFIG_EXT3_FS=y
+CONFIG_EXT3_FS_XATTR=y
+# CONFIG_EXT3_FS_POSIX_ACL is not set
+# CONFIG_EXT3_FS_SECURITY is not set
+# CONFIG_EXT4DEV_FS is not set
+CONFIG_JBD=y
+# CONFIG_JBD_DEBUG is not set
+CONFIG_FS_MBCACHE=y
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
-
-#
-# XFS support
-#
+# CONFIG_FS_POSIX_ACL is not set
 # CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
 # CONFIG_MINIX_FS is not set
 # CONFIG_ROMFS_FS is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
 CONFIG_DNOTIFY=y
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
 
 #
 # CD-ROM/DVD Filesystems
@@ -493,15 +638,12 @@ CONFIG_DNOTIFY=y
 # Pseudo filesystems
 #
 CONFIG_PROC_FS=y
+CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
-CONFIG_DEVFS_FS=y
-CONFIG_DEVFS_MOUNT=y
-# CONFIG_DEVFS_DEBUG is not set
-CONFIG_DEVPTS_FS_XATTR=y
-CONFIG_DEVPTS_FS_SECURITY=y
 # CONFIG_TMPFS is not set
 # CONFIG_HUGETLB_PAGE is not set
 CONFIG_RAMFS=y
+# CONFIG_CONFIGFS_FS is not set
 
 #
 # Miscellaneous filesystems
@@ -525,12 +667,14 @@ CONFIG_RAMFS=y
 #
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
 # CONFIG_NFS_V4 is not set
 # CONFIG_NFS_DIRECTIO is not set
 # CONFIG_NFSD is not set
 CONFIG_ROOT_NFS=y
 CONFIG_LOCKD=y
 CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
 # CONFIG_RPCSEC_GSS_KRB5 is not set
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
@@ -539,6 +683,7 @@ CONFIG_SUNRPC=y
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
+# CONFIG_9P_FS is not set
 
 #
 # Partition Types
@@ -599,10 +744,16 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 # Kernel hacking
 #
 # CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_MUST_CHECK=y
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
 # CONFIG_DEBUG_KERNEL is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_DEBUG_FS is not set
 # CONFIG_FRAME_POINTER is not set
+# CONFIG_UNWIND_INFO is not set
+# CONFIG_HEADERS_CHECK is not set
 
 #
 # Security options
@@ -616,12 +767,9 @@ CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CRYPTO is not set
 
 #
-# Hardware crypto devices
-#
-
-#
 # Library routines
 #
 # CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
 CONFIG_CRC32=y
 # CONFIG_LIBCRC32C is not set
diff -puN arch/m32r/mappi/defconfig.smp~m32r-update-defconfig-files-for-v2619 arch/m32r/mappi/defconfig.smp
--- a/arch/m32r/mappi/defconfig.smp~m32r-update-defconfig-files-for-v2619
+++ a/arch/m32r/mappi/defconfig.smp
@@ -1,21 +1,18 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.12-rc5
-# Fri Jun  3 16:21:52 2005
+# Linux kernel version: 2.6.19
+# Wed Dec 13 17:50:59 2006
 #
 CONFIG_M32R=y
-# CONFIG_UID16 is not set
 CONFIG_GENERIC_ISA_DMA=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
 # Code maturity level options
 #
 CONFIG_EXPERIMENTAL=y
-# CONFIG_CLEAN_COMPILE is not set
-CONFIG_BROKEN=y
-CONFIG_BROKEN_ON_SMP=y
 CONFIG_LOCK_KERNEL=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
 
@@ -23,32 +20,39 @@ CONFIG_INIT_ENV_ARG_LIMIT=32
 # General setup
 #
 CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SWAP=y
 CONFIG_SYSVIPC=y
+# CONFIG_IPC_NS is not set
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
-CONFIG_SYSCTL=y
+# CONFIG_TASKSTATS is not set
+# CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
-CONFIG_HOTPLUG=y
-CONFIG_KOBJECT_UEVENT=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 # CONFIG_CPUSETS is not set
+CONFIG_SYSFS_DEPRECATED=y
+# CONFIG_RELAY is not set
+CONFIG_INITRAMFS_SOURCE=""
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
 CONFIG_EMBEDDED=y
+CONFIG_SYSCTL_SYSCALL=y
 # CONFIG_KALLSYMS is not set
+CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
+CONFIG_ELF_CORE=y
 CONFIG_BASE_FULL=y
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SHMEM=y
-CONFIG_CC_ALIGN_FUNCTIONS=0
-CONFIG_CC_ALIGN_LABELS=0
-CONFIG_CC_ALIGN_LOOPS=0
-CONFIG_CC_ALIGN_JUMPS=0
+CONFIG_SLAB=y
+CONFIG_VM_EVENT_COUNTERS=y
 # CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=0
+# CONFIG_SLOB is not set
 
 #
 # Loadable module support
@@ -56,13 +60,31 @@ CONFIG_BASE_SMALL=0
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
-CONFIG_OBSOLETE_MODPARM=y
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_KMOD=y
 CONFIG_STOP_MACHINE=y
 
 #
+# Block layer
+#
+CONFIG_BLOCK=y
+# CONFIG_BLK_DEV_IO_TRACE is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+# CONFIG_IOSCHED_AS is not set
+CONFIG_IOSCHED_DEADLINE=y
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_AS is not set
+# CONFIG_DEFAULT_DEADLINE is not set
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
+
+#
 # Processor type and features
 #
 CONFIG_PLAT_MAPPI=y
@@ -72,8 +94,10 @@ CONFIG_PLAT_MAPPI=y
 # CONFIG_PLAT_OAKS32R is not set
 # CONFIG_PLAT_MAPPI2 is not set
 # CONFIG_PLAT_MAPPI3 is not set
+# CONFIG_PLAT_M32104UT is not set
 CONFIG_CHIP_M32700=y
 # CONFIG_CHIP_M32102 is not set
+# CONFIG_CHIP_M32104 is not set
 # CONFIG_CHIP_VDEC2 is not set
 # CONFIG_CHIP_OPSP is not set
 CONFIG_MMU=y
@@ -87,23 +111,33 @@ CONFIG_TIMER_DIVIDE=128
 CONFIG_MEMORY_START=0x08000000
 CONFIG_MEMORY_SIZE=0x04000000
 CONFIG_NOHIGHMEM=y
+CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
+CONFIG_SELECT_MEMORY_MODEL=y
+# CONFIG_FLATMEM_MANUAL is not set
+CONFIG_DISCONTIGMEM_MANUAL=y
+# CONFIG_SPARSEMEM_MANUAL is not set
 CONFIG_DISCONTIGMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+CONFIG_NEED_MULTIPLE_NODES=y
+# CONFIG_SPARSEMEM_STATIC is not set
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
 CONFIG_IRAM_START=0x00f00000
 CONFIG_IRAM_SIZE=0x00080000
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_PREEMPT=y
-# CONFIG_HAVE_DEC_LOCK is not set
 CONFIG_SMP=y
 CONFIG_CHIP_M32700_TS1=y
 CONFIG_NR_CPUS=2
-# CONFIG_NUMA is not set
+CONFIG_NODES_SHIFT=1
 
 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
 #
-# CONFIG_PCI is not set
 # CONFIG_ISA is not set
 
 #
@@ -112,12 +146,14 @@ CONFIG_NR_CPUS=2
 CONFIG_PCCARD=y
 # CONFIG_PCMCIA_DEBUG is not set
 CONFIG_PCMCIA=y
+CONFIG_PCMCIA_LOAD_CIS=y
+CONFIG_PCMCIA_IOCTL=y
 
 #
 # PC-card bridges
 #
-# CONFIG_TCIC is not set
 CONFIG_M32R_PCC=y
+CONFIG_PCCARD_NONSTATIC=y
 
 #
 # PCI Hotplug Support
@@ -130,6 +166,93 @@ CONFIG_BINFMT_ELF=y
 # CONFIG_BINFMT_MISC is not set
 
 #
+# Networking
+#
+CONFIG_NET=y
+
+#
+# Networking options
+#
+# CONFIG_NETDEBUG is not set
+# CONFIG_PACKET is not set
+CONFIG_UNIX=y
+CONFIG_XFRM=y
+# CONFIG_XFRM_USER is not set
+# CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+# CONFIG_IP_MULTICAST is not set
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+# CONFIG_IP_PNP_BOOTP is not set
+# CONFIG_IP_PNP_RARP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_ARPD is not set
+# CONFIG_SYN_COOKIES is not set
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+CONFIG_INET_XFRM_MODE_TRANSPORT=y
+CONFIG_INET_XFRM_MODE_TUNNEL=y
+CONFIG_INET_XFRM_MODE_BEET=y
+CONFIG_INET_DIAG=y
+CONFIG_INET_TCP_DIAG=y
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_INET6_XFRM_TUNNEL is not set
+# CONFIG_INET6_TUNNEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+
+#
+# DCCP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_DCCP is not set
+
+#
+# SCTP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_SCTP is not set
+
+#
+# TIPC Configuration (EXPERIMENTAL)
+#
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+
+#
+# QoS and/or fair queueing
+#
+# CONFIG_NET_SCHED is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_IEEE80211 is not set
+
+#
 # Device Drivers
 #
 
@@ -138,7 +261,13 @@ CONFIG_BINFMT_ELF=y
 #
 # CONFIG_STANDALONE is not set
 CONFIG_PREVENT_FIRMWARE_BUILD=y
-# CONFIG_FW_LOADER is not set
+CONFIG_FW_LOADER=y
+# CONFIG_SYS_HYPERVISOR is not set
+
+#
+# Connector - unified userspace <-> kernelspace linker
+#
+# CONFIG_CONNECTOR is not set
 
 #
 # Memory Technology Devices (MTD)
@@ -161,6 +290,8 @@ CONFIG_MTD_BLOCK=y
 # CONFIG_FTL is not set
 # CONFIG_NFTL is not set
 # CONFIG_INFTL is not set
+# CONFIG_RFD_FTL is not set
+# CONFIG_SSFDC is not set
 
 #
 # RAM/ROM/Flash chip drivers
@@ -186,6 +317,7 @@ CONFIG_MTD_CFI_I2=y
 # Mapping drivers for chip access
 #
 # CONFIG_MTD_COMPLEX_MAPPINGS is not set
+# CONFIG_MTD_PLATRAM is not set
 
 #
 # Self-contained MTD device drivers
@@ -193,7 +325,6 @@ CONFIG_MTD_CFI_I2=y
 # CONFIG_MTD_SLRAM is not set
 # CONFIG_MTD_PHRAM is not set
 # CONFIG_MTD_MTDRAM is not set
-# CONFIG_MTD_BLKMTD is not set
 # CONFIG_MTD_BLOCK2MTD is not set
 
 #
@@ -209,6 +340,11 @@ CONFIG_MTD_CFI_I2=y
 # CONFIG_MTD_NAND is not set
 
 #
+# OneNAND Flash Device Drivers
+#
+# CONFIG_MTD_ONENAND is not set
+
+#
 # Parallel port support
 #
 # CONFIG_PARPORT is not set
@@ -220,7 +356,6 @@ CONFIG_MTD_CFI_I2=y
 #
 # Block devices
 #
-# CONFIG_BLK_DEV_FD is not set
 # CONFIG_BLK_DEV_COW_COMMON is not set
 CONFIG_BLK_DEV_LOOP=y
 # CONFIG_BLK_DEV_CRYPTOLOOP is not set
@@ -228,23 +363,21 @@ CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
 
 #
-# IO Schedulers
+# Misc devices
 #
-CONFIG_IOSCHED_NOOP=y
-# CONFIG_IOSCHED_AS is not set
-CONFIG_IOSCHED_DEADLINE=y
-CONFIG_IOSCHED_CFQ=y
-# CONFIG_ATA_OVER_ETH is not set
+# CONFIG_TIFM_CORE is not set
 
 #
 # ATA/ATAPI/MFM/RLL support
 #
 CONFIG_IDE=m
+CONFIG_IDE_MAX_HWIFS=4
 CONFIG_BLK_DEV_IDE=m
 
 #
@@ -271,7 +404,13 @@ CONFIG_IDE_GENERIC=m
 #
 # SCSI device support
 #
+# CONFIG_RAID_ATTRS is not set
 # CONFIG_SCSI is not set
+# CONFIG_SCSI_NETLINK is not set
+
+#
+# Serial ATA (prod) and Parallel ATA (experimental) drivers
+#
 
 #
 # Multi-device support (RAID and LVM)
@@ -281,79 +420,19 @@ CONFIG_IDE_GENERIC=m
 #
 # Fusion MPT device support
 #
+# CONFIG_FUSION is not set
 
 #
 # IEEE 1394 (FireWire) support
 #
-# CONFIG_IEEE1394 is not set
 
 #
 # I2O device support
 #
 
 #
-# Networking support
+# Network device support
 #
-CONFIG_NET=y
-
-#
-# Networking options
-#
-# CONFIG_PACKET is not set
-CONFIG_UNIX=y
-# CONFIG_NET_KEY is not set
-CONFIG_INET=y
-# CONFIG_IP_MULTICAST is not set
-# CONFIG_IP_ADVANCED_ROUTER is not set
-CONFIG_IP_PNP=y
-CONFIG_IP_PNP_DHCP=y
-# CONFIG_IP_PNP_BOOTP is not set
-# CONFIG_IP_PNP_RARP is not set
-# CONFIG_NET_IPIP is not set
-# CONFIG_NET_IPGRE is not set
-# CONFIG_ARPD is not set
-# CONFIG_SYN_COOKIES is not set
-# CONFIG_INET_AH is not set
-# CONFIG_INET_ESP is not set
-# CONFIG_INET_IPCOMP is not set
-# CONFIG_INET_TUNNEL is not set
-CONFIG_IP_TCPDIAG=y
-# CONFIG_IP_TCPDIAG_IPV6 is not set
-# CONFIG_IPV6 is not set
-# CONFIG_NETFILTER is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
-#
-# CONFIG_IP_SCTP is not set
-# CONFIG_ATM is not set
-# CONFIG_BRIDGE is not set
-# CONFIG_VLAN_8021Q is not set
-# CONFIG_DECNET is not set
-# CONFIG_LLC2 is not set
-# CONFIG_IPX is not set
-# CONFIG_ATALK is not set
-# CONFIG_X25 is not set
-# CONFIG_LAPB is not set
-# CONFIG_NET_DIVERT is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
-# CONFIG_NET_SCHED is not set
-# CONFIG_NET_CLS_ROUTE is not set
-
-#
-# Network testing
-#
-# CONFIG_NET_PKTGEN is not set
-# CONFIG_NETPOLL is not set
-# CONFIG_NET_POLL_CONTROLLER is not set
-# CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
-# CONFIG_BT is not set
 CONFIG_NETDEVICES=y
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
@@ -361,6 +440,10 @@ CONFIG_NETDEVICES=y
 # CONFIG_TUN is not set
 
 #
+# PHY device support
+#
+
+#
 # Ethernet (10 or 100Mbit)
 #
 # CONFIG_NET_ETHERNET is not set
@@ -396,6 +479,8 @@ CONFIG_NE2000=y
 # CONFIG_SLIP is not set
 # CONFIG_SHAPER is not set
 # CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
 
 #
 # ISDN subsystem
@@ -411,6 +496,7 @@ CONFIG_NE2000=y
 # Input device support
 #
 CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set
 
 #
 # Userland interfaces
@@ -442,7 +528,6 @@ CONFIG_SERIO=y
 # CONFIG_SERIO_LIBPS2 is not set
 # CONFIG_SERIO_RAW is not set
 # CONFIG_GAMEPORT is not set
-CONFIG_SOUND_GAMEPORT=y
 
 #
 # Character devices
@@ -462,7 +547,6 @@ CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
 CONFIG_SERIAL_M32R_SIO=y
 CONFIG_SERIAL_M32R_SIO_CONSOLE=y
-# CONFIG_SERIAL_M32R_PLDSIO is not set
 CONFIG_UNIX98_PTYS=y
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
@@ -476,25 +560,27 @@ CONFIG_LEGACY_PTY_COUNT=256
 # Watchdog Cards
 #
 # CONFIG_WATCHDOG is not set
+CONFIG_HW_RANDOM=y
 # CONFIG_RTC is not set
-# CONFIG_GEN_RTC is not set
 # CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
 
 #
 # Ftape, the floppy tape device driver
 #
-# CONFIG_DRM is not set
 
 #
 # PCMCIA character devices
 #
 # CONFIG_SYNCLINK_CS is not set
+# CONFIG_CARDMAN_4000 is not set
+# CONFIG_CARDMAN_4040 is not set
 # CONFIG_RAW_DRIVER is not set
 
 #
 # TPM devices
 #
+# CONFIG_TCG_TPM is not set
 
 #
 # I2C support
@@ -502,13 +588,25 @@ CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_I2C is not set
 
 #
+# SPI support
+#
+# CONFIG_SPI is not set
+# CONFIG_SPI_MASTER is not set
+
+#
 # Dallas's 1-wire bus
 #
 # CONFIG_W1 is not set
 
 #
-# Misc devices
+# Hardware Monitoring support
 #
+CONFIG_HWMON=y
+# CONFIG_HWMON_VID is not set
+# CONFIG_SENSORS_ABITUGURU is not set
+# CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_VT1211 is not set
+# CONFIG_HWMON_DEBUG_CHIP is not set
 
 #
 # Multimedia devices
@@ -523,7 +621,9 @@ CONFIG_LEGACY_PTY_COUNT=256
 #
 # Graphics support
 #
+CONFIG_FIRMWARE_EDID=y
 # CONFIG_FB is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
 # Sound
@@ -535,6 +635,11 @@ CONFIG_LEGACY_PTY_COUNT=256
 #
 # CONFIG_USB_ARCH_HAS_HCD is not set
 # CONFIG_USB_ARCH_HAS_OHCI is not set
+# CONFIG_USB_ARCH_HAS_EHCI is not set
+
+#
+# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+#
 
 #
 # USB Gadget Support
@@ -547,30 +652,73 @@ CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_MMC is not set
 
 #
+# LED devices
+#
+# CONFIG_NEW_LEDS is not set
+
+#
+# LED drivers
+#
+
+#
+# LED Triggers
+#
+
+#
 # InfiniBand support
 #
-# CONFIG_INFINIBAND is not set
+
+#
+# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
+#
+
+#
+# Real Time Clock
+#
+# CONFIG_RTC_CLASS is not set
+
+#
+# DMA Engine support
+#
+# CONFIG_DMA_ENGINE is not set
+
+#
+# DMA Clients
+#
+
+#
+# DMA Devices
+#
 
 #
 # File systems
 #
 CONFIG_EXT2_FS=y
 # CONFIG_EXT2_FS_XATTR is not set
-# CONFIG_EXT3_FS is not set
-# CONFIG_JBD is not set
+# CONFIG_EXT2_FS_XIP is not set
+CONFIG_EXT3_FS=y
+CONFIG_EXT3_FS_XATTR=y
+# CONFIG_EXT3_FS_POSIX_ACL is not set
+# CONFIG_EXT3_FS_SECURITY is not set
+# CONFIG_EXT4DEV_FS is not set
+CONFIG_JBD=y
+# CONFIG_JBD_DEBUG is not set
+CONFIG_FS_MBCACHE=y
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
-
-#
-# XFS support
-#
+# CONFIG_FS_POSIX_ACL is not set
 # CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
 # CONFIG_MINIX_FS is not set
 CONFIG_ROMFS_FS=y
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
 CONFIG_DNOTIFY=y
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
 
 #
 # CD-ROM/DVD Filesystems
@@ -595,16 +743,13 @@ CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
 #
 CONFIG_PROC_FS=y
 CONFIG_PROC_KCORE=y
+CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
-CONFIG_DEVFS_FS=y
-CONFIG_DEVFS_MOUNT=y
-# CONFIG_DEVFS_DEBUG is not set
-# CONFIG_DEVPTS_FS_XATTR is not set
 CONFIG_TMPFS=y
-# CONFIG_TMPFS_XATTR is not set
-# CONFIG_HUGETLBFS is not set
+# CONFIG_TMPFS_POSIX_ACL is not set
 # CONFIG_HUGETLB_PAGE is not set
 CONFIG_RAMFS=y
+# CONFIG_CONFIGFS_FS is not set
 
 #
 # Miscellaneous filesystems
@@ -621,8 +766,9 @@ CONFIG_JFFS_FS_VERBOSE=0
 CONFIG_JFFS_PROC_FS=y
 CONFIG_JFFS2_FS=y
 CONFIG_JFFS2_FS_DEBUG=0
-# CONFIG_JFFS2_FS_NAND is not set
-# CONFIG_JFFS2_FS_NOR_ECC is not set
+CONFIG_JFFS2_FS_WRITEBUFFER=y
+# CONFIG_JFFS2_SUMMARY is not set
+# CONFIG_JFFS2_FS_XATTR is not set
 # CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
 CONFIG_JFFS2_ZLIB=y
 CONFIG_JFFS2_RTIME=y
@@ -639,12 +785,14 @@ CONFIG_JFFS2_RTIME=y
 #
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
 # CONFIG_NFS_V4 is not set
 # CONFIG_NFS_DIRECTIO is not set
 # CONFIG_NFSD is not set
 CONFIG_ROOT_NFS=y
 CONFIG_LOCKD=y
 CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
 # CONFIG_RPCSEC_GSS_KRB5 is not set
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
@@ -653,6 +801,7 @@ CONFIG_SUNRPC=y
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
+# CONFIG_9P_FS is not set
 
 #
 # Partition Types
@@ -713,10 +862,16 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 # Kernel hacking
 #
 # CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_MUST_CHECK=y
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
 # CONFIG_DEBUG_KERNEL is not set
 CONFIG_LOG_BUF_SHIFT=15
 # CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_DEBUG_FS is not set
 # CONFIG_FRAME_POINTER is not set
+# CONFIG_UNWIND_INFO is not set
+# CONFIG_HEADERS_CHECK is not set
 
 #
 # Security options
@@ -730,13 +885,10 @@ CONFIG_LOG_BUF_SHIFT=15
 # CONFIG_CRYPTO is not set
 
 #
-# Hardware crypto devices
-#
-
-#
 # Library routines
 #
 # CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
 CONFIG_CRC32=y
 # CONFIG_LIBCRC32C is not set
 CONFIG_ZLIB_INFLATE=y
diff -puN arch/m32r/mappi/defconfig.up~m32r-update-defconfig-files-for-v2619 arch/m32r/mappi/defconfig.up
--- a/arch/m32r/mappi/defconfig.up~m32r-update-defconfig-files-for-v2619
+++ a/arch/m32r/mappi/defconfig.up
@@ -1,20 +1,18 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.12-rc5
-# Fri Jun  3 16:21:59 2005
+# Linux kernel version: 2.6.19
+# Wed Dec 13 17:51:20 2006
 #
 CONFIG_M32R=y
-# CONFIG_UID16 is not set
 CONFIG_GENERIC_ISA_DMA=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
 # Code maturity level options
 #
 CONFIG_EXPERIMENTAL=y
-# CONFIG_CLEAN_COMPILE is not set
-CONFIG_BROKEN=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_LOCK_KERNEL=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
@@ -23,31 +21,38 @@ CONFIG_INIT_ENV_ARG_LIMIT=32
 # General setup
 #
 CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SWAP=y
 CONFIG_SYSVIPC=y
+# CONFIG_IPC_NS is not set
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
-CONFIG_SYSCTL=y
+# CONFIG_TASKSTATS is not set
+# CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
-CONFIG_HOTPLUG=y
-CONFIG_KOBJECT_UEVENT=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
+CONFIG_SYSFS_DEPRECATED=y
+# CONFIG_RELAY is not set
+CONFIG_INITRAMFS_SOURCE=""
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
 CONFIG_EMBEDDED=y
+CONFIG_SYSCTL_SYSCALL=y
 # CONFIG_KALLSYMS is not set
+CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
+CONFIG_ELF_CORE=y
 CONFIG_BASE_FULL=y
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SHMEM=y
-CONFIG_CC_ALIGN_FUNCTIONS=0
-CONFIG_CC_ALIGN_LABELS=0
-CONFIG_CC_ALIGN_LOOPS=0
-CONFIG_CC_ALIGN_JUMPS=0
+CONFIG_SLAB=y
+CONFIG_VM_EVENT_COUNTERS=y
 # CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=0
+# CONFIG_SLOB is not set
 
 #
 # Loadable module support
@@ -55,12 +60,30 @@ CONFIG_BASE_SMALL=0
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
-CONFIG_OBSOLETE_MODPARM=y
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_KMOD=y
 
 #
+# Block layer
+#
+CONFIG_BLOCK=y
+# CONFIG_BLK_DEV_IO_TRACE is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+# CONFIG_IOSCHED_AS is not set
+CONFIG_IOSCHED_DEADLINE=y
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_AS is not set
+# CONFIG_DEFAULT_DEADLINE is not set
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
+
+#
 # Processor type and features
 #
 CONFIG_PLAT_MAPPI=y
@@ -70,8 +93,10 @@ CONFIG_PLAT_MAPPI=y
 # CONFIG_PLAT_OAKS32R is not set
 # CONFIG_PLAT_MAPPI2 is not set
 # CONFIG_PLAT_MAPPI3 is not set
+# CONFIG_PLAT_M32104UT is not set
 CONFIG_CHIP_M32700=y
 # CONFIG_CHIP_M32102 is not set
+# CONFIG_CHIP_M32104 is not set
 # CONFIG_CHIP_VDEC2 is not set
 # CONFIG_CHIP_OPSP is not set
 CONFIG_MMU=y
@@ -85,20 +110,31 @@ CONFIG_TIMER_DIVIDE=128
 CONFIG_MEMORY_START=0x08000000
 CONFIG_MEMORY_SIZE=0x04000000
 CONFIG_NOHIGHMEM=y
+CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
+CONFIG_SELECT_MEMORY_MODEL=y
+# CONFIG_FLATMEM_MANUAL is not set
+CONFIG_DISCONTIGMEM_MANUAL=y
+# CONFIG_SPARSEMEM_MANUAL is not set
 CONFIG_DISCONTIGMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+CONFIG_NEED_MULTIPLE_NODES=y
+# CONFIG_SPARSEMEM_STATIC is not set
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
 CONFIG_IRAM_START=0x00f00000
 CONFIG_IRAM_SIZE=0x00080000
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_PREEMPT=y
-# CONFIG_HAVE_DEC_LOCK is not set
 # CONFIG_SMP is not set
+CONFIG_NODES_SHIFT=1
 
 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
 #
-# CONFIG_PCI is not set
 # CONFIG_ISA is not set
 
 #
@@ -107,12 +143,14 @@ CONFIG_PREEMPT=y
 CONFIG_PCCARD=y
 # CONFIG_PCMCIA_DEBUG is not set
 CONFIG_PCMCIA=y
+CONFIG_PCMCIA_LOAD_CIS=y
+CONFIG_PCMCIA_IOCTL=y
 
 #
 # PC-card bridges
 #
-# CONFIG_TCIC is not set
 CONFIG_M32R_PCC=y
+CONFIG_PCCARD_NONSTATIC=y
 
 #
 # PCI Hotplug Support
@@ -125,6 +163,93 @@ CONFIG_BINFMT_ELF=y
 # CONFIG_BINFMT_MISC is not set
 
 #
+# Networking
+#
+CONFIG_NET=y
+
+#
+# Networking options
+#
+# CONFIG_NETDEBUG is not set
+# CONFIG_PACKET is not set
+CONFIG_UNIX=y
+CONFIG_XFRM=y
+# CONFIG_XFRM_USER is not set
+# CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+# CONFIG_IP_MULTICAST is not set
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+# CONFIG_IP_PNP_BOOTP is not set
+# CONFIG_IP_PNP_RARP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_ARPD is not set
+# CONFIG_SYN_COOKIES is not set
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+CONFIG_INET_XFRM_MODE_TRANSPORT=y
+CONFIG_INET_XFRM_MODE_TUNNEL=y
+CONFIG_INET_XFRM_MODE_BEET=y
+CONFIG_INET_DIAG=y
+CONFIG_INET_TCP_DIAG=y
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_INET6_XFRM_TUNNEL is not set
+# CONFIG_INET6_TUNNEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+
+#
+# DCCP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_DCCP is not set
+
+#
+# SCTP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_SCTP is not set
+
+#
+# TIPC Configuration (EXPERIMENTAL)
+#
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+
+#
+# QoS and/or fair queueing
+#
+# CONFIG_NET_SCHED is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_IEEE80211 is not set
+
+#
 # Device Drivers
 #
 
@@ -133,7 +258,13 @@ CONFIG_BINFMT_ELF=y
 #
 # CONFIG_STANDALONE is not set
 CONFIG_PREVENT_FIRMWARE_BUILD=y
-# CONFIG_FW_LOADER is not set
+CONFIG_FW_LOADER=y
+# CONFIG_SYS_HYPERVISOR is not set
+
+#
+# Connector - unified userspace <-> kernelspace linker
+#
+# CONFIG_CONNECTOR is not set
 
 #
 # Memory Technology Devices (MTD)
@@ -156,6 +287,8 @@ CONFIG_MTD_BLOCK=y
 # CONFIG_FTL is not set
 # CONFIG_NFTL is not set
 # CONFIG_INFTL is not set
+# CONFIG_RFD_FTL is not set
+# CONFIG_SSFDC is not set
 
 #
 # RAM/ROM/Flash chip drivers
@@ -181,6 +314,7 @@ CONFIG_MTD_CFI_I2=y
 # Mapping drivers for chip access
 #
 # CONFIG_MTD_COMPLEX_MAPPINGS is not set
+# CONFIG_MTD_PLATRAM is not set
 
 #
 # Self-contained MTD device drivers
@@ -188,7 +322,6 @@ CONFIG_MTD_CFI_I2=y
 # CONFIG_MTD_SLRAM is not set
 # CONFIG_MTD_PHRAM is not set
 # CONFIG_MTD_MTDRAM is not set
-# CONFIG_MTD_BLKMTD is not set
 # CONFIG_MTD_BLOCK2MTD is not set
 
 #
@@ -204,6 +337,11 @@ CONFIG_MTD_CFI_I2=y
 # CONFIG_MTD_NAND is not set
 
 #
+# OneNAND Flash Device Drivers
+#
+# CONFIG_MTD_ONENAND is not set
+
+#
 # Parallel port support
 #
 # CONFIG_PARPORT is not set
@@ -215,7 +353,6 @@ CONFIG_MTD_CFI_I2=y
 #
 # Block devices
 #
-# CONFIG_BLK_DEV_FD is not set
 # CONFIG_BLK_DEV_COW_COMMON is not set
 CONFIG_BLK_DEV_LOOP=y
 # CONFIG_BLK_DEV_CRYPTOLOOP is not set
@@ -223,23 +360,21 @@ CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
 
 #
-# IO Schedulers
+# Misc devices
 #
-CONFIG_IOSCHED_NOOP=y
-# CONFIG_IOSCHED_AS is not set
-CONFIG_IOSCHED_DEADLINE=y
-CONFIG_IOSCHED_CFQ=y
-# CONFIG_ATA_OVER_ETH is not set
+# CONFIG_TIFM_CORE is not set
 
 #
 # ATA/ATAPI/MFM/RLL support
 #
 CONFIG_IDE=m
+CONFIG_IDE_MAX_HWIFS=4
 CONFIG_BLK_DEV_IDE=m
 
 #
@@ -266,7 +401,13 @@ CONFIG_IDE_GENERIC=m
 #
 # SCSI device support
 #
+# CONFIG_RAID_ATTRS is not set
 # CONFIG_SCSI is not set
+# CONFIG_SCSI_NETLINK is not set
+
+#
+# Serial ATA (prod) and Parallel ATA (experimental) drivers
+#
 
 #
 # Multi-device support (RAID and LVM)
@@ -276,79 +417,19 @@ CONFIG_IDE_GENERIC=m
 #
 # Fusion MPT device support
 #
+# CONFIG_FUSION is not set
 
 #
 # IEEE 1394 (FireWire) support
 #
-# CONFIG_IEEE1394 is not set
 
 #
 # I2O device support
 #
 
 #
-# Networking support
+# Network device support
 #
-CONFIG_NET=y
-
-#
-# Networking options
-#
-# CONFIG_PACKET is not set
-CONFIG_UNIX=y
-# CONFIG_NET_KEY is not set
-CONFIG_INET=y
-# CONFIG_IP_MULTICAST is not set
-# CONFIG_IP_ADVANCED_ROUTER is not set
-CONFIG_IP_PNP=y
-CONFIG_IP_PNP_DHCP=y
-# CONFIG_IP_PNP_BOOTP is not set
-# CONFIG_IP_PNP_RARP is not set
-# CONFIG_NET_IPIP is not set
-# CONFIG_NET_IPGRE is not set
-# CONFIG_ARPD is not set
-# CONFIG_SYN_COOKIES is not set
-# CONFIG_INET_AH is not set
-# CONFIG_INET_ESP is not set
-# CONFIG_INET_IPCOMP is not set
-# CONFIG_INET_TUNNEL is not set
-CONFIG_IP_TCPDIAG=y
-# CONFIG_IP_TCPDIAG_IPV6 is not set
-# CONFIG_IPV6 is not set
-# CONFIG_NETFILTER is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
-#
-# CONFIG_IP_SCTP is not set
-# CONFIG_ATM is not set
-# CONFIG_BRIDGE is not set
-# CONFIG_VLAN_8021Q is not set
-# CONFIG_DECNET is not set
-# CONFIG_LLC2 is not set
-# CONFIG_IPX is not set
-# CONFIG_ATALK is not set
-# CONFIG_X25 is not set
-# CONFIG_LAPB is not set
-# CONFIG_NET_DIVERT is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
-# CONFIG_NET_SCHED is not set
-# CONFIG_NET_CLS_ROUTE is not set
-
-#
-# Network testing
-#
-# CONFIG_NET_PKTGEN is not set
-# CONFIG_NETPOLL is not set
-# CONFIG_NET_POLL_CONTROLLER is not set
-# CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
-# CONFIG_BT is not set
 CONFIG_NETDEVICES=y
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
@@ -356,6 +437,10 @@ CONFIG_NETDEVICES=y
 # CONFIG_TUN is not set
 
 #
+# PHY device support
+#
+
+#
 # Ethernet (10 or 100Mbit)
 #
 # CONFIG_NET_ETHERNET is not set
@@ -391,6 +476,8 @@ CONFIG_NE2000=y
 # CONFIG_SLIP is not set
 # CONFIG_SHAPER is not set
 # CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
 
 #
 # ISDN subsystem
@@ -406,6 +493,7 @@ CONFIG_NE2000=y
 # Input device support
 #
 CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set
 
 #
 # Userland interfaces
@@ -437,7 +525,6 @@ CONFIG_SERIO=y
 # CONFIG_SERIO_LIBPS2 is not set
 # CONFIG_SERIO_RAW is not set
 # CONFIG_GAMEPORT is not set
-CONFIG_SOUND_GAMEPORT=y
 
 #
 # Character devices
@@ -457,7 +544,6 @@ CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
 CONFIG_SERIAL_M32R_SIO=y
 CONFIG_SERIAL_M32R_SIO_CONSOLE=y
-# CONFIG_SERIAL_M32R_PLDSIO is not set
 CONFIG_UNIX98_PTYS=y
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
@@ -471,25 +557,27 @@ CONFIG_LEGACY_PTY_COUNT=256
 # Watchdog Cards
 #
 # CONFIG_WATCHDOG is not set
+CONFIG_HW_RANDOM=y
 # CONFIG_RTC is not set
-# CONFIG_GEN_RTC is not set
 # CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
 
 #
 # Ftape, the floppy tape device driver
 #
-# CONFIG_DRM is not set
 
 #
 # PCMCIA character devices
 #
 # CONFIG_SYNCLINK_CS is not set
+# CONFIG_CARDMAN_4000 is not set
+# CONFIG_CARDMAN_4040 is not set
 # CONFIG_RAW_DRIVER is not set
 
 #
 # TPM devices
 #
+# CONFIG_TCG_TPM is not set
 
 #
 # I2C support
@@ -497,13 +585,25 @@ CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_I2C is not set
 
 #
+# SPI support
+#
+# CONFIG_SPI is not set
+# CONFIG_SPI_MASTER is not set
+
+#
 # Dallas's 1-wire bus
 #
 # CONFIG_W1 is not set
 
 #
-# Misc devices
+# Hardware Monitoring support
 #
+CONFIG_HWMON=y
+# CONFIG_HWMON_VID is not set
+# CONFIG_SENSORS_ABITUGURU is not set
+# CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_VT1211 is not set
+# CONFIG_HWMON_DEBUG_CHIP is not set
 
 #
 # Multimedia devices
@@ -518,7 +618,9 @@ CONFIG_LEGACY_PTY_COUNT=256
 #
 # Graphics support
 #
+CONFIG_FIRMWARE_EDID=y
 # CONFIG_FB is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
 # Sound
@@ -530,6 +632,11 @@ CONFIG_LEGACY_PTY_COUNT=256
 #
 # CONFIG_USB_ARCH_HAS_HCD is not set
 # CONFIG_USB_ARCH_HAS_OHCI is not set
+# CONFIG_USB_ARCH_HAS_EHCI is not set
+
+#
+# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+#
 
 #
 # USB Gadget Support
@@ -542,30 +649,73 @@ CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_MMC is not set
 
 #
+# LED devices
+#
+# CONFIG_NEW_LEDS is not set
+
+#
+# LED drivers
+#
+
+#
+# LED Triggers
+#
+
+#
 # InfiniBand support
 #
-# CONFIG_INFINIBAND is not set
+
+#
+# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
+#
+
+#
+# Real Time Clock
+#
+# CONFIG_RTC_CLASS is not set
+
+#
+# DMA Engine support
+#
+# CONFIG_DMA_ENGINE is not set
+
+#
+# DMA Clients
+#
+
+#
+# DMA Devices
+#
 
 #
 # File systems
 #
 CONFIG_EXT2_FS=y
 # CONFIG_EXT2_FS_XATTR is not set
-# CONFIG_EXT3_FS is not set
-# CONFIG_JBD is not set
+# CONFIG_EXT2_FS_XIP is not set
+CONFIG_EXT3_FS=y
+CONFIG_EXT3_FS_XATTR=y
+# CONFIG_EXT3_FS_POSIX_ACL is not set
+# CONFIG_EXT3_FS_SECURITY is not set
+# CONFIG_EXT4DEV_FS is not set
+CONFIG_JBD=y
+# CONFIG_JBD_DEBUG is not set
+CONFIG_FS_MBCACHE=y
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
-
-#
-# XFS support
-#
+# CONFIG_FS_POSIX_ACL is not set
 # CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
 # CONFIG_MINIX_FS is not set
 CONFIG_ROMFS_FS=y
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
 CONFIG_DNOTIFY=y
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
 
 #
 # CD-ROM/DVD Filesystems
@@ -590,16 +740,13 @@ CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
 #
 CONFIG_PROC_FS=y
 CONFIG_PROC_KCORE=y
+CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
-CONFIG_DEVFS_FS=y
-CONFIG_DEVFS_MOUNT=y
-# CONFIG_DEVFS_DEBUG is not set
-# CONFIG_DEVPTS_FS_XATTR is not set
 CONFIG_TMPFS=y
-# CONFIG_TMPFS_XATTR is not set
-# CONFIG_HUGETLBFS is not set
+# CONFIG_TMPFS_POSIX_ACL is not set
 # CONFIG_HUGETLB_PAGE is not set
 CONFIG_RAMFS=y
+# CONFIG_CONFIGFS_FS is not set
 
 #
 # Miscellaneous filesystems
@@ -616,8 +763,9 @@ CONFIG_JFFS_FS_VERBOSE=0
 CONFIG_JFFS_PROC_FS=y
 CONFIG_JFFS2_FS=y
 CONFIG_JFFS2_FS_DEBUG=0
-# CONFIG_JFFS2_FS_NAND is not set
-# CONFIG_JFFS2_FS_NOR_ECC is not set
+CONFIG_JFFS2_FS_WRITEBUFFER=y
+# CONFIG_JFFS2_SUMMARY is not set
+# CONFIG_JFFS2_FS_XATTR is not set
 # CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
 CONFIG_JFFS2_ZLIB=y
 CONFIG_JFFS2_RTIME=y
@@ -634,12 +782,14 @@ CONFIG_JFFS2_RTIME=y
 #
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
 # CONFIG_NFS_V4 is not set
 # CONFIG_NFS_DIRECTIO is not set
 # CONFIG_NFSD is not set
 CONFIG_ROOT_NFS=y
 CONFIG_LOCKD=y
 CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
 # CONFIG_RPCSEC_GSS_KRB5 is not set
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
@@ -648,6 +798,7 @@ CONFIG_SUNRPC=y
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
+# CONFIG_9P_FS is not set
 
 #
 # Partition Types
@@ -708,10 +859,16 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 # Kernel hacking
 #
 # CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_MUST_CHECK=y
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
 # CONFIG_DEBUG_KERNEL is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_DEBUG_FS is not set
 # CONFIG_FRAME_POINTER is not set
+# CONFIG_UNWIND_INFO is not set
+# CONFIG_HEADERS_CHECK is not set
 
 #
 # Security options
@@ -725,13 +882,10 @@ CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CRYPTO is not set
 
 #
-# Hardware crypto devices
-#
-
-#
 # Library routines
 #
 # CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
 CONFIG_CRC32=y
 # CONFIG_LIBCRC32C is not set
 CONFIG_ZLIB_INFLATE=y
diff -puN /dev/null arch/m32r/mappi2/defconfig.opsp
--- /dev/null
+++ a/arch/m32r/mappi2/defconfig.opsp
@@ -0,0 +1,883 @@
+#
+# Automatically generated make config: don't edit
+# Linux kernel version: 2.6.19
+# Wed Dec 13 19:40:30 2006
+#
+CONFIG_M32R=y
+CONFIG_GENERIC_ISA_DMA=y
+CONFIG_GENERIC_HARDIRQS=y
+CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+
+#
+# Code maturity level options
+#
+CONFIG_EXPERIMENTAL=y
+CONFIG_BROKEN_ON_SMP=y
+CONFIG_LOCK_KERNEL=y
+CONFIG_INIT_ENV_ARG_LIMIT=32
+
+#
+# General setup
+#
+CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
+CONFIG_SWAP=y
+CONFIG_SYSVIPC=y
+# CONFIG_IPC_NS is not set
+# CONFIG_POSIX_MQUEUE is not set
+CONFIG_BSD_PROCESS_ACCT=y
+# CONFIG_BSD_PROCESS_ACCT_V3 is not set
+# CONFIG_TASKSTATS is not set
+# CONFIG_UTS_NS is not set
+# CONFIG_AUDIT is not set
+CONFIG_IKCONFIG=y
+# CONFIG_IKCONFIG_PROC is not set
+CONFIG_SYSFS_DEPRECATED=y
+# CONFIG_RELAY is not set
+CONFIG_INITRAMFS_SOURCE=""
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
+CONFIG_EMBEDDED=y
+CONFIG_SYSCTL_SYSCALL=y
+# CONFIG_KALLSYMS is not set
+CONFIG_HOTPLUG=y
+CONFIG_PRINTK=y
+CONFIG_BUG=y
+CONFIG_ELF_CORE=y
+CONFIG_BASE_FULL=y
+# CONFIG_FUTEX is not set
+# CONFIG_EPOLL is not set
+CONFIG_SHMEM=y
+CONFIG_SLAB=y
+CONFIG_VM_EVENT_COUNTERS=y
+# CONFIG_TINY_SHMEM is not set
+CONFIG_BASE_SMALL=0
+# CONFIG_SLOB is not set
+
+#
+# Loadable module support
+#
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+# CONFIG_MODULE_FORCE_UNLOAD is not set
+# CONFIG_MODVERSIONS is not set
+# CONFIG_MODULE_SRCVERSION_ALL is not set
+CONFIG_KMOD=y
+
+#
+# Block layer
+#
+CONFIG_BLOCK=y
+# CONFIG_BLK_DEV_IO_TRACE is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+# CONFIG_IOSCHED_AS is not set
+CONFIG_IOSCHED_DEADLINE=y
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_AS is not set
+# CONFIG_DEFAULT_DEADLINE is not set
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
+
+#
+# Processor type and features
+#
+# CONFIG_PLAT_MAPPI is not set
+# CONFIG_PLAT_USRV is not set
+# CONFIG_PLAT_M32700UT is not set
+# CONFIG_PLAT_OPSPUT is not set
+# CONFIG_PLAT_OAKS32R is not set
+CONFIG_PLAT_MAPPI2=y
+# CONFIG_PLAT_MAPPI3 is not set
+# CONFIG_PLAT_M32104UT is not set
+# CONFIG_CHIP_M32700 is not set
+# CONFIG_CHIP_M32102 is not set
+# CONFIG_CHIP_M32104 is not set
+# CONFIG_CHIP_VDEC2 is not set
+CONFIG_CHIP_OPSP=y
+CONFIG_MMU=y
+CONFIG_TLB_ENTRIES=16
+CONFIG_ISA_M32R2=y
+CONFIG_ISA_DSP_LEVEL2=y
+CONFIG_ISA_DUAL_ISSUE=y
+CONFIG_BUS_CLOCK=50000000
+CONFIG_TIMER_DIVIDE=128
+# CONFIG_CPU_LITTLE_ENDIAN is not set
+CONFIG_MEMORY_START=0x08000000
+CONFIG_MEMORY_SIZE=0x01000000
+CONFIG_NOHIGHMEM=y
+CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
+CONFIG_SELECT_MEMORY_MODEL=y
+# CONFIG_FLATMEM_MANUAL is not set
+CONFIG_DISCONTIGMEM_MANUAL=y
+# CONFIG_SPARSEMEM_MANUAL is not set
+CONFIG_DISCONTIGMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+CONFIG_NEED_MULTIPLE_NODES=y
+# CONFIG_SPARSEMEM_STATIC is not set
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
+CONFIG_IRAM_START=0x00f00000
+CONFIG_IRAM_SIZE=0x00008000
+CONFIG_RWSEM_GENERIC_SPINLOCK=y
+# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
+CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_PREEMPT=y
+# CONFIG_SMP is not set
+CONFIG_NODES_SHIFT=1
+
+#
+# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
+#
+# CONFIG_ISA is not set
+
+#
+# PCCARD (PCMCIA/CardBus) support
+#
+CONFIG_PCCARD=y
+# CONFIG_PCMCIA_DEBUG is not set
+CONFIG_PCMCIA=y
+CONFIG_PCMCIA_LOAD_CIS=y
+CONFIG_PCMCIA_IOCTL=y
+
+#
+# PC-card bridges
+#
+# CONFIG_M32R_CFC is not set
+
+#
+# PCI Hotplug Support
+#
+
+#
+# Executable file formats
+#
+CONFIG_BINFMT_ELF=y
+# CONFIG_BINFMT_MISC is not set
+
+#
+# Networking
+#
+CONFIG_NET=y
+
+#
+# Networking options
+#
+# CONFIG_NETDEBUG is not set
+CONFIG_PACKET=y
+# CONFIG_PACKET_MMAP is not set
+CONFIG_UNIX=y
+CONFIG_XFRM=y
+# CONFIG_XFRM_USER is not set
+# CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+# CONFIG_IP_MULTICAST is not set
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+# CONFIG_IP_PNP_BOOTP is not set
+# CONFIG_IP_PNP_RARP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_ARPD is not set
+# CONFIG_SYN_COOKIES is not set
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+CONFIG_INET_XFRM_MODE_TRANSPORT=y
+CONFIG_INET_XFRM_MODE_TUNNEL=y
+CONFIG_INET_XFRM_MODE_BEET=y
+CONFIG_INET_DIAG=y
+CONFIG_INET_TCP_DIAG=y
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_INET6_XFRM_TUNNEL is not set
+# CONFIG_INET6_TUNNEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+
+#
+# DCCP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_DCCP is not set
+
+#
+# SCTP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_SCTP is not set
+
+#
+# TIPC Configuration (EXPERIMENTAL)
+#
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+
+#
+# QoS and/or fair queueing
+#
+# CONFIG_NET_SCHED is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_IEEE80211 is not set
+
+#
+# Device Drivers
+#
+
+#
+# Generic Driver Options
+#
+CONFIG_STANDALONE=y
+CONFIG_PREVENT_FIRMWARE_BUILD=y
+CONFIG_FW_LOADER=y
+# CONFIG_SYS_HYPERVISOR is not set
+
+#
+# Connector - unified userspace <-> kernelspace linker
+#
+# CONFIG_CONNECTOR is not set
+
+#
+# Memory Technology Devices (MTD)
+#
+# CONFIG_MTD is not set
+
+#
+# Parallel port support
+#
+# CONFIG_PARPORT is not set
+
+#
+# Plug and Play support
+#
+
+#
+# Block devices
+#
+# CONFIG_BLK_DEV_COW_COMMON is not set
+CONFIG_BLK_DEV_LOOP=y
+# CONFIG_BLK_DEV_CRYPTOLOOP is not set
+CONFIG_BLK_DEV_NBD=y
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_COUNT=16
+CONFIG_BLK_DEV_RAM_SIZE=4096
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
+# CONFIG_BLK_DEV_INITRD is not set
+# CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
+
+#
+# Misc devices
+#
+# CONFIG_TIFM_CORE is not set
+
+#
+# ATA/ATAPI/MFM/RLL support
+#
+CONFIG_IDE=y
+CONFIG_IDE_MAX_HWIFS=4
+CONFIG_BLK_DEV_IDE=y
+
+#
+# Please see Documentation/ide.txt for help/info on IDE drives
+#
+# CONFIG_BLK_DEV_IDE_SATA is not set
+CONFIG_BLK_DEV_IDEDISK=y
+# CONFIG_IDEDISK_MULTI_MODE is not set
+CONFIG_BLK_DEV_IDECS=y
+CONFIG_BLK_DEV_IDECD=m
+# CONFIG_BLK_DEV_IDETAPE is not set
+# CONFIG_BLK_DEV_IDEFLOPPY is not set
+# CONFIG_BLK_DEV_IDESCSI is not set
+# CONFIG_IDE_TASK_IOCTL is not set
+
+#
+# IDE chipset support/bugfixes
+#
+CONFIG_IDE_GENERIC=y
+# CONFIG_IDE_ARM is not set
+# CONFIG_BLK_DEV_IDEDMA is not set
+# CONFIG_IDEDMA_AUTO is not set
+# CONFIG_BLK_DEV_HD is not set
+
+#
+# SCSI device support
+#
+# CONFIG_RAID_ATTRS is not set
+CONFIG_SCSI=m
+# CONFIG_SCSI_NETLINK is not set
+CONFIG_SCSI_PROC_FS=y
+
+#
+# SCSI support type (disk, tape, CD-ROM)
+#
+CONFIG_BLK_DEV_SD=m
+# CONFIG_CHR_DEV_ST is not set
+# CONFIG_CHR_DEV_OSST is not set
+CONFIG_BLK_DEV_SR=m
+# CONFIG_BLK_DEV_SR_VENDOR is not set
+CONFIG_CHR_DEV_SG=m
+# CONFIG_CHR_DEV_SCH is not set
+
+#
+# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
+#
+CONFIG_SCSI_MULTI_LUN=y
+# CONFIG_SCSI_CONSTANTS is not set
+# CONFIG_SCSI_LOGGING is not set
+
+#
+# SCSI Transports
+#
+# CONFIG_SCSI_SPI_ATTRS is not set
+# CONFIG_SCSI_FC_ATTRS is not set
+# CONFIG_SCSI_ISCSI_ATTRS is not set
+# CONFIG_SCSI_SAS_ATTRS is not set
+# CONFIG_SCSI_SAS_LIBSAS is not set
+
+#
+# SCSI low-level drivers
+#
+# CONFIG_ISCSI_TCP is not set
+# CONFIG_SCSI_DEBUG is not set
+
+#
+# PCMCIA SCSI adapter support
+#
+# CONFIG_PCMCIA_AHA152X is not set
+# CONFIG_PCMCIA_FDOMAIN is not set
+# CONFIG_PCMCIA_NINJA_SCSI is not set
+# CONFIG_PCMCIA_QLOGIC is not set
+# CONFIG_PCMCIA_SYM53C500 is not set
+
+#
+# Serial ATA (prod) and Parallel ATA (experimental) drivers
+#
+
+#
+# Multi-device support (RAID and LVM)
+#
+# CONFIG_MD is not set
+
+#
+# Fusion MPT device support
+#
+# CONFIG_FUSION is not set
+
+#
+# IEEE 1394 (FireWire) support
+#
+
+#
+# I2O device support
+#
+
+#
+# Network device support
+#
+CONFIG_NETDEVICES=y
+# CONFIG_DUMMY is not set
+# CONFIG_BONDING is not set
+# CONFIG_EQUALIZER is not set
+# CONFIG_TUN is not set
+
+#
+# PHY device support
+#
+# CONFIG_PHYLIB is not set
+
+#
+# Ethernet (10 or 100Mbit)
+#
+CONFIG_NET_ETHERNET=y
+CONFIG_MII=y
+CONFIG_SMC91X=y
+# CONFIG_NE2000 is not set
+
+#
+# Ethernet (1000 Mbit)
+#
+
+#
+# Ethernet (10000 Mbit)
+#
+
+#
+# Token Ring devices
+#
+
+#
+# Wireless LAN (non-hamradio)
+#
+# CONFIG_NET_RADIO is not set
+
+#
+# PCMCIA network device support
+#
+# CONFIG_NET_PCMCIA is not set
+
+#
+# Wan interfaces
+#
+# CONFIG_WAN is not set
+# CONFIG_PPP is not set
+# CONFIG_SLIP is not set
+# CONFIG_SHAPER is not set
+# CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
+
+#
+# ISDN subsystem
+#
+# CONFIG_ISDN is not set
+
+#
+# Telephony Support
+#
+# CONFIG_PHONE is not set
+
+#
+# Input device support
+#
+CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set
+
+#
+# Userland interfaces
+#
+# CONFIG_INPUT_MOUSEDEV is not set
+# CONFIG_INPUT_JOYDEV is not set
+# CONFIG_INPUT_TSDEV is not set
+# CONFIG_INPUT_EVDEV is not set
+# CONFIG_INPUT_EVBUG is not set
+
+#
+# Input Device Drivers
+#
+# CONFIG_INPUT_KEYBOARD is not set
+# CONFIG_INPUT_MOUSE is not set
+# CONFIG_INPUT_JOYSTICK is not set
+# CONFIG_INPUT_TOUCHSCREEN is not set
+# CONFIG_INPUT_MISC is not set
+
+#
+# Hardware I/O ports
+#
+CONFIG_SERIO=y
+# CONFIG_SERIO_I8042 is not set
+CONFIG_SERIO_SERPORT=y
+# CONFIG_SERIO_LIBPS2 is not set
+# CONFIG_SERIO_RAW is not set
+# CONFIG_GAMEPORT is not set
+
+#
+# Character devices
+#
+CONFIG_VT=y
+CONFIG_VT_CONSOLE=y
+CONFIG_HW_CONSOLE=y
+# CONFIG_VT_HW_CONSOLE_BINDING is not set
+# CONFIG_SERIAL_NONSTANDARD is not set
+
+#
+# Serial drivers
+#
+# CONFIG_SERIAL_8250 is not set
+
+#
+# Non-8250 serial port support
+#
+CONFIG_SERIAL_CORE=y
+CONFIG_SERIAL_CORE_CONSOLE=y
+CONFIG_SERIAL_M32R_SIO=y
+CONFIG_SERIAL_M32R_SIO_CONSOLE=y
+CONFIG_UNIX98_PTYS=y
+CONFIG_LEGACY_PTYS=y
+CONFIG_LEGACY_PTY_COUNT=256
+
+#
+# IPMI
+#
+# CONFIG_IPMI_HANDLER is not set
+
+#
+# Watchdog Cards
+#
+# CONFIG_WATCHDOG is not set
+CONFIG_HW_RANDOM=y
+# CONFIG_RTC is not set
+# CONFIG_DTLK is not set
+# CONFIG_R3964 is not set
+
+#
+# Ftape, the floppy tape device driver
+#
+
+#
+# PCMCIA character devices
+#
+# CONFIG_SYNCLINK_CS is not set
+# CONFIG_CARDMAN_4000 is not set
+# CONFIG_CARDMAN_4040 is not set
+# CONFIG_RAW_DRIVER is not set
+
+#
+# TPM devices
+#
+# CONFIG_TCG_TPM is not set
+
+#
+# I2C support
+#
+# CONFIG_I2C is not set
+
+#
+# SPI support
+#
+# CONFIG_SPI is not set
+# CONFIG_SPI_MASTER is not set
+
+#
+# Dallas's 1-wire bus
+#
+# CONFIG_W1 is not set
+
+#
+# Hardware Monitoring support
+#
+CONFIG_HWMON=y
+# CONFIG_HWMON_VID is not set
+# CONFIG_SENSORS_ABITUGURU is not set
+# CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_VT1211 is not set
+# CONFIG_HWMON_DEBUG_CHIP is not set
+
+#
+# Multimedia devices
+#
+CONFIG_VIDEO_DEV=y
+CONFIG_VIDEO_V4L1=y
+CONFIG_VIDEO_V4L1_COMPAT=y
+CONFIG_VIDEO_V4L2=y
+
+#
+# Video Capture Adapters
+#
+
+#
+# Video Capture Adapters
+#
+# CONFIG_VIDEO_ADV_DEBUG is not set
+CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
+# CONFIG_VIDEO_VIVI is not set
+# CONFIG_VIDEO_CPIA is not set
+# CONFIG_VIDEO_M32R_AR is not set
+
+#
+# Radio Adapters
+#
+
+#
+# Digital Video Broadcasting Devices
+#
+# CONFIG_DVB is not set
+
+#
+# Graphics support
+#
+CONFIG_FIRMWARE_EDID=y
+# CONFIG_FB is not set
+
+#
+# Console display driver support
+#
+# CONFIG_VGA_CONSOLE is not set
+CONFIG_DUMMY_CONSOLE=y
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+
+#
+# Sound
+#
+# CONFIG_SOUND is not set
+
+#
+# USB support
+#
+# CONFIG_USB_ARCH_HAS_HCD is not set
+# CONFIG_USB_ARCH_HAS_OHCI is not set
+# CONFIG_USB_ARCH_HAS_EHCI is not set
+
+#
+# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+#
+
+#
+# USB Gadget Support
+#
+# CONFIG_USB_GADGET is not set
+
+#
+# MMC/SD Card support
+#
+# CONFIG_MMC is not set
+
+#
+# LED devices
+#
+# CONFIG_NEW_LEDS is not set
+
+#
+# LED drivers
+#
+
+#
+# LED Triggers
+#
+
+#
+# InfiniBand support
+#
+
+#
+# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
+#
+
+#
+# Real Time Clock
+#
+# CONFIG_RTC_CLASS is not set
+
+#
+# DMA Engine support
+#
+# CONFIG_DMA_ENGINE is not set
+
+#
+# DMA Clients
+#
+
+#
+# DMA Devices
+#
+
+#
+# File systems
+#
+CONFIG_EXT2_FS=y
+# CONFIG_EXT2_FS_XATTR is not set
+# CONFIG_EXT2_FS_XIP is not set
+CONFIG_EXT3_FS=y
+CONFIG_EXT3_FS_XATTR=y
+# CONFIG_EXT3_FS_POSIX_ACL is not set
+# CONFIG_EXT3_FS_SECURITY is not set
+# CONFIG_EXT4DEV_FS is not set
+CONFIG_JBD=y
+CONFIG_JBD_DEBUG=y
+CONFIG_FS_MBCACHE=y
+# CONFIG_REISERFS_FS is not set
+# CONFIG_JFS_FS is not set
+# CONFIG_FS_POSIX_ACL is not set
+# CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
+# CONFIG_MINIX_FS is not set
+# CONFIG_ROMFS_FS is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
+# CONFIG_QUOTA is not set
+CONFIG_DNOTIFY=y
+# CONFIG_AUTOFS_FS is not set
+# CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
+
+#
+# CD-ROM/DVD Filesystems
+#
+CONFIG_ISO9660_FS=m
+CONFIG_JOLIET=y
+# CONFIG_ZISOFS is not set
+CONFIG_UDF_FS=m
+CONFIG_UDF_NLS=y
+
+#
+# DOS/FAT/NT Filesystems
+#
+CONFIG_FAT_FS=m
+CONFIG_MSDOS_FS=m
+CONFIG_VFAT_FS=m
+CONFIG_FAT_DEFAULT_CODEPAGE=437
+CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
+# CONFIG_NTFS_FS is not set
+
+#
+# Pseudo filesystems
+#
+CONFIG_PROC_FS=y
+CONFIG_PROC_KCORE=y
+CONFIG_PROC_SYSCTL=y
+CONFIG_SYSFS=y
+CONFIG_TMPFS=y
+# CONFIG_TMPFS_POSIX_ACL is not set
+# CONFIG_HUGETLB_PAGE is not set
+CONFIG_RAMFS=y
+# CONFIG_CONFIGFS_FS is not set
+
+#
+# Miscellaneous filesystems
+#
+# CONFIG_ADFS_FS is not set
+# CONFIG_AFFS_FS is not set
+# CONFIG_HFS_FS is not set
+# CONFIG_HFSPLUS_FS is not set
+# CONFIG_BEFS_FS is not set
+# CONFIG_BFS_FS is not set
+# CONFIG_EFS_FS is not set
+# CONFIG_CRAMFS is not set
+# CONFIG_VXFS_FS is not set
+# CONFIG_HPFS_FS is not set
+# CONFIG_QNX4FS_FS is not set
+# CONFIG_SYSV_FS is not set
+# CONFIG_UFS_FS is not set
+
+#
+# Network File Systems
+#
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
+# CONFIG_NFS_V4 is not set
+# CONFIG_NFS_DIRECTIO is not set
+# CONFIG_NFSD is not set
+CONFIG_ROOT_NFS=y
+CONFIG_LOCKD=y
+CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
+CONFIG_SUNRPC=y
+# CONFIG_RPCSEC_GSS_KRB5 is not set
+# CONFIG_RPCSEC_GSS_SPKM3 is not set
+# CONFIG_SMB_FS is not set
+# CONFIG_CIFS is not set
+# CONFIG_NCP_FS is not set
+# CONFIG_CODA_FS is not set
+# CONFIG_AFS_FS is not set
+# CONFIG_9P_FS is not set
+
+#
+# Partition Types
+#
+# CONFIG_PARTITION_ADVANCED is not set
+CONFIG_MSDOS_PARTITION=y
+
+#
+# Native Language Support
+#
+CONFIG_NLS=y
+CONFIG_NLS_DEFAULT="iso8859-1"
+# CONFIG_NLS_CODEPAGE_437 is not set
+# CONFIG_NLS_CODEPAGE_737 is not set
+# CONFIG_NLS_CODEPAGE_775 is not set
+# CONFIG_NLS_CODEPAGE_850 is not set
+# CONFIG_NLS_CODEPAGE_852 is not set
+# CONFIG_NLS_CODEPAGE_855 is not set
+# CONFIG_NLS_CODEPAGE_857 is not set
+# CONFIG_NLS_CODEPAGE_860 is not set
+# CONFIG_NLS_CODEPAGE_861 is not set
+# CONFIG_NLS_CODEPAGE_862 is not set
+# CONFIG_NLS_CODEPAGE_863 is not set
+# CONFIG_NLS_CODEPAGE_864 is not set
+# CONFIG_NLS_CODEPAGE_865 is not set
+# CONFIG_NLS_CODEPAGE_866 is not set
+# CONFIG_NLS_CODEPAGE_869 is not set
+# CONFIG_NLS_CODEPAGE_936 is not set
+# CONFIG_NLS_CODEPAGE_950 is not set
+# CONFIG_NLS_CODEPAGE_932 is not set
+# CONFIG_NLS_CODEPAGE_949 is not set
+# CONFIG_NLS_CODEPAGE_874 is not set
+# CONFIG_NLS_ISO8859_8 is not set
+# CONFIG_NLS_CODEPAGE_1250 is not set
+# CONFIG_NLS_CODEPAGE_1251 is not set
+# CONFIG_NLS_ASCII is not set
+# CONFIG_NLS_ISO8859_1 is not set
+# CONFIG_NLS_ISO8859_2 is not set
+# CONFIG_NLS_ISO8859_3 is not set
+# CONFIG_NLS_ISO8859_4 is not set
+# CONFIG_NLS_ISO8859_5 is not set
+# CONFIG_NLS_ISO8859_6 is not set
+# CONFIG_NLS_ISO8859_7 is not set
+# CONFIG_NLS_ISO8859_9 is not set
+# CONFIG_NLS_ISO8859_13 is not set
+# CONFIG_NLS_ISO8859_14 is not set
+# CONFIG_NLS_ISO8859_15 is not set
+# CONFIG_NLS_KOI8_R is not set
+# CONFIG_NLS_KOI8_U is not set
+# CONFIG_NLS_UTF8 is not set
+
+#
+# Profiling support
+#
+# CONFIG_PROFILING is not set
+
+#
+# Kernel hacking
+#
+# CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_MUST_CHECK=y
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
+# CONFIG_DEBUG_KERNEL is not set
+CONFIG_LOG_BUF_SHIFT=14
+# CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_DEBUG_FS is not set
+# CONFIG_FRAME_POINTER is not set
+# CONFIG_UNWIND_INFO is not set
+# CONFIG_HEADERS_CHECK is not set
+
+#
+# Security options
+#
+# CONFIG_KEYS is not set
+# CONFIG_SECURITY is not set
+
+#
+# Cryptographic options
+#
+# CONFIG_CRYPTO is not set
+
+#
+# Library routines
+#
+# CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
+CONFIG_CRC32=y
+# CONFIG_LIBCRC32C is not set
diff -puN arch/m32r/mappi2/defconfig.vdec2~m32r-update-defconfig-files-for-v2619 arch/m32r/mappi2/defconfig.vdec2
--- a/arch/m32r/mappi2/defconfig.vdec2~m32r-update-defconfig-files-for-v2619
+++ a/arch/m32r/mappi2/defconfig.vdec2
@@ -1,19 +1,18 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.12-rc5
-# Fri Jun  3 16:22:02 2005
+# Linux kernel version: 2.6.19
+# Wed Dec 13 19:31:44 2006
 #
 CONFIG_M32R=y
-# CONFIG_UID16 is not set
 CONFIG_GENERIC_ISA_DMA=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
 # Code maturity level options
 #
 CONFIG_EXPERIMENTAL=y
-CONFIG_CLEAN_COMPILE=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_LOCK_KERNEL=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
@@ -22,32 +21,39 @@ CONFIG_INIT_ENV_ARG_LIMIT=32
 # General setup
 #
 CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SWAP=y
 CONFIG_SYSVIPC=y
+# CONFIG_IPC_NS is not set
 # CONFIG_POSIX_MQUEUE is not set
 CONFIG_BSD_PROCESS_ACCT=y
 # CONFIG_BSD_PROCESS_ACCT_V3 is not set
-CONFIG_SYSCTL=y
+# CONFIG_TASKSTATS is not set
+# CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
-CONFIG_HOTPLUG=y
-CONFIG_KOBJECT_UEVENT=y
 CONFIG_IKCONFIG=y
 # CONFIG_IKCONFIG_PROC is not set
+CONFIG_SYSFS_DEPRECATED=y
+# CONFIG_RELAY is not set
+CONFIG_INITRAMFS_SOURCE=""
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
 CONFIG_EMBEDDED=y
+CONFIG_SYSCTL_SYSCALL=y
 # CONFIG_KALLSYMS is not set
+CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
+CONFIG_ELF_CORE=y
 CONFIG_BASE_FULL=y
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SHMEM=y
-CONFIG_CC_ALIGN_FUNCTIONS=0
-CONFIG_CC_ALIGN_LABELS=0
-CONFIG_CC_ALIGN_LOOPS=0
-CONFIG_CC_ALIGN_JUMPS=0
+CONFIG_SLAB=y
+CONFIG_VM_EVENT_COUNTERS=y
 # CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=0
+# CONFIG_SLOB is not set
 
 #
 # Loadable module support
@@ -55,12 +61,30 @@ CONFIG_BASE_SMALL=0
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
-CONFIG_OBSOLETE_MODPARM=y
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_KMOD=y
 
 #
+# Block layer
+#
+CONFIG_BLOCK=y
+# CONFIG_BLK_DEV_IO_TRACE is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+# CONFIG_IOSCHED_AS is not set
+CONFIG_IOSCHED_DEADLINE=y
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_AS is not set
+# CONFIG_DEFAULT_DEADLINE is not set
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
+
+#
 # Processor type and features
 #
 # CONFIG_PLAT_MAPPI is not set
@@ -70,8 +94,10 @@ CONFIG_KMOD=y
 # CONFIG_PLAT_OAKS32R is not set
 CONFIG_PLAT_MAPPI2=y
 # CONFIG_PLAT_MAPPI3 is not set
+# CONFIG_PLAT_M32104UT is not set
 # CONFIG_CHIP_M32700 is not set
 # CONFIG_CHIP_M32102 is not set
+# CONFIG_CHIP_M32104 is not set
 CONFIG_CHIP_VDEC2=y
 # CONFIG_CHIP_OPSP is not set
 CONFIG_MMU=y
@@ -83,18 +109,31 @@ CONFIG_TIMER_DIVIDE=128
 CONFIG_MEMORY_START=0x08000000
 CONFIG_MEMORY_SIZE=0x01000000
 CONFIG_NOHIGHMEM=y
-# CONFIG_DISCONTIGMEM is not set
+CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
+CONFIG_SELECT_MEMORY_MODEL=y
+# CONFIG_FLATMEM_MANUAL is not set
+CONFIG_DISCONTIGMEM_MANUAL=y
+# CONFIG_SPARSEMEM_MANUAL is not set
+CONFIG_DISCONTIGMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+CONFIG_NEED_MULTIPLE_NODES=y
+# CONFIG_SPARSEMEM_STATIC is not set
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
+CONFIG_IRAM_START=0x00f00000
+CONFIG_IRAM_SIZE=0x00008000
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_PREEMPT=y
-# CONFIG_HAVE_DEC_LOCK is not set
 # CONFIG_SMP is not set
+CONFIG_NODES_SHIFT=1
 
 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
 #
-# CONFIG_PCI is not set
 # CONFIG_ISA is not set
 
 #
@@ -103,11 +142,12 @@ CONFIG_PREEMPT=y
 CONFIG_PCCARD=y
 # CONFIG_PCMCIA_DEBUG is not set
 CONFIG_PCMCIA=y
+CONFIG_PCMCIA_LOAD_CIS=y
+CONFIG_PCMCIA_IOCTL=y
 
 #
 # PC-card bridges
 #
-# CONFIG_TCIC is not set
 # CONFIG_M32R_CFC is not set
 
 #
@@ -121,6 +161,94 @@ CONFIG_BINFMT_ELF=y
 # CONFIG_BINFMT_MISC is not set
 
 #
+# Networking
+#
+CONFIG_NET=y
+
+#
+# Networking options
+#
+# CONFIG_NETDEBUG is not set
+CONFIG_PACKET=y
+# CONFIG_PACKET_MMAP is not set
+CONFIG_UNIX=y
+CONFIG_XFRM=y
+# CONFIG_XFRM_USER is not set
+# CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+# CONFIG_IP_MULTICAST is not set
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+# CONFIG_IP_PNP_BOOTP is not set
+# CONFIG_IP_PNP_RARP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_ARPD is not set
+# CONFIG_SYN_COOKIES is not set
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+CONFIG_INET_XFRM_MODE_TRANSPORT=y
+CONFIG_INET_XFRM_MODE_TUNNEL=y
+CONFIG_INET_XFRM_MODE_BEET=y
+CONFIG_INET_DIAG=y
+CONFIG_INET_TCP_DIAG=y
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_INET6_XFRM_TUNNEL is not set
+# CONFIG_INET6_TUNNEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+
+#
+# DCCP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_DCCP is not set
+
+#
+# SCTP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_SCTP is not set
+
+#
+# TIPC Configuration (EXPERIMENTAL)
+#
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+
+#
+# QoS and/or fair queueing
+#
+# CONFIG_NET_SCHED is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_IEEE80211 is not set
+
+#
 # Device Drivers
 #
 
@@ -129,7 +257,13 @@ CONFIG_BINFMT_ELF=y
 #
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
-# CONFIG_FW_LOADER is not set
+CONFIG_FW_LOADER=y
+# CONFIG_SYS_HYPERVISOR is not set
+
+#
+# Connector - unified userspace <-> kernelspace linker
+#
+# CONFIG_CONNECTOR is not set
 
 #
 # Memory Technology Devices (MTD)
@@ -148,7 +282,6 @@ CONFIG_PREVENT_FIRMWARE_BUILD=y
 #
 # Block devices
 #
-# CONFIG_BLK_DEV_FD is not set
 # CONFIG_BLK_DEV_COW_COMMON is not set
 CONFIG_BLK_DEV_LOOP=y
 # CONFIG_BLK_DEV_CRYPTOLOOP is not set
@@ -156,23 +289,21 @@ CONFIG_BLK_DEV_NBD=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 # CONFIG_BLK_DEV_INITRD is not set
-CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
 
 #
-# IO Schedulers
+# Misc devices
 #
-CONFIG_IOSCHED_NOOP=y
-# CONFIG_IOSCHED_AS is not set
-CONFIG_IOSCHED_DEADLINE=y
-CONFIG_IOSCHED_CFQ=y
-# CONFIG_ATA_OVER_ETH is not set
+# CONFIG_TIFM_CORE is not set
 
 #
 # ATA/ATAPI/MFM/RLL support
 #
 CONFIG_IDE=y
+CONFIG_IDE_MAX_HWIFS=4
 CONFIG_BLK_DEV_IDE=y
 
 #
@@ -200,7 +331,9 @@ CONFIG_IDE_GENERIC=y
 #
 # SCSI device support
 #
+# CONFIG_RAID_ATTRS is not set
 CONFIG_SCSI=m
+# CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
 #
@@ -212,6 +345,7 @@ CONFIG_BLK_DEV_SD=m
 CONFIG_BLK_DEV_SR=m
 # CONFIG_BLK_DEV_SR_VENDOR is not set
 CONFIG_CHR_DEV_SG=m
+# CONFIG_CHR_DEV_SCH is not set
 
 #
 # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
@@ -221,16 +355,18 @@ CONFIG_SCSI_MULTI_LUN=y
 # CONFIG_SCSI_LOGGING is not set
 
 #
-# SCSI Transport Attributes
+# SCSI Transports
 #
 # CONFIG_SCSI_SPI_ATTRS is not set
 # CONFIG_SCSI_FC_ATTRS is not set
 # CONFIG_SCSI_ISCSI_ATTRS is not set
+# CONFIG_SCSI_SAS_ATTRS is not set
+# CONFIG_SCSI_SAS_LIBSAS is not set
 
 #
 # SCSI low-level drivers
 #
-# CONFIG_SCSI_SATA is not set
+# CONFIG_ISCSI_TCP is not set
 # CONFIG_SCSI_DEBUG is not set
 
 #
@@ -243,6 +379,10 @@ CONFIG_SCSI_MULTI_LUN=y
 # CONFIG_PCMCIA_SYM53C500 is not set
 
 #
+# Serial ATA (prod) and Parallel ATA (experimental) drivers
+#
+
+#
 # Multi-device support (RAID and LVM)
 #
 # CONFIG_MD is not set
@@ -250,6 +390,7 @@ CONFIG_SCSI_MULTI_LUN=y
 #
 # Fusion MPT device support
 #
+# CONFIG_FUSION is not set
 
 #
 # IEEE 1394 (FireWire) support
@@ -260,69 +401,8 @@ CONFIG_SCSI_MULTI_LUN=y
 #
 
 #
-# Networking support
-#
-CONFIG_NET=y
-
-#
-# Networking options
-#
-CONFIG_PACKET=y
-# CONFIG_PACKET_MMAP is not set
-CONFIG_UNIX=y
-# CONFIG_NET_KEY is not set
-CONFIG_INET=y
-# CONFIG_IP_MULTICAST is not set
-# CONFIG_IP_ADVANCED_ROUTER is not set
-CONFIG_IP_PNP=y
-CONFIG_IP_PNP_DHCP=y
-# CONFIG_IP_PNP_BOOTP is not set
-# CONFIG_IP_PNP_RARP is not set
-# CONFIG_NET_IPIP is not set
-# CONFIG_NET_IPGRE is not set
-# CONFIG_ARPD is not set
-# CONFIG_SYN_COOKIES is not set
-# CONFIG_INET_AH is not set
-# CONFIG_INET_ESP is not set
-# CONFIG_INET_IPCOMP is not set
-# CONFIG_INET_TUNNEL is not set
-CONFIG_IP_TCPDIAG=y
-# CONFIG_IP_TCPDIAG_IPV6 is not set
-# CONFIG_IPV6 is not set
-# CONFIG_NETFILTER is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
-#
-# CONFIG_IP_SCTP is not set
-# CONFIG_ATM is not set
-# CONFIG_BRIDGE is not set
-# CONFIG_VLAN_8021Q is not set
-# CONFIG_DECNET is not set
-# CONFIG_LLC2 is not set
-# CONFIG_IPX is not set
-# CONFIG_ATALK is not set
-# CONFIG_X25 is not set
-# CONFIG_LAPB is not set
-# CONFIG_NET_DIVERT is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
-# CONFIG_NET_SCHED is not set
-# CONFIG_NET_CLS_ROUTE is not set
-
-#
-# Network testing
+# Network device support
 #
-# CONFIG_NET_PKTGEN is not set
-# CONFIG_NETPOLL is not set
-# CONFIG_NET_POLL_CONTROLLER is not set
-# CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
-# CONFIG_BT is not set
 CONFIG_NETDEVICES=y
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
@@ -330,6 +410,11 @@ CONFIG_NETDEVICES=y
 # CONFIG_TUN is not set
 
 #
+# PHY device support
+#
+# CONFIG_PHYLIB is not set
+
+#
 # Ethernet (10 or 100Mbit)
 #
 CONFIG_NET_ETHERNET=y
@@ -367,6 +452,8 @@ CONFIG_SMC91X=y
 # CONFIG_SLIP is not set
 # CONFIG_SHAPER is not set
 # CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
 
 #
 # ISDN subsystem
@@ -382,6 +469,7 @@ CONFIG_SMC91X=y
 # Input device support
 #
 CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set
 
 #
 # Userland interfaces
@@ -410,7 +498,6 @@ CONFIG_SERIO_SERPORT=y
 # CONFIG_SERIO_LIBPS2 is not set
 # CONFIG_SERIO_RAW is not set
 # CONFIG_GAMEPORT is not set
-CONFIG_SOUND_GAMEPORT=y
 
 #
 # Character devices
@@ -418,6 +505,7 @@ CONFIG_SOUND_GAMEPORT=y
 CONFIG_VT=y
 CONFIG_VT_CONSOLE=y
 CONFIG_HW_CONSOLE=y
+# CONFIG_VT_HW_CONSOLE_BINDING is not set
 # CONFIG_SERIAL_NONSTANDARD is not set
 
 #
@@ -432,7 +520,6 @@ CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
 CONFIG_SERIAL_M32R_SIO=y
 CONFIG_SERIAL_M32R_SIO_CONSOLE=y
-# CONFIG_SERIAL_M32R_PLDSIO is not set
 CONFIG_UNIX98_PTYS=y
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
@@ -446,25 +533,27 @@ CONFIG_LEGACY_PTY_COUNT=256
 # Watchdog Cards
 #
 # CONFIG_WATCHDOG is not set
+CONFIG_HW_RANDOM=y
 # CONFIG_RTC is not set
-# CONFIG_GEN_RTC is not set
 # CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
 
 #
 # Ftape, the floppy tape device driver
 #
-# CONFIG_DRM is not set
 
 #
 # PCMCIA character devices
 #
 # CONFIG_SYNCLINK_CS is not set
+# CONFIG_CARDMAN_4000 is not set
+# CONFIG_CARDMAN_4040 is not set
 # CONFIG_RAW_DRIVER is not set
 
 #
 # TPM devices
 #
+# CONFIG_TCG_TPM is not set
 
 #
 # I2C support
@@ -472,33 +561,50 @@ CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_I2C is not set
 
 #
+# SPI support
+#
+# CONFIG_SPI is not set
+# CONFIG_SPI_MASTER is not set
+
+#
 # Dallas's 1-wire bus
 #
 # CONFIG_W1 is not set
 
 #
-# Misc devices
+# Hardware Monitoring support
 #
+CONFIG_HWMON=y
+# CONFIG_HWMON_VID is not set
+# CONFIG_SENSORS_ABITUGURU is not set
+# CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_VT1211 is not set
+# CONFIG_HWMON_DEBUG_CHIP is not set
 
 #
 # Multimedia devices
 #
 CONFIG_VIDEO_DEV=y
+CONFIG_VIDEO_V4L1=y
+CONFIG_VIDEO_V4L1_COMPAT=y
+CONFIG_VIDEO_V4L2=y
 
 #
-# Video For Linux
+# Video Capture Adapters
 #
 
 #
-# Video Adapters
+# Video Capture Adapters
 #
+# CONFIG_VIDEO_ADV_DEBUG is not set
+CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
+# CONFIG_VIDEO_VIVI is not set
 # CONFIG_VIDEO_CPIA is not set
 # CONFIG_VIDEO_M32R_AR is not set
 
 #
 # Radio Adapters
 #
-# CONFIG_RADIO_MAESTRO is not set
 
 #
 # Digital Video Broadcasting Devices
@@ -508,6 +614,7 @@ CONFIG_VIDEO_DEV=y
 #
 # Graphics support
 #
+CONFIG_FIRMWARE_EDID=y
 # CONFIG_FB is not set
 
 #
@@ -515,6 +622,7 @@ CONFIG_VIDEO_DEV=y
 #
 # CONFIG_VGA_CONSOLE is not set
 CONFIG_DUMMY_CONSOLE=y
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
 # Sound
@@ -526,6 +634,11 @@ CONFIG_DUMMY_CONSOLE=y
 #
 # CONFIG_USB_ARCH_HAS_HCD is not set
 # CONFIG_USB_ARCH_HAS_OHCI is not set
+# CONFIG_USB_ARCH_HAS_EHCI is not set
+
+#
+# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+#
 
 #
 # USB Gadget Support
@@ -538,38 +651,73 @@ CONFIG_DUMMY_CONSOLE=y
 # CONFIG_MMC is not set
 
 #
+# LED devices
+#
+# CONFIG_NEW_LEDS is not set
+
+#
+# LED drivers
+#
+
+#
+# LED Triggers
+#
+
+#
 # InfiniBand support
 #
-# CONFIG_INFINIBAND is not set
+
+#
+# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
+#
+
+#
+# Real Time Clock
+#
+# CONFIG_RTC_CLASS is not set
+
+#
+# DMA Engine support
+#
+# CONFIG_DMA_ENGINE is not set
+
+#
+# DMA Clients
+#
+
+#
+# DMA Devices
+#
 
 #
 # File systems
 #
 CONFIG_EXT2_FS=y
 # CONFIG_EXT2_FS_XATTR is not set
-CONFIG_EXT3_FS=m
+# CONFIG_EXT2_FS_XIP is not set
+CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_XATTR=y
 # CONFIG_EXT3_FS_POSIX_ACL is not set
 # CONFIG_EXT3_FS_SECURITY is not set
-CONFIG_JBD=m
+# CONFIG_EXT4DEV_FS is not set
+CONFIG_JBD=y
 CONFIG_JBD_DEBUG=y
 CONFIG_FS_MBCACHE=y
-CONFIG_REISERFS_FS=m
-# CONFIG_REISERFS_CHECK is not set
-# CONFIG_REISERFS_PROC_INFO is not set
-# CONFIG_REISERFS_FS_XATTR is not set
+# CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
-
-#
-# XFS support
-#
+# CONFIG_FS_POSIX_ACL is not set
 # CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
 # CONFIG_MINIX_FS is not set
 # CONFIG_ROMFS_FS is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
 CONFIG_DNOTIFY=y
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
 
 #
 # CD-ROM/DVD Filesystems
@@ -595,15 +743,13 @@ CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
 #
 CONFIG_PROC_FS=y
 CONFIG_PROC_KCORE=y
+CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
-CONFIG_DEVFS_FS=y
-CONFIG_DEVFS_MOUNT=y
-# CONFIG_DEVFS_DEBUG is not set
-# CONFIG_DEVPTS_FS_XATTR is not set
 CONFIG_TMPFS=y
-# CONFIG_TMPFS_XATTR is not set
+# CONFIG_TMPFS_POSIX_ACL is not set
 # CONFIG_HUGETLB_PAGE is not set
 CONFIG_RAMFS=y
+# CONFIG_CONFIGFS_FS is not set
 
 #
 # Miscellaneous filesystems
@@ -627,12 +773,14 @@ CONFIG_RAMFS=y
 #
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
 # CONFIG_NFS_V4 is not set
 # CONFIG_NFS_DIRECTIO is not set
 # CONFIG_NFSD is not set
 CONFIG_ROOT_NFS=y
 CONFIG_LOCKD=y
 CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
 # CONFIG_RPCSEC_GSS_KRB5 is not set
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
@@ -641,6 +789,7 @@ CONFIG_SUNRPC=y
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
+# CONFIG_9P_FS is not set
 
 #
 # Partition Types
@@ -701,10 +850,16 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 # Kernel hacking
 #
 # CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_MUST_CHECK=y
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
 # CONFIG_DEBUG_KERNEL is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_DEBUG_FS is not set
 # CONFIG_FRAME_POINTER is not set
+# CONFIG_UNWIND_INFO is not set
+# CONFIG_HEADERS_CHECK is not set
 
 #
 # Security options
@@ -718,12 +873,9 @@ CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CRYPTO is not set
 
 #
-# Hardware crypto devices
-#
-
-#
 # Library routines
 #
 # CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
 CONFIG_CRC32=y
 # CONFIG_LIBCRC32C is not set
diff -puN arch/m32r/mappi3/defconfig.smp~m32r-update-defconfig-files-for-v2619 arch/m32r/mappi3/defconfig.smp
--- a/arch/m32r/mappi3/defconfig.smp~m32r-update-defconfig-files-for-v2619
+++ a/arch/m32r/mappi3/defconfig.smp
@@ -1,21 +1,18 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.12-rc5
-# Tue May 31 17:55:34 2005
+# Linux kernel version: 2.6.19
+# Mon Dec 11 19:57:33 2006
 #
 CONFIG_M32R=y
-# CONFIG_UID16 is not set
 CONFIG_GENERIC_ISA_DMA=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
 # Code maturity level options
 #
 CONFIG_EXPERIMENTAL=y
-# CONFIG_CLEAN_COMPILE is not set
-CONFIG_BROKEN=y
-CONFIG_BROKEN_ON_SMP=y
 CONFIG_LOCK_KERNEL=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
 
@@ -23,32 +20,39 @@ CONFIG_INIT_ENV_ARG_LIMIT=32
 # General setup
 #
 CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SWAP=y
 CONFIG_SYSVIPC=y
+# CONFIG_IPC_NS is not set
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
-CONFIG_SYSCTL=y
+# CONFIG_TASKSTATS is not set
+# CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
-CONFIG_HOTPLUG=y
-CONFIG_KOBJECT_UEVENT=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 # CONFIG_CPUSETS is not set
+CONFIG_SYSFS_DEPRECATED=y
+# CONFIG_RELAY is not set
+CONFIG_INITRAMFS_SOURCE=""
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
 CONFIG_EMBEDDED=y
+CONFIG_SYSCTL_SYSCALL=y
 # CONFIG_KALLSYMS is not set
+CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
+CONFIG_ELF_CORE=y
 CONFIG_BASE_FULL=y
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SHMEM=y
-CONFIG_CC_ALIGN_FUNCTIONS=0
-CONFIG_CC_ALIGN_LABELS=0
-CONFIG_CC_ALIGN_LOOPS=0
-CONFIG_CC_ALIGN_JUMPS=0
+CONFIG_SLAB=y
+CONFIG_VM_EVENT_COUNTERS=y
 # CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=0
+# CONFIG_SLOB is not set
 
 #
 # Loadable module support
@@ -56,13 +60,31 @@ CONFIG_BASE_SMALL=0
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
-CONFIG_OBSOLETE_MODPARM=y
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_KMOD=y
 CONFIG_STOP_MACHINE=y
 
 #
+# Block layer
+#
+CONFIG_BLOCK=y
+# CONFIG_BLK_DEV_IO_TRACE is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+# CONFIG_IOSCHED_AS is not set
+CONFIG_IOSCHED_DEADLINE=y
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_AS is not set
+# CONFIG_DEFAULT_DEADLINE is not set
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
+
+#
 # Processor type and features
 #
 # CONFIG_PLAT_MAPPI is not set
@@ -72,8 +94,10 @@ CONFIG_STOP_MACHINE=y
 # CONFIG_PLAT_OAKS32R is not set
 # CONFIG_PLAT_MAPPI2 is not set
 CONFIG_PLAT_MAPPI3=y
+# CONFIG_PLAT_M32104UT is not set
 CONFIG_CHIP_M32700=y
 # CONFIG_CHIP_M32102 is not set
+# CONFIG_CHIP_M32104 is not set
 # CONFIG_CHIP_VDEC2 is not set
 # CONFIG_CHIP_OPSP is not set
 CONFIG_MMU=y
@@ -87,23 +111,33 @@ CONFIG_TIMER_DIVIDE=128
 CONFIG_MEMORY_START=0x08000000
 CONFIG_MEMORY_SIZE=0x08000000
 CONFIG_NOHIGHMEM=y
+CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
+CONFIG_SELECT_MEMORY_MODEL=y
+# CONFIG_FLATMEM_MANUAL is not set
+CONFIG_DISCONTIGMEM_MANUAL=y
+# CONFIG_SPARSEMEM_MANUAL is not set
 CONFIG_DISCONTIGMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+CONFIG_NEED_MULTIPLE_NODES=y
+# CONFIG_SPARSEMEM_STATIC is not set
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
 CONFIG_IRAM_START=0x00f00000
 CONFIG_IRAM_SIZE=0x00080000
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_PREEMPT=y
-# CONFIG_HAVE_DEC_LOCK is not set
 CONFIG_SMP=y
 # CONFIG_CHIP_M32700_TS1 is not set
 CONFIG_NR_CPUS=2
-# CONFIG_NUMA is not set
+CONFIG_NODES_SHIFT=1
 
 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
 #
-# CONFIG_PCI is not set
 # CONFIG_ISA is not set
 
 #
@@ -112,11 +146,12 @@ CONFIG_NR_CPUS=2
 CONFIG_PCCARD=y
 # CONFIG_PCMCIA_DEBUG is not set
 CONFIG_PCMCIA=y
+CONFIG_PCMCIA_LOAD_CIS=y
+CONFIG_PCMCIA_IOCTL=y
 
 #
 # PC-card bridges
 #
-# CONFIG_TCIC is not set
 # CONFIG_M32R_PCC is not set
 # CONFIG_M32R_CFC is not set
 
@@ -131,6 +166,93 @@ CONFIG_BINFMT_ELF=y
 # CONFIG_BINFMT_MISC is not set
 
 #
+# Networking
+#
+CONFIG_NET=y
+
+#
+# Networking options
+#
+# CONFIG_NETDEBUG is not set
+# CONFIG_PACKET is not set
+CONFIG_UNIX=y
+CONFIG_XFRM=y
+# CONFIG_XFRM_USER is not set
+# CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+# CONFIG_IP_MULTICAST is not set
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+# CONFIG_IP_PNP_BOOTP is not set
+# CONFIG_IP_PNP_RARP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_ARPD is not set
+# CONFIG_SYN_COOKIES is not set
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+CONFIG_INET_XFRM_MODE_TRANSPORT=y
+CONFIG_INET_XFRM_MODE_TUNNEL=y
+CONFIG_INET_XFRM_MODE_BEET=y
+CONFIG_INET_DIAG=y
+CONFIG_INET_TCP_DIAG=y
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_INET6_XFRM_TUNNEL is not set
+# CONFIG_INET6_TUNNEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+
+#
+# DCCP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_DCCP is not set
+
+#
+# SCTP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_SCTP is not set
+
+#
+# TIPC Configuration (EXPERIMENTAL)
+#
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+
+#
+# QoS and/or fair queueing
+#
+# CONFIG_NET_SCHED is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_IEEE80211 is not set
+
+#
 # Device Drivers
 #
 
@@ -140,6 +262,12 @@ CONFIG_BINFMT_ELF=y
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
 CONFIG_FW_LOADER=y
+# CONFIG_SYS_HYPERVISOR is not set
+
+#
+# Connector - unified userspace <-> kernelspace linker
+#
+# CONFIG_CONNECTOR is not set
 
 #
 # Memory Technology Devices (MTD)
@@ -162,6 +290,8 @@ CONFIG_MTD_BLOCK=y
 # CONFIG_FTL is not set
 # CONFIG_NFTL is not set
 # CONFIG_INFTL is not set
+# CONFIG_RFD_FTL is not set
+# CONFIG_SSFDC is not set
 
 #
 # RAM/ROM/Flash chip drivers
@@ -187,6 +317,7 @@ CONFIG_MTD_CFI_I2=y
 # Mapping drivers for chip access
 #
 # CONFIG_MTD_COMPLEX_MAPPINGS is not set
+# CONFIG_MTD_PLATRAM is not set
 
 #
 # Self-contained MTD device drivers
@@ -194,7 +325,6 @@ CONFIG_MTD_CFI_I2=y
 # CONFIG_MTD_SLRAM is not set
 # CONFIG_MTD_PHRAM is not set
 # CONFIG_MTD_MTDRAM is not set
-# CONFIG_MTD_BLKMTD is not set
 # CONFIG_MTD_BLOCK2MTD is not set
 
 #
@@ -210,6 +340,11 @@ CONFIG_MTD_CFI_I2=y
 # CONFIG_MTD_NAND is not set
 
 #
+# OneNAND Flash Device Drivers
+#
+# CONFIG_MTD_ONENAND is not set
+
+#
 # Parallel port support
 #
 # CONFIG_PARPORT is not set
@@ -221,7 +356,6 @@ CONFIG_MTD_CFI_I2=y
 #
 # Block devices
 #
-# CONFIG_BLK_DEV_FD is not set
 # CONFIG_BLK_DEV_COW_COMMON is not set
 CONFIG_BLK_DEV_LOOP=y
 # CONFIG_BLK_DEV_CRYPTOLOOP is not set
@@ -229,23 +363,21 @@ CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
 
 #
-# IO Schedulers
+# Misc devices
 #
-CONFIG_IOSCHED_NOOP=y
-# CONFIG_IOSCHED_AS is not set
-CONFIG_IOSCHED_DEADLINE=y
-CONFIG_IOSCHED_CFQ=y
-# CONFIG_ATA_OVER_ETH is not set
+# CONFIG_TIFM_CORE is not set
 
 #
 # ATA/ATAPI/MFM/RLL support
 #
 CONFIG_IDE=y
+CONFIG_IDE_MAX_HWIFS=4
 CONFIG_BLK_DEV_IDE=y
 
 #
@@ -254,7 +386,7 @@ CONFIG_BLK_DEV_IDE=y
 # CONFIG_BLK_DEV_IDE_SATA is not set
 CONFIG_BLK_DEV_IDEDISK=y
 # CONFIG_IDEDISK_MULTI_MODE is not set
-CONFIG_BLK_DEV_IDECS=y
+CONFIG_BLK_DEV_IDECS=m
 CONFIG_BLK_DEV_IDECD=m
 # CONFIG_BLK_DEV_IDETAPE is not set
 # CONFIG_BLK_DEV_IDEFLOPPY is not set
@@ -272,7 +404,13 @@ CONFIG_IDE_GENERIC=y
 #
 # SCSI device support
 #
+# CONFIG_RAID_ATTRS is not set
 # CONFIG_SCSI is not set
+# CONFIG_SCSI_NETLINK is not set
+
+#
+# Serial ATA (prod) and Parallel ATA (experimental) drivers
+#
 
 #
 # Multi-device support (RAID and LVM)
@@ -282,79 +420,19 @@ CONFIG_IDE_GENERIC=y
 #
 # Fusion MPT device support
 #
+# CONFIG_FUSION is not set
 
 #
 # IEEE 1394 (FireWire) support
 #
-# CONFIG_IEEE1394 is not set
 
 #
 # I2O device support
 #
 
 #
-# Networking support
+# Network device support
 #
-CONFIG_NET=y
-
-#
-# Networking options
-#
-# CONFIG_PACKET is not set
-CONFIG_UNIX=y
-# CONFIG_NET_KEY is not set
-CONFIG_INET=y
-# CONFIG_IP_MULTICAST is not set
-# CONFIG_IP_ADVANCED_ROUTER is not set
-CONFIG_IP_PNP=y
-CONFIG_IP_PNP_DHCP=y
-# CONFIG_IP_PNP_BOOTP is not set
-# CONFIG_IP_PNP_RARP is not set
-# CONFIG_NET_IPIP is not set
-# CONFIG_NET_IPGRE is not set
-# CONFIG_ARPD is not set
-# CONFIG_SYN_COOKIES is not set
-# CONFIG_INET_AH is not set
-# CONFIG_INET_ESP is not set
-# CONFIG_INET_IPCOMP is not set
-# CONFIG_INET_TUNNEL is not set
-CONFIG_IP_TCPDIAG=y
-# CONFIG_IP_TCPDIAG_IPV6 is not set
-# CONFIG_IPV6 is not set
-# CONFIG_NETFILTER is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
-#
-# CONFIG_IP_SCTP is not set
-# CONFIG_ATM is not set
-# CONFIG_BRIDGE is not set
-# CONFIG_VLAN_8021Q is not set
-# CONFIG_DECNET is not set
-# CONFIG_LLC2 is not set
-# CONFIG_IPX is not set
-# CONFIG_ATALK is not set
-# CONFIG_X25 is not set
-# CONFIG_LAPB is not set
-# CONFIG_NET_DIVERT is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
-# CONFIG_NET_SCHED is not set
-# CONFIG_NET_CLS_ROUTE is not set
-
-#
-# Network testing
-#
-# CONFIG_NET_PKTGEN is not set
-# CONFIG_NETPOLL is not set
-# CONFIG_NET_POLL_CONTROLLER is not set
-# CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
-# CONFIG_BT is not set
 CONFIG_NETDEVICES=y
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
@@ -362,6 +440,11 @@ CONFIG_NETDEVICES=y
 # CONFIG_TUN is not set
 
 #
+# PHY device support
+#
+# CONFIG_PHYLIB is not set
+
+#
 # Ethernet (10 or 100Mbit)
 #
 CONFIG_NET_ETHERNET=y
@@ -399,6 +482,8 @@ CONFIG_SMC91X=y
 # CONFIG_SLIP is not set
 # CONFIG_SHAPER is not set
 # CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
 
 #
 # ISDN subsystem
@@ -414,6 +499,7 @@ CONFIG_SMC91X=y
 # Input device support
 #
 CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set
 
 #
 # Userland interfaces
@@ -445,7 +531,6 @@ CONFIG_SERIO=y
 # CONFIG_SERIO_LIBPS2 is not set
 # CONFIG_SERIO_RAW is not set
 # CONFIG_GAMEPORT is not set
-CONFIG_SOUND_GAMEPORT=y
 
 #
 # Character devices
@@ -465,7 +550,6 @@ CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
 CONFIG_SERIAL_M32R_SIO=y
 CONFIG_SERIAL_M32R_SIO_CONSOLE=y
-# CONFIG_SERIAL_M32R_PLDSIO is not set
 CONFIG_UNIX98_PTYS=y
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
@@ -479,25 +563,27 @@ CONFIG_LEGACY_PTY_COUNT=256
 # Watchdog Cards
 #
 # CONFIG_WATCHDOG is not set
+CONFIG_HW_RANDOM=y
 # CONFIG_RTC is not set
-# CONFIG_GEN_RTC is not set
 # CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
 
 #
 # Ftape, the floppy tape device driver
 #
-# CONFIG_DRM is not set
 
 #
 # PCMCIA character devices
 #
 # CONFIG_SYNCLINK_CS is not set
+# CONFIG_CARDMAN_4000 is not set
+# CONFIG_CARDMAN_4040 is not set
 # CONFIG_RAW_DRIVER is not set
 
 #
 # TPM devices
 #
+# CONFIG_TCG_TPM is not set
 
 #
 # I2C support
@@ -505,13 +591,25 @@ CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_I2C is not set
 
 #
+# SPI support
+#
+# CONFIG_SPI is not set
+# CONFIG_SPI_MASTER is not set
+
+#
 # Dallas's 1-wire bus
 #
 # CONFIG_W1 is not set
 
 #
-# Misc devices
+# Hardware Monitoring support
 #
+CONFIG_HWMON=y
+# CONFIG_HWMON_VID is not set
+# CONFIG_SENSORS_ABITUGURU is not set
+# CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_VT1211 is not set
+# CONFIG_HWMON_DEBUG_CHIP is not set
 
 #
 # Multimedia devices
@@ -526,7 +624,9 @@ CONFIG_LEGACY_PTY_COUNT=256
 #
 # Graphics support
 #
+CONFIG_FIRMWARE_EDID=y
 # CONFIG_FB is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
 # Sound
@@ -538,6 +638,11 @@ CONFIG_LEGACY_PTY_COUNT=256
 #
 # CONFIG_USB_ARCH_HAS_HCD is not set
 # CONFIG_USB_ARCH_HAS_OHCI is not set
+# CONFIG_USB_ARCH_HAS_EHCI is not set
+
+#
+# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+#
 
 #
 # USB Gadget Support
@@ -550,35 +655,73 @@ CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_MMC is not set
 
 #
+# LED devices
+#
+# CONFIG_NEW_LEDS is not set
+
+#
+# LED drivers
+#
+
+#
+# LED Triggers
+#
+
+#
 # InfiniBand support
 #
-# CONFIG_INFINIBAND is not set
+
+#
+# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
+#
+
+#
+# Real Time Clock
+#
+# CONFIG_RTC_CLASS is not set
+
+#
+# DMA Engine support
+#
+# CONFIG_DMA_ENGINE is not set
+
+#
+# DMA Clients
+#
+
+#
+# DMA Devices
+#
 
 #
 # File systems
 #
 CONFIG_EXT2_FS=y
 # CONFIG_EXT2_FS_XATTR is not set
+# CONFIG_EXT2_FS_XIP is not set
 CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_XATTR=y
 # CONFIG_EXT3_FS_POSIX_ACL is not set
 # CONFIG_EXT3_FS_SECURITY is not set
+# CONFIG_EXT4DEV_FS is not set
 CONFIG_JBD=y
 # CONFIG_JBD_DEBUG is not set
 CONFIG_FS_MBCACHE=y
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
-
-#
-# XFS support
-#
+# CONFIG_FS_POSIX_ACL is not set
 # CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
 # CONFIG_MINIX_FS is not set
 CONFIG_ROMFS_FS=y
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
 CONFIG_DNOTIFY=y
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
 
 #
 # CD-ROM/DVD Filesystems
@@ -603,16 +746,13 @@ CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
 #
 CONFIG_PROC_FS=y
 CONFIG_PROC_KCORE=y
+CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
-CONFIG_DEVFS_FS=y
-CONFIG_DEVFS_MOUNT=y
-# CONFIG_DEVFS_DEBUG is not set
-# CONFIG_DEVPTS_FS_XATTR is not set
 CONFIG_TMPFS=y
-# CONFIG_TMPFS_XATTR is not set
-# CONFIG_HUGETLBFS is not set
+# CONFIG_TMPFS_POSIX_ACL is not set
 # CONFIG_HUGETLB_PAGE is not set
 CONFIG_RAMFS=y
+# CONFIG_CONFIGFS_FS is not set
 
 #
 # Miscellaneous filesystems
@@ -629,8 +769,9 @@ CONFIG_JFFS_FS_VERBOSE=0
 CONFIG_JFFS_PROC_FS=y
 CONFIG_JFFS2_FS=y
 CONFIG_JFFS2_FS_DEBUG=0
-# CONFIG_JFFS2_FS_NAND is not set
-# CONFIG_JFFS2_FS_NOR_ECC is not set
+CONFIG_JFFS2_FS_WRITEBUFFER=y
+# CONFIG_JFFS2_SUMMARY is not set
+# CONFIG_JFFS2_FS_XATTR is not set
 # CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
 CONFIG_JFFS2_ZLIB=y
 CONFIG_JFFS2_RTIME=y
@@ -647,12 +788,14 @@ CONFIG_JFFS2_RTIME=y
 #
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
 # CONFIG_NFS_V4 is not set
 # CONFIG_NFS_DIRECTIO is not set
 # CONFIG_NFSD is not set
 CONFIG_ROOT_NFS=y
 CONFIG_LOCKD=y
 CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
 # CONFIG_RPCSEC_GSS_KRB5 is not set
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
@@ -661,6 +804,7 @@ CONFIG_SUNRPC=y
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
+# CONFIG_9P_FS is not set
 
 #
 # Partition Types
@@ -721,10 +865,16 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 # Kernel hacking
 #
 # CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_MUST_CHECK=y
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
 # CONFIG_DEBUG_KERNEL is not set
 CONFIG_LOG_BUF_SHIFT=15
 # CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_DEBUG_FS is not set
 # CONFIG_FRAME_POINTER is not set
+# CONFIG_UNWIND_INFO is not set
+# CONFIG_HEADERS_CHECK is not set
 
 #
 # Security options
@@ -738,13 +888,10 @@ CONFIG_LOG_BUF_SHIFT=15
 # CONFIG_CRYPTO is not set
 
 #
-# Hardware crypto devices
-#
-
-#
 # Library routines
 #
 # CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
 CONFIG_CRC32=y
 # CONFIG_LIBCRC32C is not set
 CONFIG_ZLIB_INFLATE=y
diff -puN arch/m32r/oaks32r/defconfig.nommu~m32r-update-defconfig-files-for-v2619 arch/m32r/oaks32r/defconfig.nommu
--- a/arch/m32r/oaks32r/defconfig.nommu~m32r-update-defconfig-files-for-v2619
+++ a/arch/m32r/oaks32r/defconfig.nommu
@@ -1,19 +1,18 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.12-rc5
-# Fri Jun  3 16:22:04 2005
+# Linux kernel version: 2.6.19
+# Tue Dec 12 12:09:17 2006
 #
 CONFIG_M32R=y
-# CONFIG_UID16 is not set
 CONFIG_GENERIC_ISA_DMA=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
 # Code maturity level options
 #
 CONFIG_EXPERIMENTAL=y
-CONFIG_CLEAN_COMPILE=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_LOCK_KERNEL=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
@@ -22,28 +21,35 @@ CONFIG_INIT_ENV_ARG_LIMIT=32
 # General setup
 #
 CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
+# CONFIG_SYSVIPC is not set
 # CONFIG_POSIX_MQUEUE is not set
 CONFIG_BSD_PROCESS_ACCT=y
 # CONFIG_BSD_PROCESS_ACCT_V3 is not set
-CONFIG_SYSCTL=y
+# CONFIG_TASKSTATS is not set
+# CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
-CONFIG_HOTPLUG=y
-CONFIG_KOBJECT_UEVENT=y
 # CONFIG_IKCONFIG is not set
+CONFIG_SYSFS_DEPRECATED=y
+# CONFIG_RELAY is not set
+CONFIG_INITRAMFS_SOURCE=""
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
 CONFIG_EMBEDDED=y
+CONFIG_SYSCTL_SYSCALL=y
 # CONFIG_KALLSYMS is not set
+CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
+CONFIG_ELF_CORE=y
 CONFIG_BASE_FULL=y
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_CC_ALIGN_FUNCTIONS=0
-CONFIG_CC_ALIGN_LABELS=0
-CONFIG_CC_ALIGN_LOOPS=0
-CONFIG_CC_ALIGN_JUMPS=0
+CONFIG_SLAB=y
+CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_TINY_SHMEM=y
 CONFIG_BASE_SMALL=0
+# CONFIG_SLOB is not set
 
 #
 # Loadable module support
@@ -51,12 +57,30 @@ CONFIG_BASE_SMALL=0
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
-CONFIG_OBSOLETE_MODPARM=y
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_KMOD=y
 
 #
+# Block layer
+#
+CONFIG_BLOCK=y
+# CONFIG_BLK_DEV_IO_TRACE is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+# CONFIG_IOSCHED_AS is not set
+CONFIG_IOSCHED_DEADLINE=y
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_AS is not set
+# CONFIG_DEFAULT_DEADLINE is not set
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
+
+#
 # Processor type and features
 #
 # CONFIG_PLAT_MAPPI is not set
@@ -66,8 +90,10 @@ CONFIG_KMOD=y
 CONFIG_PLAT_OAKS32R=y
 # CONFIG_PLAT_MAPPI2 is not set
 # CONFIG_PLAT_MAPPI3 is not set
+# CONFIG_PLAT_M32104UT is not set
 # CONFIG_CHIP_M32700 is not set
 CONFIG_CHIP_M32102=y
+# CONFIG_CHIP_M32104 is not set
 # CONFIG_CHIP_VDEC2 is not set
 # CONFIG_CHIP_OPSP is not set
 CONFIG_ISA_M32R=y
@@ -77,18 +103,31 @@ CONFIG_TIMER_DIVIDE=128
 CONFIG_MEMORY_START=0x01000000
 CONFIG_MEMORY_SIZE=0x00800000
 CONFIG_NOHIGHMEM=y
-# CONFIG_DISCONTIGMEM is not set
+CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
+CONFIG_SELECT_MEMORY_MODEL=y
+# CONFIG_FLATMEM_MANUAL is not set
+CONFIG_DISCONTIGMEM_MANUAL=y
+# CONFIG_SPARSEMEM_MANUAL is not set
+CONFIG_DISCONTIGMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+CONFIG_NEED_MULTIPLE_NODES=y
+# CONFIG_SPARSEMEM_STATIC is not set
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
+CONFIG_IRAM_START=0x00f00000
+CONFIG_IRAM_SIZE=0x00010000
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_PREEMPT=y
-# CONFIG_HAVE_DEC_LOCK is not set
 # CONFIG_SMP is not set
+CONFIG_NODES_SHIFT=1
 
 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
 #
-# CONFIG_PCI is not set
 # CONFIG_ISA is not set
 
 #
@@ -109,6 +148,94 @@ CONFIG_BINFMT_FLAT=y
 # CONFIG_BINFMT_MISC is not set
 
 #
+# Networking
+#
+CONFIG_NET=y
+
+#
+# Networking options
+#
+# CONFIG_NETDEBUG is not set
+CONFIG_PACKET=y
+# CONFIG_PACKET_MMAP is not set
+CONFIG_UNIX=y
+CONFIG_XFRM=y
+# CONFIG_XFRM_USER is not set
+# CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+# CONFIG_IP_MULTICAST is not set
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+# CONFIG_IP_PNP_BOOTP is not set
+# CONFIG_IP_PNP_RARP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_ARPD is not set
+# CONFIG_SYN_COOKIES is not set
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+CONFIG_INET_XFRM_MODE_TRANSPORT=y
+CONFIG_INET_XFRM_MODE_TUNNEL=y
+CONFIG_INET_XFRM_MODE_BEET=y
+CONFIG_INET_DIAG=y
+CONFIG_INET_TCP_DIAG=y
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_INET6_XFRM_TUNNEL is not set
+# CONFIG_INET6_TUNNEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+
+#
+# DCCP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_DCCP is not set
+
+#
+# SCTP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_SCTP is not set
+
+#
+# TIPC Configuration (EXPERIMENTAL)
+#
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+
+#
+# QoS and/or fair queueing
+#
+# CONFIG_NET_SCHED is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_IEEE80211 is not set
+
+#
 # Device Drivers
 #
 
@@ -118,6 +245,12 @@ CONFIG_BINFMT_FLAT=y
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
 # CONFIG_FW_LOADER is not set
+# CONFIG_SYS_HYPERVISOR is not set
+
+#
+# Connector - unified userspace <-> kernelspace linker
+#
+# CONFIG_CONNECTOR is not set
 
 #
 # Memory Technology Devices (MTD)
@@ -136,7 +269,6 @@ CONFIG_PREVENT_FIRMWARE_BUILD=y
 #
 # Block devices
 #
-# CONFIG_BLK_DEV_FD is not set
 # CONFIG_BLK_DEV_COW_COMMON is not set
 CONFIG_BLK_DEV_LOOP=y
 # CONFIG_BLK_DEV_CRYPTOLOOP is not set
@@ -144,18 +276,15 @@ CONFIG_BLK_DEV_NBD=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 # CONFIG_BLK_DEV_INITRD is not set
-CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
 
 #
-# IO Schedulers
+# Misc devices
 #
-CONFIG_IOSCHED_NOOP=y
-# CONFIG_IOSCHED_AS is not set
-CONFIG_IOSCHED_DEADLINE=y
-CONFIG_IOSCHED_CFQ=y
-# CONFIG_ATA_OVER_ETH is not set
+# CONFIG_TIFM_CORE is not set
 
 #
 # ATA/ATAPI/MFM/RLL support
@@ -165,7 +294,13 @@ CONFIG_IOSCHED_CFQ=y
 #
 # SCSI device support
 #
+# CONFIG_RAID_ATTRS is not set
 # CONFIG_SCSI is not set
+# CONFIG_SCSI_NETLINK is not set
+
+#
+# Serial ATA (prod) and Parallel ATA (experimental) drivers
+#
 
 #
 # Multi-device support (RAID and LVM)
@@ -175,6 +310,7 @@ CONFIG_IOSCHED_CFQ=y
 #
 # Fusion MPT device support
 #
+# CONFIG_FUSION is not set
 
 #
 # IEEE 1394 (FireWire) support
@@ -185,69 +321,8 @@ CONFIG_IOSCHED_CFQ=y
 #
 
 #
-# Networking support
-#
-CONFIG_NET=y
-
-#
-# Networking options
-#
-CONFIG_PACKET=y
-# CONFIG_PACKET_MMAP is not set
-CONFIG_UNIX=y
-# CONFIG_NET_KEY is not set
-CONFIG_INET=y
-# CONFIG_IP_MULTICAST is not set
-# CONFIG_IP_ADVANCED_ROUTER is not set
-CONFIG_IP_PNP=y
-CONFIG_IP_PNP_DHCP=y
-# CONFIG_IP_PNP_BOOTP is not set
-# CONFIG_IP_PNP_RARP is not set
-# CONFIG_NET_IPIP is not set
-# CONFIG_NET_IPGRE is not set
-# CONFIG_ARPD is not set
-# CONFIG_SYN_COOKIES is not set
-# CONFIG_INET_AH is not set
-# CONFIG_INET_ESP is not set
-# CONFIG_INET_IPCOMP is not set
-# CONFIG_INET_TUNNEL is not set
-CONFIG_IP_TCPDIAG=y
-# CONFIG_IP_TCPDIAG_IPV6 is not set
-# CONFIG_IPV6 is not set
-# CONFIG_NETFILTER is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
-#
-# CONFIG_IP_SCTP is not set
-# CONFIG_ATM is not set
-# CONFIG_BRIDGE is not set
-# CONFIG_VLAN_8021Q is not set
-# CONFIG_DECNET is not set
-# CONFIG_LLC2 is not set
-# CONFIG_IPX is not set
-# CONFIG_ATALK is not set
-# CONFIG_X25 is not set
-# CONFIG_LAPB is not set
-# CONFIG_NET_DIVERT is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
-# CONFIG_NET_SCHED is not set
-# CONFIG_NET_CLS_ROUTE is not set
-
-#
-# Network testing
+# Network device support
 #
-# CONFIG_NET_PKTGEN is not set
-# CONFIG_NETPOLL is not set
-# CONFIG_NET_POLL_CONTROLLER is not set
-# CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
-# CONFIG_BT is not set
 CONFIG_NETDEVICES=y
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
@@ -255,6 +330,10 @@ CONFIG_NETDEVICES=y
 # CONFIG_TUN is not set
 
 #
+# PHY device support
+#
+
+#
 # Ethernet (10 or 100Mbit)
 #
 # CONFIG_NET_ETHERNET is not set
@@ -285,6 +364,8 @@ CONFIG_NE2000=y
 # CONFIG_SLIP is not set
 # CONFIG_SHAPER is not set
 # CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
 
 #
 # ISDN subsystem
@@ -300,6 +381,7 @@ CONFIG_NE2000=y
 # Input device support
 #
 CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set
 
 #
 # Userland interfaces
@@ -328,7 +410,6 @@ CONFIG_SERIO_SERPORT=y
 # CONFIG_SERIO_LIBPS2 is not set
 # CONFIG_SERIO_RAW is not set
 # CONFIG_GAMEPORT is not set
-CONFIG_SOUND_GAMEPORT=y
 
 #
 # Character devices
@@ -348,7 +429,6 @@ CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
 CONFIG_SERIAL_M32R_SIO=y
 CONFIG_SERIAL_M32R_SIO_CONSOLE=y
-# CONFIG_SERIAL_M32R_PLDSIO is not set
 CONFIG_UNIX98_PTYS=y
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
@@ -362,20 +442,20 @@ CONFIG_LEGACY_PTY_COUNT=256
 # Watchdog Cards
 #
 # CONFIG_WATCHDOG is not set
+CONFIG_HW_RANDOM=y
 # CONFIG_RTC is not set
-# CONFIG_GEN_RTC is not set
 # CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
 
 #
 # Ftape, the floppy tape device driver
 #
-# CONFIG_DRM is not set
 # CONFIG_RAW_DRIVER is not set
 
 #
 # TPM devices
 #
+# CONFIG_TCG_TPM is not set
 
 #
 # I2C support
@@ -383,13 +463,25 @@ CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_I2C is not set
 
 #
+# SPI support
+#
+# CONFIG_SPI is not set
+# CONFIG_SPI_MASTER is not set
+
+#
 # Dallas's 1-wire bus
 #
 # CONFIG_W1 is not set
 
 #
-# Misc devices
+# Hardware Monitoring support
 #
+CONFIG_HWMON=y
+# CONFIG_HWMON_VID is not set
+# CONFIG_SENSORS_ABITUGURU is not set
+# CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_VT1211 is not set
+# CONFIG_HWMON_DEBUG_CHIP is not set
 
 #
 # Multimedia devices
@@ -404,7 +496,9 @@ CONFIG_LEGACY_PTY_COUNT=256
 #
 # Graphics support
 #
+CONFIG_FIRMWARE_EDID=y
 # CONFIG_FB is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
 # Sound
@@ -416,6 +510,11 @@ CONFIG_LEGACY_PTY_COUNT=256
 #
 # CONFIG_USB_ARCH_HAS_HCD is not set
 # CONFIG_USB_ARCH_HAS_OHCI is not set
+# CONFIG_USB_ARCH_HAS_EHCI is not set
+
+#
+# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+#
 
 #
 # USB Gadget Support
@@ -428,9 +527,43 @@ CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_MMC is not set
 
 #
+# LED devices
+#
+# CONFIG_NEW_LEDS is not set
+
+#
+# LED drivers
+#
+
+#
+# LED Triggers
+#
+
+#
 # InfiniBand support
 #
-# CONFIG_INFINIBAND is not set
+
+#
+# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
+#
+
+#
+# Real Time Clock
+#
+# CONFIG_RTC_CLASS is not set
+
+#
+# DMA Engine support
+#
+# CONFIG_DMA_ENGINE is not set
+
+#
+# DMA Clients
+#
+
+#
+# DMA Devices
+#
 
 #
 # File systems
@@ -438,20 +571,22 @@ CONFIG_LEGACY_PTY_COUNT=256
 CONFIG_EXT2_FS=y
 # CONFIG_EXT2_FS_XATTR is not set
 # CONFIG_EXT3_FS is not set
-# CONFIG_JBD is not set
+# CONFIG_EXT4DEV_FS is not set
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
-
-#
-# XFS support
-#
+# CONFIG_FS_POSIX_ACL is not set
 # CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
 # CONFIG_MINIX_FS is not set
 # CONFIG_ROMFS_FS is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
 CONFIG_DNOTIFY=y
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
 
 #
 # CD-ROM/DVD Filesystems
@@ -470,13 +605,12 @@ CONFIG_DNOTIFY=y
 # Pseudo filesystems
 #
 CONFIG_PROC_FS=y
+CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
-# CONFIG_DEVFS_FS is not set
-CONFIG_DEVPTS_FS_XATTR=y
-CONFIG_DEVPTS_FS_SECURITY=y
 # CONFIG_TMPFS is not set
 # CONFIG_HUGETLB_PAGE is not set
 CONFIG_RAMFS=y
+# CONFIG_CONFIGFS_FS is not set
 
 #
 # Miscellaneous filesystems
@@ -500,12 +634,14 @@ CONFIG_RAMFS=y
 #
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
 # CONFIG_NFS_V4 is not set
 # CONFIG_NFS_DIRECTIO is not set
 # CONFIG_NFSD is not set
 CONFIG_ROOT_NFS=y
 CONFIG_LOCKD=y
 CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
 # CONFIG_RPCSEC_GSS_KRB5 is not set
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
@@ -514,6 +650,7 @@ CONFIG_SUNRPC=y
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
+# CONFIG_9P_FS is not set
 
 #
 # Partition Types
@@ -574,10 +711,16 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 # Kernel hacking
 #
 # CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_MUST_CHECK=y
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
 # CONFIG_DEBUG_KERNEL is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_DEBUG_FS is not set
 # CONFIG_FRAME_POINTER is not set
+# CONFIG_UNWIND_INFO is not set
+# CONFIG_HEADERS_CHECK is not set
 
 #
 # Security options
@@ -591,12 +734,9 @@ CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CRYPTO is not set
 
 #
-# Hardware crypto devices
-#
-
-#
 # Library routines
 #
 # CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
 CONFIG_CRC32=y
 # CONFIG_LIBCRC32C is not set
diff -puN arch/m32r/opsput/defconfig.opsput~m32r-update-defconfig-files-for-v2619 arch/m32r/opsput/defconfig.opsput
--- a/arch/m32r/opsput/defconfig.opsput~m32r-update-defconfig-files-for-v2619
+++ a/arch/m32r/opsput/defconfig.opsput
@@ -1,19 +1,18 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.12-rc5
-# Fri Jun  3 16:22:06 2005
+# Linux kernel version: 2.6.19
+# Wed Dec 13 18:34:36 2006
 #
 CONFIG_M32R=y
-# CONFIG_UID16 is not set
 CONFIG_GENERIC_ISA_DMA=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
 # Code maturity level options
 #
 CONFIG_EXPERIMENTAL=y
-CONFIG_CLEAN_COMPILE=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
 
@@ -21,32 +20,39 @@ CONFIG_INIT_ENV_ARG_LIMIT=32
 # General setup
 #
 CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SWAP=y
 CONFIG_SYSVIPC=y
+# CONFIG_IPC_NS is not set
 # CONFIG_POSIX_MQUEUE is not set
 CONFIG_BSD_PROCESS_ACCT=y
 # CONFIG_BSD_PROCESS_ACCT_V3 is not set
-CONFIG_SYSCTL=y
+# CONFIG_TASKSTATS is not set
+# CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
-CONFIG_HOTPLUG=y
-CONFIG_KOBJECT_UEVENT=y
 CONFIG_IKCONFIG=y
 # CONFIG_IKCONFIG_PROC is not set
+CONFIG_SYSFS_DEPRECATED=y
+# CONFIG_RELAY is not set
+CONFIG_INITRAMFS_SOURCE=""
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
 CONFIG_EMBEDDED=y
+CONFIG_SYSCTL_SYSCALL=y
 # CONFIG_KALLSYMS is not set
+CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
+CONFIG_ELF_CORE=y
 CONFIG_BASE_FULL=y
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SHMEM=y
-CONFIG_CC_ALIGN_FUNCTIONS=0
-CONFIG_CC_ALIGN_LABELS=0
-CONFIG_CC_ALIGN_LOOPS=0
-CONFIG_CC_ALIGN_JUMPS=0
+CONFIG_SLAB=y
+CONFIG_VM_EVENT_COUNTERS=y
 # CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=0
+# CONFIG_SLOB is not set
 
 #
 # Loadable module support
@@ -54,12 +60,30 @@ CONFIG_BASE_SMALL=0
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
-CONFIG_OBSOLETE_MODPARM=y
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_KMOD=y
 
 #
+# Block layer
+#
+CONFIG_BLOCK=y
+# CONFIG_BLK_DEV_IO_TRACE is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+# CONFIG_IOSCHED_AS is not set
+CONFIG_IOSCHED_DEADLINE=y
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_AS is not set
+# CONFIG_DEFAULT_DEADLINE is not set
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
+
+#
 # Processor type and features
 #
 # CONFIG_PLAT_MAPPI is not set
@@ -69,8 +93,10 @@ CONFIG_PLAT_OPSPUT=y
 # CONFIG_PLAT_OAKS32R is not set
 # CONFIG_PLAT_MAPPI2 is not set
 # CONFIG_PLAT_MAPPI3 is not set
+# CONFIG_PLAT_M32104UT is not set
 # CONFIG_CHIP_M32700 is not set
 # CONFIG_CHIP_M32102 is not set
+# CONFIG_CHIP_M32104 is not set
 # CONFIG_CHIP_VDEC2 is not set
 CONFIG_CHIP_OPSP=y
 CONFIG_MMU=y
@@ -84,17 +110,31 @@ CONFIG_TIMER_DIVIDE=128
 CONFIG_MEMORY_START=0x08000000
 CONFIG_MEMORY_SIZE=0x01000000
 CONFIG_NOHIGHMEM=y
-# CONFIG_DISCONTIGMEM is not set
+CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
+CONFIG_SELECT_MEMORY_MODEL=y
+# CONFIG_FLATMEM_MANUAL is not set
+CONFIG_DISCONTIGMEM_MANUAL=y
+# CONFIG_SPARSEMEM_MANUAL is not set
+CONFIG_DISCONTIGMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+CONFIG_NEED_MULTIPLE_NODES=y
+# CONFIG_SPARSEMEM_STATIC is not set
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
+CONFIG_IRAM_START=0x00f00000
+CONFIG_IRAM_SIZE=0x00010000
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 # CONFIG_PREEMPT is not set
 # CONFIG_SMP is not set
+CONFIG_NODES_SHIFT=1
 
 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
 #
-# CONFIG_PCI is not set
 # CONFIG_ISA is not set
 
 #
@@ -103,13 +143,15 @@ CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_PCCARD=y
 # CONFIG_PCMCIA_DEBUG is not set
 CONFIG_PCMCIA=y
+CONFIG_PCMCIA_LOAD_CIS=y
+CONFIG_PCMCIA_IOCTL=y
 
 #
 # PC-card bridges
 #
-# CONFIG_TCIC is not set
 CONFIG_M32R_CFC=y
 CONFIG_M32R_CFC_NUM=1
+CONFIG_PCCARD_NONSTATIC=y
 
 #
 # PCI Hotplug Support
@@ -122,6 +164,94 @@ CONFIG_BINFMT_ELF=y
 # CONFIG_BINFMT_MISC is not set
 
 #
+# Networking
+#
+CONFIG_NET=y
+
+#
+# Networking options
+#
+# CONFIG_NETDEBUG is not set
+CONFIG_PACKET=y
+# CONFIG_PACKET_MMAP is not set
+CONFIG_UNIX=y
+CONFIG_XFRM=y
+# CONFIG_XFRM_USER is not set
+# CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+# CONFIG_IP_MULTICAST is not set
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+# CONFIG_IP_PNP_BOOTP is not set
+# CONFIG_IP_PNP_RARP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_ARPD is not set
+# CONFIG_SYN_COOKIES is not set
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+CONFIG_INET_XFRM_MODE_TRANSPORT=y
+CONFIG_INET_XFRM_MODE_TUNNEL=y
+CONFIG_INET_XFRM_MODE_BEET=y
+CONFIG_INET_DIAG=y
+CONFIG_INET_TCP_DIAG=y
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_INET6_XFRM_TUNNEL is not set
+# CONFIG_INET6_TUNNEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+
+#
+# DCCP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_DCCP is not set
+
+#
+# SCTP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_SCTP is not set
+
+#
+# TIPC Configuration (EXPERIMENTAL)
+#
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+
+#
+# QoS and/or fair queueing
+#
+# CONFIG_NET_SCHED is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_IEEE80211 is not set
+
+#
 # Device Drivers
 #
 
@@ -130,8 +260,14 @@ CONFIG_BINFMT_ELF=y
 #
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
-# CONFIG_FW_LOADER is not set
+CONFIG_FW_LOADER=y
 # CONFIG_DEBUG_DRIVER is not set
+# CONFIG_SYS_HYPERVISOR is not set
+
+#
+# Connector - unified userspace <-> kernelspace linker
+#
+# CONFIG_CONNECTOR is not set
 
 #
 # Memory Technology Devices (MTD)
@@ -150,7 +286,6 @@ CONFIG_PREVENT_FIRMWARE_BUILD=y
 #
 # Block devices
 #
-# CONFIG_BLK_DEV_FD is not set
 # CONFIG_BLK_DEV_COW_COMMON is not set
 CONFIG_BLK_DEV_LOOP=y
 # CONFIG_BLK_DEV_CRYPTOLOOP is not set
@@ -158,18 +293,15 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 # CONFIG_BLK_DEV_INITRD is not set
-CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
 
 #
-# IO Schedulers
+# Misc devices
 #
-CONFIG_IOSCHED_NOOP=y
-# CONFIG_IOSCHED_AS is not set
-CONFIG_IOSCHED_DEADLINE=y
-CONFIG_IOSCHED_CFQ=y
-# CONFIG_ATA_OVER_ETH is not set
+# CONFIG_TIFM_CORE is not set
 
 #
 # ATA/ATAPI/MFM/RLL support
@@ -179,7 +311,9 @@ CONFIG_IOSCHED_CFQ=y
 #
 # SCSI device support
 #
+# CONFIG_RAID_ATTRS is not set
 CONFIG_SCSI=m
+# CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
 
 #
@@ -191,6 +325,7 @@ CONFIG_BLK_DEV_SD=m
 CONFIG_BLK_DEV_SR=m
 # CONFIG_BLK_DEV_SR_VENDOR is not set
 CONFIG_CHR_DEV_SG=m
+# CONFIG_CHR_DEV_SCH is not set
 
 #
 # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
@@ -200,16 +335,18 @@ CONFIG_SCSI_MULTI_LUN=y
 # CONFIG_SCSI_LOGGING is not set
 
 #
-# SCSI Transport Attributes
+# SCSI Transports
 #
 # CONFIG_SCSI_SPI_ATTRS is not set
 # CONFIG_SCSI_FC_ATTRS is not set
 # CONFIG_SCSI_ISCSI_ATTRS is not set
+# CONFIG_SCSI_SAS_ATTRS is not set
+# CONFIG_SCSI_SAS_LIBSAS is not set
 
 #
 # SCSI low-level drivers
 #
-# CONFIG_SCSI_SATA is not set
+# CONFIG_ISCSI_TCP is not set
 # CONFIG_SCSI_DEBUG is not set
 
 #
@@ -222,6 +359,10 @@ CONFIG_SCSI_MULTI_LUN=y
 # CONFIG_PCMCIA_SYM53C500 is not set
 
 #
+# Serial ATA (prod) and Parallel ATA (experimental) drivers
+#
+
+#
 # Multi-device support (RAID and LVM)
 #
 # CONFIG_MD is not set
@@ -229,6 +370,7 @@ CONFIG_SCSI_MULTI_LUN=y
 #
 # Fusion MPT device support
 #
+# CONFIG_FUSION is not set
 
 #
 # IEEE 1394 (FireWire) support
@@ -239,69 +381,8 @@ CONFIG_SCSI_MULTI_LUN=y
 #
 
 #
-# Networking support
-#
-CONFIG_NET=y
-
-#
-# Networking options
-#
-CONFIG_PACKET=y
-# CONFIG_PACKET_MMAP is not set
-CONFIG_UNIX=y
-# CONFIG_NET_KEY is not set
-CONFIG_INET=y
-# CONFIG_IP_MULTICAST is not set
-# CONFIG_IP_ADVANCED_ROUTER is not set
-CONFIG_IP_PNP=y
-CONFIG_IP_PNP_DHCP=y
-# CONFIG_IP_PNP_BOOTP is not set
-# CONFIG_IP_PNP_RARP is not set
-# CONFIG_NET_IPIP is not set
-# CONFIG_NET_IPGRE is not set
-# CONFIG_ARPD is not set
-# CONFIG_SYN_COOKIES is not set
-# CONFIG_INET_AH is not set
-# CONFIG_INET_ESP is not set
-# CONFIG_INET_IPCOMP is not set
-# CONFIG_INET_TUNNEL is not set
-CONFIG_IP_TCPDIAG=y
-# CONFIG_IP_TCPDIAG_IPV6 is not set
-# CONFIG_IPV6 is not set
-# CONFIG_NETFILTER is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
+# Network device support
 #
-# CONFIG_IP_SCTP is not set
-# CONFIG_ATM is not set
-# CONFIG_BRIDGE is not set
-# CONFIG_VLAN_8021Q is not set
-# CONFIG_DECNET is not set
-# CONFIG_LLC2 is not set
-# CONFIG_IPX is not set
-# CONFIG_ATALK is not set
-# CONFIG_X25 is not set
-# CONFIG_LAPB is not set
-# CONFIG_NET_DIVERT is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
-# CONFIG_NET_SCHED is not set
-# CONFIG_NET_CLS_ROUTE is not set
-
-#
-# Network testing
-#
-# CONFIG_NET_PKTGEN is not set
-# CONFIG_NETPOLL is not set
-# CONFIG_NET_POLL_CONTROLLER is not set
-# CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
-# CONFIG_BT is not set
 CONFIG_NETDEVICES=y
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
@@ -309,6 +390,11 @@ CONFIG_NETDEVICES=y
 # CONFIG_TUN is not set
 
 #
+# PHY device support
+#
+# CONFIG_PHYLIB is not set
+
+#
 # Ethernet (10 or 100Mbit)
 #
 CONFIG_NET_ETHERNET=y
@@ -346,6 +432,8 @@ CONFIG_SMC91X=y
 # CONFIG_SLIP is not set
 # CONFIG_SHAPER is not set
 # CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
 
 #
 # ISDN subsystem
@@ -361,6 +449,7 @@ CONFIG_SMC91X=y
 # Input device support
 #
 CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set
 
 #
 # Userland interfaces
@@ -389,7 +478,6 @@ CONFIG_SERIO_SERPORT=y
 # CONFIG_SERIO_LIBPS2 is not set
 # CONFIG_SERIO_RAW is not set
 # CONFIG_GAMEPORT is not set
-CONFIG_SOUND_GAMEPORT=y
 
 #
 # Character devices
@@ -423,8 +511,8 @@ CONFIG_LEGACY_PTY_COUNT=256
 # Watchdog Cards
 #
 # CONFIG_WATCHDOG is not set
+CONFIG_HW_RANDOM=y
 # CONFIG_RTC is not set
-# CONFIG_GEN_RTC is not set
 CONFIG_DS1302=y
 # CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
@@ -432,17 +520,19 @@ CONFIG_DS1302=y
 #
 # Ftape, the floppy tape device driver
 #
-# CONFIG_DRM is not set
 
 #
 # PCMCIA character devices
 #
 # CONFIG_SYNCLINK_CS is not set
+# CONFIG_CARDMAN_4000 is not set
+# CONFIG_CARDMAN_4040 is not set
 # CONFIG_RAW_DRIVER is not set
 
 #
 # TPM devices
 #
+# CONFIG_TCG_TPM is not set
 
 #
 # I2C support
@@ -450,13 +540,25 @@ CONFIG_DS1302=y
 # CONFIG_I2C is not set
 
 #
+# SPI support
+#
+# CONFIG_SPI is not set
+# CONFIG_SPI_MASTER is not set
+
+#
 # Dallas's 1-wire bus
 #
 # CONFIG_W1 is not set
 
 #
-# Misc devices
+# Hardware Monitoring support
 #
+CONFIG_HWMON=y
+# CONFIG_HWMON_VID is not set
+# CONFIG_SENSORS_ABITUGURU is not set
+# CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_VT1211 is not set
+# CONFIG_HWMON_DEBUG_CHIP is not set
 
 #
 # Multimedia devices
@@ -471,7 +573,9 @@ CONFIG_DS1302=y
 #
 # Graphics support
 #
+CONFIG_FIRMWARE_EDID=y
 # CONFIG_FB is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
 # Sound
@@ -483,6 +587,11 @@ CONFIG_DS1302=y
 #
 # CONFIG_USB_ARCH_HAS_HCD is not set
 # CONFIG_USB_ARCH_HAS_OHCI is not set
+# CONFIG_USB_ARCH_HAS_EHCI is not set
+
+#
+# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+#
 
 #
 # USB Gadget Support
@@ -495,38 +604,73 @@ CONFIG_DS1302=y
 # CONFIG_MMC is not set
 
 #
+# LED devices
+#
+# CONFIG_NEW_LEDS is not set
+
+#
+# LED drivers
+#
+
+#
+# LED Triggers
+#
+
+#
 # InfiniBand support
 #
-# CONFIG_INFINIBAND is not set
+
+#
+# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
+#
+
+#
+# Real Time Clock
+#
+# CONFIG_RTC_CLASS is not set
+
+#
+# DMA Engine support
+#
+# CONFIG_DMA_ENGINE is not set
+
+#
+# DMA Clients
+#
+
+#
+# DMA Devices
+#
 
 #
 # File systems
 #
 CONFIG_EXT2_FS=y
 # CONFIG_EXT2_FS_XATTR is not set
-CONFIG_EXT3_FS=m
+# CONFIG_EXT2_FS_XIP is not set
+CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_XATTR=y
 # CONFIG_EXT3_FS_POSIX_ACL is not set
 # CONFIG_EXT3_FS_SECURITY is not set
-CONFIG_JBD=m
+# CONFIG_EXT4DEV_FS is not set
+CONFIG_JBD=y
 CONFIG_JBD_DEBUG=y
 CONFIG_FS_MBCACHE=y
-CONFIG_REISERFS_FS=m
-# CONFIG_REISERFS_CHECK is not set
-# CONFIG_REISERFS_PROC_INFO is not set
-# CONFIG_REISERFS_FS_XATTR is not set
+# CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
-
-#
-# XFS support
-#
+# CONFIG_FS_POSIX_ACL is not set
 # CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
 # CONFIG_MINIX_FS is not set
 # CONFIG_ROMFS_FS is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
 CONFIG_DNOTIFY=y
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
 
 #
 # CD-ROM/DVD Filesystems
@@ -552,15 +696,13 @@ CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
 #
 CONFIG_PROC_FS=y
 CONFIG_PROC_KCORE=y
+CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
-CONFIG_DEVFS_FS=y
-CONFIG_DEVFS_MOUNT=y
-# CONFIG_DEVFS_DEBUG is not set
-# CONFIG_DEVPTS_FS_XATTR is not set
 CONFIG_TMPFS=y
-# CONFIG_TMPFS_XATTR is not set
+# CONFIG_TMPFS_POSIX_ACL is not set
 # CONFIG_HUGETLB_PAGE is not set
 CONFIG_RAMFS=y
+# CONFIG_CONFIGFS_FS is not set
 
 #
 # Miscellaneous filesystems
@@ -584,12 +726,14 @@ CONFIG_RAMFS=y
 #
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
 # CONFIG_NFS_V4 is not set
 # CONFIG_NFS_DIRECTIO is not set
 # CONFIG_NFSD is not set
 CONFIG_ROOT_NFS=y
 CONFIG_LOCKD=y
 CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
 # CONFIG_RPCSEC_GSS_KRB5 is not set
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
@@ -598,6 +742,7 @@ CONFIG_SUNRPC=y
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
+# CONFIG_9P_FS is not set
 
 #
 # Partition Types
@@ -658,21 +803,32 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 # Kernel hacking
 #
 # CONFIG_PRINTK_TIME is not set
-CONFIG_DEBUG_KERNEL=y
+CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
+CONFIG_DEBUG_KERNEL=y
 CONFIG_LOG_BUF_SHIFT=14
+CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_DEBUG_SLAB is not set
 # CONFIG_DEBUG_SPINLOCK is not set
+# CONFIG_DEBUG_MUTEXES is not set
+# CONFIG_DEBUG_RWSEMS is not set
 # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
+# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
 # CONFIG_DEBUG_KOBJECT is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_FS is not set
+# CONFIG_DEBUG_VM is not set
+# CONFIG_DEBUG_LIST is not set
 # CONFIG_FRAME_POINTER is not set
+# CONFIG_UNWIND_INFO is not set
+CONFIG_FORCED_INLINING=y
+# CONFIG_HEADERS_CHECK is not set
+# CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_DEBUG_STACKOVERFLOW is not set
 # CONFIG_DEBUG_STACK_USAGE is not set
-# CONFIG_DEBUG_PAGEALLOC is not set
 
 #
 # Security options
@@ -686,12 +842,9 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_CRYPTO is not set
 
 #
-# Hardware crypto devices
-#
-
-#
 # Library routines
 #
 # CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
 CONFIG_CRC32=y
 # CONFIG_LIBCRC32C is not set
_

Patches currently in -mm which might be from takata@linux-m32r.org are

m32r-build-fix-for-processors-without-isa_dsp_level2.patch
m32r-fix-do_page_fault-and-update_mmu_cache.patch
m32r-update-defconfig-files-for-v2619.patch
m32r-fix-kernel-entry-address-of-vmlinux.patch
m32r-cosmetic-updates-and-trivial-fixes.patch

