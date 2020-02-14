From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-mempolicy-use-vm_bug_on_vma-in-queue_pages_test_walk.patch added to -mm
 tree
Date: Thu, 13 Feb 2020 21:26:48 -0800
Message-ID: <20200214052648.wJb1TB-5g%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgBNF0t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 Feb 2020 00:26:49 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cai@lca.pw, lixinhai.lxh@gmail.com, mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: mempolicy: use VM_BUG_ON_VMA in queue_pages_test_walk()
has been added to the -mm tree.  Its filename is
     mm-mempolicy-use-vm_bug_on_vma-in-queue_pages_test_walk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-use-vm_bug_on_vma-in-queue_pages_test_walk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-use-vm_bug_on_vma-in-queue_pages_test_walk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmpressure-dont-need-call-kfree-if-kstrndup-fails.patch
mm-vmpressure-use-mem_cgroup_is_root-api.patch
mm-vmscan-replace-open-codings-to-numa_no_node.patch
mm-mempolicy-use-vm_bug_on_vma-in-queue_pages_test_walk.patch
mm-migratec-migrate-pg_readahead-flag.patch
