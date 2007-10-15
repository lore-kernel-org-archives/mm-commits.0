From: akpm@linux-foundation.org
Subject: + x86_64-vsyscall-fix-the-oops-crash-with-__pa_vsymbol.patch added to -mm tree
Date: Mon, 15 Oct 2007 12:59:35 -0700
Message-ID: <200710151959.l9FJxZrT022256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54208 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764703AbXJOUAA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 16:00:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suresh.b.siddha@intel.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, yanmin.zhang@intel.com


The patch titled
     x86_64, vsyscall: fix the oops crash with __pa_vsymbol()
has been added to the -mm tree.  Its filename is
     x86_64-vsyscall-fix-the-oops-crash-with-__pa_vsymbol.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

x86-fix-cpu_to_node-references.patch
x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
x86-acpi-use-cpu_physical_id.patch
x86_64-vsyscall-fix-the-oops-crash-with-__pa_vsymbol.patch
x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
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
