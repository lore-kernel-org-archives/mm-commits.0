From: akpm@linux-foundation.org
Subject: [merged] thp-fix-the-count-of-thp_collapse_alloc.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:07:28 -0700
Message-ID: <20121009180728.B860E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:36832 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISH3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:07:29 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so661771vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:07:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: fix the count of THP_COLLAPSE_ALLOC
has been removed from the -mm tree.  Its filename was
     thp-fix-the-count-of-thp_collapse_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: thp: fix the count of THP_COLLAPSE_ALLOC

THP_COLLAPSE_ALLOC is double counted if NUMA is disabled since it has
already been calculated in khugepaged_alloc_hugepage

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-fix-the-count-of-thp_collapse_alloc mm/huge_memory.c
--- a/mm/huge_memory.c~thp-fix-the-count-of-thp_collapse_alloc
+++ a/mm/huge_memory.c
@@ -1874,9 +1874,9 @@ static void collapse_huge_page(struct mm
 		*hpage = ERR_PTR(-ENOMEM);
 		return;
 	}
+	count_vm_event(THP_COLLAPSE_ALLOC);
 #endif
 
-	count_vm_event(THP_COLLAPSE_ALLOC);
 	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
 #ifdef CONFIG_NUMA
 		put_page(new_page);
_

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

origin.patch
linux-next.patch

