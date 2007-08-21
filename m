From: akpm@linux-foundation.org
Subject: + flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch added to -mm tree
Date: Tue, 21 Aug 2007 13:20:03 -0700
Message-ID: <200708212020.l7LKK3qT009020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40285 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbXHUUWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Aug 2007 16:22:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com, davem@davemloft.net, hugh@veritas.com, nickpiggin@yahoo.com.au, tony.luck@intel.com


The patch titled
     small fix for ia64 icache sync patch
has been added to the -mm tree.  Its filename is
     flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: small fix for ia64 icache sync patch
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Fixing 2 small issues pointed by Tony Luck.

* removing redundant BUG_ON in __ia64_sync_icache_dcache().
* check pte_present() first.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c        |    2 --
 include/asm-ia64/pgtable.h |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/ia64/mm/init.c~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix
+++ a/arch/ia64/mm/init.c
@@ -60,8 +60,6 @@ __ia64_sync_icache_dcache (pte_t pte)
 	struct page *page;
 	unsigned long order;
 
-	BUG_ON(!pte_exec(pte));
-
 	page = pte_page(pte);
 	addr = (unsigned long) page_address(page);
 
diff -puN include/asm-ia64/pgtable.h~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix include/asm-ia64/pgtable.h
--- a/include/asm-ia64/pgtable.h~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix
+++ a/include/asm-ia64/pgtable.h
@@ -327,8 +327,8 @@ ia64_phys_addr_valid (unsigned long addr
 extern void __ia64_sync_icache_dcache(pte_t pteval);
 static inline void set_pte(pte_t *ptep, pte_t pteval)
 {
-	if (pte_exec(pteval) &&    // flush only new executable page.
-	    pte_present(pteval) && // swap out ?
+	if (pte_present(pteval) &&// swap out ?
+	    pte_exec(pteval) &&    // flush only new executable page.
 	    pte_user(pteval) &&    // ignore kernel page
 	    (!pte_present(*ptep) ||// do_no_page or swap in, migration,
 		pte_pfn(*ptep) != pte_pfn(pteval))) // do_wp_page(), page copy
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
memoryless-nodes-fix-interleave-behavior-for-memoryless-nodes.patch
memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-nodes-slab-support.patch
memoryless-nodes-slub-support.patch
memoryless-nodes-uncached-allocator-updates.patch
memoryless-nodes-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
memoryless-nodes-add-n_cpu-node-state.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-n_high_memory-for-cpusets.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-unplug-v7-ia64-interface.patch
