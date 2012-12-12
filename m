From: akpm@linux-foundation.org
Subject: [merged] thp-introduce-hugepage_vma_check.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:57:12 -0800
Message-ID: <20121212195713.537CA20005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f201.google.com ([209.85.215.201]:35878 "EHLO
	mail-ea0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLT5Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:57:16 -0500
Received: by mail-ea0-f201.google.com with SMTP id b14so63929eaa.0
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:57:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, aarcange@redhat.com, mhocko@suse.cz, minchan.kim@gmail.com, nizhan.chen@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: introduce hugepage_vma_check()
has been removed from the -mm tree.  Its filename was
     thp-introduce-hugepage_vma_check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: thp: introduce hugepage_vma_check()

Multiple places do the same check.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Ni zhan Chen <nizhan.chen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff -puN mm/huge_memory.c~thp-introduce-hugepage_vma_check mm/huge_memory.c
--- a/mm/huge_memory.c~thp-introduce-hugepage_vma_check
+++ a/mm/huge_memory.c
@@ -1894,6 +1894,20 @@ static struct page
 }
 #endif
 
+static bool hugepage_vma_check(struct vm_area_struct *vma)
+{
+	if ((!(vma->vm_flags & VM_HUGEPAGE) && !khugepaged_always()) ||
+	    (vma->vm_flags & VM_NOHUGEPAGE))
+		return false;
+
+	if (!vma->anon_vma || vma->vm_ops)
+		return false;
+	if (is_vma_temporary_stack(vma))
+		return false;
+	VM_BUG_ON(vma->vm_flags & VM_NO_THP);
+	return true;
+}
+
 static void collapse_huge_page(struct mm_struct *mm,
 				   unsigned long address,
 				   struct page **hpage,
@@ -1934,17 +1948,8 @@ static void collapse_huge_page(struct mm
 	hend = vma->vm_end & HPAGE_PMD_MASK;
 	if (address < hstart || address + HPAGE_PMD_SIZE > hend)
 		goto out;
-
-	if ((!(vma->vm_flags & VM_HUGEPAGE) && !khugepaged_always()) ||
-	    (vma->vm_flags & VM_NOHUGEPAGE))
+	if (!hugepage_vma_check(vma))
 		goto out;
-
-	if (!vma->anon_vma || vma->vm_ops)
-		goto out;
-	if (is_vma_temporary_stack(vma))
-		goto out;
-	VM_BUG_ON(vma->vm_flags & VM_NO_THP);
-
 	pmd = mm_find_pmd(mm, address);
 	if (!pmd)
 		goto out;
@@ -2152,20 +2157,11 @@ static unsigned int khugepaged_scan_mm_s
 			progress++;
 			break;
 		}
-
-		if ((!(vma->vm_flags & VM_HUGEPAGE) &&
-		     !khugepaged_always()) ||
-		    (vma->vm_flags & VM_NOHUGEPAGE)) {
-		skip:
+		if (!hugepage_vma_check(vma)) {
+skip:
 			progress++;
 			continue;
 		}
-		if (!vma->anon_vma || vma->vm_ops)
-			goto skip;
-		if (is_vma_temporary_stack(vma))
-			goto skip;
-		VM_BUG_ON(vma->vm_flags & VM_NO_THP);
