From: akpm@linux-foundation.org
Subject: + divorce-config_x86_pae-from-config_highmem64g.patch added to -mm tree
Date: Thu, 07 Jun 2007 23:03:09 -0700
Message-ID: <200706080603.l58639Tg020737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57454 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbXFHGDa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 02:03:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wli@holomorphy.com, ak@suse.de, lkml@rtr.ca


The patch titled
     i386: divorce CONFIG_X86_PAE from CONFIG_HIGHMEM64G
has been added to the -mm tree.  Its filename is
     divorce-config_x86_pae-from-config_highmem64g.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: divorce CONFIG_X86_PAE from CONFIG_HIGHMEM64G
From: William Lee Irwin III <wli@holomorphy.com>

PAE is useful for more than supporting more than 4GB RAM.  It supports
expanded swapspace and NX executable protections.  Some users may want NX
or expanded swapspace support without the overhead or instability of
highmem.  For these reasons, the following patch divorces CONFIG_X86_PAE
from CONFIG_HIGHMEM64G.

Cc: Mark Lord <lkml@rtr.ca>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: William Irwin <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig        |   16 +++++++++++-----
 arch/i386/kernel/setup.c |    8 ++++----
 2 files changed, 15 insertions(+), 9 deletions(-)

diff -puN arch/i386/Kconfig~divorce-config_x86_pae-from-config_highmem64g arch/i386/Kconfig
--- a/arch/i386/Kconfig~divorce-config_x86_pae-from-config_highmem64g
+++ a/arch/i386/Kconfig
@@ -544,6 +544,7 @@ config HIGHMEM4G
 config HIGHMEM64G
 	bool "64GB"
 	depends on X86_CMPXCHG64
+	select X86_PAE
 	help
 	  Select this if you have a 32-bit processor and more than 4
 	  gigabytes of physical RAM.
@@ -573,12 +574,12 @@ choice
 	config VMSPLIT_3G
 		bool "3G/1G user/kernel split"
 	config VMSPLIT_3G_OPT
-		depends on !HIGHMEM
+		depends on !X86_PAE
 		bool "3G/1G user/kernel split (for full 1G low memory)"
 	config VMSPLIT_2G
 		bool "2G/2G user/kernel split"
 	config VMSPLIT_2G_OPT
-		depends on !HIGHMEM
+		depends on !X86_PAE
 		bool "2G/2G user/kernel split (for full 2G low memory)"
 	config VMSPLIT_1G
 		bool "1G/3G user/kernel split"
@@ -598,10 +599,15 @@ config HIGHMEM
 	default y
 
 config X86_PAE
-	bool
-	depends on HIGHMEM64G
-	default y
+	bool "PAE (Physical Address Extension) Support"
+	default n
+	depends on !HIGHMEM4G
 	select RESOURCES_64BIT
+	help
+	  PAE is required for NX support, and furthermore enables
+	  larger swapspace support for non-overcommit purposes. It
+	  has the cost of more pagetable lookup overhead, and also
+	  consumes more pagetable space per process.
 
 # Common NUMA Features
 config NUMA
diff -puN arch/i386/kernel/setup.c~divorce-config_x86_pae-from-config_highmem64g arch/i386/kernel/setup.c
--- a/arch/i386/kernel/setup.c~divorce-config_x86_pae-from-config_highmem64g
+++ a/arch/i386/kernel/setup.c
@@ -282,18 +282,18 @@ unsigned long __init find_max_low_pfn(vo
 		printk(KERN_WARNING "Warning only %ldMB will be used.\n",
 					MAXMEM>>20);
 		if (max_pfn > MAX_NONPAE_PFN)
-			printk(KERN_WARNING "Use a PAE enabled kernel.\n");
+			printk(KERN_WARNING "Use a HIGHMEM64G enabled kernel.\n");
 		else
 			printk(KERN_WARNING "Use a HIGHMEM enabled kernel.\n");
 		max_pfn = MAXMEM_PFN;
 #else /* !CONFIG_HIGHMEM */
-#ifndef CONFIG_X86_PAE
+#ifndef CONFIG_HIGHMEM64G
 		if (max_pfn > MAX_NONPAE_PFN) {
 			max_pfn = MAX_NONPAE_PFN;
 			printk(KERN_WARNING "Warning only 4GB will be used.\n");
-			printk(KERN_WARNING "Use a PAE enabled kernel.\n");
+			printk(KERN_WARNING "Use a HIGHMEM64G enabled kernel.\n");
 		}
-#endif /* !CONFIG_X86_PAE */
+#endif /* !CONFIG_HIGHMEM64G */
 #endif /* !CONFIG_HIGHMEM */
 	} else {
 		if (highmem_pages == -1)
_

Patches currently in -mm which might be from wli@holomorphy.com are

fix-x86_64-mm-xen-xen-smp-guest-support.patch
quicklist-support-for-x86_64.patch
x86_64-support-poll-on-dev-mcelog.patch
divorce-config_x86_pae-from-config_highmem64g.patch
rework-ptep_set_access_flags-and-fix-sun4c.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix-fix.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
create-the-zone_movable-zone-fix-2.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
hugetlbfs-use-lib-parser-fix-docs.patch
containersv10-basic-container-framework-fix-2.patch
