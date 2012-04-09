From: akpm@linux-foundation.org
Subject: + mm-thp-remove-unnecessary-ret-variable.patch added to -mm tree
Date: Mon, 09 Apr 2012 16:09:46 -0700
Message-ID: <20120409230947.636CEA03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:39442 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2DIXJs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Apr 2012 19:09:48 -0400
Received: by qcsp5 with SMTP id p5so542338qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Apr 2012 16:09:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, aarcange@redhat.com


The patch titled
     Subject: mm, thp: remove unnecessary ret variable
has been added to the -mm tree.  Its filename is
     mm-thp-remove-unnecessary-ret-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: remove unnecessary ret variable

The "ret" variable is unnecessary in __do_huge_pmd_anonymous_page(), so
remove it.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-remove-unnecessary-ret-variable mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-remove-unnecessary-ret-variable
+++ a/mm/huge_memory.c
@@ -636,7 +636,6 @@ static int __do_huge_pmd_anonymous_page(
 					unsigned long haddr, pmd_t *pmd,
 					struct page *page)
 {
-	int ret = 0;
 	pgtable_t pgtable;
 
 	VM_BUG_ON(!PageCompound(page));
@@ -675,7 +674,7 @@ static int __do_huge_pmd_anonymous_page(
 		spin_unlock(&mm->page_table_lock);
 	}
 
-	return ret;
+	return 0;
 }
 
 static inline gfp_t alloc_hugepage_gfpmask(int defrag, gfp_t extra_gfp)
_
Subject: Subject: mm, thp: remove unnecessary ret variable

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mm-memory_failure-let-the-compiler-add-the-function-name.patch
mm-mempolicyc-use-enum-value-mpol_rebind_once-instead-of-0-in-mpol_rebind_policy.patch
mm-hugetlbc-cleanup-to-use-long-vars-instead-of-int-in-region_count.patch
mm-thp-remove-unnecessary-ret-variable.patch
mm-thp-allow-fallback-when-pte_alloc_one-fails-for-huge-pmd.patch

