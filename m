From: akpm@linux-foundation.org
Subject: + kexec-introduce-bootmem_exclusive.patch added to -mm tree
Date: Thu, 18 Oct 2007 14:31:30 -0700
Message-ID: <200710182131.l9ILVUqY032086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58022 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758143AbXJRVcF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 17:32:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, ebiederm@xmission.com, linux-arch@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de, vgoyal@in.ibm.com


The patch titled
     kexec: introduce BOOTMEM_EXCLUSIVE
has been added to the -mm tree.  Its filename is
     kexec-introduce-bootmem_exclusive.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kexec: introduce BOOTMEM_EXCLUSIVE
From: Bernhard Walle <bwalle@suse.de>

This flag changes the reserve_bootmem() function to accept a new flag
BOOTMEM_EXCLUSIVE.  If that flag is set, the function returns with -EBUSY if
the memory already has been reserved in the past.  This is to avoid conflicts.

Because it's necessary to unreserve the bootmem if a collision is discovered
in the middle of the area, a rwlock is introduced: only one BOOTMEM_EXCLUSIVE
caller is possible, but multiple BOOTMEM_DEFAULT callers.  But if a
BOOTMEM_EXCLUSIVE caller is in reserve_bootmem_core(), no BOOTMEM_DEFAULT
callers are allowd.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: <linux-arch@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/mpparse_32.c |    6 ++++--
 arch/x86/kernel/setup_32.c   |   16 +++++++++-------
 arch/x86/kernel/setup_64.c   |    5 +++--
 include/linux/bootmem.h      |   14 +++++++++++++-
 mm/bootmem.c                 |   25 ++++++++++++++++++++-----
 5 files changed, 49 insertions(+), 17 deletions(-)

diff -puN arch/x86/kernel/mpparse_32.c~kexec-introduce-bootmem_exclusive arch/x86/kernel/mpparse_32.c
--- a/arch/x86/kernel/mpparse_32.c~kexec-introduce-bootmem_exclusive
+++ a/arch/x86/kernel/mpparse_32.c
@@ -736,7 +736,8 @@ static int __init smp_scan_config (unsig
 			smp_found_config = 1;
 			printk(KERN_INFO "found SMP MP-table at %08lx\n",
 						virt_to_phys(mpf));
-			reserve_bootmem(virt_to_phys(mpf), PAGE_SIZE);
+			reserve_bootmem(virt_to_phys(mpf), PAGE_SIZE,
+					BOOTMEM_DEFAULT);
 			if (mpf->mpf_physptr) {
 				/*
 				 * We cannot access to MPC table to compute
@@ -751,7 +752,8 @@ static int __init smp_scan_config (unsig
 				unsigned long end = max_low_pfn * PAGE_SIZE;
 				if (mpf->mpf_physptr + size > end)
 					size = end - mpf->mpf_physptr;
-				reserve_bootmem(mpf->mpf_physptr, size);
+				reserve_bootmem(mpf->mpf_physptr, size,
+						BOOTMEM_DEFAULT);
 			}
 
 			mpf_found = mpf;
diff -puN arch/x86/kernel/setup_32.c~kexec-introduce-bootmem_exclusive arch/x86/kernel/setup_32.c
--- a/arch/x86/kernel/setup_32.c~kexec-introduce-bootmem_exclusive
+++ a/arch/x86/kernel/setup_32.c
@@ -318,7 +318,7 @@ static void __init reserve_ebda_region(v
 	unsigned int addr;
 	addr = get_bios_ebda();
 	if (addr)
-		reserve_bootmem(addr, PAGE_SIZE);	
+		reserve_bootmem(addr, PAGE_SIZE, BOOTMEM_DEFAULT);
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
@@ -412,7 +412,7 @@ static void __init reserve_crashkernel(v
 					(unsigned long)(total_mem >> 20));
 			crashk_res.start = crash_base;
 			crashk_res.end   = crash_base + crash_size - 1;
-			reserve_bootmem(crash_base, crash_size);
+			reserve_bootmem(crash_base, crash_size, BOOTMEM_DEFAULT);
 		} else
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"you have to specify a base address\n");
@@ -440,13 +440,14 @@ void __init setup_bootmem_allocator(void
 	 * bootmem allocator with an invalid RAM area.
 	 */
 	reserve_bootmem(__pa_symbol(_text), (PFN_PHYS(min_low_pfn) +
-			 bootmap_size + PAGE_SIZE-1) - __pa_symbol(_text));
+			 bootmap_size + PAGE_SIZE-1) - __pa_symbol(_text),
+			 BOOTMEM_DEFAULT);
 
 	/*
 	 * reserve physical page 0 - it's a special BIOS page on many boxes,
 	 * enabling clean reboots, SMP operation, laptop functions.
 	 */
-	reserve_bootmem(0, PAGE_SIZE);
+	reserve_bootmem(0, PAGE_SIZE, BOOTMEM_DEFAULT);
 
 	/* reserve EBDA region, it's a 4K region */
 	reserve_ebda_region();
@@ -456,7 +457,7 @@ void __init setup_bootmem_allocator(void
        unless you have no PS/2 mouse plugged in. */
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
 	    boot_cpu_data.x86 == 6)
-	     reserve_bootmem(0xa0000 - 4096, 4096);
+	     reserve_bootmem(0xa0000 - 4096, 4096, BOOTMEM_DEFAULT);
 
 #ifdef CONFIG_SMP
 	/*
@@ -464,7 +465,7 @@ void __init setup_bootmem_allocator(void
 	 * FIXME: Don't need the extra page at 4K, but need to fix
 	 * trampoline before removing it. (see the GDT stuff)
 	 */
