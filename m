From: akpm@osdl.org
Subject: - fix-bogus-bug_on-in-in-hugetlb_get_unmapped_area.patch removed from -mm tree
Date: Tue, 09 Jan 2007 12:28:28 -0800
Message-ID: <200701092028.l09KSSpA014311@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41039 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381AbXAIU2i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:28:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@gibson.dropbear.id.au, mm-commits@vger.kernel.org


The patch titled
     Fix bogus BUG_ON() in in hugetlb_get_unmapped_area()
has been removed from the -mm tree.  Its filename was
     fix-bogus-bug_on-in-in-hugetlb_get_unmapped_area.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix bogus BUG_ON() in in hugetlb_get_unmapped_area()
From: David Gibson <david@gibson.dropbear.id.au>

The powerpc specific version of hugetlb_get_unmapped_area() makes some
unwarranted assumptions about what checks have been made to its parameters
by its callers.  This will lead to a BUG_ON() if a 32-bit process attempts
to make a hugepage mapping which extends above TASK_SIZE (4GB).

I'm not sure if these assumptions came about because they were valid with
earlier versions of the get_unmapped_area() path, or if it was always
broken.  Nonetheless this patch fixes the logic, and removes the crash.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/powerpc/mm/hugetlbpage.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/mm/hugetlbpage.c~fix-bogus-bug_on-in-in-hugetlb_get_unmapped_area arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~fix-bogus-bug_on-in-in-hugetlb_get_unmapped_area
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -744,7 +744,8 @@ static int htlb_check_hinted_area(unsign
 	struct vm_area_struct *vma;
 
 	vma = find_vma(current->mm, addr);
-	if (!vma || ((addr + len) <= vma->vm_start))
+	if (TASK_SIZE - len >= addr &&
+	    (!vma || ((addr + len) <= vma->vm_start)))
 		return 0;
 
 	return -ENOMEM;
@@ -815,6 +816,8 @@ unsigned long hugetlb_get_unmapped_area(
 		return -EINVAL;
 	if (len & ~HPAGE_MASK)
 		return -EINVAL;
+	if (len > TASK_SIZE)
+		return -ENOMEM;
 
 	if (!cpu_has_feature(CPU_FTR_16M_PAGE))
 		return -EINVAL;
@@ -823,9 +826,6 @@ unsigned long hugetlb_get_unmapped_area(
 	BUG_ON((addr + len)  < addr);
 
 	if (test_thread_flag(TIF_32BIT)) {
-		/* Paranoia, caller should have dealt with this */
-		BUG_ON((addr + len) > 0x100000000UL);
-
 		curareas = current->mm->context.low_htlb_areas;
 
 		/* First see if we can use the hint address */
_

Patches currently in -mm which might be from david@gibson.dropbear.id.au are

origin.patch
