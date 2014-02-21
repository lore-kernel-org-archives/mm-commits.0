From: akpm@linux-foundation.org
Subject: + kconfig-rename-has_ioport-to-has_ioport_map.patch added to -mm
 tree
Date: Fri, 21 Feb 2014 14:36:30 -0800
Message-ID: <5307d4ee.obbOeV0tYFBqwWVy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaBUWgb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 17:36:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, arnd@arndb.de, u.kleine-koenig@pengutronix.de

Subject: + kconfig-rename-has_ioport-to-has_ioport_map.patch added to -mm tree
To: u.kleine-koenig@pengutronix.de,arnd@arndb.de
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 14:36:30 -0800


The patch titled
     Subject: Kconfig: rename HAS_IOPORT to HAS_IOPORT_MAP
has been added to the -mm tree.  Its filename is
     kconfig-rename-has_ioport-to-has_ioport_map.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kconfig-rename-has_ioport-to-has_ioport_map.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kconfig-rename-has_ioport-to-has_ioport_map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Subject: Kconfig: rename HAS_IOPORT to HAS_IOPORT_MAP

If the renamed symbol is defined lib/iomap.c implements ioport_map and
ioport_unmap and currently (nearly) all platforms define the port accessor
functions outb/inb and friend unconditionally.  So HAS_IOPORT_MAP is the
better name for this.  Consequently NO_IOPORT is renamed to NO_IOPORT_MAP.

The motivation for this change is to reintroduce a symbol HAS_IOPORT that
signals if outb/int et al are available.  I will address that at least one
merge window later though to keep surprises to a minimum and catch new
introductions of (HAS|NO)_IOPORT.

The changes in this commit were done using:

	$ git grep -l -E '(NO|HAS)_IOPORT' | xargs perl -p -i -e 's/\b((?:CONFIG_)?(?:NO|HAS)_IOPORT)\b/$1_MAP/'

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/Kconfig                    |    2 +-
 arch/arm/Kconfig                    |   12 ++++++------
 arch/arm/mach-picoxcell/Kconfig     |    2 +-
 arch/arm/mach-prima2/Kconfig        |    2 +-
 arch/arm/mach-s3c24xx/Kconfig       |    2 +-
 arch/arm/mach-shmobile/Kconfig      |    2 +-
 arch/arm/mach-vexpress/Kconfig      |    2 +-
 arch/arm/plat-samsung/Kconfig       |    4 ++--
 arch/arm64/Kconfig                  |    2 +-
 arch/cris/Kconfig                   |    2 +-
 arch/hexagon/Kconfig                |    2 +-
 arch/m32r/Kconfig                   |    2 +-
 arch/m68k/Kconfig                   |    2 +-
 arch/metag/Kconfig                  |    2 +-
 arch/mips/Kconfig                   |    4 ++--
 arch/openrisc/Kconfig               |    2 +-
 arch/s390/Kconfig                   |    2 +-
 arch/sh/Kconfig                     |    4 ++--
 arch/sh/boards/Kconfig              |    8 ++++----
 arch/sh/include/asm/io.h            |    4 ++--
 arch/sh/include/asm/io_trapped.h    |    2 +-
 arch/sh/include/asm/machvec.h       |    2 +-
 arch/sh/kernel/Makefile             |    2 +-
 arch/sh/kernel/io_trapped.c         |    4 ++--
 arch/tile/Kconfig                   |    2 +-
 arch/unicore32/Kconfig              |    2 +-
 arch/xtensa/Kconfig                 |    4 ++--
 arch/xtensa/configs/iss_defconfig   |    2 +-
 arch/xtensa/configs/s6105_defconfig |    2 +-
 drivers/char/tpm/Kconfig            |    2 +-
 drivers/i2c/busses/Kconfig          |    2 +-
 drivers/net/can/sja1000/Kconfig     |    2 +-
 drivers/net/ethernet/3com/Kconfig   |    2 +-
 include/asm-generic/io.h            |    4 ++--
 include/asm-generic/iomap.h         |    2 +-
 include/linux/io.h                  |    2 +-
 lib/Kconfig                         |    4 ++--
 lib/devres.c                        |    4 ++--
 lib/iomap.c                         |    4 ++--
 sound/isa/Kconfig                   |    2 +-
 sound/pci/Kconfig                   |    2 +-
 41 files changed, 59 insertions(+), 59 deletions(-)

