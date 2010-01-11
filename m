From: akpm@linux-foundation.org
Subject: [merged] mn10300-update-the-asb2303-defconfig.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:19:40 -0800
Message-ID: <201001112019.o0BKJeSN025588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754408Ab0AKUbL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:31:11 -0500
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

Update the defconfig for the ASB2303 platform.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/configs/asb2303_defconfig |  107 +++++++++++++++--------
 1 file changed, 70 insertions(+), 37 deletions(-)

diff -puN arch/mn10300/configs/asb2303_defconfig~mn10300-update-the-asb2303-defconfig arch/mn10300/configs/asb2303_defconfig
--- a/arch/mn10300/configs/asb2303_defconfig~mn10300-update-the-asb2303-defconfig
+++ a/arch/mn10300/configs/asb2303_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.30-rc2
-# Sat Apr 18 11:13:22 2009
+# Linux kernel version: 2.6.33-rc1
+# Tue Dec 22 19:26:25 2009
 #
 CONFIG_MN10300=y
 CONFIG_AM33=y
@@ -22,6 +22,7 @@ CONFIG_GENERIC_HARDIRQS=y
 # CONFIG_HOTPLUG_CPU is not set
 CONFIG_HZ=1000
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+CONFIG_CONSTRUCTORS=y
 
 #
 # General setup
@@ -43,11 +44,10 @@ CONFIG_BSD_PROCESS_ACCT=y
 #
 # RCU Subsystem
 #
-CONFIG_CLASSIC_RCU=y
 # CONFIG_TREE_RCU is not set
-# CONFIG_PREEMPT_RCU is not set
+# CONFIG_TREE_PREEMPT_RCU is not set
+CONFIG_TINY_RCU=y
 # CONFIG_TREE_RCU_TRACE is not set
-# CONFIG_PREEMPT_RCU_TRACE is not set
 # CONFIG_IKCONFIG is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_GROUP_SCHED is not set
@@ -62,7 +62,6 @@ CONFIG_ANON_INODES=y
 CONFIG_EMBEDDED=y
 CONFIG_SYSCTL_SYSCALL=y
 # CONFIG_KALLSYMS is not set
-CONFIG_STRIP_ASM_SYMS=y
 # CONFIG_HOTPLUG is not set
 CONFIG_PRINTK=y
 CONFIG_BUG=y
@@ -75,14 +74,22 @@ CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
 CONFIG_SHMEM=y
 CONFIG_AIO=y
+
+#
+# Kernel Performance Events And Counters
+#
 # CONFIG_VM_EVENT_COUNTERS is not set
 CONFIG_COMPAT_BRK=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
 # CONFIG_SLOB is not set
 CONFIG_PROFILING=y
-# CONFIG_MARKERS is not set
 CONFIG_HAVE_OPROFILE=y
+CONFIG_HAVE_ARCH_TRACEHOOK=y
+
+#
+# GCOV-based kernel profiling
+#
 # CONFIG_SLOW_WORK is not set
 # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
 CONFIG_SLABINFO=y
@@ -90,6 +97,35 @@ CONFIG_RT_MUTEXES=y
 CONFIG_BASE_SMALL=0
 # CONFIG_MODULES is not set
 # CONFIG_BLOCK is not set
+# CONFIG_INLINE_SPIN_TRYLOCK is not set
+# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
+# CONFIG_INLINE_SPIN_LOCK is not set
+# CONFIG_INLINE_SPIN_LOCK_BH is not set
+# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
+# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
+# CONFIG_INLINE_SPIN_UNLOCK is not set
+# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
+# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
+# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
+# CONFIG_INLINE_READ_TRYLOCK is not set
+# CONFIG_INLINE_READ_LOCK is not set
+# CONFIG_INLINE_READ_LOCK_BH is not set
+# CONFIG_INLINE_READ_LOCK_IRQ is not set
+# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
+# CONFIG_INLINE_READ_UNLOCK is not set
+# CONFIG_INLINE_READ_UNLOCK_BH is not set
+# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
+# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
+# CONFIG_INLINE_WRITE_TRYLOCK is not set
+# CONFIG_INLINE_WRITE_LOCK is not set
+# CONFIG_INLINE_WRITE_LOCK_BH is not set
+# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
+# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
+# CONFIG_INLINE_WRITE_UNLOCK is not set
+# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
+# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
+# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
+# CONFIG_MUTEX_SPIN_ON_OWNER is not set
 # CONFIG_FREEZER is not set
 
 #
@@ -145,9 +181,8 @@ CONFIG_SPLIT_PTLOCK_CPUS=4
 CONFIG_ZONE_DMA_FLAG=0
 CONFIG_NR_QUICK=1
 CONFIG_VIRT_TO_BUS=y
-CONFIG_UNEVICTABLE_LRU=y
-CONFIG_HAVE_MLOCK=y
-CONFIG_HAVE_MLOCKED_PAGE_BIT=y
+# CONFIG_KSM is not set
+CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
 
 #
 # Power management options
