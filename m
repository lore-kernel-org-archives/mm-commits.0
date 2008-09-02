From: akpm@linux-foundation.org
Subject: + kconfig-eliminate-def_bool-n-constructs.patch added to -mm tree
Date: Tue, 02 Sep 2008 15:00:46 -0700
Message-ID: <200809022200.m82M0kGd014968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181AbYIBWBo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 18:01:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, bzolnier@gmail.com, mingo@elte.hu, sam@ravnborg.org, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     Kconfig: eliminate "def_bool n" constructs
has been added to the -mm tree.  Its filename is
     kconfig-eliminate-def_bool-n-constructs.patch

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
Subject: Kconfig: eliminate "def_bool n" constructs
From: "Jan Beulich" <jbeulich@novell.com>

Using "def_bool n" is pointless, simply using bool here appears more
appropriate.

Further, retaining such options that don't have a prompt and aren't
selected by anything seems also at least questionable.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig        |   18 +++++++++---------
 arch/ia64/Kconfig   |    8 --------
 arch/x86/Kconfig    |   23 +++++------------------
 drivers/ide/Kconfig |    2 +-
 kernel/time/Kconfig |    1 -
 lib/Kconfig         |    4 ++--
 mm/Kconfig          |    4 ++--
 7 files changed, 19 insertions(+), 41 deletions(-)

diff -puN arch/Kconfig~kconfig-eliminate-def_bool-n-constructs arch/Kconfig
--- a/arch/Kconfig~kconfig-eliminate-def_bool-n-constructs
+++ a/arch/Kconfig
@@ -28,7 +28,7 @@ config OPROFILE_IBS
 	  If unsure, say N.
 
 config HAVE_OPROFILE
-	def_bool n
+	bool
 
 config KPROBES
 	bool "Kprobes"
@@ -42,7 +42,7 @@ config KPROBES
 	  If in doubt, say "N".
 
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
-	def_bool n
+	bool
 	help
 	  Some architectures are unable to perform unaligned accesses
 	  without the use of get_unaligned/put_unaligned. Others are
@@ -65,13 +65,13 @@ config KRETPROBES
 	depends on KPROBES && HAVE_KRETPROBES
 
 config HAVE_IOREMAP_PROT
-	def_bool n
+	bool
 
 config HAVE_KPROBES
-	def_bool n
+	bool
 
 config HAVE_KRETPROBES
-	def_bool n
+	bool
 
 #
 # An arch should select this if it provides all these things:
@@ -89,16 +89,16 @@ config HAVE_KRETPROBES
 #	signal delivery		calls tracehook_signal_handler()
 #
 config HAVE_ARCH_TRACEHOOK
-	def_bool n
+	bool
 
 config HAVE_DMA_ATTRS
-	def_bool n
+	bool
 
 config USE_GENERIC_SMP_HELPERS
-	def_bool n
+	bool
 
 config HAVE_CLK
-	def_bool n
+	bool
 	help
 	  The <linux/clk.h> calls support software clock gating and
 	  thus are a key power management tool on many systems.
diff -puN arch/ia64/Kconfig~kconfig-eliminate-def_bool-n-constructs arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~kconfig-eliminate-def_bool-n-constructs
+++ a/arch/ia64/Kconfig
@@ -62,14 +62,6 @@ config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default y
 
-config ARCH_HAS_ILOG2_U32
-	bool
-	default n
-
-config ARCH_HAS_ILOG2_U64
-	bool
-	default n
-
 config HUGETLB_PAGE_SIZE_VARIABLE
 	bool
 	depends on HUGETLB_PAGE
diff -puN arch/x86/Kconfig~kconfig-eliminate-def_bool-n-constructs arch/x86/Kconfig
--- a/arch/x86/Kconfig~kconfig-eliminate-def_bool-n-constructs
+++ a/arch/x86/Kconfig
@@ -41,10 +41,6 @@ config ARCH_DEFCONFIG
 	default "arch/x86/configs/i386_defconfig" if X86_32
 	default "arch/x86/configs/x86_64_defconfig" if X86_64
 
-
-config GENERIC_LOCKBREAK
-	def_bool n
-
 config GENERIC_TIME
 	def_bool y
 
