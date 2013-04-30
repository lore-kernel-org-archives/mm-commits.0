From: akpm@linux-foundation.org
Subject: [merged] x86-64-fall-back-to-regular-page-vmemmap-on-allocation-failure.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:48:16 -0700
Message-ID: <20130430184816.A166031C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:53931 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab3D3SsS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:48:18 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so85161vcb.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:48:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, Bernhard.Schmidt@lrz.de, ben@decadent.org.uk, benh@kernel.crashing.org, davem@davemloft.net, heiko.carstens@de.ibm.com, hpa@zytor.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-64: fall back to regular page vmemmap on allocation failure
has been removed from the -mm tree.  Its filename was
     x86-64-fall-back-to-regular-page-vmemmap-on-allocation-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 arch/x86/mm/init_64.c |   42 ++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff -puN arch/x86/mm/init_64.c~x86-64-fall-back-to-regular-page-vmemmap-on-allocation-failure arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86-64-fall-back-to-regular-page-vmemmap-on-allocation-failure
+++ a/arch/x86/mm/init_64.c
@@ -1303,31 +1303,37 @@ static int __meminit vmemmap_populate_hu
 
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
+				entry = pfn_pte(__pa(p) >> PAGE_SHIFT,
+						PAGE_KERNEL_LARGE);
+				set_pmd(pmd, __pmd(pte_val(entry)));
 
-			/* check to see if we have contiguous blocks */
-			if (p_end != p || node_start != node) {
-				if (p_start)
-					printk(KERN_DEBUG " [%lx-%lx] PMD -> [%p-%p] on node %d\n",
-					       addr_start, addr_end-1, p_start, p_end-1, node_start);
-				addr_start = addr;
-				node_start = node;
-				p_start = p;
-			}
+				/* check to see if we have contiguous blocks */
+				if (p_end != p || node_start != node) {
+					if (p_start)
+						printk(KERN_DEBUG " [%lx-%lx] PMD -> [%p-%p] on node %d\n",
+						       addr_start, addr_end-1, p_start, p_end-1, node_start);
+					addr_start = addr;
+					node_start = node;
+					p_start = p;
+				}
 
-			addr_end = addr + PMD_SIZE;
-			p_end = p + PMD_SIZE;
-		} else
+				addr_end = addr + PMD_SIZE;
+				p_end = p + PMD_SIZE;
+				continue;
+			}
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

origin.patch
mm-memmap_init_zone-performance-improvement.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
ipc-refactor-msg-list-search-into-separate-function-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

