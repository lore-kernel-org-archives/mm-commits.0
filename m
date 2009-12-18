From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 18 Dec 2009 12:24:26 -0800
Message-ID: <200912182024.nBIKOQoU016391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932748AbZLRUY3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 15:24:29 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id nBIKOQ1t023212
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 18 Dec 2009 12:24:28 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/configs/db1200_defconfig             |   23 ----------
 arch/mips/include/asm/mach-loongson/loongson.h |   23 ----------
 arch/mips/kernel/cpufreq/Kconfig               |   17 -------
 arch/mips/lasat/picvue_proc.c                  |   26 ------------
 arch/mips/loongson/Kconfig                     |   18 --------
 arch/mips/loongson/common/Makefile             |    8 ---
 arch/mips/loongson/common/init.c               |    4 -
 arch/mips/loongson/common/serial.c             |   13 ------
 arch/mips/loongson/common/uart_base.c          |   32 ---------------
 arch/mips/powertv/asic/asic_devices.c          |    8 ---
 arch/mips/powertv/cmdline.c                    |    4 -
 arch/mips/powertv/memory.c                     |    4 -
 arch/mips/rb532/prom.c                         |    4 -
 fs/exec.c                                      |    4 -
 14 files changed, 188 deletions(-)

diff -puN arch/mips/configs/db1200_defconfig~linux-next-git-rejects arch/mips/configs/db1200_defconfig
--- a/arch/mips/configs/db1200_defconfig~linux-next-git-rejects
+++ a/arch/mips/configs/db1200_defconfig
@@ -9,25 +9,9 @@ CONFIG_MIPS=y
 # Machine selection
 #
 CONFIG_MACH_ALCHEMY=y
-<<<<<<< HEAD:arch/mips/configs/db1200_defconfig
-# CONFIG_MIPS_MTX1 is not set
-# CONFIG_MIPS_BOSPORUS is not set
-# CONFIG_MIPS_PB1000 is not set
-# CONFIG_MIPS_PB1100 is not set
-# CONFIG_MIPS_PB1500 is not set
-# CONFIG_MIPS_PB1550 is not set
-# CONFIG_MIPS_PB1200 is not set
-# CONFIG_MIPS_DB1000 is not set
-# CONFIG_MIPS_DB1100 is not set
-# CONFIG_MIPS_DB1500 is not set
-# CONFIG_MIPS_DB1550 is not set
-CONFIG_MIPS_DB1200=y
-# CONFIG_MIPS_MIRAGE is not set
-=======
 # CONFIG_AR7 is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_BCM63XX is not set
->>>>>>> FETCH_HEAD:arch/mips/configs/db1200_defconfig
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
@@ -1440,12 +1424,6 @@ CONFIG_STRIP_ASM_SYMS=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
-<<<<<<< HEAD:arch/mips/configs/db1200_defconfig
-CONFIG_LOG_BUF_SHIFT=14
-CONFIG_CROSSCOMPILE=y
-CONFIG_CMDLINE_BOOL=y
-CONFIG_CMDLINE="mem=48M"
-=======
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_TRACING_SUPPORT=y
@@ -1454,7 +1432,6 @@ CONFIG_TRACING_SUPPORT=y
 CONFIG_HAVE_ARCH_KGDB=y
 CONFIG_CMDLINE_BOOL=y
 CONFIG_CMDLINE="console=ttyS0,115200"
->>>>>>> FETCH_HEAD:arch/mips/configs/db1200_defconfig
 # CONFIG_CMDLINE_OVERRIDE is not set
 
 #
