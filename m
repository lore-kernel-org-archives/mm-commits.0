From: akpm@linux-foundation.org
Subject: - aout-mark-arches-that-support-aout-format.patch removed from -mm tree
Date: Tue, 20 Nov 2007 12:51:13 -0800
Message-ID: <200711202051.lAKKpDoC022806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53914 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763910AbXKTUvl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 15:51:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, linux-arch@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     AOUT: Mark arches that support A.OUT format
has been removed from the -mm tree.  Its filename was
     aout-mark-arches-that-support-aout-format.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: AOUT: Mark arches that support A.OUT format
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
 arch/avr32/Kconfig     |    3 +++
 arch/blackfin/Kconfig  |    3 +++
 arch/cris/Kconfig      |    3 +++
 arch/frv/Kconfig       |    3 +++
 arch/h8300/Kconfig     |    3 +++
 arch/ia64/Kconfig      |    3 +++
 arch/m32r/Kconfig      |    3 +++
 arch/m68k/Kconfig      |    3 +++
 arch/m68knommu/Kconfig |    3 +++
 arch/mips/Kconfig      |    3 +++
 arch/parisc/Kconfig    |    3 +++
 arch/powerpc/Kconfig   |    3 +++
 arch/ppc/Kconfig       |    3 +++
 arch/s390/Kconfig      |    3 +++
 arch/sh/Kconfig        |    3 +++
 arch/sh64/Kconfig      |    3 +++
 arch/sparc/Kconfig     |    3 +++
 arch/sparc64/Kconfig   |    3 +++
 arch/um/Kconfig.i386   |    2 ++
 arch/um/Kconfig.x86_64 |    2 ++
 arch/v850/Kconfig      |    3 +++
 arch/xtensa/Kconfig    |    3 +++
 24 files changed, 70 insertions(+)

diff -puN arch/alpha/Kconfig~aout-mark-arches-that-support-aout-format arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/alpha/Kconfig
@@ -66,6 +66,9 @@ config AUTO_IRQ_AFFINITY
 	depends on SMP
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 source "init/Kconfig"
 
 
diff -puN arch/arm/Kconfig~aout-mark-arches-that-support-aout-format arch/arm/Kconfig
--- a/arch/arm/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/arm/Kconfig
@@ -114,6 +114,9 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 config ARCH_MAY_HAVE_PC_FDC
 	bool
 
diff -puN arch/avr32/Kconfig~aout-mark-arches-that-support-aout-format arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/avr32/Kconfig
@@ -67,6 +67,9 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 source "init/Kconfig"
 
 menu "System Type and features"
diff -puN arch/blackfin/Kconfig~aout-mark-arches-that-support-aout-format arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/blackfin/Kconfig
@@ -69,6 +69,9 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool n
+
 config IRQCHIP_DEMUX_GPIO
 	bool
 	depends on (BF52x || BF53x || BF561 || BF54x)
diff -puN arch/cris/Kconfig~aout-mark-arches-that-support-aout-format arch/cris/Kconfig
--- a/arch/cris/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/cris/Kconfig
@@ -51,6 +51,9 @@ config IRQ_PER_CPU
 config NO_IOPORT
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool n
+
 config CRIS
 	bool
 	default y
diff -puN arch/frv/Kconfig~aout-mark-arches-that-support-aout-format arch/frv/Kconfig
--- a/arch/frv/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/frv/Kconfig
@@ -57,6 +57,9 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool n
+
 mainmenu "Fujitsu FR-V Kernel Configuration"
 
 source "init/Kconfig"
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
 
diff -puN arch/ia64/Kconfig~aout-mark-arches-that-support-aout-format arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/ia64/Kconfig
@@ -99,6 +99,9 @@ config AUDIT_ARCH
 	bool
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool n
+
 choice
 	prompt "System type"
 	default IA64_GENERIC
diff -puN arch/m32r/Kconfig~aout-mark-arches-that-support-aout-format arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/m32r/Kconfig
@@ -34,6 +34,9 @@ config NO_IOPORT
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
@@ -60,6 +60,9 @@ config TIME_LOW_RES
 config NO_IOPORT
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 source "init/Kconfig"
 
 menu "Processor type and features"
