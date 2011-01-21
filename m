From: akpm@linux-foundation.org
Subject: [merged] thp-keep-highpte-mapped-until-it-is-no-longer-needed.patch removed from -mm tree
Date: Fri, 21 Jan 2011 12:31:22 -0800
Message-ID: <201101212031.p0LKVMf3031600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751577Ab1AUUn2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Jan 2011 15:43:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, aarcange@redhat.com, idryomov@gmail.com, rostedt@goodmis.org, w.landgraf@ru.ru, mm-commits@vger.kernel.org


The patch titled
     thp: keep highpte mapped until it is no longer needed
has been removed from the -mm tree.  Its filename was
     thp-keep-highpte-mapped-until-it-is-no-longer-needed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: keep highpte mapped until it is no longer needed
From: Johannes Weiner <hannes@cmpxchg.org>

Two users reported THP-related crashes on 32-bit x86 machines.  Their oops
reports indicated an invalid pte, and subsequent code inspection showed
that the highpte is actually used after unmap.

The fix is to unmap the pte only after all operations against it are
finished.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Ilya Dryomov <idryomov@gmail.com>
Reported-by: werner <w.landgraf@ru.ru>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Tested-by: Ilya Dryomov <idryomov@gmail.com>
Tested-by: Steven Rostedt <rostedt@goodmis.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-keep-highpte-mapped-until-it-is-no-longer-needed mm/huge_memory.c
--- a/mm/huge_memory.c~thp-keep-highpte-mapped-until-it-is-no-longer-needed
+++ a/mm/huge_memory.c
@@ -1837,9 +1837,9 @@ static void collapse_huge_page(struct mm
 	spin_lock(ptl);
 	isolated = __collapse_huge_page_isolate(vma, address, pte);
 	spin_unlock(ptl);
-	pte_unmap(pte);
 
 	if (unlikely(!isolated)) {
+		pte_unmap(pte);
 		spin_lock(&mm->page_table_lock);
 		BUG_ON(!pmd_none(*pmd));
 		set_pmd_at(mm, address, pmd, _pmd);
@@ -1856,6 +1856,7 @@ static void collapse_huge_page(struct mm
 	anon_vma_unlock(vma->anon_vma);
 
 	__collapse_huge_page_copy(pte, new_page, vma, address, ptl);
+	pte_unmap(pte);
 	__SetPageUptodate(new_page);
 	pgtable = pmd_pgtable(_pmd);
 	VM_BUG_ON(page_count(pgtable) != 1);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch

