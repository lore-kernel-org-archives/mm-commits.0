From: akpm@linux-foundation.org
Subject: [patch 27/28] mm/hugetlb: fix NULL-pointer dereference on 5-level paging machine
Date: Wed, 29 Nov 2017 16:11:30 -0800
Message-ID: <5a1f4cb2.1pFMT4uWx9HpLFS4%akpm__222.198284655128$1512000693$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60842 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753415AbdK3ALb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:11:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mhocko@suse.com, stable@vger.kernel.org, vbabka@suse.cz

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
