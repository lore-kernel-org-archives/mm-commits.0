From: akpm@linux-foundation.org
Subject: - aout-mark-arches-that-support-aout-format.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:14:55 -0800
Message-ID: <200802082014.m18KEaEc010466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39238 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753102AbYBHUxA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:53:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, linux-arch@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     aout: mark arches that support A.OUT format
has been removed from the -mm tree.  Its filename was
     aout-mark-arches-that-support-aout-format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aout: mark arches that support A.OUT format
From: David Howells <dhowells@redhat.com>

Mark arches that support A.OUT format by including the following in their
master Kconfig files:

	config ARCH_SUPPORTS_AOUT
		def_bool y

This should also be set if the arch provides compatibility A.OUT support for
an older arch, for instance x86_64 for i386 or sparc64 for sparc.

I've guessed at which arches don't, based on comments in the code, however I'm
sure that some of the ones I've marked as 'yes' actually should be 'no'.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig     |    3 +++
 arch/arm/Kconfig       |    3 +++
 arch/h8300/Kconfig     |    3 +++
 arch/m32r/Kconfig      |    3 +++
 arch/m68k/Kconfig      |    3 +++
 arch/m68knommu/Kconfig |    3 +++
 arch/parisc/Kconfig    |    3 +++
 arch/sh/Kconfig        |    3 +++
 arch/sparc/Kconfig     |    3 +++
 arch/sparc64/Kconfig   |    5 ++++-
 arch/um/Kconfig.i386   |    2 ++
 arch/um/Kconfig.x86_64 |    2 ++
 arch/v850/Kconfig      |    3 +++
 arch/x86/Kconfig       |    5 ++++-
 14 files changed, 42 insertions(+), 2 deletions(-)

diff -puN arch/alpha/Kconfig~aout-mark-arches-that-support-aout-format arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/alpha/Kconfig
@@ -67,6 +67,9 @@ config AUTO_IRQ_AFFINITY
 	depends on SMP
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 source "init/Kconfig"
 
 
diff -puN arch/arm/Kconfig~aout-mark-arches-that-support-aout-format arch/arm/Kconfig
--- a/arch/arm/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/arm/Kconfig
@@ -126,6 +126,9 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 config ARCH_MAY_HAVE_PC_FDC
 	bool
 
diff -puN arch/h8300/Kconfig~aout-mark-arches-that-support-aout-format arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/h8300/Kconfig
@@ -65,6 +65,9 @@ config TIME_LOW_RES
 	bool
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 config NO_IOPORT
 	def_bool y
 
diff -puN arch/m32r/Kconfig~aout-mark-arches-that-support-aout-format arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/m32r/Kconfig
@@ -35,6 +35,9 @@ config NO_IOPORT
 config NO_DMA
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 source "init/Kconfig"
 
 
diff -puN arch/m68k/Kconfig~aout-mark-arches-that-support-aout-format arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/m68k/Kconfig
@@ -52,6 +52,9 @@ config NO_IOPORT
 config NO_DMA
 	def_bool SUN3
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 mainmenu "Linux/68k Kernel Configuration"
 
 source "init/Kconfig"
diff -puN arch/m68knommu/Kconfig~aout-mark-arches-that-support-aout-format arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/m68knommu/Kconfig
@@ -64,6 +64,9 @@ config TIME_LOW_RES
 config NO_IOPORT
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 source "init/Kconfig"
 
 menu "Processor type and features"
diff -puN arch/parisc/Kconfig~aout-mark-arches-that-support-aout-format arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/parisc/Kconfig
@@ -75,6 +75,9 @@ config IRQ_PER_CPU
 	bool
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 # unless you want to implement ACPI on PA-RISC ... ;-)
 config PM
 	bool
diff -puN arch/sh/Kconfig~aout-mark-arches-that-support-aout-format arch/sh/Kconfig
--- a/arch/sh/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/sh/Kconfig
@@ -89,6 +89,9 @@ config ARCH_HAS_ILOG2_U64
 config ARCH_NO_VIRT_TO_BUS
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 source "init/Kconfig"
 
 menu "System type"
diff -puN arch/sparc/Kconfig~aout-mark-arches-that-support-aout-format arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/sparc/Kconfig
@@ -27,6 +27,9 @@ config ARCH_NO_VIRT_TO_BUS
 config OF
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 source "init/Kconfig"
 
 menu "General machine setup"
diff -puN arch/sparc64/Kconfig~aout-mark-arches-that-support-aout-format arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/sparc64/Kconfig
@@ -81,6 +81,9 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 	bool
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 choice
 	prompt "Kernel page size"
 	default SPARC64_PAGE_SIZE_8KB
@@ -390,7 +393,7 @@ config BINFMT_ELF32
 
 config BINFMT_AOUT32
 	bool "Kernel support for 32-bit (ie. SunOS) a.out binaries"
-	depends on SPARC32_COMPAT
+	depends on SPARC32_COMPAT && ARCH_SUPPORTS_AOUT
 	help
 	  This allows you to run 32-bit a.out format binaries on your Ultra.
 	  If you want to run SunOS binaries (see SunOS binary emulation below)
diff -puN arch/um/Kconfig.i386~aout-mark-arches-that-support-aout-format arch/um/Kconfig.i386
--- a/arch/um/Kconfig.i386~aout-mark-arches-that-support-aout-format
+++ a/arch/um/Kconfig.i386
@@ -84,3 +84,5 @@ config GENERIC_HWEIGHT
 	bool
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
diff -puN arch/um/Kconfig.x86_64~aout-mark-arches-that-support-aout-format arch/um/Kconfig.x86_64
--- a/arch/um/Kconfig.x86_64~aout-mark-arches-that-support-aout-format
+++ a/arch/um/Kconfig.x86_64
@@ -39,3 +39,5 @@ config GENERIC_HWEIGHT
 	bool
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
diff -puN arch/v850/Kconfig~aout-mark-arches-that-support-aout-format arch/v850/Kconfig
--- a/arch/v850/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/v850/Kconfig
@@ -53,6 +53,9 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 # Turn off some random 386 crap that can affect device config
 config ISA
 	bool
diff -puN arch/x86/Kconfig~aout-mark-arches-that-support-aout-format arch/x86/Kconfig
--- a/arch/x86/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/x86/Kconfig
@@ -136,6 +136,9 @@ config AUDIT_ARCH
 	bool
 	default X86_64
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 # Use the generic interrupt handling code in kernel/irq/:
 config GENERIC_HARDIRQS
 	bool
@@ -1577,7 +1580,7 @@ config IA32_EMULATION
 
 config IA32_AOUT
        tristate "IA32 a.out support"
-       depends on IA32_EMULATION
+       depends on IA32_EMULATION && ARCH_SUPPORTS_AOUT
        help
          Support old a.out binaries in the 32bit emulation.
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
mutex-subsystem-synchro-test-module.patch
