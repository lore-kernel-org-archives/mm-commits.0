From: akpm@linux-foundation.org
Subject: - fix-amd64-agp-aperture-validation.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:39:40 -0700
Message-ID: <200703292339.l2TNdenJ015449@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43249 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945951AbXC2Xjy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:39:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, ak@suse.de, davej@codemonkey.org.uk, mark.langsdorf@amd.com, mm-commits@vger.kernel.org


The patch titled
     fix amd64-agp aperture validation
has been removed from the -mm tree.  Its filename was
     fix-amd64-agp-aperture-validation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix amd64-agp aperture validation
From: "Jan Beulich" <jbeulich@novell.com>

Under CONFIG_DISCONTIGMEM, assuming that a !pfn_valid() implies all
subsequent pfn-s are also invalid is wrong.  Thus replace this by
explicitly checking against the E820 map.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/e820.c      |   20 ++++++++++++++++++++
 arch/x86_64/kernel/e820.c    |    3 ++-
 drivers/char/agp/amd64-agp.c |   13 ++++---------
 include/asm-i386/e820.h      |    1 +
 4 files changed, 27 insertions(+), 10 deletions(-)

diff -puN arch/i386/kernel/e820.c~fix-amd64-agp-aperture-validation arch/i386/kernel/e820.c
--- a/arch/i386/kernel/e820.c~fix-amd64-agp-aperture-validation
+++ a/arch/i386/kernel/e820.c
@@ -818,6 +818,26 @@ void __init limit_regions(unsigned long 
 	print_memory_map("limit_regions endfunc");
 }
 
+/*
+ * This function checks if any part of the range <start,end> is mapped
+ * with type.
+ */
+int
+e820_any_mapped(u64 start, u64 end, unsigned type)
+{
+	int i;
+	for (i = 0; i < e820.nr_map; i++) {
+		const struct e820entry *ei = &e820.map[i];
+		if (type && ei->type != type)
+			continue;
+		if (ei->addr >= end || ei->addr + ei->size <= start)
+			continue;
+		return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(e820_any_mapped);
+
  /*
   * This function checks if the entire range <start,end> is mapped with type.
   *
diff -puN arch/x86_64/kernel/e820.c~fix-amd64-agp-aperture-validation arch/x86_64/kernel/e820.c
--- a/arch/x86_64/kernel/e820.c~fix-amd64-agp-aperture-validation
+++ a/arch/x86_64/kernel/e820.c
@@ -98,7 +98,7 @@ static inline int bad_addr(unsigned long
  * This function checks if any part of the range <start,end> is mapped
  * with type.
  */
-int __meminit
+int
 e820_any_mapped(unsigned long start, unsigned long end, unsigned type)
 { 
 	int i;
@@ -112,6 +112,7 @@ e820_any_mapped(unsigned long start, uns
 	} 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(e820_any_mapped);
 
 /*
  * This function checks if the entire range <start,end> is mapped with type.
diff -puN drivers/char/agp/amd64-agp.c~fix-amd64-agp-aperture-validation drivers/char/agp/amd64-agp.c
--- a/drivers/char/agp/amd64-agp.c~fix-amd64-agp-aperture-validation
+++ a/drivers/char/agp/amd64-agp.c
@@ -14,6 +14,7 @@
 #include <linux/agp_backend.h>
 #include <linux/mmzone.h>
 #include <asm/page.h>		/* PAGE_SIZE */
+#include <asm/e820.h>
 #include <asm/k8.h>
 #include "agp.h"
 
@@ -259,7 +260,6 @@ static const struct agp_bridge_driver am
 /* Some basic sanity checks for the aperture. */
 static int __devinit aperture_valid(u64 aper, u32 size)
 {
-	u32 pfn, c;
 	if (aper == 0) {
 		printk(KERN_ERR PFX "No aperture\n");
 		return 0;
@@ -272,14 +272,9 @@ static int __devinit aperture_valid(u64 
 		printk(KERN_ERR PFX "Aperture out of bounds\n");
 		return 0;
 	}
-	pfn = aper >> PAGE_SHIFT;
-	for (c = 0; c < size/PAGE_SIZE; c++) {
-		if (!pfn_valid(pfn + c))
-			break;
-		if (!PageReserved(pfn_to_page(pfn + c))) {
-			printk(KERN_ERR PFX "Aperture pointing to RAM\n");
-			return 0;
-		}
+	if (e820_any_mapped(aper, aper + size, E820_RAM)) {
+		printk(KERN_ERR PFX "Aperture pointing to RAM\n");
+		return 0;
 	}
 
 	/* Request the Aperture. This catches cases when someone else
diff -puN include/asm-i386/e820.h~fix-amd64-agp-aperture-validation include/asm-i386/e820.h
--- a/include/asm-i386/e820.h~fix-amd64-agp-aperture-validation
+++ a/include/asm-i386/e820.h
@@ -38,6 +38,7 @@ extern struct e820map e820;
 
 extern int e820_all_mapped(unsigned long start, unsigned long end,
 			   unsigned type);
+extern int e820_any_mapped(u64 start, u64 end, unsigned type);
 extern void find_max_pfn(void);
 extern void register_bootmem_low_pages(unsigned long max_low_pfn);
 extern void e820_register_memory(void);
_

Patches currently in -mm which might be from jbeulich@novell.com are

remove-pci_dac_dma_-apis.patch
use-stop_machine_run-in-the-intel-rng-driver.patch
