From: akpm@linux-foundation.org
Subject: + flush-icache-before-set_pte-on-ia64-migration-fix.patch added to -mm tree
Date: Thu, 09 Aug 2007 13:47:37 -0700
Message-ID: <200708092047.l79KlbV8018656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55653 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756252AbXHIUxN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:53:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com, davem@davemloft.net, hugh@veritas.com, nickpiggin@yahoo.com.au, tony.luck@intel.com


The patch titled
     flush icache before set_pte() on ia64: migration fix
has been added to the -mm tree.  Its filename is
     flush-icache-before-set_pte-on-ia64-migration-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: flush icache before set_pte() on ia64: migration fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

In migration, a new page should be cache flushed before set_pte() in some
archs which have virtually-tagged cache..  I'll separate this from patch set
in the next time.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN mm/migrate.c~flush-icache-before-set_pte-on-ia64-migration-fix mm/migrate.c
--- a/mm/migrate.c~flush-icache-before-set_pte-on-ia64-migration-fix
+++ a/mm/migrate.c
@@ -171,6 +171,7 @@ static void remove_migration_pte(struct 
 	pte = pte_mkold(mk_pte(new, vma->vm_page_prot));
 	if (is_write_migration_entry(entry))
 		pte = pte_mkwrite(pte);
+	flush_cache_page(vma, addr, pte_pfn(pte));
 	set_pte_at(mm, addr, ptep, pte);
 
 	if (PageAnon(new))
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memory-hotplug-document-take-3.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-fix.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
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
flush-icache-before-set_pte-on-ia64-migration-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-unplug-v7-ia64-interface.patch
