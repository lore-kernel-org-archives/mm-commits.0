From: akpm@linux-foundation.org
Subject: - i386-x86_64-trim-memory-not-covered-by-wb-mtrrs.patch removed from -mm tree
Date: Mon, 25 Jun 2007 14:55:28 -0700
Message-ID: <200706252155.l5PLtST6011771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49825 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756597AbXFYV46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 17:56:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesse.barnes@intel.com, ak@suse.de, jpiszcz@lucidpixels.com, mm-commits@vger.kernel.org


The patch titled
     i386/x86_64: trim memory not covered by WB MTRRs
has been removed from the -mm tree.  Its filename was
     i386-x86_64-trim-memory-not-covered-by-wb-mtrrs.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: i386/x86_64: trim memory not covered by WB MTRRs
From: Jesse Barnes <jesse.barnes@intel.com>

On some machines, buggy BIOSes don't properly setup WB MTRRs to cover all
available RAM, meaning the last few megs (or even gigs) of memory will be
marked uncached.  Since Linux tends to allocate from high memory addresses
first, this causes the machine to be unusably slow as soon as the kernel
starts really using memory (i.e.  right around init time).

This patch works around the problem by scanning the MTRRs at boot and
figuring out whether the current end_pfn value (setup by early e820 code)
goes beyond the highest WB MTRR range, and if so, trimming it to match.  A
fairly obnoxious KERN_WARNING is printed too, letting the user know that
not all of their memory is available due to a likely BIOS bug.

Something similar could be done on i386 if needed, but the boot ordering
would be slightly different, since the MTRR code on i386 depends on the
boot_cpu_data structure being setup.

Signed-off-by: Jesse Barnes <jesse.barnes@intel.com>
Tested-by: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/generic.c |    8 ---
 arch/i386/kernel/cpu/mtrr/if.c      |    2 
 arch/i386/kernel/cpu/mtrr/main.c    |   55 +++++++++++++++++++-------
 arch/i386/kernel/cpu/mtrr/mtrr.h    |    1 
 arch/x86_64/kernel/bugs.c           |    1 
 arch/x86_64/kernel/setup.c          |    4 +
 include/asm-x86_64/mtrr.h           |    5 +-
 7 files changed, 52 insertions(+), 24 deletions(-)

diff -puN arch/i386/kernel/cpu/mtrr/generic.c~i386-x86_64-trim-memory-not-covered-by-wb-mtrrs arch/i386/kernel/cpu/mtrr/generic.c
--- a/arch/i386/kernel/cpu/mtrr/generic.c~i386-x86_64-trim-memory-not-covered-by-wb-mtrrs
+++ a/arch/i386/kernel/cpu/mtrr/generic.c
@@ -13,7 +13,7 @@
 #include "mtrr.h"
 
 struct mtrr_state {
-	struct mtrr_var_range *var_ranges;
+	struct mtrr_var_range var_ranges[NUM_VAR_RANGES];
 	mtrr_type fixed_ranges[NUM_FIXED_RANGES];
 	unsigned char enabled;
 	unsigned char have_fixed;
@@ -87,12 +87,6 @@ void __init get_mtrr_state(void)
 	if (!num_var_ranges)
 		return;
 
-	if (!mtrr_state.var_ranges) {
-		mtrr_state.var_ranges = kmalloc(num_var_ranges * sizeof (struct mtrr_var_range), 
-						GFP_KERNEL);
-		if (!mtrr_state.var_ranges)
-			return;
-	} 
 	vrs = mtrr_state.var_ranges;
 
 	rdmsr(MTRRcap_MSR, lo, dummy);
diff -puN arch/i386/kernel/cpu/mtrr/if.c~i386-x86_64-trim-memory-not-covered-by-wb-mtrrs arch/i386/kernel/cpu/mtrr/if.c
--- a/arch/i386/kernel/cpu/mtrr/if.c~i386-x86_64-trim-memory-not-covered-by-wb-mtrrs
+++ a/arch/i386/kernel/cpu/mtrr/if.c
@@ -12,7 +12,7 @@
 #include "mtrr.h"
 
 /* RED-PEN: this is accessed without any locking */
-extern unsigned int *usage_table;
+extern unsigned int usage_table[];
 
 
 #define FILE_FCOUNT(f) (((struct seq_file *)((f)->private_data))->private)
diff -puN arch/i386/kernel/cpu/mtrr/main.c~i386-x86_64-trim-memory-not-covered-by-wb-mtrrs arch/i386/kernel/cpu/mtrr/main.c
--- a/arch/i386/kernel/cpu/mtrr/main.c~i386-x86_64-trim-memory-not-covered-by-wb-mtrrs
+++ a/arch/i386/kernel/cpu/mtrr/main.c
@@ -38,8 +38,8 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 
+#include <asm/e820.h>
 #include <asm/mtrr.h>
-
 #include <asm/uaccess.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
@@ -47,7 +47,7 @@
 
 u32 num_var_ranges = 0;
 
-unsigned int *usage_table;
+unsigned int usage_table[NUM_VAR_RANGES];
 static DEFINE_MUTEX(mtrr_mutex);
 
 u64 size_or_mask, size_and_mask;
@@ -126,11 +126,6 @@ static void __init init_table(void)
 	}
 
 	max = num_var_ranges;
