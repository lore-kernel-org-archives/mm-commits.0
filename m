From: akpm@linux-foundation.org
Subject: - ia64-point-saved_max_pfn-to-the-max_pfn-of-the-entire-system.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:22:10 -0800
Message-ID: <200703070422.l274MAp6018967@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47111 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbXCGEWT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:22:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: horms@verge.net.au, jlan@sgi.com, nanhai.zou@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: point saved_max_pfn to the max_pfn of the entire system
has been removed from the -mm tree.  Its filename was
     ia64-point-saved_max_pfn-to-the-max_pfn-of-the-entire-system.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64: point saved_max_pfn to the max_pfn of the entire system
From: Horms <horms@verge.net.au>

Make saved_max_pfn point to max_pfn of entire system.

Without this patch is so that vmcore is zero length on ia64.  This is
because saved_max_pfn was wrongly being set to the max_pfn of the crash
kernel's address space, rather than the max_pfg on the physical memory of
the machine - the whole purpose of vmcore is to access physical memory that
is not part of the crash kernel's addresss space.

Updated for recent changes in Linus' tree.

Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
Sort-Of-Acked-By: Jay Lan <jlan@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/efi.c   |    6 ++++++
 arch/ia64/mm/contig.c    |    5 -----
 arch/ia64/mm/discontig.c |    6 ------
 3 files changed, 6 insertions(+), 11 deletions(-)

diff -puN arch/ia64/kernel/efi.c~ia64-point-saved_max_pfn-to-the-max_pfn-of-the-entire-system arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~ia64-point-saved_max_pfn-to-the-max_pfn-of-the-entire-system
+++ a/arch/ia64/kernel/efi.c
@@ -21,6 +21,7 @@
  *	Skip non-WB memory and ignore empty memory ranges.
  */
 #include <linux/module.h>
+#include <linux/bootmem.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
@@ -1009,6 +1010,11 @@ efi_memmap_init(unsigned long *s, unsign
 		} else
 			ae = efi_md_end(md);
 
+#ifdef CONFIG_CRASH_DUMP
+		/* saved_max_pfn should ignore max_addr= command line arg */
+		if (saved_max_pfn < (ae >> PAGE_SHIFT))
+			saved_max_pfn = (ae >> PAGE_SHIFT);
+#endif
 		/* keep within max_addr= and min_addr= command line arg */
 		as = max(as, min_addr);
 		ae = min(ae, max_addr);
diff -puN arch/ia64/mm/contig.c~ia64-point-saved_max_pfn-to-the-max_pfn-of-the-entire-system arch/ia64/mm/contig.c
--- a/arch/ia64/mm/contig.c~ia64-point-saved_max_pfn-to-the-max_pfn-of-the-entire-system
+++ a/arch/ia64/mm/contig.c
@@ -197,11 +197,6 @@ find_memory (void)
 
 	find_initrd();
 
-#ifdef CONFIG_CRASH_DUMP
-	/* If we are doing a crash dump, we still need to know the real mem
-	 * size before original memory map is reset. */
-	saved_max_pfn = max_pfn;
-#endif
 }
 
 #ifdef CONFIG_SMP
diff -puN arch/ia64/mm/discontig.c~ia64-point-saved_max_pfn-to-the-max_pfn-of-the-entire-system arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~ia64-point-saved_max_pfn-to-the-max_pfn-of-the-entire-system
+++ a/arch/ia64/mm/discontig.c
@@ -480,12 +480,6 @@ void __init find_memory(void)
 	max_pfn = max_low_pfn;
 
 	find_initrd();
-
-#ifdef CONFIG_CRASH_DUMP
-	/* If we are doing a crash dump, we still need to know the real mem
-	 * size before original memory map is reset. */
-        saved_max_pfn = max_pfn;
-#endif
 }
 
 #ifdef CONFIG_SMP
_

Patches currently in -mm which might be from horms@verge.net.au are

origin.patch
git-ia64.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor.patch
