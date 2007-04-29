From: akpm@linux-foundation.org
Subject: + blackfin-arch-move-revid-function-into-global-headers-as-inline-functions.patch added to -mm tree
Date: Sun, 29 Apr 2007 01:31:38 -0700
Message-ID: <200704290831.l3T8Vc1N012087@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755055AbXD2IcM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Apr 2007 04:32:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com


The patch titled
     blackfin arch: move revid function into global headers as inline functions
has been added to the -mm tree.  Its filename is
     blackfin-arch-move-revid-function-into-global-headers-as-inline-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: blackfin arch: move revid function into global headers as inline functions
From: Bryan Wu <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/setup.c            |   70 +++++-----------------
 include/asm-blackfin/mach-bf533/bf533.h |    2 
 include/asm-blackfin/mach-bf537/bf537.h |    2 
 include/asm-blackfin/mach-bf561/bf561.h |    2 
 include/asm-blackfin/processor.h        |   25 +++++++
 5 files changed, 44 insertions(+), 57 deletions(-)

diff -puN arch/blackfin/kernel/setup.c~blackfin-arch-move-revid-function-into-global-headers-as-inline-functions arch/blackfin/kernel/setup.c
--- a/arch/blackfin/kernel/setup.c~blackfin-arch-move-revid-function-into-global-headers-as-inline-functions
+++ a/arch/blackfin/kernel/setup.c
@@ -121,34 +121,6 @@ void bf53x_relocate_l1_mem(void)
 
 }
 