-	if ((usage_table = kmalloc(max * sizeof *usage_table, GFP_KERNEL))
-	    == NULL) {
-		printk(KERN_ERR "mtrr: could not allocate\n");
-		return;
-	}
 	for (i = 0; i < max; i++)
 		usage_table[i] = 1;
 }
@@ -594,16 +589,11 @@ struct mtrr_value {
 	unsigned long	lsize;
 };
 
-static struct mtrr_value * mtrr_state;
+static struct mtrr_value mtrr_state[NUM_VAR_RANGES];
 
 static int mtrr_save(struct sys_device * sysdev, pm_message_t state)
 {
 	int i;
-	int size = num_var_ranges * sizeof(struct mtrr_value);
-
-	mtrr_state = kzalloc(size,GFP_ATOMIC);
-	if (!mtrr_state)
-		return -ENOMEM;
 
 	for (i = 0; i < num_var_ranges; i++) {
 		mtrr_if->get(i,
@@ -625,7 +615,6 @@ static int mtrr_restore(struct sys_devic
 				 mtrr_state[i].lsize,
 				 mtrr_state[i].ltype);
 	}
-	kfree(mtrr_state);
 	return 0;
 }
 
@@ -636,6 +625,44 @@ static struct sysdev_driver mtrr_sysdev_
 	.resume		= mtrr_restore,
 };
 
