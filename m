From: akpm@linux-foundation.org
Subject: - swiotlb-use-iommu_is_span_boundary-helper-function.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:41:18 -0700
Message-ID: <200804300541.m3U5fI7o029044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755208AbYD3FmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:42:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     swiotlb: use iommu_is_span_boundary helper function
has been removed from the -mm tree.  Its filename was
     swiotlb-use-iommu_is_span_boundary-helper-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swiotlb: use iommu_is_span_boundary helper function
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

iommu_is_span_boundary in lib/iommu-helper.c was exported for PARISC IOMMUs
(commit 3715863aa142c4f4c5208f5f3e5e9bac06006d2f).  SWIOTLB can use it instead
of the homegrown function.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig |    5 ++++-
 arch/x86/Kconfig  |    5 ++---
 lib/swiotlb.c     |   14 +++-----------
 3 files changed, 9 insertions(+), 15 deletions(-)

diff -puN arch/ia64/Kconfig~swiotlb-use-iommu_is_span_boundary-helper-function arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~swiotlb-use-iommu_is_span_boundary-helper-function
+++ a/arch/ia64/Kconfig
@@ -47,6 +47,9 @@ config MMU
 config SWIOTLB
        bool
 
+config IOMMU_HELPER
+       bool
+
 config GENERIC_LOCKBREAK
 	bool
 	default y
@@ -615,7 +618,7 @@ config IRQ_PER_CPU
 	default y
 
 config IOMMU_HELPER
-	def_bool (IA64_HP_ZX1 || IA64_HP_ZX1_SWIOTLB || IA64_GENERIC)
+	def_bool (IA64_HP_ZX1 || IA64_HP_ZX1_SWIOTLB || IA64_GENERIC || SWIOTLB)
 
 source "arch/ia64/hp/sim/Kconfig"
 
diff -puN arch/x86/Kconfig~swiotlb-use-iommu_is_span_boundary-helper-function arch/x86/Kconfig
--- a/arch/x86/Kconfig~swiotlb-use-iommu_is_span_boundary-helper-function
+++ a/arch/x86/Kconfig
@@ -537,9 +537,6 @@ config CALGARY_IOMMU_ENABLED_BY_DEFAULT
 	  Calgary anyway, pass 'iommu=calgary' on the kernel command line.
 	  If unsure, say Y.
 
-config IOMMU_HELPER
-	def_bool (CALGARY_IOMMU || GART_IOMMU)
-
 # need this always selected by IOMMU for the VIA workaround
 config SWIOTLB
 	bool
@@ -550,6 +547,8 @@ config SWIOTLB
 	  access 32-bits of memory can be used on systems with more than
 	  3 GB of memory. If unsure, say Y.
 
+config IOMMU_HELPER
+	def_bool (CALGARY_IOMMU || GART_IOMMU || SWIOTLB)
 
 config NR_CPUS
 	int "Maximum number of CPUs (2-255)"
diff -puN lib/swiotlb.c~swiotlb-use-iommu_is_span_boundary-helper-function lib/swiotlb.c
--- a/lib/swiotlb.c~swiotlb-use-iommu_is_span_boundary-helper-function
+++ a/lib/swiotlb.c
@@ -31,6 +31,7 @@
 
 #include <linux/init.h>
 #include <linux/bootmem.h>
+#include <linux/iommu-helper.h>
 
 #define OFFSET(val,align) ((unsigned long)	\
 	                   ( (val) & ( (align) - 1)))
@@ -282,15 +283,6 @@ address_needs_mapping(struct device *hwd
 	return (addr & ~mask) != 0;
 }
 
-static inline unsigned int is_span_boundary(unsigned int index,
-					    unsigned int nslots,
-					    unsigned long offset_slots,
-					    unsigned long max_slots)
-{
-	unsigned long offset = (offset_slots + index) & (max_slots - 1);
-	return offset + nslots > max_slots;
-}