diff -puN arch/mips/include/asm/mach-loongson/loongson.h~linux-next-git-rejects arch/mips/include/asm/mach-loongson/loongson.h
--- a/arch/mips/include/asm/mach-loongson/loongson.h~linux-next-git-rejects
+++ a/arch/mips/include/asm/mach-loongson/loongson.h
@@ -31,23 +31,9 @@ extern void __init prom_init_memory(void
 extern void __init prom_init_cmdline(void);
 extern void __init prom_init_machtype(void);
 extern void __init prom_init_env(void);
-<<<<<<< HEAD:arch/mips/include/asm/mach-loongson/loongson.h
-#ifdef CONFIG_LOONGSON_UART_BASE
-extern unsigned long _loongson_uart_base, loongson_uart_base;
-extern void prom_init_loongson_uart_base(void);
-#endif
-
-static inline void prom_init_uart_base(void)
-{
-#ifdef CONFIG_LOONGSON_UART_BASE
-	prom_init_loongson_uart_base();
-#endif
-}
-=======
 extern unsigned long _loongson_uart_base;
 extern unsigned long uart8250_base[];
 extern void prom_init_uart_base(void);
->>>>>>> FETCH_HEAD:arch/mips/include/asm/mach-loongson/loongson.h
 
 /* irq operation functions */
 extern void bonito_irqdispatch(void);
@@ -241,17 +227,8 @@ extern int mach_i8259_irq(void);
 #define LOONGSON_PCIMAP_WIN(WIN, ADDR)	\
 	((((ADDR)>>26) & LOONGSON_PCIMAP_PCIMAP_LO0) << ((WIN)*6))
 
-<<<<<<< HEAD:arch/mips/include/asm/mach-loongson/loongson.h
-#ifdef CONFIG_CPU_SUPPORTS_CPUFREQ
-#include <linux/cpufreq.h>
-extern void loongson2_cpu_wait(void);
-extern struct cpufreq_frequency_table loongson2_clockmod_table[];
-
-/* Chip Config */
-=======
 /* Chip Config */
 #ifdef CONFIG_CPU_SUPPORTS_CPUFREQ
->>>>>>> FETCH_HEAD:arch/mips/include/asm/mach-loongson/loongson.h
 #define LOONGSON_CHIPCFG0		LOONGSON_REG(LOONGSON_REGBASE + 0x80)
 #endif
 
diff -puN arch/mips/kernel/cpufreq/Kconfig~linux-next-git-rejects arch/mips/kernel/cpufreq/Kconfig
--- a/arch/mips/kernel/cpufreq/Kconfig~linux-next-git-rejects
+++ a/arch/mips/kernel/cpufreq/Kconfig
@@ -20,23 +20,6 @@ if CPU_FREQ
 
 comment "CPUFreq processor drivers"
 
-<<<<<<< HEAD:arch/mips/kernel/cpufreq/Kconfig
-config LOONGSON2_CPUFREQ
-	tristate "Loongson2 CPUFreq Driver"
-	select CPU_FREQ_TABLE
-	depends on MIPS_CPUFREQ
-	help
-	  This option adds a CPUFreq driver for loongson processors which
-	  support software configurable cpu frequency.
-
-	  Loongson2F and it's successors support this feature.
-
-	  For details, take a look at <file:Documentation/cpu-freq/>.
-
-	  If in doubt, say N.
-
-=======
->>>>>>> FETCH_HEAD:arch/mips/kernel/cpufreq/Kconfig
 endif	# CPU_FREQ
 
 endmenu
diff -puN arch/mips/lasat/picvue_proc.c~linux-next-git-rejects arch/mips/lasat/picvue_proc.c
--- a/arch/mips/lasat/picvue_proc.c~linux-next-git-rejects
+++ a/arch/mips/lasat/picvue_proc.c
@@ -54,28 +54,12 @@ static int pvc_line_proc_show(struct seq
 	mutex_unlock(&pvc_mutex);
 
 	return 0;
-<<<<<<< HEAD:arch/mips/lasat/picvue_proc.c
 }
 
 static int pvc_line_proc_open(struct inode *inode, struct file *file)
 {
 	return single_open(file, pvc_line_proc_show, PDE(inode)->data);
 }
-=======
-}
-
-static int pvc_line_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, pvc_line_proc_show, PDE(inode)->data);
-}
-
-static ssize_t pvc_line_proc_write(struct file *file, const char __user *buf,
-				   size_t count, loff_t *pos)
-{
-	int lineno = *(int *)PDE(file->f_path.dentry->d_inode)->data;
-	char kbuf[PVC_LINELEN];
-	size_t len;
->>>>>>> FETCH_HEAD:arch/mips/lasat/picvue_proc.c
 
 static ssize_t pvc_line_proc_write(struct file *file, const char __user *buf,
 				   size_t count, loff_t *pos)
@@ -156,15 +140,6 @@ static int pvc_scroll_proc_show(struct s
 	mutex_unlock(&pvc_mutex);
 
 	return 0;
-<<<<<<< HEAD:arch/mips/lasat/picvue_proc.c
-}
-
-static int pvc_scroll_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, pvc_scroll_proc_show, NULL);
-}
-
-=======
 }
 
 static int pvc_scroll_proc_open(struct inode *inode, struct file *file)
