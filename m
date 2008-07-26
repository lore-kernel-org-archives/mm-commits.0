From: akpm@linux-foundation.org
Subject: - mm-readahead-scan-lockless.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:15:57 -0700
Message-ID: <200807262115.m6QLFvI1019780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757703AbYGZVQb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:16:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, hugh@veritas.com, paulmck@us.ibm.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     mm: readahead scan lockless
has been removed from the -mm tree.  Its filename was
     mm-readahead-scan-lockless.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: readahead scan lockless
From: Nick Piggin <npiggin@suse.de>

radix_tree_next_hole() is implemented as a series of radix_tree_lookup()s.
 So it can be called locklessly, under rcu_read_lock().

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Reviewed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/readahead.c~mm-readahead-scan-lockless mm/readahead.c
--- a/mm/readahead.c~mm-readahead-scan-lockless
+++ a/mm/readahead.c
@@ -382,9 +382,9 @@ ondemand_readahead(struct address_space 
 	if (hit_readahead_marker) {
 		pgoff_t start;
 
-		read_lock_irq(&mapping->tree_lock);
-		start = radix_tree_next_hole(&mapping->page_tree, offset, max+1);
-		read_unlock_irq(&mapping->tree_lock);
+		rcu_read_lock();
+		start = radix_tree_next_hole(&mapping->page_tree, offset,max+1);
+		rcu_read_unlock();
 
 		if (!start || start - offset > max)
 			return 0;
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
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