-/* Get the DSP Revision ID */
-static u_int get_dsp_rev_id(void)
-{
-	u_int id;
-	id = bfin_read_DSPID() & 0xffff;
-#if defined(CONFIG_BF561)
-	id>>=8;
-#endif
-	return id;
-}
-
-static inline u_int get_compiled_rev_id(void)
-{
-#if defined(CONFIG_BF_REV_0_0)
-	return 0;
-#elif defined(CONFIG_BF_REV_0_1)
-	return 1;
-#elif defined(CONFIG_BF_REV_0_2)
-	return 2;
-#elif defined(CONFIG_BF_REV_0_3)
-	return 3;
-#elif defined(CONFIG_BF_REV_0_4)
-	return 4;
-#elif defined(CONFIG_BF_REV_0_5)
-	return 5;
-#endif
-}
-
 /*
  * Initial parsing of the command line.  Currently, we support:
  *  - Controlling the linux memory size: mem=xxx[KMG]
@@ -196,7 +168,7 @@ static __init void parse_cmdline_early(c
 
 void __init setup_arch(char **cmdline_p)
 {
-	int bootmap_size, id;
+	int bootmap_size;
 	unsigned long l1_length, sclk, cclk;
 #ifdef CONFIG_MTD_UCLINUX
 	unsigned long mtd_phys = 0;
@@ -329,30 +301,23 @@ void __init setup_arch(char **cmdline_p)
 	init_mm.brk = (unsigned long)0;
 
 	init_leds();
-	id = get_dsp_rev_id();
 
-	printk(KERN_INFO
-	       "Blackfin support (C) 2004-2006 Analog Devices, Inc.\n");
-	printk(KERN_INFO "Compiled for ADSP-%s Rev. 0.%d\n", CPU,
-	       get_compiled_rev_id());
-	if (id != get_compiled_rev_id())
-		printk(KERN_ERR
-		       "Warning: Compiled for Rev %d, but running on Rev %d\n",
-			get_compiled_rev_id(), id );
-	if (id < SUPPORTED_DSPID)
-		printk(KERN_ERR
-		       "Warning: Unsupported Chip Revision ADSP-%s Rev. 0.%d detected\n",
-		       CPU, id);
-	printk(KERN_INFO
-	       "Blackfin uClinux support by http://blackfin.uclinux.org/\n");
+	printk(KERN_INFO "Blackfin support (C) 2004-2007 Analog Devices, Inc.\n");
+	printk(KERN_INFO "Compiled for ADSP-%s Rev 0.%d\n", CPU, bfin_compiled_revid());
+	if (bfin_revid() != bfin_compiled_revid())
+		printk(KERN_ERR "Warning: Compiled for Rev %d, but running on Rev %d\n",
+		       bfin_compiled_revid(), bfin_revid());
+	if (bfin_revid() < SUPPORTED_REVID)
+		printk(KERN_ERR "Warning: Unsupported Chip Revision ADSP-%s Rev 0.%d detected\n",
+		       CPU, bfin_revid());
+	printk(KERN_INFO "Blackfin Linux support by http://blackfin.uclinux.org/\n");
 
 	printk(KERN_INFO "Processor Speed: %lu MHz core clock and %lu Mhz System Clock\n",
 	       cclk / 1000000,  sclk / 1000000);
 
 #if defined(ANOMALY_05000273)
 	if ((cclk >> 1) <= sclk)
-		printk(KERN_ERR
-		       "\n\n\nANOMALY_05000273: CCLK must be >= 2*SCLK !!!\n\n\n");
+		printk("\n\n\nANOMALY_05000273: CCLK must be >= 2*SCLK !!!\n\n\n");
 #endif
 
 	printk(KERN_INFO "Board Memory: %ldMB\n", physical_mem_end >> 20);
@@ -778,21 +743,19 @@ EXPORT_SYMBOL(get_sclk);
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
 	char *cpu, *mmu, *fpu, *name;
-#ifdef CONFIG_BLKFIN_CACHE_LOCK
-	int lock;
-#endif
+	uint32_t revid;
 
 	u_long cclk = 0, sclk = 0;
-	u_int id, dcache_size = 0, dsup_banks = 0;
+	u_int dcache_size = 0, dsup_banks = 0;
 
 	cpu = CPU;
 	mmu = "none";
 	fpu = "none";
+	revid = bfin_revid();
 	name = bfin_board_name;
 
 	cclk = get_cclk();
 	sclk = get_sclk();
-	id = get_dsp_rev_id();
 
 	seq_printf(m, "CPU:\t\tADSP-%s Rev. 0.%d\n"
 		   "MMU:\t\t%s\n"
@@ -801,7 +764,7 @@ static int show_cpuinfo(struct seq_file 
 		   "System Clock:\t%9lu Hz\n"
 		   "BogoMips:\t%lu.%02lu\n"
 		   "Calibration:\t%lu loops\n",
-		   cpu, id, mmu, fpu,
+		   cpu, revid, mmu, fpu,
 		   cclk,
 		   sclk,
 		   (loops_per_jiffy * HZ) / 500000,
@@ -856,8 +819,7 @@ static int show_cpuinfo(struct seq_file 
 		   dsup_banks, BLKFIN_DSUBBANKS, BLKFIN_DWAYS,
 		   BLKFIN_DLINES);
 #ifdef CONFIG_BLKFIN_CACHE_LOCK
-	lock = read_iloc();
-	switch (lock) {
+	switch (read_iloc()) {
 	case WAY0_L:
 		seq_printf(m, "Way0 Locked-Down\n");
 		break;
diff -puN include/asm-blackfin/mach-bf533/bf533.h~blackfin-arch-move-revid-function-into-global-headers-as-inline-functions include/asm-blackfin/mach-bf533/bf533.h
--- a/include/asm-blackfin/mach-bf533/bf533.h~blackfin-arch-move-revid-function-into-global-headers-as-inline-functions
+++ a/include/asm-blackfin/mach-bf533/bf533.h
@@ -30,7 +30,7 @@
 #ifndef __MACH_BF533_H__
 #define __MACH_BF533_H__
 
-#define SUPPORTED_DSPID 2
+#define SUPPORTED_REVID 2
 
 #define OFFSET_(x) ((x) & 0x0000FFFF)
 
diff -puN include/asm-blackfin/mach-bf537/bf537.h~blackfin-arch-move-revid-function-into-global-headers-as-inline-functions include/asm-blackfin/mach-bf537/bf537.h
--- a/include/asm-blackfin/mach-bf537/bf537.h~blackfin-arch-move-revid-function-into-global-headers-as-inline-functions
+++ a/include/asm-blackfin/mach-bf537/bf537.h
@@ -30,7 +30,7 @@
 #ifndef __MACH_BF537_H__
 #define __MACH_BF537_H__
 
-#define SUPPORTED_DSPID 2
+#define SUPPORTED_REVID 2
 
 /* Masks for generic ERROR IRQ demultiplexing used in int-priority-sc.c */
 
diff -puN include/asm-blackfin/mach-bf561/bf561.h~blackfin-arch-move-revid-function-into-global-headers-as-inline-functions include/asm-blackfin/mach-bf561/bf561.h
--- a/include/asm-blackfin/mach-bf561/bf561.h~blackfin-arch-move-revid-function-into-global-headers-as-inline-functions
+++ a/include/asm-blackfin/mach-bf561/bf561.h
@@ -30,7 +30,7 @@
 #ifndef __MACH_BF561_H__
 #define __MACH_BF561_H__
 
-#define SUPPORTED_DSPID		0x3
+#define SUPPORTED_REVID		0x3
 
 #define OFFSET_(x) ((x) & 0x0000FFFF)
 #define L1_ISRAM		0xFFA00000
