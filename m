From: akpm@linux-foundation.org
Subject: - mm-dirty-page-accounting-vs-vm_mixedmap.patch removed from -mm tree
Date: Sun, 06 Jul 2008 19:57:56 -0700
Message-ID: <200807070257.m672vuku004405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752310AbYGGC6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 22:58:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, hugh@veritas.com, jaredeh@gmail.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: dirty page accounting vs VM_MIXEDMAP
has been removed from the -mm tree.  Its filename was
     mm-dirty-page-accounting-vs-vm_mixedmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: dirty page accounting vs VM_MIXEDMAP
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Dirty page accounting accurately measures the amound of dirty pages in
writable shared mappings by mapping the pages RO (as indicated by
vma_wants_writenotify).  We then trap on first write and call
set_page_dirty() on the page, after which we map the page RW and
continue execution.

When we launder dirty pages, we call clear_page_dirty_for_io() which
clears both the dirty flag, and maps the page RO again before we start
writeout so that the story can repeat itself.

vma_wants_writenotify() excludes VM_PFNMAP on the basis that we cannot
do the regular dirty page stuff on raw PFNs and the memory isn't going
anywhere anyway.

The recently introduced VM_MIXEDMAP mixes both !pfn_valid() and
pfn_valid() pages in a single mapping.

We can't do dirty page accounting on !pfn_valid() pages as stated
above, and mapping them RO causes them to be COW'ed on write, which
breaks VM_SHARED semantics.

Excluding VM_MIXEDMAP in vma_wants_writenotify() would mean we don't do
the regular dirty page accounting for the pfn_valid() pages, which
would bring back all the head-aches from inaccurate dirty page
accounting.

So instead, we let the !pfn_valid() pages get mapped RO, but fix them
up unconditionally in the fault path.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Acked-by: Hugh Dickins <hugh@veritas.com>
Cc: "Jared Hulbert" <jaredeh@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~mm-dirty-page-accounting-vs-vm_mixedmap mm/memory.c
--- a/mm/memory.c~mm-dirty-page-accounting-vs-vm_mixedmap
+++ a/mm/memory.c
@@ -1697,8 +1697,19 @@ static int do_wp_page(struct mm_struct *
 	struct page *dirty_page = NULL;
 
 	old_page = vm_normal_page(vma, address, orig_pte);
-	if (!old_page)
+	if (!old_page) {
+		/*
+		 * VM_MIXEDMAP !pfn_valid() case
+		 *
+		 * We should not cow pages in a shared writeable mapping.
+		 * Just mark the pages writable as we can't do any dirty
+		 * accounting on raw pfn maps.
+		 */
+		if ((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
+				     (VM_WRITE|VM_SHARED))
+			goto reuse;
 		goto gotten;
+	}
 
 	/*
 	 * Take out anonymous pages first, anonymous shared vmas are
@@ -1751,6 +1762,7 @@ static int do_wp_page(struct mm_struct *
 	}
 
 	if (reuse) {
+reuse:
 		flush_cache_page(vma, address, pte_pfn(orig_pte));
 		entry = pte_mkyoung(orig_pte);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

linux-next.patch
access_process_vm-device-memory-infrastructure.patch
access_process_vm-device-memory-infrastructure-fix.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifiers-add-mm_take_all_locks-operation-checkpatch-fixes.patch
mmu-notifier-core.patch
mmu-notifier-core-fix.patch
mmu-notifier-core-fix-2.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch

