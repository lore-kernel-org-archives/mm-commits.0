From: akpm@linux-foundation.org
Subject: [merged] thp-split_huge_page-paging.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:07 -0800
Message-ID: <201101142249.p0EMnvnC005342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861Ab1ANWuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: split_huge_page paging
has been removed from the -mm tree.  Its filename was
     thp-split_huge_page-paging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: split_huge_page paging
From: Andrea Arcangeli <aarcange@redhat.com>

Paging logic that splits the page before it is unmapped and added to swap
to ensure backwards compatibility with the legacy swap code.  Eventually
swap should natively pageout the hugepages to increase performance and
decrease seeking and fragmentation of swap space.  swapoff can just skip
over huge pmd as they cannot be part of swap yet.  In add_to_swap be
careful to split the page only if we got a valid swap entry so we don't
split hugepages with a full swap.

In theory we could split pages before isolating them during the lru scan,
but for khugepaged to be safe, I'm relying on either mmap_sem write mode,
or PG_lock taken, so split_huge_page has to run either with mmap_sem
read/write mode or PG_lock taken.  Calling it from isolate_lru_page would
make locking more complicated, in addition to that split_huge_page would
deadlock if called by __isolate_lru_page because it has to take the lru
lock to add the tail pages.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 ++
 mm/rmap.c           |    1 +
 mm/swap_state.c     |    6 ++++++
 mm/swapfile.c       |    2 ++
 4 files changed, 11 insertions(+)

diff -puN mm/memory-failure.c~thp-split_huge_page-paging mm/memory-failure.c
--- a/mm/memory-failure.c~thp-split_huge_page-paging
+++ a/mm/memory-failure.c
@@ -386,6 +386,8 @@ static void collect_procs_anon(struct pa
 	struct task_struct *tsk;
 	struct anon_vma *av;
 
+	if (unlikely(split_huge_page(page)))
+		return;
 	read_lock(&tasklist_lock);
 	av = page_lock_anon_vma(page);
 	if (av == NULL)	/* Not actually mapped anymore */
diff -puN mm/rmap.c~thp-split_huge_page-paging mm/rmap.c
--- a/mm/rmap.c~thp-split_huge_page-paging
+++ a/mm/rmap.c
@@ -1400,6 +1400,7 @@ int try_to_unmap(struct page *page, enum
 	int ret;
 
 	BUG_ON(!PageLocked(page));
+	BUG_ON(PageTransHuge(page));
 
 	if (unlikely(PageKsm(page)))
 		ret = try_to_unmap_ksm(page, flags);
diff -puN mm/swap_state.c~thp-split_huge_page-paging mm/swap_state.c
--- a/mm/swap_state.c~thp-split_huge_page-paging
+++ a/mm/swap_state.c
@@ -157,6 +157,12 @@ int add_to_swap(struct page *page)
 	if (!entry.val)
 		return 0;
 
+	if (unlikely(PageTransHuge(page)))
+		if (unlikely(split_huge_page(page))) {
+			swapcache_free(entry, NULL);
+			return 0;
+		}
+
 	/*
 	 * Radix-tree node allocations from PF_MEMALLOC contexts could
 	 * completely exhaust the page allocator. __GFP_NOMEMALLOC
diff -puN mm/swapfile.c~thp-split_huge_page-paging mm/swapfile.c
--- a/mm/swapfile.c~thp-split_huge_page-paging
+++ a/mm/swapfile.c
@@ -964,6 +964,8 @@ static inline int unuse_pmd_range(struct
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
+		if (unlikely(pmd_trans_huge(*pmd)))
+			continue;
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
 		ret = unuse_pte_range(vma, pmd, addr, next, entry, page);
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

