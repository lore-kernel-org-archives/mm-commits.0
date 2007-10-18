From: akpm@linux-foundation.org
Subject: - x86_64-vsyscall-fix-the-oops-crash-with-__pa_vsymbol.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:09:06 -0700
Message-ID: <200710180709.l9I796SR031881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52283 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762827AbXJRHRV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:17:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, yanmin.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     x86_64, vsyscall: fix the oops crash with __pa_vsymbol()
has been removed from the -mm tree.  Its filename was
     x86_64-vsyscall-fix-the-oops-crash-with-__pa_vsymbol.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64, vsyscall: fix the oops crash with __pa_vsymbol()
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Fix an oops with __pa_vsymbol().  VSYSCALL_FIRST_PAGE is a fixmap index. 
We want the starting virtual address of the vsyscall page and not the
index.

Reported-by: Yanmin Zhang <yanmin.zhang@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/vsyscall_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN /dev/null /dev/null
diff -puN arch/x86/kernel/vsyscall_64.c~x86_64-vsyscall-fix-the-oops-crash-with-__pa_vsymbol arch/x86/kernel/vsyscall_64.c
--- a/arch/x86/kernel/vsyscall_64.c~x86_64-vsyscall-fix-the-oops-crash-with-__pa_vsymbol
+++ a/arch/x86/kernel/vsyscall_64.c
@@ -48,7 +48,7 @@
 	({unsigned long v;  		\
 	extern char __vsyscall_0; 	\
 	  asm("" : "=r" (v) : "0" (x)); \
-	  ((v - VSYSCALL_FIRST_PAGE) + __pa_symbol(&__vsyscall_0)); })
+	  ((v - VSYSCALL_START) + __pa_symbol(&__vsyscall_0)); })
 
 /*
  * vsyscall_gtod_data contains data that is :
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

origin.patch
git-x86.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-optimize-sg-map-unmap-calls.patch
