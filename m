From: akpm@linux-foundation.org
Subject: [merged] thp-split_huge_page_mm-vma.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:05 -0800
Message-ID: <201101142249.p0EMntu7005339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868Ab1ANWuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hannes@cmpxchg.org, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: split_huge_page_mm/vma
has been removed from the -mm tree.  Its filename was
     thp-split_huge_page_mm-vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: split_huge_page_mm/vma
From: Andrea Arcangeli <aarcange@redhat.com>

split_huge_page_pmd compat code.  Each one of those would need to be
expanded to hundred of lines of complex code without a fully reliable
split_huge_page_pmd design.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/vm86_32.c |    1 +
 mm/mempolicy.c            |    1 +
 mm/mincore.c              |    1 +
 mm/mprotect.c             |    1 +
 mm/mremap.c               |    1 +
 mm/pagewalk.c             |    1 +
 6 files changed, 6 insertions(+)

diff -puN arch/x86/kernel/vm86_32.c~thp-split_huge_page_mm-vma arch/x86/kernel/vm86_32.c
--- a/arch/x86/kernel/vm86_32.c~thp-split_huge_page_mm-vma
+++ a/arch/x86/kernel/vm86_32.c
@@ -179,6 +179,7 @@ static void mark_screen_rdonly(struct mm
 	if (pud_none_or_clear_bad(pud))
 		goto out;
 	pmd = pmd_offset(pud, 0xA0000);
+	split_huge_page_pmd(mm, pmd);
 	if (pmd_none_or_clear_bad(pmd))
 		goto out;
 	pte = pte_offset_map_lock(mm, pmd, 0xA0000, &ptl);
diff -puN mm/mempolicy.c~thp-split_huge_page_mm-vma mm/mempolicy.c
--- a/mm/mempolicy.c~thp-split_huge_page_mm-vma
+++ a/mm/mempolicy.c
@@ -514,6 +514,7 @@ static inline int check_pmd_range(struct
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
+		split_huge_page_pmd(vma->vm_mm, pmd);
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
 		if (check_pte_range(vma, pmd, addr, next, nodes,
diff -puN mm/mincore.c~thp-split_huge_page_mm-vma mm/mincore.c
--- a/mm/mincore.c~thp-split_huge_page_mm-vma
+++ a/mm/mincore.c
@@ -154,6 +154,7 @@ static void mincore_pmd_range(struct vm_
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
+		split_huge_page_pmd(vma->vm_mm, pmd);
 		if (pmd_none_or_clear_bad(pmd))
 			mincore_unmapped_range(vma, addr, next, vec);
 		else
diff -puN mm/mprotect.c~thp-split_huge_page_mm-vma mm/mprotect.c
--- a/mm/mprotect.c~thp-split_huge_page_mm-vma
+++ a/mm/mprotect.c
@@ -88,6 +88,7 @@ static inline void change_pmd_range(stru
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
+		split_huge_page_pmd(mm, pmd);
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
 		change_pte_range(mm, pmd, addr, next, newprot, dirty_accountable);
diff -puN mm/mremap.c~thp-split_huge_page_mm-vma mm/mremap.c
--- a/mm/mremap.c~thp-split_huge_page_mm-vma
+++ a/mm/mremap.c
@@ -41,6 +41,7 @@ static pmd_t *get_old_pmd(struct mm_stru
 		return NULL;
 
 	pmd = pmd_offset(pud, addr);
+	split_huge_page_pmd(mm, pmd);
 	if (pmd_none_or_clear_bad(pmd))
 		return NULL;
 
diff -puN mm/pagewalk.c~thp-split_huge_page_mm-vma mm/pagewalk.c
--- a/mm/pagewalk.c~thp-split_huge_page_mm-vma
+++ a/mm/pagewalk.c
@@ -34,6 +34,7 @@ static int walk_pmd_range(pud_t *pud, un
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
+		split_huge_page_pmd(walk->mm, pmd);
 		if (pmd_none_or_clear_bad(pmd)) {
 			if (walk->pte_hole)
 				err = walk->pte_hole(addr, next, walk);
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

