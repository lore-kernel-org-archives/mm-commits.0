From: akpm@linux-foundation.org
Subject: + lib-move-generic_iomap-to-lib-kconfig.patch added to -mm tree
Date: Mon, 28 Nov 2011 16:08:05 -0800
Message-ID: <201111290008.pAT086KH028899@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40051 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab1K2AIo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 19:08:44 -0500
Received: by eeuu44 with SMTP id u44so50397eeu.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 16:08:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mst@redhat.com, arend@broadcom.com, arnd@arndb.de, benh@kernel.crashing.org, davem@davemloft.net, deller@gmx.de, fabio.baltieri@gmail.com, fenghua.yu@intel.com, frankyl@broadcom.com, galak@kernel.crashing.org, geert@linux-m68k.org, gxt@mprc.pku.edu.cn, hpa@zytor.com, ink@jurassic.park.msu.ru, jbarnes@virtuousgeek.org, jejb@parisc-linux.org, jesper.nilsson@axis.com, jonas@southpole.se, kyle@mcmartin.ca, lasse.collin@tukaani.org, lennox.wu@gmail.com, lethal@linux-sh.org, linux@arm.linux.org.uk, linville@tuxdriver.com, liqin.chen@sunplusct.com, lucas.demarchi@profusion.mobi, mattst88@gmail.com, michael@ellerman.id.au, mingo@redhat.com, monstr@monstr.eu, nicolas.pitre@linaro.org, olof@lixom.net, paul.gortmaker@windriver.com, paulus@samba.org, pebolle@tiscali.nl, ralf@linux-mips.org, rkuo@codeaurora.org, rob.herring@calxeda.com, rth@twiddle.net, sfr@canb.auug.org.au, starvi


The patch titled
     Subject: lib: move GENERIC_IOMAP to lib/Kconfig
has been added to the -mm tree.  Its filename is
     lib-move-generic_iomap-to-lib-kconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: lib: move GENERIC_IOMAP to lib/Kconfig

Define GENERIC_IOMAP in a central location instead of all architectures. 
This will be helpful for the follow-up patch which makes it select other
configs.  Code is also a bit shorter this way.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: Olof Johansson <olof@lixom.net>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Lasse Collin <lasse.collin@tukaani.org>
Cc: Arend van Spriel <arend@broadcom.com>
Cc: Franky Lin <frankyl@broadcom.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig             |    4 ----
 arch/cris/Kconfig              |    5 +----
 arch/hexagon/Kconfig           |    4 +---
 arch/ia64/Kconfig              |    5 +----
 arch/m68k/Kconfig              |    4 +---
 arch/openrisc/Kconfig          |    3 ---
 arch/powerpc/platforms/Kconfig |    3 ---
 arch/score/Kconfig             |    4 +---
 arch/sh/Kconfig                |    3 ---
 arch/unicore32/Kconfig         |    4 +---
 arch/x86/Kconfig               |    4 +---
 lib/Kconfig                    |    3 +++
 12 files changed, 10 insertions(+), 36 deletions(-)

diff -puN arch/alpha/Kconfig~lib-move-generic_iomap-to-lib-kconfig arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~lib-move-generic_iomap-to-lib-kconfig
+++ a/arch/alpha/Kconfig
@@ -70,10 +70,6 @@ config GENERIC_ISA_DMA
 	bool
 	default y
 
-config GENERIC_IOMAP
-	bool
-	default n
-
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
diff -puN arch/cris/Kconfig~lib-move-generic_iomap-to-lib-kconfig arch/cris/Kconfig
--- a/arch/cris/Kconfig~lib-move-generic_iomap-to-lib-kconfig
+++ a/arch/cris/Kconfig
@@ -19,10 +19,6 @@ config GENERIC_CMOS_UPDATE
 config ARCH_USES_GETTIMEOFFSET
 	def_bool n
 
-config GENERIC_IOMAP
-       bool
-       default y
-
 config ARCH_HAS_ILOG2_U32
 	bool
 	default n
@@ -52,6 +48,7 @@ config CRIS
 	select HAVE_IDE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
+	select GENERIC_IOMAP
 
 config HZ
 	int
diff -puN arch/hexagon/Kconfig~lib-move-generic_iomap-to-lib-kconfig arch/hexagon/Kconfig
--- a/arch/hexagon/Kconfig~lib-move-generic_iomap-to-lib-kconfig
+++ a/arch/hexagon/Kconfig
@@ -14,6 +14,7 @@ config HEXAGON
 	# select HAVE_CLK
 	# select IRQ_PER_CPU
 	# select GENERIC_PENDING_IRQ if SMP
+	select GENERIC_IOMAP
 	select HAVE_IRQ_WORK
 	select GENERIC_ATOMIC64
 	select HAVE_PERF_EVENTS
@@ -71,9 +72,6 @@ config GENERIC_CSUM
 config GENERIC_IRQ_PROBE
 	def_bool y
 
-config GENERIC_IOMAP
-	def_bool y
-
 config NEED_SG_DMA_LENGTH
 	def_bool y
 
diff -puN arch/ia64/Kconfig~lib-move-generic_iomap-to-lib-kconfig arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~lib-move-generic_iomap-to-lib-kconfig
+++ a/arch/ia64/Kconfig
@@ -29,6 +29,7 @@ config IA64
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_IOMAP
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
@@ -102,10 +103,6 @@ config EFI
 	bool
 	default y
 
-config GENERIC_IOMAP
-	bool
-	default y
-
 config ARCH_CLOCKSOURCE_DATA
 	def_bool y
 