@@ -172,7 +147,6 @@ static int pvc_scroll_proc_open(struct i
 	return single_open(file, pvc_scroll_proc_show, NULL);
 }
 
->>>>>>> FETCH_HEAD:arch/mips/lasat/picvue_proc.c
 static const struct file_operations pvc_scroll_proc_fops = {
 	.owner		= THIS_MODULE,
 	.open		= pvc_scroll_proc_open,
diff -puN arch/mips/loongson/Kconfig~linux-next-git-rejects arch/mips/loongson/Kconfig
--- a/arch/mips/loongson/Kconfig~linux-next-git-rejects
+++ a/arch/mips/loongson/Kconfig
@@ -34,17 +34,10 @@ config LEMOTE_MACH2F
 	select ARCH_SPARSEMEM_ENABLE
 	select BOARD_SCACHE
 	select BOOT_ELF32
-<<<<<<< HEAD:arch/mips/loongson/Kconfig
-	select CEVT_R4K if ! MIPS_EXTERNAL_TIMER
-	select CPU_HAS_WB
-	select CS5536
-	select CSRC_R4K if ! MIPS_EXTERNAL_TIMER
-=======
 	select CEVT_R4K
 	select CPU_HAS_WB
 	select CS5536
 	select CSRC_R4K
->>>>>>> FETCH_HEAD:arch/mips/loongson/Kconfig
 	select DMA_NONCOHERENT
 	select GENERIC_HARDIRQS_NO__DO_IRQ
 	select GENERIC_ISA_DMA_SUPPORT_BROKEN
@@ -72,10 +65,6 @@ config CS5536
 config CS5536_MFGPT
 	bool "CS5536 MFGPT Timer"
 	depends on CS5536
-<<<<<<< HEAD:arch/mips/loongson/Kconfig
-	select MIPS_EXTERNAL_TIMER
-=======
->>>>>>> FETCH_HEAD:arch/mips/loongson/Kconfig
 	help
 	  This option enables the mfgpt0 timer of AMD CS5536.
 
@@ -88,11 +77,4 @@ config LOONGSON_SUSPEND
 	bool
 	default y
 	depends on CPU_SUPPORTS_CPUFREQ && SUSPEND
-<<<<<<< HEAD:arch/mips/loongson/Kconfig
 
-config LOONGSON_UART_BASE
-	bool
-	default y
-	depends on EARLY_PRINTK || SERIAL_8250
-=======
->>>>>>> FETCH_HEAD:arch/mips/loongson/Kconfig
diff -puN arch/mips/loongson/common/Makefile~linux-next-git-rejects arch/mips/loongson/common/Makefile
--- a/arch/mips/loongson/common/Makefile~linux-next-git-rejects
+++ a/arch/mips/loongson/common/Makefile
@@ -3,21 +3,13 @@
 #
 
 obj-y += setup.o init.o cmdline.o env.o time.o reset.o irq.o \
-<<<<<<< HEAD:arch/mips/loongson/common/Makefile
-    pci.o bonito-irq.o mem.o machtype.o platform.o
-=======
     pci.o bonito-irq.o mem.o machtype.o uart_base.o
->>>>>>> FETCH_HEAD:arch/mips/loongson/common/Makefile
 
 #
 # Serial port support
 #
 obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
 obj-$(CONFIG_SERIAL_8250) += serial.o
-<<<<<<< HEAD:arch/mips/loongson/common/Makefile
-obj-$(CONFIG_LOONGSON_UART_BASE) += uart_base.o
-=======
->>>>>>> FETCH_HEAD:arch/mips/loongson/common/Makefile
 
 #
 # Enable CS5536 Virtual Support Module(VSM) to virtulize the PCI configure
diff -puN arch/mips/loongson/common/init.c~linux-next-git-rejects arch/mips/loongson/common/init.c
--- a/arch/mips/loongson/common/init.c~linux-next-git-rejects
+++ a/arch/mips/loongson/common/init.c
@@ -31,13 +31,9 @@ void __init prom_init(void)
 	prom_init_memory();
 
 	/*init the uart base address */
-<<<<<<< HEAD:arch/mips/loongson/common/init.c
-	prom_init_uart_base();
-=======
 #if defined(CONFIG_EARLY_PRINTK) || defined(CONFIG_SERIAL_8250)
 	prom_init_uart_base();
 #endif
->>>>>>> FETCH_HEAD:arch/mips/loongson/common/init.c
 }
 
 void __init prom_free_prom_memory(void)
