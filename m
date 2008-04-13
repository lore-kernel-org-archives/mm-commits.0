From: akpm@linux-foundation.org
Subject: - x86_64-do-not-reserve-ramdisk-two-times.patch removed from -mm tree
Date: Sat, 12 Apr 2008 19:40:01 -0700
Message-ID: <200804130240.m3D2e11B032440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755431AbYDMCkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Apr 2008 22:40:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel@gmail.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: do not reserve ramdisk two times
has been removed from the -mm tree.  Its filename was
     x86_64-do-not-reserve-ramdisk-two-times.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86_64: do not reserve ramdisk two times
From: "Yinghai Lu" <yhlu.kernel@gmail.com>

Ramdisk is reserved via reserve_early in x86_64_start_kernel, later
early_res_to_bootmem() will convert to reservation in bootmem.

Do don't need to reserve that again.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/head64.c   |    2 ++
 arch/x86/kernel/setup_64.c |    7 +++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/head64.c~x86_64-do-not-reserve-ramdisk-two-times arch/x86/kernel/head64.c
--- a/arch/x86/kernel/head64.c~x86_64-do-not-reserve-ramdisk-two-times
+++ a/arch/x86/kernel/head64.c
@@ -146,6 +146,7 @@ void __init x86_64_start_kernel(char * r
 
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&_end), "TEXT DATA BSS");
 
+#ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
 	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
 		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
@@ -153,6 +154,7 @@ void __init x86_64_start_kernel(char * r
 		unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
 		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
+#endif
 
 	reserve_ebda_region();
 
diff -puN arch/x86/kernel/setup_64.c~x86_64-do-not-reserve-ramdisk-two-times arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~x86_64-do-not-reserve-ramdisk-two-times
+++ a/arch/x86/kernel/setup_64.c
@@ -419,11 +419,14 @@ void __init setup_arch(char **cmdline_p)
 		unsigned long end_of_mem    = end_pfn << PAGE_SHIFT;
 
 		if (ramdisk_end <= end_of_mem) {
-			reserve_bootmem_generic(ramdisk_image, ramdisk_size);
+			/*
+			 * don't need to reserve again, already reserved early
+			 * in x86_64_start_kernel, and early_res_to_bootmem
+			 * convert that to reserved in bootmeem
+			 */
 			initrd_start = ramdisk_image + PAGE_OFFSET;
 			initrd_end = initrd_start+ramdisk_size;
 		} else {
-			/* Assumes everything on node 0 */
 			free_bootmem(ramdisk_image, ramdisk_size);
 			printk(KERN_ERR "initrd extends beyond end of memory "
 			       "(0x%08lx > 0x%08lx)\ndisabling initrd\n",
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

acpi-unneccessary-to-scan-the-pci-bus-already-scanned.patch
git-x86.patch
forcedeth-mac-address-fix.patch
mm-make-mem_map-allocation-continuous-v2.patch
mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
mm-offset-align-in-alloc_bootmem.patch
mm-make-reserve_bootmem-can-crossed-the-nodes.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
memory-hotplug-register-section-node-id-to-free.patch
memory-hotplug-align-memmap-to-page-size.patch
memory-hotplug-make-alloc_bootmem_section.patch
memory-hotplugallocate-usemap-on-the-section-with-pgdat.patch
memory-hotplug-free-memmaps-allocated-by-bootmem.patch