+#ifdef CONFIG_X86_64
+/**
+ * mtrr_trim_uncached_memory - trim RAM not covered by MTRRs
+ *
+ * Some buggy BIOSes don't setup the MTRRs properly for systems with certain
+ * memory configurations.  This routine checks to make sure the MTRRs having
+ * a write back type cover all of the memory the kernel is intending to use.
+ * If not, it'll trim any memory off the end by adjusting end_pfn, removing
+ * it from the kernel's allocation pools, warning the user with an obnoxious
+ * message.
+ */
+void __init mtrr_trim_uncached_memory(void)
+{
+	unsigned long i, base, size, highest_addr = 0;
+	mtrr_type type;
+
+	/* Find highest cached pfn */
+	for (i = 0; i < num_var_ranges; i++) {
+		mtrr_if->get(i, &base, &size, &type);
+		if (type != MTRR_TYPE_WRBACK)
+			continue;
+		base <<= PAGE_SHIFT;
+		size <<= PAGE_SHIFT;
+		if (highest_addr < base + size)
+			highest_addr = base + size;
+	}
+
+	if ((highest_addr >> PAGE_SHIFT) != end_pfn) {
+		printk(KERN_WARNING "***************\n");
+		printk(KERN_WARNING "**** WARNING: likely BIOS bug\n");
+		printk(KERN_WARNING "**** MTRRs don't cover all of "
+		       "memory, trimmed %ld pages\n", end_pfn -
+		       (highest_addr >> PAGE_SHIFT));
+		printk(KERN_WARNING "***************\n");
+		end_pfn = highest_addr >> PAGE_SHIFT;
+	}
+}
+#endif
 
 /**
  * mtrr_bp_init - initialize mtrrs on the boot CPU
diff -puN arch/i386/kernel/cpu/mtrr/mtrr.h~i386-x86_64-trim-memory-not-covered-by-wb-mtrrs arch/i386/kernel/cpu/mtrr/mtrr.h
--- a/arch/i386/kernel/cpu/mtrr/mtrr.h~i386-x86_64-trim-memory-not-covered-by-wb-mtrrs
+++ a/arch/i386/kernel/cpu/mtrr/mtrr.h
@@ -14,6 +14,7 @@
 #define MTRRphysMask_MSR(reg) (0x200 + 2 * (reg) + 1)
 
 #define NUM_FIXED_RANGES 88
+#define NUM_VAR_RANGES 256
 #define MTRRfix64K_00000_MSR 0x250
 #define MTRRfix16K_80000_MSR 0x258
 #define MTRRfix16K_A0000_MSR 0x259
diff -puN arch/x86_64/kernel/bugs.c~i386-x86_64-trim-memory-not-covered-by-wb-mtrrs arch/x86_64/kernel/bugs.c
--- a/arch/x86_64/kernel/bugs.c~i386-x86_64-trim-memory-not-covered-by-wb-mtrrs
+++ a/arch/x86_64/kernel/bugs.c
@@ -14,7 +14,6 @@
 void __init check_bugs(void)
 {
 	identify_cpu(&boot_cpu_data);
-	mtrr_bp_init();
 #if !defined(CONFIG_SMP)
 	printk("CPU: ");
 	print_cpu_info(&boot_cpu_data);
diff -puN arch/x86_64/kernel/setup.c~i386-x86_64-trim-memory-not-covered-by-wb-mtrrs arch/x86_64/kernel/setup.c
--- a/arch/x86_64/kernel/setup.c~i386-x86_64-trim-memory-not-covered-by-wb-mtrrs
+++ a/arch/x86_64/kernel/setup.c
@@ -266,6 +266,10 @@ void __init setup_arch(char **cmdline_p)
 	 * we are rounding upwards:
 	 */
 	end_pfn = e820_end_of_ram();
+	/* Trim memory not covered by WB MTRRs */
+	mtrr_bp_init();
+	mtrr_trim_uncached_memory();
+
 	num_physpages = end_pfn;
 
 	check_efer();
diff -puN include/asm-x86_64/mtrr.h~i386-x86_64-trim-memory-not-covered-by-wb-mtrrs include/asm-x86_64/mtrr.h
--- a/include/asm-x86_64/mtrr.h~i386-x86_64-trim-memory-not-covered-by-wb-mtrrs
+++ a/include/asm-x86_64/mtrr.h
@@ -78,6 +78,7 @@ extern int mtrr_add_page (unsigned long 
 		     unsigned int type, char increment);
 extern int mtrr_del (int reg, unsigned long base, unsigned long size);
 extern int mtrr_del_page (int reg, unsigned long base, unsigned long size);
+extern void mtrr_trim_uncached_memory(void);
 #  else
 static __inline__ int mtrr_add (unsigned long base, unsigned long size,
 				unsigned int type, char increment)
@@ -99,7 +100,9 @@ static __inline__ int mtrr_del_page (int
 {
     return -ENODEV;
 }
-
+static inline void mtrr_trim_uncached_memory(void)
+{
+}
 #endif /* CONFIG_MTRR */
 
 #ifdef CONFIG_COMPAT
_

Patches currently in -mm which might be from jesse.barnes@intel.com are

remove-pci_dac_dma_-apis.patch
pci-disable-decode-of-io-memory-during-bar-sizing.patch
i386-trim-memory-not-covered-by-wb-mtrrs.patch
i386-x86_64-trim-memory-not-covered-by-wb-mtrrs.patch
i386-mtrr-clean-up-usage_table.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer-fix.patch
vt-add-comment-for-unbind_con_driver.patch
