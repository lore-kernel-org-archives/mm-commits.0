From: akpm@linux-foundation.org
Subject: [merged]
 mm-mempolicy-use-vm_bug_on_vma-in-queue_pages_test_walk.patch removed from
 -mm tree
Date: Fri, 03 Apr 2020 13:40:19 -0700
Message-ID: <20200403204019.dKZhpcCl9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727909AbgDCUkU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:40:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cai@lca.pw, lixinhai.lxh@gmail.com, mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: mempolicy: use VM_BUG_ON_VMA in queue_pages_test_walk()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-use-vm_bug_on_vma-in-queue_pages_test_walk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: mempolicy: use VM_BUG_ON_VMA in queue_pages_test_walk()

The VM_BUG_ON() is already used by queue_pages_test_walk(), it sounds
better to dump more debug information by using VM_BUG_ON_VMA() to help
debugging.

Link: http://lkml.kernel.org/r/1579068565-110432-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Li Xinhai" <lixinhai.lxh@gmail.com>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-use-vm_bug_on_vma-in-queue_pages_test_walk
+++ a/mm/mempolicy.c
@@ -650,7 +650,7 @@ static int queue_pages_test_walk(unsigne
 	unsigned long flags = qp->flags;
 
 	/* range check first */
-	VM_BUG_ON((vma->vm_start > start) || (vma->vm_end < end));
+	VM_BUG_ON_VMA((vma->vm_start > start) || (vma->vm_end < end), vma);
 
 	if (!qp->first) {
 		qp->first = vma;
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-migratec-migrate-pg_readahead-flag.patch
