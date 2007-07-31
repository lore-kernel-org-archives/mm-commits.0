From: akpm@linux-foundation.org
Subject: - x86-64-calgary-fix-section-mismatch-warnings-in-tce.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:54:50 -0700
Message-ID: <200707312354.l6VNsoap029179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39273 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759337AbXGaXzm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 19:55:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, ak@suse.de, muli@il.ibm.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     x86-64: Calgary: fix section mismatch warnings in tce
has been removed from the -mm tree.  Its filename was
     x86-64-calgary-fix-section-mismatch-warnings-in-tce.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-64: Calgary: fix section mismatch warnings in tce
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch warnings:
these functions are called only from __init functions.

WARNING: vmlinux.o(.text+0x1861c): Section mismatch: reference to .init.text:free_bootmem (between 'free_tce_table' and 'build_tce_table')
WARNING: vmlinux.o(.text+0x187e5): Section mismatch: reference to .init.text:__alloc_bootmem_low (between 'alloc_tce_table' and 'kretprobe_trampoline_holder')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/tce.c |    2 +-
 include/asm-x86_64/tce.h |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/kernel/tce.c~x86-64-calgary-fix-section-mismatch-warnings-in-tce arch/x86_64/kernel/tce.c
--- a/arch/x86_64/kernel/tce.c~x86-64-calgary-fix-section-mismatch-warnings-in-tce
+++ a/arch/x86_64/kernel/tce.c
@@ -131,7 +131,7 @@ done:
 	return ret;
 }
 
-int build_tce_table(struct pci_dev *dev, void __iomem *bbar)
+int __init build_tce_table(struct pci_dev *dev, void __iomem *bbar)
 {
 	struct iommu_table *tbl;
 	int ret;
diff -puN include/asm-x86_64/tce.h~x86-64-calgary-fix-section-mismatch-warnings-in-tce include/asm-x86_64/tce.h
--- a/include/asm-x86_64/tce.h~x86-64-calgary-fix-section-mismatch-warnings-in-tce
+++ a/include/asm-x86_64/tce.h
@@ -41,8 +41,8 @@ struct iommu_table;
 extern void tce_build(struct iommu_table *tbl, unsigned long index,
         unsigned int npages, unsigned long uaddr, int direction);
 extern void tce_free(struct iommu_table *tbl, long index, unsigned int npages);
-extern void* alloc_tce_table(void);
-extern void free_tce_table(void *tbl);
-extern int build_tce_table(struct pci_dev *dev, void __iomem *bbar);
+extern void * __init alloc_tce_table(void);
+extern void __init free_tce_table(void *tbl);
+extern int __init build_tce_table(struct pci_dev *dev, void __iomem *bbar);
 
 #endif /* _ASM_X86_64_TCE_H */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
fix-auditscc-kernel-doc.patch
git-mtd.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-kgdb-kernel-doc.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
profile-likely-unlikely-macros.patch
