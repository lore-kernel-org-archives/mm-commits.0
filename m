From: akpm@linux-foundation.org
Subject: - mm-introduce-non-panic-alloc_bootmem.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:23:09 -0700
Message-ID: <200807242323.m6ONN9KE010631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753458AbYGXXXN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:23:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: introduce non panic alloc_bootmem
has been removed from the -mm tree.  Its filename was
     mm-introduce-non-panic-alloc_bootmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: introduce non panic alloc_bootmem
From: Nick Piggin <npiggin@suse.de>

Straight forward variant of the existing __alloc_bootmem_node, only
subsequent patch when allocating giant hugepages at boot -- don't want to
panic if we can't allocate as many as the user asked for.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    4 ++++
 mm/bootmem.c            |   12 ++++++++++++
 2 files changed, 16 insertions(+)

diff -puN include/linux/bootmem.h~mm-introduce-non-panic-alloc_bootmem include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-introduce-non-panic-alloc_bootmem
+++ a/include/linux/bootmem.h
@@ -89,6 +89,10 @@ extern void *__alloc_bootmem_node(pg_dat
 				  unsigned long size,
 				  unsigned long align,
 				  unsigned long goal);
+extern void *__alloc_bootmem_node_nopanic(pg_data_t *pgdat,
+				  unsigned long size,
+				  unsigned long align,
+				  unsigned long goal);
 extern unsigned long init_bootmem_node(pg_data_t *pgdat,
 				       unsigned long freepfn,
 				       unsigned long startpfn,
diff -puN mm/bootmem.c~mm-introduce-non-panic-alloc_bootmem mm/bootmem.c
--- a/mm/bootmem.c~mm-introduce-non-panic-alloc_bootmem
+++ a/mm/bootmem.c
@@ -578,6 +578,18 @@ void * __init alloc_bootmem_section(unsi
 }
 #endif
 
+void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
+				   unsigned long align, unsigned long goal)
+{
+	void *ptr;
+
+	ptr = alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
+	if (ptr)
+		return ptr;
+
+	return __alloc_bootmem_nopanic(size, align, goal);
+}
+
 #ifndef ARCH_LOW_ADDRESS_LIMIT
 #define ARCH_LOW_ADDRESS_LIMIT	0xffffffffUL
 #endif
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-add_to_page_cache.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

