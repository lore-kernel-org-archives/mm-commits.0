From: akpm@linux-foundation.org
Subject: + mm-huge_memory-fix-comment-in-__split_huge_pmd_locked.patch
 added to -mm tree
Date: Thu, 07 Dec 2017 16:11:51 -0800
Message-ID: <5a29d8c7.b6sXiT+mi9WCBSIY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60278 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752484AbdLHALw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2017 19:11:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: fix comment in __split_huge_pmd_locked
has been added to the -mm tree.  Its filename is
     mm-huge_memory-fix-comment-in-__split_huge_pmd_locked.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memory-fix-comment-in-__split_huge_pmd_locked.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memory-fix-comment-in-__split_huge_pmd_locked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from xieyisheng1@huawei.com are

mm-mempolicy-remove-redundant-check-in-get_nodes.patch
mm-mempolicy-fix-the-check-of-nodemask-from-user.patch
mm-mempolicy-add-nodes_empty-check-in-sysc_migrate_pages.patch
mm-huge_memory-fix-comment-in-__split_huge_pmd_locked.patch