diff -puN arch/mips/Kconfig~aout-mark-arches-that-support-aout-format arch/mips/Kconfig
--- a/arch/mips/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/mips/Kconfig
@@ -722,6 +722,9 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 	bool
 	default n
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 #
 # Select some configuration options automatically based on user selections.
 #
diff -puN arch/parisc/Kconfig~aout-mark-arches-that-support-aout-format arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/parisc/Kconfig
@@ -69,6 +69,9 @@ config IRQ_PER_CPU
 	bool
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 # unless you want to implement ACPI on PA-RISC ... ;-)
 config PM
 	bool
diff -puN arch/powerpc/Kconfig~aout-mark-arches-that-support-aout-format arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/powerpc/Kconfig
@@ -76,6 +76,9 @@ config GENERIC_FIND_NEXT_BIT
 config ARCH_NO_VIRT_TO_BUS
 	def_bool PPC64
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 config PPC
 	bool
 	default y
diff -puN arch/ppc/Kconfig~aout-mark-arches-that-support-aout-format arch/ppc/Kconfig
--- a/arch/ppc/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/ppc/Kconfig
@@ -39,6 +39,9 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool n
+
 config PPC
 	bool
 	default y
diff -puN arch/s390/Kconfig~aout-mark-arches-that-support-aout-format arch/s390/Kconfig
--- a/arch/s390/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/s390/Kconfig
@@ -47,6 +47,9 @@ config NO_IOMEM
 config NO_DMA
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool n
+
 mainmenu "Linux Kernel Configuration"
 
 config S390
diff -puN arch/sh/Kconfig~aout-mark-arches-that-support-aout-format arch/sh/Kconfig
--- a/arch/sh/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/sh/Kconfig
@@ -93,6 +93,9 @@ config ARCH_HAS_ILOG2_U64
 config ARCH_NO_VIRT_TO_BUS
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 source "init/Kconfig"
 
 menu "System type"
diff -puN arch/sh64/Kconfig~aout-mark-arches-that-support-aout-format arch/sh64/Kconfig
--- a/arch/sh64/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/sh64/Kconfig
@@ -58,6 +58,9 @@ config ARCH_HAS_ILOG2_U64
 config ARCH_NO_VIRT_TO_BUS
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 source init/Kconfig
 
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
@@ -76,6 +76,9 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 	bool
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 choice
 	prompt "Kernel page size"
 	default SPARC64_PAGE_SIZE_8KB
diff -puN arch/um/Kconfig.i386~aout-mark-arches-that-support-aout-format arch/um/Kconfig.i386
--- a/arch/um/Kconfig.i386~aout-mark-arches-that-support-aout-format
+++ a/arch/um/Kconfig.i386
@@ -77,3 +77,5 @@ config GENERIC_HWEIGHT
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
diff -puN arch/xtensa/Kconfig~aout-mark-arches-that-support-aout-format arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~aout-mark-arches-that-support-aout-format
+++ a/arch/xtensa/Kconfig
@@ -49,6 +49,9 @@ config ARCH_HAS_ILOG2_U64
 config NO_IOPORT
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool n
+
 source "init/Kconfig"
 
 menu "Processor type and features"
_

Patches currently in -mm which might be from dhowells@redhat.com are

git-mtd.patch
frv-fix-the-extern-declaration-of-kallsyms_num_syms.patch
frv-arrange-things-such-that-bra-can-reach-from-the-trap.patch
frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
frv-remove-dead-config-symbol-from-frv-code.patch
aout-mark-arches-that-support-aout-format.patch
aout-mark-arches-that-support-aout-format-fix.patch
aout-mark-arches-that-support-aout-format-fix-2.patch
aout-mark-arches-that-support-aout-format-fix-3.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
64-bit-i_version-afs-fixes.patch
add-an-err_cast-function-to-complement-err_ptr-and-co.patch
convert-err_ptrptr_errp-instances-to-err_castp.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-fix.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
unexport-asm-pageh.patch
add-cmpxchg_local-to-frv.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
tty-let-architectures-override-the-user-kernel-macros.patch
mutex-subsystem-synchro-test-module.patch
