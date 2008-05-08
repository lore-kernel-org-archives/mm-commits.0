From: akpm@linux-foundation.org
Subject: - improve-zero_page-handling-in-follow_page.patch removed from -mm tree
Date: Thu, 08 May 2008 14:28:45 -0700
Message-ID: <200805082139.m48LdetJ007105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764714AbYEHVkY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 17:40:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, hugh@veritas.com, npiggin@suse.de, tonyb@cybernetics.com, mm-commits@vger.kernel.org


The patch titled
     improve ZERO_PAGE handling in follow_page()
has been removed from the -mm tree.  Its filename was
     improve-zero_page-handling-in-follow_page.patch

This patch was dropped because compilation failed. Please redo and resend

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: improve ZERO_PAGE handling in follow_page()
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

follow_page() is called from get_user_pages(), which returns specified user
page.

follow_page() can return 1) a page or 2) NULL or 3)ZERO_PAGE.
If NULL, handle_mm_fault() is called.

Now, follow_page() to unused pte returns NULL if page table exists.  As a
result get_user_pages() calls handle_mm_fault() and allocate new memory.  This
behavior increases memory consumption at coredump, which does
read-once-but-never-written page fault.  By returning ZERO_PAGE() against
READ/ANON request, we can avoid it.

(Because exec's arguments copy needs to call handle_mm_fault at WRITE/ANON
 request, we just handle READ/ANON case here.)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: Tony Battersby <tonyb@cybernetics.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN mm/memory.c~improve-zero_page-handling-in-follow_page mm/memory.c
--- a/mm/memory.c~improve-zero_page-handling-in-follow_page
+++ a/mm/memory.c
@@ -992,15 +992,15 @@ struct page *follow_page(struct vm_area_
 	page = NULL;
 	pgd = pgd_offset(mm, address);
 	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
-		goto no_page_table;
+		goto null_or_zeropage;
 
 	pud = pud_offset(pgd, address);
 	if (pud_none(*pud) || unlikely(pud_bad(*pud)))
-		goto no_page_table;
+		goto null_or_zeropage;
 	
 	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd))
-		goto no_page_table;
+		goto null_or_zeropage;
 
 	if (pmd_huge(*pmd)) {
 		BUG_ON(flags & FOLL_GET);
@@ -1016,8 +1016,14 @@ struct page *follow_page(struct vm_area_
 		goto out;
 
 	pte = *ptep;
-	if (!pte_present(pte))
+	if (!pte_present(pte)) {
+		/* Read fault to empty pte can return ZERO_PAGE */
+		if (!(flags & FOLL_WRITE) && pte_none(pte)) {
+			pte_unmap_unlock(ptep, ptl);
+			goto null_or_zeropage;
+		}
 		goto unlock;
+	}
 	if ((flags & FOLL_WRITE) && !pte_write(pte))
 		goto unlock;
 	page = vm_normal_page(vma, address, pte);
@@ -1037,7 +1043,7 @@ unlock:
 out:
 	return page;
 
-no_page_table:
+null_or_zeropage:
 	/*
 	 * When core dumping an enormous anonymous area that nobody
 	 * has touched so far, we don't want to allocate page tables.
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memcg-fix-possible-panic-when-config_mm_owner=y.patch
memcg-fix-possible-panic-when-config_mm_owner=y-checkpatch-fixes.patch
cgroups-fix-documentation.patch
improve-zero_page-handling-in-follow_page.patch
mark-res_counter_charge_locked-with-__must_check.patch

