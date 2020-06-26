From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 15/32] mm/memory.c: properly
 pte_offset_map_lock/unlock in vm_insert_pages()
Date: Thu, 25 Jun 2020 20:30:01 -0700
Message-ID: <20200626033001.XJbNOSWZY%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728333AbgFZDaC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 23:30:02 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjunroy@google.com, edumazet@google.com, hughd@google.com, mm-commits@vger.kernel.org, rientjes@google.com, soheil@google.com, torvalds@linux-foundation.org

From: Arjun Roy <arjunroy@google.com>
Subject: mm/memory.c: properly pte_offset_map_lock/unlock in vm_insert_pages()

Calls to pte_offset_map() in vm_insert_pages() are erroneously not matched
with a call to pte_unmap().  This would cause problems on architectures
where that is not a no-op.

This patch does away with the non-traditional locking in the existing
code, and instead uses pte_offset_map_lock/unlock() as usual, incrementing
PTE as necessary.  The PTE pointer is kept within bounds since we clamp it
with PTRS_PER_PTE.

Link: http://lkml.kernel.org/r/20200618220446.20284-1-arjunroy.kdev@gmail.com
Fixes: 8cd3984d81d5 ("mm/memory.c: add vm_insert_pages()")
Signed-off-by: Arjun Roy <arjunroy@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/mm/memory.c~mm-memoryc-properly-pte_offset_map_lock-unlock-in-vm_insert_pages
+++ a/mm/memory.c
@@ -1498,7 +1498,7 @@ out:
 }
 
 #ifdef pte_index
-static int insert_page_in_batch_locked(struct mm_struct *mm, pmd_t *pmd,
+static int insert_page_in_batch_locked(struct mm_struct *mm, pte_t *pte,
 			unsigned long addr, struct page *page, pgprot_t prot)
 {
 	int err;
@@ -1506,8 +1506,9 @@ static int insert_page_in_batch_locked(s
 	if (!page_count(page))
 		return -EINVAL;
 	err = validate_page_before_insert(page);
-	return err ? err : insert_page_into_pte_locked(
-		mm, pte_offset_map(pmd, addr), addr, page, prot);
+	if (err)
+		return err;
+	return insert_page_into_pte_locked(mm, pte, addr, page, prot);
 }
 
 /* insert_pages() amortizes the cost of spinlock operations
@@ -1517,7 +1518,8 @@ static int insert_pages(struct vm_area_s
 			struct page **pages, unsigned long *num, pgprot_t prot)
 {
 	pmd_t *pmd = NULL;
-	spinlock_t *pte_lock = NULL;
+	pte_t *start_pte, *pte;
+	spinlock_t *pte_lock;
 	struct mm_struct *const mm = vma->vm_mm;
 	unsigned long curr_page_idx = 0;
 	unsigned long remaining_pages_total = *num;
@@ -1536,18 +1538,17 @@ more:
 	ret = -ENOMEM;
 	if (pte_alloc(mm, pmd))
 		goto out;
-	pte_lock = pte_lockptr(mm, pmd);
 
 	while (pages_to_write_in_pmd) {
 		int pte_idx = 0;
 		const int batch_size = min_t(int, pages_to_write_in_pmd, 8);
 
-		spin_lock(pte_lock);
-		for (; pte_idx < batch_size; ++pte_idx) {
-			int err = insert_page_in_batch_locked(mm, pmd,
+		start_pte = pte_offset_map_lock(mm, pmd, addr, &pte_lock);
+		for (pte = start_pte; pte_idx < batch_size; ++pte, ++pte_idx) {
+			int err = insert_page_in_batch_locked(mm, pte,
 				addr, pages[curr_page_idx], prot);
 			if (unlikely(err)) {
-				spin_unlock(pte_lock);
+				pte_unmap_unlock(start_pte, pte_lock);
 				ret = err;
 				remaining_pages_total -= pte_idx;
 				goto out;
@@ -1555,7 +1556,7 @@ more:
 			addr += PAGE_SIZE;
 			++curr_page_idx;
 		}
-		spin_unlock(pte_lock);
+		pte_unmap_unlock(start_pte, pte_lock);
 		pages_to_write_in_pmd -= batch_size;
 		remaining_pages_total -= batch_size;
 	}
_
