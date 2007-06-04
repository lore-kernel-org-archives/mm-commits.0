From: akpm@linux-foundation.org
Subject: - trim-memory-not-covered-by-mtrr-wb-type.patch removed from -mm tree
Date: Mon, 04 Jun 2007 13:01:29 -0700
Message-ID: <200706042001.l54K1TNI013661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56229 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759009AbXFDUBk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 16:01:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesse.barnes@intel.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386: trim memory not covered by MTRR WB type
has been removed from the -mm tree.  Its filename was
     trim-memory-not-covered-by-mtrr-wb-type.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: i386: trim memory not covered by MTRR WB type
From: Jesse Barnes <jesse.barnes@intel.com>

I've seen a few machines lately that don't map all their memory WB via the
MTRRs.  It tends to happen at large memory configurations (at least for
desktops, >3G or so), and is really a BIOS bug.  But it would be nice if
the kernel could warn the user and continue, rather than just run horribly
slowly.

This patch assumes that the unmapped memory occurs at the end of the memory
configuration, and adjusts end_pfn accordingly.  It works ok on my machine
(correctly detects the condition, adjusts end_pfn, and keeps the machine
fast), aside from the fact that X won't start.  So I obviously broke
something by making the MTRR system init so much earlier.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/main.c |   33 ++++++++++++++++++++++-------
 arch/x86_64/kernel/bugs.c        |    1 
 arch/x86_64/kernel/setup.c       |    4 +++
 include/asm-x86_64/mtrr.h        |    1 
 4 files changed, 31 insertions(+), 8 deletions(-)

diff -puN arch/i386/kernel/cpu/mtrr/main.c~trim-memory-not-covered-by-mtrr-wb-type arch/i386/kernel/cpu/mtrr/main.c
--- a/arch/i386/kernel/cpu/mtrr/main.c~trim-memory-not-covered-by-mtrr-wb-type
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
@@ -47,7 +47,8 @@
 
 u32 num_var_ranges = 0;
 
-unsigned int *usage_table;
+#define MAX_MTRR_RANGES 255
+unsigned int usage_table[MAX_MTRR_RANGES];
 static DEFINE_MUTEX(mtrr_mutex);
 
 u64 size_or_mask, size_and_mask;
@@ -126,11 +127,6 @@ static void __init init_table(void)
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
@@ -636,6 +632,29 @@ static struct sysdev_driver mtrr_sysdev_
 	.resume		= mtrr_restore,
 };
 
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
+		printk(KERN_WARNING "Warning:  MTRRs don't cover all of "
+		       "memory, trimmed %ld pages\n", end_pfn -
+		       (highest_addr >> PAGE_SHIFT));
+		end_pfn = highest_addr >> PAGE_SHIFT;
+	}
+}
 
 /**
  * mtrr_bp_init - initialize mtrrs on the boot CPU
diff -puN arch/x86_64/kernel/bugs.c~trim-memory-not-covered-by-mtrr-wb-type arch/x86_64/kernel/bugs.c
--- a/arch/x86_64/kernel/bugs.c~trim-memory-not-covered-by-mtrr-wb-type
+++ a/arch/x86_64/kernel/bugs.c
@@ -14,7 +14,6 @@
 void __init check_bugs(void)
 {
 	identify_cpu(&boot_cpu_data);
-	mtrr_bp_init();
 #if !defined(CONFIG_SMP)
 	printk("CPU: ");
 	print_cpu_info(&boot_cpu_data);
diff -puN arch/x86_64/kernel/setup.c~trim-memory-not-covered-by-mtrr-wb-type arch/x86_64/kernel/setup.c
--- a/arch/x86_64/kernel/setup.c~trim-memory-not-covered-by-mtrr-wb-type
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
diff -puN include/asm-x86_64/mtrr.h~trim-memory-not-covered-by-mtrr-wb-type include/asm-x86_64/mtrr.h
--- a/include/asm-x86_64/mtrr.h~trim-memory-not-covered-by-mtrr-wb-type
+++ a/include/asm-x86_64/mtrr.h
@@ -78,6 +78,7 @@ extern int mtrr_add_page (unsigned long 
 		     unsigned int type, char increment);
 extern int mtrr_del (int reg, unsigned long base, unsigned long size);
 extern int mtrr_del_page (int reg, unsigned long base, unsigned long size);
+extern void mtrr_trim_uncached_memory(void);
 #  else
 static __inline__ int mtrr_add (unsigned long base, unsigned long size,
 				unsigned int type, char increment)
_

Patches currently in -mm which might be from jesse.barnes@intel.com are

remove-pci_dac_dma_-apis.patch
trim-memory-not-covered-by-mtrr-wb-type.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer-fix.patch
vt-add-comment-for-unbind_con_driver.patch
