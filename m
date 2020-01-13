From: akpm@linux-foundation.org
Subject: +
 mm-gupc-use-is_vm_hugetlb_page-to-check-whether-to-follow-huge.patch added to
 -mm tree
Date: Mon, 13 Jan 2020 14:35:06 -0800
Message-ID: <20200113223506.ickqg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgAMWfH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jan 2020 17:35:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, rientjes@google.com, richardw.yang@linux.intel.com


The patch titled
     Subject: mm/gup.c: use is_vm_hugetlb_page() to check whether to follow huge
has been added to the -mm tree.  Its filename is
     mm-gupc-use-is_vm_hugetlb_page-to-check-whether-to-follow-huge.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gupc-use-is_vm_hugetlb_page-to-check-whether-to-follow-huge.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gupc-use-is_vm_hugetlb_page-to-check-whether-to-follow-huge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm/gup.c: use is_vm_hugetlb_page() to check whether to follow huge

No functional change, just leverage the helper function to improve
readability as others.

Link: http://lkml.kernel.org/r/20200113070322.26627-1-richardw.yang@linux.intel.com
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
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

mm-thp-grab-the-lock-before-manipulation-defer-list.patch
mm-gupc-use-is_vm_hugetlb_page-to-check-whether-to-follow-huge.patch
mm-huge_memoryc-use-head-to-check-huge-zero-page.patch
mm-huge_memoryc-use-head-to-emphasize-the-purpose-of-page.patch
mm-huge_memoryc-reduce-critical-section-protected-by-split_queue_lock.patch
mm-remove-dead-code-totalram_pages_set.patch
