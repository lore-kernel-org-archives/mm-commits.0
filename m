From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-fix-null-pointer-dereference-on-5-level-paging-machine.patch
 removed from -mm tree
Date: Thu, 30 Nov 2017 12:19:26 -0800
Message-ID: <20171130201926.yWXgXXeZY%akpm__21203.8886420943$1512073175$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52612 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751254AbdK3UT1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:19:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mhocko@suse.com, mm-commits@vger.kernel.org, stable@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: mm/hugetlb: fix NULL-pointer dereference on 5-level paging machine
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-null-pointer-dereference-on-5-level-paging-machine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/hugetlb: fix NULL-pointer dereference on 5-level paging machine

I made a mistake during converting hugetlb code to 5-level paging: in
huge_pte_alloc() we have to use p4d_alloc(), not p4d_offset().  Otherwise
it leads to crash -- NULL-pointer dereference in pud_alloc() if p4d table
is not yet allocated.

It only can happen in 5-level paging mode.  In 4-level paging mode
p4d_offset() always returns pgd, so we are fine.

Link: http://lkml.kernel.org/r/20171122121921.64822-1-kirill.shutemov@linux.intel.com
Fixes: c2febafc6773 ("mm: convert generic code to 5-level paging")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>	[4.11+]

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-null-pointer-dereference-on-5-level-paging-machine mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-null-pointer-dereference-on-5-level-paging-machine
+++ a/mm/hugetlb.c
@@ -4635,7 +4635,9 @@ pte_t *huge_pte_alloc(struct mm_struct *
 	pte_t *pte = NULL;
 
 	pgd = pgd_offset(mm, addr);
-	p4d = p4d_offset(pgd, addr);
+	p4d = p4d_alloc(mm, pgd, addr);
+	if (!p4d)
+		return NULL;
 	pud = pud_alloc(mm, p4d, addr);
 	if (pud) {
 		if (sz == PUD_SIZE) {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


