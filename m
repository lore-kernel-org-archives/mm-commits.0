From: akpm@linux-foundation.org
Subject: + x86_64-do-not-reserve-ramdisk-two-times.patch added to -mm tree
Date: Fri, 14 Mar 2008 12:50:54 -0700
Message-ID: <200803141950.m2EJosMW016393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752371AbYCNTwK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 15:52:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yhlu.kernel@gmail.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86_64: do not reserve ramdisk two times
has been added to the -mm tree.  Its filename is
     x86_64-do-not-reserve-ramdisk-two-times.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -150,6 +150,7 @@ void __init x86_64_start_kernel(char * r
 
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&_end), "TEXT DATA BSS");
 
+#ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
 	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
 		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
@@ -157,6 +158,7 @@ void __init x86_64_start_kernel(char * r
 		unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
 		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
+#endif
 
 	reserve_ebda_region();
 
diff -puN arch/x86/kernel/setup_64.c~x86_64-do-not-reserve-ramdisk-two-times arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~x86_64-do-not-reserve-ramdisk-two-times
+++ a/arch/x86/kernel/setup_64.c
@@ -429,11 +429,14 @@ void __init setup_arch(char **cmdline_p)
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

mm-fix-boundary-checking-in-free_bootmem_core.patch
mm-fix-boundary-checking-in-free_bootmem_core-fix.patch
git-x86.patch
x86_64-free_bootmem-should-take-phy.patch
x86_64-do-not-reserve-ramdisk-two-times.patch
mm-make-mem_map-allocation-continuous.patch
mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
mm-allocate-section_map-for-sparse_init.patch

