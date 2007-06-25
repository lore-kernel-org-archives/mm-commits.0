From: akpm@linux-foundation.org
Subject: + i386-trim-memory-not-covered-by-wb-mtrrs.patch added to -mm tree
Date: Mon, 25 Jun 2007 15:37:17 -0700
Message-ID: <200706252237.l5PMbIQ3012724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36773 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755AbXFYWiv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 18:38:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesse.barnes@intel.com, andi@firstfloor.org, ebiederm@xmission.com, jpiszcz@lucidpixels.com, yhlu.kernel@gmail.com


The patch titled
     i386: trim memory not covered by WB MTRRs
has been added to the -mm tree.  Its filename is
     i386-trim-memory-not-covered-by-wb-mtrrs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: trim memory not covered by WB MTRRs
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

This patch fixes a bug in the last patch that caused the code to run on
non-Intel machines (AMD machines apparently don't need it and it's untested
on other non-Intel machines, so best keep it off).

Signed-off-by: Jesse Barnes <jesse.barnes@intel.com>
Tested-by: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    6 +
 arch/i386/kernel/cpu/mtrr/generic.c |    8 --
 arch/i386/kernel/cpu/mtrr/if.c      |    8 --
 arch/i386/kernel/cpu/mtrr/main.c    |   85 +++++++++++++++++++-------
 arch/i386/kernel/cpu/mtrr/mtrr.h    |    3 
 arch/x86_64/kernel/bugs.c           |    1 
 arch/x86_64/kernel/setup.c          |    4 +
 include/asm-x86_64/mtrr.h           |    5 +
 8 files changed, 84 insertions(+), 36 deletions(-)

diff -puN Documentation/kernel-parameters.txt~i386-trim-memory-not-covered-by-wb-mtrrs Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~i386-trim-memory-not-covered-by-wb-mtrrs
+++ a/Documentation/kernel-parameters.txt
@@ -553,6 +553,12 @@ and is between 256 and 4096 characters. 
 			See drivers/char/README.epca and
 			Documentation/digiepca.txt.
 
+	disable_mtrr_trim [X86-64, Intel only]
+			By default the kernel will trim any uncacheable
+			memory out of your available memory pool based on
+			MTRR settings.  This parameter disables that behavior,
+			possibly causing your machine to run very slowly.
+
 	dmascc=		[HW,AX25,SERIAL] AX.25 Z80SCC driver with DMA
 			support available.
 			Format: <io_dev0>[,<io_dev1>[,..<io_dev32>]]
diff -puN arch/i386/kernel/cpu/mtrr/generic.c~i386-trim-memory-not-covered-by-wb-mtrrs arch/i386/kernel/cpu/mtrr/generic.c
--- a/arch/i386/kernel/cpu/mtrr/generic.c~i386-trim-memory-not-covered-by-wb-mtrrs
+++ a/arch/i386/kernel/cpu/mtrr/generic.c
@@ -13,7 +13,7 @@
 #include "mtrr.h"
 
 struct mtrr_state {
-	struct mtrr_var_range *var_ranges;
+	struct mtrr_var_range var_ranges[MAX_VAR_RANGES];
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
diff -puN arch/i386/kernel/cpu/mtrr/if.c~i386-trim-memory-not-covered-by-wb-mtrrs arch/i386/kernel/cpu/mtrr/if.c
--- a/arch/i386/kernel/cpu/mtrr/if.c~i386-trim-memory-not-covered-by-wb-mtrrs
+++ a/arch/i386/kernel/cpu/mtrr/if.c
@@ -11,10 +11,6 @@
 #include <asm/mtrr.h>
 #include "mtrr.h"
 
-/* RED-PEN: this is accessed without any locking */
-extern unsigned int *usage_table;
-
-
 #define FILE_FCOUNT(f) (((struct seq_file *)((f)->private_data))->private)
 
 static const char *const mtrr_strings[MTRR_NUM_TYPES] =
@@ -396,7 +392,7 @@ static int mtrr_seq_show(struct seq_file
 	for (i = 0; i < max; i++) {
 		mtrr_if->get(i, &base, &size, &type);
 		if (size == 0)
-			usage_table[i] = 0;
+			mtrr_usage_table[i] = 0;
 		else {
 			if (size < (0x100000 >> PAGE_SHIFT)) {
 				/* less than 1MB */
@@ -410,7 +406,7 @@ static int mtrr_seq_show(struct seq_file
 			len += seq_printf(seq, 
 				   "reg%02i: base=0x%05lx000 (%4luMB), size=%4lu%cB: %s, count=%d\n",
 			     i, base, base >> (20 - PAGE_SHIFT), size, factor,
-			     mtrr_attrib_to_str(type), usage_table[i]);
+			     mtrr_attrib_to_str(type), mtrr_usage_table[i]);
 		}
 	}
 	return 0;
diff -puN arch/i386/kernel/cpu/mtrr/main.c~i386-trim-memory-not-covered-by-wb-mtrrs arch/i386/kernel/cpu/mtrr/main.c
--- a/arch/i386/kernel/cpu/mtrr/main.c~i386-trim-memory-not-covered-by-wb-mtrrs
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
+unsigned int mtrr_usage_table[MAX_VAR_RANGES];
 static DEFINE_MUTEX(mtrr_mutex);
 
 u64 size_or_mask, size_and_mask;
@@ -126,13 +126,8 @@ static void __init init_table(void)
 	}
 
 	max = num_var_ranges;
-	if ((usage_table = kmalloc(max * sizeof *usage_table, GFP_KERNEL))
-	    == NULL) {
-		printk(KERN_ERR "mtrr: could not allocate\n");
-		return;
-	}
 	for (i = 0; i < max; i++)
-		usage_table[i] = 1;
+		mtrr_usage_table[i] = 1;
 }
 
 struct set_mtrr_data {
@@ -386,7 +381,7 @@ int mtrr_add_page(unsigned long base, un
 			goto out;
 		}
 		if (increment)
-			++usage_table[i];
+			++mtrr_usage_table[i];
 		error = i;
 		goto out;
 	}
@@ -395,12 +390,13 @@ int mtrr_add_page(unsigned long base, un
 	if (i >= 0) {
 		set_mtrr(i, base, size, type);
 		if (likely(replace < 0))
-			usage_table[i] = 1;
+			mtrr_usage_table[i] = 1;
 		else {
-			usage_table[i] = usage_table[replace] + !!increment;
+			mtrr_usage_table[i] = mtrr_usage_table[replace] +
+				!!increment;
 			if (unlikely(replace != i)) {
 				set_mtrr(replace, 0, 0, 0);
-				usage_table[replace] = 0;
+				mtrr_usage_table[replace] = 0;
 			}
 		}
 	} else
@@ -530,11 +526,11 @@ int mtrr_del_page(int reg, unsigned long
 		printk(KERN_WARNING "mtrr: MTRR %d not used\n", reg);
 		goto out;
 	}
-	if (usage_table[reg] < 1) {
+	if (mtrr_usage_table[reg] < 1) {
 		printk(KERN_WARNING "mtrr: reg: %d has count=0\n", reg);
 		goto out;
 	}
-	if (--usage_table[reg] < 1)
+	if (--mtrr_usage_table[reg] < 1)
 		set_mtrr(reg, 0, 0, 0);
 	error = reg;
  out:
@@ -594,16 +590,11 @@ struct mtrr_value {
 	unsigned long	lsize;
 };
 
-static struct mtrr_value * mtrr_state;
+static struct mtrr_value mtrr_state[MAX_VAR_RANGES];
 
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
@@ -625,7 +616,6 @@ static int mtrr_restore(struct sys_devic
 				 mtrr_state[i].lsize,
 				 mtrr_state[i].ltype);
 	}
-	kfree(mtrr_state);
 	return 0;
 }
 
@@ -636,6 +626,59 @@ static struct sysdev_driver mtrr_sysdev_
 	.resume		= mtrr_restore,
 };
 
