From: akpm@linux-foundation.org
Subject: + init-kconfig-re-order-config_expert-options-to-fix-menuconfig-display.patch added to -mm tree
Date: Wed, 24 Apr 2013 13:06:29 -0700
Message-ID: <20130424200629.DE3F35A415F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:34857 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615Ab3DXUGb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Apr 2013 16:06:31 -0400
Received: by mail-qe0-f74.google.com with SMTP id 6so7792qeb.5
        for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2013 13:06:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, jovi.zhangwei@huawei.com, mmarek@suse.cz, rdunlap@infradead.org


The patch titled
     Subject: init/Kconfig: re-order CONFIG_EXPERT options to fix menuconfig display
has been added to the -mm tree.  Its filename is
     init-kconfig-re-order-config_expert-options-to-fix-menuconfig-display.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1238,6 +1238,35 @@ config SYSCTL
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
@@ -1248,9 +1277,6 @@ menuconfig EXPERT
           environments which can tolerate a "non-standard" kernel.
           Only use this if you really know what you are doing.
 
-config HAVE_UID16
-	bool
-
 config UID16
 	bool "Enable 16-bit UID system calls" if EXPERT
 	depends on HAVE_UID16
@@ -1275,26 +1301,6 @@ config SYSCTL_SYSCALL
 
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
@@ -1320,9 +1326,6 @@ config KALLSYMS_ALL
 
 	   Say N unless you really need all symbols.
 
-config HOTPLUG
-	def_bool y
-
 config PRINTK
 	default y
 	bool "Enable support for printk" if EXPERT
@@ -1361,9 +1364,6 @@ config PCSPKR_PLATFORM
           This option allows to disable the internal PC-Speaker
           support, saving some memory.
 
-config HAVE_PCSPKR_PLATFORM
-	bool
-
 config BASE_FULL
 	default y
 	bool "Enable full-sized data structures for core" if EXPERT
@@ -1435,8 +1435,17 @@ config AIO
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
@@ -1511,15 +1520,6 @@ config VM_EVENT_COUNTERS
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
