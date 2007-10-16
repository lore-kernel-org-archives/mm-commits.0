From: akpm@linux-foundation.org
Subject: - generic-virtual-memmap-support-for-sparsemem-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 20:58:40 -0700
Message-ID: <200710160358.l9G3wese007606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47956 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758124AbXJPD7Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 23:59:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     sparsemem_vmemamp fix
has been removed from the -mm tree.  Its filename was
     generic-virtual-memmap-support-for-sparsemem-fix.patch

This patch was dropped because it was folded into generic-virtual-memmap-support-for-sparsemem.patch

------------------------------------------------------
Subject: sparsemem_vmemamp fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Fix sparsemem_vmemmap init.

This patch fixes page table handling in sparsemem_vmammap.

Without this, part of vmem_map is not mapped because each section's start addr of
mem_map is not aligned to PGD/PMD/PUD.
(In ia64, secion's mem_map size is 3670016bytes. )

for example,

 addr     pmd_addr_end(addr_end)         addr + PMD_SIZE
  |XXXXXXXXXX|??????????????????????????????|XXXXXXXXXXXXXXXXXX

  X ... initialized vmem_map
  ? ... not intialized

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN mm/sparse.c~generic-virtual-memmap-support-for-sparsemem-fix mm/sparse.c
--- a/mm/sparse.c~generic-virtual-memmap-support-for-sparsemem-fix
+++ a/mm/sparse.c
@@ -295,7 +295,7 @@ static int __meminit vmemmap_populate_pt
 {
 	pte_t *pte;
 
-	for (pte = pte_offset_map(pmd, addr); addr < end;
+	for (pte = pte_offset_kernel(pmd, addr); addr < end;
 						pte++, addr += PAGE_SIZE)
 		if (pte_none(*pte)) {
 			pte_t entry;
@@ -320,9 +320,10 @@ int __meminit vmemmap_populate_pmd(pud_t
 {
 	pmd_t *pmd;
 	int error = 0;
+	unsigned long next;
 
 	for (pmd = pmd_offset(pud, addr); addr < end && !error;
-						pmd++, addr += PMD_SIZE) {
+						pmd++, addr = next) {
 		if (pmd_none(*pmd)) {
 			void *p = vmemmap_alloc_block(PAGE_SIZE, node);
 			if (!p)
@@ -332,9 +333,8 @@ int __meminit vmemmap_populate_pmd(pud_t
 		} else
 			vmemmap_verify((pte_t *)pmd, node,
 					pmd_addr_end(addr, end), end);
-
-		error = vmemmap_populate_pte(pmd, addr,
-					pmd_addr_end(addr, end), node);
+		next = pmd_addr_end(addr, end);
+		error = vmemmap_populate_pte(pmd, addr, next, node);
 	}
 	return error;
 }
@@ -345,9 +345,10 @@ static int __meminit vmemmap_populate_pu
 {
 	pud_t *pud;
 	int error = 0;
+	unsigned long next;
 
 	for (pud = pud_offset(pgd, addr); addr < end && !error;
-						pud++, addr += PUD_SIZE) {
+						pud++, addr = next) {
 		if (pud_none(*pud)) {
 			void *p = vmemmap_alloc_block(PAGE_SIZE, node);
 			if (!p)
@@ -355,8 +356,8 @@ static int __meminit vmemmap_populate_pu
 
 			pud_populate(&init_mm, pud, p);
 		}
-		error = vmemmap_populate_pmd(pud, addr,
-					pud_addr_end(addr, end), node);
+		next = pud_addr_end(addr, end);
+		error = vmemmap_populate_pmd(pud, addr, next, node);
 	}
 	return error;
 }
@@ -367,13 +368,14 @@ int __meminit vmemmap_populate(struct pa
 	pgd_t *pgd;
 	unsigned long addr = (unsigned long)start_page;
 	unsigned long end = (unsigned long)(start_page + nr);
+	unsigned long next;
 	int error = 0;
 
 	printk(KERN_DEBUG "[%lx-%lx] Virtual memory section"
 		" (%ld pages) node %d\n", addr, end - 1, nr, node);
 
 	for (pgd = pgd_offset_k(addr); addr < end && !error;
-					pgd++, addr += PGDIR_SIZE) {
+					pgd++, addr = next) {
 		if (pgd_none(*pgd)) {
 			void *p = vmemmap_alloc_block(PAGE_SIZE, node);
 			if (!p)
@@ -381,8 +383,8 @@ int __meminit vmemmap_populate(struct pa
 
 			pgd_populate(&init_mm, pgd, p);
 		}
-		error = vmemmap_populate_pud(pgd, addr,
-					pgd_addr_end(addr, end), node);
+		next = pgd_addr_end(addr,end);
+		error = vmemmap_populate_pud(pgd, addr, next, node);
 	}
 	return error;
 }
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-fix.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
sparc64-sparsemem_vmemmap-support.patch
sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
update-n_high_memory-node-state-for-memory-hotadd.patch
memoryless-nodes-fix-interleave-behavior-for-memoryless-nodes.patch
memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-nodes-slab-support.patch
memoryless-nodes-slub-support.patch
memoryless-nodes-uncached-allocator-updates.patch
memoryless-nodes-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
memoryless-nodes-add-n_cpu-node-state.patch
memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-n_high_memory-for-cpusets.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-memory-hotplug-cleanup-fix.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-unplug-v7-page-offline-fix.patch
memory-unplug-v7-ia64-interface.patch
fix-memory-hot-remove-not-configured-case.patch
fix-memory-hot-remove-not-configured-case-fix.patch
hugetlb-fix-hugepage-allocation-with-memoryless-nodes.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
add-irq-protection-in-the-percpu-counters-cpu-hotplug-callback-path.patch