+static int disable_mtrr_trim;
+
+static int __init disable_mtrr_trim_setup(char *str)
+{
+	disable_mtrr_trim = 1;
+	return 0;
+}
+early_param("disable_mtrr_trim", disable_mtrr_trim_setup);
+
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
+	unsigned long i, base, size, highest_addr = 0, def, dummy;
+	mtrr_type type;
+
+	/* Make sure we only trim uncachable memory on Intel machines */
+	rdmsr(MTRRdefType_MSR, def, dummy);
+	def &= 0xff;
+	if (!is_cpu(INTEL) || disable_mtrr_trim || def != MTRR_TYPE_UNCACHABLE)
+		return;
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
diff -puN arch/i386/kernel/cpu/mtrr/mtrr.h~i386-trim-memory-not-covered-by-wb-mtrrs arch/i386/kernel/cpu/mtrr/mtrr.h
--- a/arch/i386/kernel/cpu/mtrr/mtrr.h~i386-trim-memory-not-covered-by-wb-mtrrs
+++ a/arch/i386/kernel/cpu/mtrr/mtrr.h
@@ -14,6 +14,7 @@
 #define MTRRphysMask_MSR(reg) (0x200 + 2 * (reg) + 1)
 
 #define NUM_FIXED_RANGES 88
+#define MAX_VAR_RANGES 256
 #define MTRRfix64K_00000_MSR 0x250
 #define MTRRfix16K_80000_MSR 0x258
 #define MTRRfix16K_A0000_MSR 0x259
@@ -34,6 +35,8 @@
    an 8 bit field: */
 typedef u8 mtrr_type;
 
+extern unsigned int mtrr_usage_table[MAX_VAR_RANGES];
+
 struct mtrr_ops {
 	u32	vendor;
 	u32	use_intel_if;
diff -puN arch/x86_64/kernel/bugs.c~i386-trim-memory-not-covered-by-wb-mtrrs arch/x86_64/kernel/bugs.c
--- a/arch/x86_64/kernel/bugs.c~i386-trim-memory-not-covered-by-wb-mtrrs
+++ a/arch/x86_64/kernel/bugs.c
@@ -14,7 +14,6 @@
 void __init check_bugs(void)
 {
 	identify_cpu(&boot_cpu_data);
-	mtrr_bp_init();
 #if !defined(CONFIG_SMP)
 	printk("CPU: ");
 	print_cpu_info(&boot_cpu_data);
diff -puN arch/x86_64/kernel/setup.c~i386-trim-memory-not-covered-by-wb-mtrrs arch/x86_64/kernel/setup.c
--- a/arch/x86_64/kernel/setup.c~i386-trim-memory-not-covered-by-wb-mtrrs
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
diff -puN include/asm-x86_64/mtrr.h~i386-trim-memory-not-covered-by-wb-mtrrs include/asm-x86_64/mtrr.h
--- a/include/asm-x86_64/mtrr.h~i386-trim-memory-not-covered-by-wb-mtrrs
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
+static __inline__ void mtrr_trim_uncached_memory(void)
+{
+}
 #endif /* CONFIG_MTRR */
 
 #ifdef CONFIG_COMPAT
_

Patches currently in -mm which might be from jesse.barnes@intel.com are

remove-pci_dac_dma_-apis.patch
pci-disable-decode-of-io-memory-during-bar-sizing.patch
i386-trim-memory-not-covered-by-wb-mtrrs.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer-fix.patch
vt-add-comment-for-unbind_con_driver.patch
