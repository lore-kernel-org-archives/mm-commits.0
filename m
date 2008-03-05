From: akpm@linux-foundation.org
Subject: - alpha-make-iommu-respect-the-segment-boundary-limits.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:44:56 -0800
Message-ID: <200803050744.m257iu47021547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764788AbYCEHpb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:45:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: make IOMMU respect the segment boundary limits
has been removed from the -mm tree.  Its filename was
     alpha-make-iommu-respect-the-segment-boundary-limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: make IOMMU respect the segment boundary limits
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This patch makes the IOMMU code not allocate a memory area spanning LLD's
segment boundary.

is_span_boundary() judges whether a memory area spans LLD's segment boundary. 
If iommu_arena_find_pages() finds such a area, it tries to find the next
available memory area.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci_iommu.c |   40 +++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 6 deletions(-)

diff -puN arch/alpha/kernel/pci_iommu.c~alpha-make-iommu-respect-the-segment-boundary-limits arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~alpha-make-iommu-respect-the-segment-boundary-limits
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -126,13 +126,34 @@ iommu_arena_new(struct pci_controller *h
 	return iommu_arena_new_node(0, hose, base, window_size, align);
 }
 
+static inline int is_span_boundary(unsigned int index, unsigned int nr,
+				   unsigned long shift,
+				   unsigned long boundary_size)
+{
+	shift = (shift + index) & (boundary_size - 1);
+	return shift + nr > boundary_size;
+}
+
 /* Must be called with the arena lock held */
 static long
-iommu_arena_find_pages(struct pci_iommu_arena *arena, long n, long mask)
+iommu_arena_find_pages(struct device *dev, struct pci_iommu_arena *arena,
+		       long n, long mask)
 {
 	unsigned long *ptes;
 	long i, p, nent;
 	int pass = 0;
+	unsigned long base;
+	unsigned long boundary_size;
+
+	BUG_ON(arena->dma_base & ~PAGE_MASK);
+	base = arena->dma_base >> PAGE_SHIFT;
+	if (dev)
+		boundary_size = ALIGN(dma_get_max_seg_size(dev) + 1, PAGE_SIZE)
+			>> PAGE_SHIFT;
+	else
+		boundary_size = ALIGN(1UL << 32, PAGE_SIZE) >> PAGE_SHIFT;
+
+	BUG_ON(!is_power_of_2(boundary_size));
 
 	/* Search forward for the first mask-aligned sequence of N free ptes */
 	ptes = arena->ptes;
@@ -142,6 +163,11 @@ iommu_arena_find_pages(struct pci_iommu_
 
 again:
 	while (i < n && p+i < nent) {
+		if (!i && is_span_boundary(p, n, base, boundary_size)) {
+			p = ALIGN(p + 1, mask + 1);
+			goto again;
+		}
+
 		if (ptes[p+i])
 			p = ALIGN(p + i + 1, mask + 1), i = 0;
 		else
@@ -170,7 +196,8 @@ again:
 }
 
 static long
-iommu_arena_alloc(struct pci_iommu_arena *arena, long n, unsigned int align)
+iommu_arena_alloc(struct device *dev, struct pci_iommu_arena *arena, long n,
+		  unsigned int align)
 {
 	unsigned long flags;
 	unsigned long *ptes;
@@ -181,7 +208,7 @@ iommu_arena_alloc(struct pci_iommu_arena
 	/* Search for N empty ptes */
 	ptes = arena->ptes;
 	mask = max(align, arena->align_entry) - 1;
-	p = iommu_arena_find_pages(arena, n, mask);
+	p = iommu_arena_find_pages(dev, arena, n, mask);
 	if (p < 0) {
 		spin_unlock_irqrestore(&arena->lock, flags);
 		return -1;
@@ -231,6 +258,7 @@ pci_map_single_1(struct pci_dev *pdev, v
 	unsigned long paddr;
 	dma_addr_t ret;
 	unsigned int align = 0;
+	struct device *dev = pdev ? &pdev->dev : NULL;
 
 	paddr = __pa(cpu_addr);
 
@@ -278,7 +306,7 @@ pci_map_single_1(struct pci_dev *pdev, v
 	/* Force allocation to 64KB boundary for ISA bridges. */
 	if (pdev && pdev == isa_bridge)
 		align = 8;
-	dma_ofs = iommu_arena_alloc(arena, npages, align);
+	dma_ofs = iommu_arena_alloc(dev, arena, npages, align);
 	if (dma_ofs < 0) {
 		printk(KERN_WARNING "pci_map_single failed: "
 		       "could not allocate dma page tables\n");
@@ -565,7 +593,7 @@ sg_fill(struct device *dev, struct scatt
 
 	paddr &= ~PAGE_MASK;
 	npages = calc_npages(paddr + size);
-	dma_ofs = iommu_arena_alloc(arena, npages, 0);
+	dma_ofs = iommu_arena_alloc(dev, arena, npages, 0);
 	if (dma_ofs < 0) {
 		/* If we attempted a direct map above but failed, die.  */
 		if (leader->dma_address == 0)
@@ -832,7 +860,7 @@ iommu_reserve(struct pci_iommu_arena *ar
 
 	/* Search for N empty ptes.  */
 	ptes = arena->ptes;
-	p = iommu_arena_find_pages(arena, pg_count, align_mask);
+	p = iommu_arena_find_pages(NULL, arena, pg_count, align_mask);
 	if (p < 0) {
 		spin_unlock_irqrestore(&arena->lock, flags);
 		return -1;
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

parisc-fix-a-overflow-bug-on-32bit-architectures.patch
git-scsi-misc.patch
mpt-fusion-dont-oops-if-numphys==0.patch

