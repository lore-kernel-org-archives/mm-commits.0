From: akpm@linux-foundation.org
Subject: + mm-fix-memory-leak-in-copy_huge_pmd.patch added to -mm tree
Date: Mon, 01 Feb 2016 13:33:19 -0800
Message-ID: <56afcf1f.daXtts95RpPE+bkN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41264 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbcBAVdU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2016 16:33:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix memory leak in copy_huge_pmd()
has been added to the -mm tree.  Its filename is
     mm-fix-memory-leak-in-copy_huge_pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-memory-leak-in-copy_huge_pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-memory-leak-in-copy_huge_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: mm: fix memory leak in copy_huge_pmd()

We allocate a pgtable but do not attach it to anything if the PMD is in a
DAX VMA, causing it to leak.

We certainly try to not free pgtables associated with the huge zero page
if the zero page is in a DAX VMA, so I think this is the right solution. 
This needs to be properly audited.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN mm/huge_memory.c~mm-fix-memory-leak-in-copy_huge_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~mm-fix-memory-leak-in-copy_huge_pmd
+++ a/mm/huge_memory.c
@@ -858,7 +858,8 @@ static bool set_huge_zero_page(pgtable_t
 		return false;
 	entry = mk_pmd(zero_page, vma->vm_page_prot);
 	entry = pmd_mkhuge(entry);
-	pgtable_trans_huge_deposit(mm, pmd, pgtable);
+	if (pgtable)
+		pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, haddr, pmd, entry);
 	atomic_long_inc(&mm->nr_ptes);
 	return true;
@@ -1036,13 +1037,15 @@ int copy_huge_pmd(struct mm_struct *dst_
 	spinlock_t *dst_ptl, *src_ptl;
 	struct page *src_page;
 	pmd_t pmd;
-	pgtable_t pgtable;
+	pgtable_t pgtable = NULL;
 	int ret;
 
-	ret = -ENOMEM;
-	pgtable = pte_alloc_one(dst_mm, addr);
-	if (unlikely(!pgtable))
-		goto out;
+	if (!vma_is_dax(vma)) {
+		ret = -ENOMEM;
+		pgtable = pte_alloc_one(dst_mm, addr);
+		if (unlikely(!pgtable))
+			goto out;
+	}
 
 	dst_ptl = pmd_lock(dst_mm, dst_pmd);
 	src_ptl = pmd_lockptr(src_mm, src_pmd);
@@ -1073,7 +1076,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 		goto out_unlock;
 	}
 
-	if (pmd_trans_huge(pmd)) {
+	if (!vma_is_dax(vma)) {
 		/* thp accounting separate from pmd_devmap accounting */
 		src_page = pmd_page(pmd);
 		VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

mm-fix-memory-leak-in-copy_huge_pmd.patch