diff -puN arch/arc/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/arc/Kconfig
--- a/arch/arc/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/arc/Kconfig
@@ -57,7 +57,7 @@ config ARCH_FLATMEM_ENABLE
 config MMU
 	def_bool y
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool y
 
 config GENERIC_CALIBRATE_DELAY
diff -puN arch/arm/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/arm/Kconfig
--- a/arch/arm/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/arm/Kconfig
@@ -129,7 +129,7 @@ config HAVE_TCM
 config HAVE_PROC_CPU
 	bool
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	bool
 
 config EISA
@@ -409,7 +409,7 @@ config ARCH_EBSA110
 	select ISA
 	select NEED_MACH_IO_H
 	select NEED_MACH_MEMORY_H
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	help
 	  This is an evaluation board for the StrongARM processor available
 	  from Digital. It has limited hardware on-board, including an
@@ -429,7 +429,7 @@ config ARCH_EFM32
 	select CPU_V7M
 	select GENERIC_CLOCKEVENTS
 	select NO_DMA
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select SPARSE_IRQ
 	select USE_OF
 	help
@@ -682,7 +682,7 @@ config ARCH_SHMOBILE_LEGACY
 	select HAVE_SMP
 	select MIGHT_HAVE_CACHE_L2X0
 	select MULTI_IRQ_HANDLER
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select PINCTRL
 	select PM_GENERIC_DOMAINS if PM
 	select SPARSE_IRQ
@@ -703,7 +703,7 @@ config ARCH_RPC
 	select ISA_DMA_API
 	select NEED_MACH_IO_H
 	select NEED_MACH_MEMORY_H
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select VIRT_TO_BUS
 	help
 	  On the Acorn Risc-PC, Linux can support the internal IDE disk and
@@ -762,7 +762,7 @@ config ARCH_S3C64XX
 	select HAVE_S3C2410_I2C if I2C
 	select HAVE_S3C2410_WATCHDOG if WATCHDOG
 	select HAVE_TCM
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select PLAT_SAMSUNG
 	select PM_GENERIC_DOMAINS
 	select S3C_DEV_NAND
diff -puN arch/arm/mach-picoxcell/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/arm/mach-picoxcell/Kconfig
--- a/arch/arm/mach-picoxcell/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/arm/mach-picoxcell/Kconfig
@@ -7,6 +7,6 @@ config ARCH_PICOXCELL
 	select DW_APB_TIMER_OF
 	select GENERIC_CLOCKEVENTS
 	select HAVE_TCM
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select SPARSE_IRQ
 	select USE_OF
diff -puN arch/arm/mach-prima2/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/arm/mach-prima2/Kconfig
--- a/arch/arm/mach-prima2/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/arm/mach-prima2/Kconfig
@@ -4,7 +4,7 @@ config ARCH_SIRF
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_IRQ_CHIP
 	select MIGHT_HAVE_CACHE_L2X0
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select PINCTRL
 	select PINCTRL_SIRF
 	help
diff -puN arch/arm/mach-s3c24xx/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/arm/mach-s3c24xx/Kconfig
--- a/arch/arm/mach-s3c24xx/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/arm/mach-s3c24xx/Kconfig
@@ -12,7 +12,7 @@ if ARCH_S3C24XX
 config PLAT_S3C24XX
 	def_bool y
 	select ARCH_REQUIRE_GPIOLIB
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select S3C_DEV_NAND
 	select IRQ_DOMAIN
 	help
diff -puN arch/arm/mach-shmobile/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/arm/mach-shmobile/Kconfig
--- a/arch/arm/mach-shmobile/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/arm/mach-shmobile/Kconfig
@@ -13,7 +13,7 @@ config ARCH_SHMOBILE_MULTI
 	select ARM_GIC
 	select MIGHT_HAVE_CACHE_L2X0
 	select MIGHT_HAVE_PCI
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select PINCTRL
 	select ARCH_REQUIRE_GPIOLIB
 	select CLKDEV_LOOKUP
