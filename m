From: akpm@linux-foundation.org
Subject: - i386-apic-fix-4-bit-apicid-assumption-of-mach-default.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:17:26 -0700
Message-ID: <200709202117.l8KLHQs5003081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59621 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964AbXITV2V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:28:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, ak@suse.de, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     i386, apic: fix 4 bit apicid assumption of mach-default
has been removed from the -mm tree.  Its filename was
     i386-apic-fix-4-bit-apicid-assumption-of-mach-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386, apic: fix 4 bit apicid assumption of mach-default
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Fix get_apic_id() in mach-default, so that it uses 8 bits incase of xAPIC case
and 4 bits for legacy APIC case.

This fixes the i386 kernel assumption that apic id is less than 16 for xAPIC
platforms with 8 cpus or less and makes the kernel boot on such platforms.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/mach-default/mach_apicdef.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletion(-)

diff -puN include/asm-i386/mach-default/mach_apicdef.h~i386-apic-fix-4-bit-apicid-assumption-of-mach-default include/asm-i386/mach-default/mach_apicdef.h
--- a/include/asm-i386/mach-default/mach_apicdef.h~i386-apic-fix-4-bit-apicid-assumption-of-mach-default
+++ a/include/asm-i386/mach-default/mach_apicdef.h
@@ -1,11 +1,17 @@
 #ifndef __ASM_MACH_APICDEF_H
 #define __ASM_MACH_APICDEF_H
 
+#include <asm/apic.h>
+
 #define		APIC_ID_MASK		(0xF<<24)
 
 static inline unsigned get_apic_id(unsigned long x) 
 { 
-	return (((x)>>24)&0xF);
+	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
+	if (APIC_XAPIC(ver))
+		return (((x)>>24)&0xFF);
+	else
+		return (((x)>>24)&0xF);
 } 
 
 #define		GET_APIC_ID(x)	get_apic_id(x)
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

x86-fix-cpu_to_node-references.patch
x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
x86-acpi-use-cpu_physical_id.patch
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
