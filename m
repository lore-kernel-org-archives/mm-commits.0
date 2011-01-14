From: akpm@linux-foundation.org
Subject: [merged] thp-transparent-hugepage-core-fixlet.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:20 -0800
Message-ID: <201101142250.p0EMoAM0005377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753877Ab1ANWuT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, hannes@cmpxchg.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: transparent hugepage core fixlet
has been removed from the -mm tree.  Its filename was
     thp-transparent-hugepage-core-fixlet.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: transparent hugepage core fixlet
From: Hugh Dickins <hughd@google.com>

If you configure THP in addition to HUGETLB_PAGE on x86_32 without PAE,
the p?d-folding works out that munlock_vma_pages_range() can crash to
follow_page()'s pud_huge() BUG_ON(flags & FOLL_GET): it needs the same
VM_HUGETLB check already there on the pmd_huge() line.  Conveniently,
openSUSE provides a "blogd" which tests this out at startup!

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~thp-transparent-hugepage-core-fixlet mm/memory.c
--- a/mm/memory.c~thp-transparent-hugepage-core-fixlet
+++ a/mm/memory.c
@@ -1288,7 +1288,7 @@ struct page *follow_page(struct vm_area_
 	pud = pud_offset(pgd, address);
 	if (pud_none(*pud))
 		goto no_page_table;
-	if (pud_huge(*pud)) {
+	if (pud_huge(*pud) && vma->vm_flags & VM_HUGETLB) {
 		BUG_ON(flags & FOLL_GET);
 		page = follow_huge_pud(mm, address, pud, flags & FOLL_WRITE);
 		goto out;
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-vmap-area-cache-fix.patch
prio_tree-debugging-patch.patch

