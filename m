From: akpm@linux-foundation.org
Subject: [merged] init-kconfig-re-order-config_expert-options-to-fix-menuconfig-display.patch removed from -mm tree
Date: Tue, 07 May 2013 10:50:59 -0700
Message-ID: <20130507175059.840705A451C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:49248 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509Ab3EGRvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:51:00 -0400
Received: by mail-ye0-f202.google.com with SMTP id r13so86419yen.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:51:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, jovi.zhangwei@huawei.com, mmarek@suse.cz, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: init/Kconfig: re-order CONFIG_EXPERT options to fix menuconfig display
has been removed from the -mm tree.  Its filename was
     init-kconfig-re-order-config_expert-options-to-fix-menuconfig-display.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Frysinger <vapier@gentoo.org>
Subject: init/Kconfig: re-order CONFIG_EXPERT options to fix menuconfig display

The kconfig language requires that dependent options all follow the
menuconfig symbol in order to be collapsed below it.  Recently some hidden
options were added below the EXPERT menuconfig, but did not depend on
EXPERT (because hidden options can't).  This broke the display.  So
re-order all these options, and while we're here stick the PCI quirks
under the EXPERT menu (since it isn't sitting with any related options).

Before this commit, we get:
	[*] Configure standard kernel features (expert users)  --->
	[ ] Sysctl syscall support
	[*] Load all symbols for debugging/ksymoops
	...
	[ ] Embedded system

Now we get the older (and correct) behavior:
	[*] Configure standard kernel features (expert users)  --->
	[ ] Embedded system
And if you go into the expert menu you get the expert options:
	[ ] Sysctl syscall support
	[*] Load all symbols for debugging/ksymoops
	...

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   80 ++++++++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff -puN init/Kconfig~init-kconfig-re-order-config_expert-options-to-fix-menuconfig-display init/Kconfig
--- a/init/Kconfig~init-kconfig-re-order-config_expert-options-to-fix-menuconfig-display
+++ a/init/Kconfig
@@ -1221,6 +1221,35 @@ config SYSCTL
 config ANON_INODES
 	bool
 
+config HAVE_UID16
+	bool
+
+config SYSCTL_EXCEPTION_TRACE
+	bool
+	help
+	  Enable support for /proc/sys/debug/exception-trace.
+
+config SYSCTL_ARCH_UNALIGN_NO_WARN
+	bool
+	help
+	  Enable support for /proc/sys/kernel/ignore-unaligned-usertrap
+	  Allows arch to define/use @no_unaligned_warning to possibly warn
+	  about unaligned access emulation going on under the hood.
+
+config SYSCTL_ARCH_UNALIGN_ALLOW
+	bool
+	help
+	  Enable support for /proc/sys/kernel/unaligned-trap
+	  Allows arches to define/use @unaligned_enabled to runtime toggle
+	  the unaligned access emulation.
+	  see arch/parisc/kernel/unaligned.c for reference
+
+config HOTPLUG
+	def_bool y
+
+config HAVE_PCSPKR_PLATFORM
+	bool
+
 menuconfig EXPERT
 	bool "Configure standard kernel features (expert users)"
 	# Unhide debug options, to make the on-by-default options visible
@@ -1231,9 +1260,6 @@ menuconfig EXPERT
           environments which can tolerate a "non-standard" kernel.
           Only use this if you really know what you are doing.
 
-config HAVE_UID16
-	bool
-
 config UID16
 	bool "Enable 16-bit UID system calls" if EXPERT
 	depends on HAVE_UID16
@@ -1258,26 +1284,6 @@ config SYSCTL_SYSCALL
 
 	  If unsure say N here.
 
-config SYSCTL_EXCEPTION_TRACE
-	bool
-	help
-	  Enable support for /proc/sys/debug/exception-trace.
-
-config SYSCTL_ARCH_UNALIGN_NO_WARN
-	bool
-	help
-	  Enable support for /proc/sys/kernel/ignore-unaligned-usertrap
-	  Allows arch to define/use @no_unaligned_warning to possibly warn
-	  about unaligned access emulation going on under the hood.
-
-config SYSCTL_ARCH_UNALIGN_ALLOW
-	bool
-	help
-	  Enable support for /proc/sys/kernel/unaligned-trap
-	  Allows arches to define/use @unaligned_enabled to runtime toggle
-	  the unaligned access emulation.
-	  see arch/parisc/kernel/unaligned.c for reference
-
 config KALLSYMS
 	 bool "Load all symbols for debugging/ksymoops" if EXPERT
 	 default y
@@ -1303,9 +1309,6 @@ config KALLSYMS_ALL
 
 	   Say N unless you really need all symbols.
 
-config HOTPLUG
-	def_bool y
-
 config PRINTK
 	default y
 	bool "Enable support for printk" if EXPERT
@@ -1344,9 +1347,6 @@ config PCSPKR_PLATFORM
           This option allows to disable the internal PC-Speaker
           support, saving some memory.
 
-config HAVE_PCSPKR_PLATFORM
-	bool
-
 config BASE_FULL
 	default y
 	bool "Enable full-sized data structures for core" if EXPERT
@@ -1418,8 +1418,17 @@ config AIO
 	default y
 	help
 	  This option enables POSIX asynchronous I/O which may by used
-          by some high performance threaded applications. Disabling
-          this option saves about 7k.
+	  by some high performance threaded applications. Disabling
+	  this option saves about 7k.
+
+config PCI_QUIRKS
+	default y
+	bool "Enable PCI quirk workarounds" if EXPERT
+	depends on PCI
+	help
+	  This enables workarounds for various PCI chipset
+	  bugs/quirks. Disable this only if your target machine is
+	  unaffected by PCI quirks.
 
 config EMBEDDED
 	bool "Embedded system"
@@ -1494,15 +1503,6 @@ config VM_EVENT_COUNTERS
 	  on EXPERT systems.  /proc/vmstat will only show page counts
 	  if VM event counters are disabled.
 
-config PCI_QUIRKS
-	default y
-	bool "Enable PCI quirk workarounds" if EXPERT
-	depends on PCI
-	help
-	  This enables workarounds for various PCI chipset
-          bugs/quirks. Disable this only if your target machine is
-          unaffected by PCI quirks.
