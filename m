From: akpm@linux-foundation.org
Subject: + alpha-use-iommu_is_span_boundary-helper-function.patch added to -mm tree
Date: Mon, 10 Mar 2008 20:38:51 -0700
Message-ID: <200803110338.m2B3cprf020375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420AbYCKDi5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:38:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     alpha: use iommu_is_span_boundary helper function
has been added to the -mm tree.  Its filename is
     alpha-use-iommu_is_span_boundary-helper-function.patch

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
Subject: alpha: use iommu_is_span_boundary helper function
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

iommu_is_span_boundary in lib/iommu-helper.c was exported for PARISC IOMMUs
(commit 3715863aa142c4f4c5208f5f3e5e9bac06006d2f).  Alpha's IOMMU can use it.

This removes the check on the boundary size alignment because
iommu_is_span_boundary does.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Richard Henderson <rth@twiddle.net>
Acked-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig            |    3 +++
 arch/alpha/kernel/pci_iommu.c |   12 ++----------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff -puN arch/alpha/Kconfig~alpha-use-iommu_is_span_boundary-helper-function arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~alpha-use-iommu_is_span_boundary-helper-function
+++ a/arch/alpha/Kconfig
@@ -330,6 +330,9 @@ config PCI_DOMAINS
 config PCI_SYSCALL
 	def_bool PCI
 
+config IOMMU_HELPER
+	def_bool PCI
+
 config ALPHA_CORE_AGP
 	bool
 	depends on ALPHA_GENERIC || ALPHA_TITAN || ALPHA_MARVEL
diff -puN arch/alpha/kernel/pci_iommu.c~alpha-use-iommu_is_span_boundary-helper-function arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~alpha-use-iommu_is_span_boundary-helper-function
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -10,6 +10,7 @@
 #include <linux/scatterlist.h>
 #include <linux/log2.h>
 #include <linux/dma-mapping.h>
+#include <linux/iommu-helper.h>
 
 #include <asm/io.h>
 #include <asm/hwrpb.h>
@@ -125,14 +126,6 @@ iommu_arena_new(struct pci_controller *h
 	return iommu_arena_new_node(0, hose, base, window_size, align);
 }
 
-static inline int is_span_boundary(unsigned int index, unsigned int nr,
-				   unsigned long shift,
-				   unsigned long boundary_size)
-{
-	shift = (shift + index) & (boundary_size - 1);
-	return shift + nr > boundary_size;
-}
-
 /* Must be called with the arena lock held */
 static long
 iommu_arena_find_pages(struct device *dev, struct pci_iommu_arena *arena,
@@ -147,7 +140,6 @@ iommu_arena_find_pages(struct device *de
 	base = arena->dma_base >> PAGE_SHIFT;
 	if (dev) {
 		boundary_size = dma_get_seg_boundary(dev) + 1;
-		BUG_ON(!is_power_of_2(boundary_size));
 		boundary_size >>= PAGE_SHIFT;
 	} else {
 		boundary_size = 1UL << (32 - PAGE_SHIFT);
@@ -161,7 +153,7 @@ iommu_arena_find_pages(struct device *de
 
 again:
 	while (i < n && p+i < nent) {
-		if (!i && is_span_boundary(p, n, base, boundary_size)) {
+		if (!i && iommu_is_span_boundary(p, n, base, boundary_size)) {
 			p = ALIGN(p + 1, mask + 1);
 			goto again;
 		}
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

git-scsi-misc.patch
alpha-use-iommu_is_span_boundary-helper-function.patch
ia64-make-iommu-respect-the-segment-boundary-limits.patch

