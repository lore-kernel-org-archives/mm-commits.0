From: akpm@linux-foundation.org
Subject: + x86-64-fall-back-to-regular-page-vmemmap-on-allocation-failure.patch added to -mm tree
Date: Thu, 21 Mar 2013 12:59:07 -0700
Message-ID: <20130321195907.CC13431C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:55218 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab3CUT7J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 15:59:09 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so297221qen.4
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 12:59:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, Bernhard.Schmidt@lrz.de, ben@decadent.org.uk, benh@kernel.crashing.org, davem@davemloft.net, heiko.carstens@de.ibm.com, hpa@zytor.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     Subject: x86-64: fall back to regular page vmemmap on allocation failure
has been added to the -mm tree.  Its filename is
     x86-64-fall-back-to-regular-page-vmemmap-on-allocation-failure.patch

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
Subject: x86-64: fall back to regular page vmemmap on allocation failure

Memory hotplug can happen on a machine under load, memory shortness
and fragmentation, so huge page allocations for the vmemmap are not
guaranteed to succeed.

Try to fall back to regular pages before failing the hotplug event
completely.

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

 arch/x86/mm/init_64.c |   49 +++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff -puN arch/x86/mm/init_64.c~x86-64-fall-back-to-regular-page-vmemmap-on-allocation-failure arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86-64-fall-back-to-regular-page-vmemmap-on-allocation-failure
+++ a/arch/x86/mm/init_64.c
@@ -1285,11 +1285,14 @@ static int __meminit vmemmap_populate_hu
 						unsigned long end, int node)
 {
 	unsigned long addr;
+	unsigned long next;
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
 
-	for (addr = start; addr < end; addr += PMD_SIZE) {
+	for (addr = start; addr < end; addr = next) {
+		next = pmd_addr_end(addr, end);
+
 		pgd = vmemmap_pgd_populate(addr, node);
 		if (!pgd)
 			return -ENOMEM;
@@ -1300,31 +1303,37 @@ static int __meminit vmemmap_populate_hu
 
 		pmd = pmd_offset(pud, addr);
 		if (pmd_none(*pmd)) {
-			pte_t entry;
 			void *p;
 
 			p = vmemmap_alloc_block_buf(PMD_SIZE, node);
-			if (!p)
-				return -ENOMEM;
+			if (p) {
+				pte_t entry;
 
-			entry = pfn_pte(__pa(p) >> PAGE_SHIFT,
-					PAGE_KERNEL_LARGE);
-			set_pmd(pmd, __pmd(pte_val(entry)));
-
-			/* check to see if we have contiguous blocks */
-			if (p_end != p || node_start != node) {
-				if (p_start)
-					printk(KERN_DEBUG " [%lx-%lx] PMD -> [%p-%p] on node %d\n",
-					       addr_start, addr_end-1, p_start, p_end-1, node_start);
-				addr_start = addr;
-				node_start = node;
-				p_start = p;
+				entry = pfn_pte(__pa(p) >> PAGE_SHIFT,
+						PAGE_KERNEL_LARGE);
+				set_pmd(pmd, __pmd(pte_val(entry)));
+
+				/* check to see if we have contiguous blocks */
+				if (p_end != p || node_start != node) {
+					if (p_start)
+						printk(KERN_DEBUG " [%lx-%lx] PMD -> [%p-%p] on node %d\n",
+						       addr_start, addr_end-1, p_start, p_end-1, node_start);
+					addr_start = addr;
+					node_start = node;
+					p_start = p;
+				}
+
+				addr_end = addr + PMD_SIZE;
+				p_end = p + PMD_SIZE;
+				continue;
 			}
-
-			addr_end = addr + PMD_SIZE;
-			p_end = p + PMD_SIZE;
-		} else
+		} else if (pmd_large(*pmd)) {
 			vmemmap_verify((pte_t *)pmd, node, addr, next);
+			continue;
+		}
+		pr_warn_once("vmemmap: falling back to regular page backing\n");
+		if (vmemmap_populate_basepages(addr, next, node))
+			return -ENOMEM;
 	}
 	return 0;
 }
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

