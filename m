From: akpm@linux-foundation.org
Subject: + x86-64-use-vmemmap_populate_basepages-for-pse-setups.patch added to -mm tree
Date: Thu, 21 Mar 2013 12:59:04 -0700
Message-ID: <20130321195904.EB8E931C227@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:35876 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab3CUT7H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 15:59:07 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so297363qcr.0
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 12:59:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, Bernhard.Schmidt@lrz.de, ben@decadent.org.uk, benh@kernel.crashing.org, davem@davemloft.net, heiko.carstens@de.ibm.com, hpa@zytor.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     Subject: x86-64: use vmemmap_populate_basepages() for !pse setups
has been added to the -mm tree.  Its filename is
     x86-64-use-vmemmap_populate_basepages-for-pse-setups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: x86-64: use vmemmap_populate_basepages() for !pse setups

We already have generic code to allocate vmemmap with regular pages, use
it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Bernhard Schmidt <Bernhard.Schmidt@lrz.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   83 ++++++++++++++++++----------------------
 1 file changed, 39 insertions(+), 44 deletions(-)

diff -puN arch/x86/mm/init_64.c~x86-64-use-vmemmap_populate_basepages-for-pse-setups arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86-64-use-vmemmap_populate_basepages-for-pse-setups
+++ a/arch/x86/mm/init_64.c
@@ -1281,17 +1281,15 @@ static long __meminitdata addr_start, ad
 static void __meminitdata *p_start, *p_end;
 static int __meminitdata node_start;
 
-int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node)
+static int __meminit vmemmap_populate_hugepages(unsigned long start,
+						unsigned long end, int node)
 {
 	unsigned long addr;
-	unsigned long next;
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
 
-	for (addr = start; addr < end; addr = next) {
-		void *p = NULL;
-
+	for (addr = start; addr < end; addr += PMD_SIZE) {
 		pgd = vmemmap_pgd_populate(addr, node);
 		if (!pgd)
 			return -ENOMEM;
@@ -1300,53 +1298,50 @@ int __meminit vmemmap_populate(unsigned
 		if (!pud)
 			return -ENOMEM;
 
-		if (!cpu_has_pse) {
-			next = (addr + PAGE_SIZE) & PAGE_MASK;
-			pmd = vmemmap_pmd_populate(pud, addr, node);
-
-			if (!pmd)
-				return -ENOMEM;
-
-			p = vmemmap_pte_populate(pmd, addr, node);
+		pmd = pmd_offset(pud, addr);
+		if (pmd_none(*pmd)) {
+			pte_t entry;
+			void *p;
 
+			p = vmemmap_alloc_block_buf(PMD_SIZE, node);
 			if (!p)
 				return -ENOMEM;
-		} else {
-			next = pmd_addr_end(addr, end);
-
-			pmd = pmd_offset(pud, addr);
-			if (pmd_none(*pmd)) {
-				pte_t entry;
-
-				p = vmemmap_alloc_block_buf(PMD_SIZE, node);
-				if (!p)
-					return -ENOMEM;
-
-				entry = pfn_pte(__pa(p) >> PAGE_SHIFT,
-						PAGE_KERNEL_LARGE);
-				set_pmd(pmd, __pmd(pte_val(entry)));
-
-				/* check to see if we have contiguous blocks */
-				if (p_end != p || node_start != node) {
-					if (p_start)
-						printk(KERN_DEBUG " [%lx-%lx] PMD -> [%p-%p] on node %d\n",
-						       addr_start, addr_end-1, p_start, p_end-1, node_start);
-					addr_start = addr;
-					node_start = node;
-					p_start = p;
-				}
-
-				addr_end = addr + PMD_SIZE;
-				p_end = p + PMD_SIZE;
-			} else
-				vmemmap_verify((pte_t *)pmd, node, addr, next);
-		}
 
+			entry = pfn_pte(__pa(p) >> PAGE_SHIFT,
+					PAGE_KERNEL_LARGE);
+			set_pmd(pmd, __pmd(pte_val(entry)));
+
+			/* check to see if we have contiguous blocks */
+			if (p_end != p || node_start != node) {
+				if (p_start)
+					printk(KERN_DEBUG " [%lx-%lx] PMD -> [%p-%p] on node %d\n",
+					       addr_start, addr_end-1, p_start, p_end-1, node_start);
+				addr_start = addr;
+				node_start = node;
+				p_start = p;
+			}
+
+			addr_end = addr + PMD_SIZE;
+			p_end = p + PMD_SIZE;
+		} else
+			vmemmap_verify((pte_t *)pmd, node, addr, next);
 	}
-	sync_global_pgds(start, end - 1);
 	return 0;
 }
 
+int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node)
+{
+	int err;
+
+	if (cpu_has_pse)
+		err = vmemmap_populate_hugepages(start, end, node);
+	else
+		err = vmemmap_populate_basepages(start, end, node);
+	if (!err)
+		sync_global_pgds(start, end - 1);
+	return err;
+}
+
 #if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_HAVE_BOOTMEM_INFO_NODE)
 void register_page_bootmem_memmap(unsigned long section_nr,
 				  struct page *start_page, unsigned long size)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-keep-prevs-css-alive-for-the-whole-mem_cgroup_iter.patch
memcg-rework-mem_cgroup_iter-to-use-cgroup-iterators.patch
memcg-relax-memcg-iter-caching.patch
memcg-simplify-mem_cgroup_iter.patch
memcg-further-simplify-mem_cgroup_iter.patch
cgroup-remove-css_get_next.patch
memcg-do-not-check-for-do_swap_account-in-mem_cgroup_readwritereset.patch
mm-try-harder-to-allocate-vmemmap-blocks.patch
sparse-vmemmap-specify-vmemmap-population-range-in-bytes.patch
x86-64-remove-dead-debugging-code-for-pse-setups.patch
x86-64-use-vmemmap_populate_basepages-for-pse-setups.patch
x86-64-fall-back-to-regular-page-vmemmap-on-allocation-failure.patch
mm-memmap_init_zone-performance-improvement.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
ipc-refactor-msg-list-search-into-separate-function-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