diff -puN arch/mips/loongson/common/serial.c~linux-next-git-rejects arch/mips/loongson/common/serial.c
--- a/arch/mips/loongson/common/serial.c~linux-next-git-rejects
+++ a/arch/mips/loongson/common/serial.c
@@ -57,25 +57,12 @@ static struct platform_device uart8250_d
 
 static int __init serial_init(void)
 {
-<<<<<<< HEAD:arch/mips/loongson/common/serial.c
-	unsigned char iotype;
-
-	iotype = uart8250_data[mips_machtype][0].iotype;
-
-	if (UPIO_MEM == iotype)
-		uart8250_data[mips_machtype][0].membase =
-			(void __iomem *)_loongson_uart_base;
-	else if (UPIO_PORT == iotype)
-		uart8250_data[mips_machtype][0].iobase =
-		    loongson_uart_base - LOONGSON_PCIIO_BASE;
-=======
 	if (uart8250_data[mips_machtype][0].iotype == UPIO_MEM)
 		uart8250_data[mips_machtype][0].membase =
 			(void __iomem *)_loongson_uart_base;
 	else if (uart8250_data[mips_machtype][0].iotype == UPIO_PORT)
 		uart8250_data[mips_machtype][0].iobase =
 		    uart8250_base[mips_machtype] - LOONGSON_PCIIO_BASE;
->>>>>>> FETCH_HEAD:arch/mips/loongson/common/serial.c
 
 	uart8250_device.dev.platform_data = uart8250_data[mips_machtype];
 
diff -puN arch/mips/loongson/common/uart_base.c~linux-next-git-rejects arch/mips/loongson/common/uart_base.c
--- a/arch/mips/loongson/common/uart_base.c~linux-next-git-rejects
+++ a/arch/mips/loongson/common/uart_base.c
@@ -13,37 +13,6 @@
 
 #include <loongson.h>
 
-<<<<<<< HEAD:arch/mips/loongson/common/uart_base.c
-/* ioremapped */
-unsigned long _loongson_uart_base;
-EXPORT_SYMBOL(_loongson_uart_base);
-/* raw */
-unsigned long loongson_uart_base;
-EXPORT_SYMBOL(loongson_uart_base);
-
-void prom_init_loongson_uart_base(void)
-{
-	switch (mips_machtype) {
-	case MACH_LEMOTE_FL2E:
-		loongson_uart_base = LOONGSON_PCIIO_BASE + 0x3f8;
-		break;
-	case MACH_LEMOTE_FL2F:
-	case MACH_LEMOTE_LL2F:
-		loongson_uart_base = LOONGSON_PCIIO_BASE + 0x2f8;
-		break;
-	case MACH_LEMOTE_ML2F7:
-	case MACH_LEMOTE_YL2F89:
-	case MACH_DEXXON_GDIUM2F10:
-	case MACH_LEMOTE_NAS:
-	default:
-		/* The CPU provided serial port */
-		loongson_uart_base = LOONGSON_LIO1_BASE + 0x3f8;
-		break;
-	}
-
-	_loongson_uart_base =
-		(unsigned long)ioremap_nocache(loongson_uart_base, 8);
-=======
 unsigned long __maybe_unused _loongson_uart_base;
 EXPORT_SYMBOL(_loongson_uart_base);
 
@@ -64,5 +33,4 @@ void __maybe_unused prom_init_uart_base(
 {
 	_loongson_uart_base =
 		(unsigned long)ioremap_nocache(uart8250_base[mips_machtype], 8);
->>>>>>> FETCH_HEAD:arch/mips/loongson/common/uart_base.c
 }
diff -puN arch/mips/powertv/asic/asic_devices.c~linux-next-git-rejects arch/mips/powertv/asic/asic_devices.c
--- a/arch/mips/powertv/asic/asic_devices.c~linux-next-git-rejects
+++ a/arch/mips/powertv/asic/asic_devices.c
@@ -187,11 +187,7 @@ static void __init fs_update(int pe, int
 /*
  * Allow override of bootloader-specified model
  */
-<<<<<<< HEAD:arch/mips/powertv/asic/asic_devices.c
-static char __initdata cmdline[COMMAND_LINE_SIZE];
-=======
 static char __initdata cmdline[CL_SIZE];
->>>>>>> FETCH_HEAD:arch/mips/powertv/asic/asic_devices.c
 
 #define	FORCEFAMILY_PARAM	"forcefamily"
 
@@ -203,11 +199,7 @@ static __init int check_forcefamily(unsi
 	forced_family[1] = '\0';
 
 	/* Check the command line for a forcefamily directive */
-<<<<<<< HEAD:arch/mips/powertv/asic/asic_devices.c
-	strncpy(cmdline, arcs_cmdline, COMMAND_LINE_SIZE - 1);
-=======
 	strncpy(cmdline, arcs_cmdline, CL_SIZE - 1);
->>>>>>> FETCH_HEAD:arch/mips/powertv/asic/asic_devices.c
 	p = strstr(cmdline, FORCEFAMILY_PARAM);
 	if (p && (p != cmdline) && (*(p - 1) != ' '))
 		p = strstr(p, " " FORCEFAMILY_PARAM "=");
diff -puN arch/mips/powertv/cmdline.c~linux-next-git-rejects arch/mips/powertv/cmdline.c
--- a/arch/mips/powertv/cmdline.c~linux-next-git-rejects
+++ a/arch/mips/powertv/cmdline.c
@@ -48,9 +48,5 @@ void  __init prom_init_cmdline(void)
 	arcs_cmdline[len] = ' ';
 
 	strlcpy(arcs_cmdline + len + 1, (char *)_prom_argv,
-<<<<<<< HEAD:arch/mips/powertv/cmdline.c
-		COMMAND_LINE_SIZE - len - 1);
-=======
 		CL_SIZE - len - 1);
->>>>>>> FETCH_HEAD:arch/mips/powertv/cmdline.c
 }
diff -puN arch/mips/powertv/memory.c~linux-next-git-rejects arch/mips/powertv/memory.c
--- a/arch/mips/powertv/memory.c~linux-next-git-rejects
+++ a/arch/mips/powertv/memory.c
@@ -44,11 +44,7 @@
 
 unsigned long ptv_memsize;
 
-<<<<<<< HEAD:arch/mips/powertv/memory.c
-char __initdata cmdline[COMMAND_LINE_SIZE];
-=======
 char __initdata cmdline[CL_SIZE];
->>>>>>> FETCH_HEAD:arch/mips/powertv/memory.c
 
 void __init prom_meminit(void)
 {
diff -puN arch/mips/rb532/prom.c~linux-next-git-rejects arch/mips/rb532/prom.c
--- a/arch/mips/rb532/prom.c~linux-next-git-rejects
+++ a/arch/mips/rb532/prom.c
@@ -115,11 +115,7 @@ void __init prom_setup_cmdline(void)
 		strcpy(cp, arcs_cmdline);
 		cp += strlen(arcs_cmdline);
 	}
-<<<<<<< HEAD:arch/mips/rb532/prom.c
-	cmd_line[COMMAND_LINE_SIZE - 1] = '\0';
-=======
 	cmd_line[COMMAND_LINE_SIZE-1] = '\0';
->>>>>>> FETCH_HEAD:arch/mips/rb532/prom.c
 
 	strcpy(arcs_cmdline, cmd_line);
 }
diff -puN fs/exec.c~linux-next-git-rejects fs/exec.c
--- a/fs/exec.c~linux-next-git-rejects
+++ a/fs/exec.c
@@ -1768,10 +1768,6 @@ void do_coredump(long signr, int exit_co
 	int retval = 0;
 	int flag = 0;
 	int ispipe = 0;
-<<<<<<< HEAD:fs/exec.c
-=======
-	unsigned long core_limit = rlimit(RLIMIT_CORE);
->>>>>>> FETCH_HEAD:fs/exec.c
 	char **helper_argv = NULL;
 	int helper_argc = 0;
 	int dump_count = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kfifo-move-struct-kfifo-in-place-fix.patch
linux-next.patch
linux-next-fixup.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-tools-chkobjdumpawk-fix-it.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
drivers-leds-leds-ss4200c-fix-return-statement.patch
net-sctp-socketc-fix-warning.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
fs-ext4-superc-fix-printk-warning.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
scsi-aacraid-fix-memory-leak-checkpatch-fixes.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
fs-improve-remountro-vs-buffercache-coherency.patch
drivers-net-wireless-iwlwifi-iwl-txc-fix-gcc-345-warning.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array.patch
char-cyclades-fix-compiler-warning.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
lib-add-support-for-lzo-compressed-kernels.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

