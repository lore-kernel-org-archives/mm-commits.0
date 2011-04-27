From: akpm@linux-foundation.org
Subject: [failures] init-kconfig-use-if-endif-to-surround-the-expert-menu-kconfig-symbols.patch removed from -mm tree
Date: Wed, 27 Apr 2011 15:38:58 -0700
Message-ID: <201104272315.p3RNF1eR009882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760166Ab1D0XPs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Apr 2011 19:15:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, pefoley2@verizon.net, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     init/Kconfig: use if/endif to surround the EXPERT menu kconfig symbols
has been removed from the -mm tree.  Its filename was
     init-kconfig-use-if-endif-to-surround-the-expert-menu-kconfig-symbols.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init/Kconfig: use if/endif to surround the EXPERT menu kconfig symbols
From: Randy Dunlap <randy.dunlap@oracle.com>

Surround the EXPERT menu with "if EXPERT" and "endif" so that it is forced
to stay as one unit.  Hopefully this will help to prevent it being broken
in the future.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Peter Foley <pefoley2@verizon.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff -puN init/Kconfig~init-kconfig-use-if-endif-to-surround-the-expert-menu-kconfig-symbols init/Kconfig
--- a/init/Kconfig~init-kconfig-use-if-endif-to-surround-the-expert-menu-kconfig-symbols
+++ a/init/Kconfig
@@ -929,15 +929,17 @@ menuconfig EXPERT
           environments which can tolerate a "non-standard" kernel.
           Only use this if you really know what you are doing.
 
+if EXPERT
+
 config UID16
-	bool "Enable 16-bit UID system calls" if EXPERT
+	bool "Enable 16-bit UID system calls"
 	depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && COMPAT) || UML || (X86_64 && IA32_EMULATION)
 	default y
 	help
 	  This enables the legacy 16-bit UID syscall wrappers.
 
 config SYSCTL_SYSCALL
-	bool "Sysctl syscall support" if EXPERT
+	bool "Sysctl syscall support"
 	depends on PROC_SYSCTL
 	default y
 	select SYSCTL
@@ -954,7 +956,7 @@ config SYSCTL_SYSCALL
 	  If unsure say Y here.
 
 config KALLSYMS
-	 bool "Load all symbols for debugging/ksymoops" if EXPERT
+	 bool "Load all symbols for debugging/ksymoops"
 	 default y
 	 help
 	   Say Y here to let the kernel print out symbolic crash information and
@@ -979,7 +981,7 @@ config KALLSYMS_ALL
 	   Say N unless you really need all symbols.
 
 config HOTPLUG
-	bool "Support for hot-pluggable devices" if EXPERT
+	bool "Support for hot-pluggable devices"
 	default y
 	help
 	  This option is provided for the case where no hotplug or uevent
@@ -989,7 +991,7 @@ config HOTPLUG
 
 config PRINTK
 	default y
-	bool "Enable support for printk" if EXPERT
+	bool "Enable support for printk"
 	help
 	  This option enables normal printk support. Removing it
 	  eliminates most of the message strings from the kernel image
@@ -998,7 +1000,7 @@ config PRINTK
 	  strongly discouraged.
 
 config BUG
-	bool "BUG() support" if EXPERT
+	bool "BUG() support"
 	default y
 	help
           Disabling this option eliminates support for BUG and WARN, reducing
@@ -1009,12 +1011,12 @@ config BUG
 
 config ELF_CORE
 	default y
-	bool "Enable ELF core dumps" if EXPERT
+	bool "Enable ELF core dumps"
 	help
 	  Enable support for generating core dumps. Disabling saves about 4k.
 
 config PCSPKR_PLATFORM
-	bool "Enable PC-Speaker support" if EXPERT
+	bool "Enable PC-Speaker support"
 	depends on ALPHA || X86 || MIPS || PPC_PREP || PPC_CHRP || PPC_PSERIES
 	default y
 	help
@@ -1023,14 +1025,14 @@ config PCSPKR_PLATFORM
 
 config BASE_FULL
 	default y
-	bool "Enable full-sized data structures for core" if EXPERT
+	bool "Enable full-sized data structures for core"
 	help
 	  Disabling this option reduces the size of miscellaneous core
 	  kernel data structures. This saves memory on small machines,
 	  but may reduce performance.
 
 config FUTEX
-	bool "Enable futex support" if EXPERT
+	bool "Enable futex support"
 	default y
 	select RT_MUTEXES
 	help
@@ -1039,7 +1041,7 @@ config FUTEX
 	  run glibc-based applications correctly.
 
 config EPOLL
-	bool "Enable eventpoll support" if EXPERT
+	bool "Enable eventpoll support"
 	default y
 	select ANON_INODES
 	help
@@ -1047,7 +1049,7 @@ config EPOLL
 	  support for epoll family of system calls.
 
 config SIGNALFD
-	bool "Enable signalfd() system call" if EXPERT
+	bool "Enable signalfd() system call"
 	select ANON_INODES
 	default y
 	help
@@ -1057,7 +1059,7 @@ config SIGNALFD
 	  If unsure, say Y.
 
 config TIMERFD
-	bool "Enable timerfd() system call" if EXPERT
+	bool "Enable timerfd() system call"
 	select ANON_INODES
 	default y
 	help
@@ -1067,7 +1069,7 @@ config TIMERFD
 	  If unsure, say Y.
 
 config EVENTFD
-	bool "Enable eventfd() system call" if EXPERT
+	bool "Enable eventfd() system call"
 	select ANON_INODES
 	default y
 	help
@@ -1077,7 +1079,7 @@ config EVENTFD
 	  If unsure, say Y.
 
 config SHMEM
-	bool "Use full shmem filesystem" if EXPERT
+	bool "Use full shmem filesystem"
 	default y
 	depends on MMU
 	help
@@ -1088,13 +1090,15 @@ config SHMEM
 	  which may be appropriate on small systems without swap.
 
 config AIO
-	bool "Enable AIO support" if EXPERT
+	bool "Enable AIO support"
 	default y
 	help
 	  This option enables POSIX asynchronous I/O which may by used
           by some high performance threaded applications. Disabling
           this option saves about 7k.
 
+endif # EXPERT menu
+
 config EMBEDDED
 	bool "Embedded system"
 	select EXPERT
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

uml-fix-hppfs-build.patch
linux-next.patch
drivers-leds-leds-pca9532c-add-gpio-capability.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