-	reserve_bootmem(PAGE_SIZE, PAGE_SIZE);
+	reserve_bootmem(PAGE_SIZE, PAGE_SIZE, BOOTMEM_DEFAULT);
 #endif
 #ifdef CONFIG_ACPI_SLEEP
 	/*
@@ -487,7 +488,8 @@ void __init setup_bootmem_allocator(void
 		unsigned long end_of_lowmem = max_low_pfn << PAGE_SHIFT;
 
 		if (ramdisk_end <= end_of_lowmem) {
-			reserve_bootmem(ramdisk_image, ramdisk_size);
+			reserve_bootmem(ramdisk_image, ramdisk_size,
+					BOOTMEM_DEFAULT);
 			initrd_start = ramdisk_image + PAGE_OFFSET;
 			initrd_end = initrd_start+ramdisk_size;
 		} else {
diff -puN arch/x86/kernel/setup_64.c~kexec-introduce-bootmem_exclusive arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~kexec-introduce-bootmem_exclusive
+++ a/arch/x86/kernel/setup_64.c
@@ -170,7 +170,7 @@ contig_initmem_init(unsigned long start_
 	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, end_pfn);
 	e820_register_active_regions(0, start_pfn, end_pfn);
 	free_bootmem_with_active_regions(0, end_pfn);
-	reserve_bootmem(bootmap, bootmap_size);
+	reserve_bootmem(bootmap, bootmap_size, BOOTMEM_DEFAULT);
 } 
 #endif
 
@@ -218,7 +218,8 @@ static void __init reserve_crashkernel(v
 					(unsigned long)(free_mem >> 20));
 			crashk_res.start = crash_base;
 			crashk_res.end   = crash_base + crash_size - 1;
-			reserve_bootmem(crash_base, crash_size);
+			reserve_bootmem(crash_base, crash_size,
+					BOOTMEM_DEFAULT);
 		} else
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"you have to specify a base address\n");
diff -puN include/linux/bootmem.h~kexec-introduce-bootmem_exclusive include/linux/bootmem.h
--- a/include/linux/bootmem.h~kexec-introduce-bootmem_exclusive
+++ a/include/linux/bootmem.h
@@ -61,8 +61,20 @@ extern void *__alloc_bootmem_core(struct
 				  unsigned long limit);
 extern void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size);
 
+/*
+ * flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
+ * the architecture-specific code should honor this)
+ */
+#define BOOTMEM_DEFAULT		0
+#define BOOTMEM_EXCLUSIVE	(1<<0)
+
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
-extern void reserve_bootmem(unsigned long addr, unsigned long size);
+/*
+ * If flags is 0, then the return value is always 0 (success). If
+ * flags contains BOOTMEM_EXCLUSIVE, then -EBUSY is returned if the
+ * memory already was reserved.
+ */
+extern int reserve_bootmem(unsigned long addr, unsigned long size, int flags);
 #define alloc_bootmem(x) \
 	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_low(x) \
diff -puN mm/bootmem.c~kexec-introduce-bootmem_exclusive mm/bootmem.c
--- a/mm/bootmem.c~kexec-introduce-bootmem_exclusive
+++ a/mm/bootmem.c
@@ -111,11 +111,12 @@ static unsigned long __init init_bootmem
  * might be used for boot-time allocations - or it might get added
  * to the free page pool later on.
  */
-static void __init reserve_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
-					unsigned long size)
+static int __init reserve_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
+					unsigned long size, int flags)
 {
 	unsigned long sidx, eidx;
 	unsigned long i;
+	int ret;
 
 	/*
 	 * round up, partially reserved pages are considered
@@ -133,7 +134,20 @@ static void __init reserve_bootmem_core(
 #ifdef CONFIG_DEBUG_BOOTMEM
 			printk("hm, page %08lx reserved twice.\n", i*PAGE_SIZE);
 #endif
+			if (flags & BOOTMEM_EXCLUSIVE) {
+				ret = -EBUSY;
+				goto err;
+			}
 		}
+
+	return 0;
+
+err:
+	/* unreserve memory we accidentally reserved */
+	for (i--; i >= sidx; i--)
+		clear_bit(i, bdata->node_bootmem_map);
+
+	return ret;
 }
 
 static void __init free_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
@@ -376,7 +390,7 @@ unsigned long __init init_bootmem_node(p
 void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 				 unsigned long size)
 {
-	reserve_bootmem_core(pgdat->bdata, physaddr, size);
+	reserve_bootmem_core(pgdat->bdata, physaddr, size, BOOTMEM_DEFAULT);
 }
 
 void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
@@ -398,9 +412,10 @@ unsigned long __init init_bootmem(unsign
 }
 
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
-void __init reserve_bootmem(unsigned long addr, unsigned long size)
+int __init reserve_bootmem(unsigned long addr, unsigned long size,
+			    int flags)
 {
-	reserve_bootmem_core(NODE_DATA(0)->bdata, addr, size);
+	return reserve_bootmem_core(NODE_DATA(0)->bdata, addr, size, flags);
 }
 #endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
 
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
extended-crashkernel-command-line.patch
extended-crashkernel-command-line-update.patch
extended-crashkernel-command-line-comment-fix.patch
extended-crashkernel-command-line-improve-error-handling-in-parse_crashkernel_mem.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-i386-update.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-x86_64-update.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ia64-fix.patch
use-extended-crashkernel-command-line-on-ia64-update.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-ppc64-update.patch
use-extended-crashkernel-command-line-on-sh.patch
use-extended-crashkernel-command-line-on-sh-update.patch
add-documentation-for-extended-crashkernel-syntax.patch
add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch
kexec-add-bss-to-resource-tree.patch
kexec-add-bss-to-resource-tree-checkpatch-fixes.patch
kexec-introduce-bootmem_exclusive.patch
kexec-use-bootmem_exclusive-on-x86.patch
