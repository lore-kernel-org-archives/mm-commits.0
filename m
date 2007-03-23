From: akpm@linux-foundation.org
Subject: + blackfin-arch-2.6.21-rc4-mm1-update.patch added to -mm tree
Date: Fri, 23 Mar 2007 00:22:51 -0800
Message-ID: <200703230822.l2N8MpYc009951@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42211 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422692AbXCWIXD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Mar 2007 04:23:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com


The patch titled
     blackfin-arch-2.6.21-rc4-mm1-update
has been added to the -mm tree.  Its filename is
     blackfin-arch-2.6.21-rc4-mm1-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: blackfin-arch-2.6.21-rc4-mm1-update
From: "Wu, Bryan" <bryan.wu@analog.com>

1) fixed most of issues according to Arnd and Paul's review.
2) Remove RCS tags
3) Remove unsupported BF535 machine.
4) applied and tested based on blackfin-arch-balance-parenthesis-in-macros.patch

Signed-off-by: Bryan Wu <bryan.wu@analog.com> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/Kconfig                           |  173 +
 arch/blackfin/Makefile                          |    1 
 arch/blackfin/kernel/Makefile                   |    3 
 arch/blackfin/kernel/asm-offsets.c              |    2 
 arch/blackfin/kernel/bfin_dma_5xx.c             |  245 -
 arch/blackfin/kernel/bfin_gpio.c                |   41 
 arch/blackfin/kernel/bfin_ksyms.c               |    2 
 arch/blackfin/kernel/dma-mapping.c              |   25 
 arch/blackfin/kernel/dualcore_test.c            |    2 
 arch/blackfin/kernel/entry.S                    |    6 
 arch/blackfin/kernel/flat.c                     |  101 
 arch/blackfin/kernel/init_task.c                |    5 
 arch/blackfin/kernel/irqchip.c                  |    7 
 arch/blackfin/kernel/module.c                   |    2 
 arch/blackfin/kernel/process.c                  |   56 
 arch/blackfin/kernel/ptrace.c                   |   41 
 arch/blackfin/kernel/setup.c                    |   79 
 arch/blackfin/kernel/signal.c                   |  193 -
 arch/blackfin/kernel/sys_bfin.c                 |   18 
 arch/blackfin/kernel/time.c                     |   18 
 arch/blackfin/kernel/traps.c                    |  110 
 arch/blackfin/kernel/vmlinux.lds.S              |    2 
 arch/blackfin/lib/ashldi3.c                     |    6 
 arch/blackfin/lib/ashrdi3.c                     |    6 
 arch/blackfin/lib/checksum.c                    |    6 
 arch/blackfin/lib/divsi3.S                      |    9 
 arch/blackfin/lib/gcclib.h                      |    2 
 arch/blackfin/lib/ins.S                         |    2 
 arch/blackfin/lib/lshrdi3.c                     |    6 
 arch/blackfin/lib/memchr.S                      |    2 
 arch/blackfin/lib/memcmp.S                      |    2 
 arch/blackfin/lib/memcpy.S                      |    7 
 arch/blackfin/lib/memmove.S                     |    2 
 arch/blackfin/lib/memset.S                      |    8 
 arch/blackfin/lib/modsi3.S                      |    9 
 arch/blackfin/lib/muldi3.c                      |    6 
 arch/blackfin/lib/outs.S                        |    2 
 arch/blackfin/lib/smulsi3_highpart.S            |    6 
 arch/blackfin/lib/udivsi3.S                     |   11 
 arch/blackfin/lib/umodsi3.S                     |    7 
 arch/blackfin/lib/umulsi3_highpart.S            |    6 
 arch/blackfin/mach-bf533/boards/cm_bf533.c      |    2 
 arch/blackfin/mach-bf533/boards/ezkit.c         |   11 
 arch/blackfin/mach-bf533/boards/generic_board.c |    2 
 arch/blackfin/mach-bf533/boards/stamp.c         |   17 
 arch/blackfin/mach-bf533/cpu.c                  |    2 
 arch/blackfin/mach-bf533/head.S                 |    2 
 arch/blackfin/mach-bf533/ints-priority.c        |    2 
 arch/blackfin/mach-bf537/boards/Makefile        |    9 
 arch/blackfin/mach-bf537/boards/cm_bf537.c      |   13 
 arch/blackfin/mach-bf537/boards/eth_mac.c       |   52 
 arch/blackfin/mach-bf537/boards/generic_board.c |   24 
 arch/blackfin/mach-bf537/boards/pnav10.c        |   34 
 arch/blackfin/mach-bf537/boards/stamp.c         |   95 
 arch/blackfin/mach-bf537/cpu.c                  |    2 
 arch/blackfin/mach-bf537/head.S                 |    3 
 arch/blackfin/mach-bf537/ints-priority.c        |    2 
 arch/blackfin/mach-bf561/boards/Makefile        |    1 
 arch/blackfin/mach-bf561/boards/cm_bf561.c      |   23 
 arch/blackfin/mach-bf561/boards/ezkit.c         |   19 
 arch/blackfin/mach-bf561/boards/generic_board.c |    4 
 arch/blackfin/mach-bf561/coreb.c                |    2 
 arch/blackfin/mach-bf561/head.S                 |    2 
 arch/blackfin/mach-bf561/ints-priority.c        |    2 
 arch/blackfin/mach-common/cache.S               |    4 
 arch/blackfin/mach-common/cacheinit.S           |    2 
 arch/blackfin/mach-common/cplbhdlr.S            |    6 
 arch/blackfin/mach-common/cplbinfo.c            |    2 
 arch/blackfin/mach-common/cplbmgr.S             |    6 
 arch/blackfin/mach-common/dpmc.S                |    2 
 arch/blackfin/mach-common/entry.S               |   19 
 arch/blackfin/mach-common/interrupt.S           |    2 
 arch/blackfin/mach-common/ints-priority-dc.c    |   29 
 arch/blackfin/mach-common/ints-priority-sc.c    |   28 
 arch/blackfin/mach-common/irqpanic.c            |    2 
 arch/blackfin/mach-common/lock.S                |    2 
 arch/blackfin/mach-common/pm.c                  |    2 
 arch/blackfin/mm/Makefile                       |    2 
 arch/blackfin/mm/blackfin_sram.c                |   23 
 arch/blackfin/mm/blackfin_sram.h                |    2 
 arch/blackfin/mm/init.c                         |    5 
 arch/blackfin/mm/kmap.c                         |   84 
 arch/blackfin/oprofile/common.c                 |   16 
 arch/blackfin/oprofile/op_blackfin.h            |    2 
 arch/blackfin/oprofile/op_model_bf533.c         |    4 
 arch/blackfin/oprofile/timer_int.c              |    2 
 include/asm-blackfin/bfin-global.h              |    3 
 include/asm-blackfin/bfin_spi_channel.h         |  182 -
 include/asm-blackfin/bfin_sport.h               |   16 
 include/asm-blackfin/blackfin.h                 |   87 
 include/asm-blackfin/bug.h                      |   11 
 include/asm-blackfin/cacheflush.h               |    3 
 include/asm-blackfin/cplbinit.h                 |  395 +--
 include/asm-blackfin/delay.h                    |    5 
 include/asm-blackfin/dma-mapping.h              |   21 
 include/asm-blackfin/dma.h                      |   33 
 include/asm-blackfin/dpmc.h                     |    4 
 include/asm-blackfin/entry.h                    |    5 
 include/asm-blackfin/flat.h                     |   88 
 include/asm-blackfin/io.h                       |  107 
 include/asm-blackfin/irq.h                      |    2 
 include/asm-blackfin/irq_handler.h              |   22 
 include/asm-blackfin/mach-bf533/bf533.h         |   13 
 include/asm-blackfin/mach-bf533/mem_map.h       |   63 
 include/asm-blackfin/mach-bf535/bf535.h         | 1277 ---------
 include/asm-blackfin/mach-bf535/bf535_serial.h  |  109 
 include/asm-blackfin/mach-bf535/blackfin.h      |   43 
 include/asm-blackfin/mach-bf535/cdefBF535.h     |  121 
 include/asm-blackfin/mach-bf535/cdefblackfin.h  |   69 
 include/asm-blackfin/mach-bf535/defBF535.h      | 1818 --------------
 include/asm-blackfin/mach-bf535/defblackfin.h   |  444 ---
 include/asm-blackfin/mach-bf535/irq.h           |  125 
 include/asm-blackfin/mach-bf537/bf537.h         |   13 
 include/asm-blackfin/mach-bf537/defBF534.h      |    3 
 include/asm-blackfin/mach-bf537/mem_map.h       |   79 
 include/asm-blackfin/mach-bf561/bf561.h         |    7 
 include/asm-blackfin/mach-bf561/mem_map.h       |   29 
 include/asm-blackfin/pgtable.h                  |    8 
 include/asm-blackfin/sigcontext.h               |   25 
 include/asm-blackfin/uaccess.h                  |   58 
 include/asm-blackfin/ucontext.h                 |   15 
 include/asm-blackfin/unistd.h                   |    2 
 init/Kconfig                                    |    3 
 123 files changed, 1518 insertions(+), 5598 deletions(-)

diff -puN arch/blackfin/Kconfig~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/Kconfig
@@ -21,6 +21,10 @@ config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default n
 
+config BLACKFIN
+	bool
+	default y
+
 config BFIN
 	bool
 	default y
@@ -45,11 +49,11 @@ config GENERIC_IRQ_PROBE
         bool
 	default y
 
-config GENERIC_CALIBRATE_DELAY
+config GENERIC_TIME
 	bool
-	default y
+	default n
 
-config UCLINUX
+config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
@@ -95,11 +99,6 @@ config BF534
 	help
 	  BF534 Processor Support.
 
-config BF535
-	bool "BF535 (not supported)"
-	help
-	  Not Supported - BF535 Processor Support.
-
 config BF536
 	bool "BF536"
 	help
@@ -140,21 +139,14 @@ config BF_REV_0_5
 
 endchoice
 
-config BLACKFIN
+config BFIN_DUAL_CORE
 	bool
-	depends on (BF537 || BF536 \
-		|| BF534 || BF561 || BF535 || BF533 || BF532 || BF531)
+	depends on (BF561)
 	default y
 
 config BFIN_SINGLE_CORE
 	bool
-	depends on (BF537 || BF536 \
-		|| BF534 || BF535 || BF533 || BF532 || BF531)
-	default y
-
-config BFIN_DUAL_CORE
-	bool
-	depends on (BF561)
+	depends on !BFIN_DUAL_CORE
 	default y
 
 choice
@@ -259,6 +251,18 @@ source "arch/blackfin/mach-bf537/Kconfig
 
 menu "Board customizations"
 
+config CMDLINE_BOOL
+	bool "Default bootloader kernel arguments"
+
+config CMDLINE
+	string "Initial kernel command string"
+	depends on CMDLINE_BOOL
+	default "console=ttyBF0,57600"
+	help
+	  If you don't have a boot loader capable of passing a command line string
+	  to the kernel, you may specify one here. As a minimum, you should specify
+	  the memory size and the root device (e.g., mem=8M, root=/dev/nfs).
+
 comment "Board Setup"
 
 config CLKIN_HZ
@@ -427,11 +431,104 @@ comment "Memory Optimizations"
 
 config I_ENTRY_L1
 	bool "Locate interrupt entry code in L1 Memory"
-	default n
+	default y
 	help
 	  If enabled interrupt entry code (STORE/RESTORE CONTEXT) is linked
 	  into L1 instruction memory.(less latency)
 
+config EXCPT_IRQ_SYSC_L1
+	bool "Locate entire ASM lowlevel excepetion / interrupt - Syscall and CPLB handler code in L1 Memory"
+	default y
+	help
+	  If enabled entire ASM lowlevel exception and interrupt entry code (STORE/RESTORE CONTEXT) is linked
+	  into L1 instruction memory.(less latency)
+
+config DO_IRQ_L1
+	bool "Locate frequently called do_irq dispatcher function in L1 Memory"
+	default y
+	help
+	  If enabled frequently called do_irq dispatcher function is linked
+	  into L1 instruction memory.(less latency)
+
+config CORE_TIMER_IRQ_L1
+	bool "Locate frequently called timer_interrupt() function in L1 Memory"
+	default y
+	help
+	  If enabled frequently called timer_interrupt() function is linked
+	  into L1 instruction memory.(less latency)
+
+config IDLE_L1
+	bool "Locate frequently idle function in L1 Memory"
+	default y
+	help
+	  If enabled frequently called idle function is linked
+	  into L1 instruction memory.(less latency)
+
+config SCHEDULE_L1
+	bool "Locate kernel schedule function in L1 Memory"
+	default y
+	help
+	  If enabled frequently called kernel schedule is linked
+	  into L1 instruction memory.(less latency)
+
+config ARITHMETIC_OPS_L1
+	bool "Locate kernel owned arithmetic functions in L1 Memory"
+	default y
+	help
+	  If enabled arithmetic functions are linked
+	  into L1 instruction memory.(less latency)
+
+config ACCESS_OK_L1
+	bool "Locate access_ok function in L1 Memory"
+	default y
+	help
+	  If enabled access_ok function is linked
+	  into L1 instruction memory.(less latency)
+
+config MEMSET_L1
+	bool "Locate memset function in L1 Memory"
+	default y
+	help
+	  If enabled memset function is linked
+	  into L1 instruction memory.(less latency)
+
+config MEMCPY_L1
+	bool "Locate memcpy function in L1 Memory"
+	default y
+	help
+	  If enabled memcpy function is linked
+	  into L1 instruction memory.(less latency)
+
+config SYS_BFIN_SPINLOCK_L1
+	bool "Locate sys_bfin_spinlock function in L1 Memory"
+	default y
+	help
+	  If enabled sys_bfin_spinlock function is linked
+	  into L1 instruction memory.(less latency)
+
+config IP_CHECKSUM_L1
+	bool "Locate IP Checksum function in L1 Memory"
+	default n
+	help
+	  If enabled IP Checksum function is linked
+	  into L1 instruction memory.(less latency)
+
+config SYSCALL_TAB_L1
+	bool "Locate Syscall Table L1 Data Memory"
+	default n
+	depends on !BF531
+	help
+	  If enabled the Syscall LUT is linked
+	  into L1 data memory.(less latency)
+
+config CPLB_SWITCH_TAB_L1
+	bool "Locate CPLB Switch Tables L1 Data Memory"
+	default n
+	depends on !BF531
+	help
+	  If enabled the CPLB Switch Tables are linked
+	  into L1 data memory.(less latency)
+
 endmenu
 
 
@@ -454,7 +551,6 @@ endchoice
 
 source "mm/Kconfig"
 
-
 config LARGE_ALLOCS
 	bool "Allow allocating large blocks (> 1MB) of memory"
 	help
@@ -475,11 +571,11 @@ choice
 	default DMA_UNCACHED_1M
 	depends BFIN_DMA_5XX
 config DMA_UNCACHED_2M
-	bool "Enable 2M DMA Zone"
+	bool "Enable 2M DMA region"
 config DMA_UNCACHED_1M
-	bool "Enable 1M DMA Zone"
+	bool "Enable 1M DMA region"
 config DMA_UNCACHED_NONE
-	bool "Disable DMA Zone"
+	bool "Disable DMA region"
 endchoice
 
 
@@ -488,6 +584,10 @@ config BLKFIN_CACHE
 	bool "Enable ICACHE"
 config BLKFIN_DCACHE
 	bool "Enable DCACHE"
+config BLKFIN_DCACHE_BANKA
+	bool "Enable only 16k BankA DCACHE - BankB is SRAM"
+	depends on BLKFIN_DCACHE && !BF531
+	default n
 config BLKFIN_CACHE_LOCK
 	bool "Enable Cache Locking"
 
@@ -817,11 +917,11 @@ config DEBUG_KERNEL_START
 config DEBUG_SERIAL_EARLY_INIT
 	bool "Initialize serial driver early"
 	default n
-	depends on SERIAL_BLACKFIN
+	depends on SERIAL_BFIN
 	help
 	  Say Y here if you want to get kernel output early when kernel
 	  crashes before the normal console initialization. If this option
-	  is enable, console output will always go to the ttyS0, no matter
+	  is enable, console output will always go to the ttyBF0, no matter
 	  what kernel boot paramters you set.
 
 config DEBUG_HUNT_FOR_ZERO
@@ -857,30 +957,19 @@ config DUAL_CORE_TEST_MODULE
 	help
 	  Say Y here to build-in dual core test module for dual core test.
 
-config BOOTPARAM
-	bool "Compiled-in Kernel Boot Parameter"
-
-config BOOTPARAM_STRING
-	string "Kernel Boot Parameter"
-	default "console=ttyS0,57600"
-	depends on BOOTPARAM
-
-config NO_KERNEL_MSG
-	bool "Suppress Kernel BUG Messages"
-	help
-	  Do not output any debug BUG messages within the kernel.
-
 config CPLB_INFO
 	bool "Display the CPLB information"
 	help
 	  Display the CPLB information.
 
-config NO_ACCESS_CHECK
-	bool "Do not check the user pointer address"
+config ACCESS_CHECK
+	bool "Check the user pointer address"
+	default y
 	help
 	  Usually the pointer transfer from user space is checked to see if its
-	  address is in the kernel space. This option disable that check to
-	  improve the performance.
+	  address is in the kernel space.
+
+	  Say N here to disable that check to improve the performance.
 
 endmenu
 
diff -puN arch/blackfin/Makefile~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/Makefile
--- a/arch/blackfin/Makefile~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/Makefile
@@ -21,7 +21,6 @@ machine-$(CONFIG_BF531) := bf533
 machine-$(CONFIG_BF532) := bf533
 machine-$(CONFIG_BF533) := bf533
 machine-$(CONFIG_BF534) := bf537
-machine-$(CONFIG_BF535) := bf535
 machine-$(CONFIG_BF536) := bf537
 machine-$(CONFIG_BF537) := bf537
 machine-$(CONFIG_BF561) := bf561
diff -puN arch/blackfin/kernel/Makefile~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/kernel/Makefile
--- a/arch/blackfin/kernel/Makefile~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/kernel/Makefile
@@ -6,7 +6,8 @@ extra-y := init_task.o vmlinux.lds
 
 obj-y := \
 	entry.o process.o bfin_ksyms.o ptrace.o setup.o signal.o \
-	sys_bfin.o time.o traps.o irqchip.o dma-mapping.o bfin_gpio.o
+	sys_bfin.o time.o traps.o irqchip.o dma-mapping.o bfin_gpio.o \
+	flat.o
 
 obj-$(CONFIG_MODULES)                += module.o
 obj-$(CONFIG_BFIN_DMA_5XX)           += bfin_dma_5xx.o
diff -puN arch/blackfin/kernel/asm-offsets.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/kernel/asm-offsets.c
--- a/arch/blackfin/kernel/asm-offsets.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/kernel/asm-offsets.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:  generate definitions needed by assembly language modules.
  *
- * Rev:          $Id: asm-offsets.c,v 1.16 2006/08/03 17:37:02 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/kernel/bfin_dma_5xx.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/kernel/bfin_dma_5xx.c
--- a/arch/blackfin/kernel/bfin_dma_5xx.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:  This file contains the simple DMA Implementation for Blackfin
  *
- * Rev:          $Id: bfin_dma_5xx.c,v 1.17 2006/08/08 20:46:13 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -46,66 +44,66 @@
  * Global Variables
 ***************************************************************************/
 
-static struct dma_channel_t dma_ch[MAX_BLACKFIN_DMA_CHANNEL];
+static struct dma_channel dma_ch[MAX_BLACKFIN_DMA_CHANNEL];
 #if defined (CONFIG_BF561)
-static struct dma_register_t *base_addr[MAX_BLACKFIN_DMA_CHANNEL] = {
-	(struct dma_register_t *) DMA1_0_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA1_1_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA1_2_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA1_3_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA1_4_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA1_5_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA1_6_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA1_7_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA1_8_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA1_9_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA1_10_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA1_11_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA2_0_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA2_1_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA2_2_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA2_3_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA2_4_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA2_5_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA2_6_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA2_7_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA2_8_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA2_9_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA2_10_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA2_11_NEXT_DESC_PTR,
-	(struct dma_register_t *) MDMA1_D0_NEXT_DESC_PTR,
-	(struct dma_register_t *) MDMA1_S0_NEXT_DESC_PTR,
-	(struct dma_register_t *) MDMA1_D1_NEXT_DESC_PTR,
-	(struct dma_register_t *) MDMA1_S1_NEXT_DESC_PTR,
-	(struct dma_register_t *) MDMA2_D0_NEXT_DESC_PTR,
-	(struct dma_register_t *) MDMA2_S0_NEXT_DESC_PTR,
-	(struct dma_register_t *) MDMA2_D1_NEXT_DESC_PTR,
-	(struct dma_register_t *) MDMA2_S1_NEXT_DESC_PTR,
-	(struct dma_register_t *) IMDMA_D0_NEXT_DESC_PTR,
-	(struct dma_register_t *) IMDMA_S0_NEXT_DESC_PTR,
-	(struct dma_register_t *) IMDMA_D1_NEXT_DESC_PTR,
-	(struct dma_register_t *) IMDMA_S1_NEXT_DESC_PTR,
+static struct dma_register *base_addr[MAX_BLACKFIN_DMA_CHANNEL] = {
+	(struct dma_register *) DMA1_0_NEXT_DESC_PTR,
+	(struct dma_register *) DMA1_1_NEXT_DESC_PTR,
+	(struct dma_register *) DMA1_2_NEXT_DESC_PTR,
+	(struct dma_register *) DMA1_3_NEXT_DESC_PTR,
+	(struct dma_register *) DMA1_4_NEXT_DESC_PTR,
+	(struct dma_register *) DMA1_5_NEXT_DESC_PTR,
+	(struct dma_register *) DMA1_6_NEXT_DESC_PTR,
+	(struct dma_register *) DMA1_7_NEXT_DESC_PTR,
+	(struct dma_register *) DMA1_8_NEXT_DESC_PTR,
+	(struct dma_register *) DMA1_9_NEXT_DESC_PTR,
+	(struct dma_register *) DMA1_10_NEXT_DESC_PTR,
+	(struct dma_register *) DMA1_11_NEXT_DESC_PTR,
+	(struct dma_register *) DMA2_0_NEXT_DESC_PTR,
+	(struct dma_register *) DMA2_1_NEXT_DESC_PTR,
+	(struct dma_register *) DMA2_2_NEXT_DESC_PTR,
+	(struct dma_register *) DMA2_3_NEXT_DESC_PTR,
+	(struct dma_register *) DMA2_4_NEXT_DESC_PTR,
+	(struct dma_register *) DMA2_5_NEXT_DESC_PTR,
+	(struct dma_register *) DMA2_6_NEXT_DESC_PTR,
+	(struct dma_register *) DMA2_7_NEXT_DESC_PTR,
+	(struct dma_register *) DMA2_8_NEXT_DESC_PTR,
+	(struct dma_register *) DMA2_9_NEXT_DESC_PTR,
+	(struct dma_register *) DMA2_10_NEXT_DESC_PTR,
+	(struct dma_register *) DMA2_11_NEXT_DESC_PTR,
+	(struct dma_register *) MDMA1_D0_NEXT_DESC_PTR,
+	(struct dma_register *) MDMA1_S0_NEXT_DESC_PTR,
+	(struct dma_register *) MDMA1_D1_NEXT_DESC_PTR,
+	(struct dma_register *) MDMA1_S1_NEXT_DESC_PTR,
+	(struct dma_register *) MDMA2_D0_NEXT_DESC_PTR,
+	(struct dma_register *) MDMA2_S0_NEXT_DESC_PTR,
+	(struct dma_register *) MDMA2_D1_NEXT_DESC_PTR,
+	(struct dma_register *) MDMA2_S1_NEXT_DESC_PTR,
+	(struct dma_register *) IMDMA_D0_NEXT_DESC_PTR,
+	(struct dma_register *) IMDMA_S0_NEXT_DESC_PTR,
+	(struct dma_register *) IMDMA_D1_NEXT_DESC_PTR,
+	(struct dma_register *) IMDMA_S1_NEXT_DESC_PTR,
 };
 #else
-static struct dma_register_t *base_addr[MAX_BLACKFIN_DMA_CHANNEL] = {
-	(struct dma_register_t *) DMA0_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA1_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA2_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA3_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA4_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA5_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA6_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA7_NEXT_DESC_PTR,
+static struct dma_register *base_addr[MAX_BLACKFIN_DMA_CHANNEL] = {
+	(struct dma_register *) DMA0_NEXT_DESC_PTR,
+	(struct dma_register *) DMA1_NEXT_DESC_PTR,
+	(struct dma_register *) DMA2_NEXT_DESC_PTR,
+	(struct dma_register *) DMA3_NEXT_DESC_PTR,
+	(struct dma_register *) DMA4_NEXT_DESC_PTR,
+	(struct dma_register *) DMA5_NEXT_DESC_PTR,
+	(struct dma_register *) DMA6_NEXT_DESC_PTR,
+	(struct dma_register *) DMA7_NEXT_DESC_PTR,
 #if (defined(CONFIG_BF537) || defined(CONFIG_BF534) || defined(CONFIG_BF536))
-	(struct dma_register_t *) DMA8_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA9_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA10_NEXT_DESC_PTR,
-	(struct dma_register_t *) DMA11_NEXT_DESC_PTR,
+	(struct dma_register *) DMA8_NEXT_DESC_PTR,
+	(struct dma_register *) DMA9_NEXT_DESC_PTR,
+	(struct dma_register *) DMA10_NEXT_DESC_PTR,
+	(struct dma_register *) DMA11_NEXT_DESC_PTR,
 #endif
-	(struct dma_register_t *) MDMA_D0_NEXT_DESC_PTR,
-	(struct dma_register_t *) MDMA_S0_NEXT_DESC_PTR,
-	(struct dma_register_t *) MDMA_D1_NEXT_DESC_PTR,
-	(struct dma_register_t *) MDMA_S1_NEXT_DESC_PTR,
+	(struct dma_register *) MDMA_D0_NEXT_DESC_PTR,
+	(struct dma_register *) MDMA_S0_NEXT_DESC_PTR,
+	(struct dma_register *) MDMA_D1_NEXT_DESC_PTR,
+	(struct dma_register *) MDMA_S1_NEXT_DESC_PTR,
 };
 #endif
 
@@ -130,7 +128,7 @@ int __init blackfin_dma_init(void)
 	for (i = 0; i < MAX_BLACKFIN_DMA_CHANNEL; i++) {
 		dma_ch[i].chan_status = DMA_CHANNEL_FREE;
 		dma_ch[i].regs = base_addr[i];
-		init_MUTEX(&(dma_ch[i].dmalock));
+		mutex_init(&(dma_ch[i].dmalock));
 	}
 
 	return 0;
@@ -288,11 +286,11 @@ int request_dma(unsigned int channel, ch
 {
 
 	pr_debug("request_dma() : BEGIN \n");
-	down(&(dma_ch[channel].dmalock));
+	mutex_lock(&(dma_ch[channel].dmalock));
 
 	if ((dma_ch[channel].chan_status == DMA_CHANNEL_REQUESTED)
 	    || (dma_ch[channel].chan_status == DMA_CHANNEL_ENABLED)) {
-		up(&(dma_ch[channel].dmalock));
+		mutex_unlock(&(dma_ch[channel].dmalock));
 		pr_debug("DMA CHANNEL IN USE  \n");
 		return -EBUSY;
 	} else {
@@ -300,7 +298,7 @@ int request_dma(unsigned int channel, ch
 		pr_debug("DMA CHANNEL IS ALLOCATED  \n");
 	}
 
-	up(&(dma_ch[channel].dmalock));
+	mutex_unlock(&(dma_ch[channel].dmalock));
 
 	dma_ch[channel].device_id = device_id;
 	dma_ch[channel].irq_callback = NULL;
@@ -312,13 +310,14 @@ int request_dma(unsigned int channel, ch
 	pr_debug("request_dma() : END  \n");
 	return channel;
 }
+EXPORT_SYMBOL(request_dma);
 
 int set_dma_callback(unsigned int channel, dma_interrupt_t callback, void *data)
 {
 	int ret_irq = 0;
 
-	assert(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_BLACKFIN_DMA_CHANNEL);
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	       && channel < MAX_BLACKFIN_DMA_CHANNEL));
 
 	if (callback != NULL) {
 		int ret_val;
@@ -338,14 +337,15 @@ int set_dma_callback(unsigned int channe
 	}
 	return 0;
 }
+EXPORT_SYMBOL(set_dma_callback);
 
 void free_dma(unsigned int channel)
 {
 	int ret_irq;
 
 	pr_debug("freedma() : BEGIN \n");
-	assert(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_BLACKFIN_DMA_CHANNEL);
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	       && channel < MAX_BLACKFIN_DMA_CHANNEL));
 
 	/* Halt the DMA */
 	disable_dma(channel);
@@ -357,36 +357,39 @@ void free_dma(unsigned int channel)
 	}
 
 	/* Clear the DMA Variable in the Channel */
-	down(&(dma_ch[channel].dmalock));
+	mutex_lock(&(dma_ch[channel].dmalock));
 	dma_ch[channel].chan_status = DMA_CHANNEL_FREE;
-	up(&(dma_ch[channel].dmalock));
+	mutex_unlock(&(dma_ch[channel].dmalock));
 
 	pr_debug("freedma() : END \n");
 }
+EXPORT_SYMBOL(free_dma);
 
 void dma_enable_irq(unsigned int channel)
 {
 	int ret_irq;
 
 	pr_debug("dma_enable_irq() : BEGIN \n");
-	assert(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_BLACKFIN_DMA_CHANNEL);
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	       && channel < MAX_BLACKFIN_DMA_CHANNEL));
 
 	ret_irq = channel2irq(channel);
 	enable_irq(ret_irq);
 }
+EXPORT_SYMBOL(dma_enable_irq);
 
 void dma_disable_irq(unsigned int channel)
 {
 	int ret_irq;
 
 	pr_debug("dma_disable_irq() : BEGIN \n");
-	assert(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_BLACKFIN_DMA_CHANNEL);
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	       && channel < MAX_BLACKFIN_DMA_CHANNEL));
 
 	ret_irq = channel2irq(channel);
 	disable_irq(ret_irq);
 }
+EXPORT_SYMBOL(dma_disable_irq);
 
 int dma_channel_active(unsigned int channel)
 {
@@ -396,6 +399,7 @@ int dma_channel_active(unsigned int chan
 		return 1;
 	}
 }
+EXPORT_SYMBOL(dma_channel_active);
 
 /*------------------------------------------------------------------------------
 *	stop the specific DMA channel.
@@ -404,8 +408,8 @@ void disable_dma(unsigned int channel)
 {
 	pr_debug("stop_dma() : BEGIN \n");
 
-	assert(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_BLACKFIN_DMA_CHANNEL);
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	       && channel < MAX_BLACKFIN_DMA_CHANNEL));
 
 	dma_ch[channel].regs->cfg &= ~DMAEN;	/* Clean the enable bit */
 	SSYNC();
@@ -414,13 +418,14 @@ void disable_dma(unsigned int channel)
 	pr_debug("stop_dma() : END \n");
 	return;
 }
+EXPORT_SYMBOL(disable_dma);
 
 void enable_dma(unsigned int channel)
 {
 	pr_debug("enable_dma() : BEGIN \n");
 
-	assert(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_BLACKFIN_DMA_CHANNEL);
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	       && channel < MAX_BLACKFIN_DMA_CHANNEL));
 
 	dma_ch[channel].chan_status = DMA_CHANNEL_ENABLED;
 	dma_ch[channel].regs->curr_x_count = 0;
@@ -431,6 +436,7 @@ void enable_dma(unsigned int channel)
 	pr_debug("enable_dma() : END \n");
 	return;
 }
+EXPORT_SYMBOL(enable_dma);
 
 /*------------------------------------------------------------------------------
 *		Set the Start Address register for the specific DMA channel
@@ -442,70 +448,77 @@ void set_dma_start_addr(unsigned int cha
 {
 	pr_debug("set_dma_start_addr() : BEGIN \n");
 
-	assert(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_BLACKFIN_DMA_CHANNEL);
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	       && channel < MAX_BLACKFIN_DMA_CHANNEL));
 
 	dma_ch[channel].regs->start_addr = addr;
 	SSYNC();
 	pr_debug("set_dma_start_addr() : END\n");
 }
+EXPORT_SYMBOL(set_dma_start_addr);
 
 void set_dma_next_desc_addr(unsigned int channel, unsigned long addr)
 {
 	pr_debug("set_dma_next_desc_addr() : BEGIN \n");
 
-	assert(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_BLACKFIN_DMA_CHANNEL);
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	       && channel < MAX_BLACKFIN_DMA_CHANNEL));
 
 	dma_ch[channel].regs->next_desc_ptr = addr;
 	SSYNC();
 	pr_debug("set_dma_start_addr() : END\n");
 }
+EXPORT_SYMBOL(set_dma_next_desc_addr);
 
 void set_dma_x_count(unsigned int channel, unsigned short x_count)
 {
-	assert(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_BLACKFIN_DMA_CHANNEL);
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	       && channel < MAX_BLACKFIN_DMA_CHANNEL));
 
 	dma_ch[channel].regs->x_count = x_count;
 	SSYNC();
 }
+EXPORT_SYMBOL(set_dma_x_count);
 
 void set_dma_y_count(unsigned int channel, unsigned short y_count)
 {
-	assert(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_BLACKFIN_DMA_CHANNEL);
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	       && channel < MAX_BLACKFIN_DMA_CHANNEL));
 
 	dma_ch[channel].regs->y_count = y_count;
 	SSYNC();
 }
+EXPORT_SYMBOL(set_dma_y_count);
 
 void set_dma_x_modify(unsigned int channel, short x_modify)
 {
-	assert(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_BLACKFIN_DMA_CHANNEL);
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	       && channel < MAX_BLACKFIN_DMA_CHANNEL));
 
 	dma_ch[channel].regs->x_modify = x_modify;
 	SSYNC();
 }
+EXPORT_SYMBOL(set_dma_x_modify);
 
 void set_dma_y_modify(unsigned int channel, short y_modify)
 {
-	assert(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_BLACKFIN_DMA_CHANNEL);
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	       && channel < MAX_BLACKFIN_DMA_CHANNEL));
 
 	dma_ch[channel].regs->y_modify = y_modify;
 	SSYNC();
 }
+EXPORT_SYMBOL(set_dma_y_modify);
 
 void set_dma_config(unsigned int channel, unsigned short config)
 {
-	assert(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_BLACKFIN_DMA_CHANNEL);
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	       && channel < MAX_BLACKFIN_DMA_CHANNEL));
 
 	dma_ch[channel].regs->cfg = config;
 	SSYNC();
 }
+EXPORT_SYMBOL(set_dma_config);
 
 unsigned short
 set_bfin_dma_config(char direction, char flow_mode,
@@ -518,11 +531,12 @@ set_bfin_dma_config(char direction, char
 	     (intr_mode << 6) | (flow_mode << 12) | RESTART);
 	return config;
 }
+EXPORT_SYMBOL(set_bfin_dma_config);
 
-void set_dma_sg(unsigned int channel, struct dmasg_t * sg, int nr_sg)
+void set_dma_sg(unsigned int channel, struct dmasg * sg, int nr_sg)
 {
-	assert(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_BLACKFIN_DMA_CHANNEL);
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	       && channel < MAX_BLACKFIN_DMA_CHANNEL));
 
 	dma_ch[channel].regs->cfg |= ((nr_sg & 0x0F) << 8);
 
@@ -530,49 +544,54 @@ void set_dma_sg(unsigned int channel, st
 
 	SSYNC();
 }
+EXPORT_SYMBOL(set_dma_sg);
 
 /*------------------------------------------------------------------------------
  *	Get the DMA status of a specific DMA channel from the system.
  *-----------------------------------------------------------------------------*/
 unsigned short get_dma_curr_irqstat(unsigned int channel)
 {
-	assert(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_BLACKFIN_DMA_CHANNEL);
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	       && channel < MAX_BLACKFIN_DMA_CHANNEL));
 
 	return dma_ch[channel].regs->irq_status;
 }
+EXPORT_SYMBOL(get_dma_curr_irqstat);
 
 /*------------------------------------------------------------------------------
  *	Clear the DMA_DONE bit in DMA status. Stop the DMA completion interrupt.
  *-----------------------------------------------------------------------------*/
 void clear_dma_irqstat(unsigned int channel)
 {
-	assert(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_BLACKFIN_DMA_CHANNEL);
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	       && channel < MAX_BLACKFIN_DMA_CHANNEL));
 	dma_ch[channel].regs->irq_status |= 3;
 }
+EXPORT_SYMBOL(clear_dma_irqstat);
 
 /*------------------------------------------------------------------------------
  *	Get current DMA xcount of a specific DMA channel from the system.
  *-----------------------------------------------------------------------------*/
 unsigned short get_dma_curr_xcount(unsigned int channel)
 {
-	assert(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_BLACKFIN_DMA_CHANNEL);
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	       && channel < MAX_BLACKFIN_DMA_CHANNEL));
 
 	return dma_ch[channel].regs->curr_x_count;
 }
+EXPORT_SYMBOL(get_dma_curr_xcount);
 
 /*------------------------------------------------------------------------------
  *	Get current DMA ycount of a specific DMA channel from the system.
  *-----------------------------------------------------------------------------*/
 unsigned short get_dma_curr_ycount(unsigned int channel)
 {
-	assert(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_BLACKFIN_DMA_CHANNEL);
+	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
+	       && channel < MAX_BLACKFIN_DMA_CHANNEL));
 
 	return dma_ch[channel].regs->curr_y_count;
 }
+EXPORT_SYMBOL(get_dma_curr_ycount);
 
 void *dma_memcpy(void *dest, const void *src, size_t size)
 {
@@ -709,6 +728,7 @@ void *dma_memcpy(void *dest, const void 
 
 	return dest;
 }
+EXPORT_SYMBOL(dma_memcpy);
 
 void *safe_dma_memcpy(void *dest, const void *src, size_t size)
 {
@@ -719,29 +739,4 @@ void *safe_dma_memcpy(void *dest, const 
 	local_irq_restore(flags);
 	return addr;
 }
-
-EXPORT_SYMBOL(request_dma);
-EXPORT_SYMBOL(set_dma_callback);
-EXPORT_SYMBOL(enable_dma);
-EXPORT_SYMBOL(disable_dma);
-EXPORT_SYMBOL(dma_channel_active);
-EXPORT_SYMBOL(free_dma);
-
-EXPORT_SYMBOL(get_dma_curr_irqstat);
-EXPORT_SYMBOL(clear_dma_irqstat);
-EXPORT_SYMBOL(get_dma_curr_xcount);
-EXPORT_SYMBOL(get_dma_curr_ycount);
-EXPORT_SYMBOL(set_dma_start_addr);
-
-EXPORT_SYMBOL(set_dma_config);
-EXPORT_SYMBOL(set_dma_next_desc_addr);
-EXPORT_SYMBOL(set_bfin_dma_config);
-EXPORT_SYMBOL(set_dma_x_count);
-EXPORT_SYMBOL(set_dma_x_modify);
-EXPORT_SYMBOL(set_dma_y_count);
-EXPORT_SYMBOL(set_dma_y_modify);
-EXPORT_SYMBOL(set_dma_sg);
-EXPORT_SYMBOL(dma_disable_irq);
-EXPORT_SYMBOL(dma_enable_irq);
-EXPORT_SYMBOL(dma_memcpy);
 EXPORT_SYMBOL(safe_dma_memcpy);
diff -puN arch/blackfin/kernel/bfin_gpio.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/kernel/bfin_gpio.c
--- a/arch/blackfin/kernel/bfin_gpio.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/kernel/bfin_gpio.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:  GPIO Abstraction Layer
  *
- * Rev:          $Id: bfin_gpio.c,v 1.10 2006/12/26 11:08:49 vapier Exp $
- *
  * Modified:
  *               Copyright 2006 Analog Devices Inc.
  *
@@ -88,17 +86,6 @@
 #include <asm/gpio.h>
 #include <linux/irq.h>
 
-#ifndef DEBUG
-#define assert(expr) do {} while(0)
-#else
-#define assert(expr) 						\
-	if (!(expr)) {						\
-	printk(KERN_INFO "Assertion failed! %s, %s, %s, line=%d \n",	\
-	#expr, __FILE__,__FUNCTION__,__LINE__); 		\
-	}
-#endif
-
-
 #ifdef BF533_FAMILY
 static struct gpio_port_t *gpio_bankb[gpio_bank(MAX_BLACKFIN_GPIOS)] = {
 	(struct gpio_port_t *) FIO_FLAG_D,
@@ -237,7 +224,7 @@ arch_initcall(bfin_gpio_init);
 void set_gpio_ ## name(unsigned short gpio, unsigned short arg) \
 { \
 	unsigned long flags; \
-	assert(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)); \
+	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio))); \
 	local_irq_save(flags); \
 	if (arg) \
 		gpio_bankb[gpio_bank(gpio)]->name |= gpio_bit(gpio); \
@@ -257,7 +244,7 @@ SET_GPIO(both)
 #define SET_GPIO_SC(name) \
 void set_gpio_ ## name(unsigned short gpio, unsigned short arg) \
 { \
-	assert(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)); \
+	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio))); \
 	if (arg) \
 		gpio_bankb[gpio_bank(gpio)]->name ## _set = gpio_bit(gpio); \
 	else \
@@ -272,7 +259,7 @@ SET_GPIO_SC(maskb)
 void set_gpio_data(unsigned short gpio, unsigned short arg)
 {
 	unsigned long flags;
-	assert(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio));
+	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	local_irq_save(flags);
 	if (arg)
 		gpio_bankb[gpio_bank(gpio)]->data_set = gpio_bit(gpio);
@@ -291,7 +278,7 @@ SET_GPIO_SC(data)
 void set_gpio_toggle(unsigned short gpio)
 {
 	unsigned long flags;
-	assert(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio));
+	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	local_irq_save(flags);
 	gpio_bankb[gpio_bank(gpio)]->toggle = gpio_bit(gpio);
 	bfin_read_CHIPID();
@@ -300,7 +287,7 @@ void set_gpio_toggle(unsigned short gpio
 #else
 void set_gpio_toggle(unsigned short gpio)
 {
-	assert(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio));
+	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	gpio_bankb[gpio_bank(gpio)]->toggle = gpio_bit(gpio);
 }
 #endif
@@ -329,7 +316,7 @@ SET_GPIO_P(maskb)
 void set_gpiop_data(unsigned short gpio, unsigned short arg)
 {
 	unsigned long flags;
-	assert(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio));
+	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	local_irq_save(flags);
 	gpio_bankb[gpio_bank(gpio)]->data = arg;
 	bfin_read_CHIPID();
@@ -365,7 +352,7 @@ unsigned short get_gpio_data(unsigned sh
 {
 	unsigned long flags;
 	unsigned short ret;
-	assert(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio));
+	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	local_irq_save(flags);
 	ret = 0x01 & (gpio_bankb[gpio_bank(gpio)]->data >> gpio_sub_n(gpio));
 	bfin_read_CHIPID();
@@ -399,7 +386,7 @@ unsigned short get_gpiop_data(unsigned s
 {
 	unsigned long flags;
 	unsigned short ret;
-	assert(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio));
+	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	local_irq_save(flags);
 	ret = gpio_bankb[gpio_bank(gpio)]->data;
 	bfin_read_CHIPID();
@@ -597,6 +584,7 @@ int gpio_request(unsigned short gpio, co
 
 	return 0;
 }
+EXPORT_SYMBOL(gpio_request);
 
 
 void gpio_free(unsigned short gpio)
@@ -621,34 +609,31 @@ void gpio_free(unsigned short gpio)
 
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL(gpio_free);
 
 
 void gpio_direction_input(unsigned short gpio)
 {
 	unsigned long flags;
 
-	assert(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio));
+	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 
 	local_irq_save(flags);
 	gpio_bankb[gpio_bank(gpio)]->dir &= ~gpio_bit(gpio);
 	gpio_bankb[gpio_bank(gpio)]->inen |= gpio_bit(gpio);
 	local_irq_restore(flags);
 }
-
+EXPORT_SYMBOL(gpio_direction_input);
 
 void gpio_direction_output(unsigned short gpio)
 {
 	unsigned long flags;
 
-	assert(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio));
+	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 
 	local_irq_save(flags);
 	gpio_bankb[gpio_bank(gpio)]->inen &= ~gpio_bit(gpio);
 	gpio_bankb[gpio_bank(gpio)]->dir |= gpio_bit(gpio);
 	local_irq_restore(flags);
 }
-
-EXPORT_SYMBOL(gpio_request);
-EXPORT_SYMBOL(gpio_free);
-EXPORT_SYMBOL(gpio_direction_input);
 EXPORT_SYMBOL(gpio_direction_output);
diff -puN arch/blackfin/kernel/bfin_ksyms.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/kernel/bfin_ksyms.c
--- a/arch/blackfin/kernel/bfin_ksyms.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/kernel/bfin_ksyms.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: bfin_ksyms.c,v 1.14 2005/10/18 04:23:57 magicyang Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/kernel/dma-mapping.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/kernel/dma-mapping.c
--- a/arch/blackfin/kernel/dma-mapping.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/kernel/dma-mapping.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:  Dynamic DMA mapping support.
  *
- * Rev:          $Id: dma-mapping.c,v 1.14 2006/08/03 17:37:02 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -126,6 +124,7 @@ void *dma_alloc_coherent(struct device *
 
 	return ret;
 }
+EXPORT_SYMBOL(dma_alloc_coherent);
 
 void
 dma_free_coherent(struct device *dev, size_t size, void *vaddr,
@@ -133,6 +132,7 @@ dma_free_coherent(struct device *dev, si
 {
 	__free_dma_pages((unsigned long)vaddr, get_pages(size));
 }
+EXPORT_SYMBOL(dma_free_coherent);
 
 /*
  * Dummy functions defined for some existing drivers
@@ -144,11 +144,12 @@ dma_map_single(struct device *dev, void 
 {
 	BUG_ON(direction == DMA_NONE);
 
-	blackfin_dcache_invalidate_range((unsigned long)ptr,
-					 (unsigned long)ptr + size);
+	invalidate_dcache_range((unsigned long)ptr,
+			(unsigned long)ptr + size);
 
 	return (dma_addr_t) ptr;
 }
+EXPORT_SYMBOL(dma_map_single);
 
 int
 dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
@@ -165,10 +166,18 @@ dma_map_sg(struct device *dev, struct sc
 
 	return nents;
 }
+EXPORT_SYMBOL(dma_map_sg);
 
-EXPORT_SYMBOL(dma_alloc_coherent);
-EXPORT_SYMBOL(dma_free_coherent);
-EXPORT_SYMBOL(dma_map_single);
+void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
+		enum dma_data_direction direction)
+{
+	BUG_ON(direction == DMA_NONE);
+}
 EXPORT_SYMBOL(dma_unmap_single);
-EXPORT_SYMBOL(dma_map_sg);
+
+void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
+		int nhwentries, enum dma_data_direction direction)
+{
+	BUG_ON(direction == DMA_NONE);
+}
 EXPORT_SYMBOL(dma_unmap_sg);
diff -puN arch/blackfin/kernel/dualcore_test.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/kernel/dualcore_test.c
--- a/arch/blackfin/kernel/dualcore_test.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/kernel/dualcore_test.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:  Small test code for CoreB on a BF561
  *
- * Rev:          $Id: dualcore_test.c,v 1.4 2006/08/03 17:37:02 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/kernel/entry.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/kernel/entry.S
--- a/arch/blackfin/kernel/entry.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/kernel/entry.S
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: entry.S,v 1.27 2006/12/13 08:23:00 sonicz Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -36,7 +34,11 @@
 
 #include <asm/mach-common/context.S>
 
+#ifdef CONFIG_EXCPT_IRQ_SYSC_L1
+.section .l1.text
+#else
 .text
+#endif
 
 ENTRY(_ret_from_fork)
 	SP += -12;
diff -puN /dev/null arch/blackfin/kernel/flat.c
--- /dev/null
+++ a/arch/blackfin/kernel/flat.c
@@ -0,0 +1,101 @@
+/*
+ *  arch/blackfin/kernel/flat.c
+ *
+ *  Copyright (C) 2007 Analog Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/flat.h>
+
+#define FLAT_BFIN_RELOC_TYPE_16_BIT 0
+#define FLAT_BFIN_RELOC_TYPE_16H_BIT 1
+#define FLAT_BFIN_RELOC_TYPE_32_BIT 2
+
+unsigned long bfin_get_addr_from_rp(unsigned long *ptr,
+		unsigned long relval,
+		unsigned long flags,
+		unsigned long *persistent)
+{
+	unsigned short *usptr = (unsigned short *)ptr;
+	int type = (relval >> 26) & 7;
+	unsigned long val;
+
+	switch (type) {
+		case FLAT_BFIN_RELOC_TYPE_16_BIT:
+		case FLAT_BFIN_RELOC_TYPE_16H_BIT:
+			usptr = (unsigned short *)ptr;
+			pr_debug("*usptr = %x", get_unaligned(usptr));
+			val = get_unaligned(usptr);
+			val += *persistent;
+			break;
+
+		case FLAT_BFIN_RELOC_TYPE_32_BIT:
+			pr_debug("*ptr = %lx", get_unaligned(ptr));
+			val = get_unaligned(ptr);
+			break;
+
+		default:
+			pr_debug("BINFMT_FLAT: Unknown relocation type %x\n",
+				type);
+
+			return 0;
+	}
+
+	/*
+	 * Stack-relative relocs contain the offset into the stack, we
+	 * have to add the stack's start address here and return 1 from
+	 * flat_addr_absolute to prevent the normal address calculations
+	 */
+	if (relval & (1 << 29))
+		return val + current->mm->context.end_brk;
+
+	if ((flags & FLAT_FLAG_GOTPIC) == 0)
+		val = htonl(val);
+	return val;
+}
+EXPORT_SYMBOL(bfin_get_addr_from_rp);
+
+/*
+ * Insert the address ADDR into the symbol reference at RP;
+ * RELVAL is the raw relocation-table entry from which RP is derived
+ */
+void bfin_put_addr_at_rp(unsigned long *ptr, unsigned long addr,
+		unsigned long relval)
+{
+	unsigned short *usptr = (unsigned short *)ptr;
+	int type = (relval >> 26) & 7;
+
+	switch (type) {
+		case FLAT_BFIN_RELOC_TYPE_16_BIT:
+			put_unaligned(addr, usptr);
+			pr_debug("new value %x at %p", get_unaligned(usptr),
+				usptr);
+			break;
+
+		case FLAT_BFIN_RELOC_TYPE_16H_BIT:
+			put_unaligned(addr >> 16, usptr);
+			pr_debug("new value %x", get_unaligned(usptr));
+			break;
+
+		case FLAT_BFIN_RELOC_TYPE_32_BIT:
+			put_unaligned(addr, ptr);
+			pr_debug("new ptr =%lx", get_unaligned(ptr));
+			break;
+	}
+}
+EXPORT_SYMBOL(bfin_put_addr_at_rp);
diff -puN arch/blackfin/kernel/init_task.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/kernel/init_task.c
--- a/arch/blackfin/kernel/init_task.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/kernel/init_task.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:  This file contains the simple DMA Implementation for Blackfin
  *
- * Rev:          $Id: init_task.c,v 1.7 2006/08/03 17:37:02 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -38,8 +36,8 @@ static struct fs_struct init_fs = INIT_F
 static struct files_struct init_files = INIT_FILES;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
 
+struct mm_struct init_mm = INIT_MM(init_mm);
 EXPORT_SYMBOL(init_mm);
 
 /*
@@ -48,7 +46,6 @@ EXPORT_SYMBOL(init_mm);
  * All other task structs will be allocated on slabs in fork.c
  */
 struct task_struct init_task = INIT_TASK(init_task);
-
 EXPORT_SYMBOL(init_task);
 
 /*
diff -puN arch/blackfin/kernel/irqchip.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/kernel/irqchip.c
--- a/arch/blackfin/kernel/irqchip.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/kernel/irqchip.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:  This file contains the simple DMA Implementation for Blackfin
  *
- * Rev:          $Id: irqchip.c,v 1.18 2006/08/03 17:37:02 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -97,6 +95,11 @@ int show_interrupts(struct seq_file *p, 
  * come via this function.  Instead, they should provide their
  * own 'handler'
  */
+
+#ifdef CONFIG_DO_IRQ_L1
+asmlinkage void asm_do_IRQ(unsigned int irq, struct pt_regs *regs)__attribute__((l1_text));
+#endif
+
 asmlinkage void asm_do_IRQ(unsigned int irq, struct pt_regs *regs)
 {
 	struct pt_regs *old_regs;
diff -puN arch/blackfin/kernel/module.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/kernel/module.c
--- a/arch/blackfin/kernel/module.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/kernel/module.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: module.c 2693 2007-01-25 09:27:19Z hennerich $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/kernel/process.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/kernel/process.c
--- a/arch/blackfin/kernel/process.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/kernel/process.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:  Blackfin architecture-dependent process handling.
  *
- * Rev:          $Id: process.c,v 1.30 2005/10/28 04:02:10 magicyang Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -97,7 +95,12 @@ static inline void leds_switch(int flag)
 /*
  * The idle loop on BFIN
  */
-static inline void default_idle(void)
+#ifdef CONFIG_IDLE_L1
+void default_idle(void)__attribute__((l1_text));
+void cpu_idle(void)__attribute__((l1_text));
+#endif
+
+void default_idle(void)
 {
 	while (!need_resched()) {
 		leds_switch(LED_OFF);
@@ -144,13 +147,13 @@ void machine_restart(char *__unused)
 void machine_halt(void)
 {
 	for (;;)
-		/* nothing */ ;
+		asm volatile ("idle");
 }
 
 void machine_power_off(void)
 {
 	for (;;)
-		/* nothing */ ;
+		asm volatile ("idle");
 }
 
 void show_regs(struct pt_regs *regs)
@@ -346,3 +349,46 @@ unsigned long get_wchan(struct task_stru
 	while (count++ < 16);
 	return 0;
 }
+
+#if defined(CONFIG_ACCESS_CHECK)
+int _access_ok(unsigned long addr, unsigned long size)
+{
+
+	if (addr > (addr + size))
+		return 0;
+	if (segment_eq(get_fs(),KERNEL_DS))
+		return 1;
+#ifdef CONFIG_MTD_UCLINUX
+	if (addr >= memory_start && (addr + size) <= memory_end)
+		return 1;
+	if (addr >= memory_mtd_end && (addr + size) <= physical_mem_end)
+		return 1;
+#else
+	if (addr >= memory_start && (addr + size) <= physical_mem_end)
+		return 1;
+#endif
+	if (addr >= (unsigned long)__init_begin &&
+	    addr + size <= (unsigned long)__init_end)
+		return 1;
+	if (addr >= L1_SCRATCH_START
+	    && addr + size <= L1_SCRATCH_START + L1_SCRATCH_LENGTH)
+		return 1;
+#if L1_CODE_LENGTH != 0
+	if (addr >= L1_CODE_START + (_etext_l1 - _stext_l1)
+	    && addr + size <= L1_CODE_START + L1_CODE_LENGTH)
+		return 1;
+#endif
+#if L1_DATA_A_LENGTH != 0
+	if (addr >= L1_DATA_A_START + (_ebss_l1 - _sdata_l1)
+	    && addr + size <= L1_DATA_A_START + L1_DATA_A_LENGTH)
+		return 1;
+#endif
+#if L1_DATA_B_LENGTH != 0
+	if (addr >= L1_DATA_B_START
+	    && addr + size <= L1_DATA_B_START + L1_DATA_B_LENGTH)
+		return 1;
+#endif
+	return 0;
+}
+EXPORT_SYMBOL(_access_ok);
+#endif /* CONFIG_ACCESS_CHECK */
diff -puN arch/blackfin/kernel/ptrace.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/kernel/ptrace.c
--- a/arch/blackfin/kernel/ptrace.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/kernel/ptrace.c
@@ -6,8 +6,6 @@
  * Created:      1/23/92
  * Description:
  *
- * Rev:          $Id: ptrace.c,v 1.50 2006/11/01 04:47:43 magicyang Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -45,6 +43,7 @@
 #include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/asm-offsets.h>
+#include <asm/dma.h>
 
 #define MAX_SHARED_LIBS 3
 #define TEXT_OFFSET 0
@@ -194,7 +193,7 @@ long arch_ptrace(struct task_struct *chi
 	switch (request) {
 		/* when I and D space are separate, these will need to be fixed. */
 	case PTRACE_PEEKDATA:
-		pr_debug("PTRACE_PEEKDATA\n");
+		pr_debug("ptrace: PEEKDATA\n");
 		add = MAX_SHARED_LIBS * 4;	/* space between text and data */
 		/* fall through */
 	case PTRACE_PEEKTEXT:	/* read word at location addr. */
@@ -203,15 +202,23 @@ long arch_ptrace(struct task_struct *chi
 			int copied;
 
 			ret = -EIO;
-			pr_debug("PEEKTEXT at addr %lx + add %d %ld", addr, add,
+			pr_debug("ptrace: PEEKTEXT at addr 0x%08lx + add %d %ld\n", addr, add,
 			         sizeof(data));
 			if (is_user_addr_valid(child, addr + add, sizeof(tmp)) < 0)
 				break;
+			pr_debug("ptrace: user address is valid\n");
 
+#if L1_CODE_LENGTH != 0
+			if (addr + add >= L1_CODE_START
+			    && addr + add + sizeof(tmp) <= L1_CODE_START + L1_CODE_LENGTH) {
+				safe_dma_memcpy (&tmp, (const void *)(addr + add), sizeof(tmp));
+				copied = sizeof(tmp);
+			} else
+#endif
 			copied =
 			    access_process_vm(child, addr + add, &tmp,
 					      sizeof(tmp), 0);
-			pr_debug(" bytes %lx\n", data);
+			pr_debug("ptrace: copied size %d [0x%08lx]\n", copied, tmp);
 			if (copied != sizeof(tmp))
 				break;
 			ret = put_user(tmp, (unsigned long *)data);
@@ -258,15 +265,27 @@ long arch_ptrace(struct task_struct *chi
 		/* fall through */
 	case PTRACE_POKETEXT:	/* write the word at location addr. */
 		{
+			int copied;
+
 			ret = -EIO;
-			pr_debug("POKETEXT at addr %lx + add %d %ld bytes %lx\n",
+			pr_debug("ptrace: POKETEXT at addr 0x%08lx + add %d %ld bytes %lx\n",
 			         addr, add, sizeof(data), data);
 			if (is_user_addr_valid(child, addr + add, sizeof(data)) < 0)
 				break;
+			pr_debug("ptrace: user address is valid\n");
 
-			if (access_process_vm(child, addr + add,
-					      &data, sizeof(data),
-					      1) != sizeof(data))
+#if L1_CODE_LENGTH != 0
+			if (addr + add >= L1_CODE_START
+			    && addr + add + sizeof(data) <= L1_CODE_START + L1_CODE_LENGTH) {
+				safe_dma_memcpy ((void *)(addr + add), &data, sizeof(data));
+				copied = sizeof(data);
+			} else
+#endif
+			copied =
+			    access_process_vm(child, addr + add, &data,
+					      sizeof(data), 1);
+			pr_debug("ptrace: copied size %d\n", copied);
+			if (copied != sizeof(data))
 				break;
 			ret = 0;
 			break;
@@ -377,9 +396,7 @@ long arch_ptrace(struct task_struct *chi
 			break;
 		}
 	default:
-		printk(KERN_NOTICE "ptrace: *** Unhandled case **** %d\n",
-		       (int)request);
-		ret = -EIO;
+		ret = ptrace_request(child, request, addr, data);
 		break;
 	}
 
diff -puN arch/blackfin/kernel/setup.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/kernel/setup.c
--- a/arch/blackfin/kernel/setup.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/kernel/setup.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: setup.c 2708 2007-01-31 02:36:48Z aubrey $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -45,13 +43,6 @@
 #include <asm/blackfin.h>
 #include <asm/cplbinit.h>
 
-#ifdef CONFIG_CONSOLE
-struct consw *conswitchp;
-#ifdef CONFIG_FRAMEBUFFER
-struct consw fb_con;
-#endif
-#endif
-
 unsigned long memory_start, memory_end, physical_mem_end;
 unsigned long reserved_mem_dcache_on;
 unsigned long reserved_mem_icache_on;
@@ -70,7 +61,6 @@ EXPORT_SYMBOL(mtd_size);
 
 char command_line[COMMAND_LINE_SIZE];
 
-extern void init_leds(void);
 #if defined(CONFIG_BLKFIN_DCACHE) || defined(CONFIG_BLKFIN_CACHE)
 static void generate_cpl_tables(void);
 #endif
@@ -220,10 +210,9 @@ void __init setup_arch(char **cmdline_p)
 	flash_probe();
 #endif
 
-#if defined(CONFIG_BOOTPARAM)
+#if defined(CONFIG_CMDLINE_BOOL)
 	memset(command_line, 0, sizeof(command_line));
-	strncpy(&command_line[0], CONFIG_BOOTPARAM_STRING,
-		sizeof(command_line));
+	strncpy(&command_line[0], CONFIG_CMDLINE, sizeof(command_line));
 	command_line[sizeof(command_line) - 1] = 0;
 #endif
 
@@ -309,6 +298,9 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_NOTICE "Warning: limiting memory to %liMB due to hardware anomaly 05000263\n", memory_end >> 20);
 #endif				/* ANOMALY_05000263 */
 
+#if !defined(CONFIG_MTD_UCLINUX)
+	memory_end -= SIZE_4K; /*In case there is no valid CPLB behind memory_end make sure we don't get to close*/
+#endif
 	init_mm.start_code = (unsigned long)_stext;
 	init_mm.end_code = (unsigned long)_etext;
 	init_mm.end_data = (unsigned long)_edata;
@@ -371,14 +363,6 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	       );
 
-#ifdef CONFIG_CONSOLE
-#ifdef CONFIG_FRAMEBUFFER
-	conswitchp = &fb_con;
-#else
-	conswitchp = 0;
-#endif
-#endif
-
 	/*
 	 * give all the memory to the bootmap allocator,  tell it to put the
 	 * boot mem_map at the start of memory
@@ -447,8 +431,8 @@ subsys_initcall(topology_init);
 #if defined(CONFIG_BLKFIN_DCACHE) || defined(CONFIG_BLKFIN_CACHE)
 u16 lock_kernel_check(u32 start, u32 end)
 {
-	if ((start <= (u32) _stext && end >= (u32) __bss_stop)
-	    || (start >= (u32) _stext && end <= (u32) __bss_stop))
+	if ((start <= (u32) _stext && end >= (u32) _end)
+	    || (start >= (u32) _stext && end <= (u32) _end))
 		return IN_KERNEL;
 	return 0;
 }
@@ -538,6 +522,20 @@ static void __init generate_cpl_tables(v
 	cplb_data[SDRAM_RAM_MTD].valid = mtd_size > 0;
 # if defined(CONFIG_ROMFS_FS)
 	cplb_data[SDRAM_RAM_MTD].attr |= I_CPLB;
+
+	/*
+	 * The ROMFS_FS size is often not multiple of 1MB.
+	 * This can cause multiple CPLB sets covering the same memory area.
+	 * This will then cause multiple CPLB hit exceptions.
+	 * Workaround: We ensure a contiguous memory area by extending the kernel
+	 * memory section over the mtd section.
+	 * For ROMFS_FS memory must be covered with ICPLBs anyways.
+	 * So there is no difference between kernel and mtd memory setup.
+	 */
+
+	cplb_data[SDRAM_KERN].end = memory_mtd_start + mtd_size;;
+	cplb_data[SDRAM_RAM_MTD].valid = 0;
+
 # endif
 #else
 	cplb_data[SDRAM_RAM_MTD].valid = 0;
@@ -763,16 +761,12 @@ static int show_cpuinfo(struct seq_file 
 #endif
 
 	u_long cclk = 0, sclk = 0;
-	u_int id;
+	u_int id, dcache_size = 0, dsup_banks = 0;
 
 	cpu = CPU;
 	mmu = "none";
 	fpu = "none";
-	if (&bfin_board_name) {
-		name = bfin_board_name;
-	} else {
-		name = "Unknown";
-	}
+	name = bfin_board_name;
 
 	cclk = get_cclk();
 	sclk = get_sclk();
@@ -808,13 +802,36 @@ static int show_cpuinfo(struct seq_file 
 			   "\n");
 	else
 		seq_printf(m, "D-CACHE:\tOFF\n");
+
+
+	switch(bfin_read_DMEM_CONTROL() & (1 << DMC0_P | 1 << DMC1_P)) {
+		case ACACHE_BSRAM:
+			seq_printf(m, "DBANK-A:\tCACHE\n" "DBANK-B:\tSRAM\n");
+			dcache_size = 16;
+			dsup_banks = 1;
+			break;
+		case ACACHE_BCACHE:
+			seq_printf(m, "DBANK-A:\tCACHE\n" "DBANK-B:\tCACHE\n");
+			dcache_size = 32;
+			dsup_banks = 2;
+			break;
+		case ASRAM_BSRAM:
+			seq_printf(m, "DBANK-A:\tSRAM\n" "DBANK-B:\tSRAM\n");
+			dcache_size = 0;
+			dsup_banks = 0;
+			break;
+		default:
+		break;
+	}
+
+
 	seq_printf(m, "I-CACHE Size:\t%dKB\n", BLKFIN_ICACHESIZE / 1024);
-	seq_printf(m, "D-CACHE Size:\t%dKB\n", BLKFIN_DCACHESIZE / 1024);
+	seq_printf(m, "D-CACHE Size:\t%dKB\n", dcache_size);
 	seq_printf(m, "I-CACHE Setup:\t%d Sub-banks/%d Ways, %d Lines/Way\n",
 		   BLKFIN_ISUBBANKS, BLKFIN_IWAYS, BLKFIN_ILINES);
 	seq_printf(m,
 		   "D-CACHE Setup:\t%d Super-banks/%d Sub-banks/%d Ways, %d Lines/Way\n",
-		   BLKFIN_DSUPBANKS, BLKFIN_DSUBBANKS, BLKFIN_DWAYS,
+		   dsup_banks, BLKFIN_DSUBBANKS, BLKFIN_DWAYS,
 		   BLKFIN_DLINES);
 #ifdef CONFIG_BLKFIN_CACHE_LOCK
 	lock = read_iloc();
diff -puN arch/blackfin/kernel/signal.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/kernel/signal.c
--- a/arch/blackfin/kernel/signal.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/kernel/signal.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: signal.c,v 1.38 2006/12/13 08:23:01 sonicz Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -29,14 +27,6 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-/*
- * ++roman (07/09/96): implemented signal stacks (specially for tosemu on
- * Atari :-) Current limitation: Only one sigstack can be active at one time.
- * If a second signal with SA_ONSTACK set arrives while working on a sigstack,
- * SA_ONSTACK is ignored. This behaviour avoids lots of trouble with nested
- * signal handlers!
- */
-
 #include <linux/signal.h>
 #include <linux/syscalls.h>
 #include <linux/ptrace.h>
@@ -57,7 +47,6 @@ struct fdpic_func_descriptor {
 };
 
 struct rt_sigframe {
-	char *pretcode;
 	int sig;
 	struct siginfo *pinfo;
 	void *puc;
@@ -66,78 +55,46 @@ struct rt_sigframe {
 	struct ucontext uc;
 };
 
+asmlinkage int sys_sigaltstack(const stack_t * uss, stack_t * uoss)
+{
+	return do_sigaltstack(uss, uoss, rdusp());
+}
+
 static inline int
-rt_restore_ucontext(struct pt_regs *regs, struct ucontext *uc, int *pr0)
+rt_restore_sigcontext(struct pt_regs *regs, struct sigcontext *sc, int *pr0)
 {
-	int temp = 0;
-	greg_t *gregs = uc->uc_mcontext.gregs;
 	unsigned long usp = 0;
-	int err;
+	int err = 0;
+
+#define RESTORE(x) err |= __get_user(regs->x, &sc->sc_##x)
 
-	err = __get_user(temp, &uc->uc_mcontext.version);
-	if (temp != MCONTEXT_VERSION)
-		goto badframe;
 	/* restore passed registers */
-	err |= __get_user(regs->r0, &gregs[0]);
-	err |= __get_user(regs->r1, &gregs[1]);
-	err |= __get_user(regs->r2, &gregs[2]);
-	err |= __get_user(regs->r3, &gregs[3]);
-	err |= __get_user(regs->r4, &gregs[4]);
-	err |= __get_user(regs->r5, &gregs[5]);
-	err |= __get_user(regs->r6, &gregs[6]);
-	err |= __get_user(regs->r7, &gregs[7]);
-	err |= __get_user(regs->p0, &gregs[8]);
-	err |= __get_user(regs->p1, &gregs[9]);
-	err |= __get_user(regs->p2, &gregs[10]);
-	err |= __get_user(regs->p3, &gregs[11]);
-	err |= __get_user(regs->p4, &gregs[12]);
-	err |= __get_user(regs->p5, &gregs[13]);
-	err |= __get_user(usp, &gregs[14]);
+	RESTORE(r0); RESTORE(r1); RESTORE(r2); RESTORE(r3);
+	RESTORE(r4); RESTORE(r5); RESTORE(r6); RESTORE(r7);
+	RESTORE(p0); RESTORE(p1); RESTORE(p2); RESTORE(p3);
+	RESTORE(p4); RESTORE(p5);
+	err |= __get_user(usp, &sc->sc_usp);
 	wrusp(usp);
-	err |= __get_user(regs->a0w, &gregs[15]);
-	err |= __get_user(regs->a1w, &gregs[16]);
-	err |= __get_user(regs->a0x, &gregs[17]);
-	err |= __get_user(regs->a1x, &gregs[18]);
-	err |= __get_user(regs->astat, &gregs[19]);
-	err |= __get_user(regs->rets, &gregs[20]);
-	err |= __get_user(regs->pc, &gregs[21]);
-	err |= __get_user(regs->retx, &gregs[22]);
-
-	err |= __get_user(regs->fp, &gregs[23]);
-	err |= __get_user(regs->i0, &gregs[24]);
-	err |= __get_user(regs->i1, &gregs[25]);
-	err |= __get_user(regs->i2, &gregs[26]);
-	err |= __get_user(regs->i3, &gregs[27]);
-	err |= __get_user(regs->m0, &gregs[28]);
-	err |= __get_user(regs->m1, &gregs[29]);
-	err |= __get_user(regs->m2, &gregs[30]);
-	err |= __get_user(regs->m3, &gregs[31]);
-	err |= __get_user(regs->l0, &gregs[32]);
-	err |= __get_user(regs->l1, &gregs[33]);
-	err |= __get_user(regs->l2, &gregs[34]);
-	err |= __get_user(regs->l3, &gregs[35]);
-	err |= __get_user(regs->b0, &gregs[36]);
-	err |= __get_user(regs->b1, &gregs[37]);
-	err |= __get_user(regs->b2, &gregs[38]);
-	err |= __get_user(regs->b3, &gregs[39]);
-	err |= __get_user(regs->lc0, &gregs[40]);
-	err |= __get_user(regs->lc1, &gregs[41]);
-	err |= __get_user(regs->lt0, &gregs[42]);
-	err |= __get_user(regs->lt1, &gregs[43]);
-	err |= __get_user(regs->lb0, &gregs[44]);
-	err |= __get_user(regs->lb1, &gregs[45]);
-	err |= __get_user(regs->seqstat, &gregs[46]);
+	RESTORE(a0w); RESTORE(a1w);
+	RESTORE(a0x); RESTORE(a1x);
+	RESTORE(astat);
+	RESTORE(rets);
+	RESTORE(pc);
+	RESTORE(retx);
+	RESTORE(fp);
+	RESTORE(i0); RESTORE(i1); RESTORE(i2); RESTORE(i3);
+	RESTORE(m0); RESTORE(m1); RESTORE(m2); RESTORE(m3);
+	RESTORE(l0); RESTORE(l1); RESTORE(l2); RESTORE(l3);
+	RESTORE(b0); RESTORE(b1); RESTORE(b2); RESTORE(b3);
+	RESTORE(lc0); RESTORE(lc1);
+	RESTORE(lt0); RESTORE(lt1);
+	RESTORE(lb0); RESTORE(lb1);
+	RESTORE(seqstat);
 
 	regs->orig_p0 = -1;	/* disable syscall checks */
 
-	if (do_sigaltstack(&uc->uc_stack, NULL, usp) == -EFAULT)
-		goto badframe;
-
 	*pr0 = regs->r0;
 	return err;
-
-      badframe:
-	return 1;
 }
 
 asmlinkage int do_rt_sigreturn(unsigned long __unused)
@@ -159,8 +116,12 @@ asmlinkage int do_rt_sigreturn(unsigned 
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
-	if (rt_restore_ucontext(regs, &frame->uc, &r0))
+	if (rt_restore_sigcontext(regs, &frame->uc.uc_mcontext, &r0))
+		goto badframe;
+
+	if (do_sigaltstack(&frame->uc.uc_stack, NULL, regs->usp) == -EFAULT)
 		goto badframe;
+
 	return r0;
 
       badframe:
@@ -168,60 +129,33 @@ asmlinkage int do_rt_sigreturn(unsigned 
 	return 0;
 }
 
-static inline int rt_setup_ucontext(struct ucontext *uc, struct pt_regs *regs)
+static inline int rt_setup_sigcontext(struct sigcontext *sc, struct pt_regs *regs)
 {
-	greg_t *gregs = uc->uc_mcontext.gregs;
 	int err = 0;
 
-	err |= __put_user(MCONTEXT_VERSION, &uc->uc_mcontext.version);
-	err |= __put_user(regs->r0, &gregs[0]);
-	err |= __put_user(regs->r1, &gregs[1]);
-	err |= __put_user(regs->r2, &gregs[2]);
-	err |= __put_user(regs->r3, &gregs[3]);
-	err |= __put_user(regs->r4, &gregs[4]);
-	err |= __put_user(regs->r5, &gregs[5]);
-	err |= __put_user(regs->r6, &gregs[6]);
-	err |= __put_user(regs->r7, &gregs[7]);
-	err |= __put_user(regs->p0, &gregs[8]);
-	err |= __put_user(regs->p1, &gregs[9]);
-	err |= __put_user(regs->p2, &gregs[10]);
-	err |= __put_user(regs->p3, &gregs[11]);
-	err |= __put_user(regs->p4, &gregs[12]);
-	err |= __put_user(regs->p5, &gregs[13]);
-	err |= __put_user(rdusp(), &gregs[14]);
-	err |= __put_user(regs->a0w, &gregs[15]);
-	err |= __put_user(regs->a1w, &gregs[16]);
-	err |= __put_user(regs->a0x, &gregs[17]);
-	err |= __put_user(regs->a1x, &gregs[18]);
-	err |= __put_user(regs->astat, &gregs[19]);
-	err |= __put_user(regs->rets, &gregs[20]);
-	err |= __put_user(regs->pc, &gregs[21]);
-	err |= __put_user(regs->retx, &gregs[22]);
-
-	err |= __put_user(regs->fp, &gregs[23]);
-	err |= __put_user(regs->i0, &gregs[24]);
-	err |= __put_user(regs->i1, &gregs[25]);
-	err |= __put_user(regs->i2, &gregs[26]);
-	err |= __put_user(regs->i3, &gregs[27]);
-	err |= __put_user(regs->m0, &gregs[28]);
-	err |= __put_user(regs->m1, &gregs[29]);
-	err |= __put_user(regs->m2, &gregs[30]);
-	err |= __put_user(regs->m3, &gregs[31]);
-	err |= __put_user(regs->l0, &gregs[32]);
-	err |= __put_user(regs->l1, &gregs[33]);
-	err |= __put_user(regs->l2, &gregs[34]);
-	err |= __put_user(regs->l3, &gregs[35]);
-	err |= __put_user(regs->b0, &gregs[36]);
-	err |= __put_user(regs->b1, &gregs[37]);
-	err |= __put_user(regs->b2, &gregs[38]);
-	err |= __put_user(regs->b3, &gregs[39]);
-	err |= __put_user(regs->lc0, &gregs[40]);
-	err |= __put_user(regs->lc1, &gregs[41]);
-	err |= __put_user(regs->lt0, &gregs[42]);
-	err |= __put_user(regs->lt1, &gregs[43]);
-	err |= __put_user(regs->lb0, &gregs[44]);
-	err |= __put_user(regs->lb1, &gregs[45]);
-	err |= __put_user(regs->seqstat, &gregs[46]);
+#define SETUP(x) err |= __put_user(regs->x, &sc->sc_##x)
+
+	SETUP(r0); SETUP(r1); SETUP(r2); SETUP(r3);
+	SETUP(r4); SETUP(r5); SETUP(r6); SETUP(r7);
+	SETUP(p0); SETUP(p1); SETUP(p2); SETUP(p3);
+	SETUP(p4); SETUP(p5);
+	err |= __put_user(rdusp(), &sc->sc_usp);
+	SETUP(a0w); SETUP(a1w);
+	SETUP(a0x); SETUP(a1x);
+	SETUP(astat);
+	SETUP(rets);
+	SETUP(pc);
+	SETUP(retx);
+	SETUP(fp);
+	SETUP(i0); SETUP(i1); SETUP(i2); SETUP(i3);
+	SETUP(m0); SETUP(m1); SETUP(m2); SETUP(m3);
+	SETUP(l0); SETUP(l1); SETUP(l2); SETUP(l3);
+	SETUP(b0); SETUP(b1); SETUP(b2); SETUP(b3);
+	SETUP(lc0); SETUP(lc1);
+	SETUP(lt0); SETUP(lt1);
+	SETUP(lb0); SETUP(lb1);
+	SETUP(seqstat);
+
 	return err;
 }
 
@@ -262,8 +196,6 @@ setup_rt_frame(int sig, struct k_sigacti
 			   signal_invmap[sig] : sig), &frame->sig);
 
 	err |= __put_user(&frame->info, &frame->pinfo);
-
-	err |= __put_user(&frame->info, &frame->pinfo);
 	err |= __put_user(&frame->uc, &frame->puc);
 	err |= copy_siginfo_to_user(&frame->info, info);
 
@@ -274,11 +206,10 @@ setup_rt_frame(int sig, struct k_sigacti
 	    __put_user((void *)current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
 	err |= __put_user(sas_ss_flags(rdusp()), &frame->uc.uc_stack.ss_flags);
 	err |= __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
-	err |= rt_setup_ucontext(&frame->uc, regs);
+	err |= rt_setup_sigcontext(&frame->uc.uc_mcontext, regs);
 	err |= copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 
 	/* Set up to return from userspace.  */
-	err |= __put_user(frame->retcode, &frame->pretcode);
 	err |= __put_user(0x28, &(frame->retcode[0]));
 	err |= __put_user(0xe1, &(frame->retcode[1]));
 	err |= __put_user(0xad, &(frame->retcode[2]));
@@ -306,9 +237,6 @@ setup_rt_frame(int sig, struct k_sigacti
 	regs->r1 = (unsigned long)(&frame->info);
 	regs->r2 = (unsigned long)(&frame->uc);
 
-	if (regs->seqstat)
-		regs->retx = (unsigned long)ka->sa.sa_handler;
-
 	return 0;
 
       give_sigsegv:
@@ -360,9 +288,6 @@ handle_signal(int sig, siginfo_t *info, 
 	/* set up the stack frame */
 	ret = setup_rt_frame(sig, ka, info, oldset, regs);
 
-	if (ka->sa.sa_flags & SA_ONESHOT)
-		ka->sa.sa_handler = SIG_DFL;
-
 	if (ret == 0) {
 		spin_lock_irq(&current->sighand->siglock);
 		sigorsets(&current->blocked, &current->blocked,
diff -puN arch/blackfin/kernel/sys_bfin.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/kernel/sys_bfin.c
--- a/arch/blackfin/kernel/sys_bfin.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/kernel/sys_bfin.c
@@ -8,8 +8,6 @@
  *               have a non-standard calling sequence on the Linux/bfin
  *               platform.
  *
- * Rev:          $Id: sys_bfin.c,v 1.19 2006/12/21 01:39:03 sonicz Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -115,19 +113,3 @@ asmlinkage void *sys_dma_memcpy(void *de
 {
 	return safe_dma_memcpy(dest, src, len);
 }
-
-/*
- * Do a system call from kernel instead of calling sys_execve so we
- * end up with proper pt_regs.
- */
-int kernel_execve(const char *filename, char *const argv[], char *const envp[])
-{
-       register long __res asm ("P0") = __NR_execve;
-       register long __a asm ("R0") = (long)(filename);
-       register long __b asm ("R1") = (long)(argv);
-       register long __c asm ("R2") = (long)(envp);
-       asm volatile ("raise 15" : "+d" (__a)
-                       : "d" (__res), "d" (__b), "d" (__c));
-       return __a;
-}
-
diff -puN arch/blackfin/kernel/time.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/kernel/time.c
--- a/arch/blackfin/kernel/time.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/kernel/time.c
@@ -7,8 +7,6 @@
  * Description:  This file contains the bfin-specific time handling details.
  *               Most of the stuff is located in the machine specific files.
  *
- * Rev:          $Id: time.c 2715 2007-02-02 03:31:29Z vapier $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -34,10 +32,9 @@
 #include <linux/profile.h>
 #include <linux/interrupt.h>
 #include <linux/time.h>
+#include <linux/irq.h>
 
 #include <asm/blackfin.h>
-#include <asm/irq.h>
-#include <asm/irq_regs.h>
 
 /* This is an NTP setting */
 #define	TICK_SIZE (tick_nsec / 1000)
@@ -45,7 +42,6 @@
 static void time_sched_init(irqreturn_t(*timer_routine)
 			(int, void *));
 static unsigned long gettimeoffset(void);
-extern int setup_irq(unsigned int irq, struct irqaction *handler);
 static inline void do_leds(void);
 
 #if (defined(CONFIG_BFIN_ALIVE_LED) || defined(CONFIG_BFIN_IDLE_LED))
@@ -197,6 +193,10 @@ static inline int set_rtc_mmss(unsigned 
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
  */
+#ifdef CONFIG_CORE_TIMER_IRQ_L1
+irqreturn_t timer_interrupt(int irq, void *dummy)__attribute__((l1_text));
+#endif
+
 irqreturn_t timer_interrupt(int irq, void *dummy)
 {
 	/* last time the cmos clock got updated */
@@ -243,7 +243,7 @@ void __init time_init(void)
 	 * userspace to have to deal with time values greater than
 	 * 2^31 seconds (which uClibc cannot cope with yet)
 	 */
-	if (bfin_read_RTC_STAT() & 0x60000000) {
+	if ((bfin_read_RTC_STAT() & 0xC0000000) == 0xC0000000) {
 		printk(KERN_NOTICE "bfin-rtc: invalid date; resetting\n");
 		bfin_write_RTC_STAT(0);
 	}
@@ -258,6 +258,7 @@ void __init time_init(void)
 	time_sched_init(timer_interrupt);
 }
 
+#ifndef CONFIG_GENERIC_TIME
 void do_gettimeofday(struct timeval *tv)
 {
 	unsigned long flags;
@@ -280,7 +281,6 @@ void do_gettimeofday(struct timeval *tv)
 	tv->tv_sec = sec;
 	tv->tv_usec = usec;
 }
-
 EXPORT_SYMBOL(do_gettimeofday);
 
 int do_settimeofday(struct timespec *tv)
@@ -314,6 +314,8 @@ int do_settimeofday(struct timespec *tv)
 
 	return 0;
 }
+EXPORT_SYMBOL(do_settimeofday);
+#endif /* !CONFIG_GENERIC_TIME */
 
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -322,5 +324,3 @@ unsigned long long sched_clock(void)
 {
 	return (unsigned long long)jiffies *(NSEC_PER_SEC / HZ);
 }
-
-EXPORT_SYMBOL(do_settimeofday);
diff -puN arch/blackfin/kernel/traps.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/kernel/traps.c
--- a/arch/blackfin/kernel/traps.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/kernel/traps.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:  uses S/W interrupt 15 for the system calls
  *
- * Rev:          $Id: traps.c,v 1.83 2006/12/26 11:24:36 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -34,6 +32,7 @@
 #include <asm/cacheflush.h>
 #include <asm/blackfin.h>
 #include <asm/uaccess.h>
+#include <asm/irq_handler.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #ifdef CONFIG_KGDB
@@ -41,11 +40,6 @@
 # include <linux/kgdb.h>
 #endif
 
-/* assembler routines */
-asmlinkage void evt_system_call(void);
-asmlinkage void evt_soft_int1(void);
-asmlinkage void trap(void);
-
 /* Initiate the event table handler */
 void __init trap_init(void)
 {
@@ -60,8 +54,14 @@ int kstack_depth_to_print = 48;
 
 #ifdef CONFIG_KALLSYMS
 #include <linux/kallsyms.h>
+#endif
 static int printk_address(unsigned long address)
 {
+	struct vm_list_struct *vml;
+	struct task_struct *p;
+	struct mm_struct *mm;
+
+#ifdef CONFIG_KALLSYMS
 	unsigned long offset = 0, symsize;
 	const char *symname;
 	char *modname;
@@ -69,76 +69,60 @@ static int printk_address(unsigned long 
 	char namebuf[128];
 
 	/* look up the address and see if we are in kernel space */
-	symname =
-	    kallsyms_lookup(address, &symsize, &offset, &modname, namebuf);
+	symname = kallsyms_lookup(address, &symsize, &offset, &modname, namebuf);
 
 	if (symname) {
 		/* yeah! kernel space! */
 		if (!modname)
 			modname = delim = "";
 		return printk("<0x%p> { %s%s%s%s + 0x%lx }",
-			      (void*)address, delim, modname, delim, symname,
-			      (unsigned long)offset);
+		              (void*)address, delim, modname, delim, symname,
+		              (unsigned long)offset);
 
-	} else {
-		/* looks like we're off in user-land, so let's walk all the
-		 * mappings of all our processes and see if we can't be a whee
-		 * bit more specific
-		 */
-		struct vm_list_struct *vml;
-		struct task_struct *p;
-		struct mm_struct *mm;
-
-		write_lock_irq(&tasklist_lock);
-		for_each_process(p) {
-			mm = get_task_mm(p);
-			if (!mm)
-				continue;
-
-			vml = mm->context.vmlist;
-			while (vml) {
-				struct vm_area_struct *vma = vml->vma;
-
-				if ((address >= vma->vm_start)
-				    && (address < vma->vm_end)) {
-					char *name = p->comm;
-					struct file *file = vma->vm_file;
-					if (file) {
-						char _tmpbuf[256];
-						name =
-						    d_path(file->f_dentry,
-							   file->f_vfsmnt,
-							   _tmpbuf,
-							   sizeof(_tmpbuf));
-					}
-
-					write_unlock_irq(&tasklist_lock);
-					return printk("<0x%p> [ %s + 0x%lx ]",
-						      (void*)address,
-						      name,
-						      (unsigned
-						       long)((address -
-							      vma->vm_start) +
-							     (vma->
-							      vm_pgoff <<
-							      PAGE_SHIFT)));
+	}
+#endif
+
+	/* looks like we're off in user-land, so let's walk all the
+	 * mappings of all our processes and see if we can't be a whee
+	 * bit more specific
+	 */
+	write_lock_irq(&tasklist_lock);
+	for_each_process(p) {
+		mm = get_task_mm(p);
+		if (!mm)
+			continue;
+
+		vml = mm->context.vmlist;
+		while (vml) {
+			struct vm_area_struct *vma = vml->vma;
+
+			if (address >= vma->vm_start && address < vma->vm_end) {
+				char *name = p->comm;
+				struct file *file = vma->vm_file;
+				if (file) {
+					char _tmpbuf[256];
+					name = d_path(file->f_dentry,
+					              file->f_vfsmnt,
+					              _tmpbuf,
+					              sizeof(_tmpbuf));
 				}
 
-				vml = vml->next;
+				write_unlock_irq(&tasklist_lock);
+				return printk("<0x%p> [ %s + 0x%lx ]",
+				              (void*)address, name,
+				              (unsigned long)
+				                ((address - vma->vm_start) +
+				                 (vma->vm_pgoff << PAGE_SHIFT)));
 			}
+
+			vml = vml->next;
 		}
-		write_unlock_irq(&tasklist_lock);
 	}
+	write_unlock_irq(&tasklist_lock);
 
 	/* we were unable to find this address anywhere */
 	return printk("[<0x%p>]", (void*)address);
 }
-#else
-static int printk_address(unsigned long address)
-{
-	return printk("[<0x%p>]", (void*)address);
-}
-#endif
 
 #define trace_buffer_save(x) \
 	do { \
@@ -622,6 +606,10 @@ void dump_bfin_regs(struct pt_regs *fp, 
 	printk("\n\n");
 }
 
+#ifdef CONFIG_SYS_BFIN_SPINLOCK_L1
+asmlinkage int sys_bfin_spinlock(int *spinlock)__attribute__((l1_text));
+#endif
+
 asmlinkage int sys_bfin_spinlock(int *spinlock)
 {
 	int ret = 0;
diff -puN arch/blackfin/kernel/vmlinux.lds.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/kernel/vmlinux.lds.S
--- a/arch/blackfin/kernel/vmlinux.lds.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/kernel/vmlinux.lds.S
@@ -6,8 +6,6 @@
  * Created:      Tue Sep 21 2004
  * Description:  Master linker script for blackfin architecture
  *
- * Rev:          $Id: vmlinux.lds.S,v 1.27 2006/08/09 04:25:33 aubrey Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/lib/ashldi3.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/lib/ashldi3.c
--- a/arch/blackfin/lib/ashldi3.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/lib/ashldi3.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: ashldi3.c,v 1.4 2006/08/03 17:37:07 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -31,6 +29,10 @@
 
 #include "gcclib.h"
 
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+DItype __ashldi3(DItype u, word_type b)__attribute__((l1_text));
+#endif
+
 DItype __ashldi3(DItype u, word_type b)
 {
 	DIunion w;
diff -puN arch/blackfin/lib/ashrdi3.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/lib/ashrdi3.c
--- a/arch/blackfin/lib/ashrdi3.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/lib/ashrdi3.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: ashrdi3.c,v 1.5 2006/08/03 17:37:07 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -31,6 +29,10 @@
 
 #include "gcclib.h"
 
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+DItype __ashrdi3(DItype u, word_type b)__attribute__((l1_text));
+#endif
+
 DItype __ashrdi3(DItype u, word_type b)
 {
 	DIunion w;
diff -puN arch/blackfin/lib/checksum.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/lib/checksum.c
--- a/arch/blackfin/lib/checksum.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/lib/checksum.c
@@ -8,8 +8,6 @@
  *               operating system.  INET is implemented using the  BSD Socket
  *               interface as the means of communication with the user level.
  *
- * Rev:          $Id: checksum.c,v 1.9 2006/08/03 17:37:07 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -34,6 +32,10 @@
 #include <net/checksum.h>
 #include <asm/checksum.h>
 
+#ifdef CONFIG_IP_CHECKSUM_L1
+static unsigned short do_csum(const unsigned char *buff, int len)__attribute__((l1_text));
+#endif
+
 static unsigned short do_csum(const unsigned char *buff, int len)
 {
 	register unsigned long sum = 0;
diff -puN arch/blackfin/lib/divsi3.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/lib/divsi3.S
--- a/arch/blackfin/lib/divsi3.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/lib/divsi3.S
@@ -21,7 +21,6 @@
  *                                   R1 - Denominator (i)
  *                                   R0 - Quotient    (o)
  *                 Registers Used : R2-R7,P0-P2
- * Rev:          $Id: divsi3.S,v 1.8 2006/08/03 17:37:07 vapier Exp $
  *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
@@ -46,7 +45,13 @@
 
 .global   ___divsi3;
 
-.align 8;
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+.section .l1.text
+#else
+.text
+#endif
+
+.align 2;
 ___divsi3 :
 
 
diff -puN arch/blackfin/lib/gcclib.h~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/lib/gcclib.h
--- a/arch/blackfin/lib/gcclib.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/lib/gcclib.h
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: gcclib.h,v 1.6 2006/08/03 17:37:07 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/lib/ins.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/lib/ins.S
--- a/arch/blackfin/lib/ins.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/lib/ins.S
@@ -6,8 +6,6 @@
  * Created:      Tue Mar 22 15:27:24 CEST 2005
  * Description:  Implementation of ins{bwl} for BlackFin processors using zero overhead loops.
  *
- * Rev:          $Id: ins.S,v 1.9 2006/08/03 17:37:07 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *               Copyright (C) 2005 Bas Vermeulen, BuyWays BV <bas@buyways.nl>
diff -puN arch/blackfin/lib/lshrdi3.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/lib/lshrdi3.c
--- a/arch/blackfin/lib/lshrdi3.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/lib/lshrdi3.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: lshrdi3.c,v 1.5 2006/08/03 17:37:07 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -45,6 +43,10 @@ typedef union {
 	DItype ll;
 } DIunion;
 
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+DItype __lshrdi3(DItype u, word_type b)__attribute__((l1_text));
+#endif
+
 DItype __lshrdi3(DItype u, word_type b)
 {
 	DIunion w;
diff -puN arch/blackfin/lib/memchr.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/lib/memchr.S
--- a/arch/blackfin/lib/memchr.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/lib/memchr.S
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: memchr.S,v 1.8 2006/08/03 17:37:07 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/lib/memcmp.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/lib/memcmp.S
--- a/arch/blackfin/lib/memcmp.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/lib/memcmp.S
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: memcmp.S,v 1.9 2006/08/03 17:37:07 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/lib/memcpy.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/lib/memcpy.S
--- a/arch/blackfin/lib/memcpy.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/lib/memcpy.S
@@ -11,7 +11,6 @@
  *               gives up and calls a function. We have our own, internal version
  *               so that we get something we trust, even if the user has redefined
  *               the normal symbol.
- * Rev:          $Id: memcpy.S,v 1.8 2006/08/03 17:37:07 vapier Exp $
  *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
@@ -36,6 +35,12 @@
 
 #include <linux/linkage.h>
 
+#ifdef CONFIG_MEMCPY_L1
+.section .l1.text
+#else
+.text
+#endif
+
 .align 2
 
 ENTRY(_memcpy)
diff -puN arch/blackfin/lib/memmove.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/lib/memmove.S
--- a/arch/blackfin/lib/memmove.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/lib/memmove.S
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: memmove.S,v 1.8 2006/09/23 07:53:45 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/lib/memset.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/lib/memset.S
--- a/arch/blackfin/lib/memset.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/lib/memset.S
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: memset.S,v 1.7 2006/08/03 17:37:07 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -33,6 +31,12 @@
 
 .align 2
 
+#ifdef CONFIG_MEMSET_L1
+.section .l1.text
+#else
+.text
+#endif
+
 /*
  * C Library function MEMSET
  * R0 = address (leave unchanged to form result)
diff -puN arch/blackfin/lib/modsi3.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/lib/modsi3.S
--- a/arch/blackfin/lib/modsi3.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/lib/modsi3.S
@@ -12,8 +12,6 @@
  *                 R0  -  returns remainder.
  *                 R2-R7
  *
- * Rev:          $Id: modsi3.S,v 1.7 2006/08/03 17:37:07 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -39,6 +37,13 @@
 .type ___modsi3, STT_FUNC;
 .extern ___divsi3;
 .type ___divsi3, STT_FUNC;
+
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+.section .l1.text
+#else
+.text
+#endif
+
 ___modsi3:
 
 	CC=R0==0;
diff -puN arch/blackfin/lib/muldi3.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/lib/muldi3.c
--- a/arch/blackfin/lib/muldi3.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/lib/muldi3.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: muldi3.c,v 1.5 2006/08/03 17:37:07 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -83,6 +81,10 @@ typedef union {
 	ditype ll;
 } diunion;
 
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+ditype __muldi3(ditype u, ditype v)__attribute__((l1_text));
+#endif
+
 ditype __muldi3(ditype u, ditype v)
 {
 	diunion w;
diff -puN arch/blackfin/lib/outs.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/lib/outs.S
--- a/arch/blackfin/lib/outs.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/lib/outs.S
@@ -6,8 +6,6 @@
  * Created:      Tue Mar 22 15:27:24 CEST 2005
  * Description:  Implementation of outs{bwl} for BlackFin processors using zero overhead loops.
  *
- * Rev:          $Id: outs.S,v 1.7 2006/08/03 17:37:07 vapier Exp $
- *
  * Modified:     Copyright (C) 2005 Bas Vermeulen, BuyWays BV <bas@buyways.nl>
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/lib/smulsi3_highpart.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/lib/smulsi3_highpart.S
--- a/arch/blackfin/lib/smulsi3_highpart.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/lib/smulsi3_highpart.S
@@ -2,6 +2,12 @@
 .global ___smulsi3_highpart;
 .type ___smulsi3_highpart, STT_FUNC;
 
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+.section .l1.text
+#else
+.text
+#endif
+
 ___smulsi3_highpart:
 	R2 = R1.L * R0.L (FU);
 	R3 = R1.H * R0.L (IS,M);
diff -puN arch/blackfin/lib/udivsi3.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/lib/udivsi3.S
--- a/arch/blackfin/lib/udivsi3.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/lib/udivsi3.S
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: udivsi3.S,v 1.10 2006/08/03 17:37:07 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -33,6 +31,13 @@
 
 #define CARRY AC0
 
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+.section .l1.text
+#else
+.text
+#endif
+
+
 ENTRY(___udivsi3)
 
   CC = R0 < R1 (IU);    /* If X < Y, always return 0 */
@@ -105,7 +110,7 @@ ENTRY(___udivsi3)
   ** with some post-adjustment
   */
   R3 = R1 >> 1;		/* Pre-scaled divisor for primitive case */
-  R2 = R0 >> 16 ;
+  R2 = R0 >> 16;
 
   R2 = R3 - R2;		/* shifted divisor < upper 16 bits of dividend */
   CC &= CARRY;
diff -puN arch/blackfin/lib/umodsi3.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/lib/umodsi3.S
--- a/arch/blackfin/lib/umodsi3.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/lib/umodsi3.S
@@ -6,8 +6,6 @@
  * Created:
  * Description:  libgcc1 routines for Blackfin 5xx
  *
- * Rev:          $Id: umodsi3.S,v 1.6 2006/08/03 17:37:07 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -29,7 +27,12 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+.section .l1.text
+#else
 .text
+#endif
+
 .extern ___udivsi3;
 .globl	___umodsi3
 ___umodsi3:
diff -puN arch/blackfin/lib/umulsi3_highpart.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/lib/umulsi3_highpart.S
--- a/arch/blackfin/lib/umulsi3_highpart.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/lib/umulsi3_highpart.S
@@ -2,6 +2,12 @@
 .global ___umulsi3_highpart;
 .type ___umulsi3_highpart, STT_FUNC;
 
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+.section .l1.text
+#else
+.text
+#endif
+
 ___umulsi3_highpart:
 	R2 = R1.H * R0.H, R3 = R1.L * R0.H (FU);
 	R0 = R1.L * R0.L, R1 = R1.H * R0.L (FU);
diff -puN arch/blackfin/mach-bf533/boards/cm_bf533.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf533/boards/cm_bf533.c
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -6,8 +6,6 @@
  * Created:      2005
  * Description:  Board description file
  *
- * Rev:          $Id: cm_bf533.c 2643 2007-01-15 06:57:38Z cooloney $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/mach-bf533/boards/ezkit.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf533/boards/ezkit.c
--- a/arch/blackfin/mach-bf533/boards/ezkit.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -6,8 +6,6 @@
  * Created:      2005
  * Description:
  *
- * Rev:          $Id: ezkit.c,v 1.27 2006/11/24 10:23:54 aubrey Exp $
- *
  * Modified:     Robin Getz <rgetz@blackfin.uclinux.org> - Named the boards
  *               Copyright 2005 National ICT Australia (NICTA)
  *               Copyright 2004-2006 Analog Devices Inc.
@@ -130,15 +128,12 @@ static struct bfin5xx_spi_chip ad1836_sp
 };
 #endif
 
-/* Notice: for blackfin, the speed_hz is the value of register
- * SPI_BAUD, not the real baudrate */
 static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
 	{
 		/* the modalias must be the same as spi device driver name */
 		.modalias = "m25p80", /* Name of spi_driver for this device */
-		/* this value is the baudrate divisor */
-		.max_speed_hz = 2,     /* actual baudrate is SCLK/(2xspeed_hz) */
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1, /* Framework bus number */
 		.chip_select = 2, /* Framework chip select. On STAMP537 it is SPISSEL2*/
 		.platform_data = &bfin_spi_flash_data,
@@ -149,7 +144,7 @@ static struct spi_board_info bfin_spi_bo
 #if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
 	{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
-		.max_speed_hz = 4,     /* actual baudrate is SCLK/(2xspeed_hz) */
+		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1, /* Framework bus number */
 		.chip_select = 1, /* Framework chip select. */
 		.platform_data = NULL, /* No spi_driver specific config */
@@ -160,7 +155,7 @@ static struct spi_board_info bfin_spi_bo
 #if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 	{
 		.modalias = "ad1836-spi",
-		.max_speed_hz = 16,
+		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1,
 		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
 		.controller_data = &ad1836_spi_chip_info,
diff -puN arch/blackfin/mach-bf533/boards/generic_board.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf533/boards/generic_board.c
--- a/arch/blackfin/mach-bf533/boards/generic_board.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf533/boards/generic_board.c
@@ -6,8 +6,6 @@
  * Created:      2005
  * Description:
  *
- * Rev:          $Id: generic_board.c,v 1.9 2006/09/23 06:35:21 vapier Exp $
- *
  * Modified:
  *               Copyright 2005 National ICT Australia (NICTA)
  *               Copyright 2004-2006 Analog Devices Inc.
diff -puN arch/blackfin/mach-bf533/boards/stamp.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf533/boards/stamp.c
--- a/arch/blackfin/mach-bf533/boards/stamp.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf533/boards/stamp.c
@@ -6,8 +6,6 @@
  * Created:      2005
  * Description:  Board Info File for the BF533-STAMP
  *
- * Rev:          $Id: stamp.c,v 1.35 2006/12/23 01:20:31 vapier Exp $
- *
  * Modified:
  *               Copyright 2005 National ICT Australia (NICTA)
  *               Copyright 2004-2006 Analog Devices Inc.
@@ -170,15 +168,12 @@ static struct bfin5xx_spi_chip ad5304_ch
 };
 #endif
 
-/* Notice: for blackfin, the speed_hz is the value of register
- * SPI_BAUD, not the real baudrate */
 static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
 	{
 		/* the modalias must be the same as spi device driver name */
 		.modalias = "m25p80", /* Name of spi_driver for this device */
-		/* this value is the baudrate divisor */
-		.max_speed_hz = 2,     /* actual baudrate is SCLK/(2xspeed_hz) */
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1, /* Framework bus number */
 		.chip_select = 2, /* Framework chip select. On STAMP537 it is SPISSEL2*/
 		.platform_data = &bfin_spi_flash_data,
@@ -189,7 +184,7 @@ static struct spi_board_info bfin_spi_bo
 #if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
 	{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
-		.max_speed_hz = 4,     /* actual baudrate is SCLK/(2xspeed_hz) */
+		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1, /* Framework bus number */
 		.chip_select = 1, /* Framework chip select. */
 		.platform_data = NULL, /* No spi_driver specific config */
@@ -200,7 +195,7 @@ static struct spi_board_info bfin_spi_bo
 #if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 	{
 		.modalias = "ad1836-spi",
-		.max_speed_hz = 16,
+		.max_speed_hz = 31250000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1,
 		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
 		.controller_data = &ad1836_spi_chip_info,
@@ -210,7 +205,7 @@ static struct spi_board_info bfin_spi_bo
 #if defined(CONFIG_PBX)
 	{
 		.modalias	= "fxs-spi",
-		.max_speed_hz	= 4,
+		.max_speed_hz	= 12500000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num	= 1,
 		.chip_select	= 3,
 		.controller_data= &spi_si3xxx_chip_info,
@@ -218,7 +213,7 @@ static struct spi_board_info bfin_spi_bo
 
 	{
 		.modalias	= "fxo-spi",
-		.max_speed_hz	= 4,
+		.max_speed_hz	= 12500000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num	= 1,
 		.chip_select	= 2,
 		.controller_data= &spi_si3xxx_chip_info,
@@ -228,7 +223,7 @@ static struct spi_board_info bfin_spi_bo
 #if defined(CONFIG_AD5304) || defined(CONFIG_AD5304_MODULE)
 	{
 		.modalias = "ad5304_spi",
-		.max_speed_hz = 50,
+		.max_speed_hz = 1000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1,
 		.chip_select = 2,
 		.platform_data = NULL,
diff -puN arch/blackfin/mach-bf533/cpu.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf533/cpu.c
--- a/arch/blackfin/mach-bf533/cpu.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf533/cpu.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:  clock scaling for the bf533
  *
- * Rev:          $Id: cpu.c,v 1.9 2006/08/03 17:37:10 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/mach-bf533/head.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf533/head.S
--- a/arch/blackfin/mach-bf533/head.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf533/head.S
@@ -6,8 +6,6 @@
  * Created:      1998
  * Description:  bf533 startup file
  *
- * Rev:          $Id: head.S 2708 2007-01-31 02:36:48Z aubrey $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/mach-bf533/ints-priority.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf533/ints-priority.c
--- a/arch/blackfin/mach-bf533/ints-priority.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf533/ints-priority.c
@@ -6,8 +6,6 @@
  * Created:      ?
  * Description:  Set up the interupt priorities
  *
- * Rev:          $Id: ints-priority.c,v 1.39 2006/12/19 08:03:44 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/mach-bf537/boards/Makefile~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf537/boards/Makefile
--- a/arch/blackfin/mach-bf537/boards/Makefile~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf537/boards/Makefile
@@ -2,7 +2,8 @@
 # arch/blackfin/mach-bf537/boards/Makefile
 #
 
-obj-$(CONFIG_GENERIC_BOARD)            += generic_board.o
-obj-$(CONFIG_BFIN537_STAMP)            += stamp.o led.o
-obj-$(CONFIG_BFIN537_BLUETECHNIX_CM)   += cm_bf537.o
-obj-$(CONFIG_PNAV10)                   += pnav10.o
+obj-y					+= eth_mac.o
+obj-$(CONFIG_GENERIC_BOARD)		+= generic_board.o
+obj-$(CONFIG_BFIN537_STAMP)		+= stamp.o led.o
+obj-$(CONFIG_BFIN537_BLUETECHNIX_CM)	+= cm_bf537.o
+obj-$(CONFIG_PNAV10)			+= pnav10.o
diff -puN arch/blackfin/mach-bf537/boards/cm_bf537.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf537/boards/cm_bf537.c
--- a/arch/blackfin/mach-bf537/boards/cm_bf537.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -6,8 +6,6 @@
  * Created:      2005
  * Description:  Board description file
  *
- * Rev:          $Id: cm_bf537.c 2643 2007-01-15 06:57:38Z cooloney $
- *
  * Modified:
  *               Copyright 2005 National ICT Australia (NICTA)
  *               Copyright 2004-2006 Analog Devices Inc.
@@ -365,15 +363,4 @@ static int __init cm_bf537_init(void)
 	return 0;
 }
 
-void get_bf537_ether_addr(char *addr)
-{
-	/* currently the mac addr is saved in flash */
-	int flash_mac = 0x203f0000;
-	*(u32 *)(&(addr[0])) = *(int *)flash_mac;
-	flash_mac += 4;
-	*(u16 *)(&(addr[4])) = (u16)*(int *)flash_mac;
-}
-
-EXPORT_SYMBOL(get_bf537_ether_addr);
-
 arch_initcall(cm_bf537_init);
diff -puN /dev/null arch/blackfin/mach-bf537/boards/eth_mac.c
--- /dev/null
+++ a/arch/blackfin/mach-bf537/boards/eth_mac.c
@@ -0,0 +1,52 @@
+/*
+ *  arch/blackfin/mach-bf537/board/eth_mac.c
+ *
+ *  Copyright (C) 2007 Analog Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#include <linux/module.h>
+#include <asm/blackfin.h>
+
+#if	defined(CONFIG_GENERIC_BOARD) \
+	|| defined(CONFIG_BFIN537_STAMP) \
+	|| defined(CONFIG_BFIN537_BLUETECHNIX_CM) \
+	|| defined(CONFIG_PNAV10)
+
+/*
+ * Currently the MAC address is saved in Flash by U-Boot
+ */
+#define FLASH_MAC	0x203f0000
+
+void get_bf537_ether_addr(char *addr)
+{
+	unsigned int flash_mac = (unsigned int) FLASH_MAC;
+	*(u32 *)(&(addr[0])) = bfin_read32(flash_mac);
+	flash_mac += 4;
+	*(u16 *)(&(addr[4])) = bfin_read16(flash_mac);
+}
+
+#else
+
+/*
+ * Provide MAC address function for other specific board setting
+ */
+void get_bf537_ether_addr(char *addr)
+{
+}
+
+#endif
+
+EXPORT_SYMBOL(get_bf537_ether_addr);
diff -puN arch/blackfin/mach-bf537/boards/generic_board.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf537/boards/generic_board.c
--- a/arch/blackfin/mach-bf537/boards/generic_board.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf537/boards/generic_board.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: generic_board.c,v 1.20 2006/11/24 10:23:59 aubrey Exp $
- *
  * Modified:
  *               Copyright 2005 National ICT Australia (NICTA)
  *               Copyright 2004-2006 Analog Devices Inc.
@@ -308,15 +306,12 @@ static struct bfin5xx_spi_chip ad9960_sp
 };
 #endif
 
-/* Notice: for blackfin, the speed_hz is the value of register
- * SPI_BAUD, not the real baudrate */
 static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
 	{
 		/* the modalias must be the same as spi device driver name */
 		.modalias = "m25p80", /* Name of spi_driver for this device */
-		/* this value is the baudrate divisor */
-		.max_speed_hz = 2,     /* actual baudrate is SCLK/(2xspeed_hz) */
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1, /* Framework bus number */
 		.chip_select = 2, /* Framework chip select. On STAMP537 it is SPISSEL1*/
 		.platform_data = &bfin_spi_flash_data,
@@ -327,7 +322,7 @@ static struct spi_board_info bfin_spi_bo
 #if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
 	{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
-		.max_speed_hz = 8,     /* actual baudrate is SCLK/(2xspeed_hz) */
+		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1, /* Framework bus number */
 		.chip_select = 1, /* Framework chip select. */
 		.platform_data = NULL, /* No spi_driver specific config */
@@ -338,7 +333,7 @@ static struct spi_board_info bfin_spi_bo
 #if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 	{
 		.modalias = "ad1836-spi",
-		.max_speed_hz = 16,
+		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1,
 		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
 		.controller_data = &ad1836_spi_chip_info,
@@ -348,7 +343,7 @@ static struct spi_board_info bfin_spi_bo
 #if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
 	{
 		.modalias = "ad9960-spi",
-		.max_speed_hz = 5,
+		.max_speed_hz = 10000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1,
 		.chip_select = 1,
 		.controller_data = &ad9960_spi_chip_info,
@@ -450,15 +445,4 @@ static int __init stamp_init(void)
 	return 0;
 }
 
-void get_bf537_ether_addr(char *addr)
-{
-	/* currently the mac addr is saved in flash */
-	int flash_mac = 0x203f0000;
-	*(u32 *)(&(addr[0])) = *(int *)flash_mac;
-	flash_mac += 4;
-	*(u16 *)(&(addr[4])) = (u16)*(int *)flash_mac;
-}
-
-EXPORT_SYMBOL(get_bf537_ether_addr);
-
 arch_initcall(stamp_init);
diff -puN arch/blackfin/mach-bf537/boards/pnav10.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf537/boards/pnav10.c
--- a/arch/blackfin/mach-bf537/boards/pnav10.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: pnav10.c,v 1.1 2006/12/16 13:54:43 hennerich Exp $
- *
  * Modified:
  *               Copyright 2005 National ICT Australia (NICTA)
  *               Copyright 2004-2006 Analog Devices Inc.
@@ -334,16 +332,13 @@ static const struct ad7877_platform_data
 };
 #endif
 
-/* Notice: for blackfin, the speed_hz is the value of register
- * SPI_BAUD, not the real baudrate */
 static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_MTD_M25P80) \
 	|| defined(CONFIG_MTD_M25P80_MODULE)
 	{
 		/* the modalias must be the same as spi device driver name */
 		.modalias = "m25p80", /* Name of spi_driver for this device */
-		/* this value is the baudrate divisor */
-		.max_speed_hz = 2,     /* actual baudrate is SCLK/(2xspeed_hz) */
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1, /* Framework bus number */
 		.chip_select = 1, /* Framework chip select. On STAMP537 it is SPISSEL1*/
 		.platform_data = &bfin_spi_flash_data,
@@ -355,7 +350,7 @@ static struct spi_board_info bfin_spi_bo
 	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
 	{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
-		.max_speed_hz = 8,     /* actual baudrate is SCLK/(2xspeed_hz) */
+		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1, /* Framework bus number */
 		.chip_select = 1, /* Framework chip select. */
 		.platform_data = NULL, /* No spi_driver specific config */
@@ -367,7 +362,7 @@ static struct spi_board_info bfin_spi_bo
 	|| defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 	{
 		.modalias = "ad1836-spi",
-		.max_speed_hz = 16,
+		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1,
 		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
 		.controller_data = &ad1836_spi_chip_info,
@@ -376,7 +371,7 @@ static struct spi_board_info bfin_spi_bo
 #if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
 	{
 		.modalias = "ad9960-spi",
-		.max_speed_hz = 5,
+		.max_speed_hz = 10000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1,
 		.chip_select = 1,
 		.controller_data = &ad9960_spi_chip_info,
@@ -385,7 +380,7 @@ static struct spi_board_info bfin_spi_bo
 #if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
 	{
 		.modalias = "spi_mmc_dummy",
-		.max_speed_hz = 2,
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1,
 		.chip_select = 7,
 		.platform_data = NULL,
@@ -393,7 +388,7 @@ static struct spi_board_info bfin_spi_bo
 	},
 	{
 		.modalias = "spi_mmc",
-		.max_speed_hz = 2,
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1,
 		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
 		.platform_data = NULL,
@@ -403,7 +398,7 @@ static struct spi_board_info bfin_spi_bo
 #if defined(CONFIG_PBX)
 	{
 		.modalias	= "fxs-spi",
-		.max_speed_hz	= 4,
+		.max_speed_hz	= 12500000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num	= 1,
 		.chip_select	= 3,
 		.controller_data= &spi_si3xxx_chip_info,
@@ -411,7 +406,7 @@ static struct spi_board_info bfin_spi_bo
 
 	{
 		.modalias	= "fxo-spi",
-		.max_speed_hz	= 4,
+		.max_speed_hz	= 12500000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num	= 1,
 		.chip_select	= 2,
 		.controller_data= &spi_si3xxx_chip_info,
@@ -422,7 +417,7 @@ static struct spi_board_info bfin_spi_bo
 	.modalias		= "ad7877",
 	.platform_data		= &bfin_ad7877_ts_info,
 	.irq			= IRQ_PF2,
-	.max_speed_hz		= 4, /* max sample rate */
+	.max_speed_hz		= 12500000,     /* max spi clock (SCK) speed in HZ */
 	.bus_num		= 1,
 	.chip_select  		= 5,
 	.controller_data = &spi_ad7877_chip_info,
@@ -527,15 +522,4 @@ static int __init stamp_init(void)
 	return 0;
 }
 
-void get_bf537_ether_addr(char *addr)
-{
-	/* currently the mac addr is saved in flash */
-	int flash_mac = 0x203f0000;
-	*(u32 *)(&(addr[0])) = *(int *)flash_mac;
-	flash_mac += 4;
-	*(u16 *)(&(addr[4])) = (u16) * (int *)flash_mac;
-}
-
-EXPORT_SYMBOL(get_bf537_ether_addr);
-
 arch_initcall(stamp_init);
diff -puN arch/blackfin/mach-bf537/boards/stamp.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf537/boards/stamp.c
--- a/arch/blackfin/mach-bf537/boards/stamp.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf537/boards/stamp.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: stamp.c,v 1.64 2006/12/23 01:20:32 vapier Exp $
- *
  * Modified:
  *               Copyright 2005 National ICT Australia (NICTA)
  *               Copyright 2004-2006 Analog Devices Inc.
@@ -40,6 +38,8 @@
 #include <linux/usb_isp1362.h>
 #endif
 #include <asm/irq.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
 #include <asm/bfin5xx_spi.h>
 #include <linux/usb_sl811.h>
 
@@ -54,6 +54,53 @@ char *bfin_board_name = "ADDS-BF537-STAM
  *  Driver needs to know address, irq and flag pin.
  */
 
+#define ISP1761_BASE       0x203C0000
+#define ISP1761_IRQ        IRQ_PF7
+
+#if defined(CONFIG_USB_ISP1760_HCD) || defined(CONFIG_USB_ISP1760_HCD_MODULE)
+static struct resource bfin_isp1761_resources[] = {
+	[0] = {
+		.name	= "isp1761-regs",
+		.start  = ISP1761_BASE + 0x00000000,
+		.end    = ISP1761_BASE + 0x000fffff,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = ISP1761_IRQ,
+		.end    = ISP1761_IRQ,
+		.flags  = IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL,
+	},
+};
+
+static struct platform_device bfin_isp1761_device = {
+	.name           = "isp1761",
+	.id             = 0,
+	.num_resources  = ARRAY_SIZE(bfin_isp1761_resources),
+	.resource       = bfin_isp1761_resources,
+};
+
+static struct platform_device *bfin_isp1761_devices[] = {
+	&bfin_isp1761_device,
+};
+
+int __init bfin_isp1761_init(void)
+{
+	unsigned int num_devices=ARRAY_SIZE(bfin_isp1761_devices);
+
+	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	set_irq_type(ISP1761_IRQ, IRQF_TRIGGER_FALLING);
+
+	return platform_add_devices(bfin_isp1761_devices, num_devices);
+}
+
+void __exit bfin_isp1761_exit(void)
+{
+	platform_device_unregister(&bfin_isp1761_device);
+}
+
+arch_initcall(bfin_isp1761_init);
+#endif
+
 #if defined(CONFIG_BFIN_CFPCMCIA) || defined(CONFIG_BFIN_CFPCMCIA_MODULE)
 static struct resource bfin_pcmcia_cf_resources[] = {
 	{
@@ -341,16 +388,13 @@ static const struct ad7877_platform_data
 };
 #endif
 
-/* Notice: for blackfin, the speed_hz is the value of register
- * SPI_BAUD, not the real baudrate */
 static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_MTD_M25P80) \
 	|| defined(CONFIG_MTD_M25P80_MODULE)
 	{
 		/* the modalias must be the same as spi device driver name */
 		.modalias = "m25p80", /* Name of spi_driver for this device */
-		/* this value is the baudrate divisor */
-		.max_speed_hz = 2,     /* actual baudrate is SCLK/(2xspeed_hz) */
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1, /* Framework bus number */
 		.chip_select = 1, /* Framework chip select. On STAMP537 it is SPISSEL1*/
 		.platform_data = &bfin_spi_flash_data,
@@ -362,7 +406,7 @@ static struct spi_board_info bfin_spi_bo
 	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
 	{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
-		.max_speed_hz = 8,     /* actual baudrate is SCLK/(2xspeed_hz) */
+		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1, /* Framework bus number */
 		.chip_select = 1, /* Framework chip select. */
 		.platform_data = NULL, /* No spi_driver specific config */
@@ -374,7 +418,7 @@ static struct spi_board_info bfin_spi_bo
 	|| defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 	{
 		.modalias = "ad1836-spi",
-		.max_speed_hz = 16,
+		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1,
 		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
 		.controller_data = &ad1836_spi_chip_info,
@@ -383,7 +427,7 @@ static struct spi_board_info bfin_spi_bo
 #if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
 	{
 		.modalias = "ad9960-spi",
-		.max_speed_hz = 5,
+		.max_speed_hz = 10000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1,
 		.chip_select = 1,
 		.controller_data = &ad9960_spi_chip_info,
@@ -392,7 +436,7 @@ static struct spi_board_info bfin_spi_bo
 #if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
 	{
 		.modalias = "spi_mmc_dummy",
-		.max_speed_hz = 2,
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1,
 		.chip_select = 0,
 		.platform_data = NULL,
@@ -400,7 +444,7 @@ static struct spi_board_info bfin_spi_bo
 	},
 	{
 		.modalias = "spi_mmc",
-		.max_speed_hz = 2,
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1,
 		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
 		.platform_data = NULL,
@@ -410,7 +454,7 @@ static struct spi_board_info bfin_spi_bo
 #if defined(CONFIG_PBX)
 	{
 		.modalias	= "fxs-spi",
-		.max_speed_hz	= 4,
+		.max_speed_hz	= 12500000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num	= 1,
 		.chip_select	= 3,
 		.controller_data= &spi_si3xxx_chip_info,
@@ -418,7 +462,7 @@ static struct spi_board_info bfin_spi_bo
 
 	{
 		.modalias	= "fxo-spi",
-		.max_speed_hz	= 4,
+		.max_speed_hz	= 12500000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num	= 1,
 		.chip_select	= 2,
 		.controller_data= &spi_si3xxx_chip_info,
@@ -427,7 +471,7 @@ static struct spi_board_info bfin_spi_bo
 #if defined(CONFIG_AD5304) || defined(CONFIG_AD5304_MODULE)
 	{
 		.modalias = "ad5304_spi",
-		.max_speed_hz = 50,
+		.max_speed_hz	= 1000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1,
 		.chip_select = 2,
 		.platform_data = NULL,
@@ -440,7 +484,7 @@ static struct spi_board_info bfin_spi_bo
 	.modalias		= "ad7877",
 	.platform_data		= &bfin_ad7877_ts_info,
 	.irq			= IRQ_PF6,
-	.max_speed_hz		= 4, /* max sample rate */
+	.max_speed_hz	= 12500000,     /* max spi clock (SCK) speed in HZ */
 	.bus_num	= 1,
 	.chip_select  = 1,
 	.controller_data = &spi_ad7877_chip_info,
@@ -490,6 +534,12 @@ static struct platform_device bfin_uart_
 };
 #endif
 
+#if defined(CONFIG_I2C_BLACKFIN_TWI) || defined(CONFIG_I2C_BLACKFIN_TWI_MODULE)
+static struct platform_device i2c_bfin_twi_device = {
+	.name = "i2c-bfin-twi",
+	.id = 0,
+};
+#endif
 
 #if defined(CONFIG_SERIAL_BFIN_SPORT) || defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
 static struct platform_device bfin_sport0_uart_device = {
@@ -544,6 +594,10 @@ static struct platform_device *stamp_dev
 	&bfin_uart_device,
 #endif
 
+#if defined(CONFIG_I2C_BLACKFIN_TWI) || defined(CONFIG_I2C_BLACKFIN_TWI_MODULE)
+	&i2c_bfin_twi_device,
+#endif
+
 #if defined(CONFIG_SERIAL_BFIN_SPORT) || defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
 	&bfin_sport0_uart_device,
 	&bfin_sport1_uart_device,
@@ -561,15 +615,4 @@ static int __init stamp_init(void)
 	return 0;
 }
 
-void get_bf537_ether_addr(char *addr)
-{
-	/* currently the mac addr is saved in flash */
-	int flash_mac = 0x203f0000;
-	*(u32 *)(&(addr[0])) = *(int *)flash_mac;
-	flash_mac += 4;
-	*(u16 *)(&(addr[4])) = (u16) * (int *)flash_mac;
-}
-
-EXPORT_SYMBOL(get_bf537_ether_addr);
-
 arch_initcall(stamp_init);
diff -puN arch/blackfin/mach-bf537/cpu.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf537/cpu.c
--- a/arch/blackfin/mach-bf537/cpu.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf537/cpu.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:  clock scaling for the bf537
  *
- * Rev:          $Id: cpu.c,v 1.5 2006/08/03 17:37:10 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/mach-bf537/head.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf537/head.S
--- a/arch/blackfin/mach-bf537/head.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf537/head.S
@@ -6,8 +6,6 @@
  * Created:      1998
  * Description:  Startup code for Blackfin BF537
  *
- * Rev:          $Id: head.S 2591 2007-01-04 02:11:18Z sonicz $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -240,7 +238,6 @@ ENTRY(__stext)
 	r0 = AMGCTLVAL;
 	w[p2] = r0;
 	ssync;
-	call _real_start;
 
 	/* This section keeps the processor in supervisor mode
 	 * during kernel boot.  Switches to user mode at end of boot.
diff -puN arch/blackfin/mach-bf537/ints-priority.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf537/ints-priority.c
--- a/arch/blackfin/mach-bf537/ints-priority.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf537/ints-priority.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:  Set up the interupt priorities
  *
- * Rev:          $Id: ints-priority.c,v 1.14 2006/08/03 17:37:10 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/mach-bf561/boards/Makefile~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf561/boards/Makefile
--- a/arch/blackfin/mach-bf561/boards/Makefile~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf561/boards/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_GENERIC_BOARD)            += generic_board.o
 obj-$(CONFIG_BFIN561_EZKIT)            += ezkit.o
+obj-$(CONFIG_BFIN561_BLUETECHNIX_CM)   += cm_bf561.o
diff -puN arch/blackfin/mach-bf561/boards/cm_bf561.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf561/boards/cm_bf561.c
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -6,8 +6,6 @@
  * Created:      2006
  * Description:  Board description file
  *
- * Rev:          $Id: cm_bf561.c,v 1.11 2006/11/24 13:21:43 hennerich Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -113,15 +111,12 @@ static struct bfin5xx_spi_chip spi_mmc_c
 };
 #endif
 
-/* Notice: for blackfin, the speed_hz is the value of register
- * SPI_BAUD, not the real baudrate */
 static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
 	{
 		/* the modalias must be the same as spi device driver name */
 		.modalias = "m25p80", /* Name of spi_driver for this device */
-		/* this value is the baudrate divisor */
-		.max_speed_hz = 2,     /* actual baudrate is SCLK/(2xspeed_hz) */
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1, /* Framework bus number */
 		.chip_select = 1, /* Framework chip select. On STAMP537 it is SPISSEL1*/
 		.platform_data = &bfin_spi_flash_data,
@@ -132,7 +127,7 @@ static struct spi_board_info bfin_spi_bo
 #if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
 	{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
-		.max_speed_hz = 8,     /* actual baudrate is SCLK/(2xspeed_hz) */
+		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1, /* Framework bus number */
 		.chip_select = 1, /* Framework chip select. */
 		.platform_data = NULL, /* No spi_driver specific config */
@@ -143,7 +138,7 @@ static struct spi_board_info bfin_spi_bo
 #if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 	{
 		.modalias = "ad1836-spi",
-		.max_speed_hz = 16,
+		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1,
 		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
 		.controller_data = &ad1836_spi_chip_info,
@@ -152,7 +147,7 @@ static struct spi_board_info bfin_spi_bo
 #if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
 	{
 		.modalias = "ad9960-spi",
-		.max_speed_hz = 5,
+		.max_speed_hz = 10000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1,
 		.chip_select = 1,
 		.controller_data = &ad9960_spi_chip_info,
@@ -161,7 +156,7 @@ static struct spi_board_info bfin_spi_bo
 #if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
 	{
 		.modalias = "spi_mmc",
-		.max_speed_hz = 2,
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1,
 		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
 		.platform_data = NULL,
@@ -265,6 +260,11 @@ static struct platform_device bfin_uart_
 #endif
 
 static struct platform_device *cm_bf561_devices[] __initdata = {
+
+#if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
+        &bfin_uart_device,
+#endif
+
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 	&isp1362_hcd_device,
 #endif
@@ -277,9 +277,6 @@ static struct platform_device *cm_bf561_
 	&spi_bfin_master_device,
 #endif
 
-#if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
-        &bfin_uart_device,
-#endif
 };
 
 static int __init cm_bf561_init(void)
diff -puN arch/blackfin/mach-bf561/boards/ezkit.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf561/boards/ezkit.c
--- a/arch/blackfin/mach-bf561/boards/ezkit.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: ezkit.c 2700 2007-01-30 07:32:59Z royhuang $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -59,6 +57,14 @@ static struct resource smc91x_resources[
 	},
 };
 
+static struct platform_device smc91x_device = {
+	.name = "smc91x",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(smc91x_resources),
+	.resource = smc91x_resources,
+};
+#endif
+
 #if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
 static struct resource bfin_uart_resources[] = {
         {
@@ -76,15 +82,6 @@ static struct platform_device bfin_uart_
 };
 #endif
 
-
-static struct platform_device smc91x_device = {
-	.name = "smc91x",
-	.id = 0,
-	.num_resources = ARRAY_SIZE(smc91x_resources),
-	.resource = smc91x_resources,
-};
-#endif
-
 #ifdef CONFIG_SPI_BFIN
 #if defined(CONFIG_SND_BLACKFIN_AD1836) \
 	|| defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
diff -puN arch/blackfin/mach-bf561/boards/generic_board.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf561/boards/generic_board.c
--- a/arch/blackfin/mach-bf561/boards/generic_board.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf561/boards/generic_board.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: generic_board.c,v 1.8 2006/08/03 17:45:15 vapier Exp $
- *
  * Modified:
  *               Copyright 2005 National ICT Australia (NICTA)
  *               Copyright 2004-2006 Analog Devices Inc.
@@ -34,6 +32,8 @@
 #include <linux/platform_device.h>
 #include <asm/irq.h>
 
+char *bfin_board_name = "UNKNOWN BOARD";
+
 /*
  *  Driver needs to know address, irq and flag pin.
  */
diff -puN arch/blackfin/mach-bf561/coreb.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf561/coreb.c
--- a/arch/blackfin/mach-bf561/coreb.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf561/coreb.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:  Handle CoreB on a BF561
  *
- * Rev:          $Id: coreb.c,v 1.15 2006/11/06 10:07:25 aubrey Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/mach-bf561/head.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf561/head.S
--- a/arch/blackfin/mach-bf561/head.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf561/head.S
@@ -6,8 +6,6 @@
  * Created:
  * Description:  BF561 startup file
  *
- * Rev:          $Id: head.S 2591 2007-01-04 02:11:18Z sonicz $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/mach-bf561/ints-priority.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-bf561/ints-priority.c
--- a/arch/blackfin/mach-bf561/ints-priority.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-bf561/ints-priority.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:  Set up the interupt priorities
  *
- * Rev:          $Id: ints-priority.c,v 1.5 2006/08/03 17:37:11 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/mach-common/cache.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-common/cache.S
--- a/arch/blackfin/mach-common/cache.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-common/cache.S
@@ -6,8 +6,6 @@
  * Created:
  * Description:  cache control support
  *
- * Rev:          $Id: cache.S,v 1.8 2006/08/03 17:37:12 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -211,7 +209,7 @@ ENTRY(_dcache_invalidate)
 
 	/* Configures the data cache again */
 
-	R6 = (ACACHE_BCACHE | ENDCPLB | PORT_PREF0);
+	R6 = DMEM_CNTR;
 	R7 = R7 | R6;
 
 	CLI R6;
diff -puN arch/blackfin/mach-common/cacheinit.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-common/cacheinit.S
--- a/arch/blackfin/mach-common/cacheinit.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-common/cacheinit.S
@@ -6,8 +6,6 @@
  * Created:      ?
  * Description:  cache initialization
  *
- * Rev:          $Id: cacheinit.S,v 1.8 2006/08/03 17:37:12 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/mach-common/cplbhdlr.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-common/cplbhdlr.S
--- a/arch/blackfin/mach-common/cplbhdlr.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-common/cplbhdlr.S
@@ -6,8 +6,6 @@
  * Created:      ?
  * Description:  CPLB exception handler
  *
- * Rev:          $Id: cplbhdlr.S,v 1.12 2006/09/04 04:37:10 rgetz Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -33,7 +31,11 @@
 #include <asm/cplb.h>
 #include <asm/entry.h>
 
+#ifdef CONFIG_EXCPT_IRQ_SYSC_L1
+.section .l1.text
+#else
 .text
+#endif
 
 .type _cplb_mgr, STT_FUNC;
 .type _panic_cplb_error, STT_FUNC;
diff -puN arch/blackfin/mach-common/cplbinfo.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-common/cplbinfo.c
--- a/arch/blackfin/mach-common/cplbinfo.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-common/cplbinfo.c
@@ -6,8 +6,6 @@
  * Created:      Jan. 2005
  * Description:  Display CPLB status
  *
- * Rev:          $Id: cplbinfo.c,v 1.14 2006/12/22 10:07:29 adamliyi Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/mach-common/cplbmgr.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-common/cplbmgr.S
--- a/arch/blackfin/mach-common/cplbmgr.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-common/cplbmgr.S
@@ -6,8 +6,6 @@
  * Created:      ?
  * Description:  CPLB replacement routine for CPLB mismatch
  *
- * Rev:          $Id: cplbmgr.S 2590 2007-01-04 02:09:21Z sonicz $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -55,7 +53,11 @@
 #include <asm/blackfin.h>
 #include <asm/cplb.h>
 
+#ifdef CONFIG_EXCPT_IRQ_SYSC_L1
+.section .l1.text
+#else
 .text
+#endif
 
 .align 2;
 ENTRY(_cplb_mgr)
diff -puN arch/blackfin/mach-common/dpmc.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-common/dpmc.S
--- a/arch/blackfin/mach-common/dpmc.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-common/dpmc.S
@@ -6,8 +6,6 @@
  * Created:      ?
  * Description:  Watchdog Timer APIs
  *
- * Rev:          $Id: dpmc.S 2716 2007-02-02 03:56:40Z vapier $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/mach-common/entry.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-common/entry.S
--- a/arch/blackfin/mach-common/entry.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-common/entry.S
@@ -8,8 +8,6 @@
  *               This also contains the timer-interrupt handler, as well as all
  *               interrupts and faults that can result in a task-switch.
  *
- * Rev:          $Id: entry.S,v 1.60 2006/12/21 02:09:09 sonicz Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -79,13 +77,18 @@
 # define DEBUG_STOP_HWTRACE
 #endif
 
+#ifdef CONFIG_EXCPT_IRQ_SYSC_L1
+.section .l1.text
+#else
 .text
+#endif
 
 /* Slightly simplified and streamlined entry point for CPLB misses.
  * This one does not lower the level to IRQ5, and thus can be used to
  * patch up CPLB misses on the kernel stack.
  */
 ENTRY(_ex_dcplb)
+#if defined(ANOMALY_05000261)
 	/*
 	 * Work around an anomaly: if we see a new DCPLB fault, return
 	 * without doing anything.  Then, if we get the same fault again,
@@ -99,6 +102,7 @@ ENTRY(_ex_dcplb)
 	cc = r6 == r7;
 	if !cc jump _return_from_exception;
 	/* fall through */
+#endif
 
 ENTRY(_ex_icplb)
 	(R7:6,P5:4) = [sp++];
@@ -333,7 +337,7 @@ ENTRY(_trap) /* Exception: 4th entry int
 	[sp + PT_R0] = r7;	/* return value from system call */
 	jump .Lsyscall_really_exit;
 
-ENTRY(_execve)
+ENTRY(_kernel_execve)
 	link SIZEOF_PTREGS;
 	p0 = sp;
 	r3 = SIZEOF_PTREGS / 4;
@@ -749,7 +753,11 @@ ENTRY(_init_exception_buff)
  * a CPLB. This is needed to ensure we don't get double fault conditions
  */
 
+#ifdef CONFIG_SYSCALL_TAB_L1
+.section .l1.data
+#else
 .data
+#endif
 ALIGN
 _extable:
 	/* entry for each EXCAUSE[5:0]
@@ -1010,7 +1018,7 @@ ENTRY(_sys_call_table)
 	.long _sys_getcwd
 	.long _sys_capget
 	.long _sys_capset	/* 185 */
-	.long _sys_ni_syscall	/* old sys_sigaltstack */
+	.long _sys_sigaltstack
 	.long _sys_sendfile
 	.long _sys_ni_syscall	/* streams1 */
 	.long _sys_ni_syscall	/* streams2 */
@@ -1178,10 +1186,11 @@ _exception_stack:
 	.endr
 _exception_stack_top:
 
+#if defined(ANOMALY_05000261)
 /* Used by the assembly entry point to work around an anomaly.  */
 _last_cplb_fault_retx:
 	.long 0;
-
+#endif
 /*
  * Single instructions can have multiple faults, which need to be
  * handled by traps.c, in irq5. We store the exception cause to ensure
diff -puN arch/blackfin/mach-common/interrupt.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-common/interrupt.S
--- a/arch/blackfin/mach-common/interrupt.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-common/interrupt.S
@@ -7,8 +7,6 @@
  * Created:      ?
  * Description:  Interrupt Entries
  *
- * Rev:          $Id: interrupt.S,v 1.30 2006/08/03 17:37:12 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/mach-common/ints-priority-dc.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-common/ints-priority-dc.c
--- a/arch/blackfin/mach-common/ints-priority-dc.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-common/ints-priority-dc.c
@@ -6,8 +6,6 @@
  * Created:      ?
  * Description:  Set up the interupt priorities
  *
- * Rev:          $Id: ints-priority-dc.c,v 1.21 2006/12/07 09:24:16 hennerich Exp $
- *
  * Modified:
  *               1996 Roman Zippel
  *               1999 D. Jeff Dionne <jeff@uclinux.org>
@@ -45,6 +43,7 @@
 #include <asm/traps.h>
 #include <asm/blackfin.h>
 #include <asm/gpio.h>
+#include <asm/irq_handler.h>
 
 /*
  * NOTES:
@@ -56,7 +55,7 @@
 unsigned long irq_flags = 0;
 
 /* The number of spurious interrupts */
-volatile unsigned int num_spurious;
+atomic_t num_spurious;
 
 struct ivgx {
 	/* irq number for request_irq, available in mach-bf561/irq.h */
@@ -73,24 +72,6 @@ struct ivg_slice {
 	struct ivgx *istop;
 } ivg7_13[IVG13 - IVG7 + 1];
 
-/* BASE LEVEL interrupt handler routines */
-asmlinkage void evt_emulation(void);
-asmlinkage void evt_exception(void);
-asmlinkage void trap(void);
-asmlinkage void evt_ivhw(void);
-asmlinkage void evt_timer(void);
-asmlinkage void evt_evt2(void);
-asmlinkage void evt_evt7(void);
-asmlinkage void evt_evt8(void);
-asmlinkage void evt_evt9(void);
-asmlinkage void evt_evt10(void);
-asmlinkage void evt_evt11(void);
-asmlinkage void evt_evt12(void);
-asmlinkage void evt_evt13(void);
-asmlinkage void evt_soft_int1(void);
-asmlinkage void evt_system_call(void);
-asmlinkage void init_exception_buff(void);
-
 static void search_IAR(void);
 
 /*
@@ -438,6 +419,10 @@ int __init init_arch_irq(void)
 	return 0;
 }
 
+#ifdef CONFIG_DO_IRQ_L1
+void do_irq(int vec, struct pt_regs *fp)__attribute__((l1_text));
+#endif
+
 void do_irq(int vec, struct pt_regs *fp)
 {
 	if (vec == EVT_IVTMR_P) {
@@ -453,7 +438,7 @@ void do_irq(int vec, struct pt_regs *fp)
 
 		for (;; ivg++) {
 			if (ivg >= ivg_stop) {
-				num_spurious++;
+				atomic_inc(&num_spurious);
 				return;
 			} else if ((sic_status0 & ivg->isrflag0) ||
 				   (sic_status1 & ivg->isrflag1))
diff -puN arch/blackfin/mach-common/ints-priority-sc.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-common/ints-priority-sc.c
--- a/arch/blackfin/mach-common/ints-priority-sc.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-common/ints-priority-sc.c
@@ -6,8 +6,6 @@
  * Created:      ?
  * Description:  Set up the interupt priorities
  *
- * Rev:          $Id: ints-priority-sc.c,v 1.58 2006/12/07 09:24:15 hennerich Exp $
- *
  * Modified:
  *               1996 Roman Zippel
  *               1999 D. Jeff Dionne <jeff@uclinux.org>
@@ -45,6 +43,7 @@
 #include <asm/traps.h>
 #include <asm/blackfin.h>
 #include <asm/gpio.h>
+#include <asm/irq_handler.h>
 
 #ifdef BF537_FAMILY
 # define BF537_GENERIC_ERROR_INT_DEMUX
@@ -62,7 +61,7 @@
 unsigned long irq_flags = 0;
 
 /* The number of spurious interrupts */
-volatile unsigned int num_spurious;
+atomic_t num_spurious;
 
 struct ivgx {
 	/* irq number for request_irq, available in mach-bf533/irq.h */
@@ -77,23 +76,6 @@ struct ivg_slice {
 	struct ivgx *istop;
 } ivg7_13[IVG13 - IVG7 + 1];
 
-/* BASE LEVEL interrupt handler routines */
-asmlinkage void evt_emulation(void);
-asmlinkage void evt_exception(void);
-asmlinkage void trap(void);
-asmlinkage void evt_ivhw(void);
-asmlinkage void evt_timer(void);
-asmlinkage void evt_evt2(void);
-asmlinkage void evt_evt7(void);
-asmlinkage void evt_evt8(void);
-asmlinkage void evt_evt9(void);
-asmlinkage void evt_evt10(void);
-asmlinkage void evt_evt11(void);
-asmlinkage void evt_evt12(void);
-asmlinkage void evt_evt13(void);
-asmlinkage void evt_soft_int1(void);
-asmlinkage void evt_system_call(void);
-
 static void search_IAR(void);
 
 /*
@@ -547,6 +529,10 @@ int __init init_arch_irq(void)
 	return 0;
 }
 
+#ifdef CONFIG_DO_IRQ_L1
+void do_irq(int vec, struct pt_regs *fp)__attribute__((l1_text));
+#endif
+
 void do_irq(int vec, struct pt_regs *fp)
 {
 	if (vec == EVT_IVTMR_P) {
@@ -561,7 +547,7 @@ void do_irq(int vec, struct pt_regs *fp)
 
 		for (;; ivg++) {
 			if (ivg >= ivg_stop) {
-				num_spurious++;
+				atomic_inc(&num_spurious);
 				return;
 			} else if (sic_status & ivg->isrflag)
 				break;
diff -puN arch/blackfin/mach-common/irqpanic.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-common/irqpanic.c
--- a/arch/blackfin/mach-common/irqpanic.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-common/irqpanic.c
@@ -6,8 +6,6 @@
  * Created:      ?
  * Description:  panic kernel with dump information
  *
- * Rev:          $Id: irqpanic.c,v 1.19 2006/09/05 02:58:30 aubrey Exp $
- *
  * Modified:     rgetz - added cache checking code 14Feb06
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/mach-common/lock.S~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-common/lock.S
--- a/arch/blackfin/mach-common/lock.S~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-common/lock.S
@@ -6,8 +6,6 @@
  * Created:      ?
  * Description:  kernel locks
  *
- * Rev:          $Id: lock.S,v 1.9 2006/08/03 17:37:13 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/mach-common/pm.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mach-common/pm.c
--- a/arch/blackfin/mach-common/pm.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mach-common/pm.c
@@ -6,8 +6,6 @@
  * Created:      2001
  * Description:  Power management for the bfin
  *
- * Rev:          $Id: pm.c 2677 2007-01-20 03:47:40Z vapier $
- *
  * Modified:     Nicolas Pitre - PXA250 support
  *                Copyright (c) 2002 Monta Vista Software, Inc.
  *               David Singleton - OMAP1510
diff -puN arch/blackfin/mm/Makefile~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mm/Makefile
--- a/arch/blackfin/mm/Makefile~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mm/Makefile
@@ -2,4 +2,4 @@
 # arch/blackfin/mm/Makefile
 #
 
-obj-y := blackfin_sram.o init.o kmap.o
+obj-y := blackfin_sram.o init.o
diff -puN arch/blackfin/mm/blackfin_sram.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mm/blackfin_sram.c
--- a/arch/blackfin/mm/blackfin_sram.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mm/blackfin_sram.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:  SRAM driver for Blackfin ADSP-BF5xx
  *
- * Rev:          $Id: blackfin_sram.c,v 1.38 2006/09/04 02:33:15 jiez Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -271,6 +269,7 @@ int sram_free(const void *addr)
 	else
 		return -1;
 }
+EXPORT_SYMBOL(sram_free);
 
 void *l1_data_A_sram_alloc(size_t size)
 {
@@ -298,6 +297,7 @@ void *l1_data_A_sram_alloc(size_t size)
 
 	return addr;
 }
+EXPORT_SYMBOL(l1_data_A_sram_alloc);
 
 int l1_data_A_sram_free(const void *addr)
 {
@@ -325,6 +325,7 @@ int l1_data_A_sram_free(const void *addr
 
 	return ret;
 }
+EXPORT_SYMBOL(l1_data_A_sram_free);
 
 void *l1_data_sram_zalloc(size_t size)
 {
@@ -332,11 +333,13 @@ void *l1_data_sram_zalloc(size_t size)
 	memset(addr, 0x00, size);
 	return addr;
 }
+EXPORT_SYMBOL(l1_data_sram_zalloc);
 
 int l1_data_sram_free(const void *addr)
 {
 	return l1_data_A_sram_free(addr);
 }
+EXPORT_SYMBOL(l1_data_sram_free);
 
 void *l1_data_B_sram_alloc(size_t size)
 {
@@ -360,6 +363,7 @@ void *l1_data_B_sram_alloc(size_t size)
 	return NULL;
 #endif
 }
+EXPORT_SYMBOL(l1_data_B_sram_alloc);
 
 int l1_data_B_sram_free(const void *addr)
 {
@@ -380,6 +384,7 @@ int l1_data_B_sram_free(const void *addr
 	return -1;
 #endif
 }
+EXPORT_SYMBOL(l1_data_B_sram_free);
 
 void *l1_inst_sram_alloc(size_t size)
 {
@@ -403,6 +408,7 @@ void *l1_inst_sram_alloc(size_t size)
 	return NULL;
 #endif
 }
+EXPORT_SYMBOL(l1_inst_sram_alloc);
 
 int l1_inst_sram_free(const void *addr)
 {
@@ -423,6 +429,7 @@ int l1_inst_sram_free(const void *addr)
 	return -1;
 #endif
 }
+EXPORT_SYMBOL(l1_inst_sram_free);
 
 /* L1 Scratchpad memory allocate function */
 void *l1sram_alloc(size_t size)
@@ -492,6 +499,7 @@ found:
 
 	return 0;
 }
+EXPORT_SYMBOL(sram_free_with_lsl);
 
 void *sram_alloc_with_lsl(size_t size, unsigned long flags)
 {
@@ -523,15 +531,4 @@ void *sram_alloc_with_lsl(size_t size, u
 	mm->context.sram_list = lsl;
 	return addr;
 }
-
-EXPORT_SYMBOL(l1_data_A_sram_alloc);
-EXPORT_SYMBOL(l1_data_A_sram_free);
-EXPORT_SYMBOL(l1_data_B_sram_free);
-EXPORT_SYMBOL(l1_data_B_sram_alloc);
-EXPORT_SYMBOL(l1_inst_sram_alloc);
-EXPORT_SYMBOL(l1_inst_sram_free);
-EXPORT_SYMBOL(l1_data_sram_zalloc);
-EXPORT_SYMBOL(l1_data_sram_free);
-EXPORT_SYMBOL(sram_free);
 EXPORT_SYMBOL(sram_alloc_with_lsl);
-EXPORT_SYMBOL(sram_free_with_lsl);
diff -puN arch/blackfin/mm/blackfin_sram.h~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mm/blackfin_sram.h
--- a/arch/blackfin/mm/blackfin_sram.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mm/blackfin_sram.h
@@ -6,8 +6,6 @@
  * Created:      Aug 2006
  * Description:  Local prototypes meant for internal use only
  *
- * Rev:          $Id: blackfin_sram.h,v 1.2 2006/08/09 20:31:11 vapier Exp $
- *
  * Modified:
  *               Copyright 2006 Analog Devices Inc.
  *
diff -puN arch/blackfin/mm/init.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/mm/init.c
--- a/arch/blackfin/mm/init.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/mm/init.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: init.c,v 1.32 2006/11/01 04:48:16 magicyang Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -118,8 +116,7 @@ void paging_init(void)
 	{
 		unsigned long zones_size[MAX_NR_ZONES] = { 0, };
 
-		zones_size[ZONE_DMA] = (end_mem - PAGE_OFFSET) >> PAGE_SHIFT;
-		zones_size[ZONE_NORMAL] = 0;
+		zones_size[ZONE_NORMAL] = (end_mem - PAGE_OFFSET) >> PAGE_SHIFT;
 #ifdef CONFIG_HIGHMEM
 		zones_size[ZONE_HIGHMEM] = 0;
 #endif
diff -puN arch/blackfin/mm/kmap.c~blackfin-arch-2.6.21-rc4-mm1-update /dev/null
--- a/arch/blackfin/mm/kmap.c
+++ /dev/null
@@ -1,84 +0,0 @@
-/*
- * File:         arch/blackfin/mm/kmap.c
- * Based on:     arch/m68knommu/mm/kmap.c
- * Author:
- *
- * Created:
- * Description:
- *
- * Rev:          $Id: kmap.c,v 1.9 2006/08/03 17:37:21 vapier Exp $
- *
- * Modified:
- *               Copyright 2004-2006 Analog Devices Inc.
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see the file COPYING, or write
- * to the Free Software Foundation, Inc.,
- * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-#include <asm/bfin-global.h>
-
-/*
- * Map some physical address range into the kernel address space.
- */
-
-void *__ioremap(unsigned long physaddr, unsigned long size, int cacheflag)
-{
-	return (void *)physaddr;
-}
-
-/*
- * Unmap a ioremap()ed region again
- */
-void iounmap(void *addr)
-{
-}
-
-/*
- * __iounmap unmaps nearly everything, so be careful
- * it doesn't free currently pointer/page tables anymore but it
- * wans't used anyway and might be added later.
- */
-void __iounmap(void *addr, unsigned long size)
-{
-}
-
-/*
- * Set new cache mode for some kernel address space.
- * The caller must push data for that range itself, if such data may already
- * be in the cache.
- */
-void kernel_set_cachemode(void *addr, unsigned long size, int cmode)
-{
-}
-
-int is_in_rom(unsigned long addr)
-{
-
-	/*
-	 * What we are really trying to do is determine if addr is
-	 * in an allocated kernel memory region. If not then assume
-	 * we cannot free it or otherwise de-allocate it. Ideally
-	 * we could restrict this to really being in a ROM or flash,
-	 * but that would need to be done on a board by board basis,
-	 * not globally.
-	 */
-	if ((addr < _ramstart) || (addr >= _ramend))
-		return (1);
-
-	/* Default case, not in ROM */
-	return (0);
-}
diff -puN arch/blackfin/oprofile/common.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/oprofile/common.c
--- a/arch/blackfin/oprofile/common.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/oprofile/common.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: common.c,v 1.12 2006/08/03 17:37:22 vapier Exp $
- *
  * Modified:
  *               Copyright (C) 2004 Anton Blanchard <anton@au.ibm.com>, IBM
  *               Copyright 2004-2006 Analog Devices Inc.
@@ -34,10 +32,10 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/errno.h>
+#include <linux/mutex.h>
 
 #include <asm/ptrace.h>
 #include <asm/system.h>
-#include <asm/semaphore.h>
 #include <asm/blackfin.h>
 #include <asm/irq.h>
 #include <asm/io.h>
@@ -48,7 +46,7 @@
 #define BFIN_537_ID  0xE5040002
 
 static int pfmon_enabled;
-static struct semaphore pfmon_sem;
+static struct mutex pfmon_lock;
 
 struct op_bfin533_model *model;
 
@@ -78,24 +76,24 @@ static int op_bfin_start(void)
 	int ret = -EBUSY;
 
 	printk(KERN_INFO "KSDBG:in %s\n", __FUNCTION__);
-	down(&pfmon_sem);
+	mutex_lock(&pfmon_lock);
 	if (!pfmon_enabled) {
 		ret = model->start(ctr);
 		pfmon_enabled = !ret;
 	}
-	up(&pfmon_sem);
+	mutex_unlock(&pfmon_lock);
 
 	return ret;
 }
 
 static void op_bfin_stop(void)
 {
-	down(&pfmon_sem);
+	mutex_lock(&pfmon_lock);
 	if (pfmon_enabled) {
 		model->stop();
 		pfmon_enabled = 0;
 	}
-	up(&pfmon_sem);
+	mutex_unlock(&pfmon_lock);
 }
 
 static int op_bfin_create_files(struct super_block *sb, struct dentry *root)
@@ -130,7 +128,7 @@ int __init oprofile_arch_init(struct opr
 #ifdef CONFIG_HARDWARE_PM
 	unsigned int dspid;
 
-	init_MUTEX(&pfmon_sem);
+	mutex_init(&pfmon_lock);
 
 	dspid = bfin_read_DSPID();
 
diff -puN arch/blackfin/oprofile/op_blackfin.h~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/oprofile/op_blackfin.h
--- a/arch/blackfin/oprofile/op_blackfin.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/oprofile/op_blackfin.h
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: op_blackfin.h,v 1.10 2006/08/03 17:37:22 vapier Exp $
- *
  * Modified:
  *               Copyright (C) 2004 Anton Blanchard <anton@au.ibm.com>, IBM
  *               Copyright 2004-2006 Analog Devices Inc.
diff -puN arch/blackfin/oprofile/op_model_bf533.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/oprofile/op_model_bf533.c
--- a/arch/blackfin/oprofile/op_model_bf533.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/oprofile/op_model_bf533.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: op_model_bf533.c,v 1.11 2006/08/03 17:37:22 vapier Exp $
- *
  * Modified:
  *               Copyright (C) 2004 Anton Blanchard <anton@au.ibm.com>, IBM
  *               Copyright 2004-2006 Analog Devices Inc.
@@ -50,7 +48,7 @@
 
 static int oprofile_running;
 
-unsigned curr_pfctl, curr_count[2];
+static unsigned curr_pfctl, curr_count[2];
 
 static int bfin533_reg_setup(struct op_counter_config *ctr)
 {
diff -puN arch/blackfin/oprofile/timer_int.c~blackfin-arch-2.6.21-rc4-mm1-update arch/blackfin/oprofile/timer_int.c
--- a/arch/blackfin/oprofile/timer_int.c~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/arch/blackfin/oprofile/timer_int.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: timer_int.c,v 1.3 2006/08/03 17:37:22 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff -puN include/asm-blackfin/bfin-global.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/bfin-global.h
--- a/include/asm-blackfin/bfin-global.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/bfin-global.h
@@ -5,8 +5,6 @@
  * Created:
  * Description:  Global extern defines for blackfin
  *
- * Rev:          $Id: bfin-global.h,v 1.22 2006/08/10 19:15:19 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -91,6 +89,7 @@ extern void led_off(int);
 extern void led_toggle(int);
 extern void led_disp_num(int);
 extern void led_toggle_num(int);
+extern void init_leds(void);
 
 extern char *bfin_board_name __attribute__ ((weak));
 extern unsigned long wall_jiffies;
diff -puN include/asm-blackfin/bfin_spi_channel.h~blackfin-arch-2.6.21-rc4-mm1-update /dev/null
--- a/include/asm-blackfin/bfin_spi_channel.h
+++ /dev/null
@@ -1,182 +0,0 @@
-/************************************************************
-*
-* Copyright (C) 2003, Motorola. All Rights Reserved
-*
-* FILE spi.h
-* PROGRAMMER(S): J.X.Chang (jxchang@motorola.com)
-*
-*
-* DATE OF CREATION: March 8, 2003
-*
-* SYNOPSIS:
-*
-* DESCRIPTION: It's driver of SPI in ADSP25535(ADI's DSP). It can
-*              only be used in unix or linux.
-* CAUTION:     User should use 'ioctl' to change it's
-               configuration just after openning device.
-**************************************************************
-* MODIFICATION HISTORY:
-* March 8, 2003   File spi.h Created.
-************************************************************/
-
-#ifndef _SPI_CHANNEL_H_
-#define _SPI_CHANNEL_H_
-
-#include <linux/interrupt.h>
-
-#define SPI0_REGBASE       0xffc00500
-
-#define SPI_READ              0
-#define SPI_WRITE             1
-
-struct spi_device_t {
-	char *dev_name;
-
-	unsigned short flag;
-	unsigned short bdrate;
-
-	unsigned short enable;
-	unsigned short master;
-	unsigned short out_opendrain;
-	unsigned short polar;
-	unsigned short phase;
-	unsigned short byteorder;	/* 0: MSB first; 1: LSB first; */
-	unsigned short size;	/* 0: 8 bits; 1: 16 bits */
-	unsigned short emiso;
-	unsigned short send_zero;
-	unsigned short more_data;
-	unsigned short slave_sel;
-	unsigned short ti_mod;
-
-	unsigned short dma;	/* use dma mode or not */
-	unsigned short dma_config;	/* only valid if dma enabled */
-
-	 irqreturn_t(*irq_handler) (int irq, void *dev_id,
-				    struct pt_regs *regs);
-	void *priv_data;
-};
-
-#define SPI_CTRL_OFF            0x0
-#define SPI_FLAG_OFF            0x4
-#define SPI_STAT_OFF            0x8
-#define SPI_TXBUFF_OFF          0xc
-#define SPI_RXBUFF_OFF          0x10
-#define SPI_BAUD_OFF            0x14
-#define SPI_SHAW_OFF            0x18
-
-#define CMD_SPI_OUT_ENABLE    1
-#define CMD_SPI_SET_BAUDRATE  2
-#define CMD_SPI_SET_POLAR     3
-#define CMD_SPI_SET_PHASE     4
-#define CMD_SPI_SET_MASTER    5
-#define CMD_SPI_SET_SENDOPT   6
-#define CMD_SPI_SET_RECVOPT   7
-#define CMD_SPI_SET_ORDER     8
-#define CMD_SPI_SET_LENGTH16  9
-#define CMD_SPI_GET_STAT      11
-#define CMD_SPI_GET_CFG       12
-#define CMD_SPI_SET_CSAVAIL   13
-#define CMD_SPI_SET_CSHIGH    14	/* CS unavail */
-#define CMD_SPI_SET_CSLOW     15	/* CS avail */
-#define CMD_SPI_MISO_ENABLE   16
-#define CMD_SPI_SET_CSENABLE  17
-#define CMD_SPI_SET_CSDISABLE 18
-
-#define CMD_SPI_SET_TRIGGER_MODE  19
-#define CMD_SPI_SET_TRIGGER_SENSE 20
-#define CMD_SPI_SET_TRIGGER_EDGE  21
-#define CMD_SPI_SET_TRIGGER_LEVEL 22
-
-#define CMD_SPI_SET_TIME_SPS 	  23
-#define CMD_SPI_SET_TIME_SAMPLES  24
-#define CMD_SPI_GET_SYSTEMCLOCK   25
-
-#define CMD_SPI_SET_WRITECONTINUOUS     26
-
-#define CMD_SPI_GET_ALLCONFIG 32	/* For debug */
-
-#define SPI_DEFAULT_BARD    0x0100
-
-#define SPI0_IRQ_NUM        IRQ_SPI
-#define SPI_ERR_TRIG	   -1
-
-#define BIT_CTL_ENABLE      0x4000
-#define BIT_CTL_OPENDRAIN   0x2000
-#define BIT_CTL_MASTER      0x1000
-#define BIT_CTL_POLAR       0x0800
-#define BIT_CTL_PHASE       0x0400
-#define BIT_CTL_BITORDER    0x0200
-#define BIT_CTL_WORDSIZE    0x0100
-#define BIT_CTL_MISOENABLE  0x0020
-#define BIT_CTL_RXMOD       0x0000
-#define BIT_CTL_TXMOD       0x0001
-#define BIT_CTL_TIMOD_DMA_TX 0x0003
-#define BIT_CTL_TIMOD_DMA_RX 0x0002
-#define BIT_CTL_SENDOPT     0x0004
-
-#define BIT_STU_SENDOVER    0x0001
-#define BIT_STU_RECVFULL    0x0020
-
-#define CFG_SPI_ENABLE      1
-#define CFG_SPI_DISABLE     0
-
-#define CFG_SPI_OUTENABLE   1
-#define CFG_SPI_OUTDISABLE  0
-
-#define CFG_SPI_ACTLOW      1
-#define CFG_SPI_ACTHIGH     0
-
-#define CFG_SPI_PHASESTART  1
-#define CFG_SPI_PHASEMID    0
-
-#define CFG_SPI_MASTER      1
-#define CFG_SPI_SLAVE       0
-
-#define CFG_SPI_SENELAST    1
-#define CFG_SPI_SENDZERO    0
-
-#define CFG_SPI_RCVFLUSH    1
-#define CFG_SPI_RCVDISCARD  0
-
-#define CFG_SPI_LSBFIRST    1
-#define CFG_SPI_MSBFIRST    0
-
-#define CFG_SPI_WORDSIZE16  1
-#define CFG_SPI_WORDSIZE8   0
-
-#define CFG_SPI_MISOENABLE   1
-#define CFG_SPI_MISODISABLE  0
-
-#define CFG_SPI_CSCLEARALL  0
-#define CFG_SPI_CHIPSEL1    1
-#define CFG_SPI_CHIPSEL2    2
-#define CFG_SPI_CHIPSEL3    3
-#define CFG_SPI_CHIPSEL4    4
-#define CFG_SPI_CHIPSEL5    5
-#define CFG_SPI_CHIPSEL6    6
-#define CFG_SPI_CHIPSEL7    7
-
-#define CFG_SPI_CS1VALUE    1
-#define CFG_SPI_CS2VALUE    2
-#define CFG_SPI_CS3VALUE    3
-#define CFG_SPI_CS4VALUE    4
-#define CFG_SPI_CS5VALUE    5
-#define CFG_SPI_CS6VALUE    6
-#define CFG_SPI_CS7VALUE    7
-
-void spi_send_data(unsigned short data);
-unsigned short spi_receive_data(void);
-void spi_enable(struct spi_device_t *spi_dev);
-void spi_disable(struct spi_device_t *spi_dev);
-int spi_dma_read(struct spi_device_t *spi_dev,
-		 void *buffer, unsigned int count);
-int spi_dma_write(struct spi_device_t *spi_dev,
-		  void *buffer, unsigned int count);
-void spi_clear_irqstat(struct spi_device_t *spi_dev);
-void spi_set_ctl(struct spi_device_t *spi_dev);
-void spi_get_stat(struct unsigned short *data);
-void spi_get_ctl(struct unsigned short *data);
-int spi_channel_request(struct spi_device_t *spi_dev);
-int spi_channel_release(struct spi_device_t *spi_dev);
-
-#endif				/* _SPI_CHANNEL_H_ */
diff -puN include/asm-blackfin/bfin_sport.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/bfin_sport.h
--- a/include/asm-blackfin/bfin_sport.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/bfin_sport.h
@@ -6,8 +6,6 @@
  * Created:      Thu Aug. 24 2006
  * Description:
  *
- * Rev:          $Id: bfin_sport.h,v 1.8 2006/12/11 09:21:53 royhuang Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -81,27 +79,27 @@ struct sport_config {
 };
 
 struct sport_register {
-	volatile unsigned short tcr1;
+	unsigned short tcr1;
 	unsigned short reserved0;
-	volatile unsigned short tcr2;
+	unsigned short tcr2;
 	unsigned short reserved1;
 	unsigned short tclkdiv;
 	unsigned short reserved2;
 	unsigned short tfsdiv;
 	unsigned short reserved3;
-	volatile unsigned long tx;
+	unsigned long tx;
 	unsigned long reserved_l0;
-	volatile unsigned long rx;
+	unsigned long rx;
 	unsigned long reserved_l1;
-	volatile unsigned short rcr1;
+	unsigned short rcr1;
 	unsigned short reserved4;
-	volatile unsigned short rcr2;
+	unsigned short rcr2;
 	unsigned short reserved5;
 	unsigned short rclkdiv;
 	unsigned short reserved6;
 	unsigned short rfsdiv;
 	unsigned short reserved7;
-	volatile unsigned short stat;
+	unsigned short stat;
 	unsigned short reserved8;
 	unsigned short chnl;
 	unsigned short reserved9;
diff -puN include/asm-blackfin/blackfin.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/blackfin.h
--- a/include/asm-blackfin/blackfin.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/blackfin.h
@@ -10,47 +10,72 @@
 #include <asm/mach/blackfin.h>
 #include <asm/bfin-global.h>
 
+#ifndef __ASSEMBLY__
+
+/* SSYNC implementation for C file */
 #if defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
-#define SSYNC() do { 	int _tmp; \
-                       __asm__ __volatile__ ("cli %0;\n\t"\
-	         			    "nop;nop;\n\t"\
-                                            "ssync;\n\t"\
-                                            "sti %0;\n\t" \
-                                             :"=d"(_tmp):);\
- } while (0)
+static inline void SSYNC (void)
+{
+	int _tmp;
+	__asm__ __volatile__ ("cli %0;\n\t"
+			"nop;nop;\n\t"
+			"ssync;\n\t"
+			"sti %0;\n\t"
+			:"=d"(_tmp):);
+}
 #elif defined(ANOMALY_05000312) && !defined(ANOMALY_05000244)
-#define SSYNC() do { 	int _tmp; \
-                       __asm__ __volatile__ ("cli %0;\n\t"\
-                                            "ssync;\n\t"\
-                                            "sti %0;\n\t" \
-                                             :"=d"(_tmp):);\
- } while (0)
+static inline void SSYNC (void)
+{
+	int _tmp;
+	__asm__ __volatile__ ("cli %0;\n\t"
+			"ssync;\n\t"
+			"sti %0;\n\t"
+			:"=d"(_tmp):);
+}
 #elif !defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
-#define SSYNC() do {__builtin_bfin_ssync();} while (0)
+static inline void SSYNC (void)
+{
+	__builtin_bfin_ssync();
+}
 #elif !defined(ANOMALY_05000312) && !defined(ANOMALY_05000244)
-#define SSYNC() do {__asm__ __volatile__ ("ssync;\n\t") } while (0)
+static inline void SSYNC (void)
+{
+	__asm__ __volatile__ ("ssync;\n\t");
+}
 #endif
 
-
+/* CSYNC implementation for C file */
 #if defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
-#define CSYNC() do { 	int _tmp; \
-                       __asm__ __volatile__ ("cli %0;\n\t"\
-	         			    "nop;nop;\n\t"\
-                                            "csync;\n\t"\
-                                            "sti %0;\n\t" \
-                                             :"=d"(_tmp):);\
- } while (0)
+static inline void CSYNC (void)
+{
+	int _tmp;
+	__asm__ __volatile__ ("cli %0;\n\t"
+			"nop;nop;\n\t"
+			"csync;\n\t"
+			"sti %0;\n\t"
+			:"=d"(_tmp):);
+}
 #elif defined(ANOMALY_05000312) && !defined(ANOMALY_05000244)
-#define CSYNC() do { 	int _tmp; \
-                       __asm__ __volatile__ ("cli %0;\n\t"\
-                                            "csync;\n\t"\
-                                            "sti %0;\n\t" \
-                                             :"=d"(_tmp):);\
- } while (0)
+static inline void CSYNC (void)
+{
+	int _tmp;
+	__asm__ __volatile__ ("cli %0;\n\t"
+			"csync;\n\t"
+			"sti %0;\n\t"
+			:"=d"(_tmp):);
+}
 #elif !defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
-#define CSYNC() do {__builtin_bfin_csync();} while (0)
+static inline void CSYNC (void)
+{
+	__builtin_bfin_csync();
+}
 #elif !defined(ANOMALY_05000312) && !defined(ANOMALY_05000244)
-#define CSYNC() do {__asm__ __volatile__ ("csync;\n\t") } while (0)
+static inline void CSYNC (void)
+{
+	__asm__ __volatile__ ("csync;\n\t");
+}
 #endif
 
+#endif /* __ASSEMBLY__ */
+
 #endif				/* _BLACKFIN_H_ */
diff -puN include/asm-blackfin/bug.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/bug.h
--- a/include/asm-blackfin/bug.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/bug.h
@@ -1,15 +1,4 @@
 #ifndef _BLACKFIN_BUG_H
 #define _BLACKFIN_BUG_H
-
-#ifdef CONFIG_BUG
-#define HAVE_ARCH_BUG
-#define BUG() do { \
-	dump_stack(); \
-	printk(KERN_WARNING "\nkernel BUG at %s:%d!\n",\
-		 __FILE__, __LINE__); \
-	panic("BUG!"); \
-} while (0)
-#endif
-
 #include <asm-generic/bug.h>
 #endif
diff -puN include/asm-blackfin/cacheflush.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/cacheflush.h
--- a/include/asm-blackfin/cacheflush.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/cacheflush.h
@@ -6,7 +6,6 @@
  * Created:      Tue Sep 21 2004
  * Description:  Blackfin low-level cache routines adapted from the i386
  * 		 and PPC versions by Greg Ungerer (gerg@snapgear.com)
- * Rev:          $Id: cacheflush.h,v 1.14 2006/09/25 23:17:43 vapier Exp $
  *
  * Modified:
  *
@@ -71,7 +70,7 @@ static inline void flush_icache_range(un
 
 #define copy_to_user_page(vma, page, vaddr, dst, src, len) \
 do { memcpy(dst, src, len); \
-     flush_icache_range (vaddr, vaddr + len); \
+     flush_icache_range ((unsigned) (dst), (unsigned) (dst) + (len)); \
 } while (0)
 #define copy_from_user_page(vma, page, vaddr, dst, src, len)	memcpy(dst, src, len)
 
diff -puN include/asm-blackfin/cplbinit.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/cplbinit.h
--- a/include/asm-blackfin/cplbinit.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/cplbinit.h
@@ -1,192 +1,203 @@
-/*
- * File:         include/asm-blackfin/cplbinit.h
- * Based on:
- * Author:
- *
- * Created:
- * Description:
- *
- * Rev:          $Id: cplbinit.h,v 1.3 2007/01/02 03:11:59 adamliyi Exp $
- *
- * Modified:
- *               Copyright 2004-2006 Analog Devices Inc.
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see the file COPYING, or write
- * to the Free Software Foundation, Inc.,
- * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-#include <asm/blackfin.h>
-#include <asm/cplb.h>
-
-#define INITIAL_T 0x1
-#define SWITCH_T  0x2
-#define I_CPLB    0x4
-#define D_CPLB    0x8
-
-#define IN_KERNEL 1
-
-enum
-{ZERO_P, L1I_MEM, L1D_MEM, SDRAM_KERN , SDRAM_RAM_MTD, SDRAM_DMAZ, RES_MEM, ASYNC_MEM, L2_MEM};
-
-struct cplb_desc {
-	u32 start; /* start address */
-	u32 end; /* end address */
-	u32 psize; /* prefered size if any otherwise 1MB or 4MB*/
-	u16 attr;/* attributes */
-	u16 i_conf;/* I-CPLB DATA */
-	u16 d_conf;/* D-CPLB DATA */
-	u16 valid;/* valid */
-	const s8 name[30];/* name */
-};
-
-struct cplb_tab {
-  u_long *tab;
-	u16 pos;
-	u16 size;
-};
-
-u_long icplb_table[MAX_CPLBS+1];
-u_long dcplb_table[MAX_CPLBS+1];
-
-/* Till here we are discussing about the static memory management model.
- * However, the operating envoronments commonly define more CPLB
- * descriptors to cover the entire addressable memory than will fit into
- * the available on-chip 16 CPLB MMRs. When this happens, the below table
- * will be used which will hold all the potentially required CPLB descriptors
- *
- * This is how Page descriptor Table is implemented in uClinux/Blackfin.
- */
-
-u_long ipdt_table[MAX_SWITCH_I_CPLBS+1];
-u_long dpdt_table[MAX_SWITCH_D_CPLBS+1];
-
-#ifdef CONFIG_CPLB_INFO
-u_long ipdt_swapcount_table[MAX_SWITCH_I_CPLBS];
-u_long dpdt_swapcount_table[MAX_SWITCH_D_CPLBS];
-#endif
-
-struct s_cplb {
-	struct cplb_tab init_i;
-	struct cplb_tab init_d;
-	struct cplb_tab switch_i;
-	struct cplb_tab switch_d;
-};
-
-#if defined(CONFIG_BLKFIN_DCACHE) || defined(CONFIG_BLKFIN_CACHE)
-static struct cplb_desc cplb_data[] = {
-	{
-		.start = 0,
-		.end = SIZE_4K,
-		.psize = SIZE_4K,
-		.attr = INITIAL_T | SWITCH_T | I_CPLB | D_CPLB,
-		.i_conf = SDRAM_OOPS,
-		.d_conf = SDRAM_OOPS,
-#if defined(CONFIG_DEBUG_HUNT_FOR_ZERO)
-		.valid = 1,
-#else
-		.valid = 0,
-#endif
-		.name = "ZERO Pointer Saveguard",
-	},
-	{
-		.start = L1_CODE_START,
-		.end = L1_CODE_START + L1_CODE_LENGTH,
-		.psize = SIZE_4M,
-		.attr = INITIAL_T | SWITCH_T | I_CPLB,
-		.i_conf = L1_IMEMORY,
-		.d_conf = 0,
-		.valid = 1,
-		.name = "L1 I-Memory",
-	},
-	{
-		.start = L1_DATA_A_START,
-		.end = L1_DATA_B_START + L1_DATA_B_LENGTH,
-		.psize = SIZE_4M,
-		.attr = INITIAL_T | SWITCH_T | D_CPLB,
-		.i_conf = 0,
-		.d_conf = L1_DMEMORY,
-#if defined(CONFIG_BF536)
-		.valid = 0,
-#else
-		.valid = 1,
-#endif
-		.name = "L1 D-Memory",
-	},
-	{
-		.start = 0,
-		.end = 0,  /* dynamic */
-		.psize = 0,
-		.attr = INITIAL_T | SWITCH_T | I_CPLB | D_CPLB,
-		.i_conf =  SDRAM_IGENERIC,
-		.d_conf =  SDRAM_DGENERIC,
-		.valid = 1,
-		.name = "SDRAM Kernel",
-	},
-	{
-		.start = 0, /* dynamic */
-		.end = 0, /* dynamic */
-		.psize = 0,
-		.attr = INITIAL_T | SWITCH_T | D_CPLB,
-		.i_conf =  SDRAM_IGENERIC,
-		.d_conf =  SDRAM_DNON_CHBL,
-		.valid = 1,
-		.name = "SDRAM RAM MTD",
-	},
-	{
-		.start = 0, /* dynamic */
-		.end = 0,   /* dynamic */
-		.psize = SIZE_1M,
-		.attr = INITIAL_T | SWITCH_T | D_CPLB,
-		.d_conf = SDRAM_DNON_CHBL,
-		.valid = 1,//(DMA_UNCACHED_REGION > 0),
-		.name = "SDRAM Uncached DMA ZONE",
-	},
-	{
-		.start = 0, /* dynamic */
-		.end = 0, /* dynamic */
-		.psize = 0,
-		.attr = SWITCH_T | D_CPLB,
-		.i_conf = 0, /* dynamic */
-		.d_conf = 0, /* dynamic */
-		.valid = 1,
-		.name = "SDRAM Reserved Memory",
-	},
-	{
-		.start = ASYNC_BANK0_BASE,
-		.end = ASYNC_BANK3_BASE + ASYNC_BANK3_SIZE,
-		.psize = 0,
-		.attr = SWITCH_T | D_CPLB,
-		.d_conf = SDRAM_EBIU,
-		.valid = 1,
-		.name = "ASYNC Memory",
-	},
-	{
-#if defined(CONFIG_BF561)
-		.start = L2_SRAM,
-		.end = L2_SRAM_END,
-		.psize = SIZE_1M,
-		.attr = SWITCH_T | D_CPLB,
-		.i_conf = L2_MEMORY,
-		.d_conf = L2_MEMORY,
-		.valid = 1,
-#else
-		.valid = 0,
-#endif
-		.name = "L2 Memory",
-	}
-};
-#endif
+/*
+ * File:         include/asm-blackfin/cplbinit.h
+ * Based on:
+ * Author:
+ *
+ * Created:
+ * Description:
+ *
+ * Modified:
+ *               Copyright 2004-2006 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <asm/blackfin.h>
+#include <asm/cplb.h>
+
+#define INITIAL_T 0x1
+#define SWITCH_T  0x2
+#define I_CPLB    0x4
+#define D_CPLB    0x8
+
+#define IN_KERNEL 1
+
+enum
+{ZERO_P, L1I_MEM, L1D_MEM, SDRAM_KERN , SDRAM_RAM_MTD, SDRAM_DMAZ, RES_MEM, ASYNC_MEM, L2_MEM};
+
+struct cplb_desc {
+	u32 start; /* start address */
+	u32 end; /* end address */
+	u32 psize; /* prefered size if any otherwise 1MB or 4MB*/
+	u16 attr;/* attributes */
+	u16 i_conf;/* I-CPLB DATA */
+	u16 d_conf;/* D-CPLB DATA */
+	u16 valid;/* valid */
+	const s8 name[30];/* name */
+};
+
+struct cplb_tab {
+  u_long *tab;
+	u16 pos;
+	u16 size;
+};
+
+u_long icplb_table[MAX_CPLBS+1];
+u_long dcplb_table[MAX_CPLBS+1];
+
+/* Till here we are discussing about the static memory management model.
+ * However, the operating envoronments commonly define more CPLB
+ * descriptors to cover the entire addressable memory than will fit into
+ * the available on-chip 16 CPLB MMRs. When this happens, the below table
+ * will be used which will hold all the potentially required CPLB descriptors
+ *
+ * This is how Page descriptor Table is implemented in uClinux/Blackfin.
+ */
+
+#ifdef CONFIG_CPLB_SWITCH_TAB_L1
+u_long ipdt_table[MAX_SWITCH_I_CPLBS+1]__attribute__((l1_data));
+u_long dpdt_table[MAX_SWITCH_D_CPLBS+1]__attribute__((l1_data));
+
+#ifdef CONFIG_CPLB_INFO
+u_long ipdt_swapcount_table[MAX_SWITCH_I_CPLBS]__attribute__((l1_data));
+u_long dpdt_swapcount_table[MAX_SWITCH_D_CPLBS]__attribute__((l1_data));
+#endif /* CONFIG_CPLB_INFO */
+
+#else
+
+u_long ipdt_table[MAX_SWITCH_I_CPLBS+1];
+u_long dpdt_table[MAX_SWITCH_D_CPLBS+1];
+
+#ifdef CONFIG_CPLB_INFO
+u_long ipdt_swapcount_table[MAX_SWITCH_I_CPLBS];
+u_long dpdt_swapcount_table[MAX_SWITCH_D_CPLBS];
+#endif /* CONFIG_CPLB_INFO */
+
+#endif /*CONFIG_CPLB_SWITCH_TAB_L1*/
+
+struct s_cplb {
+	struct cplb_tab init_i;
+	struct cplb_tab init_d;
+	struct cplb_tab switch_i;
+	struct cplb_tab switch_d;
+};
+
+#if defined(CONFIG_BLKFIN_DCACHE) || defined(CONFIG_BLKFIN_CACHE)
+static struct cplb_desc cplb_data[] = {
+	{
+		.start = 0,
+		.end = SIZE_4K,
+		.psize = SIZE_4K,
+		.attr = INITIAL_T | SWITCH_T | I_CPLB | D_CPLB,
+		.i_conf = SDRAM_OOPS,
+		.d_conf = SDRAM_OOPS,
+#if defined(CONFIG_DEBUG_HUNT_FOR_ZERO)
+		.valid = 1,
+#else
+		.valid = 0,
+#endif
+		.name = "ZERO Pointer Saveguard",
+	},
+	{
+		.start = L1_CODE_START,
+		.end = L1_CODE_START + L1_CODE_LENGTH,
+		.psize = SIZE_4M,
+		.attr = INITIAL_T | SWITCH_T | I_CPLB,
+		.i_conf = L1_IMEMORY,
+		.d_conf = 0,
+		.valid = 1,
+		.name = "L1 I-Memory",
+	},
+	{
+		.start = L1_DATA_A_START,
+		.end = L1_DATA_B_START + L1_DATA_B_LENGTH,
+		.psize = SIZE_4M,
+		.attr = INITIAL_T | SWITCH_T | D_CPLB,
+		.i_conf = 0,
+		.d_conf = L1_DMEMORY,
+#if ((L1_DATA_A_LENGTH > 0) || (L1_DATA_B_LENGTH > 0))
+		.valid = 1,
+#else
+		.valid = 0,
+#endif
+		.name = "L1 D-Memory",
+	},
+	{
+		.start = 0,
+		.end = 0,  /* dynamic */
+		.psize = 0,
+		.attr = INITIAL_T | SWITCH_T | I_CPLB | D_CPLB,
+		.i_conf =  SDRAM_IGENERIC,
+		.d_conf =  SDRAM_DGENERIC,
+		.valid = 1,
+		.name = "SDRAM Kernel",
+	},
+	{
+		.start = 0, /* dynamic */
+		.end = 0, /* dynamic */
+		.psize = 0,
+		.attr = INITIAL_T | SWITCH_T | D_CPLB,
+		.i_conf =  SDRAM_IGENERIC,
+		.d_conf =  SDRAM_DNON_CHBL,
+		.valid = 1,
+		.name = "SDRAM RAM MTD",
+	},
+	{
+		.start = 0, /* dynamic */
+		.end = 0,   /* dynamic */
+		.psize = SIZE_1M,
+		.attr = INITIAL_T | SWITCH_T | D_CPLB,
+		.d_conf = SDRAM_DNON_CHBL,
+		.valid = 1,//(DMA_UNCACHED_REGION > 0),
+		.name = "SDRAM Uncached DMA ZONE",
+	},
+	{
+		.start = 0, /* dynamic */
+		.end = 0, /* dynamic */
+		.psize = 0,
+		.attr = SWITCH_T | D_CPLB,
+		.i_conf = 0, /* dynamic */
+		.d_conf = 0, /* dynamic */
+		.valid = 1,
+		.name = "SDRAM Reserved Memory",
+	},
+	{
+		.start = ASYNC_BANK0_BASE,
+		.end = ASYNC_BANK3_BASE + ASYNC_BANK3_SIZE,
+		.psize = 0,
+		.attr = SWITCH_T | D_CPLB,
+		.d_conf = SDRAM_EBIU,
+		.valid = 1,
+		.name = "ASYNC Memory",
+	},
+	{
+#if defined(CONFIG_BF561)
+		.start = L2_SRAM,
+		.end = L2_SRAM_END,
+		.psize = SIZE_1M,
+		.attr = SWITCH_T | D_CPLB,
+		.i_conf = L2_MEMORY,
+		.d_conf = L2_MEMORY,
+		.valid = 1,
+#else
+		.valid = 0,
+#endif
+		.name = "L2 Memory",
+	}
+};
+#endif
diff -puN include/asm-blackfin/delay.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/delay.h
--- a/include/asm-blackfin/delay.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/delay.h
@@ -7,10 +7,11 @@ static inline void __delay(unsigned long
 /* FIXME: Currently the assembler doesn't recognize Loop Register Clobbers,
    uncomment this as soon those are implemented */
 /*
-      __asm__ __volatile__ (  "\t LSETUP (1,1) LC0= %0\n\t"
-                              "l:\t NOP;\n\t"
+      __asm__ __volatile__ (  "\t LSETUP (1f,1f) LC0= %0\n\t"
+                              "1:\t NOP;\n\t"
                               : :"a" (loops)
                               : "LT0","LB0","LC0");
+
 */
 
 	__asm__ __volatile__("[--SP] = LC0;\n\t"
diff -puN include/asm-blackfin/dma-mapping.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/dma-mapping.h
--- a/include/asm-blackfin/dma-mapping.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/dma-mapping.h
@@ -27,12 +27,8 @@ extern dma_addr_t dma_map_single(struct 
  * After this call, reads by the cpu to the buffer are guarenteed to see
  * whatever the device wrote there.
  */
-static inline
-    void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-			  enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
+extern void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
+			  enum dma_data_direction direction);
 
 /*
  * Map a set of buffers described by scatterlist in streaming
@@ -58,11 +54,12 @@ extern int dma_map_sg(struct device *dev
  * Again, cpu read rules concerning calls here are the same as for
  * pci_unmap_single() above.
  */
-static inline
-    void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
-		      int nhwentries, enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
+extern void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
+		      int nhwentries, enum dma_data_direction direction);
+
+/* Now for the API extensions over the pci_ one */
+
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
 #endif				/* _BLACKFIN_DMA_MAPPING_H */
diff -puN include/asm-blackfin/dma.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/dma.h
--- a/include/asm-blackfin/dma.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/dma.h
@@ -6,7 +6,6 @@
  * Created:      Tue Sep 21 2004
  * Description:  This file contains the major Data structures and constants
  * 		 used for DMA Implementation in BF533
- * Rev:          $Id: dma.h,v 1.20 2006/11/01 05:27:32 magicyang Exp $
  * Modified:
  *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
@@ -44,23 +43,11 @@
 
 #define MAX_DMA_ADDRESS PAGE_OFFSET
 
-#undef BFIN_DMA_NDEBUG
-
-#ifdef BFIN_DMA_NDEBUG
-#define assert(expr) do {} while(0)
-#else
-#define assert(expr) 						\
-	if (!(expr)) {						\
-	printk(KERN_INFO "Assertion failed! %s, %s, %s, line=%d \n",	\
-	#expr, __FILE__,__FUNCTION__,__LINE__); 		\
-	}
-#endif
-
 /*****************************************************************************
 *        Generic DMA  Declarations
 *
 ****************************************************************************/
-enum dma_chan_status_t {
+enum dma_chan_status {
 	DMA_CHANNEL_FREE,
 	DMA_CHANNEL_REQUESTED,
 	DMA_CHANNEL_ENABLED,
@@ -89,8 +76,7 @@ enum dma_chan_status_t {
 #define INTR_ON_BUF    2
 #define INTR_ON_ROW    3
 
-#pragma pack(2)
-struct dmasg_t {
+struct dmasg {
 	unsigned long next_desc_addr;
 	unsigned long start_addr;
 	unsigned short cfg;
@@ -99,9 +85,8 @@ struct dmasg_t {
 	unsigned short y_count;
 	short y_modify;
 };
-#pragma pack()
 
-struct dma_register_t {
+struct dma_register {
 	unsigned long next_desc_ptr;	/* DMA Next Descriptor Pointer register */
 	unsigned long start_addr;	/* DMA Start address  register */
 
@@ -148,12 +133,12 @@ struct dma_register_t {
 
 typedef irqreturn_t(*dma_interrupt_t) (int irq, void *dev_id);
 
-struct dma_channel_t {
-	struct semaphore dmalock;
+struct dma_channel {
+	struct mutex dmalock;
 	char *device_id;
-	enum dma_chan_status_t chan_status;
-	struct dma_register_t *regs;
-	struct dmasg_t *sg;		/* large mode descriptor */
+	enum dma_chan_status chan_status;
+	struct dma_register *regs;
+	struct dmasg *sg;		/* large mode descriptor */
 	unsigned int ctrl_num;	/* controller number */
 	dma_interrupt_t irq_callback;
 	void *data;
@@ -181,7 +166,7 @@ unsigned short get_dma_curr_xcount(unsig
 unsigned short get_dma_curr_ycount(unsigned int channel);
 
 /* set large DMA mode descriptor */
-void set_dma_sg(unsigned int channel, struct dmasg_t *sg, int nr_sg);
+void set_dma_sg(unsigned int channel, struct dmasg *sg, int nr_sg);
 
 /* check if current channel is in use */
 int dma_channel_active(unsigned int channel);
diff -puN include/asm-blackfin/dpmc.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/dpmc.h
--- a/include/asm-blackfin/dpmc.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/dpmc.h
@@ -38,6 +38,8 @@
 #define ON	0
 #define OFF	1
 
+#ifdef __KERNEL__
+
 unsigned long calc_volt(void);
 int calc_vlev(int vlt);
 unsigned long change_voltage(unsigned long volt);
@@ -63,4 +65,6 @@ void disable_wdog_timer(void);
 extern unsigned long get_cclk(void);
 extern unsigned long get_sclk(void);
 
+#endif	/* __KERNEL__ */
+
 #endif	/*_BLACKFIN_DPMC_H_*/
diff -puN include/asm-blackfin/entry.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/entry.h
--- a/include/asm-blackfin/entry.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/entry.h
@@ -52,10 +52,5 @@
 #define RESTORE_ALL_SYS		restore_context_no_interrupts
 #define RESTORE_CONTEXT		restore_context_with_interrupts
 
-#define STR(X) STR1(X)
-#define STR1(X) #X
-# define PT_OFF_ORIG_P0		208
-# define PT_OFF_SR		8
-
 #endif				/* __ASSEMBLY__ */
 #endif				/* __BFIN_ENTRY_H */
diff -puN include/asm-blackfin/flat.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/flat.h
--- a/include/asm-blackfin/flat.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/flat.h
@@ -14,6 +14,14 @@
 #define	flat_argvp_envp_on_stack()		0
 #define	flat_old_ram_flag(flags)		(flags)
 
+extern unsigned long bfin_get_addr_from_rp (unsigned long *ptr,
+					unsigned long relval,
+					unsigned long flags,
+					unsigned long *persistent);
+
+extern void bfin_put_addr_at_rp(unsigned long *ptr, unsigned long addr,
+		                unsigned long relval);
+
 /* The amount by which a relocation can exceed the program image limits
    without being regarded as an error.  */
 
@@ -24,10 +32,6 @@
 #define	flat_put_addr_at_rp(rp, val, relval)	\
 	bfin_put_addr_at_rp(rp, val, relval)
 
-#define FLAT_BFIN_RELOC_TYPE_16_BIT 0
-#define FLAT_BFIN_RELOC_TYPE_16H_BIT 1
-#define FLAT_BFIN_RELOC_TYPE_32_BIT 2
-
 /* Convert a relocation entry into an address.  */
 static inline unsigned long
 flat_get_relocate_addr (unsigned long relval)
@@ -51,80 +55,4 @@ static inline int flat_addr_absolute(uns
 	return (relval & (1 << 29)) != 0;
 }
 
-static inline unsigned long bfin_get_addr_from_rp(unsigned long *ptr,
-						  unsigned long relval,
-						  unsigned long flags,
-						  unsigned long *persistent)
-{
-	unsigned short *usptr = (unsigned short *)ptr;
-	int type = (relval >> 26) & 7;
-	unsigned long val;
-
-	switch (type) {
-	case FLAT_BFIN_RELOC_TYPE_16_BIT:
-	case FLAT_BFIN_RELOC_TYPE_16H_BIT:
-		usptr = (unsigned short *)ptr;
-#ifdef DEBUG_BFIN_RELOC
-		printk(KERN_INFO " *usptr = %x", get_unaligned(usptr));
-#endif
-		val = get_unaligned(usptr);
-		val += *persistent;
-		break;
-
-	case FLAT_BFIN_RELOC_TYPE_32_BIT:
-#ifdef DEBUG_BFIN_RELOC
-		printk(KERN_INFO " *ptr = %x", get_unaligned(ptr));
-#endif
-		val = get_unaligned(ptr);
-		break;
-
-	default:
-		printk(KERN_INFO "BINFMT_FLAT: Unknown relocation type %x\n",
-			type);
-		return 0;
-	}
-
-	/* Stack-relative relocs contain the offset into the stack, we
-	   have to add the stack's start address here and return 1 from
-	   flat_addr_absolute to prevent the normal address calculations.  */
-	if (relval & (1 << 29))
-		return val + current->mm->context.end_brk;
-
-	if ((flags & FLAT_FLAG_GOTPIC) == 0)
-		val = htonl(val);
-	return val;
-}
-
-/* Insert the address ADDR into the symbol reference at RP;
-   RELVAL is the raw relocation-table entry from which RP is derived.  */
-static inline void bfin_put_addr_at_rp(unsigned long *ptr, unsigned long addr,
-				       unsigned long relval)
-{
-	unsigned short *usptr = (unsigned short *)ptr;
-	int type = (relval >> 26) & 7;
-
-	switch (type) {
-	case FLAT_BFIN_RELOC_TYPE_16_BIT:
-		put_unaligned(addr, usptr);
-#ifdef DEBUG_BFIN_RELOC
-		printk(KERN_INFO " new value %x at %p", get_unaligned(usptr), usptr);
-#endif
-		break;
-
-	case FLAT_BFIN_RELOC_TYPE_16H_BIT:
-		put_unaligned(addr >> 16, usptr);
-#ifdef DEBUG_BFIN_RELOC
-		printk(KERN_INFO " new value %x", get_unaligned(usptr));
-#endif
-		break;
-
-	case FLAT_BFIN_RELOC_TYPE_32_BIT:
-		put_unaligned(addr, ptr);
-#ifdef DEBUG_BFIN_RELOC
-		printk(KERN_INFO " new ptr =%x", get_unaligned(ptr));
-#endif
-		break;
-	}
-}
-
 #endif				/* __BLACKFIN_FLAT_H__ */
diff -puN include/asm-blackfin/io.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/io.h
--- a/include/asm-blackfin/io.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/io.h
@@ -18,29 +18,53 @@
  * differently. On the bfin architecture, we just read/write the
  * memory location directly.
  */
-#define readb(addr) ({ unsigned __v; \
-		       int _tmp; \
-		       __asm__ __volatile__ ("cli %1;\n\t"\
-	         			 "NOP;NOP;SSYNC;\n\t"\
-					     "%0 = b [%2] (z);\n\t"\
-					     "sti %1;\n\t" \
-  : "=d"(__v), "=d"(_tmp): "a"(addr)); (unsigned char)__v; })
-
-#define readw(addr) ({ unsigned __v; \
-					   int _tmp; \
-                       __asm__ __volatile__ ("cli %1;\n\t"\
-	         			    				 "NOP;NOP;SSYNC;\n\t"\
-	         			     				 "%0 = w [%2] (z);\n\t"\
-                                             "sti %1;\n\t" \
-  : "=d"(__v), "=d"(_tmp): "a"(addr)); (unsigned short)__v; })
-
-#define readl(addr) ({ unsigned __v; \
-					   int _tmp; \
-                      __asm__ __volatile__ ("cli %1;\n\t"\
-	         			    				 "NOP;NOP;SSYNC;\n\t"\
-                                            "%0 = [%2];\n\t"\
-                                            "sti %1;\n\t" \
-  : "=d"(__v), "=d"(_tmp): "a"(addr)); __v; })
+#ifndef __ASSEMBLY__
+
+static inline unsigned char readb(void __iomem *addr)
+{
+	unsigned int val;
+	int tmp;
+
+	__asm__ __volatile__ ("cli %1;\n\t"
+			"NOP; NOP; SSYNC;\n\t"
+			"%0 = b [%2] (z);\n\t"
+			"sti %1;\n\t"
+			: "=d"(val), "=d"(tmp): "a"(addr)
+			);
+
+	return (unsigned char) val;
+}
+
+static inline unsigned short readw(void __iomem *addr)
+{
+	unsigned int val;
+	int tmp;
+
+	__asm__ __volatile__ ("cli %1;\n\t"
+			"NOP; NOP; SSYNC;\n\t"
+			"%0 = w [%2] (z);\n\t"
+			"sti %1;\n\t"
+		      	: "=d"(val), "=d"(tmp): "a"(addr)
+			);
+
+	return (unsigned short) val;
+}
+
+static inline unsigned int readl(void __iomem *addr)
+{
+	unsigned int val;
+	int tmp;
+
+	__asm__ __volatile__ ("cli %1;\n\t"
+			"NOP; NOP; SSYNC;\n\t"
+			"%0 = [%2];\n\t"
+			"sti %1;\n\t"
+		      	: "=d"(val), "=d"(tmp): "a"(addr)
+			);
+	return val;
+}
+
+#endif /*  __ASSEMBLY__ */
 
 #define writeb(b,addr) (void)((*(volatile unsigned char *) (addr)) = (b))
 #define writew(b,addr) (void)((*(volatile unsigned short *) (addr)) = (b))
@@ -99,9 +123,40 @@ extern void insb(const void __iomem *por
 extern void insw(const void __iomem *port, void *addr, unsigned long count);
 extern void insl(const void __iomem *port, void *addr, unsigned long count);
 
-extern void *__ioremap(unsigned long physaddr, unsigned long size,
-		       int cacheflag);
-extern void iounmap(void *addr);
+/*
+ * Map some physical address range into the kernel address space.
+ */
+static inline void __iomem *__ioremap(unsigned long physaddr, unsigned long size,
+				int cacheflag)
+{
+	return (void __iomem *)physaddr;
+}
+
+/*
+ * Unmap a ioremap()ed region again
+ */
+static inline void iounmap(void *addr)
+{
+}
+
+/*
+ * __iounmap unmaps nearly everything, so be careful
+ * it doesn't free currently pointer/page tables anymore but it
+ * wans't used anyway and might be added later.
+ */
+static inline void __iounmap(void *addr, unsigned long size)
+{
+}
+
+/*
+ * Set new cache mode for some kernel address space.
+ * The caller must push data for that range itself, if such data may already
+ * be in the cache.
+ */
+static inline void kernel_set_cachemode(void *addr, unsigned long size,
+					int cmode)
+{
+}
 
 static inline void __iomem *ioremap(unsigned long physaddr, unsigned long size)
 {
diff -puN include/asm-blackfin/irq.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/irq.h
--- a/include/asm-blackfin/irq.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/irq.h
@@ -53,8 +53,6 @@
  *                                                      01/11/97 - Jes
  */
 
-extern void sys_free_irq(unsigned int irq, void *dev_id);
-
 extern void ack_bad_irq(unsigned int irq);
 
 static __inline__ int irq_canonicalize(int irq)
diff -puN /dev/null include/asm-blackfin/irq_handler.h
--- /dev/null
+++ a/include/asm-blackfin/irq_handler.h
@@ -0,0 +1,22 @@
+#ifndef _IRQ_HANDLER_H
+#define _IRQ_HANDLER_H
+
+/* BASE LEVEL interrupt handler routines */
+asmlinkage void evt_emulation(void);
+asmlinkage void evt_exception(void);
+asmlinkage void trap(void);
+asmlinkage void evt_ivhw(void);
+asmlinkage void evt_timer(void);
+asmlinkage void evt_evt2(void);
+asmlinkage void evt_evt7(void);
+asmlinkage void evt_evt8(void);
+asmlinkage void evt_evt9(void);
+asmlinkage void evt_evt10(void);
+asmlinkage void evt_evt11(void);
+asmlinkage void evt_evt12(void);
+asmlinkage void evt_evt13(void);
+asmlinkage void evt_soft_int1(void);
+asmlinkage void evt_system_call(void);
+asmlinkage void init_exception_buff(void);
+
+#endif
diff -puN include/asm-blackfin/mach-bf533/bf533.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/mach-bf533/bf533.h
--- a/include/asm-blackfin/mach-bf533/bf533.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/mach-bf533/bf533.h
@@ -6,8 +6,6 @@
  * Created:
  * Description:  SYSTEM MMR REGISTER AND MEMORY MAP FOR ADSP-BF561
  *
- * Rev:          $Id: bf533.h,v 1.25 2006/11/20 18:20:19 rgetz Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -53,15 +51,6 @@
 
 /***************************/
 
-#define BLKFIN_ICACHESIZE	(16*1024)
-
-#if defined(CONFIG_BF533) || defined(CONFIG_BF532)
-#define BLKFIN_DCACHESIZE	(32*1024)
-#define BLKFIN_DSUPBANKS	2
-#else
-#define BLKFIN_DCACHESIZE	(16*1024)
-#define BLKFIN_DSUPBANKS	1
-#endif
 
 #define BLKFIN_DSUBBANKS	4
 #define BLKFIN_DWAYS		2
@@ -280,7 +269,7 @@
 			| CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND)
 #endif
 
-#define L1_DMEMORY       (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY)
+#define L1_DMEMORY       (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_LOCK | CPLB_DIRTY)
 #define SDRAM_DNON_CHBL  (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY)
 #define SDRAM_EBIU       (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY)
 #define SDRAM_OOPS  	 (CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_LOCK | CPLB_DIRTY)
diff -puN include/asm-blackfin/mach-bf533/mem_map.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/mach-bf533/mem_map.h
--- a/include/asm-blackfin/mach-bf533/mem_map.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/mach-bf533/mem_map.h
@@ -11,7 +11,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
@@ -52,6 +51,12 @@
 
 /* Level 1 Memory */
 
+#ifdef CONFIG_BLKFIN_CACHE
+#define BLKFIN_ICACHESIZE	(16*1024)
+#else
+#define BLKFIN_ICACHESIZE	(0*1024)
+#endif
+
 /* Memory Map for ADSP-BF533 processors */
 
 #ifdef CONFIG_BF533
@@ -66,18 +71,28 @@
 #endif
 
 #ifdef CONFIG_BLKFIN_DCACHE
-#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+
+#ifdef CONFIG_BLKFIN_DCACHE_BANKA
+#define DMEM_CNTR (ACACHE_BSRAM | ENDCPLB | PORT_PREF0)
 #define L1_DATA_A_LENGTH      (0x8000 - 0x4000)
+#define L1_DATA_B_LENGTH      0x8000
+#define BLKFIN_DCACHESIZE	(16*1024)
+#define BLKFIN_DSUPBANKS	1
 #else
-#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
-#define L1_DATA_A_LENGTH      0x8000
+#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      (0x8000 - 0x4000)
+#define L1_DATA_B_LENGTH      (0x8000 - 0x4000)
+#define BLKFIN_DCACHESIZE	(32*1024)
+#define BLKFIN_DSUPBANKS	2
 #endif
 
-#ifdef CONFIG_BLKFIN_DCACHE
-#define L1_DATA_B_LENGTH      (0x8000 - 0x4000)
 #else
+#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      0x8000
 #define L1_DATA_B_LENGTH      0x8000
-#endif
+#define BLKFIN_DCACHESIZE	(0*1024)
+#define BLKFIN_DSUPBANKS	0
+#endif /*CONFIG_BLKFIN_DCACHE*/
 #endif
 
 /* Memory Map for ADSP-BF532 processors */
@@ -94,18 +109,29 @@
 #endif
 
 #ifdef CONFIG_BLKFIN_DCACHE
-#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+
+#ifdef CONFIG_BLKFIN_DCACHE_BANKA
+#define DMEM_CNTR (ACACHE_BSRAM | ENDCPLB | PORT_PREF0)
 #define L1_DATA_A_LENGTH      (0x4000 - 0x4000)
+#define L1_DATA_B_LENGTH      0x4000
+#define BLKFIN_DCACHESIZE	(16*1024)
+#define BLKFIN_DSUPBANKS	1
+
 #else
-#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
-#define L1_DATA_A_LENGTH      0x4000
+#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      (0x4000 - 0x4000)
+#define L1_DATA_B_LENGTH      (0x4000 - 0x4000)
+#define BLKFIN_DCACHESIZE	(32*1024)
+#define BLKFIN_DSUPBANKS	2
 #endif
 
-#ifdef CONFIG_BLKFIN_DCACHE
-#define L1_DATA_B_LENGTH      (0x4000 - 0x4000)
 #else
+#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      0x4000
 #define L1_DATA_B_LENGTH      0x4000
-#endif
+#define BLKFIN_DCACHESIZE	(0*1024)
+#define BLKFIN_DSUPBANKS	0
+#endif /*CONFIG_BLKFIN_DCACHE*/
 #endif
 
 /* Memory Map for ADSP-BF531 processors */
@@ -116,13 +142,20 @@
 #define L1_DATA_B_START     0xFF904000
 #define L1_CODE_LENGTH      0x4000
 #define L1_DATA_B_LENGTH      0x0000
+
+
 #ifdef CONFIG_BLKFIN_DCACHE
-#define DMEM_CNTR (ACACHE_BSRAM | ENDCPLB)
+#define DMEM_CNTR (ACACHE_BSRAM | ENDCPLB  | PORT_PREF0)
 #define L1_DATA_A_LENGTH      (0x4000 - 0x4000)
+#define BLKFIN_DCACHESIZE	(16*1024)
+#define BLKFIN_DSUPBANKS	1
 #else
-#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB)
+#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB  | PORT_PREF0)
 #define L1_DATA_A_LENGTH      0x4000
+#define BLKFIN_DCACHESIZE	(0*1024)
+#define BLKFIN_DSUPBANKS	0
 #endif
+
 #endif
 
 /* Scratch Pad Memory */
diff -puN include/asm-blackfin/mach-bf535/bf535.h~blackfin-arch-2.6.21-rc4-mm1-update /dev/null
--- a/include/asm-blackfin/mach-bf535/bf535.h
+++ /dev/null
@@ -1,1277 +0,0 @@
-/*
- * File:         include/asm-blackfin/mach-bf535/bf535.h
- * Based on:
- * Author:
- *
- * Created:
- * Description:  SYSTEM MMR REGISTER AND MEMORY MAP FOR ADSP-BF561
- *
- * Rev:          $Id: bf535.h,v 1.6 2006/09/25 23:17:44 vapier Exp $
- *
- * Modified:
- *               Copyright 2004-2006 Analog Devices Inc.
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see the file COPYING, or write
- * to the Free Software Foundation, Inc.,
- * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-/* FOR BlackFin DSP:     BYTE = 08 bits,  HALFWORD = 16 bit & WORD = 32 bits    */
-
-#ifndef __MACH_BF535_H__
-#define __MACH_BF535_H__
-
-#define BYTE_REF(addr)		 (*((volatile unsigned char*)addr))
-#define HALFWORD_REF(addr) 	 (*((volatile unsigned short*)addr))
-#define WORD_REF(addr)		 (*((volatile unsigned long*)addr))
-
-/*
- * Typedefs
- */
-
-#define PUT_FIELD(field, val) (((val) << field##_SHIFT) & field##_MASK)	/* ?  */
-#define GET_FIELD(reg, field) (((reg) & field##_MASK) >> field##_SHIFT)	/*  ?   */
-
-/*      FOLLOWING ARE THE BlackFin SYSTEM MMR REGISTERS (LOWER 2 MB)     */
-
-/**************************
- *
- * L2 MULTIPLE INPUT SIGNATURE REGISTERS (MISR) (0XFFC0000 - 0XFFC003FF)
- *
- **************************/
-
-#define MISR_CTL_ADDR		0xffc00000	/* Control register 32 bit */
-#define MISR_CTL			WORD_REF(MISR_CTL_ADDR)
-#define MISR_RMISR0_ADDR	0xffc00004	/* CoreL2[31:0] read bus register 32 bit */
-#define MISR_RMISR0			WORD_REF(MISR_RMISR0_ADDR)
-#define MISR_RMISR1_ADDR	0xffc00008	/* CoreL2[63:32] read bus register 32 bit */
-#define MISR_RMISR1			WORD_REF(MISR_RMISR1_ADDR)
-#define MISR_RMISR2_ADDR	0xffc0000C	/* SysL2[31:0] read bus register 32 bit */
-#define MISR_RMISR2			WORD_REF(MISR_RMISR2_ADDR)
-#define MISR_WMISR0_ADDR	0xffc00010	/* CoreL2[31:0] write bus register 32 bit */
-#define MISR_WMISR0			WORD_REF(MISR_WMISR0_ADDR)
-#define MISR_WMISR1_ADDR	0xffc00014	/* CoreL2[63:32] write bus register 32 bit */
-#define MISR_WMISR1			WORD_REF(MISR_WMISR1_ADDR)
-#define MISR_WMISR2_ADDR	0xffc00018	/* SysL2[31:0] write bus register 32 bit */
-#define MISR_WMISR2			WORD_REF(MISR_WMISR2_ADDR)
-
-/**************************
- *
- * CLOCK & SYSTEM CONTROL (0XFFC0400 - 0XFFC007FF)
- *
- **************************/
-
-#define PLLCTL_ADDR			0xffc00400	/* PLL control register 32 bit */
-#define PLLCTL				WORD_REF(PLLCTL_ADDR)
-#define PLLSTAT_ADDR		0xffc00404	/* PLL status register 16 bit */
-#define PLLSTAT				HALFWORD_REF(PLLSTAT_ADDR)
-#define LOCKCNT_ADDR		0xffc00406	/* PLL lock counter register 16 bit */
-#define LOCKCNT				HALFWORD_REF(LOCKCNT_ADDR)
-#define IOCKR_ADDR			0xffc00408	/* Peripheral clock enable register 16 bit */
-#define IOCKR				HALFWORD_REF(IOCKR_ADDR)
-#define SWRST_ADDR			0xffc00410	/* Software reset register 16 bit */
-#define SWRST				HALFWORD_REF(SWRST_ADDR)
-#define NXTSCR_ADDR			0xffc00412	/* Next system configuration register 16 bit */
-#define NXTSCR				HALFWORD_REF(NXTSCR_ADDR)
-#define SYSCR_ADDR			0xffc00414	/* Sytem Configuration register */
-#define SYSCR 				HALFWORD_REF(SYSCR_ADDR)
-
-/**************************
- *
- * JTAG/DEBUG COMMUNICATION CHANNEL (0XFFC00800 - 0XFFC00BFF)
- *
- **************************/
-
-#define INDATA_ADDR			0xffc00800	/* Indata register 16 bit */
-#define INDATA				HALFWORD_REF(INDATA_ADDR)
-#define OUTDATA_ADDR		0xffc00802	/*  Outdata register  16 bit */
-#define OUTDATA				HALFWORD_REF(OUTDATA_ADDR)
-#define JDCSR_ADDR			0xffc00804	/*  JDCC Control/Status register 32 bit */
-#define JDCSR				WORD_REF(JDCSR_ADDR)
-#define IDDEV_ADDR			0xffc00808	/*  Device ID register  32 bit */
-#define IDDEV				WORD_REF(IDDEV_ADDR)
-#define IDCORE_ADDR			0xffc0080c	/*  Core ID register 32 bit */
-#define IDCORE				WORD_REF(IDCORE_ADDR)
-
-/****************************
- *
- *  EXTENDED CORE INTERRUPT CONTROLLER (ECIC) 0XFFC00C00 - 0XFFC0OFFF
- *
- ****************************/
-
-#define RVECT_ADDR			0xffc00c00	/* Reset vector register 32 bit */
-#define RVECT				WORD_REF(RVECT_ADDR)
-#define IAR0_ADDR			0xffc00c04	/* Interrupt assignment register 0 32 bit */
-#define IAR0				WORD_REF(IAR0_ADDR)
-#define IAR1_ADDR			0xffc00c08	/* Interrupt assignment register 1 32 bit */
-#define IAR1				WORD_REF(IAR1_ADDR)
-#define IAR2_ADDR			0xffc00c0c	/* Interrupt assignment register 2 32 bit */
-#define IAR2				WORD_REF(IAR2_ADDR)
-#define IMR_ADDR			0xffc00c10	/* Interrupt mask register  32 bit */
-#define IMR				WORD_REF(IMR_ADDR)
-#define ISR_ADDR			0xffc00c14	/* Interrupt status register  32 bit */
-#define ISR				WORD_REF(ISR_ADDR)
-#define IWR_ADDR			0xffc00c18	/* Interrupt wakeup register  32 bit */
-#define IWR				WORD_REF(IWR_ADDR)
-
-/****************************
- *
- *  WATCHDOG TIMER  (0XFFC01000 - 0XFFC013F)
- *
- ****************************/
-
-#define WDOGCTL_ADDR		0xffc01000	/* Watchdog control register  32 bit */
-#define WDOGCTL				WORD_REF(WDOGCTL_ADDR)
-#define WDOGCNT_ADDR		0xffc01004	/* Watchdog count register 32 bit */
-#define WDOGCNT				WORD_REF(WDOGCNT_ADDR)
-#define WDOGSTAT_ADDR		0xffc01008	/* Watchdog status register 32 bit */
-#define WDOGSTAT			WORD_REF(WDOGSTAT_ADDR)
-
-/****************************
- *
- *  REAL TIME CLOCK (RTC) REGISTERS  (0XFFC01400 - 0XFFC017FF)
- *
- ****************************/
-
-#define RTCSTAT_ADDR		0xffc01400	/* RTC status register  32 bit */
-#define RTCSTAT				WORD_REF(RTCSTAT_ADDR)
-#define RTCICTL_ADDR		0xffc01404	/* RTC Interrupt control register  32 bit */
-#define RTCICTL				WORD_REF(RTCICTL_ADDR)
-#define RTCISTAT_ADDR		0xffc01408	/* RTC Interrupt status register  32 bit */
-#define RTCISTAT			WORD_REF(RTCISTAT_ADDR)
-#define RTCSWCNT_ADDR		0xffc0140c	/* RTC Stop watch count register  32 bit */
-#define RTCSWCNT			WORD_REF(RTCSWCNT_ADDR)
-#define RTCALARM_ADDR		0xffc01410	/* RTC Alarm time register  32 bit */
-#define RTCALARM			WORD_REF(RTCALARM_ADDR)
-#define RTCFAST_ADDR		0xffc01414	/* RTC Prescalar control register  32 bit */
-#define RTCFAST				WORD_REF(RTCFAST_ADDR)
-
-/****************************
- *
- *  UART 0 CONTROLLER REGISTERS  (0XFFC01800 - 0XFFC01BFF)
- *
- ****************************/
-
-#define UART0_THR_ADDR		0xffc01800	/* UART 0 Transmit holding register  16 bit */
-#define UART0_THR			HALFWORD_REF(UART0_THR_ADDR)
-#define UART0_THR_MASK		0x00ff	/* Data to be transmitted */
-
-#define UART0_RBR_ADDR		0xffc01800	/* UART 0 Receive buffer register  16 bit */
-#define UART0_RBR			HALFWORD_REF(UART0_RBR_ADDR)
-#define UART0_RBR_MASK		0x00ff	/* Data to be received */
-
-#define UART0_DLL_ADDR		0xffc01800	/* UART 0 Divisor latch (low byte) register  16 bit */
-#define UART0_DLL			HALFWORD_REF(UART0_DLL_ADDR)
-
-#define UART0_IER_ADDR		0xffc01802	/* UART 0 Interrupt enable register  16 bit */
-#define UART0_IER			HALFWORD_REF(UART0_IER_ADDR)
-#define UART0_IER_ERBFI			0x01	/* Enable Receive Buffer Full Interrupt(DR bit) */
-#define UART0_IER_ETBEI			0x02	/* Enable Transmit Buffer Empty Interrupt(THRE bit) */
-#define UART0_IER_ELSI			0x04	/* Enable RX Status Interrupt(gen if any of LSR[4:1] set) */
-#define UART0_IER_EDDSI			0x08	/* Enable Modem Status Interrupt(gen if any UARTx_MSR[3:0] set) */
-
-#define UART0_DLH_ADDR		0xffc01802	/* UART 0 Divisor latch (high byte) register  16 bit */
-#define UART0_DLH			HALFWORD_REF(UART0_DLH_ADDR)
-#define UART0_IIR_ADDR		0xffc01804	/* UART 0 Interrupt identification register  16 bit */
-#define UART0_IIR			HALFWORD_REF(UART0_IIR_ADDR)
-#define UART0_IIR_NOINT			0x01	/* Bit0: cleared when no interrupt */
-#define UART0_IIR_STATUS		0x06	/* mask bit for the status: bit2-1 */
-#define UART0_IIR_LSR			0x06	/* Receive line status */
-#define UART0_IIR_RBR			0x04	/* Receive data ready */
-#define UART0_IIR_THR			0x02	/* Ready to transmit  */
-#define UART0_IIR_MSR			0x00	/* Modem status       */
-
-#define UART0_LCR_ADDR		0xffc01806	/* UART 0 Line control register  16 bit */
-#define UART0_LCR			HALFWORD_REF(UART0_LCR_ADDR)
-#define UART0_LCR_WLS5			0	/* word length 5 bits */
-#define UART0_LCR_WLS6			0x01	/* word length 6 bits */
-#define UART0_LCR_WLS7			0x02	/* word length 7 bits */
-#define UART0_LCR_WLS8			0x03	/* word length 8 bits */
-#define UART0_LCR_STB			0x04	/* StopBit: 1: 2 stop bits for non-5-bit word length
-						   1/2 stop bits for 5-bit word length
-						   0: 1 stop bit */
-#define UART0_LCR_PEN			0x08	/* Parity Enable 1: for enable */
-#define UART0_LCR_EPS			0x10	/* Parity Selection: 1: for even pariety
-						   0: odd parity when PEN =1 & SP =0 */
-#define UART0_LCR_SP			0x20	/* Sticky Parity: */
-#define UART0_LCR_SB			0x40	/* Set Break: force TX pin to 0 */
-#define UART0_LCR_DLAB			0x80	/* Divisor Latch Access */
-
-#define UART0_MCR_ADDR		0xffc01808	/* UART 0 Module Control register  16 bit */
-#define UART0_MCR			HALFWORD_REF(UART0_MCR_ADDR)
-
-#define UART0_LSR_ADDR		0xffc0180a	/* UART 0 Line status register  16 bit */
-#define UART0_LSR			HALFWORD_REF(UART0_LSR_ADDR)
-#define UART0_LSR_DR			0x01	/* Data Ready */
-#define UART0_LSR_OE			0x02	/* Overrun Error */
-#define UART0_LSR_PE			0x04	/* Parity Error  */
-#define UART0_LSR_FE			0x08	/* Frame Error   */
-#define UART0_LSR_BI			0x10	/* Break Interrupt */
-#define UART0_LSR_THRE			0x20	/* THR empty, REady to accept */
-#define UART0_LSR_TEMT			0x40	/* TSR and UARTx_thr both empty */
-
-#define UART0_MSR_ADDR		0xffc0180c	/* UART 0 Modem status register  16 bit */
-#define UART0_MSR			HALFWORD_REF(UART0_MSR_ADDR)
-#define UART0_SCR_ADDR		0xffc0180e	/* UART 0 Scratch register  16 bit */
-#define UART0_SCR			HALFWORD_REF(UART0_SCR_ADDR)
-#define UART0_IRCR_ADDR		0xffc01810	/* UART 0 IrDA Control register  16 bit */
-#define UART0_IRCR			HALFWORD_REF(UART0_IRCR_ADDR)
-
-#define UART0_CURR_PTR_RX_ADDR		0xffc01a00	/* UART 0 RCV DMA Current pointer register 16 bit */
-#define UART0_CURR_PTR_RX			HALFWORD_REF(UART0_CURR_PTR_RX_ADDR)
-#define UART0_CONFIG_RX_ADDR		0xffc01a02	/* UART 0 RCV DMA Configuration register 16 bit */
-#define UART0_CONFIG_RX				HALFWORD_REF(UART0_CONFIG_RX_ADDR)
-#define UART0_START_ADDR_HI_RX_ADDR	0xffc01a04	/* UART 0 RCV DMA start add. hi reg 16 bit */
-#define UART0_START_ADDR_HI_RX		HALFWORD_REF(UART0_START_ADDR_HI_RX_ADDR)
-#define UART0_START_ADDR_LO_RX_ADDR	0xffc01a06	/* UART 0 RCV DMA start add. lo reg 16 bit */
-#define UART0_START_ADDR_LO_RX		HALFWORD_REF(UART0_START_ADDR_LO_RX_ADDR)
-#define UART0_COUNT_RX_ADDR			0xffc01a08	/* UART 0 RCV DMA count register  16 bit */
-#define UART0_COUNT_RX				HALFWORD_REF(UART0_COUNT_RX_ADDR)
-#define UART0_NEXT_DESCR_RX_ADDR    0xffc01a0a	/*UART 0 RCV DMA next descripter poin reg 16 bit */
-#define UART0_NEXT_DESCR_RX			HALFWORD_REF(UART0_NEXT_DESCR_RX_ADDR)
-#define UART0_DESCR_RDY_RX_ADDR		0xffc01a0c	/* UART 0 RCV DMA descripter ready reg 16 bit */
-#define UART0_DESCR_RDY_RX			HALFWORD_REF(UART0_DESCR_RDY_RX_ADDR)
-#define UART0_IRQSTAT_RX_ADDR		0xffc01a0e	/* UART 0 RCV DMA Interrupt register  16 bit */
-#define UART0_IRQSTAT_RX			HALFWORD_REF(UART0_IRQSTAT_RX_ADDR)
-
-#define UART0_CURR_PTR_TX_ADDR		0xffc01b00	/* UART 0 XMT DMA Current pointer register 16 bit */
-#define UART0_CURR_PTR_TX			HALFWORD_REF(UART0_CURR_PTR_TX_ADDR)
-#define UART0_CONFIG_TX_ADDR		0xffc01b02	/* UART 0 XMT DMA Configuration register 16 bit */
-#define UART0_CONFIG_TX				HALFWORD_REF(UART0_CONFIG_TX_ADDR)
-#define UART0_START_ADDR_HI_TX_ADDR	0xffc01b04	/* UART 0 XMT DMA start add. hi reg 16 bit */
-#define UART0_START_ADDR_HI_TX		HALFWORD_REF(UART0_START_ADDR_HI_TX_ADDR)
-#define UART0_START_ADDR_LO_TX_ADDR	0xffc01b06	/* UART 0 XMT DMA start add. lo reg 16 bit */
-#define UART0_START_ADDR_LO_TX		HALFWORD_REF(UART0_START_ADDR_LO_TX_ADDR)
-#define UART0_COUNT_TX_ADDR			0xffc01b08	/* UART 0 XMT DMA count register  16 bit */
-#define UART0_COUNT_TX				HALFWORD_REF(UART0_COUNT_TX_ADDR)
-#define UART0_NEXT_DESCR_TX_ADDR	0xffc01b0a	/*UART 0 XMT DMA next descripter poin reg 16 bit */
-#define UART0_NEXT_DESCR_TX			HALFWORD_REF(UART0_NEXT_DESCR_TX_ADDR)
-#define UART0_DESCR_RDY_TX_ADDR		0xffc01b0c	/* UART 0 XMT DMA descripter ready reg 16 bit */
-#define UART0_DESCR_RDY_TX			HALFWORD_REF(UART0_DESCR_RDY_TX_ADDR)
-#define UART0_IRQSTAT_TX_ADDR		0xffc01b0e	/* UART 0 XMT DMA Interrupt register  16 bit */
-#define UART0_IRQSTAT_TX			HALFWORD_REF(UART0_IRQSTAT_TX_ADDR)
-
-/****************************
- *
- *  UART 1 CONTROLLER REGISTERS  (0XFFC01C00 - 0XFFC01FFF)
- *
- ****************************/
-
-#define UART1_THR_ADDR		0xffc01c00	/* UART 1 Transmit holding register  16 bit */
-#define UART1_THR			HALFWORD_REF(UART1_THR_ADDR)
-#define UART1_THR_MASK		0x00ff	/* Data to be transmitted */
-
-#define UART1_RBR_ADDR		0xffc01c00	/* UART 1 Receive buffer register  16 bit */
-#define UART1_RBR			HALFWORD_REF(UART1_RBR_ADDR)
-#define UART1_RBR_MASK		0x00ff	/* Data to be transmitted */
-
-#define UART1_DLL_ADDR		0xffc01c00	/* UART 1 Divisor latch (low byte) register  16 bit */
-#define UART1_DLL			HALFWORD_REF(UART1_DLL_ADDR)
-
-#define UART1_IER_ADDR		0xffc01c02	/* UART 1 Interrupt enable register  16 bit */
-#define UART1_IER			HALFWORD_REF(UART1_IER_ADDR)
-#define UART1_IER_ERBFI			0x01	/* Enable Receive Buffer Full Interrupt(DR bit) */
-#define UART1_IER_ETBEI			0x02	/* Enable Transmit Buffer Empty Interrupt(THRE bit) */
-#define UART1_IER_ELSI			0x04	/* Enable RX Status Interrupt(gen if any of LSR[4:1] set) */
-#define UART1_IER_EDDSI			0x08	/* Enable Modem Status Interrupt(gen if any UARTx_MSR[3:0] set) */
-
-#define UART1_DLH_ADDR		0xffc01c02	/* UART 1 Divisor latch (high byte) register  16 bit */
-#define UART1_DLH			HALFWORD_REF(UART1_DLH_ADDR)
-
-#define UART1_IIR_ADDR		0xffc01c04	/* UART 1 Interrupt identification register  16 bit */
-#define UART1_IIR			HALFWORD_REF(UART1_IIR_ADDR)
-#define UART1_IIR_NOINT     	0x01	/* Bit0: cleared when no interrupt */
-#define UART1_IIR_STATUS        0x06	/* mask bit for the status: bit2-1 */
-#define UART1_IIR_LSR           0x06	/* Receive line status */
-#define UART1_IIR_RBR           0x04	/* Receive data ready */
-#define UART1_IIR_THR           0x02	/* Ready to transmit  */
-#define UART1_IIR_MSR           0x00	/* Modem status       */
-
-#define UART1_LCR_ADDR		0xffc01c06	/* UART 1 Line control register  16 bit */
-#define UART1_LCR			HALFWORD_REF(UART1_LCR_ADDR)
-#define UART1_LCR_WLS5      	0	/* word length 5 bits */
-#define UART1_LCR_WLS6      	0x01	/* word length 6 bits */
-#define UART1_LCR_WLS7          0x02	/* word length 7 bits */
-#define UART1_LCR_WLS8          0x03	/* word length 8 bits */
-#define UART1_LCR_STB           0x04	/* StopBit: 1: 2 stop bits for non-5-bit word length
-					   1/2 stop bits for 5-bit word length
-					   0: 1 stop bit */
-#define UART1_LCR_PEN           0x08	/* Parity Enable 1: for enable */
-#define UART1_LCR_EPS           0x10	/* Parity Selection: 1: for even pariety
-					   0: odd parity when PEN =1 &
-					   SP =0 */
-#define UART1_LCR_SP            0x20	/* Sticky Parity: */
-#define UART1_LCR_SB            0x40	/* Set Break: force TX pin to 0 */
-#define UART1_LCR_DLAB          0x80	/* Divisor Latch Access */
-
-#define UART1_MCR_ADDR		0xffc01c08	/* UART 1 Module Control register  16 bit */
-#define UART1_MCR			HALFWORD_REF(UART1_MCR_ADDR)
-
-#define UART1_LSR_ADDR		0xffc01c0a	/* UART 1 Line status register  16 bit */
-#define UART1_LSR			HALFWORD_REF(UART1_LSR_ADDR)
-#define UART1_LSR_DR        	0x01	/* Data Ready */
-#define UART1_LSR_OE            0x02	/* Overrun Error */
-#define UART1_LSR_PE            0x04	/* Parity Error  */
-#define UART1_LSR_FE            0x08	/* Frame Error   */
-#define UART1_LSR_BI            0x10	/* Break Interrupt */
-#define UART1_LSR_THRE          0x20	/* THR empty, REady to accept */
-#define UART1_LSR_TEMT          0x40	/* TSR and UARTx_thr both empty */
-
-#define UART1_MSR_ADDR		0xffc01c0c	/* UART 1 Modem status register  16 bit */
-#define UART1_MSR			HALFWORD_REF(UART1_MSR_ADDR)
-#define UART1_SCR_ADDR		0xffc01c0e	/* UART 1 Scratch register  16 bit */
-#define UART1_SCR			HALFWORD_REF(UART1_SCR_ADDR)
-
-#define UART1_CURR_PTR_RX_ADDR		0xffc01e00	/* UART 1 RCV DMA Current pointer register 16 bit */
-#define UART1_CURR_PTR_RX			HALFWORD_REF(UART1_CURR_PTR_RX_ADDR)
-#define UART1_CONFIG_RX_ADDR		0xffc01e02	/* UART 1 RCV DMA Configuration register 16 bit */
-#define UART1_CONFIG_RX				HALFWORD_REF(UART1_CONFIG_RX_ADDR)
-#define UART1_START_ADDR_HI_RX_ADDR	0xffc01e04	/* UART 1 RCV DMA start add. hi reg 16 bit */
-#define UART1_START_ADDR_HI_RX		HALFWORD_REF(UART1_START_ADDR_HI_RX_ADDR)
-#define UART1_START_ADDR_LO_RX_ADDR	0xffc01e06	/* UART 1 RCV DMA start add. lo reg 16 bit */
-#define UART1_START_ADDR_LO_RX		HALFWORD_REF(UART1_START_ADDR_LO_RX_ADDR)
-#define UART1_COUNT_RX_ADDR			0xffc01e08	/* UART 1 RCV DMA count register  16 bit */
-#define UART1_COUNT_RX				HALFWORD_REF(UART1_COUNT_RX_ADDR)
-#define UART1_NEXT_DESCR_RX_ADDR   	0xffc01e0a	/*UART 1 RCV DMA next descripter poin reg 16 bit */
-#define UART1_NEXT_DESCR_RX			HALFWORD_REF(UART1_NEXT_DESCR_RX_ADDR)
-#define UART1_DESCR_RDY_RX_ADDR		0xffc01e0c	/* UART 1 RCV DMA descripter ready reg 16 bit */
-#define UART1_DESCR_RDY_RX			HALFWORD_REF(UART1_DESCR_RDY_RX_ADDR)
-#define UART1_IRQSTAT_RX_ADDR		0xffc01e0e	/* UART 1 RCV DMA Interrupt register  16 bit */
-#define UART1_IRQSTAT_RX			HALFWORD_REF(UART1_IRQSTAT_RX_ADDR)
-
-#define UART1_CURR_PTR_TX_ADDR		0xffc01f00	/* UART 1 XMT DMA Current pointer register 16 bit */
-#define UART1_CURR_PTR_TX			HALFWORD_REF(UART1_CURR_PTR_TX_ADDR)
-#define UART1_CONFIG_TX_ADDR		0xffc01f02	/* UART 1 XMT DMA Configuration register 16 bit */
-#define UART1_CONFIG_TX				HALFWORD_REF(UART1_CONFIG_TX_ADDR)
-#define UART1_START_ADDR_HI_TX_ADDR	0xffc01f04	/* UART 1 XMT DMA start add. hi reg 16 bit */
-#define UART1_START_ADDR_HI_TX		HALFWORD_REF(UART1_START_ADDR_HI_TX_ADDR)
-#define UART1_START_ADDR_LO_TX_ADDR	0xffc01f06	/* UART 1 XMT DMA start add. lo reg 16 bit */
-#define UART1_START_ADDR_LO_TX		HALFWORD_REF(UART1_START_ADDR_LO_TX_ADDR)
-#define UART1_COUNT_TX_ADDR			0xffc01f08	/* UART 1 XMT DMA count register  16 bit */
-#define UART1_COUNT_TX				HALFWORD_REF(UART1_COUNT_TX_ADDR)
-#define UART1_NEXT_DESCR_TX_ADDR	0xffc01f0a	/*UART 1 XMT DMA next descripter poin reg 16 bit */
-#define UART1_NEXT_DESCR_TX			HALFWORD_REF(UART1_NEXT_DESCR_TX_ADDR)
-#define UART1_DESCR_RDY_TX_ADDR		0xffc01f0c	/* UART 1 XMT DMA descripter ready reg 16 bit */
-#define UART1_DESCR_RDY_TX			HALFWORD_REF(UART1_DESCR_RDY_TX_ADDR)
-#define UART1_IRQSTAT_TX_ADDR		0xffc01f0e	/* UART 1 XMT DMA Interrupt register  16 bit */
-#define UART1_IRQSTAT_TX			HALFWORD_REF(UART1_IRQSTAT_TX_ADDR)
-
-/****************************
- *
- *  TIMER REGISTERS  (0XFFC02000 - 0XFFC023FF)
- *       THERE ARE 3 TIMERS
- ****************************/
-
-		/*             TIMER 0              */
-
-#define TIMER0_STATUS_ADDR		0xffc02000	/* TIMER 0 Global status & sticky register  16 bit */
-#define TIMER0_STATUS			HALFWORD_REF(TIMER0_STATUS_ADDR)
-#define TIMER0_CONFIG_ADDR		0xffc02002	/* TIMER 0 configuration register  16 bit */
-#define TIMER0_CONFIG			HALFWORD_REF(TIMER0_CONFIG_ADDR)
-#define TIMER0_COUNTER_LO_ADDR	0xffc02004	/* TIMER 0 counter (low word) register   16 bit */
-#define TIMER0_COUNTER_LO		HALFWORD_REF(TIMER0_COUNTER_LO_ADDR)
-#define TIMER0_COUNTER_HI_ADDR	0xffc02006	/* TIMER 0 counter (high word) register  16 bit */
-#define TIMER0_COUNTER_HI		HALFWORD_REF(TIMER0_COUNTER_HI_ADDR)
-#define TIMER0_PERIOD_LO_ADDR	0xffc02008	/* TIMER 0 period (low word) register  16 bit */
-#define TIMER0_PERIOD_LO		HALFWORD_REF(TIMER0_PERIOD_LO_ADDR)
-#define TIMER0_PERIOD_HI_ADDR	0xffc0200a	/* TIMER 0 period (high word) register  16 bit */
-#define TIMER0_PERIOD_HI		HALFWORD_REF(TIMER0_PERIOD_HI_ADDR)
-#define TIMER0_WIDTH_LO_ADDR	0xffc0200c	/* TIMER 0 width (low word) register  16 bit */
-#define TIMER0_WIDTH_LO			HALFWORD_REF(TIMER0_WIDTH_LO_ADDR)
-#define TIMER0_WIDTH_HI_ADDR	0xffc0200e	/* TIMER 0 width (high word) register  16 bit */
-#define TIMER0_WIDTH_HI			HALFWORD_REF(TIMER0_WIDTH_HI_ADDR)
-
-		/*             TIMER 1              */
-
-#define TIMER1_STATUS_ADDR		0xffc02010	/* TIMER 1 Global status & sticky register  16 bit */
-#define TIMER1_STATUS			HALFWORD_REF(TIMER1_STATUS_ADDR)
-#define TIMER1_CONFIG_ADDR		0xffc02012	/* TIMER 1 configuration register  16 bit */
-#define TIMER1_CONFIG			HALFWORD_REF(TIMER1_CONFIG_ADDR)
-#define TIMER1_COUNTER_LO_ADDR	0xffc02014	/* TIMER 1 counter (low word) register   16 bit */
-#define TIMER1_COUNTER_LO		HALFWORD_REF(TIMER1_COUNTER_LO_ADDR)
-#define TIMER1_COUNTER_HI_ADDR	0xffc02016	/* TIMER 1 counter (high word) register  16 bit */
-#define TIMER1_COUNTER_HI		HALFWORD_REF(TIMER1_COUNTER_HI_ADDR)
-#define TIMER1_PERIOD_LO_ADDR	0xffc02018	/* TIMER 1 period (low word) register  16 bit */
-#define TIMER1_PERIOD_LO		HALFWORD_REF(TIMER1_PERIOD_LO_ADDR)
-#define TIMER1_PERIOD_HI_ADDR	0xffc0201a	/* TIMER 1 period (high word) register  16 bit */
-#define TIMER1_PERIOD_HI		HALFWORD_REF(TIMER1_PERIOD_HI_ADDR)
-#define TIMER1_WIDTH_LO_ADDR	0xffc0201c	/* TIMER 1 width (low word) register  16 bit */
-#define TIMER1_WIDTH_LO			HALFWORD_REF(TIMER1_WIDTH_LO_ADDR)
-#define TIMER1_WIDTH_HI_ADDR	0xffc0201e	/* TIMER 1 width (high word) register  16 bit */
-#define TIMER1_WIDTH_HI			HALFWORD_REF(TIMER1_WIDTH_HI_ADDR)
-
-		/*             TIMER 2              */
-
-#define TIMER2_STATUS_ADDR		0xffc02020	/* TIMER 2 Global status & sticky register  16 bit */
-#define TIMER2_STATUS			HALFWORD_REF(TIMER2_STATUS_ADDR)
-#define TIMER2_CONFIG_ADDR		0xffc02022	/* TIMER 2 configuration register  16 bit */
-#define TIMER2_CONFIG			HALFWORD_REF(TIMER2_CONFIG_ADDR)
-#define TIMER2_COUNTER_LO_ADDR	0xffc02024	/* TIMER 2 counter (low word) register   16 bit */
-#define TIMER2_COUNTER_LO		HALFWORD_REF(TIMER2_COUNTER_LO_ADDR)
-#define TIMER2_COUNTER_HI_ADDR	0xffc02026	/* TIMER 2 counter (high word) register  16 bit */
-#define TIMER2_COUNTER_HI		HALFWORD_REF(TIMER2_COUNTER_HI_ADDR)
-#define TIMER2_PERIOD_LO_ADDR	0xffc02028	/* TIMER 2 period (low word) register  16 bit */
-#define TIMER2_PERIOD_LO		HALFWORD_REF(TIMER2_PERIOD_LO_ADDR)
-#define TIMER2_PERIOD_HI_ADDR	0xffc0202a	/* TIMER 2 period (high word) register  16 bit */
-#define TIMER2_PERIOD_HI		HALFWORD_REF(TIMER2_PERIOD_HI_ADDR)
-#define TIMER2_WIDTH_LO_ADDR	0xffc0202c	/* TIMER 2 width (low word) register  16 bit */
-#define TIMER2_WIDTH_LO			HALFWORD_REF(TIMER2_WIDTH_LO_ADDR)
-#define TIMER2_WIDTH_HI_ADDR	0xffc0202e	/* TIMER 2 width (high word) register  16 bit */
-#define TIMER2_WIDTH_HI			HALFWORD_REF(TIMER2_WIDTH_HI_ADDR)
-
-/****************************
- *
- *  GENERAL PURPOSE IO REGISTERS  (0XFFC02400 - 0XFFC027FF)
- *
- ****************************/
-
-#define FIO_DIR_C_ADDR		0xffc02400	/* Peripheral flag direction (clear) register 16 bit */
-#define FIO_DIR_C			HALFWORD_REF(FIO_DIR_C_ADDR)
-#define FIO_DIR_S_ADDR		0xffc02402	/* Peripheral flag direction (set) register 16 bit */
-#define FIO_DIR_S			HALFWORD_REF(FIO_DIR_S_ADDR)
-#define FIO_FLAG_C_ADDR		0xffc02404	/* Peripheral Interrupt flag (clear) register 16 bit */
-#define FIO_FLAG_C			HALFWORD_REF(FIO_FLAG_C_ADDR)
-#define FIO_FLAG_S_ADDR		0xffc02406	/* Peripheral Interrupt flag (set) register 16 bit */
-#define FIO_FLAG_S			HALFWORD_REF(FIO_FLAG_S_ADDR)
-#define FIO_MASKA_C_ADDR	0xffc02408	/* Flag Mask Interrupt A (clear) register 16 bit */
-#define FIO_MASKA_C			HALFWORD_REF(FIO_MASKA_C_ADDR)
-#define FIO_MASKA_S_ADDR	0xffc0240a	/* Flag Mask Interrupt A (set) register 16 bit */
-#define FIO_MASKA_S			HALFWORD_REF(FIO_MASKA_S_ADDR)
-#define FIO_MASKB_C_ADDR	0xffc0240c	/* Flag Mask Interrupt B (clear) register 16 bit */
-#define FIO_MASKB_C			HALFWORD_REF(FIO_MASKB_C_ADDR)
-#define FIO_MASKB_S_ADDR	0xffc0240e	/* Flag Mask Interrupt B (set) register 16 bit */
-#define FIO_MASKB_S			HALFWORD_REF(FIO_MASKB_S_ADDR)
-#define FIO_POLAR_C_ADDR	0xffc02410	/* Flag source polarity (clear) register 16 bit */
-#define FIO_POLAR_C			HALFWORD_REF(FIO_POLAR_C_ADDR)
-#define FIO_POLAR_S_ADDR	0xffc02412	/* Flag source polarity (set) register 16 bit */
-#define FIO_POLAR_S			HALFWORD_REF(FIO_POLAR_S_ADDR)
-#define FIO_EDGE_C_ADDR		0xffc02414	/* Flag source sensitivity (clear) register 16 bit */
-#define FIO_EDGE_C			HALFWORD_REF(FIO_EDGE_C_ADDR)
-#define FIO_EDGE_S_ADDR		0xffc02416	/* Flag source sensitivity (set) register 16 bit */
-#define FIO_EDGE_S			HALFWORD_REF(FIO_EDGE_S_ADDR)
-#define FIO_BOTH_C_ADDR		0xffc02418	/* Flag set on both edges (clear) register 16 bit */
-#define FIO_BOTH_C			HALFWORD_REF(FIO_BOTH_C_ADDR)
-#define FIO_BOTH_S_ADDR		0xffc0241a	/* Flag set on both edges (set) register 16 bit */
-#define FIO_BOTH_S			HALFWORD_REF(FIO_BOTH_S_ADDR)
-
-/****************************
- *
- *  SPORT 0 CONTROLLER REGISTERS  (0XFFC02800 - 0XFFC02BFF)
- *
- ****************************/
-
-#define SPORT0_TX_CONFIG_ADDR	0xffc02800	/* SPORT 0 Transmit configuration register 16 bit */
-#define SPORT0_TX_CONFIG		HALFWORD_REF(SPORT0_TX_CONFIG_ADDR)
-#define SPORT0_RX_CONFIG_ADDR	0xffc02802	/* SPORT 0 Receive configuration register 16 bit */
-#define SPORT0_RX_CONFIG		HALFWORD_REF(SPORT0_RX_CONFIG_ADDR)
-#define SPORT0_TX_ADDR			0xffc02804	/* SPORT 0 Transmit register 16 bit */
-#define SPORT0_TX				HALFWORD_REF(SPORT0_TX_ADDR)
-#define SPORT0_RX_ADDR			0xffc02806	/* SPORT 0 Receive register 16 bit */
-#define SPORT0_RX				HALFWORD_REF(SPORT0_RX_ADDR)
-#define SPORT0_TSCLKDIV_ADDR	0xffc02808	/* SPORT 0 Transmit serial clock divider 16 bit */
-#define SPORT0_TSCLKDIV			HALFWORD_REF(SPORT0_TSCLKDIV_ADDR)
-#define SPORT0_RSCLKDIV_ADDR	0xffc0280a	/* SPORT 0 Receive serial clock divider 16 bit */
-#define SPORT0_RSCLKDIV			HALFWORD_REF(SPORT0_RSCLKDIV_ADDR)
-#define SPORT0_TFSDIV_ADDR		0xffc0280c	/* SPORT 0 Transmit frame sync divider 16 bit */
-#define SPORT0_TFSDIV			HALFWORD_REF(SPORT0_TFSDIV_ADDR)
-#define SPORT0_RFSDIV_ADDR		0xffc0280e	/* SPORT 0 Receive frame sync divider 16 bit */
-#define SPORT0_RFSDIV			HALFWORD_REF(SPORT0_RFSDIV_ADDR)
-#define SPORT0_STAT_ADDR		0xffc02810	/* SPORT 0 status register 16 bit */
-#define SPORT0_STAT				HALFWORD_REF(SPORT0_STAT_ADDR)
-#define SPORT0_MTCS0_ADDR		0xffc02812	/* SPORT 0 Multi-channel Transmit select reg 16 bit */
-#define SPORT0_MTCS0			HALFWORD_REF(SPORT0_MTCS0_ADDR)
-#define SPORT0_MTCS1_ADDR		0xffc02814	/* SPORT 0 Multi-channel Transmit select reg 16 bit */
-#define SPORT0_MTCS1			HALFWORD_REF(SPORT0_MTCS1_ADDR)
-#define SPORT0_MTCS2_ADDR		0xffc02816	/* SPORT 0 Multi-channel Transmit select reg 16 bit */
-#define SPORT0_MTCS2			HALFWORD_REF(SPORT0_MTCS2_ADDR)
-#define SPORT0_MTCS3_ADDR		0xffc02818	/* SPORT 0 Multi-channel Transmit select reg 16 bit */
-#define SPORT0_MTCS3			HALFWORD_REF(SPORT0_MTCS3_ADDR)
-#define SPORT0_MTCS4_ADDR		0xffc0281a	/* SPORT 0 Multi-channel Transmit select reg 16 bit */
-#define SPORT0_MTCS4			HALFWORD_REF(SPORT0_MTCS4_ADDR)
-#define SPORT0_MTCS5_ADDR		0xffc0281c	/* SPORT 0 Multi-channel Transmit select reg 16 bit */
-#define SPORT0_MTCS5			HALFWORD_REF(SPORT0_MTCS5_ADDR)
-#define SPORT0_MTCS6_ADDR		0xffc0281e	/* SPORT 0 Multi-channel Transmit select reg 16 bit */
-#define SPORT0_MTCS6			HALFWORD_REF(SPORT0_MTCS6_ADDR)
-#define SPORT0_MTCS7_ADDR		0xffc02820	/* SPORT 0 Multi-channel Transmit select reg 16 bit */
-#define SPORT0_MTCS7			HALFWORD_REF(SPORT0_MTCS7_ADDR)
-#define SPORT0_MRCS0_ADDR		0xffc02822	/* SPORT 0 Multi-channel Receive select reg 16 bit */
-#define SPORT0_MRCS0			HALFWORD_REF(SPORT0_MRCS0_ADDR)
-#define SPORT0_MRCS1_ADDR		0xffc02824	/* SPORT 0 Multi-channel Receive select reg 16 bit */
-#define SPORT0_MRCS1			HALFWORD_REF(SPORT0_MRCS1_ADDR)
-#define SPORT0_MRCS2_ADDR		0xffc02826	/* SPORT 0 Multi-channel Receive select reg 16 bit */
-#define SPORT0_MRCS2			HALFWORD_REF(SPORT0_MRCS2_ADDR)
-#define SPORT0_MRCS3_ADDR		0xffc02828	/* SPORT 0 Multi-channel Receive select reg 16 bit */
-#define SPORT0_MRCS3			HALFWORD_REF(SPORT0_MRCS3_ADDR)
-#define SPORT0_MRCS4_ADDR		0xffc0282a	/* SPORT 0 Multi-channel Receive select reg 16 bit */
-#define SPORT0_MRCS4			HALFWORD_REF(SPORT0_MRCS4_ADDR)
-#define SPORT0_MRCS5_ADDR		0xffc0282c	/* SPORT 0 Multi-channel Receive select reg 16 bit */
-#define SPORT0_MRCS5			HALFWORD_REF(SPORT0_MRCS5_ADDR)
-#define SPORT0_MRCS6_ADDR		0xffc0282e	/* SPORT 0 Multi-channel Receive select reg 16 bit */
-#define SPORT0_MRCS6			HALFWORD_REF(SPORT0_MRCS6_ADDR)
-#define SPORT0_MRCS7_ADDR		0xffc02830	/* SPORT 0 Multi-channel Receive select reg 16 bit */
-#define SPORT0_MRCS7			HALFWORD_REF(SPORT0_MRCS7_ADDR)
-#define SPORT0_MCMC1_ADDR		0xffc02832	/* SPORT 0 Multi-channel configuration reg 1 16 bit */
-#define SPORT0_MCMC1			HALFWORD_REF(SPORT0_MCMC1_ADDR)
-#define SPORT0_MCMC2_ADDR		0xffc02834	/* SPORT 0 Multi-channel configuration reg 2 16 bit */
-#define SPORT0_MCMC2			HALFWORD_REF(SPORT0_MCMC2_ADDR)
-
-#define SPORT0_CURR_PTR_RX_ADDR		0xffc02a00	/* SPORT 0 RCV DMA Current pointer reg 16 bit */
-#define SPORT0_CURR_PTR_RX			HALFWORD_REF(SPORT0_CURR_PTR_RX_ADDR)
-#define SPORT0_CONFIG_DMA_RX_ADDR	0xffc02a02	/* SPORT 0 RCV DMA Configuration reg 16 bit */
-
-#if 0
-#define SPORT0_CONFIG_DMA_RX		HALFWORD_REF(SPORT0_CONFIG_RX_ADDR)
-#else
-#define SPORT0_CONFIG_DMA_RX		HALFWORD_REF(SPORT0_CONFIG_DMA_RX_ADDR)
-#endif
-
-#define SPORT0_START_ADDR_HI_RX_ADDR  	0xffc02a04	/* SPORT 0 RCV DMA start add. hi reg 16 bit */
-#define SPORT0_START_ADDR_HI_RX		HALFWORD_REF(SPORT0_START_ADDR_HI_RX_ADDR)
-#define SPORT0_START_ADDR_LO_RX_ADDR  	0xffc02a06	/* SPORT 0 RCV DMA start add. lo reg 16 bit */
-#define SPORT0_START_ADDR_LO_RX		HALFWORD_REF(SPORT0_START_ADDR_LO_RX_ADDR)
-#define SPORT0_COUNT_RX_ADDR  		0xffc02a08	/* SPORT 0 RCV DMA count reg 16 bit */
-#define SPORT0_COUNT_RX				HALFWORD_REF(SPORT0_COUNT_RX_ADDR)
-#define SPORT0_NEXT_DESCR_RX_ADDR  	0xffc02a0a	/* SPORT 0 RCV DMA next descriptor poin reg 16 bit */
-#define SPORT0_NEXT_DESCR_RX		HALFWORD_REF(SPORT0_NEXT_DESCR_RX_ADDR)
-#define SPORT0_DESCR_RDY_RX_ADDR  	0xffc02a0c	/* SPORT 0 RCV DMA descriptor ready reg 16 bit */
-#define SPORT0_DESCR_RDY_RX			HALFWORD_REF(SPORT0_DESCR_RDY_RX_ADDR)
-#define SPORT0_IRQSTAT_RX_ADDR  	0xffc02a0e	/* SPORT 0 RCV DMA interrupt reg 16 bit */
-#define SPORT0_IRQSTAT_RX			HALFWORD_REF(SPORT0_IRQSTAT_RX_ADDR)
-
-#define SPORT0_CURR_PTR_TX_ADDR		0xffc02b00	/* SPORT 0 XMT DMA Current pointer reg 16 bit */
-#define SPORT0_CURR_PTR_TX			HALFWORD_REF(SPORT0_CURR_PTR_TX_ADDR)
-#define SPORT0_CONFIG_DMA_TX_ADDR	0xffc02b02	/* SPORT 0 XMT DMA Configuration reg 16 bit */
-
-/* Fixed in Jul 2 2003 for SPORT driver*/
-#if 0
-#define SPORT0_CONFIG_DMA_TX		HALFWORD_REF(SPORT0_CONFIG_TX_ADDR)
-#else
-#define SPORT0_CONFIG_DMA_TX		HALFWORD_REF(SPORT0_CONFIG_DMA_TX_ADDR)
-#endif
-
-#define SPORT0_START_ADDR_HI_TX_ADDR  	0xffc02b04	/* SPORT 0 XMT DMA start add. hi reg 16 bit */
-#define SPORT0_START_ADDR_HI_TX		HALFWORD_REF(SPORT0_START_ADDR_HI_TX_ADDR)
-#define SPORT0_START_ADDR_LO_TX_ADDR  	0xffc02b06	/* SPORT 0 XMT DMA start add. lo reg 16 bit */
-#define SPORT0_START_ADDR_LO_TX		HALFWORD_REF(SPORT0_START_ADDR_LO_TX_ADDR)
-#define SPORT0_COUNT_TX_ADDR  		0xffc02b08	/* SPORT 0 XMT DMA count reg 16 bit */
-#define SPORT0_COUNT_TX				HALFWORD_REF(SPORT0_COUNT_TX_ADDR)
-#define SPORT0_NEXT_DESCR_TX_ADDR  	0xffc02b0a	/* SPORT 0 XMT DMA next descriptor poin reg 16 bit */
-#define SPORT0_NEXT_DESCR_TX		HALFWORD_REF(SPORT0_NEXT_DESCR_TX_ADDR)
-#define SPORT0_DESCR_RDY_TX_ADDR  	0xffc02b0c	/* SPORT 0 XMT DMA descriptor ready reg 16 bit */
-#define SPORT0_DESCR_RDY_TX			HALFWORD_REF(SPORT0_DESCR_RDY_TX_ADDR)
-#define SPORT0_IRQSTAT_TX_ADDR  	0xffc02b0e	/* SPORT 0 XMT DMA interrupt reg 16 bit */
-#define SPORT0_IRQSTAT_TX			HALFWORD_REF(SPORT0_IRQSTAT_TX_ADDR)
-
-/****************************
- *
- *  SPORT 1 CONTROLLER REGISTERS  (0XFFC02C00 - 0XFFC02FFF)
- *
- ****************************/
-
-#define SPORT1_TX_CONFIG_ADDR	0xffc02c00	/* SPORT 1 Transmit configuration register 16 bit */
-#define SPORT1_TX_CONFIG		HALFWORD_REF(SPORT1_TX_CONFIG_ADDR)
-#define SPORT1_RX_CONFIG_ADDR	0xffc02c02	/* SPORT 1 Receive configuration register 16 bit */
-#define SPORT1_RX_CONFIG		HALFWORD_REF(SPORT1_RX_CONFIG_ADDR)
-#define SPORT1_TX_ADDR			0xffc02c04	/* SPORT 1 Transmit register 16 bit */
-#define SPORT1_TX				HALFWORD_REF(SPORT1_TX_ADDR)
-#define SPORT1_RX_ADDR			0xffc02c06	/* SPORT 1 Receive register 16 bit */
-#define SPORT1_RX				HALFWORD_REF(SPORT1_RX_ADDR)
-#define SPORT1_TSCLKDIV_ADDR	0xffc02c08	/* SPORT 1 Transmit serial clock divider 16 bit */
-#define SPORT1_TSCLKDIV			HALFWORD_REF(SPORT1_TSCLKDIV_ADDR)
-#define SPORT1_RSCLKDIV_ADDR	0xffc02c0a	/* SPORT 1 Receive serial clock divider 16 bit */
-#define SPORT1_RSCLKDIV			HALFWORD_REF(SPORT1_RSCLKDIV_ADDR)
-#define SPORT1_TFSDIV_ADDR		0xffc02c0c	/* SPORT 1 Transmit frame sync divider 16 bit */
-#define SPORT1_TFSDIV			HALFWORD_REF(SPORT1_TFSDIV_ADDR)
-#define SPORT1_RFSDIV_ADDR		0xffc02c0e	/* SPORT 1 Receive frame sync divider 16 bit */
-#define SPORT1_RFSDIV			HALFWORD_REF(SPORT1_RFSDIV_ADDR)
-#define SPORT1_STAT_ADDR		0xffc02c10	/* SPORT 1 status register 16 bit */
-#define SPORT1_STAT				HALFWORD_REF(SPORT1_STAT_ADDR)
-#define SPORT1_MTCS0_ADDR		0xffc02c12	/* SPORT 1 Multi-channel Transmit select reg 16 bit */
-#define SPORT1_MTCS0			HALFWORD_REF(SPORT1_MTCS0_ADDR)
-#define SPORT1_MTCS1_ADDR		0xffc02c14	/* SPORT 1 Multi-channel Transmit select reg 16 bit */
-#define SPORT1_MTCS1			HALFWORD_REF(SPORT1_MTCS1_ADDR)
-#define SPORT1_MTCS2_ADDR		0xffc02c16	/* SPORT 1 Multi-channel Transmit select reg 16 bit */
-#define SPORT1_MTCS2			HALFWORD_REF(SPORT1_MTCS2_ADDR)
-#define SPORT1_MTCS3_ADDR		0xffc02c18	/* SPORT 1 Multi-channel Transmit select reg 16 bit */
-#define SPORT1_MTCS3			HALFWORD_REF(SPORT1_MTCS3_ADDR)
-#define SPORT1_MTCS4_ADDR		0xffc02c1a	/* SPORT 1 Multi-channel Transmit select reg 16 bit */
-#define SPORT1_MTCS4			HALFWORD_REF(SPORT1_MTCS4_ADDR)
-#define SPORT1_MTCS5_ADDR		0xffc02c1c	/* SPORT 1 Multi-channel Transmit select reg 16 bit */
-#define SPORT1_MTCS5			HALFWORD_REF(SPORT1_MTCS5_ADDR)
-#define SPORT1_MTCS6_ADDR		0xffc02c1e	/* SPORT 1 Multi-channel Transmit select reg 16 bit */
-#define SPORT1_MTCS6			HALFWORD_REF(SPORT1_MTCS6_ADDR)
-#define SPORT1_MTCS7_ADDR		0xffc02c20	/* SPORT 1 Multi-channel Transmit select reg 16 bit */
-#define SPORT1_MTCS7			HALFWORD_REF(SPORT1_MTCS7_ADDR)
-#define SPORT1_MRCS0_ADDR		0xffc02c22	/* SPORT 1 Multi-channel Receive select reg 16 bit */
-#define SPORT1_MRCS0			HALFWORD_REF(SPORT1_MRCS0_ADDR)
-#define SPORT1_MRCS1_ADDR		0xffc02c24	/* SPORT 1 Multi-channel Receive select reg 16 bit */
-#define SPORT1_MRCS1			HALFWORD_REF(SPORT1_MRCS1_ADDR)
-#define SPORT1_MRCS2_ADDR		0xffc02c26	/* SPORT 1 Multi-channel Receive select reg 16 bit */
-#define SPORT1_MRCS2			HALFWORD_REF(SPORT1_MRCS2_ADDR)
-#define SPORT1_MRCS3_ADDR		0xffc02c28	/* SPORT 1 Multi-channel Receive select reg 16 bit */
-#define SPORT1_MRCS3			HALFWORD_REF(SPORT1_MRCS3_ADDR)
-#define SPORT1_MRCS4_ADDR		0xffc02c2a	/* SPORT 1 Multi-channel Receive select reg 16 bit */
-#define SPORT1_MRCS4			HALFWORD_REF(SPORT1_MRCS4_ADDR)
-#define SPORT1_MRCS5_ADDR		0xffc02c2c	/* SPORT 1 Multi-channel Receive select reg 16 bit */
-#define SPORT1_MRCS5			HALFWORD_REF(SPORT1_MRCS5_ADDR)
-#define SPORT1_MRCS6_ADDR		0xffc02c2e	/* SPORT 1 Multi-channel Receive select reg 16 bit */
-#define SPORT1_MRCS6			HALFWORD_REF(SPORT1_MRCS6_ADDR)
-#define SPORT1_MRCS7_ADDR		0xffc02c30	/* SPORT 1 Multi-channel Receive select reg 16 bit */
-#define SPORT1_MRCS7			HALFWORD_REF(SPORT1_MRCS7_ADDR)
-#define SPORT1_MCMC1_ADDR		0xffc02c32	/* SPORT 1 Multi-channel configuration reg 1 16 bit */
-#define SPORT1_MCMC1			HALFWORD_REF(SPORT1_MCMC1_ADDR)
-#define SPORT1_MCMC2_ADDR		0xffc02c34	/* SPORT 1 Multi-channel configuration reg 2 16 bit */
-#define SPORT1_MCMC2			HALFWORD_REF(SPORT1_MCMC2_ADDR)
-
-#define SPORT1_CURR_PTR_RX_ADDR		0xffc02e00	/* SPORT 1 RCV DMA Current pointer reg 16 bit */
-#define SPORT1_CURR_PTR_RX			HALFWORD_REF(SPORT1_CURR_PTR_RX_ADDR)
-#define SPORT1_CONFIG_DMA_RX_ADDR	0xffc02e02	/* SPORT 1 RCV DMA Configuration reg 16 bit */
-
-/* Fixed for SPORT driver, Jul 2 2003 */
-#if 0
-#define SPORT1_CONFIG_DMA_RX		HALFWORD_REF(SPORT1_CONFIG_RX_ADDR)
-#else
-#define SPORT1_CONFIG_DMA_RX		HALFWORD_REF(SPORT1_CONFIG_DMA_RX_ADDR)
-#endif
-
-#define SPORT1_START_ADDR_HI_RX_ADDR  	0xffc02e04	/* SPORT 1 RCV DMA start add. hi reg 16 bit */
-#define SPORT1_START_ADDR_HI_RX		HALFWORD_REF(SPORT1_START_ADDR_HI_RX_ADDR)
-#define SPORT1_START_ADDR_LO_RX_ADDR  	0xffc02e06	/* SPORT 1 RCV DMA start add. lo reg 16 bit */
-#define SPORT1_START_ADDR_LO_RX		HALFWORD_REF(SPORT1_START_ADDR_LO_RX_ADDR)
-#define SPORT1_COUNT_RX_ADDR  		0xffc02e08	/* SPORT 1 RCV DMA count reg 16 bit */
-#define SPORT1_COUNT_RX				HALFWORD_REF(SPORT1_COUNT_RX_ADDR)
-#define SPORT1_NEXT_DESCR_RX_ADDR  	0xffc02e0a	/* SPORT 1 RCV DMA next descriptor poin reg 16 bit */
-#define SPORT1_NEXT_DESCR_RX		HALFWORD_REF(SPORT1_NEXT_DESCR_RX_ADDR)
-#define SPORT1_DESCR_RDY_RX_ADDR  	0xffc02e0c	/* SPORT 1 RCV DMA descriptor ready reg 16 bit */
-#define SPORT1_DESCR_RDY_RX			HALFWORD_REF(SPORT1_DESCR_RDY_RX_ADDR)
-#define SPORT1_IRQSTAT_RX_ADDR  	0xffc02e0e	/* SPORT 1 RCV DMA interrupt reg 16 bit */
-#define SPORT1_IRQSTAT_RX			HALFWORD_REF(SPORT1_IRQSTAT_RX_ADDR)
-
-#define SPORT1_CURR_PTR_TX_ADDR		0xffc02f00	/* SPORT 1 XMT DMA Current pointer reg 16 bit */
-#define SPORT1_CURR_PTR_TX			HALFWORD_REF(SPORT1_CURR_PTR_TX_ADDR)
-#define SPORT1_CONFIG_DMA_TX_ADDR	0xffc02f02	/* SPORT 1 XMT DMA Configuration reg 16 bit */
-
-#if 0
-#define SPORT1_CONFIG_DMA_TX		HALFWORD_REF(SPORT1_CONFIG_TX_ADDR)
-#else
-#define SPORT1_CONFIG_DMA_TX		HALFWORD_REF(SPORT1_CONFIG_DMA_TX_ADDR)
-#endif
-
-#define SPORT1_START_ADDR_HI_TX_ADDR  	0xffc02f04	/* SPORT 1 XMT DMA start add. hi reg 16 bit */
-#define SPORT1_START_ADDR_HI_TX		HALFWORD_REF(SPORT1_START_ADDR_HI_TX_ADDR)
-#define SPORT1_START_ADDR_LO_TX_ADDR  	0xffc02f06	/* SPORT 1 XMT DMA start add. lo reg 16 bit */
-#define SPORT1_START_ADDR_LO_TX		HALFWORD_REF(SPORT1_START_ADDR_LO_TX_ADDR)
-#define SPORT1_COUNT_TX_ADDR  		0xffc02f08	/* SPORT 1 XMT DMA count reg 16 bit */
-#define SPORT1_COUNT_TX				HALFWORD_REF(SPORT1_COUNT_TX_ADDR)
-#define SPORT1_NEXT_DESCR_TX_ADDR  	0xffc02f0a	/* SPORT 1 XMT DMA next descriptor poin reg 16 bit */
-#define SPORT1_NEXT_DESCR_TX		HALFWORD_REF(SPORT1_NEXT_DESCR_TX_ADDR)
-#define SPORT1_DESCR_RDY_TX_ADDR  	0xffc02f0c	/* SPORT 1 XMT DMA descriptor ready reg 16 bit */
-#define SPORT1_DESCR_RDY_TX			HALFWORD_REF(SPORT1_DESCR_RDY_TX_ADDR)
-#define SPORT1_IRQSTAT_TX_ADDR  	0xffc02f0e	/* SPORT 1 XMT DMA interrupt reg 16 bit */
-#define SPORT1_IRQSTAT_TX			HALFWORD_REF(SPORT1_IRQSTAT_TX_ADDR)
-
-/****************************
- *
- *  SPI 0 CONTROLLER REGISTERS  (0XFFC03000 - 0XFFC033FF)
- *
- ****************************/
-
-#define SPI0_CTL_ADDR		0xffc03000	/* SPI 0 control register 16 bit */
-#define SPI0_CTL			HALFWORD_REF(SPI0_CTL_ADDR)
-#define SPI0_FLG_ADDR		0xffc03002	/* SPI 0 flag register 16 bit */
-#define SPI0_FLG			HALFWORD_REF(SPI0_FLG_ADDR)
-#define SPI0_ST_ADDR		0xffc03004	/* SPI 0 status register 16 bit */
-#define SPI0_ST				HALFWORD_REF(SPI0_ST_ADDR)
-#define SPI0_TDBR_ADDR		0xffc03006	/* SPI 0 transmit data buffer register 16 bit */
-#define SPI0_TDBR			HALFWORD_REF(SPI0_TDBR_ADDR)
-#define SPI0_RDBR_ADDR		0xffc03008	/* SPI 0 receive data buffer register 16 bit */
-#define SPI0_RDBR			HALFWORD_REF(SPI0_RDBR_ADDR)
-#define SPI0_BAUD_ADDR		0xffc0300a	/* SPI 0 baud rate register 16 bit */
-#define SPI0_BAUD			HALFWORD_REF(SPI0_BAUD_ADDR)
-#define SPI0_SHADOW_ADDR	0xffc0300c	/* SPI 0 RDBR register 16 bit */
-#define SPI0_SHADOW			HALFWORD_REF(SPI0_SHADOW_ADDR)
-
-#define SPI0_CURR_PTR_ADDR		0xffc03200	/* SPI 0 DMA current pointer register 16 bit */
-#define SPI0_CURR_PTR			HALFWORD_REF(SPI0_CURR_PTR_ADDR)
-#define SPI0_CONFIG_ADDR		0xffc03202	/* SPI 0 DMA configuration register 16 bit */
-#define SPI0_CONFIG				HALFWORD_REF(SPI0_CONFIG_ADDR)
-#define SPI0_START_ADDR_HI_ADDR	0xffc03204	/* SPI 0 DMA start address hi register 16 bit */
-#define SPI0_START_ADDR_HI		HALFWORD_REF(SPI0_START_ADDR_HI_ADDR)
-#define SPI0_START_ADDR_LO_ADDR	0xffc03206	/* SPI 0 DMA start address lo register 16 bit */
-#define SPI0_START_ADDR_LO		HALFWORD_REF(SPI0_START_ADDR_LO_ADDR)
-#define SPI0_COUNT_ADDR			0xffc03208	/* SPI 0 DMA count register 16 bit */
-#define SPI0_COUNT				HALFWORD_REF(SPI0_COUNT_ADDR)
-#define SPI0_NEXT_DESCR_ADDR	0xffc0320a	/* SPI 0 DMA Next descriptor pointer register 16 bit */
-#define SPI0_NEXT_DESCR			HALFWORD_REF(SPI0_NEXT_DESCR_ADDR)
-#define SPI0_DESCR_RDY_ADDR		0xffc0320c	/* SPI 0 DMA descriptor ready register 16 bit */
-#define SPI0_DESCR_RDY			HALFWORD_REF(SPI0_DESCR_RDY_ADDR)
-#define SPI0_DMA_INT_ADDR		0xffc0320e	/* SPI 0 DMA interrupt register 16 bit */
-#define SPI0_DMA_INT			HALFWORD_REF(SPI0_DMA_INT_ADDR)
-
-/****************************
- *
- *  SPI 1 CONTROLLER REGISTERS  (0XFFC03400 - 0XFFC037FF)
- *
- ****************************/
-
-#define SPI1_CTL_ADDR		0xffc03400	/* SPI 1 control register 16 bit */
-#define SPI1_CTL			HALFWORD_REF(SPI1_CTL_ADDR)
-#define SPI1_FLG_ADDR		0xffc03402	/* SPI 1 flag register 16 bit */
-#define SPI1_FLG			HALFWORD_REF(SPI1_FLG_ADDR)
-#define SPI1_ST_ADDR		0xffc03404	/* SPI 1 status register 16 bit */
-#define SPI1_ST				HALFWORD_REF(SPI1_ST_ADDR)
-#define SPI1_TDBR_ADDR		0xffc03406	/* SPI 1 transmit data buffer register 16 bit */
-#define SPI1_TDBR			HALFWORD_REF(SPI1_TDBR_ADDR)
-#define SPI1_RDBR_ADDR		0xffc03408	/* SPI 1 receive data buffer register 16 bit */
-#define SPI1_RDBR			HALFWORD_REF(SPI1_RDBR_ADDR)
-#define SPI1_BAUD_ADDR		0xffc0340a	/* SPI 1 baud rate register 16 bit */
-#define SPI1_BAUD			HALFWORD_REF(SPI1_BAUD_ADDR)
-#define SPI1_SHADOW_ADDR	0xffc0340c	/* SPI 1 RDBR register 16 bit */
-#define SPI1_SHADOW			HALFWORD_REF(SPI1_SHADOW_ADDR)
-
-#define SPI1_CURR_PTR_ADDR		0xffc03600	/* SPI 1 DMA current pointer register 16 bit */
-#define SPI1_CURR_PTR			HALFWORD_REF(SPI1_CURR_PTR_ADDR)
-#define SPI1_CONFIG_ADDR		0xffc03602	/* SPI 1 DMA configuration register 16 bit */
-#define SPI1_CONFIG				HALFWORD_REF(SPI1_CONFIG_ADDR)
-#define SPI1_START_ADDR_HI_ADDR	0xffc03604	/* SPI 1 DMA start address hi register 16 bit */
-#define SPI1_START_ADDR_HI		HALFWORD_REF(SPI1_START_ADDR_HI_ADDR)
-#define SPI1_START_ADDR_LO_ADDR	0xffc03606	/* SPI 1 DMA start address lo register 16 bit */
-#define SPI1_START_ADDR_LO		HALFWORD_REF(SPI1_START_ADDR_LO_ADDR)
-#define SPI1_COUNT_ADDR			0xffc03608	/* SPI 1 DMA count register 16 bit */
-#define SPI1_COUNT				HALFWORD_REF(SPI1_COUNT_ADDR)
-#define SPI1_NEXT_DESCR_ADDR	0xffc0360a	/* SPI 1 DMA Next descriptor pointer register 16 bit */
-#define SPI1_NEXT_DESCR			HALFWORD_REF(SPI1_NEXT_DESCR_ADDR)
-#define SPI1_DESCR_RDY_ADDR		0xffc0360c	/* SPI 1 DMA descriptor ready register 16 bit */
-#define SPI1_DESCR_RDY			HALFWORD_REF(SPI1_DESCR_RDY_ADDR)
-#define SPI1_DMA_INT_ADDR		0xffc0360e	/* SPI 1 DMA interrupt register 16 bit */
-#define SPI1_DMA_INT			HALFWORD_REF(SPI1_DMA_INT_ADDR)
-
-/****************************
- *
- *  MEMORY DMA CONTROLLER REGISTERS  (0XFFC03800 - 0XFFC03BFF)
- *
- ****************************/
-
-#define MDW_DCP_ADDR		0xffc03800	/* Current pointer write channel register 16 bit */
-#define MDW_DCP				HALFWORD_REF(MDW_DCP_ADDR)
-#define MDW_DCFG_ADDR		0xffc03802	/* DMA configuration write channel register 16 bit */
-#define MDW_DCFG			HALFWORD_REF(MDW_DCFG_ADDR)
-#define MDW_DSAH_ADDR		0xffc03804	/* Start address hi write channel register 16 bit */
-#define MDW_DSAH			HALFWORD_REF(MDW_DSAH_ADDR)
-#define MDW_DSAL_ADDR		0xffc03806	/* Start address lo write channel register 16 bit */
-#define MDW_DSAL			HALFWORD_REF(MDW_DSAL_ADDR)
-#define MDW_DCT_ADDR		0xffc03808	/* DMA count write channel register 16 bit */
-#define MDW_DCT				HALFWORD_REF(MDW_DCT_ADDR)
-#define MDW_DND_ADDR		0xffc0380a	/* Next descriptor pointer write channel register 16 bit */
-#define MDW_DND				HALFWORD_REF(MDW_DND_ADDR)
-#define MDW_DDR_ADDR		0xffc0380c	/* Descriptor ready write channel register 16 bit */
-#define MDW_DDR				HALFWORD_REF(MDW_DDR_ADDR)
-#define MDW_DI_ADDR			0xffc0380e	/* DMA interrupt write channel register 16 bit */
-#define MDW_DI				HALFWORD_REF(MDW_DI_ADDR)
-
-#define MDR_DCP_ADDR		0xffc03900	/* Current pointer read channel register 16 bit */
-#define MDR_DCP				HALFWORD_REF(MDR_DCP_ADDR)
-#define MDR_DCFG_ADDR		0xffc03902	/* DMA configuration read channel register 16 bit */
-#define MDR_DCFG			HALFWORD_REF(MDR_DCFG_ADDR)
-#define MDR_DSAH_ADDR		0xffc03904	/* Start address hi read channel register 16 bit */
-#define MDR_DSAH			HALFWORD_REF(MDR_DSAH_ADDR)
-#define MDR_DSAL_ADDR		0xffc03906	/* Start address lo read channel register 16 bit */
-#define MDR_DSAL			HALFWORD_REF(MDR_DSAL_ADDR)
-#define MDR_DCT_ADDR		0xffc03908	/* DMA count read channel register 16 bit */
-#define MDR_DCT				HALFWORD_REF(MDR_DCT_ADDR)
-#define MDR_DND_ADDR		0xffc0390a	/* Next descriptor pointer read channel register 16 bit */
-#define MDR_DND				HALFWORD_REF(MDR_DND_ADDR)
-#define MDR_DDR_ADDR		0xffc0390c	/* Descriptor ready read channel register 16 bit */
-#define MDR_DDR				HALFWORD_REF(MDR_DDR_ADDR)
-#define MDR_DI_ADDR			0xffc0390e	/* DMA interrupt read channel register 16 bit */
-#define MDR_DI				HALFWORD_REF(MDR_DI_ADDR)
-
-/****************************
- *
- *  ASYNCHRONOUS MEMORY CONTROLLER REGISTERS EDIU (0XFFC03C00 - 0XFFC03FFF)
- *
- ****************************/
-
-#define EBIU_AMGCTL_ADDR	0xffc03c00	/* Asynchronous memory global control register ? bit */
-#define EBIU_AMGCTL			WORD_REF(MDW_AMGCTL_ADDR)
-#define EBIU_AMBCTL0_ADDR	0xffc03c04	/* Asynchronous memory bank control register 0 32 bit */
-#define EBIU_AMBCTL0		WORD_REF(MDW_AMBCTL0_ADDR)
-#define EBIU_AMBCTL1_ADDR	0xffc03c08	/* Asynchronous memory bank control register 1 32 bit */
-#define EBIU_AMBCTL1		WORD_REF(MDW_AMBCTL1_ADDR)
-
-/****************************
- *
- *  PCI BRIDGE PAB REGISTERS  (0XFFC04000 - 0XFFC043FF)
- *
- ****************************/
-
-#define PCI_CTL_ADDR		0xffc04000	/* PCI bridge control register 32 bit */
-#define PCI_CTL				WORD_REF(PCI_CTL_ADDR)
-#define PCI_STAT_ADDR		0xffc04004	/* PCI bridge status register 32 bit */
-#define PCI_STAT			WORD_REF(PCI_STAT_ADDR)
-#define PCI_ICTL_ADDR		0xffc04008	/* PCI bridge interrupt control register 32 bit */
-#define PCI_ICTL			WORD_REF(PCI_ICTL_ADDR)
-#define PCI_MBAP_ADDR		0xffc0400c	/* PCI memory space base address pointer[31:27] register 32 bit */
-#define PCI_MBAP			WORD_REF(PCI_MBAP_ADDR)
-#define PCI_IBAP_ADDR		0xffc04010	/* PCI IO space base address pointer register 32 bit */
-#define PCI_IBAP			WORD_REF(PCI_IBAP_ADDR)
-#define PCI_CPAB_ADDR		0xffc04014	/* PCI config space base address port register 32 bit */
-#define PCI_CPAB			WORD_REF(PCI_CPAB_ADDR)
-#define PCI_TMBAP_ADDR		0xffc04018	/* PCI to Tahoe memory base address pointer register 32 bit */
-#define PCI_TMBAP			WORD_REF(PCI_TMBAP_ADDR)
-#define PCI_TIBAP_ADDR		0xffc0401c	/* PCI to Tahoe IO base address pointer register 32 bit */
-#define PCI_TIBAP			WORD_REF(PCI_TIBAP_ADDR)
-
-/****************************
- *
- *  PCI BRIDGE EXTERNAL ACCESS BUS REGISTERS  (0XEEFFFF00 - 0XEEFFFFFF)
- *
- ****************************/
-
-#define PCI_DMBARM_ADDR		0xeeffff00	/* PCI Device memory bar mask register 32 bit */
-#define PCI_DMBARM			WORD_REF(PCI_DMBARM_ADDR)
-#define PCI_DIBARM_ADDR		0xeeffff04	/* PCI Device IO bar mask register 32 bit */
-#define PCI_DIBARM			WORD_REF(PCI_DIBARM_ADDR)
-#define PCI_CFG_DIC_ADDR	0xeeffff08	/* PCI config Device ID register 32 bit */
-#define PCI_CFG_DIC			WORD_REF(PCI_CFG_DIC_ADDR)
-#define PCI_CFG_VIC_ADDR	0xeeffff0c	/* PCI config vendor ID register 32 bit */
-#define PCI_CFG_VIC			WORD_REF(PCI_CFG_VIC_ADDR)
-#define PCI_CFG_STAT_ADDR	0xeeffff10	/* PCI config status (read only) register 32 bit */
-#define PCI_CFG_STAT		WORD_REF(PCI_CFG_STAT_ADDR)
-#define PCI_CFG_CMD_ADDR	0xeeffff14	/* PCI config command register 32 bit */
-#define PCI_CFG_CMD			WORD_REF(PCI_CFG_CMD_ADDR)
-#define PCI_CFG_CC_ADDR		0xeeffff18	/* PCI config class code register 32 bit */
-#define PCI_CFG_CC			WORD_REF(PCI_CFG_CC_ADDR)
-#define PCI_CFG_RID_ADDR	0xeeffff1C	/* PCI config revision ID register 32 bit */
-#define PCI_CFG_RID			WORD_REF(PCI_CFG_RID_ADDR)
-#define PCI_CFG_BIST_ADDR	0xeeffff20	/* PCI config BIST register 32 bit */
-#define PCI_CFG_BIST		WORD_REF(PCI_CFG_BIST_ADDR)
-#define PCI_CFG_HT_ADDR		0xeeffff24	/* PCI config header type register 32 bit */
-#define PCI_CFG_HT			WORD_REF(PCI_CFG_HT_ADDR)
-#define PCI_CFG_MLT_ADDR	0xeeffff28	/* PCI config memory latency timer register 32 bit */
-#define PCI_CFG_MLT			WORD_REF(PCI_CFG_MLT_ADDR)
-#define PCI_CFG_CLS_ADDR	0xeeffff2C	/* PCI config cache line (block) size register 32 bit */
-#define PCI_CFG_CLS			WORD_REF(PCI_CFG_CLS_ADDR)
-#define PCI_CFG_MBAR_ADDR	0xeeffff30	/* PCI config memory base address register 32 bit */
-#define PCI_CFG_MBAR		WORD_REF(PCI_CFG_MBAR_ADDR)
-#define PCI_CFG_IBAR_ADDR	0xeeffff34	/* PCI config IO base address register 32 bit */
-#define PCI_CFG_IBAR		WORD_REF(PCI_CFG_IBAR_ADDR)
-#define PCI_CFG_SID_ADDR	0xeeffff38	/* PCI config subsystem ID register 32 bit */
-#define PCI_CFG_SID			WORD_REF(PCI_CFG_SID_ADDR)
-#define PCI_CFG_SVID_ADDR	0xeeffff3C	/* PCI config subsystem vendor ID register 32 bit */
-#define PCI_CFG_SVID		WORD_REF(PCI_CFG_SVID_ADDR)
-#define PCI_CFG_MAXL_ADDR	0xeeffff40	/* PCI config maximum latency cycles register 32 bit */
-#define PCI_CFG_MAXL		WORD_REF(PCI_CFG_MAXL_ADDR)
-#define PCI_CFG_MING_ADDR	0xeeffff44	/* PCI config minimum grant cycles register 32 bit */
-#define PCI_CFG_MING		WORD_REF(PCI_CFG_MING_ADDR)
-#define PCI_CFG_IP_ADDR		0xeeffff48	/* PCI config interrupt pin register 32 bit */
-#define PCI_CFG_IP			WORD_REF(PCI_CFG_IP_ADDR)
-#define PCI_CFG_IL_ADDR		0xeeffff4C	/* PCI config interrupt line register 32 bit */
-#define PCI_CFG_IL			WORD_REF(PCI_CFG_IL_ADDR)
-#define PCI_HMCTL_ADDR		0xeeffff50	/* PCI config blocking BAR mask 1 (host only) register 32 bit */
-#define PCI_HMCTL			WORD_REF(PCI_HMCTL_ADDR)
-
-/****************************
- *
- *  UNIVERSAL SERIAL BUS INTERFACE (USB) REGISTERS  (0XFFC04400 - 0XFFC047FF)
- *
- ****************************/
-
-#define USBD_ID_ADDR		0xffc04400	/* USB Device ID register 16 bit */
-#define USBD_ID				HALFWORD_REF(USBD_ID_ADDR)
-#define USBD_FRM_ADDR		0xffc04402	/* Current USB frame number register 16 bit */
-#define USBD_FRM			HALFWORD_REF(USBD_FRM_ADDR)
-#define USBD_FRMAT_ADDR		0xffc04404	/* Match value for USB frame number register 16 bit */
-#define USBD_FRMAT			HALFWORD_REF(USBD_FRMAT_ADDR)
-#define USBD_EPBUF_ADDR		0xffc04406	/* Enables download of configuration into UDC core register 16 bit */
-#define USBD_EPBUF			HALFWORD_REF(USBD_EPBUF_ADDR)
-#define USBD_STAT_ADDR		0xffc04408	/* Return USBD Module status register 16 bit */
-#define USBD_STAT			HALFWORD_REF(USBD_STAT_ADDR)
-#define USBD_CTRL_ADDR		0xffc0440a	/* Allows configuration & control of USBD module register 16 bit */
-#define USBD_CTRL			HALFWORD_REF(USBD_CTRL_ADDR)
-#define USBD_GINTR_ADDR		0xffc0440c	/* Global interrupt register 16 bit */
-#define USBD_GINTR			HALFWORD_REF(USBD_GINTR_ADDR)
-#define USBD_GMASK_ADDR		0xffc0440e	/* Global interrupt register mask register 16 bit */
-#define USBD_GMASK			HALFWORD_REF(USBD_GMASK_ADDR)
-
-#define USBD_DMACFG_ADDR	0xffc04440	/* DMA Master channel configuration register 16 bit */
-#define USBD_DMACFG			HALFWORD_REF(USBD_DMACFG_ADDR)
-#define USBD_DMABL_ADDR		0xffc04442	/* DMA Master channel base address low register 16 bit */
-#define USBD_DMABL			HALFWORD_REF(USBD_DMABL_ADDR)
-#define USBD_DMABH_ADDR		0xffc04444	/* DMA Master channel base address high register 16 bit */
-#define USBD_DMABH			HALFWORD_REF(USBD_DMABH_ADDR)
-#define USBD_DMACT_ADDR		0xffc04446	/* DMA Master channel count register 16 bit */
-#define USBD_DMACT			HALFWORD_REF(USBD_DMACT_ADDR)
-#define USBD_DMAIRQ_ADDR	0xffc04448	/* DMA Master channel IRQ register 16 bit */
-#define USBD_DMAIRQ			HALFWORD_REF(USBD_DMAIRQ_ADDR)
-
-#define USBD_INTR0_ADDR		0xffc04480	/* USB Endpoint 0 interrupt register 16 bit */
-#define USBD_INTR0			HALFWORD_REF(USBD_INTR0_ADDR)
-#define USBD_MASK0_ADDR		0xffc04482	/* USB Endpoint 0 mask register 16 bit */
-#define USBD_MASK0			HALFWORD_REF(USBD_MASK0_ADDR)
-#define USBD_EPCFG0_ADDR	0xffc04484	/* USB Endpoint 0 control register 16 bit */
-#define USBD_EPCFG0			HALFWORD_REF(USBD_EPCFG0_ADDR)
-#define USBD_EPADR0_ADDR	0xffc04486	/* USB Endpoint 0 address offset register 16 bit */
-#define USBD_EPADR0			HALFWORD_REF(USBD_EPADR0_ADDR)
-#define USBD_EPLEN0_ADDR	0xffc04488	/* USB Endpoint 0 buffer length register 16 bit */
-#define USBD_EPLEN0			HALFWORD_REF(USBD_EPLEN0_ADDR)
-
-#define USBD_INTR1_ADDR		0xffc0448a	/* USB Endpoint 1 interrupt register 16 bit */
-#define USBD_INTR1			HALFWORD_REF(USBD_INTR1_ADDR)
-#define USBD_MASK1_ADDR		0xffc0448c	/* USB Endpoint 1 mask register 16 bit */
-#define USBD_MASK1			HALFWORD_REF(USBD_MASK1_ADDR)
-#define USBD_EPCFG1_ADDR	0xffc0448e	/* USB Endpoint 1 control register 16 bit */
-#define USBD_EPCFG1			HALFWORD_REF(USBD_EPCFG1_ADDR)
-#define USBD_EPADR1_ADDR	0xffc04490	/* USB Endpoint 1 address offset register 16 bit */
-#define USBD_EPADR1			HALFWORD_REF(USBD_EPADR1_ADDR)
-#define USBD_EPLEN1_ADDR	0xffc04492	/* USB Endpoint 1 buffer length register 16 bit */
-#define USBD_EPLEN1			HALFWORD_REF(USBD_EPLEN1_ADDR)
-
-#define USBD_INTR2_ADDR		0xffc04494	/* USB Endpoint 2 interrupt register 16 bit */
-#define USBD_INTR2			HALFWORD_REF(USBD_INTR2_ADDR)
-#define USBD_MASK2_ADDR		0xffc04496	/* USB Endpoint 2 mask register 16 bit */
-#define USBD_MASK2			HALFWORD_REF(USBD_MASK2_ADDR)
-#define USBD_EPCFG2_ADDR	0xffc04498	/* USB Endpoint 2 control register 16 bit */
-#define USBD_EPCFG2			HALFWORD_REF(USBD_EPCFG2_ADDR)
-#define USBD_EPADR2_ADDR	0xffc0449a	/* USB Endpoint 2 address offset register 16 bit */
-#define USBD_EPADR2			HALFWORD_REF(USBD_EPADR2_ADDR)
-#define USBD_EPLEN2_ADDR	0xffc0449c	/* USB Endpoint 2 buffer length register 16 bit */
-#define USBD_EPLEN2			HALFWORD_REF(USBD_EPLEN2_ADDR)
-
-/* Fixed by HuTao, Jun18 2003 4:35PM */
-#if 0
-#define USBD_INTR3_ADDR		0xffc0448e	/* USB Endpoint 3 interrupt register 16 bit */
-#else
-#define USBD_INTR3_ADDR		0xffc0449e	/* USB Endpoint 3 interrupt register 16 bit */
-#endif
-
-#define USBD_INTR3			HALFWORD_REF(USBD_INTR3_ADDR)
-#define USBD_MASK3_ADDR		0xffc044a0	/* USB Endpoint 3 mask register 16 bit */
-#define USBD_MASK3			HALFWORD_REF(USBD_MASK3_ADDR)
-#define USBD_EPCFG3_ADDR	0xffc044a2	/* USB Endpoint 3 control register 16 bit */
-#define USBD_EPCFG3			HALFWORD_REF(USBD_EPCFG3_ADDR)
-#define USBD_EPADR3_ADDR	0xffc044a4	/* USB Endpoint 3 address offset register 16 bit */
-#define USBD_EPADR3			HALFWORD_REF(USBD_EPADR3_ADDR)
-#define USBD_EPLEN3_ADDR	0xffc044a6	/* USB Endpoint 3 buffer length register 16 bit */
-#define USBD_EPLEN3			HALFWORD_REF(USBD_EPLEN3_ADDR)
-
-#define USBD_INTR4_ADDR		0xffc044a8	/* USB Endpoint 4 interrupt register 16 bit */
-#define USBD_INTR4			HALFWORD_REF(USBD_INTR4_ADDR)
-#define USBD_MASK4_ADDR		0xffc044aa	/* USB Endpoint 4 mask register 16 bit */
-#define USBD_MASK4			HALFWORD_REF(USBD_MASK4_ADDR)
-#define USBD_EPCFG4_ADDR	0xffc044ac	/* USB Endpoint 4 control register 16 bit */
-#define USBD_EPCFG4			HALFWORD_REF(USBD_EPCFG4_ADDR)
-#define USBD_EPADR4_ADDR	0xffc044ae	/* USB Endpoint 4 address offset register 16 bit */
-#define USBD_EPADR4			HALFWORD_REF(USBD_EPADR4_ADDR)
-#define USBD_EPLEN4_ADDR	0xffc044b0	/* USB Endpoint 4 buffer length register 16 bit */
-#define USBD_EPLEN4			HALFWORD_REF(USBD_EPLEN4_ADDR)
-
-#define USBD_INTR5_ADDR		0xffc044b2	/* USB Endpoint 5 interrupt register 16 bit */
-#define USBD_INTR5			HALFWORD_REF(USBD_INTR5_ADDR)
-#define USBD_MASK5_ADDR		0xffc044b4	/* USB Endpoint 5 mask register 16 bit */
-#define USBD_MASK5			HALFWORD_REF(USBD_MASK5_ADDR)
-#define USBD_EPCFG5_ADDR	0xffc044b6	/* USB Endpoint 5 control register 16 bit */
-#define USBD_EPCFG5			HALFWORD_REF(USBD_EPCFG5_ADDR)
-#define USBD_EPADR5_ADDR	0xffc044b8	/* USB Endpoint 5 address offset register 16 bit */
-#define USBD_EPADR5			HALFWORD_REF(USBD_EPADR5_ADDR)
-#define USBD_EPLEN5_ADDR	0xffc044ba	/* USB Endpoint 5 buffer length register 16 bit */
-#define USBD_EPLEN5			HALFWORD_REF(USBD_EPLEN5_ADDR)
-
-#define USBD_INTR6_ADDR		0xffc044bc	/* USB Endpoint 6 interrupt register 16 bit */
-#define USBD_INTR6			HALFWORD_REF(USBD_INTR6_ADDR)
-#define USBD_MASK6_ADDR		0xffc044be	/* USB Endpoint 6 mask register 16 bit */
-#define USBD_MASK6			HALFWORD_REF(USBD_MASK6_ADDR)
-#define USBD_EPCFG6_ADDR	0xffc044c0	/* USB Endpoint 6 control register 16 bit */
-#define USBD_EPCFG6			HALFWORD_REF(USBD_EPCFG6_ADDR)
-#define USBD_EPADR6_ADDR	0xffc044c2	/* USB Endpoint 6 address offset register 16 bit */
-#define USBD_EPADR6			HALFWORD_REF(USBD_EPADR6_ADDR)
-#define USBD_EPLEN6_ADDR	0xffc044c4	/* USB Endpoint 6 buffer length register 16 bit */
-#define USBD_EPLEN6			HALFWORD_REF(USBD_EPLEN6_ADDR)
-
-#define USBD_INTR7_ADDR		0xffc044c6	/* USB Endpoint 7 interrupt register 16 bit */
-#define USBD_INTR7			HALFWORD_REF(USBD_INTR7_ADDR)
-#define USBD_MASK7_ADDR		0xffc044c8	/* USB Endpoint 7 mask register 16 bit */
-#define USBD_MASK7			HALFWORD_REF(USBD_MASK7_ADDR)
-#define USBD_EPCFG7_ADDR	0xffc044ca	/* USB Endpoint 7 control register 16 bit */
-#define USBD_EPCFG7			HALFWORD_REF(USBD_EPCFG7_ADDR)
-#define USBD_EPADR7_ADDR	0xffc044cc	/* USB Endpoint 7 address offset register 16 bit */
-#define USBD_EPADR7			HALFWORD_REF(USBD_EPADR7_ADDR)
-#define USBD_EPLEN7_ADDR	0xffc044ce	/* USB Endpoint 7 buffer length register 16 bit */
-#define USBD_EPLEN7			HALFWORD_REF(USBD_EPLEN7_ADDR)
-
-/****************************
- *
- * SYSTEM BUS INTERFACE UNIT REGISTERS  (0XFFC04800 - 0XFFC04FFF)
- *
- ****************************/
-
-#define L1SBAR_ADDR		0xffc04840	/* L1 SRAM base address register 16 bit */
-#define L1SBAR			HALFWORD_REF(L1SBAR_ADDR)
-#define L1CSR_ADDR		0xffc04844	/* L1 SRAM control initialization register 32 bit */
-#define L1CSR			WORD_REF(L1CSR_ADDR)
-#define DB_NDBP_ADDR		0xffc04880	/* Next descriptor base pointer register 32 bit */
-#define DB_NDBP			WORD_REF(DB_NDBP_ADDR)
-#define DB_ACOMP_ADDR		0xffc04884	/* DMA bus address comparator register 32 bit */
-#define DB_ACOMP		WORD_REF(DB_ACOMP_ADDR)
-#define DB_CCOMP_ADDR		0xffc04888	/* DMA bus control comparator register 32 bit */
-#define DB_CCOMP		WORD_REF(DB_CCOMP_ADDR)
-
-/****************************
- *
- * SDRAM CONTROLLER EXTERNAL BUS INTERFACE REGISTERS  (0XFFC04C00 - 0XFFC04FFF)
- *
- ****************************/
-
-#define EBIU_SDGCTL_ADDR	0xffc04c00	/* SDRAM Memory global control register 32 bit */
-#define EBIU_SDGCTL		WORD_REF(EBIU_SDGCTL_ADDR)
-#define EBIU_SDBCTL_ADDR	0xffc04c00	/* SDRAM Memory bank control register 32 bit */
-#define EBIU_SDBCTL		WORD_REF(EBIU_SDBCTL_ADDR)
-#define EBIU_SDRRC_ADDR		0xffc04c00	/* SDRAM Memory refresh rate count register 16 bit */
-#define EBIU_SDRRC		HALFWORD_REF(EBIU_SDRRC_ADDR)
-#define EBIU_SDSTAT_ADDR	0xffc04c00	/* SDRAM control status register 16 bit */
-#define EBIU_SDSTAT		HALFWORD_REF(EBIU_SDSTAT_ADDR)
-
- /*      FOLLOWING ARE THE BFIN CORE MMR REGISTERS (TOP 2 MB)     */
-
-/****************************
- *
- *  L1 DATA MEMORY CONTROLLER REGISTERS  (0XFFE00000 - 0XFFE00404)
- *
- ****************************/
-
-#define SRAM_BASE_ADDR_ADDR	0xffe00000	/* read only register 32 bit */
-#define SRAM_BASE_ADDR		WORD_REF(SRAM_BASE_ADDR_ADDR)
-#define DATA_FAULT_STATUS_ADDR	0xffe00008	/* read only register 32 bit */
-#define DATA_FAULT_STATUS	WORD_REF(DATA_FAULT_STATUS_ADDR)
-#define DATA_FAULT_ADDR_ADDR	0xffe0000c	/* read only register 32 bit */
-#define DATA_FAULT_ADDR		WORD_REF(DATA_FAULT_ADDR_ADDR)
-
-		/* These are total sixteen */
-
-#define DCPLB_ADDR_ADDR		0xffe00100	/* read/write register 32 bit */
-#define DCPLB_ADDR		WORD_REF(DCPLB_ADDR_ADDR)
-
-		/* These are total sixteen */
-
-#define DCPLB_DATA_ADDR		0xffe00200	/* read/write register 32 bit */
-#define DCPLB_DATA		WORD_REF(DCPLB_DATA_ADDR)
-
-		/* These are total 4 */
-
-#define DTEST_DATA_ADDR		0xffe00400	/* read/write register 32 bit */
-#define DTEST_DATA		WORD_REF(DTEST_DATA_ADDR)
-
-/****************************
- *
- *  L1 CODE MEMORY CONTROLLER REGISTERS  (0XFFE01004 - 0XFFE1404)
- *
- ****************************/
-
-#define CODE_FAULT_STATUS_ADDR	0xffe01008	/* read only register 32 bit */
-#define CODE_FAULT_STATUS	WORD_REF(CODE_FAULT_STATUS_ADDR)
-#define CODE_FAULT_ADDR_ADDR	0xffe0100c	/* read only register 32 bit */
-#define CODE_FAULT_ADDR		WORD_REF(CODE_FAULT_ADDR_ADDR)
-
-		/* These are total sixteen */
-
-#define ICPLB_ADDR_ADDR		0xffe01100	/* read/write register 32 bit */
-#define ICPLB_ADDR		WORD_REF(ICPLB_ADDR_ADDR)
-
-		/* These are total sixteen */
-
-#define ICPLB_DATA_ADDR		0xffe01200	/* read/write register 32 bit */
-#define ICPLB_DATA		WORD_REF(ICPLB_DATA_ADDR)
-
-		/* These are total 4 */
-
-#define ITEST_DATA_ADDR		0xffe01400	/* read/write register 32 bit */
-#define ITEST_DATA		WORD_REF(ITEST_DATA_ADDR)
-
-/****************************
- *
- *  INTERRUPT CONTROLLER REGISTERS  (0XFFE02000 - 0XFFE0210C)
- *
- ****************************/
-
- /*   EVENT VECTOR TABLE IS USED FOR 16 INTERRUPTS AS SHOWN BELOW
-    ALSO THEIR PRIORITY SEQUENCE IS ALSO GIVEN HERE
-    1           EMULATION               HIGHEST
-    2           RESET
-    3           NMI
-    4           EXCEPTION
-    5           INTERRUPTS              LOWEST */
-
-/*  Used with JTAG register 32 bit */
-#define EVT_EMULATION_ADDR	0xffe02000
-#define EVT_EMULATION		WORD_REF(EVT_EMULATION_ADDR)
-/*  register 32 bit */
-#define EVT_RESET_ADDR		0xffe02004
-#define EVT_RESET		WORD_REF(EVT_RESET_ADDR)
-/*  NMI register 32 bit */
-#define EVT_NMI_ADDR		0xffe02008
-#define EVT_NMI			WORD_REF(EVT_NMI_ADDR)
-/*  Identification with code in EXCAUSE register 32 bit */
-#define EVT_EXCEPTION_ADDR	0xffe0200c
-#define EVT_EXCEPTION		WORD_REF(EVT_EXCEPTION_ADDR)
-/*  Global interrupt enable register 32 bit */
-#define EVT_GLOBAL_INT_ENB_ADDR	0xffe02010
-#define EVT_GLOBAL_INT_ENB	WORD_REF(EVT_GLOBAL_INT_ENB_ADDR)
-/*  Active while error condition exsists register 32 bit */
-#define EVT_HARDWARE_ERROR_ADDR	0xffe02014
-#define EVT_HARDWARE_ERROR	WORD_REF(EVT_HARDWARE_ERROR_ADDR)
-/*  High priority timer register 32 bit */
-#define EVT_TIMER_ADDR		0xffe02018
-#define EVT_TIMER		WORD_REF(EVT_TIMER_ADDR)
-/*  General purpose interrupt register 32 bit */
-#define EVT_IVG7_ADDR		0xffe0201c
-#define EVT_IVG7		WORD_REF(EVT_IVG7_ADDR)
-/*  General purpose interrupt register 32 bit */
-#define EVT_IVG8_ADDR		0xffe02020
-#define EVT_IVG8		WORD_REF(EVT_IVG8_ADDR)
-/*  General purpose interrupt register 32 bit */
-#define EVT_IVG9_ADDR		0xffe02024
-#define EVT_IVG9		WORD_REF(EVT_IVG9_ADDR)
-/*  General purpose interrupt register 32 bit */
-#define EVT_IVG10_ADDR		0xffe02028
-#define EVT_IVG10		WORD_REF(EVT_IVG10_ADDR)
-/*  General purpose interrupt register 32 bit */
-#define EVT_IVG11_ADDR		0xffe0202c
-#define EVT_IVG11		WORD_REF(EVT_IVG11_ADDR)
-/*  General purpose interrupt register 32 bit */
-#define EVT_IVG12_ADDR		0xffe02030
-#define EVT_IVG12		WORD_REF(EVT_IVG12_ADDR)
-/*  General purpose interrupt register 32 bit */
-#define EVT_IVG13_ADDR		0xffe02034
-#define EVT_IVG13		WORD_REF(EVT_IVG13_ADDR)
-
-/* IVG14 & IVG15 should be used as software interrupts  */
-
-/*  General purpose interrupt register 32 bit */
-#define EVT_IVG14_ADDR		0xffe02038
-#define EVT_IVG14		WORD_REF(EVT_IVG14_ADDR)
-/*  General purpose interrupt register 32 bit */
-#define EVT_IVG15_ADDR		0xffe0203c
-#define EVT_IVG15		WORD_REF(EVT_IVG15_ADDR)
-
-#define EVT_OVERRIDE_ADDR	0xffe02100	/*  register 32 bit */
-#define EVT_OVERRIDE		WORD_REF(EVT_OVERRIDE_ADDR)
-#define IMASK_ADDR		0xffe02104	/*  register 32 bit */
-#define IMASK			WORD_REF(IMASK_ADDR)
-#define IPEND_ADDR		0xffe02108	/*  register 32 bit */
-#define IPEND			WORD_REF(IPEND_ADDR)
-#define ILAT_ADDR		0xffe0210c	/*  register 32 bit */
-#define ILAT			WORD_REF(ILAT_ADDR)
-
-/****************************
- *
- *  TIMER REGISTERS  (0XFFC03000 - 0XFFC0300C)
- *
- ****************************/
-
-#define TCNTL_ADDR		0xffe03000	/*  register 32 bit */
-#define TCNTL			WORD_REF(TCNTL_ADDR)
-#define TPERIOD_ADDR		0xffe03004	/*  register 32 bit */
-#define TPERIOD			WORD_REF(TPERIOD_ADDR)
-#define TSCALE_ADDR		0xffe03008	/*  register 32 bit */
-#define TSCALE			WORD_REF(TSCALE_ADDR)
-#define TCOUNT_ADDR		0xffe0300c	/*  register 32 bit */
-#define TCOUNT			WORD_REF(TCOUNT_ADDR)
-
-/****************************
- *
- *  DEBUG & EMULATION UNIT REGISTERS  (0XFFC05000 - 0XFFC0500C)
- *
- ****************************/
-
-#define DSPID_ADDR		0xffe05000	/*  register 32 bit */
-#define DSPID			WORD_REF(DSPID_ADDR)
-#define DBGSTAT_ADDR		0xffe05008	/*  register 32 bit */
-#define DBGSTAT			WORD_REF(DBGSTAT_ADDR)
-#define EMUDAT_ADDR		0xffe0500c	/*  register 32 bit */
-#define EMUDAT			WORD_REF(EMUDAT_ADDR)
-
-/****************************
- *
- *  TRACE UNIT REGISTERS  (0XFFC06000 - 0XFFC06100)
- *
- ****************************/
-
-#define TBUFCTL_ADDR		0xffe06000	/*  register 32 bit */
-#define TBUFCTL			WORD_REF(TBUFCTL_ADDR)
-#define TBUFSTAT_ADDR		0xffe06004	/*  register 32 bit */
-#define TBUFSTAT		WORD_REF(TBUFSTAT_ADDR)
-#define TBUF_ADDR		0xffe06100	/*  register 32 bit */
-#define TBUF			WORD_REF(TBUF_ADDR)
-
-/****************************
- *
- *  WATCHPOINT & PATCH UNIT REGISTERS  (0XFFC07000 - 0XFFC07200)
- *
- ****************************/
-
-#define WPIACTL_ADDR		0xffe07000	/*  register 32 bit */
-#define WPIACTL			WORD_REF(WPIACTL_ADDR)
-		/* TOTAL OF 6  */
-#define WPIA_ADDR		0xffe07040	/*  register 32 bit */
-#define WPIA			WORD_REF(WPIA_ADDR)
-		/* TOTAL OF 6  */
-#define WPIACNT_ADDR		0xffe07080	/*  register 32 bit */
-#define WPIACNT			WORD_REF(WPIACNT_ADDR)
-
-#define WPDACTL_ADDR		0xffe07100	/*  register 32 bit */
-#define WPDACTL			WORD_REF(WPDACTL_ADDR)
-		/* TOTAL OF 2 */
-#define WPDA_ADDR		0xffe07140	/*  register 32 bit */
-#define WPDA			WORD_REF(WPDA_ADDR)
-		/* TOTAL OF 2 */
-#define WPDACNT_ADDR		0xffe07180	/*  register 32 bit */
-#define WPDACNT			WORD_REF(WPDACNT_ADDR)
-
-#define WPSTAT_ADDR		0xffe07200	/*  register 32 bit */
-#define WPSTAT			WORD_REF(WPSTAT_ADDR)
-
-/****************************
- *
- *  PERFORMANCE MONITOR REGISTERS  (0XFFC08000 - 0XFFC08104)
- *
- ****************************/
-
-#define PFCTL_ADDR		0xffe08000	/*  register 32 bit */
-#define PFCTL			WORD_REF(PFCTL_ADDR)
-		/* TOTAL OF 2 */
-#define PFCNTR_ADDR		0xffe08100	/*  register 32 bit */
-#define PFCNTR			WORD_REF(PFCNTR_ADDR)
-
-/***************************
- *
- * SYSTEM INTERRUPT CONTROLLER REGISTERS
- *
- ***************************/
-#define SIC_ISR_ADDR		0xffc00c14	/*  register 32 bit */
-#define SIC_ISR			WORD_REF(SIC_ISR_ADDR)
-
-#define SIC_IWR_ADDR		0xffc00c18	/*  register 32 bit */
-#define SIC_IWR			WORD_REF(SIC_IWR_ADDR)
-
-#define SIC_MASK_ADDR		0xffc00c10	/*  register 32 bit */
-#define SIC_MASK		WORD_REF(SIC_MASK_ADDR)
-
-#define SIC_RVECT_ADDR		0xffc00c00	/*  register 16 bit */
-#define SIC_RVECT		HALFWORD_REF(SIC_RVECT_ADDR)
-
-#define SIC_MASK_ALL		0x80000000
-
-#endif				/* __MACH_BF535_H__  */
diff -puN include/asm-blackfin/mach-bf535/bf535_serial.h~blackfin-arch-2.6.21-rc4-mm1-update /dev/null
--- a/include/asm-blackfin/mach-bf535/bf535_serial.h
+++ /dev/null
@@ -1,109 +0,0 @@
-
- /*
-  * File:         include/asm-blackfin/mach-bf535/bf535_serial.h
-  * Based on:
-  * Author:
-  *
-  * Created:
-  * Description:
-  *
-  * Rev:
-  *
-  * Modified:
-  *
-  *
-  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
-  *
-  * This program is free software; you can redistribute it and/or modify
-  * it under the terms of the GNU General Public License as published by
-  * the Free Software Foundation; either version 2, or (at your option)
-  * any later version.
-  *
-  * This program is distributed in the hope that it will be useful,
-  * but WITHOUT ANY WARRANTY; without even the implied warranty of
-  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  * GNU General Public License for more details.
-  *
-  * You should have received a copy of the GNU General Public License
-  * along with this program; see the file COPYING.
-  * If not, write to the Free Software Foundation,
-  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
-  */
-
-#ifndef _BF535_SERIAL_H_
-#define _BF535_SERIAL_H_
-
-#define UART0_THR_ADDR		0xffc01800	/* UART 0 Transmit holding register
-						   16 bit */
-#define UART_THR(idx)		HALFWORD_REF((UART0_THR_ADDR | (idx << 10)))
-
-#define UART0_RBR_ADDR		0xffc01800	/* UART 0 Receive buffer register
-						   16 bit */
-#define UART_RBR(idx)		HALFWORD_REF((UART0_RBR_ADDR | (idx << 10)))
-
-#define UART0_DLL_ADDR		0xffc01800	/* UART 0 Divisor latch (low byte)
-						   register  16 bit */
-#define UART_DLL(idx)		HALFWORD_REF((UART0_DLL_ADDR | (idx << 10)))
-
-#define UART0_IER_ADDR		0xffc01802	/* UART 0 Interrupt enable register  16 bit */
-#define UART_IER(idx)		HALFWORD_REF((UART0_IER_ADDR | (idx << 10)))
-#define UART_IER_ERBFI		0x01	/* Enable Receive Buffer Full Interrupt
-					   (DR bit) */
-#define UART_IER_ETBEI		0x02	/* Enable Transmit Buffer Empty
-					   Interrupt(THRE bit) */
-#define UART_IER_ELSI		0x04	/* Enable RX Status Interrupt
-					   (gen if any of LSR[4:1] set) */
-#define UART_IER_EDDSI		0x08	/* Enable Modem Status Interrupt(gen if any UARTx_MSR[3:0] set) */
-
-#define UART0_DLH_ADDR		0xffc01802	/* UART 0 Divisor latch (high byte) register  16 bit */
-#define UART_DLH(idx)		HALFWORD_REF((UART0_DLH_ADDR | (idx << 10)))
-#define UART0_IIR_ADDR		0xffc01804	/* UART 0 Interrupt identification register  16 bit */
-#define UART_IIR(idx)		HALFWORD_REF((UART0_IIR_ADDR | (idx << 10)))
-#define UART_IIR_NOINT		0x01	/* Bit0: cleared when no interrupt */
-#define UART_IIR_STATUS		0x06	/* mask bit for the status: bit2-1 */
-#define UART_IIR_LSR		0x06	/* Receive line status */
-#define UART_IIR_RBR		0x04	/* Receive data ready */
-#define UART_IIR_THR		0x02	/* Ready to transmit  */
-#define UART_IIR_MSR		0x00	/* Modem status       */
-
-#define UART0_LCR_ADDR          0xffc01806	/* UART 0 Line control register  16 bit */
-#define UART_LCR(idx)           HALFWORD_REF((UART0_LCR_ADDR | (idx << 10)))
-#define UART_LCR_WLS5           0	/* word length 5 bits */
-#define UART_LCR_WLS6           0x01	/* word length 6 bits */
-#define UART_LCR_WLS7           0x02	/* word length 7 bits */
-#define UART_LCR_WLS8           0x03	/* word length 8 bits */
-#define UART_LCR_STB            0x04	/* StopBit: 1: 2 stop bits for
-					   non-5-bit word length 1/2 stop bits
-					   for 5-bit word length 0:
-					   1 stop bit */
-#define UART_LCR_PEN            0x08	/* Parity Enable 1: for enable */
-#define UART_LCR_EPS            0x10	/* Parity Selection:
-					   1: for even pariety
-					   0: odd parity when PEN =1 & SP =0 */
-#define UART_LCR_SP             0x20	/* Sticky Parity: */
-#define UART_LCR_SB             0x40	/* Set Break: force TX pin to 0 */
-#define UART_LCR_DLAB           0x80	/* Divisor Latch Access */
-
-#define UART0_MCR_ADDR          0xffc01808	/* UART 0 Module Control register
-						   16 bit */
-#define UART_MCR(idx)           HALFWORD_REF((UART0_MCR_ADDR | (idx << 10)))
-
-#define UART0_LSR_ADDR          0xffc0180a	/* UART 0 Line status register
-						   16 bit */
-#define UART_LSR(idx)           HALFWORD_REF((UART0_LSR_ADDR | (idx << 10)))
-#define UART_LSR_DR             0x01	/* Data Ready */
-#define UART_LSR_OE             0x02	/* Overrun Error */
-#define UART_LSR_PE             0x04	/* Parity Error  */
-#define UART_LSR_FE             0x08	/* Frame Error   */
-#define UART_LSR_BI             0x10	/* Break Interrupt */
-#define UART_LSR_THRE           0x20	/* THR empty, REady to accept */
-#define UART_LSR_TEMT           0x40	/* TSR and UARTx_thr both empty */
-
-#define UART0_MSR_ADDR          0xffc0180c	/* UART 0 Modem status register  16 bit */
-#define UART_MSR(idx)           HALFWORD_REF((UART0_MSR_ADDR | (idx << 10)))
-#define UART0_SCR_ADDR          0xffc0180e	/* UART 0 Scratch register  16 bit */
-#define UART_SCR(idx)           HALFWORD_REF((UART0_SCR_ADDR | (idx << 10)))
-#define UART0_IRCR_ADDR         0xffc01810	/* UART 0 IrDA Control register  16 bit */
-#define UART_IRCR(idx)          HALFWORD_REF((UART0_IRCR_ADDR | (idx << 10)))
-
-#endif				/* _BF535_SERIAL_H_ */
diff -puN include/asm-blackfin/mach-bf535/blackfin.h~blackfin-arch-2.6.21-rc4-mm1-update /dev/null
--- a/include/asm-blackfin/mach-bf535/blackfin.h
+++ /dev/null
@@ -1,43 +0,0 @@
-/*
- * File:         include/asm-blackfin/mach-bf535/blackfin.h
- * Based on:
- * Author:
- *
- * Created:
- * Description:
- *	Common header file for blackfin family of processors
- * Rev:
- *
- * Modified:
- *
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; see the file COPYING.
- * If not, write to the Free Software Foundation,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-#ifndef _MACH_BLACKFIN_H_
-#define _MACH_BLACKFIN_H_
-
-#include "bf535.h"
-#include "mem_map.h"
-#include "defBF535.h"
-
-#if !(defined(__ASSEMBLY__) || defined(ASSEMBLY))
-#include "cdefBF535.h"
-#endif
-
-#endif				/* _MACH_BLACKFIN_H_ */
diff -puN include/asm-blackfin/mach-bf535/cdefBF535.h~blackfin-arch-2.6.21-rc4-mm1-update /dev/null
--- a/include/asm-blackfin/mach-bf535/cdefBF535.h
+++ /dev/null
@@ -1,121 +0,0 @@
-/*
- * File:         include/asm-blackfin/mach-bf535/cdefBF535.h
- * Based on:
- * Author:
- *
- * Created:
- * Description:
- *	include all Core registers and bit definition
- * Rev:
- *
- * Modified:
- *
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; see the file COPYING.
- * If not, write to the Free Software Foundation,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-#ifndef _CDEF_BF535_H
-#define _CDEF_BF535_H
-
- /* */
-/*
-#if defined(__ADSPLPBLACKFIN__)
-#warning cdefBF535.h should only be included for 535 compatible chips.
-#endif
-*/
-#include "defBF535.h"
-
- /* include core specific register pointer definitions */
-#include "cdefblackfin.h"
-
- /* Clock and System Control (0xFFC0 0400-0xFFC0 07FF) */
-
- /* JTAG/Debug Communication Channel (0xFFC0 0800-0xFFC0 0BFF) */
-
- /* System Interrupt Controller (0xFFC0 0C00-0xFFC0 0FFF) */
-/*
-#define SIC_RVECT              0xFFC00C00   /* Reset Vector Register */
-*/
-
- /* Watchdog Timer (0xFFC0 1000-0xFFC0 13FF) */
-
- /* Real Time Clock (0xFFC0 1400-0xFFC0 17FF) */
-
- /* General Purpose IO (0xFFC0 2400-0xFFC0 27FF) */
-
- /* Aysnchronous Memory Controller - External Bus Interface Unit (0xFFC0 3C00-0xFFC0 3FFF) */
-
- /* USB Registers (0xFFC0 4400 - 0xFFC0 47FF) */
-
- /* SDRAM Controller External Bus Interface Unit (0xFFC0 4C00-0xFFC0 4FFF) */
-
- /* Memory Map */
-
- /* Core MMRs */
-
- /* System MMRs */
-
- /* L1 cache/SRAM internal memory */
-
- /* L2 SRAM external memory */
-
- /* PCI Spaces */
-
- /* Async Memory Banks */
-
- /* Sync DRAM Banks */
-
- /* System MMR Register Map */
-/*
- /* L2 MISR MMRs (0xFFC0 0000-0xFFC0 03FF) */
-#define MISR_CTL               0xFFC00000      /* Control Register */
-#define MISR_RMISR0            0xFFC00004      /* coreL2[31:0] read bus */
-#define MISR_RMISR1            0xFFC00008      /* coreL2[63:32] read bus */
-#define MISR_RMISR2            0xFFC0000C      /* sysL2[31:0] read bus */
-#define MISR_WMISR0            0xFFC00010      /* coreL2[31:0] write bus */
-#define MISR_WMISR1            0xFFC00014      /* coreL2[63:32] write bus */
-#define MISR_WMISR2            0xFFC00018      /* sysL2[31:0] write bus */
-*/
-
- /* UART 0 Controller (0xFFC0 1800-0xFFC0 1BFF) */
-
- /* UART 1 Controller (0xFFC0 1C00-0xFFC0 1FFF) */
-
- /* TIMER 0, 1, 2 Registers (0xFFC0 2000-0xFFC0 23FF) */
-
- /* SPORT0 Controller (0xFFC0 2800-0xFFC0 2BFF) */
-
- /* SPORT1 Controller (0xFFC0 2C00-0xFFC0 2FFF) */
-
- /* SPI 0 Controller (0xFFC0 3000-0xFFC0 33FF) */
-
- /* SPI 1 Controller (0xFFC0 3400-0xFFC0 37FF) */
-
- /* Memory DMA Controller (0xFFC0 3800-0xFFC0 3BFF) */
-
- /* PCI Bridge PAB Registers (0xFFC0 4000-0xFFC0 43FF) */
-
- /* PCI Bridge External Access Bus Registers (0xEEFF FF00-0xEEFF FFFF) */
-
- /* System Bus Interface Unit (0xFFC0 4800-0xFFC0 4FFF) */
-
-/* #define L1SBAR                 0xFFC04840    */  /* L1 SRAM Base Address Register */
-/* #define L1CSR                  0xFFC04844 */  /* L1 SRAM Control Initialization Register */
-
-
-#endif				/* _CDEF_BF535_H */
diff -puN include/asm-blackfin/mach-bf535/cdefblackfin.h~blackfin-arch-2.6.21-rc4-mm1-update /dev/null
--- a/include/asm-blackfin/mach-bf535/cdefblackfin.h
+++ /dev/null
@@ -1,69 +0,0 @@
-
-/*
- * File:         include/asm-blackfin/mach-bf535/cdefblackfin.h
- * Based on:
- * Author:
- *
- * Created:
- * Description:
- *	Common header file for blackfin family of processors
- * Rev:
- *
- * Modified:
- *
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; see the file COPYING.
- * If not, write to the Free Software Foundation,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-#ifndef _CDEF_BLACKFIN_H
-#define _CDEF_BLACKFIN_H
-/*
-#if defined(__ADSPLPBLACKFIN__)
-#warning cdefblackfin.h should only be included for 535 compatible chips.
-#endif
-*/
-#include "defblackfin.h"
-
- /* Cache & SRAM Memory */
-/*
-#define MMR_TIMEOUT            0xFFE00010   /* Memory-Mapped Register Timeout Register */
-*/
-/*
-#define DTEST_INDEX            0xFFE00304   /* Data Test Index Register */
-*/
-/*
-/* #define DTEST_DATA2            0xFFE00408 */   /* Data Test Data Register */
-/* #define DTEST_DATA3            0xFFE0040C */   /* Data Test Data Register */
-*/
-/*
-#define ITEST_INDEX            0xFFE01304   /* Instruction Test Index Register */
-*/
-
- /* Event/Interrupt Registers */
-
- /* Core Timer Registers */
-
- /* Debug/MP/Emulation Registers */
-
- /* Trace Buffer Registers */
-
- /* Watch Point Control Registers */
-
- /* Performance Monitor Registers */
-
-#endif				/* _CDEF_BLACKFIN_H */
diff -puN include/asm-blackfin/mach-bf535/defBF535.h~blackfin-arch-2.6.21-rc4-mm1-update /dev/null
--- a/include/asm-blackfin/mach-bf535/defBF535.h
+++ /dev/null
@@ -1,1818 +0,0 @@
-/*
- * File:         include/asm-blackfin/mach-bf535/defBF535.h
- * Based on:
- * Author:
- *
- * Created:
- * Description:
- *	Common header file for blackfin family of processors
- * Rev:
- *
- * Modified:
- *
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; see the file COPYING.
- * If not, write to the Free Software Foundation,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-/* SYSTEM & MM REGISTER BIT & ADDRESS DEFINITIONS FOR ADSP-BF535 */
-
-#ifndef _DEF_BF535_H
-#define _DEF_BF535_H
-
-#if defined(__ADSPLPBLACKFIN__)
-#warning defBF535.h should only be included for 535 compatible chips.
-#endif
-#include <defBlackfin.h>
-
-/********************************
- * Memory Map
- ********************************/
-
-/* Core MMRs */
-#define COREMMR_BASE           0xFFE00000	 /* Core MMRs */
-#define COREMMR_SIZE           0x200000	 /* 2MB */
-
- /*System MMRs */
-#define SYSMMR_BASE            0xFFC00000	 /* System MMRs */
-#define SYSMMR_SIZE            0x200000	 /* 2MB */
-
- /* L1 cache/SRAM internal memory */
-#define L1_DATA_A		0xFF800000	 /* L1 Data Bank A */
-#define L1_DATA_B		0xFF900000	 /* L1 Data Bank B */
-#define L1_DATA_SIZE		0x4000	 /* 16K */
-#define L1_CODE			0xFFA00000	 /* L1 Code SRAM */
-#define L1_CODE_SIZE		0x4000	 /* 16K */
-#define L1_SCRATCH		0xFFB00000	 /* L1 Scratch SRAM */
-#define L1_SCRATCH_SIZE		0x1000	 /* 4K */
-
- /* L2 SRAM external memory */
-#define L2_BASE			0xF0000000	 /* L2 SRAM */
-#define L2_SIZE			0x40000	 /* 256K */
-
- /* PCI Spaces */
-#define PCI_CONFIG_SPACE_PORT	0xEEFFFFFC	 /* PCI config space reg */
-#define PCI_CONFIG_BASE		0xEEFFFF00	 /* PCI config region */
-#define PCI_CONFIG_SIZE		0x10000	 /* 64K */
-#define PCI_IO_BASE		0xEEFE0000	 /* PCI I/O space */
-#define PCI_IO_SIZE		0x10000	 /* 64K */
-#define PCI_MEM_BASE		0xE0000000	 /* PCI Mem space */
-#define PCI_MEM_SIZE		0x8000000	 /* 64K */
-
- /* Async Memory Banks */
-#define ASYNC_BANK3_BASE	0x2C000000	 /* Async Bank 3 */
-#define ASYNC_BANK3_SIZE	0x4000000	 /* 64 MB */
-#define ASYNC_BANK2_BASE	0x28000000	 /* Async Bank 2 */
-#define ASYNC_BANK2_SIZE	0x4000000	 /* 64 MB */
-#define ASYNC_BANK1_BASE	0x24000000	 /* Async Bank 1 */
-#define ASYNC_BANK1_SIZE	0x4000000	 /* 64 MB */
-#define ASYNC_BANK0_BASE	0x20000000	 /* Async Bank 0 */
-#define ASYNC_BANK0_SIZE	0x4000000	 /* 64 MB */
-
- /* Sync DRAM Banks */
-#define SDRAM_BANK3_BASE	0x18000000	 /* Sync Bank 3 */
-#define SDRAM_BANK2_BASE	0x10000000	 /* Sync Bank 2 */
-#define SDRAM_BANK1_BASE	0x08000000	 /* Sync Bank 1 */
-#define SDRAM_BANK0_BASE	0x00000000	 /* Sync Bank 0 */
-
- /*********************************************************************************** */
- /* System MMR Register Map */
- /*********************************************************************************** */
-
- /* L2 MISR MMRs (0xFFC0 0000-0xFFC0 03FF) */
-#define MISR_CTL               0xFFC00000	 /* Control Register */
-#define MISR_RMISR0            0xFFC00004	 /* coreL2[31:0] read bus */
-#define MISR_RMISR1            0xFFC00008	 /* coreL2[63:32] read bus */
-#define MISR_RMISR2            0xFFC0000C	 /* sysL2[31:0] read bus */
-#define MISR_WMISR0            0xFFC00010	 /* coreL2[31:0] write bus */
-#define MISR_WMISR1            0xFFC00014	 /* coreL2[63:32] write bus */
-#define MISR_WMISR2            0xFFC00018	 /* sysL2[31:0] write bus */
-
- /* Clock and System Control (0xFFC0 0400-0xFFC0 07FF) */
-#define PLL_CTL                0xFFC00400	 /* PLL Control register */
-						 /* (32-bit) */
-#define PLL_STAT               0xFFC00404	 /* PLL Status register */
-#define PLL_LOCKCNT            0xFFC00406	 /* PLL Lock Counter register */
-#define PLL_IOCKR              0xFFC00408	 /* Peripheral Clock Enable */
-						 /* register (32-bit) */
-#define SWRST                  0xFFC00410	 /* Software Reset Register */
-
-#define PLLCTL			PLL_CTL
-#define PLLSTAT			PLL_STAT
-#define LOCKCNT			PLL_LOCKCNT
-#define IOCKR			PLL_IOCKR
-
-#define SYSCR                  0xFFC00414	 /* System Configuration */
-						 /* register (RCSR) */
-
-/* JTAG/Debug Communication Channel (0xFFC0 0800-0xFFC0 0BFF) */
-#define CHIPID                 0xFFC048C0	 /* Device ID Register */
-
-/* System Interrupt Controller (0xFFC0 0C00-0xFFC0 0FFF) */
-#define SIC_RVECT              0xFFC00C00	 /* Reset Vector Register */
-#define SIC_IAR0               0xFFC00C04	 /* Interrupt Assignment */
-						 /* Register 0 */
-#define SIC_IAR1               0xFFC00C08	 /* Interrupt Assignment */
-						 /* Register 1 */
-#define SIC_IAR2               0xFFC00C0C	 /* Interrupt Assignment */
-						 /* Register 2 */
-#define SIC_IMASK              0xFFC00C10	 /* Interrupt Mask Register */
-#define SIC_ISR                0xFFC00C14	 /* Interrupt Status Register */
-#define SIC_IWR                0xFFC00C18	 /* Interrupt Wakeup Register */
-
-/* Watchdog Timer (0xFFC0 1000-0xFFC0 13FF) */
-#define WDOGCTL                0xFFC01000	 /* Watchdog Control Register */
-#define WDOGCNT                0xFFC01004	 /* Watchdog Count Register */
-#define WDOGSTAT               0xFFC01008	 /* Watchdog Status Register */
-
-#define WDOG_CTL		WDOGCTL
-#define WDOG_CNT		WDOGCNT
-#define WDOG_STAT		WDOGSTAT
-
-/* Real Time Clock (0xFFC0 1400-0xFFC0 17FF) */
-#define RTCSTAT                0xFFC01400	 /* RTC Status Register */
-#define RTCICTL                0xFFC01404	 /* RTC Interrupt Control */
-						 /* Register */
-#define RTCISTAT               0xFFC01408	 /* RTC Interrupt Status */
-						 /* Register */
-#define RTCSWCNT               0xFFC0140C	 /* RTC Stopwatch Count Register */
-#define RTCALARM               0xFFC01410	 /* RTC Alarm Time Register */
-#define RTCFAST                0xFFC01414	 /* RTC Prescaler Control */
-						 /* Register */
-
-#define RTC_STAT		RTCSTAT
-#define RTC_ICTL		RTCICTL
-#define RTC_ISTAT		RTCISTAT
-#define RTC_SWCNT		RTCSWCNT
-#define RTC_ALARM		RTCALARM
-#define RTC_FAST		RTCFAST
-
-/* UART 0 Controller (0xFFC0 1800-0xFFC0 1BFF) */
-#define UART0_THR              0xFFC01800	 /* Transmit Holding register */
-#define UART0_RBR              0xFFC01800	 /* Receive Buffer register */
-#define UART0_DLL              0xFFC01800	 /* Divisor Latch (Low-Byte) */
-#define UART0_IER              0xFFC01802	 /* Interrupt Enable Register */
-#define UART0_DLH              0xFFC01802	 /* Divisor Latch (High-Byte) */
-#define UART0_IIR              0xFFC01804	 /* Interrupt Identification */
-						 /* Register */
-#define UART0_LCR              0xFFC01806	 /* Line Control Register */
-#define UART0_MCR              0xFFC01808	 /* Module Control Register */
-#define UART0_LSR              0xFFC0180A	 /* Line Status Register */
-#define UART0_MSR              0xFFC0180C	 /* MSR Modem Status Register */
-#define UART0_SCR              0xFFC0180E	 /* SCR Scratch Register */
-#define UART0_IRCR             0xFFC01810	 /* IRCR IrDA Control Register */
-#define UART0_CURR_PTR_RX      0xFFC01A00	 /* UART -DMA RCV Current */
-						 /* Pointer register */
-#define UART0_CONFIG_RX        0xFFC01A02	 /* UART -RCV DMA Configuration */
-						 /* register */
-#define UART0_START_ADDR_HI_RX 0xFFC01A04	 /* UART -RCV DMA Start Page */
-						 /* register */
-#define UART0_START_ADDR_LO_RX 0xFFC01A06	 /* UART -RCV DMA Start Address */
-						 /* register */
-#define UART0_COUNT_RX         0xFFC01A08	 /* UART -RCV DMA Count register */
-#define UART0_NEXT_DESCR_RX    0xFFC01A0A	 /* UART -RCV DMA Next */
-						 /* Descriptor Pointer register */
-#define UART0_DESCR_RDY_RX     0xFFC01A0C	 /* UART -RCV DMA Descriptor */
-						 /* Ready */
-#define UART0_IRQSTAT_RX       0xFFC01A0E	 /* UART -RCV DMA Interrupt */
-						 /* Register */
-#define UART0_CURR_PTR_TX      0xFFC01B00	 /* UART -XMT DMA Current */
-						 /* Pointer register */
-#define UART0_CONFIG_TX        0xFFC01B02	 /* UART -XMT DMA Configuration */
-						 /* register */
-#define UART0_START_ADDR_HI_TX 0xFFC01B04	 /* UART -XMT DMA Start Page */
-						 /* register */
-#define UART0_START_ADDR_LO_TX 0xFFC01B06	 /* UART -XMT DMA Start Address */
-						 /* register */
-#define UART0_COUNT_TX         0xFFC01B08	 /* UART -XMT DMA Count register */
-#define UART0_NEXT_DESCR_TX    0xFFC01B0A	 /* UART -XMT DMA Next */
-						 /* Descriptor Pointer register */
-#define UART0_DESCR_RDY_TX     0xFFC01B0C	 /* UART -XMT DMA Descriptor */
-						 /* Ready */
-#define UART0_IRQSTAT_TX       0xFFC01B0E	 /* UART -XMT DMA Interrupt */
-						 /* register */
-
- /* UART 1 Controller (0xFFC0 1C00-0xFFC0 1FFF) */
-#define UART1_THR              0xFFC01C00	 /* Transmit Holding register */
-#define UART1_RBR              0xFFC01C00	 /* Receive Buffer register */
-#define UART1_DLL              0xFFC01C00	 /* Divisor Latch (Low-Byte) */
-#define UART1_IER              0xFFC01C02	 /* Interrupt Enable Register */
-#define UART1_DLH              0xFFC01C02	 /* Divisor Latch (High-Byte) */
-#define UART1_IIR              0xFFC01C04	 /* Interrupt Identification */
-						 /* Register */
-#define UART1_LCR              0xFFC01C06	 /* Line Control Register */
-#define UART1_MCR              0xFFC01C08	 /* Module Control Register */
-#define UART1_LSR              0xFFC01C0A	 /* Line Status Register */
-#define UART1_MSR              0xFFC01C0C	 /* MSR Modem Status Register */
-#define UART1_SCR              0xFFC01C0E	 /* SCR Scratch Register */
-#define UART1_CURR_PTR_RX      0xFFC01E00	 /* UART -DMA RCV Current */
-						 /* Pointer register */
-#define UART1_CONFIG_RX        0xFFC01E02	 /* UART -RCV DMA Configuration */
-						 /* register */
-#define UART1_START_ADDR_HI_RX 0xFFC01E04	 /* UART -RCV DMA Start Page */
-						 /* register */
-#define UART1_START_ADDR_LO_RX 0xFFC01E06	 /* UART -RCV DMA Start Address */
-						 /* register */
-#define UART1_COUNT_RX         0xFFC01E08	 /* UART -RCV DMA Count register */
-#define UART1_NEXT_DESCR_RX    0xFFC01E0A	 /* UART -RCV DMA Next */
-						 /* Descriptor Pointer register */
-#define UART1_DESCR_RDY_RX     0xFFC01E0C	 /* UART -RCV DMA Descriptor */
-						 /* Ready */
-#define UART1_IRQSTAT_RX       0xFFC01E0E	 /* UART -RCV DMA Interrupt */
-						 /* Register */
-#define UART1_CURR_PTR_TX      0xFFC01F00	 /* UART -XMT DMA Current */
-						 /* Pointer register */
-#define UART1_CONFIG_TX        0xFFC01F02	 /* UART -XMT DMA Configuration */
-						 /* register */
-#define UART1_START_ADDR_HI_TX 0xFFC01F04	 /* UART -XMT DMA Start Page */
-						 /* register */
-#define UART1_START_ADDR_LO_TX 0xFFC01F06	 /* UART -XMT DMA Start Address */
-						 /* register */
-#define UART1_COUNT_TX         0xFFC01F08	 /* UART -XMT DMA Count register */
-#define UART1_NEXT_DESCR_TX    0xFFC01F0A	 /* UART -XMT DMA Next */
-						 /* Descriptor Pointer register */
-#define UART1_DESCR_RDY_TX     0xFFC01F0C	 /* UART -XMT DMA Descriptor */
-						 /* Ready */
-#define UART1_IRQSTAT_TX       0xFFC01F0E	 /* UART -XMT DMA Interrupt */
-						 /* register */
-
- /* TIMER 0, 1, 2 Registers (0xFFC0 2000-0xFFC0 23FF) */
-#define TIMER0_STATUS          0xFFC02000	 /* Timer 0 Global Status and */
-						 /* Sticky Register */
-#define TIMER0_CONFIG          0xFFC02002	 /* Timer 0 configuration */
-						 /* Register */
-#define TIMER0_COUNTER_LO      0xFFC02004	 /* Timer 0 Counter Register */
-						 /* (low word) */
-#define TIMER0_COUNTER_HI      0xFFC02006	 /* Timer 0 Counter Register */
-						 /* (high word) */
-#define TIMER0_PERIOD_LO       0xFFC02008	 /* Timer 0 Period Register (low */
-						 /* word) */
-#define TIMER0_PERIOD_HI       0xFFC0200A	 /* Timer 0 Period Register */
-						 /* (high word) */
-#define TIMER0_WIDTH_LO        0xFFC0200C	 /* Timer 0 Width Register (low */
-						 /* word) */
-#define TIMER0_WIDTH_HI        0xFFC0200E	 /* Timer 0 Width Register (high */
-						 /* word) */
-#define TIMER1_STATUS          0xFFC02010	 /* Timer 1 Global Status and */
-						 /* Sticky Register */
-#define TIMER1_CONFIG          0xFFC02012	 /* Timer 1 configuration */
-						 /* register */
-#define TIMER1_COUNTER_LO      0xFFC02014	 /* Timer 1 Counter Register */
-						 /* (low word) */
-#define TIMER1_COUNTER_HI      0xFFC02016	 /* Timer 1 Counter Register */
-						 /* (high word) */
-#define TIMER1_PERIOD_LO       0xFFC02018	 /* Timer 1 Period Register (low */
-						 /* word) */
-#define TIMER1_PERIOD_HI       0xFFC0201A	 /* Timer 1 Period Register */
-						 /* (high word) */
-#define TIMER1_WIDTH_LO        0xFFC0201C	 /* Timer 1 Width Register (low */
-						 /* word) */
-#define TIMER1_WIDTH_HI        0xFFC0201E	 /* Timer 1 Width Register (high */
-						 /* word) */
-#define TIMER2_STATUS          0xFFC02020	 /* Timer 2 Global Status and */
-						 /* Sticky Register */
-#define TIMER2_CONFIG          0xFFC02022	 /* Timer 2 configuration */
-						 /* register */
-#define TIMER2_COUNTER_LO      0xFFC02024	 /* Timer 2 Counter Register */
-						 /* (low word) */
-#define TIMER2_COUNTER_HI      0xFFC02026	 /* Timer 2 Counter Register */
-						 /* (high word) */
-#define TIMER2_PERIOD_LO       0xFFC02028	 /* Timer 2 Period Register (low */
-						 /* word) */
-#define TIMER2_PERIOD_HI       0xFFC0202A	 /* Timer 2 Period Register */
-						 /* (high word) */
-#define TIMER2_WIDTH_LO        0xFFC0202C	 /* Timer 2 Width Register (low */
-						 /* word) */
-#define TIMER2_WIDTH_HI        0xFFC0202E	 /* Timer 2 Width Register (high */
-						 /* word) */
-
- /* General Purpose IO (0xFFC0 2400-0xFFC0 27FF) */
-#define FIO_DIR                0xFFC02400	 /* Peripheral Flag Direction */
-						 /* Register */
-#define FIO_FLAG_C             0xFFC02404	 /* Peripheral Interrupt Flag */
-						 /* Register (clear) */
-#define FIO_FLAG_S             0xFFC02406	 /* Peripheral Interrupt Flag */
-						 /* Register (set) */
-#define FIO_MASKA_C            0xFFC02408	 /* Flag Mask Interrupt A */
-						 /* Register (clear) */
-#define FIO_MASKA_S            0xFFC0240A	 /* Flag Mask Interrupt A */
-						 /* Register (set) */
-#define FIO_MASKB_C            0xFFC0240C	 /* Flag Mask Interrupt B */
-						 /* Register (clear) */
-#define FIO_MASKB_S            0xFFC0240E	 /* Flag Mask Interrupt B */
-						 /* Register (set) */
-#define FIO_POLAR              0xFFC02410	 /* Flag Source Polarity */
-						 /* Register */
-#define FIO_EDGE               0xFFC02414	 /* Flag Source Sensitivity */
-						 /* Register */
-#define FIO_BOTH               0xFFC02418	 /* Flag Set on BOTH Edges */
-						 /* Register */
-
- /* SPORT0 Controller (0xFFC0 2800-0xFFC0 2BFF) */
-#define SPORT0_TX_CONFIG       0xFFC02800	 /* SPORT0 Transmit */
-						 /* Configuration Register */
-#define SPORT0_RX_CONFIG       0xFFC02802	 /* SPORT0 Receive Configuration */
-						 /* Register */
-#define SPORT0_TX              0xFFC02804	 /* SPORT0 TX transmit Register */
-#define SPORT0_RX              0xFFC02806	 /* SPORT0 RX Receive register */
-#define SPORT0_TSCLKDIV        0xFFC02808	 /* SPORT0 Transmit Serial Clock */
-						 /* Divider */
-#define SPORT0_RSCLKDIV        0xFFC0280A	 /* SPORT0 Receive Serial Clock */
-						 /* Divider */
-#define SPORT0_TFSDIV          0xFFC0280C	 /* SPORT0 Transmit Frame Sync */
-						 /* Divider */
-#define SPORT0_RFSDIV          0xFFC0280E	 /* SPORT0 Receive Frame Sync */
-						 /* Divider */
-#define SPORT0_STAT            0xFFC02810	 /* SPORT0 Status Register */
-#define SPORT0_MTCS0           0xFFC02812	 /* SPORT0 Multi-Channel */
-						 /* Transmit Select Register */
-#define SPORT0_MTCS1           0xFFC02814	 /* SPORT0 Multi-Channel */
-						 /* Transmit Select Register */
-#define SPORT0_MTCS2           0xFFC02816	 /* SPORT0 Multi-Channel */
-						 /* Transmit Select Register */
-#define SPORT0_MTCS3           0xFFC02818	 /* SPORT0 Multi-Channel */
-						 /* Transmit Select Register */
-#define SPORT0_MTCS4           0xFFC0281A	 /* SPORT0 Multi-Channel */
-						 /* Transmit Select Register */
-#define SPORT0_MTCS5           0xFFC0281C	 /* SPORT0 Multi-Channel */
-						 /* Transmit Select Register */
-#define SPORT0_MTCS6           0xFFC0281E	 /* SPORT0 Multi-Channel */
-						 /* Transmit Select Register */
-#define SPORT0_MTCS7           0xFFC02820	 /* SPORT0 Multi-Channel */
-						 /* Transmit Select Register */
-#define SPORT0_MRCS0           0xFFC02822	 /* SPORT0 Multi-Channel Receive */
-						 /* Select Register */
-#define SPORT0_MRCS1           0xFFC02824	 /* SPORT0 Multi-Channel Receive */
-						 /* Select Register */
-#define SPORT0_MRCS2           0xFFC02826	 /* SPORT0 Multi-Channel Receive */
-						 /* Select Register */
-#define SPORT0_MRCS3           0xFFC02828	 /* SPORT0 Multi-Channel Receive */
-						 /* Select Register */
-#define SPORT0_MRCS4           0xFFC0282A	 /* SPORT0 Multi-Channel Receive */
-						 /* Select Register */
-#define SPORT0_MRCS5           0xFFC0282C	 /* SPORT0 Multi-Channel Receive */
-						 /* Select Register */
-#define SPORT0_MRCS6           0xFFC0282E	 /* SPORT0 Multi-Channel Receive */
-						 /* Select Register */
-#define SPORT0_MRCS7           0xFFC02830	 /* SPORT0 Multi-Channel Receive */
-						 /* Select Register */
-#define SPORT0_MCMC1           0xFFC02832	 /* SPORT0 Multi-Channel */
-						 /* Configuration Register 1 */
-#define SPORT0_MCMC2           0xFFC02834	 /* SPORT0 Multi-Channel */
-						 /* Configuration Register 2 */
-#define SPORT0_CURR_PTR_RX     0xFFC02A00	 /* SPORT0 -RCV DMA Current */
-						 /* Pointer */
-#define SPORT0_CONFIG_DMA_RX   0xFFC02A02	 /* SPORT0 -RCV DMA */
-						 /* Configuration */
-#define SPORT0_START_ADDR_HI_RX 0xFFC02A04	 /* SPORT0 -RCV DMA Start Page */
-#define SPORT0_START_ADDR_LO_RX 0xFFC02A06	 /* SPORT0 -RCV DMA Start */
-						 /* Address */
-#define SPORT0_COUNT_RX        0xFFC02A08	 /* SPORT0 -RCV DMA Count */
-#define SPORT0_NEXT_DESCR_RX   0xFFC02A0A	 /* SPORT0 -RCV DMA Next */
-						 /* Descriptor Pointer */
-#define SPORT0_DESCR_RDY_RX    0xFFC02A0C	 /* SPORT0 -RCV DMA Descriptor */
-						 /* Ready */
-#define SPORT0_IRQSTAT_RX      0xFFC02A0E	 /* SPORT0 -RCV DMA Interrupt */
-						 /* Register */
-#define SPORT0_CURR_PTR_TX     0xFFC02B00	 /* SPORT0 -XMT DMA Current */
-						 /* Pointer */
-#define SPORT0_CONFIG_DMA_TX   0xFFC02B02	 /* SPORT0 -XMT DMA */
-						 /* Configuration */
-#define SPORT0_START_ADDR_HI_TX 0xFFC02B04	 /* SPORT0 -XMT DMA Start Page */
-#define SPORT0_START_ADDR_LO_TX 0xFFC02B06	 /* SPORT0 -XMT DMA Start */
-						 /* Address */
-#define SPORT0_COUNT_TX        0xFFC02B08	 /* SPORT0 -XMT DMA Count */
-#define SPORT0_NEXT_DESCR_TX   0xFFC02B0A	 /* SPORT0 -XMT DMA Next */
-						 /* Descriptor Pointer */
-#define SPORT0_DESCR_RDY_TX    0xFFC02B0C	 /* SPORT0 -XMT DMA Descriptor */
-						 /* Ready */
-#define SPORT0_IRQSTAT_TX      0xFFC02B0E	 /* SPORT0 -XMT DMA Interrupt */
-						 /* Register */
-
- /* SPORT1 Controller (0xFFC0 2C00-0xFFC0 2FFF) */
-#define SPORT1_TX_CONFIG       0xFFC02C00	 /* SPORT1 Transmit */
-						 /* Configuration Register */
-#define SPORT1_RX_CONFIG       0xFFC02C02	 /* SPORT1 Receive Configuration */
-						 /* Register */
-#define SPORT1_TX              0xFFC02C04	 /* SPORT1 TX transmit Register */
-#define SPORT1_RX              0xFFC02C06	 /* SPORT1 RX Receive register */
-#define SPORT1_TSCLKDIV        0xFFC02C08	 /* SPORT1 Transmit Serial Clock */
-						 /* Divider */
-#define SPORT1_RSCLKDIV        0xFFC02C0A	 /* SPORT1 Receive Serial Clock */
-						 /* Divider */
-#define SPORT1_TFSDIV          0xFFC02C0C	 /* SPORT1 Transmit Frame Sync */
-						 /* Divider */
-#define SPORT1_RFSDIV          0xFFC02C0E	 /* SPORT1 Receive Frame Sync */
-						 /* Divider */
-#define SPORT1_STAT            0xFFC02C10	 /* SPORT1 Status Register */
-#define SPORT1_MTCS0           0xFFC02C12	 /* SPORT1 Multi-Channel */
-						 /* Transmit Select Register */
-#define SPORT1_MTCS1           0xFFC02C14	 /* SPORT1 Multi-Channel */
-						 /* Transmit Select Register */
-#define SPORT1_MTCS2           0xFFC02C16	 /* SPORT1 Multi-Channel */
-						 /* Transmit Select Register */
-#define SPORT1_MTCS3           0xFFC02C18	 /* SPORT1 Multi-Channel */
-						 /* Transmit Select Register */
-#define SPORT1_MTCS4           0xFFC02C1A	 /* SPORT1 Multi-Channel */
-						 /* Transmit Select Register */
-#define SPORT1_MTCS5           0xFFC02C1C	 /* SPORT1 Multi-Channel */
-						 /* Transmit Select Register */
-#define SPORT1_MTCS6           0xFFC02C1E	 /* SPORT1 Multi-Channel */
-						 /* Transmit Select Register */
-#define SPORT1_MTCS7           0xFFC02C20	 /* SPORT1 Multi-Channel */
-						 /* Transmit Select Register */
-#define SPORT1_MRCS0           0xFFC02C22	 /* SPORT1 Multi-Channel Receive */
-						 /* Select Register */
-#define SPORT1_MRCS1           0xFFC02C24	 /* SPORT1 Multi-Channel Receive */
-						 /* Select Register */
-#define SPORT1_MRCS2           0xFFC02C26	 /* SPORT1 Multi-Channel Receive */
-						 /* Select Register */
-#define SPORT1_MRCS3           0xFFC02C28	 /* SPORT1 Multi-Channel Receive */
-						 /* Select Register */
-#define SPORT1_MRCS4           0xFFC02C2A	 /* SPORT1 Multi-Channel Receive */
-						 /* Select Register */
-#define SPORT1_MRCS5           0xFFC02C2C	 /* SPORT1 Multi-Channel Receive */
-						 /* Select Register */
-#define SPORT1_MRCS6           0xFFC02C2E	 /* SPORT1 Multi-Channel Receive */
-						 /* Select Register */
-#define SPORT1_MRCS7           0xFFC02C30	 /* SPORT1 Multi-Channel Receive */
-						 /* Select Register */
-#define SPORT1_MCMC1           0xFFC02C32	 /* SPORT1 Multi-Channel */
-						 /* Configuration Register 1 */
-#define SPORT1_MCMC2           0xFFC02C34	 /* SPORT1 Multi-Channel */
-						 /* Configuration Register 2 */
-#define SPORT1_CURR_PTR_RX     0xFFC02E00	 /* SPORT1 -RCV DMA Current */
-						 /* Pointer */
-#define SPORT1_CONFIG_DMA_RX   0xFFC02E02	 /* SPORT1 -RCV DMA */
-						 /* Configuration */
-#define SPORT1_START_ADDR_HI_RX 0xFFC02E04	 /* SPORT1 -RCV DMA Start Page */
-#define SPORT1_START_ADDR_LO_RX 0xFFC02E06	 /* SPORT1 -RCV DMA Start */
-						 /* Address */
-#define SPORT1_COUNT_RX        0xFFC02E08	 /* SPORT1 -RCV DMA Count */
-#define SPORT1_NEXT_DESCR_RX   0xFFC02E0A	 /* SPORT1 -RCV DMA Next */
-						 /* Descriptor Pointer */
-#define SPORT1_DESCR_RDY_RX    0xFFC02E0C	 /* SPORT1 -RCV DMA Descriptor */
-						 /* Ready */
-#define SPORT1_IRQSTAT_RX      0xFFC02E0E	 /* SPORT1 -RCV DMA Interrupt */
-						 /* Register */
-#define SPORT1_CURR_PTR_TX     0xFFC02F00	 /* SPORT1 -XMT DMA Current */
-						 /* Pointer */
-#define SPORT1_CONFIG_DMA_TX   0xFFC02F02	 /* SPORT1 -XMT DMA */
-						 /* Configuration */
-#define SPORT1_START_ADDR_HI_TX 0xFFC02F04	 /* SPORT1 -XMT DMA Start Page */
-#define SPORT1_START_ADDR_LO_TX 0xFFC02F06	 /* SPORT1 -XMT DMA Start */
-						 /* Address */
-#define SPORT1_COUNT_TX        0xFFC02F08	 /* SPORT1 -XMT DMA Count */
-#define SPORT1_NEXT_DESCR_TX   0xFFC02F0A	 /* SPORT1 -XMT DMA Next */
-						 /* Descriptor Pointer */
-#define SPORT1_DESCR_RDY_TX    0xFFC02F0C	 /* SPORT1 -XMT DMA Descriptor */
-						 /* Ready */
-#define SPORT1_IRQSTAT_TX      0xFFC02F0E	 /* SPORT1 -XMT DMA Interrupt */
-						 /* Register */
-
- /* SPI 0 Controller (0xFFC0 3000-0xFFC0 33FF) */
-#define SPI0_CTL               0xFFC03000	 /* SPI0 Control Register */
-#define SPI0_FLG               0xFFC03002	 /* SPI0 Flag register */
-#define SPI0_ST                0xFFC03004	 /* SPI0 Status register */
-#define SPI0_TDBR              0xFFC03006	 /* SPI0 Transmit Data Buffer */
-						 /* Register */
-#define SPI0_RDBR              0xFFC03008	 /* SPI0 Receive Data Buffer */
-						 /* Register */
-#define SPI0_BAUD              0xFFC0300A	 /* SPI0 Baud rate Register */
-#define SPI0_SHADOW            0xFFC0300C
-#define SPI0_CURR_PTR          0xFFC03200	 /* SPI0 -DMA Current Pointer */
-						 /* register */
-#define SPI0_CONFIG            0xFFC03202	 /* SPI0 -DMA Configuration */
-						 /* register */
-#define SPI0_START_ADDR_HI     0xFFC03204	 /* SPI0 -DMA Start Page */
-						 /* register */
-#define SPI0_START_ADDR_LO     0xFFC03206	 /* SPI0 -DMA Start Address */
-						 /* register */
-#define SPI0_COUNT             0xFFC03208	 /* SPI0 -DMA Count register */
-#define SPI0_NEXT_DESCR        0xFFC0320A	 /* SPI0 -DMA Next Descriptor */
-						 /* Pointer */
-#define SPI0_DESCR_RDY         0xFFC0320C	 /* SPI0 -DMA Descriptor Ready */
-#define SPI0_DMA_INT           0xFFC0320E	 /* SPI0 -DMA Interrupt register */
-
- /* SPI 1 Controller (0xFFC0 3400-0xFFC0 37FF) */
-#define SPI1_CTL               0xFFC03400	 /* SPI1 Control Register */
-#define SPI1_FLG               0xFFC03402	 /* SPI1 Flag register */
-#define SPI1_ST                0xFFC03404	 /* SPI1 Status register */
-#define SPI1_TDBR              0xFFC03406	 /* SPI1 Transmit Data Buffer */
-						 /* Register */
-#define SPI1_RDBR              0xFFC03408	 /* SPI1 Receive Data Buffer */
-						 /* Register */
-#define SPI1_BAUD              0xFFC0340A	 /* SPI1 Baud rate Register */
-#define SPI1_SHADOW            0xFFC0340C
-#define SPI1_CURR_PTR          0xFFC03600	 /* SPI1 -DMA Current Pointer */
-						 /* register */
-#define SPI1_CONFIG            0xFFC03602	 /* SPI1 -DMA Configuration */
-						 /* register */
-#define SPI1_START_ADDR_HI     0xFFC03604	 /* SPI1 -DMA Start Page */
-						 /* register */
-#define SPI1_START_ADDR_LO     0xFFC03606	 /* SPI1 -DMA Start Address */
-						 /* register */
-#define SPI1_COUNT             0xFFC03608	 /* SPI1 -DMA Count register */
-#define SPI1_NEXT_DESCR        0xFFC0360A	 /* SPI1 -DMA Next Descriptor */
-						 /* Pointer */
-#define SPI1_DESCR_RDY         0xFFC0360C	 /* SPI1 -DMA Descriptor Ready */
-#define SPI1_DMA_INT           0xFFC0360E	 /* SPI1 -DMA Interrupt register */
-
- /* Memory DMA Controller (0xFFC0 3800-0xFFC0 3BFF) */
-#define MDD_DCP                0xFFC03800	 /* Current Pointer - Write */
-						 /* Channel */
-#define MDD_DCFG               0xFFC03802	 /* DMA Configuration - Write */
-						 /* Channel */
-#define MDD_DSAH               0xFFC03804	 /* Start Address Hi - Write */
-						 /* Channel */
-#define MDD_DSAL               0xFFC03806	 /* Start Address Lo - Write */
-						 /* Channel */
-#define MDD_DCT                0xFFC03808	 /* DMA Count - Write Channel */
-#define MDD_DND                0xFFC0380A	 /* Next Descriptor Pointer - */
-						 /* Write Channel */
-#define MDD_DDR                0xFFC0380C	 /* Descriptor Ready - Write */
-						 /* Channel */
-#define MDD_DI                 0xFFC0380E	 /* DMA Interrupt - Write */
-						 /* Channel */
-#define MDS_DCP                0xFFC03900	 /* Current Pointer - Read */
-						 /* Channel */
-#define MDS_DCFG               0xFFC03902	 /* DMA Configuration - Read */
-						 /* Channel */
-#define MDS_DSAH               0xFFC03904	 /* Start Address Hi - Read */
-						 /* Channel */
-#define MDS_DSAL               0xFFC03906	 /* Start Address Lo - Read */
-						 /* Channel */
-#define MDS_DCT                0xFFC03908	 /* DMA Count - Read Channel */
-#define MDS_DND                0xFFC0390A	 /* Next Descriptor Pointer - */
-						 /* Read Channel */
-#define MDS_DDR                0xFFC0390C	 /* Descriptor Ready - Read */
-						 /* Channel */
-#define MDS_DI                 0xFFC0390E	 /* DMA Interrupt - Read Channel */
-
- /* For backwards-compatibility with VDSP++3.0 and earlier code... */
-#define MDW_DCP                MDD_DCP
-#define MDW_DCFG               MDD_DCFG
-#define MDW_DSAH               MDD_DSAH
-#define MDW_DSAL               MDD_DSAL
-#define MDW_DCT                MDD_DCT
-#define MDW_DND                MDD_DND
-#define MDW_DDR                MDD_DDR
-#define MDW_DI                 MDD_DI
-#define MDR_DCP                MDS_DCP
-#define MDR_DCFG               MDS_DCFG
-#define MDR_DSAH               MDS_DSAH
-#define MDR_DSAL               MDS_DSAL
-#define MDR_DCT                MDS_DCT
-#define MDR_DND                MDS_DND
-#define MDR_DDR                MDS_DDR
-#define MDR_DI                 MDS_DI
-
- /* Aysnchronous Memory Controller - External Bus Interface Unit (0xFFC0 3C00-0xFFC0 3FFF) */
-#define EBIU_AMGCTL            0xFFC03C00	 /* Asynchronous Memory Global */
-						 /* Control Register */
-#define EBIU_AMBCTL0           0xFFC03C04	 /* Asynchronous Memory Bank */
-						 /* Control Register 0 */
-#define EBIU_AMBCTL1           0xFFC03C08	 /* Asynchronous Memory Bank */
-						 /* Control Register 1 */
-
- /* PCI Bridge PAB Registers (0xFFC0 4000-0xFFC0 43FF) */
-#define PCI_CTL                0xFFC04000	 /* PCI Bridge Control */
-#define  PCI_CTL_HOST	 	 0x01
-#define  PCI_CTL_ENABPCI	 0x02
-#define  PCI_CTL_FASTBCK2BCK	 0x04
-#define  PCI_CTL_ENABINTA	 0x08
-#define  PCI_CTL_OUTPUTINTA	 0x10
-#define  PCI_CTL_ENABRST	 0x20
-#define  PCI_CTL_OUTPUTRST	 0x40
-
-#define PCI_STAT               0xFFC04004	 /* PCI Bridge Status */
-#define   PCI_STAT_INTA	         0x0001
-#define   PCI_STAT_INTB	         0x0002
-#define   PCI_STAT_INTC	         0x0004
-#define   PCI_STAT_INTD	         0x0008
-#define   PCI_STAT_PARERR	 0x0010
-#define   PCI_STAT_FATERR	 0x0020
-#define   PCI_STAT_RESET	 0x0040
-#define   PCI_STAT_TXEMPTY	 0x0080
-#define   PCI_STAT_TXFULL	 0x0100
-#define   PCI_STAT_QUEFULL	 0x0200
-#define   PCI_STAT_MEMWRINV	 0x0400
-#define   PCI_STAT_INRDERR	 0x0800
-#define   PCI_STAT_INWRERR	 0x1000
-#define   PCI_STAT_INVEABACC	 0x2000
-#define   PCI_STAT_SYSERR	 0x4000
-
-#define PCI_ICTL               0xFFC04008	 /* PCI Bridge Interrupt Control */
-#define   PCI_ICTL_INTA	         0x0001
-#define   PCI_ICTL_INTB	         0x0002
-#define   PCI_ICTL_INTC	         0x0004
-#define   PCI_ICTL_INTD	         0x0008
-#define   PCI_ICTL_PARERR	 0x0010
-#define   PCI_ICTL_FATERR	 0x0020
-#define   PCI_ICTL_RESET	 0x0040
-#define   PCI_ICTL_TXFULL	 0x0080
-#define   PCI_ICTL_MEMWRINV	 0x0400
-#define   PCI_ICTL_INRDERR	 0x0800
-#define   PCI_ICTL_INWRERR	 0x1000
-#define   PCI_ICTL_INVEABACC	 0x2000
-#define   PCI_ICTL_SYSERR	 0x4000
-
-#define PCI_MBAP               0xFFC0400C	 /* PCI Memory Space Base */
-						 /* Address Pointer [31:27] */
-#define PCI_IBAP               0xFFC04010	 /* PCI IO Space Base Address */
-						 /* Pointer */
-#define PCI_CBAP               0xFFC04014	 /* PCI Config Space Base */
-						 /* Address Port */
-#define PCI_TMBAP              0xFFC04018	 /* PCI to BF535 Memory Base */
-						 /* Address Pointer */
-#define PCI_TIBAP              0xFFC0401C	 /* PCI to BF535 IO Base Address */
-						 /* Pointer */
-
- /* PCI Bridge External Access Bus Registers (0xEEFF FF00-0xEEFF FFFF) */
-#define PCI_DMBARM             0xEEFFFF00	 /* PCI Device Memory Bar Mask */
-#define PCI_DIBARM             0xEEFFFF04	 /* PCI Device IO Bar Mask */
-#define PCI_CFG_DIC            0xEEFFFF08	 /* PCI Config Device ID */
-#define PCI_CFG_VIC            0xEEFFFF0C	 /* PCI Config Vendor ID */
-#define PCI_CFG_STAT           0xEEFFFF10	 /* PCI Config Status */
-						 /* (Read-only) */
-#define PCI_CFG_CMD            0xEEFFFF14	 /* PCI Config Command */
-#define PCI_CFG_CC             0xEEFFFF18	 /* PCI Config Class Code */
-#define PCI_CFG_RID            0xEEFFFF1C	 /* PCI Config Revision ID */
-#define PCI_CFG_BIST           0xEEFFFF20	 /* PCI Config BIST */
-#define PCI_CFG_HT             0xEEFFFF24	 /* PCI Config Header Type */
-#define PCI_CFG_MLT            0xEEFFFF28	 /* PCI Config Memory Latency */
-						 /* Timer */
-#define PCI_CFG_CLS            0xEEFFFF2C	 /* PCI Config Cache Line Size */
-#define PCI_CFG_MBAR           0xEEFFFF30	 /* PCI Config Memory Base */
-						 /* Address Register */
-#define PCI_CFG_IBAR           0xEEFFFF34	 /* PCI Config IO Base Address */
-						 /* Register */
-#define PCI_CFG_SID            0xEEFFFF38	 /* PCI Config Sub-system ID */
-#define PCI_CFG_SVID           0xEEFFFF3C	 /* PCI Config Sub-system Vendor */
-						 /* ID */
-#define PCI_CFG_MAXL           0xEEFFFF40	 /* PCI Config Maximum Latency */
-						 /* Cycles */
-#define PCI_CFG_MING           0xEEFFFF44	 /* PCI Config Minimum Grant */
-						 /* Cycles */
-#define PCI_CFG_IP             0xEEFFFF48	 /* PCI Config Interrupt Pin */
-#define PCI_CFG_IL             0xEEFFFF4C	 /* PCI Config Interrupt Line */
-#define PCI_HMCTL              0xEEFFFF50	 /* PCI Blocking BAR Host Mode */
-						 /* Control */
-
-#define  PCI_HMCTL_SYSMMRENAB	 0x1
-#define  PCI_HMCTL_L2ENAB	 0x2
-#define  PCI_HMCTL_ASYNCENAB	 0x4
-#define  PCI_HMCTL_ASYNCSIZE	 0x18	/* 00-64MB, 01-128MB, 10-192MB,
-					   11-256MB */
-#define  PCI_HMCTL_SDRAMENAB	 0x20
-#define  PCI_HMCTL_SDRAMSIZE	 0x7C0	/* 0-32MB, 1-64MB, 2-96MB, 128MB, 160MB
-					 */
-
- /* USB Registers (0xFFC0 4400 - 0xFFC0 47FF) */
-#define USBD_ID                0xFFC04400	 /* USB Device ID Register */
-#define USBD_FRM               0xFFC04402	 /* Current USB Frame Number */
-#define USBD_FRMAT             0xFFC04404	 /* Match value for USB frame */
-						 /* number. */
-#define USBD_EPBUF             0xFFC04406	 /* Enables Download of */
-						 /* Configuration Into UDC Core */
-#define USBD_STAT              0xFFC04408	 /* Returns USBD Module Status */
-#define USBD_CTRL              0xFFC0440A	 /* Allows Configuration and */
-						 /* Control of USBD Module. */
-#define USBD_GINTR             0xFFC0440C	 /* Global Interrupt Register */
-#define USBD_GMASK             0xFFC0440E	 /* Global Interrupt Register */
-						 /* Mask */
-#define USBD_DMACFG            0xFFC04440	 /* DMA Master Channel */
-						 /* Configuration Register */
-#define USBD_DMABL             0xFFC04442	 /* DMA Master Channel Base */
-						 /* Address, Low */
-#define USBD_DMABH             0xFFC04444	 /* DMA Master Channel Base */
-						 /* Address, High */
-#define USBD_DMACT             0xFFC04446	 /* DMA Master Channel Count */
-						 /* Register */
-#define USBD_DMAIRQ            0xFFC04448	 /* DMA Master Channel DMA Count */
-						 /* Register */
-#define USBD_INTR0             0xFFC04480	 /* USB Endpoint 0 Interrupt */
-						 /* Register */
-#define USBD_MASK0             0xFFC04482	 /* USB Endpoint 0 Mask Register */
-#define USBD_EPCFG0            0xFFC04484	 /* USB Endpoint 0 Control */
-						 /* Register */
-#define USBD_EPADR0            0xFFC04486	 /* USB Endpoint 0 Address */
-						 /* Offset Register */
-#define USBD_EPLEN0            0xFFC04488	 /* USB Endpoint 0 Buffer Length */
-						 /* Register */
-#define USBD_INTR1             0xFFC0448A	 /* USB Endpoint 1 Interrupt */
-						 /* Register */
-#define USBD_MASK1             0xFFC0448C	 /* USB Endpoint 1 Mask Register */
-#define USBD_EPCFG1            0xFFC0448E	 /* USB Endpoint 1 Control */
-						 /* Register */
-#define USBD_EPADR1            0xFFC04490	 /* USB Endpoint 1 Address */
-						 /* Offset Register */
-#define USBD_EPLEN1            0xFFC04492	 /* USB Endpoint 1 Buffer Length */
-						 /* Register */
-#define USBD_INTR2             0xFFC04494	 /* USB Endpoint 2 Interrupt */
-						 /* Register */
-#define USBD_MASK2             0xFFC04496	 /* USB Endpoint 2 Mask Register */
-#define USBD_EPCFG2            0xFFC04498	 /* USB Endpoint 2 Control */
-						 /* Register */
-#define USBD_EPADR2            0xFFC0449A	 /* USB Endpoint 2 Address */
-						 /* Offset Register */
-#define USBD_EPLEN2            0xFFC0449C	 /* USB Endpoint 2 Buffer Length */
-						 /* Register */
-#define USBD_INTR3             0xFFC0449E	 /* USB Endpoint 3 Interrupt */
-						 /* Register */
-#define USBD_MASK3             0xFFC044A0	 /* USB Endpoint 3 Mask Register */
-#define USBD_EPCFG3            0xFFC044A2	 /* USB Endpoint 3 Control */
-						 /* Register */
-#define USBD_EPADR3            0xFFC044A4	 /* USB Endpoint 3 Address */
-						 /* Offset Register */
-#define USBD_EPLEN3            0xFFC044A6	 /* USB Endpoint 3 Buffer Length */
-						 /* Register */
-#define USBD_INTR4             0xFFC044A8	 /* USB Endpoint 4 Interrupt */
-						 /* Register */
-#define USBD_MASK4             0xFFC044AA	 /* USB Endpoint 4 Mask Register */
-#define USBD_EPCFG4            0xFFC044AC	 /* USB Endpoint 4 Control */
-						 /* Register */
-#define USBD_EPADR4            0xFFC044AE	 /* USB Endpoint 4 Address */
-						 /* Offset Register */
-#define USBD_EPLEN4            0xFFC044B0	 /* USB Endpoint 4 Buffer Length */
-						 /* Register */
-#define USBD_INTR5             0xFFC044B2	 /* USB Endpoint 5 Interrupt */
-						 /* Register */
-#define USBD_MASK5             0xFFC044B4	 /* USB Endpoint 5 Mask Register */
-#define USBD_EPCFG5            0xFFC044B6	 /* USB Endpoint 5 Control */
-						 /* Register */
-#define USBD_EPADR5            0xFFC044B8	 /* USB Endpoint 5 Address */
-						 /* Offset Register */
-#define USBD_EPLEN5            0xFFC044BA	 /* USB Endpoint 5 Buffer Length */
-						 /* Register */
-#define USBD_INTR6             0xFFC044BC	 /* USB Endpoint 6 Interrupt */
-						 /* Register */
-#define USBD_MASK6             0xFFC044BE	 /* USB Endpoint 6 Mask Register */
-#define USBD_EPCFG6            0xFFC044C0	 /* USB Endpoint 6 Control */
-						 /* Register */
-#define USBD_EPADR6            0xFFC044C2	 /* USB Endpoint 6 Address */
-						 /* Offset Register */
-#define USBD_EPLEN6            0xFFC044C4	 /* USB Endpoint 6 Buffer Length */
-						 /* Register */
-#define USBD_INTR7             0xFFC044C6	 /* USB Endpoint 7 Interrupt */
-						 /* Register */
-#define USBD_MASK7             0xFFC044C8	 /* USB Endpoint 7 Mask Register */
-#define USBD_EPCFG7            0xFFC044CA	 /* USB Endpoint 7 Control */
-						 /* Register */
-#define USBD_EPADR7            0xFFC044CC	 /* USB Endpoint 7 Address */
-						 /* Offset Register */
-#define USBD_EPLEN7            0xFFC044CE	 /* USB Endpoint 7 Buffer Length */
-						 /* Register */
-
- /* System Bus Interface Unit (0xFFC0 4800-0xFFC0 4FFF) */
-#define L1SBAR                 0xFFC04840	 /* L1 SRAM Base Address */
-						 /* Register */
-#define L1CSR                  0xFFC04844	 /* L1 SRAM Control */
-						 /* Initialization Register */
-#define DMA_DBP                0xFFC04880	 /* Next Descriptor Base Pointer */
-#define DB_ACOMP               0xFFC04884	 /* DMA Bus Address Comparator */
-#define DB_CCOMP               0xFFC04888	 /* DMA Bus Control Comparator */
-
-#define DB_NDBP                DMA_DBP	 /* Backward compatibility */
-
-#define L1_SBAR			L1SBAR
-#define L1_CSR			L1CSR
-
- /* SDRAM Controller External Bus Interface Unit (0xFFC0 4C00-0xFFC0 4FFF) */
-#define EBIU_SDGCTL            0xFFC04C00	 /* SDRAM Global Control */
-						 /* Register */
-#define EBIU_SDBCTL            0xFFC04C04	 /* SDRAM Bank Control Register */
-#define EBIU_SDRRC             0xFFC04C0A	 /* SDRAM Refresh Rate Control */
-						 /* Register */
-#define EBIU_SDSTAT            0xFFC04C0E	 /* SDRAM Status Register */
-
- /* PAB Reserved (0xFFC0 5000-0xFFDF FFFF) (**Reserved**) */
-
- /*********************************************************************************** */
- /* System MMR Register Bits */
- /*********************************************************************************** */
-
- /* PLLCTL Masks */
-#define PLL_CLKIN              0x00000000	 /* Pass CLKIN to PLL */
-#define PLL_CLKIN_DIV2         0x00000001	 /* Pass CLKIN/2 to PLL */
-#define PLL_OFF                0x00000002	 /* Shut off PLL clocks */
-#define STOPCK_OFF             0x00000008	 /* Core clock off */
-#define PDWN                   0x00000020	 /* Put the PLL in a Deep Sleep */
-						 /* state */
-#define BYPASS                 0x00000100	 /* Bypass the PLL */
-#define CCLK_DIV2              0x00000000	 /* SCLK = CCLK / 2 */
-#define CCLK_DIV2_5            0x00010000	 /* SCLK = CCLK / 2.5 */
-#define CCLK_DIV3              0x00020000	 /* SCLK = CCLK / 3 */
-#define CCLK_DIV4              0x00030000	 /* SCLK = CCLK / 4 */
-
- /* IOCKR Masks */
-#define IOCK_PCI               0x00000001	 /* Enable PCI peripheral clock */
-#define IOCK_L2                0x00000002	 /* Enable L2 memory peripheral */
-						 /* clock */
-#define IOCK_EBIU              0x00000004	 /* Enable EBIU controller */
-						 /* peripheral clock */
-#define IOCK_GPIO              0x00000008	 /* Enable GPIO peripheral clock */
-#define IOCK_MEMDMA            0x00000010	 /* Enable MemDMA controller */
-						 /* peripheral clock */
-#define IOCK_SPORT0            0x00000020	 /* Enable SPORT0 controller */
-						 /* peripheral clock */
-#define IOCK_SPORT1            0x00000040	 /* Enable SPORT1 controller */
-						 /* peripheral clock */
-#define IOCK_SPI0              0x00000080	 /* Enable SPI0 controller */
-						 /* peripheral clock */
-#define IOCK_SPI1              0x00000100	 /* Enable SPI1 controller */
-						 /* peripheral clock */
-#define IOCK_UART0             0x00000200	 /* Enable UART0 controller */
-						 /* peripheral clock */
-#define IOCK_UART1             0x00000400	 /* Enable UART1 controller */
-						 /* peripheral clock */
-#define IOCK_TIMER0            0x00000800	 /* Enable TIMER0 peripheral */
-						 /* clock */
-#define IOCK_TIMER1            0x00001000	 /* Enable TIMER1 peripheral */
-						 /* clock */
-#define IOCK_TIMER2            0x00002000	 /* Enable TIMER2 peripheral */
-						 /* clock */
-#define IOCK_USB               0x00004000	 /* Enable USB peripheral clock */
-
- /* SWRST Mask */
-#define SYSTEM_RESET           0x00000007	 /* Initiates a system software */
-						 /* reset */
-
- /* System Interrupt Controller Masks (SIC_IAR0, SIC_IAR1, SIC_IAR2, SIC_IMASK, SIC_IWR) */
- /* SIC_IAR0 Masks */
-
- /* */
-#define P0_IVG7                0x00000000	 /* Peripheral #0 assigned IVG7 */
-#define P0_IVG8                0x00000001	 /* Peripheral #0 assigned IVG8 */
-#define P0_IVG9                0x00000002	 /* Peripheral #0 assigned IVG9 */
-#define P0_IVG10               0x00000003	 /* Peripheral #0 assigned IVG10 */
-#define P0_IVG11               0x00000004	 /* Peripheral #0 assigned IVG11 */
-#define P0_IVG12               0x00000005	 /* Peripheral #0 assigned IVG12 */
-#define P0_IVG13               0x00000006	 /* Peripheral #0 assigned IVG13 */
-#define P0_IVG14               0x00000007	 /* Peripheral #0 assigned IVG14 */
-#define P0_IVG15               0x00000008	 /* Peripheral #0 assigned IVG15 */
-#define P1_IVG7                0x00000000	 /* Peripheral #1 assigned IVG7 */
-#define P1_IVG8                0x00000010	 /* Peripheral #1 assigned IVG8 */
-#define P1_IVG9                0x00000020	 /* Peripheral #1 assigned IVG9 */
-#define P1_IVG10               0x00000030	 /* Peripheral #1 assigned IVG10 */
-#define P1_IVG11               0x00000040	 /* Peripheral #1 assigned IVG11 */
-#define P1_IVG12               0x00000050	 /* Peripheral #1 assigned IVG12 */
-#define P1_IVG13               0x00000060	 /* Peripheral #1 assigned IVG13 */
-#define P1_IVG14               0x00000070	 /* Peripheral #1 assigned IVG14 */
-#define P1_IVG15               0x00000080	 /* Peripheral #1 assigned IVG15 */
-#define P2_IVG7                0x00000000	 /* Peripheral #2 assigned IVG7 */
-#define P2_IVG8                0x00000100	 /* Peripheral #2 assigned IVG8 */
-#define P2_IVG9                0x00000200	 /* Peripheral #2 assigned IVG9 */
-#define P2_IVG10               0x00000300	 /* Peripheral #2 assigned IVG10 */
-#define P2_IVG11               0x00000400	 /* Peripheral #2 assigned IVG11 */
-#define P2_IVG12               0x00000500	 /* Peripheral #2 assigned IVG12 */
-#define P2_IVG13               0x00000600	 /* Peripheral #2 assigned IVG13 */
-#define P2_IVG14               0x00000700	 /* Peripheral #2 assigned IVG14 */
-#define P2_IVG15               0x00000800	 /* Peripheral #2 assigned IVG15 */
-#define P3_IVG7                0x00000000	 /* Peripheral #3 assigned IVG7 */
-#define P3_IVG8                0x00001000	 /* Peripheral #3 assigned IVG8 */
-#define P3_IVG9                0x00002000	 /* Peripheral #3 assigned IVG9 */
-#define P3_IVG10               0x00003000	 /* Peripheral #3 assigned IVG10 */
-#define P3_IVG11               0x00004000	 /* Peripheral #3 assigned IVG11 */
-#define P3_IVG12               0x00005000	 /* Peripheral #3 assigned IVG12 */
-#define P3_IVG13               0x00006000	 /* Peripheral #3 assigned IVG13 */
-#define P3_IVG14               0x00007000	 /* Peripheral #3 assigned IVG14 */
-#define P3_IVG15               0x00008000	 /* Peripheral #3 assigned IVG15 */
-#define P4_IVG7                0x00000000	 /* Peripheral #4 assigned IVG7 */
-#define P4_IVG8                0x00010000	 /* Peripheral #4 assigned IVG8 */
-#define P4_IVG9                0x00020000	 /* Peripheral #4 assigned IVG9 */
-#define P4_IVG10               0x00030000	 /* Peripheral #4 assigned IVG10 */
-#define P4_IVG11               0x00040000	 /* Peripheral #4 assigned IVG11 */
-#define P4_IVG12               0x00050000	 /* Peripheral #4 assigned IVG12 */
-#define P4_IVG13               0x00060000	 /* Peripheral #4 assigned IVG13 */
-#define P4_IVG14               0x00070000	 /* Peripheral #4 assigned IVG14 */
-#define P4_IVG15               0x00080000	 /* Peripheral #4 assigned IVG15 */
-#define P5_IVG7                0x00000000	 /* Peripheral #5 assigned IVG7 */
-#define P5_IVG8                0x00100000	 /* Peripheral #5 assigned IVG8 */
-#define P5_IVG9                0x00200000	 /* Peripheral #5 assigned IVG9 */
-#define P5_IVG10               0x00300000	 /* Peripheral #5 assigned IVG10 */
-#define P5_IVG11               0x00400000	 /* Peripheral #5 assigned IVG11 */
-#define P5_IVG12               0x00500000	 /* Peripheral #5 assigned IVG12 */
-#define P5_IVG13               0x00600000	 /* Peripheral #5 assigned IVG13 */
-#define P5_IVG14               0x00700000	 /* Peripheral #5 assigned IVG14 */
-#define P5_IVG15               0x00800000	 /* Peripheral #5 assigned IVG15 */
-#define P6_IVG7                0x00000000	 /* Peripheral #6 assigned IVG7 */
-#define P6_IVG8                0x01000000	 /* Peripheral #6 assigned IVG8 */
-#define P6_IVG9                0x02000000	 /* Peripheral #6 assigned IVG9 */
-#define P6_IVG10               0x03000000	 /* Peripheral #6 assigned IVG10 */
-#define P6_IVG11               0x04000000	 /* Peripheral #6 assigned IVG11 */
-#define P6_IVG12               0x05000000	 /* Peripheral #6 assigned IVG12 */
-#define P6_IVG13               0x06000000	 /* Peripheral #6 assigned IVG13 */
-#define P6_IVG14               0x07000000	 /* Peripheral #6 assigned IVG14 */
-#define P6_IVG15               0x08000000	 /* Peripheral #6 assigned IVG15 */
-#define P7_IVG7                0x00000000	 /* Peripheral #7 assigned IVG7 */
-#define P7_IVG8                0x10000000	 /* Peripheral #7 assigned IVG8 */
-#define P7_IVG9                0x20000000	 /* Peripheral #7 assigned IVG9 */
-#define P7_IVG10               0x30000000	 /* Peripheral #7 assigned IVG10 */
-#define P7_IVG11               0x40000000	 /* Peripheral #7 assigned IVG11 */
-#define P7_IVG12               0x50000000	 /* Peripheral #7 assigned IVG12 */
-#define P7_IVG13               0x60000000	 /* Peripheral #7 assigned IVG13 */
-#define P7_IVG14               0x70000000	 /* Peripheral #7 assigned IVG14 */
-#define P7_IVG15               0x80000000	 /* Peripheral #7 assigned IVG15 */
-
- /* SIC_IAR1 Masks */
-#define P8_IVG7                0x00000000	 /* Peripheral #8 assigned IVG7 */
-#define P8_IVG8                0x00000001	 /* Peripheral #8 assigned IVG8 */
-#define P8_IVG9                0x00000002	 /* Peripheral #8 assigned IVG9 */
-#define P8_IVG10               0x00000003	 /* Peripheral #8 assigned IVG10 */
-#define P8_IVG11               0x00000004	 /* Peripheral #8 assigned IVG11 */
-#define P8_IVG12               0x00000005	 /* Peripheral #8 assigned IVG12 */
-#define P8_IVG13               0x00000006	 /* Peripheral #8 assigned IVG13 */
-#define P8_IVG14               0x00000007	 /* Peripheral #8 assigned IVG14 */
-#define P8_IVG15               0x00000008	 /* Peripheral #8 assigned IVG15 */
-#define P9_IVG7                0x00000000	 /* Peripheral #9 assigned IVG7 */
-#define P9_IVG8                0x00000010	 /* Peripheral #9 assigned IVG8 */
-#define P9_IVG9                0x00000020	 /* Peripheral #9 assigned IVG9 */
-#define P9_IVG10               0x00000030	 /* Peripheral #9 assigned IVG10 */
-#define P9_IVG11               0x00000040	 /* Peripheral #9 assigned IVG11 */
-#define P9_IVG12               0x00000050	 /* Peripheral #9 assigned IVG12 */
-#define P9_IVG13               0x00000060	 /* Peripheral #9 assigned IVG13 */
-#define P9_IVG14               0x00000070	 /* Peripheral #9 assigned IVG14 */
-#define P9_IVG15               0x00000080	 /* Peripheral #9 assigned IVG15 */
-#define P10_IVG7               0x00000000	 /* Peripheral #10 assigned IVG7 */
-#define P10_IVG8               0x00000100	 /* Peripheral #10 assigned IVG8 */
-#define P10_IVG9               0x00000200	 /* Peripheral #10 assigned IVG9 */
-#define P10_IVG10              0x00000300	 /* Peripheral #10 assigned */
-						 /* IVG10 */
-#define P10_IVG11              0x00000400	 /* Peripheral #10 assigned */
-						 /* IVG11 */
-#define P10_IVG12              0x00000500	 /* Peripheral #10 assigned */
-						 /* IVG12 */
-#define P10_IVG13              0x00000600	 /* Peripheral #10 assigned */
-						 /* IVG13 */
-#define P10_IVG14              0x00000700	 /* Peripheral #10 assigned */
-						 /* IVG14 */
-#define P10_IVG15              0x00000800	 /* Peripheral #10 assigned */
-						 /* IVG15 */
-#define P11_IVG7               0x00000000	 /* Peripheral #11 assigned IVG7 */
-#define P11_IVG8               0x00001000	 /* Peripheral #11 assigned IVG8 */
-#define P11_IVG9               0x00002000	 /* Peripheral #11 assigned IVG9 */
-#define P11_IVG10              0x00003000	 /* Peripheral #11 assigned */
-						 /* IVG10 */
-#define P11_IVG11              0x00004000	 /* Peripheral #11 assigned */
-						 /* IVG11 */
-#define P11_IVG12              0x00005000	 /* Peripheral #11 assigned */
-						 /* IVG12 */
-#define P11_IVG13              0x00006000	 /* Peripheral #11 assigned */
-						 /* IVG13 */
-#define P11_IVG14              0x00007000	 /* Peripheral #11 assigned */
-						 /* IVG14 */
-#define P11_IVG15              0x00008000	 /* Peripheral #11 assigned */
-						 /* IVG15 */
-#define P12_IVG7               0x00000000	 /* Peripheral #12 assigned IVG7 */
-#define P12_IVG8               0x00010000	 /* Peripheral #12 assigned IVG8 */
-#define P12_IVG9               0x00020000	 /* Peripheral #12 assigned IVG9 */
-#define P12_IVG10              0x00030000	 /* Peripheral #12 assigned */
-						 /* IVG10 */
-#define P12_IVG11              0x00040000	 /* Peripheral #12 assigned */
-						 /* IVG11 */
-#define P12_IVG12              0x00050000	 /* Peripheral #12 assigned */
-						 /* IVG12 */
-#define P12_IVG13              0x00060000	 /* Peripheral #12 assigned */
-						 /* IVG13 */
-#define P12_IVG14              0x00070000	 /* Peripheral #12 assigned */
-						 /* IVG14 */
-#define P12_IVG15              0x00080000	 /* Peripheral #12 assigned */
-						 /* IVG15 */
-#define P13_IVG7               0x00000000	 /* Peripheral #13 assigned IVG7 */
-#define P13_IVG8               0x00100000	 /* Peripheral #13 assigned IVG8 */
-#define P13_IVG9               0x00200000	 /* Peripheral #13 assigned IVG9 */
-#define P13_IVG10              0x00300000	 /* Peripheral #13 assigned */
-						 /* IVG10 */
-#define P13_IVG11              0x00400000	 /* Peripheral #13 assigned */
-						 /* IVG11 */
-#define P13_IVG12              0x00500000	 /* Peripheral #13 assigned */
-						 /* IVG12 */
-#define P13_IVG13              0x00600000	 /* Peripheral #13 assigned */
-						 /* IVG13 */
-#define P13_IVG14              0x00700000	 /* Peripheral #14 assigned */
-						 /* IVG14 */
-#define P13_IVG15              0x00800000	 /* Peripheral #14 assigned */
-						 /* IVG15 */
-#define P14_IVG7               0x00000000	 /* Peripheral #14 assigned IVG7 */
-#define P14_IVG8               0x01000000	 /* Peripheral #14 assigned IVG8 */
-#define P14_IVG9               0x02000000	 /* Peripheral #14 assigned IVG9 */
-#define P14_IVG10              0x03000000	 /* Peripheral #14 assigned */
-						 /* IVG10 */
-#define P14_IVG11              0x04000000	 /* Peripheral #14 assigned */
-						 /* IVG11 */
-#define P14_IVG12              0x05000000	 /* Peripheral #14 assigned */
-						 /* IVG12 */
-#define P14_IVG13              0x06000000	 /* Peripheral #14 assigned */
-						 /* IVG13 */
-#define P14_IVG14              0x07000000	 /* Peripheral #14 assigned */
-						 /* IVG14 */
-#define P14_IVG15              0x08000000	 /* Peripheral #14 assigned */
-						 /* IVG15 */
-#define P15_IVG7               0x00000000	 /* Peripheral #15 assigned IVG7 */
-#define P15_IVG8               0x10000000	 /* Peripheral #15 assigned IVG8 */
-#define P15_IVG9               0x20000000	 /* Peripheral #15 assigned IVG9 */
-#define P15_IVG10              0x30000000	 /* Peripheral #15 assigned */
-						 /* IVG10 */
-#define P15_IVG11              0x40000000	 /* Peripheral #15 assigned */
-						 /* IVG11 */
-#define P15_IVG12              0x50000000	 /* Peripheral #15 assigned */
-						 /* IVG12 */
-#define P15_IVG13              0x60000000	 /* Peripheral #15 assigned */
-						 /* IVG13 */
-#define P15_IVG14              0x70000000	 /* Peripheral #15 assigned */
-						 /* IVG14 */
-#define P15_IVG15              0x80000000	 /* Peripheral #15 assigned */
-						 /* IVG15 */
-
- /* SIC_IAR2 Masks */
-#define P16_IVG7               0x00000000	 /* Peripheral #16 assigned IVG7 */
-#define P16_IVG8               0x00000001	 /* Peripheral #16 assigned IVG8 */
-#define P16_IVG9               0x00000002	 /* Peripheral #16 assigned IVG9 */
-#define P16_IVG10              0x00000003	 /* Peripheral #16 assigned */
-						 /* IVG10 */
-#define P16_IVG11              0x00000004	 /* Peripheral #16 assigned */
-						 /* IVG11 */
-#define P16_IVG12              0x00000005	 /* Peripheral #16 assigned */
-						 /* IVG12 */
-#define P16_IVG13              0x00000006	 /* Peripheral #16 assigned */
-						 /* IVG13 */
-#define P16_IVG14              0x00000007	 /* Peripheral #16 assigned */
-						 /* IVG14 */
-#define P16_IVG15              0x00000008	 /* Peripheral #16 assigned */
-						 /* IVG15 */
-#define P17_IVG7               0x00000000	 /* Peripheral #17 assigned IVG7 */
-#define P17_IVG8               0x00000010	 /* Peripheral #17 assigned IVG8 */
-#define P17_IVG9               0x00000020	 /* Peripheral #17 assigned IVG9 */
-#define P17_IVG10              0x00000030	 /* Peripheral #17 assigned */
-						 /* IVG10 */
-#define P17_IVG11              0x00000040	 /* Peripheral #17 assigned */
-						 /* IVG11 */
-#define P17_IVG12              0x00000050	 /* Peripheral #17 assigned */
-						 /* IVG12 */
-#define P17_IVG13              0x00000060	 /* Peripheral #17 assigned */
-						 /* IVG13 */
-#define P17_IVG14              0x00000070	 /* Peripheral #17 assigned */
-						 /* IVG14 */
-#define P17_IVG15              0x00000080	 /* Peripheral #17 assigned */
-						 /* IVG15 */
-#define P18_IVG7               0x00000000	 /* Peripheral #18 assigned IVG7 */
-#define P18_IVG8               0x00000100	 /* Peripheral #18 assigned IVG8 */
-#define P18_IVG9               0x00000200	 /* Peripheral #18 assigned IVG9 */
-#define P18_IVG10              0x00000300	 /* Peripheral #18 assigned */
-						 /* IVG10 */
-#define P18_IVG11              0x00000400	 /* Peripheral #18 assigned */
-						 /* IVG11 */
-#define P18_IVG12              0x00000500	 /* Peripheral #18 assigned */
-						 /* IVG12 */
-#define P18_IVG13              0x00000600	 /* Peripheral #18 assigned */
-						 /* IVG13 */
-#define P18_IVG14              0x00000700	 /* Peripheral #18 assigned */
-						 /* IVG14 */
-#define P18_IVG15              0x00000800	 /* Peripheral #18 assigned */
-						 /* IVG15 */
-#define P19_IVG7               0x00000000	 /* Peripheral #19 assigned IVG7 */
-#define P19_IVG8               0x00001000	 /* Peripheral #19 assigned IVG8 */
-#define P19_IVG9               0x00002000	 /* Peripheral #19 assigned IVG9 */
-#define P19_IVG10              0x00003000	 /* Peripheral #19 assigned */
-						 /* IVG10 */
-#define P19_IVG11              0x00004000	 /* Peripheral #19 assigned */
-						 /* IVG11 */
-#define P19_IVG12              0x00005000	 /* Peripheral #19 assigned */
-						 /* IVG12 */
-#define P19_IVG13              0x00006000	 /* Peripheral #19 assigned */
-						 /* IVG13 */
-#define P19_IVG14              0x00007000	 /* Peripheral #19 assigned */
-						 /* IVG14 */
-#define P19_IVG15              0x00008000	 /* Peripheral #19 assigned */
-						 /* IVG15 */
-#define P20_IVG7               0x00000000	 /* Peripheral #20 assigned IVG7 */
-#define P20_IVG8               0x00010000	 /* Peripheral #20 assigned IVG8 */
-#define P20_IVG9               0x00020000	 /* Peripheral #20 assigned IVG9 */
-#define P20_IVG10              0x00030000	 /* Peripheral #20 assigned */
-						 /* IVG10 */
-#define P20_IVG11              0x00040000	 /* Peripheral #20 assigned */
-						 /* IVG11 */
-#define P20_IVG12              0x00050000	 /* Peripheral #20 assigned */
-						 /* IVG12 */
-#define P20_IVG13              0x00060000	 /* Peripheral #20 assigned */
-						 /* IVG13 */
-#define P20_IVG14              0x00070000	 /* Peripheral #20 assigned */
-						 /* IVG14 */
-#define P20_IVG15              0x00080000	 /* Peripheral #20 assigned */
-						 /* IVG15 */
- /* */
- /* SIC_IMASK Masks */
-#define SIC_UNMASK_ALL         0x00000000	 /* Unmask all peripheral */
-						 /* interrupts */
-#define SIC_MASK_ALL           0xFFFFFFFF	 /* Mask all peripheral */
-						 /* interrupts */
-#define SIC_MASK0              0x00000001	 /* Mask Peripheral #0 interrupt */
-#define SIC_MASK1              0x00000002	 /* Mask Peripheral #1 interrupt */
-#define SIC_MASK2              0x00000004	 /* Mask Peripheral #2 interrupt */
-#define SIC_MASK3              0x00000008	 /* Mask Peripheral #3 interrupt */
-#define SIC_MASK4              0x00000010	 /* Mask Peripheral #4 interrupt */
-#define SIC_MASK5              0x00000020	 /* Mask Peripheral #5 interrupt */
-#define SIC_MASK6              0x00000040	 /* Mask Peripheral #6 interrupt */
-#define SIC_MASK7              0x00000080	 /* Mask Peripheral #7 interrupt */
-#define SIC_MASK8              0x00000100	 /* Mask Peripheral #8 interrupt */
-#define SIC_MASK9              0x00000200	 /* Mask Peripheral #9 interrupt */
-#define SIC_MASK10             0x00000400	 /* Mask Peripheral #10 */
-						 /* interrupt */
-#define SIC_MASK11             0x00000800	 /* Mask Peripheral #11 */
-						 /* interrupt */
-#define SIC_MASK12             0x00001000	 /* Mask Peripheral #12 */
-						 /* interrupt */
-#define SIC_MASK13             0x00002000	 /* Mask Peripheral #13 */
-						 /* interrupt */
-#define SIC_MASK14             0x00004000	 /* Mask Peripheral #14 */
-						 /* interrupt */
-#define SIC_MASK15             0x00008000	 /* Mask Peripheral #15 */
-						 /* interrupt */
-#define SIC_MASK16             0x00010000	 /* Mask Peripheral #16 */
-						 /* interrupt */
-#define SIC_MASK17             0x00020000	 /* Mask Peripheral #17 */
-						 /* interrupt */
-#define SIC_MASK18             0x00040000	 /* Mask Peripheral #18 */
-						 /* interrupt */
-#define SIC_MASK19             0x00080000	 /* Mask Peripheral #19 */
-						 /* interrupt */
-#define SIC_MASK20             0x00100000	 /* Mask Peripheral #20 */
-						 /* interrupt */
-#define SIC_MASK_DFR           0x80000000	 /* Mask Core Double Fault Reset */
-#define SIC_UNMASK0            0xFFFFFFFE	 /* Unmask Peripheral #0 */
-						 /* interrupt */
-#define SIC_UNMASK1            0xFFFFFFFD	 /* Unmask Peripheral #1 */
-						 /* interrupt */
-#define SIC_UNMASK2            0xFFFFFFFB	 /* Unmask Peripheral #2 */
-						 /* interrupt */
-#define SIC_UNMASK3            0xFFFFFFF7	 /* Unmask Peripheral #3 */
-						 /* interrupt */
-#define SIC_UNMASK4            0xFFFFFFEF	 /* Unmask Peripheral #4 */
-						 /* interrupt */
-#define SIC_UNMASK5            0xFFFFFFDF	 /* Unmask Peripheral #5 */
-						 /* interrupt */
-#define SIC_UNMASK6            0xFFFFFFBF	 /* Unmask Peripheral #6 */
-						 /* interrupt */
-#define SIC_UNMASK7            0xFFFFFF7F	 /* Unmask Peripheral #7 */
-						 /* interrupt */
-#define SIC_UNMASK8            0xFFFFFEFF	 /* Unmask Peripheral #8 */
-						 /* interrupt */
-#define SIC_UNMASK9            0xFFFFFDFF	 /* Unmask Peripheral #9 */
-						 /* interrupt */
-#define SIC_UNMASK10           0xFFFFFBFF	 /* Unmask Peripheral #10 */
-						 /* interrupt */
-#define SIC_UNMASK11           0xFFFFF7FF	 /* Unmask Peripheral #11 */
-						 /* interrupt */
-#define SIC_UNMASK12           0xFFFFEFFF	 /* Unmask Peripheral #12 */
-						 /* interrupt */
-#define SIC_UNMASK13           0xFFFFDFFF	 /* Unmask Peripheral #13 */
-						 /* interrupt */
-#define SIC_UNMASK14           0xFFFFBFFF	 /* Unmask Peripheral #14 */
-						 /* interrupt */
-#define SIC_UNMASK15           0xFFFF7FFF	 /* Unmask Peripheral #15 */
-						 /* interrupt */
-#define SIC_UNMASK16           0xFFFEFFFF	 /* Unmask Peripheral #16 */
-						 /* interrupt */
-#define SIC_UNMASK17           0xFFFDFFFF	 /* Unmask Peripheral #17 */
-						 /* interrupt */
-#define SIC_UNMASK18           0xFFFBFFFF	 /* Unmask Peripheral #18 */
-						 /* interrupt */
-#define SIC_UNMASK19           0xFFF7FFFF	 /* Unmask Peripheral #19 */
-						 /* interrupt */
-#define SIC_UNMASK20           0xFFEFFFFF	 /* Unmask Peripheral #20 */
-						 /* interrupt */
-#define SIC_UNMASK_DFR         0x7FFFFFFF	 /* Unmask Core Double Fault */
-						 /* Reset */
-
- /* SIC_IWR Masks */
-#define IWR_DISABLE_ALL        0x00000000	 /* Wakeup Disable all */
-						 /* peripherals */
-#define IWR_ENABLE_ALL         0xFFFFFFFF	 /* Wakeup Enable all */
-						 /* peripherals */
-#define IWR_ENABLE0            0x00000001	 /* Wakeup Enable Peripheral #0 */
-#define IWR_ENABLE1            0x00000002	 /* Wakeup Enable Peripheral #1 */
-#define IWR_ENABLE2            0x00000004	 /* Wakeup Enable Peripheral #2 */
-#define IWR_ENABLE3            0x00000008	 /* Wakeup Enable Peripheral #3 */
-#define IWR_ENABLE4            0x00000010	 /* Wakeup Enable Peripheral #4 */
-#define IWR_ENABLE5            0x00000020	 /* Wakeup Enable Peripheral #5 */
-#define IWR_ENABLE6            0x00000040	 /* Wakeup Enable Peripheral #6 */
-#define IWR_ENABLE7            0x00000080	 /* Wakeup Enable Peripheral #7 */
-#define IWR_ENABLE8            0x00000100	 /* Wakeup Enable Peripheral #8 */
-#define IWR_ENABLE9            0x00000200	 /* Wakeup Enable Peripheral #9 */
-#define IWR_ENABLE10           0x00000400	 /* Wakeup Enable Peripheral #10 */
-#define IWR_ENABLE11           0x00000800	 /* Wakeup Enable Peripheral #11 */
-#define IWR_ENABLE12           0x00001000	 /* Wakeup Enable Peripheral #12 */
-#define IWR_ENABLE13           0x00002000	 /* Wakeup Enable Peripheral #13 */
-#define IWR_ENABLE14           0x00004000	 /* Wakeup Enable Peripheral #14 */
-#define IWR_ENABLE15           0x00008000	 /* Wakeup Enable Peripheral #15 */
-#define IWR_ENABLE16           0x00010000	 /* Wakeup Enable Peripheral #16 */
-#define IWR_ENABLE17           0x00020000	 /* Wakeup Enable Peripheral #17 */
-#define IWR_ENABLE18           0x00040000	 /* Wakeup Enable Peripheral #18 */
-#define IWR_ENABLE19           0x00080000	 /* Wakeup Enable Peripheral #19 */
-#define IWR_ENABLE20           0x00100000	 /* Wakeup Enable Peripheral #20 */
-#define IWR_DISABLE0           0xFFFFFFFE	 /* Wakeup Disable Peripheral #0 */
-#define IWR_DISABLE1           0xFFFFFFFD	 /* Wakeup Disable Peripheral #1 */
-#define IWR_DISABLE2           0xFFFFFFFB	 /* Wakeup Disable Peripheral #2 */
-#define IWR_DISABLE3           0xFFFFFFF7	 /* Wakeup Disable Peripheral #3 */
-#define IWR_DISABLE4           0xFFFFFFEF	 /* Wakeup Disable Peripheral #4 */
-#define IWR_DISABLE5           0xFFFFFFDF	 /* Wakeup Disable Peripheral #5 */
-#define IWR_DISABLE6           0xFFFFFFBF	 /* Wakeup Disable Peripheral #6 */
-#define IWR_DISABLE7           0xFFFFFF7F	 /* Wakeup Disable Peripheral #7 */
-#define IWR_DISABLE8           0xFFFFFEFF	 /* Wakeup Disable Peripheral #8 */
-#define IWR_DISABLE9           0xFFFFFDFF	 /* Wakeup Disable Peripheral #9 */
-#define IWR_DISABLE10          0xFFFFFBFF	 /* Wakeup Disable Peripheral */
-						 /* #10 */
-#define IWR_DISABLE11          0xFFFFF7FF	 /* Wakeup Disable Peripheral */
-						 /* #11 */
-#define IWR_DISABLE12          0xFFFFEFFF	 /* Wakeup Disable Peripheral */
-						 /* #12 */
-#define IWR_DISABLE13          0xFFFFDFFF	 /* Wakeup Disable Peripheral */
-						 /* #13 */
-#define IWR_DISABLE14          0xFFFFBFFF	 /* Wakeup Disable Peripheral */
-						 /* #14 */
-#define IWR_DISABLE15          0xFFFF7FFF	 /* Wakeup Disable Peripheral */
-						 /* #15 */
-#define IWR_DISABLE16          0xFFFEFFFF	 /* Wakeup Disable Peripheral */
-						 /* #16 */
-#define IWR_DISABLE17          0xFFFDFFFF	 /* Wakeup Disable Peripheral */
-						 /* #17 */
-#define IWR_DISABLE18          0xFFFBFFFF	 /* Wakeup Disable Peripheral */
-						 /* #18 */
-#define IWR_DISABLE19          0xFFF7FFFF	 /* Wakeup Disable Peripheral */
-						 /* #19 */
-#define IWR_DISABLE20          0xFFEFFFFF	 /* Wakeup Disable Peripheral */
-						 /* #20 */
-
- /* WDOGCTL Masks */
-#define ENABLE_RESET           0x00000000	 /* Set Watchdog Timer to */
-						 /* generate reset */
-#define ENABLE_NMI             0x00000002	 /* Set Watchdog Timer to */
-						 /* generate non-maskable */
-						 /* interrupt */
-#define ENABLE_GPI             0x00000004	 /* Set Watchdog Timer to */
-						 /* generate general-purpose */
-						 /* interrupt */
-#define DISABLE_EVT            0x00000006	 /* Disable Watchdog Timer */
-						 /* interrupts */
-
- /* SPICTLx Masks */
-#define TIMOD                  0x00000003	 /* Transfer initiation mode and */
-						 /* interrupt generation */
-#define SZ                     0x00000004	 /* Send Zero (=0) or last (=1) */
-						 /* word when TDBR empty. */
-#define GM                     0x00000008	 /* When RDBR full, get more */
-						 /* (=1) data or discard (=0) */
-						 /* incoming Data */
-#define PSSE                   0x00000010	 /* Enable (=1) Slave-Select */
-						 /* input for Master. */
-#define EMISO                  0x00000020	 /* Enable (=1) MISO pin as an */
-						 /* output. */
-#define SIZE                   0x00000100	 /* Word length (0 => 8 bits, 1 */
-						 /* => 16 bits) */
-#define LSBF                   0x00000200	 /* Data format (0 => MSB */
-						 /* sent/received first 1 => LSB  */
-						 /*  */
-						 /* sent/received first) */
-#define CPHA                   0x00000400	 /* Clock phase (0 => SPICLK */
-						 /* starts toggling in middle of  */
-						 /*  */
-						 /* xfer, 1 => SPICLK toggles at  */
-						 /*  */
-						 /* the beginning of xfer. */
-#define CPOL                   0x00000800	 /* Clock polarity (0 => */
-						 /* active-high, 1 => */
-						 /* active-low) */
-#define MSTR                   0x00001000	 /* Configures SPI as master */
-						 /* (=1) or slave (=0) */
-#define WOM                    0x00002000	 /* Open drain (=1) data output */
-						 /* enable (for MOSI and MISO) */
-#define SPE                    0x00004000	 /* SPI module enable (=1), */
-						 /* disable (=0) */
-
- /* SPIFLGx Masks */
-#define FLS1                   0x00000002	 /* Enables (=1) SPI_FLOUT1 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLS2                   0x00000004	 /* Enables (=1) SPI_FLOUT2 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLS3                   0x00000008	 /* Enables (=1) SPI_FLOUT3 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLS4                   0x00000010	 /* Enables (=1) SPI_FLOUT4 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLS5                   0x00000020	 /* Enables (=1) SPI_FLOUT5 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLS6                   0x00000040	 /* Enables (=1) SPI_FLOUT6 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLS7                   0x00000080	 /* Enables (=1) SPI_FLOUT7 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLG1                   0x00000200	 /* Activates (=0) SPI_FLOUT1 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLG2                   0x00000400	 /* Activates (=0) SPI_FLOUT2 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLG3                   0x00000800	 /* Activates (=0) SPI_FLOUT3 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLG4                   0x00001000	 /* Activates (=0) SPI_FLOUT4 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLG5                   0x00002000	 /* Activates (=0) SPI_FLOUT5 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLG6                   0x00004000	 /* Activates (=0) SPI_FLOUT6 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLG7                   0x00008000	 /* Activates (=0) SPI_FLOUT7 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-
- /* SPIFLGx Bit Positions */
-#define FLS1_P                 0x00000001	 /* Enables (=1) SPI_FLOUT1 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLS2_P                 0x00000002	 /* Enables (=1) SPI_FLOUT2 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLS3_P                 0x00000003	 /* Enables (=1) SPI_FLOUT3 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLS4_P                 0x00000004	 /* Enables (=1) SPI_FLOUT4 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLS5_P                 0x00000005	 /* Enables (=1) SPI_FLOUT5 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLS6_P                 0x00000006	 /* Enables (=1) SPI_FLOUT6 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLS7_P                 0x00000007	 /* Enables (=1) SPI_FLOUT7 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLG1_P                 0x00000009	 /* Activates (=0) SPI_FLOUT1 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLG2_P                 0x0000000A	 /* Activates (=0) SPI_FLOUT2 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLG3_P                 0x0000000B	 /* Activates (=0) SPI_FLOUT3 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLG4_P                 0x0000000C	 /* Activates (=0) SPI_FLOUT4 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLG5_P                 0x0000000D	 /* Activates (=0) SPI_FLOUT5 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLG6_P                 0x0000000E	 /* Activates (=0) SPI_FLOUT6 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-#define FLG7_P                 0x0000000F	 /* Activates (=0) SPI_FLOUT7 as */
-						 /* flag output for SPI */
-						 /* Slave-select */
-
- /* AMGCTL Masks */
-#define AMCKEN                 0x00000001	 /* Enable CLKOUT */
-#define AMBEN_B4               0x00000002	 /* Enable Asynchronous Memory */
-						 /* Bank 6 only */
-#define AMBEN_B4_B5            0x00000004	 /* Enable Asynchronous Memory */
-						 /* Banks 4 & 5 only */
-#define AMBEN_ALL              0x00000006	 /* Enable Asynchronous Memory */
-						 /* Banks (all) 4, 5, 6, and 7 */
-#define B4PEN                  0x00000010	 /* Enable 16-bit packing for */
-						 /* Asynchronous Memory Bank 4 */
-#define B5PEN                  0x00000020	 /* Enable 16-bit packing for */
-						 /* Asynchronous Memory Bank 5 */
-#define B6PEN                  0x00000040	 /* Enable 16-bit packing for */
-						 /* Asynchronous Memory Bank 6 */
-#define B7PEN                  0x00000080	 /* Enable 16-bit packing for */
-						 /* Asynchronous Memory Bank 7 */
-
- /* AMGCTL Bit Positions */
-#define AMCKEN_P               0x00000000	 /* Enable CLKOUT */
-#define AMBEN_P0               0x00000001	 /* Asynchronous Memory Enable, */
-						 /* 00 - banks 4-7 disabled, 01 */
-						 /* - bank 4 enabled */
-#define AMBEN_P1               0x00000002	 /* Asynchronous Memory Enable, */
-						 /* 10 - banks 4&5 enabled, 11 -  */
-						 /*  */
-						 /* banks 4-7 enabled */
-#define B4PEN_P                0x00000004	 /* Enable 16-bit packing for */
-						 /* Asynchronous Memory Bank 4 */
-#define B5PEN_P                0x00000005	 /* Enable 16-bit packing for */
-						 /* Asynchronous Memory Bank 5 */
-#define B6PEN_P                0x00000006	 /* Enable 16-bit packing for */
-						 /* Asynchronous Memory Bank 6 */
-#define B7PEN_P                0x00000007	 /* Enable 16-bit packing for */
-						 /* Asynchronous Memory Bank 7 */
-
- /* AMBCTL0 Masks */
-#define B4RDYEN                0x00000001	 /* Bank 4 RDY Enable, */
-						 /* 0=disable, 1=enable */
-#define B4RDYPOL               0x00000002	 /* Bank 4 RDY Active high, */
-						 /* 0=active low, 1=active high */
-#define B4TT_1                 0x00000004	 /* Bank 4 Transition Time from */
-						 /* Read to Write = 1 cycle */
-#define B4TT_2                 0x00000008	 /* Bank 4 Transition Time from */
-						 /* Read to Write = 2 cycles */
-#define B4TT_3                 0x0000000C	 /* Bank 4 Transition Time from */
-						 /* Read to Write = 3 cycles */
-#define B4TT_4                 0x00000000	 /* Bank 4 Transition Time from */
-						 /* Read to Write = 4 cycles */
-#define B4ST_1                 0x00000010	 /* Bank 4 Setup Time from AOE */
-						 /* asserted to Read or Write */
-						 /* asserted = 1 cycle */
-#define B4ST_2                 0x00000020	 /* Bank 4 Setup Time from AOE */
-						 /* asserted to Read or Write */
-						 /* asserted = 2 cycles */
-#define B4ST_3                 0x00000030	 /* Bank 4 Setup Time from AOE */
-						 /* asserted to Read or Write */
-						 /* asserted = 3 cycles */
-#define B4ST_4                 0x00000000	 /* Bank 4 Setup Time from AOE */
-						 /* asserted to Read or Write */
-						 /* asserted = 4 cycles */
-#define B4HT_1                 0x00000040	 /* Bank 4 Hold Time from Read */
-						 /* or Write deasserted to AOE */
-						 /* deasserted = 1 cycle */
-#define B4HT_2                 0x00000080	 /* Bank 4 Hold Time from Read */
-						 /* or Write deasserted to AOE */
-						 /* deasserted = 2 cycles */
-#define B4HT_3                 0x000000C0	 /* Bank 4 Hold Time from Read */
-						 /* or Write deasserted to AOE */
-						 /* deasserted = 3 cycles */
-#define B4HT_4                 0x00000000	 /* Bank 4 Hold Time from Read */
-						 /* or Write deasserted to AOE */
-						 /* deasserted = 4 cycles */
-#define B4RAT_1                0x00000100	 /* Bank 4 Read Access Time = 1 */
-						 /* cycle */
-#define B4RAT_2                0x00000200	 /* Bank 4 Read Access Time = 2 */
-						 /* cycles */
-#define B4RAT_3                0x00000300	 /* Bank 4 Read Access Time = 3 */
-						 /* cycles */
-#define B4RAT_4                0x00000400	 /* Bank 4 Read Access Time = 4 */
-						 /* cycles */
-#define B4RAT_5                0x00000500	 /* Bank 4 Read Access Time = 5 */
-						 /* cycles */
-#define B4RAT_6                0x00000600	 /* Bank 4 Read Access Time = 6 */
-						 /* cycles */
-#define B4RAT_7                0x00000700	 /* Bank 4 Read Access Time = 7 */
-						 /* cycles */
-#define B4RAT_8                0x00000800	 /* Bank 4 Read Access Time = 8 */
-						 /* cycles */
-#define B4RAT_9                0x00000900	 /* Bank 4 Read Access Time = 9 */
-						 /* cycles */
-#define B4RAT_10               0x00000A00	 /* Bank 4 Read Access Time = 10 */
-						 /* cycles */
-#define B4RAT_11               0x00000B00	 /* Bank 4 Read Access Time = 11 */
-						 /* cycles */
-#define B4RAT_12               0x00000C00	 /* Bank 4 Read Access Time = 12 */
-						 /* cycles */
-#define B4RAT_13               0x00000D00	 /* Bank 4 Read Access Time = 13 */
-						 /* cycles */
-#define B4RAT_14               0x00000E00	 /* Bank 4 Read Access Time = 14 */
-						 /* cycles */
-#define B4RAT_15               0x00000F00	 /* Bank 4 Read Access Time = 15 */
-						 /* cycles */
-#define B4WAT_1                0x00001000	 /* Bank 4 Write Access Time = 1 */
-						 /* cycle */
-#define B4WAT_2                0x00002000	 /* Bank 4 Write Access Time = 2 */
-						 /* cycles */
-#define B4WAT_3                0x00003000	 /* Bank 4 Write Access Time = 3 */
-						 /* cycles */
-#define B4WAT_4                0x00004000	 /* Bank 4 Write Access Time = 4 */
-						 /* cycles */
-#define B4WAT_5                0x00005000	 /* Bank 4 Write Access Time = 5 */
-						 /* cycles */
-#define B4WAT_6                0x00006000	 /* Bank 4 Write Access Time = 6 */
-						 /* cycles */
-#define B4WAT_7                0x00007000	 /* Bank 4 Write Access Time = 7 */
-						 /* cycles */
-#define B4WAT_8                0x00008000	 /* Bank 4 Write Access Time = 8 */
-						 /* cycles */
-#define B4WAT_9                0x00009000	 /* Bank 4 Write Access Time = 9 */
-						 /* cycles */
-#define B4WAT_10               0x0000A000	 /* Bank 4 Write Access Time = */
-						 /* 10 cycles */
-#define B4WAT_11               0x0000B000	 /* Bank 4 Write Access Time = */
-						 /* 11 cycles */
-#define B4WAT_12               0x0000C000	 /* Bank 4 Write Access Time = */
-						 /* 12 cycles */
-#define B4WAT_13               0x0000D000	 /* Bank 4 Write Access Time = */
-						 /* 13 cycles */
-#define B4WAT_14               0x0000E000	 /* Bank 4 Write Access Time = */
-						 /* 14 cycles */
-#define B4WAT_15               0x0000F000	 /* Bank 4 Write Access Time = */
-						 /* 15 cycles */
-#define B5RDYEN                0x00000001	 /* Bank 5 RDY enable, */
-						 /* 0=disable, 1=enable */
-#define B5RDYPOL               0x00000002	 /* Bank 5 RDY Active high, */
-						 /* 0=active low, 1=active high */
-#define B5TT_1                 0x00000004	 /* Bank 5 Transition Time from */
-						 /* Read to Write = 1 cycle */
-#define B5TT_2                 0x00000008	 /* Bank 5 Transition Time from */
-						 /* Read to Write = 2 cycles */
-#define B5TT_3                 0x0000000C	 /* Bank 5 Transition Time from */
-						 /* Read to Write = 3 cycles */
-#define B5TT_4                 0x00000000	 /* Bank 5 Transition Time from */
-						 /* Read to Write = 4 cycles */
-#define B5ST_1                 0x00000010	 /* Bank 5 Setup Time from AOE */
-						 /* asserted to Read or Write */
-						 /* asserted = 1 cycle */
-#define B5ST_2                 0x00000020	 /* Bank 5 Setup Time from AOE */
-						 /* asserted to Read or Write */
-						 /* asserted = 2 cycles */
-#define B5ST_3                 0x00000030	 /* Bank 5 Setup Time from AOE */
-						 /* asserted to Read or Write */
-						 /* asserted = 3 cycles */
-#define B5ST_4                 0x00000000	 /* Bank 5 Setup Time from AOE */
-						 /* asserted to Read or Write */
-						 /* asserted = 4 cycles */
-#define B5HT_1                 0x00000040	 /* Bank 5 Hold Time from Read */
-						 /* or Write deasserted to AOE */
-						 /* deasserted = 1 cycle */
-#define B5HT_2                 0x00000080	 /* Bank 5 Hold Time from Read */
-						 /* or Write deasserted to AOE */
-						 /* deasserted = 2 cycles */
-#define B5HT_3                 0x000000C0	 /* Bank 5 Hold Time from Read */
-						 /* or Write deasserted to AOE */
-						 /* deasserted = 3 cycles */
-#define B5HT_4                 0x00000000	 /* Bank 5 Hold Time from Read */
-						 /* or Write deasserted to AOE */
-						 /* deasserted = 4 cycles */
-#define B5RAT_1                0x00000100	 /* Bank 5 Read Access Time = 1 */
-						 /* cycle */
-#define B5RAT_2                0x00000200	 /* Bank 5 Read Access Time = 2 */
-						 /* cycles */
-#define B5RAT_3                0x00000300	 /* Bank 5 Read Access Time = 3 */
-						 /* cycles */
-#define B5RAT_4                0x00000400	 /* Bank 5 Read Access Time = 4 */
-						 /* cycles */
-#define B5RAT_5                0x00000500	 /* Bank 5 Read Access Time = 5 */
-						 /* cycles */
-#define B5RAT_6                0x00000600	 /* Bank 5 Read Access Time = 6 */
-						 /* cycles */
-#define B5RAT_7                0x00000700	 /* Bank 5 Read Access Time = 7 */
-						 /* cycles */
-#define B5RAT_8                0x00000800	 /* Bank 5 Read Access Time = 8 */
-						 /* cycles */
-#define B5RAT_9                0x00000900	 /* Bank 5 Read Access Time = 9 */
-						 /* cycles */
-#define B5RAT_10               0x00000A00	 /* Bank 5 Read Access Time = 10 */
-						 /* cycles */
-#define B5RAT_11               0x00000B00	 /* Bank 5 Read Access Time = 11 */
-						 /* cycles */
-#define B5RAT_12               0x00000C00	 /* Bank 5 Read Access Time = 12 */
-						 /* cycles */
-#define B5RAT_13               0x00000D00	 /* Bank 5 Read Access Time = 13 */
-						 /* cycles */
-#define B5RAT_14               0x00000E00	 /* Bank 5 Read Access Time = 14 */
-						 /* cycles */
-#define B5RAT_15               0x00000F00	 /* Bank 5 Read Access Time = 15 */
-						 /* cycles */
-#define B5WAT_1                0x00001000	 /* Bank 5 Write Access Time = 1 */
-						 /* cycle */
-#define B5WAT_2                0x00002000	 /* Bank 5 Write Access Time = 2 */
-						 /* cycles */
-#define B5WAT_3                0x00003000	 /* Bank 5 Write Access Time = 3 */
-						 /* cycles */
-#define B5WAT_4                0x00004000	 /* Bank 5 Write Access Time = 4 */
-						 /* cycles */
-#define B5WAT_5                0x00005000	 /* Bank 5 Write Access Time = 5 */
-						 /* cycles */
-#define B5WAT_6                0x00006000	 /* Bank 5 Write Access Time = 6 */
-						 /* cycles */
-#define B5WAT_7                0x00007000	 /* Bank 5 Write Access Time = 7 */
-						 /* cycles */
-#define B5WAT_8                0x00008000	 /* Bank 5 Write Access Time = 8 */
-						 /* cycles */
-#define B5WAT_9                0x00009000	 /* Bank 5 Write Access Time = 9 */
-						 /* cycles */
-#define B5WAT_10               0x0000A000	 /* Bank 5 Write Access Time = */
-						 /* 10 cycles */
-#define B5WAT_11               0x0000B000	 /* Bank 5 Write Access Time = */
-						 /* 11 cycles */
-#define B5WAT_12               0x0000C000	 /* Bank 5 Write Access Time = */
-						 /* 12 cycles */
-#define B5WAT_13               0x0000D000	 /* Bank 5 Write Access Time = */
-						 /* 13 cycles */
-#define B5WAT_14               0x0000E000	 /* Bank 5 Write Access Time = */
-						 /* 14 cycles */
-#define B5WAT_15               0x0000F000	 /* Bank 5 Write Access Time = */
-						 /* 15 cycles */
-
- /* AMBCTL1 Masks */
-#define B6RDYEN                0x00000001	 /* Bank 6 RDY Enable, */
-						 /* 0=disable, 1=enable */
-#define B6RDYPOL               0x00000002	 /* Bank 6 RDY Active high, */
-						 /* 0=active low, 1=active high */
-#define B6TT_1                 0x00000004	 /* Bank 6 Transition Time from */
-						 /* Read to Write = 1 cycle */
-#define B6TT_2                 0x00000008	 /* Bank 6 Transition Time from */
-						 /* Read to Write = 2 cycles */
-#define B6TT_3                 0x0000000C	 /* Bank 6 Transition Time from */
-						 /* Read to Write = 3 cycles */
-#define B6TT_4                 0x00000000	 /* Bank 6 Transition Time from */
-						 /* Read to Write = 4 cycles */
-#define B6ST_1                 0x00000010	 /* Bank 6 Setup Time from AOE */
-						 /* asserted to Read or Write */
-						 /* asserted = 1 cycle */
-#define B6ST_2                 0x00000020	 /* Bank 6 Setup Time from AOE */
-						 /* asserted to Read or Write */
-						 /* asserted = 2 cycles */
-#define B6ST_3                 0x00000030	 /* Bank 6 Setup Time from AOE */
-						 /* asserted to Read or Write */
-						 /* asserted = 3 cycles */
-#define B6ST_4                 0x00000000	 /* Bank 6 Setup Time from AOE */
-						 /* asserted to Read or Write */
-						 /* asserted = 4 cycles */
-#define B6HT_1                 0x00000040	 /* Bank 6 Hold Time from Read */
-						 /* or Write deasserted to AOE */
-						 /* deasserted = 1 cycle */
-#define B6HT_2                 0x00000080	 /* Bank 6 Hold Time from Read */
-						 /* or Write deasserted to AOE */
-						 /* deasserted = 2 cycles */
-#define B6HT_3                 0x000000C0	 /* Bank 6 Hold Time from Read */
-						 /* or Write deasserted to AOE */
-						 /* deasserted = 3 cycles */
-#define B6HT_4                 0x00000000	 /* Bank 6 Hold Time from Read */
-						 /* or Write deasserted to AOE */
-						 /* deasserted = 4 cycles */
-#define B6RAT_1                0x00000100	 /* Bank 6 Read Access Time = 1 */
-						 /* cycle */
-#define B6RAT_2                0x00000200	 /* Bank 6 Read Access Time = 2 */
-						 /* cycles */
-#define B6RAT_3                0x00000300	 /* Bank 6 Read Access Time = 3 */
-						 /* cycles */
-#define B6RAT_4                0x00000400	 /* Bank 6 Read Access Time = 4 */
-						 /* cycles */
-#define B6RAT_5                0x00000500	 /* Bank 6 Read Access Time = 5 */
-						 /* cycles */
-#define B6RAT_6                0x00000600	 /* Bank 6 Read Access Time = 6 */
-						 /* cycles */
-#define B6RAT_7                0x00000700	 /* Bank 6 Read Access Time = 7 */
-						 /* cycles */
-#define B6RAT_8                0x00000800	 /* Bank 6 Read Access Time = 8 */
-						 /* cycles */
-#define B6RAT_9                0x00000900	 /* Bank 6 Read Access Time = 9 */
-						 /* cycles */
-#define B6RAT_10               0x00000A00	 /* Bank 6 Read Access Time = 10 */
-						 /* cycles */
-#define B6RAT_11               0x00000B00	 /* Bank 6 Read Access Time = 11 */
-						 /* cycles */
-#define B6RAT_12               0x00000C00	 /* Bank 6 Read Access Time = 12 */
-						 /* cycles */
-#define B6RAT_13               0x00000D00	 /* Bank 6 Read Access Time = 13 */
-						 /* cycles */
-#define B6RAT_14               0x00000E00	 /* Bank 6 Read Access Time = 14 */
-						 /* cycles */
-#define B6RAT_15               0x00000F00	 /* Bank 6 Read Access Time = 15 */
-						 /* cycles */
-#define B6WAT_1                0x00001000	 /* Bank 6 Write Access Time = 1 */
-						 /* cycle */
-#define B6WAT_2                0x00002000	 /* Bank 6 Write Access Time = 2 */
-						 /* cycles */
-#define B6WAT_3                0x00003000	 /* Bank 6 Write Access Time = 3 */
-						 /* cycles */
-#define B6WAT_4                0x00004000	 /* Bank 6 Write Access Time = 4 */
-						 /* cycles */
-#define B6WAT_5                0x00005000	 /* Bank 6 Write Access Time = 5 */
-						 /* cycles */
-#define B6WAT_6                0x00006000	 /* Bank 6 Write Access Time = 6 */
-						 /* cycles */
-#define B6WAT_7                0x00007000	 /* Bank 6 Write Access Time = 7 */
-						 /* cycles */
-#define B6WAT_8                0x00008000	 /* Bank 6 Write Access Time = 8 */
-						 /* cycles */
-#define B6WAT_9                0x00009000	 /* Bank 6 Write Access Time = 9 */
-						 /* cycles */
-#define B6WAT_10               0x0000A000	 /* Bank 6 Write Access Time = */
-						 /* 10 cycles */
-#define B6WAT_11               0x0000B000	 /* Bank 6 Write Access Time = */
-						 /* 11 cycles */
-#define B6WAT_12               0x0000C000	 /* Bank 6 Write Access Time = */
-						 /* 12 cycles */
-#define B6WAT_13               0x0000D000	 /* Bank 6 Write Access Time = */
-						 /* 13 cycles */
-#define B6WAT_14               0x0000E000	 /* Bank 6 Write Access Time = */
-						 /* 14 cycles */
-#define B6WAT_15               0x0000F000	 /* Bank 6 Write Access Time = */
-						 /* 15 cycles */
-#define B7RDYEN                0x00000001	 /* Bank 7 RDY enable, */
-						 /* 0=disable, 1=enable */
-#define B7RDYPOL               0x00000002	 /* Bank 7 RDY Active high, */
-						 /* 0=active low, 1=active high */
-#define B7TT_1                 0x00000004	 /* Bank 7 Transition Time from */
-						 /* Read to Write = 1 cycle */
-#define B7TT_2                 0x00000008	 /* Bank 7 Transition Time from */
-						 /* Read to Write = 2 cycles */
-#define B7TT_3                 0x0000000C	 /* Bank 7 Transition Time from */
-						 /* Read to Write = 3 cycles */
-#define B7TT_4                 0x00000000	 /* Bank 7 Transition Time from */
-						 /* Read to Write = 4 cycles */
-#define B7ST_1                 0x00000010	 /* Bank 7 Setup Time from AOE */
-						 /* asserted to Read or Write */
-						 /* asserted = 1 cycle */
-#define B7ST_2                 0x00000020	 /* Bank 7 Setup Time from AOE */
-						 /* asserted to Read or Write */
-						 /* asserted = 2 cycles */
-#define B7ST_3                 0x00000030	 /* Bank 7 Setup Time from AOE */
-						 /* asserted to Read or Write */
-						 /* asserted = 3 cycles */
-#define B7ST_4                 0x00000000	 /* Bank 7 Setup Time from AOE */
-						 /* asserted to Read or Write */
-						 /* asserted = 4 cycles */
-#define B7HT_1                 0x00000040	 /* Bank 7 Hold Time from Read */
-						 /* or Write deasserted to AOE */
-						 /* deasserted = 1 cycle */
-#define B7HT_2                 0x00000080	 /* Bank 7 Hold Time from Read */
-						 /* or Write deasserted to AOE */
-						 /* deasserted = 2 cycles */
-#define B7HT_3                 0x000000C0	 /* Bank 7 Hold Time from Read */
-						 /* or Write deasserted to AOE */
-						 /* deasserted = 3 cycles */
-#define B7HT_4                 0x00000000	 /* Bank 7 Hold Time from Read */
-						 /* or Write deasserted to AOE */
-						 /* deasserted = 4 cycles */
-#define B7RAT_1                0x00000100	 /* Bank 7 Read Access Time = 1 */
-						 /* cycle */
-#define B7RAT_2                0x00000200	 /* Bank 7 Read Access Time = 2 */
-						 /* cycles */
-#define B7RAT_3                0x00000300	 /* Bank 7 Read Access Time = 3 */
-						 /* cycles */
-#define B7RAT_4                0x00000400	 /* Bank 7 Read Access Time = 4 */
-						 /* cycles */
-#define B7RAT_5                0x00000500	 /* Bank 7 Read Access Time = 5 */
-						 /* cycles */
-#define B7RAT_6                0x00000600	 /* Bank 7 Read Access Time = 6 */
-						 /* cycles */
-#define B7RAT_7                0x00000700	 /* Bank 7 Read Access Time = 7 */
-						 /* cycles */
-#define B7RAT_8                0x00000800	 /* Bank 7 Read Access Time = 8 */
-						 /* cycles */
-#define B7RAT_9                0x00000900	 /* Bank 7 Read Access Time = 9 */
-						 /* cycles */
-#define B7RAT_10               0x00000A00	 /* Bank 7 Read Access Time = 10 */
-						 /* cycles */
-#define B7RAT_11               0x00000B00	 /* Bank 7 Read Access Time = 11 */
-						 /* cycles */
-#define B7RAT_12               0x00000C00	 /* Bank 7 Read Access Time = 12 */
-						 /* cycles */
-#define B7RAT_13               0x00000D00	 /* Bank 7 Read Access Time = 13 */
-						 /* cycles */
-#define B7RAT_14               0x00000E00	 /* Bank 7 Read Access Time = 14 */
-						 /* cycles */
-#define B7RAT_15               0x00000F00	 /* Bank 7 Read Access Time = 15 */
-						 /* cycles */
-#define B7WAT_1                0x00001000	 /* Bank 7 Write Access Time = 1 */
-						 /* cycle */
-#define B7WAT_2                0x00002000	 /* Bank 7 Write Access Time = 2 */
-						 /* cycles */
-#define B7WAT_3                0x00003000	 /* Bank 7 Write Access Time = 3 */
-						 /* cycles */
-#define B7WAT_4                0x00004000	 /* Bank 7 Write Access Time = 4 */
-						 /* cycles */
-#define B7WAT_5                0x00005000	 /* Bank 7 Write Access Time = 5 */
-						 /* cycles */
-#define B7WAT_6                0x00006000	 /* Bank 7 Write Access Time = 6 */
-						 /* cycles */
-#define B7WAT_7                0x00007000	 /* Bank 7 Write Access Time = 7 */
-						 /* cycles */
-#define B7WAT_8                0x00008000	 /* Bank 7 Write Access Time = 8 */
-						 /* cycles */
-#define B7WAT_9                0x00009000	 /* Bank 7 Write Access Time = 9 */
-						 /* cycles */
-#define B7WAT_10               0x0000A000	 /* Bank 7 Write Access Time = */
-						 /* 10 cycles */
-#define B7WAT_11               0x0000B000	 /* Bank 7 Write Access Time = */
-						 /* 11 cycles */
-#define B7WAT_12               0x0000C000	 /* Bank 7 Write Access Time = */
-						 /* 12 cycles */
-#define B7WAT_13               0x0000D000	 /* Bank 7 Write Access Time = */
-						 /* 13 cycles */
-#define B7WAT_14               0x0000E000	 /* Bank 7 Write Access Time = */
-						 /* 14 cycles */
-#define B7WAT_15               0x0000F000	 /* Bank 7 Write Access Time = */
-						 /* 15 cycles */
-
-#endif				/* __DEF_BF535_H */
diff -puN include/asm-blackfin/mach-bf535/defblackfin.h~blackfin-arch-2.6.21-rc4-mm1-update /dev/null
--- a/include/asm-blackfin/mach-bf535/defblackfin.h
+++ /dev/null
@@ -1,444 +0,0 @@
-/*
- * File:         include/asm-blackfin/mach-bf535/defblackfin.h
- * Based on:
- * Author:
- *
- * Created:
- * Description:
- *	Common header file for blackfin family of processors
- * Rev:
- *
- * Modified:
- *
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; see the file COPYING.
- * If not, write to the Free Software Foundation,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-/* SYSTEM & MM REGISTER BIT & ADDRESS DEFINITIONS FOR ADSP-BF535 */
-
-#ifndef _DEF_BLACKFIN_H
-#define _DEF_BLACKFIN_H
-
-#if defined(__ADSPLPBLACKFIN__)
-#warning defblackfin.h should only be included for 535 compatible chips.
-#endif
-#define MK_BMSK_(x) (1<<x)
-
- /*********************************************************************************** */
- /* System Register Bits */
- /*********************************************************************************** */
-
- /*************************************************** */
- /*   ASTAT register */
- /*************************************************** */
-
-#ifdef __ADSPBF535__
- /* ** Bit Positions */
-#define ASTAT_AZ_P         0x00000000	 /* Result of last ALU0 or shifter operation is zero */
-#define ASTAT_AN_P         0x00000001	 /* Result of last ALU0 or shifter operation is negative */
-#define ASTAT_AC_P         0x00000002	 /* Result of last ALU0 operation generated a carry */
-#define ASTAT_AV0_P        0x00000003	 /* Result of last ALU0 or MAC0 operation overflowed, sticky for MAC */
-#define ASTAT_AV1_P        0x00000004	 /* Result of last MAC1 operation overflowed, sticky for MAC */
-#define ASTAT_CC_P         0x00000005	 /* Condition Code, used for holding comparison results */
-#define ASTAT_AQ_P         0x00000006	 /* Quotient Bit */
-#define ASTAT_RND_MOD_P    0x00000008	 /* Rounding mode, set for biased, clear for unbiased */
-
- /* NOTE: ASTAT_AC_P will be deprecated in future releases */
- /* To be replaced by ASTAT_AC0_P */
-#define ASTAT_AC0_P        ASTAT_AC_P
-
-#else				/* __ADSPBF535__ */
-
- /* definitions of ASTAT bit positions for next revision of BLACKFIN */
-#define ASTAT_AZ_P         0x00000000	 /* Result of last ALU0 or shifter operation is zero */
-#define ASTAT_AN_P         0x00000001	 /* Result of last ALU0 or shifter operation is negative */
-#define ASTAT_CC_P         0x00000005	 /* Condition Code, used for holding comparison results */
-#define ASTAT_AQ_P         0x00000006	 /* Quotient Bit */
-#define ASTAT_RND_MOD_P    0x00000008	 /* Rounding mode, set for biased, clear for unbiased */
-#define ASTAT_AC0_P        0x0000000C	 /* Result of last ALU0 operation generated a carry */
-#define ASTAT_AC1_P        0x0000000D	 /* Result of last ALU1 operation generated a carry */
-#define ASTAT_AV0_P        0x00000010	 /* Result of last ALU0 or MAC0 operation overflowed, sticky for MAC */
-#define ASTAT_AV0S_P       0x00000011	 /* Sticky version of ASTAT_AV0_P */
-#define ASTAT_AV1_P        0x00000012	 /* Result of last MAC1 operation overflowed, sticky for MAC */
-#define ASTAT_AV1S_P       0x00000013	 /* Sticky version of ASTAT_AV1_P */
-#define ASTAT_V_P          0x00000018	 /* Result of last op written to data register file. */
-#define ASTAT_VS_P         0x00000019	 /* Sticky version of ASTAT_V_P */
-#endif				/* __ADSPBF535__ */
-
- /* ** Masks */
-#define ASTAT_AZ           MK_BMSK_(ASTAT_AZ_P)	 /* Result of last ALU0 or shifter operation is zero */
-#define ASTAT_AN           MK_BMSK_(ASTAT_AN_P)	 /* Result of last ALU0 or shifter operation is negative */
-#define ASTAT_AV0          MK_BMSK_(ASTAT_AV0_P)	 /* Result of last ALU0 or MAC0 operation overflowed, sticky for MAC */
-#define ASTAT_AV1          MK_BMSK_(ASTAT_AV1_P)	 /* Result of last MAC1 operation overflowed, sticky for MAC */
-#define ASTAT_CC           MK_BMSK_(ASTAT_CC_P)	 /* Condition Code, used for holding comparison results */
-#define ASTAT_AQ           MK_BMSK_(ASTAT_AQ_P)	 /* Quotient Bit */
-#define ASTAT_RND_MOD      MK_BMSK_(ASTAT_RND_MOD_P)	 /* Rounding mode, set for biased, clear for unbiased */
-
-#ifdef __ADSPBF535__
-
-#define ASTAT_AC           MK_BMSK_(ASTAT_AC_P)	 /* Result of last ALU0 operation generated a carry */
-
-#else				/* __ADSPBF535__ */
-
-#define ASTAT_AC0          MK_BMSK_(ASTAT_AC0_P)	 /* Result of last ALU0 operation generated a carry */
-#define ASTAT_AC1          MK_BMSK_(ASTAT_AC1_P)	 /* Result of last ALU1 operation generated a carry */
-#define ASTAT_AV0S         MK_BMSK_(ASTAT_AV0S_P)	 /* Sticky version of ASTAT_AV0_P */
-#define ASTAT_AV1S         MK_BMSK_(ASTAT_AV1S_P)	 /* Sticky version of ASTAT_AV1_P */
-#define ASTAT_V            MK_BMSK_(ASTAT_V_P)	 /* Result of last op written to data register file. */
-#define ASTAT_VS           MK_BMSK_(ASTAT_VS_P)	 /* Sticky version of ASTAT_V_P */
-
-#endif				/* __ADSPBF535__ */
-
- /*************************************************** */
- /*   SEQSTAT register */
- /*************************************************** */
-
- /* ** Bit Positions */
-#define SEQSTAT_EXCAUSE0_P     0x00000000	 /* Last exception cause bit 0 */
-#define SEQSTAT_EXCAUSE1_P     0x00000001	 /* Last exception cause bit 1 */
-#define SEQSTAT_EXCAUSE2_P     0x00000002	 /* Last exception cause bit 2 */
-#define SEQSTAT_EXCAUSE3_P     0x00000003	 /* Last exception cause bit 3 */
-#define SEQSTAT_EXCAUSE4_P     0x00000004	 /* Last exception cause bit 4 */
-#define SEQSTAT_EXCAUSE5_P     0x00000005	 /* Last exception cause bit 5 */
-#define SEQSTAT_OMODE0_P       0x0000000A	 /* Operating mode: 00 user, 01 supervisor, 1x debug */
-#define SEQSTAT_OMODE1_P       0x0000000B	 /* Operating mode: 00 user, 01 supervisor, 1x debug */
-#define SEQSTAT_IDLE_REQ_P     0x0000000C	 /* Pending idle mode request, set by IDLE instruction */
-#define SEQSTAT_SFTRESET_P     0x0000000D	 /* Indicates whether the last reset was a software reset (=1) */
-#define SEQSTAT_HWERRCAUSE0_P  0x0000000E	 /* Last hw error cause bit 0 */
-#define SEQSTAT_HWERRCAUSE1_P  0x0000000F	 /* Last hw error cause bit 1 */
-#define SEQSTAT_HWERRCAUSE2_P  0x00000010	 /* Last hw error cause bit 2 */
-#define SEQSTAT_HWERRCAUSE3_P  0x00000011	 /* Last hw error cause bit 3 */
-#define SEQSTAT_HWERRCAUSE4_P  0x00000012	 /* Last hw error cause bit 4 */
-
- /* ** Masks */
- /* Exception cause */
-#define SEQSTAT_EXCAUSE        MK_BMSK_(SEQSTAT_EXCAUSE0_P) | \
-                               MK_BMSK_(SEQSTAT_EXCAUSE1_P) | \
-                               MK_BMSK_(SEQSTAT_EXCAUSE2_P) | \
-                               MK_BMSK_(SEQSTAT_EXCAUSE3_P) | \
-                               MK_BMSK_(SEQSTAT_EXCAUSE4_P) | \
-                               MK_BMSK_(SEQSTAT_EXCAUSE5_P) | \
-                               0
-
- /* Operating mode: 00 user, 01 supervisor, 1x debug */
-#define SEQSTAT_OMODE          MK_BMSK_(SEQSTAT_OMODE0_P) | \
-                               MK_BMSK_(SEQSTAT_OMODE1_P) | \
-                               0
-
- /* Pending idle mode request, set by IDLE instruction */
-#define SEQSTAT_IDLE_REQ       MK_BMSK_(SEQSTAT_IDLE_REQ_P)
-
- /* Indicates whether the last reset was a software reset (=1) */
-#define SEQSTAT_SFTRESET       MK_BMSK_(SEQSTAT_SFTRESET_P)
-
- /* Last hw error cause */
-#define SEQSTAT_HWERRCAUSE     MK_BMSK_(SEQSTAT_HWERRCAUSE0_P) | \
-                               MK_BMSK_(SEQSTAT_HWERRCAUSE1_P) | \
-                               MK_BMSK_(SEQSTAT_HWERRCAUSE2_P) | \
-                               MK_BMSK_(SEQSTAT_HWERRCAUSE3_P) | \
-                               MK_BMSK_(SEQSTAT_HWERRCAUSE4_P) | \
-                               0
-
- /*************************************************** */
- /*   SYSCFG register */
- /*************************************************** */
-
- /* ** Bit Positions */
-#define SYSCFG_SSSTEP_P        0x00000000	 /* Supervisor single step, when set it forces an exception for each instruction executed */
-#define SYSCFG_CCEN_P          0x00000001	 /* Enable cycle counter (=1) */
-#define SYSCFG_SNEN_P          0x00000002	 /* Enable self-nesting interrupts (=1) */
-
- /* ** Masks */
-#define SYSCFG_SSSTEP         MK_BMSK_(SYSCFG_SSSTEP_P)	 /* Supervisor single step, when set it forces an exception for each instruction executed */
-#define SYSCFG_CCEN           MK_BMSK_(SYSCFG_CCEN_P)	 /* Enable cycle counter (=1) */
-#define SYSCFG_SNEN           MK_BMSK_(SYSCFG_SNEN_P)	 /* Enable self-nesting interrupts (=1) */
-/* Backward-compatibility for typos in prior releases */
-#define SYSCFG_SSSSTEP         SYSCFG_SSSTEP
-#define SYSCFG_CCCEN           SYSCFG_CCEN
-
- /*********************************************************************************** */
- /* Core MMR Register Map */
- /*********************************************************************************** */
-
- /* Cache & SRAM Memory */
-#define SRAM_BASE_ADDRESS      0xFFE00000	 /* SRAM Base Address (Read Only) */
-#define DMEM_CONTROL           0xFFE00004	 /* Data memory control */
-#define DCPLB_STATUS           0xFFE00008	 /* Data Cache Programmable Look-Aside Buffer Status */
-#define DCPLB_FAULT_ADDR       0xFFE0000C	 /* Data Cache Programmable Look-Aside Buffer Fault Address */
-#define MMR_TIMEOUT            0xFFE00010	 /* Memory-Mapped Register Timeout Register */
-#define DCPLB_ADDR0            0xFFE00100	 /* Data Cache Protection Lookaside Buffer 0 */
-#define DCPLB_ADDR1            0xFFE00104	 /* Data Cache Protection Lookaside Buffer 1 */
-#define DCPLB_ADDR2            0xFFE00108	 /* Data Cache Protection Lookaside Buffer 2 */
-#define DCPLB_ADDR3            0xFFE0010C	 /* Data Cache Protection Lookaside Buffer 3 */
-#define DCPLB_ADDR4            0xFFE00110	 /* Data Cache Protection Lookaside Buffer 4 */
-#define DCPLB_ADDR5            0xFFE00114	 /* Data Cache Protection Lookaside Buffer 5 */
-#define DCPLB_ADDR6            0xFFE00118	 /* Data Cache Protection Lookaside Buffer 6 */
-#define DCPLB_ADDR7            0xFFE0011C	 /* Data Cache Protection Lookaside Buffer 7 */
-#define DCPLB_ADDR8            0xFFE00120	 /* Data Cache Protection Lookaside Buffer 8 */
-#define DCPLB_ADDR9            0xFFE00124	 /* Data Cache Protection Lookaside Buffer 9 */
-#define DCPLB_ADDR10           0xFFE00128	 /* Data Cache Protection Lookaside Buffer 10 */
-#define DCPLB_ADDR11           0xFFE0012C	 /* Data Cache Protection Lookaside Buffer 11 */
-#define DCPLB_ADDR12           0xFFE00130	 /* Data Cache Protection Lookaside Buffer 12 */
-#define DCPLB_ADDR13           0xFFE00134	 /* Data Cache Protection Lookaside Buffer 13 */
-#define DCPLB_ADDR14           0xFFE00138	 /* Data Cache Protection Lookaside Buffer 14 */
-#define DCPLB_ADDR15           0xFFE0013C	 /* Data Cache Protection Lookaside Buffer 15 */
-#define DCPLB_DATA0            0xFFE00200	 /* Data Cache 0 Status */
-#define DCPLB_DATA1            0xFFE00204	 /* Data Cache 1 Status */
-#define DCPLB_DATA2            0xFFE00208	 /* Data Cache 2 Status */
-#define DCPLB_DATA3            0xFFE0020C	 /* Data Cache 3 Status */
-#define DCPLB_DATA4            0xFFE00210	 /* Data Cache 4 Status */
-#define DCPLB_DATA5            0xFFE00214	 /* Data Cache 5 Status */
-#define DCPLB_DATA6            0xFFE00218	 /* Data Cache 6 Status */
-#define DCPLB_DATA7            0xFFE0021C	 /* Data Cache 7 Status */
-#define DCPLB_DATA8            0xFFE00220	 /* Data Cache 8 Status */
-#define DCPLB_DATA9            0xFFE00224	 /* Data Cache 9 Status */
-#define DCPLB_DATA10           0xFFE00228	 /* Data Cache 10 Status */
-#define DCPLB_DATA11           0xFFE0022C	 /* Data Cache 11 Status */
-#define DCPLB_DATA12           0xFFE00230	 /* Data Cache 12 Status */
-#define DCPLB_DATA13           0xFFE00234	 /* Data Cache 13 Status */
-#define DCPLB_DATA14           0xFFE00238	 /* Data Cache 14 Status */
-#define DCPLB_DATA15           0xFFE0023C	 /* Data Cache 15 Status */
-#define DTEST_COMMAND          0xFFE00300	 /* Data Test Command Register */
-#define DTEST_INDEX            0xFFE00304	 /* Data Test Index Register */
-#define DTEST_DATA0            0xFFE00400	 /* Data Test Data Register */
-#define DTEST_DATA1            0xFFE00404	 /* Data Test Data Register */
-#define DTEST_DATA2            0xFFE00408	 /* Data Test Data Register */
-#define DTEST_DATA3            0xFFE0040C	 /* Data Test Data Register */
-#define IMEM_CONTROL           0xFFE01004	 /* Instruction Memory Control */
-#define ICPLB_STATUS           0xFFE01008	 /* Instruction Cache miss status */
-#define ICPLB_FAULT_ADDR       0xFFE0100C	 /* Instruction Cache miss address */
-#define ICPLB_ADDR0            0xFFE01100	 /* Instruction Cache Protection Lookaside Buffer 0 */
-#define ICPLB_ADDR1            0xFFE01104	 /* Instruction Cache Protection Lookaside Buffer 1 */
-#define ICPLB_ADDR2            0xFFE01108	 /* Instruction Cache Protection Lookaside Buffer 2 */
-#define ICPLB_ADDR3            0xFFE0110C	 /* Instruction Cache Protection Lookaside Buffer 3 */
-#define ICPLB_ADDR4            0xFFE01110	 /* Instruction Cache Protection Lookaside Buffer 4 */
-#define ICPLB_ADDR5            0xFFE01114	 /* Instruction Cache Protection Lookaside Buffer 5 */
-#define ICPLB_ADDR6            0xFFE01118	 /* Instruction Cache Protection Lookaside Buffer 6 */
-#define ICPLB_ADDR7            0xFFE0111C	 /* Instruction Cache Protection Lookaside Buffer 7 */
-#define ICPLB_ADDR8            0xFFE01120	 /* Instruction Cache Protection Lookaside Buffer 8 */
-#define ICPLB_ADDR9            0xFFE01124	 /* Instruction Cache Protection Lookaside Buffer 9 */
-#define ICPLB_ADDR10           0xFFE01128	 /* Instruction Cache Protection Lookaside Buffer 10 */
-#define ICPLB_ADDR11           0xFFE0112C	 /* Instruction Cache Protection Lookaside Buffer 11 */
-#define ICPLB_ADDR12           0xFFE01130	 /* Instruction Cache Protection Lookaside Buffer 12 */
-#define ICPLB_ADDR13           0xFFE01134	 /* Instruction Cache Protection Lookaside Buffer 13 */
-#define ICPLB_ADDR14           0xFFE01138	 /* Instruction Cache Protection Lookaside Buffer 14 */
-#define ICPLB_ADDR15           0xFFE0113C	 /* Instruction Cache Protection Lookaside Buffer 15 */
-#define ICPLB_DATA0            0xFFE01200	 /* Instruction Cache 0 Status */
-#define ICPLB_DATA1            0xFFE01204	 /* Instruction Cache 1 Status */
-#define ICPLB_DATA2            0xFFE01208	 /* Instruction Cache 2 Status */
-#define ICPLB_DATA3            0xFFE0120C	 /* Instruction Cache 3 Status */
-#define ICPLB_DATA4            0xFFE01210	 /* Instruction Cache 4 Status */
-#define ICPLB_DATA5            0xFFE01214	 /* Instruction Cache 5 Status */
-#define ICPLB_DATA6            0xFFE01218	 /* Instruction Cache 6 Status */
-#define ICPLB_DATA7            0xFFE0121C	 /* Instruction Cache 7 Status */
-#define ICPLB_DATA8            0xFFE01220	 /* Instruction Cache 8 Status */
-#define ICPLB_DATA9            0xFFE01224	 /* Instruction Cache 9 Status */
-#define ICPLB_DATA10           0xFFE01228	 /* Instruction Cache 10 Status */
-#define ICPLB_DATA11           0xFFE0122C	 /* Instruction Cache 11 Status */
-#define ICPLB_DATA12           0xFFE01230	 /* Instruction Cache 12 Status */
-#define ICPLB_DATA13           0xFFE01234	 /* Instruction Cache 13 Status */
-#define ICPLB_DATA14           0xFFE01238	 /* Instruction Cache 14 Status */
-#define ICPLB_DATA15           0xFFE0123C	 /* Instruction Cache 15 Status */
-#define ITEST_COMMAND          0xFFE01300	 /* Instruction Test Command Register */
-#define ITEST_INDEX            0xFFE01304	 /* Instruction Test Index Register */
-#define ITEST_DATA0            0xFFE01400	 /* Instruction Test Data Register */
-#define ITEST_DATA1            0xFFE01404	 /* Instruction Test Data Register */
-
- /* Event/Interrupt Registers */
-#define EVT0                   0xFFE02000	 /* Event Vector 0 ESR Address */
-#define EVT1                   0xFFE02004	 /* Event Vector 1 ESR Address */
-#define EVT2                   0xFFE02008	 /* Event Vector 2 ESR Address */
-#define EVT3                   0xFFE0200C	 /* Event Vector 3 ESR Address */
-#define EVT4                   0xFFE02010	 /* Event Vector 4 ESR Address */
-#define EVT5                   0xFFE02014	 /* Event Vector 5 ESR Address */
-#define EVT6                   0xFFE02018	 /* Event Vector 6 ESR Address */
-#define EVT7                   0xFFE0201C	 /* Event Vector 7 ESR Address */
-#define EVT8                   0xFFE02020	 /* Event Vector 8 ESR Address */
-#define EVT9                   0xFFE02024	 /* Event Vector 9 ESR Address */
-#define EVT10                  0xFFE02028	 /* Event Vector 10 ESR Address */
-#define EVT11                  0xFFE0202C	 /* Event Vector 11 ESR Address */
-#define EVT12                  0xFFE02030	 /* Event Vector 12 ESR Address */
-#define EVT13                  0xFFE02034	 /* Event Vector 13 ESR Address */
-#define EVT14                  0xFFE02038	 /* Event Vector 14 ESR Address */
-#define EVT15                  0xFFE0203C	 /* Event Vector 15 ESR Address */
-#define IMASK                  0xFFE02104	 /* Interrupt Mask Register */
-#define IPEND                  0xFFE02108	 /* Interrupt Pending Register */
-#define ILAT                   0xFFE0210C	 /* Interrupt Latch Register */
-
- /* Core Timer Registers */
-#define TCNTL                  0xFFE03000	 /* Core Timer Control Register */
-#define TPERIOD                0xFFE03004	 /* Core Timer Period Register */
-#define TSCALE                 0xFFE03008	 /* Core Timer Scale Register */
-#define TCOUNT                 0xFFE0300C	 /* Core Timer Count Register */
-
- /* Debug/MP/Emulation Registers */
-#define DSPID                  0xFFE05000	 /* DSP Processor ID Register for MP implementations */
-#define DBGCTL                 0xFFE05004	 /* Debug Control Register */
-#define DBGSTAT                0xFFE05008	 /* Debug Status Register */
-#define EMUDAT                 0xFFE0500C	 /* Emulator Data Register */
-
- /* Trace Buffer Registers */
-#define TBUFCTL                0xFFE06000	 /* Trace Buffer Control Register */
-#define TBUFSTAT               0xFFE06004	 /* Trace Buffer Status Register */
-#define TBUF                   0xFFE06100	 /* Trace Buffer */
-
- /* Watch Point Control Registers */
-#define WPIACTL                0xFFE07000	 /* Instruction Watch Point Control Register */
-#define WPIA0                  0xFFE07040	 /* Instruction Watch Point Address 0 */
-#define WPIA1                  0xFFE07044	 /* Instruction Watch Point Address 1 */
-#define WPIA2                  0xFFE07048	 /* Instruction Watch Point Address 2 */
-#define WPIA3                  0xFFE0704C	 /* Instruction Watch Point Address 3 */
-#define WPIA4                  0xFFE07050	 /* Instruction Watch Point Address 4 */
-#define WPIA5                  0xFFE07054	 /* Instruction Watch Point Address 5 */
-#define WPIACNT0               0xFFE07080	 /* Instruction Watch Point Counter 0 */
-#define WPIACNT1               0xFFE07084	 /* Instruction Watch Point Counter 1 */
-#define WPIACNT2               0xFFE07088	 /* Instruction Watch Point Counter 2 */
-#define WPIACNT3               0xFFE0708C	 /* Instruction Watch Point Counter 3 */
-#define WPIACNT4               0xFFE07090	 /* Instruction Watch Point Counter 4 */
-#define WPIACNT5               0xFFE07094	 /* Instruction Watch Point Counter 5 */
-#define WPDACTL                0xFFE07100	 /* Data Watch Point Control Register */
-#define WPDA0                  0xFFE07140	 /* Data Watch Point Address 0 */
-#define WPDA1                  0xFFE07144	 /* Data Watch Point Address 1 */
-#define WPDACNT0               0xFFE07180	 /* Data Watch Point Counter 0 */
-#define WPDACNT1               0xFFE07184	 /* Data Watch Point Counter 1 */
-#define WPSTAT                 0xFFE07200	 /* Watch Point Status Register */
-
- /* Performance Monitor Registers */
-#define PFCTL                  0xFFE08000	 /* Performance Monitor Control Register */
-#define PFCNTR0                0xFFE08100	 /* Performance Monitor Counter Register 0 */
-#define PFCNTR1                0xFFE08104	 /* Performance Monitor Counter Register 1 */
-
- /*********************************************************************************** */
- /* Core MMR Register Bits */
- /*********************************************************************************** */
-
- /*************************************************** */
- /*   EVT registers (ILAT, IMASK, and IPEND). */
- /*************************************************** */
-
- /* ** Bit Positions */
-#define EVT_EMU_P            0x00000000	 /* Emulator interrupt bit position */
-#define EVT_RST_P            0x00000001	 /* Reset interrupt bit position */
-#define EVT_NMI_P            0x00000002	 /* Non Maskable interrupt bit position */
-#define EVT_EVX_P            0x00000003	 /* Exception bit position */
-#define EVT_IRPTEN_P         0x00000004	 /* Global interrupt enable bit position */
-#define EVT_IVHW_P           0x00000005	 /* Hardware Error interrupt bit position */
-#define EVT_IVTMR_P          0x00000006	 /* Timer interrupt bit position */
-#define EVT_IVG7_P           0x00000007	 /* IVG7 interrupt bit position */
-#define EVT_IVG8_P           0x00000008	 /* IVG8 interrupt bit position */
-#define EVT_IVG9_P           0x00000009	 /* IVG9 interrupt bit position */
-#define EVT_IVG10_P          0x0000000a	 /* IVG10 interrupt bit position */
-#define EVT_IVG11_P          0x0000000b	 /* IVG11 interrupt bit position */
-#define EVT_IVG12_P          0x0000000c	 /* IVG12 interrupt bit position */
-#define EVT_IVG13_P          0x0000000d	 /* IVG13 interrupt bit position */
-#define EVT_IVG14_P          0x0000000e	 /* IVG14 interrupt bit position */
-#define EVT_IVG15_P          0x0000000f	 /* IVG15 interrupt bit position */
-
- /* ** Masks */
-#define EVT_EMU              MK_BMSK_(EVT_EMU_P   )	 /* Emulator interrupt mask */
-#define EVT_RST              MK_BMSK_(EVT_RST_P   )	 /* Reset interrupt mask */
-#define EVT_NMI              MK_BMSK_(EVT_NMI_P   )	 /* Non Maskable interrupt mask */
-#define EVT_EVX              MK_BMSK_(EVT_EVX_P   )	 /* Exception mask */
-#define EVT_IRPTEN           MK_BMSK_(EVT_IRPTEN_P)	 /* Global interrupt enable mask */
-#define EVT_IVHW             MK_BMSK_(EVT_IVHW_P  )	 /* Hardware Error interrupt mask */
-#define EVT_IVTMR            MK_BMSK_(EVT_IVTMR_P )	 /* Timer interrupt mask */
-#define EVT_IVG7             MK_BMSK_(EVT_IVG7_P  )	 /* IVG7 interrupt mask */
-#define EVT_IVG8             MK_BMSK_(EVT_IVG8_P  )	 /* IVG8 interrupt mask */
-#define EVT_IVG9             MK_BMSK_(EVT_IVG9_P  )	 /* IVG9 interrupt mask */
-#define EVT_IVG10            MK_BMSK_(EVT_IVG10_P )	 /* IVG10 interrupt mask */
-#define EVT_IVG11            MK_BMSK_(EVT_IVG11_P )	 /* IVG11 interrupt mask */
-#define EVT_IVG12            MK_BMSK_(EVT_IVG12_P )	 /* IVG12 interrupt mask */
-#define EVT_IVG13            MK_BMSK_(EVT_IVG13_P )	 /* IVG13 interrupt mask */
-#define EVT_IVG14            MK_BMSK_(EVT_IVG14_P )	 /* IVG14 interrupt mask */
-#define EVT_IVG15            MK_BMSK_(EVT_IVG15_P )	 /* IVG15 interrupt mask */
-
- /*************************************************** */
- /*   DMEM_CONTROL register */
- /*************************************************** */
- /* ** Bit Positions */
-#define ENDM_P						 0x00	 /* Enable Data Memory L1 */
-#define DMCTL_ENDM_P				 ENDM_P	 /* "" (older define) */
-#define ENDCPLB_P					 0x01	 /* Enable DCPLBS */
-#define DMCTL_ENDCPLB_P			 ENDCPLB_P	 /* "" (older define) */
-#define DMC0_P						 0x02	 /* L1 Data Memory Configure bit 0 */
-#define DMCTL_DMC0_P				 DMC0_P	 /* "" (older define) */
-#define DMC1_P						 0x03	 /* L1 Data Memory Configure bit 1 */
-#define DMCTL_DMC1_P				 DMC1_P	 /* "" (older define) */
-
- /* ** Masks */
-#define ENDM                   MK_BMSK_(DMCTL_ENDM_P)	 /* Enable Data Memory L1 */
-
- /* Bank A set as SRAM, Bank B set as SRAM */
-#define ASRAM_BSRAM            0x00000000
-
- /* Enable DCPLB */
-#define ENDCPLB                MK_BMSK_(DMCTL_ENDCPLB_P) | \
-                               0
-
- /* Bank A set as CACHE, Bank B set as SRAM */
-#define ACACHE_BSRAM           0x00000008
- /* Bank A set as CACHE, Bank B set as CACHE */
-#define ACACHE_BCACHE          0x0000000C
-#define DCBS                   0x00000010	 /* If HIGHBIT is 1, select L1 data memory B */
-					    /* If HIGHBIT is 0, select L1 data memory A */
-					    /* If LOWBIT is 1, select L1 memory bank B */
-					    /* If LOWBIT is 0, select L1 memory bank A */
-
- /* IMEM_CONTROL Masks */
-#define ENIM                   0x00000001	 /* Enable L1 Code Memory */
-#define ENICPLB                0x00000002	 /* Enable ICPLB */
-#define IMC                    0x00000004	 /* Configure L1 code memory as cache (0=SRAM) */
-
- /* TCNTL Masks */
-#define TMPWR                  0x00000001	 /* Timer Low Power Control, 0=low power mode, 1=active state */
-#define TMREN                  0x00000002	 /* Timer enable, 0=disable, 1=enable */
-#define TAUTORLD               0x00000004	 /* Timer auto reload */
-#define TINT                   0x00000008	 /* Timer generated interrupt 0=no interrupt has been generated, 1=interrupt has been generated (sticky) */
-
- /* TCNTL Bit Positions */
-#define TMPWR_P                0x00000000	 /* Timer Low Power Control, 0=low power mode, 1=active state */
-#define TMREN_P                0x00000001	 /* Timer enable, 0=disable, 1=enable */
-#define TAUTORLD_P             0x00000002	 /* Timer auto reload */
-#define TINT_P                 0x00000003	 /* Timer generated interrupt 0=no interrupt has been generated, 1=interrupt has been generated (sticky) */
-
- /* DCPLB_DATA and ICPLB_DATA Masks */
-#define CPLB_VALID             0x00000001	 /* 0=invalid entry, 1=valid entry */
-#define CPLB_LOCK              0x00000002	 /* 0=entry may be replaced, 1=entry locked */
-#define CPLB_USER_RD           0x00000004	 /* 0=no read access, 1=read access allowed (user mode) */
-#define CPLB_USER_WR           0x00000008	 /* 0=no write access, 0=write access allowed (user mode) */
-	  /* only applies to L1 data memory */
-#define CPLB_SUPV_WR           0x00000010	 /* 0=no write access, 0=write access allowed (supervisor mode) */
-#define CPLB_L1SRAM            0x00000020	 /* 0=SRAM mapped in L1, 0=SRAM not mapped to L1 */
-#define CPLB_DA0ACC            0x00000040	 /* 0=access allowed from either DAG, 1=access from DAG0 only */
-	  /* only applies in L1 data memory controller */
-#define CPLB_DIRTY             0x00000080	 /* 1=dirty, 0=clean */
-	  /* only applies in L1 data memory controller */
-#define CPLB_L1_CHBL           0x00001000	 /* 0=non-cacheable in L1, 1=cacheable in L1 */
-#define CPLB_WT                0x00004000	 /* 0=write-back, 1=write-through */
-	  /* only applies in L1 data memory controller in cache mode */
-#define PAGE_SIZE_1KB          0x00000000	 /* 1 KB page size */
-#define PAGE_SIZE_4KB          0x00010000	 /* 4 KB page size */
-#define PAGE_SIZE_1MB          0x00020000	 /* 1 MB page size */
-#define PAGE_SIZE_4MB          0x00030000	 /* 4 MB page size */
-
- /* DCPLB_DATA and ICPLB_DATA Bit Positions */
-#define CPLB_VALID_P           0x00000000	 /* 0=invalid entry, 1=valid entry */
-#define CPLB_LOCK_P            0x00000001	 /* 0=entry may be replaced, 1=entry locked */
-#define CPLB_USER_RD_P         0x00000002	 /* */
-
-#endif				/* _DEF_BLACKFIN_H */
diff -puN include/asm-blackfin/mach-bf535/irq.h~blackfin-arch-2.6.21-rc4-mm1-update /dev/null
--- a/include/asm-blackfin/mach-bf535/irq.h
+++ /dev/null
@@ -1,125 +0,0 @@
-/*
- * File:         include/asm-blackfin/mach-bf535/irq.h
- * Based on:
- * Author:
- *
- * Created:
- * Description:
- *	Common header file for blackfin family of processors
- * Rev:
- *
- * Modified:
- *
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; see the file COPYING.
- * If not, write to the Free Software Foundation,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-#ifndef _BF535_IRQ_H_
-#define _BF535_IRQ_H_
-
-/*
- * Interrupt source definitions
-             Event Source    Core Event Name
-Core        Emulation               **
- Events         (highest priority)  EMU         0
-            Reset                   RST         1
-            NMI                     NMI         2
-            Exception               EVX         3
-            Reserved                --          4
-            Hardware Error          IVHW        5
-            Core Timer              IVTMR       6 *
-            System RTC              IVG7        7
-            Interrupts USB Rx/Tx    IVG7        8
-            ** SPARE **             --          9
-            PCI                     IVG7        10
-            SPORT0 RX/TX            IVG8        11
-            ** SPARE **             --          12
-            SPORT1 RX/TX            IVG8        13
-            ** SPARE **             --          14
-            SPI0 RX/TX              IVG9        15
-            ** SPARE **             --          16
-            SPI1 RX/TX              IVG9        17
-            ** SPARE **             --          18
-            UART0 RX/TX             IVG10       19
-            **SPARE **              --          20
-            UART1 RX/TX             IVG10       21
-            ** SPARE **             --          22
-            Timer0                  IVG11       23
-            Timer1                  IVG11       24
-            Timer2                  IVG11       25
-            ** SPARE **                         26
-            Programmable Flags      **
-                    Interrupt A     IVG12       27 (all 8)
-                    Interrupt B     IVG12       28 (all 8)
-            Memory DMA              --          29
-            Watchdog Timer          IVG13       30
-            Software Interrupt 1    IVG14       31
-            Software Interrupt 2    --
-                 (lowest priority)  IVG15       32 *
- */
-/* The ABSTRACT IRQ definitions */
-/** the first seven of the following are fixed, the rest you change if you need to **/
-#define	IRQ_EMU			0	 /* Emulation */
-#define	IRQ_RST			1	 /* reset */
-#define	IRQ_NMI			2	 /* Non Maskable */
-#define	IRQ_EVX			3	 /* Exception */
-#define	IRQ_UNUSED		4	 /*  - unused interrupt */
-#define	IRQ_HWERR		5	 /* Hardware Error */
-#define	IRQ_CORETMR		6	 /* Core timer */
-#define	IRQ_RTC			7	 /* Real Time Clock */
-#define	IRQ_USB			8	 /* Universal Serial Bus */
-#define	IRQ_SPARE1		9	 /*  Spare ?? USB */
-#define IRQ_PCI_INTA		9	 /* PCI INTA */
-
- /* Exchanged with IRQ_UART1. HuTao Apr18 2003 */
-#define	IRQ_PCI			10	 /* Personal Computer Interface ?? */
-#define	IRQ_SPORT0		11	 /* Synchronous Serial Port 0 */
-#define	IRQ_SPARE2		12	 /*  Spare ?? split SPORT0 */
-#define IRQ_PCI_INTB		12	 /* PCI INTB */
-
-#define	IRQ_SPORT1		13	 /* Synchronous Serial Port 1 */
-#define	IRQ_SPARE3		14	 /*  Spare ?? split SPORT1 */
-#define IRQ_PCI_INTC		14
-
-#define	IRQ_SPI0		15	 /* Serial Peripheral Interface 0 */
-#define	IRQ_SPARE4		16	 /*  Spare */
-#define IRQ_PCI_INTD		16
-
-#define	IRQ_SPI1		17	 /* Serial Peripheral Interface 1 */
-#define	IRQ_SPARE5		18	 /*  Spare */
-#define	IRQ_UART0		19	 /* UART 0 */
-#define	IRQ_SPARE6		20	 /*  Spare */
-
- /* Changed to make UART driver work. HuTao Apr18 2003 */
-#define	IRQ_UART1		21	 /* UART 1 */
-
-#define	IRQ_SPARE7		22	 /*  Spare */
-#define	IRQ_TMR0		23	 /* Timer 0 */
-#define	IRQ_TMR1		24	 /* Timer 1 */
-#define	IRQ_TMR2		25	 /* Timer 2 */
-#define	IRQ_SPARE8		26	 /*  Spare */
-#define	IRQ_PROG_INTA		27	 /* Programmable Flags A (8) */
-#define	IRQ_PROG_INTB		28	 /* Programmable Flags B (8) */
-#define	IRQ_MEM_DMA		29	 /* Memory DMA Xfer Comp */
-#define	IRQ_WATCH	   	30	 /* Watch Dog Timer */
-#define	IRQ_SW_INT1		31	 /* Software Int 1 */
-#define	IRQ_SW_INT2		32	 /* Software Int 2 (reserved for SYSCALL) */
-
-#define SYS_IRQS		33	 /* Number of interrupt levels the kernel sees. */
-
-#endif				/* _BF535_IRQ_H_ */
diff -puN include/asm-blackfin/mach-bf537/bf537.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/mach-bf537/bf537.h
--- a/include/asm-blackfin/mach-bf537/bf537.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/mach-bf537/bf537.h
@@ -6,8 +6,6 @@
  * Created:
  * Description:  SYSTEM MMR REGISTER AND MEMORY MAP FOR ADSP-BF537
  *
- * Rev:          $Id: bf537.h,v 1.27 2006/11/20 18:20:27 rgetz Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -63,15 +61,6 @@
 
 /***************************/
 
-#define BLKFIN_ICACHESIZE	(16*1024)
-
-#if defined(CONFIG_BF537) || defined(CONFIG_BF534)
-#define BLKFIN_DCACHESIZE	(32*1024)
-#define BLKFIN_DSUPBANKS	2
-#else
-#define BLKFIN_DCACHESIZE	(16*1024)
-#define BLKFIN_DSUPBANKS	1
-#endif
 
 #define BLKFIN_DSUBBANKS	4
 #define BLKFIN_DWAYS		2
@@ -261,7 +250,7 @@
 #endif
 
 
-#define L1_DMEMORY       (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY )
+#define L1_DMEMORY       (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_LOCK | CPLB_DIRTY )
 #define SDRAM_DNON_CHBL  (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY )
 #define SDRAM_EBIU       (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY )
 #define SDRAM_OOPS  	 (CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_LOCK | CPLB_DIRTY )
diff -puN include/asm-blackfin/mach-bf537/defBF534.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/mach-bf537/defBF534.h
--- a/include/asm-blackfin/mach-bf537/defBF534.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/mach-bf537/defBF534.h
@@ -10,7 +10,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
@@ -1171,7 +1170,7 @@
 #define GM			0x0008	/* Get More (When RDBR Full, Overwrite/Discard*)        */
 #define PSSE		0x0010	/* Slave-Select Input Enable                                            */
 #define EMISO		0x0020	/* Enable MISO As Output                                                        */
-#define SIZE		0x0100	/* Size of Words (16/8* Bits)                                           */
+#define SPI_SIZE	0x0100	/* Size of Words (16/8* Bits)                                           */
 #define LSBF		0x0200	/* LSB First                                                                            */
 #define CPHA		0x0400	/* Clock Phase                                                                          */
 #define CPOL		0x0800	/* Clock Polarity                                                                       */
diff -puN include/asm-blackfin/mach-bf537/mem_map.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/mach-bf537/mem_map.h
--- a/include/asm-blackfin/mach-bf537/mem_map.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/mach-bf537/mem_map.h
@@ -2,7 +2,6 @@
  * Memory MAP
  * Common header file for blackfin BF537/6/4 of processors.
  *
- *
  */
 /*
  * file:         include/asm-blackfin/mach-bf537/mem_map.h
@@ -16,7 +15,6 @@
  *
  * modified:
  *
- *
  * bugs:         enter bugs at http://blackfin.uclinux.org/
  *
  * this program is free software; you can redistribute it and/or modify
@@ -59,6 +57,13 @@
 
 /* Memory Map for ADSP-BF537 processors */
 
+#ifdef CONFIG_BLKFIN_CACHE
+#define BLKFIN_ICACHESIZE	(16*1024)
+#else
+#define BLKFIN_ICACHESIZE	(0*1024)
+#endif
+
+
 #ifdef CONFIG_BF537
 #define L1_CODE_START       0xFFA00000
 #define L1_DATA_A_START     0xFF800000
@@ -67,20 +72,30 @@
 #define L1_CODE_LENGTH      0xC000
 
 #ifdef CONFIG_BLKFIN_DCACHE
-#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+
+#ifdef CONFIG_BLKFIN_DCACHE_BANKA
+#define DMEM_CNTR (ACACHE_BSRAM | ENDCPLB | PORT_PREF0)
 #define L1_DATA_A_LENGTH      (0x8000 - 0x4000)
+#define L1_DATA_B_LENGTH      0x8000
+#define BLKFIN_DCACHESIZE	(16*1024)
+#define BLKFIN_DSUPBANKS	1
 #else
-#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
-#define L1_DATA_A_LENGTH      0x8000
+#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      (0x8000 - 0x4000)
+#define L1_DATA_B_LENGTH      (0x8000 - 0x4000)
+#define BLKFIN_DCACHESIZE	(32*1024)
+#define BLKFIN_DSUPBANKS	2
 #endif
 
-#ifdef CONFIG_BLKFIN_DCACHE
-#define L1_DATA_B_LENGTH      (0x8000 - 0x4000)
 #else
+#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      0x8000
 #define L1_DATA_B_LENGTH      0x8000
-#endif
+#define BLKFIN_DCACHESIZE	(0*1024)
+#define BLKFIN_DSUPBANKS	0
+#endif /*CONFIG_BLKFIN_DCACHE*/
 
-#endif
+#endif /*CONFIG_BF537*/
 
 /* Memory Map for ADSP-BF536 processors */
 
@@ -91,19 +106,31 @@
 
 #define L1_CODE_LENGTH      0xC000
 
+
 #ifdef CONFIG_BLKFIN_DCACHE
-#define DMEM_CNTR (ACACHE_BSRAM | ENDCPLB)
+
+#ifdef CONFIG_BLKFIN_DCACHE_BANKA
+#define DMEM_CNTR (ACACHE_BSRAM | ENDCPLB | PORT_PREF0)
 #define L1_DATA_A_LENGTH      (0x4000 - 0x4000)
+#define L1_DATA_B_LENGTH      0x4000
+#define BLKFIN_DCACHESIZE	(16*1024)
+#define BLKFIN_DSUPBANKS	1
+
 #else
-#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB)
-#define L1_DATA_A_LENGTH      0x4000
+#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      (0x4000 - 0x4000)
+#define L1_DATA_B_LENGTH      (0x4000 - 0x4000)
+#define BLKFIN_DCACHESIZE	(32*1024)
+#define BLKFIN_DSUPBANKS	2
 #endif
 
-#ifdef CONFIG_BLKFIN_DCACHE
-#define L1_DATA_B_LENGTH      (0x4000 - 0x4000)
 #else
+#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      0x4000
 #define L1_DATA_B_LENGTH      0x4000
-#endif
+#define BLKFIN_DCACHESIZE	(0*1024)
+#define BLKFIN_DSUPBANKS	0
+#endif /*CONFIG_BLKFIN_DCACHE*/
 
 #endif
 
@@ -118,18 +145,28 @@
 
 #ifdef CONFIG_BLKFIN_DCACHE
 
-#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+#ifdef CONFIG_BLKFIN_DCACHE_BANKA
+#define DMEM_CNTR (ACACHE_BSRAM | ENDCPLB | PORT_PREF0)
 #define L1_DATA_A_LENGTH      (0x8000 - 0x4000)
+#define L1_DATA_B_LENGTH      0x8000
+#define BLKFIN_DCACHESIZE	(16*1024)
+#define BLKFIN_DSUPBANKS	1
+
 #else
-#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
-#define L1_DATA_A_LENGTH      0x8000
-#endif
-#ifdef CONFIG_BLKFIN_DCACHE
+#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      (0x8000 - 0x4000)
 #define L1_DATA_B_LENGTH      (0x8000 - 0x4000)
+#define BLKFIN_DCACHESIZE	(32*1024)
+#define BLKFIN_DSUPBANKS	2
+#endif
 
 #else
+#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      0x8000
 #define L1_DATA_B_LENGTH      0x8000
-#endif
+#define BLKFIN_DCACHESIZE	(0*1024)
+#define BLKFIN_DSUPBANKS	0
+#endif /*CONFIG_BLKFIN_DCACHE*/
 
 #endif
 
diff -puN include/asm-blackfin/mach-bf561/bf561.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/mach-bf561/bf561.h
--- a/include/asm-blackfin/mach-bf561/bf561.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/mach-bf561/bf561.h
@@ -6,8 +6,6 @@
  * Created:
  * Description:  SYSTEM MMR REGISTER AND MEMORY MAP FOR ADSP-BF561
  *
- * Rev:          $Id: bf561.h,v 1.22 2006/11/20 18:20:36 rgetz Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -74,14 +72,11 @@
  * Blackfin Cache setup
  */
 
-#define BLKFIN_ICACHESIZE	(16*1024)
-#define BLKFIN_DCACHESIZE	(32*1024)
 
 #define BLKFIN_ISUBBANKS	4
 #define BLKFIN_IWAYS		4
 #define BLKFIN_ILINES		32
 
-#define BLKFIN_DSUPBANKS	2
 #define BLKFIN_DSUBBANKS	4
 #define BLKFIN_DWAYS		2
 #define BLKFIN_DLINES		64
@@ -351,7 +346,7 @@
 #endif
 
 
-#define L1_DMEMORY       (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY)
+#define L1_DMEMORY       (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_LOCK | CPLB_DIRTY)
 #define SDRAM_DNON_CHBL  (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY)
 #define SDRAM_EBIU       (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY)
 #define SDRAM_OOPS  	 (CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_LOCK | CPLB_DIRTY)
diff -puN include/asm-blackfin/mach-bf561/mem_map.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/mach-bf561/mem_map.h
--- a/include/asm-blackfin/mach-bf561/mem_map.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/mach-bf561/mem_map.h
@@ -2,7 +2,6 @@
  * Memory MAP
  * Common header file for blackfin BF561 of processors.
  *
- *
  */
 
 #ifndef _MEM_MAP_561_H_
@@ -23,6 +22,12 @@
 
 /* Level 1 Memory */
 
+#ifdef CONFIG_BLKFIN_CACHE
+#define BLKFIN_ICACHESIZE	(16*1024)
+#else
+#define BLKFIN_ICACHESIZE	(0*1024)
+#endif
+
 /* Memory Map for ADSP-BF561 processors */
 
 #ifdef CONFIG_BF561
@@ -33,18 +38,28 @@
 #define L1_CODE_LENGTH      0x4000
 
 #ifdef CONFIG_BLKFIN_DCACHE
-#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+
+#ifdef CONFIG_BLKFIN_DCACHE_BANKA
+#define DMEM_CNTR (ACACHE_BSRAM | ENDCPLB | PORT_PREF0)
 #define L1_DATA_A_LENGTH      (0x8000 - 0x4000)
+#define L1_DATA_B_LENGTH      0x8000
+#define BLKFIN_DCACHESIZE	(16*1024)
+#define BLKFIN_DSUPBANKS	1
 #else
-#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
-#define L1_DATA_A_LENGTH      0x8000
+#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      (0x8000 - 0x4000)
+#define L1_DATA_B_LENGTH      (0x8000 - 0x4000)
+#define BLKFIN_DCACHESIZE	(32*1024)
+#define BLKFIN_DSUPBANKS	2
 #endif
 
-#ifdef CONFIG_BLKFIN_DCACHE
-#define L1_DATA_B_LENGTH      (0x8000 - 0x4000)
 #else
+#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      0x8000
 #define L1_DATA_B_LENGTH      0x8000
-#endif
+#define BLKFIN_DCACHESIZE	(0*1024)
+#define BLKFIN_DSUPBANKS	0
+#endif /*CONFIG_BLKFIN_DCACHE*/
 #endif
 
 /* Level 2 Memory */
diff -puN include/asm-blackfin/pgtable.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/pgtable.h
--- a/include/asm-blackfin/pgtable.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/pgtable.h
@@ -59,4 +59,12 @@ extern unsigned int kobjsize(const void 
 #define	VMALLOC_START	0
 #define	VMALLOC_END	0xffffffff
 
+#define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
+#define arch_enter_lazy_cpu_mode()	do {} while (0)
+#define arch_leave_lazy_cpu_mode()	do {} while (0)
+
+#define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
+#define arch_enter_lazy_mmu_mode()	do {} while (0)
+#define arch_leave_lazy_mmu_mode()	do {} while (0)
+
 #endif				/* _BLACKFIN_PGTABLE_H */
diff -puN include/asm-blackfin/sigcontext.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/sigcontext.h
--- a/include/asm-blackfin/sigcontext.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/sigcontext.h
@@ -3,17 +3,30 @@
 
 /* Add new entries at the end of the structure only.  */
 struct sigcontext {
-	unsigned long sc_mask;	/* old sigmask */
-	unsigned long sc_usp;	/* old user stack pointer */
 	unsigned long sc_r0;
 	unsigned long sc_r1;
 	unsigned long sc_r2;
 	unsigned long sc_r3;
 	unsigned long sc_r4;
+	unsigned long sc_r5;
+	unsigned long sc_r6;
+	unsigned long sc_r7;
 	unsigned long sc_p0;
 	unsigned long sc_p1;
 	unsigned long sc_p2;
 	unsigned long sc_p3;
+	unsigned long sc_p4;
+	unsigned long sc_p5;
+	unsigned long sc_usp;
+	unsigned long sc_a0w;
+	unsigned long sc_a1w;
+	unsigned long sc_a0x;
+	unsigned long sc_a1x;
+	unsigned long sc_astat;
+	unsigned long sc_rets;
+	unsigned long sc_pc;
+	unsigned long sc_retx;
+	unsigned long sc_fp;
 	unsigned long sc_i0;
 	unsigned long sc_i1;
 	unsigned long sc_i2;
@@ -30,12 +43,6 @@ struct sigcontext {
 	unsigned long sc_b1;
 	unsigned long sc_b2;
 	unsigned long sc_b3;
-	unsigned long sc_a0x;
-	unsigned long sc_a0w;
-	unsigned long sc_a1x;
-	unsigned long sc_a1w;
-	unsigned long sc_astat;
-	unsigned long sc_rets;
 	unsigned long sc_lc0;
 	unsigned long sc_lc1;
 	unsigned long sc_lt0;
@@ -43,8 +50,6 @@ struct sigcontext {
 	unsigned long sc_lb0;
 	unsigned long sc_lb1;
 	unsigned long sc_seqstat;
-	unsigned long sc_pc;
-	unsigned long sc_retx;
 };
 
 #endif
diff -puN include/asm-blackfin/uaccess.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/uaccess.h
--- a/include/asm-blackfin/uaccess.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/uaccess.h
@@ -33,7 +33,22 @@ static inline void set_fs(mm_segment_t f
 
 #define access_ok(type,addr,size) _access_ok((unsigned long)(addr),(size))
 
-extern int is_in_rom(unsigned long);
+static inline int is_in_rom(unsigned long addr)
+{
+	/*
+	 * What we are really trying to do is determine if addr is
+	 * in an allocated kernel memory region. If not then assume
+	 * we cannot free it or otherwise de-allocate it. Ideally
+	 * we could restrict this to really being in a ROM or flash,
+	 * but that would need to be done on a board by board basis,
+	 * not globally.
+	 */
+	if ((addr < _ramstart) || (addr >= _ramend))
+		return (1);
+
+	/* Default case, not in ROM */
+	return (0);
+}
 
 /*
  * The fs value determines whether argument validity checking should be
@@ -41,48 +56,15 @@ extern int is_in_rom(unsigned long);
  * get_fs() == KERNEL_DS, checking is bypassed.
  */
 
-static inline int _access_ok(unsigned long addr, unsigned long size)
-{
 #ifdef CONFIG_NO_ACCESS_CHECK
-	return 1;
+static inline int _access_ok(unsigned long addr, unsigned long size) { return 1; }
 #else
-	if (addr > (addr + size))
-		return 0;
-	if (segment_eq(get_fs(),KERNEL_DS))
-		return 1;
-#ifdef CONFIG_MTD_UCLINUX
-	if (addr >= memory_start && (addr + size) <= memory_end)
-		return 1;
-	if (addr >= memory_mtd_end && (addr + size) <= physical_mem_end)
-		return 1;
+#ifdef CONFIG_ACCESS_OK_L1
+extern int _access_ok(unsigned long addr, unsigned long size)__attribute__((l1_text));
 #else
-	if (addr >= memory_start && (addr + size) <= physical_mem_end)
-		return 1;
-#endif
-	if (addr >= (unsigned long)__init_begin &&
-	    addr + size <= (unsigned long)__init_end)
-		return 1;
-	if (addr >= L1_SCRATCH_START
-	    && addr + size <= L1_SCRATCH_START + L1_SCRATCH_LENGTH)
-		return 1;
-#if L1_CODE_LENGTH != 0
-	if (addr >= L1_CODE_START + (_etext_l1 - _stext_l1)
-	    && addr + size <= L1_CODE_START + L1_CODE_LENGTH)
-		return 1;
+extern int _access_ok(unsigned long addr, unsigned long size);
 #endif
-#if L1_DATA_A_LENGTH != 0
-	if (addr >= L1_DATA_A_START + (_ebss_l1 - _sdata_l1)
-	    && addr + size <= L1_DATA_A_START + L1_DATA_A_LENGTH)
-		return 1;
 #endif
-#if L1_DATA_B_LENGTH != 0
-	if (addr >= L1_DATA_B_START
-	    && addr + size <= L1_DATA_B_START + L1_DATA_B_LENGTH)
-		return 1;
-#endif
-	return 0;
-#endif
-}
 
 /*
  * The exception table consists of pairs of addresses: the first is the
diff -puN include/asm-blackfin/ucontext.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/ucontext.h
--- a/include/asm-blackfin/ucontext.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/ucontext.h
@@ -6,24 +6,11 @@
 #ifndef _BLACKFIN_UCONTEXT_H
 #define _BLACKFIN_UCONTEXT_H
 
-typedef int greg_t;
-#define NGREG 47
-/* including: r0-7, p0-5, a0/1w, a0/1x, astat, rets, reti, retx */
-/* fp, m0-3, l0-3, b0-3, lc0/1, lt0/1, lb0/1, seqstat */
-typedef greg_t gregset_t[NGREG];
-
-struct mcontext {
-	int version;
-	gregset_t gregs;
-};
-
-#define MCONTEXT_VERSION 2
-
 struct ucontext {
 	unsigned long uc_flags;	/* the others are necessary */
 	struct ucontext *uc_link;
 	stack_t uc_stack;
-	struct mcontext uc_mcontext;
+	struct sigcontext uc_mcontext;
 	sigset_t uc_sigmask;	/* mask last for extensibility */
 };
 
diff -puN include/asm-blackfin/unistd.h~blackfin-arch-2.6.21-rc4-mm1-update include/asm-blackfin/unistd.h
--- a/include/asm-blackfin/unistd.h~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/include/asm-blackfin/unistd.h
@@ -188,7 +188,7 @@
 #define __NR_getcwd		183
 #define __NR_capget		184
 #define __NR_capset		185
-				/* 186 __NR_sigaltstack obsolete */
+#define __NR_sigaltstack	186
 #define __NR_sendfile		187
 				/* 188 __NR_getpmsg */
 				/* 189 __NR_putpmsg */
diff -puN init/Kconfig~blackfin-arch-2.6.21-rc4-mm1-update init/Kconfig
--- a/init/Kconfig~blackfin-arch-2.6.21-rc4-mm1-update
+++ a/init/Kconfig
@@ -352,7 +352,7 @@ menuconfig EMBEDDED
 
 config UID16
 	bool "Enable 16-bit UID system calls" if EMBEDDED
-	depends on ARM || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && SPARC32_COMPAT) || UML || (X86_64 && IA32_EMULATION) || BFIN
+	depends on ARM || BFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && SPARC32_COMPAT) || UML || (X86_64 && IA32_EMULATION)
 	default y
 	help
 	  This enables the legacy 16-bit UID syscall wrappers.
@@ -459,7 +459,6 @@ config FUTEX
 config EPOLL
 	bool "Enable eventpoll support" if EMBEDDED
 	default y
-	depends on MMU
 	help
 	  Disabling this option will cause the kernel to be built without
 	  support for epoll family of system calls.
_

Patches currently in -mm which might be from bryan.wu@analog.com are

blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-balance-parenthesis-in-macros.patch
blackfin-arch-2.6.21-rc4-mm1-update.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-on-chip-ethernet-mac-controller-driver-update.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-i2c-driver-update-2.patch
blackfin-blackfin-utrace-patch.patch
utrace-nommu-fixup-support-utrace.patch