@@ -97,7 +93,7 @@ config GENERIC_HWEIGHT
 	def_bool y
 
 config GENERIC_GPIO
-	def_bool n
+	bool
 
 config ARCH_MAY_HAVE_PC_FDC
 	def_bool y
@@ -108,12 +104,6 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool X86_XADD
 
-config ARCH_HAS_ILOG2_U32
-	def_bool n
-
-config ARCH_HAS_ILOG2_U64
-	def_bool n
-
 config ARCH_HAS_CPU_IDLE_WAIT
 	def_bool y
 
@@ -774,9 +764,8 @@ config I8K
 	  Say N otherwise.
 
 config X86_REBOOTFIXUPS
-	def_bool n
-	prompt "Enable X86 board specific fixups for reboot"
-	depends on X86_32 && X86
+	bool "Enable X86 board specific fixups for reboot"
+	depends on X86_32
 	---help---
 	  This enables chipset and/or board specific fixups to be done
 	  in order to get reboot to work correctly. This is only needed on
@@ -966,8 +955,7 @@ config HIGHMEM
 	depends on X86_32 && (HIGHMEM64G || HIGHMEM4G)
 
 config X86_PAE
-	def_bool n
-	prompt "PAE (Physical Address Extension) Support"
+	bool "PAE (Physical Address Extension) Support"
 	depends on X86_32 && !HIGHMEM4G
 	help
 	  PAE is required for NX support, and furthermore enables
@@ -1217,8 +1205,7 @@ config X86_PAT
 	  If unsure, say Y.
 
 config EFI
-	def_bool n
-	prompt "EFI runtime service support"
+	bool "EFI runtime service support"
 	depends on ACPI
 	---help---
 	This enables the kernel to use EFI runtime services that are
diff -puN drivers/ide/Kconfig~kconfig-eliminate-def_bool-n-constructs drivers/ide/Kconfig
--- a/drivers/ide/Kconfig~kconfig-eliminate-def_bool-n-constructs
+++ a/drivers/ide/Kconfig
@@ -4,7 +4,7 @@
 
 # Select HAVE_IDE if IDE is supported
 config HAVE_IDE
-	def_bool n
+	bool
 
 menuconfig IDE
 	tristate "ATA/ATAPI/MFM/RLL support"
diff -puN kernel/time/Kconfig~kconfig-eliminate-def_bool-n-constructs kernel/time/Kconfig
--- a/kernel/time/Kconfig~kconfig-eliminate-def_bool-n-constructs
+++ a/kernel/time/Kconfig
@@ -3,7 +3,6 @@
 #
 config TICK_ONESHOT
 	bool
-	default n
 
 config NO_HZ
 	bool "Tickless System (Dynamic Ticks)"
diff -puN lib/Kconfig~kconfig-eliminate-def_bool-n-constructs lib/Kconfig
--- a/lib/Kconfig~kconfig-eliminate-def_bool-n-constructs
+++ a/lib/Kconfig
@@ -8,10 +8,10 @@ config BITREVERSE
 	tristate
 
 config GENERIC_FIND_FIRST_BIT
-	def_bool n
+	bool
 
 config GENERIC_FIND_NEXT_BIT
-	def_bool n
+	bool
 
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
diff -puN mm/Kconfig~kconfig-eliminate-def_bool-n-constructs mm/Kconfig
--- a/mm/Kconfig~kconfig-eliminate-def_bool-n-constructs
+++ a/mm/Kconfig
@@ -101,7 +101,7 @@ config HAVE_MEMORY_PRESENT
 # with gcc 3.4 and later.
 #
 config SPARSEMEM_STATIC
-	def_bool n
+	bool
 
 #
 # Architecture platforms which require a two level mem_section in SPARSEMEM
@@ -113,7 +113,7 @@ config SPARSEMEM_EXTREME
 	depends on SPARSEMEM && !SPARSEMEM_STATIC
 
 config SPARSEMEM_VMEMMAP_ENABLE
-	def_bool n
+	bool
 
 config SPARSEMEM_VMEMMAP
 	bool "Sparse Memory virtual memmap"
_

Patches currently in -mm which might be from jbeulich@novell.com are

linux-next.patch
adjust-init-section-definitions.patch
kconfig-eliminate-def_bool-n-constructs.patch

