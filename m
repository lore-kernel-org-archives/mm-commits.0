From: akpm@linux-foundation.org
Subject: + mm-thp-allow-fallback-when-pte_alloc_one-fails-for-huge-pmd.patch added to -mm tree
Date: Mon, 09 Apr 2012 16:09:49 -0700
Message-ID: <20120409230950.2860EA03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:62516 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2DIXJv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Apr 2012 19:09:51 -0400
Received: by vbnl22 with SMTP id l22so539154vbn.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Apr 2012 16:09:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, aarcange@redhat.com


The patch titled
     Subject: mm, thp: allow fallback when pte_alloc_one() fails for huge pmd
has been added to the -mm tree.  Its filename is
     mm-thp-allow-fallback-when-pte_alloc_one-fails-for-huge-pmd.patch

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
Subject: mm, thp: allow fallback when pte_alloc_one() fails for huge pmd

The transparent hugepages feature is careful to not invoke the oom killer
when a hugepage cannot be allocated.

pte_alloc_one() failing in __do_huge_pmd_anonymous_page(), however,
currently results in VM_FAULT_OOM which invokes the pagefault oom killer
to kill a memory-hogging task.

This is unnecessary since it's possible to drop the reference to the
hugepage and fallback to allocating a small page.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-allow-fallback-when-pte_alloc_one-fails-for-huge-pmd mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-allow-fallback-when-pte_alloc_one-fails-for-huge-pmd
+++ a/mm/huge_memory.c
@@ -640,11 +640,8 @@ static int __do_huge_pmd_anonymous_page(
 
 	VM_BUG_ON(!PageCompound(page));
 	pgtable = pte_alloc_one(mm, haddr);
-	if (unlikely(!pgtable)) {
-		mem_cgroup_uncharge_page(page);
-		put_page(page);
+	if (unlikely(!pgtable))
 		return VM_FAULT_OOM;
-	}
 
 	clear_huge_page(page, haddr, HPAGE_PMD_NR);
 	__SetPageUptodate(page);
@@ -723,8 +720,14 @@ int do_huge_pmd_anonymous_page(struct mm
 			put_page(page);
 			goto out;
 		}
+		if (unlikely(__do_huge_pmd_anonymous_page(mm, vma, haddr, pmd,
+							  page))) {
+			mem_cgroup_uncharge_page(page);
+			put_page(page);
+			goto out;
+		}
 
-		return __do_huge_pmd_anonymous_page(mm, vma, haddr, pmd, page);
+		return 0;
 	}
 out:
 	/*
_
Subject: Subject: mm, thp: allow fallback when pte_alloc_one() fails for huge pmd

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mm-memory_failure-let-the-compiler-add-the-function-name.patch
mm-mempolicyc-use-enum-value-mpol_rebind_once-instead-of-0-in-mpol_rebind_policy.patch
mm-hugetlbc-cleanup-to-use-long-vars-instead-of-int-in-region_count.patch
mm-thp-remove-unnecessary-ret-variable.patch
mm-thp-allow-fallback-when-pte_alloc_one-fails-for-huge-pmd.patch

