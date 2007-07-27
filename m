From: akpm@linux-foundation.org
Subject: + x86-64-calgary-fix-section-mismatch-warnings-in-tce.patch added to -mm tree
Date: Thu, 26 Jul 2007 22:17:50 -0700
Message-ID: <200707270517.l6R5HoIR006957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58637 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754033AbXG0FXL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 01:23:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, ak@suse.de, muli@il.ibm.com, sam@ravnborg.org


The patch titled
     x86-64: Calgary: fix section mismatch warnings in tce
has been added to the -mm tree.  Its filename is
     x86-64-calgary-fix-section-mismatch-warnings-in-tce.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

kernel-doc-fix-for-kmodc.patch
update-dontdiff-file.patch
kernel-doc-fixes-for-pci-and-drivers-base.patch
docbook-add-pipes-other-fixes.patch
x86-64-calgary-fix-section-mismatch-warnings-in-tce.patch
git-acpi.patch
git-mtd.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
i2ch-kernel-doc-additions.patch
irqh-fix-kernel-doc.patch
docbook-bad-file-references.patch
kthread-silence-bogus-section-mismatch-warning.patch
profile-likely-unlikely-macros.patch
