From: akpm@linux-foundation.org
Subject: + container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig.patch added to -mm tree
Date: Fri, 22 Aug 2008 13:37:42 -0700
Message-ID: <200808222037.m7MKbgaH015373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751068AbYHVUor (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 16:44:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthltc@us.ibm.com, clg@fr.ibm.com, pavel@suse.cz, rjw@sisk.pl, serue@us.ibm.com


The patch titled
     container freezer: fix freezer Kconfig
has been added to the -mm tree.  Its filename is
     container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig.patch

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
Subject: container freezer: fix freezer Kconfig
From: Matt Helsley <matthltc@us.ibm.com>

kernel/power/Kconfig is not sourced from all architectures but the freezer
code should be available to all architectures for the cgroup freezer
subsystem.  Sourcing a new kernel/Kconfig.freezer has the added advantage
of keeping the config definition close to its use in the kernel/Makefile.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@suse.cz>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig     |    1 +
 arch/arm/Kconfig       |    2 ++
 arch/avr32/Kconfig     |    2 ++
 arch/blackfin/Kconfig  |    3 +++
 arch/cris/Kconfig      |    2 ++
 arch/frv/Kconfig       |    2 ++
 arch/h8300/Kconfig     |    2 ++
 arch/ia64/Kconfig      |    2 ++
 arch/m32r/Kconfig      |    2 ++
 arch/m68k/Kconfig      |    2 ++
 arch/m68knommu/Kconfig |    2 ++
 arch/mips/Kconfig      |    2 ++
 arch/mn10300/Kconfig   |    2 ++
 arch/parisc/Kconfig    |    2 ++
 arch/powerpc/Kconfig   |    2 ++
 arch/s390/Kconfig      |    2 ++
 arch/sh/Kconfig        |    2 ++
 arch/sparc/Kconfig     |    2 ++
 arch/sparc64/Kconfig   |    1 +
 arch/um/Kconfig        |    2 ++
 arch/x86/Kconfig       |    1 +
 arch/xtensa/Kconfig    |    1 +
 kernel/Kconfig.freezer |    2 ++
 kernel/power/Kconfig   |    3 ---
 24 files changed, 43 insertions(+), 3 deletions(-)

diff -puN arch/alpha/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/alpha/Kconfig
@@ -72,6 +72,7 @@ config ARCH_SUPPORTS_AOUT
 	def_bool y
 
 source "init/Kconfig"
+source "kernel/Kconfig.freezer"
 
 
 menu "System setup"
diff -puN arch/arm/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/arm/Kconfig
--- a/arch/arm/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/arm/Kconfig
@@ -195,6 +195,8 @@ config VECTORS_BASE
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "System Type"
 
 choice
diff -puN arch/avr32/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/avr32/Kconfig
@@ -72,6 +72,8 @@ config GENERIC_BUG
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "System Type and features"
 
 source "kernel/time/Kconfig"
diff -puN arch/blackfin/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/blackfin/Kconfig
@@ -64,8 +64,11 @@ config HARDWARE_PM
 	depends on OPROFILE
 
 source "init/Kconfig"
+
 source "kernel/Kconfig.preempt"
 
+source "kernel/Kconfig.freezer"
+
 menu "Blackfin Processor Options"
 
 comment "Processor and Board Settings"
diff -puN arch/cris/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/cris/Kconfig
--- a/arch/cris/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/cris/Kconfig
@@ -62,6 +62,8 @@ config HZ
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "General setup"
 
 source "fs/Kconfig.binfmt"
diff -puN arch/frv/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/frv/Kconfig
--- a/arch/frv/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/frv/Kconfig
@@ -66,6 +66,8 @@ mainmenu "Fujitsu FR-V Kernel Configurat
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 
 menu "Fujitsu FR-V system setup"
 
diff -puN arch/h8300/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/h8300/Kconfig
@@ -93,6 +93,8 @@ config HZ
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 source "arch/h8300/Kconfig.cpu"
 
 menu "Executable file formats"
diff -puN arch/ia64/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/ia64/Kconfig
@@ -7,6 +7,8 @@ mainmenu "IA-64 Linux Kernel Configurati
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "Processor type and features"
 
 config IA64
diff -puN arch/m32r/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/m32r/Kconfig
@@ -45,6 +45,8 @@ config HZ
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 
 menu "Processor type and features"
 
diff -puN arch/m68k/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/m68k/Kconfig
@@ -64,6 +64,8 @@ mainmenu "Linux/68k Kernel Configuration
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "Platform dependent setup"
 
 config EISA
diff -puN arch/m68knommu/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/m68knommu/Kconfig
@@ -78,6 +78,8 @@ config ARCH_SUPPORTS_AOUT
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "Processor type and features"
 
 choice
diff -puN arch/mips/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/mips/Kconfig
--- a/arch/mips/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/mips/Kconfig
@@ -1886,6 +1886,8 @@ config STACKTRACE_SUPPORT
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "Bus options (PCI, PCMCIA, EISA, ISA, TC)"
 
 config HW_HAS_EISA
diff -puN arch/mn10300/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/mn10300/Kconfig
--- a/arch/mn10300/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/mn10300/Kconfig
@@ -71,6 +71,8 @@ mainmenu "Matsushita MN10300/AM33 Kernel
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 
 menu "Matsushita MN10300 system setup"
 
diff -puN arch/parisc/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/parisc/Kconfig
@@ -93,6 +93,8 @@ config ARCH_MAY_HAVE_PC_FDC
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 
 menu "Processor type and features"
 
diff -puN arch/powerpc/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/powerpc/Kconfig
@@ -230,6 +230,8 @@ config PPC_OF_PLATFORM_PCI
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 source "arch/powerpc/sysdev/Kconfig"
 source "arch/powerpc/platforms/Kconfig"
 
diff -puN arch/s390/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/s390/Kconfig
--- a/arch/s390/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/s390/Kconfig
@@ -77,6 +77,8 @@ config S390
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "Base setup"
 
 comment "Processor type and features"
diff -puN arch/sh/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/sh/Kconfig
--- a/arch/sh/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/sh/Kconfig
@@ -106,6 +106,8 @@ config IO_TRAPPED
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "System type"
 
 #
diff -puN arch/sparc/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/sparc/Kconfig
@@ -32,6 +32,8 @@ config HZ
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "General machine setup"
 
 config SMP
diff -puN arch/sparc64/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/sparc64/Kconfig
@@ -84,6 +84,7 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 	def_bool y
 
 source "init/Kconfig"
+source "kernel/Kconfig.freezer"
 
 menu "Processor type and features"
 
diff -puN arch/um/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/um/Kconfig
--- a/arch/um/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/um/Kconfig
@@ -229,6 +229,8 @@ endmenu
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 source "drivers/block/Kconfig"
 
 source "arch/um/Kconfig.char"
diff -puN arch/x86/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/x86/Kconfig
--- a/arch/x86/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/x86/Kconfig
@@ -206,6 +206,7 @@ config X86_TRAMPOLINE
 config KTIME_SCALAR
 	def_bool X86_32
 source "init/Kconfig"
+source "kernel/Kconfig.freezer"
 
 menu "Processor type and features"
 
diff -puN arch/xtensa/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/arch/xtensa/Kconfig
@@ -55,6 +55,7 @@ config HZ
 	default 100
 
 source "init/Kconfig"
+source "kernel/Kconfig.freezer"
 
 menu "Processor type and features"
 
diff -puN /dev/null kernel/Kconfig.freezer
--- /dev/null
+++ a/kernel/Kconfig.freezer
@@ -0,0 +1,2 @@
+config FREEZER
+	def_bool PM_SLEEP || CGROUP_FREEZER
diff -puN kernel/power/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig kernel/power/Kconfig
--- a/kernel/power/Kconfig~container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig
+++ a/kernel/power/Kconfig
@@ -85,9 +85,6 @@ config PM_SLEEP
 	depends on SUSPEND || HIBERNATION || XEN_SAVE_RESTORE
 	default y
 
-config FREEZER
-	def_bool PM_SLEEP || CGROUP_FREEZER
