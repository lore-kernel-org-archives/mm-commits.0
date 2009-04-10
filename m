From: akpm@linux-foundation.org
Subject: + x86-enable-gart-iommu-only-after-setting-up-protection-methods.patch added to -mm tree
Date: Fri, 10 Apr 2009 14:44:34 -0700
Message-ID: <200904102144.n3ALiZVx005239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752599AbZDJVsO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 17:48:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mark.langsdorf@amd.com, hpa@zytor.com, jbarnes@virtuousgeek.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: enable GART-IOMMU only after setting up protection methods
has been added to the -mm tree.  Its filename is
     x86-enable-gart-iommu-only-after-setting-up-protection-methods.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: enable GART-IOMMU only after setting up protection methods
From: Mark Langsdorf <mark.langsdorf@amd.com>

The current code to set up the GART as an IOMMU enables GART translations
before it removes the aperture from the kernel memory map, sets the GART
PTEs to UC, sets up the guard and scratch pages, or does a wbinvd().  This
leaves the possibility of cache aliasing open and can cause system
crashes.

Re-order the code and add tlbflush so as to enable the GART translations
only after all safeguards are in place and the tlb has been flushed.

AMD has tested this patch and seen no adverse effects.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pci-gart_64.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/pci-gart_64.c~x86-enable-gart-iommu-only-after-setting-up-protection-methods arch/x86/kernel/pci-gart_64.c
--- a/arch/x86/kernel/pci-gart_64.c~x86-enable-gart-iommu-only-after-setting-up-protection-methods
+++ a/arch/x86/kernel/pci-gart_64.c
@@ -38,6 +38,7 @@
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
 #include <asm/k8.h>
+#include <asm/tlbflush.h>
 
 static unsigned long iommu_bus_base;	/* GART remapping area (physical) */
 static unsigned long iommu_size;	/* size of remapping area bytes */
@@ -686,9 +687,9 @@ static __init int init_k8_gatt(struct ag
 	if (set_memory_uc((unsigned long)gatt, gatt_size >> PAGE_SHIFT))
 		panic("Could not set GART PTEs to uncacheable pages");
 
-	agp_gatt_table = gatt;
+	wbinvd();
 
-	enable_gart_translations();
+	agp_gatt_table = gatt;
 
 	error = sysdev_class_register(&gart_sysdev_class);
 	if (!error)
@@ -859,6 +860,11 @@ void __init gart_iommu_init(void)
 	for (i = EMERGENCY_PAGES; i < iommu_pages; i++)
 		iommu_gatt_base[i] = gart_unmapped_entry;
 
+	wbinvd();
+	flush_tlb_all();
+
+	enable_gart_translations();
+
 	flush_gart();
 	dma_ops = &gart_dma_ops;
 }
_

Patches currently in -mm which might be from mark.langsdorf@amd.com are

x86-enable-gart-iommu-only-after-setting-up-protection-methods.patch