diff -puN arch/arm/mach-vexpress/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/arm/mach-vexpress/Kconfig
--- a/arch/arm/mach-vexpress/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/arm/mach-vexpress/Kconfig
@@ -15,7 +15,7 @@ config ARCH_VEXPRESS
 	select HAVE_SMP
 	select ICST
 	select MIGHT_HAVE_CACHE_L2X0
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select PLAT_VERSATILE
 	select PLAT_VERSATILE_CLCD
 	select POWER_RESET
diff -puN arch/arm/plat-samsung/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/arm/plat-samsung/Kconfig
--- a/arch/arm/plat-samsung/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/arm/plat-samsung/Kconfig
@@ -9,7 +9,7 @@ config PLAT_SAMSUNG
 	depends on PLAT_S3C24XX || ARCH_S3C64XX || PLAT_S5P || ARCH_EXYNOS
 	default y
 	select GENERIC_IRQ_CHIP
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	help
 	  Base platform code for all Samsung SoC based systems
 
@@ -19,7 +19,7 @@ config PLAT_S5P
 	default y
 	select ARCH_REQUIRE_GPIOLIB
 	select ARM_VIC
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select PLAT_SAMSUNG
 	select S3C_GPIO_TRACK
 	select S5P_GPIO_DRVSTR
diff -puN arch/arm64/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/arm64/Kconfig
@@ -61,7 +61,7 @@ config ARCH_PHYS_ADDR_T_64BIT
 config MMU
 	def_bool y
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool y
 
 config STACKTRACE_SUPPORT
diff -puN arch/cris/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/cris/Kconfig
--- a/arch/cris/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/cris/Kconfig
@@ -29,7 +29,7 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool y
 
 config FORCE_MAX_ZONEORDER
diff -puN arch/hexagon/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/hexagon/Kconfig
--- a/arch/hexagon/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/hexagon/Kconfig
@@ -19,7 +19,7 @@ config HEXAGON
 	select GENERIC_IRQ_SHOW
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
 	select STACKTRACE_SUPPORT
diff -puN arch/m32r/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/m32r/Kconfig
@@ -28,7 +28,7 @@ config ZONE_DMA
 	bool
 	default y
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool y
 
 config NO_DMA
diff -puN arch/m68k/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/m68k/Kconfig
@@ -51,7 +51,7 @@ config TIME_LOW_RES
 	bool
 	default y
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool y
 
 config NO_DMA
diff -puN arch/metag/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/metag/Kconfig
--- a/arch/metag/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/metag/Kconfig
@@ -52,7 +52,7 @@ config GENERIC_HWEIGHT
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool y
 
 source "init/Kconfig"
diff -puN arch/mips/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/mips/Kconfig
--- a/arch/mips/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/mips/Kconfig
@@ -175,7 +175,7 @@ config MACH_DECSTATION
 	select CPU_R4000_WORKAROUNDS if 64BIT
 	select CPU_R4400_WORKAROUNDS if 64BIT
 	select DMA_NONCOHERENT
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select IRQ_CPU
 	select SYS_HAS_CPU_R3000
 	select SYS_HAS_CPU_R4X00
@@ -949,7 +949,7 @@ config SYNC_R4K
 config MIPS_MACHINE
 	def_bool n
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool n
 
 config GENERIC_ISA_DMA
diff -puN arch/openrisc/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/openrisc/Kconfig
--- a/arch/openrisc/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/openrisc/Kconfig
@@ -41,7 +41,7 @@ config RWSEM_XCHGADD_ALGORITHM
 config GENERIC_HWEIGHT
 	def_bool y
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool y
 
 config TRACE_IRQFLAGS_SUPPORT
diff -puN arch/s390/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/s390/Kconfig
--- a/arch/s390/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/s390/Kconfig
@@ -52,7 +52,7 @@ config KEXEC
 config AUDIT_ARCH
 	def_bool y
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool y
 
 config PCI_QUIRKS
diff -puN arch/sh/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/sh/Kconfig
--- a/arch/sh/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/sh/Kconfig
@@ -3,7 +3,7 @@ config SUPERH
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select EXPERT
 	select CLKDEV_LOOKUP
