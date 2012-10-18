From: akpm@linux-foundation.org
Subject: + thp-introduce-hugepage_vma_check.patch added to -mm tree
Date: Thu, 18 Oct 2012 13:11:09 -0700
Message-ID: <20121018201109.97AB6100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:56459 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab2JRULK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 16:11:10 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so1123266qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 13:11:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, aarcange@redhat.com, mhocko@suse.cz, minchan.kim@gmail.com


The patch titled
     Subject: thp: introduce hugepage_vma_check()
has been added to the -mm tree.  Its filename is
     thp-introduce-hugepage_vma_check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: thp: introduce hugepage_vma_check()

Multiple places do the same check.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff -puN mm/huge_memory.c~thp-introduce-hugepage_vma_check mm/huge_memory.c
--- a/mm/huge_memory.c~thp-introduce-hugepage_vma_check
+++ a/mm/huge_memory.c
@@ -1980,6 +1980,20 @@ static struct page
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
@@ -2020,17 +2034,8 @@ static void collapse_huge_page(struct mm
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
 	pmd = hugepage_get_pmd(mm, address);
 	if (!pmd)
 		goto out;
@@ -2238,20 +2243,11 @@ static unsigned int khugepaged_scan_mm_s
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
