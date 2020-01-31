From: akpm@linux-foundation.org
Subject: [merged]
 mm-gupc-use-is_vm_hugetlb_page-to-check-whether-to-follow-huge.patch
 removed from -mm tree
Date: Fri, 31 Jan 2020 15:17:27 -0800
Message-ID: <20200131231727.cjiriwmtv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXR3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:17:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rcampbell@nvidia.com, richardw.yang@linux.intel.com, rientjes@google.com, vbabka@suse.cz


The patch titled
     Subject: mm/gup.c: use is_vm_hugetlb_page() to check whether to follow huge
has been removed from the -mm tree.  Its filename was
     mm-gupc-use-is_vm_hugetlb_page-to-check-whether-to-follow-huge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm/gup.c: use is_vm_hugetlb_page() to check whether to follow huge

No functional change, just leverage the helper function to improve
readability as others.

Link: http://lkml.kernel.org/r/20200113070322.26627-1-richardw.yang@linux.intel.com
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-gupc-use-is_vm_hugetlb_page-to-check-whether-to-follow-huge
+++ a/mm/gup.c
@@ -323,7 +323,7 @@ static struct page *follow_pmd_mask(stru
 	pmdval = READ_ONCE(*pmd);
 	if (pmd_none(pmdval))
 		return no_page_table(vma, flags);
-	if (pmd_huge(pmdval) && vma->vm_flags & VM_HUGETLB) {
+	if (pmd_huge(pmdval) && is_vm_hugetlb_page(vma)) {
 		page = follow_huge_pmd(mm, address, pmd, flags);
 		if (page)
 			return page;
@@ -433,7 +433,7 @@ static struct page *follow_pud_mask(stru
 	pud = pud_offset(p4dp, address);
 	if (pud_none(*pud))
 		return no_page_table(vma, flags);
-	if (pud_huge(*pud) && vma->vm_flags & VM_HUGETLB) {
+	if (pud_huge(*pud) && is_vm_hugetlb_page(vma)) {
 		page = follow_huge_pud(mm, address, pud, flags);
 		if (page)
 			return page;
_

Patches currently in -mm which might be from richardw.yang@linux.intel.com are