-	select HAVE_IDE if HAS_IOPORT
+	select HAVE_IDE if HAS_IOPORT_MAP
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select ARCH_DISCARD_MEMBLOCK
@@ -147,7 +147,7 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	def_bool n
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool !PCI
 	depends on !SH_CAYMAN && !SH_SH4202_MICRODEV && !SH_SHMIN && \
 		   !SH_HP6XX && !SH_SOLUTION_ENGINE
diff -puN arch/sh/boards/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/sh/boards/Kconfig
--- a/arch/sh/boards/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/sh/boards/Kconfig
@@ -158,7 +158,7 @@ config SH_SDK7786
 	bool "SDK7786"
 	depends on CPU_SUBTYPE_SH7786
 	select SYS_SUPPORTS_PCI
-	select NO_IOPORT if !PCI
+	select NO_IOPORT_MAP if !PCI
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_SRAM_POOL
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
@@ -204,7 +204,7 @@ config SH_URQUELL
 	depends on CPU_SUBTYPE_SH7786
 	select ARCH_REQUIRE_GPIOLIB
 	select SYS_SUPPORTS_PCI
-	select NO_IOPORT if !PCI
+	select NO_IOPORT_MAP if !PCI
 
 config SH_MIGOR
 	bool "Migo-R"
@@ -306,7 +306,7 @@ config SH_LBOX_RE2
 config SH_X3PROTO
 	bool "SH-X3 Prototype board"
 	depends on CPU_SUBTYPE_SHX3
-	select NO_IOPORT if !PCI
+	select NO_IOPORT_MAP if !PCI
 	select IRQ_DOMAIN
 
 config SH_MAGIC_PANEL_R2
@@ -333,7 +333,7 @@ config SH_POLARIS
 
 config SH_SH2007
 	bool "SH-2007 board"
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 	depends on CPU_SUBTYPE_SH7780
 	help
diff -puN arch/sh/include/asm/io.h~kconfig-rename-has_ioport-to-has_ioport_map arch/sh/include/asm/io.h
--- a/arch/sh/include/asm/io.h~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/sh/include/asm/io.h
@@ -122,7 +122,7 @@ __BUILD_MEMORY_STRING(__raw_, l, u32)
 
 __BUILD_MEMORY_STRING(__raw_, q, u64)
 
-#ifdef CONFIG_HAS_IOPORT
+#ifdef CONFIG_HAS_IOPORT_MAP
 
 /*
  * Slowdown I/O port space accesses for antique hardware.
@@ -218,7 +218,7 @@ __BUILD_IOPORT_STRING(w, u16)
 __BUILD_IOPORT_STRING(l, u32)
 __BUILD_IOPORT_STRING(q, u64)
 
-#else /* !CONFIG_HAS_IOPORT */
+#else /* !CONFIG_HAS_IOPORT_MAP */
 
 #include <asm/io_noioport.h>
 
