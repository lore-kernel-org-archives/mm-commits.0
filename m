From: akpm@linux-foundation.org
Subject: [merged] mm-thp-allow-fallback-when-pte_alloc_one-fails-for-huge-pmd.patch removed from -mm tree
Date: Thu, 31 May 2012 12:13:44 -0700
Message-ID: <20120531191344.6296FA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:48565 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab2EaTNp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:13:45 -0400
Received: by yhgm50 with SMTP id m50so146456yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:13:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: allow fallback when pte_alloc_one() fails for huge pmd
has been removed from the -mm tree.  Its filename was
     mm-thp-allow-fallback-when-pte_alloc_one-fails-for-huge-pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
slab-move-full-state-transition-to-an-initcall.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index-fix.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-simplify-migrate_huge_page-fix.patch
memcg-add-hugetlb-extension-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch

