From: akpm@osdl.org
Subject: - kconfig-refactoring-for-better-menu-nesting.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:51:25 -0800
Message-ID: <200612130651.kBD6pP7u030347@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57226 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964960AbWLMGvr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:51:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwm@meer.net, rdunlap@xenotime.net, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Kconfig refactoring for better menu nesting
has been removed from the -mm tree.  Its filename was
     kconfig-refactoring-for-better-menu-nesting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Kconfig refactoring for better menu nesting
From: Don Mullis <dwm@meer.net>

Refactor Kconfig content to maximize nesting of menus by menuconfig and
xconfig.

Tested by simultaneously running `make xconfig` with and without
patch, and comparing displays.

Signed-off-by: Don Mullis <dwm@meer.net>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/parport/Kconfig     |    6 +--
 drivers/pci/hotplug/Kconfig |    3 +
 drivers/serial/Kconfig      |   53 ++++++++++++++++------------------
 lib/Kconfig.debug           |   49 ++++++++++++++++---------------
 4 files changed, 56 insertions(+), 55 deletions(-)

diff -puN drivers/parport/Kconfig~kconfig-refactoring-for-better-menu-nesting drivers/parport/Kconfig
--- a/drivers/parport/Kconfig~kconfig-refactoring-for-better-menu-nesting
+++ a/drivers/parport/Kconfig
@@ -82,9 +82,6 @@ config PARPORT_PC_PCMCIA
 	  Say Y here if you need PCMCIA support for your PC-style parallel
 	  ports. If unsure, say N.
 
-config PARPORT_NOT_PC
-	bool
-
 config PARPORT_IP32
 	tristate "SGI IP32 builtin port (EXPERIMENTAL)"
 	depends on SGI_IP32 && PARPORT && EXPERIMENTAL
@@ -158,5 +155,8 @@ config PARPORT_1284
 	  transfer modes. Also say Y if you want device ID information to
 	  appear in /proc/sys/dev/parport/*/autoprobe*. It is safe to say N.
 
+config PARPORT_NOT_PC
+	bool
+
 endmenu
 
diff -puN drivers/pci/hotplug/Kconfig~kconfig-refactoring-for-better-menu-nesting drivers/pci/hotplug/Kconfig
--- a/drivers/pci/hotplug/Kconfig~kconfig-refactoring-for-better-menu-nesting
+++ a/drivers/pci/hotplug/Kconfig
@@ -76,7 +76,8 @@ config HOTPLUG_PCI_IBM
 
 config HOTPLUG_PCI_ACPI
 	tristate "ACPI PCI Hotplug driver"
-	depends on (!ACPI_DOCK && ACPI && HOTPLUG_PCI) || (ACPI_DOCK && HOTPLUG_PCI)
+	depends on HOTPLUG_PCI
+	depends on (!ACPI_DOCK && ACPI) || (ACPI_DOCK)
 	help
 	  Say Y here if you have a system that supports PCI Hotplug using
 	  ACPI.
diff -puN drivers/serial/Kconfig~kconfig-refactoring-for-better-menu-nesting drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~kconfig-refactoring-for-better-menu-nesting
+++ a/drivers/serial/Kconfig
@@ -151,32 +151,6 @@ config SERIAL_8250_MANY_PORTS
 	  say N here to save some memory. You can also say Y if you have an
 	  "intelligent" multiport card such as Cyclades, Digiboards, etc.
 
-config SERIAL_8250_SHARE_IRQ
-	bool "Support for sharing serial interrupts"
-	depends on SERIAL_8250_EXTENDED
-	help
-	  Some serial boards have hardware support which allows multiple dumb
-	  serial ports on the same board to share a single IRQ. To enable
-	  support for this in the serial driver, say Y here.
-
-config SERIAL_8250_DETECT_IRQ
-	bool "Autodetect IRQ on standard ports (unsafe)"
-	depends on SERIAL_8250_EXTENDED
-	help
-	  Say Y here if you want the kernel to try to guess which IRQ
-	  to use for your serial port.
-
-	  This is considered unsafe; it is far better to configure the IRQ in
-	  a boot script using the setserial command.
-
-	  If unsure, say N.
-
-config SERIAL_8250_RSA
-	bool "Support RSA serial ports"
-	depends on SERIAL_8250_EXTENDED
-	help
-	  ::: To be written :::
-
 #
 # Multi-port serial cards
 #
@@ -199,7 +173,6 @@ config SERIAL_8250_ACCENT
 	  To compile this driver as a module, choose M here: the module
 	  will be called 8250_accent.
 
-
 config SERIAL_8250_BOCA
 	tristate "Support Boca cards"
 	depends on SERIAL_8250 != n && ISA && SERIAL_8250_MANY_PORTS
@@ -230,6 +203,32 @@ config SERIAL_8250_HUB6
 	  To compile this driver as a module, choose M here: the module
 	  will be called 8250_hub6.
 
+config SERIAL_8250_SHARE_IRQ
+	bool "Support for sharing serial interrupts"
+	depends on SERIAL_8250_EXTENDED
+	help
+	  Some serial boards have hardware support which allows multiple dumb
+	  serial ports on the same board to share a single IRQ. To enable
+	  support for this in the serial driver, say Y here.
+
+config SERIAL_8250_DETECT_IRQ
+	bool "Autodetect IRQ on standard ports (unsafe)"
+	depends on SERIAL_8250_EXTENDED
+	help
+	  Say Y here if you want the kernel to try to guess which IRQ
+	  to use for your serial port.
+
+	  This is considered unsafe; it is far better to configure the IRQ in
+	  a boot script using the setserial command.
+
+	  If unsure, say N.
+
+config SERIAL_8250_RSA
+	bool "Support RSA serial ports"
+	depends on SERIAL_8250_EXTENDED
+	help
+	  ::: To be written :::
+
 config SERIAL_8250_MCA
 	tristate "Support 8250-type ports on MCA buses"
 	depends on SERIAL_8250 != n && MCA
diff -puN lib/Kconfig.debug~kconfig-refactoring-for-better-menu-nesting lib/Kconfig.debug
--- a/lib/Kconfig.debug~kconfig-refactoring-for-better-menu-nesting
+++ a/lib/Kconfig.debug
@@ -47,6 +47,30 @@ config UNUSED_SYMBOLS
 	  you really need it, and what the merge plan to the mainline kernel for
 	  your module is.
 
+config DEBUG_FS
+	bool "Debug Filesystem"
+	depends on SYSFS
+	help
+	  debugfs is a virtual file system that kernel developers use to put
+	  debugging files into.  Enable this option to be able to read and
+	  write to these files.
+
+	  If unsure, say N.
+
+config HEADERS_CHECK
+	bool "Run 'make headers_check' when building vmlinux"
+	depends on !UML
+	help
+	  This option will extract the user-visible kernel headers whenever
+	  building the kernel, and will run basic sanity checks on them to
+	  ensure that exported files do not attempt to include files which
+	  were not exported, etc.
+
+	  If you're making modifications to header files which are
+	  relevant for userspace, say 'Y', and check the headers
+	  exported to $(INSTALL_HDR_PATH) (usually 'usr/include' in
+	  your build tree), to make sure they're suitable.
+
 config DEBUG_KERNEL
 	bool "Kernel debugging"
 	help
@@ -302,16 +326,6 @@ config DEBUG_INFO
 
 	  If unsure, say N.
 
-config DEBUG_FS
-	bool "Debug Filesystem"
-	depends on SYSFS
-	help
-	  debugfs is a virtual file system that kernel developers use to put
-	  debugging files into.  Enable this option to be able to read and
-	  write to these files.
-
-	  If unsure, say N.
-
 config DEBUG_VM
 	bool "Debug VM"
 	depends on DEBUG_KERNEL
@@ -372,20 +386,6 @@ config FORCED_INLINING
 	  become the default in the future, until then this option is there to
 	  test gcc for this.
 
-config HEADERS_CHECK
-	bool "Run 'make headers_check' when building vmlinux"
-	depends on !UML
-	help
-	  This option will extract the user-visible kernel headers whenever
-	  building the kernel, and will run basic sanity checks on them to
-	  ensure that exported files do not attempt to include files which
-	  were not exported, etc.
-
-	  If you're making modifications to header files which are
-	  relevant for userspace, say 'Y', and check the headers
-	  exported to $(INSTALL_HDR_PATH) (usually 'usr/include' in
-	  your build tree), to make sure they're suitable.
-
 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL
@@ -402,6 +402,7 @@ config RCU_TORTURE_TEST
 
 config LKDTM
 	tristate "Linux Kernel Dump Test Tool Module"
+	depends on DEBUG_KERNEL
 	depends on KPROBES
 	default n
 	help
_

Patches currently in -mm which might be from dwm@meer.net are

origin.patch