diff -puN arch/m68k/Kconfig~lib-move-generic_iomap-to-lib-kconfig arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~lib-move-generic_iomap-to-lib-kconfig
+++ a/arch/m68k/Kconfig
@@ -37,9 +37,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_IOMAP
-	def_bool MMU
-
 config GENERIC_CSUM
 	bool
 
@@ -78,6 +75,7 @@ source "kernel/Kconfig.freezer"
 config MMU
 	bool "MMU-based Paged Memory Management Support"
 	default y
+	select GENERIC_IOMAP
 	help
 	  Select if you want MMU-based virtualised addressing space
 	  support by paged memory management. If unsure, say 'Y'.
diff -puN arch/openrisc/Kconfig~lib-move-generic_iomap-to-lib-kconfig arch/openrisc/Kconfig
--- a/arch/openrisc/Kconfig~lib-move-generic_iomap-to-lib-kconfig
+++ a/arch/openrisc/Kconfig
@@ -38,9 +38,6 @@ config RWSEM_XCHGADD_ALGORITHM
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_IOMAP
-	def_bool y
-
 config NO_IOPORT
 	def_bool y
 
diff -puN arch/powerpc/platforms/Kconfig~lib-move-generic_iomap-to-lib-kconfig arch/powerpc/platforms/Kconfig
--- a/arch/powerpc/platforms/Kconfig~lib-move-generic_iomap-to-lib-kconfig
+++ a/arch/powerpc/platforms/Kconfig
@@ -175,9 +175,6 @@ config PPC_INDIRECT_MMIO
 config PPC_IO_WORKAROUNDS
 	bool
 
-config GENERIC_IOMAP
-	bool
-
 source "drivers/cpufreq/Kconfig"
 
 menu "CPU Frequency drivers"
diff -puN arch/score/Kconfig~lib-move-generic_iomap-to-lib-kconfig arch/score/Kconfig
--- a/arch/score/Kconfig~lib-move-generic_iomap-to-lib-kconfig
+++ a/arch/score/Kconfig
@@ -4,6 +4,7 @@ config SCORE
        def_bool y
        select HAVE_GENERIC_HARDIRQS
        select GENERIC_IRQ_SHOW
+       select GENERIC_IOMAP
 
 choice
 	prompt "System type"
@@ -33,9 +34,6 @@ endmenu
 config CPU_SCORE7
 	bool
 
-config GENERIC_IOMAP
-	def_bool y
-
 config NO_DMA
 	bool
 	default y
diff -puN arch/sh/Kconfig~lib-move-generic_iomap-to-lib-kconfig arch/sh/Kconfig
--- a/arch/sh/Kconfig~lib-move-generic_iomap-to-lib-kconfig
+++ a/arch/sh/Kconfig
@@ -84,9 +84,6 @@ config GENERIC_GPIO
 config GENERIC_CALIBRATE_DELAY
 	bool
 
-config GENERIC_IOMAP
-	bool
-
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
diff -puN arch/unicore32/Kconfig~lib-move-generic_iomap-to-lib-kconfig arch/unicore32/Kconfig
--- a/arch/unicore32/Kconfig~lib-move-generic_iomap-to-lib-kconfig
+++ a/arch/unicore32/Kconfig
@@ -12,6 +12,7 @@ config UNICORE32
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_FRAME_POINTERS
+	select GENERIC_IOMAP
 	help
 	  UniCore-32 is 32-bit Instruction Set Architecture,
 	  including a series of low-power-consumption RISC chip
@@ -30,9 +31,6 @@ config GENERIC_CLOCKEVENTS
 config GENERIC_CSUM
 	def_bool y
 
-config GENERIC_IOMAP
-	def_bool y
-
 config NO_IOPORT
 	bool
 
diff -puN arch/x86/Kconfig~lib-move-generic_iomap-to-lib-kconfig arch/x86/Kconfig
--- a/arch/x86/Kconfig~lib-move-generic_iomap-to-lib-kconfig
+++ a/arch/x86/Kconfig
@@ -43,6 +43,7 @@ config X86
 	select HAVE_KVM
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
+	select GENERIC_IOMAP
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select USER_STACKTRACE_SUPPORT
@@ -144,9 +145,6 @@ config NEED_SG_DMA_LENGTH
 config GENERIC_ISA_DMA
 	def_bool ISA_DMA_API
 
-config GENERIC_IOMAP
-	def_bool y
-
 config GENERIC_BUG
 	def_bool y
 	depends on BUG
diff -puN lib/Kconfig~lib-move-generic_iomap-to-lib-kconfig lib/Kconfig
--- a/lib/Kconfig~lib-move-generic_iomap-to-lib-kconfig
+++ a/lib/Kconfig
@@ -19,6 +19,9 @@ config RATIONAL
 config GENERIC_FIND_FIRST_BIT
 	bool
 
+config GENERIC_IOMAP
+	bool
+
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
 	help
_
Subject: Subject: lib: move GENERIC_IOMAP to lib/Kconfig

Patches currently in -mm which might be from mst@redhat.com are

linux-next.patch
lib-move-generic_iomap-to-lib-kconfig.patch
lib-add-generic_pci_iomap.patch
alpha-switch-to-generic_pci_iomap.patch
arm-switch-to-generic_pci_iomap.patch
microblaze-switch-to-generic_pci_iomap.patch
mips-switch-to-generic_pci_iomap.patch
parisc-switch-to-generic_pci_iomap.patch
powerpc-switch-to-generic_pci_iomap.patch
sh-switch-to-generic_pci_iomap.patch
sparc-switch-to-generic_pci_iomap.patch