@@ -202,6 +237,7 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_NETFILTER is not set
 # CONFIG_IP_DCCP is not set
 # CONFIG_IP_SCTP is not set
+# CONFIG_RDS is not set
 # CONFIG_TIPC is not set
 # CONFIG_ATM is not set
 # CONFIG_BRIDGE is not set
@@ -216,6 +252,7 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_ECONET is not set
 # CONFIG_WAN_ROUTER is not set
 # CONFIG_PHONET is not set
+# CONFIG_IEEE802154 is not set
 # CONFIG_NET_SCHED is not set
 # CONFIG_DCB is not set
 
@@ -341,7 +378,6 @@ CONFIG_MISC_DEVICES=y
 # CONFIG_SCSI_DMA is not set
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_NETDEVICES=y
-CONFIG_COMPAT_NET_DEV_OPS=y
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
 # CONFIG_MACVLAN is not set
@@ -362,14 +398,11 @@ CONFIG_SMC91X=y
 # CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
 # CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
 # CONFIG_B44 is not set
+# CONFIG_KS8842 is not set
+# CONFIG_KS8851_MLL is not set
 # CONFIG_NETDEV_1000 is not set
 # CONFIG_NETDEV_10000 is not set
-
-#
-# Wireless LAN
-#
-# CONFIG_WLAN_PRE80211 is not set
-# CONFIG_WLAN_80211 is not set
+# CONFIG_WLAN is not set
 
 #
 # Enable WiMAX (Networking options) to see the WiMAX drivers
@@ -430,11 +463,15 @@ CONFIG_RTC=y
 # CONFIG_TCG_TPM is not set
 # CONFIG_I2C is not set
 # CONFIG_SPI is not set
+
+#
+# PPS support
+#
+# CONFIG_PPS is not set
 # CONFIG_W1 is not set
 # CONFIG_POWER_SUPPLY is not set
 # CONFIG_HWMON is not set
 # CONFIG_THERMAL is not set
-# CONFIG_THERMAL_HWMON is not set
 # CONFIG_WATCHDOG is not set
 CONFIG_SSB_POSSIBLE=y
 
@@ -451,22 +488,7 @@ CONFIG_SSB_POSSIBLE=y
 # CONFIG_HTC_PASIC3 is not set
 # CONFIG_MFD_TMIO is not set
 # CONFIG_REGULATOR is not set
-
-#
-# Multimedia devices
-#
-
-#
-# Multimedia core support
-#
-# CONFIG_VIDEO_DEV is not set
-# CONFIG_DVB_CORE is not set
-# CONFIG_VIDEO_MEDIA is not set
-
-#
-# Multimedia drivers
-#
-# CONFIG_DAB is not set
+# CONFIG_MEDIA_SUPPORT is not set
 
 #
 # Graphics support
@@ -490,11 +512,17 @@ CONFIG_SSB_POSSIBLE=y
 # CONFIG_DMADEVICES is not set
 # CONFIG_AUXDISPLAY is not set
 # CONFIG_UIO is not set
+
+#
+# TI VLYNQ
+#
 # CONFIG_STAGING is not set
 
 #
 # File systems
 #
+CONFIG_FILE_LOCKING=y
+CONFIG_FSNOTIFY=y
 CONFIG_DNOTIFY=y
 CONFIG_INOTIFY=y
 CONFIG_INOTIFY_USER=y
@@ -539,6 +567,7 @@ CONFIG_NFS_V3=y
 # CONFIG_NFS_V3_ACL is not set
 # CONFIG_NFS_V4 is not set
 CONFIG_ROOT_NFS=y
+# CONFIG_NFSD is not set
 CONFIG_LOCKD=y
 CONFIG_LOCKD_V4=y
 CONFIG_NFS_COMMON=y
@@ -561,13 +590,13 @@ CONFIG_ENABLE_WARN_DEPRECATED=y
 CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_FRAME_WARN=1024
 CONFIG_MAGIC_SYSRQ=y
+CONFIG_STRIP_ASM_SYMS=y
 # CONFIG_UNUSED_SYMBOLS is not set
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
-# CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_MEMORY_INIT is not set
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_SYSCTL_SYSCALL_CHECK is not set
 # CONFIG_SAMPLES is not set
 
@@ -577,7 +606,11 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_KEYS is not set
 # CONFIG_SECURITY is not set
 # CONFIG_SECURITYFS is not set
-# CONFIG_SECURITY_FILE_CAPABILITIES is not set
+# CONFIG_DEFAULT_SECURITY_SELINUX is not set
+# CONFIG_DEFAULT_SECURITY_SMACK is not set
+# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
+CONFIG_DEFAULT_SECURITY_DAC=y
+CONFIG_DEFAULT_SECURITY=""
 # CONFIG_CRYPTO is not set
 # CONFIG_BINARY_PRINTF is not set
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
kernel-credc-use-kmem_cache_free.patch
frv-duplicate-output_buffer-of-e03.patch
coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

