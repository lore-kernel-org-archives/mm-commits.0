From: akpm@linux-foundation.org
Subject: [patch 056/119] mm/huge_memory.c: fix comment in
 __split_huge_pmd_locked
Date: Wed, 31 Jan 2018 16:17:29 -0800
Message-ID: <20180201001729.yIVF8ktwG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34958 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752981AbeBAARa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:17:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, xieyisheng1@huawei.com

From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: mm/huge_memory.c: fix comment in __split_huge_pmd_locked

pmd_trans_splitting() was removed after THP refcounting redesign,
therefore related comment should be updated.

Link: http://lkml.kernel.org/r/1512625745-59451-1-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/huge_memory.c~mm-huge_memory-fix-comment-in-__split_huge_pmd_locked mm/huge_memory.c
--- a/mm/huge_memory.c~mm-huge_memory-fix-comment-in-__split_huge_pmd_locked
+++ a/mm/huge_memory.c
@@ -2205,10 +2205,9 @@ static void __split_huge_pmd_locked(stru
 	 * for the same virtual address to be loaded simultaneously. So instead
 	 * of doing "pmd_populate(); flush_pmd_tlb_range();" we first mark the
 	 * current pmd notpresent (atomically because here the pmd_trans_huge
-	 * and pmd_trans_splitting must remain set at all times on the pmd
-	 * until the split is complete for this pmd), then we flush the SMP TLB
-	 * and finally we write the non-huge version of the pmd entry with
-	 * pmd_populate.
+	 * must remain set at all times on the pmd until the split is complete
+	 * for this pmd), then we flush the SMP TLB and finally we write the
+	 * non-huge version of the pmd entry with pmd_populate.
 	 */
 	pmdp_invalidate(vma, haddr, pmd);
 	pmd_populate(mm, pmd, pgtable);
_