diff -puN include/asm-blackfin/processor.h~blackfin-arch-move-revid-function-into-global-headers-as-inline-functions include/asm-blackfin/processor.h
--- a/include/asm-blackfin/processor.h~blackfin-arch-move-revid-function-into-global-headers-as-inline-functions
+++ a/include/asm-blackfin/processor.h
@@ -7,6 +7,7 @@
  */
 #define current_text_addr() ({ __label__ _l; _l: &&_l;})
 
+#include <asm/blackfin.h>
 #include <asm/segment.h>
 #include <linux/compiler.h>
 
@@ -102,4 +103,28 @@ unsigned long get_wchan(struct task_stru
 
 #define cpu_relax()    	barrier()
 
+/* Get the Silicon Revision of the chip */
+static inline uint32_t bfin_revid(void)
+{
+	/* stored in the upper 4 bits */
+	return bfin_read_CHIPID() >> 28;
+}
+
+static inline uint32_t bfin_compiled_revid(void)
+{
+#if defined(CONFIG_BF_REV_0_0)
+	return 0;
+#elif defined(CONFIG_BF_REV_0_1)
+	return 1;
+#elif defined(CONFIG_BF_REV_0_2)
+	return 2;
+#elif defined(CONFIG_BF_REV_0_3)
+	return 3;
+#elif defined(CONFIG_BF_REV_0_4)
+	return 4;
+#elif defined(CONFIG_BF_REV_0_5)
+	return 5;
+#endif
+}
+
 #endif
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-balance-parenthesis-in-macros.patch
blackfin-arch-2.6.21-rc4-mm1-update.patch
blackfin-arch-fix-struct-dmasg-packing-bug.patch
blackfin-arch-cleanup-cache-header-file.patch
blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-arch-fix-compiling-error-in-flat-c-file.patch
blackfin-arch-power-management-replace-firmware-disk-mode.patch
blackfin-arch-add-kdebug-header-file.patch
blackfin-arch-fix-bug-bf561-rev-id-are-8-bit.patch
blackfin-arch-fix-bug-prevent-warning-in-case-bf531-is-target.patch
blackfin-arch-fix-stamp537-isp1716-irq-setting-bug.patch
blackfin-arch-fix-bug-interrupt-setup-problem-request_irq.patch
blackfin-arch-pnav-and-bluetechnix-cm-bf537-use-the-mac.patch
blackfin-arch-always-include-linux-kallsysms-header-file.patch
blackfin-arch-sync-with-uclibc-no-functional-changes.patch
blackfin-arch-using-asm-generic-pgtable-header-file-by.patch
blackfin-arch-add-missing-__clear_user-function-to.patch
blackfin-arch-use-boot_command_line-instead-of.patch
blackfin-arch-fix-some-coding-style-in-include.patch
blackfin-arch-add-scm_timestampns-and-siocgstampns-to.patch
blackfin-arch-add-missing-blackfin-support-in-lib.patch
blackfin-arch-fix-bug-data-cannot-be-put-into-l1-data.patch
blackfin-arch-source-kernel-preemption-option.patch
blackfin-arch-workaround-bf561-anomaly-05000266.patch
blackfin-arch-define-a-new-cacheline_aligned-attribute-to-put-it-in-l1-data-memory-with-linkscript-update.patch
blackfin-arch-fix-bug-asserting-gpio-requested-doesnt-make-sense-with-gpio-whole-port-accesses.patch
blackfin-arch-04-and-05-silicon-doesnt-exist-for-bf534-bf536-adn-bf537-so-dont-let-people-select-the-option.patch
blackfin-arch-fix-coding-style-in-ints-priority-sc-c-file.patch
blackfin-arch-fix-bug-refuse-to-boot-if-rootfs-image-is-not-attached-when-mtd_uclinux-is-selected.patch
blackfin-arch-move-revid-function-into-global-headers-as-inline-functions.patch
blackfin-arch-need-linux-ttyh-header-for-console_init-prototype.patch
blackfin-arch-convert-most-blackfin-specific-spi-register-settings-to-common-spi-framework-settings.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-on-chip-ethernet-mac-controller-driver-update.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-on-chip-rtc-controller-driver-fix-rtc_update_irq-augument.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver-cleanup-and-coding-style-fixing.patch
blackfin-blackfin-on-chip-spi-controller-driver-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-serial-core-driver-uart1-should-depend-on-bf534-bf536-bf537-remove-experimental-marking-from-on-chip-serial-core-driver-and-make-options-less-wordy.patch
blackfin-spi-controller-driver-update-according-to-david-brownells-review.patch
move-die-notifier-handling-to-common-code-fix.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
