From: akpm@linux-foundation.org
Subject: [folded-merged] x86-64-use-vmemmap_populate_basepages-for-pse-setups-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:47:59 -0700
Message-ID: <20130429214759.BA50D5A4034@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:49214 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758296Ab3D2VsA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:48:00 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so478883qea.0
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:48:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-64: use vmemmap_populate_basepages() for !pse setups fix
has been removed from the -mm tree.  Its filename was
     x86-64-use-vmemmap_populate_basepages-for-pse-setups-fix.patch

This patch was dropped because it was folded into x86-64-use-vmemmap_populate_basepages-for-pse-setups.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: x86-64: use vmemmap_populate_basepages() for !pse setups fix

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/init_64.c~x86-64-use-vmemmap_populate_basepages-for-pse-setups-fix arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86-64-use-vmemmap_populate_basepages-for-pse-setups-fix
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
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim.patch
memcg-avoid-accessing-memcg-after-releasing-reference.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0.patch
mm-memcg-give-exiting-processes-access-to-memory-reserves.patch
swap-redirty-page-if-page-write-fails-on-swap-file.patch
mm-nobootmem-clean-up-of-free_low_memory_core_early.patch
mm-nobootmem-do-memset-after-memblock_reserve.patch
mem-hotunplug-fix-kfree-of-bootmem-memory.patch
mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch
memcg-take-reference-before-releasing-rcu_read_lock.patch

