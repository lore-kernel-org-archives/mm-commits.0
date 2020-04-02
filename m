From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 136/155] mm: mempolicy: use VM_BUG_ON_VMA in
 queue_pages_test_walk()
Date: Wed, 01 Apr 2020 21:10:55 -0700
Message-ID: <20200402041055.o8u300uTM%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEK4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:10:56 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cai@lca.pw, linux-mm@kvack.org, lixinhai.lxh@gmail.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, yang.shi@linux.alibaba.com

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
