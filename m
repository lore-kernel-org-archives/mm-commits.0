From: akpm@linux-foundation.org
Subject: - ia64-enable-swiotlb-only-when-needed.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:52:01 -0800
Message-ID: <200702071952.l17Jq1Vt025209@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33575 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422729AbXBGTwG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:52:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, ak@suse.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: Enable SWIOTLB only when needed
has been removed from the -mm tree.  Its filename was
     ia64-enable-swiotlb-only-when-needed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64: Enable SWIOTLB only when needed
From: "Jan Beulich" <jbeulich@novell.com>

Don't force CONFIG_SWIOTLB on when not actually needed (i.e. HP_ZX1 and
SGI_SN2).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/ia64/Kconfig~ia64-enable-swiotlb-only-when-needed arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~ia64-enable-swiotlb-only-when-needed
+++ a/arch/ia64/Kconfig
@@ -28,7 +28,6 @@ config MMU
 
 config SWIOTLB
        bool
-       default y
 
 config RWSEM_XCHGADD_ALGORITHM
 	bool
@@ -88,6 +87,7 @@ config IA64_GENERIC
 	select PCI
 	select NUMA
 	select ACPI_NUMA
+	select SWIOTLB
 	help
 	  This selects the system type of your hardware.  A "generic" kernel
 	  will run on any supported IA-64 system.  However, if you configure
@@ -104,6 +104,7 @@ config IA64_GENERIC
 
 config IA64_DIG
 	bool "DIG-compliant"
+	select SWIOTLB
 
 config IA64_HP_ZX1
 	bool "HP-zx1/sx1000"
@@ -113,6 +114,7 @@ config IA64_HP_ZX1
 
 config IA64_HP_ZX1_SWIOTLB
 	bool "HP-zx1/sx1000 with software I/O TLB"
+	select SWIOTLB
 	help
 	  Build a kernel that runs on HP zx1 and sx1000 systems even when they
 	  have broken PCI devices which cannot DMA to full 32 bits.  Apart
@@ -131,6 +133,7 @@ config IA64_SGI_SN2
 
 config IA64_HP_SIM
 	bool "Ski-simulator"
+	select SWIOTLB
 
 endchoice
 
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
missing-critical-phys_to_virt-in-lib-swiotlbc.patch
i386-entrys-end-endproc-annotations.patch