diff -puN arch/sh/include/asm/io_trapped.h~kconfig-rename-has_ioport-to-has_ioport_map arch/sh/include/asm/io_trapped.h
--- a/arch/sh/include/asm/io_trapped.h~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/sh/include/asm/io_trapped.h
@@ -36,7 +36,7 @@ __ioremap_trapped(unsigned long offset,
 #define __ioremap_trapped(offset, size) NULL
 #endif
 
-#ifdef CONFIG_HAS_IOPORT
+#ifdef CONFIG_HAS_IOPORT_MAP
 extern struct list_head trapped_io;
 
 static inline void __iomem *
diff -puN arch/sh/include/asm/machvec.h~kconfig-rename-has_ioport-to-has_ioport_map arch/sh/include/asm/machvec.h
--- a/arch/sh/include/asm/machvec.h~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/sh/include/asm/machvec.h
@@ -21,7 +21,7 @@ struct sh_machine_vector {
 	int (*mv_irq_demux)(int irq);
 	void (*mv_init_irq)(void);
 
-#ifdef CONFIG_HAS_IOPORT
+#ifdef CONFIG_HAS_IOPORT_MAP
 	void __iomem *(*mv_ioport_map)(unsigned long port, unsigned int size);
 	void (*mv_ioport_unmap)(void __iomem *);
 #endif
diff -puN arch/sh/kernel/Makefile~kconfig-rename-has_ioport-to-has_ioport_map arch/sh/kernel/Makefile
--- a/arch/sh/kernel/Makefile~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/sh/kernel/Makefile
@@ -22,7 +22,7 @@ obj-y	:= debugtraps.o dma-nommu.o dumpst
 
 ifndef CONFIG_GENERIC_IOMAP
 obj-y				+= iomap.o
-obj-$(CONFIG_HAS_IOPORT)	+= ioport.o
+obj-$(CONFIG_HAS_IOPORT_MAP)	+= ioport.o
 endif
 
 obj-$(CONFIG_SUPERH32)		+= sys_sh32.o
diff -puN arch/sh/kernel/io_trapped.c~kconfig-rename-has_ioport-to-has_ioport_map arch/sh/kernel/io_trapped.c
--- a/arch/sh/kernel/io_trapped.c~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/sh/kernel/io_trapped.c
@@ -22,7 +22,7 @@
 
 #define TRAPPED_PAGES_MAX 16
 
-#ifdef CONFIG_HAS_IOPORT
+#ifdef CONFIG_HAS_IOPORT_MAP
 LIST_HEAD(trapped_io);
 EXPORT_SYMBOL_GPL(trapped_io);
 #endif
@@ -90,7 +90,7 @@ int register_trapped_io(struct trapped_i
 	tiop->magic = IO_TRAPPED_MAGIC;
 	INIT_LIST_HEAD(&tiop->list);
 	spin_lock_irq(&trapped_lock);
-#ifdef CONFIG_HAS_IOPORT
+#ifdef CONFIG_HAS_IOPORT_MAP
 	if (flags & IORESOURCE_IO)
 		list_add(&tiop->list, &trapped_io);
 #endif
diff -puN arch/tile/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/tile/Kconfig
--- a/arch/tile/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/tile/Kconfig
@@ -405,7 +405,7 @@ config PCI_DOMAINS
 config NO_IOMEM
 	def_bool !PCI
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool !PCI
 
 config TILE_PCI_IO
diff -puN arch/unicore32/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/unicore32/Kconfig
--- a/arch/unicore32/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/unicore32/Kconfig
@@ -27,7 +27,7 @@ config UNICORE32
 config GENERIC_CSUM
 	def_bool y
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	bool
 
 config STACKTRACE_SUPPORT
diff -puN arch/xtensa/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/xtensa/Kconfig
@@ -40,7 +40,7 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	def_bool n
 
-config NO_IOPORT
+config NO_IOPORT_MAP
 	def_bool n
 
 config HZ
@@ -240,7 +240,7 @@ config XTENSA_PLATFORM_XT2000
 config XTENSA_PLATFORM_S6105
 	bool "S6105"
 	select SERIAL_CONSOLE
-	select NO_IOPORT
+	select NO_IOPORT_MAP
 
 config XTENSA_PLATFORM_XTFPGA
 	bool "XTFPGA"
diff -puN arch/xtensa/configs/iss_defconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/xtensa/configs/iss_defconfig
--- a/arch/xtensa/configs/iss_defconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/xtensa/configs/iss_defconfig
@@ -11,7 +11,7 @@ CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
 # CONFIG_ARCH_HAS_ILOG2_U32 is not set
 # CONFIG_ARCH_HAS_ILOG2_U64 is not set
-CONFIG_NO_IOPORT=y
+CONFIG_NO_IOPORT_MAP=y
 CONFIG_HZ=100
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 CONFIG_CONSTRUCTORS=y
diff -puN arch/xtensa/configs/s6105_defconfig~kconfig-rename-has_ioport-to-has_ioport_map arch/xtensa/configs/s6105_defconfig
--- a/arch/xtensa/configs/s6105_defconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/arch/xtensa/configs/s6105_defconfig
@@ -11,7 +11,7 @@ CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
 # CONFIG_ARCH_HAS_ILOG2_U32 is not set
 # CONFIG_ARCH_HAS_ILOG2_U64 is not set
-CONFIG_NO_IOPORT=y
+CONFIG_NO_IOPORT_MAP=y
 CONFIG_HZ=100
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
diff -puN drivers/char/tpm/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map drivers/char/tpm/Kconfig
--- a/drivers/char/tpm/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/drivers/char/tpm/Kconfig
@@ -74,7 +74,7 @@ config TCG_NSC
 
 config TCG_ATMEL
 	tristate "Atmel TPM Interface"
-	depends on PPC64 || HAS_IOPORT
+	depends on PPC64 || HAS_IOPORT_MAP
 	---help---
 	  If you have a TPM security chip from Atmel say Yes and it 
 	  will be accessible from within Linux.  To compile this driver 
diff -puN drivers/i2c/busses/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map drivers/i2c/busses/Kconfig
--- a/drivers/i2c/busses/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/drivers/i2c/busses/Kconfig
@@ -936,7 +936,7 @@ config I2C_ACORN
 
 config I2C_ELEKTOR
 	tristate "Elektor ISA card"
-	depends on ISA && HAS_IOPORT && BROKEN_ON_SMP
+	depends on ISA && HAS_IOPORT_MAP && BROKEN_ON_SMP
 	select I2C_ALGOPCF
 	help
 	  This supports the PCF8584 ISA bus I2C adapter.  Say Y if you own
diff -puN drivers/net/can/sja1000/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map drivers/net/can/sja1000/Kconfig
--- a/drivers/net/can/sja1000/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/drivers/net/can/sja1000/Kconfig
@@ -46,7 +46,7 @@ config CAN_EMS_PCI
 config CAN_PEAK_PCMCIA
 	tristate "PEAK PCAN-PC Card"
 	depends on PCMCIA
-	depends on HAS_IOPORT
+	depends on HAS_IOPORT_MAP
 	---help---
 	  This driver is for the PCAN-PC Card PCMCIA adapter (1 or 2 channels)
 	  from PEAK-System (http://www.peak-system.com). To compile this
diff -puN drivers/net/ethernet/3com/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map drivers/net/ethernet/3com/Kconfig
--- a/drivers/net/ethernet/3com/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/drivers/net/ethernet/3com/Kconfig
@@ -66,7 +66,7 @@ config PCMCIA_3C589
 
 config VORTEX
 	tristate "3c590/3c900 series (592/595/597) \"Vortex/Boomerang\" support"
-	depends on (PCI || EISA) && HAS_IOPORT
+	depends on (PCI || EISA) && HAS_IOPORT_MAP
 	select MII
 	---help---
 	  This option enables driver support for a large number of 10Mbps and
diff -puN include/asm-generic/io.h~kconfig-rename-has_ioport-to-has_ioport_map include/asm-generic/io.h
--- a/include/asm-generic/io.h~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/include/asm-generic/io.h
@@ -327,7 +327,7 @@ static inline void iounmap(void __iomem
 }
 #endif /* CONFIG_MMU */
 
-#ifdef CONFIG_HAS_IOPORT
+#ifdef CONFIG_HAS_IOPORT_MAP
 #ifndef CONFIG_GENERIC_IOMAP
 static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
 {
@@ -341,7 +341,7 @@ static inline void ioport_unmap(void __i
 extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
 extern void ioport_unmap(void __iomem *p);
 #endif /* CONFIG_GENERIC_IOMAP */
-#endif /* CONFIG_HAS_IOPORT */
+#endif /* CONFIG_HAS_IOPORT_MAP */
 
 #ifndef xlate_dev_kmem_ptr
 #define xlate_dev_kmem_ptr(p)	p
diff -puN include/asm-generic/iomap.h~kconfig-rename-has_ioport-to-has_ioport_map include/asm-generic/iomap.h
--- a/include/asm-generic/iomap.h~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/include/asm-generic/iomap.h
@@ -56,7 +56,7 @@ extern void iowrite8_rep(void __iomem *p
 extern void iowrite16_rep(void __iomem *port, const void *buf, unsigned long count);
 extern void iowrite32_rep(void __iomem *port, const void *buf, unsigned long count);
 
-#ifdef CONFIG_HAS_IOPORT
+#ifdef CONFIG_HAS_IOPORT_MAP
 /* Create a virtual mapping cookie for an IO port range */
 extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
 extern void ioport_unmap(void __iomem *);
diff -puN include/linux/io.h~kconfig-rename-has_ioport-to-has_ioport_map include/linux/io.h
--- a/include/linux/io.h~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/include/linux/io.h
@@ -41,7 +41,7 @@ static inline int ioremap_page_range(uns
 /*
  * Managed iomap interface
  */
-#ifdef CONFIG_HAS_IOPORT
+#ifdef CONFIG_HAS_IOPORT_MAP
 void __iomem * devm_ioport_map(struct device *dev, unsigned long port,
 			       unsigned int nr);
 void devm_ioport_unmap(struct device *dev, void __iomem *addr);
diff -puN lib/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map lib/Kconfig
--- a/lib/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/lib/Kconfig
@@ -342,9 +342,9 @@ config HAS_IOMEM
 	select GENERIC_IO
 	default y
 
-config HAS_IOPORT
+config HAS_IOPORT_MAP
 	boolean
-	depends on HAS_IOMEM && !NO_IOPORT
+	depends on HAS_IOMEM && !NO_IOPORT_MAP
 	default y
 
 config HAS_DMA
diff -puN lib/devres.c~kconfig-rename-has_ioport-to-has_ioport_map lib/devres.c
--- a/lib/devres.c~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/lib/devres.c
@@ -168,7 +168,7 @@ void __iomem *devm_request_and_ioremap(s
 }
 EXPORT_SYMBOL(devm_request_and_ioremap);
 
-#ifdef CONFIG_HAS_IOPORT
+#ifdef CONFIG_HAS_IOPORT_MAP
 /*
  * Generic iomap devres
  */
@@ -227,7 +227,7 @@ void devm_ioport_unmap(struct device *de
 			       devm_ioport_map_match, (void *)addr));
 }
 EXPORT_SYMBOL(devm_ioport_unmap);
-#endif /* CONFIG_HAS_IOPORT */
+#endif /* CONFIG_HAS_IOPORT_MAP */
 
 #ifdef CONFIG_PCI
 /*
diff -puN lib/iomap.c~kconfig-rename-has_ioport-to-has_ioport_map lib/iomap.c
--- a/lib/iomap.c~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/lib/iomap.c
@@ -224,7 +224,7 @@ EXPORT_SYMBOL(iowrite8_rep);
 EXPORT_SYMBOL(iowrite16_rep);
 EXPORT_SYMBOL(iowrite32_rep);
 
-#ifdef CONFIG_HAS_IOPORT
+#ifdef CONFIG_HAS_IOPORT_MAP
 /* Create a virtual mapping cookie for an IO port range */
 void __iomem *ioport_map(unsigned long port, unsigned int nr)
 {
@@ -239,7 +239,7 @@ void ioport_unmap(void __iomem *addr)
 }
 EXPORT_SYMBOL(ioport_map);
 EXPORT_SYMBOL(ioport_unmap);
-#endif /* CONFIG_HAS_IOPORT */
+#endif /* CONFIG_HAS_IOPORT_MAP */
 
 #ifdef CONFIG_PCI
 /* Hide the details if this is a MMIO or PIO address space and just do what
diff -puN sound/isa/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map sound/isa/Kconfig
--- a/sound/isa/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/sound/isa/Kconfig
@@ -191,7 +191,7 @@ config SND_ES18XX
 
 config SND_SC6000
 	tristate "Gallant SC-6000/6600/7000 and Audio Excel DSP 16"
-	depends on HAS_IOPORT
+	depends on HAS_IOPORT_MAP
 	select SND_WSS_LIB
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
diff -puN sound/pci/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map sound/pci/Kconfig
--- a/sound/pci/Kconfig~kconfig-rename-has_ioport-to-has_ioport_map
+++ a/sound/pci/Kconfig
@@ -689,7 +689,7 @@ config SND_LOLA
 
 config SND_LX6464ES
 	tristate "Digigram LX6464ES"
-	depends on HAS_IOPORT
+	depends on HAS_IOPORT_MAP
 	select SND_PCM
 	help
 	  Say Y here to include support for Digigram LX6464ES boards.
_

Patches currently in -mm which might be from u.kleine-koenig@pengutronix.de are

origin.patch
kconfig-rename-has_ioport-to-has_ioport_map.patch
linux-next.patch

